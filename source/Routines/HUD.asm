; =============== S U B	R O U T	I N E =======================================

HudUpdate:
		lea	(VDP_data_port).l,a6
		tst.w	(Debug_mode_flag).w
		bne.w	HUD_Debug
		tst.b	(Update_HUD_score).w
		beq.s	loc_1B266
		clr.b	(Update_HUD_score).w
		locVRAMtemp	$DC80		; set VRAM address
		move.l	(Score).w,d1
		bsr.w	HUD_Score

loc_1B266:
		tst.b	(Update_HUD_rings).w
		beq.s	loc_1B286
		bpl.s	loc_1B272
		bsr.w	HUD_LoadZero

loc_1B272:
		clr.b	(Update_HUD_rings).w
		locVRAMtemp	$DF40		; set VRAM address
		moveq	#0,d1
		move.w	(Ring_count).w,d1
		bsr.w	HUD_Rings

loc_1B286:
		tst.b	(Update_HUD_timer).w
		beq.s	loc_1B2E2
		tst.b	(Game_paused).w
		bne.s	loc_1B2E2
		lea	(Timer).w,a1
		cmpi.l	#(9*$10000)+(59*$100)+59,(a1)+ ; is the time 9:59:59?
		beq.s	loc_1B2C2	; prevent timer from updating
		addq.b	#1,-(a1)
		cmpi.b	#60,(a1)
		bcs.s	loc_1B2E2
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#60,(a1)
		bcs.s	loc_1B2C2
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#9,(a1)
		bcs.s	loc_1B2C2
		move.b	#9,(a1)

loc_1B2C2:
		locVRAMtemp	$DE40
		moveq	#0,d1
		move.b	(Timer_minute).w,d1
		bsr.w	HUD_Mins
		locVRAMtemp	$DEC0
		moveq	#0,d1
		move.b	(Timer_second).w,d1
		bsr.w	HUD_Secs

loc_1B2E2:
		tst.b	(Update_HUD_lives).w
		beq.s	loc_1B2F0
		clr.b	(Update_HUD_lives).w
		bsr.w	HUD_Lives

loc_1B2F0:
		tst.b	(Update_Bonus_score).w
		beq.s	locret_1B318
		clr.b	(Update_Bonus_score).w
		locVRAM	$AE00
		moveq	#0,d1
		move.w	(Bonus_Countdown_1).w,d1
		bsr.w	HUD_TimeRingBonus
		moveq	#0,d1
		move.w	(Bonus_Countdown_2).w,d1
		bsr.w	HUD_TimeRingBonus

locret_1B318:
		rts
; ===========================================================================
; kills the player if the time has reached 9:59, except now it's unused due
; to its "beq" command being noped out above
S1TimeOver:
		clr.b	(Update_HUD_timer).w
		lea	(MainCharacter).w,a0
		movea.l	a0,a2
		bsr.w	KillSonic
		move.b	#1,($FFFFFE1A).w
		rts
; ===========================================================================

HUD_Debug:	
		bsr.w	HUDDebug_XY
		tst.b	(Update_HUD_rings).w
		beq.s	loc_1B354
		bpl.s	loc_1B340
		bsr.w	HUD_LoadZero

loc_1B340:	
		clr.b	(Update_HUD_rings).w
		move.l	#$5F400003,d0
		moveq	#0,d1
		move.w	(Ring_count).w,d1
		bsr.w	HUD_Rings

loc_1B354:	
		locVRAMtemp	$DE40
		moveq	#0,d1
		btst.b	#7,(MainCharacter+art_tile).w	; check Player 1's priority
		beq.s	@NotPrio
		moveq	#10,d1
	@NotPrio:
		btst.b	#1,(MainCharacter+lrb_solid_bit).w	; check Player 1's path
		beq.s	@NotPath
		addq	#1,d1
	@NotPath:
		bsr.w	HUD_Secs

		locVRAMtemp	$DEC0
		moveq	#0,d1
		move.b	(Sprite_count).w,d1
		bsr.w	HUD_Secs

		tst.b	(Update_HUD_lives).w
		beq.s	loc_1B372
		clr.b	(Update_HUD_lives).w
		bsr.w	HUD_Lives

loc_1B372:	
		tst.b	(Update_Bonus_score).w
		beq.s	@DoNothing
		clr.b	(Update_Bonus_score).w
		move.l	#$6E000002,(VDP_control_port).l
		moveq	#0,d1
		move.w	(Bonus_Countdown_1).w,d1
		bsr.w	HUD_TimeRingBonus
		moveq	#0,d1
		move.w	(Bonus_Countdown_2).w,d1
		bsr.w	HUD_TimeRingBonus
@DoNothing:	
		rts
; ===========================================================================
HUD_LoadZero:	
		locVRAM	$DF40
		lea	HUD_TilesZero(pc),a2
		move.w	#3-1,d2
		bra.s	HUD_DrawBase

; ===========================================================================
HUD_Base:				
		lea	(VDP_data_port).l,a6
		bsr.w	HUD_Lives
		locVRAM	$DC40
		lea	HUD_TilesBase(pc),a2
		move.w	#15-1,d2

HUD_DrawBase:	
		lea	Artunc_HudNumbers(pc),a1

	@Loop:
		move.w	#((8*2)-2)-1,d1	; Fixing a skill issue
		move.b	(a2)+,d0
		bmi.s	@MakeBlank
		ext.w	d0
		lsl.w	#5,d0
		lea	(a1,d0.w),a3

	@LoadTiles:
		move.l	(a3)+,(a6)	; Send to VRAM via Data Port
		dbf	d1,@LoadTiles
		move.l	#0,(a6)
		move.l	#0,(a6)
	@BackToLoop:
		dbf	d2,@Loop
		rts
	; ---------
	@MakeBlank:	
		move.l	#0,(a6)
		dbf	d1,@MakeBlank
		move.l	#0,(a6)		; goddamnit Jeff, look what you made me do
		move.l	#0,(a6)
		bra.s	@BackToLoop
; ===========================================================================
HUD_TilesBase:	dc.b 11*2, -1,-1,-1,-1,-1,-1, 0  ; Score
		dc.b 0, 10*2, 0, 0		 ; Time
HUD_TilesZero:	dc.b -1,-1, 0			 ; Rings
		even
; ===========================================================================


HUDDebug_XY:				; CODE XREF: HudUpdate:HUD_Debugp
		locVRAM	$DC40
		move.w	(Camera_X_pos).w,d1
		swap	d1
		move.w	(MainCharacter+x_pos).w,d1
		bsr.s	HUDDebug_XY2
		move.w	(Camera_Y_pos).w,d1
		swap	d1
		move.w	(MainCharacter+y_pos).w,d1
; End of function HUDDebug_XY


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUDDebug_XY2:				; CODE XREF: HUDDebug_XY+14p
		moveq	#8-1,d6
		lea	(Artunc_DebugTXT).l,a1

loc_1B430:				; CODE XREF: HUDDebug_XY2+32j
		rol.w	#4,d1
		move.w	d1,d2
		andi.w	#$F,d2
		cmpi.w	#$A,d2
		bcs.s	loc_1B442
		addi.w	#7,d2

loc_1B442:				; CODE XREF: HUDDebug_XY2+14j
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		swap	d1
		dbf	d6,loc_1B430
		rts
; End of function HUDDebug_XY2


; ===========================================================================
HUD_Rings:	
		lea	(HUD_100).l,a2
		moveq	#3-1,d6
		bra.s	HUD_LoadArt
; ===========================================================================
HUD_Score:				
		lea	(HUD_100000).l,a2
		moveq	#6-1,d6
		; code continues bellow
; ---------------------------------------------------------------------------
; Load Digits into a Tilemap Layer (used for HUDs and Time)
; input : 
;	d0	= VDP VRAM write command
;	d1	= Digits to Draw
;	d6	= Number of digits -1 
;	a2	= reference number in decimal
; output :
;	d0	= VDP VRAM write command (Last Digit)
;	d1.l	= trash
;	d2.w	= Last Digit of value in decimal * 64
;	d3.l	= 1
;	d4.w	= Number of Zeroes
;	d6.w	= -1 (end of loop)
;	a1	= trash
;	a2	= (Hud_1)+4
;	a3	= trash
; ---------------------------------------------------------------------------
Hud_LoadArt:
		moveq	#0,d4
		lea	Artunc_HudNumbers(pc),a1

Hud_DrawDigitsLoop:
		moveq	#0,d2
		move.l	(a2)+,d3	; get next multiple of 10

@ConvertHexToDecimal:
		sub.l	d3,d1		; subtract decimal and compare with hex number
		bcs.s	@DigitFound	; if underflown, branch
		addq.w	#1,d2		; increase digit to draw
		bra.s	@ConvertHexToDecimal	; loop until 
; ===========================================================================

	@DigitFound:
		add.l	d3,d1		; undo last subtract
		tst.w	d2		; is digit a zero
		beq.s	@NotZero
		move.w	#1,d4		; count up
	@NotZero:
		tst.w	d4		; is this one of the first Zeros?
		beq.s	@DontDraw
		move.l	d0,4(a6)	; send write VRAM command to Control Port
		lsl.w	#6,d2		; multiply by 64 (2 tiles worth)
		lea	(a1,d2.w),a3	; fetch correct digit
		rept	(8*2)-2		; Fixing Jeff's a skill issue
		move.l	(a3)+,(a6)
		endr

	@DontDraw:	
		addi.l	#(($20*2)<<16),d0
		dbf	d6,Hud_DrawDigitsLoop
		rts
; End of function HUD_Score

; ===========================================================================

ContScrCounter:
		locVRAM	$DF80
		lea	(VDP_data_port).l,a6
		lea	(HUD_10).l,a2
		moveq	#1,d6
		moveq	#0,d4
		lea	Artunc_HudNumbers(pc),a1

ContScr_Loop:				; CODE XREF: ROM:0001B51Aj
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1B4EA:				; CODE XREF: ROM:0001B4F0j
		sub.l	d3,d1
		bcs.s	loc_1B4F2
		addq.w	#1,d2
		bra.s	loc_1B4EA
; ===========================================================================

loc_1B4F2:				; CODE XREF: ROM:0001B4ECj
		add.l	d3,d1
		lsl.w	#6,d2
		lea	(a1,d2.w),a3
		rept	(8*2)-2		; Fixing Jeff's a skill issue
		move.l	(a3)+,(a6)
		endr
		dbf	d6,ContScr_Loop
		rts
; ===========================================================================
HUD_100000:	dc.l 100000
HUD_10000:	dc.l 10000
HUD_1000:	dc.l 1000
HUD_100:	dc.l 100
HUD_10:		dc.l 10
HUD_1:		dc.l 1

; ===========================================================================


HUD_Mins:				; CODE XREF: HudUpdate+90p
		lea	HUD_1(pc),a2
		moveq	#0,d6
		bra.s	loc_1B546
; End of function HUD_Mins


; ===========================================================================


HUD_Secs:				; CODE XREF: HudUpdate+A0p
					; HudUpdate+122p
		lea	HUD_10(pc),a2
		moveq	#1,d6

loc_1B546:				; CODE XREF: HUD_Mins+6j
		moveq	#0,d4

loc_1B548:
		lea	Artunc_HudNumbers(pc),a1

loc_1B54C:				; CODE XREF: HUD_Secs+52j
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1B550:				; CODE XREF: HUD_Secs+16j
		sub.l	d3,d1
		bcs.s	loc_1B558
		addq.w	#1,d2
		bra.s	loc_1B550
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B558:				; CODE XREF: HUD_Secs+12j
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1B562
		move.w	#1,d4

loc_1B562:				; CODE XREF: HUD_Secs+1Cj
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3

		rept	(8*2)-2		; Fixing Jeff's a skill issue
		move.l	(a3)+,(a6)
		endr

		addi.l	#(($20*2)<<16),d0
		dbf	d6,loc_1B54C
		rts
; End of function HUD_Secs


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUD_TimeRingBonus:			; CODE XREF: HudUpdate+CCp
					; HudUpdate+D6p ...
		lea	HUD_1000(pc),a2
		moveq	#3,d6
		moveq	#0,d4
		lea	Artunc_HudNumbers(pc),a1

loc_1B5A4:				; CODE XREF: HUD_TimeRingBonus:loc_1B5E4j
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1B5A8:				; CODE XREF: HUD_TimeRingBonus+16j
		sub.l	d3,d1
		bcs.s	loc_1B5B0
		addq.w	#1,d2
		bra.s	loc_1B5A8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B5B0:				; CODE XREF: HUD_TimeRingBonus+12j
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1B5BA
		move.w	#1,d4

loc_1B5BA:				; CODE XREF: HUD_TimeRingBonus+1Cj
		tst.w	d4
		beq.s	loc_1B5EA
		lsl.w	#6,d2
		lea	(a1,d2.w),a3
		rept	8*2
		move.l	(a3)+,(a6)
		endr

loc_1B5E4:				; CODE XREF: HUD_TimeRingBonus+5Ej
		dbf	d6,loc_1B5A4
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B5EA:				; CODE XREF: HUD_TimeRingBonus+24j
		moveq	#$F,d5

loc_1B5EC:				; CODE XREF: HUD_TimeRingBonus+5Aj
		move.l	#0,(a6)
		dbf	d5,loc_1B5EC
		bra.s	loc_1B5E4
; End of function HUD_TimeRingBonus


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HUD_Lives:				; CODE XREF: HudUpdate+AEp
					; HudUpdate+130p ...
		locVRAMtemp	$FBA0		; set VRAM address
		moveq	#0,d1
		move.b	(Life_count).w,d1
		lea	HUD_10(pc),a2
		moveq	#1,d6
		moveq	#0,d4
		lea	Artunc_HudLifeNumbers(pc),a1

loc_1B610:				; CODE XREF: HUD_Lives+52j
		move.l	d0,4(a6)
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1B618:				; CODE XREF: HUD_Lives+26j
		sub.l	d3,d1
		bcs.s	loc_1B620
		addq.w	#1,d2
		bra.s	loc_1B618
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B620:				; CODE XREF: HUD_Lives+22j
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1B62A
		move.w	#1,d4

loc_1B62A:				; CODE XREF: HUD_Lives+2Cj
		tst.w	d4
		beq.s	loc_1B650

loc_1B62E:				; CODE XREF: HUD_Lives+5Aj
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		rept	8*2
		move.l	(a3)+,(a6)
		endr

loc_1B644:				; CODE XREF: HUD_Lives+68j
		addi.l	#(($20*2)<<16),d0
		dbf	d6,loc_1B610
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1B650:				; CODE XREF: HUD_Lives+34j
		tst.w	d6
		beq.s	loc_1B62E
		moveq	#7,d5

loc_1B656:				; CODE XREF: HUD_Lives+64j
		move.l	#0,(a6)
		dbf	d5,loc_1B656
		bra.s	loc_1B644

	Artunc_Add	none, HudLifeNumbers,	Objects\HUD\,	HudLifeNumbers
	Artunc_Add	none, HudNumbers,	Objects\HUD\,	HudNumbers