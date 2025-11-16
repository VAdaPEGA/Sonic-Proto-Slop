; ===========================================================================
; Different Spring types
	Nem_Add VSpring,	Objects\Springs\,	Spring_Vertical
	Nem_Add HSpring,	Objects\Springs\,	Spring_Horizontal
	Nem_Add DSpring,	Objects\Springs\,	Spring_Diagonal

; ===========================================================================

Obj41_SlopeData_DiagUp:
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		dc.b $10,$10,$10,$10
		dc.b  $E, $C, $A,  8
		dc.b   6,  4,  2,  0
		dc.b $FE,$FC,$FC,$FC
		dc.b $FC,$FC,$FC,$FC
; byte_E950:
Obj41_SlopeData_DiagDown:
		dc.b $F4,$F0,$F0,$F0
		dc.b $F0,$F0,$F0,$F0
		dc.b $F0,$F0,$F0,$F0
		dc.b $F2,$F4,$F6,$F8
		dc.b $FA,$FC,$FE,  0
		dc.b   2,  4,  4,  4
		dc.b   4,  4,  4,  4
; ===========================================================================
; animation script
Ani_obj41:	dc.w byte_E978-Ani_obj41
		dc.w byte_E97B-Ani_obj41
		dc.w byte_E987-Ani_obj41
		dc.w byte_E98A-Ani_obj41
		dc.w byte_E996-Ani_obj41
		dc.w byte_E999-Ani_obj41
byte_E978:	dc.b  $F,  0,$FF
byte_E97B:	dc.b   0,  1,  0,  0,  2,  2,  2,  2
		dc.b   2,  2,$FD,  0
byte_E987:	dc.b  $F,  3,$FF
byte_E98A:	dc.b   0,  4,  3,  3,  5,  5,  5,  5
		dc.b   5,  5,$FD,  2
byte_E996:	dc.b  $F,  7,$FF
byte_E999:	dc.b   0,  8,  7,  7,  9,  9,  9,  9
		dc.b   9,  9,$FD,  4,  0

; ----------------------------------------------------------------------------
; Primary sprite mappings for springs (Red)
; ----------------------------------------------------------------------------
Map_Springs:
		IndexStart	Map_obj41	
		GenerateIndex	2, Map_SpringVertical
		GenerateIndex	2, word_EA5C
		GenerateIndex	2, word_EA66
		GenerateIndex	2, Map_SpringHorizontal
		GenerateIndex	2, word_EA8A
		GenerateIndex	2, word_EA94
		GenerateIndex	2, word_EAA6
		GenerateIndex	2, Map_SpringDiagonal
		GenerateIndex	2, word_EADA
		GenerateIndex	2, word_EAF4
		GenerateIndex	2, word_EB16
; -------------------------------------------------------------------------------
; Secondary sprite mappings for springs (Yellow)
; merged with the above mappings; can't split to file in a useful way...
; -------------------------------------------------------------------------------
		IndexStart	Map_obj41a
		GenerateIndex	2, Map_SpringVertical
		GenerateIndex	2, word_EA5C
		GenerateIndex	2, word_EA66
		GenerateIndex	2, Map_SpringHorizontal
		GenerateIndex	2, word_EA8A
		GenerateIndex	2, word_EA94
		GenerateIndex	2, word_EAA6
		GenerateIndex	2, Map_SpringDiagonal_Alt
		GenerateIndex	2, word_EB5A
		GenerateIndex	2, word_EB74
		GenerateIndex	2, word_EB96
Map_SpringVertical:	
		dc.w 2
		dc.w $F00D,    0,    0,$FFF0
		dc.w	 5,    8,    4,$FFF8
word_EA5C:	dc.w 1
		dc.w $F80D,    0,    0,$FFF0
word_EA66:	dc.w 2
		dc.w $E00D,    0,    0,$FFF0
		dc.w $F007,   $C,    6,$FFF8
Map_SpringHorizontal:	
		dc.w 2
		dc.w $F003,    0,    0,	   0
		dc.w $F801,    4,    2,$FFF8
word_EA8A:	dc.w 1
		dc.w $F003,    0,    0,$FFF8
word_EA94:	dc.w 2
		dc.w $F003,    0,    0,	 $10
		dc.w $F809,    6,    3,$FFF8
word_EAA6:	dc.w 2
		dc.w	$D,$1000,$1000,$FFF0
		dc.w $F005,$1008,$1004,$FFF8
Map_SpringDiagonal:	
		dc.w 4
		dc.w $F00D,    0,    0,$FFF0
		dc.w	 5,    8,    4,	   0
		dc.w $FB05,   $C,    6,$FFF6
		dc.w	 5,$201C,$200E,$FFF0
word_EADA:	dc.w 3
		dc.w $F60D,    0,    0,$FFEA
		dc.w  $605,    8,    4,$FFFA
		dc.w	 5,$201C,$200E,$FFF0
word_EAF4:	dc.w 4
		dc.w $E60D,    0,    0,$FFFB
		dc.w $F605,    8,    4,	  $B
		dc.w $F30B,  $10,    8,$FFF6
		dc.w	 5,$201C,$200E,$FFF0
word_EB16:	dc.w 4
		dc.w	$D,$1000,$1000,$FFF0
		dc.w $F005,$1008,$1004,	   0
		dc.w $F505,$100C,$1006,$FFF6
		dc.w $F005,$301C,$300E,$FFF0
Map_SpringDiagonal_Alt:	
		dc.w 4
		dc.w $F00D,    0,    0,$FFF0
		dc.w	 5,    8,    4,	   0
		dc.w $FB05,   $C,    6,$FFF6
		dc.w	 5,  $1C,   $E,$FFF0
word_EB5A:	dc.w 3
		dc.w $F60D,    0,    0,$FFEA
		dc.w  $605,    8,    4,$FFFA
		dc.w	 5,  $1C,   $E,$FFF0
word_EB74:	dc.w 4
		dc.w $E60D,    0,    0,$FFFB
		dc.w $F605,    8,    4,	  $B
		dc.w $F30B,  $10,    8,$FFF6
		dc.w	 5,  $1C,   $E,$FFF0
word_EB96:	dc.w 4
		dc.w	$D,$1000,$1000,$FFF0
		dc.w $F005,$1008,$1004,	   0
		dc.w $F505,$100C,$1006,$FFF6
		dc.w $F005,$101C,$100E,$FFF0