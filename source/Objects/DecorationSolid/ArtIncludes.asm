; ---------------------------------------------------------------------------
	Nem_Add	RockGHZ,	\_ObjLoc,	GHZRock
	Nem_Add	HPZ_Diamond,	\_ObjLoc, 	HPZ_Diamond
; ---------------------------------------------------------------------------
	IndexStart	Map_DecorationSolid
	GenerateLocalIndex	GHZRock
	GenerateLocalIndex	HPZEmerald
@GHZRock:	dc.w	(@GHZRock_End-@GHZRock)/8
	MAP_Entry	-24, -16, $0B,	0,	0, 0, 0, 0
	MAP_Entry	  0, -16, $0B,	$C,	0, 0, 0, 0
@GHZRock_End:
@HPZEmerald:	dc.w	2
		dc.w	$F00F,	0,	0,	$FFE0
		dc.w	$F00F,	$10,	8,	0
; ---------------------------------------------------------------------------	
DecorationSolid_Data:
	dc.l	Map_DecorationSolid
@macro	macro	VRAM, Width, Height, RenderW, Speeds
	dc.w	VRAM
	dc.b	Width, Height/2
	dc.l	Speeds+RenderW<<24
	endm ;	VRAM,		Width,	Height,	RenderWidth,	Speeds
	@macro	($6C0+$6000),	27,	32,	19,	SmashSpd_2Pieces	; GHZ Rock
	@macro	($392+$6000),	32,	32,	30,	SmashSpd_2Pieces	; HPZ Emerald
; ---------------------------------------------------------------------------
SmashSpd_2Pieces:	;X_Vel	;Y_Vel
	dc.w	2-1
	dc.w		-$200,	-$200
	dc.w		 $200,	-$200
; ===========================================================================
Obj3C_FragSpdRight:
		dc.w	$400,$FB00	; 0
		dc.w	$600,$FF00	; 2
		dc.w	$600, $100	; 4
		dc.w	$400, $500	; 6
		dc.w	$600,$FA00	; 8
		dc.w	$800,$FE00	; 10
		dc.w	$800, $200	; 12
		dc.w	$600, $600	; 14
Obj3C_FragSpdLeft:
		dc.w $FA00,$FA00	; 0
		dc.w $F800,$FE00	; 2
		dc.w $F800, $200	; 4
		dc.w $FA00, $600	; 6
		dc.w $FC00,$FB00	; 8
		dc.w $FA00,$FF00	; 10
		dc.w $FA00, $100	; 12
		dc.w $FC00, $500	; 14


Map_Obj3C:	dc.w word_CA6C-Map_Obj3C
		dc.w word_CAAE-Map_Obj3C
		dc.w word_CAF0-Map_Obj3C
word_CA6C:	dc.w 8
		dc.w $E005,    0,    0,$FFF0; 0
		dc.w $F005,    0,    0,$FFF0; 4
		dc.w	 5,    0,    0,$FFF0; 8
		dc.w $1005,    0,    0,$FFF0; 12
		dc.w $E005,    4,    2,	   0; 16
		dc.w $F005,    4,    2,	   0; 20
		dc.w	 5,    4,    2,	   0; 24
		dc.w $1005,    4,    2,	   0; 28
word_CAAE:	dc.w 8	
		dc.w $E005,    4,    2,$FFF0; 0
		dc.w $F005,    4,    2,$FFF0; 4
		dc.w	 5,    4,    2,$FFF0; 8
		dc.w $1005,    4,    2,$FFF0; 12
		dc.w $E005,    4,    2,	   0; 16
		dc.w $F005,    4,    2,	   0; 20
		dc.w	 5,    4,    2,	   0; 24
		dc.w $1005,    4,    2,	   0; 28
word_CAF0:	dc.w 8	
		dc.w $E005,    4,    2,$FFF0; 0
		dc.w $F005,    4,    2,$FFF0; 4
		dc.w	 5,    4,    2,$FFF0; 8
		dc.w $1005,    4,    2,$FFF0; 12
		dc.w $E005,    8,    4,	   0; 16
		dc.w $F005,    8,    4,	   0; 20
		dc.w	 5,    8,    4,	   0; 24
		dc.w $1005,    8,    4,	   0; 28
; ===========================================================================