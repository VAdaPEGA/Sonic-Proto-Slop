; ---------------------------------------------------------------------------
; Subroutine to pause the game
; ---------------------------------------------------------------------------

PauseGame:
		tst.b	(Life_count).w
		beq.s	Unpause
		tst.b	(Game_paused).w
		bne.s	Pause_AlreadyPaused
		btst	#bitStart,(Ctrl_1_Press).w
		beq.s	Pause_DoNothing

Pause_AlreadyPaused:
		st	(Game_paused).w
		move.b	#1,(Sound_Driver_RAM+StopMusic).w

Pause_Loop:
		move.b	#VintID_Pause,(Vint_routine).w
		bsr.w	WaitForVint
		tst.b	(Slow_motion_flag).w
		beq.s	Pause_ChkStart
		btst	#bitA,(Ctrl_1_Press).w
		beq.s	Pause_ChkBC
		move.b	#GameModeID_TitleScreen,(Game_Mode).w
		nop
		bra.s	Pause_Resume
; ===========================================================================

Pause_ChkBC:
		btst	#bitB,(Ctrl_1_Held).w
		bne.s	Pause_SlowMo
		btst	#bitC,(Ctrl_1_Press).w
		bne.s	Pause_SlowMo

Pause_ChkStart:
		btst	#bitStart,(Ctrl_1_Press).w
		beq.s	Pause_Loop
; loc_1464:
Pause_Resume:
		move.b	#$80,(Sound_Driver_RAM+StopMusic).w

Unpause:
		sf	(Game_paused).w

Pause_DoNothing:
		rts
; ===========================================================================
; loc_1472:
Pause_SlowMo:
		st	(Game_paused).w
		move.b	#$80,(Sound_Driver_RAM+StopMusic).w
		rts