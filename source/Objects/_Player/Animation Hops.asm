; ---------------------------------------------------------------------------
; Animation script - Hops
; TO DO : AUTOMATE PROCESS (This is BAD)
; ---------------------------------------------------------------------------
	IndexStart	HopsAniData, 1
	GenerateIndexID	HopsAni, Walk
	GenerateIndex	HopsAni, Run
	GenerateIndex	HopsAni, Roll
	GenerateIndex	HopsAni, Roll2
	GenerateIndex	HopsAni, Push
	GenerateIndexID	HopsAni, Wait
	GenerateIndex	HopsAni, Balance
	GenerateIndex	HopsAni, LookUp
	GenerateIndex	HopsAni, Duck
	GenerateIndex	HopsAni, Spindash
	GenerateIndex	HopsAni, 0A
	GenerateIndex	HopsAni, 0B
	GenerateIndex	HopsAni, 0C
	GenerateIndex	HopsAni, Stop
	GenerateIndex	HopsAni, Float1
	GenerateIndex	HopsAni, Float2
	GenerateIndex	HopsAni, Spring
	GenerateIndex	HopsAni, Hang
	GenerateIndex	HopsAni, TurnAround
	GenerateIndex	HopsAni, 13
	GenerateIndex	HopsAni, 14
	GenerateIndex	HopsAni, 14
	GenerateIndex	HopsAni, Death1
	GenerateIndex	HopsAni, Drown
	GenerateIndex	HopsAni, Death2
	GenerateIndex	HopsAni, Bubble
	GenerateIndex	HopsAni, Hurt
	GenerateIndex	HopsAni, Balance2
	GenerateIndex	HopsAni, 1C
	GenerateIndex	HopsAni, 1D
	GenerateIndex	HopsAni, 1E
; ---------------------------------------------------------------------------
HopsAni_Walk:		dc.b	-5
f	=	5
		AnimIncRept	6,+1
		dc.b	afEnd
HopsAni_Run:		dc.b	-5
		AnimIncRept	4,+1
		dc.b	afEnd

HopsAni_Roll2:
HopsAni_Roll:		dc.b	-5
		AnimIncRept	6,+1
		dc.b	afEnd

HopsAni_Balance:
HopsAni_Push:		dc.b	-3
			dc.b	2, 3, 4	; flutter
			dc.b	afEnd

HopsAni_Wait:		dc.b	7
		dc.b	1
		dc.b	afEnd
					
HopsAni_LookUp:	dc.b	$3F
		dc.b	1
		dc.b	afEnd

HopsAni_Duck:		dc.b	$3F
		dc.b	1
		dc.b	afEnd

HopsAni_Spindash:	dc.b	0		
		dc.b	2, 3, 4	; flutter
		dc.b	afEnd

HopsAni_0A:		dc.b	$3F	; Wall Recoil 1
HopsAni_0B:
HopsAni_0C:
		dc.b	2, 3, 4	; flutter
		dc.b	afEnd

HopsAni_Stop:		dc.b	7
		dc.b	2, 3, 4	; flutter
		dc.b	afEnd

HopsAni_Float1:	dc.b	7
		dc.b	2, 3, 4	; flutter
		dc.b	afEnd
HopsAni_Float2:	dc.b	7
		dc.b	2, 3, 4	; flutter
		dc.b	afEnd

HopsAni_Spring:	dc.b	3
		dc.b	2, 3, 4	; flutter
		dc.b	afChange, HopsAniID_Walk

HopsAni_Hang:		dc.b	4
		dc.b	2, 3, 4	; flutter
		dc.b	afEnd

HopsAni_TurnAround:	dc.b	$F	;S1 Unused Leap
		dc.b	2, 3, 4	; flutter
			dc.b	afChange, HopsAniID_Walk	; Turning around

HopsAni_13:		dc.b	$F	;S1 Unused Leap2
		dc.b	2, 3, 4	; flutter
			dc.b	afChange, HopsAniID_Walk

HopsAni_14:		dc.b	$3F	;S1 unused Slide
		dc.b	2, 3, 4	; flutter
			dc.b	afChange, HopsAniID_Walk	

HopsAni_Bubble:	dc.b	$B
		dc.b	2, 3, 4	; flutter
			dc.b	afChange,  HopsAniID_Walk

HopsAni_Death1:	dc.b	$20
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

HopsAni_Drown:		dc.b	$2F
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

HopsAni_Death2:	dc.b	3
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

HopsAni_Shrinking:	dc.b	3
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

HopsAni_Hurt:		dc.b	12
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

HopsAni_Balance2:	dc.b	7
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

HopsAni_1C:		dc.b	$77
		dc.b	2, 3, 4	; flutter
			dc.b	afChange,  HopsAniID_Walk

HopsAni_1D:		dc.b	3
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd

HopsAni_1E:		dc.b	3
		dc.b	2, 3, 4	; flutter
			dc.b	afEnd
; ---------------------------------------------------------------------------
			even