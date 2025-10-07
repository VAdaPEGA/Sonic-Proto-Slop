; ===========================================================================

BusError:
		move.b	#2,(v_errortype).w
		bra.s	loc_43A

AddressError:
		move.b	#4,(v_errortype).w
		bra.s	loc_43A

IllegalInstr:
		move.b	#6,(v_errortype).w
		addq.l	#2,2(sp)
		bra.w	loc_462

ZeroDivide:
		move.b	#8,(v_errortype).w
		bra.s	loc_462

ChkInstr:
		move.b	#$A,(v_errortype).w
		bra.s	loc_462

TrapvInstr:
		move.b	#$C,(v_errortype).w
		bra.s	loc_462

PrivilegeViol:
		move.b	#$E,(v_errortype).w
		bra.s	loc_462

Trace:
		move.b	#$10,(v_errortype).w
		bra.s	loc_462

Line1010Emu:
		move.b	#$12,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	loc_462

Line1111Emu:
		move.b	#$14,(v_errortype).w
		addq.l	#2,2(sp)
		bra.s	loc_462

ErrorExcept:
		move.b	#0,(v_errortype).w
		bra.s	loc_462
INVALIDOBJECT:
		move.b	#$16,(v_errortype).w
		bsr.s	loc_462
; ===========================================================================

loc_43A:	; Bus / Address Error
		disable_ints
		addq.w	#2,sp
		move.l	(sp)+,(v_spbuffer).w
		addq.w	#2,sp
		movem.l	d0-a7,(v_regbuffer).w
		bsr.w	ShowErrorMessage
		move.l	2(sp),d0
		locVRAM	(vram_fg+$B84)
		bsr.w	ShowErrorValue
		move.l	(v_spbuffer).w,d0
		bsr.w	ShowErrorValue
		bra.s	loc_478
; ===========================================================================

loc_462:
		disable_ints
		movem.l	d0-a7,(v_regbuffer).w
		bsr.w	ShowErrorMessage
		move.l	2(sp),d0
		locVRAM	(vram_fg+$B84)
		bsr.w	ShowErrorValue

loc_478:
		clr.l	(v_scrposy_dup).w		; clear Vertical position
		clr.l	(v_hscrolltablebuffer).w	; clear horizontal position

		lea	(vdp_data_port).l,a6
		locVSRAM 0		
		move.l	#$0,(a6)		; clear Y position in VSRAM
		locVRAM	vram_hscroll
		move.l	#$0,(a6)		; clear X position in VRAM

		locCRAM	2*1				; update palette
		move.w	#cBlack,(a6)
		locCRAM	2*2
		move.w	#cWhite,(a6)

		locVRAM	(VRAM_sprites)
		move.l	#$0,(a6)
		move.l	#$0,(a6)

		move.l	#$8B009100,(vdp_control_port).l	; scroll mode (one long for screen), no Window
		bsr.w	ErrorWaitForC	
		if	(Lockon)
		move.l	#$8B039100,(vdp_control_port).l	; scroll mode (one long for each line) no Window
		else
		move.l	#$8B03918E,(vdp_control_port).l	; scroll mode (one long for each line) Window
		endif
		movem.l	(v_regbuffer).w,d0-a7
		enable_ints
		rte	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ShowErrorMessage:
		lea	(vdp_data_port).l,a6
		locVRAM	$F800
		lea	(Art_Text).l,a0
		move.w	#(48*8)-1,d1
	@loadgfx:
		move.l	(a0)+,(a6)
		dbf	d1,@loadgfx


		; stack
		locVRAM	(vram_fg+4+128*11)	
		lea	ErrorStack,a0
		bsr	@showchars

		locVRAM	(vram_fg+40+128*11)
		move.l	sp,d0
		add.l	#6,d0
		move.l	d0,a0
		bsr	ShowErrorValue

		locVRAM	(vram_fg+4+128*12)
		moveq	#4-1,d3
		bsr	@loopStack
		locVRAM	(vram_fg+4+128*13)
		moveq	#4-1,d3
		bsr	@loopStack
		locVRAM	(vram_fg+4+128*14)
		moveq	#4-1,d3
		bsr	@loopStack
		locVRAM	(vram_fg+4+128*15)
		moveq	#4-1,d3
		bsr	@loopStack
		; ---


		locVRAM	(vram_fg+4+128*1)	
		lea	ErrorCat,a0
		bsr	@showchars

		; d0 > d7
		locVRAM	(vram_fg+4+128*3)
		move.l	#$87D487C0,d4	; D0
		lea	ErrorDataReg,a0
		bsr	@showchars

		lea	(v_regbuffer).w,a0		
		moveq	#2-1,d3
		bsr	@loopregLine
		locVRAM	(vram_fg+4+128*4)
		moveq	#3-1,d3
		bsr	@loopregLine
		locVRAM	(vram_fg+4+128*5)
		moveq	#3-1,d3
		bsr	@loopregLine
		; ---

		; a0 > a7
		locVRAM	(vram_fg+4+128*7)
		move.l	#$87D187C0,d4	; A0	
		lea	ErrorAddrReg,a0
		bsr	@showchars

		lea	(v_regbuffer+4*8).w,a0
		moveq	#2-1,d3
		bsr	@loopregLine
		locVRAM	(vram_fg+4+128*8)
		moveq	#3-1,d3
		bsr	@loopregLine
		locVRAM	(vram_fg+4+128*9)
		moveq	#3-1,d3
		bsr	@loopregLine
		; ---

		moveq	#0,d0		; clear	d0
		move.b	(v_errortype).w,d0 ; load error code
		move.w	ErrorText(pc,d0.w),d0
		lea	ErrorText(pc,d0.w),a0
		locVRAM	(vram_fg+$B04)
		bsr	@showchars
		locVRAM	(vram_fg+$C84)
		lea	ErrorPress,a0
	@showchars:
		moveq	#0,d0
		move.b	(a0)+,d0	
		bmi.s	@_end		; text termination
		addi.w	#$8790,d0
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
		move.w	#$87EF,(a6)	; display " " symbol
		dbf	d3,@loopregLine	; loop for each line
		rts
; End of function ShowErrorMessage

; ===========================================================================
ErrorText:	dc.w @exception-ErrorText, @bus-ErrorText
		dc.w @address-ErrorText, @illinstruct-ErrorText
		dc.w @zerodivide-ErrorText, @chkinstruct-ErrorText
		dc.w @trapv-ErrorText, @privilege-ErrorText
		dc.w @trace-ErrorText, @line1010-ErrorText
		dc.w @line1111-ErrorText, @InvalidObject-ErrorText
@exception:	dc.b "[PROTO_EXCEPTION]", $FF
@bus:		dc.b "[IMAGINE_A_BUS]", $FF
@address:	dc.b "[ADDRESS_BETA]", $FF
@illinstruct:	dc.b "[ILLEGAL_DUMP]", $FF
@zerodivide:	dc.b "[DIVIDED_COMMUNITY]", $FF
@chkinstruct:	dc.b "[CHECK_MY_HACK]", $FF
@trapv:		dc.b "[TRAPVERY]", $FF
@privilege:	dc.b "[PROTO_VIOLATION]", $FF
@trace:		dc.b "[TRACED_ART]", $FF
@line1010:	dc.b "[1010_VERSION]", $FF
@line1111:	dc.b "[1111_VERSION]", $FF
@InvalidObject:	dc.b "[INVALID_LVL_OBJECT]", $FF

ErrorPress:	dc.b "[HACK_UNSTABLE]_>PRESS_C_TO_CONTINUE<", $FF
ErrorCat:	dc.b "OH_NO__MY_PROTOS", $FF
ErrorDataReg:	dc.b "\DATA_REGS\_", $FF
ErrorAddrReg:	dc.b "\ADDR_REGS\_", $FF
ErrorStack:	dc.b "\SYSTEM_STACK\", $FF

		even


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ShowErrorValue:
		move.w	#$87D0,(a6)	; display "$" symbol
		moveq	#8-1,d2

	@loop:
		rol.l	#4,d0
		bsr.s	@shownumber	; display 8 numbers
		dbf	d2,@loop
		rts	
; End of function ShowErrorValue




; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


@shownumber:
		move.w	d0,d1
		andi.w	#$F,d1
		cmpi.w	#$A,d1
		blo.s	@chars0to9
		addq.w	#7,d1		; add 7 for characters A-F

	@chars0to9:
		addi.w	#$87C0,d1
		move.w	d1,(a6)
		rts	
; End of function sub_5CA


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ErrorWaitForC:
		if	(Lockon)
		jsr	ReadJoypads
		else
		bsr.w	ReadJoypads
		endif
		cmpi.b	#btnC,(v_jpadpress1).w ; is button C pressed?
		bne.s	@checkforABC	; if not, branch
		rts	
@checkforABC:
		cmpi.b	#btnABC,(v_jpadhold1).w ; is button ABC held?
		bne.s	ErrorWaitForC	; if not, branch
		rts	
; End of function ErrorWaitForC
; ===========================================================================
