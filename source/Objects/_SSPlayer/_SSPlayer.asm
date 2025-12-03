; ===========================================================================
; ---------------------------------------------------------------------------
; Object 09 - Sonic in Special Stage
; ---------------------------------------------------------------------------
Obj09:	
		tst.w	(Debug_placement_mode).w
		beq.s	Obj09_Normal
		bsr.w	S1SS_FixCamera
		bra.w	DebugMode
; ===========================================================================
Obj09_Normal:	
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex	 Obj09_Init
	GenerateIndex	 Obj09_Main
	GenerateIndex	 Obj09_ExitTransition
	GenerateIndex	 Obj09_ExitSpecialStage
; ===========================================================================
Obj09_Init:	
		addq.b	#2,routine(a0)
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.l	#Map_Sonic,mappings(a0)
		move.w	#$780,art_tile(a0)
		jsr	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#0,priority(a0)
		move.b	#2,anim(a0)
		bset	#2,status(a0)
		bset	#1,status(a0)

Obj09_Main:	
		tst.w	(Debug_mode_flag).w
		beq.s	@NoObjectPlace
		btst	#bitB,(Ctrl_1_Press).w
		beq.s	@NoObjectPlace
		move.w	#1,(Debug_placement_mode).w
	@NoObjectPlace:	
		move.b	#0,$30(a0)
		moveq	#0,d0
		move.b	status(a0),d0
		andi.w	#2,d0
		move.w	@Index(pc,d0.w),d1
		jsr	@Index(pc,d1.w)
		jsr	(LoadSonicDynPLC).l
		jmp	(DisplaySprite).l
; ===========================================================================
		IndexStart
	GenerateIndex	 Obj09_OnWall
	GenerateIndex	 Obj09_InAir
; ===========================================================================

Obj09_OnWall:		
		bsr.w	Obj09_Jump
		bsr.w	Obj09_Move
		bsr.w	Obj09_Fall
		bra.s	Obj09_Display
; ===========================================================================

Obj09_InAir:	
		bsr.w	Obj09_LimitHeight
		bsr.w	Obj09_Move
		bsr.w	Obj09_Fall

Obj09_Display:		
		bsr.w	Obj09_ChkItems
		bsr.w	Obj09_ChkItems2
		jsr	(ObjectMove).l
		bsr.w	S1SS_FixCamera
		move.w	(Special_Stage_Angle).w,d0
		add.w	(Special_Stage_Speed).w,d0
		move.w	d0,(Special_Stage_Angle).w
		jmp	(Sonic_Animate).l

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj09_Move:	
		btst	#bitL,(Ctrl_1_Held_Logical).w
		beq.s	@CheckRight
		bsr.w	Obj09_MoveLeft

	@CheckRight:
		btst	#bitR,(Ctrl_1_Held_Logical).w
		beq.s	@CheckNone
		bsr.w	Obj09_MoveRight

	@CheckNone:
		move.b	(Ctrl_1_Held_Logical).w,d0
		andi.b	#btnL+btnR,d0
		bne.s	loc_1A4E0
		move.w	ground_speed(a0),d0
		beq.s	loc_1A4E0
		bmi.s	loc_1A4D2
		subi.w	#$C,d0
		bcc.s	loc_1A4CC
		move.w	#0,d0

loc_1A4CC:	
		move.w	d0,ground_speed(a0)
		bra.s	loc_1A4E0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1A4D2:	
		addi.w	#$C,d0
		bcc.s	loc_1A4DC
		move.w	#0,d0

loc_1A4DC:	
		move.w	d0,ground_speed(a0)

loc_1A4E0:	
		move.b	(Special_Stage_Angle).w,d0
		addi.b	#$20,d0	; ' '
		andi.b	#$C0,d0
		neg.b	d0
		jsr	(CalcSine).l
		muls.w	ground_speed(a0),d0
		add.l	d0,x_pos(a0)
		muls.w	ground_speed(a0),d1
		add.l	d1,y_pos(a0)

		movem.l	d0-d1,-(sp)
		move.l	y_pos(a0),d2
		move.l	x_pos(a0),d3
		bsr.w	sub_1A720
		beq.s	loc_1A52A

		movem.l	(sp)+,d0-d1
		sub.l	d0,x_pos(a0)
		sub.l	d1,y_pos(a0)
		move.w	#0,ground_speed(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1A52A:				; CODE XREF: Obj09_Move+7Cj
		movem.l	(sp)+,d0-d1
		rts
; End of function Obj09_Move


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj09_MoveLeft:				; CODE XREF: Obj09_Move+8p
		bset	#0,status(a0)
		move.w	ground_speed(a0),d0
		beq.s	loc_1A53E
		bpl.s	loc_1A552

loc_1A53E:				; CODE XREF: Obj09_MoveLeft+Aj
		subi.w	#$C,d0
		cmpi.w	#$F800,d0
		bgt.s	loc_1A54C
		move.w	#$F800,d0

loc_1A54C:				; CODE XREF: Obj09_MoveLeft+16j
		move.w	d0,ground_speed(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1A552:				; CODE XREF: Obj09_MoveLeft+Cj
		subi.w	#$40,d0
;		bcc.s	loc_1A55A


loc_1A55A:				; CODE XREF: Obj09_MoveLeft+26j
		move.w	d0,ground_speed(a0)
		rts
; End of function Obj09_MoveLeft


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj09_MoveRight:			; CODE XREF: Obj09_Move+14p
		bclr	#0,status(a0)
		move.w	ground_speed(a0),d0
		bmi.s	loc_1A580
		addi.w	#$C,d0
		cmpi.w	#$800,d0
		blt.s	loc_1A57A
		move.w	#$800,d0

loc_1A57A:				; CODE XREF: Obj09_MoveRight+14j
		move.w	d0,ground_speed(a0)
		bra.s	locret_1A58C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1A580:				; CODE XREF: Obj09_MoveRight+Aj
		addi.w	#$40,d0
;		bcc.s	loc_1A588


loc_1A588:				; CODE XREF: Obj09_MoveRight+24j
		move.w	d0,ground_speed(a0)

locret_1A58C:				; CODE XREF: Obj09_MoveRight+1Ej
		rts
; End of function Obj09_MoveRight


; ---------------------------------------------------------------------------

Obj09_Jump:	
		move.b	(Ctrl_1_Press_Logical).w,d0
		andi.b	#btnABC,d0
		beq.s	@DoNothing

		move.b	(Special_Stage_Angle).w,d0
		andi.b	#$FC,d0
		neg.b	d0
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	#$680,d0
		asr.l	#8,d0
		move.w	d0,x_vel(a0)
		muls.w	#$680,d1
		asr.l	#8,d1
		move.w	d1,y_vel(a0)
		bset	#PlayerStatusBitAir,status(a0)
		bset	#7,Status(a0)
		move.w	#$A0,d0
		jmp	(PlaySound_Special).l
	@DoNothing:	
		rts
; End of function Obj09_Jump
; ---------------------------------------------------------------------------
Obj09_LimitHeight:	

		move.b	(Ctrl_1_Press_Logical).w,d0
		andi.b	#btnABC,d0
		beq.s	@DoNothing

		btst	#7,Status(a0)		; did Sonic jump or is he just falling or hit by a bumper?
		beq.s	@doNothing		; if not, branch to return
		move.b	(Special_Stage_Angle).w,d0	; get SS angle

		andi.b	#$FC,d0		; angle is normal	

		neg.b	d0
		subi.b	#$40,d0
		jsr	(CalcSine).l

		move.w	y_vel(a0),d2		; get Y speed
		muls.w	d1,d2			; multiply Y speed by sin
		asr.l	#8,d2			; find the new Y speed
		move.w	x_vel(a0),d3		; get X speed
		muls.w	d0,d3			; multiply X speed by cos
		asr.l	#8,d3			; find the new X speed
		add.w	d2,d3			; combine the two speeds
		cmpi.w	#$400,d3		; compare the combined speed with the jump release speed
		ble.s	@doNothing		; if it's less, branch to return

		muls.w	#$400,d0
		asr.l	#8,d0
		move.w	d0,x_vel(a0)
		muls.w	#$400,d1
		asr.l	#8,d1
		move.w	d1,y_vel(a0)		; set the speed to the jump release speed
		bclr	#7,Status(a0)		; clear "Sonic has jumped" flag

	@doNothing:
		rts
; ---------------------------------------------------------------------------

S1SS_FixCamera:	
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		and.w	#$3FF,d2
		and.w	#$3FF,d3	; Fix for wrap around
		move.w	d2,y_pos(a0)
		move.w	d3,x_pos(a0)

		move.w	(Camera_X_pos).w,d0
		subi.w	#320/2,d3
		;bcs.s	loc_1A606
		sub.w	d3,d0
		and.w	#$3FF,d0
		sub.w	d0,(Camera_X_pos).w

loc_1A606:	
		move.w	(Camera_Y_pos).w,d0
		subi.w	#224/2,d2
		;bcs.s	locret_1A616
		sub.w	d2,d0
		and.w	#$3FF,d0
		sub.w	d0,(Camera_Y_pos).w

locret_1A616:	
		rts

; ===========================================================================

Obj09_ExitTransition:	
		addi.w	#$40,(Special_Stage_Speed).w
		cmpi.w	#$1800,(Special_Stage_Speed).w
		bne.s	@SpeedNotReached
		move.b	#GameModeID_Level,(Game_Mode).w

	@SpeedNotReached:	
		cmpi.w	#$3000,(Special_Stage_Speed).w
		blt.s	@IncreaseSpeed
		move.w	#0,(Special_Stage_Speed).w
		move.w	#$4000,(Special_Stage_Angle).w
		addq.b	#2,routine(a0)
		move.w	#60,$38(a0)	; 1 second timer

	@IncreaseSpeed:	
		move.w	(Special_Stage_Angle).w,d0
		add.w	(Special_Stage_Speed).w,d0
		move.w	d0,(Special_Stage_Angle).w
		jsr	(Sonic_Animate).l
		jsr	(LoadSonicDynPLC).l
		bsr.w	S1SS_FixCamera
		jmp	(DisplaySprite).l
; ===========================================================================
Obj09_ExitSpecialStage:	
		subq.w	#1,$38(a0)
		bne.s	@TimerNotExpired
		move.b	#GameModeID_Level,(Game_Mode).w

@TimerNotExpired:	
		jsr	(Sonic_Animate).l
		jsr	(LoadSonicDynPLC).l
		bsr.w	S1SS_FixCamera
		jmp	(DisplaySprite).l

; ===========================================================================
Obj09_Fall:	
		move.l	y_pos(a0),d2
		move.l	x_pos(a0),d3
		move.b	(Special_Stage_Angle).w,d0
		andi.b	#$FC,d0
		jsr	(CalcSine).l
		move.w	x_vel(a0),d4
		ext.l	d4		; extend velocity to long-word	| 0000 XXXX
		asl.l	#8,d4		; bit shift to the left word	| 00XX XX00
		muls.w	#42,d1		; multiply sine by 42
		add.l	d4,d1		; add velocity

		move.w	y_vel(a0),d4
		ext.l	d4		; extend velocity to long-word	| 0000 YYYY
		asl.l	#8,d4		; bit shift to the left word	| 00YY YY00
		muls.w	#42,d0		; multiply cosine by 42
		add.l	d4,d0		; add velocity

		add.l	d1,d3		; add to Sonic's X position
		and.l	#$3FFFFFF,d3
		bsr.w	sub_1A720	; check collision, -1 if touching a block, 0 if not
		beq.s	loc_1A6E8	; if 0, branch
		sub.l	d1,d3		; subtract from X position (undoes addition)
		moveq	#0,d1		; clear d0
		move.w	d1,x_vel(a0)	; reset X velocity
		bclr	#1,status(a0)	; clear jump flag (sonic can jump)
		
		add.l	d0,d2		; add to Sonic's Y position
		and.l	#$3FFFFFF,d2
		bsr.w	sub_1A720	; check collision, -1 if touching a block, 0 if not
		beq.s	loc_1A6FE	; if 0, branch
		sub.l	d0,d2		; subtract from Y position (undoes addition)
		moveq	#0,d0		; clear d0
		move.w	d0,y_vel(a0)	; reset Y velocity
		rts
; ---------------------------------------------------------------------------
loc_1A6E8:	
		add.l	d0,d2
		bsr.w	sub_1A720
		beq.s	loc_1A70C
		sub.l	d0,d2
		moveq	#0,d0
		move.w	d0,y_vel(a0)
		bclr	#1,status(a0)

loc_1A6FE:	
		asr.l	#8,d1
		asr.l	#8,d0
		move.w	d1,x_vel(a0)
		move.w	d0,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_1A70C:	
		asr.l	#8,d1
		asr.l	#8,d0
		move.w	d1,x_vel(a0)
		move.w	d0,y_vel(a0)
		bset	#1,status(a0)
		rts
; ===========================================================================

sub_1A720:	; Moving "downwards"
		lea	(RAM_Start).l,a1
		moveq	#0,d4
		swap	d2
		move.w	d2,d4
		swap	d2
		addi.w	#$44,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		swap	d3
		move.w	d3,d4
		swap	d3
		addi.w	#$14,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		moveq	#0,d5		; non-solid
		move.b	(a1)+,d4
		bsr.s	sub_1A768	; Top Left
		move.b	(a1)+,d4
		bsr.s	sub_1A768	; Top Right
		adda.w	#$7E,a1
		move.b	(a1)+,d4
		bsr.s	sub_1A768	; Bottom Left
		move.b	(a1)+,d4
		bsr.s	sub_1A768	; Bottom Right
		tst.b	d5
		rts
; End of function sub_1A720


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_1A768:	; assign item ID and location to be checked later for special collision
		; stuff that has effects, but is also solid

		beq.s	@DoNothing	; air is not a wall
		cmpi.b	#SSBlockID_1up,d4	; check 1up ID
		beq.s	@DoNothing	; 1up is not a wall
		cmpi.b	#$3A,d4		; before ghost (the visible one)
		; emeralds and ring, but includes other blocks
		bcs.s	@SetCollisionType
		cmpi.b	#$4B,d4		; everything past ghost activation
		; glass transitions
		bcc.s	@OnlySolid
	@DoNothing:
		rts

		; S&K's collision fix
		; only give effect to blocks that have effects, ignore all else
		cmpi.b	#6,(Emerald_count).w 	; do you have 6 emeralds?
		beq.s	@SetCollisionType	; if yes, unfix collision
	
		cmpi.b	#SSBlockID_Bumper,d4	; before bumper (all walls)
		blo.s	@OnlySolid
		cmpi.b	#SSBlockID_W,d4
		beq.s	@OnlySolid	;
		cmpi.b	#SSBlockID_Peppermint,d4
		beq.s	@OnlySolid	;
		
		cmpi.b	#$31,d4		; after glass
		blo.s	@SetCollisionType	;
		cmpi.b	#SSBlockID_Ring,d4	; before ring
		; this includes zone blocks and R / bumper transitions
		blo.s	@OnlySolid
	@SetCollisionType:
		move.b	d4,$30(a0)
		move.l	a1,$32(a0)
	@OnlySolid:
		moveq	#-1,d5		; set as solid
		rts

; ===========================================================================

Obj09_ChkItems:		
		lea	(RAM_Start).l,a1
		moveq	#0,d4
		move.w	y_pos(a0),d4
		addi.w	#$50,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		move.w	x_pos(a0),d4
		addi.w	#$20,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		move.b	(a1),d4
		bne.s	SS_CheckRing
	; Ghoostbusterrrrrs (all has to happen within one frame)
		tst.b	$3A(a0)		; is the ghost marked as "solid"?
		bpl.s	@NotSolid	; if not, branch
		lea	($FF1020).l,a1
		moveq	#64-1,d1
	@Loop2:	moveq	#64-1,d2
	@Loop:
		cmpi.b	#$41,(a1)	; is the item a	ghost block?
		bne.s	@NoReplace	; if not, branch
		move.b	#$2C,(a1)	; replace ghost	block with a solid block

	@NoReplace:
		addq.w	#1,a1
		dbf	d2,@Loop
		lea	$40(a1),a1	; Go to next row
		dbf	d1,@Loop2

	@NotSolid:
		clr.b	$3A(a0)
		rts	

	@DoNothing:
		rts
; ===========================================================================

SS_CheckRing:	
		cmpi.b	#SSBlockID_Ring,d4
		bne.s	SS_Check1UP
		bsr.w	SS_FindFreeAnimSlot
		bne.s	@NoFreeSlot
		move.b	#1,(a2)
		move.l	a1,4(a2)
		jsr	(Collect_Single_Ring).l
		cmpi.w	#50,(Ring_count).w
		bcs.s	@NoContinue
		addq.b	#1,($FFFFFE18).w ; +1 continue
		move.w	#$BF,d0
		jsr	(PlaySound).l
	@NoContinue:	
	@NoFreeSlot:
		rts
; ===========================================================================

SS_Check1UP:	
		cmpi.b	#SSBlockID_1up,d4
		bne.s	SS_CheckEmerald
		bsr.w	SS_FindFreeAnimSlot
		bne.s	loc_1A814
		move.b	#3,(a2)
		move.l	a1,4(a2)

loc_1A814:	
		addq.b	#1,(Life_count).w
		addq.b	#1,(Update_HUD_lives).w
		move.w	#MusID_ExtraLife,d0
		jsr	(PlaySound).l
		rts
; ===========================================================================

SS_CheckEmerald:	
		cmpi.b	#SSBlockID_Emerald,d4
		bcs.s	SS_CheckGhost
		cmpi.b	#SSBlockID_Emerald+5,d4
		bhi.s	SS_CheckGhost
		bsr.w	SS_FindFreeAnimSlot
		bne.s	loc_1A844
		move.b	#5,(a2)
		move.l	a1,4(a2)

loc_1A844:	
		cmpi.b	#6,(Emerald_count).w
		beq.s	loc_1A862
		subi.b	#$3B,d4
		moveq	#0,d0
		move.b	(Emerald_count).w,d0
		lea	(Got_Emeralds_array).w,a2
		move.b	d4,(a2,d0.w)
		addq.b	#1,(Emerald_count).w

loc_1A862:	
		move.w	#$93,d0
		jsr	(PlaySound_Special).l
		rts
; ===========================================================================

SS_CheckGhost:	
		cmpi.b	#$41,d4
		bne.s	loc_1A87C
		move.b	#1,$3A(a0)

loc_1A87C:	
		cmpi.b	#$4A,d4
		bne.s	@DoNothing
		cmpi.b	#1,$3A(a0)
		bne.s	@DoNothing
		st	$3A(a0)
	@DoNothing:	
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj09_ChkItems2:			
		move.b	$30(a0),d0
		bne.s	SS_CheckBumper
		subq.b	#1,$36(a0)
		bpl.s	loc_1A8D8
		move.b	#0,$36(a0)

loc_1A8D8:				
		subq.b	#1,$37(a0)
		bpl.s	locret_1A8E4
		move.b	#0,$37(a0)

locret_1A8E4:			
		rts
; ===========================================================================
SS_CheckBumper:			
		cmpi.b	#SSBlockID_Bumper,d0
		bne.s	SS_CheckGoal
		move.l	$32(a0),d1
		subi.l	#$FFFF0001,d1
		move.w	d1,d2
		andi.w	#$7F,d1
		mulu.w	#$18,d1
		subi.w	#$14,d1
		lsr.w	#7,d2
		andi.w	#$7F,d2
		mulu.w	#$18,d2
		subi.w	#$44,d2
		sub.w	x_pos(a0),d1
		sub.w	y_pos(a0),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		muls.w	#-$700,d0
		asr.l	#8,d0
		move.w	d0,x_vel(a0)
		muls.w	#-$700,d1
		asr.l	#8,d1
		move.w	d1,y_vel(a0)
		bset	#1,status(a0)
		bclr	#7,Status(a0)	; clear "Sonic has jumped" flag
		bsr.w	SS_FindFreeAnimSlot
		bne.s	loc_1A954
		move.b	#2,(a2)
		move.l	$32(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)

loc_1A954:	
		move.w	#$B4,d0	; '´'
		jmp	(PlaySound_Special).l
; ===========================================================================

SS_CheckGoal:	
		cmpi.b	#SSBlockID_Goal,d0
		bne.s	SS_CheckUp
		addq.b	#2,routine(a0)
		move.w	#$A8,d0	; '¨'
		jsr	(PlaySound_Special).l
		rts
; ===========================================================================

SS_CheckUp:	
		cmpi.b	#SSBlockID_Up,d0
		bne.s	SS_CheckDown
		tst.b	$36(a0)
		bne.w	SS_DoNothing
		move.b	#$1E,$36(a0)
		btst	#6,($FFFFF783).w
		beq.s	loc_1A99E
		asl	(Special_Stage_Speed).w
		movea.l	$32(a0),a1
		subq.l	#1,a1
		move.b	#$2A,(a1)

loc_1A99E:	
		move.w	#$A9,d0	; '©'
		jmp	(PlaySound_Special).l
; ===========================================================================

SS_CheckDown:	
		cmpi.b	#SSBlockID_Down,d0
		bne.s	SS_CheckRotate
		tst.b	$36(a0)
		bne.w	SS_DoNothing
		move.b	#$1E,$36(a0)
		btst	#6,($FFFFF783).w
		bne.s	loc_1A9D2
		asr	(Special_Stage_Speed).w
		movea.l	$32(a0),a1
		subq.l	#1,a1
		move.b	#$29,(a1)

loc_1A9D2:	
		move.w	#$A9,d0
		jmp	(PlaySound_Special).l
; ===========================================================================

SS_CheckRotate:	
		cmpi.b	#SSBlockID_Rotate,d0
		bne.s	SS_CheckGlass
		tst.b	$37(a0)
		bne.w	SS_DoNothing
		move.b	#$1E,$37(a0)
		bsr.w	SS_FindFreeAnimSlot
		bne.s	loc_1AA04
		move.b	#4,(a2)
		move.l	$32(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)
	loc_1AA04:	
		neg.w	(Special_Stage_Speed).w
		move.w	#$A9,d0
		jmp	(PlaySound_Special).l
; ===========================================================================

SS_CheckGlass:				; breakable diamond
		cmpi.b	#$2D,d0
		beq.s	@ThisIsGlass
		cmpi.b	#$2E,d0
		beq.s	@ThisIsGlass
		cmpi.b	#$2F,d0
		beq.s	@ThisIsGlass
		cmpi.b	#$30,d0
		bne.s	SS_DoNothing

	@ThisIsGlass:	
		bsr.w	SS_FindFreeAnimSlot
		bne.s	@PlaySound	; if no free slot is available, do nothing

		move.b	#6,(a2)
		movea.l	$32(a0),a1
		subq.l	#1,a1
		move.l	a1,4(a2)	; Address
		move.b	(a1),d0
		addq.b	#1,d0
		cmpi.b	#$30,d0
		bls.s	@NotBroken
		clr.b	d0
	@NotBroken:
		move.b	d0,4(a2)
	@PlaySound:	
		move.w	#$BA,d0	;
		jmp	(PlaySound_Special).l
SS_DoNothing:	
		rts
; End of function Obj09_ChkItems2