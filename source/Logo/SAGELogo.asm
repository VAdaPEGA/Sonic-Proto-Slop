; ---------------------------------------------------------------------------
; Sound Test
; ---------------------------------------------------------------------------

GM_SoundTest:				; XREF: GameModeArray
		music	bgm_Stop	; stop music
		jsr	ClearPLC
		jsr	PaletteFadeOut	
		disable_ints

	;	lea	(vdp_debug).l,a6
	;	move.w	#%111000000,(a6)		; Plane B only (HW)	

		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)		; 8-colour mode
		move.w	#$8200+($C000>>10),(a6) ; set foreground nametable address
		move.w	#$8400+($A000>>13),(a6) ; set background nametable address
		move.w	#$8500+(vram_sprites>>9),(a6) ; set sprite table address
		move.w	#$8B03,(a6)		; line scroll mode
		move.w	#$9011,(a6)		; Plane size
		move.w	#$8710,(a6)		; set background colour (line 1; colour 0)
		move.w	#$8C89,(a6)		; SH mode
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(a6)			; enable Display
		move.w	(v_hbla_hreg).w,(a6)
		sf	(f_wtr_state).w

		jsr	ClearScreen
		jsr	ClearScreen2
		jsr	ClearSprites
		movea.l	#0,a1		
		lea	(v_objspace).w,a1
		moveq	#0,d0
		moveq	#0,d1
		move.w	#$7FF,d1

	@clr_obj:
		move.l	d0,(a1)+
		dbf	d1,@clr_obj	; fill object space ($D000-$EFFF) with 0

		move.b	#$16,(v_vbla_routine).w
		jsr	WaitForVBla

		moveq	#$00,d0					; clear d0

		move.w	#256,(v_scrposy_dup).w

		disable_ints

		lea	($FF0000).l,a1
		lea	(Eni_CutSAGE).l,a0 ; load mappings for Japanese credits
		moveq	#0,d0
		jsr	EniDec
		copyTilemap	$FF0000,$C000,$27,$2A,1

		lea	($FF0000).l,a1
		lea	(Eni_CutSAGE2).l,a0 ; load mappings for Japanese credits
		move.w	#UncSize_Zip_CutSage/$20,d0
		jsr	EniDec
		copyTilemap	$FF0000,$A000,$27,$1D,1

		Zip_Decompress	CutSage,0
		move.b	#$16,(v_vbla_routine).w
		jsr	WaitForVBla
		@waitfordma:
		tst.w	(v_dma_queue).w
		bne.s	@waitfordma
		Zip_Decompress	CutSage2,UncSize_Zip_CutSage

		move.b	#bgm_xmas,d0
		jsr	PlaySound_Special

		lea	Pal_CUTSAGE,a1
		lea	(v_pal_dry).w,a2		; Load palette address to a1
		lea	(v_pal_dry_dup).w,a3
		moveq	#($20*4)/4-1,d0			; Loop for 4 lines
		@LoadPal:
		move.l	#$02000200,(a2)+		; move data (two colours, each 1 word)
		move.l	(a1)+,(a3)+			; move data (two colours, each 1 word)
		dbf	d0,@LoadPal			; loop untill all is loaded (16 colours, $20)
	
		move.l	#$02000000,v_pal_dry+(2*16)
		move.l	#$00000000,v_pal_dry+(2*18)
		move.l	#$00000000,v_pal_dry+(2*20)

; ---------------------------------------------------------------------------
		move.w	#$3E0,d4
		moveq	#0,d5
		@MoveDown:
		move.b	#$16,(v_vbla_routine).w
		jsr	WaitForVBla

		;move.w	(v_scrposy_dup).w,d1
		;sub.w	#(256*2)-32+1,d1
		;asr.w	#5,d1

		move.b	(v_vbla_byte).w,d0
		and.w	#7,d0
		bne.s	@noFade1
			move.w	#((2*17)<<8)+(5-1),(v_pfade_start).w
			jsr	FadeIn_FromBlack
		@noFade1:

		subq.w	#8,d4
		beq.s	@noMoveDown
		add.w	d4,d5
		move.w	d5,d1
		lsr.w	#$8,d1
		lsr.w	#$1,d1
		add.w	#256+128+9,d1
		neg.w	d1
		move.w	d1,(v_scrposy_dup).w

		move.w	d4,d0
		subq.w	#8,d0
		lsl.w	#3,d0
		neg.w	d0
		move.w	d0,(v_ScrTransWobble).w

		moveq	#0,d0
		move.w 	#240-1,d7
		lea	(v_hscrolltablebuffer).w,a1
		@loopClr:
		move.l	d0,(a1)+
		dbf	d7,@loopClr

		jsr	fuckthescreenup
		bra.s	@MoveDown



		@noMoveDown:
		move.l	#SAGE_SnowSpawn,(v_player).w

		bsr	SAGE_Sync
		move.w	#0,(v_ScrTransWobble).w

		move.b	(v_vbla_byte).w,d0
		and.w	#1,d0
		bne.s	@noFade2
			move.w	#((2*3)<<8)+(13-1),(v_pfade_start).w
			jsr	FadeIn_FromBlack
		@noFade2:
		cmpi.w	#$0EEE,v_pal_dry+(2*14)
		bne.s	@noMoveDown
		bsr	SAGE_paletteCycle
		;move.w	#$0200,v_pal_dry_dup.w

		@lastfade:
		bsr	SAGE_Sync
			move.w	#((2*0)<<8)+(3-1),(v_pfade_start).w
			jsr	FadeIn_FromBlack
		cmpi.w	#$02E0,v_pal_dry.w
		bne.s	@lastfade

		move.l	#$0AEA0EEE,(v_pal_dry_dup+2).w
		bsr	SAGE_paletteCycle

		move.w	#60*3,(v_demolength).w	; 3 seconds of wait time
		move.b	#GameModeID_Logo,(v_gamemode).w

		@loop:
		bsr	SAGE_Sync
		andi.b	#btnStart,(v_jpadpress1).w 	; is Start button pressed?
		bne.s	@start			; if not, branch
		tst.w	(v_demolength).w
		bne.s	@loop
		@start:
		rts
; ---------------------------------------------------------------------------
SAGE_paletteCycle:
		move.w	#6*2,d0		; 3 palette indexes
	@WaitPal:
		movem.l	d0-a6,-(sp)	; push
		bsr	SAGE_Sync
		movem.l	(sp)+,d0-a6	; pop
		move.b	(v_vbla_byte).w,d4
		and.b	#1,d4
		bne.s	@WaitPal
	
		lea	(v_pal_dry_dup).w,a0	; load fade palette to a0
		lea	(v_pal_dry+(2*16)).w,a1	; load RAM palette into a1
		moveq	#2,d1			; 3 palette indexes
		move.w	#48*2,d2		; end point of palette (excludes transparent)
		jsr	PalCycle_PalShift	
		cmpi.w	#48*2,d0		; has end been reached?
		bpl.s	@end				; if not, loop
		bra.s	@WaitPal			; if not, branch
	@end:
		rts



; ---------------------------------------------------------------------------
SAGE_Sync:
		move.b	#$16,(v_vbla_routine).w	; V-Sync
		jsr	WaitForVBla		
		jsr	ExecuteObjects
		jmp	BuildSprites
; ---------------------------------------------------------------------------
SAGE_SnowSpawn:
		subq.b	#1,obRoutine(a0)
		bpl.s	@doNothing
		move.b	#2,obRoutine(a0)
		jsr	FindFreeObj
		bne	@doNothing
			move.l	#SAGE_Snow,(a1)
			move.l	#@map,obMap(a1)
			move.b	#24,obActWid(a1)
			move.b	#$24,obRender(a1)
			move.w	#$280,obVelY(a1)
			jsr	(RandomNumber).l
			and.w	#255,d1
			move.w	d1,obX(a1)
			add.w	#32,obX(a1)
			and.w	#15,d1
			lsl.w	#4,d1
			add.w	d1,obVelY(a1)
			and.w	#15,d0
			lsl.w	#6,d0
			sub.w	#$200,d0
			move.w	d0,obVelX(a1)
			swap	d0
			and.w	#3,d0
			move.w	d0,obGfx(a1)
		@doNothing:
		rts
		@map:	MAP_Entry	-4,-4,0,(UncSize_Zip_CutSage/$20),1,3,0,0
SAGE_Snow:
		addq.l	#8,(a0)
		jmp	DisplaySprite
		jsr	DisplaySprite
		tst.b	obRender(a0)
		bpl.s	@norender
		jmp	SpeedToPos
		@norender:
		jmp	DeleteObject
; ---------------------------------------------------------------------------