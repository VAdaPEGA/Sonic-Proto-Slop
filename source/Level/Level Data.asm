; ===========================================================================
; Other Level Inclusions:
		include	"Level/Level Animated Blocks.asm"
; ===========================================================================
; Level layouts, three entries per act (although the third one is unused)
; ---------------------------------------------------------------------------
Level_Index:	
c		=	0
		rept	ZoneCount
		dc.w	(Level1_\#c)-Level_Index,(LevelBG_\#c)-Level_Index,Level_Null-Level_Index
		dc.w	(Level2_\#c)-Level_Index,(LevelBG_\#c)-Level_Index,Level_Null-Level_Index
		dc.w	(Level3_\#c)-Level_Index,(LevelBG_\#c)-Level_Index,Level_Null-Level_Index
		dc.w	(LevelB_\#c)-Level_Index,(LevelBG_\#c)-Level_Index,Level_Null-Level_Index
c		=	c+1
		endr
; ---------------------------------------------------------------------------
c		=	0
		rept	ZoneCount
_temp	equs	_ZoneFolder\#c
LevelB_\#c:	
	if	(filesize("\_temp\Data/Layout_Boss.bin")=-1)
		else
		incbin	"\_temp\Data/Layout_Boss.bin"
		even
	endif
Level3_\#c:	
	if	(filesize("\_temp\Data/Layout_3.bin")=-1)
		else
		incbin	"\_temp\Data/Layout_3.bin"
		even
	endif
Level2_\#c:	
	if	(filesize("\_temp\Data/Layout_2.bin")=-1)
		else
		incbin	"\_temp\Data/Layout_2.bin"
		even
	endif
Level1_\#c:	incbin	"\_temp\Data/Layout_1.bin"
		even
LevelBG_\#c:	incbin	"\_temp\Data/Layout_BG.bin"
		even
c		=	c+1
		endr

Level_Null:	dc.b   0,  0,  0,  0
; ===========================================================================
; Object layouts
; ---------------------------------------------------------------------------
ObjPos_Index:	
c		=	0
		rept	ZoneCount
		dc.w	(@ObjPos1_\#c)-ObjPos_Index,ObjPos_Null-ObjPos_Index
		dc.w	(@ObjPos2_\#c)-ObjPos_Index,ObjPos_Null-ObjPos_Index
		dc.w	(@ObjPos3_\#c)-ObjPos_Index,ObjPos_Null-ObjPos_Index
		dc.w	(@ObjPosB_\#c)-ObjPos_Index,ObjPos_Null-ObjPos_Index
c		=	c+1
		endr
; ---------------------------------------------------------------------------
c		=	0
		rept	ZoneCount
		dc.w 	$FFFF,    0,    0
_temp	equs	_ZoneFolder\#c
@ObjPosB_\#c:
	if	(filesize("\_temp\Data/ObjPos_Boss.bin")=-1)
		else
		incbin	"\_temp\Data/ObjPos_Boss.bin"
		dc.w 	$FFFF,   0,    0
	endif
@ObjPos3_\#c:	
	if	(filesize("\_temp\Data/ObjPos_3.bin")=-1)
		else
		incbin	"\_temp\Data/ObjPos_3.bin"
		dc.w 	$FFFF,   0,    0
	endif

@ObjPos2_\#c:	
	if	(filesize("\_temp\Data/ObjPos_2.bin")=-1)
		else
		incbin	"\_temp\Data/ObjPos_2.bin"
		dc.w 	$FFFF,   0,    0
	endif

@ObjPos1_\#c:	incbin	"\_temp\Data/ObjPos_1.bin"

c		=	c+1
		endr
ObjPos_Null	dc.w	$FFFF,    0,    0
; ===========================================================================
; Ring layouts
; ---------------------------------------------------------------------------
RingPos_Index:	
c		=	0
		rept	ZoneCount
		dc.w	(@RingPos1_\#c)-RingPos_Index
		dc.w	(@RingPos2_\#c)-RingPos_Index
		dc.w	(@RingPos3_\#c)-RingPos_Index
		dc.w	(@RingPosB_\#c)-RingPos_Index
c		=	c+1
		endr
; ---------------------------------------------------------------------------
c		=	0
		rept	ZoneCount
		dc.w 	$FFFF,    0
_temp	equs	_ZoneFolder\#c
@RingPosB_\#c:
	if	(filesize("\_temp\Data/RingPos_Boss.bin")=-1)
		else
		incbin	"\_temp\Data/RingPos_Boss.bin"
	endif
@RingPos3_\#c:	
	if	(filesize("\_temp\Data/RingPos_3.bin")=-1)
		else
		incbin	"\_temp\Data/RingPos_3.bin"
	endif

@RingPos2_\#c:	
	if	(filesize("\_temp\Data/RingPos_2.bin")=-1)
		else
		incbin	"\_temp\Data/RingPos_2.bin"
	endif
@RingPos1_\#c:	incbin	"\_temp\Data/RingPos_1.bin"
c		=	c+1
		endr
; ===========================================================================
; Palette
; ---------------------------------------------------------------------------
c	=	0
		rept ZoneCount
_temp	equs	_ZoneFolder\#c
ZonePal_\#c:
	if	(ZonePal_Water\#c)
		incbin	"\_temp\Palette/PalWater_1.bin"
	endif
		incbin	"\_temp\Palette/PalMain_1.bin"

	if	(ZonePal_Water\#c)
		incbin	"\_temp\Palette/PalWater_2.bin"
	endif
		incbin	"\_temp\Palette/PalMain_2.bin"

	if	(ZonePal_Water\#c)
		incbin	"\_temp\Palette/PalWater_3.bin"
	endif
		incbin	"\_temp\Palette/PalMain_3.bin"

	if	(ZonePal_Water\#c)
		incbin	"\_temp\Palette/PalWater_B.bin"
	endif
		incbin	"\_temp\Palette/PalMain_B.bin"
c	=	c+1
		endr
; ---------------------------------------------------------------------------
; Zone Specific palette Cycles

Pal_GHZCyc:	incbin "level/GHZ/Palette/PalCycle_1.bin"
Pal_EHZCyc:	incbin "level/EHZ/Palette/PalCycle_1.bin"

Pal_HTZCyc1:	incbin "level/HTZ/Palette/PalCycle_1.bin"
Pal_HTZCyc2:	incbin "level/HTZ/Palette/PalCycle_Delay.bin"

Pal_CPZCyc1:	incbin "level/CPZ/Palette/PalCycle_1.bin"
Pal_CPZCyc2:	incbin "level/CPZ/Palette/PalCycle_2.bin"
Pal_CPZCyc3:	incbin "level/CPZ/Palette/PalCycle_3.bin"

Pal_HPZCyc1:	incbin "level/HPZ/Palette/PalCycle_1.bin"
Pal_HPZCyc2:	incbin "level/HPZ/Palette/PalCycle_Water1.bin"
; ===========================================================================
; Level Mappings and Collision
; ---------------------------------------------------------------------------
c	=	0
		rept ZoneCount
_temp	equs	_ZoneFolder\#c
Map16x16_\#c:	incbin	"\_temp\Data/map16.mapeni"
		even
Map128x128_\#c:	incbin	"\_temp\Data/map128.bin"
		even
ColP_\#c:	incbin	"\_temp\Data/ColP.bin"
		even
ColS_\#c:	incbin	"\_temp\Data/ColS.bin"
		even
c		=	c+1
		endr
AngleMap:	incbin	"Level/Curve and resistance mapping.bin"
		even
ColArray1:	incbin	"Level/Collision array 1.bin"
		even
ColArray2:	incbin	"Level/Collision array 2.bin"
		even

; ===========================================================================
; Music for each Zone and returning from drowning / invincibility
; ---------------------------------------------------------------------------
MusicList:	dc.b	MusID_GHZ
		dc.b	MusID_LZ
		dc.b	MusID_CPZ
		dc.b	MusID_EHZ
		dc.b	MusID_HPZ
		dc.b	MusID_HTZ
		dc.b	$8D
		even
; ===========================================================================
; Level Headers
; ---------------------------------------------------------------------------
LevelArtPointers:
c		=	0
		rept ZoneCount
		dc.l (map16x16_\#c)+((PLCID_GHZ2+(c*2))<<24)	; 16x16 Block Mappings + (PLC2)
		dc.l (map128x128_\#c)		; 128x128 Chunks
		dc.l (ZonePal_\#c)+(($FF*ZonePal_Water\#c)<<24)	; Zone palette
		dc.w (PLCID_GHZ+(c*2)),(PLCID_GHZ2+(c*2))		; Zone Art (PLC1)
c		=	c+1
		endr

; ===========================================================================
; Corkscrew position and Flipma data for EHZ
; ===========================================================================
QuirkyCorkscrewData:	; Flip_angle of player and Floor Angle of Corkscrews
QuirkyCorkscrew_FlipmaData			macro	Flipma, Angle
		if	(Flipma)=0
		dc.b	1, Angle
		else
		dc.b	(($16)*Flipma), Angle
		endif
		endm
QuirkyCorkscrew_Chunk1_Flipma:	; Going Upwards		Flipma,	Angle
		QuirkyCorkscrew_FlipmaData		0,	 $00
		QuirkyCorkscrew_FlipmaData		1,	 $08
		QuirkyCorkscrew_FlipmaData		2,	-$0C
		QuirkyCorkscrew_FlipmaData		2,	-$10
		QuirkyCorkscrew_FlipmaData		3,	-$14
		QuirkyCorkscrew_FlipmaData		3,	-$18
		QuirkyCorkscrew_FlipmaData		4,	-$1C
		QuirkyCorkscrew_FlipmaData		4,	-$20
QuirkyCorkscrew_Chunk2_Flipma:	; Up to Down
		QuirkyCorkscrew_FlipmaData		5,	-$1C
		QuirkyCorkscrew_FlipmaData		5,	-$14
		QuirkyCorkscrew_FlipmaData		6,	-$10
		QuirkyCorkscrew_FlipmaData		6,	-$08
		QuirkyCorkscrew_FlipmaData		6,	 $08
		QuirkyCorkscrew_FlipmaData		7,	 $10
		QuirkyCorkscrew_FlipmaData		7,	 $14
		QuirkyCorkscrew_FlipmaData		8,	 $1C
QuirkyCorkscrew_Chunk3_Flipma:	; Going Downwards
		QuirkyCorkscrew_FlipmaData		8,	 $20
		QuirkyCorkscrew_FlipmaData		9,	 $1C
		QuirkyCorkscrew_FlipmaData		9,	 $18
		QuirkyCorkscrew_FlipmaData		10,	 $14
		QuirkyCorkscrew_FlipmaData		10,	 $10
		QuirkyCorkscrew_FlipmaData		11,	 $0C
		QuirkyCorkscrew_FlipmaData		11,	 $08
		QuirkyCorkscrew_FlipmaData		0,	 $00
QuirkyCorkscrew_DDiag_Flipma:	; Going Downwards
		QuirkyCorkscrew_FlipmaData		10,	 $1C
		QuirkyCorkscrew_FlipmaData		10,	 $1C
		QuirkyCorkscrew_FlipmaData		10,	 $1C
		QuirkyCorkscrew_FlipmaData		10,	 $1C
		QuirkyCorkscrew_FlipmaData		10,	 $1C
		QuirkyCorkscrew_FlipmaData		10,	 $1C
		QuirkyCorkscrew_FlipmaData		10,	 $1C
		QuirkyCorkscrew_FlipmaData		10,	 $1C
; ===========================================================================
	; Y position of player relative to chunk

QuirkyCorkscrew_Reposition	macro	
c	=	\1
			rept	narg-1
			dc.b	(\2+c)-64
			shift
		endr
		endm
QuirkyCorkscrew_Chunk1_Pos:
	QuirkyCorkscrew_Reposition	0,	 32, 32, 32, 32, 32, 32, 32, 32
	QuirkyCorkscrew_Reposition	0,	 32, 32, 32, 32, 32, 32, 31, 31
	QuirkyCorkscrew_Reposition	0,	 31, 31, 31, 31, 31, 31, 31, 31
	QuirkyCorkscrew_Reposition	0,	 31, 31, 31, 31, 31, 30, 30, 30
	QuirkyCorkscrew_Reposition	0,	 30, 30, 30, 30, 30, 30, 29, 29
	QuirkyCorkscrew_Reposition	0,	 29, 29, 29, 28, 28, 28, 28, 27
	QuirkyCorkscrew_Reposition	0,	 27, 27, 27, 26, 26, 26, 25, 25
	QuirkyCorkscrew_Reposition	0,	 25, 24, 24, 24, 23, 23, 22, 22
	QuirkyCorkscrew_Reposition	0,	 21, 21, 20, 20, 19, 18, 18, 17
	QuirkyCorkscrew_Reposition	0,	 16, 16, 15, 14, 14, 13, 12, 12
	QuirkyCorkscrew_Reposition	0,	 11, 10, 10,  9,  8,  8,  7,  6
	QuirkyCorkscrew_Reposition	0,	  6,  5,  4,  4,  3,  2,  1,  0
	QuirkyCorkscrew_Reposition	0,	 -1, -1, -2, -2, -3, -4, -4, -5
	QuirkyCorkscrew_Reposition	0,	 -6, -7, -7, -8, -9, -9,-10,-10
	QuirkyCorkscrew_Reposition	0,	-11,-11,-12,-12,-13,-14,-14,-15
	QuirkyCorkscrew_Reposition	0,	-15,-16,-16,-17,-17,-18,-18,-19

QuirkyCorkscrew_Chunk1_1_Pos:
	QuirkyCorkscrew_Reposition	128,	 32, 32, 32, 32, 32, 32, 32, 32
	QuirkyCorkscrew_Reposition	128,	 32, 32, 32, 32, 32, 32, 31, 31
	QuirkyCorkscrew_Reposition	128,	 31, 31, 31, 31, 31, 31, 31, 31
	QuirkyCorkscrew_Reposition	128,	 31, 31, 31, 31, 31, 30, 30, 30
	QuirkyCorkscrew_Reposition	128,	 30, 30, 30, 30, 30, 30, 29, 29
	QuirkyCorkscrew_Reposition	128,	 29, 29, 29, 28, 28, 28, 28, 27
	QuirkyCorkscrew_Reposition	128,	 27, 27, 27, 26, 26, 26, 25, 25
	QuirkyCorkscrew_Reposition	128,	 25, 24, 24, 24, 23, 23, 22, 22
	QuirkyCorkscrew_Reposition	128,	 21, 21, 20, 20, 19, 18, 18, 17
	QuirkyCorkscrew_Reposition	128,	 16, 16, 15, 14, 14, 13, 12, 12
	QuirkyCorkscrew_Reposition	128,	 11, 10, 10,  9,  8,  8,  7,  6
	QuirkyCorkscrew_Reposition	128,	  6,  5,  4,  4,  3,  2,  1,  0
	QuirkyCorkscrew_Reposition	128,	 -1, -1, -2, -2, -3, -4, -4, -5
	QuirkyCorkscrew_Reposition	128,	 -6, -7, -7, -8, -9, -9,-10,-10
	QuirkyCorkscrew_Reposition	128,	-11,-11,-12,-12,-13,-14,-14,-15
	QuirkyCorkscrew_Reposition	128,	-15,-16,-16,-17,-17,-18,-18,-19

QuirkyCorkscrew_Chunk2_Pos:
	QuirkyCorkscrew_Reposition	128,	-19,-19,-20,-21,-21,-22,-22,-23
	QuirkyCorkscrew_Reposition	128,	-23,-24,-24,-25,-25,-26,-26,-27
	QuirkyCorkscrew_Reposition	128,	-27,-28,-28,-28,-29,-29,-30,-30
	QuirkyCorkscrew_Reposition	128,	-30,-31,-31,-31,-32,-32,-32,-33
	QuirkyCorkscrew_Reposition	128,	-33,-33,-33,-34,-34,-34,-35,-35
	QuirkyCorkscrew_Reposition	128,	-35,-35,-35,-35,-35,-35,-36,-36
	QuirkyCorkscrew_Reposition	128,	-36,-36,-36,-36,-36,-36,-36,-37
	QuirkyCorkscrew_Reposition	128,	-37,-37,-37,-37,-37,-37,-37,-37
	QuirkyCorkscrew_Reposition	128,	-37,-37,-37,-37,-37,-37,-37,-37
	QuirkyCorkscrew_Reposition	128,	-37,-37,-37,-37,-37,-37,-37,-37
	QuirkyCorkscrew_Reposition	128,	-37,-37,-37,-37,-36,-36,-36,-36
	QuirkyCorkscrew_Reposition	128,	-36,-36,-36,-35,-35,-35,-35,-35
	QuirkyCorkscrew_Reposition	128,	-35,-35,-35,-34,-34,-34,-33,-33
	QuirkyCorkscrew_Reposition	128,	-33,-33,-32,-32,-32,-31,-31,-31
	QuirkyCorkscrew_Reposition	128,	-30,-30,-30,-29,-29,-28,-28,-28
	QuirkyCorkscrew_Reposition	128,	-27,-27,-26,-26,-25,-25,-24,-24

QuirkyCorkscrew_Chunk3_Pos:
	QuirkyCorkscrew_Reposition	128,	-23,-23,-22,-22,-21,-21,-20,-19
	QuirkyCorkscrew_Reposition	128,	-19,-18,-18,-17,-16,-16,-15,-14
	QuirkyCorkscrew_Reposition	128,	-14,-13,-12,-11,-11,-10, -9, -8
	QuirkyCorkscrew_Reposition	128,	 -7, -7, -6, -5, -4, -3, -2, -1
	QuirkyCorkscrew_Reposition	128,	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	128,	  8,  8,  9, 10, 10, 11, 12, 13
	QuirkyCorkscrew_Reposition	128,	 13, 14, 14, 15, 15, 16, 16, 17
	QuirkyCorkscrew_Reposition	128,	 17, 18, 18, 19, 19, 20, 20, 21
	QuirkyCorkscrew_Reposition	128,	 21, 22, 22, 23, 23, 24, 24, 24
	QuirkyCorkscrew_Reposition	128,	 25, 25, 25, 25, 26, 26, 26, 26
	QuirkyCorkscrew_Reposition	128,	 27, 27, 27, 27, 28, 28, 28, 28
	QuirkyCorkscrew_Reposition	128,	 28, 28, 29, 29, 29, 29, 29, 29
	QuirkyCorkscrew_Reposition	128,	 29, 30, 30, 30, 30, 30, 30, 30
	QuirkyCorkscrew_Reposition	128,	 31, 31, 31, 31, 31, 31, 31, 31
	QuirkyCorkscrew_Reposition	128,	 31, 31, 32, 32, 32, 32, 32, 32
	QuirkyCorkscrew_Reposition	128,	 32, 32, 32, 32, 32, 32, 32, 32

QuirkyCorkscrew_Chunk3_1_Pos:
	QuirkyCorkscrew_Reposition	0,	-23,-23,-22,-22,-21,-21,-20,-19
	QuirkyCorkscrew_Reposition	0,	-19,-18,-18,-17,-16,-16,-15,-14
	QuirkyCorkscrew_Reposition	0,	-14,-13,-12,-11,-11,-10, -9, -8
	QuirkyCorkscrew_Reposition	0,	 -7, -7, -6, -5, -4, -3, -2, -1
	QuirkyCorkscrew_Reposition	0,	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	0,	  8,  8,  9, 10, 10, 11, 12, 13
	QuirkyCorkscrew_Reposition	0,	 13, 14, 14, 15, 15, 16, 16, 17
	QuirkyCorkscrew_Reposition	0,	 17, 18, 18, 19, 19, 20, 20, 21
	QuirkyCorkscrew_Reposition	0,	 21, 22, 22, 23, 23, 24, 24, 24
	QuirkyCorkscrew_Reposition	0,	 25, 25, 25, 25, 26, 26, 26, 26
	QuirkyCorkscrew_Reposition	0,	 27, 27, 27, 27, 28, 28, 28, 28
	QuirkyCorkscrew_Reposition	0,	 28, 28, 29, 29, 29, 29, 29, 29
	QuirkyCorkscrew_Reposition	0,	 29, 30, 30, 30, 30, 30, 30, 30
	QuirkyCorkscrew_Reposition	0,	 31, 31, 31, 31, 31, 31, 31, 31
	QuirkyCorkscrew_Reposition	0,	 31, 31, 32, 32, 32, 32, 32, 32
	QuirkyCorkscrew_Reposition	0,	 32, 32, 32, 32, 32, 32, 32, 32

QuirkyCorkscrew_DDiag_Pos:
	QuirkyCorkscrew_Reposition	-(8*4),	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	-(8*3),	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	-(8*2),	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	-8,	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	0,	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	8,	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(8*2),	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(8*3),	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(8*4),	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(8*5),	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(8*6),	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(8*7),	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(8*8),	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(8*9),	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(8*10),	  0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(8*11),	  0,  1,  2,  3,  4,  5,  6,  7

QuirkyCorkscrew_DDiag_1_Pos:
	QuirkyCorkscrew_Reposition	(128-(8*4)),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128-(8*3)),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128-(8*2)),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128-8),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	128,	  	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128+8),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128+8*2),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128+8*3),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128+8*4),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128+8*5),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128+8*6),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128+8*7),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128+8*8),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128+8*9),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128+8*10),	0,  1,  2,  3,  4,  5,  6,  7
	QuirkyCorkscrew_Reposition	(128+8*11),	0,  1,  2,  3,  4,  5,  6,  7
; ===========================================================================
; Main Zone Art
c		=	0
	rept	ZoneCount
_temp	equs	_ZoneFolder\#c
_temp2	equs	_ZoneName\#c
	Nem_Add		\_temp2\, \_temp\Art/, ZoneArt
c	=	c+1
	endr
; ===========================================================================
; Compressed Object Art, Mappings and Animation when available
obcunt	= 1
	rept	ObjCount-1
_temp	equs	_Obj\#obcunt
_ObjLoc	equs	"Objects/\_temp\/"
		
		if	filesize("\_ObjLoc\/\_temp\.ArtNem")=-1
		else	
	Nem_Add	\_temp, \_ObjLoc, \_temp
		endif

		if	filesize("\_ObjLoc\/\_temp\.SprMap")=-1
		else
Map_\_temp:	incbin	"\_ObjLoc\/\_temp\.SprMap"
		even
		endif

		if	filesize("\_ObjLoc\/Map_\_temp\.asm")=-1
		else
Map_\_temp:	include	"\_ObjLoc\/Map_\_temp\.asm"
		even
		endif

		if	filesize("\_ObjLoc\/ArtIncludes.asm")=-1
		else
		include	"\_ObjLoc\/ArtIncludes.asm"
		even
		endif

		if	filesize("\_ObjLoc\/Animation.asm")=-1
		else
Ani_\_temp:	include	"\_ObjLoc\/Animation.asm"
		even
		endif
obcunt	=	obcunt+1
	endr

; ===========================================================================

	Artunc_Add	none, EHZFlower1,	Level\EHZ\Art\, Ani_Flower1
	Artunc_Add	none, EHZFlower2,	Level\EHZ\Art\, Ani_Flower2
	Artunc_Add	none, EHZFlower3,	Level\EHZ\Art\, Ani_Flower3
	Artunc_Add	none, EHZFlower4,	Level\EHZ\Art\, Ani_Flower4
	Artunc_Add	none, EHZFlower5,	Level\EHZ\Art\, Ani_Ball

	Artunc_Add	none, HPZBbackground,	Level\HPZ\Art\, Ani_Background
	Artunc_Add	none, HPZGlowingBall,	Level\HPZ\Art\, Ani_GlowingBall

; ---------------------------------------------------------------------------

ArtUnc_UnkZone_1:	
		dc.l $12332411,$12334199,$12331999,$12331999,$12331999,$12343199,$12313311,$12222222; 0
		dc.l $11423333,$99143333,$99913333,$99913333,$99913333,$99133333,$11333333,$22222222; 8
		dc.l $33332411,$333341BB,$33331BBB,$33331BBB,$33331BBB,$333331BB,$33333311,$22222222; 16
		dc.l $11423321,$BB143321,$BBB13321,$BBB13321,$BBB13321,$BB134321,$11331321,$22222221; 24
		dc.l $12332411,$123341BB,$12331BBB,$12331BBB,$12331BBB,$123431BB,$12313311,$12222222; 32
		dc.l $11423333,$BB143333,$BBB13333,$BBB13333,$BBB13333,$BB133333,$11333333,$22222222; 40
		dc.l $33332411,$33334199,$33331999,$33331999,$33331999,$33333199,$33333311,$22222222; 48
		dc.l $11423321,$99143321,$99913321,$99913321,$99913321,$99134321,$11331321,$22222221; 56
ArtUnc_UnkZone_2:	
		dc.l $13333334,$11111111,$13333334,$13333334,$11111111,$13333334,$13333334,$14444444; 0
		dc.l $13333334,$11111111,$13333334,$13333334,$11111111,$13333334,$13333334,$14444444; 8
		dc.l $11111111,$14444445,$14444445,$15555555,$15555555,$11111111,$15555555,$15555555; 16
		dc.l $11111111,$14444445,$14444445,$15555555,$15555555,$11111111,$15555555,$15555555; 24
		dc.l $15555555,$15555555,$11111111,$15555555,$15555555,$14444445,$14444445,$11111111; 32
		dc.l $15555555,$15555555,$11111111,$15555555,$15555555,$14444445,$14444445,$11111111; 40
		dc.l $14444444,$13333334,$13333334,$11111111,$13333334,$13333334,$11111111,$13333334; 48
		dc.l $14444444,$13333334,$13333334,$11111111,$13333334,$13333334,$11111111,$13333334; 56
		dc.l $13333334,$13333334,$11111111,$13333334,$13333334,$13333334,$11111111,$14444445; 64
		dc.l $11111111,$13333334,$11111111,$13333334,$13333334,$11111111,$13333334,$14444445; 72
		dc.l $14444445,$14444445,$15555555,$11111111,$15555555,$15555555,$15555555,$15555555; 80
		dc.l $14444445,$11111111,$14444445,$15555555,$15555555,$15555555,$11111111,$15555555; 88
		dc.l $15555555,$11111111,$15555555,$15555555,$15555555,$14444445,$11111111,$14444445; 96
		dc.l $15555555,$15555555,$15555555,$15555555,$11111111,$15555555,$14444445,$14444445; 104
		dc.l $14444445,$13333334,$11111111,$13333334,$13333334,$11111111,$13333334,$11111111; 112
		dc.l $14444445,$11111111,$13333334,$13333334,$13333334,$11111111,$13333334,$13333334; 120
		dc.l $11111111,$13333334,$11111111,$13333334,$13333334,$11111111,$13333334,$14444445; 128
		dc.l $13333334,$13333334,$11111111,$13333334,$13333334,$13333334,$11111111,$14444445; 136
		dc.l $14444445,$11111111,$14444445,$15555555,$15555555,$15555555,$11111111,$15555555; 144
		dc.l $14444445,$14444445,$15555555,$11111111,$15555555,$15555555,$15555555,$15555555; 152
		dc.l $15555555,$15555555,$15555555,$15555555,$11111111,$15555555,$14444445,$14444445; 160
		dc.l $15555555,$11111111,$15555555,$15555555,$15555555,$14444445,$11111111,$14444445; 168
		dc.l $14444445,$11111111,$13333334,$13333334,$13333334,$11111111,$13333334,$13333334; 176
		dc.l $14444445,$13333334,$11111111,$13333334,$13333334,$11111111,$13333334,$11111111; 184
ArtUnc_UnkZone_3:	
		dc.l $11111111,$13111131,$13111131,$14333341,$12222221,$12222221,$11111111,$11111111; 0
		dc.l $11111111,$13111131,$13111131,$14333341,$12222221,$12222221,$11111111,$11111111; 8
		dc.l $13111131,$13111131,$14333341,$12222221,$12222221,$11111111,$11111111,$11111111; 16
		dc.l $11111111,$11111111,$13111131,$13111131,$14333341,$12222221,$12222221,$11111111; 24
		dc.l $11111111,$11111111,$13111131,$13111131,$14333341,$12222221,$12222221,$11111111; 32
		dc.l $13111131,$13111131,$14333341,$12222221,$12222221,$11111111,$11111111,$11111111; 40
ArtUnc_UnkZone_4:	
		dc.l $22222233,$15111111,$11111455,$11145555,$1115B555,$11455B55,$115555B5,$1155555B; 0
		dc.l $33434445,$11111151,$55411111,$55554111,$55555111,$55555411,$55555511,$55555511; 8
		dc.l $22222233,$15111111,$11111455,$1114555B,$1115555B,$1145555B,$1155555B,$1155555B; 16
		dc.l $33434445,$11111151,$55411111,$55554111,$55555111,$55555411,$55555511,$55555511; 24
		dc.l $22222233,$15111111,$11111455,$11145555,$11155555,$11455555,$11555555,$1155555B; 32
		dc.l $33434445,$11111151,$55411111,$55554111,$55B55111,$5B555411,$B5555511,$55555511; 40
ArtUnc_UnkZone_5:	
		dc.l $11111111,$15511222,$15511222,$11155111,$11155111,$12211551,$12211551,$12211115; 0
		dc.l $11111111,$12211222,$12211222,$11155111,$11155111,$12211551,$12211551,$12211115; 8
		dc.l $11111111,$12211222,$12211222,$11122111,$11122111,$12211551,$12211551,$12211115; 16
		dc.l $11111111,$12211222,$12211222,$11122111,$11122111,$12211221,$12211221,$12211115; 24
		dc.l $11111111,$12211222,$12211222,$11122111,$11122111,$12211221,$12211221,$12211112; 32
		dc.l $11111111,$12211555,$12211555,$11155111,$11155111,$15511221,$15511221,$15511112; 40
ArtUnc_UnkZone_6:	
		dc.l	     0,	       0,	 0,	   0,	     0,	$2222222,$22222222,$22222222; 0
		dc.l	  $234,	    $234,     $234,	$234,	  $234,$22000234,$22222234,$22222211; 8
		dc.l $43200000,$43200000,$43200000,$43200000,$43200000,$43200044,$43234444,$11233333; 16
		dc.l	     0,	       0,	 0,	   0,	     0,$55555500,$44455555,$33444444; 24
		dc.l	     0,	       0,	 0,	   0,	     0,	     $44,    $4433,    $3332; 32
		dc.l	  $234,	    $234,     $234,	$234,	  $234,$33300234,$32222234,$22222211; 40
		dc.l $43200000,$43200000,$43200000,$43200000,$43200000,$43200054,$43225543,$11354432; 48
		dc.l	     0,	       0,	 0,	   0,	     0,$32000000,$32220000,$22220000; 56
		dc.l	     0,	       0,	 0,	   0,	     0,	       0,	 0,	   0; 64
		dc.l	  $234,	    $234,     $234,	$234,	  $234,	    $223,    $2334,    $2211; 72
		dc.l $43200000,$43200000,$43200000,$43200000,$43200000,$45200000,$44500000,$11250000; 80
		dc.l	     0,	       0,	 0,	   0,	     0,	       0,	 0,	   0; 88
ArtUnc_UnkZone_7:	
		dc.l	     0,	       0,	 0,	   0,	 $8700,	 $688786,$87876887,$68767768; 0
		dc.l	     0,	       0,	 0,	   0,$80000000,$67600000,$87876007,$68767768; 8
		dc.l	     0,	       0,	 0,	   0,	 $8700,	 $688786,$87876887,$68767768; 16
		dc.l	     0,	       0,	 0,	   0,	   $68,	   $8786,$87876887,$68767768; 24
		dc.l	     0,	       0,	 0,	   0,$88778000,$67688780,$87876887,$68767768; 32
		dc.l	     0,	       0,	 0,	   0,	     8,	   $8786,$87876887,$68767768; 40
		dc.l	     0,	       0,	 0,	   0,	 $8000,	     $86,$80076887,$68767768; 48
		dc.l	     0,	       0,	 0,	   0,$88778760,$67688786,$87876887,$68767768; 56
		dc.l	     0,	       0,	 0,	   0,	     0,$67680000,$87876887,$68767768; 64
		dc.l	     0,	       0,	 0,	   0,	     0,$67600000,$87876800,$68767768; 72
		dc.l	     0,	       0,	 0,	   0,	   $68,	   $8786,  $876887,$68767768; 80
		dc.l	     0,	       0,	 0,	   0,$88700000,$67688780,$87876887,$68767768; 88
		dc.l	     0,	       0,	 0,	   0,$80000000,$67688700,$87876887,$68767768; 96
		dc.l	     0,	       0,	 0,	   0,	     0,	       6,$87000887,$68767768; 104
		dc.l	     0,	       0,	 0,	   0,  $778760,$67688786,$87876887,$68767768; 112
		dc.l	     0,	       0,	 0,	   0,  $778700,$67688786,$87876887,$68767768; 120
		dc.l	     0,	       0,	 0,	   0,	     0,$60000000,$87800087,$68767768; 128
		dc.l	     0,	       0,	 0,	   0,	$78700,	$7688786,$87876887,$68767768; 136
ArtUnc_UnkZone_8:	
		dc.l  $6600666,	$7777777, $8888888,	   0, $6600666,	$7777777, $8888888,	   0; 0
		dc.l	     0,	$6600666, $7777777, $8888888,	     0,	$6600666, $7777777, $8888888; 8
		dc.l  $8888888,	       0, $6600666, $7777777, $8888888,	       0, $6600666, $7777777; 16
		dc.l  $7777777,	$8888888,	 0, $6600666, $7777777,	$8888888,	 0, $6600666; 24


; ===========================================================================

Demo_EHZ:	dc.b   0,$44,  8,  0,$28,  5,  8,$59,$28,  4,  8,$35,$28,  6,  8,$42; 0
		dc.b $28,  4,  8,$19,  0, $F,  8, $A,$28,  9,  8,$4A,$28,  9,  8,$10; 16
		dc.b   0,  5,  4,$1B,  2,  0,  8,$4B,$28,$2D,  8,$55,$28,  9,  8,$26; 32
		dc.b $28,$1C,  8,$19,$28,  8,  8,$FF,  8,$96,$28,$13,  8,$1D,$28,$19; 48
		dc.b   8,$2A,$28,  7,  9,  0,  1,  0,  5,$20,  4,  2,  5,  1,  0,  0; 64
		dc.b   8,$3A,  0,$25,  4, $A,$24,  9,  4,$1C,  0,  3,  8,$3A,$28,  6; 80
		dc.b   8, $C,  0,$16,  8,  0,$28, $F,  8,$33,$28,  7,  8,  4,  0,$46; 96
		dc.b   8,$6A,  0,$29,$80,  0,$C0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 112
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 128
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 144
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 160
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 176
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 192
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 208
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 224
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 240
Demo_2P:	dc.b   0,$46,  8,$1E,$28, $A,  8,$5E,$28,$30,  8,$66,  0, $F,  8, $F; 0
		dc.b $28,$2E,  8,  0,  0,$1F,  8,$12,  0,$13,  8, $A,  0,$16,  4, $D; 16
		dc.b   0,  8,  4,$10,  0,$30,  8,$6B,$28,$14,  8,$80, $A,  2,  2,$23; 32
		dc.b   0,  7,  8,$13,$28,$17,  8,  0,  0,  3,  4,  3,  5,  0,  1,  0; 48
		dc.b   9,  1,  8,$3C,$28,  7,  0,$18,  8,$4D,$28,$12,  8,  1,  0,  4; 64
		dc.b   8, $B,  0,  7,  8,$1B,  0,  9,$20,  5,$28,$13,  8,  4,  0,$21; 80
		dc.b   8,$11,  0,$20,  8,$51,  0, $B,  4,$57,  0, $D,  2,$27, $A,  0; 96
		dc.b   0,  2,  9,  1,  8,$2A,$28,$15,  8,  3,$28,$19,  8, $A,  0, $A; 112
		dc.b   8,  2,$28,$1B,  8,$33,  0,$27,  8,$3A,  9,$12,  1,  7,  0,$13; 128
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 144
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 160
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 176
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 192
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 208
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 224
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 240
Demo_HTZ:	dc.b   0,  5,  1,$1D,  9,  3,$29,  5,  9,$10,  1,  0,  0,$13,  4,  0; 0
		dc.b   5, $A,$25,  7,  5,$10,  4,  1,  0, $C,  8,  4,  9, $C,$29, $A; 16
		dc.b   9,$10,  8,  3,  0,$1C,$20,  7,  0, $B,  4,  6,  0,$25,$20,  6; 32
		dc.b   0,$22,  8,  5,  0,$25,  4, $E,  0,$33,  8,  7,  0,$39,  8, $A; 48
		dc.b $28,  8,  8,$16,  0,$24,  8,$74,$28,  2,$29,  7,  9,  3,  0, $F; 64
		dc.b   8, $D,  0,  5,  4, $C,  0,  1,$20,  2,$28,  0,$2A,  8,$28,  2; 80
		dc.b   8,$1E,  0,  4,  4,$13,  0,$12,  8,$18,$28, $B,  8,$11,  0,$2C; 96
		dc.b   8, $C,  0, $D,$20,  4,$28,  3,  8,  5,  0,$22,  4,$12,  0,  4; 112
		dc.b   8,$1A,  0, $D,  4,  6,  0,$37,  8, $C,  0,$19,  8, $D,  0, $C; 128
		dc.b   4,  9,  0,  3,  8,$20,  0,$1A,  4,  6,  0,$22,  8,  9,  0,  9; 144
		dc.b   8,$16,  0,$2F,  8, $E,$28,  4,$20,  2,  0,  8,  4,$19,  0,  5; 160
		dc.b   8,  6,$28,  8,  8,  8,  0,$24,  8,$72, $A,  9,  2, $E, $A,$6B; 176
		dc.b $8A,  0,$40,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 192
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 208
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 224
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 240
Demo_HPZ:	dc.b   0,$40,  8,$33,$28,  6,  8,$39,$28,  5,  8, $D,  0,$25,  8,$10; 0
		dc.b $28,$2A,  8,$1C,  2,  0,$26,  3,$22,  0,$2A,  0,$28,  6,  8,$22; 16
		dc.b   2,  0,  6, $F,  4,  8,  6,  0,  2, $E,  6,$2F,  2,$79,  6,  1; 32
		dc.b   4,$43,$24, $F,  4,$17,  0,  9,  8,$1C,$28,  3,  8,$45,  0,  5; 48
		dc.b   8,$1A,$28,$33,  8,$72,  0, $F,  4,$15,$24,$10,  4, $B,  0,$24; 64
		dc.b   4,  1,$24,  8,  4,  7,  0,  6,  4,  4,  0,$1E,$24, $E,  4,$15; 80
		dc.b   0,$1E,$20,  3,$24, $F,  4,  0,  0,  7,  8,$12,  4,  9,$24, $F; 96
		dc.b   4,  6,  0, $A,  4,$62,$24,$12,$20,  4,  0,$21,$28, $E,  8,$16; 112
		dc.b   0,$19,  8,$29,  0,$63,  4,$15,$24,  9,  4,$39,  0,$31,  8,$25; 128
		dc.b $28,  2,  8,$12,  0,$93,$80,  0,$C0,  0,  0,  0,  0,  0,  0,  0; 144
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 160
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 176
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 192
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 208
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 224
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 240
Demo_CPZ:	dc.b   0,$1B,  1,$30,  0,$19,  8,$29,$28,$13,  8,  3,  0,$1D,$20,  3; 0
		dc.b $28,$1E,  8,  2,  0,  9,  4,  5,  0,$2E,  8,$1E,$28,  5,$20,  3; 16
		dc.b   0, $B,  4,  1,  5,  7,  4,  0,  0,$2F,$28,  3,$2A,  4, $A,  0; 32
		dc.b   8,  6,  0,$24,  8,  2,$28,  6,  8,  1,  0,$26,  8,$FF,  8,$14; 48
		dc.b $28, $A,  8,  3,  0,$60,  8, $E,$28,  7,  8, $C,  0,  8,  4, $B; 64
		dc.b   0,$23,  8,  5,  0,$93,  8,$19,$28,$11,  8,$78,$28, $F,  8,$FF; 80
		dc.b   8,$83,$28, $D,  8,$82,  0,$1F,$80,  0,$40,  0,  0,  0,  0,  0; 96
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 112
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 128
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 144
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 160
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 176
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 192
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 208
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 224
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 240
Demo_S1GHZ:	dc.b   0,$4A,  8,$61,$28, $B,  8,$47,$28,  7,  8,$3B,$28,  8,  8,$D1; 0
		dc.b $28,$10,  8, $A,  0, $E,$20,$12,$28,  4,  8,$1F,  0, $B,  6,  5; 16 ; leftover demo from Sonic 1 GHZ
		dc.b   4,  5,  0,  4,$20, $B,$28, $E,  8,$20,  0,  5,$20,  2,$28,$12; 32
		dc.b   8, $F,  0, $F,  8, $B,  0,  0,$20, $E,$28,  4,  8, $B,  0,$1A; 48
		dc.b   8, $C,  0,  6,$20,$12,$28,  7,  8,$77,$28,  0,$20, $C,$24,  4; 64
		dc.b $20,  7,$28,  6,  8,  4,  0, $F,  8,$39,  0,$11,  8, $D,$28, $A; 80
		dc.b   8,$50,$28, $F,  8,  5,  0,$14,  8,$FF,  8,$56,  0,$FF,  0,$3F; 96
		dc.b   8,  0,$28, $E,  8,$17,  0,$17,  8,  5,  0,  0,  0,  0,  0,  0; 112
		dc.b   0,  9,  8,$78,  0,  6,  8,  6,  0,  3,$20,  5,$28,$11,  8, $D; 128
		dc.b   0,$2B,  8,  2,$29,  7,  9,  2,  0,  7,  5, $F,  0,  8,  8, $D; 144
		dc.b $28,  7,  8, $B,  0,$28,  8,  0,  9,  2,$29,  2,$28,  4,  8,$12; 160
		dc.b   0,  9,  8,  0,$29,  2,$28,  4,  8,  9,  0, $F,  8, $C,  0, $E; 176
		dc.b   9,  0,$29,  8,  9,  2,  8,$18,  0,  9,$28,  0,$29, $A,  9,$12; 192
		dc.b   8,  0,  0,$18,$29,$10,  9,$10,  8,  3,  0,$2F,  5,  6,  0,  9; 208
		dc.b   8,  0,  9,  1,$29,$12,  9,  0,  8,  5,  0,$24,  8,  0,  9,  0; 224
		dc.b $29,  9,$28,  6,  8, $A,  0,$2A,  8,$1B,  0,$17,  4,  5,  0, $C; 240
		dc.b   8,$20,  0,  4,$20,  3,  0, $E,  9,  4,  1,  0,  0,$1E,  8,  5; 256
		dc.b   0,  1,$20,  6,$29,  1,  5,  7,  0,$13,  8,  5,  0,$15,$20,  1; 272
		dc.b $28,  2,$29,  4,  9,  1,  8,  0,  0,  7,  8, $B,  0,$19,  8, $B; 288
		dc.b $28,  6,  8,  5,  0,$12,  8,$11,  0, $C,$20,  2,$28,  4,  8,  4; 304
		dc.b   0,$15,  8, $C,  0,$14,$20,  4,$28,  0,  8,  2,  0,$18,  8,  3; 320
		dc.b   0,$2C,$20,  2,$28,  7,  8,  4,  0,$24,  6,$48,  4,$47,  0, $A; 336
		dc.b   4,  7,  0,$14,  4,$44,  5,  0,  4,  0,  0,$15,  8,$15, $A,  1; 352
		dc.b   0,  8,  4,  2,  5,$14,  0,  1,  5,  1,$25, $D,  5,$1B,  0,  7; 368
		dc.b   8,$23,  9,  0,  0,  7,  5,$22,$25, $B,  5,$52,  0,  6,  8,$26; 384
		dc.b   9,  1,  1,  0,  0,  0,  1,  0,  5,$17,$25,  8,  5,$1A,  0, $C; 400
		dc.b   8,  6,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 416
		dc.b   0,$11,  8,$37,$28,  4,  8, $A,  0,$12,  8, $B,  0,$1F,  8,$1B; 432
		dc.b   0,  9,  8,$20,  0,$14,  4,$16,$24,  0,$20, $F,  0,$13,  4,$17; 448
		dc.b   6,  4,  2,  0,  0,$24,  8, $D,  0,$46,  8,$77,  0,$60,  8,$17; 464
		dc.b   0,$16,  4,  3,  0,$22,  8,$19,$28,  2,$20,  1,  0,$26,$20,  9; 480
		dc.b   0,$3A,$20,$23,  0,  3,  8,  1,  0,$29,  4,$13,  0,$19,  4,$1B; 496
		dc.b   0,$91,  8,$21,  0,$19,  4,  4,  0,$67,  4,$23,  0, $A,  8,  5; 512
		dc.b   0,$87,  8,$21,  0,$2C,  8,$27,  0, $F,  8,$35,$28,  8,  8,$45; 528
		dc.b $28,  9,  8,$31,  0,$99,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 544
Demo_S1SS:	dc.b   0,$26,  4,  5,  0,$2A,  8,$1B,  0,  6,  4,  9,  0,  6,$20,  1; 0
		dc.b $28,  1,$29,  2,  9,  0,  8,  8,  0,  6,  8,  7,  0,$49,  8, $B; 16 ; leftover demo from Sonic 1 Special Stage
		dc.b   0,  2,$20,  3,  0, $D,  8,$1D,  0,$13,  8,  6,  0,$21,  8,$21; 32
		dc.b   0,  6,  8,$36,  0,$1E,  8,$1A,  0,  6,$20,  0,$28,  4,  8,$19; 48
		dc.b   0,  4,  4,$11,  0,$1F,  4, $D,  0, $C,  4,$1E,  5,  1,  4,  0; 64
		dc.b   0,  9,  8, $C,  0,  6,  4,  5,  5,  1,  4,$87,$24,  7,  4,  4; 80
		dc.b   0,  4,  8, $D,  9,$14,  8,  4,  0,  3,  4,$17,$24,$13,  4, $A; 96
		dc.b   0,  4,  9,  9,  8,  2,  0,  6,  4,$18,$24, $B,$20,  4,  0,  2; 112
		dc.b   4,$2E,  5,  1,  4,  0,  0,$13,$20,$14,  0,  4,  8,$19,  0,$10; 128
		dc.b $20,$1D,$24,  7,  4, $E,  0, $B,$20,$1B,$24,  5,  4,$17,$24,  0; 144
		dc.b $20,$18,$24,  5,  4, $B,  0,  8,$20,$1F,$24,  1,  4,  8,  0, $B; 160
		dc.b $20,$12,$28,  7,$29, $C,$20,  0,  4,$18,  0,$1A,  8,  0,  9,  7; 176
		dc.b   8,  9,  9,$31,  8,  0,  0,  7,$20,  8,$24,$15,  4,  8,  0,$27; 192
		dc.b $20,  9,$24,$12,  4, $E,$24, $E,  4, $A,  0,  9,  8,$16,$28,  0; 208
		dc.b $20, $F,$28,  4,$29,$1B,  9,  5,$29, $C,  9,  0,  8,  7,  0,$A0; 224
		dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 240