; ---------------------------------------------------------------------------
; Object 01 - Sonic
; ---------------------------------------------------------------------------
ObjPlayer:	
		tst.w	(Debug_placement_mode).w	; is debug mode being used?
		beq.s	ObjPlayer_Normal			; if not, branch
		jmp	(DebugMode).l
; ===========================================================================

ObjPlayer_Normal:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
	IndexStart	
	GenerateIndex	 ObjPlayer, Init
	GenerateIndexID	 ObjPlayer, Control
	GenerateIndexID	 ObjPlayer, Hurt
	GenerateIndexID	 ObjPlayer, Dead
; ===========================================================================
; ObjPlayer_Main:
ObjPlayer_Init:
		addq.b	#ObjPlayerID_Control,routine(a0)
		move.b	#$13,y_radius(a0)	; this sets Sonic's collision height (2*pixels)
		move.b	#9,x_radius(a0)
		move.l	#Map_Sonic,mappings(a0)
		;move.l	#Map_Tails,mappings(a0)
		move.w	#VRAM_Plr1/$20,art_tile(a0)
		jsr	Adjust2PArtPointer
		move.b	#2,priority(a0)
		move.b	#$18,width_pixels(a0)
		move.b	#4,render_flags(a0)

		move.b	#30,air_left(a0)

		move.w	#$600,(Sonic_top_speed).w	; set Sonic's top speed
		move.w	#$C,(Sonic_acceleration).w	; set Sonic's acceleration
		move.w	#$80,(Sonic_deceleration).w	; set Sonic's deceleration

		move.b	#$C,top_solid_bit(a0)
		move.b	#$D,lrb_solid_bit(a0)
		move.b	#0,flips_remaining(a0)
		move.b	#4,flip_speed(a0)
		move.w	#0,(Sonic_Pos_Record_Index).w
		move.w	#$40-1,d2

loc_FA88:
		bsr.w	Sonic_RecordPos
		move.w	#0,(a1,d0.w)
		dbf	d2,loc_FA88

; ---------------------------------------------------------------------------
; Normal state for Player
; ---------------------------------------------------------------------------

ObjPlayer_Control:
		tst.w	(Debug_mode_flag).w		; is debug cheat enabled?
		beq.s	loc_FAB0			; if not, branch
		btst	#4,(Ctrl_1_Press).w		; is button B pressed?
		beq.s	loc_FAB0			; if not, branch
		move.w	#1,(Debug_placement_mode).w	; change Player into ring/item
		clr.b	($FFFFF7CC).w			; unlock control
		rts
; -----------------------------------------------------------------------
loc_FAB0:
		tst.b	($FFFFF7CC).w		; are controls locked?
		bne.s	loc_FABC		; if yes, branch
		move.w	(Ctrl_1).w,(Ctrl_1_Logical).w	; copy new held buttons, to enable joypad

loc_FABC:
		btst	#0,obj_control(a0)	; is Sonic interacting with another object that holds him in place or controls his movement somehow?
		bne.s	ObjPlayer_ControlsLock	; if yes, branch to skip Player's control
		moveq	#0,d0
		move.b	status(a0),d0
		andi.w	#6,d0
		add.b	Character(a0),d0
		move.w	ObjPlayer_Modes(pc,d0.w),d1
		jsr	ObjPlayer_Modes(pc,d1.w)	; run Player Control code

		tst.w	(Camera_Min_Y_pos).w	; is vertical wrapping enabled?
		bpl.s	@NoVerticalWrap		; if not, branch
		andi.w	#$7FF,y_pos(a0) 	; perform wrapping of Player's y position
	@NoVerticalWrap:

ObjPlayer_ControlsLock:
		bsr.w	Sonic_Display
		bsr.w	Sonic_RecordPos
		bsr.w	Sonic_Water
		move.b	($FFFFF768).w,next_tilt(a0)
		move.b	($FFFFF76A).w,tilt(a0)
		tst.b	($FFFFF7C7).w
		beq.s	loc_FAFE
		tst.b	anim(a0)
		bne.s	loc_FAFE
		move.b	prev_anim(a0),anim(a0)

loc_FAFE:
		bsr.w	Sonic_Animate
		tst.b	obj_control(a0)
		bmi.s	@IgnoreCollisionWhenPlayerIsLocked
			jsr	TouchResponse
	@IgnoreCollisionWhenPlayerIsLocked:
		bsr.w	Player_CheckChunk
		bra.w	LoadSonicDynPLC
; ===========================================================================
; secondary states under state ObjPlayer_Control
	IndexStart	ObjPlayer_Modes
	; Sonic
	GenerateIndex	ObjPlayer, MdNormal
	GenerateIndex	ObjPlayer, MdAir
	GenerateIndex	ObjPlayer, MdRoll
	GenerateIndex	ObjPlayer, MdJump
	; Boom
	GenerateIndex	ObjPlayer, MdNormal
	GenerateIndex	ObjPlayer, MdAir
	GenerateIndex	ObjPlayer, MdRoll
	GenerateIndex	ObjPlayer, MdJump
	; Tails
	GenerateIndex	ObjPlayer, MdNormal
	GenerateIndex	ObjPlayer, MdAir
	GenerateIndex	ObjPlayer, MdRoll
	GenerateIndex	ObjPlayer, MdJump
	; Hops
	GenerateIndex	ObjPlayer, MdNormal
	GenerateIndex	ObjPlayer, MdAir
	GenerateIndex	ObjPlayer, MdRoll
	GenerateIndex	ObjPlayer, MdJump
	; Tammy
	GenerateIndex	ObjPlayer, MdNormal
	GenerateIndex	ObjPlayer, MdAir
	GenerateIndex	ObjPlayer, MdRoll
	GenerateIndex	ObjPlayer, MdJump
; ===========================================================================
ObjPlayer_WaterResumeMusic:
		cmpi.b	#12,air_left(a0)
		bhi.s	@NotDrowning

		tst.b	($FFFFFE2D).w
		bne.s	ObjPlayer_PlayZoneMusic
		move.w	#MusID_Invincible,d0
		pea	(PlaySound).l
	@NotDrowning:	
		move.b	#30,air_left(a0)
;		clr.b	(MainCharacter_Bubbles+$32).w	; commenting this not only benefits the player with some random extra time, it also saves me headaches :V
		rts
; -----------------------------------------------------------------------
ObjPlayer_PlayZoneMusic:
		tst.b	($FFFFF7AA).w
		beq.s	@NotBoss
		move.w	#MusID_Boss,d0
		bra.s	ObjPlayer_PlaySound
	@NotBoss:
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		cmpi.w	#$103,(Current_ZoneAndAct).w
		bne.s	@NotSBZ3
		moveq	#5,d0
	@NotSBZ3:
		lea	MusicList,a1
		move.b	(a1,d0.w),d0
ObjPlayer_PlaySound:
		jmp	(PlaySound).l
; ===========================================================================

Sonic_Display:
	move.w	invincibility_time(a0),d0	; check invulnerability
	bpl.s	@ChkInv			; if positive, branch
		addq.w	#1,invincibility_time(a0)	; count up (invulnerability is a negative number)
		btst	#2,d0		; is a invulnerability frame to be undisplayed?
		bne.s	@ChkShoes	; if not, branch
		rts	; no display (also no speed shoes check, meaning extra speed time when invulnerability frames happen)
	@ChkInv:
		tst.w	d0	; Checks if invincibility has expired
		beq.s	@ChkShoes
			subq.w	#1,invincibility_time(a0)
			cmpi.w	#60,d0
			bne.s	@ChkShoes
				tst.b	($FFFFF7AA).w	; Boss / right side boundary flag
				bne.s	@ChkShoes
					cmpi.b	#12,air_left(a0)
					bcs.s	@ChkShoes
						bsr.s	ObjPlayer_PlayZoneMusic
		@ChkShoes:	; Checks if Speed Shoes have expired and disables them if they have.
		tst.w	speedshoes_time(a0)
		beq.s	@DoNothing
			subq.w	#1,speedshoes_time(a0)
			bne.s	@DoNothing
			inform	1, "TO DO : Expand Speed shoes related stuff for different characters"
				move.w	#$600,(Sonic_top_speed).w
				move.w	#$C,(Sonic_acceleration).w
				move.w	#$80,(Sonic_deceleration).w
				move.w	#$E3,d0
				jmp	(PlaySound).l
	@DoNothing:
		jmp	(DisplaySprite).l
; End of function Sonic_Display

; ---------------------------------------------------------------------------
; Subroutine to record Sonic's previous positions for invincibility stars
; and input/status flags for Tails' AI to follow
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_FBB2: CopySonicMovesForTails:
Sonic_RecordPos:
		move.w	(Sonic_Pos_Record_Index).w,d0
		lea	(Sonic_Pos_Record_Buf).w,a1
		lea	(a1,d0.w),a1
		move.w	x_pos(a0),(a1)+
		move.w	y_pos(a0),(a1)+
		addq.b	#4,(Sonic_Pos_Record_Index+1).w

		lea	(Sonic_Stat_Record_Buf).w,a1
		move.w	($FFFFF604).w,(a1,d0.w)
		rts
; End of function Sonic_RecordPos

; ===========================================================================
; ---------------------------------------------------------------------------
; Seemingly an earlier subroutine to copy Sonic's status flags for Tails' AI
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Unused_RecordPos:
		move.w	($FFFFEEE0).w,d0
		subq.b	#4,d0
		lea	(Tails_Pos_Record_Buf).w,a1
		lea	(a1,d0.w),a2
		move.w	x_pos(a0),d1
		swap	d1
		move.w	y_pos(a0),d1
		cmp.l	(a2),d1
		beq.s	locret_FC02
		addq.b	#4,d0
		lea	(a1,d0.w),a2
		move.w	x_pos(a0),(a2)+
		move.w	y_pos(a0),(a2)
		addq.b	#4,($FFFFEEE1).w

locret_FC02:
		rts
; End of subroutine Unused_RecordPos

; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_FC06:
Sonic_Water:
		tst.b	(Water_flag).w
		bne.s	ObjPlayer_InWater

locret_FC0A:
		rts
; ---------------------------------------------------------------------------
; loc_FC0E: ObjPlayer_InLevelWithWater:
ObjPlayer_InWater:
		move.w	(Water_Level_1).w,d0
		cmp.w	y_pos(a0),d0	; is Sonic above water?
		bge.s	ObjPlayer_OutWater	; if yes, branch

		bset	#PlayerStatusBitWater,status(a0)	; set underwater flag
		bne.s	locret_FC0A	; if already underwater, branch

		bsr.w	ObjPlayer_WaterResumeMusic
		move.b	#ObjID_BubblesAndCountdown,(MainCharacter_Bubbles).w
		move.b	#$80+1,(MainCharacter_Bubbles+subtype).w	; Countdown Subtype
		move.w	#$300,(Sonic_top_speed).w
		move.w	#6,(Sonic_acceleration).w
		move.w	#$40,(Sonic_deceleration).w
		asr	x_vel(a0)
		asr	y_vel(a0)	; memory oprands can only be shifted one at a time
		asr	y_vel(a0)
		beq.s	locret_FC0A
		move.b	#8,(Water_Splash).w	; splash animation
		move.w	#$AA,d0			; splash sound
		jmp	(PlaySound_Special).l

; ---------------------------------------------------------------------------
; ObjPlayer_NotInWater:
ObjPlayer_OutWater:
		bclr	#PlayerStatusBitWater,status(a0)	; unset underwater flag
		beq.s	locret_FC0A	; if already unset, branch

		bsr.w	ObjPlayer_WaterResumeMusic
		move.w	#$600,(Sonic_top_speed).w
		move.w	#$C,(Sonic_acceleration).w
		move.w	#$80,(Sonic_deceleration).w
		asl	y_vel(a0)
		beq.w	locret_FC0A
		move.b	#8,(Water_Splash).w	; splash animation
		cmpi.w	#-$1000,y_vel(a0)
		bgt.s	loc_FC98
		move.w	#-$1000,y_vel(a0)	; limit upward y velocity exiting the water

loc_FC98:
		move.w	#$AA,d0		; splash sound
		jmp	(PlaySound_Special).l
; End of function Sonic_Water

; ===========================================================================
; ---------------------------------------------------------------------------
; Start of subroutine ObjPlayer_MdNormal
; Called if Sonic is neither airborne nor rolling this frame
; ---------------------------------------------------------------------------

ObjPlayer_MdNormalNoRoll:
		bsr.w	Sonic_Jump
		bra.s	ObjPlayer_MdNormalReturn
ObjPlayer_MdNormal:
		bsr.w	Sonic_CheckSpindash
		bsr.w	Sonic_Jump
ObjPlayer_MdNormalReturn:
		bsr.w	Sonic_SlopeResist
		bsr.w	Sonic_Move
		bsr.w	Sonic_Roll
		bsr.w	Sonic_LevelBound
		jsr	(ObjectMove).l
		bsr.w	AnglePos
		bsr.w	Sonic_SlopeRepel
		rts
; End of subroutine ObjPlayer_MdNormal

; ===========================================================================
; Start of subroutine ObjPlayer_MdAir
; Called if Sonic is airborne, but not in a ball (thus, probably not jumping)
; ObjPlayer_MdJump:
ObjPlayer_MdAir:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_ChgJumpDir
		bsr.w	Sonic_LevelBound
		jsr	(ObjectMoveAndFall).l
		btst	#PlayerStatusBitWater,status(a0)	; is Sonic underwater?
		beq.s	loc_FCEA	; if not, branch
		subi.w	#$28,y_vel(a0)	; reduce gravity by $28 ($38-$28=$10)

loc_FCEA:
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_DoLevelCollision
		rts
; End of subroutine ObjPlayer_MdAir

; ===========================================================================
; Start of subroutine ObjPlayer_MdRoll
; Called if Sonic is in a ball, but not airborne (thus, probably rolling)

ObjPlayer_MdRoll:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_RollRepel
		bsr.w	Sonic_RollSpeed
		bsr.w	Sonic_LevelBound
		jsr	(ObjectMove).l
		bsr.w	AnglePos
		bsr.w	Sonic_SlopeRepel
		rts
; End of subroutine ObjPlayer_MdRoll

; ===========================================================================
; Start of subroutine ObjPlayer_MdJump
; Called if Sonic is in a ball and airborne (he could be jumping but not necessarily)
; Notes: This is identical to ObjPlayer_MdAir, at least at this outer level.
;        Why they gave it a separate copy of the code, I don't know.
; ObjPlayer_MdJump2:
ObjPlayer_MdJump:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_ChgJumpDir
		bsr.w	Sonic_LevelBound
		jsr	(ObjectMoveAndFall).l
		btst	#PlayerStatusBitWater,status(a0)	; is Sonic underwater?
		beq.s	loc_FD34	; if not, branch
		subi.w	#$28,y_vel(a0)	; reduce gravity by $28 ($38-$28=$10)

loc_FD34:
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_DoLevelCollision
		rts
; End of subroutine ObjPlayer_MdJump

; ---------------------------------------------------------------------------
; Subroutine to make Sonic walk/run
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Move:
		move.w	(Sonic_top_speed).w,d6
		move.w	(Sonic_acceleration).w,d5
		move.w	(Sonic_deceleration).w,d4
		tst.b	($FFFFF7CA).w
		bne.w	ObjPlayer_Traction
		tst.w	move_lock(a0)
		bne.w	ObjPlayer_UpdateSpeedOnGround
		btst	#bitL,(Ctrl_1_Held_Logical).w	; is left being pressed?
		beq.s	loc_FD66		; if not, branch
		bsr.w	Sonic_MoveLeft

loc_FD66:
		btst	#bitR,(Ctrl_1_Held_Logical).w	; is right being pressed?
		beq.s	loc_FD72		; if not, branch
		bsr.w	Sonic_MoveRight

loc_FD72:
		move.b	angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0				; is Sonic on a slope?
		bne.w	ObjPlayer_UpdateSpeedOnGround	; if yes, branch
		tst.w	ground_speed(a0)			; is Sonic moving?
		bne.w	ObjPlayer_UpdateSpeedOnGround	; if yes, branch
		bclr	#PlayerStatusBitPush,status(a0)
		cmpi.b	#$B,anim(a0)	; use "standing" animation
		beq.s	Sonic_Balance
		move.b	#5,anim(a0)

Sonic_Balance:
		btst	#PlayerStatusBitOnObject,status(a0)
		beq.s	@BalanceOnLevelLayout
		moveq	#0,d0
		move.b	interact(a0),d0
		lsl.w	#6,d0
		lea	(MainCharacter).w,a1	; a1=character
		lea	(a1,d0.w),a1		; a1=object
		tst.b	status(a1)
		bmi.w	Sonic_LookUp
		moveq	#0,d1
		move.b	width_pixels(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2
		add.w	x_pos(a0),d1
		sub.w	x_pos(a1),d1
		cmpi.w	#4,d1
		blt.s	@BalanceLeft
		cmp.w	d2,d1
		bge.s	@BalanceRight
		bra.s	Sonic_LookUp
; ---------------------------------------------------------------------------
	@BalanceOnLevelLayout:
		jsr	(ChkFloorEdge).l
		cmpi.w	#$C,d1
		blt.s	Sonic_LookUp
		cmpi.b	#3,next_tilt(a0)
		bne.s	@BalanceCheckLeft

	@BalanceRight:
		move.b	#SonicAniID_Balance,anim(a0)
		bclr	#PlayerStatusBitHFlip,status(a0)
		move.w	x_pos(a0),d3
		subq.w	#5,d3
		jsr	(ChkFloorEdge_Part2).l
		cmpi.w	#$C,d1
		blt.s	ObjPlayer_UpdateSpeedOnGround
		move.b	#SonicAniID_Balance2,anim(a0)
		bra.s	ObjPlayer_UpdateSpeedOnGround
; ---------------------------------------------------------------------------
	@BalanceCheckLeft:
		cmpi.b	#3,tilt(a0)
		bne.s	Sonic_LookUp

	@BalanceLeft:
		move.b	#SonicAniID_Balance,anim(a0)
		bset	#PlayerStatusBitHFlip,status(a0)
		move.w	x_pos(a0),d3
		addq.w	#5,d3
		jsr	(ChkFloorEdge_Part2).l
		cmpi.w	#$C,d1
		blt.s	ObjPlayer_UpdateSpeedOnGround
		move.b	#SonicAniID_Balance2,anim(a0)
		bra.s	ObjPlayer_UpdateSpeedOnGround
; ---------------------------------------------------------------------------

Sonic_LookUp:
		btst	#bitUp,(Ctrl_1_Held_Logical).w	; is up being pressed?
		beq.s	Sonic_Duck		; if not, branch
		move.b	#SonicAniID_LookUp,anim(a0)	; use "looking up" animation
		bra.s	ObjPlayer_UpdateSpeedOnGround
; ---------------------------------------------------------------------------

Sonic_Duck:
		btst	#bitDn,(Ctrl_1_Held_Logical).w		; is down being pressed?
		beq.s	ObjPlayer_UpdateSpeedOnGround	; if not, branch
		move.b	#SonicAniID_Duck,anim(a0)	; use "ducking" animation

; ---------------------------------------------------------------------------
; updates Sonic's speed on the ground
; ---------------------------------------------------------------------------
; loc_FE2C:
ObjPlayer_UpdateSpeedOnGround:
		move.b	(Ctrl_1_Held_Logical).w,d0
		andi.b	#btnL+btnR,d0		; is left/right being pressed?
		bne.s	ObjPlayer_Traction	; if yes, branch
		move.w	ground_speed(a0),d0
		beq.s	ObjPlayer_Traction
		bmi.s	ObjPlayer_SettleLeft

; slow down when facing right and not pressing a direction
; ObjPlayer_SettleRight:
		sub.w	d5,d0
		bcc.s	loc_FE46
		move.w	#0,d0

loc_FE46:
		move.w	d0,ground_speed(a0)
		bra.s	ObjPlayer_Traction
; ---------------------------------------------------------------------------
; slow down when facing left and not pressing a direction
; loc_FE4C:
ObjPlayer_SettleLeft:
		add.w	d5,d0
		bcc.s	loc_FE54
		move.w	#0,d0

loc_FE54:
		move.w	d0,ground_speed(a0)

; increase or decrease speed on the ground
; loc_FE58:
ObjPlayer_Traction:
		move.b	angle(a0),d0
		jsr	(CalcSine).l
		muls.w	ground_speed(a0),d0
		asr.l	#8,d0
		move.w	d0,x_vel(a0)
		muls.w	ground_speed(a0),d1
		asr.l	#8,d1
		move.w	d1,y_vel(a0)

; stops Sonic from running through walls that meet the ground
; loc_FE76:
ObjPlayer_CheckWallsOnGround:
		move.b	angle(a0),d0
		addi.b	#$40,d0
		bmi.s	locret_FEF6
		move.b	#$40,d1		; rotate 90 degress clockwise
		tst.w	ground_speed(a0)	; check if Sonic's moving
		beq.s	locret_FEF6	; if not, branch
		bmi.s	loc_FE8E	; if negative, branch
		neg.w	d1		; rotate counterclockwise

loc_FE8E:
		move.b	angle(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	CalcRoomInFront
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_FEF6
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	loc_FEF2
		cmpi.b	#$40,d0
		beq.s	loc_FED8
		cmpi.b	#$80,d0
		beq.s	loc_FED2
		cmpi.w	#$600,x_vel(a0)		; is Sonic at max speed?
		bge.s	Sonic_WallRecoil	; if yes, branch
		add.w	d1,x_vel(a0)
		bset	#PlayerStatusBitPush,status(a0)
		move.w	#0,ground_speed(a0)
		rts
; ---------------------------------------------------------------------------

loc_FED2:
		sub.w	d1,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_FED8:
		cmpi.w	#$FA00,x_vel(a0)	; is Sonic at max speed?
		ble.s	Sonic_WallRecoil	; if yes, branch
		sub.w	d1,x_vel(a0)
		bset	#PlayerStatusBitPush,status(a0)
		move.w	#0,ground_speed(a0)
		rts
; ---------------------------------------------------------------------------

loc_FEF2:
		add.w	d1,y_vel(a0)

locret_FEF6:
		rts

; ---------------------------------------------------------------------------
; Subroutine to recoil Sonic off a wall if moving a top speed
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WallRecoil:
		move.b	#$A3,d2
		move.b	#4,routine(a0)
		bsr.w	Sonic_ResetOnFloor
		bset	#PlayerStatusBitAir,status(a0)
		move.w	#-$200,d0
		tst.w	x_vel(a0)
		bpl.s	@Right
		neg.w	d0
	@Right:
		move.b	(Vint_runcount+3),d1
		and.b	#%00001001,d1
		bne.s	@NoSuperBonk
		asl.w	#2,d0
		move.b	#SndID_SuperBonk,d2
	@NoSuperBonk:
		move.w	d0,x_vel(a0)
		move.w	#-$400,y_vel(a0)
		move.w	#0,ground_speed(a0)
		move.b	#$A,anim(a0)
		move.b	#1,routine_secondary(a0)
		move.w	d2,d0
		jmp	(PlaySound_Special).l
; End of function Sonic_Move


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_MoveLeft:
		move.w	ground_speed(a0),d0
		beq.s	loc_FF44
		bpl.s	Sonic_TurnLeft

loc_FF44:
		bset	#PlayerStatusBitHFlip,status(a0)
		bne.s	loc_FF58
		bclr	#PlayerStatusBitPush,status(a0)
		cmpi.b	#$D,anim(a0)
		bne.s	@NotSkid
		move.b	#$13,anim(a0)
		bra.s	loc_FF58
		@NotSkid:
		move.b	#$12,anim(a0)

loc_FF58:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_FF64
		move.w	d1,d0

loc_FF64:
		move.w	d0,ground_speed(a0)
		cmpi.b	#$D,anim(a0)
		bne.s	@NotSkid
		move.b	#$14,anim(a0)
		cmpi.w	#-$580,d0
		bhi.s	@NotSkid
		move.b	#$15,anim(a0)
		@NotSkid:
		cmpi.b	#$12,anim(a0)
		blo.s	@ResetWalk
		cmpi.b	#$15,anim(a0)
		bgt.s	@ResetWalk
		rts
		@ResetWalk:
		move.b	#0,anim(a0)
		rts
; ---------------------------------------------------------------------------
; loc_FF70:
Sonic_TurnLeft:
		sub.w	d4,d0
		bcc.s	loc_FF78
		move.w	#$FF80,d0

loc_FF78:
		move.w	d0,ground_speed(a0)
		move.b	angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_FFA6
		cmpi.w	#$400,d0
		blt.s	locret_FFA6
		move.b	#$D,anim(a0)
		bclr	#PlayerStatusBitHFlip,status(a0)
		move.w	#$A4,d0
		jsr	(PlaySound_Special).l

locret_FFA6:
		rts
; End of function Sonic_MoveLeft


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_MoveRight:
		move.w	ground_speed(a0),d0
		bmi.s	Sonic_TurnRight
		bclr	#PlayerStatusBitHFlip,status(a0)
		beq.s	loc_FFC2
		bclr	#PlayerStatusBitPush,status(a0)
		cmpi.b	#$D,anim(a0)
		bne.s	@NotSkid
		move.b	#$13,anim(a0)
		bra.s	loc_FFC2
		@NotSkid:
		move.b	#$12,anim(a0)

loc_FFC2:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_FFCA
		move.w	d6,d0

loc_FFCA:
		move.w	d0,ground_speed(a0)
		cmpi.b	#$D,anim(a0)
		bne.s	@NotSkid
		move.b	#$14,anim(a0)
		cmpi.w	#$580,d0
		blo.s	@NotSkid
		move.b	#$15,anim(a0)
		@NotSkid:
		cmpi.b	#$12,anim(a0)
		blo.s	@ResetWalk
		cmpi.b	#$15,anim(a0)
		bgt.s	@ResetWalk
		rts
		@ResetWalk:
		move.b	#0,anim(a0)
		rts
; ---------------------------------------------------------------------------
; loc_FFD6:
Sonic_TurnRight:
		add.w	d4,d0
		bcc.s	loc_FFDE
		move.w	#$80,d0

loc_FFDE:
		move.w	d0,ground_speed(a0)
		move.b	angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_1000C
		cmpi.w	#$FC00,d0
		bgt.s	locret_1000C
		move.b	#$D,anim(a0)

loc_FFFC:
		bset	#PlayerStatusBitHFlip,status(a0)
		move.w	#$A4,d0
		jsr	(PlaySound_Special).l

locret_1000C:
		rts
; End of function Sonic_MoveRight


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_RollSpeed:
		move.w	(Sonic_top_speed).w,d6
		asl.w	#1,d6
		move.w	(Sonic_acceleration).w,d5
		asr.w	#1,d5
		move.w	(Sonic_deceleration).w,d4
		asr.w	#2,d4
		tst.b	($FFFFF7CA).w
		bne.w	loc_1008A
		tst.w	move_lock(a0)
		bne.s	loc_10046
		btst	#bitL,(Ctrl_1_Held_Logical).w
		beq.s	loc_1003A
		bsr.w	Sonic_RollLeft

loc_1003A:
		btst	#bitR,(Ctrl_1_Held_Logical).w
		beq.s	loc_10046
		bsr.w	Sonic_RollRight

loc_10046:
		move.w	ground_speed(a0),d0
		beq.s	loc_10068
		bmi.s	loc_1005C
		sub.w	d5,d0
		bcc.s	loc_10056
		move.w	#0,d0

loc_10056:
		move.w	d0,ground_speed(a0)
		bra.s	loc_10068
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1005C:
		add.w	d5,d0
		bcc.s	loc_10064
		move.w	#0,d0

loc_10064:
		move.w	d0,ground_speed(a0)

loc_10068:
		tst.w	ground_speed(a0)
		bne.s	loc_1008A
		bclr	#PlayerStatusBitSpin,status(a0)
		move.b	#$13,y_radius(a0)
		move.b	#9,x_radius(a0)
		move.b	#5,anim(a0)
		subq.w	#5,y_pos(a0)

loc_1008A:
		move.b	angle(a0),d0
		jsr	(CalcSine).l
		muls.w	ground_speed(a0),d1
		asr.l	#8,d1
		move.w	d1,y_vel(a0)
		muls.w	ground_speed(a0),d0
		asr.l	#8,d0
		cmpi.w	#$1000,d0
		ble.s	loc_100AE
		move.w	#$1000,d0

loc_100AE:
		cmpi.w	#$F000,d0
		bge.s	loc_100B8
		move.w	#$F000,d0

loc_100B8:
		move.w	d0,x_vel(a0)
		bra.w	ObjPlayer_CheckWallsOnGround
; End of function Sonic_RollSpeed


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_RollLeft:
		move.w	ground_speed(a0),d0
		beq.s	loc_100C8
		bpl.s	loc_100D6

loc_100C8:
		bset	#PlayerStatusBitHFlip,status(a0)
		move.b	#2,anim(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_100D6:
		sub.w	d4,d0
		bcc.s	loc_100DE
		move.w	#$FF80,d0

loc_100DE:
		move.w	d0,ground_speed(a0)
		rts
; End of function Sonic_RollLeft


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_RollRight:
		move.w	ground_speed(a0),d0
		bmi.s	loc_100F8
		bclr	#PlayerStatusBitHFlip,status(a0)
		move.b	#2,anim(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_100F8:
		add.w	d4,d0
		bcc.s	loc_10100
		move.w	#$80,d0

loc_10100:
		move.w	d0,ground_speed(a0)
		rts
; End of function Sonic_RollRight


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_ChgJumpDir:
	move.w	(Sonic_top_speed).w,d6
	move.w	(Sonic_acceleration).w,d5
	asl.w	#1,d5
	btst	#PlayerStatusBitRollLock,status(a0)	; Roll Lock >:C
	bne.s	loc_10150
		move.w	x_vel(a0),d0
		btst	#bitL,(Ctrl_1_Held_Logical).w
		beq.s	loc_10136

		btst	#PlayerStatusBitHFlip,status(a0)
		beq.s	@CheckSpeedRev
			tst.w	ground_speed(a0)
			beq.s	@JumpNormal
			bmi.s	@JumpNormal
			addq.w	#5,d5
			add.w	d6,d6
			bra.s	@JumpNormal
	@CheckSpeedRev:
		tst.w	ground_speed(a0)
		bpl.s	@JumpNormal
		addq.w	#5,d5
		add.w	d6,d6
	@JumpNormal:


		;bset	#PlayerStatusBitHFlip,status(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_10136
		move.w	d1,d0
	loc_10136:
		btst	#bitR,(Ctrl_1_Held_Logical).w
		beq.s	loc_1014C

		btst	#PlayerStatusBitHFlip,status(a0)
		bne.s	@CheckSpeedRev
			tst.w	ground_speed(a0)
			bpl.s	@JumpNormal
			addq.w	#5,d5
			add.w	d6,d6
			bra.s	@JumpNormal
			
	@CheckSpeedRev:
		tst.w	ground_speed(a0)
		beq.s	@JumpNormal
		bmi.s	@JumpNormal
		addq.w	#5,d5
		add.w	d6,d6
	@JumpNormal:


		;bclr	#PlayerStatusBitHFlip,status(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_1014C
		move.w	d6,d0

loc_1014C:
		move.w	d0,x_vel(a0)

loc_10150:
		cmpi.w	#$60,(Camera_Y_pos_bias).w
		beq.s	loc_10162
		bcc.s	loc_1015E
		addq.w	#4,(Camera_Y_pos_bias).w

loc_1015E:
		subq.w	#2,(Camera_Y_pos_bias).w

loc_10162:
		cmpi.w	#$FC00,y_vel(a0)
		bcs.s	locret_10190
		move.w	x_vel(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.s	locret_10190
		bmi.s	loc_10184
		sub.w	d1,d0
		bcc.s	loc_1017E
		move.w	#0,d0

loc_1017E:
		move.w	d0,x_vel(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_10184:
		sub.w	d1,d0
		bcs.s	loc_1018C
		move.w	#0,d0

loc_1018C:
		move.w	d0,x_vel(a0)

locret_10190:
		rts
; End of function Sonic_ChgJumpDir


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ

; Sonic_LevelBoundaries:
Sonic_LevelBound:
		move.l	x_pos(a0),d1
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(Camera_Min_X_pos).w,d0
		addi.w	#$10,d0
		cmp.w	d1,d0
		bhi.s	Sonic_Boundary_Sides
		move.w	(Camera_Max_X_pos).w,d0
		addi.w	#320-24,d0	; screen width - Player width
		tst.b	($FFFFF7AA).w
		bne.s	@NotABoss
		addi.w	#64,d0	; extra space on the right for signpost
	@NotABoss:
		cmp.w	d1,d0
		bls.s	Sonic_Boundary_Sides

Sonic_Boundary_CheckBottom:
		move.w	(Camera_Max_Y_pos_now).w,d0
		addi.w	#224,d0
		cmp.w	y_pos(a0),d0
		blt.s	Sonic_Boundary_Bottom
		rts
; ---------------------------------------------------------------------------

Sonic_Boundary_Bottom:
		tst.w	(Camera_Min_Y_pos).w	; check for vertical wrap
		bpl.s	@jmp	;JmpTo_KillSonic
		rts
; ---------------------------------------------------------------------------
	@jmp:
		moveq	#Err_DeathPit,d0
		TRAP	#0
		bra.w	JmpTo_KillSonic


Sonic_Boundary_Sides:
		move.w	d0,x_pos(a0)
		move.w	#0,x_sub(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,ground_speed(a0)
		bra.s	Sonic_Boundary_CheckBottom
; End of function Sonic_LevelBound


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_Roll:
		tst.b	($FFFFF7CA).w
		bne.s	ObjPlayer_NoRoll
		move.w	ground_speed(a0),d0
		bpl.s	loc_10220
		neg.w	d0

loc_10220:
		cmpi.w	#$80,d0
		bcs.s	ObjPlayer_NoRoll
		move.b	(Ctrl_1_Held_Logical).w,d0
		andi.b	#btnL+btnR,d0
		bne.s	ObjPlayer_NoRoll
		btst	#bitDn,(Ctrl_1_Held_Logical).w
		bne.s	loc_1023A

ObjPlayer_NoRoll:
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1023A:
		btst	#PlayerStatusBitSpin,status(a0)
		beq.s	ObjPlayer_DoRoll
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ObjPlayer_DoRoll:
		bset	#PlayerStatusBitSpin,status(a0)
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.b	#2,anim(a0)
		addq.w	#5,y_pos(a0)
		move.w	#$BE,d0
		jsr	(PlaySound_Special).l
		tst.w	ground_speed(a0)
		bne.s	locret_10276
		move.w	#$200,ground_speed(a0)

locret_10276:
		rts
; End of function Sonic_Roll


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_Jump:
	move.b	(Ctrl_1_Press_Logical).w,d0
	andi.b	#btnABC,d0
	beq.w	@DoNothing
		moveq	#0,d0
		move.b	angle(a0),d0
		addi.b	#$80,d0
		bsr.w	sub_13102
		cmpi.w	#6,d1
		blt.w	@DoNothing	; Do nothing if ceiling is too low
			move.w	#$680,d2	; Jump height
			btst	#PlayerStatusBitWater,status(a0)
			beq.s	@NotUnderwater
				move.w	#$380,d2	; Jump Height underwater
		@NotUnderwater:
			moveq	#0,d0
			move.b	angle(a0),d0
			subi.b	#$40,d0
			jsr	(CalcSine).l
			muls.w	d2,d0
			asr.l	#8,d0
			add.w	d0,x_vel(a0)
			muls.w	d2,d1
			asr.l	#8,d1
			add.w	d1,y_vel(a0)
			bset	#PlayerStatusBitAir,status(a0)
			bclr	#PlayerStatusBitPush,status(a0)
			move.l	#ObjectMove,(sp)
			move.b	#1,jumping(a0)
			clr.b	stick_to_convex(a0)
			move.w	#$A0,d0
			jsr	(PlaySound_Special).l	; Play Jump Sound
			move.b	#$13,y_radius(a0)
			move.b	#9,x_radius(a0)
			btst	#PlayerStatusBitSpin,status(a0)
			bne.s	@AlreadySpinning
				move.b	#$E,y_radius(a0)
				move.b	#7,x_radius(a0)
				move.b	#SonicAniID_Roll,anim(a0)
				bset	#PlayerStatusBitSpin,status(a0)
				addq.w	#5,y_pos(a0)
	@DoNothing:
		rts
	@AlreadySpinning:
		bset	#PlayerStatusBitRollLock,status(a0)
		rts
; End of function Sonic_Jump


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_JumpHeight:
		tst.b	jumping(a0)
		beq.s	loc_10352
		move.w	#-$400,d1
		btst	#PlayerStatusBitWater,status(a0)
		beq.s	@NotUnderwater
		move.w	#-$200,d1
	@NotUnderwater:
		cmp.w	y_vel(a0),d1
		ble.s	@DoNothing
		move.b	(Ctrl_1_Held_Logical).w,d0
		andi.b	#btnABC,d0
		bne.s	@DoNothing
		move.w	d1,y_vel(a0)	; Set speed if jump button isn't held
	@DoNothing:
		rts
; ---------------------------------------------------------------------------

loc_10352:
		cmpi.w	#-$FC0,y_vel(a0)
		bge.s	@NotCap
		move.w	#-$FC0,y_vel(a0)
	@NotCap:
		rts
; End of function Sonic_JumpHeight

; ---------------------------------------------------------------------------
; Subroutine to check for starting to charge a spindash
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Sonic_Spindash:
Sonic_CheckSpindash:
		tst.b	spindash_flag(a0)
		bne.s	Sonic_UpdateSpindash
		cmpi.b	#8,anim(a0)
		bne.s	locret_10394
		move.b	(Ctrl_1_Press_Logical).w,d0
		andi.b	#btnABC,d0
		beq.w	locret_10394
		move.b	#9,anim(a0)
		move.w	#$BE,d0
		jsr	(PlaySound_Special).l
		addq.l	#4,sp
		move.b	#1,spindash_flag(a0)

locret_10394:
		rts
; ===========================================================================
; loc_10396:
Sonic_UpdateSpindash:
		move.b	(Ctrl_1_Held_Logical).w,d0
		btst	#bitDn,d0
		bne.s	Sonic_ChargingSpindash

		; unleash the charged spindash and start rolling quickly:
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.b	#2,anim(a0)
		addq.w	#5,y_pos(a0)	; add the difference between Sonic's rolling and standing heights
		move.b	#0,spindash_flag(a0)
		move.w	#$2000,(Horiz_scroll_delay_val).w
		move.w	#$800,ground_speed(a0)
		btst	#PlayerStatusBitHFlip,status(a0)
		beq.s	loc_103D4
		neg.w	ground_speed(a0)

loc_103D4:
		bset	#PlayerStatusBitSpin,status(a0)
		rts
; ===========================================================================
; loc_103DC:
Sonic_ChargingSpindash:
		move.b	(Ctrl_1_Press_Logical).w,d0
		andi.b	#btnABC,d0	
		beq.w	loc_103EA
		nop

loc_103EA:
		addq.l	#4,sp
		rts
; End of function Sonic_CheckSpindash
; ---------------------------------------------------------------------------
Sonic_SlopeResist:
		move.b	angle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_10422
		move.b	angle(a0),d0

	loc_10400:
		jsr	(CalcSine).l
		muls.w	#32,d1	; multiply by 32
		asr.l	#8,d1	; divide by 256
		tst.w	ground_speed(a0)
		beq.s	locret_10422
		bmi.s	loc_1041E
		tst.w	d1
		beq.s	locret_1041C
		add.w	d1,ground_speed(a0)
	locret_1041C:
		rts
loc_1041E:
		add.w	d1,ground_speed(a0)
locret_10422:
		rts
; End of function Sonic_SlopeResist
; ---------------------------------------------------------------------------
Sonic_RollRepel:
		move.b	angle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_1045E
		move.b	angle(a0),d0
		jsr	(CalcSine).l
		muls.w	#80,d1	; multiply by 80
		asr.l	#8,d1	; divide by 256
		tst.w	ground_speed(a0)
		bmi.s	loc_10454
		tst.w	d1
		bpl.s	loc_1044E
		asr.l	#2,d1
	loc_1044E:
		add.w	d1,ground_speed(a0)
		rts
	loc_10454:
		tst.w	d1
		bmi.s	loc_1045A
		asr.l	#2,d0

	loc_1045A:
		add.w	d1,ground_speed(a0)

	locret_1045E:
		rts
; ---------------------------------------------------------------------------
Sonic_SlopeRepel:
		nop
		tst.b	stick_to_convex(a0)
		bne.s	locret_1049A
		tst.w	move_lock(a0)
		bne.s	loc_1049C
		move.b	angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	locret_1049A
		move.w	ground_speed(a0),d0
		bpl.s	loc_10484
		neg.w	d0

loc_10484:
		cmpi.w	#$280,d0
		bcc.s	locret_1049A
		clr.w	ground_speed(a0)
		bset	#PlayerStatusBitAir,status(a0)
		move.w	#$1E,move_lock(a0)

locret_1049A:
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1049C:
		subq.w	#1,move_lock(a0)
		rts
; End of function Sonic_SlopeRepel


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_JumpAngle:
		move.b	angle(a0),d0
		beq.s	loc_104BC
		bpl.s	loc_104B2
		addq.b	#2,d0
		bcc.s	loc_104B0
		moveq	#0,d0

loc_104B0:
		bra.s	loc_104B8
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_104B2:
		subq.b	#2,d0
		bcc.s	loc_104B8
		moveq	#0,d0

loc_104B8:
		move.b	d0,angle(a0)

loc_104BC:
		move.b	flip_angle(a0),d0
		beq.s	locret_104FA
		tst.w	ground_speed(a0)
		bmi.s	loc_104E0
		move.b	flip_speed(a0),d1
		add.b	d1,d0
		bcc.s	loc_104DE
		subq.b	#1,flips_remaining(a0)
		bcc.s	loc_104DE
		move.b	#0,flips_remaining(a0)
		moveq	#0,d0

loc_104DE:
		bra.s	loc_104F6
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_104E0:
		move.b	flip_speed(a0),d1
		sub.b	d1,d0
		bcc.s	loc_104F6
		subq.b	#1,flips_remaining(a0)
		bcc.s	loc_104F6
		move.b	#0,flips_remaining(a0)
		moveq	#0,d0

loc_104F6:
		move.b	d0,flip_angle(a0)

locret_104FA:
		rts
; End of function Sonic_JumpAngle


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ

; Sonic_Floor:
Sonic_DoLevelCollision:
		move.l	#Primary_Collision,(Collision_addr).w
		cmpi.b	#$C,top_solid_bit(a0)
		beq.s	loc_10514
		move.l	#Secondary_Collision,(Collision_addr).w

loc_10514:
		move.b	lrb_solid_bit(a0),d5
		move.w	x_vel(a0),d1
		move.w	y_vel(a0),d2
		jsr	(CalcAngle).l
		subi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_105E4
		cmpi.b	#$80,d0
		beq.w	loc_10646
		cmpi.b	#$C0,d0
		beq.w	loc_106A2
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_10558
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_10558:
		bsr.w	sub_132EE
		tst.w	d1
		bpl.s	loc_1056A
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_1056A:
		bsr.w	loc_13146
		tst.w	d1
		bpl.s	locret_105E2
		move.b	y_vel(a0),d2
		addq.b	#8,d2
		neg.b	d2
		cmp.b	d2,d1
		bge.s	loc_10582
		cmp.b	d2,d0
		blt.s	locret_105E2

loc_10582:
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#0,anim(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_105C0
		move.b	d3,d0
		addi.b	#$10,d0
		andi.b	#$20,d0
		beq.s	loc_105B2
		asr	y_vel(a0)
		bra.s	loc_105D4
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_105B2:
		move.w	#0,y_vel(a0)
		move.w	x_vel(a0),ground_speed(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_105C0:
		move.w	#0,x_vel(a0)
		cmpi.w	#$FC0,y_vel(a0)
		ble.s	loc_105D4
		move.w	#$FC0,y_vel(a0)

loc_105D4:
		move.w	y_vel(a0),ground_speed(a0)
		tst.b	d3
		bpl.s	locret_105E2
		neg.w	ground_speed(a0)

locret_105E2:
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_105E4:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_105FE
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		move.w	y_vel(a0),ground_speed(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_105FE:
		bsr.w	Sonic_DontRunOnWalls
		tst.w	d1
		bpl.s	loc_10618
		sub.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	locret_10616
		move.w	#0,y_vel(a0)

locret_10616:
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_10618:
		tst.w	y_vel(a0)
		bmi.s	locret_10644
		bsr.w	loc_13146
		tst.w	d1
		bpl.s	locret_10644
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#0,anim(a0)
		move.w	#0,y_vel(a0)
		move.w	x_vel(a0),ground_speed(a0)

locret_10644:
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_10646:
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_10658
		sub.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_10658:
		bsr.w	sub_132EE
		tst.w	d1
		bpl.s	loc_1066A
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)

loc_1066A:
		bsr.w	Sonic_DontRunOnWalls
		tst.w	d1
		bpl.s	locret_106A0
		sub.w	d1,y_pos(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_1068A
		move.w	#0,y_vel(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1068A:
		move.b	d3,angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.w	y_vel(a0),ground_speed(a0)
		tst.b	d3
		bpl.s	locret_106A0
		neg.w	ground_speed(a0)

locret_106A0:
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_106A2:
		bsr.w	sub_132EE
		tst.w	d1
		bpl.s	loc_106BC
		add.w	d1,x_pos(a0)
		move.w	#0,x_vel(a0)
		move.w	y_vel(a0),ground_speed(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_106BC:
		bsr.w	Sonic_DontRunOnWalls
		tst.w	d1
		bpl.s	loc_106D6
		sub.w	d1,y_pos(a0)
		tst.w	y_vel(a0)
		bpl.s	locret_106D4
		move.w	#0,y_vel(a0)

locret_106D4:
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_106D6:
		tst.w	y_vel(a0)
		bmi.s	locret_10702
		bsr.w	loc_13146
		tst.w	d1
		bpl.s	locret_10702
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#0,anim(a0)
		move.w	#0,y_vel(a0)
		move.w	x_vel(a0),ground_speed(a0)

locret_10702:
		rts
; End of function Sonic_DoLevelCollision


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_ResetOnFloor:
;		btst	#PlayerStatusBitRollLock,status(a0)
;		beq.s	loc_10712
;		nop
;		nop
;		nop
;
;loc_10712:
		bclr	#PlayerStatusBitPush,status(a0)
		bclr	#PlayerStatusBitAir,status(a0)
		bclr	#PlayerStatusBitRollLock,status(a0)
		bclr	#PlayerStatusBitSpin,status(a0)
		beq.s	@NotRolling
			move.b	#$13,y_radius(a0)
			move.b	#9,x_radius(a0)
			move.b	#0,anim(a0)
			subq.w	#5,y_pos(a0)
		@NotRolling:
		move.b	#0,jumping(a0)
		move.w	#0,($FFFFF7D0).w
		move.b	#0,flip_angle(a0)
		rts
; End of function Sonic_ResetOnFloor

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ObjPlayer_Hurt:
		tst.b	routine_secondary(a0)
		bmi.w	loc_107E8
		jsr	(ObjectMove).l
		addi.w	#$30,y_vel(a0)
		btst	#PlayerStatusBitWater,status(a0)
		beq.s	loc_1077E
		subi.w	#$20,y_vel(a0)

loc_1077E:
		bsr.w	Sonic_HurtStop
		bsr.w	Sonic_LevelBound
		bsr.w	Sonic_RecordPos
		bsr.w	Sonic_Animate
		bsr.w	LoadSonicDynPLC
		jmp	(DisplaySprite).l

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_HurtStop:
		move.l	(Camera_Min_Y_pos).w,d0	; Min Y and Max Y are next to each other
		bmi.s	@LevelWrap		; skip if level wrapping is on	
		addi.w	#224,d0
		cmp.w	y_pos(a0),d0
		bcs.w	JmpTo_KillSonic
	@LevelWrap:
		bsr.w	Sonic_DoLevelCollision
		btst	#PlayerStatusBitAir,status(a0)
		bne.s	locret_107E6
		moveq	#0,d0
		move.w	d0,y_vel(a0)
		move.w	d0,x_vel(a0)
		move.w	d0,ground_speed(a0)
		tst.b	routine_secondary(a0)
		beq.s	loc_107D6
		move.b	#$FF,routine_secondary(a0)
		move.b	#$B,anim(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_107D6:
		move.b	#0,anim(a0)
		subq.b	#2,routine(a0)
		move.w	#-$78,invincibility_time(a0)

locret_107E6:
		rts
; End of function Sonic_HurtStop

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_107E8:
		cmpi.b	#$B,anim(a0)
		bne.s	loc_107FA
		move.b	(Ctrl_1_Press).w,d0
		andi.b	#$7F,d0
		beq.s	loc_10804

loc_107FA:
		subq.b	#2,routine(a0)
		move.b	#0,routine_secondary(a0)

loc_10804:
		bsr.w	Sonic_RecordPos
		bsr.w	Sonic_Animate
		bsr.w	LoadSonicDynPLC
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; ObjPlayer_Death:
ObjPlayer_Dead:
	cmpi.b	#$39,(Game_Over).w	; is game over text present?
	beq.s	ObjPlayer_ResetLevel	; if so, branch
		bsr.w	Sonic_GameOver
		jsr	(ObjectMoveAndFall).l
		bsr.w	Sonic_RecordPos
		bsr.w	Sonic_Animate
		bsr.w	LoadSonicDynPLC
		jmp	(DisplaySprite).l
ObjPlayer_ResetLevel:
	tst.w	$3A(a0)
	beq.s	locret_108C8
	subq.w	#1,$3A(a0)
	bne.s	locret_108C8
	move.b	#1,(Level_Reload).w	; reset level
locret_108C8:
	rts


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_GameOver:
		move.w	(Camera_Max_Y_pos_now).w,d0
		addi.w	#$100,d0
		cmp.w	y_pos(a0),d0	; has player fallen off the bottom of the screen
		bcc.w	locret_108B4
		move.w	#$FFC8,y_vel(a0)
		pea	ObjPlayer_ResetLevel
		clr.b	(Update_HUD_timer).w
		addq.b	#1,(Update_HUD_lives).w
		subq.b	#1,(Life_count).w
		bne.s	loc_10888
		move.w	#0,$3A(a0)
		move.b	#$39,(Game_Over).w
		move.b	#$39,(Game_Over2).w
		move.b	#1,(Game_Over2+mapping_frame).w
		clr.b	($FFFFFE1A).w

	loc_10876:
		move.w	#$8F,d0
		jsr	(PlaySound).l
		moveq	#PLCID_GameOver,d0
		jmp	(LoadPLC).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	loc_10888:
		move.w	#$3C,$3A(a0)
		tst.b	($FFFFFE1A).w
		beq.s	locret_108B4
		move.w	#0,$3A(a0)
		move.b	#$39,(Game_Over).w
		move.b	#$39,(Game_Over2).w
		move.b	#2,(Game_Over+mapping_frame).w
		move.b	#3,(Game_Over2+mapping_frame).w
		bra.s	loc_10876
locret_108B4:
		rts
; End of function Sonic_GameOver
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to animate Sonic's sprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Animate:
		lea	(SonicAniData).l,a1
		;lea	(TailsAniData).l,a1
		moveq	#0,d0
		move.b	anim(a0),d0
		cmp.b	prev_anim(a0),d0
		beq.s	SonicAnimate_Do
		move.b	d0,prev_anim(a0)
		move.b	#0,anim_frame(a0)
		move.b	#0,anim_frame_duration(a0)
; loc_108EC:
SonicAnimate_Do:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		move.b	(a1),d0
		bmi.s	SonicAnimate_WalkRun
		move.b	status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	SonicAnimate_Delay
		move.b	d0,anim_frame_duration(a0)
; sub_10912:
SonicAnimate_Do2:
		moveq	#0,d1
		move.b	anim_frame(a0),d1
		move.b	1(a1,d1.w),d0
		cmpi.b	#$F0,d0
		bcc.s	SonicAnimate_CmdFF
; loc_10922:
SonicAnimate_Next:
		move.b	d0,mapping_frame(a0)
		addq.b	#1,anim_frame(a0)
; locret_1092A:
SonicAnimate_Delay:
		rts
; ===========================================================================
; loc_1092C:
SonicAnimate_CmdFF:
		addq.b	#1,d0
		bne.s	SonicAnimate_CmdFE
		move.b	#0,anim_frame(a0)
		move.b	1(a1),d0
		bra.s	SonicAnimate_Next
; ===========================================================================
; loc_1093C:
SonicAnimate_CmdFE:
		addq.b	#1,d0
		bne.s	SonicAnimate_CmdFD
		move.b	2(a1,d1.w),d0
		sub.b	d0,anim_frame(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	SonicAnimate_Next
; ===========================================================================
; loc_10950:
SonicAnimate_CmdFD:
		addq.b	#1,d0
		bne.s	SonicAnimate_End
		move.b	2(a1,d1.w),anim(a0)
; locret_1095A:
SonicAnimate_End:
		rts
; ===========================================================================
; loc_1095C:
SonicAnimate_WalkRun:
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	SonicAnimate_Delay
		addq.b	#1,d0
		bne.w	SonicAnimate_Roll
		moveq	#0,d0
		move.b	flip_angle(a0),d0
		bne.w	SonicAnimate_Tumble
		moveq	#0,d1
		move.b	angle(a0),d0
		move.b	status(a0),d2
		andi.b	#1,d2
		bne.s	loc_10984
		not.b	d0

loc_10984:
		addi.b	#$10,d0
		bpl.s	loc_1098C
		moveq	#3,d1

loc_1098C:
		andi.b	#$FC,render_flags(a0)
		eor.b	d1,d2
		or.b	d2,render_flags(a0)
		btst	#PlayerStatusBitPush,status(a0)
		bne.w	SonicAnimate_Push
		lsr.b	#4,d0
		andi.b	#6,d0
		move.w	ground_speed(a0),d2
		bpl.s	loc_109B0
		neg.w	d2

loc_109B0:
		lea	(SonicAni_Walk).l,a1
		cmpi.w	#$580,d2
		blo.s	@walk
		lea	(SonicAni_Run).l,a1
	@walk:
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0
		add.b	d0,d0
		add.b	d0,d0
		move.b	d0,d3

		cmpi.w	#$600,d2	; check for speed (full running speed)
		blo.s	@NoOffset
		addq.b	#4,d3		; next set of running sprites
		cmpi.w	#$700,d2	; check for speed (speedshoes)
		blo.s	@NoOffset
		addq.b	#4,d3		; next set of running sprites
	@NoOffset:
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	loc_109D8
		moveq	#0,d2

loc_109D8:
		lsr.w	#8,d2
		lsr.w	#1,d2
		move.b	d2,anim_frame_duration(a0)
		bsr.w	SonicAnimate_Do2

		add.b	d3,mapping_frame(a0)
		rts
; ===========================================================================
; loc_109EA:
SonicAnimate_Tumble:
		move.b	flip_angle(a0),d0
		moveq	#0,d1
		move.b	status(a0),d2
		andi.b	#1,d2
		bne.s	SonicAnimate_TumbleLeft

		andi.b	#$FC,render_flags(a0)
		moveq	#0,d2
		or.b	d2,render_flags(a0)
		addi.b	#$B,d0
		divu.w	#$16,d0
		addi.b	#$9B,d0
		move.b	d0,mapping_frame(a0)
		move.b	#0,anim_frame_duration(a0)
		rts
; ---------------------------------------------------------------------------
; loc_10A1E:
SonicAnimate_TumbleLeft:
		moveq	#3,d2
		andi.b	#$FC,render_flags(a0)
		or.b	d2,render_flags(a0)
		neg.b	d0
		addi.b	#$8F,d0
		divu.w	#$16,d0
		addi.b	#$9B,d0
		move.b	d0,mapping_frame(a0)
		move.b	#0,anim_frame_duration(a0)
		rts
; ===========================================================================
; loc_10A44:
SonicAnimate_Roll:
	addq.b	#1,d0
	bne.s	SonicAnimate_Push
		btst	#PlayerStatusBitHFlip,status(a0)
		beq.s	@CheckSpeedRev
		move.w	ground_speed(a0),d2
		bpl.s	@RollReverse
		neg.w	d2
		bra.s	@RollNormal
	@CheckSpeedRev:
		move.w	ground_speed(a0),d2
		bpl.s	@RollNormal
		neg.w	d2
	@RollReverse:
		lea	(SonicAni_Roll4).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_10A62
		lea	(SonicAni_Roll3).l,a1
		bra.s	loc_10A62

	@RollNormal:
		lea	(SonicAni_Roll2).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_10A62
		lea	(SonicAni_Roll).l,a1

loc_10A62:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	loc_10A6C
		moveq	#0,d2

loc_10A6C:
		lsr.w	#8,d2
		move.b	d2,anim_frame_duration(a0)
		move.b	status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		bra.w	SonicAnimate_Do2
; ===========================================================================
; loc_10A88:
SonicAnimate_Push:
		move.w	ground_speed(a0),d2
		bmi.s	loc_10A90
		neg.w	d2

loc_10A90:
		addi.w	#$800,d2
		bpl.s	loc_10A98
		moveq	#0,d2

loc_10A98:
		lsr.w	#6,d2
		move.b	d2,anim_frame_duration(a0)
		lea	(SonicAni_Push).l,a1
		move.b	status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		bra.w	SonicAnimate_Do2
; End of function Sonic_Animate

; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


LoadSonicDynPLC:
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	cmp.b	(Sonic_LastLoadedDPLC).w,d0
	beq.s	@DoNothing
		move.b	d0,(Sonic_LastLoadedDPLC).w

		moveq	#0,d3
		move.b	Character(a0),d3	; get entry
		lea	@Values(pc,d3.w),a2
		move.l	(a2)+,d4		; load VRAM location
		move.l	(a2)+,mappings(a0)	; Load Mapping
		move.l	(a2)+,a3		; Load Art
		move.l	(a2),a2 		; load PLC script

		moveq	#0,d3
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	@DoNothing
	@ReadEntry:
		moveq	#0,d1
		move.w	(a2)+,d1
		move.w	d1,d3
		lsr.w	#8,d3
		andi.w	#$F0,d3
		addi.w	#$10,d3
		andi.w	#$FFF,d1
		lsl.l	#5,d1

		add.l	a3,d1

		move.w	d4,d2
		add.w	d3,d4
		add.w	d3,d4
		jsr	(QueueDMATransfer).l
	dbf	d5,@ReadEntry
	@DoNothing:
		rts
; End of function LoadSonicDynPLC
; ===========================================================================
@macro	macro	VRAM, VRAM2, map, art, dplc
	dc.w	VRAM2, VRAM
	dc.l	map, art, dplc
	endm
@Values:;	VRAM Player 1	VRAM Player 2	Sprite Map data		Uncompressed Art	DPLC
	@macro	VRAM_Plr1,	VRAM_Plr2,	Map_Sonic,		Art_Sonic,	SonicDynPLC
	@macro	VRAM_Plr1,	VRAM_Plr2,	Map_Tails,		Art_Tails,	TailsDynPLC ; Boomer
	@macro	VRAM_Plr1,	VRAM_Plr2,	Map_Tails,		Art_Tails,	TailsDynPLC
	@macro	VRAM_Plr1,	VRAM_Plr2,	Map_Tails,		Art_Tails,	TailsDynPLC ; Hops
	@macro	VRAM_Plr1,	VRAM_Plr2,	Map_Tails,		Art_Tails,	TailsDynPLC ; Tammy

; ===========================================================================

JmpTo_KillSonic:	; JmpTo
		jmp	(KillSonic).l
; ===========================================================================
Player_CheckChunk:
		include	"Level/Level Chunks Effects.asm"
; ===========================================================================
; Everything else
		include "Objects/_Player/Collision Routines.asm"
		include "Objects/_Player/TouchResponses.asm"
		include "Objects/_Player/ObjectPlace.asm"