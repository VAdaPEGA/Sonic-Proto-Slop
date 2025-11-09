;----------------------------------------------------
; Object 51 - unused Skyhorse badnik from HPZ
;----------------------------------------------------

Obj51:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	off_16532(pc,d0.w),d1
		jmp	off_16532(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_16532:	dc.w loc_1653E-off_16532
		dc.w loc_1659C-off_16532
		dc.w loc_165C0-off_16532

		dc.w 0
		dc.w Obj50_Routine08-off_16532
		dc.w Obj50_Routine0A-off_16532
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1653E:				; DATA XREF: ROM:off_16532o
		addq.b	#2,routine(a0)
		move.l	#Map_Obj50,mappings(a0)
		move.w	#$2570,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$A,$20(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#6,anim(a0)
		move.b	$28(a0),d0
		andi.w	#$F,d0
		move.w	d0,d1
		lsl.w	#5,d1
		subq.w	#1,d1
		move.w	d1,$32(a0)
		move.w	d1,$34(a0)
		move.w	y_pos(a0),$2A(a0)
		move.w	y_pos(a0),$2E(a0)
		addi.w	#$60,$2E(a0) ; '`'
		move.w	#$FF00,x_vel(a0)

loc_1659C:				; DATA XREF: ROM:00016534o
		lea	Ani_Obj50,a1
		bsr	AnimateSprite
		move.w	#$39C,(Water_Level_1).w
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	off_165BC(pc,d0.w),d1
		jsr	off_165BC(pc,d1.w)
		bra.s	loc_1677A
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_165BC:	dc.w loc_165D4-off_165BC
		dc.w loc_165EA-off_165BC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
loc_165C0:				; DATA XREF: ROM:00016536o
		bsr.w	loc_162FC
		bsr	ObjectMove
		lea	Ani_Obj50,a1
		bsr	AnimateSprite
loc_1677A:	
		jmp	MarkObjGone
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_165D4:				; DATA XREF: ROM:off_165BCo
		bsr	ObjectMove
		bsr.w	sub_162DE
		bsr.w	loc_16626
		bsr.w	loc_16708
		bsr.w	loc_16678
		rts

loc_165EA:				; DATA XREF: ROM:000165BEo
		bsr	ObjectMove
		bsr.w	sub_162DE
		bsr.w	loc_16626
		bsr.w	loc_16708
		bsr.w	loc_16600
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16600:				; CODE XREF: ROM:000165FAp
		subq.w	#1,$30(a0)
		beq.s	loc_16614
		move.w	$30(a0),d0
		cmpi.w	#$12,d0
		beq.w	loc_1669E
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16614:				; CODE XREF: ROM:00016604j
		subq.b	#2,routine_secondary(a0)
		move.b	#6,anim(a0)
		move.w	#$B4,$30(a0) ; '´'
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16626:				; CODE XREF: ROM:000165DCp
					; ROM:000165F2p
		sf	$2D(a0)
		sf	$2C(a0)
		sf	$36(a0)
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		bpl.s	loc_16646
		btst	#0,status(a0)
		bne.s	loc_1664E
		bra.s	loc_16652
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16646:				; CODE XREF: ROM:0001663Aj
		btst	#0,status(a0)
		bne.s	loc_16652

loc_1664E:				; CODE XREF: ROM:00016642j
		st	$2C(a0)

loc_16652:				; CODE XREF: ROM:00016644j
					; ROM:0001664Cj
		move.w	(MainCharacter+y_pos).w,d0
		sub.w	y_pos(a0),d0
		cmpi.w	#$FFFC,d0
		blt.s	locret_16676
		cmpi.w	#4,d0
		bgt.s	loc_16672
		st	$2D(a0)
		move.w	#0,y_vel(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16672:				; CODE XREF: ROM:00016664j
		st	$36(a0)

locret_16676:				; CODE XREF: ROM:0001665Ej
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16678:				; CODE XREF: ROM:000165E4p
		tst.b	$2C(a0)
		bne.s	locret_1669C
		subq.w	#1,$30(a0)
		bgt.s	locret_1669C
		tst.b	$2D(a0)
		beq.s	locret_1669C
		move.b	#7,anim(a0)
		move.w	#$24,$30(a0) ; '$'
		addi.b	#2,routine_secondary(a0)

locret_1669C:				; CODE XREF: ROM:0001667Cj
					; ROM:00016682j ...
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1669E:				; CODE XREF: ROM:0001660Ej
		jsr	SingleObjLoad
		bne.s	locret_16706
		move.b	#$51,id(a1) ; 'Q'
		move.b	#4,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	#Map_Obj50,mappings(a1)
		move.w	#$24E0,art_tile(a1)
		ori.b	#4,render_flags(a1)
		move.b	#3,priority(a1)
		move.b	#2,anim(a1)
		move.b	#$E5,$20(a1)
		move.w	#$C,d0
		move.w	#$10,d1
		move.w	#$FD00,d2
		btst	#0,status(a0)
		beq.s	loc_166FA
		neg.w	d1
		neg.w	d2

loc_166FA:				; CODE XREF: ROM:000166F4j
		sub.w	d0,y_pos(a1)
		sub.w	d1,x_pos(a1)
		move.w	d2,x_vel(a1)

locret_16706:				; CODE XREF: ROM:000166A2j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16708:				; CODE XREF: ROM:000165E0p
					; ROM:000165F6p
		tst.b	$2D(a0)
		bne.s	@DoNothing
		tst.b	$36(a0)
		beq.s	loc_16738
		move.w	$2E(a0),d0
		cmp.w	y_pos(a0),d0
		ble.s	loc_1675C
		tst.b	$2C(a0)
		beq.s	loc_16730
		move.w	$2A(a0),d0
		cmp.w	y_pos(a0),d0
		bge.s	loc_1675C
	@DoNothing:
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16730:				; CODE XREF: ROM:00016722j
		move.w	#$180,y_vel(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16738:				; CODE XREF: ROM:00016712j
		move.w	$2A(a0),d0
		cmp.w	y_pos(a0),d0
		bge.s	loc_1675C
		tst.b	$2C(a0)
		beq.s	loc_16754
		move.w	$2E(a0),d0
		cmp.w	y_pos(a0),d0
		ble.s	loc_1675C
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16754:				; CODE XREF: ROM:00016746j
		move.w	#$FE80,y_vel(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1675C:				; CODE XREF: ROM:0001671Cj
					; ROM:0001672Cj ...
		move.w	d0,y_pos(a0)
		move.w	#0,y_vel(a0)
		rts
