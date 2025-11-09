;----------------------------------------------------
; Object 4D - Rhinobot badnik
;----------------------------------------------------

Obj4D:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj4D_Index(pc,d0.w),d1
		jmp	Obj4D_Index(pc,d1.w)
; ===========================================================================
Obj4D_Index:	dc.w Obj4D_Init-Obj4D_Index
		dc.w Obj4D_Main-Obj4D_Index
; ===========================================================================

Obj4D_Init:				; DATA XREF: ROM:Obj4D_Indexo
		move.l	#Map_Obj4D,mappings(a0)
		move.w	#$23C4,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$A,$20(a0)
		move.b	#4,priority(a0)
		move.b	#$18,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#$18,x_radius(a0)
		bsr.s	Obj4D_ObjectMoveAndFall
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	locret_158DC
		add.w	d1,y_pos(a0)
		move.w	#0,y_vel(a0)
		addq.b	#2,routine(a0)

locret_158DC:				; CODE XREF: ROM:000158CCj
		rts
; ===========================================================================
Obj4D_Main:				; DATA XREF: ROM:0001588Co
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj4D_SubIndex(pc,d0.w),d1
		jsr	Obj4D_SubIndex(pc,d1.w)
		lea	(Ani_Obj4D).l,a1
		jsr	AnimateSprite
		jmp	(MarkObjGone).l
; ===========================================================================
Obj4D_ObjectMoveAndFall:	
		jmp	(ObjectMoveAndFall).l
; ===========================================================================
Obj4D_SubIndex:	dc.w loc_158FE-Obj4D_SubIndex
		dc.w loc_15922-Obj4D_SubIndex
; ===========================================================================

loc_158FE:				; DATA XREF: ROM:Obj4D_SubIndexo
		subq.w	#1,$30(a0)
		bpl.s	locret_15920
		addq.b	#2,routine_secondary(a0)
		move.w	#$FF80,x_vel(a0)
		move.b	#0,anim(a0)
		bchg	#0,status(a0)
		bne.s	locret_15920
		neg.w	x_vel(a0)

locret_15920:				; CODE XREF: ROM:00015902j
					; ROM:0001591Aj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_15922:				; DATA XREF: ROM:000158FCo
		bsr.w	sub_1596C
		bsr.s	Obj4D_ObjectMoveAndFall
		jsr	(ObjHitFloor).l
		cmpi.w	#$FFF8,d1
		blt.s	loc_15948
		cmpi.w	#$C,d1
		bge.s	locret_15946
		move.w	#0,y_vel(a0)
		add.w	d1,y_pos(a0)

locret_15946:				; CODE XREF: ROM:0001593Aj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_15948:				; CODE XREF: ROM:00015934j
		subq.b	#2,routine_secondary(a0)
		move.w	#$3B,$30(a0) ; ';'
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,x_pos(a0)
		move.w	#0,x_vel(a0)
		move.b	#1,anim(a0)
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_1596C:				; CODE XREF: ROM:loc_15922p
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		bmi.s	loc_159A0
		cmpi.w	#$60,d0	; '`'
		bgt.s	locret_15990
		btst	#0,status(a0)
		bne.s	loc_15992
		move.b	#2,anim(a0)
		move.w	#$FE00,x_vel(a0)

locret_15990:				; CODE XREF: sub_1596C+Ej
					; sub_1596C+38j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_15992:				; CODE XREF: sub_1596C+16j
		move.b	#0,anim(a0)
		move.w	#$80,x_vel(a0) ; '€'
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_159A0:				; CODE XREF: sub_1596C+8j
		cmpi.w	#$FFA0,d0
		blt.s	locret_15990
		btst	#0,status(a0)
		beq.s	loc_159BC
		move.b	#2,anim(a0)
		move.w	#$200,x_vel(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_159BC:				; CODE XREF: sub_1596C+40j
		move.b	#0,anim(a0)
		move.w	#$FF80,x_vel(a0)
		rts
; End of function sub_1596C

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Ani_Obj4D:	dc.w byte_159D0-Ani_Obj4D
		dc.w byte_159DE-Ani_Obj4D
		dc.w byte_159E1-Ani_Obj4D
byte_159D0:	dc.b   2,  0,  0,  0,  3,  3,  4,  1,  1,  2,  5,  5,  5,$FF; 0
byte_159DE:	dc.b  $F,  0,$FF	
byte_159E1:	dc.b   2,  6,  7,$FF,  0
