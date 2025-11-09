S1Obj47:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	S1Obj47_Index(pc,d0.w),d1
		jmp	S1Obj47_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
S1Obj47_Index:	dc.w S1Obj47_Init-S1Obj47_Index
		dc.w S1Obj47_Main-S1Obj47_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

S1Obj47_Init:				; DATA XREF: ROM:S1Obj47_Indexo
		addq.b	#2,routine(a0)
		move.l	#Map_S1Obj47,mappings(a0)
		move.w	#$380,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#1,priority(a0)
		move.b	#$D7,$20(a0)

S1Obj47_Main:				; DATA XREF: ROM:00013884o
		move.b	$21(a0),d0
		beq.w	loc_13976
		lea	(MainCharacter).w,a1
		bclr	#0,$21(a0)
		beq.s	loc_138CA
		bsr.s	S1Obj47_Bump

loc_138CA:				; CODE XREF: ROM:000138C6j
		lea	(Sidekick).w,a1
		bclr	#1,$21(a0)
		beq.s	loc_138D8
		bsr.s	S1Obj47_Bump

loc_138D8:				; CODE XREF: ROM:000138D4j
		clr.b	$21(a0)
		bra.w	loc_13976

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


S1Obj47_Bump:				; CODE XREF: ROM:000138C8p
					; ROM:000138D6p
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		muls.w	#-$700,d0
		asr.l	#8,d0
		move.w	d0,x_vel(a1)
		muls.w	#-$700,d1
		asr.l	#8,d1
		move.w	d1,y_vel(a1)
		bset	#1,status(a1)
		bclr	#4,status(a1)
		bclr	#5,status(a1)
		clr.b	jumping(a1)
		move.b	#1,anim(a0)
		move.w	#$B4,d0	; '´'
		jsr	(PlaySound_Special).l
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_1394E
		cmpi.b	#$8A,2(a2,d0.w)
		bcc.s	locret_13974
		addq.b	#1,2(a2,d0.w)

loc_1394E:				; CODE XREF: S1Obj47_Bump+60j
		moveq	#1,d0
		jsr	(AddPoints).l
		bsr.w	SingleObjLoad
		bne.s	locret_13974
		move.b	#ObjId_AnimalsAndPoints,id(a1)
		move.b	#PointsID_Main,Routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	#4,mapping_frame(a1)

locret_13974:	
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_13976:	
		lea	(Ani_S1Obj47).l,a1
		bsr.w	AnimateSprite
		bra.w	MarkObjGone
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Ani_S1Obj47:	dc.w byte_13988-Ani_S1Obj47 ; DATA XREF: ROM:loc_13976o
					; ROM:Ani_S1Obj47o ...
		dc.w byte_1398B-Ani_S1Obj47
byte_13988:	dc.b  $F,  0,$FF	; 0 ; DATA XREF: ROM:Ani_S1Obj47o
byte_1398B:	dc.b   3,  1,  2,  1,  2,$FD,  0; 0 ; DATA XREF: ROM:00013986o
Map_S1Obj47:	dc.w word_13998-Map_S1Obj47 ; DATA XREF: ROM:0001388Ao
					; ROM:Map_S1Obj47o ...
		dc.w word_139AA-Map_S1Obj47
		dc.w word_139BC-Map_S1Obj47
word_13998:	dc.w 2			; DATA XREF: ROM:Map_S1Obj47o
		dc.w $F007,    0,    0,$FFF0; 0
		dc.w $F007, $800, $800,	   0; 4
word_139AA:	dc.w 2			; DATA XREF: ROM:00013994o
		dc.w $F406,    8,    4,$FFF4; 0
		dc.w $F402, $808, $804,	   4; 4
word_139BC:	dc.w 2			; DATA XREF: ROM:00013996o
		dc.w $F007,   $E,    7,$FFF0; 0
		dc.w $F007, $80E, $807,	   0; 4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ