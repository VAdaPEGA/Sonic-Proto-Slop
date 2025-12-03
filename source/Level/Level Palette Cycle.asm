PalCycle_Load:
		moveq	#0,d2
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		add.w	d0,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex	 PalCycle_GHZ
	GenerateIndex	 PalCycle_CPZ
	GenerateIndex	 PalCycle_None
	GenerateIndex	 PalCycle_EHZ
	GenerateIndex	 PalCycle_HPZ
	GenerateIndex	 PalCycle_HTZ
	GenerateIndex	 PalCycle_CNZ
; ===========================================================================
PalCycle_GHZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	PalCycle_None
		lea	(Pal_GHZCyc).l,a0
		move.w	#6-1,(PalCycle_Timer).w
		move.w	(PalCycle_Frame).w,d0
		addq.w	#1,(PalCycle_Frame).w
		andi.w	#3,d0
		lsl.w	#3,d0
		lea	(8*2+Normal_palette_line3).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)
PalCycle_None:
	rts
; ===========================================================================
PalCycle_CPZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	@DoNothing
		move.w	#8-1,(PalCycle_Timer).w
		lea	(Pal_CPZCyc1).l,a0
		move.w	(PalCycle_Frame).w,d0
		addq.w	#6,(PalCycle_Frame).w
		cmpi.w	#$36,(PalCycle_Frame).w
		bcs.s	@loc_1ECC
			move.w	#0,(PalCycle_Frame).w
		@loc_1ECC:
		lea	(12*2+Normal_palette_line4).w,a1
		move.l	(a0,d0.w),(a1)+
		move.w	4(a0,d0.w),(a1)

		lea	(Pal_CPZCyc2).l,a0
		move.w	(PalCycle_Frame2).w,d0
		addq.w	#2,(PalCycle_Frame2).w
		cmpi.w	#$2A,(PalCycle_Frame2).w
		bcs.s	@loc_1EF4
			move.w	#0,(PalCycle_Frame2).w
		@loc_1EF4:
		move.w	(a0,d0.w),(15*2+Normal_palette_line4).w

		lea	(Pal_CPZCyc3).l,a0
		move.w	(PalCycle_Frame3).w,d0
		addq.w	#2,(PalCycle_Frame3).w
		andi.w	#$1E,(PalCycle_Frame3).w
		move.w	(a0,d0.w),(15*2+Normal_palette_line3).w
	@DoNothing:
	rts
; ===========================================================================
PalCycle_HPZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	@DoNothing
		move.w	#5-1,(PalCycle_Timer).w
		move.w	(PalCycle_Frame).w,d0
		subq.w	#2,(PalCycle_Frame).w
		bcc.s	@loc_1F38
			move.w	#6,(PalCycle_Frame).w
	@loc_1F38:
		lea	(Pal_HPZCyc1).l,a0
		lea	(9*2+Normal_palette_line4).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)

		lea	(Pal_HPZCyc2).l,a0
		lea	(9*2+Water_palette_line4).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)

	@DoNothing:
		rts
; ===========================================================================
PalCycle_EHZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	@DoNothing
		move.w	#8-1,(PalCycle_Timer).w
		lea	(Pal_EHZCyc).l,a0
		move.w	(PalCycle_Frame).w,d0
		addq.w	#1,(PalCycle_Frame).w
		andi.w	#3,d0
		lsl.w	#3,d0
		add.w	d0,a0	; DANGER : may mess up if the palette cycle data happens to surpass the $10000 threshhold
		lea	(1*2+Normal_palette_line2),a1 ; first colour of second line
		move.l	(a0)+,(a1)+
		move.l	(a0),(a1)
	@DoNothing:
	rts
; ===========================================================================
PalCycle_HTZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	@DoNothing
		lea	(Pal_HTZCyc1).l,a0
		move.w	#0,(PalCycle_Timer).w
		move.w	(PalCycle_Frame).w,d0
		addq.w	#1,(PalCycle_Frame).w
		andi.w	#$F,d0
		;move.b	Pal_HTZCyc2(pc,d0.w),($FFFFF635).w
		lsl.w	#3,d0
		add.w	d0,a0	; DANGER : may mess up if the palette cycle data happens to surpass the $10000 threshhold
		lea	(1*2+Normal_palette_line2).w,a1
		move.l	(a0)+,(a1)+
		move.l	(a0),(a1)
	@DoNothing:
		rts
; ===========================================================================
PalCycle_CNZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	@DoNothing
		move.w	#4-1,(PalCycle_Timer).w
		nop	; placeholder!
	@DoNothing:
	rts