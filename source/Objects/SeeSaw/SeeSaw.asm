;----------------------------------------------------
; Object 14 - HTZ see-saw
;----------------------------------------------------

Obj14:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj14_Index(pc,d0.w),d1
		jsr	Obj14_Index(pc,d1.w)
		move.w	$30(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		jmp	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj14_Index:	dc.w loc_14CD2-Obj14_Index ; DATA XREF:	ROM:Obj14_Indexo
					; ROM:00014CC8o ...
		dc.w loc_14D40-Obj14_Index
		dc.w locret_14DF2-Obj14_Index
		dc.w loc_14E3C-Obj14_Index
		dc.w loc_14E9C-Obj14_Index
		dc.w loc_14F30-Obj14_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_14CD2:				; DATA XREF: ROM:Obj14_Indexo
		addq.b	#2,routine(a0)
		move.l	#Map_SeeSaw,mappings(a0)
		move.w	#$3CE,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$30,width_pixels(a0) ; '0'
		move.w	x_pos(a0),$30(a0)
		tst.b	$28(a0)
		bne.s	loc_14D2C
		jsr	SingleObjLoad2
		bne.s	loc_14D2C
		move.b	#ObjID_SeeSaw,id(a1)
		addq.b	#6,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	status(a0),status(a1)
		move.l	a0,$3C(a1)

loc_14D2C:	
		btst	#0,status(a0)
		beq.s	loc_14D3A
		move.b	#2,mapping_frame(a0)

loc_14D3A:				; CODE XREF: ROM:00014D32j
		move.b	mapping_frame(a0),$3A(a0)

loc_14D40:				; DATA XREF: ROM:00014CC8o
		move.b	$3A(a0),d1
		btst	#3,status(a0)
		beq.s	loc_14D9A
		moveq	#2,d1
		lea	(MainCharacter).w,a1
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0
		bcc.s	loc_14D60
		neg.w	d0
		moveq	#0,d1

loc_14D60:				; CODE XREF: ROM:00014D5Aj
		cmpi.w	#8,d0
		bcc.s	loc_14D68
		moveq	#1,d1

loc_14D68:				; CODE XREF: ROM:00014D64j
		btst	#4,status(a0)
		beq.s	loc_14DBE
		moveq	#2,d2
		lea	(Sidekick).w,a1
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0
		bcc.s	loc_14D84
		neg.w	d0
		moveq	#0,d2

loc_14D84:				; CODE XREF: ROM:00014D7Ej
		cmpi.w	#8,d0
		bcc.s	loc_14D8C
		moveq	#1,d2

loc_14D8C:				; CODE XREF: ROM:00014D88j
		add.w	d2,d1
		cmpi.w	#3,d1
		bne.s	loc_14D96
		addq.w	#1,d1

loc_14D96:				; CODE XREF: ROM:00014D92j
		lsr.w	#1,d1
		bra.s	loc_14DBE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_14D9A:				; CODE XREF: ROM:00014D4Aj
		btst	#4,status(a0)
		beq.s	loc_14DBE
		moveq	#2,d1
		lea	(Sidekick).w,a1
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0
		bcc.s	loc_14DB6
		neg.w	d0
		moveq	#0,d1

loc_14DB6:				; CODE XREF: ROM:00014DB0j
		cmpi.w	#8,d0
		bcc.s	loc_14DBE
		moveq	#1,d1

loc_14DBE:				; CODE XREF: ROM:00014D6Ej
					; ROM:00014D98j ...
		bsr.w	sub_14E10
		lea	(byte_14FFE).l,a2
		btst	#0,mapping_frame(a0)
		beq.s	loc_14DD6
		lea	(byte_1502F).l,a2

loc_14DD6:				; CODE XREF: ROM:00014DCEj
		lea	(MainCharacter).w,a1
		move.w	y_vel(a1),$38(a0)
		move.w	x_pos(a0),-(sp)
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#8,d3
		move.w	(sp)+,d4
		bra.w	sub_F7DC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_14DF2:				; DATA XREF: ROM:00014CCAo
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		moveq	#2,d1
		lea	(MainCharacter).w,a1
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0
		bcc.s	loc_14E08
		neg.w	d0
		moveq	#0,d1

loc_14E08:				; CODE XREF: ROM:00014E02j
		cmpi.w	#8,d0
		bcc.s	sub_14E10
		moveq	#1,d1

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_14E10:				; CODE XREF: ROM:loc_14DBEp
					; ROM:00014E0Cj
		move.b	mapping_frame(a0),d0
		cmp.b	d1,d0
		beq.s	locret_14E3A
		bcc.s	loc_14E1C
		addq.b	#2,d0

loc_14E1C:				; CODE XREF: sub_14E10+8j
		subq.b	#1,d0
		move.b	d0,mapping_frame(a0)
		move.b	d1,$3A(a0)
		bclr	#0,render_flags(a0)
		btst	#1,mapping_frame(a0)
		beq.s	locret_14E3A
		bset	#0,render_flags(a0)

locret_14E3A:				; CODE XREF: sub_14E10+6j
					; sub_14E10+22j
		rts
; End of function sub_14E10

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_14E3C:				; DATA XREF: ROM:00014CCCo
		addq.b	#2,routine(a0)
		move.l	#Map_SeeSawB,mappings(a0)
		move.w	#$3CE,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$8B,$20(a0)
		move.b	#$C,width_pixels(a0)
		move.w	x_pos(a0),$30(a0)
		addi.w	#$28,x_pos(a0) ; '('
		addi.w	#$10,y_pos(a0)
		move.w	y_pos(a0),$34(a0)
		move.b	#1,mapping_frame(a0)
		btst	#0,status(a0)
		beq.s	loc_14E9C
		subi.w	#$50,x_pos(a0) ; 'P'
		move.b	#2,$3A(a0)

loc_14E9C:				; CODE XREF: ROM:00014E8Ej
					; DATA XREF: ROM:00014CCEo
		movea.l	$3C(a0),a1
		moveq	#0,d0
		move.b	$3A(a0),d0
		sub.b	$3A(a1),d0
		beq.s	loc_14EF2
		bcc.s	loc_14EB0
		neg.b	d0

loc_14EB0:				; CODE XREF: ROM:00014EACj
		move.w	#$F7E8,d1
		move.w	#$FEEC,d2
		cmpi.b	#1,d0
		beq.s	loc_14ED6
		move.w	#$F510,d1
		move.w	#$FF34,d2
		cmpi.w	#$A00,$38(a1)
		blt.s	loc_14ED6
		move.w	#$F200,d1
		move.w	#$FF60,d2

loc_14ED6:				; CODE XREF: ROM:00014EBCj
					; ROM:00014ECCj
		move.w	d1,y_vel(a0)
		move.w	d2,x_vel(a0)
		move.w	x_pos(a0),d0
		sub.w	$30(a0),d0
		bcc.s	loc_14EEC
		neg.w	x_vel(a0)

loc_14EEC:				; CODE XREF: ROM:00014EE6j
		addq.b	#2,routine(a0)
		bra.s	loc_14F30
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_14EF2:				; CODE XREF: ROM:00014EAAj
		lea	(word_14FF4).l,a2
		moveq	#0,d0
		move.b	mapping_frame(a1),d0
		move.w	#$28,d2	; '('
		move.w	x_pos(a0),d1
		sub.w	$30(a0),d1
		bcc.s	loc_14F10
		neg.w	d2
		addq.w	#2,d0

loc_14F10:				; CODE XREF: ROM:00014F0Aj
		add.w	d0,d0
		move.w	$34(a0),d1
		add.w	(a2,d0.w),d1
		move.w	d1,y_pos(a0)
		add.w	$30(a0),d2
		move.w	d2,x_pos(a0)
		clr.w	y_sub(a0)
		clr.w	x_sub(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_14F30:				; CODE XREF: ROM:00014EF0j
					; DATA XREF: ROM:00014CD0o
		tst.w	y_vel(a0)
		bpl.s	loc_14F4E
		bsr.w	objectmoveandfall
		move.w	$34(a0),d0
		subi.w	#$2F,d0	; '/'
		cmp.w	y_pos(a0),d0
		bgt.s	locret_14F4C
		bsr.w	objectmoveandfall

locret_14F4C:				; CODE XREF: ROM:00014F46j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_14F4E:				; CODE XREF: ROM:00014F34j
		bsr.w	objectmoveandfall
		movea.l	$3C(a0),a1
		lea	(word_14FF4).l,a2
		moveq	#0,d0
		move.b	mapping_frame(a1),d0
		move.w	x_pos(a0),d1
		sub.w	$30(a0),d1
		bcc.s	loc_14F6E
		addq.w	#2,d0

loc_14F6E:				; CODE XREF: ROM:00014F6Aj
		add.w	d0,d0
		move.w	$34(a0),d1
		add.w	(a2,d0.w),d1
		cmp.w	y_pos(a0),d1
		bgt.s	locret_14FC2
		movea.l	$3C(a0),a1
		moveq	#2,d1
		tst.w	x_vel(a0)
		bmi.s	loc_14F8C
		moveq	#0,d1

loc_14F8C:				; CODE XREF: ROM:00014F88j
		move.b	d1,$3A(a1)
		move.b	d1,$3A(a0)
		cmp.b	mapping_frame(a1),d1
		beq.s	loc_14FB6
		lea	(MainCharacter).w,a2
		bclr	#3,status(a1)
		beq.s	loc_14FA8
		bsr.s	sub_14FC4

loc_14FA8:				; CODE XREF: ROM:00014FA4j
		lea	(Sidekick).w,a2
		bclr	#4,status(a1)
		beq.s	loc_14FB6
		bsr.s	sub_14FC4

loc_14FB6:				; CODE XREF: ROM:00014F98j
					; ROM:00014FB2j
		clr.w	x_vel(a0)
		clr.w	y_vel(a0)
		subq.b	#2,routine(a0)

locret_14FC2:				; CODE XREF: ROM:00014F7Cj
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_14FC4:				; CODE XREF: ROM:00014FA6p
					; ROM:00014FB4p
		move.w	y_vel(a0),y_vel(a2)
		neg.w	y_vel(a2)
		bset	#1,status(a2)
		bclr	#3,status(a2)
		clr.b	jumping(a2)
		move.b	#$10,anim(a2)
		move.b	#2,routine(a2)
		move.w	#$CC,d0	; 'Ì'
		jmp	(PlaySound_Special).l
; End of function sub_14FC4

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
word_14FF4:	dc.w	 -8,  -$1C,  -$2F,  -$1C,    -8; 0 ; DATA XREF:	ROM:loc_14EF2o
					; ROM:00014F56o
byte_14FFE:	dc.b  $14, $14,	$16, $18, $1A, $1C, $1A; 0 ; DATA XREF:	ROM:00014DC2o
		dc.b  $18, $16,	$14, $13, $12, $11, $10; 7
		dc.b   $F,  $E,	 $D,  $C,  $B,	$A,   9; 14
		dc.b	8,   7,	  6,   5,   4,	 3,   2; 21
		dc.b	1,   0,	 -1,  -2,  -3,	-4,  -5; 28
		dc.b   -6,  -7,	 -8,  -9, -$A, -$B, -$C; 35
		dc.b  -$D, -$E,	-$E, -$E, -$E, -$E, -$E; 42
byte_1502F:	dc.b	5,   5,	  5,   5,   5,	 5,   5; 0 ; DATA XREF:	ROM:00014DD0o
		dc.b	5,   5,	  5,   5,   5,	 5,   5; 7
		dc.b	5,   5,	  5,   5,   5,	 5,   5; 14
		dc.b	5,   5,	  5,   5,   5,	 5,   5; 21
		dc.b	5,   5,	  5,   5,   5,	 5,   5; 28
		dc.b	5,   5,	  5,   5,   5,	 5,   5; 35
		dc.b	5,   5,	  5,   5,   5,	 5,   0; 42