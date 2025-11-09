; ===========================================================================
; ---------------------------------------------------------------------------
; Object 3D - GHZ Boss
; ---------------------------------------------------------------------------

Obj3D:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj3D_Index(pc,d0.w),d1
		jmp	Obj3D_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj3D_Index:	dc.w Obj3D_Main-Obj3D_Index
		dc.w Obj3D_ShipMain-Obj3D_Index
		dc.w Obj3D_FaceMain-Obj3D_Index
		dc.w Obj3D_FlameMain-Obj3D_Index
Obj3D_ObjData:	dc.b   2,  0		; 0 ; DATA XREF: ROM:Obj3D_Maint
		dc.b   4,  1		; 2
		dc.b   6,  7		; 4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj3D_Main:				; DATA XREF: ROM:Obj3D_Indexo
		lea	Obj3D_ObjData(pc),a2
		movea.l	a0,a1
		moveq	#2,d1
		bra.s	loc_18D2A
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18D22:				; CODE XREF: ROM:00018D6Cj
		jsr	(SingleObjLoad2).l
		bne.s	loc_18D70

loc_18D2A:				; CODE XREF: ROM:00018D20j
		move.b	(a2)+,routine(a1)
		move.b	#$3D,id(a1) ; '='
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	#Map_Eggman,mappings(a1)
		move.w	#$400,art_tile(a1)
		jsr	Adjust2PArtPointer2
		move.b	#4,render_flags(a1)
		move.b	#$20,width_pixels(a1) ; ' '
		move.b	#3,priority(a1)
		move.b	(a2)+,anim(a1)
		move.l	a0,$34(a1)
		dbf	d1,loc_18D22

loc_18D70:				; CODE XREF: ROM:00018D28j
		move.w	x_pos(a0),$30(a0)
		move.w	y_pos(a0),$38(a0)
		move.b	#$F,$20(a0)
		move.b	#8,$21(a0)

Obj3D_ShipMain:				; DATA XREF: ROM:00018D0Co
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj3D_ShipIndex(pc,d0.w),d1
		jsr	Obj3D_ShipIndex(pc,d1.w)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		move.b	status(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,render_flags(a0)
		or.b	d0,render_flags(a0)
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj3D_ShipIndex:dc.w loc_18DC8-Obj3D_ShipIndex ; DATA XREF: ROM:Obj3D_ShipIndexo
					; ROM:00018DBCo ...
		dc.w loc_18EC8-Obj3D_ShipIndex
		dc.w loc_18F18-Obj3D_ShipIndex
		dc.w loc_18F52-Obj3D_ShipIndex
		dc.w loc_18F78-Obj3D_ShipIndex
		dc.w loc_18FAA-Obj3D_ShipIndex
		dc.w loc_18FF6-Obj3D_ShipIndex
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18DC8:				; DATA XREF: ROM:Obj3D_ShipIndexo
		move.w	#$100,y_vel(a0)
		bsr.w	BossMove
		cmpi.w	#$338,$38(a0)
		bne.s	loc_18DE4
		move.w	#0,y_vel(a0)
		addq.b	#2,routine_secondary(a0)

loc_18DE4:				; CODE XREF: ROM:00018DD8j
					; ROM:loc_18F14j ...
		move.b	$3F(a0),d0
		jsr	(CalcSine).l
		asr.w	#6,d0
		add.w	$38(a0),d0
		move.w	d0,y_pos(a0)
		move.w	$30(a0),x_pos(a0)
		addq.b	#2,$3F(a0)
		cmpi.b	#8,routine_secondary(a0)
		bcc.s	locret_18E48
		tst.b	status(a0)
		bmi.s	loc_18E4A
		tst.b	$20(a0)
		bne.s	locret_18E48
		tst.b	$3E(a0)
		bne.s	loc_18E2C
		move.b	#$20,$3E(a0) ; ' '
		move.w	#$AC,d0	; '¬'
		jsr	(PlaySound_Special).l

loc_18E2C:				; CODE XREF: ROM:00018E1Aj
		lea	($FFFFFB22).w,a1
		moveq	#0,d0
		tst.w	(a1)
		bne.s	loc_18E3A
		move.w	#$EEE,d0

loc_18E3A:				; CODE XREF: ROM:00018E34j
		move.w	d0,(a1)
		subq.b	#1,$3E(a0)
		bne.s	locret_18E48
		move.b	#$F,$20(a0)

locret_18E48:				; CODE XREF: ROM:00018E08j
					; ROM:00018E14j ...
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18E4A:				; CODE XREF: ROM:00018E0Ej
		moveq	#$64,d0	; 'd'
		bsr.w	AddPoints
		move.b	#8,routine_secondary(a0)
		move.w	#$B3,$3C(a0) ; '³'
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


BossDefeated:				; CODE XREF: ROM:00017956j
					; ROM:00018F7Ej ...
		move.b	($FFFFFE0F).w,d0
		andi.b	#7,d0
		bne.s	locret_18EA0
		jsr	(SingleObjLoad).l
		bne.s	locret_18EA0
		move.b	#$3F,id(a1) ; '?'
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1	; ' '
		add.w	d1,x_pos(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,y_pos(a1)

locret_18EA0:				; CODE XREF: BossDefeated+8j
					; BossDefeated+10j
		rts
; End of function BossDefeated


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


BossMove:				; CODE XREF: ROM:00018DCEp
					; ROM:00018ED4p ...
		move.l	$30(a0),d2
		move.l	$38(a0),d3
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,$30(a0)
		move.l	d3,$38(a0)
		rts
; End of function BossMove

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18EC8:				; DATA XREF: ROM:00018DBCo
		move.w	#$FF00,x_vel(a0)
		move.w	#$FFC0,y_vel(a0)
		bsr.w	BossMove
		cmpi.w	#$2A00,$30(a0)
		bne.s	loc_18F14
		move.w	#0,x_vel(a0)
		move.w	#0,y_vel(a0)
		addq.b	#2,routine_secondary(a0)
		jsr	(SingleObjLoad2).l
		bne.s	loc_18F0E
		move.b	#$48,id(a1) ; 'H'
		move.w	$30(a0),x_pos(a1)
		move.w	$38(a0),y_pos(a1)
		move.l	a0,$34(a1)

loc_18F0E:				; CODE XREF: ROM:00018EF6j
		move.w	#$77,$3C(a0) ; 'w'

loc_18F14:				; CODE XREF: ROM:00018EDEj
		bra.w	loc_18DE4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18F18:				; DATA XREF: ROM:00018DBEo
		subq.w	#1,$3C(a0)
		bpl.s	loc_18F42
		addq.b	#2,routine_secondary(a0)
		move.w	#$3F,$3C(a0) ; '?'
		move.w	#$100,x_vel(a0)
		cmpi.w	#$2A00,$30(a0)
		bne.s	loc_18F42
		move.w	#$7F,$3C(a0) ; ''
		move.w	#$40,x_vel(a0) ; '@'

loc_18F42:				; CODE XREF: ROM:00018F1Cj
					; ROM:00018F34j
		btst	#0,status(a0)
		bne.s	loc_18F4E
		neg.w	x_vel(a0)

loc_18F4E:				; CODE XREF: ROM:00018F48j
		bra.w	loc_18DE4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18F52:				; DATA XREF: ROM:00018DC0o
		subq.w	#1,$3C(a0)
		bmi.s	loc_18F5E
		bsr.w	BossMove
		bra.s	loc_18F74
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18F5E:				; CODE XREF: ROM:00018F56j
		bchg	#0,status(a0)
		move.w	#$3F,$3C(a0) ; '?'
		subq.b	#2,routine_secondary(a0)
		move.w	#0,x_vel(a0)

loc_18F74:				; CODE XREF: ROM:00018F5Cj
		bra.w	loc_18DE4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18F78:				; DATA XREF: ROM:00018DC2o
		subq.w	#1,$3C(a0)
		bmi.s	loc_18F82
		bra.w	BossDefeated
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18F82:				; CODE XREF: ROM:00018F7Cj
		bset	#0,status(a0)
		bclr	#7,status(a0)
		clr.w	x_vel(a0)
		addq.b	#2,routine_secondary(a0)
		move.w	#$FFDA,$3C(a0)
		tst.b	($FFFFF7A7).w
		bne.s	locret_18FA8
		move.b	#1,($FFFFF7A7).w

locret_18FA8:				; CODE XREF: ROM:00018FA0j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18FAA:				; DATA XREF: ROM:00018DC4o
		addq.w	#1,$3C(a0)
		beq.s	loc_18FBA
		bpl.s	loc_18FC0
		addi.w	#$18,y_vel(a0)
		bra.s	loc_18FEE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18FBA:				; CODE XREF: ROM:00018FAEj
		clr.w	y_vel(a0)
		bra.s	loc_18FEE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18FC0:				; CODE XREF: ROM:00018FB0j
		cmpi.w	#$30,$3C(a0) ; '0'
		bcs.s	loc_18FD8
		beq.s	loc_18FE0
		cmpi.w	#$38,$3C(a0) ; '8'
		bcs.s	loc_18FEE
		addq.b	#2,routine_secondary(a0)
		bra.s	loc_18FEE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18FD8:				; CODE XREF: ROM:00018FC6j
		subi.w	#8,y_vel(a0)
		bra.s	loc_18FEE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18FE0:				; CODE XREF: ROM:00018FC8j
		clr.w	y_vel(a0)
		move.w	#MusID_GHZ,d0	; ''
		jsr	(PlaySound).l

loc_18FEE:				; CODE XREF: ROM:00018FB8j
					; ROM:00018FBEj ...
		bsr.w	BossMove
		bra.w	loc_18DE4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_18FF6:				; DATA XREF: ROM:00018DC6o
		move.w	#$400,x_vel(a0)
		move.w	#$FFC0,y_vel(a0)
		cmpi.w	#$2AC0,(Camera_Max_X_pos).w
		beq.s	loc_19010
		addq.w	#2,(Camera_Max_X_pos).w
		bra.s	loc_19016
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_19010:				; CODE XREF: ROM:00019008j
		tst.b	render_flags(a0)
		bpl.s	loc_1901E

loc_19016:				; CODE XREF: ROM:0001900Ej
		bsr.w	BossMove
		bra.w	loc_18DE4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1901E:				; CODE XREF: ROM:00019014j
		addq.l	#4,sp
		jmp	DeleteObject
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj3D_FaceMain:				; DATA XREF: ROM:00018D0Eo
		moveq	#0,d0
		moveq	#1,d1
		movea.l	$34(a0),a1
		move.b	routine_secondary(a1),d0
		subq.b	#4,d0
		bne.s	loc_19040
		cmpi.w	#$2A00,$30(a1)
		bne.s	loc_19048
		moveq	#4,d1

loc_19040:				; CODE XREF: ROM:00019034j
		subq.b	#6,d0
		bmi.s	loc_19048
		moveq	#$A,d1
		bra.s	loc_1905C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_19048:				; CODE XREF: ROM:0001903Cj
					; ROM:00019042j
		tst.b	$20(a1)
		bne.s	loc_19052
		moveq	#5,d1
		bra.s	loc_1905C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_19052:				; CODE XREF: ROM:0001904Cj
		cmpi.b	#4,(MainCharacter+routine).w
		bcs.s	loc_1905C
		moveq	#4,d1

loc_1905C:				; CODE XREF: ROM:00019046j
					; ROM:00019050j ...
		move.b	d1,anim(a0)
		subq.b	#2,d0
		bne.s	loc_19070
		move.b	#6,anim(a0)
		tst.b	render_flags(a0)
		bpl.s	loc_19072

loc_19070:				; CODE XREF: ROM:00019062j
		bra.s	Obj3D_Display
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_19072:				; CODE XREF: ROM:0001906Ej
		jmp	DeleteObject
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj3D_FlameMain:			; DATA XREF: ROM:00018D10o
		move.b	#7,anim(a0)
		movea.l	$34(a0),a1
		cmpi.b	#$C,routine_secondary(a1)
		bne.s	loc_19098
		move.b	#$B,anim(a0)
		tst.b	render_flags(a0)
		bpl.s	loc_190A6
		bra.s	loc_190A4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_19098:				; CODE XREF: ROM:00019088j
		move.w	x_vel(a1),d0
		beq.s	loc_190A4
		move.b	#8,anim(a0)

loc_190A4:				; CODE XREF: ROM:00019096j
					; ROM:0001909Cj
		bra.s	Obj3D_Display
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_190A6:				; CODE XREF: ROM:00019094j
		jmp	DeleteObject
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj3D_Display:				; CODE XREF: ROM:loc_19070j
					; ROM:loc_190A4j
		movea.l	$34(a0),a1
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		move.b	status(a1),status(a0)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		move.b	status(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,render_flags(a0)
		or.b	d0,render_flags(a0)
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------
; Object 48 - the ball that swings on the GHZ boss
;----------------------------------------------------

Obj48:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj48_Index(pc,d0.w),d1
		jmp	Obj48_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj48_Index:	dc.w Obj48_Init-Obj48_Index ; DATA XREF: ROM:Obj48_Indexo
					; ROM:000190F6o ...
		dc.w Obj48_Main-Obj48_Index
		dc.w loc_19226-Obj48_Index
		dc.w loc_19274-Obj48_Index
		dc.w loc_19290-Obj48_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj48_Init:				; DATA XREF: ROM:Obj48_Indexo
		addq.b	#2,routine(a0)
		move.w	#$4080,angle(a0)
		move.w	#$FE00,$3E(a0)
		move.l	#Map_BossItems,mappings(a0)
		move.w	#$46C,art_tile(a0)
		jsr	Adjust2PArtPointer
		lea	$28(a0),a2
		move.b	#0,(a2)+
		moveq	#5,d1
		movea.l	a0,a1
		bra.s	loc_1916A
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1912E:				; CODE XREF: ROM:00019190j
		jsr	(SingleObjLoad2).l
		bne.s	loc_19194
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	#$48,id(a1) ; 'H'
		move.b	#6,routine(a1)
		move.l	#Map_SwingingPlatforms,mappings(a1)
		move.w	#$380,art_tile(a1)
		jsr	Adjust2PArtPointer2
		move.b	#1,mapping_frame(a1)
		addq.b	#1,$28(a0)

loc_1916A:				; CODE XREF: ROM:0001912Cj
		move.w	a1,d5
		subi.w	#Object_Space,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5	; ''
		move.b	d5,(a2)+
		move.b	#4,render_flags(a1)
		move.b	#8,width_pixels(a1)
		move.b	#6,priority(a1)
		move.l	$34(a0),$34(a1)
		dbf	d1,loc_1912E

loc_19194:				; CODE XREF: ROM:00019134j
		move.b	#8,routine(a1)
		move.l	#Map_Obj48,mappings(a1)
		move.w	#$43AA,art_tile(a1)
		move.b	#1,mapping_frame(a1)
		move.b	#5,priority(a1)
		move.b	#$81,$20(a1)
		jmp	Adjust2PArtPointer2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj48_PosData:	dc.b   0,$10,$20,$30,$40,$60; 0	; DATA XREF: ROM:Obj48_Maint
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj48_Main:				; DATA XREF: ROM:000190F6o
		lea	Obj48_PosData(pc),a3
		lea	$28(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_191D2:				; CODE XREF: ROM:loc_191ECj
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#Object_Space,d4
		movea.l	d4,a1
		move.b	(a3)+,d0
		cmp.b	$3C(a1),d0
		beq.s	loc_191EC
		addq.b	#1,$3C(a1)

loc_191EC:				; CODE XREF: ROM:000191E6j
		dbf	d6,loc_191D2
		cmp.b	$3C(a1),d0
		bne.s	loc_19206
		movea.l	$34(a0),a1
		cmpi.b	#6,routine_secondary(a1)
		bne.s	loc_19206
		addq.b	#2,routine(a0)

loc_19206:				; CODE XREF: ROM:000191F4j
					; ROM:00019200j
		cmpi.w	#$20,$32(a0) ; ' '
		beq.s	loc_19212
		addq.w	#1,$32(a0)

loc_19212:				; CODE XREF: ROM:0001920Cj
		bsr.w	sub_19236
		move.b	angle(a0),d0
		jsr	(loc_842E).l
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_19226:				; DATA XREF: ROM:000190F8o
		bsr.w	sub_19236
		jsr	(loc_83EA).l
		jmp	(DisplaySprite).l

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_19236:				; CODE XREF: ROM:loc_19212p
					; ROM:loc_19226p
		movea.l	$34(a0),a1
		addi.b	#$20,anim_frame(a0) ; ' '
		bcc.s	loc_19248
		bchg	#0,mapping_frame(a0)

loc_19248:				; CODE XREF: sub_19236+Aj
		move.w	x_pos(a1),$3A(a0)
		move.w	y_pos(a1),d0
		add.w	$32(a0),d0
		move.w	d0,$38(a0)
		move.b	status(a1),status(a0)
		tst.b	status(a1)
		bpl.s	locret_19272
		move.b	#$3F,id(a0) ; '?'
		move.b	#0,routine(a0)

locret_19272:				; CODE XREF: sub_19236+2Ej
		rts
; End of function sub_19236

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_19274:				; DATA XREF: ROM:000190FAo
		movea.l	$34(a0),a1
		tst.b	status(a1)
		bpl.s	loc_1928A
		move.b	#$3F,id(a0) ; '?'
		move.b	#0,routine(a0)

loc_1928A:				; CODE XREF: ROM:0001927Cj
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_19290:				; DATA XREF: ROM:000190FCo
		moveq	#0,d0
		tst.b	mapping_frame(a0)
		bne.s	loc_1929A
		addq.b	#1,d0

loc_1929A:				; CODE XREF: ROM:00019296j
		move.b	d0,mapping_frame(a0)
		movea.l	$34(a0),a1
		tst.b	status(a1)
		bpl.s	loc_192C2
		move.b	#0,$20(a0)
		bsr.w	BossDefeated
		subq.b	#1,$3C(a0)
		bpl.s	loc_192C2
		move.b	#$3F,(a0) ; '?'
		move.b	#0,routine(a0)

loc_192C2:				; CODE XREF: ROM:000192A6j
					; ROM:000192B6j
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Ani_Eggman:	dc.w byte_192E0-Ani_Eggman ; DATA XREF:	ROM:00018D96o
					; ROM:000190C2o ...
		dc.w byte_192E3-Ani_Eggman
		dc.w byte_192E7-Ani_Eggman
		dc.w byte_192EB-Ani_Eggman
		dc.w byte_192EF-Ani_Eggman
		dc.w byte_192F3-Ani_Eggman
		dc.w byte_192F7-Ani_Eggman
		dc.w byte_192FB-Ani_Eggman
		dc.w byte_192FE-Ani_Eggman
		dc.w byte_19302-Ani_Eggman
		dc.w byte_19306-Ani_Eggman
		dc.w byte_19309-Ani_Eggman
byte_192E0:	dc.b  $F,  0,$FF	; 0 ; DATA XREF: ROM:Ani_Eggmano
byte_192E3:	dc.b   5,  1,  2,$FF	; 0 ; DATA XREF: ROM:000192CAo
byte_192E7:	dc.b   3,  1,  2,$FF	; 0 ; DATA XREF: ROM:000192CCo
byte_192EB:	dc.b   1,  1,  2,$FF	; 0 ; DATA XREF: ROM:000192CEo
byte_192EF:	dc.b   4,  3,  4,$FF	; 0 ; DATA XREF: ROM:000192D0o
byte_192F3:	dc.b $1F,  5,  1,$FF	; 0 ; DATA XREF: ROM:000192D2o
byte_192F7:	dc.b   3,  6,  1,$FF	; 0 ; DATA XREF: ROM:000192D4o
byte_192FB:	dc.b  $F, $A,$FF	; 0 ; DATA XREF: ROM:000192D6o
byte_192FE:	dc.b   3,  8,  9,$FF	; 0 ; DATA XREF: ROM:000192D8o
byte_19302:	dc.b   1,  8,  9,$FF	; 0 ; DATA XREF: ROM:000192DAo
byte_19306:	dc.b  $F,  7,$FF	; 0 ; DATA XREF: ROM:000192DCo
byte_19309:	dc.b   2,  9,  8, $B, $C, $B, $C,  9,  8,$FE,  2; 0
					; DATA XREF: ROM:000192DEo
Map_Eggman:	dc.w word_1932E-Map_Eggman ; DATA XREF:	ROM:00018D40o
					; ROM:Map_Eggmano ...
		dc.w word_19360-Map_Eggman
		dc.w word_19372-Map_Eggman
		dc.w word_19384-Map_Eggman
		dc.w word_1939E-Map_Eggman
		dc.w word_193B8-Map_Eggman
		dc.w word_193D2-Map_Eggman
		dc.w word_193EC-Map_Eggman
		dc.w word_1940E-Map_Eggman
		dc.w word_19418-Map_Eggman
		dc.w word_19422-Map_Eggman
		dc.w word_19424-Map_Eggman
		dc.w word_19436-Map_Eggman
word_1932E:	dc.w 6			; DATA XREF: ROM:Map_Eggmano
		dc.w $EC01,   $A,    5,$FFE4; 0
		dc.w $EC05,   $C,    6,	  $C; 4
		dc.w $FC0E,$2010,$2008,$FFE4; 8
		dc.w $FC0E,$201C,$200E,	   4; 12
		dc.w $140C,$2028,$2014,$FFEC; 16
		dc.w $1400,$202C,$2016,	  $C; 20
word_19360:	dc.w 2			; DATA XREF: ROM:00019316o
		dc.w $E404,    0,    0,$FFF4; 0
		dc.w $EC0D,    2,    1,$FFEC; 4
word_19372:	dc.w 2			; DATA XREF: ROM:00019318o
		dc.w $E404,    0,    0,$FFF4; 0
		dc.w $EC0D,  $35,  $1A,$FFEC; 4
word_19384:	dc.w 3			; DATA XREF: ROM:0001931Ao
		dc.w $E408,  $3D,  $1E,$FFF4; 0
		dc.w $EC09,  $40,  $20,$FFEC; 4
		dc.w $EC05,  $46,  $23,	   4; 8
word_1939E:	dc.w 3			; DATA XREF: ROM:0001931Co
		dc.w $E408,  $4A,  $25,$FFF4; 0
		dc.w $EC09,  $4D,  $26,$FFEC; 4
		dc.w $EC05,  $53,  $29,	   4; 8
word_193B8:	dc.w 3			; DATA XREF: ROM:0001931Eo
		dc.w $E408,  $57,  $2B,$FFF4; 0
		dc.w $EC09,  $5A,  $2D,$FFEC; 4
		dc.w $EC05,  $60,  $30,	   4; 8
word_193D2:	dc.w 3			; DATA XREF: ROM:00019320o
		dc.w $E404,  $64,  $32,	   4; 0
		dc.w $E404,    0,    0,$FFF4; 4
		dc.w $EC0D,  $35,  $1A,$FFEC; 8
word_193EC:	dc.w 4			; DATA XREF: ROM:00019322o
		dc.w $E409,  $66,  $33,$FFF4; 0
		dc.w $E408,  $57,  $2B,$FFF4; 4
		dc.w $EC09,  $5A,  $2D,$FFEC; 8
		dc.w $EC05,  $60,  $30,	   4; 12
word_1940E:	dc.w 1			; DATA XREF: ROM:00019324o
		dc.w  $405,  $2D,  $16,	 $22; 0
word_19418:	dc.w 1			; DATA XREF: ROM:00019326o
		dc.w  $405,  $31,  $18,	 $22; 0
word_19422:	dc.w 0			; DATA XREF: ROM:00019328o
word_19424:	dc.w 2			; DATA XREF: ROM:0001932Ao
		dc.w	 8, $12A, $195,	 $22; 0
		dc.w  $808,$112A,$1995,	 $22; 4
word_19436:	dc.w 2			; DATA XREF: ROM:0001932Co
		dc.w $F80B, $12D, $199,	 $22; 0
		dc.w	 1, $139, $1AB,	 $3A; 4
Map_BossItems:	dc.w word_19458-Map_BossItems ;	DATA XREF: ROM:0001910Eo
					; ROM:Map_BossItemso ...
		dc.w word_19462-Map_BossItems
		dc.w word_19474-Map_BossItems
		dc.w word_1947E-Map_BossItems
		dc.w word_19488-Map_BossItems
		dc.w word_19492-Map_BossItems
		dc.w word_194B4-Map_BossItems
		dc.w word_194C6-Map_BossItems
word_19458:	dc.w 1			; DATA XREF: ROM:Map_BossItemso
		dc.w $F805,    0,    0,$FFF8; 0
word_19462:	dc.w 2			; DATA XREF: ROM:0001944Ao
		dc.w $FC04,    4,    2,$FFF8; 0
		dc.w $F805,    0,    0,$FFF8; 4
word_19474:	dc.w 1			; DATA XREF: ROM:0001944Co
		dc.w $FC00,    6,    3,$FFFC; 0
word_1947E:	dc.w 1			; DATA XREF: ROM:0001944Eo
		dc.w $1409,    7,    3,$FFF4; 0
word_19488:	dc.w 1			; DATA XREF: ROM:00019450o
		dc.w $1405,   $D,    6,$FFF8; 0
word_19492:	dc.w 4			; DATA XREF: ROM:00019452o
		dc.w $F004,  $11,    8,$FFF8; 0
		dc.w $F801,  $13,    9,$FFF8; 4
		dc.w $F801, $813, $809,	   0; 8
		dc.w  $804,  $15,   $A,$FFF8; 12
word_194B4:	dc.w 2			; DATA XREF: ROM:00019454o
		dc.w	 5,  $17,   $B,	   0; 0
		dc.w	 0,  $1B,   $D,	 $10; 4
word_194C6:	dc.w 2			; DATA XREF: ROM:00019456o
		dc.w $1804,  $1C,   $E,	   0; 0
		dc.w	$B,  $1E,   $F,	 $10; 4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Map_Obj48:	dc.w word_85D2-Map_Obj48 ; DATA	XREF: ROM:00008364o
					; ROM:Map_Obj48o ...
		dc.w word_8604-Map_Obj48
		dc.w word_8626-Map_Obj48
		dc.w word_8648-Map_Obj48
word_85D2:	dc.w 6			; DATA XREF: ROM:Map_Obj48o
		dc.w $F004,  $24,  $12,$FFF0; 0
		dc.w $F804,$1024,$1012,$FFF0; 4
		dc.w $E80A,    0,    0,$FFE8; 8
		dc.w $E80A, $800, $800,	   0; 12
		dc.w	$A,$1000,$1000,$FFE8; 16
		dc.w	$A,$1800,$1800,	   0; 20
word_8604:	dc.w 4			; DATA XREF: ROM:000085CCo
		dc.w $E80A,    9,    4,$FFE8; 0
		dc.w $E80A, $809, $804,	   0; 4
		dc.w	$A,$1009,$1004,$FFE8; 8
		dc.w	$A,$1809,$1804,	   0; 12
word_8626:	dc.w 4			; DATA XREF: ROM:000085CEo
		dc.w $E80A,  $12,    9,$FFE8; 0
		dc.w $E80A,  $1B,   $D,	   0; 4
		dc.w	$A,$181B,$180D,$FFE8; 8
		dc.w	$A,$1812,$1809,	   0; 12
word_8648:	dc.w 4			; DATA XREF: ROM:000085D0o
		dc.w $E80A, $81B, $80D,$FFE8; 0
		dc.w $E80A, $812, $809,	   0; 4
		dc.w	$A,$1012,$1009,$FFE8; 8
		dc.w	$A,$101B,$100D,	   0; 12
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ