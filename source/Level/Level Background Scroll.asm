; Initialization of Background (relative to last checkpoint)
BgScrollSpeed:	
		tst.b	(Last_LampPost_hit).w
		bne.s	loc_59B6
		move.w	d0,(Camera_BG_Y_pos).w
		move.w	d0,(Camera_BG2_Y_pos).w
		move.w	d1,(Camera_BG_X_pos).w
		move.w	d1,(Camera_BG2_X_pos).w
		move.w	d1,(Camera_BG3_X_pos).w
		move.w	d0,(Camera_BG_Y_pos_P2).w
		move.w	d0,(Camera_BG2_Y_pos_P2).w
		move.w	d1,(Camera_BG_X_pos_P2).w
		move.w	d1,(Camera_BG2_X_pos_P2).w
		move.w	d1,(Camera_BG3_X_pos_P2).w

loc_59B6:	
		moveq	#0,d2
		move.b	(Current_Zone).w,d2
		add.w	d2,d2
		move.w	BgScroll_Index(pc,d2.w),d2
		jmp	BgScroll_Index(pc,d2.w)
; ===========================================================================
BgScroll_Index:	dc.w BgScroll_GHZ-BgScroll_Index
		dc.w BgScroll_LZ-BgScroll_Index; 1
		dc.w BgScroll_CPZ-BgScroll_Index; 2
		dc.w BgScroll_EHZ-BgScroll_Index; 3
		dc.w BgScroll_HPZ-BgScroll_Index; 4
		dc.w BgScroll_EHZ-BgScroll_Index; 5
		dc.w BgScroll_S1Ending-BgScroll_Index; 6
; ===========================================================================
BgScroll_GHZ:	
		clr.l	(Camera_BG_X_pos).w
		clr.l	(Camera_BG_Y_pos).w
		clr.l	(Camera_BG2_Y_pos).w
		clr.l	(Camera_BG3_Y_pos).w
		lea	(TempArray_LayerDef).w,a2
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(Camera_BG_X_pos_P2).w
		clr.l	(Camera_BG_Y_pos_P2).w
		clr.l	(Camera_BG2_Y_pos_P2).w
		clr.l	(Camera_BG3_Y_pos_P2).w
		rts
; ---------------------------------------------------------------------------
BgScroll_LZ:	
		asr.l	#1,d0
		move.w	d0,(Camera_BG_Y_pos).w
		rts
; ---------------------------------------------------------------------------
BgScroll_CPZ:	
		lsr.w	#2,d0
		move.w	d0,(Camera_BG_Y_pos).w
		move.w	d0,(Camera_BG_Y_pos_P2).w
		clr.l	(Camera_BG_X_pos).w
		clr.l	(Camera_BG2_X_pos).w
		rts
; ---------------------------------------------------------------------------
BgScroll_EHZ:	
		clr.l	(Camera_BG_X_pos).w
		clr.l	(Camera_BG_Y_pos).w
		clr.l	(Camera_BG2_Y_pos).w
		clr.l	(Camera_BG3_Y_pos).w
		lea	(TempArray_LayerDef).w,a2
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(Camera_BG_X_pos_P2).w
		clr.l	(Camera_BG_Y_pos_P2).w
		clr.l	(Camera_BG2_Y_pos_P2).w
		clr.l	(Camera_BG3_Y_pos_P2).w
		rts
; ---------------------------------------------------------------------------
BgScroll_HPZ:	
		asr.w	#1,d0
		move.w	d0,(Camera_BG_Y_pos).w
		clr.l	(Camera_BG_X_pos).w
		rts
; ---------------------------------------------------------------------------
BgScroll_S1SYZ:				; leftover from	Sonic 1
		asl.l	#4,d0
		move.l	d0,d2
		asl.l	#1,d0
		add.l	d2,d0
		asr.l	#8,d0
		addq.w	#1,d0
		move.w	d0,(Camera_BG_Y_pos).w
		clr.l	(Camera_BG_X_pos).w
		rts
; ---------------------------------------------------------------------------
BgScroll_S1Ending:	
		move.w	(Camera_X_pos).w,d0
		asr.w	#1,d0
		move.w	d0,(Camera_BG_X_pos).w
		move.w	d0,(Camera_BG2_X_pos).w
		asr.w	#2,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		move.w	d0,(Camera_BG3_X_pos).w
		clr.l	(Camera_BG_Y_pos).w
		clr.l	(Camera_BG2_Y_pos).w
		clr.l	(Camera_BG3_Y_pos).w
		lea	(TempArray_LayerDef).w,a2
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(a2)+
		rts
; ===========================================================================

DeformBGLayer:	
		tst.b	($FFFFEEDC).w
		beq.s	loc_5AA4
		rts
; ===========================================================================
loc_5AA4:	
		clr.w	(Scroll_flags).w
		clr.w	(Scroll_flags_BG).w
		clr.w	(Scroll_flags_BG2).w
		clr.w	(Scroll_flags_BG3).w
		clr.w	(Scroll_flags_P2).w
		clr.w	(Scroll_flags_BG_P2).w
		clr.w	(Scroll_flags_BG2_P2).w
		clr.w	(Scroll_flags_BG3_P2).w
	; Player 1 Camera
		lea	(MainCharacter).w,a0
		lea	(Camera_X_pos).w,a1
		lea	(Camera_Min_X_pos).w,a2
		lea	(Scroll_flags).w,a3
		lea	(Camera_X_pos_diff).w,a4
		lea	(Horiz_scroll_delay_val).w,a5
		lea	(Sonic_Pos_Record_Buf).w,a6
		bsr.w	ScrollHorizontal

		lea	(Horiz_block_crossed_flag).w,a2
		bsr.w	SetHorizScrollFlags

		lea	(Camera_Y_pos).w,a1
		lea	(Camera_Min_X_pos).w,a2
		lea	(Camera_Y_pos_diff).w,a4
		move.w	(Camera_Y_pos_bias).w,d3
		bsr.w	ScrollVertical

		lea	(Verti_block_crossed_flag).w,a2
		bsr.w	SetVertiScrollFlags

		tst.w	(Two_player_mode).w
		beq.s	loc_5B2A
	; Player 2 Camera
		lea	(Sidekick).w,a0
		lea	(Camera_X_pos_P2).w,a1
		lea	(Camera_Min_X_pos_P2).w,a2
		lea	(Scroll_flags_P2).w,a3
		lea	($FFFFEEB6).w,a4
		lea	($FFFFEED4).w,a5
		lea	($FFFFE700).w,a6
		bsr.w	ScrollHorizontal
		lea	(Horiz_block_crossed_flag_P2).w,a2
		bsr.w	SetHorizScrollFlags

		lea	(Camera_Y_pos_P2).w,a1
		lea	(Camera_Min_X_pos_P2).w,a2
		lea	($FFFFEEB8).w,a4
		move.w	(Camera_Y_pos_bias_P2).w,d3	; not implemented yet
		bsr.w	ScrollVertical
		lea	(Verti_block_crossed_flag_P2).w,a2
		bsr.w	SetVertiScrollFlags

loc_5B2A:				; CODE XREF: DeformBGLayer+5Cj
		bsr.w	DynScreenResizeLoad
		move.w	(Camera_Y_pos).w,(Vscroll_Factor).w
		move.w	(Camera_BG_Y_pos).w,($FFFFF618).w
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		add.w	d0,d0
		move.w	Deform_Index(pc,d0.w),d0
		jmp	Deform_Index(pc,d0.w)
; End of function DeformBGLayer

; ===========================================================================
Deform_Index:	dc.w Deform_GHZ-Deform_Index	; 0
		dc.w Deform_LZ-Deform_Index	; 1
		dc.w Deform_CPZ-Deform_Index	; 2
		dc.w Deform_EHZ-Deform_Index	; 3
		dc.w Deform_HPZ-Deform_Index	; 4
		dc.w Deform_HTZ-Deform_Index	; 5
		dc.w Deform_GHZ-Deform_Index	; 6
; ===========================================================================
Deform_GHZ:	
		tst.w	(Two_player_mode).w
		bne.w	loc_5C5A
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d6
		bsr.w	ScrollBlock6
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#0,d6
		bsr.w	ScrollBlock5
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_Y_pos).w,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$20,d0	; ' '
		bpl.s	loc_5B9A
		moveq	#0,d0

loc_5B9A:	
		move.w	d0,d4
		move.w	d0,($FFFFF618).w
		move.w	(Camera_X_pos).w,d0
		cmpi.b	#GameModeID_TitleScreen,(Game_Mode).w
		bne.s	loc_5BAE
		moveq	#0,d0

loc_5BAE:	
		neg.w	d0
		swap	d0
		lea	(TempArray_LayerDef).w,a2
		addi.l	#$10000,(a2)+
		addi.l	#$C000,(a2)+
		addi.l	#$8000,(a2)+
		move.w	(TempArray_LayerDef).w,d0
		add.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		move.w	#$1F,d1
		sub.w	d4,d1
		bcs.s	loc_5BE0

loc_5BDA:				; CODE XREF: ROM:00005BDCj
		move.l	d0,(a1)+
		dbf	d1,loc_5BDA

loc_5BE0:				; CODE XREF: ROM:00005BD8j
		move.w	(TempArray_LayerDef+4).w,d0
		add.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		move.w	#$F,d1

loc_5BEE:				; CODE XREF: ROM:00005BF0j
		move.l	d0,(a1)+
		dbf	d1,loc_5BEE
		move.w	(TempArray_LayerDef+8).w,d0
		add.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		move.w	#$F,d1

loc_5C02:				; CODE XREF: ROM:00005C04j
		move.l	d0,(a1)+
		dbf	d1,loc_5C02
		move.w	#$2F,d1	; '/'
		move.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0

loc_5C12:				; CODE XREF: ROM:00005C14j
		move.l	d0,(a1)+
		dbf	d1,loc_5C12
		move.w	#$27,d1	; '''
		move.w	(Camera_BG2_X_pos).w,d0
		neg.w	d0

loc_5C22:				; CODE XREF: ROM:00005C24j
		move.l	d0,(a1)+
		dbf	d1,loc_5C22
		move.w	(Camera_BG2_X_pos).w,d0
		move.w	(Camera_X_pos).w,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2	; 'h'
		ext.l	d2
		asl.l	#8,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#$47,d1	; 'G'
		add.w	d4,d1

loc_5C48:				; CODE XREF: ROM:00005C54j
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,loc_5C48
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_5C5A:				; CODE XREF: ROM:00005B5Cj
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d6
		bsr.w	ScrollBlock6
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#0,d6
		bsr.w	ScrollBlock5
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_Y_pos).w,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$20,d0	; ' '
		bpl.s	loc_5C94
		moveq	#0,d0

loc_5C94:				; CODE XREF: ROM:00005C90j
		andi.w	#$FFFE,d0
		move.w	d0,d4
		lsr.w	#1,d4
		move.w	d0,($FFFFF618).w
		andi.l	#$FFFEFFFE,(Vscroll_Factor).w
		move.w	(Camera_X_pos).w,d0
		cmpi.b	#GameModeID_TitleScreen,(Game_Mode).w
		bne.s	loc_5CB6
		moveq	#0,d0

loc_5CB6:				; CODE XREF: ROM:00005CB2j
		neg.w	d0
		swap	d0
		lea	(TempArray_LayerDef).w,a2
		addi.l	#$10000,(a2)+
		addi.l	#$C000,(a2)+
		addi.l	#$8000,(a2)+
		move.w	(TempArray_LayerDef).w,d0
		add.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		move.w	#$F,d1
		sub.w	d4,d1
		bcs.s	loc_5CE8

loc_5CE2:				; CODE XREF: ROM:00005CE4j
		move.l	d0,(a1)+
		dbf	d1,loc_5CE2

loc_5CE8:				; CODE XREF: ROM:00005CE0j
		move.w	(TempArray_LayerDef+4).w,d0
		add.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		move.w	#7,d1

loc_5CF6:				; CODE XREF: ROM:00005CF8j
		move.l	d0,(a1)+
		dbf	d1,loc_5CF6
		move.w	(TempArray_LayerDef+8).w,d0
		add.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		move.w	#7,d1

loc_5D0A:				; CODE XREF: ROM:00005D0Cj
		move.l	d0,(a1)+
		dbf	d1,loc_5D0A
		move.w	#$17,d1
		move.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0

loc_5D1A:				; CODE XREF: ROM:00005D1Cj
		move.l	d0,(a1)+
		dbf	d1,loc_5D1A
		move.w	#$17,d1
		move.w	(Camera_BG2_X_pos).w,d0
		neg.w	d0

loc_5D2A:				; CODE XREF: ROM:00005D2Cj
		move.l	d0,(a1)+
		dbf	d1,loc_5D2A
		move.w	(Camera_BG2_X_pos).w,d0
		move.w	(Camera_X_pos).w,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2	; 'h'
		ext.l	d2
		asl.l	#8,d2
		add.l	d2,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#$23,d1	; '#'
		add.w	d4,d1

loc_5D52:				; CODE XREF: ROM:00005D5Ej
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,loc_5D52
		move.w	($FFFFEEB6).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		add.l	d4,(Camera_BG3_X_pos_P2).w
		move.w	($FFFFEEB6).w,d4
		ext.l	d4
		asl.l	#7,d4
		add.l	d4,(Camera_BG2_X_pos_P2).w
		lea	($FFFFE1C0).w,a1
		move.w	(Camera_Y_pos_P2).w,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$20,d0	; ' '
		bpl.s	loc_5D98
		moveq	#0,d0

loc_5D98:				; CODE XREF: ROM:00005D94j
		andi.w	#$FFFE,d0
		move.w	d0,d4
		lsr.w	#1,d4
		move.w	d0,($FFFFF620).w
		subi.w	#224,($FFFFF620).w ; 'à'
		move.w	(Camera_Y_pos_P2).w,($FFFFF61E).w
		subi.w	#224,($FFFFF61E).w ; 'à'
		andi.l	#$FFFEFFFE,($FFFFF61E).w
		move.w	(Camera_X_pos_P2).w,d0
		cmpi.b	#GameModeID_TitleScreen,(Game_Mode).w
		bne.s	loc_5DCC
		moveq	#0,d0

loc_5DCC:				; CODE XREF: ROM:00005DC8j
		neg.w	d0
		swap	d0
		move.w	(TempArray_LayerDef).w,d0
		add.w	(Camera_BG3_X_pos_P2).w,d0
		neg.w	d0
		move.w	#$F,d1
		sub.w	d4,d1
		bcs.s	loc_5DE8

loc_5DE2:				; CODE XREF: ROM:00005DE4j
		move.l	d0,(a1)+
		dbf	d1,loc_5DE2

loc_5DE8:				; CODE XREF: ROM:00005DE0j
		move.w	(TempArray_LayerDef+4).w,d0
		add.w	(Camera_BG3_X_pos_P2).w,d0
		neg.w	d0
		move.w	#7,d1

loc_5DF6:				; CODE XREF: ROM:00005DF8j
		move.l	d0,(a1)+
		dbf	d1,loc_5DF6
		move.w	(TempArray_LayerDef+8).w,d0
		add.w	(Camera_BG3_X_pos_P2).w,d0
		neg.w	d0
		move.w	#7,d1

loc_5E0A:				; CODE XREF: ROM:00005E0Cj
		move.l	d0,(a1)+
		dbf	d1,loc_5E0A
		move.w	#$17,d1
		move.w	(Camera_BG3_X_pos_P2).w,d0
		neg.w	d0

loc_5E1A:				; CODE XREF: ROM:00005E1Cj
		move.l	d0,(a1)+
		dbf	d1,loc_5E1A
		move.w	#$17,d1
		move.w	(Camera_BG2_X_pos_P2).w,d0
		neg.w	d0

loc_5E2A:				; CODE XREF: ROM:00005E2Cj
		move.l	d0,(a1)+
		dbf	d1,loc_5E2A
		move.w	(Camera_BG2_X_pos_P2).w,d0
		move.w	(Camera_X_pos_P2).w,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2	; 'h'
		ext.l	d2
		asl.l	#8,d2
		add.l	d2,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#$23,d1	; '#'
		add.w	d4,d1

loc_5E52:				; CODE XREF: ROM:00005E5Ej
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,loc_5E52
		rts
; ===========================================================================

Deform_LZ:				; DATA XREF: ROM:Deform_Indexo
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	(Camera_Y_pos_diff).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	ScrollBlock1
		move.w	(Camera_BG_Y_pos).w,($FFFFF618).w
		lea	(Deform_LZ_Data1).l,a3
		lea	(Obj0A_WobbleData).l,a2
		move.b	($FFFFF7D8).w,d2
		move.b	d2,d3
		addi.w	#$80,($FFFFF7D8).w ; '€'
		add.w	(Camera_BG_Y_pos).w,d2
		andi.w	#$FF,d2
		add.w	(Camera_Y_pos).w,d3
		andi.w	#$FF,d3
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	#$DF,d1	; 'ß'
		move.w	(Camera_X_pos).w,d0
		neg.w	d0
		move.w	d0,d6
		swap	d0
		move.w	(Camera_BG_X_pos).w,d0
		neg.w	d0
		move.w	(Water_Level_1).w,d4
		move.w	(Camera_Y_pos).w,d5

loc_5EC6:				; CODE XREF: ROM:00005ED2j
		cmp.w	d4,d5
		bge.s	loc_5ED8
		move.l	d0,(a1)+
		addq.w	#1,d5
		addq.b	#1,d2
		addq.b	#1,d3
		dbf	d1,loc_5EC6
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_5ED8:				; CODE XREF: ROM:00005EC8j
					; ROM:00005EF0j
		move.b	(a3,d3.w),d4
		ext.w	d4
		add.w	d6,d4
		move.w	d4,(a1)+
		move.b	(a2,d2.w),d4
		ext.w	d4
		add.w	d0,d4
		move.w	d4,(a1)+
		addq.b	#1,d2
		addq.b	#1,d3
		dbf	d1,loc_5ED8
		rts
; ===========================================================================
Deform_LZ_Data1:dc.b   1,  1,  2,  2,  3,  3,  3,  3,  2,  2,  1,  1,  0,  0,  0,  0; 0
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 16
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 32
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 48
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 64
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 80
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 96
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 112
		dc.b $FF,$FF,$FE,$FE,$FD,$FD,$FD,$FD,$FE,$FE,$FF,$FF,  0,  0,  0,  0; 128
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 144
		dc.b   1,  1,  2,  2,  3,  3,  3,  3,  2,  2,  1,  1,  0,  0,  0,  0; 160
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 176
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 192
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 208
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 224
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 240
; ===========================================================================
Deform_CPZ:	
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.w	(Camera_Y_pos_diff).w,d5
		ext.l	d5
		asl.l	#6,d5
		bsr.w	ScrollBlock1
		move.w	(Camera_BG_Y_pos).w,($FFFFF618).w
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	#$DF,d1	; 'ß'
		move.w	(Camera_X_pos).w,d0
		neg.w	d0
		swap	d0
		move.w	(Camera_BG_X_pos).w,d0
		neg.w	d0

loc_6026:	
		move.l	d0,(a1)+
		dbf	d1,loc_6026
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Deform_Unk:				; unknown BG deform
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.w	(Camera_Y_pos_diff).w,d5
		ext.l	d5
		asl.l	#6,d5
		bsr.w	ScrollBlock1
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#4,d6
		bsr.w	ScrollBlock5
		move.w	(Camera_BG_Y_pos).w,($FFFFF618).w
		move.b	(Scroll_flags_BG).w,d0
		or.b	(Scroll_flags_BG2).w,d0
		move.b	d0,(Scroll_flags_BG3).w
		clr.b	(Scroll_flags_BG).w
		clr.b	(Scroll_flags_BG2).w
		lea	(TempArray_LayerDef).w,a1
		move.w	(Camera_BG_X_pos).w,d0
		neg.w	d0
		move.w	#$12,d1

loc_6078:				; CODE XREF: ROM:0000607Aj
		move.w	d0,(a1)+
		dbf	d1,loc_6078
		move.w	(Camera_BG2_X_pos).w,d0
		neg.w	d0
		move.w	#$1C,d1

loc_6088:				; CODE XREF: ROM:0000608Aj
		move.w	d0,(a1)+
		dbf	d1,loc_6088
		lea	(TempArray_LayerDef).w,a2
		move.w	(Camera_BG_Y_pos).w,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		bra.w	loc_6306

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Deform_TitleScreen:			; CODE XREF: ROM:00003404p

; FUNCTION CHUNK AT 0000620E SIZE 00000056 BYTES

		move.w	(Camera_BG_Y_pos).w,($FFFFF618).w
		move.w	(Camera_X_pos).w,d0
		cmpi.w	#$1C00,d0
		bcc.s	loc_60B6
		addq.w	#8,d0

loc_60B6:				; CODE XREF: Deform_TitleScreen+Ej
		move.w	d0,(Camera_X_pos).w
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_X_pos).w,d2
		neg.w	d2
		moveq	#0,d0
		bra.s	TitleDeform
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Deform_EHZ:				; DATA XREF: ROM:Deform_Indexo
		tst.w	(Two_player_mode).w
		bne.w	Deform_EHZ_2P
		move.w	(Camera_BG_Y_pos).w,($FFFFF618).w
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_X_pos).w,d0

		neg.w	d0
		move.w	d0,d2
		swap	d0
TitleDeform:				; CODE XREF: Deform_TitleScreen+22j
	; Top Cloud (unused)
		move.w	#0,d0

		move.w	#22-1,d1
	@LoopScrollCloudsTop:
		move.l	d0,(a1)+
		dbf	d1,@LoopScrollCloudsTop

	; Big Cloud
		move.w	d2,d0
		asr.w	#6,d0

		move.w	#58-1,d1
	@LoopScrollCloudsBig:
		move.l	d0,(a1)+
		dbf	d1,@LoopScrollCloudsBig

	; Water Ripple
		move.w	d0,d3
		move.b	(Vint_runcount+3).w,d1
		andi.w	#3,d1	; used to be 7
		bne.s	@WaterRippleTimer
		subq.w	#1,(TempArray_LayerDef).w
	@WaterRippleTimer:
		move.w	(TempArray_LayerDef).w,d1
		andi.w	#$1F,d1
		lea	(SwScrl_RippleData).l,a2
		lea	(a2,d1.w),a2

		move.w	#22-1,d1
	@LoopScrollWaterRipple:
		move.b	(a2)+,d0
		ext.w	d0
		add.w	d3,d0
		move.l	d0,(a1)+
		dbf	d1,@LoopScrollWaterRipple

	; Water Cloud (unused)
		move.w	#0,d0

		move.w	#10-1,d1
	@LoopScrollWaterCloud:
		move.l	d0,(a1)+
		dbf	d1,@LoopScrollWaterCloud

	; Hills Top
		move.w	d2,d0
		asr.w	#4,d0

		move.w	#16-1,d1
	@LoopHillsTop:
		move.l	d0,(a1)+
		dbf	d1,@LoopHillsTop

	; Hills Bottom	
		move.w	d2,d0
		asr.w	#4,d0
		move.w	d0,d1
		asr.w	#1,d1
		add.w	d1,d0

		move.w	#16-1,d1
	@LoopHillsBottom:
		move.l	d0,(a1)+
		dbf	d1,@LoopHillsBottom

	; Flower Field		
		move.l	d0,d4
		swap	d4
		move.w	d2,d0
		asr.w	#1,d0
		move.w	d2,d1
		asr.w	#3,d1
		sub.w	d1,d0
		ext.l	d0
		asl.l	#5,d0
		divs.w	#48,d0	; '0'
		ext.l	d0
		asl.l	#3,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#3,d3

		move.w	#15-1,d1

	@LoopFlowerField1:			
		move.w	d4,(a1)+
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,@LoopFlowerField1

		move.w	#(18/2)-1,d1
	@LoopFlowerField2:		
		move.w	d4,(a1)+
		move.w	d3,(a1)+
		move.w	d4,(a1)+
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		dbf	d1,@LoopFlowerField2

		move.w	#(44/3)-1,d1
	@LoopFlowerField3:
		move.w	d4,(a1)+
		move.w	d3,(a1)+
		move.w	d4,(a1)+
		move.w	d3,(a1)+
		move.w	d4,(a1)+
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		dbf	d1,@LoopFlowerField3
		rts
; End of function Deform_TitleScreen

; ===========================================================================
SwScrl_RippleData:dc.b   1,  2,  1,  3,  1,  2,  2,  1,  2,  3,  1,  2,  1,  2,  0,  0; 0
					; DATA XREF: Deform_TitleScreen+74o
					; sub_6264+28t
		dc.b   2,  0,  3,  2,  2,  3,  2,  2,  1,  3,  0,  0,  1,  0,  1,  3; 16
		dc.b   1,  2,  1,  3,  1,  2,  2,  1,  2,  3,  1,  2,  1,  2,  0,  0; 32
		dc.b   2,  0,  3,  2,  2,  3,  2,  2,  1,  3,  0,  0,  1,  0,  1,  3; 48
; ===========================================================================
; START	OF FUNCTION CHUNK FOR Deform_TitleScreen

Deform_EHZ_2P:	
		move.b	(Vint_runcount+3).w,d1
		andi.w	#7,d1
		bne.s	loc_621C
		subq.w	#1,(TempArray_LayerDef).w

loc_621C:	
		move.w	(Camera_BG_Y_pos).w,($FFFFF618).w
		andi.l	#$FFFEFFFE,(Vscroll_Factor).w
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_X_pos).w,d0
		move.w	#(22/2)-1,d1
		bsr.s	sub_6264
		moveq	#0,d0
		move.w	d0,($FFFFF620).w
		subi.w	#224,($FFFFF620).w
		move.w	(Camera_Y_pos_P2).w,($FFFFF61E).w
		subi.w	#224,($FFFFF61E).w
		andi.l	#$FFFEFFFE,($FFFFF61E).w
		lea	($FFFFE1B0).w,a1
		move.w	(Camera_X_pos_P2).w,d0
		move.w	#((8+22)/2)-1,d1	; account for seperation
; END OF FUNCTION CHUNK	FOR Deform_TitleScreen


sub_6264:
		neg.w	d0
		move.w	d0,d2
		swap	d0

	; Top Cloud (unused)
		move.w	#0,d0

	@LoopScrollCloudsTop:
		move.l	d0,(a1)+
		dbf	d1,@LoopScrollCloudsTop

	; Big Cloud
		move.w	d2,d0
		asr.w	#6,d0

		move.w	#(58/2)-1,d1
	@LoopScrollCloudsBig:
		move.l	d0,(a1)+
		dbf	d1,@LoopScrollCloudsBig

	; Water Ripple
		move.w	d0,d3
		move.w	(TempArray_LayerDef).w,d1
		andi.w	#$1F,d1
		lea	SwScrl_RippleData(pc),a2
		lea	(a2,d1.w),a2

		move.w	#(22/2)-1,d1
	@LoopScrollWaterRipple:	
		move.b	(a2)+,d0
		ext.w	d0
		add.w	d3,d0
		move.l	d0,(a1)+
		dbf	d1,@LoopScrollWaterRipple

	; Water Cloud (unused)
		move.w	#0,d0

		move.w	#(10/2)-1,d1
	@LoopScrollWaterCloud:
		move.l	d0,(a1)+
		dbf	d1,@LoopScrollWaterCloud

	; Hills Top
		move.w	d2,d0
		asr.w	#4,d0

		move.w	#(16/2)-1,d1
	@LoopHillsTop:
		move.l	d0,(a1)+
		dbf	d1,@LoopHillsTop

	; Hills Bottom
		move.w	d2,d0
		asr.w	#4,d0
		move.w	d0,d1
		asr.w	#1,d1
		add.w	d1,d0

		move.w	#(16/2)-1,d1
@LoopHillsBottom:
		move.l	d0,(a1)+
		dbf	d1,@LoopHillsBottom

	; Flower Field
		move.w	d2,d0
		asr.w	#1,d0
		move.w	d2,d1
		asr.w	#3,d1
		sub.w	d1,d0
		ext.l	d0
		asl.l	#8,d0
		divs.w	#48,d0
		ext.l	d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#3,d3

		move.w	#(80/2)-1,d1
@LoopFlowerField:
		move.w	d2,(a1)+
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,@LoopFlowerField

		rts
; End of function sub_6264

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6306:				; CODE XREF: ROM:000060A0j
					; ROM:0000640Cj
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	#$E,d1
		move.w	(Camera_X_pos).w,d0
		neg.w	d0
		swap	d0
		andi.w	#$F,d2
		add.w	d2,d2
		move.w	(a2)+,d0
		jmp	loc_6324(pc,d2.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6322:				; CODE XREF: ROM:00006344j
		move.w	(a2)+,d0

loc_6324:
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		dbf	d1,loc_6322
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Deform_HPZ:				; DATA XREF: ROM:Deform_Indexo
		move.w	(Camera_X_pos_diff).w,d4
		ext.l	d4
		asl.l	#6,d4
		moveq	#2,d6
		bsr.w	ScrollBlock4
		move.w	(Camera_Y_pos_diff).w,d5
		ext.l	d5
		asl.l	#7,d5
		moveq	#6,d6
		bsr.w	ScrollBlock2
		move.w	(Camera_BG_Y_pos).w,($FFFFF618).w
		lea	(TempArray_LayerDef).w,a1
		move.w	(Camera_X_pos).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#1,d0
		move.w	#7,d1

loc_637E:				; CODE XREF: ROM:00006380j
		move.w	d0,(a1)+
		dbf	d1,loc_637E
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#8,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		lea	(TempArray_LayerDef+$60).w,a2
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,(a1)+
		move.w	d3,(a1)+
		move.w	d3,(a1)+
		move.w	d3,-(a2)
		move.w	d3,-(a2)
		move.w	d3,-(a2)
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,(a1)+
		move.w	d3,(a1)+
		move.w	d3,-(a2)
		move.w	d3,-(a2)
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,(a1)+
		move.w	d3,-(a2)
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,(a1)+
		move.w	d3,-(a2)
		move.w	(Camera_BG_X_pos).w,d0
		neg.w	d0
		move.w	#$19,d1

loc_63E0:				; CODE XREF: ROM:000063E2j
		move.w	d0,(a1)+
		dbf	d1,loc_63E0
		adda.w	#$E,a1
		move.w	d2,d0
		asr.w	#1,d0
		move.w	#$17,d1

loc_63F2:				; CODE XREF: ROM:000063F4j
		move.w	d0,(a1)+
		dbf	d1,loc_63F2
		lea	(TempArray_LayerDef).w,a2
		move.w	(Camera_BG_Y_pos).w,d0
		move.w	d0,d2
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		bra.w	loc_6306
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Deform_HTZ:				; DATA XREF: ROM:Deform_Indexo
		move.w	(Camera_BG_Y_pos).w,($FFFFF618).w
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_X_pos).w,d0
		neg.w	d0
		move.w	d0,d2
		swap	d0
		move.w	d2,d0
		asr.w	#3,d0
		move.w	#$7F,d1	; ''

loc_642C:				; CODE XREF: ROM:0000642Ej
		move.l	d0,(a1)+
		dbf	d1,loc_642C
		move.l	d0,d4
		move.w	d2,d0
		asr.w	#1,d0
		move.w	d2,d1
		asr.w	#3,d1
		sub.w	d1,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$18,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#3,d3
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,d4
		move.l	d4,(a1)+
		move.l	d4,(a1)+
		move.l	d4,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,d4
		move.l	d4,(a1)+
		move.l	d4,(a1)+
		move.l	d4,(a1)+
		move.l	d4,(a1)+
		move.l	d4,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		move.w	d3,d4
		move.w	#6,d1

loc_647E:				; CODE XREF: ROM:00006480j
		move.l	d4,(a1)+
		dbf	d1,loc_647E
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		move.w	d3,d4
		move.w	#7,d1

loc_6492:				; CODE XREF: ROM:00006494j
		move.l	d4,(a1)+
		dbf	d1,loc_6492
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		move.w	d3,d4
		move.w	#9,d1

loc_64A6:				; CODE XREF: ROM:000064A8j
		move.l	d4,(a1)+
		dbf	d1,loc_64A6
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		move.w	d3,d4
		move.w	#$E,d1

loc_64BC:				; CODE XREF: ROM:000064BEj
		move.l	d4,(a1)+
		dbf	d1,loc_64BC
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		move.w	#2,d2

loc_64D0:				; CODE XREF: ROM:000064E8j
		move.w	d3,d4
		move.w	#$F,d1

loc_64D6:				; CODE XREF: ROM:000064D8j
		move.l	d4,(a1)+
		dbf	d1,loc_64D6
		swap	d3
		add.l	d0,d3
		add.l	d0,d3
		add.l	d0,d3
		add.l	d0,d3
		swap	d3
		dbf	d2,loc_64D0
		rts