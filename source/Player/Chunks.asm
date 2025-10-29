; ---------------------------------------------------------------------------
; Chunk related effects, such as S tunnels, Corkscrews and more!
; ---------------------------------------------------------------------------
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		add.w	d0,d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
	IndexStart
	GenerateLocalIndex	2, DoNothing,	; GHZ
	GenerateLocalIndex	2, DoNothing,	; CPZ
	GenerateLocalIndex	2, DoNothing,	; MMZ
	GenerateLocalIndex	2, EHZ,		; EHZ
	GenerateLocalIndex	2, DoNothing,	; HPZ
	GenerateLocalIndex	2, IcePhysics,	; HTZ
	GenerateLocalIndex	2, DoNothing,	; CNZ
; ===========================================================================
	if	(c=ZoneCount*2)
	else
c	=	c/2	; warning for if someone forgets to add an entry
		inform	1,"Chunk Effects don't match Zone Count (\#ZoneCount\ - \#c\)"
	endif
; ===========================================================================
	@GetChunk:	; Fetch chunk player is currently on
		move.w	y_pos(a0),d0
		add.w	d0,d0		; y*2
		andi.w	#$F00,d0	; Masked, only upper nibble matters

		move.w	x_pos(a0),d1
		lsr.w	#7,d1		; Divide X position by 128
		andi.w	#$7F,d1		; mask

		add.w	d1,d0		; add both numbers
		lea	(Level_Layout).w,a1
		move.b	(a1,d0.w),d1	; d1 is	the Chunk Player is currently on

		; debug, check if chunk fetching is correct
;		move.w	d1,(Ring_count).w
;		st	(Update_HUD_rings).w
		rts
; ===========================================================================
	@EHZ:
	bsr.s	@GetChunk
	sub.b	#8,d1		; S Tube Chunks
	bcs.w	loc_1023A	; Force Player to roll ala S1 (a.k.a wrong)
		moveq	#StatusBitP1Stand,d6
		cmpi.b	#11,d1		; Corkscrew Chunks
		bcs	PlayerQuirkyCorkscrew
			bclr	#PlayerStatusBitChunk,status(a0)	; Get off the Corkscrew
			beq.s	@DoNothing
				move.b	#4,flip_speed(a0)
				bclr	#PlayerStatusBitOnObject,status(a0)
				tst.b	angle(a0)
				bne.s	@DoNothing
					clr.b	flip_angle(a0)

		@DoNothing:
			rts
; ===========================================================================
@IcePhysics:
	bsr	@GetChunk
	cmpi.b	#$0F,d1		; is chunk 0F?
	bhi.s	@no_ice		; if not, branch
		move.b	#1,(0).w
		rts
	@no_ice:
	move.b	#0,(0).w
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Getting on the Corkxcrew / Spiral / Twisting Pathway, whatever ya call it
; ---------------------------------------------------------------------------
PlayerQuirkyCorkscrew:
	btst	#PlayerStatusBitChunk,status(a0)	; is player in corkscrew?
	bne.s	@OnCorkscrew		; if yes, branch
		cmpi.b	#5,d1	; can you enter this corkscrew chunk?
		bcc.s	@DoNothing
			btst	#PlayerStatusBitAir,status(a0)
			bne.s	@DoNothing
				; attempt to get player on Corkscrew
				move.w	x_pos(a0),d0
				andi.w	#128-1,d0	; mask
				tst.w	x_vel(a0)	; check speed
				bpl.s	@EnterFromLeft
					sub.w	#128-16,d0
				@EnterFromLeft:
				cmpi.w	#16,d0
				bgt.s	@DoNothing
					; add Y check here if something goes wrong, wait for Jeff to complain
					bset	#PlayerStatusBitChunk,status(a0)	; Enter Corkscrew
					bset	#PlayerStatusBitOnObject,status(a0)
				@DoNothing:
				rts
; ===========================================================================
	@GetOffCorkscrew:
		bclr	#PlayerStatusBitChunk,status(a0)	; Exit Corkscrew
		bclr	#PlayerStatusBitOnObject,status(a0)
		move.b	#0,flips_remaining(a0)
		move.b	#4,flip_speed(a0)
		and.b	#-4,flip_angle(a0)
		rts
; ===========================================================================
@OnCorkscrew:
	move.w	ground_speed(a0),d0	; get ground speed
	bpl.s	@PositiveSpeed
		neg.w	d0	; remove negative sign cause we don't need it
	@PositiveSpeed:
	cmpi.w	#$480,d0		; is player moving fast enough?
	bcs.s	@GetOffCorkscrew	; if not, branch
		tst.b	jumping(a0)		; Has player jumped?
		bne.s	@GetOffCorkscrew	; if so, branch
			add.w	d1,d1
			add.w	d1,d1

			lea	QuirkyCorkscrewData,a1
			add.w	QuirkyCorkscrewTable(pc,d1.w),a1	; get pointer to current chunk position data

			move.w	y_pos(a0),d0
			;move.w	d0,d4
			andi.w	#$F80,d0	; Get Current Chunk position

			move.w	x_pos(a0),d2
			and.w	#128-1,d2	; X position relative to chunk
			move.w	d2,d3
			move.b	(a1,d2.w),d2
			ext.w	d2
			add.w	d2,d0
			move.w	d0,y_pos(a0)	; set Y position
			moveq	#64+19,d0
			sub.b	y_radius(a0),d0
			add.w	d0,y_pos(a0)

			lea	QuirkyCorkscrewData,a1
			add.w	QuirkyCorkscrewTable+2(pc,d1.w),a1	; get pointer to current chunk Flipma Data

			lsr.w	#4,d3		; only 4 options
			bclr	#0,d3		; no uneven bytes
			move.b	(a1,d3.w),flip_angle(a0)
			move.b	(1,a1,d3.w),angle(a0)


	;		sub.w	y_pos(a0),d4
	;		neg.w	d4
	;		asl.w	#3,d4
	;		tst.w	ground_speed(a0)
	;		bmi.s	@GoingLeft
	;			add.w	d4,ground_speed(a0)
			@DoNothing2:
		rts
	;		@GoingLeft:
	;			sub.w	d4,ground_speed(a0)
	;			rts
; End of function sub_149BC

; ===========================================================================
	IndexStart	QuirkyCorkscrewTable
	dc.w QuirkyCorkscrew_Chunk1_Pos-QuirkyCorkscrewData,	QuirkyCorkscrew_Chunk1_Flipma-QuirkyCorkscrewData
	dc.w QuirkyCorkscrew_Chunk1_Pos-QuirkyCorkscrewData,	QuirkyCorkscrew_Chunk1_Flipma-QuirkyCorkscrewData
	dc.w QuirkyCorkscrew_Chunk1_Pos-QuirkyCorkscrewData,	QuirkyCorkscrew_Chunk1_Flipma-QuirkyCorkscrewData

	dc.w QuirkyCorkscrew_Chunk3_1_Pos-QuirkyCorkscrewData,	QuirkyCorkscrew_Chunk3_Flipma-QuirkyCorkscrewData
	dc.w QuirkyCorkscrew_Chunk3_1_Pos-QuirkyCorkscrewData,	QuirkyCorkscrew_Chunk3_Flipma-QuirkyCorkscrewData

	dc.w QuirkyCorkscrew_Chunk1_1_Pos-QuirkyCorkscrewData,	QuirkyCorkscrew_Chunk1_Flipma-QuirkyCorkscrewData
	dc.w QuirkyCorkscrew_Chunk2_Pos-QuirkyCorkscrewData,	QuirkyCorkscrew_Chunk2_Flipma-QuirkyCorkscrewData
	dc.w QuirkyCorkscrew_Chunk3_Pos-QuirkyCorkscrewData,	QuirkyCorkscrew_Chunk3_Flipma-QuirkyCorkscrewData

	dc.w QuirkyCorkscrew_DDiag_Pos-QuirkyCorkscrewData,	QuirkyCorkscrew_DDiag_Flipma-QuirkyCorkscrewData
	dc.w QuirkyCorkscrew_DDiag_1_Pos-QuirkyCorkscrewData,	QuirkyCorkscrew_DDiag_Flipma-QuirkyCorkscrewData
	dc.w QuirkyCorkscrew_DDiag_1_Pos-QuirkyCorkscrewData,	QuirkyCorkscrew_DDiag_Flipma-QuirkyCorkscrewData