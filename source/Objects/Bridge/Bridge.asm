;----------------------------------------------------
; Object 11 - Bridge
;----------------------------------------------------

Obj11:					; DATA XREF: ROM:Obj_Indexo
		btst	#6,render_flags(a0)
		bne.w	@DisplaySprites
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj11_Index(pc,d0.w),d1
		jmp	Obj11_Index(pc,d1.w)
; ===========================================================================

	@DisplaySprites:	
		move.w	#(3<<7)&$380,d0
		bra.w	DisplaySpriteSub
; ===========================================================================
Obj11_Index:	dc.w @Init-Obj11_Index
		dc.w Obj11_EHZ-Obj11_Index
		dc.w Obj11_Display-Obj11_Index
		dc.w Obj11_HPZ-Obj11_Index
; ===========================================================================

Obj11_Child1	=	$30
Obj11_Child2	=	$34

@Init:	
		addq.b	#2,routine(a0)
		move.l	#Map_Bridge_GHZ,mappings(a0)
		move.w	#$44C6,art_tile(a0)

		cmpi.b	#ZoneID_EHZ,(Current_Zone).w
		bne.s	@NotEHZ

		move.l	#Map_Bridge_EHZ,mappings(a0)
		move.w	#$43C6,art_tile(a0)
	@NotEHZ:

		cmpi.b	#ZoneID_HPZ,(Current_Zone).w
		bne.s	@NotHPZ
		addq.b	#4,routine(a0)
		move.l	#Map_Bridge_HPZ,mappings(a0)
		move.w	#$6300,art_tile(a0)

	@NotHPZ:	
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$80,width_pixels(a0)
		move.w	y_pos(a0),d2
		move.w	d2,$3C(a0)
		move.w	x_pos(a0),d3
		lea	subtype(a0),a2
		moveq	#0,d1
		move.b	(a2),d1
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3
		swap	d1
		move.w	#8,d1
		bsr.s	sub_7C76
		beq.s	@Child1Spawned
		move.b	#0,routine(a0)
		rts
		@Child1Spawned:
		move.w	subtype(a1),d0
		subq.w	#8,d0
		move.w	d0,x_pos(a1)
		move.l	a1,Obj11_Child1(a0)
		swap	d1
		subq.w	#8,d1
		bls.s	@AllSegmentsDone
		move.w	d1,d4
		bsr.s	sub_7C76
		bne.s	@Child2Failed

		move.l	a1,Obj11_Child2(a0)
		move.w	d4,d0
		add.w	d0,d0
		add.w	d4,d0
		move.w	$10(a1,d0.w),d0
		subq.w	#8,d0
		move.w	d0,x_pos(a1)

	@AllSegmentsDone:	
		bra.s	Obj11_EHZ
;-----------------------------------------------------------------------------
@Child2Failed:
		move.b	#0,routine(a0)	; return as safety precaution
		movea.l	Obj11_Child1(a0),a1	; DELETE CHILD 1
		bra.w	DeleteObject2
;-----------------------------------------------------------------------------
sub_7C76:	
		jsr	SingleObjLoad2
		bne.s	@FailedSpawn
		move.b	id(a0),id(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	render_flags(a0),render_flags(a1)
		bset	#6,render_flags(a1)	; Render Subprites
		move.b	#$40,mainspr_width(a1)
		move.b	d1,mainspr_childsprites(a1)
		subq.b	#1,d1
		lea	sub2_x_pos(a1),a2
	@PositionSegments:	
		move.w	d3,(a2)+	; Horizontal Position
		move.w	d2,(a2)+	; Vertical Position
		move.w	#0,(a2)+	; Frame
		addi.w	#16,d3		; Offset by 16 pixels
		dbf	d1,@PositionSegments
		moveq	#0,d0	; make sure it's seen as zero when completed
		rts
	@FailedSpawn:
		rts
; End of function sub_7C76

;-----------------------------------------------------------------------------

Obj11_EHZ:	
		move.b	status(a0),d0
		andi.b	#$18,d0
		bne.s	loc_7CDE
		tst.b	$3E(a0)
		beq.s	loc_7D0A
		subq.b	#4,$3E(a0)
		bra.s	loc_7D06
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7CDE:				; CODE XREF: ROM:00007CD0j
		andi.b	#$10,d0
		beq.s	loc_7CFA
		move.b	$3F(a0),d0
		sub.b	$3B(a0),d0
		beq.s	loc_7CFA
		bcc.s	loc_7CF6
		addq.b	#1,$3F(a0)
		bra.s	loc_7CFA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7CF6:				; CODE XREF: ROM:00007CEEj
		subq.b	#1,$3F(a0)

loc_7CFA:				; CODE XREF: ROM:00007CE2j
					; ROM:00007CECj ...
		cmpi.b	#$40,$3E(a0) ; '@'
		beq.s	loc_7D06
		addq.b	#4,$3E(a0)

loc_7D06:				; CODE XREF: ROM:00007CDCj
					; ROM:00007D00j
		bsr.w	sub_7F36

loc_7D0A:				; CODE XREF: ROM:00007CD6j
		moveq	#0,d1
		move.b	$28(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		moveq	#8,d3
		move.w	x_pos(a0),d4
		bsr.w	sub_7DC0

loc_7D22:				; CODE XREF: ROM:00007DBCj
		tst.w	(Two_player_mode).w
		beq.s	loc_7D2A
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7D2A:				; CODE XREF: ROM:00007D26j
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	loc_7D3E
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7D3E:	
		movea.l	Obj11_Child1(a0),a1	; DELETE CHILD
		bsr.w	DeleteObject2
		cmpi.b	#8,$28(a0)
		bls.s	loc_7D56
		movea.l	Obj11_Child2(a0),a1
		bsr.w	DeleteObject2

loc_7D56:	
		bra.w	DeleteObject
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj11_Display:				; DATA XREF: ROM:00007BC2o
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj11_HPZ:				; DATA XREF: ROM:00007BC4o
		move.b	status(a0),d0
		andi.b	#$18,d0
		bne.s	loc_7D74
		tst.b	$3E(a0)
		beq.s	loc_7DA0
		subq.b	#4,$3E(a0)
		bra.s	loc_7D9C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7D74:				; CODE XREF: ROM:00007D66j
		andi.b	#$10,d0
		beq.s	loc_7D90
		move.b	$3F(a0),d0
		sub.b	$3B(a0),d0
		beq.s	loc_7D90
		bcc.s	loc_7D8C
		addq.b	#1,$3F(a0)
		bra.s	loc_7D90
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7D8C:				; CODE XREF: ROM:00007D84j
		subq.b	#1,$3F(a0)

loc_7D90:				; CODE XREF: ROM:00007D78j
					; ROM:00007D82j ...
		cmpi.b	#$40,$3E(a0) ; '@'
		beq.s	loc_7D9C
		addq.b	#4,$3E(a0)

loc_7D9C:				; CODE XREF: ROM:00007D72j
					; ROM:00007D96j
		bsr.w	sub_7F36

loc_7DA0:				; CODE XREF: ROM:00007D6Cj
		moveq	#0,d1
		move.b	subtype(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		moveq	#8,d3
		move.w	x_pos(a0),d4
		bsr.w	sub_7DC0
		bsr.w	sub_7E60
		bra.w	loc_7D22

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_7DC0:				; CODE XREF: ROM:00007D1Ep
					; ROM:00007DB4p
		lea	(Sidekick).w,a1
		moveq	#4,d6
		moveq	#$3B,d5	; ';'
		movem.l	d1-d4,-(sp)
		bsr.s	sub_7DDA
		movem.l	(sp)+,d1-d4
		lea	(MainCharacter).w,a1
		subq.b	#1,d6
		moveq	#$3F,d5	; '?'
; End of function sub_7DC0


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_7DDA:				; CODE XREF: sub_7DC0+Cp
		btst	d6,status(a0)
		beq.s	loc_7E3E
		btst	#PlayerStatusBitAir,status(a1)
		bne.s	loc_7DFA
		moveq	#0,d0
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_7DFA
		cmp.w	d2,d0
		bcs.s	loc_7E08

loc_7DFA:				; CODE XREF: sub_7DDA+Cj sub_7DDA+1Aj
		bclr	#PlayerStatusBitOnObject,status(a1)
		bclr	d6,status(a0)
		moveq	#0,d4
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7E08:				; CODE XREF: sub_7DDA+1Ej
		lsr.w	#4,d0
		move.b	d0,(a0,d5.w)
		movea.l	Obj11_Child1(a0),a2
		cmpi.w	#8,d0
		bcs.s	loc_7E20
		movea.l	Obj11_Child2(a0),a2
		subi.w	#8,d0

loc_7E20:				; CODE XREF: sub_7DDA+3Cj
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		move.w	sub2_y_pos(a2,d0.w),d0
		subq.w	#8,d0
		moveq	#0,d1
		move.b	$16(a1),d1
		sub.w	d1,d0
		move.w	d0,y_pos(a1)
		moveq	#0,d4
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7E3E:				; CODE XREF: sub_7DDA+4j
		move.w	d1,-(sp)
		jsr	sub_F880
		move.w	(sp)+,d1
		btst	d6,status(a0)
		beq.s	locret_7E5E
		moveq	#0,d0
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		lsr.w	#4,d0
		move.b	d0,(a0,d5.w)

locret_7E5E:				; CODE XREF: sub_7DDA+70j
		rts
; End of function sub_7DDA


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_7E60:				; CODE XREF: ROM:00007DB8p
		moveq	#0,d0
		tst.w	(MainCharacter+x_vel).w
		bne.s	loc_7E72
		move.b	($FFFFFE0F).w,d0
		andi.w	#$1C,d0
		lsr.w	#1,d0

loc_7E72:				; CODE XREF: sub_7E60+6j
		moveq	#0,d2
		move.b	byte_7E9F(pc,d0.w),d2
		swap	d2
		move.b	byte_7E9E(pc,d0.w),d2
		moveq	#0,d0
		tst.w	(Sidekick+x_vel).w
		bne.s	loc_7E90
		move.b	($FFFFFE0F).w,d0
		andi.w	#$1C,d0
		lsr.w	#1,d0

loc_7E90:				; CODE XREF: sub_7E60+24j
		moveq	#0,d6
		move.b	byte_7E9F(pc,d0.w),d6
		swap	d6
		move.b	byte_7E9E(pc,d0.w),d6
		bra.s	loc_7EAE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_7E9E:	dc.b 1
byte_7E9F:	dc.b   2,  1,  2,  1,  2,  1,  2,  0,  1,  0,  0,  0,  0,  0,  1; 0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7EAE:				; CODE XREF: sub_7E60+3Cj
		moveq	#-2,d3
		moveq	#-2,d4
		move.b	status(a0),d0
		andi.b	#8,d0
		beq.s	loc_7EC0
		move.b	$3F(a0),d3

loc_7EC0:				; CODE XREF: sub_7E60+5Aj
		move.b	status(a0),d0
		andi.b	#$10,d0
		beq.s	loc_7ECE
		move.b	$3B(a0),d4

loc_7ECE:				; CODE XREF: sub_7E60+68j
		movea.l	Obj11_Child1(a0),a1
		lea	$45(a1),a2
		lea	$15(a1),a1
		moveq	#0,d1
		move.b	$28(a0),d1
		subq.b	#1,d1
		moveq	#0,d5

loc_7EE4:				; CODE XREF: sub_7E60:loc_7F30j
		moveq	#0,d0
		subq.w	#1,d3
		cmp.b	d3,d5
		bne.s	loc_7EEE
		move.w	d2,d0

loc_7EEE:				; CODE XREF: sub_7E60+8Aj
		addq.w	#2,d3
		cmp.b	d3,d5
		bne.s	loc_7EF6
		move.w	d2,d0

loc_7EF6:				; CODE XREF: sub_7E60+92j
		subq.w	#1,d3
		subq.w	#1,d4
		cmp.b	d4,d5
		bne.s	loc_7F00
		move.w	d6,d0

loc_7F00:				; CODE XREF: sub_7E60+9Cj
		addq.w	#2,d4
		cmp.b	d4,d5
		bne.s	loc_7F08
		move.w	d6,d0

loc_7F08:				; CODE XREF: sub_7E60+A4j
		subq.w	#1,d4
		cmp.b	d3,d5
		bne.s	loc_7F14
		swap	d2
		move.w	d2,d0
		swap	d2

loc_7F14:				; CODE XREF: sub_7E60+ACj
		cmp.b	d4,d5
		bne.s	loc_7F1E
		swap	d6
		move.w	d6,d0
		swap	d6

loc_7F1E:				; CODE XREF: sub_7E60+B6j
		move.b	d0,(a1)
		addq.w	#1,d5
		addq.w	#6,a1
		cmpa.w	a2,a1
		bne.s	loc_7F30
		movea.l	Obj11_Child2(a0),a1
		lea	$15(a1),a1

loc_7F30:				; CODE XREF: sub_7E60+C6j
		dbf	d1,loc_7EE4
		rts
; End of function sub_7E60


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_7F36:				; CODE XREF: ROM:loc_7D06p
					; ROM:loc_7D9Cp
		move.b	$3E(a0),d0
		bsr.w	CalcSine
		move.w	d1,d4
		lea	(Obj11_BendData2).l,a4
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#4,d0
		moveq	#0,d3
		move.b	$3F(a0),d3
		move.w	d3,d2
		add.w	d0,d3
		moveq	#0,d5
		lea	(Obj11_BendData-$80).l,a5
		move.b	(a5,d3.w),d5

loc_7F64:
		andi.w	#$F,d3
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		movea.l	Obj11_Child1(a0),a1
		lea	sub9_y_pos+next_subspr(a1),a2
		lea	sub2_y_pos(a1),a1

loc_7F7A:				; CODE XREF: sub_7F36:loc_7F9Aj
		moveq	#0,d0
		move.b	(a3)+,d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	$3C(a0),d0
		move.w	d0,(a1)
		addq.w	#next_subspr,a1
		cmpa.w	a2,a1
		bne.s	loc_7F9A
		movea.l	Obj11_Child2(a0),a1
		lea	sub2_y_pos(a1),a1

loc_7F9A:				; CODE XREF: sub_7F36+5Aj
		dbf	d2,loc_7F7A
		moveq	#0,d0
		move.b	$28(a0),d0
		moveq	#0,d3
		move.b	$3F(a0),d3
		addq.b	#1,d3
		sub.b	d0,d3
		neg.b	d3
		bmi.s	locret_7FE4
		move.w	d3,d2
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		adda.w	d2,a3
		subq.w	#1,d2
		bcs.s	locret_7FE4

loc_7FC0:				; CODE XREF: sub_7F36:loc_7FE0j
		moveq	#0,d0
		move.b	-(a3),d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	$3C(a0),d0
		move.w	d0,(a1)
		addq.w	#next_subspr,a1
		cmpa.w	a2,a1
		bne.s	loc_7FE0
		movea.l	Obj11_Child2(a0),a1
		lea	sub2_y_pos(a1),a1

loc_7FE0:				; CODE XREF: sub_7F36+A0j
		dbf	d2,loc_7FC0

locret_7FE4:				; CODE XREF: sub_7F36+7Aj sub_7F36+88j
		rts
; End of function sub_7F36

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj11_BendData:	dc.b   2,  4,  6,  8,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0,  0,  0; 0
					; DATA XREF: sub_7F36+24t
		dc.b   2,  4,  6,  8, $A,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0,  0; 16
		dc.b   2,  4,  6,  8, $A, $A,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0; 32
		dc.b   2,  4,  6,  8, $A, $C, $A,  8,  6,  4,  2,  0,  0,  0,  0,  0; 48
		dc.b   2,  4,  6,  8, $A, $C, $C, $A,  8,  6,  4,  2,  0,  0,  0,  0; 64
		dc.b   2,  4,  6,  8, $A, $C, $E, $C, $A,  8,  6,  4,  2,  0,  0,  0; 80
		dc.b   2,  4,  6,  8, $A, $C, $E, $E, $C, $A,  8,  6,  4,  2,  0,  0; 96
		dc.b   2,  4,  6,  8, $A, $C, $E,$10, $E, $C, $A,  8,  6,  4,  2,  0; 112
		dc.b   2,  4,  6,  8, $A, $C, $E,$10,$10, $E, $C, $A,  8,  6,  4,  2; 128
Obj11_BendData2:dc.b $FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 0
		dc.b $B5,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 16
		dc.b $7E,$DB,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 32
		dc.b $61,$B5,$EC,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 48
		dc.b $4A,$93,$CD,$F3,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 64
		dc.b $3E,$7E,$B0,$DB,$F6,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 80
		dc.b $38,$6D,$9D,$C5,$E4,$F8,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0; 96
		dc.b $31,$61,$8E,$B5,$D4,$EC,$FB,$FF,  0,  0,  0,  0,  0,  0,  0,  0; 112
		dc.b $2B,$56,$7E,$A2,$C1,$DB,$EE,$FB,$FF,  0,  0,  0,  0,  0,  0,  0; 128
		dc.b $25,$4A,$73,$93,$B0,$CD,$E1,$F3,$FC,$FF,  0,  0,  0,  0,  0,  0; 144
		dc.b $1F,$44,$67,$88,$A7,$BD,$D4,$E7,$F4,$FD,$FF,  0,  0,  0,  0,  0; 160
		dc.b $1F,$3E,$5C,$7E,$98,$B0,$C9,$DB,$EA,$F6,$FD,$FF,  0,  0,  0,  0; 176
		dc.b $19,$38,$56,$73,$8E,$A7,$BD,$D1,$E1,$EE,$F8,$FE,$FF,  0,  0,  0; 192
		dc.b $19,$38,$50,$6D,$83,$9D,$B0,$C5,$D8,$E4,$F1,$F8,$FE,$FF,  0,  0; 208
		dc.b $19,$31,$4A,$67,$7E,$93,$A7,$BD,$CD,$DB,$E7,$F3,$F9,$FE,$FF,  0; 224
		dc.b $19,$31,$4A,$61,$78,$8E,$A2,$B5,$C5,$D4,$E1,$EC,$F4,$FB,$FE,$FF; 240
; ===========================================================================