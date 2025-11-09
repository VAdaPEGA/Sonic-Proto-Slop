; ===========================================================================
; SCORE, TIME, RINGS
; ---------------------------------------------------------------------------
		tst.b	routine(a0)
		beq.s	@Init

		bsr	DisplaySprite
		tst.w	(Ring_count).w
		beq.s	@NoRings
		moveq	#0,d0
		btst	#3,(Level_Counter+1).w
		bne.s	@UpdateFrame
		cmpi.b	#9,(Timer_minute).w
		bne.s	@UpdateFrame
		addq.w	#2,d0
	@UpdateFrame:
		move.b	d0,mapping_frame(a0)
		rts
; ---------------------------------------------------------------------------
	@NoRings:
		moveq	#0,d0
		btst	#3,(Level_Counter+1).w
		bne.s	@UpdateFrame2
		addq.w	#1,d0
		cmpi.b	#9,(Timer_minute).w
		bne.s	@UpdateFrame2
		addq.w	#2,d0
	@UpdateFrame2:
		move.b	d0,mapping_frame(a0)
		rts
; ===========================================================================
	@Init:
		st	routine(a0)
		move.w	#$90,x_pixel(a0)
		move.w	#$108,y_pixel(a0)
		move.l	#Map_HUD,mappings(a0)
		move.w	#$6CA,art_tile(a0)
		bra	Adjust2PArtPointer
