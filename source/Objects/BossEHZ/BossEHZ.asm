;----------------------------------------------------
; Object 57 - sub object of the	EHZ boss
;----------------------------------------------------

Obj57:					; DATA XREF: ROM:Obj_Indexo
					; ROM:0001833Co
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	off_17892(pc,d0.w),d1
		jmp	off_17892(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_17892:	dc.w loc_1789E-off_17892; 0 ; DATA XREF: ROM:off_17892o
					; ROM:off_17892+2o ...
		dc.w loc_178C4-off_17892; 1
		dc.w loc_17920-off_17892; 2
		dc.w loc_17952-off_17892; 3
		dc.w loc_1797C-off_17892; 4
		dc.w loc_17996-off_17892; 5
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1789E:				; DATA XREF: ROM:off_17892o
		move.b	#0,$20(a0)
		cmpi.w	#$29D0,x_pos(a0)
		ble.s	loc_178B6
		subi.w	#1,x_pos(a0)
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_178B6:				; CODE XREF: ROM:000178AAj
		move.w	#$29D0,x_pos(a0)
		addq.b	#2,routine_secondary(a0)
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_178C4:				; DATA XREF: ROM:off_17892o
		moveq	#0,d0
		move.b	$2C(a0),d0
		move.w	off_178D2(pc,d0.w),d1
		jmp	off_178D2(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_178D2:	dc.w loc_178D6-off_178D2 ; DATA	XREF: ROM:off_178D2o
					; ROM:000178D4o
		dc.w loc_178FC-off_178D2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_178D6:				; DATA XREF: ROM:off_178D2o
		cmpi.w	#$41E,y_pos(a0)
		bge.s	loc_178E8
		addi.w	#1,y_pos(a0)
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_178E8:				; CODE XREF: ROM:000178DCj
		addq.b	#2,$2C(a0)
		bset	#0,$2D(a0)
		move.w	#$3C,$2A(a0) ; '<'
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_178FC:				; DATA XREF: ROM:000178D4o
		subi.w	#1,$2A(a0)
		bpl.w	loc_181A8
		move.w	#$FE00,x_vel(a0)
		addq.b	#2,routine_secondary(a0)
		move.b	#$F,$20(a0)
		bset	#1,$2D(a0)
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17920:				; DATA XREF: ROM:off_17892o
		bsr.w	sub_17A8C
		bsr.w	sub_17A6A
		move.w	$2E(a0),d0
		lsr.w	#1,d0
		subi.w	#$14,d0
		move.w	d0,y_pos(a0)
		move.w	#0,$2E(a0)
		move.l	x_pos(a0),d2
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.l	d2,x_pos(a0)
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17952:				; DATA XREF: ROM:off_17892o
		subq.w	#1,$3C(a0)
		bpl.w	BossDefeated
		bset	#0,status(a0)
		bclr	#7,status(a0)
		clr.w	x_vel(a0)
		addq.b	#2,routine_secondary(a0)
		move.w	#$FFDA,$3C(a0)
		move.w	#$C,$2A(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1797C:				; DATA XREF: ROM:off_17892o
		addq.w	#1,y_pos(a0)
		subq.w	#1,$2A(a0)
		bpl.w	loc_181A8
		addq.b	#2,routine_secondary(a0)
		move.b	#0,$2C(a0)
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17996:				; DATA XREF: ROM:off_17892o
		moveq	#0,d0
		move.b	$2C(a0),d0
		move.w	off_179A8(pc,d0.w),d1
		jsr	off_179A8(pc,d1.w)
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_179A8:	dc.w loc_179AE-off_179A8 ; DATA	XREF: ROM:off_179A8o
					; ROM:000179AAo ...
		dc.w loc_17A22-off_179A8
		dc.w loc_17A3C-off_179A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_179AE:				; DATA XREF: ROM:off_179A8o
		bclr	#0,$2D(a0)
		bsr.w	j_SingleObjLoad2
		bne.w	loc_181A8
		move.b	#$58,id(a1) ; 'X'
		move.l	a0,$34(a1)
		move.l	#Map_Obj58,mappings(a1)
		move.w	#$2540,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.b	#$20,width_pixels(a1) ; ' '
		move.b	#4,priority(a1)
		move.l	x_pos(a0),x_pos(a1)
		move.l	y_pos(a0),y_pos(a1)
		addi.w	#$C,y_pos(a1)
		move.b	status(a0),status(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	#8,routine(a1)
		move.b	#2,anim(a1)
		move.w	#$10,$2A(a1)
		move.w	#$32,$2A(a0) ; '2'
		addq.b	#2,$2C(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17A22:				; DATA XREF: ROM:000179AAo
		subi.w	#1,$2A(a0)
		bpl.s	locret_17A3A
		bset	#2,$2D(a0)
		move.w	#$60,$2A(a0) ; '`'
		addq.b	#2,$2C(a0)

locret_17A3A:				; CODE XREF: ROM:00017A28j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17A3C:				; DATA XREF: ROM:000179ACo
		subq.w	#1,y_pos(a0)
		subi.w	#1,$2A(a0)
		bpl.s	locret_17A68
		addq.w	#1,y_pos(a0)
		addq.w	#2,x_pos(a0)
		cmpi.w	#$2B08,x_pos(a0)
		bcs.s	locret_17A68
		tst.b	($FFFFF7A7).w
		bne.s	locret_17A68
		move.b	#1,($FFFFF7A7).w
		bra.w	loc_181AE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_17A68:				; CODE XREF: ROM:00017A46j
					; ROM:00017A56j ...
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_17A6A:				; CODE XREF: ROM:00017924p
					; ROM:loc_17C58p
		move.w	x_pos(a0),d0
		cmpi.w	#$2720,d0
		ble.s	loc_17A7A
		cmpi.w	#$2B08,d0
		blt.s	locret_17A8A

loc_17A7A:				; CODE XREF: sub_17A6A+8j
		bchg	#0,status(a0)
		bchg	#0,render_flags(a0)
		neg.w	x_vel(a0)

locret_17A8A:				; CODE XREF: sub_17A6A+Ej
		rts
; End of function sub_17A6A


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_17A8C:				; CODE XREF: ROM:loc_17920p
		cmpi.b	#6,routine_secondary(a0)
		bcc.s	locret_17AD2
		tst.b	status(a0)
		bmi.s	loc_17AD4
		tst.b	$20(a0)
		bne.s	locret_17AD2
		tst.b	$3E(a0)
		bne.s	loc_17AB6
		move.b	#$20,$3E(a0) ; ' '
		move.w	#$AC,d0	; '¬'
		jsr	(PlaySound_Special).l

loc_17AB6:				; CODE XREF: sub_17A8C+18j
		lea	($FFFFFB22).w,a1
		moveq	#0,d0
		tst.w	(a1)
		bne.s	loc_17AC4
		move.w	#$EEE,d0

loc_17AC4:				; CODE XREF: sub_17A8C+32j
		move.w	d0,(a1)
		subq.b	#1,$3E(a0)
		bne.s	locret_17AD2
		move.b	#$F,$20(a0)

locret_17AD2:				; CODE XREF: sub_17A8C+6j
					; sub_17A8C+12j ...
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17AD4:				; CODE XREF: sub_17A8C+Cj
		moveq	#$64,d0	; 'd'
		bsr.w	AddPoints
		move.b	#6,routine_secondary(a0)
		move.w	#$B3,$3C(a0) ; '³'
		bset	#3,$2D(a0)
		rts
; End of function sub_17A8C

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------
; Object 58 - sub object of the	EHZ boss
;----------------------------------------------------

Obj58:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	off_17AFC(pc,d0.w),d1
		jmp	off_17AFC(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_17AFC:	dc.w loc_17B2A-off_17AFC ; DATA	XREF: ROM:off_17AFCo
					; ROM:00017AFEo ...
		dc.w loc_17BB0-off_17AFC
		dc.w loc_17C02-off_17AFC
		dc.w loc_17CE4-off_17AFC
		dc.w loc_17B06-off_17AFC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17B06:				; DATA XREF: ROM:00017B04o
		subi.w	#1,y_pos(a0)
		subi.w	#1,$2A(a0)
		bpl.w	loc_181A8
		move.b	#0,routine(a0)
		lea	(Ani_Obj58).l,a1
		bsr.w	j_AnimateSprite_9
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17B2A:				; DATA XREF: ROM:off_17AFCo
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	off_17B38(pc,d0.w),d1
		jmp	off_17B38(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_17B38:	dc.w loc_17B3C-off_17B38 ; DATA	XREF: ROM:off_17B38o
					; ROM:00017B3Ao
		dc.w loc_17B86-off_17B38
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17B3C:				; DATA XREF: ROM:off_17B38o
		movea.l	$34(a0),a1
		cmpi.b	#$55,(a1) ; 'U'
		bne.w	loc_181AE
		btst	#0,$2D(a1)
		beq.s	loc_17B60
		move.b	#1,anim(a0)
		move.w	#$18,$2A(a0)
		addq.b	#2,routine_secondary(a0)

loc_17B60:				; CODE XREF: ROM:00017B4Ej
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		move.b	status(a1),status(a0)
		move.b	render_flags(a1),render_flags(a0)
		lea	(Ani_Obj58).l,a1
		bsr.w	j_AnimateSprite_9
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17B86:				; DATA XREF: ROM:00017B3Ao
		subi.w	#1,$2A(a0)
		bpl.s	loc_17BA2
		cmpi.w	#$FFF0,$2A(a0)
		ble.w	loc_181AE
		addi.w	#1,y_pos(a0)
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17BA2:				; CODE XREF: ROM:00017B8Cj
		lea	(Ani_Obj58).l,a1
		bsr.w	j_AnimateSprite_9
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17BB0:				; DATA XREF: ROM:00017AFEo
		movea.l	$34(a0),a1
		cmpi.b	#$55,(a1) ; 'U'
		bne.w	loc_181AE
		btst	#1,$2D(a1)
		beq.w	loc_181A8
		btst	#2,$2D(a1)
		bne.w	loc_17BF2
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		addi.w	#8,y_pos(a0)
		move.b	status(a1),status(a0)
		move.b	render_flags(a1),render_flags(a0)
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17BF2:				; CODE XREF: ROM:00017BCCj
		move.b	#8,mapping_frame(a0)
		move.b	#0,priority(a0)
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17C02:				; DATA XREF: ROM:00017B00o
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	off_17C10(pc,d0.w),d1
		jmp	off_17C10(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_17C10:	dc.w loc_17C18-off_17C10 ; DATA	XREF: ROM:off_17C10o
					; ROM:00017C12o ...
		dc.w loc_17C36-off_17C10
		dc.w loc_17C96-off_17C10
		dc.w loc_17CC2-off_17C10
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17C18:				; DATA XREF: ROM:off_17C10o
		movea.l	$34(a0),a1
		cmpi.b	#$55,(a1) ; 'U'
		bne.w	loc_181AE
		btst	#1,$2D(a1)
		beq.w	loc_181A8
		addq.b	#2,routine_secondary(a0)
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17C36:				; DATA XREF: ROM:00017C12o
		movea.l	$34(a0),a1
		cmpi.b	#$55,(a1) ; 'U'
		bne.w	loc_181AE
		move.b	status(a1),status(a0)
		move.b	render_flags(a1),render_flags(a0)
		tst.b	status(a0)
		bpl.s	loc_17C58
		addq.b	#2,routine_secondary(a0)

loc_17C58:				; CODE XREF: ROM:00017C52j
		bsr.w	sub_17A6A
		bsr.w	j_ObjectMoveAndFall_6
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_17C6E
		add.w	d1,y_pos(a0)

loc_17C6E:				; CODE XREF: ROM:00017C68j
		move.w	#$100,y_vel(a0)
		cmpi.b	#1,priority(a0)
		bne.s	loc_17C88
		move.w	y_pos(a0),d0
		movea.l	$34(a0),a1
		add.w	d0,$2E(a1)

loc_17C88:				; CODE XREF: ROM:00017C7Aj
		lea	(Ani_Obj58a).l,a1
		bsr.w	j_AnimateSprite_9
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17C96:				; DATA XREF: ROM:00017C14o
		subi.w	#1,$2A(a0)
		bpl.w	loc_181A8
		addq.b	#2,routine_secondary(a0)
		move.w	#$A,$2A(a0)
		move.w	#$FD00,y_vel(a0)
		cmpi.b	#1,priority(a0)
		beq.w	loc_181A8
		neg.w	x_vel(a0)
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17CC2:				; DATA XREF: ROM:00017C16o
		subq.w	#1,$2A(a0)
		bpl.w	loc_181A8
		bsr.w	j_ObjectMoveAndFall_6
		bsr.w	ObjHitFloor
		tst.w	d1
		bpl.s	loc_17CE0
		move.w	#$FE00,y_vel(a0)
		add.w	d1,y_pos(a0)

loc_17CE0:				; CODE XREF: ROM:00017CD4j
		bra.w	loc_181B4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17CE4:				; DATA XREF: ROM:00017B02o
		movea.l	$34(a0),a1
		cmpi.b	#$55,(a1) ; 'U'
		bne.w	loc_181AE
		btst	#3,$2D(a1)
		bne.s	loc_17D4A
		bsr.w	sub_17D6A
		btst	#1,$2D(a1)
		beq.w	loc_181A8
		move.b	#$8B,$20(a0)
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		move.b	status(a1),status(a0)
		move.b	render_flags(a1),render_flags(a0)
		addi.w	#$10,y_pos(a0)
		move.w	#$FFCA,d0
		btst	#0,status(a0)
		beq.s	loc_17D38
		neg.w	d0

loc_17D38:				; CODE XREF: ROM:00017D34j
		add.w	d0,x_pos(a0)
		lea	(Ani_Obj58a).l,a1
		bsr.w	j_AnimateSprite_9
		bra.w	loc_181A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17D4A:				; CODE XREF: ROM:00017CF6j
		move.w	#$FFFD,d0
		btst	#0,status(a0)
		beq.s	loc_17D58
		neg.w	d0

loc_17D58:				; CODE XREF: ROM:00017D54j
		add.w	d0,x_pos(a0)
		lea	(Ani_Obj58a).l,a1
		bsr.w	j_AnimateSprite_9
		bra.w	loc_181A8

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_17D6A:				; CODE XREF: ROM:00017CF8p
		cmpi.b	#1,$21(a1)
		beq.s	loc_17D74
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17D74:				; CODE XREF: sub_17D6A+6j
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		bpl.s	loc_17D88
		btst	#0,status(a1)
		bne.s	loc_17D92
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17D88:				; CODE XREF: sub_17D6A+12j
		btst	#0,status(a1)
		beq.s	loc_17D92
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17D92:				; CODE XREF: sub_17D6A+1Aj
					; sub_17D6A+24j
		bset	#3,$2D(a1)
		rts
; End of function sub_17D6A


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_17D9A:				; CODE XREF: ROM:loc_17F98p
		jsr	(SingleObjLoad2).l
		bne.s	loc_17E0E
		move.b	#$58,id(a1) ; 'X'
		move.l	a0,$34(a1)
		move.l	#Map_Obj58a,mappings(a1)
		move.w	#$24C0,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.b	#$10,width_pixels(a1)
		move.b	#1,priority(a1)
		move.b	#$10,y_radius(a1)
		move.b	#$10,x_radius(a1)
		move.l	x_pos(a0),x_pos(a1)
		move.l	y_pos(a0),y_pos(a1)
		addi.w	#$1C,x_pos(a1)
		addi.w	#$C,y_pos(a1)
		move.w	#$FE00,x_vel(a1)
		move.b	#4,routine(a1)
		move.b	#4,mapping_frame(a1)
		move.b	#1,anim(a1)
		move.w	#$16,$2A(a1)

loc_17E0E:				; CODE XREF: sub_17D9A+6j
		jsr	(SingleObjLoad2).l
		bne.s	loc_17E82
		move.b	#$58,id(a1) ; 'X'
		move.l	a0,$34(a1)
		move.l	#Map_Obj58a,mappings(a1)
		move.w	#$24C0,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.b	#$10,width_pixels(a1)
		move.b	#1,priority(a1)
		move.b	#$10,y_radius(a1)
		move.b	#$10,x_radius(a1)
		move.l	x_pos(a0),x_pos(a1)
		move.l	y_pos(a0),y_pos(a1)
		addi.w	#$FFF4,x_pos(a1)
		addi.w	#$C,y_pos(a1)
		move.w	#$FE00,x_vel(a1)
		move.b	#4,routine(a1)
		move.b	#4,mapping_frame(a1)
		move.b	#1,anim(a1)
		move.w	#$4B,$2A(a1) ; 'K'

loc_17E82:				; CODE XREF: sub_17D9A+7Aj
		jsr	(SingleObjLoad2).l
		bne.s	loc_17EF6
		move.b	#$58,id(a1) ; 'X'
		move.l	a0,$34(a1)
		move.l	#Map_Obj58a,mappings(a1)
		move.w	#$24C0,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.b	#$10,width_pixels(a1)
		move.b	#2,priority(a1)
		move.b	#$10,y_radius(a1)
		move.b	#$10,x_radius(a1)
		move.l	x_pos(a0),x_pos(a1)
		move.l	y_pos(a0),y_pos(a1)
		addi.w	#$FFD4,x_pos(a1)
		addi.w	#$C,y_pos(a1)
		move.w	#$FE00,x_vel(a1)
		move.b	#4,routine(a1)
		move.b	#6,mapping_frame(a1)
		move.b	#2,anim(a1)
		move.w	#$30,$2A(a1) ; '0'

loc_17EF6:				; CODE XREF: sub_17D9A+EEj
		jsr	(SingleObjLoad2).l
		bne.s	locret_17F52
		move.b	#$58,id(a1) ; 'X'
		move.l	a0,$34(a1)
		move.l	#Map_Obj58a,mappings(a1)
		move.w	#$24C0,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.b	#$10,width_pixels(a1)
		move.b	#1,priority(a1)
		move.l	x_pos(a0),x_pos(a1)
		move.l	y_pos(a0),y_pos(a1)
		addi.w	#$FFCA,x_pos(a1)
		addi.w	#8,y_pos(a1)
		move.b	#6,routine(a1)
		move.b	#1,mapping_frame(a1)
		move.b	#0,anim(a1)

locret_17F52:				; CODE XREF: sub_17D9A+162j
		rts
; End of function sub_17D9A

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_17F54:				; DATA XREF: ROM:000182FEo
		jsr	(SingleObjLoad2).l
		bne.s	loc_17F98
		move.b	#$58,id(a1) ; 'X'
		move.l	a0,$34(a1)
		move.l	#Map_Obj58a,mappings(a1)
		move.w	#$4C0,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.b	#$20,width_pixels(a1) ; ' '
		move.b	#2,priority(a1)
		move.l	x_pos(a0),x_pos(a1)
		move.l	y_pos(a0),y_pos(a1)
		move.b	#2,routine(a1)

loc_17F98:				; CODE XREF: ROM:00017F5Aj
		bsr.w	sub_17D9A
		subi.w	#8,$38(a0)
		move.w	#$2A00,x_pos(a0)
		move.w	#$2C0,y_pos(a0)
		jsr	(SingleObjLoad2).l
		bne.s	locret_17FF8
		move.b	#$58,id(a1) ; 'X'
		move.l	a0,$34(a1)
		move.l	#Map_Obj58,mappings(a1)
		move.w	#$2540,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.b	#$20,width_pixels(a1) ; ' '
		move.b	#4,priority(a1)
		move.l	x_pos(a0),x_pos(a1)
		move.l	y_pos(a0),y_pos(a1)
		move.w	#$1E,$2A(a1)
		move.b	#0,routine(a1)

locret_17FF8:				; CODE XREF: ROM:00017FB4j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Ani_Obj58:	dc.w byte_18000-Ani_Obj58 ; DATA XREF: ROM:00017B1Co
					; ROM:00017B78o ...
		dc.w byte_18004-Ani_Obj58
		dc.w byte_1801A-Ani_Obj58
byte_18000:	dc.b   1,  5,  6,$FF	; 0 ; DATA XREF: ROM:Ani_Obj58o
byte_18004:	dc.b   1,  1,  1,  1,  2,  2,  2,  3,  3,  3,  4,  4,  4,  0,  0,  0; 0
					; DATA XREF: ROM:00017FFCo
		dc.b   0,  0,  0,  0,  0,$FF; 16
byte_1801A:	dc.b   1,  0,  0,  0,  0,  0,  0,  0,  0,  4,  4,  4,  3,  3,  3,  2; 0
					; DATA XREF: ROM:00017FFEo
		dc.b   2,  2,  1,  1,  1,  5,  6,$FE,  2,  0; 16
Map_Obj58:	dc.w word_18042-Map_Obj58 ; DATA XREF: ROM:000179C6o
					; ROM:00017FC0o ...
		dc.w word_1804C-Map_Obj58
		dc.w word_18076-Map_Obj58
		dc.w word_180A0-Map_Obj58
		dc.w word_180BA-Map_Obj58
		dc.w word_180D4-Map_Obj58
		dc.w word_180EE-Map_Obj58
word_18042:	dc.w 1			; DATA XREF: ROM:Map_Obj58o
		dc.w $D805,    0,    0,	   2; 0
word_1804C:	dc.w 5			; DATA XREF: ROM:00018036o
		dc.w $D805,    4,    2,	   2; 0
		dc.w $D80D,   $C,    6,	 $12; 4
		dc.w $D80D,   $C,    6,	 $32; 8
		dc.w $D80D,   $C,    6,$FFE2; 12
		dc.w $D80D,   $C,    6,$FFC2; 16
word_18076:	dc.w 5			; DATA XREF: ROM:00018038o
		dc.w $D805,    4,    2,	   2; 0
		dc.w $D80D,   $C,    6,	 $12; 4
		dc.w $D805,    8,    4,	 $32; 8
		dc.w $D80D,   $C,    6,$FFE2; 12
		dc.w $D805,    8,    4,$FFD2; 16
word_180A0:	dc.w 3			; DATA XREF: ROM:0001803Ao
		dc.w $D805,    4,    2,	   2; 0
		dc.w $D80D,   $C,    6,	 $12; 4
		dc.w $D80D,   $C,    6,$FFE2; 8
word_180BA:	dc.w 3			; DATA XREF: ROM:0001803Co
		dc.w $D805,    4,    2,	   2; 0
		dc.w $D805,    8,    4,	 $12; 4
		dc.w $D805,    8,    4,$FFF2; 8
word_180D4:	dc.w 3			; DATA XREF: ROM:0001803Eo
		dc.w $D805,    0,    0,	   2; 0
		dc.w $D80D,   $C,    6,	 $12; 4
		dc.w $D80D,   $C,    6,	 $32; 8
word_180EE:	dc.w 3			; DATA XREF: ROM:00018040o
		dc.w $D805,    4,    2,	   2; 0
		dc.w $D80D,   $C,    6,$FFE2; 4
		dc.w $D80D,   $C,    6,$FFC2; 8
Ani_Obj58a:	dc.w byte_1810E-Ani_Obj58a ; DATA XREF:	ROM:loc_17C88o
					; ROM:00017D3Co ...
		dc.w byte_18113-Ani_Obj58a
		dc.w byte_18117-Ani_Obj58a
byte_1810E:	dc.b   5,  1,  2,  3,$FF; 0 ; DATA XREF: ROM:Ani_Obj58ao
byte_18113:	dc.b   1,  4,  5,$FF	; 0 ; DATA XREF: ROM:0001810Ao
byte_18117:	dc.b   1,  6,  7,$FF,  0; 0 ; DATA XREF: ROM:0001810Co
Map_Obj58a:	dc.w word_1812E-Map_Obj58a ; DATA XREF:	sub_17D9A+12o
					; sub_17D9A+86o ...
		dc.w word_18148-Map_Obj58a
		dc.w word_18152-Map_Obj58a
		dc.w word_1815C-Map_Obj58a
		dc.w word_18166-Map_Obj58a
		dc.w word_18170-Map_Obj58a
		dc.w word_1817A-Map_Obj58a
		dc.w word_18184-Map_Obj58a
		dc.w word_1818E-Map_Obj58a
word_1812E:	dc.w 3			; DATA XREF: ROM:Map_Obj58ao
		dc.w $F00F,    0,    0,$FFD0; 0
		dc.w $F00F,  $10,    8,$FFF0; 4
		dc.w $F00F,  $20,  $10,	 $10; 8
word_18148:	dc.w 1			; DATA XREF: ROM:0001811Eo
		dc.w $F00F,  $30,  $18,$FFF0; 0
word_18152:	dc.w 1			; DATA XREF: ROM:00018120o
		dc.w $F00F,  $40,  $20,$FFF0; 0
word_1815C:	dc.w 1			; DATA XREF: ROM:00018122o
		dc.w $F00F,  $50,  $28,$FFF0; 0
word_18166:	dc.w 1			; DATA XREF: ROM:00018124o
		dc.w $F00F,  $60,  $30,$FFF0; 0
word_18170:	dc.w 1			; DATA XREF: ROM:00018126o
		dc.w $F00F,$1060,$1030,$FFF0; 0
word_1817A:	dc.w 1			; DATA XREF: ROM:00018128o
		dc.w $F00F,  $70,  $38,$FFF0; 0
word_18184:	dc.w 1			; DATA XREF: ROM:0001812Ao
		dc.w $F00F,$1070,$1038,$FFF0; 0
word_1818E:	dc.w 3			; DATA XREF: ROM:0001812Co
		dc.w $F00F,$8000,$8000,$FFD0; 0
		dc.w $F00F,$8010,$8008,$FFF0; 4
		dc.w $F00F,$8020,$8010,	 $10; 8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_181A8:				; CODE XREF: ROM:000178B2j
					; ROM:000178C0j ...
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_181AE:				; CODE XREF: ROM:00017A64j
					; ROM:00017B44j ...
		jmp	DeleteObject
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_181B4:				; CODE XREF: ROM:loc_17CE0j
		jmp	MarkObjGone
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

j_SingleObjLoad2:			; CODE XREF: ROM:000179B4p
		jmp	SingleObjLoad2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

j_AnimateSprite_9:			; CODE XREF: ROM:00017B22p
					; ROM:00017B7Ep ...
		jmp	AnimateSprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

j_ObjectMoveAndFall_6:				; CODE XREF: ROM:00017C5Cp
					; ROM:00017CCAp
		jmp	ObjectMoveAndFall
; ===========================================================================
; ---------------------------------------------------------------------------
; Object 55 - EHZ boss
; ---------------------------------------------------------------------------

Obj55:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj55_Index(pc,d0.w),d1
		jmp	Obj55_Index(pc,d1.w)
; ===========================================================================
Obj55_Index:	dc.w Obj55_Init-Obj55_Index
		dc.w loc_18302-Obj55_Index
		dc.w loc_18340-Obj55_Index
		dc.w loc_18372-Obj55_Index
		dc.w loc_18410-Obj55_Index
; ===========================================================================
; loc_181E4:
Obj55_Init:
		move.l	#Map_Obj55,mappings(a0)
		move.w	#$2400,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$20,width_pixels(a0)
		move.b	#3,priority(a0)
		move.b	#$F,$20(a0)
		move.b	#8,$21(a0)
		addq.b	#2,routine(a0)
		move.w	x_pos(a0),$30(a0)
		move.w	y_pos(a0),$38(a0)
		move.b	$28(a0),d0
		cmpi.b	#$81,d0
		bne.s	loc_18230
		addi.w	#$60,art_tile(a0)

loc_18230:
		jsr	(SingleObjLoad2).l
		bne.w	loc_182E8
		move.b	#$55,id(a1)
		move.l	a0,$34(a1)
		move.l	a1,$34(a0)
		move.l	#Map_Obj55,mappings(a1)
		move.w	#$400,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.b	#$20,width_pixels(a1)
		move.b	#3,priority(a1)
		move.l	x_pos(a0),x_pos(a1)
		move.l	y_pos(a0),y_pos(a1)
		addq.b	#4,routine(a1)
		move.b	#1,anim(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	$28(a0),d0
		cmpi.b	#$81,d0
		bne.s	loc_18294
		addi.w	#$60,art_tile(a1)

loc_18294:
		tst.b	$28(a0)
		bmi.s	loc_182E8
		jsr	(SingleObjLoad2).l
		bne.s	loc_182E8
		move.b	#$55,id(a1)
		move.l	a0,$34(a1)

loc_182AC:
		move.l	#Map_Obj55a,mappings(a1)
		move.w	#$4D0,art_tile(a1)
		move.b	#1,anim_frame_duration(a0)

loc_182C0:
		move.b	#4,render_flags(a1)
		move.b	#$20,width_pixels(a1)
		move.b	#3,priority(a1)
		move.l	x_pos(a0),x_pos(a1)
		move.l	y_pos(a0),y_pos(a1)
		addq.b	#6,routine(a1)
		move.b	render_flags(a0),render_flags(a1)

loc_182E8:
		move.b	$28(a0),d0
		andi.w	#$7F,d0
		add.w	d0,d0
		add.w	d0,d0
		movea.l	dword_182FA(pc,d0.w),a1
		jmp	(a1)
; ===========================================================================
dword_182FA:	dc.l 0
		dc.l loc_17F54
; ===========================================================================

loc_18302:
		move.b	$28(a0),d0
		andi.w	#$7F,d0
		add.w	d0,d0
		add.w	d0,d0
		movea.l	dword_18338(pc,d0.w),a1
		jsr	(a1)
		lea	(Ani_Obj55a).l,a1
		jsr	(AnimateSprite).l
		move.b	status(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,render_flags(a0)
		or.b	d0,render_flags(a0)
		jmp	(DisplaySprite).l
; ===========================================================================
dword_18338:	dc.l 0
		dc.l Obj57
; ===========================================================================

loc_18340:
		movea.l	$34(a0),a1
		move.l	x_pos(a1),x_pos(a0)
		move.l	y_pos(a1),y_pos(a0)
		move.b	status(a1),status(a0)
		move.b	render_flags(a1),render_flags(a0)
		movea.l	#Ani_Obj55a,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================
byte_1836E:	dc.b   0,$FF,  1,  0	; 0
; ===========================================================================

loc_18372:
		btst	#7,status(a0)
		bne.s	loc_183C6
		movea.l	$34(a0),a1
		move.l	x_pos(a1),x_pos(a0)
		move.l	y_pos(a1),y_pos(a0)
		move.b	status(a1),status(a0)
		move.b	render_flags(a1),render_flags(a0)
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	loc_183BA
		move.b	#1,anim_frame_duration(a0)
		move.b	$2A(a0),d0
		addq.b	#1,d0
		cmpi.b	#2,d0
		ble.s	loc_183B0
		moveq	#0,d0

loc_183B0:
		move.b	byte_1836E(pc,d0.w),mapping_frame(a0)
		move.b	d0,$2A(a0)

loc_183BA:
		cmpi.b	#$FF,mapping_frame(a0)
		bne.w	loc_185D4
		rts
; ===========================================================================

loc_183C6:
		movea.l	$34(a0),a1
		btst	#6,$2E(a1)
		bne.s	loc_183D4
		rts
; ===========================================================================

loc_183D4:
		addq.b	#2,routine(a0)
		move.l	#Map_Obj55b,mappings(a0)
		move.w	#$4D8,art_tile(a0)
		move.b	#0,mapping_frame(a0)
		move.b	#5,anim_frame_duration(a0)
		movea.l	$34(a0),a1
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		addi.w	#4,y_pos(a0)
		subi.w	#$28,x_pos(a0)
		rts
; ===========================================================================

loc_18410:
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	loc_18452
		move.b	#5,anim_frame_duration(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#4,mapping_frame(a0)
		bne.w	loc_18452
		move.b	#0,mapping_frame(a0)
		movea.l	$34(a0),a1
		move.b	(a1),d0
		beq.w	loc_185DA
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		addi.w	#4,y_pos(a0)
		subi.w	#$28,x_pos(a0)

loc_18452:
		bra.w	loc_185D4
; ===========================================================================
Obj56:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj56_Index(pc,d0.w),d1
		jmp	Obj56_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj56_Index:	dc.w Obj56_Init-Obj56_Index ; DATA XREF: ROM:Obj56_Indexo
					; ROM:00018466o
		dc.w Obj56_Animate-Obj56_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj56_Init:				; DATA XREF: ROM:Obj56_Indexo
		addq.b	#2,routine(a0)
		move.l	#Map_Obj56,mappings(a0)
		move.w	#$5A0,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.b	#1,priority(a0)
		move.b	#0,$20(a0)
		move.b	#$C,width_pixels(a0)
		move.b	#7,anim_frame_duration(a0)
		move.b	#0,mapping_frame(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj56_Animate:				; DATA XREF: ROM:00018466o
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	loc_184BA
		move.b	#7,anim_frame_duration(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.w	loc_185DA

loc_184BA:				; CODE XREF: ROM:000184A4j
		bra.w	loc_185D4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Map_Obj55a:	dc.w word_184C2-Map_Obj55a ; DATA XREF:	ROM:loc_182ACo
					; ROM:Map_Obj55ao ...
		dc.w word_184CC-Map_Obj55a
word_184C2:	dc.w 1			; DATA XREF: ROM:Map_Obj55ao
		dc.w	 5,    0,    0,	 $1C; 0
word_184CC:	dc.w 1			; DATA XREF: ROM:000184C0o
		dc.w	 5,    4,    2,	 $1C; 0
Map_Obj55b:	dc.w word_184DE-Map_Obj55b ; DATA XREF:	ROM:000183D8o
					; ROM:Map_Obj55bo ...
		dc.w word_184E8-Map_Obj55b
		dc.w word_184F2-Map_Obj55b
		dc.w word_184FC-Map_Obj55b
word_184DE:	dc.w 1			; DATA XREF: ROM:Map_Obj55bo
		dc.w $F805,    0,    0,$FFF8; 0
word_184E8:	dc.w 1			; DATA XREF: ROM:000184D8o
		dc.w $F805,    4,    2,$FFF8; 0
word_184F2:	dc.w 1			; DATA XREF: ROM:000184DAo
		dc.w $F805,    8,    4,$FFF8; 0
word_184FC:	dc.w 1			; DATA XREF: ROM:000184DCo
		dc.w $F805,   $C,    6,$FFF8; 0
Map_Obj56:	dc.w word_18514-Map_Obj56 ; DATA XREF: ROM:0001846Co
					; ROM:Map_Obj56o ...
		dc.w word_1851E-Map_Obj56
		dc.w word_18528-Map_Obj56
		dc.w word_18532-Map_Obj56
		dc.w word_1853C-Map_Obj56
		dc.w word_18546-Map_Obj56
		dc.w word_18550-Map_Obj56
word_18514:	dc.w 1			; DATA XREF: ROM:Map_Obj56o
		dc.w $F805,    0,    0,$FFF8; 0
word_1851E:	dc.w 1			; DATA XREF: ROM:00018508o
		dc.w $F00F,    4,    2,$FFF0; 0
word_18528:	dc.w 1			; DATA XREF: ROM:0001850Ao
		dc.w $F00F,  $14,   $A,$FFF0; 0
word_18532:	dc.w 1			; DATA XREF: ROM:0001850Co
		dc.w $F00F,  $24,  $12,$FFF0; 0
word_1853C:	dc.w 1			; DATA XREF: ROM:0001850Eo
		dc.w $F00F,  $34,  $1A,$FFF0; 0
word_18546:	dc.w 1			; DATA XREF: ROM:00018510o
		dc.w $F00F,  $44,  $22,$FFF0; 0
word_18550:	dc.w 1			; DATA XREF: ROM:00018512o
		dc.w $F00F,  $54,  $2A,$FFF0; 0
Ani_Obj55a:	dc.w byte_1855E-Ani_Obj55a ; DATA XREF:	ROM:00018314o
					; ROM:0001835Co ...
		dc.w byte_18561-Ani_Obj55a
byte_1855E:	dc.b  $F,  0,$FF	; 0 ; DATA XREF: ROM:Ani_Obj55ao
byte_18561:	dc.b   7,  1,  2,$FF,  0; 0 ; DATA XREF: ROM:0001855Co
Map_Obj55:	dc.w word_1856C-Map_Obj55 ; DATA XREF: ROM:loc_181E4o
					; ROM:00018248o ...
		dc.w word_1858E-Map_Obj55
		dc.w word_185B0-Map_Obj55
word_1856C:	dc.w 4			; DATA XREF: ROM:Map_Obj55o
		dc.w $F805,    0,    0,$FFE0; 0
		dc.w  $805,    4,    2,$FFE0; 4
		dc.w $F80F,    8,    4,$FFF0; 8
		dc.w $F807,  $18,   $C,	 $10; 12
word_1858E:	dc.w 4			; DATA XREF: ROM:00018568o
		dc.w $E805,  $28,  $14,$FFE0; 0
		dc.w $E80D,  $30,  $18,$FFF0; 4
		dc.w $E805,  $24,  $12,	 $10; 8
		dc.w $D805,  $20,  $10,	   2; 12
word_185B0:	dc.w 4			; DATA XREF: ROM:0001856Ao
		dc.w $E805,  $28,  $14,$FFE0; 0
		dc.w $E80D,  $38,  $1C,$FFF0; 4
		dc.w $E805,  $24,  $12,	 $10; 8
		dc.w $D805,  $20,  $10,	   2; 12
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		nop

loc_185D4:				; CODE XREF: ROM:000183C0j
					; ROM:loc_18452j ...
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_185DA:				; CODE XREF: ROM:00018436j
					; ROM:000184B6j
		jmp	DeleteObject

j_Adjust2PArtPointer_4:	; JmpTo
		jmp	(Adjust2PArtPointer).l

j_Adjust2PArtPointer2_1:		; CODE XREF: ROM:00018D4Ep
					; ROM:0001915Cp ...
		jmp	Adjust2PArtPointer2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

j_Adjust2PArtPointer_5:		; CODE XREF: ROM:0001911Cp
		jmp	Adjust2PArtPointer
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ