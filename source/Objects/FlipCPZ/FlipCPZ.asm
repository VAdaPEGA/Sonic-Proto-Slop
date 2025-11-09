; ===========================================================================
; Some jackass said this was the LZ pole that breaks, I got lied to real hard
; This is CPZ Flipma 
; ---------------------------------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex	2, loc_141C8
	GenerateIndex	2, loc_1421C
	GenerateIndex	2, loc_1422A
; ===========================================================================
loc_141C8:	
		addq.b	#2,routine(a0)
		move.l	#Map_Obj0B,mappings(a0)
		move.w	#$E000,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#4,priority(a0)
		moveq	#0,d0

		move.b	subtype(a0),d0
		andi.w	#$F0,d0
		addi.w	#16,d0
		move.w	d0,d1
		subq.w	#1,d0
		move.w	d0,$30(a0)
		move.w	d0,$32(a0)
		
		moveq	#0,d0
		move.b	subtype(a0),d0
		andi.w	#$F,d0
		addq.w	#1,d0
		lsl.w	#4,d0
		move.b	d0,$36(a0)

loc_1421C:	
		move.b	($FFFFFE0F).w,d0
		add.b	$36(a0),d0
		bne.s	loc_14254
		addq.b	#2,routine(a0)

loc_1422A:	
		subq.w	#1,$30(a0)
		bpl.s	loc_14248
		move.w	#$7F,$30(a0)
		tst.b	anim(a0)
		beq.s	loc_14242
		move.w	$32(a0),$30(a0)

loc_14242:	
		bchg	#0,anim(a0)

loc_14248:	
		lea	(Ani_FlipCPZ).l,a1
		bra	AnimateSprite

loc_14254:	
		tst.b	mapping_frame(a0)
		bne.s	loc_1426E
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#$11,d3
		move.w	x_pos(a0),d4
		bsr.w	sub_F78A
		bra.w	MarkObjGone
; ---------------------------------------------------------------------------
loc_1426E:	
		btst	#3,status(a0)
		beq.s	loc_14286
		lea	(MainCharacter).w,a1
		bclr	#3,status(a1)
		bclr	#3,status(a0)

loc_14286:	
		bra.w	MarkObjGone