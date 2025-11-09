; ---------------------------------------------------------------------------
; Animation script - Sonic
; TO DO : AUTOMATE PROCESS (This is BAD)
; ---------------------------------------------------------------------------
	IndexStart	SonicAniData
	GenerateIndexID	1, SonicAni, Walk
	GenerateIndex	1, SonicAni, SkidToWalk
	GenerateIndexID	1, SonicAni, Roll
	GenerateIndexID	1, SonicAni, Roll2
	GenerateIndexID	1, SonicAni, Push
	GenerateIndexID	1, SonicAni, Wait
	GenerateIndexID	1, SonicAni, Balance
	GenerateIndexID	1, SonicAni, LookUp
	GenerateIndexID	1, SonicAni, Duck
	GenerateIndexID	1, SonicAni, Spindash
	GenerateIndexID	1, SonicAni, WallRecoil1
	GenerateIndexID	1, SonicAni, WallRecoil2
	GenerateIndexID	1, SonicAni, 0C
	GenerateIndexID	1, SonicAni, Stop
	GenerateIndexID	1, SonicAni, Float1
	GenerateIndexID	1, SonicAni, Float2
	GenerateIndexID	1, SonicAni, 10
	GenerateIndexID	1, SonicAni, S1LZHang
	GenerateIndexID	1, SonicAni, TurnAround
	GenerateIndexID	1, SonicAni, SkidToWalk
	GenerateIndexID	1, SonicAni, SkidToWalk2
	GenerateIndexID	1, SonicAni, SkidToWalk3
	GenerateIndexID	1, SonicAni, Death1
	GenerateIndexID	1, SonicAni, Drown
	GenerateIndexID	1, SonicAni, Death2
	GenerateIndexID	1, SonicAni, Bubble
	GenerateIndexID	1, SonicAni, Hurt
	GenerateIndexID	1, SonicAni, Balance2
	GenerateIndexID	1, SonicAni, 1C
	GenerateIndexID	1, SonicAni, Float3
	GenerateIndexID	1, SonicAni, 1E
SonicAni_Walk:		dc.b 	$FF
			dc.b 	$10,$11,$12,$13,$14,$15,$16,$17, $C, $D, $E, $F, afEnd

SonicAni_Run:		dc.b 	$FF
			dc.b 	$3C,$3D,$3E,$3F,$3C,$3D,$3E,$3F
			dc.b	afEnd, afEnd, afEnd, afEnd, afEnd

SonicAni_SkidToWalk:	dc.b	1
			dc.b	$85,$86,$87, afChange, 0
SonicAni_SkidToWalk2:	dc.b	2
			dc.b	$87, afChange, 0
SonicAni_SkidToWalk3:	dc.b	1
			dc.b	$87, $88, afChange, 0

SonicAni_Roll:		dc.b 	$FE
			dc.b 	$6C,$70,$6D,$70,$6E,$70,$6F,$70, afEnd
SonicAni_Roll2:		dc.b 	$FE
			dc.b 	$6C,$70,$6D,$70,$6E,$70,$6F,$70, afEnd
SonicAni_Push:		dc.b 	$FD
			dc.b	$77,$78,$79,$7A,$77,$78,$79,$7A
			dc.b	afEnd, afEnd, afEnd, afEnd, afEnd
SonicAni_Wait:		dc.b	7
			dc.b	1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1
			dc.b	1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  2
			dc.b	3,  3,  3,  4,  4,  5,  5, afBack,  4
SonicAni_Balance:	dc.b	8
			dc.b	$89, $8A,afEnd
SonicAni_Balance2:	dc.b	7
			dc.b	$8B,$8C, afEnd
SonicAni_LookUp:	dc.b	5
			dc.b	6, 7, afBack, 1
SonicAni_Duck:		dc.b	5,$7F,$80,afBack, 1
SonicAni_Spindash:	dc.b	0,$71,$72,$71,$73,$71,$74,$71,$75,$71,$76,$71,$FF
SonicAni_WallRecoil1:	dc.b	$3F
			dc.b	$82, afEnd
SonicAni_WallRecoil2:	dc.b	7
			dc.b	8, 8, 9, afChange, 5 ; get up from Bonk
SonicAni_0C:		dc.b	7
			dc.b	9, afChange, 5	; get up
SonicAni_Stop:		dc.b	4
			dc.b	$81,$82,$83,$84, afBack, 2
SonicAni_Float1:	dc.b	7
			dc.b	$94,$96, afEnd
SonicAni_Float2:	dc.b	7
			dc.b	$91,$92,$93,$94,$95, afEnd
SonicAni_10:		dc.b	$2F
			dc.b	$7E, afChange,  0	; Spring up
SonicAni_S1LZHang:	dc.b	5
			dc.b	$8F,$90,afEnd
SonicAni_TurnAround:	dc.b	1
			dc.b	$B, $A, afChange, 0	; Turning around
SonicAni_Bubble:	dc.b	$B
			dc.b	$97,$97,$12,$13, afChange, 0
SonicAni_Death1:	dc.b	$20
			dc.b	$9A, afEnd
SonicAni_Drown:		dc.b	$20
			dc.b	$99, afEnd
SonicAni_Death2:	dc.b	$20
			dc.b	$98, afEnd
SonicAni_Unused19:	dc.b	3
			dc.b	$4E,$4F,$50,$51,$52, 0, afBack, 1
SonicAni_Hurt:		dc.b	12
			dc.b	$8D,$8E, afEnd
SonicAni_1C:		dc.b	$77
			dc.b	0,$FD,  0
SonicAni_Float3:	dc.b	3
			dc.b	$91,$92,$93,$94,$95, afEnd
SonicAni_1E:		dc.b	3
			dc.b	$3C, afChange, 0
	even