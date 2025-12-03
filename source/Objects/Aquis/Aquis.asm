;----------------------------------------------------
; Seahorse badnik from HPZ
;----------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex	 Obj50_Init
	GenerateIndex	 loc_15FDA
	GenerateIndex	 loc_16006
	GenerateIndex	 loc_16030
	GenerateIndex	 Obj50_Routine08
	GenerateIndex	 Obj50_Routine0A
; ===========================================================================
Obj50_Init:	
		addq.b	#2,routine(a0)
		move.l	#Map_Obj50,mappings(a0)
		move.w	#$2570,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$A,$20(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.w	#$FF00,x_vel(a0)
		move.b	$28(a0),d0
		move.b	d0,d1
		andi.w	#$F0,d1	; 'ð'
		lsl.w	#4,d1
		move.w	d1,$2E(a0)
		move.w	d1,$30(a0)
		andi.w	#$F,d0
		lsl.w	#4,d0
		subq.w	#1,d0
		move.w	d0,$32(a0)
		move.w	d0,$34(a0)
		move.w	y_pos(a0),$2A(a0)
		bsr	SingleObjLoad
		bne.s	loc_15FDA
		move.b	#$50,id(a1) ; 'P'
		move.b	#4,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		addi.w	#$A,x_pos(a1)
		addi.w	#$FFFA,y_pos(a1)
		move.l	#Map_Obj50,mappings(a1)
		move.w	#$24E0,art_tile(a1)
		ori.b	#4,render_flags(a1)
		move.b	#3,priority(a1)
		move.b	status(a0),status(a1)
		move.b	#3,anim(a1)
		move.l	a1,$36(a0)
		move.l	a0,$36(a1)
		bset	#6,status(a0)

loc_15FDA:	
		lea	(Ani_Obj50).l,a1
		bsr	AnimateSprite
		move.w	#$39C,(Water_Level_1).w
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj50_SubIndex(pc,d0.w),d1
		jsr	Obj50_SubIndex(pc,d1.w)
		bsr.w	sub_161D8
		bra.w	loc_1677A
; ===========================================================================
Obj50_SubIndex:	dc.w loc_16046-Obj50_SubIndex
		dc.w loc_16058-Obj50_SubIndex
		dc.w loc_16066-Obj50_SubIndex
; ===========================================================================

loc_16006:		
		movea.l	$36(a0),a1
		tst.b	(a1)
		beq.w	loc_1676E
		cmpi.b	#$50,(a1) ; 'P'
		bne.w	loc_1676E
		btst	#7,status(a1)
		bne.w	loc_1676E
		lea	(Ani_Obj50).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
loc_16030:	
		bsr.w	loc_162FC
		bsr.w	ObjectMove
		lea	(Ani_Obj50).l,a1
		bsr.w	AnimateSprite
		bra.w	loc_1677A
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
loc_16046:	
		bsr.w	ObjectMove
		bsr.w	sub_162DE
		bsr.w	sub_16184
		bsr.w	sub_1611C
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
loc_16058:	
		bsr.w	ObjectMove
		bsr.w	sub_162DE
		bsr.w	sub_161A6
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
loc_16066:	
		bsr.w	ObjectMoveAndFall
		bsr.w	sub_162DE
		bsr.w	sub_16078
		bsr.w	sub_160F4
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_16078:				; CODE XREF: ROM:0001606Ep
		tst.b	$2D(a0)
		bne.s	locret_16084
		tst.w	y_vel(a0)
		bpl.s	loc_16086

locret_16084:				; CODE XREF: sub_16078+4j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16086:				; CODE XREF: sub_16078+Aj
		st	$2D(a0)
		bsr.w	SingleObjLoad
		bne.s	locret_160F2
		move.b	#$50,id(a1) ; 'P'
		move.b	#6,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	#Map_Obj50,mappings(a1)
		move.w	#$24E0,art_tile(a1)
		ori.b	#4,render_flags(a1)
		move.b	#3,priority(a1)
		move.b	#$E5,$20(a1)
		move.b	#2,anim(a1)
		move.w	#$C,d0
		move.w	#$10,d1
		move.w	#$FD00,d2
		btst	#0,status(a0)
		beq.s	loc_160E6
		neg.w	d1
		neg.w	d2

loc_160E6:				; CODE XREF: sub_16078+68j
		sub.w	d0,y_pos(a1)
		sub.w	d1,x_pos(a1)
		move.w	d2,x_vel(a1)

locret_160F2:				; CODE XREF: sub_16078+16j
		rts
; End of function sub_16078


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_160F4:				; CODE XREF: ROM:00016072p
		move.w	y_pos(a0),d0
		cmp.w	(Water_Level_1).w,d0
		blt.s	locret_1611A
		move.b	#2,routine_secondary(a0)
		move.b	#0,anim(a0)
		move.w	$30(a0),$2E(a0)
		move.w	#$40,y_vel(a0) ; '@'
		sf	$2D(a0)

locret_1611A:				; CODE XREF: sub_160F4+8j
		rts
; End of function sub_160F4


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_1611C:				; CODE XREF: ROM:00016052p
		tst.b	$2C(a0)
		beq.s	locret_16182
		move.w	(MainCharacter+x_pos).w,d0
		move.w	(MainCharacter+y_pos).w,d1
		sub.w	y_pos(a0),d1
		bpl.s	locret_16182
		cmpi.w	#$FFD0,d1
		blt.s	locret_16182
		sub.w	x_pos(a0),d0
		cmpi.w	#$48,d0	; 'H'
		bgt.s	locret_16182
		cmpi.w	#$FFB8,d0
		blt.s	locret_16182
		tst.w	d0
		bpl.s	loc_1615A
		cmpi.w	#$FFD8,d0
		bgt.s	locret_16182
		btst	#0,status(a0)
		bne.s	locret_16182
		bra.s	loc_16168
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1615A:				; CODE XREF: sub_1611C+2Cj
		cmpi.w	#$28,d0	; '('
		blt.s	locret_16182
		btst	#0,status(a0)
		beq.s	locret_16182

loc_16168:				; CODE XREF: sub_1611C+3Cj
		moveq	#$20,d0	; ' '
		cmp.w	$32(a0),d0
		bgt.s	locret_16182
		move.b	#4,routine_secondary(a0)
		move.b	#1,anim(a0)
		move.w	#$FC00,y_vel(a0)

locret_16182:				; CODE XREF: sub_1611C+4j
					; sub_1611C+12j ...
		rts
; End of function sub_1611C


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_16184:				; CODE XREF: ROM:0001604Ep
		subq.w	#1,$2E(a0)
		bne.s	locret_161A4
		move.w	$30(a0),$2E(a0)
		addq.b	#2,routine_secondary(a0)
		move.w	#$FFC0,d0
		tst.b	$2C(a0)
		beq.s	loc_161A0
		neg.w	d0

loc_161A0:				; CODE XREF: sub_16184+18j
		move.w	d0,y_vel(a0)

locret_161A4:				; CODE XREF: sub_16184+4j
		rts
; End of function sub_16184


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_161A6:				; CODE XREF: ROM:00016060p
		move.w	y_pos(a0),d0
		tst.b	$2C(a0)
		bne.s	loc_161C4
		cmp.w	(Water_Level_1).w,d0
		bgt.s	locret_161C2
		subq.b	#2,routine_secondary(a0)
		st	$2C(a0)
		clr.w	y_vel(a0)

locret_161C2:				; CODE XREF: sub_161A6+Ej
					; sub_161A6+22j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_161C4:				; CODE XREF: sub_161A6+8j
		cmp.w	$2A(a0),d0
		blt.s	locret_161C2
		subq.b	#2,routine_secondary(a0)
		sf	$2C(a0)
		clr.w	y_vel(a0)
		rts
; End of function sub_161A6


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_161D8:				; CODE XREF: ROM:00015FF8p
		moveq	#$A,d0
		moveq	#$FFFFFFFA,d1
		movea.l	$36(a0),a1
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	status(a0),status(a1)
		move.b	$23(a0),$23(a1)
		move.b	render_flags(a0),render_flags(a1)
		btst	#0,status(a1)
		beq.s	loc_16208
		neg.w	d0

loc_16208:				; CODE XREF: sub_161D8+2Cj
		add.w	d0,x_pos(a1)
		add.w	d1,y_pos(a1)
		rts
; End of function sub_161D8

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj50_Routine08:			; DATA XREF: ROM:00015F1Eo
					; ROM:0001653At
		bsr.w	ObjectMoveAndFall
		bsr.w	sub_16228
		lea	(Ani_Obj50).l,a1
		bsr.w	AnimateSprite
		bra.w	loc_1677A

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_16228:				; CODE XREF: ROM:00016216p
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_16242
		add.w	d1,y_pos(a0)
		move.w	y_vel(a0),d0
		asr.w	#1,d0
		neg.w	d0
		move.w	d0,y_vel(a0)

loc_16242:				; CODE XREF: sub_16228+8j
		subi.b	#1,$21(a0)
		beq.w	loc_1676E
		rts
; End of function sub_16228

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj50_Routine0A:			; DATA XREF: ROM:00015F20o
					; ROM:0001653Ct
		bsr.w	sub_1629E
		tst.b	routine_secondary(a0)
		beq.s	locret_1628E
		subi.w	#1,$2C(a0)
		beq.w	loc_1676E
		move.w	(MainCharacter+x_pos).w,x_pos(a0)
		move.w	(MainCharacter+y_pos).w,y_pos(a0)
		addi.w	#$C,y_pos(a0)
		subi.b	#1,$2A(a0)
		bne.s	loc_16290
		move.b	#3,$2A(a0)
		bchg	#0,status(a0)
		bchg	#0,render_flags(a0)

locret_1628E:				; CODE XREF: ROM:00016256j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16290:				; CODE XREF: ROM:0001627Aj
		lea	(Ani_Obj50).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_1629E:				; CODE XREF: ROM:Obj50_Routine0Ap
		tst.b	routine_secondary(a0)
		bne.s	locret_162DC
		move.b	(MainCharacter+routine).w,d0
		cmpi.b	#2,d0
		bne.s	locret_162DC
		move.w	(MainCharacter+x_pos).w,x_pos(a0)
		move.w	(MainCharacter+y_pos).w,y_pos(a0)
		ori.b	#4,render_flags(a0)
		move.b	#1,priority(a0)
		move.b	#5,anim(a0)
		st	routine_secondary(a0)
		move.w	#$12C,$2C(a0)
		move.b	#3,$2A(a0)

locret_162DC:				; CODE XREF: sub_1629E+4j sub_1629E+Ej
		rts
; End of function sub_1629E


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_162DE:				; CODE XREF: ROM:0001604Ap
					; ROM:0001605Cp ...
		subq.w	#1,$32(a0)
		bpl.s	locret_162FA
		move.w	$34(a0),$32(a0)
		neg.w	x_vel(a0)
		bchg	#0,status(a0)
		move.b	#1,prev_anim(a0)

locret_162FA:				; CODE XREF: sub_162DE+4j
		rts
; End of function sub_162DE

; ===========================================================================
loc_162FC:	
		tst.b	$21(a0)
		beq.w	locret_162FA
		moveq	#2,d3

loc_16306:	
		bsr.w	SingleObjLoad
		bne.s	loc_16378
		move.b	id(a0),id(a1)
		move.b	#8,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	#$24E0,art_tile(a1)
		ori.b	#4,render_flags(a1)
		move.b	#3,priority(a1)
		move.w	#$FF00,y_vel(a1)
		move.b	#4,anim(a1)
		move.b	#$78,$21(a1) ; 'x'
		cmpi.w	#1,d3
		beq.s	loc_16372
		blt.s	loc_16364
		move.w	#$C0,x_vel(a1) ; 'À'
		addi.w	#$FF40,y_vel(a1)
		bra.s	loc_16378
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16364:		
		move.w	#$FF00,x_vel(a1)
		addi.w	#$FFC0,y_vel(a1)
		bra.s	loc_16378
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16372:	
		move.w	#$40,x_vel(a1) ; '@'

loc_16378:	
		dbf	d3,loc_16306
		bsr.w	SingleObjLoad
		bne.s	loc_1639A
		move.b	id(a0),id(a1)
		move.b	#$A,routine(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	#$24E0,art_tile(a1)

loc_1639A:	
loc_1676E:
		jmp	MarkObjGone_P1
