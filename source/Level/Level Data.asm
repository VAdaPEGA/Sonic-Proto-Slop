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