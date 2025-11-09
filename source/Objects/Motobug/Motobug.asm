; ===========================================================================
; ---------------------------------------------------------------------------
; Object 40 - GHZ Motobug
; ---------------------------------------------------------------------------

Obj40:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj40_Index(pc,d0.w),d1
		jmp	Obj40_Index(pc,d1.w)
; ===========================================================================
; off_F256:
Obj40_Index:	dc.w Obj40_Init-Obj40_Index
		dc.w Obj40_Main-Obj40_Index
		dc.w Obj40_Animate-Obj40_Index
		dc.w Obj40_Delete-Obj40_Index
; ===========================================================================
; loc_F25E:
Obj40_Init:
		move.l	#Map_Motobug,mappings(a0)
		move.w	#$4E0,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$14,width_pixels(a0)
		tst.b	anim(a0)
		bne.s	Obj40_Smoke
		move.b	#$E,y_radius(a0)
		move.b	#8,x_radius(a0)
		move.b	#$C,$20(a0)
		bsr.w	ObjectMoveAndFall
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	locret_F2BC
		add.w	d1,y_pos(a0)
		move.w	#0,y_vel(a0)
		addq.b	#2,routine(a0)
		bchg	#0,status(a0)

locret_F2BC:
		rts
; ===========================================================================
; loc_F2BE:
Obj40_Smoke:
		addq.b	#4,routine(a0)
		bra.w	Obj40_Animate
; ===========================================================================
; loc_F2C6:
Obj40_Main:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj40_Main_Index(pc,d0.w),d1
		jsr	Obj40_Main_Index(pc,d1.w)
		lea	(Ani_obj40).l,a1
		bsr.w	AnimateSprite
		bra.w	MarkObjGone
; ===========================================================================
; off_F2E2
Obj40_Main_Index:	dc.w Obj40_Move-Obj40_Main_Index
			dc.w Obj40_Floor-Obj40_Main_Index
; ===========================================================================
; loc_F2E6:
Obj40_Move:
		subq.w	#1,$30(a0)
		bpl.s	locret_F308
		addq.b	#2,routine_secondary(a0)
		move.w	#-$100,x_vel(a0)
		move.b	#1,anim(a0)
		bchg	#0,status(a0)
		bne.s	locret_F308
		neg.w	x_vel(a0)

locret_F308:
		rts
; ===========================================================================
; loc_F30A:
Obj40_Floor:
		bsr.w	ObjectMove
		jsr	(ObjHitFloor).l
		cmpi.w	#-8,d1
		blt.s	Obj40_StopMoving
		cmpi.w	#$C,d1
		bge.s	Obj40_StopMoving
		add.w	d1,y_pos(a0)
		subq.b	#1,$33(a0)
		bpl.s	locret_F354
		move.b	#$F,$33(a0)
		jsr	SingleObjLoad
		bne.s	locret_F354
		move.b	#$40,id(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	status(a0),status(a1)
		move.b	#2,anim(a1)

locret_F354:
		rts
; ---------------------------------------------------------------------------
; loc_F356:
Obj40_StopMoving:
		subq.b	#2,routine_secondary(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,x_vel(a0)
		move.b	#0,anim(a0)
		rts
; ===========================================================================
; loc_F36E:
Obj40_Animate:
		lea	(Ani_obj40).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ===========================================================================
; loc_F37C:
Obj40_Delete:
		bra.w	DeleteObject
; ===========================================================================
; animation script
Ani_obj40:	dc.w byte_F386-Ani_obj40
		dc.w byte_F389-Ani_obj40
		dc.w byte_F38F-Ani_obj40
byte_F386:	dc.b  $F,  2,$FF
byte_F389:	dc.b   7,  0,  1,  0,  2,$FF
byte_F38F:	dc.b   1,  3,  6,  3,  6,  4,  6,  4
		dc.b   6,  4,  6,  5,$FC
		even