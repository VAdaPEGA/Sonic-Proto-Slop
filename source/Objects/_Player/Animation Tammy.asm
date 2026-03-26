; ---------------------------------------------------------------------------
; Animation script - Tammy
; TO DO : AUTOMATE PROCESS (This is BAD)
; ---------------------------------------------------------------------------
	IndexStart	TammyAniData, 1
	GenerateIndexID	TammyAni, Walk
	GenerateIndex	TammyAni, Run
	GenerateIndex	TammyAni, Roll
	GenerateIndex	TammyAni, Roll2
	GenerateIndex	TammyAni, Push
	GenerateIndexID	TammyAni, Wait
	GenerateIndex	TammyAni, Balance
	GenerateIndex	TammyAni, LookUp
	GenerateIndex	TammyAni, Duck
	GenerateIndex	TammyAni, Spindash
	GenerateIndex	TammyAni, 0A
	GenerateIndex	TammyAni, 0B
	GenerateIndex	TammyAni, 0C
	GenerateIndex	TammyAni, Stop
	GenerateIndex	TammyAni, Float1
	GenerateIndex	TammyAni, Float2
	GenerateIndex	TammyAni, Spring
	GenerateIndex	TammyAni, Hang
	GenerateIndex	TammyAni, TurnAround
	GenerateIndex	TammyAni, 13
	GenerateIndex	TammyAni, 14
	GenerateIndex	TammyAni, 14
	GenerateIndex	TammyAni, Death1
	GenerateIndex	TammyAni, Drown
	GenerateIndex	TammyAni, Death2
	GenerateIndex	TammyAni, Bubble
	GenerateIndex	TammyAni, Hurt
	GenerateIndex	TammyAni, Balance2
	GenerateIndex	TammyAni, 1C
	GenerateIndex	TammyAni, 1D
	GenerateIndex	TammyAni, 1E
; ---------------------------------------------------------------------------
TammyAni_Walk:		dc.b	-5
f	=	5
		AnimIncRept	6,+1
		dc.b	afEnd
TammyAni_Run:		dc.b	-5
		AnimIncRept	4,+1
		dc.b	afEnd

TammyAni_Roll2:
TammyAni_Roll:		dc.b	-5
		AnimIncRept	6,+1
		dc.b	afEnd

TammyAni_Balance:
TammyAni_Push:		dc.b	-3
			dc.b	2, 3, 4	; flutter
			dc.b	afEnd

TammyAni_Wait:		dc.b	7
		dc.b	1
		dc.b	afEnd
					
TammyAni_LookUp:	dc.b	$3F
		dc.b	1
		dc.b	afEnd

TammyAni_Duck:		dc.b	$3F
		dc.b	1
		dc.b	afEnd

TammyAni_Spindash:	dc.b	0		
		dc.b	2, 3, 4	; flutter
		dc.b	afEnd

TammyAni_0A:		dc.b	$3F	; Wall Recoil 1
TammyAni_0B:
TammyAni_0C:
		dc.b	2, 3, 4	; flutter
		dc.b	afEnd

TammyAni_Stop:		dc.b	7
		dc.b	2, 3, 4	; flutter
		dc.b	afEnd

TammyAni_Float1:	dc.b	7
		dc.b	2, 3, 4	; flutter
		dc.b	afEnd
TammyAni_Float2:	dc.b	7
		dc.b	2, 3, 4	; flutter
		dc.b	afEnd

TammyAni_Spring:	dc.b	3
		dc.b	2, 3, 4	; flutter
		dc.b	afChange, TammyAniID_Walk

TammyAni_Hang:		dc.b	4
		dc.b	2, 3, 4	; flutter
		dc.b	afEnd

TammyAni_TurnAround:	dc.b	$F	;S1 Unused Leap
		dc.b	2, 3, 4	; flutter
			dc.b	afChange, TammyAniID_Walk	; Turning around

TammyAni_13:		dc.b	$F	;S1 Unused Leap2
		dc.b	2, 3, 4	; flutter
			dc.b	afChange, TammyAniID_Walk

TammyAni_14:		dc.b	$3F	;S1 unused Slide
		dc.b	2, 3, 4	; flutter
			dc.b	afChange, TammyAniID_Walk	

TammyAni_Bubble:	dc.b	$B
		dc.b	2, 3, 4	; flutter
			dc.b	afChange,  TammyAniID_Walk

TammyAni_Death1:	dc.b	$20
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

TammyAni_Drown:		dc.b	$2F
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

TammyAni_Death2:	dc.b	3
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

TammyAni_Shrinking:	dc.b	3
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

TammyAni_Hurt:		dc.b	12
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

TammyAni_Balance2:	dc.b	7
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

TammyAni_1C:		dc.b	$77
		dc.b	2, 3, 4	; flutter
			dc.b	afChange,  TammyAniID_Walk

TammyAni_1D:		dc.b	3
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

TammyAni_1E:		dc.b	3
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd
; ---------------------------------------------------------------------------
			even