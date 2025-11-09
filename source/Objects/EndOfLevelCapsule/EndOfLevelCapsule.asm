;----------------------------------------------------
; Object 3E - prison capsule
;----------------------------------------------------

Obj3E:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj3E_Index(pc,d0.w),d1
		jsr	Obj3E_Index(pc,d1.w)
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	loc_1950A
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1950A:				; CODE XREF: ROM:00019502j
		jmp	DeleteObject
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj3E_Index:	dc.w Obj3E_Init-Obj3E_Index ; DATA XREF: ROM:Obj3E_Indexo
					; ROM:00019512o ...
		dc.w Obj3E_BodyMain-Obj3E_Index
		dc.w Obj3E_Switched-Obj3E_Index
		dc.w Obj3E_Explosion-Obj3E_Index
		dc.w Obj3E_Explosion-Obj3E_Index
		dc.w Obj3E_Explosion-Obj3E_Index
		dc.w Obj3E_Animals-Obj3E_Index
		dc.w Obj3E_EndAct-Obj3E_Index
Obj3E_Var:	dc.b   2,$20,  4,  0	; 0
		dc.b   4, $C,  5,  1	; 4
		dc.b   6,$10,  4,  3	; 8
		dc.b   8,$10,  3,  5	; 12
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj3E_Init:				; DATA XREF: ROM:Obj3E_Indexo
		move.l	#Map_Obj3E,mappings(a0)
		move.w	#$49D,art_tile(a0)
		bsr.w	j_Adjust2PArtPointer_6
		move.b	#4,render_flags(a0)
		move.w	y_pos(a0),$30(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsl.w	#2,d0
		lea	Obj3E_Var(pc,d0.w),a1
		move.b	(a1)+,routine(a0)
		move.b	(a1)+,width_pixels(a0)
		move.b	(a1)+,priority(a0)
		move.b	(a1)+,mapping_frame(a0)
		cmpi.w	#8,d0
		bne.s	locret_1957C
		move.b	#6,$20(a0)
		move.b	#8,$21(a0)

locret_1957C:				; CODE XREF: ROM:0001956Ej
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj3E_BodyMain:				; DATA XREF: ROM:00019512o
		cmpi.b	#2,($FFFFF7A7).w
		beq.s	loc_1959C
		move.w	#$2B,d1	; '+'
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	x_pos(a0),d4
		jmp	SolidObject
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1959C:				; CODE XREF: ROM:00019584j
		tst.b	routine_secondary(a0)
		beq.s	loc_195B2
		clr.b	routine_secondary(a0)
		bclr	#PlayerStatusBitOnObject,(MainCharacter+status).w
		bset	#PlayerStatusBitAir,(MainCharacter+status).w

loc_195B2:				; CODE XREF: ROM:000195A0j
		move.b	#2,mapping_frame(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj3E_Switched:				; DATA XREF: ROM:00019514o
		move.w	#$17,d1
		move.w	#8,d2
		move.w	#8,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObject).l
		lea	(Ani_Obj3E).l,a1
		jsr	(AnimateSprite).l
		move.w	$30(a0),y_pos(a0)
		move.b	status(a0),d0
		andi.b	#$18,d0
		beq.s	locret_19620
		addq.w	#8,y_pos(a0)
		move.b	#$A,routine(a0)
		move.w	#$3C,anim_frame_duration(a0) ; '<'
		clr.b	(Update_HUD_timer).w
		clr.b	($FFFFF7AA).w
		move.b	#1,($FFFFF7CC).w
		move.w	#btnR<<8,(Ctrl_1_Logical).w	; force right held input
		clr.b	routine_secondary(a0)
		bclr	#PlayerStatusBitOnObject,(MainCharacter+status).w
		bset	#PlayerStatusBitAir,(MainCharacter+status).w

locret_19620:	
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj3E_Explosion:			; DATA XREF: ROM:00019516o
					; ROM:00019518o ...
		moveq	#7,d0
		and.b	($FFFFFE0F).w,d0
		bne.s	loc_19660
		jsr	(SingleObjLoad).l
		bne.s	loc_19660
		move.b	#$3F,id(a1) ; '?'
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		jsr	(RandomNumber).l
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1	; ' '
		add.w	d1,x_pos(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,y_pos(a1)

loc_19660:				; CODE XREF: ROM:00019628j
					; ROM:00019630j
		subq.w	#1,anim_frame_duration(a0)
		beq.s	loc_19668
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_19668:				; CODE XREF: ROM:00019664j
		move.b	#2,($FFFFF7A7).w
		move.b	#$C,routine(a0)
		move.b	#6,mapping_frame(a0)
		move.w	#$96,anim_frame_duration(a0) ; '–'
		addi.w	#$20,y_pos(a0) ; ' '
		moveq	#8-1,d6
		move.w	#$9A,d5	; 'š'
		moveq	#$FFFFFFE4,d4

loc_1968E:				; CODE XREF: ROM:000196B4j
		jsr	(SingleObjLoad).l
		bne.s	locret_196B8
		move.b	#$28,id(a1) ; '('
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		add.w	d4,x_pos(a1)
		addq.w	#7,d4
		move.w	d5,$36(a1)
		subq.w	#8,d5
		dbf	d6,loc_1968E

locret_196B8:				; CODE XREF: ROM:00019694j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj3E_Animals:				; DATA XREF: ROM:0001951Co
		moveq	#8-1,d0
		and.b	($FFFFFE0F).w,d0
		bne.s	loc_196F8
		jsr	(SingleObjLoad).l
		bne.s	loc_196F8
		move.b	#$28,id(a1) ; '('
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		jsr	(RandomNumber).l
		andi.w	#$1F,d0
		subq.w	#6,d0
		tst.w	d1
		bpl.s	loc_196EE
		neg.w	d0

loc_196EE:				; CODE XREF: ROM:000196EAj
		add.w	d0,x_pos(a1)
		move.w	#$C,$36(a1)

loc_196F8:				; CODE XREF: ROM:000196C0j
					; ROM:000196C8j
		subq.w	#1,anim_frame_duration(a0)
		bne.s	locret_19708
		addq.b	#2,routine(a0)
		move.w	#$B4,anim_frame_duration(a0) ; '´'

locret_19708:				; CODE XREF: ROM:000196FCj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj3E_EndAct:				; DATA XREF: ROM:0001951Eo
		moveq	#63-1,d0
		moveq	#$28,d1	; animals object slot
		moveq	#Object_RAM,d2
		lea	(Sidekick).w,a1

loc_19714:				; CODE XREF: ROM:0001971Aj
		cmp.b	(a1),d1
		beq.s	locret_1972A
		adda.w	d2,a1
		dbf	d0,loc_19714
		jsr	(Load_EndOfAct).l
		jmp	(DeleteObject).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_1972A:				; CODE XREF: ROM:00019716j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Ani_Obj3E:	dc.w byte_19730-Ani_Obj3E ; DATA XREF: ROM:000195D0o
					; ROM:Ani_Obj3Eo ...
		dc.w byte_19730-Ani_Obj3E
byte_19730:	dc.b   2,  1,  3,$FF	; 0 ; DATA XREF: ROM:Ani_Obj3Eo
					; ROM:0001972Eo
Map_Obj3E:	dc.w word_19742-Map_Obj3E ; DATA XREF: ROM:Obj3E_Inito
					; ROM:Map_Obj3Eo ...
		dc.w word_1977C-Map_Obj3E
		dc.w word_19786-Map_Obj3E
		dc.w word_197B8-Map_Obj3E
		dc.w word_197C2-Map_Obj3E
		dc.w word_197D4-Map_Obj3E
		dc.w unk_197DE-Map_Obj3E
word_19742:	dc.w 7			; DATA XREF: ROM:Map_Obj3Eo
		dc.w $E00C,$2000,$2000,$FFF0; 0
		dc.w $E80D,$2004,$2002,$FFE0; 4
		dc.w $E80D,$200C,$2006,	   0; 8
		dc.w $F80E,$2014,$200A,$FFE0; 12
		dc.w $F80E,$2020,$2010,	   0; 16
		dc.w $100D,$202C,$2016,$FFE0; 20
		dc.w $100D,$2034,$201A,	   0; 24
word_1977C:	dc.w 1			; DATA XREF: ROM:00019736o
		dc.w $F809,  $3C,  $1E,$FFF4; 0
word_19786:	dc.w 6			; DATA XREF: ROM:00019738o
		dc.w	 8,$2042,$2021,$FFE0; 0
		dc.w  $80C,$2045,$2022,$FFE0; 4
		dc.w	 4,$2049,$2024,	 $10; 8
		dc.w  $80C,$204B,$2025,	   0; 12
		dc.w $100D,$202C,$2016,$FFE0; 16
		dc.w $100D,$2034,$201A,	   0; 20
word_197B8:	dc.w 1			; DATA XREF: ROM:0001973Ao
		dc.w $F809,  $4F,  $27,$FFF4; 0
word_197C2:	dc.w 2			; DATA XREF: ROM:0001973Co
		dc.w $E80E,$2055,$202A,$FFF0; 0
		dc.w	$E,$2061,$2030,$FFF0; 4
word_197D4:	dc.w 1			; DATA XREF: ROM:0001973Eo
		dc.w $F007,$206D,$2036,$FFF8; 0
unk_197DE:	dc.b   0		; DATA XREF: ROM:00019740o
		dc.b   0
; ===========================================================================
j_Adjust2PArtPointer_6:
		jmp	Adjust2PArtPointer
; ===========================================================================