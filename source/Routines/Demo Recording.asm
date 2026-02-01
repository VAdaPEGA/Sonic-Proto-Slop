MoveSonicInDemo:
; ===========================================================================
	if	(RecordDemoMode)	; subroutine for recording demos
; ===========================================================================
		lea	($FE8000).l,a1
loc_4474:
		move.w	($FFFFF790).w,d0
		adda.w	d0,a1
		move.b	(Ctrl_1).w,d0
		cmp.b	(a1),d0
		bne.s	loc_4490
		addq.b	#1,1(a1)
		cmpi.b	#$FF,1(a1)
		beq.s	loc_4490
		bra.s	loc_44A4
; ===========================================================================

loc_4490:
		move.b	d0,2(a1)
		move.b	#0,3(a1)
		addq.w	#2,($FFFFF790).w
		andi.w	#$3FF,($FFFFF790).w

loc_44A4:
		cmpi.b	#3,(Current_Zone).w
		bne.s	locret_44E2
		lea	($FEC000).l,a1
		move.w	($FFFFF740).w,d0
		adda.w	d0,a1
		move.b	(Ctrl_2).w,d0
		cmp.b	(a1),d0
		bne.s	loc_44CE
		addq.b	#1,1(a1)
		cmpi.b	#$FF,1(a1)
		beq.s	loc_44CE
		bra.s	locret_44E2
; ===========================================================================

loc_44CE:	
		move.b	d0,2(a1)
		move.b	#0,3(a1)
		addq.w	#2,($FFFFF740).w
		andi.w	#$3FF,($FFFFF740).w

locret_44E2:	
		rts
; ===========================================================================
	else
; ===========================================================================
	; playback demo code
	tst.w	(Demo_Mode_Flag).w
	beq.s	@DoNothing
	tst.b	(Ctrl_1).w	; has player pressed a button?
	bpl.s	@StayInDemo	; if not, branch
		tst.w	(Demo_Mode_Flag).w	; is this the credits sequence?
		bmi.s	@StayInDemo		; if so, branch
			move.b	#GameModeID_TitleScreen,(Game_Mode).w
@StayInDemo:
	lea	(Demo_Index-4).l,a1
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w
	bne.s	@Level
		moveq	#6,d0	; use Special Stage demo
@Level:	
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a1
	move.w	($FFFFF790).w,d0
	adda.w	d0,a1
	move.b	(a1),d0
	lea	(Ctrl_1).w,a0
	move.b	d0,d1
	moveq	#0,d2
	eor.b	d2,d0
	move.b	d1,(a0)+
	and.b	d1,d0
	move.b	d0,(a0)+
	subq.b	#1,($FFFFF792).w	; has input timer expired?
	bcc.s	@HandlePlayer2		; if not, branch
		move.b	3(a1),($FFFFF792).w
		addq.w	#2,($FFFFF790).w
@HandlePlayer2:	
;	lea	(Demo_2P).l,a1
;	move.w	($FFFFF740).w,d0
;	adda.w	d0,a1
;	move.b	(a1),d0
;	lea	(Ctrl_2).w,a0
;	move.b	d0,d1
;	moveq	#0,d2
;	eor.b	d2,d0
;	move.b	d1,(a0)+
;	and.b	d1,d0
;	move.b	d0,(a0)+
;	subq.b	#1,($FFFFF742).w
;	bcc.s	@DoNothing
;		move.b	3(a1),($FFFFF742).w
;		addq.w	#2,($FFFFF740).w
@DoNothing:	
	rts
; ===========================================================================
loc_4572:	
		move.w	#0,(Ctrl_2_Held).w
		rts
; End of function MoveSonicInDemo
	endif
; ===========================================================================
Demo_Index:	
		dc.l Demo_S1GHZ
		dc.l Demo_CPZ
		dc.l Demo_EHZ
		dc.l Demo_HPZ
		dc.l Demo_HTZ
		dc.l Demo_S1SS
	;	dc.l $FE8000	; interestingly, it points at the fresh recording
	;	dc.l $FE8000