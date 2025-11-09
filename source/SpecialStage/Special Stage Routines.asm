S1SS_ShowLayout:	
		bsr.w	SS_AniWallsRings
		bsr.w	SS_AniItems
		move.w	d5,-(sp)		; Store Sprite Count
		lea	($FFFF8000).w,a1
		move.b	(Special_Stage_Angle).w,d0
		andi.b	#SSAngleModifier,d0
		jsr	(CalcSine).l
		move.w	d0,d4
		move.w	d1,d5
		muls.w	#24,d4
		muls.w	#24,d5
		moveq	#0,d2
		move.w	(Camera_X_pos).w,d2
		divu.w	#24,d2
		swap	d2
		neg.w	d2
		subi.w	#180,d2
		moveq	#0,d3
		move.w	(Camera_Y_pos).w,d3
		divu.w	#24,d3
		swap	d3
		neg.w	d3
		subi.w	#180,d3
		move.w	#16-1,d7

loc_19BD0:		
		movem.w	d0-d2,-(sp)
		movem.w	d0-d1,-(sp)
		neg.w	d0
		muls.w	d2,d1
		muls.w	d3,d1
		move.l	d0,d6
		add.l	d1,d6
		movem.w	(sp)+,d0-d1
		muls.w	d2,d0
		muls.w	d3,d1
		add.l	d0,d1
		move.l	d6,d2
		move.w	#16-1,d6

loc_19BF2:		
		move.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		move.l	d1,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		add.l	d5,d2
		add.l	d4,d1
		dbf	d6,loc_19BF2
		movem.w	(sp)+,d0-d2
		addi.w	#24,d3
		dbf	d7,loc_19BD0

		move.w	(sp)+,d5
		lea	(RAM_Start).l,a0
		moveq	#0,d0
		move.w	(Camera_Y_pos).w,d0
		divu.w	#24,d0

		lsl.w	#7,d0
		;mulu.w	#$80,d0	; ok but why tho

		adda.l	d0,a0
		moveq	#0,d0
		move.w	(Camera_X_pos).w,d0
		divu.w	#24,d0
		adda.w	d0,a0
		lea	($FFFF8000).w,a4
		move.w	#16-1,d7
loc_19C3E:	
		move.w	#16-1,d6
loc_19C42:	
		moveq	#0,d0
		move.b	(a0)+,d0
		beq.s	@DontDrawSprite		; Don't draw if it's blank

		cmpi.b	#SSBlockID_Last,d0	; Is this past the last Block Type?
		bhi.s	@DontDrawSprite		; If so, branch

		move.w	(a4),d3
		addi.w	#320-32,d3
		cmpi.w	#$70,d3
		bcs.s	@DontDrawSprite
		cmpi.w	#$1D0,d3
		bcc.s	@DontDrawSprite
		move.w	2(a4),d2
		addi.w	#$F0,d2
		cmpi.w	#$70,d2
		bcs.s	@DontDrawSprite
		cmpi.w	#$170,d2
		bcc.s	@DontDrawSprite
		lea	($FFFF4000).l,a5	; Get mapping data
		lsl.w	#3,d0
		lea	(a5,d0.w),a5
		movea.l	(a5)+,a1
		move.w	(a5)+,d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		movea.w	(a5)+,a3
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	@DontDrawSprite
		cmpi.b	#80,d5
		bhs.s	@DontDrawSprite
		jsr	(DrawSprite_Loop).l
	@DontDrawSprite:
		addq.w	#4,a4
		dbf	d6,loc_19C42
		lea	$70(a0),a0
		dbf	d7,loc_19C3E
		move.b	d5,(Sprite_count).w
		cmpi.b	#80,d5	; check for sprite limit
		beq.s	loc_19CBA
		move.l	#0,(a2)
		rts
	loc_19CBA:	
		move.b	#0,-5(a2)
		rts
; End of function S1SS_ShowLayout


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


SS_AniWallsRings:	
		lea	($FFFF4000+$C).l,a1
		moveq	#0,d0
		move.b	(Special_Stage_Angle).w,d0
		lsr.b	#2,d0
		andi.w	#$F,d0
		moveq	#(9*4)-1,d1	; Walls
	loc_19CD6:	
		move.w	d0,(a1)		; Update Wall Frame for angle
		addq.w	#8,a1
		dbf	d1,loc_19CD6

		lea	($FFFF4000+5).l,a1	; Points to animation frame

		subq.b	#1,(Rings_anim_counter).w
		bpl.s	loc_19CFA
		move.b	#8-1,(Rings_anim_counter).w
		addq.b	#1,(Rings_anim_frame).w
		andi.b	#3,(Rings_anim_frame).w
		addq.b	#1,($FFFFFEC5).w
		andi.b	#1,($FFFFFEC5).w
		subq.b	#1,(Logspike_anim_frame).w
		andi.b	#7,(Logspike_anim_frame).w
	loc_19CFA:	
		move.b	(Rings_anim_frame).w,SSBlockID_Ring*8(a1)

		move.b	($FFFFFEC5).w,d0
		move.b	d0,SSBlockID_Goal*8(a1)
		move.b	d0,SSBlockID_Peppermint*8(a1)
		move.b	d0,SSBlockID_Up*8(a1)
		move.b	d0,SSBlockID_Down*8(a1)
		move.b	d0,SSBlockID_Emerald*8(a1)
		move.b	d0,(SSBlockID_Emerald+1)*8(a1)
		move.b	d0,(SSBlockID_Emerald+2)*8(a1)
		move.b	d0,(SSBlockID_Emerald+3)*8(a1)
		move.b	d0,(SSBlockID_Emerald+4)*8(a1)
		move.b	d0,(SSBlockID_Emerald+5)*8(a1)

		subq.b	#1,(Ring_spill_anim_counter).w
		bpl.s	loc_19D58
		move.b	#5-1,(Ring_spill_anim_counter).w
		addq.b	#1,(Ring_spill_anim_frame).w
		andi.b	#3,(Ring_spill_anim_frame).w

	loc_19D58:				
		move.b	(Ring_spill_anim_frame).w,d0
		move.b	d0,SSBlockID_Glass*8(a1)
		move.b	d0,(SSBlockID_Glass+1)*8(a1)
		move.b	d0,(SSBlockID_Glass+2)*8(a1)
		move.b	d0,(SSBlockID_Glass+3)*8(a1)

		lea	($FFFF4000+(8*2)+4+2).l,a1
		lea	(S1SS_WaRiVramSet).l,a0
		moveq	#0,d0
		move.b	(Logspike_anim_frame).w,d0
		add.w	d0,d0
		lea	(a0,d0.w),a0

		move.w	(a0),(a1)
		move.w	02(a0),8(a1)
		move.w	04(a0),$10(a1)
		move.w	06(a0),$18(a1)
		move.w	08(a0),$20(a1)
		move.w	10(a0),$28(a1)
		move.w	12(a0),$30(a1)
		move.w	14(a0),$38(a1)
		adda.w	#$10*2,a0	; Go to the next set
		adda.w	#9*8,a1

		move.w	(a0),(a1)
		move.w	02(a0),8(a1)
		move.w	04(a0),$10(a1)
		move.w	06(a0),$18(a1)
		move.w	08(a0),$20(a1)
		move.w	10(a0),$28(a1)
		move.w	12(a0),$30(a1)
		move.w	14(a0),$38(a1)
		adda.w	#$10*2,a0	; Go to the next set
		adda.w	#9*8,a1

		move.w	(a0),(a1)
		move.w	02(a0),8(a1)
		move.w	04(a0),$10(a1)
		move.w	06(a0),$18(a1)
		move.w	08(a0),$20(a1)
		move.w	10(a0),$28(a1)
		move.w	12(a0),$30(a1)
		move.w	14(a0),$38(a1)
		adda.w	#$10*2,a0	; Go to the next set
		adda.w	#9*8,a1

		move.w	(a0),(a1)
		move.w	02(a0),8(a1)
		move.w	04(a0),$10(a1)
		move.w	06(a0),$18(a1)
		move.w	08(a0),$20(a1)
		move.w	10(a0),$28(a1)
		move.w	12(a0),$30(a1)
		move.w	14(a0),$38(a1)
		adda.w	#$10*2,a0	; Go to the next set
		adda.w	#9*8,a1

		rts
; End of function SS_AniWallsRings

; ===========================================================================
S1SS_WaRiVramSet:
	; Blue		(goes green)
	dc.w	$0142,	$6142,	$0142,	$0142,	$0142,	$0142,	$0142,	$6142
	dc.w	$0142,	$6142,	$0142,	$0142,	$0142,	$0142,	$0142,	$6142
	; Yellow	(goes Blue)
	dc.w	$2142,	$0142,	$2142,	$2142,	$2142,	$2142,	$2142,	$0142
	dc.w	$2142,	$0142,	$2142,	$2142,	$2142,	$2142,	$2142,	$0142
	; Pink		(goes Yellow)
	dc.w	$4142,	$2142,	$4142,	$4142,	$4142,	$4142,	$4142,	$2142
	dc.w	$4142,	$2142,	$4142,	$4142,	$4142,	$4142,	$4142,	$2142
	; Green		(goes Pink)
	dc.w	$6142,	$4142,	$6142,	$6142,	$6142,	$6142,	$6142,	$4142
	dc.w	$6142,	$4142,	$6142,	$6142,	$6142,	$6142,	$6142,	$4142
; ===========================================================================

SS_FindFreeAnimSlot:	; used by the player object to interact with items so they animate
		lea	($FF4400).l,a2	; Anim Slots location in RAM
		move.w	#32-1,d0	; number of slots

	@loop:
		tst.b	(a2)		; check if 0
		beq.s	@DoNothing	; if so, branch and do nothing
		addq.w	#8,a2		; add to a2
		dbf	d0,@loop	; repeat 32 times

@DoNothing:
		rts
; Data Layout:
;		Block ID (1 byte)
;		 (1 byte)
;		 (1 byte)
;		 (1 byte)
;		Block RAM Location (4 bytes)

; ---------------------------------------------------------------------------
; Subroutine to	animate	special	stage items when you touch them
; ---------------------------------------------------------------------------
SS_AniItems:	
		lea	($FF4400).l,a0	; Anim Slots location in RAM
		move.w	#32-1,d7	; number of slots
	@Loop:	
		moveq	#0,d0
		move.b	(a0),d0
		beq.s	@EmptySlop
		lsl.w	#2,d0
		movea.l	@Index-4(pc,d0.w),a1
		jsr	(a1)
	@EmptySlop:	
		addq.w	#8,a0
		dbf	d7,@Loop
		rts
; ===========================================================================
		IndexStart
		dc.l SS_AniRingSparks
		dc.l SS_AniBumper
		dc.l SS_AniRingSparks	; 1Up
		dc.l SS_AniReverse
		dc.l SS_AniEmeraldSparks
		dc.l SS_AniGlassBlock
; ===========================================================================
SS_AniRingSparks:	
		subq.b	#1,2(a0)
		bpl.s	@DoNothing
		move.b	#5,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	@AnimData(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	@DoNothing
		clr.l	(a0)
		clr.l	4(a0)
	@DoNothing:	
		rts
; ===========================================================================
	@AnimData:	dc.b $42,$43,$44,$45,  0,  0; 0
; ===========================================================================
SS_AniBumper:	
		subq.b	#1,2(a0)
		bpl.s	@DoNothing
		move.b	#7,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	@AnimData(pc,d0.w),d0
		bne.s	@loc_19F96
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#$25,(a1)
		rts
	@loc_19F96:
		move.b	d0,(a1)
	@DoNothing:
		rts
; ===========================================================================
	@AnimData:	dc.b $32,$33,$32,$33,  0,  0; 0
; ===========================================================================
SS_AniReverse:	
		subq.b	#1,2(a0)
		bpl.s	@DoNothing
		move.b	#7,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	@AnimData(pc,d0.w),d0
		bne.s	@loc_19FFC
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#$2B,(a1)
		rts
	@loc_19FFC:	
		move.b	d0,(a1)
	@DoNothing:	
		rts
; ===========================================================================
	@AnimData:	dc.b $2B,$31,$2B,$31,  0,  0; 0
; ===========================================================================
SS_AniEmeraldSparks:	
		subq.b	#1,2(a0)
		bpl.s	@DoNothing
		move.b	#5,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	@AnimData(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	@DoNothing
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#4,(MainCharacter+routine).w	; Exit Routine
		move.w	#$A8,d0				; Warp sound
		jsr	(PlaySound_Special).l
	@DoNothing:	
		rts
; ===========================================================================
	@AnimData:	dc.b $46,$47,$48,$49,  0,  0; 0
; ===========================================================================
SS_AniGlassBlock:	
		subq.b	#1,2(a0)
		bpl.s	@DoNothing
		move.b	#1,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	@AnimData(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	@DoNothing
		move.b	4(a0),(a1)
		clr.l	(a0)
		clr.l	4(a0)
	@DoNothing:	
		rts
; ===========================================================================
	@AnimData:	dc.b $4B,$4C,$4D,$4E,$4B,$4C,$4D,$4E, 0,  0
; ===========================================================================
SpecialStage_Data:
c	=	1
	rept	7
	incbin	"SpecialStage/Layout/Start\#c\.bin"
	dc.l	S1SS_\#c
c	=	c+1
	endr


; ===========================================================================

S1SS_Load:	
		cmpi.b	#6,(Emerald_count).w
		blo.s	@NotSS7
		moveq	#7,d0
		bra.s	loc_1A0E8
	@NotSS7:
		moveq	#0,d0
		move.b	($FFFFFE16).w,d0
		addq.b	#1,($FFFFFE16).w
		cmpi.b	#6,($FFFFFE16).w
		bcs.s	loc_1A0C6
		move.b	#0,($FFFFFE16).w
loc_1A0C6:	
		moveq	#0,d1
		move.b	(Emerald_count).w,d1
		subq.b	#1,d1
		bcs.s	loc_1A0E8
		lea	(Got_Emeralds_array).w,a3
loc_1A0DC:	
		cmp.b	(a3,d1.w),d0
		bne.s	loc_1A0E4
		bra.s	S1SS_Load
; ===========================================================================
loc_1A0E4:	
		dbf	d1,loc_1A0DC

loc_1A0E8:	
		lsl.w	#3,d0
		lea	SpecialStage_Data(pc,d0.w),a1	
		move.w	(a1)+,(MainCharacter+x_pos).w	; Start positions
		move.w	(a1)+,(MainCharacter+y_pos).w
		movea.l	(a1),a1				; Layout
		lea	($FFFF4000).l,a1		; Decompression buffer for Special stage
		move.w	#0,d0				; Starting point
		jsr	(EniDec).l			; Decomp that stuff
		lea	(RAM_Start).l,a1		; Start of RAM
		move.w	#$4000/4-1,d0
	@ClearRAM:	
		clr.l	(a1)+
		dbf	d0,@ClearRAM

;	Special Stage format :
; 128 by 128, but only 64x64 is used


		lea	(RAM_Start+32+32*$80).l,a1
		lea	($FFFF4000).l,a0
		moveq	#64-1,d1
	@Loop2:	moveq	#64-1,d2
	@Loop:	
		move.b	(a0)+,(a1)+
		dbf	d2,@Loop
		lea	64(a1),a1
		dbf	d1,@Loop2

		lea	($FFFF4008).l,a1
		lea	(S1SS_MapIndex).l,a0
		move.l	(a0)+,d0
		moveq	#4-1,d7
		@LoopBlocks2:
			move.w	(a0)+,d1
			moveq	#9-1,d6
			@LoopBlocks:
				move.l	d0,(a1)+
				clr.w	(a1)+
				move.w	d1,(a1)+
			dbf	d6,@LoopBlocks
		dbf	d7,@LoopBlocks2

		moveq	#(SSBlockID_Last-9*4)-1,d7
	@LoadMappingData:
		move.l	(a0)+,(a1)+
		move.w	#0,(a1)+
		move.b	-4(a0),-1(a1)
		move.w	(a0)+,(a1)+
		dbf	d7,@LoadMappingData

		lea	($FF4400).l,a1
		move.w	#(32*8)/4-1,d7
	@ClearAnimationSlotRAM:	
		clr.l	(a1)+
		dbf	d7,@ClearAnimationSlotRAM
		rts
; End of function S1SS_Load