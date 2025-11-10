; Gonna help everyone in the future by letting y'all know these are a thing with asm68k
;
;	def(a)			Returns true if "a" has been defined
;	ref(a)			Returns true if "a" has been referenced
;	type(a)			Returns the data type of "a"
;	sqrt(a)			Returns the square root of "a"
;	strlen(text)		Returns the length of string in characters
;	strcmp(texta,textb)	Returns true if strings match
;	instr([start,]txa,txb)	Locate substring "a" in string "b"
;	filesize("filename")	Returns the length of a specified file, or -1 if it does not exist.
;
; That last one being very powerful as you may find out~
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; enable / disable interrupts
; ---------------------------------------------------------------------------
disable_ints:	macro
		move	#$2700,sr
		endm
enable_ints:	macro
		move	#$2300,sr
		endm
; ---------------------------------------------------------------------------
; Align to the specified location
; ---------------------------------------------------------------------------
align:	macro
	if (narg=1)
	cnop 0,\1
	else
	dcb.b \1-((*)%\1),\2
	endif
	endm
; ---------------------------------------------------------------------------
; Z80 related	
; ---------------------------------------------------------------------------
stopZ80 	macro
		move.w	#$100,(Z80_Bus_Request).l
		endm
; ---------------------------------------------------------------------------
waitZ80:	macro
	@wait:	btst	#0,(Z80_Bus_Request).l
		bne.s	@wait
		endm
; ---------------------------------------------------------------------------
startZ80	macro
		move.w	#0,(Z80_Bus_Request).l
		endm
; ---------------------------------------------------------------------------
resetZ80:	macro
		move.w	#$100,(Z80_reset).l
		endm
; ---------------------------------------------------------------------------
resetZ80a:	macro
		move.w	#0,(Z80_reset).l
		endm
; ---------------------------------------------------------------------------
; Get Date	(the sloppy but "reliable" one)
; ---------------------------------------------------------------------------
GetDate:	macro
_getyear	=	_year-100	; somehow this works
		dc.b "20\#_getyear-"
		if (strlen("\#_month")=2)
		dc.b "\#_month-"
		else
		dc.b "0\#_month-"
		endif
		if (strlen("\#_day")=2)
		dc.b "\#_day "
		else
		dc.b "0\#_day "
		endif
		if (strlen("\#_hours")=2)
		dc.b "\#_hours:"
		else
		dc.b "0\#_hours:"
		endif
		if (strlen("\#_minutes")=2)
		dc.b "\#_minutes"
		else
		dc.b "0\#_minutes"
		endif
		endm
; ---------------------------------------------------------------------------
; Lagometer (uses Window Layer)
; ---------------------------------------------------------------------------
LagOn	macro
	if	(Lagometer)
	move.w	#$9193,(VDP_Control_Port).l
	endif
	endm
LagOff	macro
	if	(Lagometer)
	move.w	#$9100,(VDP_Control_Port).l
	endif
	endm
; ---------------------------------------------------------------------------
; Set a VRAM address via the VDP control port.
; input: 16-bit VRAM address, control port (default is ($C00004).l)
; ---------------------------------------------------------------------------

locVRAM:	macro loc,controlport
		if (narg=1)
		move.l	#($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),(VDP_Control_Port).l
		else
		move.l	#($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),controlport
		endif
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
		move.l	#($C0000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),(VDP_Control_Port).l
		else
		move.l	#($C0000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),controlport
		endif
		endm

; ---------------------------------------------------------------------------
; Set a VSRAM address via the VDP control port. (kind of pointless, actually)
; input: 16-bit VRAM address, control port (default is ($C00004).l)
; ---------------------------------------------------------------------------

locVSRAM:	macro loc,controlport
		if (narg=1)
		move.l	#($40000010+((loc&$3FFF)<<16)+((loc&$C000)>>14)),(VDP_Control_Port).l
		else
		move.l	#($40000010+((loc&$3FFF)<<16)+((loc&$C000)>>14)),controlport
		endif
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the VRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeVRAM:	macro
		if (narg<4)
		lea	(VDP_Control_Port).l,a5
		endif
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+$9300+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+$9500+((\1>>1)&$FF),(a5)
		move.w	#$9700+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$4000+(\3&$3FFF),(a5)
		move.w	#$80+((\3&$C000)>>14),(DMA_data_thunk).w
		move.w	(DMA_data_thunk).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the CRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeCRAM:	macro
		if (narg<4)
		lea	(VDP_Control_Port).l,a5
		endif
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+$9300+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+$9500+((\1>>1)&$FF),(a5)
		move.w	#$9700+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$C000+(\3&$3FFF),(a5)
		move.w	#$80+((\3&$C000)>>14),(DMA_data_thunk).w
		move.w	(DMA_data_thunk).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the VSRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeVSRAM:	macro
		if (narg<4)
		lea	(VDP_Control_Port).l,a5
		endif
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+$9300+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+$9500+((\1>>1)&$FF),(a5)
		move.w	#$9700+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$4000+(\3&$3FFF),(a5)
		move.w	#$90+((\3&$C000)>>14),(DMA_data_thunk).w
		move.w	(DMA_data_thunk).w,(a5)
		endm

; ---------------------------------------------------------------------------
; prepare data from 68K (ROM/RAM) to the VSRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

preparewriteVSRAM:	macro
		if (narg<4)
		lea	(VDP_Control_Port).l,a5
		endif
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+$9300+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+$9500+((\1>>1)&$FF),(a5)
		move.w	#$9700+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$90+((\3&$C000)>>14),(DMA_data_thunk).w
		endm

; ---------------------------------------------------------------------------
; DMA fill VRAM with a value
; input: value, length, destination
; ---------------------------------------------------------------------------

fillVRAM:	macro value,length,loc
		lea	(VDP_Control_Port).l,a5
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

copyTilemap_H40:	macro source,loc,width,height,jump
		lea	(source).l,a1
		move.l	#$40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14),d0
		moveq	#width-1,d1
		moveq	#height-1,d2
		if (narg=5)
		jsr	PlaneMapToVRAM_H40
		else
		bsr.w	PlaneMapToVRAM_H40
		endif
		endm

copyTilemap_H20:	macro source,loc,width,height,jump
		lea	(source).l,a1
		move.l	#$40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14),d0
		moveq	#width-1,d1
		moveq	#height-1,d2
		if (narg=5)
		jsr	PlaneMapToVRAM_H20
		else
		bsr.w	PlaneMapToVRAM_H20
		endif
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
		endif
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
		if	(UncSize_Art_\name)=-1
		inform	1, "Missing Uncompressed Art for \name\ at \path\\file\.Zip"
		endif
		endm
; ---------------------------------------------------------------------------
; Adding Sprite Mappings file
Map_Add:	macro	name, path, file
		if	filesize("\path\\file\.asm")=-1
Map_\name:	incbin	'\path\\file\.SprMap'
		else
Map_\name:	include	'\path\\file\.asm'
		endif
		even
		endm
; ---------------------------------------------------------------------------
; Adding NES "Compressed" Art file
; Format : Two sets of 8 bytes where each bit represents a pixel, combined for a 4 colour palette
NES_Add:	macro	name, path, file
ArtNES_\name:	incbin	'\path\\file\.ArtNES'
		even
Size_ArtNES_\name:	equ	filesize("\path\\file\.artNES")
UncSize_Art_\name:	equ	(filesize("\path\\file\.artNES")*2)
		endm
; ---------------------------------------------------------------------------
; Adding 1BPP "Compressed" Art file
; Format : 8 bytes where each bit represents a pixel
Mono_Add:	macro	name, path, file
Art1Bit_\name:	incbin	'\path\\file\.Art1Bit'
		even
Size_Art1Bit_\name:	equ	filesize("\path\\file\.art1Bit")
UncSize_Art_\name:	equ	(filesize("\path\\file\.art1Bit")*4)
		endm
; ---------------------------------------------------------------------------
; Adding Nemesis Compressed Art file
Nem_Add:	macro	name, path, file
ArtNem_\name:	incbin	'\path\\file\.ArtNem'
		even
UncSize_Art_\name:	equ	filesize("\path\\file\.ArtUnc")
		if	filesize("\path\\file\.ArtUnc")=-1
		inform	1, "Missing Uncompressed Art for \name\ at \path\\file\.ArtNem"
		endif
		endm
; ---------------------------------------------------------------------------
; Adding Enigma Compressed Tilemap file
Eni_Add:	macro	name, path, file
Eni_\name:	incbin	'\path\\file\.MapEni'
		even
		endm
; ---------------------------------------------------------------------------
; Adding Uncompressed Art + Mapping + dplc
Artunc_Add:		macro	options, name, path, file
			if	(*&$1FFFF>(*+filesize('\path\\file\.artunc'))&$1FFFF)
			align	$20000,$69	; allign art if it surpasses DMA boundary
			endif
ArtSize_\name:		equ	filesize("\path\\file\.artunc")
Artunc_\name:		incbin	'\path\\file\.Artunc'
			even
@temp	=	"\options"
			case	@temp
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
; Object Pointers and Definition
ObjCount	=	0
IncludeObject	macro
ObjCount	=	ObjCount+1
		if	(narg=0)
		dc.l	ObjNull	; Blank slot
_Obj\#ObjCount:	equs	"NULL"
		else
ObjId_\1	equ	ObjCount
_Obj\#ObjCount:	equs	"\1\"
		dc.l	obj\1
		endif
		endm
; ---------------------------------------------------------------------------
; Tables!!!!
IndexStart		macro	name
		if (narg=1)
\name:
		endif
@index:
c	=		0
			endm
; ---
GenerateLocalIndex	macro	Increase,label
			dc.w	@\label\-@Index
		if (narg=1)
@Index\label:		equ	c
		endif
c	=		c+Increase
			endm
; ---
GenerateIndexID		macro	Increase,LabelName,name
			dc.w	\LabelName\_\name\-@Index
\LabelName\ID_\name:	equ	c
			if (narg=3)
			else
			dc.w	\LabelName\-@Index
_\LabelName\:		equ	c
			endif
c	=		c+increase
			endm
; ---
GenerateIndex	macro	Increase,LabelName,name
			if (narg=3)
			dc.w	\LabelName\_\name\-@Index
			else
			dc.w	\LabelName\-@Index
			endif
c	=		c+increase
			endm

; ---------------------------------------------------------------------------
Artunc_FakeVScroll	macro	Zone, name, num
c	=	0
size	=	filesize('Level/\Zone\/Art/Ani_\name\0.ArtUnc')
	rept	num
	if	(*&$1FFFF>(*+(size))&$1FFFF)
	align	$20000,$69	; allign art if it surpasses DMA boundary
	endif
Artunc_\name\_\#c:	incbin	'Level/\Zone\/Art/Ani_\name\\#c\.ArtUnc'
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
_ZoneName\#ZoneCount:		equs	"\Name\"
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