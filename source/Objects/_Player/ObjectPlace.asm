; ===========================================================================
; ---------------------------------------------------------------------------
; When debug mode is currently in use, you can actually find the original
; source code for it within the leftovers at $50A9C, which includes the
; code that has been commented out below
; ---------------------------------------------------------------------------

DebugMode:
		moveq	#0,d0
		move.b	(Debug_placement_mode).w,d0
		move.w	DebugIndex(pc,d0.w),d1
		jmp	DebugIndex(pc,d1.w)
; ===========================================================================
DebugIndex:	dc.w Debug_Init-DebugIndex
		dc.w Debug_Main-DebugIndex
; ===========================================================================
Debug_Init:
		addq.b	#2,(Debug_placement_mode).w
		move.w	(Camera_Min_Y_pos).w,(Camera_Min_Y_pos_Copy).w
		move.w	(Camera_Max_Y_pos).w,(Camera_Max_Y_pos_Copy).w
		tst.w	(Camera_Min_Y_pos).w	; check Vertical Wrap
		bmi.s	@VerticalWrap		; skip code so bounds don't get messed with
		move.w	#0,(Camera_Min_Y_pos).w
		move.w	#$3FFF,(Camera_Max_Y_pos).w	; Final Sonic 2 debug, used to be $720
	@VerticalWrap:
		andi.w	#$7FF,(MainCharacter+y_pos).w
		andi.w	#$7FF,(Camera_Y_pos).w
		andi.w	#$3FF,(Camera_BG_Y_pos).w
		move.b	#0,mapping_frame(a0)
		move.b	#0,anim(a0)

; Debug_CheckSS:
		cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; is this the Special Stage?
		bne.s	loc_1BB04	; if not, branch
		;move.b	#7-1,(Current_Zone).w	; sets the debug object list and resets Special Stage rotation
		;move.w	#0,($FFFFF782).w
		;move.w	#0,($FFFFF780).w
		moveq	#6,d0		; force zone 6's debug object list (was the ending in S1)
		bra.s	loc_1BB0A
; ===========================================================================

loc_1BB04:
		moveq	#0,d0
		move.b	(Current_Zone).w,d0

loc_1BB0A:
		lea	(DebugList).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		cmp.b	(Debug_object).w,d6
		bhi.s	loc_1BB24
		move.b	#0,(Debug_object).w

loc_1BB24:
		bsr.w	LoadDebugObjectSprite
		move.b	#$C,(Debug_Accel_Timer).w
		move.b	#1,(Debug_Speed).w

Debug_Main:
		moveq	#6,d0		; force zone 6's debug object list (was the ending in S1)
		cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; is this the Special Stage?
		beq.s	loc_1BB44	; if yes, branch

		moveq	#0,d0
		move.b	(Current_Zone).w,d0

loc_1BB44:
		lea	(DebugList).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		bsr.w	Debug_Control
		;bsr.w	dirsprset		; I have no idea what this branches to, since it can't be found within the symbol tables
		jmp	(DisplaySprite).l

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Debug_Control:
		moveq	#0,d4
		move.w	#1,d1
		move.b	(Ctrl_1_Press).w,d4
		andi.w	#btnDir,d4
		bne.s	Debug_Move
		move.b	(Ctrl_1_Held).w,d0
		andi.w	#btnDir,d0
		bne.s	Debug_ContinueMoving
		move.b	#$C,(Debug_Accel_Timer).w
		move.b	#$F,(Debug_Speed).w
		bra.w	Debug_ControlObjects
; ===========================================================================
; loc_1BB86:
Debug_ContinueMoving:
		subq.b	#1,(Debug_Accel_Timer).w
		bne.s	Debug_TimerNotOver
		move.b	#1,(Debug_Accel_Timer).w
		addq.b	#1,(Debug_Speed).w
		;cmpi.b	#-1,(Debug_Speed).w	; this effectively resets the Debug movement speed when it reaches 255
		bne.s	Debug_Move
		move.b	#-1,(Debug_Speed).w
; loc_1BB9E:
Debug_Move:
		move.b	(Ctrl_1_Held).w,d4
; loc_1BBA2:
Debug_TimerNotOver:
		moveq	#0,d1
		move.b	(Debug_Speed).w,d1
		addq.w	#1,d1
		swap	d1
		asr.l	#4,d1
		move.l	y_pos(a0),d2
		move.l	x_pos(a0),d3

		; move up
		btst	#bitUp,d4
		beq.s	loc_1BBC2
		sub.l	d1,d2
		bcc.s	loc_1BBC2
		moveq	#0,d2

loc_1BBC2:
		; move down
		btst	#bitDn,d4
		beq.s	loc_1BBD8
		add.l	d1,d2
		cmpi.l	#$7FF0000,d2
		bcs.s	loc_1BBD8
		move.l	#$7FF0000,d2

loc_1BBD8:
		; move left
		btst	#bitL,d4
		beq.s	loc_1BBE4
		sub.l	d1,d3
		bcc.s	loc_1BBE4
		moveq	#0,d3

loc_1BBE4:
		; move right
		btst	#bitR,d4
		beq.s	loc_1BBEC
		add.l	d1,d3

loc_1BBEC:
		move.l	d2,y_pos(a0)
		move.l	d3,x_pos(a0)
; loc_1BBF4:
Debug_ControlObjects:
		btst	#bitA,(Ctrl_1_Held).w
		beq.s	Debug_SpawnObject
		btst	#bitC,(Ctrl_1_Press).w
		beq.s	Debug_CycleObjects
		; cycle backwards through the object list
		subq.b	#1,(Debug_object).w
		bcc.s	loc_1BC28
		add.b	d6,(Debug_object).w
		bra.s	loc_1BC28
; ===========================================================================
; loc_1BC10:
Debug_CycleObjects:
		btst	#bitA,(Ctrl_1_Press).w
		beq.s	Debug_SpawnObject
		addq.b	#1,(Debug_object).w
		cmp.b	(Debug_object).w,d6
		bhi.s	loc_1BC28
		move.b	#0,(Debug_object).w

loc_1BC28:
		bra.w	LoadDebugObjectSprite
; ===========================================================================
; loc_1BC2C:
Debug_SpawnObject:
		btst	#bitC,(Ctrl_1_Press).w
		beq.s	Debug_ExitDebugMode
		; spawn object
		jsr	(SingleObjLoad).l
		bne.s	Debug_ExitDebugMode
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	mappings(a0),id(a1) ; load obj
		move.b	render_flags(a0),render_flags(a1)
		move.b	render_flags(a0),status(a1)
		andi.b	#$7F,status(a1)
		moveq	#0,d0
		move.b	(Debug_object).w,d0
		lsl.w	#3,d0
		move.b	4(a2,d0.w),$28(a1)
		rts
; ===========================================================================
; loc_1BC70:
Debug_ExitDebugMode:
		btst	#bitB,(Ctrl_1_Press).w
		beq.s	locret_1BCCA
		; exit Debug Mode
		moveq	#0,d0
		move.w	d0,(Debug_placement_mode).w
		move.l	#Map_Sonic,(MainCharacter+mappings).w
		move.w	#$780,(MainCharacter+art_tile).w
		tst.w	(Two_player_mode).w
		beq.s	loc_1BC98
		move.w	#$3C0,(MainCharacter+art_tile).w

loc_1BC98:
		move.b	d0,(MainCharacter+anim).w
		move.w	d0,x_sub(a0)
		move.w	d0,y_sub(a0)
		move.w	(Camera_Min_Y_pos_Copy).w,(Camera_Min_Y_pos).w
		move.w	(Camera_Max_Y_pos_Copy).w,(Camera_Max_Y_pos).w
		cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; is this the Special Stage?
		bne.s	locret_1BCCA		; if not, branch

		;clr.w	($FFFFF780).w		; again, this resets the Special Stage rotation
		;move.w	#$40,($FFFFF782).w	; and Sonic's art for whatever reason
		;move.l	#Map_Sonic,($FFFFD004).w
		;move.w	#$780,($FFFFD002).w

		move.b	#2,(MainCharacter+anim).w
		bset	#2,(MainCharacter+status).w
		bset	#1,(MainCharacter+status).w

locret_1BCCA:
		rts
; End of function Debug_Control
		include	"Level\Level Debug List.asm"