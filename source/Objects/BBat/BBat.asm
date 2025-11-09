;----------------------------------------------------
; Object 4C - Bat badnik from HPZ
;----------------------------------------------------

Obj4C:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj4C_Index(pc,d0.w),d1
		jmp	Obj4C_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj4C_Index:	dc.w Obj4C_Init-Obj4C_Index
		dc.w loc_16DA2-Obj4C_Index
		dc.w loc_16E10-Obj4C_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj4C_Init:				; DATA XREF: ROM:Obj4C_Indexo
		move.l	#Map_Obj4C,mappings(a0)
		move.w	#$2530,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$A,$20(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#8,x_radius(a0)
		addq.b	#2,routine(a0)
		move.w	y_pos(a0),$2E(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16DA2:				; DATA XREF: ROM:00016D60o
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj4C_SubIndex(pc,d0.w),d1
		jsr	Obj4C_SubIndex(pc,d1.w)
		bsr.w	sub_16DC8
		lea	(Ani_Obj4C).l,a1
		bra.w	j_AnimateSprite_6
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj4C_SubIndex:	dc.w loc_16F2E-Obj4C_SubIndex
		dc.w loc_16F66-Obj4C_SubIndex
		dc.w loc_16F72-Obj4C_SubIndex

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_16DC8:				; CODE XREF: ROM:00016DB0p
		move.b	$3F(a0),d0
		jsr	(CalcSine).l
		asr.w	#6,d1
		add.w	$2E(a0),d1
		move.w	d1,y_pos(a0)
		addq.b	#4,$3F(a0)
		rts
; End of function sub_16DC8


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_16DE2:				; CODE XREF: ROM:00016F36p
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		cmpi.w	#$80,d0	; '€'
		bgt.s	locret_16E0E
		cmpi.w	#$FF80,d0
		blt.s	locret_16E0E
		move.b	#4,routine_secondary(a0)
		move.b	#2,anim(a0)
		move.w	#8,$2A(a0)
		move.b	#0,$3E(a0)

locret_16E0E:				; CODE XREF: sub_16DE2+Cj
					; sub_16DE2+12j
		rts
; End of function sub_16DE2

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16E10:				; DATA XREF: ROM:00016D62o
		bsr.w	sub_16F0E
		bsr.w	sub_16EB0
		bsr.w	sub_16E30
		jsr	ObjectMove
		lea	(Ani_Obj4C).l,a1
j_AnimateSprite_6:	
		jsr	AnimateSprite
		jmp	MarkObjGone

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_16E30:				; CODE XREF: ROM:00016E18p
		tst.b	$3D(a0)
		beq.s	locret_16E42
		bset	#0,render_flags(a0)
		bset	#0,status(a0)

locret_16E42:				; CODE XREF: sub_16E30+4j
		rts
; End of function sub_16E30


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_16E44:				; CODE XREF: ROM:loc_16F72p
		subi.w	#1,$2C(a0)
		bpl.s	locret_16E8E
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		cmpi.w	#$60,d0	; '`'
		bgt.s	loc_16E90
		cmpi.w	#$FFA0,d0
		blt.s	loc_16E90
		tst.w	d0
		bpl.s	loc_16E68
		st	$3D(a0)

loc_16E68:				; CODE XREF: sub_16E44+1Ej
		move.b	#$40,$3F(a0) ; '@'
		move.w	#$400,ground_speed(a0)
		move.b	#4,routine(a0)
		move.b	#3,anim(a0)
		move.w	#$C,$2A(a0)
		move.b	#1,$3E(a0)
		moveq	#0,d0

locret_16E8E:				; CODE XREF: sub_16E44+6j
					; sub_16E44+56j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16E90:				; CODE XREF: sub_16E44+14j
					; sub_16E44+1Aj
		cmpi.w	#$80,d0	; '€'
		bgt.s	loc_16E9C
		cmpi.w	#$FF80,d0
		bgt.s	locret_16E8E

loc_16E9C:				; CODE XREF: sub_16E44+50j
		move.b	#1,anim(a0)
		move.b	#0,routine_secondary(a0)
		move.w	#$18,$2A(a0)
		rts
; End of function sub_16E44


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_16EB0:				; CODE XREF: ROM:00016E14p
		tst.b	$3D(a0)
		bne.s	loc_16ECA
		moveq	#0,d0
		move.b	$3F(a0),d0
		cmpi.w	#$C0,d0	; 'À'
		bge.s	loc_16EDE
		addq.b	#2,d0
		move.b	d0,$3F(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16ECA:				; CODE XREF: sub_16EB0+4j
		moveq	#0,d0
		move.b	$3F(a0),d0
		cmpi.w	#$C0,d0	; 'À'
		beq.s	loc_16EDE
		subq.b	#2,d0
		move.b	d0,$3F(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16EDE:				; CODE XREF: sub_16EB0+10j
					; sub_16EB0+24j
		sf	$3D(a0)
		move.b	#0,anim(a0)
		move.b	#2,routine(a0)
		move.b	#0,routine_secondary(a0)
		move.w	#$18,$2A(a0)
		move.b	#1,anim(a0)
		bclr	#0,render_flags(a0)
		bclr	#0,status(a0)
		rts
; End of function sub_16EB0


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_16F0E:				; CODE XREF: ROM:loc_16E10p
		move.b	$3F(a0),d0
		jsr	(CalcSine).l
		muls.w	ground_speed(a0),d0
		asr.l	#8,d0
		move.w	d0,x_vel(a0)
		muls.w	ground_speed(a0),d1
		asr.l	#8,d1
		move.w	d1,y_vel(a0)
		rts
; End of function sub_16F0E

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16F2E:				; DATA XREF: ROM:Obj4C_SubIndexo
		subi.w	#1,$2A(a0)
		bpl.s	locret_16F64
		bsr.w	sub_16DE2
		beq.s	locret_16F64
		jsr	(RandomNumber).l
		andi.b	#$FF,d0
		bne.s	locret_16F64
		move.w	#$18,$2A(a0)
		move.w	#$1E,$2C(a0)
		addq.b	#2,routine_secondary(a0)
		move.b	#1,anim(a0)
		move.b	#0,$3E(a0)

locret_16F64:				; CODE XREF: ROM:00016F34j
					; ROM:00016F3Aj ...
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16F66:				; DATA XREF: ROM:00016DC4o
		subq.b	#1,$2A(a0)
		bpl.s	locret_16F70
		subq.b	#2,routine_secondary(a0)

locret_16F70:				; CODE XREF: ROM:00016F6Aj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16F72:				; DATA XREF: ROM:00016DC6o
		bsr.w	sub_16E44
		beq.s	locret_16FB8
		subi.w	#1,$2A(a0)
		bne.s	locret_16FB8
		move.b	$3E(a0),d0
		beq.s	loc_16FA0
		move.b	#0,$3E(a0)
		move.w	#8,$2A(a0)
		bset	#0,render_flags(a0)
		bset	#0,status(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16FA0:				; CODE XREF: ROM:00016F84j
		move.b	#1,$3E(a0)
		move.w	#$C,$2A(a0)
		bclr	#0,render_flags(a0)
		bclr	#0,status(a0)

locret_16FB8:				; CODE XREF: ROM:00016F76j
					; ROM:00016F7Ej
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Ani_Obj4C:	dc.w byte_16FC2-Ani_Obj4C ; DATA XREF: ROM:00016DB4o
					; ROM:00016E20o ...
		dc.w byte_16FC6-Ani_Obj4C
		dc.w byte_16FD5-Ani_Obj4C
		dc.w byte_16FE6-Ani_Obj4C
byte_16FC2:	dc.b   1,  0,  5,$FF	; 0 ; DATA XREF: ROM:Ani_Obj4Co
byte_16FC6:	dc.b   1,  1,  6,  1,  6,  2,  7,  2,  7,  1,  6,  1,  6,$FD,  0; 0
					; DATA XREF: ROM:00016FBCo
byte_16FD5:	dc.b   1,  1,  6,  1,  6,  2,  7,  3,  8,  4,  9,  4,  9,  3,  8,$FE; 0
					; DATA XREF: ROM:00016FBEo
		dc.b  $A		; 16
byte_16FE6:	dc.b   3, $A, $B, $C, $D, $E,$FF,  0; 0	; DATA XREF: ROM:00016FC0o
