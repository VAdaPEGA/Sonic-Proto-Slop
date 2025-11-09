
LoadDebugObjectSprite:
		moveq	#0,d0
		move.b	(Debug_object).w,d0
		lsl.w	#3,d0
		move.l	(a2,d0.w),mappings(a0)
		move.w	6(a2,d0.w),art_tile(a0)
		move.b	5(a2,d0.w),mapping_frame(a0)
		move.b	4(a2,d0.w),Subtype(a0)
		jmp	Adjust2PArtPointer
; End of function Debug_ShowItem
; ===========================================================================
ObjPlaceEntry	macro	ID, Subtype, Frame, VRAM, Mappings
	if	(narg<4)
@temp	equs	\_Obj\#ID
@temp	equs	Map_\@temp
		dc.l	@temp+ID<<24	; Use ID defined Mapping data
	else
		dc.l	Mappings+ID<<24	; Use Specified Mapping Data
	endif
		dc.b	Subtype, Frame
	if	(narg=3)
		dc.w	0	; Use ID defined VRAM (not implemented)
	else
		dc.w	VRAM
	endif
	endm
DebugList:
ObjPlacec	=	0
		rept	ZoneCount
		dc.w	(_ObjPlaceLst_\#ObjPlacec)-DebugList
ObjPlacec	=	ObjPlacec+1
		endr



ObjPlacec	=	0
		rept	ZoneCount
_ObjPlaceLst_\#ObjPlacec:
	@ListStart:	dc.w	@ListEnd-@ListStart
_temp	equs	_ZoneFolder\#ObjPlacec
		if	(filesize("\_temp\ObjPlaceList.asm")=-1)
	; Generic List if file doesn't exist

	ObjPlaceEntry	ObjID_Ring,	0, 0, $26BC
	ObjPlaceEntry	ObjID_Monitor,	0, 1, $0680
	ObjPlaceEntry	ObjID_LampPost,	1, 0, $047C
		else
		include	"\_temp\ObjPlaceList.asm"
		endif
	@ListEnd:
ObjPlacec	=	objplacec+1
		endr