	Nem_Add	GameOver,	\_ObjLoc, GameOver

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; Game Over
Map_Obj39:	dc.w word_C280-Map_Obj39
		dc.w word_C292-Map_Obj39
		dc.w word_C2A4-Map_Obj39
		dc.w word_C2B6-Map_Obj39

word_C280:	dc.w 2			; DATA XREF: ROM:Map_Obj39o
		dc.w $F80D,    0,    0,$FFB8; 0
		dc.w $F80D,    8,    4,$FFD8; 4
word_C292:	dc.w 2			; DATA XREF: ROM:0000C27Ao
		dc.w $F80D,  $14,   $A,	   8; 0
		dc.w $F80D,   $C,    6,	 $28; 4
word_C2A4:	dc.w 2			; DATA XREF: ROM:0000C27Co
		dc.w $F809,  $1C,   $E,$FFC4; 0
		dc.w $F80D,    8,    4,$FFDC; 4
word_C2B6:	dc.w 2			; DATA XREF: ROM:0000C27Eo
		dc.w $F80D,  $14,   $A,	  $C; 0
		dc.w $F80D,   $C,    6,	 $2C; 4


; Emeralds
Map_S1Obj7F:	dc.w word_C624-Map_S1Obj7F
		dc.w word_C62E-Map_S1Obj7F
		dc.w word_C638-Map_S1Obj7F
		dc.w word_C642-Map_S1Obj7F
		dc.w word_C64C-Map_S1Obj7F
		dc.w word_C656-Map_S1Obj7F
		dc.w word_C660-Map_S1Obj7F

		
word_C624:	dc.w 1			; DATA XREF: ROM:Map_S1Obj7Fo
		dc.w $F805,$2004,$2002,$FFF8; 0
word_C62E:	dc.w 1			; DATA XREF: ROM:0000C618o
		dc.w $F805,    0,    0,$FFF8; 0
word_C638:	dc.w 1			; DATA XREF: ROM:0000C61Ao
		dc.w $F805,$4004,$4002,$FFF8; 0
word_C642:	dc.w 1			; DATA XREF: ROM:0000C61Co
		dc.w $F805,$6004,$6002,$FFF8; 0
word_C64C:	dc.w 1			; DATA XREF: ROM:0000C61Eo
		dc.w $F805,$2008,$2004,$FFF8; 0
word_C656:	dc.w 1			; DATA XREF: ROM:0000C620o
		dc.w $F805,$200C,$2006,$FFF8; 0
word_C660:	dc.w 0			; DATA XREF: ROM:0000C622o