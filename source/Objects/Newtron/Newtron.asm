; ===========================================================================
; ---------------------------------------------------------------------------
; Object 42 - GHZ Newtron badnik
; ---------------------------------------------------------------------------

Obj42:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj42_Index(pc,d0.w),d1
		jmp	Obj42_Index(pc,d1.w)
; ===========================================================================
Obj42_Index:	dc.w Obj42_Init-Obj42_Index
		dc.w Obj42_Main-Obj42_Index
		dc.w Obj42_Delete-Obj42_Index
; ===========================================================================
; loc_EBCC:
Obj42_Init:
		addq.b	#2,routine(a0)
		move.l	#Map_Newtron,mappings(a0)
		move.w	#$49B,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$14,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#8,x_radius(a0)
; loc_EC00:
Obj42_Main
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj42_Main_Index(pc,d0.w),d1
		jsr	Obj42_Main_Index(pc,d1.w)
		lea	(Ani_Newtron).l,a1
		bsr	AnimateSprite
		bra	MarkObjGone
; ===========================================================================
Obj42_Main_Index:	dc.w Obj42_ChkDistance-Obj42_Main_Index
			dc.w Obj42_Type00-Obj42_Main_Index
			dc.w Obj42_ChkFloor-Obj42_Main_Index
			dc.w Obj42_Move-Obj42_Main_Index
			dc.w Obj42_Type02-Obj42_Main_Index
; ===========================================================================
; loc_EC26:
Obj42_ChkDistance:
		bset	#0,status(a0)
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		bcc.s	loc_EC3E
		neg.w	d0
		bclr	#0,status(a0)

loc_EC3E:
		cmpi.w	#$80,d0
		bcc.s	locret_EC6A
		addq.b	#2,routine_secondary(a0)
		move.b	#1,anim(a0)
		tst.b	subtype(a0)
		beq.s	locret_EC6A
		move.w	#$249B,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#8,routine_secondary(a0)
		move.b	#4,anim(a0)

locret_EC6A:
		rts
; ===========================================================================
; Blue Newtron that appears before chasing Sonic/Tails
; loc_EC6C:
Obj42_Type00:
		cmpi.b	#4,mapping_frame(a0)
		bcc.s	Obj42_Fall
		bset	#0,status(a0)
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		bcc.s	locret_EC8A
		bclr	#0,status(a0)

locret_EC8A:
		rts
; ---------------------------------------------------------------------------
; loc_EC8C:
Obj42_Fall:
		cmpi.b	#1,mapping_frame(a0)
		bne.s	loc_EC9A
		move.b	#$C,$20(a0)

loc_EC9A:
		bsr.w	ObjectMoveAndFall
		bsr.w	ObjHitFloor
		tst.w	d1
		bpl.s	locret_ECDE
		add.w	d1,y_pos(a0)
		move.w	#0,y_vel(a0)
		addq.b	#2,routine_secondary(a0)
		move.b	#2,anim(a0)
		btst	#5,art_tile(a0)
		beq.s	loc_ECC6
		addq.b	#1,anim(a0)

loc_ECC6:
		move.b	#$D,$20(a0)
		move.w	#$200,x_vel(a0)
		btst	#0,status(a0)
		bne.s	locret_ECDE
		neg.w	x_vel(a0)

locret_ECDE:
		rts
; ===========================================================================
; loc_ECE0:
Obj42_ChkFloor:
		bsr.w	ObjectMove
		bsr.w	ObjHitFloor
		cmpi.w	#-8,d1
		blt.s	loc_ECFA
		cmpi.w	#$C,d1
		bge.s	loc_ECFA
		add.w	d1,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

loc_ECFA:
		addq.b	#2,routine_secondary(a0)
		rts
; ===========================================================================
; loc_ED00:
Obj42_Move:
		bsr.w	ObjectMove
		rts
; ===========================================================================
; Green Newtron that fires a missile
; loc_ED06:
Obj42_Type02:
		cmpi.b	#1,mapping_frame(a0)
		bne.s	Obj42_FireMissile
		move.b	#$C,$20(a0)
; loc_ED14:
Obj42_FireMissile:
		cmpi.b	#2,mapping_frame(a0)
		bne.s	locret_ED6C
		tst.b	$32(a0)
		bne.s	locret_ED6C
		move.b	#1,$32(a0)
		jsr	SingleObjLoad
		bne.s	locret_ED6C
		move.b	#ObjID_Missile,id(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		subq.w	#8,y_pos(a1)
		move.w	#$200,x_vel(a1)
		move.w	#$14,d0
		btst	#0,status(a0)
		bne.s	loc_ED5C
		neg.w	d0
		neg.w	x_vel(a1)

loc_ED5C:
		add.w	d0,x_pos(a1)
		move.b	status(a0),status(a1)
		move.b	#1,subtype(a1)

locret_ED6C:
		rts
; ===========================================================================
; loc_ED6E:
Obj42_Delete:
		bra.w	DeleteObject
; ===========================================================================