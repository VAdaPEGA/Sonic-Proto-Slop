; ---------------------------------------------------------------------------
; Macros
align macro
	cnop 0,\1
	endm

stopZ80 macro
	move.w	#$100,(Z80_Bus_Request).l
@loop:	btst	#0,(Z80_Bus_Request).l
	bne.s	@loop
	endm

startZ80 macro
	move.w	#0,(Z80_Bus_Request).l
	endm

; ---------------------------------------------------------------------------
; Get Date	
; ---------------------------------------------------------------------------
GetDate:	macro
_getyear	=	_year-100
		dc.b "20\#_getyear-"
		if (strlen("\#_month")=2)
		dc.b "\#_month-"
		else
		dc.b "0\#_month-"
		endc
		if (strlen("\#_day")=2)
		dc.b "\#_day "
		else
		dc.b "0\#_day "
		endc
		if (strlen("\#_hours")=2)
		dc.b "\#_hours:"
		else
		dc.b "0\#_hours:"
		endc
		if (strlen("\#_minutes")=2)
		dc.b "\#_minutes"
		else
		dc.b "0\#_minutes"
		endc
		endm
; ---------------------------------------------------------------------------
; Lagometer (uses Window Layer)
; ---------------------------------------------------------------------------
LagOn	macro
	if	(lagometer)
	move.w	#$9193,(vdp_control_port).l
	endif
	endm
LagOff	macro
	if	(lagometer)
	move.w	#$9100,(vdp_control_port).l
	endif
	endm
; ---------------------------------------------------------------------------
; Set a VRAM address via the VDP control port.
; input: 16-bit VRAM address, control port (default is ($C00004).l)
; ---------------------------------------------------------------------------

locVRAM:	macro loc,controlport
		if (narg=1)
		move.l	#($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),(vdp_control_port).l
		else
		move.l	#($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),controlport
		endc
		endm
; ---------------------------------------------------------------------------
locVRAMtemp:	macro loc
		if (narg=1)
		move.l	#($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),d0
		else
_VDPcommand	=	($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14))
		endif
		endm
; ---------------------------------------------------------------------------
; Set a CRAM address via the VDP control port.
; input: 16-bit CRAM address, control port (default is ($C00004).l)
; ---------------------------------------------------------------------------

locCRAM:	macro loc,controlport
		if (narg=1)
		move.l	#($C0000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),(vdp_control_port).l
		else
		move.l	#($C0000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),controlport
		endc
		endm

; ---------------------------------------------------------------------------
; Set a VSRAM address via the VDP control port. (kind of pointless, actually)
; input: 16-bit VRAM address, control port (default is ($C00004).l)
; ---------------------------------------------------------------------------

locVSRAM:	macro loc,controlport
		if (narg=1)
		move.l	#($40000010+((loc&$3FFF)<<16)+((loc&$C000)>>14)),(vdp_control_port).l
		else
		move.l	#($40000010+((loc&$3FFF)<<16)+((loc&$C000)>>14)),controlport
		endc
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the VRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeVRAM:	macro
		if (narg<4)
		lea	(vdp_control_port).l,a5
		endif
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+$9300+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+$9500+((\1>>1)&$FF),(a5)
		move.w	#$9700+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$4000+(\3&$3FFF),(a5)
		move.w	#$80+((\3&$C000)>>14),(v_vdp_buffer2).w
		move.w	(v_vdp_buffer2).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the CRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeCRAM:	macro
		if (narg<4)
		lea	(vdp_control_port).l,a5
		endif
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+$9300+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+$9500+((\1>>1)&$FF),(a5)
		move.w	#$9700+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$C000+(\3&$3FFF),(a5)
		move.w	#$80+((\3&$C000)>>14),(v_vdp_buffer2).w
		move.w	(v_vdp_buffer2).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the VSRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeVSRAM:	macro
		if (narg<4)
		lea	(vdp_control_port).l,a5
		endif
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+$9300+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+$9500+((\1>>1)&$FF),(a5)
		move.w	#$9700+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$4000+(\3&$3FFF),(a5)
		move.w	#$90+((\3&$C000)>>14),(v_vdp_buffer2).w
		move.w	(v_vdp_buffer2).w,(a5)
		endm

; ---------------------------------------------------------------------------
; prepare data from 68K (ROM/RAM) to the VSRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

preparewriteVSRAM:	macro
		if (narg<4)
		lea	(vdp_control_port).l,a5
		endif
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+$9300+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+$9500+((\1>>1)&$FF),(a5)
		move.w	#$9700+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$90+((\3&$C000)>>14),(v_vdp_buffer2).w
		endm

; ---------------------------------------------------------------------------
; DMA fill VRAM with a value
; input: value, length, destination
; ---------------------------------------------------------------------------

fillVRAM:	macro value,length,loc
		lea	(vdp_control_port).l,a5
		move.w	#$8F01,(a5)
		move.l	#$94000000+((length&$FF00)<<8)+$9300+(length&$FF),(a5)
		move.w	#$9780,(a5)
		move.l	#$40000080+((loc&$3FFF)<<16)+((loc&$C000)>>14),(a5)
		move.w	#value,(vdp_data_port).l
		endm

; ---------------------------------------------------------------------------
; Copy a tilemap from 68K (ROM/RAM) to the VRAM without using DMA
; input: source, destination, width [cells], height [cells]
; ---------------------------------------------------------------------------

copyTilemap:	macro source,loc,width,height,jump
		lea	(source).l,a1
		move.l	#$40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14),d0
		moveq	#width,d1
		moveq	#height,d2
		if (narg=5)
		jsr	TilemapToVRAM
		else
		bsr.w	TilemapToVRAM
		endif
		endm

copyTilemap256:	macro source,loc,width,height,jump
		lea	(source).l,a1
		move.l	#$40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14),d0
		moveq	#width,d1
		moveq	#height,d2
		if (narg=5)
		jsr	TilemapToVRAM256
		else
		bsr.w	TilemapToVRAM256
		endif
		endm	
; ---------------------------------------------------------------------------
; disable interrupts
; ---------------------------------------------------------------------------
disable_ints:	macro
		move	#$2700,sr
		endm
; ---------------------------------------------------------------------------
; enable interrupts
; ---------------------------------------------------------------------------
enable_ints:	macro
		move	#$2300,sr
		endm

; ---------------------------------------------------------------------------
; check if object moves out of range
; input: location to jump to if out of range, x-axis pos (obX(a0) by default)
; ---------------------------------------------------------------------------

out_of_range:	macro exit,pos
		if (narg=2)
		move.w	pos,d0		; get object position (if specified as not obX)
		else
		move.w	x_pos(a0),d0	; get object position
		endc
		andi.w	#$FF80,d0	; round down to nearest $80
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#320*2,d0
		bhi.\0	exit
		endm

; ---------------------------------------------------------------------------		
; Adding new Entry to Mapping 
; ---------------------------------------------------------------------------
MAP_Entry:	macro 	x,y,size,vram,priority,pal,flipx,flipy	
		dc.b	y	; Y position
		dc.b	size	; Sprite size 
		dc.w	((priority<<15)+(pal<<13)++(flipy<<12)+(flipx<<11)+vram)
		dc.w	((priority<<15)+(pal<<13)++(flipy<<12)+(flipx<<11)+(vram>>1))
		dc.w	x	; X position
		endm

; ---------------------------------------------------------------------------
;   Gatoslip Macros (no, not big cats)
; a lot of this won't get used for this project, but hey y'all get a glimpse
; at the insanity of my work~ -VAda
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Decompress Zip file [WARNING : WILL TAKE OVER RAM FOR BIG FILES, USE SPARINGLY]
Zip_Decompress:		macro	zip,vram
		lea	(Zip_\zip\).l,a5			
		movea.l	#$FFFF0000,a4
		lea	$FFFF8000.w,a6
		jsr	inflate		; decompress zip
		move.l  #$FF0000,d1	
		move.w  #vram,d2	; VRAM location
		move.w  #(UncSize_zip_\zip\)/2,d3	; Size
		jsr	QueueDMATransfer
		endm
; ---------------------------------------------------------------------------
; ZIP compressed data (general)
Zip_Add:	macro	name, extention, path, file

UncSize_Zip_\name:	equ	filesize("\path\\file\.\extention\")	
Zip_\name:	incbin	'\path\\file\.zip',($1F+strlen("\file")+strlen("\extention"))
		even
		endm
; ---------------------------------------------------------------------------
; Adding Sprite Mappings file
Map_Add:	macro	name, path, file
Map_\name:	include	'\path\\file\.asm'
		even
		endm
; ---------------------------------------------------------------------------
; Adding Nemesis Compressed Art file
Nem_Add:	macro	name, path, file
ArtNem_\name:	incbin	'\path\\file\.artnem'
		even
UncSize_Art_\name:	equ	filesize("\path\\file\.artunc")
		endm
; ---------------------------------------------------------------------------
; Adding Enigma Compressed Tilemap file
Eni_Add:	macro	name, path, file
Eni_\name:	incbin	'\path\\file\.mapeni'
		even
		endm
; ---------------------------------------------------------------------------
; Adding Uncompressed Art + Mapping + dplc
Artunc_Add:		macro	options, name, path, file
			if	(*&$1FFFF>(*+filesize('\path\\file\.artunc'))&$1FFFF)
			align	$20000,$69	; allign art if it surpasses DMA boundary
			endif
ArtSize_\name:		equ	filesize("\path\\file\.artunc")
Artunc_\name:		incbin	'\path\\file\.artunc'
			even
temp	=	"\options"
			case	temp
="dplc"
DPLC_\name:		include	'\path\\file\DPLC.asm'
Map_\name:		include	'\path\\file\MAP.asm'
="map"
Map_\name:		include	'\path\\file\MAP.asm'
=?
			endcase
			endm
; ---------------------------------------------------------------------------
; Inflate / decompress zip
; ---------------------------------------------------------------------------
LoadzipVRAM:	macro	art,location
		lea	(art).l,a5	; Art
		movea.l	#$FFFF0000,a4	; 
		lea	$FFFF8000.w,a6	; 
		jsr	inflate		; decompress zip
		move.l	#$FF0000,d1	
		move.w	#location,d2		; VRAM location
		move.w	#(UncSize_\art)/2,d3	; Size
		jsr	QueueDMATransfer
		jsr	ProcessDMAQueue
		endm
; --------------------------------------------------------------------------
LoadzipMAP:	macro	map,width,height,location
		lea	(map).l,a5	; Mappings
		movea.l	#$FFFF0000,a4	; 
		lea	$FFFF8000.w,a6	; 
		jsr	inflate		; decompress zip
		move.l	#$FF0000,a1
		move.l	#($40000000+((location&$3FFF)<<16)+((location&$C000)>>14)),d0
		move.w	#width,d1 		; width (cells)
		move.w	#height,d2 		; height (cells)
		jsr	TilemapToVRAM	
		endm
; ---------------------------------------------------------------------------
; Cutscene ZIP compressed art, mappings and palette [NEEDS TO BE REPLACED]
Zip_CutAdd:		macro	file

UncSize_Zip_Cut\file:	equ	filesize("GameMode/Overworld/Cutscenes/Art/\file\.artunc")	
Zip_Cut\file:		incbin	'GameMode/Overworld/Cutscenes/Art/\file\.zip',($1F+strlen("\file")+6)
			even
Eni_Cut\file:		incbin	'GameMode/Overworld/Cutscenes/Art/\file\.mapeni'
			even
			if (narg=1)
Pal_Cut\file:			incbin	'GameMode/Overworld/Cutscenes/Art/\file\.pal'
				even
			endif
			endm
; ---------------------------------------------------------------------------
; Cutscene ZIP compressed art, mappings and palette [NEEDS TO BE REPLACED]
Nem_CutAdd:		macro	file

UncSize_Zip_Cut\file:	equ	filesize("GameMode/Overworld/Cutscenes/Art/\file\.artunc")	
Nem_Cut\file:		incbin	'GameMode/Overworld/Cutscenes/Art/\file\.artnem'
			even
Eni_Cut\file:		incbin	'GameMode/Overworld/Cutscenes/Art/\file\.mapeni'
			even
			if (narg=1)
Pal_Cut\file:			incbin	'GameMode/Overworld/Cutscenes/Art/\file\.pal'
				even
			endif
			endm
; ---------------------------------------------------------------------------
; Uncompressed art for Textbox Profiles
GatoslipProfileCount	=	0
Artunc_GatoslipProfile:	macro	file
Artunc_Profile_\file:	incbin	'HUD/Profiles/\file\.bin'
			even
TxtProfile_\file:	equ	GatoslipProfileCount
GatoslipProfileCount	=	GatoslipProfileCount+1
			endm
; ---------------------------------------------------------------------------
; Uncompressed art for HUD icons
GatoslipHUDCount	=	2
Artunc_GatoslipHUD:	macro	file
Artunc_HUD_\file:	incbin	'HUD/HUDicons/\file\.bin'
			even
			incbin	'HUD/HUDicons/confirm/\file\.bin'
			even
HUDid_\file:		equ	GatoslipHUDCount
GatoslipHUDCount	=	GatoslipHUDCount+2
			endm
; ---------------------------------------------------------------------------
; Object Pointers
ObjPointer	macro	object, name
		if	(narg=2)
id_\name	equ	c
		endc
		dc.l	object
c	=	c+1
		endm
; ---------------------------------------------------------------------------
; Adding Overworld Objects for Level Maps
LvlObj_Add:	macro	group, name 
Obj_\group\_\name:	include	'GameMode/Overworld/Objects/\group\/\name\/\name\.asm'
		endm
; ---------------------------------------------------------------------------
; Adding Overworld Object Art and Mappings
LvlObjArt_Add:		macro	group, name, type, map, ani
		if	strcmp("none","\type")
		else
UncSize_Art_\group\_\name:	equ	filesize("GameMode/Overworld/Objects/\group\/\name\/\name\.artunc")	
		if	strcmp("artunc","\type")
			if	(offset(*)&$1FFFF>(offset(*)+UncSize_Art_\group\_\name)&$1FFFF)
			align	$20000,$69	; allign art if it surpasses DMA boundary
			endif
		endif
\Type\_\group\_\name:	incbin	'GameMode/Overworld/Objects/\group\/\name\/\name\.\type\'
			even
		endif
		if	(narg>=4)
Map_\group\_\name:	include	"GameMode/Overworld/Objects/\group\/\name\/\name\MAP.asm"
			even
		endif
		if	(narg=5)
Ani_\group\_\name:	include	"GameMode/Overworld/Objects/\group\/\name\/\name\ANI.asm"
			even
		endif
		endm
; ---------------------------------------------------------------------------
; Tables!!!!
IndexStart		macro	name
		if (narg=1)
\name:
@index:
		endif
c	=		0
			endm
; ---
GenerateLocalIndex	macro	label
			dc.w	@\label\-@Index
		if (narg=1)
@Index\label:		equ	c
		endif
c	=		c+2
			endm
; ---
GenerateIndex		macro	Increase,LabelName,name
			dc.w	@\name\-@Index
\LabelName\_\name:		equ	c
c	=		c+increase
			endm

; ---------------------------------------------------------------------------
Artunc_FakeVScroll	macro	Zone, name, num
c	=	0
size	=	filesize('Level/\Zone\/AnimatedTiles/\name\0.bin')
	rept	num
	if	(*&$1FFFF>(*+(size))&$1FFFF)
	align	$20000,$69	; allign art if it surpasses DMA boundary
	endif
Artunc_\name\_\#c:	incbin	'Level/\Zone\/AnimatedTiles/\name\\#c\.bin'
c	=	c+1
	endr
	even
	endm
; ---------------------------------------------------------------------------
; Adding new Game Modes
GameModeCount	=	0
IncludeGameMode	macro	name, routine, debug
GameModeID_\name\:		equ	(GameModeCount*2)
GameModeName\#GameModeCount:	equs	\debug
_GameMode\#GameModeCount:	equ	routine
GameModeCount	=	GameModeCount+1
		endm
; ---------------------------------------------------------------------------
; Adding new Zones
ZoneCount	=	0
IncludeZone	macro	Name, water, debug
ZoneID_\Name\:		equ	ZoneCount
ZoneName\#ZoneCount:		equs	\debug
UncArt_Zone_\#ZoneCount:	equ	filesize("Level/\Name\/Art.Artunc")
_ZoneFolder\#ZoneCount:		equs	"Level/\Name\/"
ZonePal_Water\#ZoneCount	=	water
ZoneCount	=	ZoneCount+1
		endm
; ---------------------------------------------------------------------------
; Adding new Music
MusicCount	=	0
IncludeMusic	macro	speed, name, filepath, debug1, debug2
MusID_\name\:			equ	(MusicCount+1)
MusicName\#MusicCount:		equs	\debug1
MusicComposer\#MusicCount:	equ	debug2
_Music\#MusicCount:		equs	"SoundDriver/music/\filepath\"
_Musicspd\#MusicCount:		equ	speed
MusicCount	=	MusicCount+1
		endm
; ---------------------------------------------------------------------------
; Adding new Sound
SoundCount	=	0
IncludeSound	macro	priority, name, filepath, debug1, debug2, label
SndID_\name\:			equ	(SoundCount+MusicCount+1)
SoundName\#SoundCount:		equs	\debug1
SoundSub\#SoundCount:		equs	\debug2
	if			(narg=5)
_Sound\#SoundCount:		equs	"SoundDriver/sfx/\filepath\"
	else
_Sound\#SoundCount:		equs	"_"
_SoundLabel\#SoundCount:	equ	label
	endif
_SoundPrio\#SoundCount:		equ	priority
SoundCount	=	SoundCount+1
		endm