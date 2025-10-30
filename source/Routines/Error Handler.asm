; ===========================================================================
BusError:
		move.b	#2,(Error_Type).w
		bra.s	BusAndAddressError
AddressError:
		move.b	#4,(Error_Type).w
		bra.s	BusAndAddressError
IllegalInstr:
		move.b	#6,(Error_Type).w
		addq.l	#2,2(sp)
		bra.w	AnyOtherError
ZeroDivide:
		move.b	#8,(Error_Type).w
		bra.s	AnyOtherError
ChkInstr:
		move.b	#$A,(Error_Type).w
		bra.s	AnyOtherError
TrapvInstr:
		move.b	#$C,(Error_Type).w
		bra.s	AnyOtherError
PrivilegeViol:
		move.b	#$E,(Error_Type).w
		bra.s	AnyOtherError
Trace:
		move.b	#$10,(Error_Type).w
		bra.s	AnyOtherError
Line1010Emu:
		move.b	#$12,(Error_Type).w
		addq.l	#2,2(sp)
		bra.s	AnyOtherError
Line1111Emu:
		move.b	#$14,(Error_Type).w
		addq.l	#2,2(sp)
		bra.s	AnyOtherError
ErrorExcept:
		move.b	#0,(Error_Type).w
		bra.s	AnyOtherError
TrapException:
		move.b	d0,(Error_Type).w	; custom error (and fake ones too)
		bra.s	AnyOtherError
; ===========================================================================

BusAndAddressError:	; Bus / Address Error
		disable_ints
		addq.w	#2,sp
		move.l	(sp)+,(Error_Stack_Pointer).w
		addq.w	#2,sp
		movem.l	d0-a7,(Error_Registers).w
		bsr.w	ShowErrorMessage
		move.l	2(sp),d0
		locVRAM	(VRAM_FG+$B84)
		bsr.w	ShowErrorValue
		move.l	(Error_Stack_Pointer).w,d0
		bsr.w	ShowErrorValue
		bra.s	RepositionScreenForError
; ===========================================================================

AnyOtherError:
		disable_ints
		movem.l	d0-a7,(Error_Registers).w
		bsr.w	ShowErrorMessage
		move.l	2(sp),d0
		locVRAM	(VRAM_FG+$B84)
		bsr.w	ShowErrorValue

RepositionScreenForError:
		clr.l	(Vscroll_Factor).w	; clear Vertical position
		clr.l	(TempArray_LayerDef).w	; clear horizontal position

		lea	(vdp_data_port).l,a6
		locVSRAM 0		
		move.l	#$0,(a6)		; clear Y position in VSRAM
		locVRAM	VRAM_HScroll
		move.l	#$0,(a6)		; clear X position in VRAM

		locCRAM	2*(16-2)			; force colours for visibility and style
		move.l	#(cBlack<<16)+cWhite,(a6)
		locCRAM	2*(16*2-2)
		move.l	#(cBlack<<16)+cAqua,(a6)
		locCRAM	2*(16*3-2)
		move.l	#(cBlack<<16)+cGreen,(a6)
		locCRAM	2*(16*4-2)
		move.l	#(cBlack<<16)+cMagenta,(a6)

		locVRAM	(VRAM_sprites)
		move.l	#$0,(a6)
		move.l	#$0,(a6)		; Disable sprites
		
		move.w	#$8200+(VRAM_FG>>10),(vdp_control_port).l ; set foreground nametable address
		move.w	#$8B00,(vdp_control_port).l	; scroll mode (one long for screen)
		bsr.w	ErrorWaitForC
		move.w	#$8B03,(vdp_control_port).l	; scroll mode (one long for each line)
		; Sadly, there is no way to read from VDP registers, so Plane A and Scroll mode will get messed up
		movem.l	(Error_Registers).w,d0-a7
		enable_ints
		rte
; ===========================================================================
ShowErrorMessage:
ErrorTextVRAM	=	$F820
ErrorTextTile	=	(TMap_Priority+(ErrorTextVRAM/$20)-"0")	; For writing to VRAM
		lea	(vdp_data_port).l,a6
		locVRAM	ErrorTextVRAM
		lea	(ArtUnc_DebugTXT).l,a0
		move.w	#(48*8)-1,d1
	@loadgfx:
		move.l	(a0)+,(a6)
		dbf	d1,@loadgfx

		; stack
		move.w	#ErrorTextTile+TMap_PalLine3,d5	; Green
		locVRAM	(VRAM_FG+4+128*11)
		lea	ErrorStack,a0
		bsr	@showchars

		move.w	#ErrorTextTile+TMap_PalLine2,d5	; Cyan
		locVRAM	(VRAM_FG+40+128*11)
		move.l	sp,d0
		add.l	#6,d0
		move.l	d0,a0
		bsr	ShowErrorValue

		move.w	#ErrorTextTile+TMap_PalLine4,d5	; Magenta
		locVRAM	(VRAM_FG+4+128*12)
		moveq	#4-1,d3
		bsr	@loopStack
		locVRAM	(VRAM_FG+4+128*13)
		moveq	#4-1,d3
		bsr	@loopStack
		locVRAM	(VRAM_FG+4+128*14)
		moveq	#4-1,d3
		bsr	@loopStack
		locVRAM	(VRAM_FG+4+128*15)
		moveq	#4-1,d3
		bsr	@loopStack
		; ---
		; d0 > d7
		move.w	#ErrorTextTile+TMap_PalLine3,d5	; Green
		locVRAM	(VRAM_FG+4+128*3)
		move.l	#(TMap_PalLine3+ErrorTextTile+"D")<<16+(TMap_PalLine3+ErrorTextTile+"0"),d4	; D0
		lea	ErrorDataReg,a0
		bsr	@showchars

		move.w	#ErrorTextTile+TMap_PalLine4,d5	; Magenta
		lea	(Error_Registers).w,a0		
		moveq	#2-1,d3
		bsr	@loopregLine
		locVRAM	(VRAM_FG+4+128*4)
		moveq	#3-1,d3
		bsr	@loopregLine
		locVRAM	(VRAM_FG+4+128*5)
		moveq	#3-1,d3
		bsr	@loopregLine
		; ---
		; a0 > a7
		move.w	#ErrorTextTile+TMap_PalLine3,d5	; Green
		locVRAM	(VRAM_FG+4+128*7)
		move.l	#(TMap_PalLine3+ErrorTextTile+"A")<<16+(TMap_PalLine3+ErrorTextTile+"0"),d4	; A0
		lea	ErrorAddrReg,a0
		bsr	@showchars

		move.w	#ErrorTextTile+TMap_PalLine4,d5	; Magenta
		lea	(Error_Registers+4*8).w,a0
		moveq	#2-1,d3
		bsr	@loopregLine
		locVRAM	(VRAM_FG+4+128*8)
		moveq	#3-1,d3
		bsr	@loopregLine
		locVRAM	(VRAM_FG+4+128*9)
		moveq	#3-1,d3
		bsr	@loopregLine
		; ---
		moveq	#0,d0		; clear	d0
		move.b	(Error_Type).w,d0	; load error code
		move.w	ErrorText(pc,d0.w),d0
		lea	ErrorText(pc,d0.w),a0
		move.w	#ErrorTextTile,d5	; White
		locVRAM	(VRAM_FG+$B04)
		bsr	@showchars
		locVRAM	(VRAM_FG+$C84)
		lea	ErrorPress,a0
		bsr	@showchars
		locVRAM	(VRAM_FG+4+128*1)	; top message

	@showchars:
		moveq	#0,d0
		move.b	(a0)+,d0
		bmi.s	@_end		; text termination
		add.w	d5,d0		; Offset by ErrorTextTile+palette
		move.w	d0,(a6)
		bra.s	@showchars	; repeat for number of characters
		@_end:
		rts
	@loopstack:	; d3 = loop counter
		move.l	(a0)+,d0	; load saved register
		bsr	ShowErrorValue	; show it
		dbf	d3,@loopstack	; loop for each line
		rts	
	@loopregLine:	; d4 = Letter/Number | d3 = loop counter
		move.l	(a0)+,d0	; load saved register
		swap	d4
		move.w	d4,(a6)		; show letter (A or D)
		swap	d4
		move.w	d4,(a6)		; show number
		addq.b	#1,d4		; increase by 1
		bsr	ShowErrorValue	; show it
		move.w	#(ErrorTextTile+"_"),(a6)	; display " " symbol
		dbf	d3,@loopregLine	; loop for each line
		rts
; End of function ShowErrorMessage
; ===========================================================================
ErrorText:	; Error text generated via macro
c		=	0
ErrCode		macro	name, desc
		dc.w	@Err\#c-ErrorText
errdesc\#c:	equs	\desc
Err_\name\:	equ	c
c		=	c+2
		endm
; ---------------------------------------------------------------------------
	ErrCode	exception,	"[PROTO_EXCEPTION]"
	ErrCode	bus,		"[IMAGINE_A_BUS]"
	ErrCode	address,	"[ADDRESS_BETA]"
	ErrCode	illinstruct,	"[ILLEGAL_DUMP]"
	ErrCode	zerodivide,	"[DIVIDED_COMMUNITY]"
	ErrCode	chkinstruct,	"[CHECK_MY_HACK]"
	ErrCode	trapv,		"[MY_PROTO_OVERFLOWETH]"
	ErrCode	privilege,	"[PROTO_VIOLATION]"
	ErrCode	trace,		"[TRACED_ART]"
	ErrCode	line1010,	"[1010_VERSION]"
	ErrCode	line1111,	"[1111_VERSION]"
	ErrCode	InvalidObject,	"[INVALID_LVL_OBJECT]"
	ErrCode	GenericError2,	"[GENERIC_ERROR]"
	ErrCode	GenericError3,	"[GENERIC_ERROR_TWO]"
	ErrCode	DeathPit,	"[SKILL_ISSUE_DETECTED]"
; ---------------------------------------------------------------------------
		rept	c/2
c		=	c-2
_temp		equs	errdesc\#c
@Err\#c:	dc.b	"\_temp", -1
		endr
; ---------------------------------------------------------------------------
ErrorPress:	dc.b "[HACK_UNSTABLE]_>PRESS_C_TO_CONTINUE<", -1
		dc.b "OH_NO;_MY_PROTOS", -1	; Top message
ErrorDataReg:	dc.b "[DATA_REGS]_", -1
ErrorAddrReg:	dc.b "[ADDR_REGS]_", -1
ErrorStack:	dc.b "[SYSTEM_STACK]", -1
		even
; ===========================================================================
ShowErrorValue:
		move.w	#(ErrorTextTile+"@"),(a6)	; display "$" symbol
		moveq	#8-1,d2

	@loop:
		rol.l	#4,d0
		bsr.s	@shownumber	; display 8 numbers
		dbf	d2,@loop
		rts	
; ---------------------------------------------------------------------------
@shownumber:
		move.w	d0,d1
		andi.w	#$F,d1
		cmpi.w	#10,d1
		blo.s	@chars0to9
		addq.w	#7,d1		; add 7 for characters A-F

	@chars0to9:
		add.w	d5,d1		; Add ErrorTextTile + palette
		add.w	#48,d1
		move.w	d1,(a6)
		rts
; ===========================================================================
ErrorWaitForC:
		jsr	ReadJoypads
		cmpi.b	#btnC,(Ctrl_1_Press).w ; is button C pressed?
		bne.s	@checkforABC	; if not, branch
		rts	
@checkforABC:
		cmpi.b	#btnABC,(Ctrl_1_Held).w ; is button ABC held?
		bne.s	ErrorWaitForC	; if not, branch
		rts	
; End of function ErrorWaitForC
; ===========================================================================
