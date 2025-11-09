		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj18_Index(pc,d0.w),d1
		jmp	Obj18_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj18_Index:	dc.w loc_882C-Obj18_Index
		dc.w loc_88A2-Obj18_Index
		dc.w loc_8908-Obj18_Index
		dc.w loc_88E0-Obj18_Index
Obj18_Conf: ;	Width,	Frame
	dc.b	$20,	00
	dc.b	$20,	01
	dc.b	$20,	02
	dc.b	$40,	03
	dc.b	$30,	04
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_882C:				; DATA XREF: ROM:Obj18_Indexo
		addq.b	#2,routine(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	Obj18_Conf(pc,d0.w),a2
		move.b	(a2)+,width_pixels(a0)
		move.b	(a2)+,mapping_frame(a0)
		move.w	#$4000,art_tile(a0)
		move.l	#Map_Platforms,mappings(a0)
		cmpi.b	#ZoneID_EHZ,(Current_Zone).w
		beq.s	loc_8866
		cmpi.b	#ZoneID_HTZ,(Current_Zone).w
		bne.s	loc_8874

loc_8866:				; CODE XREF: ROM:0000885Cj
		move.l	#Map_Platforms_EHZ,mappings(a0)
		move.w	#$4000,art_tile(a0)

loc_8874:				; CODE XREF: ROM:00008864j
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.w	y_pos(a0),$2C(a0)
		move.w	y_pos(a0),$34(a0)
		move.w	x_pos(a0),$32(a0)
		move.w	#$80,angle(a0) ; '€'
		andi.b	#$F,$28(a0)

loc_88A2:				; DATA XREF: ROM:0000881Co
		move.b	status(a0),d0
		andi.b	#$18,d0
		bne.s	loc_88B8
		tst.b	$38(a0)
		beq.s	loc_88C4
		subq.b	#4,$38(a0)
		bra.s	loc_88C4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_88B8:				; CODE XREF: ROM:000088AAj
		cmpi.b	#$40,$38(a0) ; '@'
		beq.s	loc_88C4
		addq.b	#4,$38(a0)

loc_88C4:				; CODE XREF: ROM:000088B0j
					; ROM:000088B6j ...
		move.w	x_pos(a0),-(sp)
		bsr.w	sub_8926
		bsr.w	sub_890C
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#8,d3
		move.w	(sp)+,d4
		bsr.w	sub_F78A
		bra.s	loc_88E8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_88E0:				; DATA XREF: ROM:00008820o
		bsr.w	sub_8926
		bsr.w	sub_890C

loc_88E8:				; CODE XREF: ROM:000088DEj
		tst.w	(Two_player_mode).w
		beq.s	loc_88F2
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_88F2:				; CODE XREF: ROM:000088ECj
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	loc_8908
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8908:				; CODE XREF: ROM:00008902j
					; DATA XREF: ROM:0000881Eo
		bra.w	DeleteObject

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_890C:				; CODE XREF: ROM:000088CCp
					; ROM:000088E4p
		move.b	$38(a0),d0
		bsr.w	CalcSine
		move.w	#$400,d0
		muls.w	d0,d1
		swap	d1
		add.w	$2C(a0),d1
		move.w	d1,y_pos(a0)
		rts
; End of function sub_890C


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_8926:				; CODE XREF: ROM:000088C8p
					; ROM:loc_88E0p
		moveq	#0,d0
		move.b	subtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_893A(pc,d0.w),d1
		jmp	off_893A(pc,d1.w)
; End of function sub_8926

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_893A:	dc.w locret_8956-off_893A
		dc.w loc_8968-off_893A
		dc.w loc_89AE-off_893A
		dc.w loc_89C6-off_893A
		dc.w loc_89EE-off_893A
		dc.w loc_8958-off_893A
		dc.w loc_899E-off_893A
		dc.w loc_8A5C-off_893A
		dc.w loc_8A88-off_893A
		dc.w locret_8956-off_893A
		dc.w loc_8AA0-off_893A
		dc.w loc_8ABA-off_893A
		dc.w loc_8990-off_893A
		dc.w loc_8980-off_893A
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_8956:	
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8958:				; DATA XREF: ROM:00008944o
		move.w	$32(a0),d0
		move.b	angle(a0),d1
		neg.b	d1
		addi.b	#$40,d1	; '@'
		bra.s	loc_8974
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8968:				; DATA XREF: ROM:0000893Co
		move.w	$32(a0),d0
		move.b	angle(a0),d1
		subi.b	#$40,d1	; '@'

loc_8974:				; CODE XREF: ROM:00008966j
		ext.w	d1
		add.w	d1,d0
		move.w	d0,x_pos(a0)
		bra.w	loc_8AD2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8980:				; DATA XREF: ROM:00008954o
		move.w	$34(a0),d0
		move.b	($FFFFFE6C).w,d1
		neg.b	d1
		addi.b	#$30,d1	; '0'
		bra.s	loc_89BA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8990:				; DATA XREF: ROM:00008952o
		move.w	$34(a0),d0
		move.b	($FFFFFE6C).w,d1
		subi.b	#$30,d1	; '0'
		bra.s	loc_89BA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_899E:				; DATA XREF: ROM:00008946o
		move.w	$34(a0),d0
		move.b	angle(a0),d1
		neg.b	d1
		addi.b	#$40,d1	; '@'
		bra.s	loc_89BA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_89AE:				; DATA XREF: ROM:0000893Eo
		move.w	$34(a0),d0
		move.b	angle(a0),d1
		subi.b	#$40,d1	; '@'

loc_89BA:				; CODE XREF: ROM:0000898Ej
					; ROM:0000899Cj ...
		ext.w	d1
		add.w	d1,d0
		move.w	d0,$2C(a0)
		bra.w	loc_8AD2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_89C6:				; DATA XREF: ROM:00008940o
		tst.w	$3A(a0)
		bne.s	loc_89DC
		btst	#3,status(a0)
		beq.s	locret_89DA
		move.w	#$1E,$3A(a0)

locret_89DA:				; CODE XREF: ROM:000089D2j
					; ROM:000089E0j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_89DC:				; CODE XREF: ROM:000089CAj
		subq.w	#1,$3A(a0)
		bne.s	locret_89DA
		move.w	#$20,$3A(a0) ; ' '
		addq.b	#1,$28(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_89EE:				; DATA XREF: ROM:00008942o
		tst.w	$3A(a0)
		beq.s	loc_8A2E
		subq.w	#1,$3A(a0)
		bne.s	loc_8A2E
		btst	#3,status(a0)
		beq.s	loc_8A28
		lea	(MainCharacter).w,a1
		bset	#1,status(a1)
		bclr	#3,status(a1)
		move.b	#2,routine(a1)
		bclr	#3,status(a0)
		clr.b	routine_secondary(a0)
		move.w	y_vel(a0),y_vel(a1)

loc_8A28:				; CODE XREF: ROM:00008A00j
		move.b	#6,routine(a0)

loc_8A2E:				; CODE XREF: ROM:000089F2j
					; ROM:000089F8j
		move.l	$2C(a0),d3
		move.w	y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d3,$2C(a0)
		addi.w	#$38,y_vel(a0) ; '8'
		move.w	(Camera_Max_Y_pos_now).w,d0
		addi.w	#224,d0	; 'à'
		cmp.w	$2C(a0),d0
		bcc.s	locret_8A5A
		move.b	#4,routine(a0)

locret_8A5A:				; CODE XREF: ROM:00008A52j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8A5C:				; DATA XREF: ROM:00008948o
		tst.w	$3A(a0)
		bne.s	loc_8A7C
		lea	($FFFFF7E0).w,a2
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#4,d0
		tst.b	(a2,d0.w)
		beq.s	locret_8A7A
		move.w	#$3C,$3A(a0) ; '<'

locret_8A7A:				; CODE XREF: ROM:00008A72j
					; ROM:00008A80j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8A7C:				; CODE XREF: ROM:00008A60j
		subq.w	#1,$3A(a0)
		bne.s	locret_8A7A
		addq.b	#1,$28(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8A88:				; DATA XREF: ROM:0000894Ao
		subq.w	#2,$2C(a0)
		move.w	$34(a0),d0
		subi.w	#$200,d0
		cmp.w	$2C(a0),d0
		bne.s	locret_8A9E
		clr.b	$28(a0)

locret_8A9E:				; CODE XREF: ROM:00008A98j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8AA0:				; DATA XREF: ROM:0000894Eo
		move.w	$34(a0),d0
		move.b	angle(a0),d1
		subi.b	#$40,d1	; '@'
		ext.w	d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	d0,$2C(a0)
		bra.w	loc_8AD2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8ABA:				; DATA XREF: ROM:00008950o
		move.w	$34(a0),d0
		move.b	angle(a0),d1
		neg.b	d1
		addi.b	#$40,d1	; '@'
		ext.w	d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	d0,$2C(a0)

loc_8AD2:				; CODE XREF: ROM:0000897Cj
					; ROM:000089C2j ...
		move.b	($FFFFFE78).w,angle(a0)
		rts


