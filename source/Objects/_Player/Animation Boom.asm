; ---------------------------------------------------------------------------
; Animation script - Boom
; TO DO : AUTOMATE PROCESS (This is BAD)
; ---------------------------------------------------------------------------
	IndexStart	BoomAniData, 1
	GenerateIndexID	BoomAni, Walk
	GenerateIndex	BoomAni, Run
	GenerateIndexID	BoomAni, Roll
	GenerateIndexID	BoomAni, Roll2	; this is a free slot
	GenerateIndexID	BoomAni, Push
	GenerateIndexID	BoomAni, Wait
	GenerateIndexID	BoomAni, Balance
	GenerateIndexID	BoomAni, LookUp
	GenerateIndexID	BoomAni, Duck
	GenerateIndexID	BoomAni, Spindash
	GenerateIndexID	BoomAni, WallRecoil1
	GenerateIndexID	BoomAni, WallRecoil2
	GenerateIndexID	BoomAni, WallRecoil3
	GenerateIndexID	BoomAni, Stop
	GenerateIndexID	BoomAni, Float1
	GenerateIndexID	BoomAni, Float2
	GenerateIndexID	BoomAni, Spring
	GenerateIndexID	BoomAni, Hang
	GenerateIndexID	BoomAni, TurnAround
	GenerateIndexID	BoomAni, SkidToWalk
	GenerateIndexID	BoomAni, SkidToWalk2
	GenerateIndexID	BoomAni, SkidToWalk3
	GenerateIndexID	BoomAni, Death1
	GenerateIndexID	BoomAni, Drown
	GenerateIndexID	BoomAni, Death2
	GenerateIndexID	BoomAni, Bubble
	GenerateIndexID	BoomAni, Hurt
	GenerateIndexID	BoomAni, Balance2
	GenerateIndexID	BoomAni, Null	; S1 Big Ring (make Sonic invisible)
	GenerateIndexID	BoomAni, Float3	; continue screen in S1
	GenerateIndexID	BoomAni, ContinueGetUp
; ---------------------------------------------------------------------------
BoomAni_Wait:		dc.b	2
		rept	50
		dc.b	1
		endr
		dc.b	2, 2, 2,  3, 3, 3,  4, 4, 4,  5, 5, 5, 5, 5,  4
		dc.b	3,  afBack,  1

BoomAni_TurnAround:	dc.b	1
			dc.b	3, 2
			dc.b	afChange, BoomAniID_Walk ; Turning around

BoomAni_Roll3:	
BoomAni_Roll4:		dc.b 	-5
f	=	8+6
		AnimIncRept	6,-1
		dc.b	afEnd

BoomAni_Roll2:
BoomAni_Roll:		dc.b 	-5
f	=	8
		AnimIncRept	6,+1
		dc.b	afEnd

BoomAni_Run:
BoomAni_Walk:		dc.b 	-5
		AnimIncRept	10,+1
		dc.b	afEnd

BoomAni_SkidToWalk:	dc.b	1
		dc.b	1,1,1
		dc.b	afChange, BoomAniID_Walk

BoomAni_SkidToWalk2:	dc.b	2
		dc.b	1
		dc.b	afChange, BoomAniID_Walk

BoomAni_SkidToWalk3:	dc.b	1
		dc.b	1, 1
		dc.b	afChange, BoomAniID_Walk

BoomAni_Push:		dc.b 	-3
		rept	3
		dc.b	1,1,1,1
		endr
		dc.b	afEnd

BoomAni_Balance:	dc.b	8
		dc.b	1, 1
		dc.b	afEnd

BoomAni_Balance2:	dc.b	7
		dc.b	1,1
		dc.b	afEnd

BoomAni_LookUp:		dc.b	5
		dc.b	6
		dc.b	7, afBack, 1

BoomAni_Duck:		dc.b	5
		dc.b	7, afBack, 1

BoomAni_Spindash:	dc.b	0
		dc.b	1,2,1,2,1,2,1,2,1,2
		dc.b	afEnd

BoomAni_WallRecoil1:	dc.b	$3F
		dc.b	1
		dc.b	afEnd

BoomAni_WallRecoil2:	dc.b	7
		dc.b	1, 1, 1
		dc.b	afChange, BoomAniID_Wait ; get up from Bonk

BoomAni_WallRecoil3:	dc.b	7
		dc.b	1
		dc.b	afChange, BoomAniID_Wait	; get up

BoomAni_Stop:		dc.b	4
		dc.b	1,1
		dc.b	1,1, afBack, 2

BoomAni_Float1:		dc.b	7
		dc.b	1,1
		dc.b	afEnd

BoomAni_Float2:		dc.b	7
		dc.b	1,1,1,1,1
		dc.b	afEnd

BoomAni_Spring:		dc.b	$2F
		dc.b	1
		dc.b	afChange, BoomAniID_Walk	; Spring up

BoomAni_Hang:		dc.b	5
		dc.b	1,1
		dc.b	afEnd

BoomAni_Bubble:		dc.b	$B
		dc.b	1,1,1,1
		dc.b	afChange,  BoomAniID_Walk

BoomAni_Death1:		dc.b	$20
		dc.b	1
		dc.b	afEnd

BoomAni_Drown:		dc.b	$20
		dc.b	1
		dc.b	afEnd

BoomAni_Death2:		dc.b	$20
		dc.b	1
		dc.b	afEnd

BoomAni_Shrinking:	dc.b	3
		dc.b	1,1,1,1,1
		dc.b	0, afBack, 1

BoomAni_Hurt:		dc.b	12
		dc.b	1,1
		dc.b	afEnd

BoomAni_Null:		dc.b	$77
		dc.b	0
		dc.b	afChange,  BoomAniID_Walk

BoomAni_Float3:	dc.b	3
		dc.b	1,1,1,1,1
		dc.b	afEnd

BoomAni_ContinueGetUp:	dc.b	3
		dc.b	1
		dc.b	afChange, BoomAniID_Walk
; ---------------------------------------------------------------------------
			even