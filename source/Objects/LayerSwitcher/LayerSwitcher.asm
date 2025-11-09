;----------------------------------------------------
; Collision index switcher (in loops)
; or Path Swappers, whatever ya wanna call it
; Layer Switchers? ....aaaaaAAAAAAAAA
Obj03_Length	=	$32
Obj03_Touched	=	$30
;----------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj03_Index(pc,d0.w),d1
		jsr	Obj03_Index(pc,d1.w)
		tst.w	(Debug_mode_flag).w
		beq.w	MarkObjGone2
		jmp	(MarkObjGone).l
; ===========================================================================
Obj03_Index:	dc.w Obj03_Init-Obj03_Index 
		dc.w Obj03_Vertical-Obj03_Index
		dc.w Obj03_Horizontal-Obj03_Index
; ===========================================================================

Obj03_Init:				; DATA XREF: ROM:Obj03_Indexo
		addq.b	#2,routine(a0)
		move.l	#Map_LayerSwitcher,mappings(a0)
		move.w	#$26BC+10,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#5,priority(a0)
		move.b	subtype(a0),d0
		btst	#2,d0
		beq.s	@vertical_Sprite
		; Vertical (tall) Pathswapper
		addq.b	#2,routine(a0)
		andi.w	#7,d0
		move.b	d0,mapping_frame(a0)
		andi.w	#3,d0
		add.w	d0,d0
		move.w	@Length(pc,d0.w),Obj03_Length(a0)
		bra.w	Obj03_Horizontal
; ===========================================================================
	@Length:	dc.w	64/2	; half chunk
			dc.w	128/2	; chunk
			dc.w	256/2	; two chunk
			dc.w	512/2	; oh boy he large
; ===========================================================================
	@vertical_Sprite:
		andi.w	#3,d0
		move.b	d0,mapping_frame(a0)
		add.w	d0,d0
		move.w	@Length(pc,d0.w),Obj03_Length(a0)

Obj03_Vertical:	
		tst.w	(Debug_placement_mode).w
		bne.w	Obj03_Vertical_ShiftTouchedValues
		move.w	Obj03_Touched(a0),d5

		move.w	x_pos(a0),d0
		move.w	d0,d1
		subq.w	#8,d0
		addq.w	#8,d1	; that Janky 16px hitbox tho

		move.w	y_pos(a0),d2
		move.w	d2,d3
		move.w	Obj03_Length(a0),d4
		sub.w	d4,d2
		add.w	d4,d3
		lea	(Obj03_PlayerRAM).l,a2
		moveq	#8-1,d6		; WHYYY????

	@CheckNextObject:
		move.l	(a2)+,d4
		beq.w	@ShiftTouchedValues	; ignore if blank
		movea.l	d4,a1
		move.w	x_pos(a1),d4
		cmp.w	d0,d4		; left
		blo.w	@NotTouched
		cmp.w	d1,d4		; right
		bhs.w	@NotTouched
		move.w	y_pos(a1),d4
		cmp.w	d2,d4		; top
		blo.w	@NotTouched
		cmp.w	d3,d4		; bottom
		bhs.w	@NotTouched
		ori.w	#$8000,d5	; Player has touched pathswapper
		bra.w	@ShiftTouchedValues
; ---------------------------------------------------------------------------

	@NotTouched:	
		tst.w	d5
		bpl.w	@ShiftTouchedValues
		swap	d0	; store player's X position (???)
		move.b	subtype(a0),d0
		bpl.s	@NoFloorCheck
		btst	#PlayerStatusBitAir,status(a1)
		bne.s	@NotOnGround
	@NoFloorCheck:	
		move.w	x_pos(a1),d4
		cmp.w	x_pos(a0),d4
		bcs.s	@ObjectOnTheLeft
		move.b	#$C,top_solid_bit(a1)	; Path 1
		move.b	#$D,lrb_solid_bit(a1)
		btst	#3,d0		
		beq.s	@RightSideTriggersPath1
		move.b	#$E,top_solid_bit(a1)	; Right side triggers path 2
		move.b	#$F,lrb_solid_bit(a1)

	@RightSideTriggersPath1:	
		bclr	#7,art_tile(a1)
		btst	#5,d0
		beq.s	@DebugPlaySound		; Right side sets priority
		bset	#7,art_tile(a1)
		bra.s	@DebugPlaySound
; ---------------------------------------------------------------------------

	@ObjectOnTheLeft:	
		move.b	#$C,top_solid_bit(a1)	; Path 1
		move.b	#$D,lrb_solid_bit(a1)
		btst	#4,d0		
		beq.s	@LeftSideTriggersPath1
		move.b	#$E,top_solid_bit(a1)	; Left side triggers path 2
		move.b	#$F,lrb_solid_bit(a1)

	@LeftSideTriggersPath1:	
		bclr	#7,art_tile(a1)
		btst	#6,d0
		beq.s	@DebugPlaySound		; Left side sets priority
		bset	#7,art_tile(a1)

	@DebugPlaySound:	
		tst.w	(Debug_mode_flag).w
		beq.s	@NotOnGround
		move.w	#$A1,d0	; '¡'
		jsr	(PlaySound_Special).l

	@NotOnGround:	
		swap	d0		; get back object's position for no reason
		andi.w	#$7FFF,d5

	@ShiftTouchedValues:	
		add.l	d5,d5		; shift to the left by 1
		dbf	d6,@CheckNextObject
		swap	d5
		move.b	d5,Obj03_Touched(a0)

Obj03_Vertical_ShiftTouchedValues:				; CODE XREF: ROM:00013EB8j
		rts
; ===========================================================================

Obj03_Horizontal:				; CODE XREF: ROM:00013E98j
					; DATA XREF: ROM:00013E4Co
		tst.w	(Debug_placement_mode).w
		bne.w	Obj03_Horizontal_ShiftTouchedValues
		move.w	Obj03_Touched(a0),d5
		move.w	x_pos(a0),d0
		move.w	d0,d1
		move.w	Obj03_Length(a0),d4
		sub.w	d4,d0
		add.w	d4,d1
		move.w	y_pos(a0),d2
		move.w	d2,d3
		subq.w	#8,d2
		addq.w	#8,d3
		lea	(Obj03_PlayerRAM).l,a2
		moveq	#8-1,d6

loc_13FE2:	
		move.l	(a2)+,d4	
		beq.w	loc_140AA	; branch if zero (why even have em then???)
		movea.l	d4,a1
		move.w	x_pos(a1),d4
		cmp.w	d0,d4
		bcs.w	loc_14012
		cmp.w	d1,d4
		bcc.w	loc_14012
		move.w	y_pos(a1),d4
		cmp.w	d2,d4
		bcs.w	loc_14012
		cmp.w	d3,d4
		bcc.w	loc_14012
		ori.w	#$8000,d5
		bra.w	loc_140AA
; ---------------------------------------------------------------------------

loc_14012:				; CODE XREF: ROM:00013FF0j
					; ROM:00013FF6j ...
		tst.w	d5
		bpl.w	loc_140AA
		swap	d0
		move.b	subtype(a0),d0
		bpl.s	loc_14028
		btst	#PlayerStatusBitAir,status(a1)
		bne.s	loc_140A4

loc_14028:				; CODE XREF: ROM:0001401Ej
		move.w	y_pos(a1),d4
		cmp.w	y_pos(a0),d4
		bcs.s	loc_14064
		move.b	#$C,top_solid_bit(a1)
		move.b	#$D,lrb_solid_bit(a1)
		btst	#3,d0
		beq.s	loc_14050
		move.b	#$E,top_solid_bit(a1)
		move.b	#$F,lrb_solid_bit(a1)

loc_14050:				; CODE XREF: ROM:00014042j
		bclr	#7,art_tile(a1)
		btst	#5,d0
		beq.s	loc_14094
		bset	#7,art_tile(a1)
		bra.s	loc_14094
; ---------------------------------------------------------------------------

loc_14064:				; CODE XREF: ROM:00014030j
		move.b	#$C,top_solid_bit(a1)
		move.b	#$D,lrb_solid_bit(a1)
		btst	#4,d0
		beq.s	loc_14082
		move.b	#$E,top_solid_bit(a1)
		move.b	#$F,lrb_solid_bit(a1)

loc_14082:				; CODE XREF: ROM:00014074j
		bclr	#7,art_tile(a1)
		btst	#6,d0
		beq.s	loc_14094
		bset	#7,art_tile(a1)

loc_14094:				; CODE XREF: ROM:0001405Aj
					; ROM:00014062j ...
		tst.w	(Debug_mode_flag).w
		beq.s	loc_140A4
		move.w	#$A1,d0	; '¡'
		jsr	(PlaySound_Special).l

loc_140A4:				; CODE XREF: ROM:00014026j
					; ROM:00014098j
		swap	d0
		andi.w	#$7FFF,d5

loc_140AA:				; CODE XREF: ROM:00013FE4j
					; ROM:0001400Ej ...
		add.l	d5,d5
		dbf	d6,loc_13FE2
		swap	d5
		move.b	d5,Obj03_Touched(a0)

Obj03_Horizontal_ShiftTouchedValues:				; CODE XREF: ROM:00013FBAj
		rts
; ===========================================================================
Obj03_PlayerRAM:	
		dc.l MainCharacter
		dc.l Sidekick
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
		dc.l 0
; ===========================================================================