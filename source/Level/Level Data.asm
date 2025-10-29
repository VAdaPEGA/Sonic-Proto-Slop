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
	if	(filesize("\_temp\Layout_Boss.bin")=-1)
		else
		incbin	"\_temp\Layout_Boss.bin"
		even
	endif
Level3_\#c:	
	if	(filesize("\_temp\Layout_3.bin")=-1)
		else
		incbin	"\_temp\Layout_3.bin"
		even
	endif
Level2_\#c:	
	if	(filesize("\_temp\Layout_2.bin")=-1)
		else
		incbin	"\_temp\Layout_2.bin"
		even
	endif
Level1_\#c:	incbin	"\_temp\Layout_1.bin"
		even
LevelBG_\#c:	incbin	"\_temp\Layout_BG.bin"
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
	if	(filesize("\_temp\ObjPos_Boss.bin")=-1)
		else
		incbin	"\_temp\ObjPos_Boss.bin"
		dc.w 	$FFFF,   0,    0
	endif
@ObjPos3_\#c:	
	if	(filesize("\_temp\ObjPos_3.bin")=-1)
		else
		incbin	"\_temp\ObjPos_3.bin"
		dc.w 	$FFFF,   0,    0
	endif

@ObjPos2_\#c:	
	if	(filesize("\_temp\ObjPos_2.bin")=-1)
		else
		incbin	"\_temp\ObjPos_2.bin"
		dc.w 	$FFFF,   0,    0
	endif

@ObjPos1_\#c:	incbin	"\_temp\ObjPos_1.bin"

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
		dc.w 	$FFFF,    0,    0
_temp	equs	_ZoneFolder\#c
@RingPosB_\#c:
	if	(filesize("\_temp\RingPos_Boss.bin")=-1)
		else
		incbin	"\_temp\RingPos_Boss.bin"
		dc.w 	$FFFF,   0,    0
	endif
@RingPos3_\#c:	
	if	(filesize("\_temp\RingPos_3.bin")=-1)
		else
		incbin	"\_temp\RingPos_3.bin"
		dc.w 	$FFFF,   0,    0
	endif

@RingPos2_\#c:	
	if	(filesize("\_temp\RingPos_2.bin")=-1)
		else
		incbin	"\_temp\RingPos_2.bin"
		dc.w 	$FFFF,   0,    0
	endif
@RingPos1_\#c:	incbin	"\_temp\RingPos_1.bin"
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
		incbin	"\_temp\PalWater_1.bin"
	endif
		incbin	"\_temp\PalMain_1.bin"

	if	(ZonePal_Water\#c)
		incbin	"\_temp\PalWater_2.bin"
	endif
		incbin	"\_temp\PalMain_2.bin"

	if	(ZonePal_Water\#c)
		incbin	"\_temp\PalWater_3.bin"
	endif
		incbin	"\_temp\PalMain_3.bin"

	if	(ZonePal_Water\#c)
		incbin	"\_temp\PalWater_B.bin"
	endif
		incbin	"\_temp\PalMain_B.bin"
c	=	c+1
		endr
; ---------------------------------------------------------------------------
; Zone Specific palette Cycles

Pal_GHZCyc:	incbin "level/GHZ/PalCycle_1.bin"
Pal_EHZCyc:	incbin "level/EHZ/PalCycle_1.bin"

Pal_HTZCyc1:	incbin "level/HTZ/PalCycle_1.bin"
Pal_HTZCyc2:	incbin "level/HTZ/PalCycle_Delay.bin"

Pal_CPZCyc1:	incbin "level/CPZ/PalCycle_1.bin"
Pal_CPZCyc2:	incbin "level/CPZ/PalCycle_2.bin"
Pal_CPZCyc3:	incbin "level/CPZ/PalCycle_3.bin"

Pal_HPZCyc1:	incbin "level/HPZ/PalCycle_1.bin"
Pal_HPZCyc2:	incbin "level/HPZ/PalCycle_Water1.bin"
; ===========================================================================
; Level Mappings and Collision
; ---------------------------------------------------------------------------
c	=	0
		rept ZoneCount
_temp	equs	_ZoneFolder\#c
Map16x16_\#c:	incbin	"\_temp\map16.mapeni"
		even
Map128x128_\#c:	incbin	"\_temp\map128.bin"
		even
ColP_\#c:	incbin	"\_temp\ColP.bin"
		even
ColS_\#c:	incbin	"\_temp\ColS.bin"
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
QuirkyCorkscrewData:
	; Flip_angle of player relative to chunk
	QuirkyCorkscrew_Chunk1_Flipma:	dc.b	$16, $00, $2C, $F0, $42, $E8, $58, $E0  ; Going Upwards
	QuirkyCorkscrew_Chunk2_Flipma:	dc.b	$6E, $F4, $84, $F0, $9A, $10, $B0, $1C  ; Up to Down
	QuirkyCorkscrew_Chunk3_Flipma:	dc.b	$C6, $20, $DC, $18, $F2, $10, $01, $00  ; Going Downwards
	QuirkyCorkscrew_DDiag_Flipma:	dc.b	$DC, $1C, $DC, $1C, $DC, $1C, $DC, $1C  ; Going Downwards
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