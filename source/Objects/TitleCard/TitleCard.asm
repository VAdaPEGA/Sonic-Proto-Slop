;----------------------------------------------------
; Title cards, Game Over and results screen
;----------------------------------------------------

Obj34:	
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj34_Index(pc,d0.w),d1
		jmp	Obj34_Index(pc,d1.w)
; ===========================================================================
Obj34_Index:	dc.w Obj34_CheckLZ4-Obj34_Index
		dc.w Obj34_CheckPos-Obj34_Index
		dc.w Obj34_Wait-Obj34_Index
		dc.w Obj34_Wait-Obj34_Index

		dc.w Obj3A_ChkPLC-Obj34_Index
		dc.w Obj3A_ChkPos-Obj34_Index
		dc.w Obj3A_Wait-Obj34_Index
		dc.w Obj3A_TimeBonus-Obj34_Index
		dc.w Obj3A_Wait-Obj34_Index
		dc.w Obj3A_NextLevel-Obj34_Index

Obj34_card_mainX:	equ $30		; position for card to display on
Obj34_card_finalX:	equ $32		; position for card to finish on
Obj34_card_timer:	equ $34		; timer for if the title card is spawned in from mid level ala sonic 3
; ===========================================================================

Obj34_CheckLZ4:	
		movea.l	a0,a1
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		move.w	d0,d2
		lea	(Obj34_Config).l,a3
		lsl.w	#4,d0
		adda.w	d0,a3
		lea	(Obj34_ItemData).l,a2
		moveq	#3,d1

Obj34_Loop:				
		move.b	#ObjID_TitleCard,id(a1)
		move.w	(a3),x_pixel(a1)
		move.w	(a3)+,Obj34_card_finalX(a1)
		move.w	(a3)+,Obj34_card_mainX(a1)

		move.w	(a2)+,y_pixel(a1)
		move.b	(a2)+,routine(a1)
		move.b	(a2)+,d0
		cmpi.b	#$12,d0
		bne.s	Obj34_ActNumber
		add.b	d2,d0

Obj34_ActNumber:			
		tst.b	d0
		bne.s	Obj34_MakeSprite
		add.b	(Current_Act).w,d0
		cmpi.b	#3,(Current_Act).w
		bne.s	Obj34_MakeSprite
		subq.b	#1,d0

Obj34_MakeSprite:	
		move.b	d0,mapping_frame(a1)
		move.l	#Map_TitleCard,mappings(a1)
		move.w	#$8580,art_tile(a1)
		jsr	Adjust2PArtPointer2
		move.b	#$78,width_pixels(a1)
		move.b	#0,render_flags(a1)
		move.b	#0,priority(a1)
		move.w	#$3C,anim_frame_duration(a1)
		lea	$40(a1),a1
		dbf	d1,Obj34_Loop

Obj34_CheckPos:			
		moveq	#$10,d1
		move.w	Obj34_card_mainX(a0),d0
		cmp.w	x_pixel(a0),d0
		beq.s	loc_B98E
		bge.s	Obj34_Move
		neg.w	d1

Obj34_Move:		
		add.w	d1,x_pixel(a0)

loc_B98E:	
		move.w	x_pixel(a0),d0
		bmi.s	Obj34_NoDisplay
		cmpi.w	#$200,d0
		bcc.s	Obj34_NoDisplay
		jmp	DisplaySprite
; ===========================================================================
Obj34_NoDisplay:	
		rts
; ===========================================================================

Obj34_Wait:				; DATA XREF: ROM:Obj34_Indexo
		tst.w	anim_frame_duration(a0)
		beq.s	Obj34_CheckPos2
		subq.w	#1,anim_frame_duration(a0)
		jmp	DisplaySprite
; ===========================================================================

Obj34_CheckPos2:			; CODE XREF: ROM:0000B9A6j
		tst.b	render_flags(a0)
		bpl.s	Obj34_ChangeArt
		moveq	#$20,d1	; ' '
		move.w	Obj34_card_finalX(a0),d0
		cmp.w	x_pixel(a0),d0
		beq.s	Obj34_ChangeArt
		bge.s	Obj34_Move2
		neg.w	d1

Obj34_Move2:				; CODE XREF: ROM:0000B9C4j
		add.w	d1,x_pixel(a0)
		move.w	x_pixel(a0),d0
		bmi.s	Obj34_NoDisplay2
		cmpi.w	#$200,d0
		bcc.s	Obj34_NoDisplay2
		jmp	DisplaySprite
; ===========================================================================

Obj34_NoDisplay2:	
		rts
; ===========================================================================

Obj34_ChangeArt:	
		cmpi.b	#4,routine(a0)
		bne.s	Obj34_Delete
		moveq	#PLCID_Explode,d0
		jsr	(LoadPLC).l
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		addi.w	#PLCID_GHZAnimals,d0
		jsr	(LoadPLC).l

Obj34_Delete:				
		jmp	DeleteObject


; ---------------------------------------------------------------------------
; Object 3A - End of level results screen
; ---------------------------------------------------------------------------
Obj3A_ChkPLC:
		tst.l	(Plc_Buffer).w
		beq.s	Obj3A_Config
		rts
; ---------------------------------------------------------------------------
; loc_BB64:
Obj3A_Config:
		movea.l	a0,a1
		lea	(Obj34_GotConfig).l,a2
		moveq	#7-1,d1
; loc_BB6E:
Obj3A_Init:
		move.b	#ObjID_TitleCard,id(a1)
		move.w	(a2),x_pixel(a1)
		move.w	(a2)+,$32(a1)
		move.w	(a2)+,$30(a1)
		move.w	(a2)+,y_pixel(a1)
		move.b	(a2)+,routine(a1)
		move.b	(a2)+,d0
		cmpi.b	#6,d0
		bne.s	loc_BB94
		add.b	(Current_Act).w,d0

loc_BB94:
		move.b	d0,mapping_frame(a1)
		move.l	#Map_TitleCard,mappings(a1)
		move.w	#$8580,art_tile(a1)
		jsr	Adjust2PArtPointer2
		move.b	#0,render_flags(a1)
		lea	$40(a1),a1
		dbf	d1,Obj3A_Init
; loc_BBB8:
Obj3A_ChkPos:
		moveq	#$10,d1
		move.w	$30(a0),d0
		cmp.w	x_pixel(a0),d0
		beq.s	loc_BBEA
		bge.s	Obj3A_Move
		neg.w	d1
; loc_BBC8:
Obj3A_Move
		add.w	d1,x_pixel(a0)

loc_BBCC:
		move.w	x_pixel(a0),d0
		bmi.s	locret_BBDE
		cmpi.w	#$200,d0
		bcc.s	locret_BBDE
		jmp	DisplaySprite
; ===========================================================================

locret_BBDE:
		rts
; ===========================================================================

loc_BBE0:
		move.b	#$E,routine(a0)
		bra.w	loc_BCF8
; ===========================================================================

loc_BBEA:
		cmpi.b	#$E,(End_Of_act_Title_Card6+routine).w
		beq.s	loc_BBE0
		cmpi.b	#4,mapping_frame(a0)
		bne.s	loc_BBCC
		addq.b	#2,routine(a0)
		move.w	#$B4,anim_frame_duration(a0)
; loc_BC04:
Obj3A_Wait:
		subq.w	#1,anim_frame_duration(a0)
		bne.s	@display
		addq.b	#2,routine(a0)
	@display:
		jmp	DisplaySprite
; ===========================================================================
Obj3A_TimeBonus:
		jsr	DisplaySprite
		move.b	#1,(Update_Bonus_score).w
		moveq	#0,d0
		tst.w	(Bonus_Countdown_1).w
		beq.s	Obj3A_RingBonus
		addi.w	#$A,d0
		subi.w	#$A,(Bonus_Countdown_1).w
; loc_BC30:
Obj3A_RingBonus:
		tst.w	(Bonus_Countdown_2).w
		beq.s	Obj3A_ChkBonus
		addi.w	#$A,d0
		subi.w	#$A,(Bonus_Countdown_2).w
; loc_BC40:
Obj3A_ChkBonus:
		tst.w	d0
		bne.s	Obj3A_AddBonus
		move.w	#$C5,d0
		jsr	(PlaySound_Special).l
		addq.b	#2,routine(a0)
		cmpi.w	#$501,(Current_ZoneAndAct).w
		bne.s	Obj3A_SetDelay
		addq.b	#4,routine(a0)
; loc_BC5E:
Obj3A_SetDelay:
		move.w	#$B4,anim_frame_duration(a0)

locret_BC64:
		rts
; ===========================================================================
; loc_BC66:
Obj3A_AddBonus:
		jsr	(AddPoints).l
		move.b	($FFFFFE0F).w,d0
		andi.b	#3,d0
		bne.s	locret_BC64
		move.w	#$CD,d0
		jmp	(PlaySound_Special).l
; ===========================================================================
; loc_BC80:
Obj3A_NextLevel:
		move.b	(Current_Zone).w,d0
		andi.w	#7,d0
		lsl.w	#3,d0
		move.b	(Current_Act).w,d1
		andi.w	#3,d1
		add.w	d1,d1
		add.w	d1,d0
		move.w	LevelOrder(pc,d0.w),d0
		move.w	d0,(Current_ZoneAndAct).w
		tst.w	d0
		bne.s	Obj3A_ChkSS
		move.b	#GameModeID_Logo,(Game_Mode).w
		bra.s	locret_BCC2
; ===========================================================================
; loc_BCAA:
Obj3A_ChkSS:
		clr.b	($FFFFFE30).w
		tst.b	($FFFFF7CD).w
		beq.s	loc_BCBC
		move.b	#GameModeID_SpecialStage,(Game_Mode).w
		bra.s	locret_BCC2
; ===========================================================================

loc_BCBC:
		move.b	#1,(Level_Reload).w

locret_BCC2:
		jmp	DisplaySprite
; ===========================================================================
LevelOrder:	include	"Level/Level Order.asm"
; ===========================================================================

loc_BCF8:				; CODE XREF: ROM:0000BBE6j
		moveq	#$20,d1	; ' '
		move.w	$32(a0),d0
		cmp.w	x_pixel(a0),d0
		beq.s	loc_BD1E
		bge.s	loc_BD08
		neg.w	d1

loc_BD08:				; CODE XREF: ROM:0000BD04j
		add.w	d1,x_pixel(a0)
		move.w	x_pixel(a0),d0
		bmi.s	locret_BD1C
		cmpi.w	#$200,d0
		bcc.s	locret_BD1C
		jmp	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_BD1C:				; CODE XREF: ROM:0000BD10j
					; ROM:0000BD16j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BD1E:				; CODE XREF: ROM:0000BD02j
		cmpi.b	#4,mapping_frame(a0)
		bne.w	Obj34_Delete
		addq.b	#2,routine(a0)
		clr.b	($FFFFF7CC).w
		move.w	#$8D,d0	; ''
		jmp	(PlaySound).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		addq.w	#2,(Camera_Max_X_pos).w
		cmpi.w	#$2100,(Camera_Max_X_pos).w
		beq.w	Obj34_Delete
		rts
; ===========================================================================


; ===========================================================================
Obj34_ItemData:	; y-axis position, 	frame number (changes)
		dc.w $D0,		$0212	; Actual Stage Name
		dc.w $E4,		$0211	; Zone
		dc.w $EA,		$0200	; Act number
		dc.w $E0,		$0203	; Oval
; ---------------------------------------------------------------------------
; Title	card configuration data
; Format:
; 4 bytes per item (SSSS EEEE) Start and End X positions
; 4 items per level (GREEN HILL, ZONE, ACT X, oval)
; ---------------------------------------------------------------------------
Obj34_Config:	dc.w 0,	$120, $FEFC, $13C, $414, $154, $214, $154 ; GHZ
		dc.w 0,	$120, $FEF4, $134, $40C, $14C, $20C, $14C ; LZ
		dc.w 0,	$100, $FEE0, $120, $3F8, $138, $1F8, $138 ; MZ
		dc.w 0,	$120, $FEFC, $13C, $414, $154, $214, $154 ; SLZ
		dc.w 0,	$120, $FF04, $144, $41C, $15C, $21C, $15C ; SYZ
		dc.w 0,	$120, $FF04, $144, $41C, $15C, $21C, $15C ; SBZ
		dc.w 0,	$120, $FEE4, $124, $3EC, $3EC, $1EC, $12C ; FZ
; ---------------------------------------------------------------------------
; Results Title Card configuration Data
; ---------------------------------------------------------------------------
Obj34_GotConfig:	
		;    x-start,	x-main,	y-main,
		;				routine, frame number

		dc.w 4,		$124,	$BC			; "SONIC HAS"
		dc.b 				(2+8),	0

		dc.w -$120,	$120,	$D0			; "PASSED"
		dc.b 				(2+8),	1

		dc.w $40C,	$14C,	$D6			; "ACT" 1/2/3
		dc.b 				(2+8),	6

		dc.w $520,	$120,	$EC			; score
		dc.b 				(2+8),	2

		dc.w $540,	$120,	$FC			; time bonus
		dc.b 				(2+8),	3

		dc.w $560,	$120,	$10C			; ring bonus
		dc.b 				(2+8),	4

		dc.w $20C,	$14C,	$CC			; oval
		dc.b 				(2+8),	5



; ===========================================================================
;----------------------------------------------------
; Object 39 - Game over	/ time over
;----------------------------------------------------

Obj39:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj39_Index(pc,d0.w),d1
		jmp	Obj39_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj39_Index:	dc.w loc_BA98-Obj39_Index 
		dc.w loc_BADC-Obj39_Index
		dc.w loc_BAFE-Obj39_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BA98:				; DATA XREF: ROM:Obj39_Indexo
		tst.l	(Plc_Buffer).w
		beq.s	loc_BAA0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BAA0:				; CODE XREF: ROM:0000BA9Cj
		addq.b	#2,routine(a0)
		move.w	#$50,x_pixel(a0) ; 'P'
		btst	#0,mapping_frame(a0)
		beq.s	loc_BAB8
		move.w	#$1F0,8(a0)

loc_BAB8:				; CODE XREF: ROM:0000BAB0j
		move.w	#$F0,y_pixel(a0) ; 'ð'
		move.l	#Map_Obj39,mappings(a0)
		move.w	#$855E,art_tile(a0)
		jsr	Adjust2PArtPointer
		move.b	#0,render_flags(a0)
		move.b	#0,priority(a0)

loc_BADC:				; DATA XREF: ROM:0000BA94o
		moveq	#$10,d1
		cmpi.w	#$120,x_pixel(a0)
		beq.s	loc_BAF2
		bcs.s	loc_BAEA
		neg.w	d1

loc_BAEA:				; CODE XREF: ROM:0000BAE6j
		add.w	d1,x_pixel(a0)
		jmp	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BAF2:				; CODE XREF: ROM:0000BAE4j
		move.w	#$2D0,anim_frame_duration(a0)
		addq.b	#2,routine(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BAFE:				; DATA XREF: ROM:0000BA96o
		move.b	(Ctrl_1_Press).w,d0
		andi.b	#$70,d0	; 'p'
		bne.s	loc_BB1E
		btst	#0,mapping_frame(a0)
		bne.s	loc_BB42
		tst.w	anim_frame_duration(a0)
		beq.s	loc_BB1E
		subq.w	#1,anim_frame_duration(a0)
		jmp	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BB1E:				; CODE XREF: ROM:0000BB06j
					; ROM:0000BB14j
		tst.b	($FFFFFE1A).w
		bne.s	loc_BB38
		move.b	#GameModeID_Logo,(Game_Mode).w	; Normally Continue Screen
		tst.b	($FFFFFE18).w
		bne.s	loc_BB42
		move.b	#GameModeID_Logo,(Game_Mode).w
		bra.s	loc_BB42
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BB38:				; CODE XREF: ROM:0000BB22j
		clr.l	($FFFFFE38).w
		move.b	#1,(Level_Reload).w

loc_BB42:	
		jmp	DisplaySprite

; ===========================================================================
;----------------------------------------------------
; Sonic	1 Object 7E - leftover S1 Special Stage	results
;----------------------------------------------------

S1Obj7E:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	S1Obj7E_Index(pc,d0.w),d1
		jmp	S1Obj7E_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
S1Obj7E_Index:	dc.w loc_BDA6-S1Obj7E_Index
		dc.w loc_BE1E-S1Obj7E_Index
		dc.w loc_BE5C-S1Obj7E_Index
		dc.w loc_BE6A-S1Obj7E_Index
		dc.w loc_BE5C-S1Obj7E_Index
		dc.w loc_BEC4-S1Obj7E_Index
		dc.w loc_BE5C-S1Obj7E_Index
		dc.w loc_BECE-S1Obj7E_Index
		dc.w loc_BE5C-S1Obj7E_Index
		dc.w loc_BEC4-S1Obj7E_Index
		dc.w loc_BEF2-S1Obj7E_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BDA6:				; DATA XREF: ROM:S1Obj7E_Indexo
		tst.l	(Plc_Buffer).w
		beq.s	loc_BDAE
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BDAE:				; CODE XREF: ROM:0000BDAAj
		movea.l	a0,a1
		lea	(S1Obj7E_Conf).l,a2
		moveq	#3,d1
		cmpi.w	#$32,(Ring_count).w ; '2'
		bcs.s	loc_BDC2
		addq.w	#1,d1

loc_BDC2:				; CODE XREF: ROM:0000BDBEj
					; ROM:0000BDF8j
		move.b	#$7E,id(a1) ; '~'
		move.w	(a2)+,x_pixel(a1)
		move.w	(a2)+,$30(a1)
		move.w	(a2)+,y_pixel(a1)
		move.b	(a2)+,routine(a1)
		move.b	(a2)+,mapping_frame(a1)
		move.l	#Map_TitleCard,mappings(a1)
		move.w	#$8580,art_tile(a1)
		jsr	Adjust2PArtPointer2
		move.b	#0,render_flags(a1)
		lea	$40(a1),a1
		dbf	d1,loc_BDC2
		moveq	#7,d0
		move.b	($FFFFFE57).w,d1
		beq.s	loc_BE1A
		moveq	#0,d0
		cmpi.b	#6,d1
		bne.s	loc_BE1A
		moveq	#8,d0
		move.w	#$18,x_pixel(a0)
		move.w	#$118,$30(a0)

loc_BE1A:				; CODE XREF: ROM:0000BE02j
					; ROM:0000BE0Aj
		move.b	d0,mapping_frame(a0)

loc_BE1E:				; DATA XREF: ROM:0000BD92o
		moveq	#$10,d1
		move.w	$30(a0),d0
		cmp.w	x_pixel(a0),d0
		beq.s	loc_BE44
		bge.s	loc_BE2E
		neg.w	d1

loc_BE2E:				; CODE XREF: ROM:0000BE2Aj
		add.w	d1,x_pixel(a0)

loc_BE32:				; CODE XREF: ROM:0000BE4Aj
		move.w	x_pixel(a0),d0
		bmi.s	locret_BE42
		cmpi.w	#$200,d0
		bcc.s	locret_BE42
		jmp	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_BE42:				; CODE XREF: ROM:0000BE36j
					; ROM:0000BE3Cj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BE44:				; CODE XREF: ROM:0000BE28j
		cmpi.b	#2,mapping_frame(a0)
		bne.s	loc_BE32
		addq.b	#2,routine(a0)
		move.w	#$B4,anim_frame_duration(a0) ; '´'
		move.b	#$7F,(Object_Space+$800).w ; ''

loc_BE5C:				; DATA XREF: ROM:0000BD94o
					; ROM:0000BD98o ...
		subq.w	#1,anim_frame_duration(a0)
		bne.s	loc_BE66
		addq.b	#2,routine(a0)

loc_BE66:				; CODE XREF: ROM:0000BE60j
		jmp	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BE6A:				; DATA XREF: ROM:0000BD96o
		bsr.s	loc_BE66
		move.b	#1,(Update_Bonus_score).w
		tst.w	(Bonus_Countdown_2).w
		beq.s	loc_BE9C
		subi.w	#$A,(Bonus_Countdown_2).w
		moveq	#$A,d0
		jsr	(AddPoints).l
		move.b	($FFFFFE0F).w,d0
		andi.b	#3,d0
		bne.s	locret_BEC2
		move.w	#$CD,d0	; 'Í'
		jmp	(PlaySound_Special).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BE9C:				; CODE XREF: ROM:0000BE78j
		move.w	#$C5,d0	; 'Å'
		jsr	(PlaySound_Special).l
		addq.b	#2,routine(a0)
		move.w	#$B4,anim_frame_duration(a0) ; '´'
		cmpi.w	#$32,(Ring_count).w ; '2'
		bcs.s	locret_BEC2
		move.w	#$3C,anim_frame_duration(a0) ; '<'
		addq.b	#4,routine(a0)

locret_BEC2:				; CODE XREF: ROM:0000BE90j
					; ROM:0000BEB6j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BEC4:				; DATA XREF: ROM:0000BD9Ao
					; ROM:0000BDA2o
		move.b	#1,(Level_Reload).w
		jmp	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BECE:				; DATA XREF: ROM:0000BD9Eo
		move.b	#4,(End_Of_act_Title_Card5+mapping_frame).w
		move.b	#$14,(End_Of_act_Title_Card5+routine).w
		move.w	#$BF,d0	; '¿'
		jsr	(PlaySound_Special).l
		addq.b	#2,routine(a0)
		move.w	#$168,anim_frame_duration(a0)
		jmp	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BEF2:				; DATA XREF: ROM:0000BDA4o
		move.b	($FFFFFE0F).w,d0
		andi.b	#$F,d0
		bne.s	loc_BF02
		bchg	#0,mapping_frame(a0)

loc_BF02:				; CODE XREF: ROM:0000BEFAj
		jmp	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
S1Obj7E_Conf:	dc.w   $20, $120,  $C4,	$200; 0	; DATA XREF: ROM:0000BDB0o
		dc.w  $320, $120, $118,	$201; 4
		dc.w  $360, $120, $128,	$202; 8
		dc.w  $1EC, $11C,  $C4,	$203; 12
		dc.w  $3A0, $120, $138,	$206; 16
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------
; Sonic	1 Object 7F - leftover Sonic 1 SS emeralds
;----------------------------------------------------

S1Obj7F:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	S1Obj7F_Index(pc,d0.w),d1
		jmp	S1Obj7F_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
S1Obj7F_Index:	dc.w loc_BF4C-S1Obj7F_Index ; DATA XREF: ROM:S1Obj7F_Indexo
					; ROM:0000BF3Eo
		dc.w loc_BFA6-S1Obj7F_Index
word_BF40:	dc.w $110		; DATA XREF: ROM:0000BF4Et
		dc.w $128
		dc.w $F8
		dc.w $140
		dc.w $E0
		dc.w $158
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_BF4C:				; DATA XREF: ROM:S1Obj7F_Indexo
		movea.l	a0,a1
		lea	word_BF40(pc),a2
		moveq	#0,d2
		moveq	#0,d1
		move.b	($FFFFFE57).w,d1
		subq.b	#1,d1
		bcs.w	Obj34_Delete

loc_BF60:				; CODE XREF: ROM:0000BFA2j
		move.b	#$7F,id(a1) ; ''
		move.w	(a2)+,x_pixel(a1)
		move.w	#$F0,y_pixel(a1) ; 'ð'
		lea	($FFFFFE58).w,a3
		move.b	(a3,d2.w),d3
		move.b	d3,mapping_frame(a1)
		move.b	d3,anim(a1)
		addq.b	#1,d2
		addq.b	#2,routine(a1)
		move.l	#Map_S1Obj7F,mappings(a1)
		move.w	#$8541,art_tile(a1)
		jsr	Adjust2PArtPointer2
		move.b	#0,render_flags(a1)
		lea	$40(a1),a1
		dbf	d1,loc_BF60

loc_BFA6:				; DATA XREF: ROM:0000BF3Eo
		move.b	mapping_frame(a0),d0
		move.b	#6,mapping_frame(a0)
		cmpi.b	#6,d0
		bne.s	loc_BFBC
		move.b	anim(a0),mapping_frame(a0)

loc_BFBC:				; CODE XREF: ROM:0000BFB4j
		jmp	DisplaySprite
