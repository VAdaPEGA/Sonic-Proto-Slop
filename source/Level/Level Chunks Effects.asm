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
	GenerateLocalIndex	DoNothing	; GHZ
	GenerateLocalIndex	DoNothing, 1	; CPZ
	GenerateLocalIndex	DoNothing, 1	; MMZ
	GenerateLocalIndex	EHZ		; EHZ
	GenerateLocalIndex	DoNothing, 1	; HPZ
	GenerateLocalIndex	IcePhysics	; HTZ
	GenerateLocalIndex	DoNothing, 1	; CNZ
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

			lsr.w	#3,d3		; only 8 options
			bclr	#0,d3		; no uneven bytes
			move.b	(a1,d3.w),flip_angle(a0)
			move.b	(1,a1,d3.w),angle(a0)

			@DoNothing2:
		rts

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

; ===========================================================================
S1_LZWindTunnels:			; leftover from	Sonic 1's LZ
		tst.w	(Debug_placement_mode).w
		bne.w	locret_43A2
		lea	(S1LZWind_Data).l,a2
		moveq	#0,d0
		move.b	(Current_Act).w,d0
		lsl.w	#3,d0
		adda.w	d0,a2
		moveq	#0,d1
		tst.b	(Current_Act).w
		bne.s	loc_42EA
		moveq	#1,d1
		subq.w	#8,a2

loc_42EA:				; CODE XREF: ROM:000042E4j
		lea	(MainCharacter).w,a1

loc_42EE:				; CODE XREF: ROM:0000438Ej
		move.w	x_pos(a1),d0
		cmp.w	(a2),d0
		bcs.w	loc_438C
		cmp.w	4(a2),d0
		bcc.w	loc_438C
		move.w	y_pos(a1),d2
		cmp.w	2(a2),d2
		bcs.w	loc_438C
		cmp.w	6(a2),d2
		bcc.s	loc_438C
		move.b	($FFFFFE0F).w,d0
		andi.b	#$3F,d0	; '?'
		bne.s	loc_4326
		move.w	#$D0,d0	; 'Ð'
		jsr	(PlaySound_Special).l

loc_4326:				; CODE XREF: ROM:0000431Aj
		tst.b	($FFFFF7C9).w
		bne.w	locret_43A2
		cmpi.b	#4,routine(a1)
		bcc.s	loc_439E
		move.b	#1,($FFFFF7C7).w
		subi.w	#$80,d0	; '€'
		cmp.w	(a2),d0
		bcc.s	loc_4354
		moveq	#2,d0
		cmpi.b	#1,(Current_Act).w
		bne.s	loc_4350
		neg.w	d0

loc_4350:				; CODE XREF: ROM:0000434Cj
		add.w	d0,y_pos(a1)

loc_4354:				; CODE XREF: ROM:00004342j
		addi.w	#4,x_pos(a1)
		move.w	#$400,x_vel(a1)
		move.w	#0,y_vel(a1)
		move.b	#$F,anim(a1)
		bset	#1,status(a1)
		btst	#0,($FFFFF604).w
		beq.s	loc_437E
		subq.w	#1,y_pos(a1)

loc_437E:				; CODE XREF: ROM:00004378j
		btst	#1,($FFFFF604).w
		beq.s	locret_438A
		addq.w	#1,y_pos(a1)

locret_438A:				; CODE XREF: ROM:00004384j
		rts
; ===========================================================================

loc_438C:				; CODE XREF: ROM:000042F4j
					; ROM:000042FCj ...
		addq.w	#8,a2
		dbf	d1,loc_42EE
		tst.b	($FFFFF7C7).w
		beq.s	locret_43A2
		move.b	#0,anim(a1)

loc_439E:				; CODE XREF: ROM:00004334j
		clr.b	($FFFFF7C7).w

locret_43A2:				; CODE XREF: ROM:000042CAj
					; ROM:0000432Aj ...
		rts
; ===========================================================================
		dc.w  $A80, $300, $C10,	$380; 0
S1LZWind_Data:	dc.w  $F80, $100,$1410,	$180, $460, $400, $710,	$480, $A20, $600,$1610,	$6E0, $C80, $600,$13D0,	$680; 0
					; DATA XREF: ROM:000042CEo
; ===========================================================================

S1_LZWaterSlides:
		lea	(MainCharacter).w,a1
		btst	#1,status(a1)
		bne.s	loc_4400
		move.w	y_pos(a1),d0
		andi.w	#$700,d0
		move.b	x_pos(a1),d1

loc_43E4:
		andi.w	#$7F,d1	; ''
		add.w	d1,d0
		lea	(Level_Layout).w,a2
		move.b	(a2,d0.w),d0
		lea	byte_4465(pc),a2
		moveq	#6,d1

loc_43F8:				; CODE XREF: ROM:000043FAj
		cmp.b	-(a2),d0
		dbeq	d1,loc_43F8
		beq.s	loc_4412

loc_4400:				; CODE XREF: ROM:000043D6j
		tst.b	($FFFFF7CA).w
		beq.s	locret_4410
		move.w	#5,move_lock(a1)
		clr.b	($FFFFF7CA).w

locret_4410:				; CODE XREF: ROM:00004404j
		rts
; ===========================================================================

loc_4412:				; CODE XREF: ROM:000043FEj
		cmpi.w	#3,d1
		bcc.s	loc_441A
		nop

loc_441A:				; CODE XREF: ROM:00004416j
		bclr	#0,status(a1)
		move.b	byte_4456(pc,d1.w),d0
		move.b	d0,ground_speed(a1)
		bpl.s	loc_4430
		bset	#0,status(a1)

loc_4430:				; CODE XREF: ROM:00004428j
		clr.b	$15(a1)
		move.b	#$1B,anim(a1)
		move.b	#1,($FFFFF7CA).w
		move.b	($FFFFFE0F).w,d0
		andi.b	#$1F,d0
		bne.s	locret_4454
		move.w	#$D0,d0	; 'Ð'
		jsr	(PlaySound_Special).l

locret_4454:				; CODE XREF: ROM:00004448j
		rts
; ===========================================================================
byte_4456:	dc.b  $A,$F5, $A,$F6,$F5,$F4, $B,  0,  2,  7,  3,$4C,$4B,  8,  4; 0
byte_4465:	dc.b 0			; DATA XREF: ROM:000043F2t
; ===========================================================================

