Ani_S1Obj64:
	IndexStart	Ani_Bub,	1
	GenerateLocalIndex	small
	GenerateLocalIndex	medium
	GenerateLocalIndex	large
	GenerateLocalIndex	incroutine
	GenerateLocalIndex	incroutine,1
	GenerateLocalIndex	burst
	GenerateLocalIndex	bubmaker
; ===========================================================================
@small:		dc.b $E,	0, 1, 2, afRoutine		; small bubble forming
@medium:	dc.b $E,	1, 2, 3, 4, afRoutine		; medium bubble forming
@large:		dc.b $E,	2, 3, 4, 5, 6,	afRoutine	; full size bubble forming
@incroutine:	dc.b 4,		afRoutine			; increment routine counter (no animation)
@burst:		dc.b 4,		6, 7, 8, afRoutine 		; large bubble bursts
@bubmaker:	dc.b $F,	$13, $14, $15,	afEnd 		; bubble maker on the floor
; ===========================================================================