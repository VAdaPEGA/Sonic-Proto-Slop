; ---------------------------------------------------------------------------
; Animation script - Sonic
; TO DO : AUTOMATE PROCESS (This is BAD)
; ---------------------------------------------------------------------------
	IndexStart	SonicAniData, 1
	GenerateIndexID	SonicAni, Walk
	GenerateIndex	SonicAni, Run
	GenerateIndexID	SonicAni, Roll
	GenerateIndexID	SonicAni, Roll2	; this is a free slot
	GenerateIndexID	SonicAni, Push
	GenerateIndexID	SonicAni, Wait
	GenerateIndexID	SonicAni, Balance
	GenerateIndexID	SonicAni, LookUp
	GenerateIndexID	SonicAni, Duck
	GenerateIndexID	SonicAni, Spindash
	GenerateIndexID	SonicAni, WallRecoil1
	GenerateIndexID	SonicAni, WallRecoil2
	GenerateIndexID	SonicAni, WallRecoil3
	GenerateIndexID	SonicAni, Stop
	GenerateIndexID	SonicAni, Float1
	GenerateIndexID	SonicAni, Float2
	GenerateIndexID	SonicAni, Spring
	GenerateIndexID	SonicAni, Hang
	GenerateIndexID	SonicAni, TurnAround
	GenerateIndexID	SonicAni, SkidToWalk
	GenerateIndexID	SonicAni, SkidToWalk2
	GenerateIndexID	SonicAni, SkidToWalk3
	GenerateIndexID	SonicAni, Death1
	GenerateIndexID	SonicAni, Drown
	GenerateIndexID	SonicAni, Death2
	GenerateIndexID	SonicAni, Bubble
	GenerateIndexID	SonicAni, Hurt
	GenerateIndexID	SonicAni, Balance2
	GenerateIndexID	SonicAni, Null	; S1 Big Ring (make Sonic invisible)
	GenerateIndexID	SonicAni, Float3	; continue screen in S1
	GenerateIndexID	SonicAni, ContinueGetUp
; ---------------------------------------------------------------------------
SonicAni_Walk:		dc.b 	-1
			dc.b 	$10,$11,$12,$13,$14,$15,$16,$17, $C, $D, $E, $F
			dc.b	afEnd

SonicAni_Run:		dc.b 	-1
			rept	3
			dc.b 	$3C,$3D,$3E,$3F
			endr
			dc.b 	afEnd

SonicAni_SkidToWalk:	dc.b	1
			dc.b	$85,$86,$87
			dc.b	afChange, SonicAniID_Walk

SonicAni_SkidToWalk2:	dc.b	2
			dc.b	$87
			dc.b	afChange, SonicAniID_Walk

SonicAni_SkidToWalk3:	dc.b	1
			dc.b	$87, $88
			dc.b	afChange, SonicAniID_Walk

SonicAni_Roll:		dc.b 	-2
			rept	2
			dc.b 	$6C,$6D,$6E,$6F
			endr
			dc.b	afEnd

SonicAni_Roll2:		dc.b 	-2
			dc.b 	$6C,$70,$6D,$70,$6E,$70,$6F,$70
			dc.b	afEnd

SonicAni_Roll3:		dc.b 	-2
			rept	2
			dc.b 	$6C,$6F,$6E,$6D
			endr
			dc.b	afEnd

SonicAni_Roll4:		dc.b 	-2
			dc.b 	$6C,$70,$6F,$70,$6E,$70,$6D,$70
			dc.b	afEnd

SonicAni_Push:		dc.b 	-3
			rept	3
			dc.b	$77,$78,$79,$7A
			endr
			dc.b	afEnd

SonicAni_Wait:		dc.b	7

			rept	30
			dc.b	1
			endr
			dc.b	2,  3,  3,  3
			dc.b	4,  4,  5,  5, afBack,  4

SonicAni_Balance:	dc.b	8
			dc.b	$89, $8A
			dc.b	afEnd

SonicAni_Balance2:	dc.b	7
			dc.b	$8B,$8C
			dc.b	afEnd

SonicAni_LookUp:	dc.b	5
			dc.b	6
			dc.b	7, afBack, 1

SonicAni_Duck:		dc.b	5
			dc.b	$7F
			dc.b	$80, afBack, 1

SonicAni_Spindash:	dc.b	0
			dc.b	$71,$72,$71,$73,$71,$74,$71,$75,$71,$76
			dc.b	afEnd

SonicAni_WallRecoil1:	dc.b	$3F
			dc.b	$82
			dc.b	afEnd

SonicAni_WallRecoil2:	dc.b	7
			dc.b	8, 8, 9
			dc.b	afChange, SonicAniID_Wait ; get up from Bonk

SonicAni_WallRecoil3:	dc.b	7
			dc.b	9
			dc.b	afChange, SonicAniID_Wait	; get up

SonicAni_Stop:		dc.b	4
			dc.b	$81,$82
			dc.b	$83,$84, afBack, 2

SonicAni_Float1:	dc.b	7
			dc.b	$91,$96
			dc.b	afEnd

SonicAni_Float2:	dc.b	7
			dc.b	$91,$92,$93,$94,$95
			dc.b	afEnd

SonicAni_Spring:	dc.b	$2F
			dc.b	$7E
			dc.b	afChange,  0	; Spring up

SonicAni_Hang:		dc.b	5
			dc.b	$8F,$90
			dc.b	afEnd

SonicAni_TurnAround:	dc.b	1
			dc.b	$B, $A
			dc.b	afChange, 0	; Turning around

SonicAni_Bubble:	dc.b	$B
			dc.b	$97,$97,$12,$13
			dc.b	afChange,  SonicAniID_Walk

SonicAni_Death1:	dc.b	$20
			dc.b	$9A
			dc.b	afEnd

SonicAni_Drown:		dc.b	$20
			dc.b	$99
			dc.b	afEnd

SonicAni_Death2:	dc.b	$20
			dc.b	$98
			dc.b	afEnd

SonicAni_Shrinking:	dc.b	3
			dc.b	$4E,$4F,$50,$51,$52
			dc.b	0, afBack, 1

SonicAni_Hurt:		dc.b	12
			dc.b	$8D,$8E
			dc.b	afEnd

SonicAni_Null:		dc.b	$77
			dc.b	0
			dc.b	afChange,  SonicAniID_Walk

SonicAni_Float3:	dc.b	3
			dc.b	$91,$92,$93,$94,$95
			dc.b	afEnd

SonicAni_ContinueGetUp:	dc.b	3
			dc.b	$3C
			dc.b	afChange, SonicAniID_Walk
; ---------------------------------------------------------------------------
			even