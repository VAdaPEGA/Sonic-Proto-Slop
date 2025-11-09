Ani_S1Obj64:
	IndexStart	Ani_Bub
	GenerateLocalIndex	2, small
	GenerateLocalIndex	2, medium
	GenerateLocalIndex	2, large
	GenerateLocalIndex	2, incroutine
	GenerateLocalIndex	2, incroutine
	GenerateLocalIndex	2, burst
	GenerateLocalIndex	2, bubmaker
; ===========================================================================
@small:		dc.b $E,	0, 1, 2, afRoutine		; small bubble forming
@medium:	dc.b $E,	1, 2, 3, 4, afRoutine		; medium bubble forming
@large:		dc.b $E,	2, 3, 4, 5, 6,	afRoutine	; full size bubble forming
@incroutine:	dc.b 4,		afRoutine			; increment routine counter (no animation)
@burst:		dc.b 4,		6, 7, 8, afRoutine 		; large bubble bursts
@bubmaker:	dc.b $F,	$13, $14, $15,	afEnd 		; bubble maker on the floor
; ===========================================================================