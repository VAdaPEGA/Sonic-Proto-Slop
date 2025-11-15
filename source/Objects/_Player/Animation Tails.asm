; ---------------------------------------------------------------------------
; Animation script - Tails
; TO DO : AUTOMATE PROCESS (This is BAD)
; ---------------------------------------------------------------------------
	IndexStart	TailsAniData
	GenerateIndexID	1, TailsAni, Walk
	GenerateIndex	1, TailsAni, Run
	GenerateIndex	1, TailsAni, Roll
	GenerateIndex	1, TailsAni, Roll2
	GenerateIndex	1, TailsAni, Push
	GenerateIndexID	1, TailsAni, Wait
	GenerateIndex	1, TailsAni, Balance
	GenerateIndex	1, TailsAni, LookUp
	GenerateIndex	1, TailsAni, Duck
	GenerateIndex	1, TailsAni, Spindash
	GenerateIndex	1, TailsAni, 0A
	GenerateIndex	1, TailsAni, 0B
	GenerateIndex	1, TailsAni, 0C
	GenerateIndex	1, TailsAni, Stop
	GenerateIndex	1, TailsAni, Float1
	GenerateIndex	1, TailsAni, Float2
	GenerateIndex	1, TailsAni, Spring
	GenerateIndex	1, TailsAni, Hang
	GenerateIndex	1, TailsAni, 12
	GenerateIndex	1, TailsAni, 13
	GenerateIndex	1, TailsAni, 14
	GenerateIndex	1, TailsAni, 14
	GenerateIndex	1, TailsAni, Death1
	GenerateIndex	1, TailsAni, Drown
	GenerateIndex	1, TailsAni, Death2
	GenerateIndex	1, TailsAni, Bubble
	GenerateIndex	1, TailsAni, Hurt
	GenerateIndex	1, TailsAni, Balance2
	GenerateIndex	1, TailsAni, 1C
	GenerateIndex	1, TailsAni, 1D
	GenerateIndex	1, TailsAni, 1E
	GenerateIndexID	1, TailsAni, Fly
; ---------------------------------------------------------------------------
TailsAni_Walk:		dc.b	-1
			dc.b	$10,$11,$12,$13,$14,$15, $E, $F
			dc.b	afEnd

TailsAni_Run:		dc.b	-1
			rept	2
			dc.b	$2E,$2F,$30,$31
			endr
			dc.b	afEnd

TailsAni_Roll:		dc.b	-2
			dc.b	$48,$47,$46
			dc.b	afEnd

TailsAni_Roll2:		dc.b	-2
			dc.b	$48,$47,$46
			dc.b	afEnd

TailsAni_Push:		dc.b	-3
			dc.b	9, $A, $B, $C, $D, $E
			dc.b	afEnd

TailsAni_Wait:		dc.b	7
		rept 10
			dc.b	1
		endr
			dc.b	3,  2
		rept 8
			dc.b	1
		endr
			dc.b	3,  2
		rept 9
			dc.b	1
		endr
		@Loop:
		rept 16
			dc.b	5
		endr
			dc.b	6,  7,  8,  7,  8,  7,  8,  7,  8,  7,  8,  6, afBack, *-@Loop-2

TailsAni_Balance:	dc.b	$1F
@Fr	=	$69
			dc.b	@Fr, @Fr+1
			dc.b	afEnd
					
TailsAni_LookUp:	dc.b	$3F,  4
			dc.b	afEnd

TailsAni_Duck:		dc.b	$3F,$5B
			dc.b	afEnd

TailsAni_Spindash:	dc.b	0
			dc.b	$60,$61,$62
			dc.b	afEnd

TailsAni_0A:		dc.b	$3F	; Wall Recoil 1
			dc.b	$82
			dc.b	afEnd

TailsAni_0B:		dc.b	7	; Wall Recoil 2
			dc.b	8,  8,  9
			dc.b	afChange,  TailsAniID_Wait

TailsAni_0C:		dc.b	7	; Wall Recoil 3
			dc.b	9
			dc.b	afChange,  TailsAniID_Wait

TailsAni_Stop:		dc.b	7
@Fr	=	$67
			dc.b	@Fr,  @Fr+1
			dc.b	afEnd

TailsAni_Fly:		dc.b	7
			dc.b	$5E,$5F
			dc.b	afEnd

TailsAni_Float1:	dc.b	7
			dc.b	$6E,$73
			dc.b	afEnd
TailsAni_Float2:	dc.b	7
@Fr	=	$6E
			dc.b	@Fr, @Fr+1,  @Fr+2,  @Fr+3,  @Fr+4
			dc.b	afEnd

TailsAni_Spring:	dc.b	3
			dc.b	$59,$5A,$59,$5A,$59,$5A,$59,$5A,$59,$5A,$59,$5A
			dc.b	afChange, TailsAniID_Walk

TailsAni_Hang:		dc.b	4
@Fr	=	$6C
			dc.b	@Fr,  @Fr+1
			dc.b	afEnd

TailsAni_12:		dc.b	$F	;S1 Unused Leap
			dc.b	1,  2
			dc.b	3,afBack,  1

TailsAni_13:		dc.b	$F	;S1 Unused Leap2
			dc.b	1
			dc.b	2,afBack,  1

TailsAni_14:		dc.b	$3F	;S1 unused Slide
			dc.b	1
			dc.b	afEnd	

TailsAni_Bubble:	dc.b	$B
			dc.b	$74,$74,$12,$13
			dc.b	afChange,  TailsAniID_Walk

TailsAni_Death1:	dc.b	$20
			dc.b	$5D
			dc.b	afEnd

TailsAni_Drown:		dc.b	$2F
			dc.b	$5D
			dc.b	afEnd

TailsAni_Death2:	dc.b	3
			dc.b	$5D
			dc.b	afEnd

TailsAni_Shrinking:	dc.b	3
			dc.b	$5D
			dc.b	afEnd

TailsAni_Hurt:		dc.b	12
			dc.b	$5C,$6B
			dc.b	afEnd

TailsAni_Balance2:	dc.b	7
@Fr	=	$69
			dc.b	@Fr, @Fr+1
			dc.b	afEnd

TailsAni_1C:		dc.b	$77
			dc.b	0
			dc.b	afChange,  TailsAniID_Walk

TailsAni_1D:		dc.b	3
			dc.b	1,  2,  3,  4,  5,  6,  7,  8
			dc.b	afEnd

TailsAni_1E:		dc.b	3
			dc.b	1,  2,  3,  4,  5,  6,  7,  8
			dc.b	afEnd
			even