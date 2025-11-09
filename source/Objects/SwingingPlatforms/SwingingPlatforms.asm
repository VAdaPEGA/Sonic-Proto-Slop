; ===========================================================================
; Swinging platforms
;----------------------------------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex	2, loc_821E
	GenerateIndex	2, loc_83AA
	GenerateIndex	2, loc_8526
	GenerateIndex	2, loc_8526
	GenerateIndex	2, loc_852A
	GenerateIndex	2, loc_83CA
; ===========================================================================
loc_821E:	
		addq.b	#2,routine(a0)
		move.l	#Map_SwingingPlatforms,mappings(a0)
		move.w	#$44D0,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#3,priority(a0)
		move.b	#$18,width_pixels(a0)
		move.b	#8,y_radius(a0)
		move.w	y_pos(a0),$38(a0)
		move.w	x_pos(a0),$3A(a0)
		cmpi.b	#ZoneID_EHZ,(Current_Zone).w
		bne.s	loc_8284

		move.l	#Map_Obj15_EHZ,mappings(a0)
		move.w	#$43DC,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#$20,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#$99,$20(a0)

loc_8284:	
		cmpi.b	#ZoneID_CPZ,(Current_Zone).w
		bne.s	loc_82BE

		move.l	#Map_PlatformsCPZ,mappings(a0)
		move.w	#$6400,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#$20,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		lea	subtype(a0),a2
		move.b	(a2),d0
		lsl.w	#4,d0
		move.b	d0,$3C(a0)
		move.b	#0,(a2)+
		bra.w	loc_8388
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_82BE:
		move.b	id(a0),d4
		moveq	#0,d1
		lea	subtype(a0),a2
		move.b	(a2),d1
		move.w	d1,-(sp)
		andi.w	#$F,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		addi.b	#8,d3
		move.b	d3,$3C(a0)
		subi.b	#8,d3
		tst.b	mapping_frame(a0)
		beq.s	loc_82F0
		addi.b	#8,d3
		subq.w	#1,d1

loc_82F0:	
		jsr	SingleObjLoad2
		bne.s	loc_835C
		addq.b	#1,$28(a0)
		move.w	a1,d5
		subi.w	#Object_Space,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5	; ''
		move.b	d5,(a2)+
		move.b	#8,routine(a1)
		move.b	d4,id(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		bclr	#6,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.b	#4,priority(a1)
		move.b	#8,width_pixels(a1)
		move.b	#1,mapping_frame(a1)
		move.b	d3,$3C(a1)
		subi.b	#$10,d3
		bcc.s	loc_8358
		move.b	#2,mapping_frame(a1)
		move.b	#3,priority(a1)
		bset	#6,art_tile(a1)

loc_8358:	
		dbf	d1,loc_82F0

loc_835C:	
		move.w	(sp)+,d1
		btst	#4,d1
		beq.s	loc_8388
		move.l	#Map_Obj48,mappings(a0)
		move.w	#$43AA,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#1,mapping_frame(a0)
		move.b	#2,priority(a0)
		move.b	#$81,$20(a0)

loc_8388:	
		move.w	a0,d5
		subi.w	#Object_Space,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.w	#$4080,angle(a0)
		move.w	#$FE00,$3E(a0)
		cmpi.b	#ZoneID_HTZ,(Current_Zone).w	; Scrap Brain Maces
		beq.s	loc_83CA

loc_83AA:	
		move.w	x_pos(a0),-(sp)
		bsr.w	sub_83D2
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#0,d3
		move.b	y_radius(a0),d3
		addq.b	#1,d3
		move.w	(sp)+,d4
		bsr.w	sub_F82E
		bra.w	loc_84EE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_83CA:	
		bsr.w	sub_83D2
		bra.w	loc_84EE

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_83D2:	
		move.b	($FFFFFE78).w,d0
		move.w	#$80,d1	; '€'
		btst	#0,status(a0)
		beq.s	loc_83E6
		neg.w	d0
		add.w	d1,d0

loc_83E6:				; CODE XREF: sub_83D2+Ej
		bra.w	loc_8472
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_83EA:				; CODE XREF: ROM:0001922Ap
		tst.b	$3D(a0)
		bne.s	loc_840E
		move.w	$3E(a0),d0
		addi.w	#8,d0
		move.w	d0,$3E(a0)
		add.w	d0,angle(a0)
		cmpi.w	#$200,d0
		bne.s	loc_842A
		move.b	#1,$3D(a0)
		bra.s	loc_842A
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_840E:				; CODE XREF: sub_83D2+1Cj
		move.w	$3E(a0),d0
		subi.w	#8,d0
		move.w	d0,$3E(a0)
		add.w	d0,angle(a0)
		cmpi.w	#$FE00,d0
		bne.s	loc_842A
		move.b	#0,$3D(a0)

loc_842A:				; CODE XREF: sub_83D2+32j sub_83D2+3Aj ...
		move.b	angle(a0),d0

loc_842E:				; CODE XREF: ROM:0001921Ap
		bsr.w	CalcSine
		move.w	$38(a0),d2
		move.w	$3A(a0),d3
		lea	$28(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_8442:				; CODE XREF: sub_83D2+9Aj
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#Object_Space,d4
		movea.l	d4,a1
		moveq	#0,d4
		move.b	$3C(a1),d4
		move.l	d4,d5
		muls.w	d0,d5
		asr.l	#8,d5
		muls.w	d1,d4
		asr.l	#8,d4
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,y_pos(a1)
		move.w	d5,x_pos(a1)
		dbf	d6,loc_8442
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8472:				; CODE XREF: sub_83D2:loc_83E6j
		bsr.w	CalcSine
		move.w	$38(a0),d2
		move.w	$3A(a0),d3
		moveq	#0,d4
		move.b	$3C(a0),d4
		move.l	d4,d5
		muls.w	d0,d5
		asr.l	#8,d5
		muls.w	d1,d4
		asr.l	#8,d4
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,y_pos(a0)
		move.w	d5,x_pos(a0)
		lea	$28(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6
		adda.w	d6,a2
		subq.b	#1,d6
		bcs.s	locret_84EC
		move.w	d6,-(sp)
		asl.w	#4,d0
		ext.l	d0
		asl.l	#8,d0
		asl.w	#4,d1
		ext.l	d1
		asl.l	#8,d1
		moveq	#0,d4
		moveq	#0,d5

loc_84BA:				; CODE XREF: sub_83D2+114j
		moveq	#0,d6
		move.b	-(a2),d6
		lsl.w	#6,d6
		addi.l	#Object_Space,d6
		movea.l	d6,a1
		movem.l	d4-d5,-(sp)
		swap	d4
		swap	d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,y_pos(a1)
		move.w	d5,x_pos(a1)
		movem.l	(sp)+,d4-d5
		add.l	d0,d5
		add.l	d1,d4
		subq.w	#1,(sp)
		bcc.w	loc_84BA
		addq.w	#2,sp

locret_84EC:				; CODE XREF: sub_83D2+D4j
		rts
; End of function sub_83D2

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_84EE:				; CODE XREF: ROM:000083C6j
					; ROM:000083CEj
		move.w	$3A(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_8506
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8506:				; CODE XREF: ROM:000084FEj
		moveq	#0,d2
		lea	$28(a0),a2
		move.b	(a2)+,d2

loc_850E:				; CODE XREF: ROM:00008520j
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#Object_Space,d0
		movea.l	d0,a1
		bsr.w	DeleteObject2
		dbf	d2,loc_850E
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8526:				; DATA XREF: ROM:00008216o
					; ROM:00008218o
		bra.w	DeleteObject
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_852A:				; DATA XREF: ROM:0000821Ao
		bra.w	DisplaySprite
