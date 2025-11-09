; ---------------------------------------------------------------------------
	Map_Add	Platforms_EHZ,	Objects\Platforms\,	Platforms_EHZ
; ---------------------------------------------------------------------------
Map_Obj18x:	dc.w word_8ADE-Map_Obj18x ; DATA XREF: ROM:Map_Obj18xo
					; ROM:00008ADCo
		dc.w word_8AF0-Map_Obj18x
word_8ADE:	dc.w 2	
		dc.w $F40B,  $3C,  $1E,$FFE8; 0
		dc.w $F40B,  $48,  $24,	   0; 4
word_8AF0:	dc.w $A	
		dc.w $F40F,  $CA,  $65,$FFE0; 0
		dc.w  $40F,  $DA,  $6D,$FFE0; 4
		dc.w $240F,  $DA,  $6D,$FFE0; 8
		dc.w $440F,  $DA,  $6D,$FFE0; 12
		dc.w $640F,  $DA,  $6D,$FFE0; 16
		dc.w $F40F, $8CA, $865,	   0; 20
		dc.w  $40F, $8DA, $86D,	   0; 24
		dc.w $240F, $8DA, $86D,	   0; 28
		dc.w $440F, $8DA, $86D,	   0; 32
		dc.w $640F, $8DA, $86D,	   0; 36