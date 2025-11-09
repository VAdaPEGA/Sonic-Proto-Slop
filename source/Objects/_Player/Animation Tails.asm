TailsAniData:	
		dc.w TailsAni_Walk-TailsAniData,TailsAni_Run-TailsAniData; 0
		dc.w TailsAni_Roll-TailsAniData,TailsAni_Roll2-TailsAniData; 2
		dc.w TailsAni_Push_NoArt-TailsAniData,TailsAni_Wait-TailsAniData; 4
		dc.w TailsAni_Balance_NoArt-TailsAniData,TailsAni_LookUp-TailsAniData; 6
		dc.w TailsAni_Duck-TailsAniData,TailsAni_Spindash-TailsAniData;	8
		dc.w TailsAni_0A-TailsAniData,TailsAni_0B-TailsAniData;	10
		dc.w TailsAni_0C-TailsAniData,TailsAni_Stop-TailsAniData; 12
		dc.w TailsAni_Fly-TailsAniData,TailsAni_0F-TailsAniData; 14
		dc.w TailsAni_Jump-TailsAniData,TailsAni_11-TailsAniData; 16
		dc.w TailsAni_12-TailsAniData,TailsAni_13-TailsAniData;	18
		dc.w TailsAni_14-TailsAniData,TailsAni_15-TailsAniData;	20
		dc.w TailsAni_Death1-TailsAniData,TailsAni_UnusedDrown-TailsAniData; 22
		dc.w TailsAni_Death2-TailsAniData,TailsAni_19-TailsAniData; 24
		dc.w TailsAni_1A-TailsAniData,TailsAni_1B-TailsAniData;	26
		dc.w TailsAni_1C-TailsAniData,TailsAni_1D-TailsAniData;	28
		dc.w TailsAni_1E-TailsAniData; 30
TailsAni_Walk:	dc.b $FF,$10,$11,$12,$13,$14,$15, $E, $F,$FF; 0
					; DATA XREF: Tails_Animate+E2o
					; ROM:TailsAniDatao
TailsAni_Run:	dc.b $FF,$2E,$2F,$30,$31,$FF,$FF,$FF,$FF,$FF; 0
					; DATA XREF: Tails_Animate+EEo
					; ROM:TailsAniDatao
TailsAni_Roll:	dc.b   1,$48,$47,$46,$FF; 0 ; DATA XREF: Tails_Animate+18Ao
					; ROM:TailsAniDatao
TailsAni_Roll2:	dc.b   1,$48,$47,$46,$FF; 0 ; DATA XREF: Tails_Animate:loc_11B1Ao
					; ROM:TailsAniDatao
TailsAni_Push_NoArt:dc.b $FD,  9, $A, $B, $C, $D, $E,$FF; 0 ; DATA XREF: Tails_Animate+1D0o
					; ROM:TailsAniDatao
TailsAni_Wait:	dc.b   7,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  3,  2,  1,  1,  1; 0
					; DATA XREF: ROM:TailsAniDatao
		dc.b   1,  1,  1,  1,  1,  3,  2,  1,  1,  1,  1,  1,  1,  1,  1,  1; 16
		dc.b   5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5; 32
		dc.b   6,  7,  8,  7,  8,  7,  8,  7,  8,  7,  8,  6,$FE,$1C; 48
TailsAni_Balance_NoArt:dc.b $1F,  1,  2,  3,  4,  5,  6,  7,  8,$FF; 0
					; DATA XREF: ROM:TailsAniDatao
TailsAni_LookUp:dc.b $3F,  4,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_Duck:	dc.b $3F,$5B,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_Spindash:dc.b	 0,$60,$61,$62,$FF; 0 ;	DATA XREF: ROM:TailsAniDatao
TailsAni_0A:	dc.b $3F,$82,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_0B:	dc.b   7,  8,  8,  9,$FD,  5; 0	; DATA XREF: ROM:TailsAniDatao
TailsAni_0C:	dc.b   7,  9,$FD,  5	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_Stop:	dc.b   7,  1,  2,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_Fly:	dc.b   7,$5E,$5F,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_0F:	dc.b   7,  1,  2,  3,  4,  5,$FF; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_Jump:	dc.b   3,$59,$5A,$59,$5A,$59,$5A,$59,$5A,$59,$5A,$59,$5A,$FD,  0; 0
					; DATA XREF: ROM:TailsAniDatao
TailsAni_11:	dc.b   4,  1,  2,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_12:	dc.b  $F,  1,  2,  3,$FE,  1; 0	; DATA XREF: ROM:TailsAniDatao
TailsAni_13:	dc.b  $F,  1,  2,$FE,  1; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_14:	dc.b $3F,  1,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_15:	dc.b  $B,  1,  2,  3,  4,$FD,  0; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_Death1:dc.b $20,$5D,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_UnusedDrown:dc.b $2F,$5D,$FF	     ; 0 ; DATA	XREF: ROM:TailsAniDatao
TailsAni_Death2:dc.b   3,$5D,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_19:	dc.b   3,$5D,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_1A:	dc.b   3,$5C,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_1B:	dc.b   7,  1,  1,$FF	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_1C:	dc.b $77,  0,$FD,  0	; 0 ; DATA XREF: ROM:TailsAniDatao
TailsAni_1D:	dc.b   3,  1,  2,  3,  4,  5,  6,  7,  8,$FF; 0
					; DATA XREF: ROM:TailsAniDatao
TailsAni_1E:	dc.b   3,  1,  2,  3,  4,  5,  6,  7,  8,$FF