; ---------------------------------------------------------------------------
; Object 4F - Redz (dinosaur badnik) from HPZ
; ---------------------------------------------------------------------------

Obj4F:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj4F_Index(pc,d0.w),d1
		jmp	Obj4F_Index(pc,d1.w)
; ===========================================================================
Obj4F_Index:	dc.w Obj4F_Init-Obj4F_Index
		dc.w Obj4F_Main-Obj4F_Index
; ===========================================================================

Obj4F_Init:
		move.l	#Map_Redz,mappings(a0)
		move.w	#$500,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#6,x_radius(a0)
		move.b	#$C,$20(a0)
		bsr.w	ObjectMoveAndFall
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	locret_15E0C
		add.w	d1,y_pos(a0)

loc_15DFC:
		move.w	#0,y_vel(a0)
		addq.b	#2,routine(a0)
		bchg	#0,status(a0)

locret_15E0C:
		rts
; ===========================================================================

Obj4F_Main:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj4F_SubIndex(pc,d0.w),d1
		jsr	Obj4F_SubIndex(pc,d1.w)
		lea	(Ani_obj4F).l,a1
		bsr.w	AnimateSprite
		out_of_range	loc_15E3E
		bra	DisplaySprite
; ---------------------------------------------------------------------------
loc_15E3E:
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_15E50
		bclr	#7,2(a2,d0.w)

loc_15E50:
		bra	DeleteObject
; ===========================================================================
Obj4F_SubIndex:	dc.w Obj4F_MoveLeft-Obj4F_SubIndex
		dc.w Obj4F_ChkFloor-Obj4F_SubIndex
; ===========================================================================
; loc_15E58:
Obj4F_MoveLeft:
		subq.w	#1,$30(a0)	; is Redz not moving?
		bpl.s	locret_15E7A	; if not, branch
		addq.b	#2,routine_secondary(a0)
		move.w	#$FF80,x_vel(a0)
		move.b	#1,anim(a0)
		bchg	#0,status(a0)
		bne.s	locret_15E7A
		neg.w	x_vel(a0)

locret_15E7A:
		rts
; ===========================================================================
; loc_15E7C:
Obj4F_ChkFloor:
		bsr.w	ObjectMove
		jsr	(ObjHitFloor).l
		cmpi.w	#$FFF8,d1
		blt.s	Obj4F_StopMoving
		cmpi.w	#$C,d1
		bge.s	Obj4F_StopMoving
		add.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------
; loc_15E98:
Obj4F_StopMoving:
		subq.b	#2,routine_secondary(a0)
		move.w	#(1*60)-1,$30(a0)	; pause for 1 second
		move.w	#0,x_vel(a0)
		move.b	#0,anim(a0)
		rts
