; A sloppy implementation of 6502 in ASM68k macros
; But interpreted in such a way that it feels like coding in 68k assembly
; Note, due to being unable to use numbers for macro names,
; the prefix NES will be used instead
; ===========================================================================
; These will make things easier to program with but boy is it sloppy
A	=	$10000000
X	=	$20000000
Y	=	$30000000
NES_SP	=	$40000000

_tempval	=	0
_tempval2	=	0
_tempval3	=	0

; Programming between the M68k and 6502 can be quite tricky, so here are
; a few things to keep in mind:

; A, X and Y are all 8-bit in size

; A is the accumulator, it's similar to a Data Register
; X and Y can also be used like a Data Register but are much more limited

; X and Y are NOT the same as Address Registers
; They're merely used as offsets, similar to how "$xx(a0)" works, 
; where X/Y takes the role of the offset and the address is immediate

; There is no such thing as an Address Error, no need for "even"
; store your data however you like!

; Pages are the new think you have to worry about:
; Each page is the $xx00 of the current program counter
; If something complains about the page being wrong, make sure 
; the code is alligned to the nearest $100 to the data

; ===========================================================================
; Word sized data but backwards because 6502 is little endian
NES_DCW	macro	
	rept	narg-1
	dc.b	(\1)&$FF, ((\1)&$FF00)>>8
	shift
	endr
	endm
; ===========================================================================
; $00 - BRK - Force Break - Basically 6502's "ILLEGAL"
NES_BRK macros	
	dc.b	$00
; ===========================================================================
; $EA - NOP - No Operation - Of course it's EA, I'd NOP out too
NES_NOP macros	
	dc.b	$EA
; ===========================================================================
; $60 - RTS - Return from Subroutine
; $40 - RTI - Return from Interrupt
; The bare essentials
NES_RTS macros	
	dc.b	$60
NES_RTE macros	
	dc.b	$40
; ===========================================================================
; $78 - SEI - Set Interrupt Disable Status
; $58 - CLI - Clear Interrupt Disable Status
; Disable or Enable interrupts, self explanatory
NES_EnableInts	macros	
	dc.b	$58
NES_DisableInts	macros	
	dc.b	$78
; ===========================================================================
; $F8 - SED - Set Decimal Mode
; $18 - CLD - Clear Decimal Mode
; Disable or Enable Decimal Mode
NES_EnableDecs	macros	
	dc.b	$F8
NES_DisableDecs	macros	
	dc.b	$18
; ===========================================================================
; VERY Short branching via compare instruction abuse
; This is apparently common practice
; can be done on the M68K with tst.l but it's highly innefficient, so don't
NES_BRA	macro	Address
	case	Address
=Address=*+2
	dc.b	$C9	; CMP - Compare Memory with Accumulator - immediate
=Address=*+3
	dc.b	$24	; BIT - Test bits in Memory with Accumulator - Absolute
=?	
	inform	2, "Invalid short branch, can only branch forwards 2-3 bytes"
	endcase
	endm
; ===========================================================================
; $A5, $B5, $AD, $BD, $B9 - LDA - Load Accumulator with memory 
; $A6, $B6, $AE, $BE - LDX - Load Index X with Memory
; $A4, $B4, $AC, $BC - LDY - Load Index Y with Memory
; Loads Index with a value from an Address
; use examples : 
; 	NES_LD	Address,X	; load content in address to X
; 	NES_LD	Address+X,Y	; load content in address to Y offset by X 

; There isn't a close equivalent outside of MOVE, so we're using LD
; LEA is a poor equivalent logically and would trip up newcommers

NES_LD	macro	Address, Index
_tempval	=	($F0000000&(Address))
	if	_tempval>Y	; failsafe
		inform	3, "Something went really wrong here, buddy"
	endif
_tempval2	=	(Address&$0000FF00)
_tempval3	=	(*&$0000FF00)
	if ((Address&$0FFFFFFF)>$FFFF)	; failsafe
_tempval	=	(Address&$0FFFFFFF)
		inform	2, "That's going way too far, my dude, check your address! - %h", _tempval
	elseif ((_tempval2)=(_tempval3))	; check if address matches page
		case	Index
=A
		if	_tempval=X
		dc.b	$B5,	(Address)&$00FF	; LDA zeropage,X
		elseif	_tempval=Y
		dc.b	$B9,	(Address)&$00FF, _tempval2>>8 ; no zeropage equivalent :c
		elseif	_tempval=0
		dc.b	$A5,	(Address)&$00FF	; LDA zeropage
		else	
		inform	2, "X or Y expected, got A - %h", _tempval
		endif		
=X
		if	_tempval=Y
		dc.b	$B6,	(Address)&$00FF	; LDX zeropage,Y
		elseif	_tempval=0
		dc.b	$A6,	(Address)&$00FF	; LDX zeropage	
		else
		inform	2, "Y expected, got X or A"
		endif
=Y
		if	_tempval=X
		dc.b	$B4,	(Address)&$00FF	; LDY zeropage,X
		elseif	_tempval=0
		dc.b	$A4,	(Address)&$00FF	; LDY zeropage
		else
		inform	2, "X expected, got Y or A"
		endif
=?
		inform	2, "It's either X or Y, it can't be anything else!"
		endcase
	else
		case	Index
=A
		if	_tempval=X
		dc.b	$BD,	(Address)&$00FF, _tempval2>>8	; LDA absolute,X
		elseif	_tempval=Y
		dc.b	$B9,	(Address)&$00FF, _tempval2>>8	; LDA absolute,Y
		elseif	_tempval=0
		dc.b	$AD,	Address&$00FF, _tempval2>>8	; LDA absolute
		else
		inform	2, "X or Y expected, got A - %h", _tempval
		endif
=X
		if	_tempval=Y
		dc.b	$BE,	(Address)&$00FF, _tempval2>>8	; LDX absolute,Y
		elseif	_tempval=0
		dc.b	$AE,	Address&$00FF, _tempval2>>8	; LDX absolute
		else
		inform	2, "Y expected, got X or A"
		endif
=Y
		if	_tempval=X
		dc.b	$BC,	(Address)&$00FF, _tempval2>>8	; LDY absolute,X
		elseif	_tempval=0
		dc.b	$AC,	Address&$00FF, _tempval2>>8	; LDY absolute
		else
		inform	2, "X expected, got Y or A"
		endif
=?
		inform	2, "It's either X or Y, it can't be anything else!"
		endcase
	endif
	endm
; ===========================================================================
; $A9 - LDA - Load Accumulator with Memory 
; $A2 - LDX - Load Index X with Memory 
; $A0 - LDY - Load Index Y with Memory 
; $AA - TAX - Transfer Accumulator to X
; $A8 - TAY - Transfer Accumulator to Y
; $8A - TXA - Transfer Index X to Accumulator
; $98 - TYA - Transfer Index Y to Accumulator
; Loads Index with immediate value
; This is faster than LD, but far more limited
NES_MOVEA	macro	Value, Index
_tempval	=	($F0000000&Value)
	if	_tempval>Y	; failsafe
		inform	2, "Something went really wrong here, buddy"
	mexit
	endif
	if	(Value&$0FFFFFFF)>$FF
_tempval	=	(Value&$0FFFFFFF)
		inform	2, "Value too high, needs to be Byte sized (8-bit) - %h", _tempval
	endif
	case	Index
=A
	if	_tempval=X
		dc.b	$8A,	Value	; TXA
	elseif	_tempval=Y
		dc.b	$98,	Value	; TYA
	elseif	_tempval=0
		dc.b	$A9,	Value	; LDA
	else
		inform	2, "Invalid value, dude, come on!"
	endif
=X
	if	_tempval=A
		dc.b	$AA,	Value	; TAX time (how much??)
	elseif	_tempval=0
		dc.b	$A2,	Value	; LDX
	else
		inform	2, "Invalid value, dude, what?!"
	endif
=Y
	if	_tempval=A
		dc.b	$A8,	Value	; TAY time (Like the Joyful musician!)
	elseif	_tempval=0
		dc.b	$A0,	Value	; LDY
	else
		inform	2, "Invalid value, dude, why!?"
	endif
=?
		inform	2, "Invalid instruction, absolute skill issue"
	endcase
	endm
; ===========================================================================
; $C6, $D6, $CE, $DE - DEC - Decrement Memory by One
; $3A - DEC - Decrement by One (Accumulator)
; $CA - DEX - Decrement Index X by One
; $88 - DEY - Decrement Index Y by One
; Subtracts by 1, a quick operation
; NES_SUBQ	Address+X ; is also valid
NES_SUBQ	macro	Address
_tempval	=	($F0000000&Address)
_tempval2	=	(Address&$0FFFFFFF)
	if ((_tempval2)>$0000FFFF)	; failsafe
		inform	2, "That's going way too far, my dude, check your address!"
		mexit
	endif
	case	_tempval
=A
	if	_tempval2=0
		dc.b	$3A	; DEC
	else
		inform	2, "Index X only!"	
	endif
=X
	if	_tempval2=0
		dc.b	$CA	; DEX
	elseif	($FF00&_tempval2)=($0000FF00&*)
		dc.b	$D6, (Address)&$00FF	; DEC zeropage,X
	else
		dc.b	$DE, (Address)&$00FF, ((Address)&$00FF00)>>8	; DEC absolute,X
	endif
=Y
	if	_tempval2=0
		dc.b	$88	; DEY
	else
		inform	2, "Index X only!"	
	endif
=0
	if (($FF00&Address)=($FF00&*))	; check if address matches page
		dc.b	$C6, Address&$00FF	; DEC zeropage
	else
		dc.b	$CE, Address&$00FF, (Address&$00FF00)>>8	; DEC absolute
	endif
=?	
	inform	2, "Invalid instruction, absolute skill issue"	
	endcase
	endm
; ===========================================================================
; $85, $95, $8D, $9D, $99 - STA - Store Acumulator in memory 
; $86, $96, $8E - STX - Store Index X in Memory
; $84, $94, $8C - STY - Store Index Y in Memory
; Stored Index to an Address in memory
; use examples : 
; 	NES_ST	X,Address	; store content of X in RAM address
; 	NES_ST	Y,Address+X	; store content of Y in RAM address offset by X 

; There isn't a close equivalent outside of MOVE, so we're using ST

NES_ST	macro	Index, Address
_tempval	=	($F0000000&Address)
	if	_tempval>Y	; failsafe
		inform	3, "Something went really wrong here, buddy"
	endif
_tempval2	=	(Address&$0000FF00)
_tempval3	=	(*&$0000FF00)
	if ((Address&$0FFFFFFF)>$FFFF)	; failsafe
_tempval	=	(Address&$0FFFFFFF)
		inform	2, "That's going way too far, my dude, check your address! - %h", _tempval
	elseif ((_tempval2)=(_tempval3))	; check if address matches page
		case	Index
=A
		if	_tempval=X
		dc.b	$95,	(Address)&$00FF	; STA zeropage,X
		elseif	_tempval=Y
		dc.b	$99,	(Address)&$00FF, _tempval2>>8 ; no zeropage equivalent :c
		elseif	_tempval=0
		dc.b	$85,	Address&$00FF	; STA zeropage
		else	
		inform	2, "X or Y expected, got A - %h", _tempval
		endif		
=X
		if	_tempval=Y
		dc.b	$96,	(Address)&$00FF	; STX zeropage,Y
		elseif	_tempval=0
		dc.b	$86,	Address&$00FF	; STX zeropage	
		else
		inform	2, "Y expected, got X or A"
		endif
=Y
		if	_tempval=X
		dc.b	$94,	(Address)&$00FF	; STY zeropage,X
		elseif	_tempval=0
		dc.b	$84,	Address&$00FF	; STY zeropage
		else
		inform	2, "X expected, got Y or A"
		endif
=?
		inform	2, "It's either X or Y, it can't be anything else!"
		endcase
	else
		case	Index
=A
		if	_tempval=X
		dc.b	$9D,	(Address)&$00FF, _tempval2>>8	; STA absolute,X
		elseif	_tempval=Y
		dc.b	$99,	(Address)&$00FF, _tempval2>>8	; STA absolute,Y
		elseif	_tempval=0
		dc.b	$8D,	Address&$00FF, _tempval2>>8	; STA absolute
		else
		inform	2, "X or Y expected, got A - %h", _tempval
		endif
=X
		if	_tempval=Y
		inform	2, "Address in wrong page for Y"
		elseif	_tempval=0
		dc.b	$8E,	Address&$00FF, _tempval2>>8	; STX absolute
		else
		inform	2, "Address in wrong page and A / X used, Mega Skill issue"
		endif
=Y
		if	_tempval=X
		inform	2, "Address in wrong page for X"
		elseif	_tempval=0
		dc.b	$8C,	Address&$00FF, _tempval2>>8	; STY absolute
		else
		inform	2, "Address too far and A / Y used, Mega Skill issue"
		endif
=?
		inform	2, "It's either X or Y, it can't be anything else!"
		endcase
	endif
	endm
; ===========================================================================	
; $4C - JMP - Jump to New Location
; There's also $6C which is the same but indirect, 
; but there's no reason to use it unless code is stored in RAM
; and we do self modifying code
; $20 - JSR - Jump to New Location Saving Return Address
NES_JMP	macro	location
	dc.b	$4C, (location)&$FF, ((location)&$FF00)>>8
	endm
NES_JSR	macro	location
	dc.b	$20, (location)&$FF, ((location)&$FF00)>>8
	endm
; ===========================================================================
; $4A - LSR - Shift One Bit Right (Memory or Accumulator)
; WIP
NES_LSR	macro	Address, Index
	dc.b	$4A	; LSR A
	endm
; ===========================================================================
; $10 - BPL - Branch on Result Plus
NES_BPL	macro	location
_tempval	=	(location-(*+2))
	dc.b	$10, _tempval
	endm