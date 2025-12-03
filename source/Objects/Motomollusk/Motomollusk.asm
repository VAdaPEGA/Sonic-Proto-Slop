; ===========================================================================
; Snail badnik from EHZ
; ---------------------------------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex	 Obj54_Init
	GenerateIndex	 Obj54_Move
	GenerateIndex	 loc_177B4
	GenerateIndex	 loc_177EC
	GenerateIndex	 loc_17772
; ===========================================================================

Obj54_Init:
		move.l	#Map_Motomollusk,mappings(a0)
		move.w	#$402,art_tile(a0)
		jsr	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#$A,$20(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#$E,x_radius(a0)
		jsr	SingleObjLoad2
		bne.s	loc_17670
		move.b	#ObjID_Motomollusk,id(a1)
		move.b	#6,routine(a1)
		move.l	#Map_Motomollusk,mappings(a1)
		move.w	#$2402,art_tile(a1)
		jsr	Adjust2PArtPointer2
		move.b	#3,priority(a1)
		move.b	#$10,width_pixels(a1)
		move.b	status(a0),status(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.l	a0,$2A(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	#2,mapping_frame(a1)

loc_17670:
		addq.b	#2,routine(a0)
		move.w	#$FF80,d0
		btst	#0,status(a0)
		beq.s	loc_17682
		neg.w	d0

loc_17682:
		move.w	d0,x_vel(a0)
		rts
; ===========================================================================
; loc_17688:
Obj54_Move:
		bsr.w	sub_176D0
		jsr	ObjectMove
		jsr	(ObjHitFloor).l
		cmpi.w	#-8,d1
		blt.s	Obj54_Display
		cmpi.w	#$C,d1
		bge.s	Obj54_Display
		add.w	d1,y_pos(a0)
		bra.s	Obj54_Display_2
; ===========================================================================
; loc_176B4:
Obj54_Display:
		addq.b	#2,routine(a0)
		move.w	#$14,$30(a0)
		st	$34(a0)
Obj54_Display_2:
		lea	(Ani_Obj54).l,a1
		jsr	AnimateSprite
		bra.w	J_MarkObjGone_P1

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_176D0:				; CODE XREF: ROM:loc_17688p
		tst.b	$35(a0)
		bne.s	locret_17712
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		cmpi.w	#$64,d0	; 'd'
		bgt.s	locret_17712
		cmpi.w	#$FF9C,d0
		blt.s	locret_17712
		tst.w	d0
		bmi.s	loc_176F8
		btst	#0,status(a0)
		beq.s	locret_17712
		bra.s	loc_17700
; ===========================================================================


loc_176F8:
		btst	#0,status(a0)
		bne.s	locret_17712

loc_17700:
		move.w	x_vel(a0),d0
		asl.w	#2,d0
		move.w	d0,x_vel(a0)
		st	$35(a0)
		bsr.w	sub_17714

locret_17712:	
		rts
; End of function sub_176D0


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ

sub_17714:	
		jsr	SingleObjLoad2
		bne.s	@NoFreeObj
		move.b	#ObjID_Motomollusk,id(a1)
		move.b	#8,routine(a1)
		move.l	#Map_Buzzer,mappings(a1)
		move.w	#$3E6,art_tile(a1)
		jsr	Adjust2PArtPointer2
		move.b	#4,priority(a1)
		move.b	#$10,width_pixels(a1)
		move.b	status(a0),status(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.l	a0,$2A(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		addq.w	#7,y_pos(a1)
		addi.w	#$D,x_pos(a1)
		move.b	#1,anim(a1)
	@NoFreeObj:	
		rts
; End of function sub_17714

; ===========================================================================

loc_17772:
		movea.l	$2A(a0),a1
		cmpi.b	#ObjID_Motomollusk,(a1)
		bne	DeleteObject
		tst.b	$34(a1)
		bne	DeleteObject
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		addq.w	#7,y_pos(a0)
		moveq	#$D,d0
		btst	#0,status(a0)
		beq.s	loc_177A2
		neg.w	d0

loc_177A2:
		add.w	d0,x_pos(a0)
		bra.w	Obj54_Display_2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_177B4:				; DATA XREF: ROM:000175E2o
		subi.w	#1,$30(a0)
		bpl.w	J_MarkObjGone_P1
		neg.w	x_vel(a0)
		jsr	ObjectMoveAndFall
		move.w	x_vel(a0),d0
		asr.w	#2,d0
		move.w	d0,x_vel(a0)
		bchg	#0,status(a0)
		bchg	#0,render_flags(a0)
		subq.b	#2,routine(a0)
		sf	$34(a0)
		sf	$35(a0)
		bra.w	J_MarkObjGone_P1
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_177EC:				; DATA XREF: ROM:000175E4o
		movea.l	$2A(a0),a1
		cmpi.b	#$54,(a1) ; 'T'
		bne	DeleteObject
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		move.b	status(a1),status(a0)
		move.b	render_flags(a1),render_flags(a0)

J_MarkObjGone_P1:	
		jmp	MarkObjGone_P1