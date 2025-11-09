; ===========================================================================
; ---------------------------------------------------------------------------
; Object 8A - "SONIC TEAM PRESENTS" screen and credits
; ---------------------------------------------------------------------------

Obj8A:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj8A_Index(pc,d0.w),d1
		jmp	Obj8A_Index(pc,d1.w)
; ===========================================================================
; off_185EE:
Obj8A_Index:	dc.w Obj8A_Init-Obj8A_Index
		dc.w Obj8A_Display-Obj8A_Index
; ===========================================================================
; loc_185F2:
Obj8A_Init:
		addq.b	#2,routine(a0)
		move.w	#$120,x_pixel(a0)
		move.w	#$F0,y_pixel(a0)
		move.l	#Map_Credits,mappings(a0)
		move.w	#$5A0,art_tile(a0)


; Obj8A_Credits:
		move.w	($FFFFFFF4).w,d0	; load credits index number
		move.b	d0,mapping_frame(a0)	; display appropriate credits
		move.b	#0,render_flags(a0)
		move.b	#0,priority(a0)

		cmpi.b	#GameModeID_TitleScreen,(Game_Mode).w	; is this the title screen?
		bne.s	@Display		; if not, branch

; Obj8A_SonicTeam:
		move.w	#$300,art_tile(a0)
		move.b	#$A,mapping_frame(a0)
		tst.b	(S1_hidden_credits_flag).w	; is the Sonic 1 hidden credits cheat activated?
		beq.s	@Display	; if not, branch
		cmpi.b	#btnABC+btnDn,(Ctrl_1_Held).w	; has the player pressed A+B+C+Down?
		bne.s	@Display	; if not, branch
		move.l	#$0EEE0880,(Normal_palette_line3).w	; change colours to display JP credits
		jmp	(DeleteObject).l
; ===========================================================================
	@Display:
		jsr	Adjust2PArtPointer
Obj8A_Display:
		jmp	(DisplaySprite).l