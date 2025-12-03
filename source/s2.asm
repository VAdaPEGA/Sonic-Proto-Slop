; /=========================================================================\
; | ~Sonic Proto Slop~
; \=========================================================================/
; Generated with Interactive Disassembler (IDA)
; Original Disassembly : drx | Special Thanks : Hivebrain and Rika_Chou
;
; ===========================================================================
	include	"s2.macros.asm"
	include	"s2.constants.asm"
	include	"s2.ram.asm"
; ===========================================================================
; Development relevant
Devmode		=	1   ; Development mode, enables all cheats by default
DevHitboxes	=	1   ; Show Hitboxes of everything that's parsed in "TouchResponses"
Lagometer	=	1   ; Lagometer (uses window layer to show lag)
RecordDemoMode	=	1   ; 
; Build Features
Lockon		=	1   ; Lock-on Support
NESROMSupport	=	1   ; Support for NES compatability via Vector Table Hijack
SSAngleModifier	=	$FC ; Special Stage angle : Set number from $00 to $FF as the smoothness modifier
; ===========================================================================
StartOfRom:
Vectors:	
		if (NESROMSupport)
		; iNES header (not using NES 2.0 to keep things sane)
		dc.b	"NES", $1A	; 0-3 	Constant $4E $45 $53 $1A (ASCII "NES" followed by MS-DOS end-of-file)

		dc.b	$04	; 4 	Size of PRG ROM in 16 KB units
		dc.b	$02	; 5 	Size of CHR ROM in 8 KB units (value 0 means the board uses CHR RAM)
		dc.b	$11	; 6 	Flags 6 – Mapper, mirroring, battery, trainer
		dc.b	$00	; 7 	Flags 7 – Mapper, VS/Playchoice, NES 2.0

		; Entry point is now at $021100

		; I didn't need to support these but it felt like I should complete it, plus it lets me do something stupid
		; later down in the vector table, you'll see it~
		dc.b	$00	; 8 	Flags 8 – PRG-RAM size (rarely used extension)
		dc.b	$00	; 9 	Flags 9 – TV system (rarely used extension)
		dc.b	$00	; 10 	Flags 10 – TV system, PRG-RAM presence (unofficial, rarely used extension)
		dc.b	$A0	; 11	Unused padding (jump to header)

		dc.l	AddressError	; Address error (4)		; 12-15	Unused padding (should be filled with zero)

		else
		dc.l	System_Stack	; Initial stack pointer value	; 0-3
		dc.l	EntryPoint	; Start of program		; 4-7
		dc.l	BusError	; A Crazy error			; 8-11
		dc.l	AddressError	; Address error (4)		; 12-15
		endif
		
		dc.l	IllegalInstr	; Illegal instruction
		dc.l	ZeroDivide	; Division by zero
		dc.l	ChkInstr	; CHK exception
		dc.l	TrapvInstr	; TRAPV exception (8)
		dc.l	PrivilegeViol	; Check your Privilege
		dc.l	Trace		; TRACE exception
		dc.l	Line1010Emu	; Line-A emulator
		dc.l	Line1111Emu	; Line-F emulator (12)
		dc.b	"- HACK BY:     -"
		dc.b	"    VAdaPEGA    "
		dc.b	"- VADAPEGA.ART -"
		dc.l	ErrorExcept	; Spurious exception
		dc.l	ErrorTrap	; IRQ level 1
		dc.l	ErrorTrap	; IRQ level 2
		dc.l	ErrorTrap	; IRQ level 3 (28)
		dc.l	H_Int		; IRQ level 4 (horizontal retrace interrupt)
		dc.l	ErrorTrap	; IRQ level 5
		dc.l	V_Int		; IRQ level 6 (vertical retrace interrupt)
		dc.l	ErrorTrap	; IRQ level 7 (32)
		dc.l	TrapException	; TRAP #00 exception
		dc.b	"-->"
		dc.b	$87
		dc.b	"IS THAT "
		dc.b	"THE BYTE OF 87!?"
		bra.w	BusError		; Funny Hack-ey workaround
		dc.w	ASCII_Linebreak
		dc.b	"=="
		dc.w	ASCII_Linebreak
		dc.b	"PROJECT PROTO SLOP    "
		dc.w	ASCII_Linebreak
		if (Devmode)
		dc.b	"** DEBUG BUILD **  "
		else
		dc.b 	"*  Proto release? *"
		endif	
		dc.w	ASCII_Linebreak
		dc.b	"LOCAL BUILD DATE : "
		GetDate
		dc.w	ASCII_Linebreak
		dc.b	"=="
		dc.w	ASCII_Linebreak; byte_100
Header:
		dc.b "SEGA MEGA DRIVE " ; Console name
		dc.b "(C)SEGA 1991.APR" ; Copyright holder and release year (leftover from Sonic 1)
Title_Local:	dc.b "SONIC PROTO SLOP"
		if (Devmode)
		dc.b "       -DEBUG-  " 
		else
		dc.b "                "	; Domestic name + Build date
		endif
		GetDate
Title_Int:	dc.b "SONIC PROTO SLOP"
		if (Devmode)
		dc.b "       -DEBUG-  " 
		else
		dc.b "                "	; International name + Build date
		endif
		GetDate	

		if	(Lockon)
		dc.b "GM MK-1079 -00"   ; Sonic 3
		else
		dc.b "GM 00004049-01"   ; Version (leftover from Sonic 1)
		endif
Checksum:
		dc.w $AFC7		; Checksum (patched later if incorrect)
		dc.b "J               " ; I/O support
		dc.l StartOfRom		; Start address of ROM
ROMLoc:		dc.l StartOfRom,	EndOfRom-1	; ROM start and end
RAMLoc:		dc.l $FF0000,		$FFFFFF		; RAM start and end
SRAMSupport:	dc.b 'RA',	$F8,	$20		; SRAM type
SRAMLoc:	dc.l $200001,		$20FFFF		; SRAM start and end
ModemSupport:	dc.l $0					; Modem Type
ModemLoc:	dc.l $0,		$0		; Modem start and end
Notes:		dc.b "THIS IS STILL A SONIC 1 ROM HACK!!"
; ===========================================================================
ErrorTrap:	; yup, it's part of the NOTES now, sue me for saving 6 bytes
		nop	
		nop	
		bra.s	ErrorTrap
; ===========================================================================
Region:		dc.b	"UJE             " ; Region
		dc.w	ASCII_Linebreak
		incbin	"Description.txt"	; Keep description at 95 lines! 
		even
; ===========================================================================
		include	"Routines\Error Handler.asm"
		include	"Routines\Error Checksum.asm"
; ===========================================================================
		if (NESROMSupport)
		include	"SOUP\6502MacroSet.asm"
SMBTopScoreDisplay	= $07d7
		OBJ	*+$8000-$10	; Allign code
SwapChr:
		NES_MOVEA $80,A
		NES_ST	A,$8008	; Reset 
		NES_ST	A,$EAAE
		
		NES_MOVEA %00010,A
		NES_ST	A,$8008
		NES_LSR	A
		NES_ST	A,$8008
		NES_LSR	A
		NES_ST	A,$8008
		NES_LSR	A
		NES_ST	A,$8008
		NES_LSR	A
		NES_ST	A,$8008
		
		NES_MOVEA 2,A
		NES_ST	A,$EAAE
		NES_LSR	A
		NES_ST	A,$EAAE
		NES_LSR	A
		NES_ST	A,$EAAE
		NES_ST	A,$EAAE
		NES_ST	A,$EAAE
		NES_JMP	$8128
SwapChrEnd:
;-------------------------------------------------------------------------------------
		align	$A000
		NES_DisableInts
		NES_MOVEA	((SwapChrEnd-SwapChr)-1),X	; number of loops (ammount of data to store in RAM)
@loop:		
		NES_LD	SwapChr+X,A	; get 
		NES_ST	A,SMBTopScoreDisplay+X	; store code here so game knows it's a cold boot
		NES_SUBQ	X	; subtract X by 1
		NES_BPL	@loop	; loop until X is negative
		NES_JMP	SMBTopScoreDisplay
		OBJEND	; return to normal allignment
	; Special Thanks to kakalakola for the help with the Bank Switching
; ===========================================================================
	if	(filesize("..\SMB1.nes")=-1)
		inform	3, "YOU DUMBASS, YOU FORGOT YOUR SUPER MARIO BROS. ROM, make sure it's present as 'SMB1.nes' in the root folder"
	else
	endif
		align	$008010,$CA
		incbin	"SOUP\SOUP.BIN"
	;	incbin	"SOUP\SOUP.ArtUnc"
	;	incbin	"SOUP\SOUP.ArtUnc"
	if	(filesize("..\SMB1.nes")=$A010)
NES_CHR	=	$8010
	else	; headerless ROM
NES_CHR	=	$8000
	endif
		incbin	"..\SMB1.nes", NES_CHR, $CD0
	NES_Add	ProToad,	SOUP\, ProToad	
		incbin	"..\SMB1.nes", (NES_CHR+($CD0+size_artnes_protoad)),($1000-$CD0-size_artnes_protoad)

	NES_Add	LevSelNums,	SOUP\, LevelSelectNumbers
	NES_Add LevSelLetters,	SOUP\, LevelSelectLetters
		incbin	"..\SMB1.nes", (NES_CHR+$1000+(*-ArtNES_LevSelNums)),($1000-(*-ArtNES_LevSelNums))
	Mono_Add	LevSel1, Routines\, DebugASCII_Part1	; Level select text (1BPP cause why not)
	Mono_Add	LevSel2, Routines\, DebugASCII_Part2
	Mono_Add	LevSel3, Routines\, DebugASCII_Part3
; ===========================================================================
		align	$021100
EntryPoint:
		move.l	#System_Stack,sp
		else

	Mono_Add LevelSelectPart1, Routines\, DebugASCII_Part1	; Level select text (1BPP cause why not)
	NES_Add	LevSelNums,	SOUP\, LevelSelectNumbers
	Mono_Add LevelSelectPart2, Routines\, DebugASCII_Part2
	NES_Add LevSelLetters,	SOUP\, LevelSelectLetters
	Mono_Add LevelSelectPart3, Routines\, DebugASCII_Part3

EntryPoint:		
		endif

		tst.l	(HW_Port_1_Control-1).l		; test port A & B control registers
		bne.s	PortA_Ok
		tst.w	(HW_Expansion_Control-1).l	; test port C control register
	PortA_Ok:
		bne.s	SkipSetup

		lea	SetupValues(pc),a5
		movem.w	(a5)+,d5-d7
		movem.l	(a5)+,d4/a0-a4
		move.b	(HW_Version-Z80_Bus_Request)(a1),d0
		andi.b	#ByteIoVersion,d0	; check Hardware version
		beq.s	SkipSecurity		; skip if Hardware has no TMSS
		move.l	d4,(HW_SEGA-Z80_Bus_Request)(a1)	; move "SEGA" to TMSS register

SkipSecurity:
		move.w	(a4),d0
		moveq	#0,d0
		movea.l	d0,a6
		move.l	a6,usp		; set usp to 0

		moveq	#$60/4-1,d1
VDPInitLoop:
		move.b	(a5)+,d5	; add $8000 to value
		move.w	d5,(a4)		; move value to	VDP register
		add.w	d7,d5		; next register
		dbf	d1,VDPInitLoop

		move.l	(a5)+,(a4)
		move.w	d0,(a3)		; clear	the VRAM
		move.w	d7,(a1)		; stop the Z80
		move.w	d7,(a2)		; reset	the Z80

	WaitForZ80:
		btst	d0,(a1)		; has the Z80 stopped?
		bne.s	WaitForZ80	; if not, branch

		moveq	#$26-1,d2
Z80InitLoop:
		move.b	(a5)+,(a0)+
		dbf	d2,Z80InitLoop

		move.w	d0,(a2)
		move.w	d0,(a1)		; start	the Z80
		move.w	d7,(a2)		; reset	the Z80

ClrRAMLoop:
		move.l	d0,-(a6)
		dbf	d6,ClrRAMLoop	; clear	the entire RAM

		move.l	(a5)+,(a4)	; set VDP display mode and increment
		move.l	(a5)+,(a4)	; set VDP to CRAM write

		moveq	#$80/4-1,d3
ClrCRAMLoop:
		move.l	d0,(a3)
		dbf	d3,ClrCRAMLoop	; clear	the CRAM
		move.l	(a5)+,(a4)

		moveq	#$50/4-1,d4
ClrVSRAMLoop:
		move.l	d0,(a3)
		dbf	d4,ClrVSRAMLoop ; clear the VSRAM
		moveq	#3,d5

PSGInitLoop:
		move.b	(a5)+,$11(a3)	; reset	the PSG
		dbf	d5,PSGInitLoop
		move.w	d0,(a2)
		movem.l	(a6),d0-a6	; clear	all registers
		disable_ints

SkipSetup:
		bra.w	GameProgram	; begin game
; ===========================================================================
SetupValues:	dc.w $8000		; d5 | VDP register start number
		dc.w $3FFF		; d6 | size of RAM/4
		dc.w $100		; d7 | VDP register diff

		dc.b 'SEGA'		; d4 | SEGA
		dc.l z80_ram		; a0 | start of Z80 RAM
		dc.l z80_bus_request	; a1 | Z80 bus request
		dc.l z80_reset		; a2 | Z80 reset
		dc.l vdp_data_port	; a3 | VDP data
		dc.l vdp_control_port	; a4 | VDP control

		dc.b 4			; VDP $80 - 8-colour mode
		dc.b $14		; VDP $81 - Megadrive mode, DMA enable
		dc.b (VRAM_FG>>10)	; VDP $82 - foreground nametable address
		dc.b (VRAM_FG2P>>10)	; VDP $83 - window nametable address
		dc.b (VRAM_BG>>13)	; VDP $84 - background nametable address
		dc.b (VRAM_Sprites>>9)	; VDP $85 - sprite table address
		dc.b 0			; VDP $86 - unused
		dc.b 0			; VDP $87 - background colour
		dc.b 0			; VDP $88 - unused
		dc.b 0			; VDP $89 - unused
		dc.b 255		; VDP $8A - HBlank register
		dc.b 0			; VDP $8B - full screen scroll
		dc.b $81		; VDP $8C - 40 cell display
		dc.b (VRAM_HScroll>>10)	; VDP $8D - hscroll table address
		dc.b 0			; VDP $8E - unused
		dc.b 1			; VDP $8F - VDP increment
		dc.b 1			; VDP $90 - 64 cell hscroll size
		dc.b 0			; VDP $91 - window h position
		dc.b 0			; VDP $92 - window v position
		dc.w $FFFF		; VDP $93/94 - DMA length
		dc.w 0			; VDP $95/96 - DMA source
		dc.b $80		; VDP $97 - DMA fill VRAM
		dc.l $40000080		; VRAM address 0

		dc.b $AF		; xor	a
		dc.b $01, $D9, $1F	; ld	bc,1fd9h
		dc.b $11, $27, $00	; ld	de,0027h
		dc.b $21, $26, $00	; ld	hl,0026h
		dc.b $F9		; ld	sp,hl
		dc.b $77		; ld	(hl),a
		dc.b $ED, $B0		; ldir
		dc.b $DD, $E1		; pop	ix
		dc.b $FD, $E1		; pop	iy
		dc.b $ED, $47		; ld	i,a
		dc.b $ED, $4F		; ld	r,a
		dc.b $D1		; pop	de
		dc.b $E1		; pop	hl
		dc.b $F1		; pop	af
		dc.b $08		; ex	af,af'
		dc.b $D9		; exx
		dc.b $C1		; pop	bc
		dc.b $D1		; pop	de
		dc.b $E1		; pop	hl
		dc.b $F1		; pop	af
		dc.b $F9		; ld	sp,hl
		dc.b $F3		; di
		dc.b $ED, $56		; im1
		dc.b $36, $E9		; ld	(hl),e9h
		dc.b $E9		; jp	(hl)

		dc.w $8104		; VDP display mode
		dc.w $8F02		; VDP increment
		dc.l $C0000000		; CRAM write mode
		dc.l $40000010		; VSRAM address 0

		dc.b $9F, $BF, $DF, $FF	; values for PSG channel volumes
; ===========================================================================

GameProgram:
		tst.w	(VDP_control_port).l
		btst	#6,(HW_Expansion_Control).l
		beq.s	ChecksumTest
		cmpi.l	#'BETA',(Checksum_Init).w
		beq.w	GameInit

ChecksumTest:
		movea.l	#ErrorTrap,a0	; start checking bytes after header ($200)
		movea.l	#ROMLoc+4,a1	; stop at end of ROM (but not really since it's half the ROM, leftover from Sonic 1)
		move.l	(a1),d0
		move.l	#$7FFFF,d0
		moveq	#0,d1

ChecksumLoop:
		add.w	(a0)+,d1
		cmp.l	a0,d0
		bcc.s	ChecksumLoop
		movea.l	#Checksum,a1	; read the checksum
		cmp.w	(a1),d1		; compare correct checksum to one in ROM
		;beq	CheckSumError

		lea	($FFFFFE00).w,a6
		moveq	#0,d7
		moveq	#$200/4-1,d6
	@ClearRAM:
		move.l	d7,(a6)+
		dbf	d6,@ClearRAM

		move.b	(HW_Version).l,d0
		andi.b	#$C0,d0
		move.b	d0,($FFFFFFF8).w	; save only PAL and Region info
		move.l	#'BETA',(Checksum_Init).w

GameInit:
		lea	($FF0000).l,a6
		moveq	#0,d7
		move.w	#$3F7F,d6

GameClrRAM:
		move.l	d7,(a6)+
		dbf	d6,GameClrRAM
		bsr.w	VDPSetupGame
		; SoundDriverLoad
		stopZ80
		resetZ80
		lea	(Kos_Z80).l,a0
		lea	(Z80_RAM).l,a1
		bsr.w	KosDec
		resetZ80a
		nop
		nop
		nop
		nop
		resetZ80

		; Joypad Init
		moveq	#$40,d0
		move.b	d0,(HW_Port_1_Control).l
		move.b	d0,(HW_Port_2_Control).l
		move.b	d0,(HW_Expansion_Control).l
		startZ80

		move.b	#GameModeID_Logo,(Game_Mode).w
MainGameLoop:
		move.b	(Game_Mode).w,d0		; load Game Mode
		andi.w	#$1E,d0				; Mask out bytes and clean d0
		move.w	@GameModeArray(pc,d0.w),a0	; get value from table
		add.l	a0,a0				; multiply by 2
		add.l	#GameModesStart,a0		; stupid workaround I'm so mad x.x
		jsr	(a0)	; Jump to Game Mode
		bra.s	MainGameLoop
; ===========================================================================
@GameModeArray:
c	=	0
		rept	GameModeCount
		dc.w	((_GameMode\#c)-GameModesStart)/2
c	=	c+1
		endr
		rts
; ===========================================================================

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; vertical and horizontal interrupt handlers
; VERTICAL INTERRUPT HANDLER:
; VBlank
; VBI
V_Int:
		movem.l	d0-a6,-(sp)
		LagOn
		tst.b	(Vint_routine).w
		beq.s	Vint_Lag

loc_B12:
		move.w	(VDP_control_port).l,d0
		andi.w	#8,d0
		beq.s	loc_B12
		locVSRAM	0
		move.l	(Vscroll_Factor).w,(VDP_data_port).l
		btst	#6,($FFFFFFF8).w
		beq.s	loc_B40
		move.w	#$700,d0

loc_B3C:
		dbf	d0,loc_B3C

loc_B40:
		move.b	(Vint_routine).w,d0
		move.b	#VintID_Lag,(Vint_routine).w
		move.w	#1,(Hint_flag).w
		andi.w	#$3E,d0
		move.w	Vint_SwitchTbl(pc,d0.w),d0
		jsr	Vint_SwitchTbl(pc,d0.w)
; loc_B5C:
Vint_SoundDriver:
		jsr	(sub_71B4C).l
; loc_B62:
VintRet:
		addq.l	#1,(Vint_runcount).w
		movem.l	(sp)+,d0-a6
		rte
; ===========================================================================
; off_B6C:
	IndexStart	Vint_SwitchTbl
	GenerateIndexID	Vint, Lag
	GenerateIndexID	Vint, SEGA
	GenerateIndexID	Vint, Title
	GenerateIndexID	Vint, Unused6
	GenerateIndexID	Vint, Level
	GenerateIndexID	Vint, S1SS
	GenerateIndexID	Vint, TitleCard
	GenerateIndexID	Vint, UnusedE
	GenerateIndexID	Vint, Pause
	GenerateIndexID	Vint, Fade
	GenerateIndexID	Vint, PCM
	GenerateIndexID	Vint, SSResults
	GenerateIndex	Vint, TitleCard
; ===========================================================================
; loc_B86: VintSub0:
Vint_Lag:
		cmpi.b	#GameModeID_TitleCard|GameModeID_Level,(Game_Mode).w
		beq.s	loc_BA0
		cmpi.b	#GameModeID_Demo,(Game_Mode).w
		beq.s	loc_BA0
		cmpi.b	#GameModeID_Level,(Game_Mode).w
		bne.w	Vint_SoundDriver

loc_BA0:
		tst.b	(Water_flag).w
		beq.w	Vint0_noWater
		move.w	(VDP_control_port).l,d0
		move.w	#1,(Hint_flag).w
		stopZ80
		waitZ80
		tst.b	(Water_fullscreen_flag).w
		bne.s	@ScreenIsUnderWater
		writeCRAM	Normal_Palette, (32*4), 0
		bra.s	@ScreenIsAboveWater
	@ScreenIsUnderWater:
		writeCRAM	Water_Palette, (32*4), 0
	@ScreenIsAboveWater:
		move.w	(Hint_counter_reserve).w,(a5)
		move.w	#$8230,(VDP_control_port).l
		startZ80
		bra.w	Vint_SoundDriver
; ---------------------------------------------------------------------------
; loc_C3E:
Vint0_noWater:
		move.w	(VDP_control_port).l,d0
		locVSRAM	0
		move.l	(Vscroll_Factor).w,(VDP_data_port).l
		move.w	#1,(Hint_flag).w
		move.w	(Hint_counter_reserve).w,(VDP_control_port).l
		move.w	#$8230,(VDP_control_port).l
		move.l	($FFFFF61E).w,($FFFFEEF0).w	; prepare screen for 2nd Player
		writeVRAM	Sprite_Table,$280,VRAM_Sprites
		bra.w	Vint_SoundDriver
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; loc_CAA: VintSub2:
Vint_SEGA:
		bsr.w	Do_ControllerPal
; loc_CAE: VintSub14:
Vint_PCM:
		tst.w	(Demo_Time_left).w
		beq.w	locret_CBA
		subq.w	#1,(Demo_Time_left).w

locret_CBA:
		rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; loc_CBC: VintSub4:
Vint_Title:
		bsr.w	Do_ControllerPal
		bsr.w	ProcessPLC
		tst.w	(Demo_Time_left).w
		beq.w	locret_CD0

loc_CCC:
		subq.w	#1,(Demo_Time_left).w

locret_CD0:
		rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; loc_CD2: VintSub6:
Vint_Unused6:
		bsr.w	Do_ControllerPal
		rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; loc_CD8: VintSub10:
Vint_Pause:
		cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w
		beq.w	Vint_S1SS
; loc_CE2: VintSub8:
Vint_Level:
		bsr.w	ReadJoypads
		bsr.w	ProcessDMAQueue
		startZ80

		tst.b	(Water_fullscreen_flag).w
		bne.s	@ScreenIsUnderWater
		writeCRAM	Normal_Palette, (32*4), 0
		bra.s	@ScreenIsAboveWater
	@ScreenIsUnderWater:
		writeCRAM	Water_Palette, (32*4), 0
	@ScreenIsAboveWater:
		move.w	(Hint_counter_reserve).w,(a5)
		move.w	#$8230,(VDP_control_port).l
		writeVRAM	Horiz_Scroll_Buf,(224*4),VRAM_HScroll
		writeVRAM	Sprite_Table,$280,VRAM_Sprites

		movem.l	(Camera_RAM).w,d0-d7
		movem.l	d0-d7,($FFFFEE60).w
		movem.l	(Camera_X_pos_P2).w,d0-d7
		movem.l	d0-d7,($FFFFEE80).w
		movem.l	(Scroll_flags).w,d0-d3
		movem.l	d0-d3,($FFFFEEA0).w
		move.l	($FFFFF61E).w,($FFFFEEF0).w
		cmpi.b	#92,(Hint_counter_reserve+1).w
		bcc.s	Do_Updates
		move.b	#1,(Do_Updates_in_H_int).w
		addq.l	#4,sp
		bra.w	VintRet

; ---------------------------------------------------------------------------
; Subroutine to run a demo for an amount of time
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Demo_Time:
Do_Updates:
		bsr.w	LoadTilesAsYouMove
		jsr	(HudUpdate).l
		bsr.w	ProcessPLC2
		tst.w	(Demo_Time_left).w
		beq.w	Do_Updates_End
		subq.w	#1,(Demo_Time_left).w

Do_Updates_End:	
		rts
; End of function Do_Updates

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; loc_E02: VintSubA:
Vint_S1SS:
		bsr.w	ReadJoypads
		bsr.w	ProcessDMAQueue
		startZ80
		writeCRAM	Normal_Palette, (32*4), 0
		writeVRAM	Horiz_Scroll_Buf,(224*4),VRAM_HScroll
		writeVRAM	Sprite_Table,$280,VRAM_Sprites
		bsr.w	PalCycle_S1SS
		tst.w	(Demo_Time_left).w
		beq.w	locret_EA0
		subq.w	#1,(Demo_Time_left).w

locret_EA0:
		rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; loc_EA2: VintSubC: VintSub18:
Vint_TitleCard:	
		bsr.w	ReadJoypads
		bsr.w	ProcessDMAQueue
		startZ80
		tst.b	(Water_fullscreen_flag).w
		bne.s	@ScreenIsUnderWater
		writeCRAM	Normal_Palette, (32*4), 0
		bra.s	@ScreenIsAboveWater
	@ScreenIsUnderWater:
		writeCRAM	Water_Palette, (32*4), 0
	@ScreenIsAboveWater:
		move.w	(Hint_counter_reserve).w,(a5)
		writeVRAM	Horiz_Scroll_Buf,(224*4),VRAM_HScroll
		writeVRAM	Sprite_Table,$280,VRAM_Sprites
		movem.l	(Camera_RAM).w,d0-d7
		movem.l	d0-d7,($FFFFEE60).w
		movem.l	(Scroll_flags).w,d0-d1
		movem.l	d0-d1,($FFFFEEA0).w
		bsr.w	LoadTilesAsYouMove
		jsr	(HudUpdate).l
		bsr.w	ProcessPLC
		rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; loc_F88: VintSubE:
Vint_UnusedE:
		bsr.w	Do_ControllerPal
		addq.b	#1,($FFFFF628).w
		move.b	#$E,(Vint_routine).w
		rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; loc_F98: VintSub12:
Vint_Fade:
		bsr.w	Do_ControllerPal
		move.w	(Hint_counter_reserve).w,(a5)
		bra.w	ProcessPLC
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; loc_FA4: VintSub16:
Vint_SSResults:
		bsr.w	ReadJoypads
		startZ80
		writeVRAM	Horiz_Scroll_Buf,(224*4),VRAM_HScroll
		writeVRAM	Sprite_Table,$280,VRAM_Sprites
		writeCRAM	Normal_Palette, (32*4), 0
		tst.w	(Demo_Time_left).w
		beq.w	locret_103A
		subq.w	#1,(Demo_Time_left).w

locret_103A:
		rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_103C:
Do_ControllerPal:

		tst.b	(Water_fullscreen_flag).w
		bne.s	@ScreenIsUnderWater
		writeCRAM	Normal_Palette, (32*4), 0
		bra.s	@ScreenIsAboveWater
; ---------------------------------------------------------------------------
	@ScreenIsUnderWater:
		writeCRAM	Water_Palette, (32*4), 0
	@ScreenIsAboveWater:
		writeVRAM	Horiz_Scroll_Buf,(224*4),VRAM_HScroll
		writeVRAM	Sprite_Table,$280,VRAM_Sprites
; ---------------------------------------------------------------------------
ReadJoypads:
		stopZ80
		waitZ80
		lea	(Ctrl_1).w,a0		; address where joypad states are written
		lea	(HW_Port_1_Data).l,a1	; first joypad port
		bsr.s	Joypad_Read		; do the first joypad
		addq.w	#2,a1			; do the second joypad

Joypad_Read:
		move.b	#0,(a1)
		nop
		nop
		move.b	(a1),d0
		lsl.b	#2,d0
		andi.b	#$C0,d0
		move.b	#$40,(a1)
		nop
		nop
		move.b	(a1),d1
		andi.b	#$3F,d1
		or.b	d1,d0
		not.b	d0
		move.b	(a0),d1
		eor.b	d0,d1
		move.b	d0,(a0)+
		and.b	d0,d1
		move.b	d1,(a0)+
		rts
; ---------------------------------------------------------------------------
; ||||||||||||||| E N D   O F   V - I N T |||||||||||||||||||||||||||||||||||

; ===========================================================================
; Start of H-INT code
H_Int:
		tst.w	(Hint_flag).w
		beq.w	locret_1184
		tst.w	(Two_player_mode).w
		beq.w	PalToCRAM
		move.w	#0,(Hint_flag).w
		move.l	a5,-(sp)
		move.l	d0,-(sp)

loc_110E:
		move.w	(VDP_control_port).l,d0
		andi.w	#4,d0
		beq.s	loc_110E
		move.w	(VDP_Reg1_val).w,d0
		andi.b	#$BF,d0
		;move.w	d0,(VDP_control_port).l	; Turn off Display
		move.w	#$8200+(VRAM_FG2P/$400),(VDP_control_port).l	; Set Plane A Nametable to Second Player screen
		locVSRAM	0
		move.l	($FFFFEEF0).w,(VDP_data_port).l	; Copy of Player 2's Camera offset by 320
		lea	(VDP_control_port).l,a5
		move.l	#$94019340,(a5)	; Length : 320
		move.l	#$96EE9580,(a5) ; $FFDD00 Source (Sprite_Table_2P)
		move.w	#$977F,(a5)	; DMA Copy
		move.w	#$7800,(a5)	; 
		move.w	#$83,(DMA_data_thunk).w
		move.w	(DMA_data_thunk).w,(a5)	; $F800 (VRAM_Sprites)

loc_1166:
		move.w	(VDP_control_port).l,d0
		andi.w	#4,d0
		beq.s	loc_1166
		move.w	(VDP_Reg1_val).w,d0
		ori.b	#$40,d0
		move.w	d0,(VDP_control_port).l	; Turn on Display
		move.l	(sp)+,d0
		movea.l	(sp)+,a5

locret_1184:
		rte

; ---------------------------------------------------------------------------
; loc_1188:
PalToCRAM:
		disable_ints
		move.w	#0,(Hint_flag).w
		movem.l	a0-a1,-(sp)
		lea	(VDP_data_port).l,a1
		lea	(Water_palette).w,a0	; load palette from RAM
		move.l	#$C0000000,4(a1)	; set VDP to write to CRAM address $00
	rept 32
		move.l	(a0)+,(a1)		; move palette to CRAM (all 64 colors at once)
	endr
		move.w	#$8A00+223,4(a1)	; write %1101 %1111 to register 10 (interrupt every 224th line)
		movem.l	(sp)+,a0-a1
		tst.b	(Do_Updates_in_H_int).w
		bne.s	Hint_SoundDriver
		rte
; ===========================================================================
; loc_11F8:
Hint_SoundDriver:
		clr.b	(Do_Updates_in_H_int).w
		movem.l	d0-a6,-(sp)
		bsr.w	Do_Updates
		jsr	(sub_71B4C).l
		movem.l	(sp)+,d0-a6
		rte

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; game code
VDPSetupGame:
		lea	(VDP_control_port).l,a0
		lea	(VDP_data_port).l,a1
		lea	(VDPSetupArray).l,a2
		moveq	#19-1,d7

	@Loop:
		move.w	(a2)+,(a0)
		dbf	d7,@Loop
		move.w	(VDPSetupArray+2).l,d0
		btst	#6,($FFFFFFF8).w	; Check Pal
		beq.s	@NotPAL
		bset	#3,d0	; PAL extra resolution, but let's not account for it elsewhere~
	@NotPAL:
		move.w	d0,(VDP_Reg1_val).w
		move.w	#$8ADF,(Hint_counter_reserve).w
		moveq	#0,d0
		locVSRAM	0
		move.w	d0,(a1)
		move.w	d0,(a1)
		locCRAM	0
		moveq	#$40-1,d7
VDP_ClrCRAM:
		move.w	d0,(a1)
		dbf	d7,VDP_ClrCRAM
		move.l	d1,-(sp)
		fillVRAM	0,$FFFF,0
		move.l	d0,(Vscroll_Factor).w
		move.l	d0,(HScroll_Factor).w
VDP_WaitDMA:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	VDP_WaitDMA

		move.w	#$8F02,(a5)		; set VDP increment size back to 2
		move.l	(sp)+,d1
		rts
; End of function VDPSetupGame

; ===========================================================================
VDPSetupArray:	dc.w $8004			; 8-colour mode
		dc.w $8134			; enable V.interrupts, enable DMA
		dc.w $8200+(VRAM_FG>>10)	; set foreground nametable address
		dc.w $8300+(VRAM_FG2P>>10)	; set window nametable address
		dc.w $8400+(VRAM_BG>>13)	; set background nametable address
		dc.w $8500+(VRAM_Sprites>>9)	; set sprite table address
		dc.w $8600			; unused
		dc.w $8700			; set background colour (palette entry 0)
		dc.w $8800			; unused
		dc.w $8900			; unused
		dc.w $8A00			; default H.interrupt register
		dc.w $8B00			; full-screen vertical scrolling
		dc.w $8C81			; 40-cell display mode
		dc.w $8D00+(vram_HScroll>>10)	; set background hscroll address
		dc.w $8E00			; unused
		dc.w $8F02			; set VDP increment size
		dc.w $9001			; 64-cell hscroll size
		dc.w $9100			; window horizontal position
		dc.w $9200			; window vertical position
; ===========================================================================
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


ClearScreen:
		fillVRAM	0,($1000-1),vram_fg ; clear foreground namespace
	@DMAWait1:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	@DMAWait1

		fillVRAM	0,($1000-1),vram_bg ; clear background namespace
	@DMAWait2:	
		move.w	(a5),d1
		btst	#1,d1
		bne.s	@DMAWait2

		move.w	#$8F02,(a5)

		moveq	#0,d0
		move.l	d0,(Vscroll_Factor).w
		move.l	d0,(HScroll_Factor).w

		lea	(Sprite_Table).w,a1
		move.w	#$280/4-1,d1
	@ClearBuffer1:
		move.l	d0,(a1)+
		dbf	d1,@ClearBuffer1

		lea	(Horiz_Scroll_Buf).w,a1
		move.w	#$400/4-1,d1
	@ClearBuffer2:
		move.l	d0,(a1)+
		dbf	d1,@ClearBuffer2
		rts
; End of function ClearScreen

; ===========================================================================

		include	"Sound/PlaySound.asm"
		include	"Routines/Pause Game.asm"
		include "Routines/PlaneMAP to VRAM.asm"
		include "Routines/DMA Queue.asm"

		include "Routines/Decompress Nemesis.asm"

		include "Routines/PLC Queue.asm"

		include "Routines/Decompress Enigma.asm"
		include "Routines/Decompress Kosinski.asm"
		include "Routines/Decompress Chameleon.asm"

; ===========================================================================
; Convert 1-bit / NES Art to be Mega Drive compatible
;
; input :
; d0 : Art Size (divide by 8 for NES) -1
; d1 : Colour 1 
; d2 : Colour 0 (keep left nibble clear)
; a0 : 1-bit Art
; a1 : Output RAM
; 
; output :
; a2, a3
; d3, d4, d5, d6, d7 : trash
; ---------------------------------------------------------------------------
DecNESArt:
	@loopTile:
	move.l	a1,a2
	moveq	#8-1,d7
	bsr	Dec1BitArtLoopByte
	move.l	a1,a3
	moveq	#8-1,d7
	bsr	Dec1BitArtLoopByte
	swap	d1
	swap	d2
	move.l	a2,a1
		moveq	#16-1,d7
		@loopConvert:
			move.w	(a2)+,d5
			move.w	(a3)+,d6
			and.w	d2,d5
			and.w	d1,d6
			or.w	d5,d6
			move.w	d6,(a1)+
		dbf	d7,@loopConvert
	swap	d1
	swap	d2
	dbf	d0,@loopTile
	rts
Dec1BitArt:
	move.w	d0,d7
Dec1BitArtLoopByte:
	move.b	(a0)+,d3	; Current 1-bit colour Byte of data (8 pixels)
	moveq	#8-1,d4		; loop
		@LoopRow:
			btst	d4,d3	; check bit
			sne	d5	; set or clear depending on state
			subq.b	#1,d4	; next bit
			btst	d4,d3	; 
			sne	d6	; same as above
			and.b	d2,d5	; 
			and.b	d2,d6	;
			lsl.b	#4,d5	;
			add.b	d5,d6	;
			or.b	d1,d6	;
			move.b	d6,(a1)+	; store result in RAM
		dbf	d4,@LoopRow
	dbf	d7,Dec1BitArtLoopByte
	rts	
; ===========================================================================«
		include "Level/Level Palette Cycle.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to fade in from black
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Pal_FadeTo:
Pal_FadeFromBlack:
		move.w	#(32*2)-1,($FFFFF626).w
; Pal_FadeTo2:
Pal_FadeFromBlack2:
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		move.b	($FFFFF626).w,d0
		adda.w	d0,a0
		moveq	#0,d1
		move.b	($FFFFF627).w,d0
loc_2162:
		move.w	d1,(a0)+
		dbf	d0,loc_2162		; fill palette with $000 (black)
		move.w	#$16-1,d4

loc_216C:
		move.b	#VintID_Fade,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.s	Pal_FadeIn
		bsr.w	RunPLC_RAM
		dbf	d4,loc_216C
		rts
; End of function Pal_FadeFromBlack

; ---------------------------------------------------------------------------
; Subroutine to update all colours once
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Pal_FadeIn:
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		lea	(Target_palette).w,a1
		move.b	($FFFFF626).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	($FFFFF627).w,d0

loc_2198:
		bsr.s	Pal_AddColor
		dbf	d0,loc_2198
		tst.b	(Water_flag).w
		beq.s	locret_21C0
		moveq	#0,d0
		lea	(Water_palette).w,a0
		lea	(Water_target_palette).w,a1
		move.b	($FFFFF626).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	($FFFFF627).w,d0

loc_21BA:
		bsr.s	Pal_AddColor
		dbf	d0,loc_21BA

locret_21C0:
		rts
; End of function Pal_FadeIn

; ---------------------------------------------------------------------------
; Subroutine to update a single colour once
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Pal_AddColor:
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3
		beq.s	Pal_AddNone
		move.w	d3,d1
		addi.w	#$200,d1
		cmp.w	d2,d1
		bhi.s	Pal_AddGreen
		move.w	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

Pal_AddGreen:
		move.w	d3,d1
		addi.w	#$20,d1
		cmp.w	d2,d1
		bhi.s	Pal_AddRed
		move.w	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

Pal_AddRed:
		addq.w	#2,(a0)+
		rts
; ---------------------------------------------------------------------------
; Pal_NoAdd:
Pal_AddNone:
		addq.w	#2,a0
		rts
; End of function Pal_AddColor


; ---------------------------------------------------------------------------
; Subroutine to fade out to black
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Pal_FadeFrom:
Pal_FadeToBlack:
		move.w	#$3F,($FFFFF626).w
		move.w	#$15,d4

loc_21F8:
		move.b	#VintID_Fade,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.s	Pal_FadeOut
		bsr.w	RunPLC_RAM
		dbf	d4,loc_21F8
		rts
; End of function Pal_FadeFrom

; ---------------------------------------------------------------------------
; Subroutine to update all colours once
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Pal_FadeOut:
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		move.b	($FFFFF626).w,d0
		adda.w	d0,a0
		move.b	($FFFFF627).w,d0

loc_221E:
		bsr.s	Pal_DecColor
		dbf	d0,loc_221E
		moveq	#0,d0
		lea	(Water_palette).w,a0
		move.b	($FFFFF626).w,d0
		adda.w	d0,a0
		move.b	($FFFFF627).w,d0

loc_2234:
		bsr.s	Pal_DecColor
		dbf	d0,loc_2234
		rts
; End of function Pal_FadeOut


; ---------------------------------------------------------------------------
; Subroutine to update a single colour once
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Pal_DecColor:
		move.w	(a0),d2
		beq.s	Pal_NoDec
		move.w	d2,d1
		andi.w	#$E,d1
		beq.s	Pal_DecGreen
		subq.w	#2,(a0)+
		rts
; ---------------------------------------------------------------------------

Pal_DecGreen:
		move.w	d2,d1
		andi.w	#$E0,d1
		beq.s	Pal_DecBlue
		subi.w	#$20,(a0)+
		rts
; ---------------------------------------------------------------------------

Pal_DecBlue:
		move.w	d2,d1
		andi.w	#$E00,d1
		beq.s	Pal_NoDec
		subi.w	#$200,(a0)+
		rts
; ---------------------------------------------------------------------------

Pal_NoDec:
		addq.w	#2,a0
		rts
; End of function Pal_DecColor


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Pal_MakeWhite:				; CODE XREF: ROM:00005166p
		move.w	#$3F,($FFFFF626).w ; '?'
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		move.b	($FFFFF626).w,d0
		adda.w	d0,a0
		move.w	#$EEE,d1
		move.b	($FFFFF627).w,d0

loc_2286:				; CODE XREF: Pal_MakeWhite+1Cj
		move.w	d1,(a0)+
		dbf	d0,loc_2286
		move.w	#$15,d4

loc_2290:				; CODE XREF: Pal_MakeWhite+34j
		move.b	#VintID_Fade,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.s	Pal_WhiteToBlack
		bsr.w	RunPLC_RAM
		dbf	d4,loc_2290
		rts
; End of function Pal_MakeWhite


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Pal_WhiteToBlack:			; CODE XREF: Pal_MakeWhite+2Ep
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		lea	(Target_palette).w,a1
		move.b	($FFFFF626).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	($FFFFF627).w,d0

loc_22BC:				; CODE XREF: Pal_WhiteToBlack+18j
		bsr.s	Pal_DecColor2
		dbf	d0,loc_22BC
		tst.b	(Water_flag).w
		beq.s	locret_22E4
		moveq	#0,d0
		lea	(Water_palette).w,a0
		lea	(Water_target_palette).w,a1
		move.b	($FFFFF626).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	($FFFFF627).w,d0

loc_22DE:				; CODE XREF: Pal_WhiteToBlack+3Aj
		bsr.s	Pal_DecColor2
		dbf	d0,loc_22DE

locret_22E4:				; CODE XREF: Pal_WhiteToBlack+20j
		rts
; End of function Pal_WhiteToBlack


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Pal_DecColor2:				; CODE XREF: Pal_WhiteToBlack:loc_22BCp
					; Pal_WhiteToBlack:loc_22DEp
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3
		beq.s	loc_2312
		move.w	d3,d1
		subi.w	#$200,d1
		bcs.s	loc_22FE
		cmp.w	d2,d1
		bcs.s	loc_22FE
		move.w	d1,(a0)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_22FE:				; CODE XREF: Pal_DecColor2+Ej
					; Pal_DecColor2+12j
		move.w	d3,d1
		subi.w	#$20,d1	; ' '
		bcs.s	loc_230E
		cmp.w	d2,d1
		bcs.s	loc_230E
		move.w	d1,(a0)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_230E:				; CODE XREF: Pal_DecColor2+1Ej
					; Pal_DecColor2+22j
		subq.w	#2,(a0)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_2312:				; CODE XREF: Pal_DecColor2+6j
		addq.w	#2,a0
		rts
; End of function Pal_DecColor2


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Pal_MakeFlash:				; CODE XREF: ROM:00005024p
					; ROM:000052CEp
		move.w	#$3F,($FFFFF626).w ; '?'
		move.w	#$15,d4

loc_2320:				; CODE XREF: Pal_MakeFlash+1Aj
		move.b	#VintID_Fade,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.s	Pal_ToWhite
		bsr.w	RunPLC_RAM
		dbf	d4,loc_2320
		rts
; End of function Pal_MakeFlash


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Pal_ToWhite:				; CODE XREF: Pal_MakeFlash+14p
					; ROM:00005210p
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		move.b	($FFFFF626).w,d0
		adda.w	d0,a0
		move.b	($FFFFF627).w,d0

loc_2346:				; CODE XREF: Pal_ToWhite+12j
		bsr.s	Pal_AddColor2
		dbf	d0,loc_2346
		moveq	#0,d0

loc_234E:
		lea	(Water_palette).w,a0
		move.b	($FFFFF626).w,d0
		adda.w	d0,a0
		move.b	($FFFFF627).w,d0

loc_235C:				; CODE XREF: Pal_ToWhite+28j
		bsr.s	Pal_AddColor2
		dbf	d0,loc_235C
		rts
; End of function Pal_ToWhite


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Pal_AddColor2:				; CODE XREF: Pal_ToWhite:loc_2346p
					; Pal_ToWhite:loc_235Cp
		move.w	(a0),d2
		cmpi.w	#$EEE,d2
		beq.s	loc_23A0
		move.w	d2,d1
		andi.w	#$E,d1
		cmpi.w	#$E,d1
		beq.s	loc_237C
		addq.w	#2,(a0)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_237C:				; CODE XREF: Pal_AddColor2+12j
		move.w	d2,d1
		andi.w	#$E0,d1	; 'à'
		cmpi.w	#$E0,d1	; 'à'
		beq.s	loc_238E

loc_2388:
		addi.w	#$20,(a0)+ ; ' '
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_238E:				; CODE XREF: Pal_AddColor2+22j
		move.w	d2,d1
		andi.w	#$E00,d1
		cmpi.w	#$E00,d1
		beq.s	loc_23A0
		addi.w	#$200,(a0)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_23A0:				; CODE XREF: Pal_AddColor2+6j
					; Pal_AddColor2+34j
		addq.w	#2,a0
		rts
; End of function Pal_AddColor2


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


PalCycle_Sega:				; CODE XREF: ROM:000031A0p
		tst.b	($FFFFF635).w
		bne.s	loc_2404
		lea	($FFFFFB20).w,a1
		lea	(Pal_Sega1).l,a0
		moveq	#5,d1
		move.w	(PalCycle_Frame).w,d0

loc_23BA:				; CODE XREF: PalCycle_Sega+1Ej
		bpl.s	loc_23C4
		addq.w	#2,a0
		subq.w	#1,d1
		addq.w	#2,d0
		bra.s	loc_23BA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_23C4:				; CODE XREF: PalCycle_Sega:loc_23BAj
					; PalCycle_Sega+36j
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_23CE
		addq.w	#2,d0

loc_23CE:				; CODE XREF: PalCycle_Sega+26j
		cmpi.w	#$60,d0	; '`'
		bcc.s	loc_23D8
		move.w	(a0)+,(a1,d0.w)

loc_23D8:				; CODE XREF: PalCycle_Sega+2Ej
		addq.w	#2,d0
		dbf	d1,loc_23C4
		move.w	(PalCycle_Frame).w,d0
		addq.w	#2,d0
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_23EE
		addq.w	#2,d0

loc_23EE:				; CODE XREF: PalCycle_Sega+46j
		cmpi.w	#$64,d0	; 'd'
		blt.s	loc_23FC
		move.w	#$401,(PalCycle_Timer).w
		moveq	#$FFFFFFF4,d0

loc_23FC:				; CODE XREF: PalCycle_Sega+4Ej
		move.w	d0,(PalCycle_Frame).w
		moveq	#1,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_2404:				; CODE XREF: PalCycle_Sega+4j
		subq.b	#1,(PalCycle_Timer).w
		bpl.s	loc_2456
		move.b	#4,(PalCycle_Timer).w
		move.w	(PalCycle_Frame).w,d0
		addi.w	#$C,d0
		cmpi.w	#$30,d0	; '0'
		bcs.s	loc_2422
		moveq	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_2422:				; CODE XREF: PalCycle_Sega+78j
		move.w	d0,(PalCycle_Frame).w
		lea	(Pal_Sega2).l,a0
		lea	(a0,d0.w),a0
		lea	($FFFFFB04).w,a1
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)
		lea	($FFFFFB20).w,a1
		moveq	#0,d0
		moveq	#$2C,d1	; ','

loc_2442:				; CODE XREF: PalCycle_Sega+AEj
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_244C
		addq.w	#2,d0

loc_244C:				; CODE XREF: PalCycle_Sega+A4j
		move.w	(a0),(a1,d0.w)
		addq.w	#2,d0
		dbf	d1,loc_2442

loc_2456:				; CODE XREF: PalCycle_Sega+64j
		moveq	#1,d0
		rts
; End of function PalCycle_Sega

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Pal_Sega1:	dc.w  $EEE, $EEA, $EE4,	$EC0, $EE4, $EEA; 0 ; DATA XREF: PalCycle_Sega
Pal_Sega2:	dc.w  $EEC, $EEA, $EEA,	$EEA, $EEA, $EEA, $EEC,	$EEA, $EE4, $EC0, $EC0,	$EC0, $EEC, $EEA, $EE4,	$EC0
		dc.w  $EA0, $E60, $EEA,	$EE4, $EC0, $EA0, $E80,	$E00
; ===========================================================================
PalLoadFade:	; Load Palette for fading
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2
		movea.w	(a1)+,a3
		suba.w	#$100,a3
		move.w	(a1)+,d7
	@Loop:
		move.l	(a2)+,(a3)+
		dbf	d7,@Loop
		rts
; ---------------------------------------------------------------------------
PalLoadNormal:	; Load Palette
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2
		movea.w	(a1)+,a3
		move.w	(a1)+,d7
	@Loop:
		move.l	(a2)+,(a3)+
		dbf	d7,@Loop
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Palette pointers
; (PALETTE DESCRIPTOR ARRAY)
; This struct array defines the palette to use for each level.
; ---------------------------------------------------------------------------
c	=	0
palptr	macro	ptr,ram,size
	dc.l @\ptr	; Pointer to palette
	dc.w ram	; Location in ram to load palette into
	dc.w (size/2)-1	; Size of palette in (bytes / 4)
PalID_\ptr	equ	c
c	=	c+1
	endm

PalPointers:
	palptr SegaBG,		Normal_palette&$FFFF,64
	palptr Title,		Normal_palette&$FFFF,64
	palptr LevelSelect,	Normal_palette&$FFFF,64
	palptr Main,		Normal_palette&$FFFF,16
	palptr Special,		Normal_palette&$FFFF,64
	palptr SpeResults,	Normal_palette&$FFFF,64
; ---------------------------------------------------------------------------
	@SegaBG:	incbin	"Logo/Sega screen background.pal"
	@Title:		incbin	"Title/Title.pal"
	@LevelSelect:	incbin	"Title/Level Select.pal"
	@Main:		incbin	"Level/Main.pal"
	@Special:	incbin	"SpecialStage/Special Stage.pal"
	@SpeResults:	incbin	"SpecialStage/Special Stage results.pal"
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to perform vertical synchronization
; ---------------------------------------------------------------------------
; DelayProgram:
WaitForVint:
		enable_ints
		LagOff
	@Loop:
		tst.b	(Vint_routine).w ; infinite loop till this is zero
		bne.s	@Loop
		rts
; End of function WaitForVint
; ---------------------------------------------------------------------------
	include	"Maths\CalcSine.asm"
	include	"Maths\CalcSqrt.asm"
	include	"Maths\CalcAngle.asm"
	include	"Maths\RandomNumber.asm"
; ---------------------------------------------------------------------------
GameModesStart:
; ---------------------------------------------------------------------------
; Sega logo, exact same as Sonic 1's
; ---------------------------------------------------------------------------
Logo:
SegaScreen:
		move.b	#$E4,d0
		bsr.w	PlaySound_Special
		bsr.w	ClearPLC
		bsr.w	Pal_FadeToBlack
		lea	(VDP_control_port).l,a6
		move.w	#$8004,(a6)
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$8700,(a6)
		move.w	#$8B00,(a6)
		move.w	#$8C81,(a6)
		clr.b	(Water_fullscreen_flag).w
		move	#$2700,sr
		move.w	(VDP_Reg1_val).w,d0
		andi.b	#$BF,d0
		move.w	d0,(VDP_control_port).l	; Turn off Display
		bsr.w	ClearScreen
		move.l	#$40000000,(VDP_control_port).l
		lea	(ArtNem_SegaLogo).l,a0
		bsr.w	NemDec
		lea	(RAM_Start).l,a1
		lea	(Eni_SegaLogo).l,a0
		move.w	#0,d0
		bsr.w	EniDec
		lea	(RAM_Start).l,a1
		move.l	#$65100003,d0
		moveq	#$17,d1
		moveq	#7,d2
		bsr.w	PlaneMapToVRAM_H40
		lea	($FFFF0180).l,a1
		move.l	#$40000003,d0
		moveq	#$27,d1
		moveq	#$1B,d2
		bsr.w	PlaneMapToVRAM_H40
		tst.b	($FFFFFFF8).w	; is console Japanese?
		bmi.s	loc_316A	; if not, branch
		; hide 'TM' symbol
		lea	($FFFF0A40).l,a1
		move.l	#$453A0003,d0
		moveq	#2,d1
		moveq	#1,d2
		bsr.w	PlaneMapToVRAM_H40

loc_316A:
		moveq	#0,d0
		bsr.w	PalLoadNormal
		move.w	#-$A,(PalCycle_Frame).w
		move.w	#0,(PalCycle_Timer).w
		move.w	#0,($FFFFF662).w
		move.w	#0,($FFFFF660).w
		move.w	(VDP_Reg1_val).w,d0
		ori.b	#$40,d0
		move.w	d0,(VDP_control_port).l	; Turn on Display

Sega_WaitPalette:
		move.b	#VintID_SEGA,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.w	PalCycle_Sega
		bne.s	Sega_WaitPalette

		move.b	#$E1,d0
		bsr.w	PlaySound_Special
		move.b	#VintID_PCM,(Vint_routine).w
		bsr.w	WaitForVint
		move.w	#$1E,(Demo_Time_left).w

Sega_WaitEnd:
		move.b	#VintID_SEGA,(Vint_routine).w
		bsr.w	WaitForVint
		tst.w	(Demo_Time_left).w
		beq.s	Sega_GoToTitleScreen
		andi.b	#$80,(Ctrl_1_Press).w
		beq.s	Sega_WaitEnd

Sega_GoToTitleScreen:
		move.b	#GameModeID_TitleScreen,(Game_Mode).w
		rts
; ===========================================================================

TitleScreen:	
		move.b	#$E4,d0
		bsr.w	PlaySound_Special
		bsr.w	ClearPLC
		bsr.w	Pal_FadeToBlack
		move	#$2700,sr
		lea	(VDP_control_port).l,a6
		move.l	#$80048230,(a6)
		move.l	#$84079001,(a6)
		move.l	#$92008B03,(a6)
		move.l	#$87208C81,(a6)
		clr.b	(Water_fullscreen_flag).w

		bsr.w	ClearScreen

		lea	(Sprite_Input_Table).w,a1
		moveq	#0,d0
		move.w	#(Sprite_Input_Table_End-Sprite_Input_Table)/4-1,d1
	@ClearSpriteTable:	
		move.l	d0,(a1)+
		dbf	d1,@ClearSpriteTable

		lea	(Object_Space).w,a1
		move.w	#(Object_Space_End-Object_Space)/4-1,d1
	@ClearObjectRAM:		
		move.l	d0,(a1)+
		dbf	d1,@ClearObjectRAM

		lea	(unk_F700).w,a1
		move.w	#$100/4-1,d1
	@ClearRAM2:		
		move.l	d0,(a1)+
		dbf	d1,@ClearRAM2

		lea	(Camera_RAM).w,a1
		move.w	#$100/4-1,d1
	@ClearCamRAM:			
		move.l	d0,(a1)+
		dbf	d1,@ClearCamRAM

;		lea	(Target_palette).w,a1	; useless
;		move.w	#(Target_palette_End-Target_palette)/4-1,d1
;	@ClearFadePalette:			
;		move.l	d0,(a1)+
;		dbf	d1,@ClearFadePalette


		moveq	#3,d0
		bsr.w	PalLoadFade
		bsr.w	Pal_FadeFromBlack
		disable_ints

		locVRAM		0
		lea		(ArtNem_Title).l,a0
		bsr.w		NemDec

		locVRAM		$4000
		lea		(ArtNem_TitleSonicTails).l,a0
		bsr.w		NemDec

; --- Loading Level Select Art
VRAMLevSelTextArt	=	$A000
ArtSize_LevelSelect	=	(UncSize_art_LevSel1+UncSize_art_LevSelNums+UncSize_art_LevSel2+UncSize_art_LevSelLetters+UncSize_art_LevSel3)

		lea	Art1Bit_LevSel1,a0
		lea	$FFFF0000,a1
		move.w	#Size_Art1Bit_LevSel1-1,d0	; Size
		move.l	#$FFFF000F,d2	; Colour for 0
		move.l	#$DDDD00EE,d1	; Colour for 1
		bsr	Dec1BitArt

		lea	ArtNES_LevSelNums,a0
		move.w	#Size_ArtNES_LevSelNums/16-1,d0
		bsr	DecNESArt

		lea	Art1Bit_LevSel2,a0
		move.w	#Size_Art1Bit_LevSel2-1,d0	; Size
		bsr	Dec1BitArt

		lea	ArtNES_LevSelLetters,a0
		move.w	#(Size_ArtNES_LevSelLetters-12*16)/16-1,d0
		bsr	DecNESArt

		lea	Art1Bit_LevSel3,a0
		move.w	#Size_Art1Bit_LevSel3-1,d0	; Size
		bsr	Dec1BitArt

		lea		(VDP_data_port).l,a6
		locVRAMtemp	VRAMLevSelTextArt,_VDPcommand
		move.l	#_VDPcommand,4(a6)
		lea	$FFFF0000,a5	; start of RAM
		move.w	#(ArtSize_LevelSelect/4)-1,d1
	@LoadLevelSelectText:	
		move.l	(a5)+,(a6)
		dbf	d1,@LoadLevelSelectText

; --- Loading Hitbox Viewer Art
		locVRAMtemp	$FF80,_VDPcommand
		move.l	#_VDPcommand,4(a6)
		lea	(ArtUnc_HitboxViewer).l,a5
		move.w	#(ArtSize_HitboxViewer/4)-1,d1
	@LoadHitboxViewer:			
		move.l	(a5)+,(a6)
		dbf	d1,@LoadHitboxViewer



		move.b	#0,(Last_LampPost_hit).w
		move.w	#0,(Debug_placement_mode).w
		move.w	#0,(Demo_Mode_Flag).w
		move.w	#0,($FFFFFFEA).w
		move.w	#0,(Current_ZoneAndAct).w
		move.w	#0,(PalCycle_Timer).w
		bsr.w	Pal_FadeToBlack

		disable_ints
		lea	(RAM_Start).l,a1
		lea	(Eni_TitleMap).l,a0
		move.w	#0,d0
		bsr.w	EniDec
	copyTilemap_H40	RAM_Start,VRAM_FG,40,28

		lea	(RAM_Start).l,a1
		lea	(Eni_TitleBg1).l,a0
		move.w	#0,d0
		bsr.w	EniDec
	copyTilemap_H40	RAM_Start,VRAM_BG,32,28


		lea	(RAM_Start).l,a1
		lea	(Eni_TitleBg2).l,a0
		move.w	#0,d0
		bsr.w	EniDec
	copyTilemap_H40	RAM_Start,(VRAM_BG+64),32,28
		

		moveq	#1,d0
		bsr.w	PalLoadFade
		move.b	#MusID_Title,d0
		bsr.w	PlaySound_Special
		move.b	#0,(Debug_mode_flag).w
		move.w	#0,(Two_player_mode).w
		move.w	#$178,(Demo_Time_left).w

		lea	(Object_Space+$80).w,a1
		moveq	#0,d0
		move.w	#Object_RAM/4-1,d1
loc_339A:	
		move.l	d0,(a1)+
		dbf	d1,loc_339A

		move.b	#ObjID_TitleObject,(Object_Space+$40).w
		move.b	#ObjID_TitleObject,(Object_Space+$80).w
		move.b	#1,(Object_Space+$80+mapping_frame).w
		jsr	(RunObjects).l
		jsr	(BuildSprites).l
		moveq	#PLCID_Main,d0
		bsr.w	LoadPLC2
		move.w	#0,($FFFFFFE4).w
		move.w	#0,($FFFFFFE6).w
		move.w	#$300,(Current_ZoneAndAct).w
		move.w	#4,(Sonic_Pos_Record_Index).w
		move.w	#0,(Sonic_Pos_Record_Buf).w
		move.w	(VDP_Reg1_val).w,d0
		ori.b	#$40,d0	; '@'
		move.w	d0,(VDP_control_port).l	; Turn on Display
		bsr.w	Pal_FadeFromBlack

TitleScreen_Loop:			; CODE XREF: ROM:0000349Aj
		move.b	#VintID_Title,(Vint_routine).w
	if	(Devmode)
		move.l	#-1,(Cheat_Flags).w ; screw you, enables your debug
	endif
		bsr.w	WaitForVint
		jsr	(RunObjects).l
		bsr.w	Deform_TitleScreen
		jsr	(BuildSprites).l
		bsr.w	RunPLC_RAM
		tst.b	($FFFFFFF8).w
		bpl.s	Title_RegionJ
		lea	(LvlSelCode_US).l,a0
		bra.s	LevelSelectCheat
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Title_RegionJ:				; CODE XREF: ROM:00003416j
		lea	(LvlSelCode_J).l,a0

LevelSelectCheat:			; CODE XREF: ROM:0000341Ej
		move.w	($FFFFFFE4).w,d0
		adda.w	d0,a0
		move.b	(Ctrl_1_Press).w,d0
		andi.b	#$F,d0
		cmp.b	(a0),d0
		bne.s	Title_Cheat_NoMatch
		addq.w	#1,($FFFFFFE4).w
		tst.b	d0
		bne.s	Title_Cheat_CountC
		lea	(Cheat_Flags).w,a0
		move.w	($FFFFFFE6).w,d1
		lsr.w	#1,d1
		andi.w	#3,d1
		beq.s	Title_Cheat_PlayRing
		tst.b	($FFFFFFF8).w
		bpl.s	Title_Cheat_PlayRing
		moveq	#1,d1
		move.b	d1,1(a0,d1.w)

Title_Cheat_PlayRing:			; CODE XREF: ROM:0000344Ej
					; ROM:00003454j
		move.b	#1,(a0,d1.w)
		move.b	#$B5,d0
		bsr.w	PlaySound_Special
		bra.s	Title_Cheat_CountC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Title_Cheat_NoMatch:			; CODE XREF: ROM:00003436j
		tst.b	d0
		beq.s	Title_Cheat_CountC
		cmpi.w	#9,($FFFFFFE4).w
		beq.s	Title_Cheat_CountC
		move.w	#0,($FFFFFFE4).w

Title_Cheat_CountC:			; CODE XREF: ROM:0000343Ej
					; ROM:0000346Aj ...
		move.b	(Ctrl_1_Press).w,d0
		andi.b	#$20,d0	; ' '
		beq.s	Title_Cheat_NoC
		addq.w	#1,($FFFFFFE6).w

Title_Cheat_NoC:			; CODE XREF: ROM:00003486j
		tst.w	(Demo_Time_left).w
		beq.w	Demo
		andi.b	#$80,(Ctrl_1_Press).w
		beq.w	TitleScreen_Loop

Title_CheckLvlSel:			; CODE XREF: ROM:0000365Cj
		tst.b	(Level_select_flag).w
		beq.w	PlayLevel
		moveq	#2,d0
		bsr.w	PalLoadNormal
		lea	(Horiz_Scroll_Buf).w,a1
		moveq	#0,d0
		move.w	#$DF,d1

LevelSelect_ClearScroll:		; CODE XREF: ROM:000034B8j
		move.l	d0,(a1)+
		dbf	d1,LevelSelect_ClearScroll
		move.l	d0,(Vscroll_Factor).w
		move	#$2700,sr
		lea	(VDP_data_port).l,a6
		move.l	#$60000003,(VDP_control_port).l
		move.w	#$3FF,d1

LevelSelect_ClearVRAM:			; CODE XREF: ROM:000034DAj
		move.l	d0,(a6)
		dbf	d1,LevelSelect_ClearVRAM
		bsr.w	LevelSelect_TextLoad

; ===========================================================================
; ---------------------------------------------------------------------------
; Level Select
; ---------------------------------------------------------------------------

LevelSelect_Loop:
		move.b	#VintID_Title,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.w	LevelSelect_Controls
		bsr.w	RunPLC_RAM
		tst.l	(Plc_Buffer).w
		bne.s	LevelSelect_Loop
		andi.b	#$F0,(Ctrl_1_Press).w		; is A, B, C, or Start being pressed?
		beq.s	LevelSelect_Loop		; if not, branch
		move.w	#0,(Two_player_mode).w
		btst	#4,($FFFFF604).w		; is B being held?
		beq.s	.singlePlayer			; if not, branch
		move.w	#1,(Two_player_mode).w
; loc_3516:
.singlePlayer:
		move.w	($FFFFFF82).w,d0
		cmpi.w	#LevelSelectMax-1,d0			; have you selected sound test?
		bne.s	LevelSelect_StartGame		; if not, go to	Level/SS subroutine
		move.w	($FFFFFF84).w,d0
		addi.w	#$80,d0
		tst.b	(S1_hidden_credits_flag).w	; is the Japanese credits cheat on?
		beq.s	LevelSelect_NoCheats		; if not, branch
		cmpi.w	#$9F,d0				; is sound $9F being played?
		beq.s	LevelSelect_PlayEnding		; if yes, branch
		cmpi.w	#$9E,d0				; is sound $9E being played?
		beq.s	LevelSelect_PlayCredits		; if yes, branch
; loc_353A:
LevelSelect_NoCheats:
		cmpi.w	#$94,d0
		bcs.s	LevelSelect_PlaySound
		cmpi.w	#$A0,d0
		bcs.s	LevelSelect_Loop
; loc_3546:
LevelSelect_PlaySound:
		bsr.w	PlaySound_Special
		bra.s	LevelSelect_Loop
; ===========================================================================
; loc_354C:
LevelSelect_PlayEnding:
		move.b	#GameModeID_Logo,(Game_Mode).w
		move.w	#$600,(Current_ZoneAndAct).w
		rts
; ===========================================================================
; loc_355A:
LevelSelect_PlayCredits:
		move.b	#GameModeID_Logo,(Game_Mode).w
		move.b	#$91,d0
		bsr.w	PlaySound_Special
		move.w	#0,($FFFFFFF4).w
		rts
; ===========================================================================
; loc_3570:
LevelSelect_StartGame:
		add.w	d0,d0
		move.w	LevelSelect_LevelOrder(pc,d0.w),d0
		bmi.w	LevelSelect_Loop
		cmpi.w	#$0800,d0		; is level $0800 loaded?
		bne.s	LevelSelect_StartZone	; if not, branch

; LevelSelect_SpecialStage:
		move.b	#GameModeID_SpecialStage,(Game_Mode).w
		clr.w	(Current_ZoneAndAct).w
		move.b	#3,(Life_count).w
		moveq	#0,d0
		move.w	d0,(Ring_count).w
		move.l	d0,(Timer).w
		move.l	d0,(Score).w
		move.l	#5000,(Next_Extra_life_score).w
		rts
; ===========================================================================

LevelSelect_LevelOrder:
		dc.b	ZoneID_GHZ,00
		dc.b	ZoneID_GHZ,01
		dc.b	ZoneID_GHZ,02
		dc.b	ZoneID_GHZ,03

		dc.b	ZoneID_CPZ,00
		dc.b	ZoneID_CPZ,01
		dc.b	ZoneID_CPZ,02
		dc.b	ZoneID_CPZ,03

		dc.b	ZoneID_MMZ,00
		dc.b	ZoneID_MMZ,01
		dc.b	ZoneID_MMZ,02
		dc.b	ZoneID_MMZ,03

		dc.b	ZoneID_EHZ,00
		dc.b	ZoneID_EHZ,01
		dc.b	ZoneID_EHZ,02
		dc.b	ZoneID_EHZ,03

		dc.b	ZoneID_HPZ,00
		dc.b	ZoneID_HPZ,01
		dc.b	ZoneID_HPZ,02
		dc.b	ZoneID_HPZ,03

		dc.b	ZoneID_HTZ,00
		dc.b	ZoneID_HTZ,01
		dc.b	ZoneID_HTZ,02
		dc.b	ZoneID_HTZ,03

		dc.b	ZoneID_CNZ,00
		dc.b	ZoneID_CNZ,01
		dc.b	ZoneID_CNZ,02
		dc.b	ZoneID_CNZ,03

		dc.b	08,00
		dc.b	$80,00
		even
; ===========================================================================
; LevelSelect_Level:
LevelSelect_StartZone:
		andi.w	#$3FFF,d0
		move.w	d0,(Current_ZoneAndAct).w

PlayLevel:
		move.b	#GameModeID_Level,(Game_Mode).w
		move.b	#3,(Life_count).w
		moveq	#0,d0
		move.w	d0,(Ring_count).w
		move.l	d0,(Timer).w
		move.l	d0,(Score).w
		move.b	d0,($FFFFFE16).w
		move.b	d0,($FFFFFE57).w
		move.l	d0,($FFFFFE58).w
		move.l	d0,($FFFFFE5C).w
		move.b	d0,($FFFFFE18).w
		move.l	#$1388,(Next_Extra_life_score).w
		move.b	#$E0,d0
		bsr.w	PlaySound_Special
		rts
; End of function LevelSelect

; ===========================================================================

LvlSelCode_J:	dc.b   1,  2,  2,  2,  2,  1,  0,$FF
		even
LvlSelCode_US:	dc.b   1,  2,  2,  2,  2,  1,  0,$FF
		even
; ===========================================================================

Demo:
		move.w	#$1E,(Demo_Time_left).w

loc_3630:
		move.b	#VintID_Title,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.w	RunPLC_RAM
		move.w	(MainCharacter+x_pos).w,d0
		addq.w	#2,d0
		move.w	d0,(MainCharacter+x_pos).w
		cmpi.w	#$1C00,d0
		bcs.s	RunDemo
		move.b	#GameModeID_Logo,(Game_Mode).w
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

RunDemo:				; CODE XREF: ROM:0000364Cj
		andi.b	#$80,(Ctrl_1_Press).w
		bne.w	Title_CheckLvlSel
		tst.w	(Demo_Time_left).w
		bne.w	loc_3630
		move.b	#$E0,d0
		bsr.w	PlaySound_Special
		move.w	($FFFFFFF2).w,d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	Demo_Levels(pc,d0.w),d0
		move.w	d0,(Current_ZoneAndAct).w
		addq.w	#1,($FFFFFFF2).w
		cmpi.w	#4,($FFFFFFF2).w
		bcs.s	loc_3694
		move.w	#0,($FFFFFFF2).w

loc_3694:				; CODE XREF: ROM:0000368Cj
		move.w	#1,(Demo_Mode_Flag).w
		move.b	#GameModeID_Demo,(Game_Mode).w
		cmpi.w	#$300,d0
		bne.s	loc_36AC
		move.w	#1,(Two_player_mode).w

loc_36AC:				; CODE XREF: ROM:000036A4j
		cmpi.w	#$600,d0
		bne.s	loc_36C0
		move.b	#GameModeID_SpecialStage,(Game_Mode).w
		clr.w	(Current_ZoneAndAct).w
		clr.b	($FFFFFE16).w

loc_36C0:				; CODE XREF: ROM:000036B0j
		move.b	#3,(Life_count).w
		moveq	#0,d0
		move.w	d0,(Ring_count).w
		move.l	d0,(Timer).w
		move.l	d0,(Score).w
		move.l	#$1388,(Next_Extra_life_score).w
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Demo_Levels:	dc.w  $200, $300	; 0
		dc.w  $400, $500	; 2
		dc.w  $500, $500	; 4
		dc.w  $500, $500	; 6
		dc.w  $400, $400	; 8
		dc.w  $400, $400	; 10

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


LevelSelect_Controls:
		move.b	(Ctrl_1_Press).w,d1
		andi.b	#3,d1
		bne.s	.holdButton
		subq.w	#1,($FFFFFF80).w
		bpl.s	LevelSelect_CheckLR
; loc_3706:
.holdButton:
		move.w	#$B,($FFFFFF80).w
		move.b	($FFFFF604).w,d1
		andi.b	#3,d1
		beq.s	LevelSelect_CheckLR
; .pressUp:
		move.w	($FFFFFF82).w,d0
		btst	#0,d1
		beq.s	.pressDown
		subq.w	#1,d0
		bcc.s	.pressDown
		moveq	#LevelSelectMax-1,d0
; loc_3726:
.pressDown:
		btst	#1,d1
		beq.s	.updateSelection
		addq.w	#1,d0
		cmpi.w	#LevelSelectMax,d0
		bcs.s	.updateSelection
		moveq	#0,d0
; loc_3736:
.updateSelection:
		move.w	d0,($FFFFFF82).w
		bsr.w	LevelSelect_TextLoad
		rts
; ===========================================================================
; loc_3740:
LevelSelect_CheckLR:
		cmpi.w	#LevelSelectMax-1,($FFFFFF82).w
		bne.s	locret_377A
		move.b	(Ctrl_1_Press).w,d1
		andi.b	#$C,d1
		beq.s	locret_377A
		move.w	($FFFFFF84).w,d0
		btst	#2,d1
		beq.s	loc_3762
		subq.w	#1,d0
		bcc.s	loc_3762
		moveq	#$4F,d0	; 'O'

loc_3762:
		btst	#3,d1
		beq.s	loc_3772
		addq.w	#1,d0
		cmpi.w	#$50,d0	; 'P'
		bcs.s	loc_3772
		moveq	#0,d0

loc_3772:
		move.w	d0,($FFFFFF84).w
		bsr.w	LevelSelect_TextLoad

locret_377A:
		rts
; End of function LevelSelect_Controls


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


LevelSelect_TextLoad:			; We'll replace this soon

		lea	(LevelSelectText).l,a1
		lea	(VDP_data_port).l,a6
		locVRAMtemp ($E000+(2*128)+(2*8)),_VDPcommand
		move.l	#_VDPcommand,d4
		move.w	#(VRAMLevSelTextArt/$20)+TMap_Priority,d3
		moveq	#LevelSelectMax-1,d1

	@LoadBaseTextColour:	
		move.l	d4,4(a6)
		bsr.w	sub_381C
		addi.l	#$800000,d4	; Next line
		dbf	d1,@LoadBaseTextColour

		moveq	#0,d0
		move.w	($FFFFFF82).w,d0
		move.w	d0,d1
		move.l	#_VDPcommand,d4
		lsl.w	#7,d0
		swap	d0
		add.l	d0,d4
		lea	(LevelSelectText).l,a1
		lsl.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		adda.w	d1,a1
		lsr.w	#3,d0
		move.w	d0,d1
		lsr.w	#1,d0
		add.w	d1,d0
		move.w	d0,Vscroll_Factor+2.w
		move.w	#(VRAMLevSelTextArt/$20)+TMap_Priority+TMap_PalLine3,d3
		move.l	d4,4(a6)
		bsr.w	sub_381C
		move.w	#(VRAMLevSelTextArt/$20)+TMap_Priority+"0",d3
		cmpi.w	#LevelSelectMax-1,($FFFFFF82).w
		bne.s	loc_37E6
		move.w	#(VRAMLevSelTextArt/$20)+TMap_Priority+TMap_PalLine3+"0",d3

loc_37E6:	
		locVRAMtemp ($E000+(31*128)+(2*25)),_VDPcommand
		move.l	#_VDPcommand,(VDP_control_port).l
		move.w	($FFFFFF84).w,d0
		addi.w	#$80,d0
		move.b	d0,d2
		lsr.b	#4,d0
		bsr.w	sub_3808
		move.b	d2,d0
		bsr.w	sub_3808
		rts
; End of function LevelSelect_TextLoad


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_3808:				; CODE XREF: LevelSelect_TextLoad+80p
					; LevelSelect_TextLoad+86p
		andi.w	#$F,d0
		cmpi.b	#$A,d0
		bcs.s	loc_3816
		addi.b	#7,d0

loc_3816:				; CODE XREF: sub_3808+8j
		add.w	d3,d0
		move.w	d0,(a6)
		rts
; End of function sub_3808


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_381C:				; CODE XREF: LevelSelect_TextLoad+1Cp
					; LevelSelect_TextLoad+56p
		moveq	#24-1,d2

loc_381E:				; CODE XREF: sub_381C+Cj sub_381C+16j
		moveq	#0,d0
		move.b	(a1)+,d0
		bpl.s	loc_382E
		move.w	#0,(a6)
		dbf	d2,loc_381E
		rts
; ===========================================================================

loc_382E:				; CODE XREF: sub_381C+6j
		add.w	d3,d0
		move.w	d0,(a6)
		dbf	d2,loc_381E
		rts
; End of function sub_381C
; ===========================================================================
; ---------------------------------------------------------------------------
; Level
; DEMO AND ZONE LOOP (MLS values $08, $0C; bit 7 set indicates that load routine is running)
; ---------------------------------------------------------------------------

Level:	
		bset	#GameModeFlag_TitleCard,(Game_Mode).w
		tst.w	(Demo_Mode_Flag).w
		bmi.s	@NoMusicFadeIfCredits
		move.b	#$E0,d0
		bsr.w	PlaySound_Special

	@NoMusicFadeIfCredits:
		bsr.w	ClearPLC
		bsr.w	Pal_FadeToBlack
		tst.w	(Demo_Mode_Flag).w
		bmi.w	@SkipIfCreditsDemo

		disable_ints
		locVRAM	$B000
		lea	(ArtNem_TitleCard).l,a0
		bsr.w	NemDec
		bsr.w	ClearScreen
		lea	(VDP_control_port).l,a5
		fillVRAM	0,$0FFF,$A000

		lea	($FFFFF628).w,a1
		moveq	#0,d0
		move.w	#($D8/4)-1,d1
	@ClearRAM1:
		move.l	d0,(a1)+
		dbf	d1,@ClearRAM1
	; ---
		lea	(unk_F700).w,a1
		moveq	#0,d0
		move.w	#($100/4)-1,d1
	@ClearRAM2:
		move.l	d0,(a1)+
		dbf	d1,@ClearRAM2

	@CheckDMAFill:
		move.w	(a5),d1
		btst	#1,d1	; Wait for DMA to be completed
		bne.s	@CheckDMAFill
		move.w	#$8F02,(a5)	; Auto increment set to 2
		enable_ints

		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		lsl.w	#4,d0
		lea	(LevelArtPointers).l,a2
		lea	(a2,d0.w),a2

		moveq	#0,d0
		move.b	(a2),d0
		beq.s	@No2ndZonePLC	; if zero, load no PLC
		bsr.w	LoadPLC
	@No2ndZonePLC:
		moveq	#PLCID_Main2,d0
		bsr.w	LoadPLC

	@SkipIfCreditsDemo:
		lea	(Sprite_Input_Table).w,a1
		moveq	#0,d0
		move.w	#(Sprite_Input_Table_End-Sprite_Input_Table)/4-1,d1
	@ClearSprTable:
		move.l	d0,(a1)+
		dbf	d1,@ClearSprTable
	; ---
		lea	(Object_Space).w,a1
		moveq	#0,d0
		move.w	#(Object_Space_End-Object_Space)/4-1,d1
	@ClearObj:
		move.l	d0,(a1)+
		dbf	d1,@ClearObj
	; ---
		lea	($FFFFFE60).w,a1
		moveq	#0,d0
		move.w	#($120/4)-1,d1

	@ClearRAM3:
		move.l	d0,(a1)+
		dbf	d1,@ClearRAM3

		lea	(VDP_control_port).l,a6
		move.l	#$8B038230,(a6)
		move.l	#$8407857C,(a6)
		move.l	#$90018004,(a6)
		move.w	#$8720,(a6)
		move.w	#$8ADF,(Hint_counter_reserve).w
		tst.w	(Two_player_mode).w
		beq.s	@1PlayerGame
		move.w	#$8A6B,(Hint_counter_reserve).w
		move.l	#$80148C87,(a6)

	@1PlayerGame:
		moveq	#3,d0
		bsr.w	PalLoadNormal

		tst.w	(Demo_Mode_Flag).w
		bmi.s	loc_3D2A	; skip if credits is on
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		lea	MusicList,a1
		move.b	(a1,d0.w),d0
		bsr.w	PlaySound
		move.b	#ObjID_TitleCard,(Title_Card).w	; Title Card

loc_3D2A:
		moveq	#3,d0
		bsr.w	PalLoadFade
		bsr.w	LevelSizeLoad
		bsr.w	DeformBGLayer
		bset	#2,(Scroll_flags).w
		bsr.w	MainLevelLoadBlock
		jsr	(LoadAnimatedBlocks).l
		bsr.w	LoadTilesFromStart
		bsr.w	LoadCollisionIndexes
		bsr.w	WaterEffects
		move.b	#ObjID__Player,(MainCharacter).w

LevelInit_TitleCard:
		move.b	#VintID_TitleCard,(Vint_routine).w
		bsr.w	WaitForVint
		jsr	(RunObjects).l
		jsr	(BuildSprites).l
		bsr.w	RunPLC_RAM
		move.w	(Title_Card3+x_pixel).w,d0
		cmp.w	(Title_Card3+$30).w,d0
		bne.s	LevelInit_TitleCard
		tst.l	(Plc_Buffer).w
		bne.s	LevelInit_TitleCard

		tst.w	(Demo_Mode_Flag).w
		bmi.s	@NoHud
		move.b	#$21,(HudObject).w
		jsr	(HUD_Base).l
	@NoHud:

		tst.w	(Two_player_mode).w
		beq.s	LevelInit_SkipTails
		move.b	#ObjID__Player,(Sidekick).w
		move.w	(MainCharacter+x_pos).w,(Sidekick+x_pos).w
		move.w	(MainCharacter+y_pos).w,(Sidekick+y_pos).w
		subi.w	#$20,(Sidekick+x_pos).w

LevelInit_SkipTails:
		tst.b	(Debug_options_flag).w
		beq.s	loc_3DA6
		btst	#bitA,(Ctrl_1_Held).w
		beq.s	loc_3DA6
		move.b	#1,(Debug_mode_flag).w

loc_3DA6:
		move.w	#0,(Ctrl_1_Logical).w
		move.w	#0,(Ctrl_1).w
		tst.b	(Water_flag).w
		beq.s	loc_3DD0
		move.b	#4,(Water_Surface_Object).w
		move.w	#$60,(Water_Surface_Object+x_pos).w
		move.b	#4,(Water_Surface_Object2).w
		move.w	#$120,(Water_Surface_Object2+x_pos).w

loc_3DD0:
		jsr	(ObjectsManager).l
		jsr	(RingsManager).l
		jsr	(RunObjects).l
		jsr	(BuildSprites).l
		jsr	(AniArt_Load).l
		moveq	#0,d0
		tst.b	(Last_LampPost_hit).w
		bne.s	loc_3E00
		move.w	d0,(Ring_count).w
		move.l	d0,(Timer).w
		move.b	d0,(Extra_life_flags).w

loc_3E00:
		move.b	d0,($FFFFFE1A).w
		move.b	d0,($FFFFFE2C).w
		move.b	d0,($FFFFFE2D).w
		move.b	d0,($FFFFFE2E).w
		move.b	d0,($FFFFFE2F).w
		move.w	d0,(Debug_placement_mode).w
		move.w	d0,(Level_Reload).w
		move.w	d0,(Level_Counter).w
		bsr.w	OscillateNumInit
		move.b	#1,(Update_HUD_score).w
		move.b	#1,(Update_HUD_rings).w
		move.b	#1,(Update_HUD_timer).w
		move.w	#4,(Sonic_Pos_Record_Index).w
		move.w	#0,(Sonic_Pos_Record_Buf).w
		move.w	#0,($FFFFF790).w
		move.w	#0,($FFFFF740).w
		lea	(Demo_Index).l,a1
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		tst.w	(Demo_Mode_Flag).w
		bpl.s	loc_3E78
		lea	(Demo_S1EndIndex).l,a1 ; garbage, leftover from	Sonic 1's ending sequence demos
		move.w	($FFFFFFF4).w,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1

loc_3E78:
		move.b	1(a1),($FFFFF792).w
		subq.b	#1,($FFFFF792).w
		lea	(Demo_2P).l,a1
		move.b	1(a1),($FFFFF742).w
		subq.b	#1,($FFFFF742).w
		move.w	#$668,(Demo_Time_left).w
		tst.w	(Demo_Mode_Flag).w
		bpl.s	loc_3EB2
		move.w	#$21C,(Demo_Time_left).w
		cmpi.w	#4,($FFFFFFF4).w
		bne.s	loc_3EB2
		move.w	#$1FE,(Demo_Time_left).w
loc_3EB2:
		move.w	#3,d1
loc_3ECC:
		move.b	#VintID_Level,(Vint_routine).w
		bsr.w	WaitForVint
		dbf	d1,loc_3ECC
		move.w	#(1*$2000)+(3*$10)-1,($FFFFF626).w	; Fade 3 lines past 1st line
		bsr.w	Pal_FadeFromBlack2
		tst.w	(Demo_Mode_Flag).w
		bmi.s	Level_ClrTitleCard
		addq.b	#2,(Title_Card+routine).w
		addq.b	#4,(Title_Card2+routine).w
		addq.b	#4,(Title_Card3+routine).w
		addq.b	#4,(Title_Card4+routine).w
		bra.s	Level_StartGame
; ===========================================================================

Level_ClrTitleCard:
		moveq	#PLCID_Explode,d0
		jsr	(LoadPLC).l
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		addi.w	#PLCID_GHZAnimals,d0
		jsr	(LoadPLC).l


Level_StartGame:
		bclr	#GameModeFlag_TitleCard,(Game_Mode).w

; ---------------------------------------------------------------------------
; Main level loop (when all title card and loading sequences are finished)
; ---------------------------------------------------------------------------

Level_MainLoop:
		bsr.w	PauseGame
		move.b	#VintID_Level,(Vint_routine).w
		bsr.w	WaitForVint
		addq.w	#1,(Level_Counter).w
		bsr.w	MoveSonicInDemo
		bsr.w	WaterEffects
		jsr	(RunObjects).l
		tst.b	(Level_Reload).w
		bne.w	Level
		tst.w	(Debug_placement_mode).w
		bne.s	loc_3F50
		cmpi.b	#6,(MainCharacter+routine).w
		bcc.s	loc_3F54

loc_3F50:
		bsr.w	DeformBGLayer

loc_3F54:
		bsr.w	ChangeWaterSurfacePos
		jsr	(RingsManager).l
		jsr	(AniArt_Load).l
		bsr.w	PalCycle_Load
		bsr.w	RunPLC_RAM
		bsr.w	OscillateNumDo
		bsr.w	ChangeRingFrame

	; Signpost Load routine
		tst.w	(Debug_placement_mode).w
		bne.w	@NoSignpostArt
		cmpi.b	#3,(Current_Act).w	; No Signpost art on Boss acts
		beq.s	@NoSignpostArt
		move.w	(Camera_X_pos).w,d0
		move.w	(Camera_Max_X_pos).w,d1
		subi.w	#$100,d1
		cmp.w	d1,d0
		blt.s	@NoSignpostArt
		tst.b	(Update_HUD_timer).w
		beq.s	@NoSignpostArt
		cmp.w	(Camera_Min_X_pos).w,d1
		beq.s	@NoSignpostArt
		move.w	d1,(Camera_Min_X_pos).w
		moveq	#PLCID_Signpost,d0
		bra.w	LoadPLC2
	@NoSignpostArt:



		jsr	(BuildSprites).l
		jsr	(ObjectsManager).l
		cmpi.b	#GameModeID_Level,(Game_Mode).w
		beq.w	Level_MainLoop
		cmpi.b	#GameModeID_Demo,(Game_Mode).w
		bne.s	@ExitGamemode

		tst.b	(Level_Reload).w
		bne.s	loc_3FB4
		tst.w	(Demo_Time_left).w
		beq.s	loc_3FB4
		cmpi.b	#GameModeID_Demo,(Game_Mode).w
		beq.w	Level_MainLoop
		move.b	#GameModeID_Logo,(Game_Mode).w
	@ExitGamemode:
		rts
; ===========================================================================

loc_3FB4:
		cmpi.b	#GameModeID_Demo,(Game_Mode).w
		bne.s	loc_3FCE
		move.b	#GameModeID_Logo,(Game_Mode).w
		tst.w	(Demo_Mode_Flag).w
		bpl.s	loc_3FCE
		move.b	#GameModeID_Logo,(Game_Mode).w

loc_3FCE:
		move.w	#$3C,(Demo_Time_left).w
		move.w	#$3F,($FFFFF626).w
		clr.w	($FFFFF794).w

loc_3FDE:
		move.b	#VintID_Level,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.w	MoveSonicInDemo
		jsr	(RunObjects).l
		jsr	(BuildSprites).l
		jsr	(ObjectsManager).l
		subq.w	#1,($FFFFF794).w
		bpl.s	loc_400E
		move.w	#2,($FFFFF794).w
		bsr.w	Pal_FadeOut

loc_400E:
		tst.w	(Demo_Time_left).w
		bne.s	loc_3FDE
		rts
; ===========================================================================

ChangeWaterSurfacePos:
		tst.b	(Water_flag).w
		beq.s	@NoWater
		move.w	(Camera_X_pos).w,d1
		btst	#0,(Level_Counter+1).w
		beq.s	@loc_402C
		addi.w	#$20,d1

	@loc_402C:
		move.w	d1,d0
		addi.w	#$60,d0
		move.w	d0,(Water_Surface_Object+x_pos).w
		addi.w	#$120,d1
		move.w	d1,(Water_Surface_Object2+x_pos).w

	@NoWater:
		rts
; End of function ChangeWaterSurfacePos


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


WaterEffects:				; CODE XREF: ROM:00003D56p
					; ROM:00003F30p
		tst.b	(Water_flag).w
		beq.s	@NoWater
		tst.b	($FFFFEEDC).w
		bne.s	@loc_4058
		cmpi.b	#6,(MainCharacter+routine).w
		bcc.s	@loc_4058
		bsr.w	DynamicWaterHeight

	@loc_4058:	
		clr.b	(Water_fullscreen_flag).w
		moveq	#0,d0
		move.b	($FFFFFE60).w,d0
		lsr.w	#1,d0
		add.w	(Water_Level_2).w,d0
		move.w	d0,(Water_Level_1).w
		move.w	(Water_Level_1).w,d0
		sub.w	(Camera_Y_pos).w,d0
		bcc.s	@loc_4086
		tst.w	d0
		bpl.s	@loc_4086
		move.b	#224-1,(Hint_counter_reserve+1).w
		move.b	#1,(Water_fullscreen_flag).w

	@loc_4086:	
		cmpi.w	#224-1,d0
		bcs.s	@loc_4090
		move.w	#224-1,d0

	@loc_4090:	
		move.b	d0,(Hint_counter_reserve+1).w

	@NoWater:	
		rts
; End of function WaterEffects
; ===========================================================================
		Include	"Level/Level Water Start.asm"
		Include	"Level/Dynamic Water Events.asm"
		Include	"Routines/Demo Recording.asm"
; ===========================================================================



LoadCollisionIndexes:		; these are Kosinski compressed in the final
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		lsl.w	#3,d0
;		move.l	#Primary_Collision,(Collision_addr).w	; Both players write here anyway, I hate it
		movea.l	Col_Index(pc,d0.w),a1
		lea	(Primary_Collision).w,a2
		bsr.s	Col_Load
		movea.l	Col_Index+4(pc,d0.w),a1
		lea	(Secondary_Collision).w,a2
; End of function LoadCollisionIndexes

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

Col_Load:
		move.w	#$300-1,d1
		moveq	#0,d2

loc_4616:
		move.b	(a1)+,d2
		move.w	d2,(a2)+
		dbf	d1,loc_4616
		rts
; End of function Col_Load

; ===========================================================================
; ---------------------------------------------------------------------------
; Pointers to Primary and Secondary collision indexes
;
; Contains an array of pointers to the collision index data for each
; level. 2 pointers for each level, pointing the collision indexes.
; ---------------------------------------------------------------------------
Col_Index:	
c	=	0
		rept ZoneCount
		dc.l ColP_\#c, ColS_\#c
c		=	c+1
		endr

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


OscillateNumInit:			; CODE XREF: ROM:00003E20p
		lea	($FFFFFE5E).w,a1
		lea	(Osc_Data).l,a2
		moveq	#$21-1,d1

loc_465C:				; CODE XREF: OscillateNumInit+Ej
		move.w	(a2)+,(a1)+
		dbf	d1,loc_465C
		rts
; End of function OscillateNumInit

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Osc_Data:	dc.w	$007C,	$0080	; 0
		dc.w	$0000,	$0080	; 2
		dc.w	$0000,	$0080	; 4
		dc.w	$0000,	$0080	; 6
		dc.w	$0000,	$0080	; 8
		dc.w	$0000,	$0080	; 10
		dc.w	$0000,	$0080	; 12
		dc.w	$0000,	$0080	; 14
		dc.w	$0000,	$0080	; 16
		dc.w	$0000,	$50F0	; 18
		dc.w	$011E,	$2080	; 20
		dc.w	$00B4,	$3080	; 22
		dc.w	$010E,	$5080	; 24
		dc.w	$01C2,	$7080	; 26
		dc.w	$0276,	$0080	; 28
		dc.w	$0000,	$0080	; 30
		dc.w	$0000

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


OscillateNumDo:				; CODE XREF: ROM:00003F6Ap
		cmpi.b	#6,(MainCharacter+routine).w
		bcc.s	locret_46FC
		lea	($FFFFFE5E).w,a1
		lea	(OscData2).l,a2
		move.w	(a1)+,d3
		moveq	#$10-1,d1

loc_46BC:				; CODE XREF: OscillateNumDo+4Ej
		move.w	(a2)+,d2
		move.w	(a2)+,d4
		btst	d1,d3
		bne.s	loc_46DC
		move.w	2(a1),d0
		add.w	d2,d0
		move.w	d0,2(a1)
		add.w	d0,0(a1)
		cmp.b	0(a1),d4
		bhi.s	loc_46F2
		bset	d1,d3
		bra.s	loc_46F2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_46DC:				; CODE XREF: OscillateNumDo+1Cj
		move.w	2(a1),d0
		sub.w	d2,d0
		move.w	d0,2(a1)
		add.w	d0,0(a1)
		cmp.b	0(a1),d4
		bls.s	loc_46F2
		bclr	d1,d3

loc_46F2:				; CODE XREF: OscillateNumDo+30j
					; OscillateNumDo+34j ...
		addq.w	#4,a1
		dbf	d1,loc_46BC
		move.w	d3,($FFFFFE5E).w

locret_46FC:				; CODE XREF: OscillateNumDo+6j
		rts
; End of function OscillateNumDo

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
OscData2:	dc.w	 2,  $10	; 0 ; DATA XREF: OscillateNumDo+Co
		dc.w	 2,  $18	; 2
		dc.w	 2,  $20	; 4
		dc.w	 2,  $30	; 6
		dc.w	 4,  $20	; 8
		dc.w	 8,    8	; 10
		dc.w	 8,  $40	; 12
		dc.w	 4,  $40	; 14
		dc.w	 2,  $50	; 16
		dc.w	 2,  $50	; 18
		dc.w	 2,  $20	; 20
		dc.w	 3,  $30	; 22
		dc.w	 5,  $50	; 24
		dc.w	 7,  $70	; 26
		dc.w	 2,  $10	; 28
		dc.w	 2,  $10	; 30

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


ChangeRingFrame:	
		subq.b	#1,(Logspike_anim_counter).w
		bpl.s	loc_4754
		move.b	#12-1,(Logspike_anim_counter).w
		subq.b	#1,(Logspike_anim_frame).w
		andi.b	#7,(Logspike_anim_frame).w

loc_4754:	
		subq.b	#1,(Rings_anim_counter).w
		bpl.s	loc_4788
		move.b	#8-1,(Rings_anim_counter).w
		addq.b	#1,(Rings_anim_frame).w
		andi.b	#3,(Rings_anim_frame).w
		addq.b	#1,($FFFFFEC5).w
		cmpi.b	#6,($FFFFFEC5).w
		bcs.s	loc_4788
		move.b	#0,($FFFFFEC5).w

loc_4788:
		tst.b	(Ring_spill_anim_counter).w
		beq.s	@DoNothing
		moveq	#0,d0
		move.b	(Ring_spill_anim_counter).w,d0
		add.w	(Ring_spill_anim_accum).w,d0
		move.w	d0,(Ring_spill_anim_accum).w
		rol.w	#7,d0
		andi.w	#3,d0
		move.b	d0,(Ring_spill_anim_frame).w	
		subq.b	#1,(Ring_spill_anim_counter).w

	@DoNothing:
		rts
; End of function ChangeRingFrame

; ---------------------------------------------------------------------------
; ===========================================================================
; Sonic 1 Special Stage
SpecialStage:
		move.w	#$CA,d0
		bsr.w	PlaySound_Special
		bsr.w	Pal_MakeFlash
		move	#$2700,sr
		lea	(VDP_control_port).l,a6
		move.l	#$8B038004,(a6)
		move.w	#$8A00+175,(Hint_counter_reserve).w
		move.w	#$9011,(a6)	; AAAAAAAAAAAAAAAAAAAAAA

	inform	1, "TO DO : 32x128 MODE ASAP FOR MORE TILE DATA, NEED THEM PRIDE BLOCKS"
		;move.w	#$9030,(a6)

		move.w	(VDP_Reg1_val).w,d0
		andi.b	#$BF,d0
		move.w	d0,(VDP_control_port).l	; Turn off Display
		bsr.w	ClearScreen
		enable_ints
; ---------------------------------------------------------------------------
		fillVRAM 0,$7000-1,$5000 ; This is right at the mappings for the birds/fish, I can't
	@WaitForDMA:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	@WaitForDMA
		move.w	#$8F02,(a5)
; ---------------------------------------------------------------------------

;		bsr.w	S1_SSBGLoad	; That Background that I hate
		moveq	#PLCID_S1SpecialStage,d0
		bsr.w	RunPLC_ROM

		lea	(Object_Space).w,a1
		moveq	#0,d0
		move.w	#((Object_Space_End)-(Object_Space))/4-1,d1
loc_509C:
		move.l	d0,(a1)+
		dbf	d1,loc_509C

		lea	(unk_F700).w,a1
		moveq	#0,d0
		move.w	#$100/4-1,d1
loc_50AC:
		move.l	d0,(a1)+
		dbf	d1,loc_50AC

		lea	($FFFFFE60).w,a1
		moveq	#0,d0
		move.w	#$A0/4-1,d1
loc_50BC:
		move.l	d0,(a1)+
		dbf	d1,loc_50BC

		lea	(Decomp_Buffer).w,a1
		moveq	#0,d0
		move.w	#$200/4-1,d1

loc_50CC:
		move.l	d0,(a1)+
		dbf	d1,loc_50CC

		clr.b	(Water_fullscreen_flag).w
		clr.b	(Level_Reload).w

		moveq	#4,d0
		bsr.w	PalLoadFade

		jsr	(S1SS_Load).l
		move.l	#0,(Camera_X_pos).w
		move.l	#0,(Camera_Y_pos).w
		move.b	#ObjID__SSPlayer,(MainCharacter).w
		bsr.w	PalCycle_S1SS
		clr.w	(Special_Stage_Angle).w
		move.w	#$40,(Special_Stage_Speed).w
		move.w	#MusID_SpecialStage,d0
		bsr.w	PlaySound
		move.w	#0,($FFFFF790).w
		lea	(Demo_Index).l,a1
		moveq	#6,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.b	1(a1),($FFFFF792).w
		subq.b	#1,($FFFFF792).w
		clr.w	(Ring_count).w
		clr.b	(Extra_life_flags).w
		move.w	#0,(Debug_placement_mode).w
		move.w	#$708,(Demo_Time_left).w
		tst.b	(Debug_options_flag).w
		beq.s	loc_5158
		btst	#6,(Ctrl_1_Held).w
		beq.s	loc_5158
		move.b	#1,(Debug_mode_flag).w

loc_5158:
		move.w	(VDP_Reg1_val).w,d0
		ori.b	#$40,d0
		move.w	d0,(VDP_control_port).l	; Turn on Display
		bsr.w	Pal_MakeWhite
; ---------------------------------------------------------------------------
; Main Special Stage loop
; ---------------------------------------------------------------------------

SS_MainLoop:
		bsr.w	PauseGame
		move.b	#VintID_S1SS,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.w	MoveSonicInDemo
		move.w	(Ctrl_1).w,(Ctrl_1_Logical).w
		jsr	(RunObjects).l
		jsr	(BuildSprites).l
		jsr	(S1SS_ShowLayout).l
		bsr.w	S1SS_BgAnimate
		tst.w	(Demo_Mode_Flag).w	; check demo
		beq.s	loc_51A6
		tst.w	(Demo_Time_left).w
		beq.w	loc_52D4

loc_51A6:
		cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w
		beq.w	SS_MainLoop

		tst.w	(Demo_Mode_Flag).w	; check demo
		bne.w	loc_52DC
		move.b	#GameModeID_Level,(Game_Mode).w
		move.w	#$3C,(Demo_Time_left).w
		move.w	#$3F,($FFFFF626).w
		clr.w	($FFFFF794).w

loc_51DA:
		move.b	#VintID_SSResults,(Vint_routine).w
		bsr.w	WaitForVint
		bsr.w	MoveSonicInDemo
		move.w	(Ctrl_1).w,(Ctrl_1_Logical).w
		jsr	(RunObjects).l
		jsr	(BuildSprites).l
		jsr	(S1SS_ShowLayout).l
		bsr.w	S1SS_BgAnimate
		subq.w	#1,($FFFFF794).w
		bpl.s	loc_5214
		move.w	#2,($FFFFF794).w
		bsr.w	Pal_ToWhite

loc_5214:
		tst.w	(Demo_Time_left).w
		bne.s	loc_51DA
		move	#$2700,sr
		lea	(VDP_control_port).l,a6
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$9001,(a6)
		bsr.w	ClearScreen
		locVRAM	$B000
		lea	(ArtNem_TitleCard).l,a0
		bsr.w	NemDec
		jsr	(HUD_Base).l
		move	#$2300,sr
		moveq	#5,d0
		bsr.w	PalLoadNormal
		moveq	#PLCID_Main,d0
		bsr.w	LoadPLC2
		moveq	#PLCID_S1TitleCard,d0
		bsr.w	LoadPLC
		move.b	#1,(Update_HUD_score).w
		move.b	#1,(Update_Bonus_score).w
		move.w	(Ring_count).w,d0
		mulu.w	#$A,d0
		move.w	d0,(Bonus_Countdown_2).w
		move.w	#$8E,d0
		jsr	(PlaySound_Special).l
		lea	(Object_Space).w,a1
		moveq	#0,d0
		move.w	#(Object_Space_End-Object_Space)/4-1,d1

loc_5290:
		move.l	d0,(a1)+
		dbf	d1,loc_5290
		move.b	#$7E,(End_Of_act_Title_Card).w

loc_529C:
		bsr.w	PauseGame
		move.b	#VintID_TitleCard,(Vint_routine).w
		bsr.w	WaitForVint
		jsr	(RunObjects).l
		jsr	(BuildSprites).l
		bsr.w	RunPLC_RAM
		tst.b	(Level_Reload).w
		beq.s	loc_529C
		tst.l	(Plc_Buffer).w
		bne.s	loc_529C
		move.w	#$CA,d0
		bsr.w	PlaySound_Special
		bsr.w	Pal_MakeFlash
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_52D4:				; CODE XREF: ROM:000051A2j
					; ROM:000052E2j
		move.b	#GameModeID_Logo,(Game_Mode).w
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_52DC:				; CODE XREF: ROM:000051B4j
		cmpi.b	#GameModeID_Level,(Game_Mode).w
		beq.s	loc_52D4
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


S1_SSBGLoad:				; CODE XREF: ROM:00005088p
		lea	(RAM_Start).l,a1
		move.w	#$4051,d0
		bsr.w	EniDec
		move.l	#$50000001,d3
		lea	($FFFF0080).l,a2
		moveq	#6,d7

loc_5302:				; CODE XREF: S1_SSBGLoad+7Ej
		move.l	d3,d0
		moveq	#3,d6
		moveq	#0,d4
		cmpi.w	#3,d7
		bcc.s	loc_5310
		moveq	#1,d4

loc_5310:				; CODE XREF: S1_SSBGLoad+26j
					; S1_SSBGLoad+64j
		moveq	#7,d5

loc_5312:				; CODE XREF: S1_SSBGLoad+56j
		movea.l	a2,a1
		eori.b	#1,d4
		bne.s	loc_5326
		cmpi.w	#6,d7
		bne.s	loc_5336
		lea	(RAM_Start).l,a1

loc_5326:				; CODE XREF: S1_SSBGLoad+32j
		movem.l	d0-d4,-(sp)
		moveq	#7,d1
		moveq	#7,d2
		bsr.w	PlaneMapToVRAM_H40
		movem.l	(sp)+,d0-d4

loc_5336:				; CODE XREF: S1_SSBGLoad+38j
		addi.l	#$100000,d0
		dbf	d5,loc_5312
		addi.l	#$3800000,d0
		eori.b	#1,d4
		dbf	d6,loc_5310
		addi.l	#$10000000,d3
		bpl.s	loc_5360
		swap	d3
		addi.l	#$C000,d3
		swap	d3

loc_5360:				; CODE XREF: S1_SSBGLoad+6Ej
		adda.w	#$80,a2	; '€'
		dbf	d7,loc_5302
		lea	(RAM_Start).l,a1
		move.w	#$4000,d0
		bsr.w	EniDec
		lea	(RAM_Start).l,a1
		move.l	#$40000003,d0
		moveq	#$3F,d1	; '?'
		moveq	#$1F,d2
		bsr.w	PlaneMapToVRAM_H40
		lea	(RAM_Start).l,a1
		move.l	#$50000003,d0
		moveq	#$3F,d1	; '?'
		moveq	#$3F,d2	; '?'
		bsr.w	PlaneMapToVRAM_H40
		rts
; End of function S1_SSBGLoad


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


PalCycle_S1SS:				; CODE XREF: ROM:00000E90p
					; ROM:000050FCp
		tst.b	(Game_paused).w
		bne.s	locret_5424
		subq.w	#1,($FFFFF79C).w
		bpl.s	locret_5424
		lea	(VDP_control_port).l,a6
		move.w	($FFFFF79A).w,d0
		addq.w	#1,($FFFFF79A).w
		andi.w	#$1F,d0
		lsl.w	#2,d0
		lea	(word_547A).l,a0
		adda.w	d0,a0
		move.b	(a0)+,d0
		bpl.s	loc_53D0
		move.w	#$1FF,d0

loc_53D0:				; CODE XREF: PalCycle_S1SS+2Aj
		move.w	d0,($FFFFF79C).w
		moveq	#0,d0
		move.b	(a0)+,d0
		move.w	d0,($FFFFF7A0).w
		lea	(word_54FA).l,a1
		lea	(a1,d0.w),a1
		move.w	#$8200,d0
		move.b	(a1)+,d0
		move.w	d0,(a6)
		move.b	(a1),(Vscroll_Factor).w
		move.w	#$8400,d0
		move.b	(a0)+,d0
		move.w	d0,(a6)
		locVSRAM	0
		move.l	(Vscroll_Factor).w,(VDP_data_port).l
		moveq	#0,d0
		move.b	(a0)+,d0
		bmi.s	loc_5426
		lea	(Pal_S1SSCyc1).l,a1
		adda.w	d0,a1
		lea	($FFFFFB4E).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+

locret_5424:				; CODE XREF: PalCycle_S1SS+4j
					; PalCycle_S1SS+Aj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_5426:				; CODE XREF: PalCycle_S1SS+70j
		move.w	($FFFFF79E).w,d1
		cmpi.w	#$8A,d0	; 'Š'
		bcs.s	loc_5432
		addq.w	#1,d1

loc_5432:				; CODE XREF: PalCycle_S1SS+8Ej
		mulu.w	#$2A,d1	; '*'
		lea	(Pal_S1SSCyc2).l,a1
		adda.w	d1,a1
		andi.w	#$7F,d0	; ''
		bclr	#0,d0
		beq.s	loc_5456
		lea	($FFFFFB6E).w,a2
		move.l	(a1),(a2)+
		move.l	4(a1),(a2)+
		move.l	8(a1),(a2)+

loc_5456:				; CODE XREF: PalCycle_S1SS+A6j
		adda.w	#$C,a1
		lea	($FFFFFB5A).w,a2
		cmpi.w	#$A,d0
		bcs.s	loc_546C
		subi.w	#$A,d0
		lea	($FFFFFB7A).w,a2

loc_546C:				; CODE XREF: PalCycle_S1SS+C2j
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		adda.w	d0,a1
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		rts
; End of function PalCycle_S1SS

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
word_547A:	dc.w  $300, $792, $300,	$790, $300, $78E, $300,	$78C, $300, $78B, $300,	$780, $300, $782, $300,	$784; 0
					; DATA XREF: PalCycle_S1SS+20o
		dc.w  $300, $786, $300,	$788, $708, $700, $70A,	$70C,$FF0C, $718,$FF0C,	$718, $70A, $70C, $708,	$700; 16
		dc.w  $300, $688, $300,	$686, $300, $684, $300,	$682, $300, $681, $300,	$68A, $300, $68C, $300,	$68E; 32
		dc.w  $300, $690, $300,	$692, $702, $624, $704,	$630,$FF06, $63C,$FF06,	$63C, $704, $630, $702,	$624; 48
word_54FA:	dc.w $1001,$1800,$1801,$2000,$2001,$2800,$2801;	0
					; DATA XREF: PalCycle_S1SS+3Co
Pal_S1SSCyc1:	dc.w  $400, $600, $620,	$624, $664, $666, $600,	$820, $A64, $A68, $AA6,	$AAA, $800, $C42, $E86,	$ECA; 0
					; DATA XREF: PalCycle_S1SS+72o
		dc.w  $EEC, $EEE, $400,	$420, $620, $620, $864,	$666, $420, $620, $842,	$842, $A86, $AAA, $620,	$842; 16
		dc.w  $A64, $C86, $EA8,	$EEE; 32
Pal_S1SSCyc2:	dc.w  $EEA, $EE0, $AA0,	$880, $660, $440, $EE0,	$AA0, $440, $AA0, $AA0,	$AA0, $860, $860, $860,	$640; 0
					; DATA XREF: PalCycle_S1SS+96o
		dc.w  $640, $640, $400,	$400, $400, $AEC, $6EA,	$4C6, $2A4,  $82,  $60,	$6EA, $4C6,  $60, $4C6,	$4C6; 16
		dc.w  $4C6, $484, $484,	$484, $442, $442, $442,	$400, $400, $400, $ECC,	$E8A, $C68, $A46, $824,	$602; 32
		dc.w  $E8A, $C68, $602,	$C68, $C68, $C68, $846,	$846, $846, $624, $624,	$624, $400, $400, $400,	$AEC; 48
		dc.w  $8CA, $6A8, $486,	$264,  $42, $8CA, $6A8,	 $42, $6A8, $6A8, $6A8,	$684, $684, $684, $442,	$442; 64
		dc.w  $442, $400, $400,	$400, $EEC, $CCA, $AA8,	$886, $664, $442, $CCA,	$AA8, $442, $AA8, $AA8,	$AA8; 80
		dc.w  $864, $864, $864,	$642, $642, $642, $400,	$400, $400; 96

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


S1SS_BgAnimate:	
		rts	
		move.w	($FFFFF7A0).w,d0
		bne.s	loc_5634
		move.w	#0,(Camera_BG_Y_pos).w
		move.w	(Camera_BG_Y_pos).w,($FFFFF618).w

loc_5634:	
		cmpi.w	#8,d0
		bcc.s	loc_568C
		cmpi.w	#6,d0
		bne.s	loc_564E
		addq.w	#1,(Camera_BG3_X_pos).w
		addq.w	#1,(Camera_BG_Y_pos).w
		move.w	(Camera_BG_Y_pos).w,($FFFFF618).w

loc_564E:	
		moveq	#0,d0
		move.w	(Camera_BG_X_pos).w,d0
		neg.w	d0
		swap	d0
		lea	(byte_5709).l,a1
		lea	(Decomp_Buffer).w,a3
		moveq	#9,d3

loc_5664:	
		move.w	2(a3),d0
		bsr.w	CalcSine
		moveq	#0,d2
		move.b	(a1)+,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,(a3)+
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d2,(a3)+
		dbf	d3,loc_5664
		lea	(Decomp_Buffer).w,a3
		lea	(byte_56F6).l,a2
		bra.s	loc_56BC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_568C:				; CODE XREF: S1SS_BgAnimate+16j
		cmpi.w	#$C,d0
		bne.s	loc_56B2
		subq.w	#1,(Camera_BG3_X_pos).w
		lea	(Decomp_Buffer+$100).w,a3
		move.l	#$18000,d2
		moveq	#6,d1

loc_56A2:				; CODE XREF: S1SS_BgAnimate+8Cj
		move.l	(a3),d0
		sub.l	d2,d0
		move.l	d0,(a3)+
		subi.l	#$2000,d2
		dbf	d1,loc_56A2

loc_56B2:				; CODE XREF: S1SS_BgAnimate+6Ej
		lea	(Decomp_Buffer+$100).w,a3
		lea	(byte_5701).l,a2

loc_56BC:				; CODE XREF: S1SS_BgAnimate+68j
		lea	(Horiz_Scroll_Buf).w,a1
		move.w	(Camera_BG3_X_pos).w,d0
		neg.w	d0
		swap	d0
		moveq	#0,d3
		move.b	(a2)+,d3
		move.w	(Camera_BG_Y_pos).w,d2
		neg.w	d2
		andi.w	#$FF,d2
		lsl.w	#2,d2

loc_56D8:				; CODE XREF: S1SS_BgAnimate+CEj
		move.w	(a3)+,d0
		addq.w	#2,a3
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.w	#1,d1

loc_56E2:				; CODE XREF: S1SS_BgAnimate+CAj
		move.l	d0,(a1,d2.w)
		addq.w	#4,d2
		andi.w	#$3FC,d2
		dbf	d1,loc_56E2
		dbf	d3,loc_56D8
		rts
; End of function S1SS_BgAnimate

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_56F6:	dc.b   9,$28,$18,$10,$28,$18,$10,$30,$18,  8,$10
byte_5701:	dc.b   6,$30,$30,$30,$28,$18,$18,$18
byte_5709:	dc.b   8,  2,  4,$FF,  2,  3,  8,$FF,  4,  2,  2,  3,  8,$FD,  4,  2; 0
		dc.b   2,  3,  2,$FF,  0
; ===========================================================================

LevelSizeLoad:				; CODE XREF: ROM:00003D30p
		clr.l	(Scroll_flags).w
		clr.l	(Scroll_flags_BG2).w
		clr.l	(Scroll_flags_P2).w
		clr.l	(Scroll_flags_BG2_P2).w
		clr.l	($FFFFEEA0).w
		clr.l	($FFFFEEA4).w
		clr.l	($FFFFEEA8).w
		clr.l	($FFFFEEAC).w
		clr.b	($FFFFEEDC).w
		moveq	#0,d0
		move.b	d0,(Dynamic_Resize_Routine).w
		move.w	(Current_ZoneAndAct).w,d0
		lsl.b	#6,d0
		lsr.w	#3,d0
		lea	LevelSizeArray(pc,d0.w),a0
		move.l	(a0)+,d0
		move.l	d0,(Camera_Min_X_pos).w
		move.l	d0,($FFFFEEC0).w
		move.l	(a0)+,d0
		move.l	d0,(Camera_Min_Y_pos).w
		move.l	d0,($FFFFEEC4).w
		move.w	#$1010,(Horiz_block_crossed_flag).w
		move.w	#$60,(Camera_Y_pos_bias).w
		bra.w	LevelSize_CheckLamp
; ===========================================================================
LevelSizeArray:
		include	"Level/Level Initial Size.asm"
; ===========================================================================

Lamppost_StoreInfo:	
		lea	(LampPost_Save_RAM).w,a2
		move.b	subtype(a0),(a2)+	; Store object subtype as last checkpoint
		move.b	(Dynamic_Resize_Routine).w,(a2)+
		move.w	x_pos(a0),(a2)+
		move.w	y_pos(a0),(a2)+
		move.w	(Ring_count).w,(a2)+
		move.l	(Timer).w,(a2)+
		move.w	(MainCharacter+top_solid_bit).w,(a2)+

		move.w	(Camera_X_pos).w,(a2)+
		move.w	(Camera_Y_pos).w,(a2)+
		move.w	(Camera_BG_X_pos).w,(a2)+
		move.w	(Camera_BG_Y_pos).w,(a2)+
		move.w	(Camera_BG2_X_pos).w,(a2)+
		move.w	(Camera_BG2_Y_pos).w,(a2)+
		move.w	(Camera_BG3_X_pos).w,(a2)+
		move.w	(Camera_BG3_Y_pos).w,(a2)+
		move.w	(Camera_Max_Y_pos_now).w,(a2)+

		move.w	(Water_Level_2).w,(a2)+
		move.b	(Water_routine+1).w,(a2)+
		move.b	(Water_fullscreen_flag).w,(a2)+
		move.b	(Extra_life_flags).w,(a2)

		tst.b	(Last_LampPost_hit).w
		bpl.s	@DoNothing
		move.w	(Saved_x_pos).w,d0
		subi.w	#320/2,d0
		move.w	d0,(Camera_Min_X_pos).w
	@DoNothing:
		rts
; End of function Lamppost_StoreInfo
; ===========================================================================

LevelSize_CheckLamp:	
		tst.b	(Last_LampPost_hit).w
		beq	LevelSize_StartLoc

		lea	(LampPost_Save_RAM+1).w,a2
		move.b	(a2)+,(Dynamic_Resize_Routine).w
		move.w	(a2)+,d1	; Player X Position
		move.w	(a2)+,d2	; Player Y Position
		move.w	(a2)+,(Ring_count).w
		move.l	(a2)+,(Timer).w
		move.b	#59,(Timer_frame).w
		subq.b	#1,(Timer_second).w
		move.w	(a2)+,(MainCharacter+top_solid_bit).w

		move.w	(a2)+,(Camera_X_pos).w
		move.w	(a2)+,(Camera_Y_pos).w
		move.w	(a2)+,(Camera_BG_X_pos).w
		move.w	(a2)+,(Camera_BG_Y_pos).w
		move.w	(a2)+,(Camera_BG2_X_pos).w
		move.w	(a2)+,(Camera_BG2_Y_pos).w
		move.w	(a2)+,(Camera_BG3_X_pos).w
		move.w	(a2)+,(Camera_BG3_Y_pos).w
		move.w	(a2),(Camera_Max_Y_pos).w
		move.w	(a2)+,(Camera_Max_Y_pos_now).w

		move.w	(a2)+,(Water_Level_2).w
		move.b	(a2)+,(Water_routine+1).w
		move.b	(a2)+,(Water_fullscreen_flag).w
		move.b	(a2),(Extra_life_flags).w

		;hi, I'm a condition
		;beq	@noFlagClear	; Don't clear flags when coming from Special Stage
		clr.w	(Ring_count).w
		clr.b	(Extra_life_flags).w
	@NoFlagClear:
		tst.b	(Last_LampPost_hit).w
		bpl.s	LevelSize_StartLocLoaded
		move.w	(Saved_x_pos).w,d0
		subi.w	#320/2,d0
		move.w	d0,(Camera_Min_X_pos).w
		bra.s	LevelSize_StartLocLoaded
; ===========================================================================
S1EndingStartLoc:
		dc.w	$0050,	$3B0
		dc.w	$0EA0,	$46C
		dc.w	$1750,	$0BD
		dc.w	$0A00,	$62C
		dc.w	$0BB0,	$04C
		dc.w	$1570,	$16C
		dc.w	$01B0,	$72C
		dc.w	$1400,	$2AC
; ===========================================================================

LevelSize_StartLoc:	
		move.w	(Current_ZoneAndAct).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	StartLocArray(pc,d0.w),a1

		tst.w	(Demo_Mode_Flag).w
		bpl.s	@NotCredits

		move.w	($FFFFFFF4).w,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		lea	S1EndingStartLoc(pc,d0.w),a1

	@NotCredits:	
		moveq	#0,d1
		move.w	(a1)+,d1
		move.w	d1,(MainCharacter+x_pos).w
		moveq	#0,d2
		move.w	(a1),d2
		move.w	d2,(MainCharacter+y_pos).w

LevelSize_StartLocLoaded:	; Return from checkpoint or similar
		subi.w	#320/2,d1
		bcc.s	loc_58E6
		moveq	#0,d1
	loc_58E6:	
		move.w	(Camera_Max_X_pos).w,d0
		cmp.w	d0,d1
		bcs.s	loc_58F0
		move.w	d0,d1
	loc_58F0:
		move.w	d1,(Camera_X_pos).w
		move.w	d1,(Camera_X_pos_P2).w

		subi.w	#$60,d2
		bcc.s	loc_5900
		moveq	#0,d2
	loc_5900:
		cmp.w	(Camera_Max_Y_pos_now).w,d2
		blt.s	loc_590A
		move.w	(Camera_Max_Y_pos_now).w,d2
	loc_590A:	
		move.w	d2,(Camera_Y_pos).w
		move.w	d2,(Camera_Y_pos_P2).w
		bra.w	BgScrollSpeed
; End of function LevelSizeLoad

; ===========================================================================
StartLocArray:	; Starting location of each Zone
c		=	0
		rept	ZoneCount
_temp	equs	_ZoneFolder\#c
		incbin	"\_temp\Data\StartPos_1.bin"
		incbin	"\_temp\Data\StartPos_2.bin"
		incbin	"\_temp\Data\StartPos_3.bin"
		incbin	"\_temp\Data\StartPos_Boss.bin"
c		=	c+1
		endr
; ===========================================================================
		include	"Level\Level Background Scroll.asm"
; ===========================================================================


SetHorizScrollFlags:	
		move.w	(a1),d0
		andi.w	#$10,d0
		move.b	(a2),d1
		eor.b	d1,d0
		bne.s	@DoNothing
		eori.b	#$10,(a2)
		move.w	(a1),d0
		sub.w	d4,d0
		bpl.s	@Forward
		bset	#2,(a3)
		rts
	@Forward:
		bset	#3,(a3)		; set moving forward in level bit
	@DoNothing:			
		rts
; End of function ScrollHorizontal

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

ScrollHorizontal:
		move.w	(a1),d4
		; Final game puts a teleport flag here that stops the code
		move.w	(a5),d1		; should scrolling be delayed?
		beq.s	@scrollNotDelayed	; if not, branch
		subi.w	#$100,d1	; reduce delay value
		move.w	d1,(a5)
		moveq	#0,d1
		move.b	(a5),d1		; get delay value
		lsl.b	#2,d1		; multiply by 4, the size of a position buffer entry
		addq.b	#4,d1
		move.w	2(a5),d0	; get current position buffer index
		sub.b	d1,d0
		move.w	(a6,d0.w),d0	; get Sonic's position a certain number of frames ago
		andi.w	#$3FFF,d0
		bra.s	@checkIfShouldScroll
; ===========================================================================

@scrollNotDelayed:	
		move.w	x_pos(a0),d0
	@checkIfShouldScroll:		
		sub.w	(a1),d0
		subi.w	#(320/2)-16,d0	; is the player less than 144 pixels from the screen edge?
		blt.s	@ScrollLeft	; if he is, scroll left
		subi.w	#16,d0		; is the player more than 159 pixels from the screen edge?
		bge.s	@ScrollRight	; if he is, scroll right
		clr.w	(a4)		; otherwise, don't scroll
		rts
; ===========================================================================
@ScrollLeft:				; CODE XREF: sub_6514+2Cj
		cmpi.w	#-16,d0
		bgt.s	@maxNotReached
		move.w	#-16,d0		; limit scrolling to 16 pixels per frame
	@maxNotReached:
		add.w	(a1),d0		; get new camera position
		cmp.w	(a2),d0		; is it greater than the minimum position?
		bgt.s	@doScroll	; if it is, branch
		move.w	(a2),d0		; prevent camera from going any further back
		bra.s	@doScroll
; ===========================================================================
@ScrollRight:
		cmpi.w	#16,d0
		blo.s	@maxNotReached2
		move.w	#16,d0
	@maxNotReached2:
		add.w	(a1),d0
		cmp.w	Camera_Max_X_pos-Camera_Min_X_pos(a2),d0	; is it less than the max position?
		blt.s	@doScroll	; if it is, branch
		move.w	Camera_Max_X_pos-Camera_Min_X_pos(a2),d0	; prevent camera from going any further forward

	@doScroll:
		move.w	d0,d1
		sub.w	(a1),d1		; subtract old camera position
		asl.w	#8,d1		; shift up by a byte
		move.w	d0,(a1)		; set new camera position
		move.w	d1,(a4)		; set difference between old and new positions
		rts
; End of function sub_6514


; ---------------------------------------------------------------------------
; Subroutine to scroll the camera vertically
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

ScrollVertical:	

		moveq	#0,d1
		move.w	y_pos(a0),d0
		sub.w	(a1),d0

		tst.w	(Camera_Min_Y_pos).w	; does the level wrap vertically?
		bpl.s	@NoVerticalWrap			; if not, branch
		andi.w	#$7FF,d0
	@NoVerticalWrap:
		btst	#PlayerStatusBitSpin,status(a0)
		beq.s	@NotSpinning
		subq.w	#5,d0

	@NotSpinning:	
		btst	#PlayerStatusBitAir,status(a0)
		beq.s	@NotInTheAir

		addi.w	#32,d0		
		sub.w	d3,d0		; subtract camera bias (Sonic 2 final)
		bcs.s	@DoScroll_fast
		subi.w	#64,d0
		bcc.s	@DoScroll_fast
		tst.b	(Camera_Max_Y_pos_Changing).w
		bne.s	@ScrollUpOrDown_maxYPosChanging
		bra.s	@DoNotScroll
; ===========================================================================

@NotInTheAir:
		sub.w	d3,d0		; subtract camera bias (Sonic 2 final)
		bne.s	@DecideScrollType
		tst.b	(Camera_Max_Y_pos_Changing).w
		bne.s	@ScrollUpOrDown_maxYPosChanging

@DoNotScroll:
		clr.w	(a4)
		rts
; ===========================================================================

@DecideScrollType:
		cmpi.w	#(224/2)-16,d3 	; is the camera bias normal?
		bne.s	@DoScroll_slow	; if not, branch
		move.w	ground_speed(a0),d1 ; get player ground velocity
		bpl.s	@doScroll_medium	
		neg.w	d1		;  force it to be positive
	@doScroll_medium:
		cmpi.w	#$800,d1	; is the player travelling very fast?
		bhs.s	@DoScroll_fast	; if he is, branch

		move.w	#6<<8,d1
		cmpi.w	#6,d0		; is the positions difference greater than 6 pixels?
		bgt.s	@ScrollDown_max	; if so, move camera at capped speed
		cmpi.w	#-6,d0		; is the positions difference less than -6 pixels?
		blt.s	@ScrollUp_max	; if so, move camera at capped speed
		bra.s	@ScrollUpOrDown	; otherwise, move camera at player's speed
; ===========================================================================

@DoScroll_slow:
		move.w	#2<<8,d1	; If player is going too fast, cap camera movement to 2 pixels per frame
		cmpi.w	#2,d0		; is player going down too fast?
		bgt.s	@ScrollDown_max	; if so, move camera at capped speed
		cmpi.w	#-2,d0		; is player going up too fast?
		blt.s	@ScrollUp_max	; if so, move camera at capped speed
		bra.s	@ScrollUpOrDown	; otherwise, move camera at player's speed
; ===========================================================================

@DoScroll_fast:	
		move.w	#16<<8,d1	; If player is going too fast, cap camera movement to $10 pixels per frame
		cmpi.w	#16,d0		; is player going down too fast?
		bgt.s	@ScrollDown_max	; if so, move camera at capped speed
		cmpi.w	#-16,d0		; is player going up too fast?
		blt.s	@ScrollUp_max	; if so, move camera at capped speed
		bra.s	@ScrollUpOrDown	; otherwise, move camera at player's speed
; ===========================================================================

@ScrollUpOrDown_MaxYPosChanging:	
		moveq	#0,d0		; Distance for camera to move = 0
		move.b	d0,(Camera_Max_Y_pos_Changing).w	; clear camera max Y pos changing flag

@ScrollUpOrDown:	
		moveq	#0,d1
		move.w	d0,d1		; get position difference
		add.w	(a1),d1		; add old camera Y position
		tst.w	d0		; is the camera to scroll down?
		bpl.w	@ScrollDown	; if it is, branch
		bra.w	@ScrollUp
; ===========================================================================

@ScrollUp_max:	
		neg.w	d1	; make the value negative (since we're going backwards)
		ext.l	d1
		asl.l	#8,d1	; move this into the upper word, so it lines up with the actual y_pos value in Camera_Y_pos
		add.l	(a1),d1	; add the two, getting the new Camera_Y_pos value
		swap	d1	; actual Y-coordinate is now the low word

@ScrollUp:	
		cmp.w	(Camera_Min_Y_pos).w,d1	; is the new position less than the minimum Y pos?
		bgt.s	@DoScroll	; if not, branch
		cmpi.w	#-$100,d1
		bgt.s	@MinYPosReached
		andi.w	#$7FF,d1
		andi.w	#$7FF,(a1)
		bra.s	@DoScroll
; ===========================================================================

@minYPosReached:	
		move.w	4(a2),d1	; prevent camera from going any further up
		bra.s	@DoScroll
; ===========================================================================

@ScrollDown_max:	
		ext.l	d1
		asl.l	#8,d1
		add.l	(a1),d1
		swap	d1		; calculate new camera pos

@ScrollDown:				
		cmp.w	6(a2),d1	; is the new position greater than the maximum Y pos?
		blt.s	@doScroll	; if not, branch
		subi.w	#$800,d1
		bcs.s	@MaxYPosReached
		subi.w	#$800,(a1)
		bra.s	@doScroll
; ===========================================================================

@MaxYPosReached:				
		move.w	6(a2),d1	; prevent camera from going any further down

@doScroll:	
		move.w	(a1),d4		; get old pos (used by SetVertiScrollFlags)
		swap	d1		; actual Y-coordinate is now the high word, as Camera_Y_pos expects it
		move.l	d1,d3
		sub.l	(a1),d3
		ror.l	#8,d3
		move.w	d3,(a4)		; set difference between old and new positions
		move.l	d1,(a1)		; set new camera Y pos
		rts
; ===========================================================================

SetVertiScrollFlags:
		move.w	(a1),d0		; get camera Y pos
		andi.w	#$10,d0
		move.b	(a2),d1
		eor.b	d1,d0		; has the camera crossed a 16-pixel boundary?
		bne.s	@DoNothing	; if not, branch
		eori.b	#$10,(a2)
		move.w	(a1),d0		; get camera Y pos
		sub.w	d4,d0		; subtract old camera Y pos
		bpl.s	@ScrollDown	; branch if the camera has scrolled down
		bset	#0,(a3)		; set moving up in level bit
		rts
@ScrollDown:	
		bset	#1,(a3)	; set moving down in level bit
@DoNothing:	
		rts
; End of function ScrollVertical


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


ScrollBlock1:				; CODE XREF: ROM:00005E74p
					; ROM:00006006p ...
		move.l	(Camera_BG_X_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(Camera_BG_X_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(Horiz_block_crossed_flag_BG).w,d3
		eor.b	d3,d1
		bne.s	loc_66EA
		eori.b	#$10,(Horiz_block_crossed_flag_BG).w
		sub.l	d2,d0
		bpl.s	loc_66E4
		bset	#2,(Scroll_flags_BG).w
		bra.s	loc_66EA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_66E4:				; CODE XREF: ScrollBlock1+24j
		bset	#3,(Scroll_flags_BG).w

loc_66EA:				; CODE XREF: ScrollBlock1+1Aj
					; ScrollBlock1+2Cj
		move.l	(Camera_BG_Y_pos).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(Camera_BG_Y_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(Verti_block_crossed_flag_BG).w,d2
		eor.b	d2,d1
		bne.s	locret_671E
		eori.b	#$10,(Verti_block_crossed_flag_BG).w
		sub.l	d3,d0
		bpl.s	loc_6718
		bset	#0,(Scroll_flags_BG).w
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6718:				; CODE XREF: ScrollBlock1+58j
		bset	#1,(Scroll_flags_BG).w

locret_671E:				; CODE XREF: ScrollBlock1+4Ej
		rts
; End of function ScrollBlock1


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


ScrollBlock2:				; CODE XREF: ROM:00006362p
		move.l	(Camera_BG_Y_pos).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(Camera_BG_Y_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(Verti_block_crossed_flag_BG).w,d2
		eor.b	d2,d1
		bne.s	locret_6752
		eori.b	#$10,(Verti_block_crossed_flag_BG).w
		sub.l	d3,d0
		bpl.s	loc_674C
		bset	d6,(Scroll_flags_BG).w
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_674C:				; CODE XREF: ScrollBlock2+24j
		addq.b	#1,d6
		bset	d6,(Scroll_flags_BG).w

locret_6752:				; CODE XREF: ScrollBlock2+1Aj
		rts
; End of function ScrollBlock2

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ScrollBlock3:
		move.w	(Camera_BG_Y_pos).w,d3
		move.w	d0,(Camera_BG_Y_pos).w
		move.w	d0,d1
		andi.w	#$10,d1
		move.b	(Verti_block_crossed_flag_BG).w,d2
		eor.b	d2,d1
		bne.s	locret_6782
		eori.b	#$10,(Verti_block_crossed_flag_BG).w
		sub.w	d3,d0
		bpl.s	loc_677C
		bset	#0,(Scroll_flags_BG).w
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_677C:				; CODE XREF: ROM:00006772j
		bset	#1,(Scroll_flags_BG).w

locret_6782:				; CODE XREF: ROM:00006768j
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


ScrollBlock4:				; CODE XREF: ROM:00006354p
		move.l	(Camera_BG_X_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(Camera_BG_X_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(Horiz_block_crossed_flag_BG).w,d3
		eor.b	d3,d1
		bne.s	locret_67B6
		eori.b	#$10,(Horiz_block_crossed_flag_BG).w
		sub.l	d2,d0
		bpl.s	loc_67B0
		bset	d6,(Scroll_flags_BG).w
		bra.s	locret_67B6
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_67B0:				; CODE XREF: ScrollBlock4+24j
		addq.b	#1,d6
		bset	d6,(Scroll_flags_BG).w

locret_67B6:				; CODE XREF: ScrollBlock4+1Aj
					; ScrollBlock4+2Aj
		rts
; End of function ScrollBlock4


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


ScrollBlock5:				; CODE XREF: ROM:00005B7Ep
					; ROM:00005C78p ...
		move.l	(Camera_BG2_X_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(Camera_BG2_X_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(Horiz_block_crossed_flag_BG2).w,d3
		eor.b	d3,d1
		bne.s	locret_67EA
		eori.b	#$10,(Horiz_block_crossed_flag_BG2).w
		sub.l	d2,d0
		bpl.s	loc_67E4
		bset	d6,(Scroll_flags_BG2).w
		bra.s	locret_67EA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_67E4:				; CODE XREF: ScrollBlock5+24j
		addq.b	#1,d6
		bset	d6,(Scroll_flags_BG2).w

locret_67EA:				; CODE XREF: ScrollBlock5+1Aj
					; ScrollBlock5+2Aj
		rts
; End of function ScrollBlock5


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


ScrollBlock6:				; CODE XREF: ROM:00005B70p
					; ROM:00005C6Ap
		move.l	(Camera_BG3_X_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(Camera_BG3_X_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(Horiz_block_crossed_flag_BG3).w,d3
		eor.b	d3,d1
		bne.s	locret_681E
		eori.b	#$10,(Horiz_block_crossed_flag_BG3).w
		sub.l	d2,d0
		bpl.s	loc_6818
		bset	d6,(Scroll_flags_BG3).w
		bra.s	locret_681E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6818:				; CODE XREF: ScrollBlock6+24j
		addq.b	#1,d6
		bset	d6,(Scroll_flags_BG3).w

locret_681E:				; CODE XREF: ScrollBlock6+1Aj
					; ScrollBlock6+2Aj
		rts
; End of function ScrollBlock6

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		lea	(VDP_control_port).l,a5
		lea	(VDP_data_port).l,a6
		lea	(Scroll_flags_BG).w,a2
		lea	(Camera_BG_X_pos).w,a3
		lea	(Level_Layout+levelrowsize).w,a4
		move.w	#$6000,d2
		bsr.w	sub_69B2
		lea	(Scroll_flags_BG2).w,a2
		lea	(Camera_BG2_X_pos).w,a3
		bra.w	sub_6A82

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


LoadTilesAsYouMove:
		lea	(VDP_control_port).l,a5
		lea	(VDP_data_port).l,a6
		; update the background
		lea	($FFFFEEA2).w,a2
		lea	($FFFFEE68).w,a3
		lea	(Level_Layout+levelrowsize).w,a4
		move.w	#$6000,d2
		bsr.w	sub_69B2
		lea	($FFFFEEA4).w,a2
		lea	($FFFFEE70).w,a3
		bsr.w	sub_6A82
		lea	($FFFFEEA6).w,a2
		lea	($FFFFEE78).w,a3
		bsr.w	sub_6B7C
		; then draw the foreground
		tst.w	(Two_player_mode).w
		beq.s	.drawPlayerOne
		lea	($FFFFEEA8).w,a2
		lea	($FFFFEE80).w,a3
		lea	(Level_Layout).w,a4
		move.w	#$6000,d2
		bsr.w	sub_694C
; loc_689E:
.drawPlayerOne:
		lea	($FFFFEEA0).w,a2
		lea	($FFFFEE60).w,a3
		lea	(Level_Layout).w,a4
		move.w	#$4000,d2
		tst.b	($FFFFF720).w
		beq.s	loc_68E6
		move.b	#0,($FFFFF720).w
		moveq	#Demo_Mode_Flag,d4
		moveq	#$F,d6
; loc_68BE:
Draw_EntireScreen:
		; redraw the entire screen; not actually used yet in this prototype
		movem.l	d4-d6,-(sp)
		moveq	#Demo_Mode_Flag,d5
		move.w	d4,d1
		bsr.w	CalculateVRAMPosition
		move.w	d1,d4
		moveq	#Demo_Mode_Flag,d5
		bsr.w	sub_6D8C		; draw the current row
		movem.l	(sp)+,d4-d6
		addi.w	#$10,d4			; move onto the next row
		dbf	d6,Draw_EntireScreen	; repeat for all rows
		move.b	#0,($FFFFEEA0).w
		rts
; ===========================================================================

loc_68E6:
		tst.b	(a2)			; are any scroll flags set?
		beq.s	locret_694A		; if not, no need to update
		bclr	#0,(a2)
		beq.s	loc_6900
		moveq	#Demo_Mode_Flag,d4
		moveq	#Demo_Mode_Flag,d5
		bsr.w	CalculateVRAMPosition
		moveq	#Demo_Mode_Flag,d4
		moveq	#Demo_Mode_Flag,d5
		bsr.w	sub_6D8C

loc_6900:				; CODE XREF: LoadTilesAsYouMove+A2j
		bclr	#1,(a2)
		beq.s	loc_691A
		move.w	#$E0,d4	; 'à'
		moveq	#Demo_Mode_Flag,d5
		bsr.w	CalculateVRAMPosition
		move.w	#$E0,d4	; 'à'
		moveq	#Demo_Mode_Flag,d5
		bsr.w	sub_6D8C

loc_691A:				; CODE XREF: LoadTilesAsYouMove+B8j
		bclr	#2,(a2)
		beq.s	loc_6930
		moveq	#Demo_Mode_Flag,d4
		moveq	#Demo_Mode_Flag,d5
		bsr.w	CalculateVRAMPosition
		moveq	#Demo_Mode_Flag,d4
		moveq	#Demo_Mode_Flag,d5
		bsr.w	sub_6CFE

loc_6930:				; CODE XREF: LoadTilesAsYouMove+D2j
		bclr	#3,(a2)
		beq.s	locret_694A
		moveq	#Demo_Mode_Flag,d4
		move.w	#$140,d5
		bsr.w	CalculateVRAMPosition
		moveq	#Demo_Mode_Flag,d4
		move.w	#$140,d5
		bsr.w	sub_6CFE

locret_694A:				; CODE XREF: LoadTilesAsYouMove+9Cj
					; LoadTilesAsYouMove+E8j
		rts
; End of function LoadTilesAsYouMove


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_694C:				; CODE XREF: LoadTilesAsYouMove+4Ep
		tst.b	(a2)
		beq.s	locret_69B0
		bclr	#0,(a2)
		beq.s	loc_6966
		moveq	#Demo_Mode_Flag,d4
		moveq	#Demo_Mode_Flag,d5
		bsr.w	CalculateVRAMPosition2
		moveq	#Demo_Mode_Flag,d4
		moveq	#Demo_Mode_Flag,d5
		bsr.w	sub_6D8C

loc_6966:				; CODE XREF: sub_694C+8j
		bclr	#1,(a2)
		beq.s	loc_6980
		move.w	#$E0,d4	; 'à'
		moveq	#Demo_Mode_Flag,d5
		bsr.w	CalculateVRAMPosition2
		move.w	#$E0,d4	; 'à'
		moveq	#Demo_Mode_Flag,d5
		bsr.w	sub_6D8C

loc_6980:				; CODE XREF: sub_694C+1Ej
		bclr	#2,(a2)
		beq.s	loc_6996
		moveq	#Demo_Mode_Flag,d4
		moveq	#Demo_Mode_Flag,d5
		bsr.w	CalculateVRAMPosition2
		moveq	#Demo_Mode_Flag,d4
		moveq	#Demo_Mode_Flag,d5
		bsr.w	sub_6CFE

loc_6996:				; CODE XREF: sub_694C+38j
		bclr	#3,(a2)
		beq.s	locret_69B0
		moveq	#Demo_Mode_Flag,d4
		move.w	#$140,d5
		bsr.w	CalculateVRAMPosition2
		moveq	#Demo_Mode_Flag,d4
		move.w	#$140,d5
		bsr.w	sub_6CFE

locret_69B0:				; CODE XREF: sub_694C+2j sub_694C+4Ej
		rts
; End of function sub_694C


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_69B2:				; CODE XREF: ROM:0000683Cp
					; LoadTilesAsYouMove+1Cp
		tst.b	(a2)
		beq.w	locret_6A80
		bclr	#0,(a2)
		beq.s	loc_69CE
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	CalculateVRAMPosition
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	sub_6D8C

loc_69CE:				; CODE XREF: sub_69B2+Aj
		bclr	#1,(a2)
		beq.s	loc_69E8
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	CalculateVRAMPosition
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	sub_6D8C

loc_69E8:				; CODE XREF: sub_69B2+20j
		bclr	#2,(a2)
		beq.s	loc_69FE
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	CalculateVRAMPosition
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	sub_6CFE

loc_69FE:				; CODE XREF: sub_69B2+3Aj
		bclr	#3,(a2)
		beq.s	loc_6A18
		moveq	#-16,d4
		move.w	#$140,d5
		bsr.w	CalculateVRAMPosition
		moveq	#-16,d4
		move.w	#$140,d5
		bsr.w	sub_6CFE

loc_6A18:				; CODE XREF: sub_69B2+50j
		bclr	#4,(a2)
		beq.s	loc_6A30
		moveq	#-16,d4
		moveq	#0,d5
		bsr.w	CalculateVRAMPosition_Absolute
		moveq	#-16,d4
		moveq	#0,d5
		moveq	#$1F,d6
		bsr.w	sub_6D90

loc_6A30:				; CODE XREF: sub_69B2+6Aj
		bclr	#5,(a2)
		beq.s	loc_6A4C
		move.w	#$E0,d4	; 'à'
		moveq	#0,d5
		bsr.w	CalculateVRAMPosition_Absolute
		move.w	#$E0,d4	; 'à'
		moveq	#0,d5
		moveq	#$1F,d6
		bsr.w	sub_6D90

loc_6A4C:				; CODE XREF: sub_69B2+82j
		bclr	#6,(a2)
		beq.s	loc_6A64
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	CalculateVRAMPosition
		moveq	#-16,d4
		moveq	#-16,d5
		moveq	#$1F,d6
		bsr.w	sub_6D84

loc_6A64:				; CODE XREF: sub_69B2+9Ej
		bclr	#7,(a2)
		beq.s	locret_6A80
		move.w	#224,d4	; 'à'
		moveq	#-16,d5
		bsr.w	CalculateVRAMPosition
		move.w	#224,d4	; 'à'
		moveq	#-16,d5
		moveq	#$1F,d6
		bsr.w	sub_6D84

locret_6A80:				; CODE XREF: sub_69B2+2j sub_69B2+B6j
		rts
; End of function sub_69B2


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6A82:				; CODE XREF: ROM:00006848j
					; LoadTilesAsYouMove+28p
		tst.b	(a2)
		beq.w	locret_6ACE
		cmpi.b	#5,(Current_Zone).w
		beq.w	loc_6AF2
		bclr	#0,(a2)
		beq.s	loc_6AAE
		move.w	#$70,d4
		moveq	#-16,d5
		bsr.w	CalculateVRAMPosition
		move.w	#$70,d4
		moveq	#-16,d5
		moveq	#2,d6
		bsr.w	sub_6D00

loc_6AAE:				; CODE XREF: sub_6A82+14j
		bclr	#1,(a2)
		beq.s	locret_6ACE
		move.w	#$70,d4
		move.w	#$140,d5
		bsr.w	CalculateVRAMPosition
		move.w	#$70,d4
		move.w	#$140,d5
		moveq	#2,d6
		bsr.w	sub_6D00

locret_6ACE:				; CODE XREF: sub_6A82+2j sub_6A82+30j
		rts
; ---------------------------------------------------------------------------
; byte_6AD0:
SBZ_CameraSections:
		dcb.b	80/16, static1		; background 1 (clouds, static)
		dcb.b	160/16, dynamic3	; background 3 (furthest buildings)
		dcb.b	112/16, dynamic2	; background 2 (closer buildings)
		dcb.b	176/16, dynamic1	; background 1 (closest buildings)
		even
; ---------------------------------------------------------------------------

loc_6AF2:				; CODE XREF: sub_6A82+Cj
		moveq	#-16,d4
		bclr	#0,(a2)
		bne.s	loc_6B04
		bclr	#1,(a2)
		beq.s	loc_6B4C
		move.w	#$E0,d4	; 'à'

loc_6B04:				; CODE XREF: sub_6A82+76j
		lea	SBZ_CameraSections+1(pc),a0
		move.w	(Camera_BG_Y_pos).w,d0
		add.w	d4,d0
		andi.w	#$1F0,d0
		lsr.w	#4,d0
		move.b	(a0,d0.w),d0
		lea	(word_6C78).l,a3
		movea.w	(a3,d0.w),a3
		beq.s	loc_6B38
		moveq	#-16,d5
		movem.l	d4-d5,-(sp)
		bsr.w	CalculateVRAMPosition
		movem.l	(sp)+,d4-d5
		bsr.w	sub_6D8C
		bra.s	loc_6B4C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6B38:				; CODE XREF: sub_6A82+A0j
		moveq	#0,d5
		movem.l	d4-d5,-(sp)
		bsr.w	CalculateVRAMPosition_Absolute
		movem.l	(sp)+,d4-d5
		moveq	#$1F,d6
		bsr.w	sub_6D90

loc_6B4C:				; CODE XREF: sub_6A82+7Cj sub_6A82+B4j
		tst.b	(a2)
		bne.s	loc_6B52
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6B52:				; CODE XREF: sub_6A82+CCj
		moveq	#-16,d4
		moveq	#-16,d5
		move.b	(a2),d0
		andi.b	#$A8,d0
		beq.s	loc_6B66
		lsr.b	#1,d0
		move.b	d0,(a2)
		move.w	#$140,d5

loc_6B66:				; CODE XREF: sub_6A82+DAj
		lea	SBZ_CameraSections(pc),a0
		move.w	(Camera_BG_Y_pos).w,d0
		andi.w	#$1F0,d0
		lsr.w	#4,d0
		lea	(a0,d0.w),a0
		bra.w	loc_6C80
; End of function sub_6A82


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6B7C:				; CODE XREF: LoadTilesAsYouMove+34p
		tst.b	(a2)
		beq.w	locret_6BC8
		cmpi.b	#2,(Current_Zone).w
		beq.w	loc_6C0C
		bclr	#0,(a2)
		beq.s	loc_6BA8
		move.w	#$40,d4	; '@'
		moveq	#-16,d5
		bsr.w	CalculateVRAMPosition
		move.w	#$40,d4	; '@'
		moveq	#-16,d5
		moveq	#2,d6
		bsr.w	sub_6D00

loc_6BA8:				; CODE XREF: sub_6B7C+14j
		bclr	#1,(a2)
		beq.s	locret_6BC8
		move.w	#$40,d4	; '@'
		move.w	#$140,d5
		bsr.w	CalculateVRAMPosition
		move.w	#$40,d4	; '@'
		move.w	#$140,d5
		moveq	#2,d6
		bsr.w	sub_6D00

locret_6BC8:				; CODE XREF: sub_6B7C+2j sub_6B7C+30j
		rts
; ---------------------------------------------------------------------------
; Each row is assigned a background camera to determine how to draw it,
; see BGCameraSections for more information
; byte_6BCA:
MZ_CameraSections:
		dcb.b	16/16, static1		; background 1 (just above the screen, static)
		dcb.b	304/16, dynamic1	; background 1 (above ground)
		dcb.b	720/16, dynamic2	; background 2 (underground)
		even
; ---------------------------------------------------------------------------

loc_6C0C:				; CODE XREF: sub_6B7C+Cj
		moveq	#-16,d4
		bclr	#0,(a2)
		bne.s	loc_6C1E
		bclr	#1,(a2)
		beq.s	loc_6C48
		move.w	#$E0,d4	; 'à'

loc_6C1E:				; CODE XREF: sub_6B7C+96j
		lea	MZ_CameraSections+1(pc),a0
		move.w	(Camera_BG_Y_pos).w,d0
		add.w	d4,d0
		andi.w	#$3F0,d0
		lsr.w	#4,d0
		move.b	(a0,d0.w),d0
		movea.w	word_6C78(pc,d0.w),a3
		moveq	#-16,d5
		movem.l	d4-d5,-(sp)
		bsr.w	CalculateVRAMPosition
		movem.l	(sp)+,d4-d5
		bsr.w	sub_6D8C

loc_6C48:				; CODE XREF: sub_6B7C+9Cj
		tst.b	(a2)
		bne.s	loc_6C4E
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6C4E:				; CODE XREF: sub_6B7C+CEj
		moveq	#-16,d4
		moveq	#-16,d5
		move.b	(a2),d0
		andi.b	#$A8,d0
		beq.s	loc_6C62
		lsr.b	#1,d0
		move.b	d0,(a2)
		move.w	#$140,d5

loc_6C62:				; CODE XREF: sub_6B7C+DCj
		lea	MZ_CameraSections(pc),a0
		move.w	(Camera_BG_Y_pos).w,d0
		andi.w	#$7F0,d0
		lsr.w	#4,d0
		lea	(a0,d0.w),a0
		bra.w	loc_6C80
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
word_6C78:	dc.w $EE68,$EE68,$EE70,$EE78; 0	; DATA XREF: sub_6A82+96o
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6C80:				; CODE XREF: sub_6A82+F6j sub_6B7C+F8j
		tst.w	(Two_player_mode).w
		bne.s	loc_6CC2
		moveq	#$F,d6
		move.l	#$800000,d7

loc_6C8E:				; CODE XREF: sub_6B7C+13Ej
		moveq	#0,d0
		move.b	(a0)+,d0
		btst	d0,(a2)
		beq.s	loc_6CB6
		movea.w	word_6C78(pc,d0.w),a3
		movem.l	d4-d5/a0,-(sp)
		movem.l	d4-d5,-(sp)
		bsr.w	sub_7040
		movem.l	(sp)+,d4-d5
		bsr.w	CalculateVRAMPosition
		bsr.w	sub_6F70
		movem.l	(sp)+,d4-d5/a0

loc_6CB6:				; CODE XREF: sub_6B7C+118j
		addi.w	#$10,d4
		dbf	d6,loc_6C8E
		clr.b	(a2)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6CC2:				; CODE XREF: sub_6B7C+108j
		moveq	#$F,d6
		move.l	#$800000,d7

loc_6CCA:				; CODE XREF: sub_6B7C+17Aj
		moveq	#0,d0
		move.b	(a0)+,d0
		btst	d0,(a2)
		beq.s	loc_6CF2
		movea.w	word_6C78(pc,d0.w),a3
		movem.l	d4-d5/a0,-(sp)
		movem.l	d4-d5,-(sp)
		bsr.w	sub_7040
		movem.l	(sp)+,d4-d5
		bsr.w	CalculateVRAMPosition
		bsr.w	sub_6FF6
		movem.l	(sp)+,d4-d5/a0

loc_6CF2:				; CODE XREF: sub_6B7C+154j
		addi.w	#$10,d4
		dbf	d6,loc_6CCA
		clr.b	(a2)
		rts
; End of function sub_6B7C


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6CFE:				; CODE XREF: LoadTilesAsYouMove+E0p
					; LoadTilesAsYouMove+FAp ...
		moveq	#$F,d6
; End of function sub_6CFE


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6D00:				; CODE XREF: sub_6A82+28p sub_6A82+48p ...
		add.w	(a3),d5
		add.w	4(a3),d4
		move.l	#$800000,d7
		move.l	d0,d1
		bsr.w	sub_6E98
		tst.w	(Two_player_mode).w
		bne.s	loc_6D4E

loc_6D18:				; CODE XREF: sub_6D00:loc_6D48j
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		lea	(Block_Table).w,a1
		adda.w	d3,a1
		move.l	d1,d0
		bsr.w	sub_6F70
		adda.w	#$10,a0
		addi.w	#$100,d1
		andi.w	#$FFF,d1
		addi.w	#$10,d4
		move.w	d4,d0
		andi.w	#$70,d0	; 'p'
		bne.s	loc_6D48
		bsr.w	sub_6E98

loc_6D48:				; CODE XREF: sub_6D00+42j
		dbf	d6,loc_6D18
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6D4E:				; CODE XREF: sub_6D00+16j
					; sub_6D00:loc_6D7Ej
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		lea	(Block_Table).w,a1
		adda.w	d3,a1
		move.l	d1,d0
		bsr.w	sub_6FF6
		adda.w	#$10,a0
		addi.w	#$80,d1	; '€'
		andi.w	#$FFF,d1
		addi.w	#$10,d4
		move.w	d4,d0
		andi.w	#$70,d0	; 'p'
		bne.s	loc_6D7E
		bsr.w	sub_6E98

loc_6D7E:				; CODE XREF: sub_6D00+78j
		dbf	d6,loc_6D4E
		rts
; End of function sub_6D00


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6D84:				; CODE XREF: sub_69B2+AEp sub_69B2+CAp ...
		add.w	(a3),d5
		add.w	4(a3),d4
		bra.s	loc_6D94
; End of function sub_6D84


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6D8C:				; CODE XREF: LoadTilesAsYouMove+82p
					; LoadTilesAsYouMove+B0p ...
		moveq	#$15,d6
		add.w	(a3),d5
; End of function sub_6D8C


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6D90:				; CODE XREF: sub_69B2+7Ap sub_69B2+96p ...
		add.w	4(a3),d4

loc_6D94:				; CODE XREF: sub_6D84+6j
		tst.w	(Two_player_mode).w
		bne.s	loc_6E12
		move.l	a2,-(sp)
		move.w	d6,-(sp)
		lea	($FFFFEF00).w,a2
		move.l	d0,d1
		or.w	d2,d1
		swap	d1
		move.l	d1,-(sp)
		move.l	d1,(a5)
		swap	d1
		bsr.w	sub_6E98

loc_6DB2:				; CODE XREF: sub_6D90:loc_6DE4j
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		lea	(Block_Table).w,a1
		adda.w	d3,a1
		bsr.w	sub_6ED0
		addq.w	#2,a0
		addq.b	#4,d1
		bpl.s	loc_6DD4
		andi.b	#$7F,d1	; ''
		swap	d1
		move.l	d1,(a5)
		swap	d1

loc_6DD4:				; CODE XREF: sub_6D90+38j
		addi.w	#$10,d5
		move.w	d5,d0
		andi.w	#$70,d0	; 'p'
		bne.s	loc_6DE4
		bsr.w	sub_6E98

loc_6DE4:				; CODE XREF: sub_6D90+4Ej
		dbf	d6,loc_6DB2
		move.l	(sp)+,d1
		addi.l	#$800000,d1
		lea	($FFFFEF00).w,a2
		move.l	d1,(a5)
		swap	d1
		move.w	(sp)+,d6

loc_6DFA:				; CODE XREF: sub_6D90:loc_6E0Aj
		move.l	(a2)+,(a6)
		addq.b	#4,d1
		bmi.s	loc_6E0A
		ori.b	#$80,d1
		swap	d1
		move.l	d1,(a5)
		swap	d1

loc_6E0A:				; CODE XREF: sub_6D90+6Ej
		dbf	d6,loc_6DFA
		movea.l	(sp)+,a2
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6E12:				; CODE XREF: sub_6D90+8j
		move.l	d0,d1
		or.w	d2,d1
		swap	d1
		move.l	d1,(a5)
		swap	d1
		tst.b	d1
		bmi.s	loc_6E5C
		bsr.w	sub_6E98

loc_6E24:				; CODE XREF: sub_6D90:loc_6E56j
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		lea	(Block_Table).w,a1
		adda.w	d3,a1
		bsr.w	sub_6F32
		addq.w	#2,a0
		addq.b	#4,d1
		bpl.s	loc_6E46
		andi.b	#$7F,d1	; ''
		swap	d1
		move.l	d1,(a5)
		swap	d1

loc_6E46:				; CODE XREF: sub_6D90+AAj
		addi.w	#$10,d5
		move.w	d5,d0
		andi.w	#$70,d0	; 'p'
		bne.s	loc_6E56
		bsr.w	sub_6E98

loc_6E56:				; CODE XREF: sub_6D90+C0j
		dbf	d6,loc_6E24
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6E5C:				; CODE XREF: sub_6D90+8Ej
		bsr.w	sub_6E98

loc_6E60:				; CODE XREF: sub_6D90:loc_6E92j
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		lea	(Block_Table).w,a1
		adda.w	d3,a1
		bsr.w	sub_6F32
		addq.w	#2,a0
		addq.b	#4,d1
		bmi.s	loc_6E82
		ori.b	#$80,d1
		swap	d1
		move.l	d1,(a5)
		swap	d1

loc_6E82:				; CODE XREF: sub_6D90+E6j
		addi.w	#$10,d5
		move.w	d5,d0
		andi.w	#$70,d0	; 'p'
		bne.s	loc_6E92
		bsr.w	sub_6E98

loc_6E92:				; CODE XREF: sub_6D90+FCj
		dbf	d6,loc_6E60
		rts
; End of function sub_6D90


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6E98:				; CODE XREF: sub_6D00+Ep sub_6D00+44p	...
		movem.l	d4-d5,-(sp)
		move.w	d4,d3
		add.w	d3,d3
		andi.w	#$F00,d3
		lsr.w	#3,d5
		move.w	d5,d0
		lsr.w	#4,d0
		andi.w	#$7F,d0	; ''
		add.w	d3,d0
		moveq	#$FFFFFFFF,d3
		move.b	(a4,d0.w),d3
		andi.w	#$FF,d3
		lsl.w	#7,d3
		andi.w	#$70,d4	; 'p'
		andi.w	#$E,d5
		add.w	d4,d3
		add.w	d5,d3
		movea.l	d3,a0
		movem.l	(sp)+,d4-d5
		rts
; End of function sub_6E98


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6ED0:				; CODE XREF: sub_6D90+30p
		btst	#3,(a0)
		bne.s	loc_6EFC
		btst	#2,(a0)
		bne.s	loc_6EE2
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a2)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6EE2:				; CODE XREF: sub_6ED0+Aj
		move.l	(a1)+,d3
		eori.l	#$8000800,d3
		swap	d3
		move.l	d3,(a6)
		move.l	(a1)+,d3
		eori.l	#$8000800,d3
		swap	d3
		move.l	d3,(a2)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6EFC:				; CODE XREF: sub_6ED0+4j
		btst	#2,(a0)
		bne.s	loc_6F18
		move.l	(a1)+,d0
		move.l	(a1)+,d3
		eori.l	#$10001000,d3
		move.l	d3,(a6)
		eori.l	#$10001000,d0
		move.l	d0,(a2)+
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6F18:				; CODE XREF: sub_6ED0+30j
		move.l	(a1)+,d0
		move.l	(a1)+,d3
		eori.l	#$18001800,d3
		swap	d3
		move.l	d3,(a6)
		eori.l	#$18001800,d0
		swap	d0
		move.l	d0,(a2)+
		rts
; End of function sub_6ED0


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6F32:				; CODE XREF: sub_6D90+A2p sub_6D90+DEp
		btst	#3,(a0)
		bne.s	loc_6F50
		btst	#2,(a0)
		bne.s	loc_6F42
		move.l	(a1)+,(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6F42:				; CODE XREF: sub_6F32+Aj
		move.l	(a1)+,d3
		eori.l	#$8000800,d3
		swap	d3
		move.l	d3,(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6F50:				; CODE XREF: sub_6F32+4j
		btst	#2,(a0)
		bne.s	loc_6F62
		move.l	(a1)+,d3
		eori.l	#$10001000,d3
		move.l	d3,(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6F62:				; CODE XREF: sub_6F32+22j
		move.l	(a1)+,d3
		eori.l	#$18001800,d3
		swap	d3
		move.l	d3,(a6)
		rts
; End of function sub_6F32


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6F70:				; CODE XREF: sub_6B7C+132p
					; sub_6D00+28p
		or.w	d2,d0
		swap	d0
		btst	#3,(a0)
		bne.s	loc_6FAC
		btst	#2,(a0)
		bne.s	loc_6F8C
		move.l	d0,(a5)
		move.l	(a1)+,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.l	(a1)+,(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6F8C:				; CODE XREF: sub_6F70+Ej
		move.l	d0,(a5)
		move.l	(a1)+,d3
		eori.l	#$8000800,d3
		swap	d3
		move.l	d3,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.l	(a1)+,d3
		eori.l	#$8000800,d3
		swap	d3
		move.l	d3,(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6FAC:				; CODE XREF: sub_6F70+8j
		btst	#2,(a0)
		bne.s	loc_6FD2
		move.l	d5,-(sp)
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d3
		eori.l	#$10001000,d3
		move.l	d3,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$10001000,d5
		move.l	d5,(a6)
		move.l	(sp)+,d5
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_6FD2:				; CODE XREF: sub_6F70+40j
		move.l	d5,-(sp)
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d3
		eori.l	#$18001800,d3
		swap	d3
		move.l	d3,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$18001800,d5
		swap	d5
		move.l	d5,(a6)
		move.l	(sp)+,d5
		rts
; End of function sub_6F70


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_6FF6:				; CODE XREF: sub_6B7C+16Ep
					; sub_6D00+5Ep
		or.w	d2,d0
		swap	d0
		btst	#3,(a0)
		bne.s	loc_701C
		btst	#2,(a0)
		bne.s	loc_700C
		move.l	d0,(a5)
		move.l	(a1)+,(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_700C:				; CODE XREF: sub_6FF6+Ej
		move.l	d0,(a5)
		move.l	(a1)+,d3
		eori.l	#$8000800,d3
		swap	d3
		move.l	d3,(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_701C:				; CODE XREF: sub_6FF6+8j
		btst	#2,(a0)
		bne.s	loc_7030
		move.l	d0,(a5)
		move.l	(a1)+,d3
		eori.l	#$10001000,d3
		move.l	d3,(a6)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_7030:				; CODE XREF: sub_6FF6+2Aj
		move.l	d0,(a5)
		move.l	(a1)+,d3
		eori.l	#$18001800,d3
		swap	d3
		move.l	d3,(a6)
		rts
; End of function sub_6FF6


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_7040:				; CODE XREF: sub_6B7C+126p
					; sub_6B7C+162p
		add.w	(a3),d5
		add.w	4(a3),d4
		lea	(Block_Table).w,a1
		move.w	d4,d3
		add.w	d3,d3
		andi.w	#$F00,d3
		lsr.w	#3,d5
		move.w	d5,d0
		lsr.w	#4,d0
		andi.w	#$7F,d0	; ''
		add.w	d3,d0
		moveq	#$FFFFFFFF,d3
		move.b	(a4,d0.w),d3
		andi.w	#$FF,d3
		lsl.w	#7,d3
		andi.w	#$70,d4	; 'p'
		andi.w	#$E,d5
		add.w	d4,d3
		add.w	d5,d3
		movea.l	d3,a0
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		adda.w	d3,a1
		rts
; End of function sub_7040


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
; sub_7084:
CalculateVRAMPosition:
		add.w	(a3),d5
; sub_7086:
CalculateVRAMPosition_Absolute:
		tst.w	(Two_player_mode).w
		bne.s	CalculateVRAMPosition_TwoPlayer
		add.w	4(a3),d4
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#3,d0
		swap	d0
		move.w	d4,d0
		rts
; ===========================================================================
; loc_70A6:
CalculateVRAMPosition_TwoPlayer:
		add.w	4(a3),d4
		andi.w	#$1F0,d4
		andi.w	#$1F0,d5
		lsl.w	#3,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#3,d0
		swap	d0
		move.w	d4,d0
		rts
; End of function CalculateVRAMPosition


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
; sub_70C0:
CalculateVRAMPosition2:
		tst.w	(Two_player_mode).w
		bne.s	CalculateVRAMPosition2_PlayerTwo
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#2,d0
		swap	d0
		move.w	d4,d0
		rts
; ===========================================================================
; In Sonic 1, this was unused but was part of an abandoned set of functions
; that would effectively create a third scrolling layer (at the cost of the
; background appearing cut-off at the bottom), similar to one that was seen
; in the Tokyo Toy Show '90 demo
;
; Now, it is instead used to draw player two's screen in interlaced mode
; loc_70E2:
CalculateVRAMPosition2_PlayerTwo:
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$1F0,d4
		andi.w	#$1F0,d5
		lsl.w	#3,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#2,d0
		swap	d0
		move.w	d4,d0
		rts
; End of function CalculateVRAMPosition2

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load the level's initial state into VRAM; the final game
; would considerably cut down on this, instead just loading the background
; while the foreground is loaded in DrawLevelTitleCard
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


LoadTilesFromStart:
		lea	(VDP_control_port).l,a5
		lea	(VDP_data_port).l,a6
		tst.w	(Two_player_mode).w	; is this two player mode?
		beq.s	loc_711E		; if not, branch
		lea	(Camera_X_pos_P2).w,a3
		lea	(Level_Layout).w,a4
		move.w	#$6000,d2
		bsr.s	LoadTilesFromStart_2p

loc_711E:
		lea	(Camera_X_pos).w,a3
		lea	(Level_Layout).w,a4
		move.w	#$4000,d2
		bsr.s	LoadTilesFromStart2
		lea	(Camera_BG_X_pos).w,a3
		lea	(Level_Layout+levelrowsize).w,a4
		move.w	#$6000,d2
		tst.b	(Current_Zone).w
		beq.w	DrawBackground_GHZ

LoadTilesFromStart2:
		moveq	#-16,d4
		moveq	#256/16-1,d6

loc_7144:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	CalculateVRAMPosition
		move.w	d1,d4
		moveq	#0,d5
		moveq	#512/16-1,d6
		move	#$2700,sr
		bsr.w	sub_6D84
		move	#$2300,sr
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,loc_7144
		rts
; ---------------------------------------------------------------------------
; This is still in the final game, unused
LoadTilesFromStart_2p:
		moveq	#-16,d4
		moveq	#256/16-1,d6

loc_7174:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	CalculateVRAMPosition2
		move.w	d1,d4
		moveq	#0,d5
		moveq	#512/16-1,d6
		move	#$2700,sr
		bsr.w	sub_6D84
		move	#$2300,sr
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,loc_7174
		rts
; End of function LoadTilesFromStart

; ===========================================================================
; ---------------------------------------------------------------------------
; Stage-specific background drawing routines
; Green Hill Zone
; ---------------------------------------------------------------------------
; loc_71A0:
DrawBackground_GHZ:
		moveq	#0,d4		; start drawing at the top of the screen
		moveq	#$F,d6		; 16 blocks per column
; loc_71A4:
.drawRow:
		movem.l	d4-d6,-(sp)
		lea	(GHZ_CameraSections).l,a0
		move.w	(Camera_BG_Y_pos).w,d0
		add.w	d4,d0
		andi.w	#$F0,d0
		bsr.w	Draw_BackgroundRow
		movem.l	(sp)+,d4-d6
		; after we finish drawing the current row, head down to the next one
		addi.w	#16,d4
		dbf	d6,.drawRow
		rts
; ---------------------------------------------------------------------------
; Each row is assigned a background camera to determine how to draw it,
; see BGCameraSections for more information
; byte_71CA:
GHZ_CameraSections:
		dcb.b	64/16, static1		; background 1 (clouds, static)
		dcb.b	48/16, dynamic3		; background 3 (mountains)
		dcb.b	48/16, dynamic2		; background 2 (hills/bushes)
		dcb.b	96/16, static1		; background 1 (water, static)
; End of function DrawBackground_GHZ

; ---------------------------------------------------------------------------
; Marble Zone
; ---------------------------------------------------------------------------
; loc_71DA:
DrawBackground_MZ:
		moveq	#-16,d4		; start drawing just above the top of the screen
		moveq	#$F,d6		; 16 blocks per column

loc_71DE:
		movem.l	d4-d6,-(sp)
		lea	MZ_CameraSections+1(pc),a0
		move.w	(Camera_BG_Y_pos).w,d0
		add.w	d4,d0
		andi.w	#$3F0,d0
		bsr.w	Draw_BackgroundRow
		movem.l	(sp)+,d4-d6
		; after we finish drawing the current row, head down to the next one
		addi.w	#16,d4
		dbf	d6,loc_71DE
		rts
; End of function DrawBackground_MZ

; ---------------------------------------------------------------------------
; Scrap Brain Zone
; ---------------------------------------------------------------------------
; loc_7200:
DrawBackground_SBZ:
		moveq	#-16,d4		; start drawing just above the top of the screen
		moveq	#$F,d6		; 16 blocks per column

loc_7206:
		movem.l	d4-d6,-(sp)
		lea	SBZ_CameraSections+1(pc),a0
		move.w	(Camera_BG_Y_pos).w,d0
		add.w	d4,d0
		andi.w	#$1F0,d0
		bsr.w	Draw_BackgroundRow
		movem.l	(sp)+,d4-d6
		; after we finish drawing the current row, head down to the next one
		addi.w	#16,d4
		dbf	d6,loc_7206
		rts
; End of function DrawBackground_MZ

; ===========================================================================
; This is a lookup table which the game uses to know what background the
; block rows should update their tiles relative to, allowing for larger
; backgrounds than normally possib.e
; word_722A:
BGCameraSections:
		dc.w Camera_BG_X_pos		; Background A (static)
		dc.w Camera_BG_X_pos		; Background A (dynamic)
		dc.w Camera_BG2_X_pos		; Background B (dynamic)
		dc.w Camera_BG3_X_pos		; Background C (dynamic)

; ---------------------------------------------------------------------------
; Subroutine to draw background block rows depending on the camera type
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7232:
Draw_BackgroundRow:
		lsr.w	#4,d0
		move.b	(a0,d0.w),d0
		movea.w	BGCameraSections(pc,d0.w),a3	; get camera type
		beq.s	.staticRow		; if it's staic, branch

		moveq	#-16,d5			; start drawing a row of blocks
		movem.l	d4-d5,-(sp)
		bsr.w	CalculateVRAMPosition
		movem.l	(sp)+,d4-d5
		move	#$2700,sr
		bsr.w	sub_6D8C
		move	#$2300,sr
		rts
; ---------------------------------------------------------------------------
; loc_725A:
.staticRow:
		moveq	#0,d5			; draw a static row of blocks
		movem.l	d4-d5,-(sp)
		bsr.w	CalculateVRAMPosition_Absolute
		movem.l	(sp)+,d4-d5
		moveq	#$1F,d6
		bsr.w	sub_6D90
		rts
; End of function Draw_BackgroundRow


; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load blocks, chunks, PLCs, and tiles for the current zone
; ---------------------------------------------------------------------------

MainLevelLoadBlock:
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		lsl.w	#4,d0
		lea	(LevelArtPointers).l,a2
		lea	(a2,d0.w),a2

		movea.l	(a2)+,a0		; Source
		lea	(Block_Table).w,a1	; Destination
		move.w	#0,d0			; Art start
		bsr.w	EniDec			; Decompress Blocks

		tst.w	(Two_player_mode).w	; Check for 2 Player mode
		beq.s	@notTwoPlayer		; if 1 Player mode, branch

		lea	(Block_Table).w,a1
		move.w	#(Block_Table_End-Block_Table)/2-1,d2
	@ConvertToInterlacedMode:	; Convert 16x16 map format to work with Interlaced mode
		move.w	(a1),d0

		move.w	d0,d1
		andi.w	#$F800,d0
		andi.w	#$7FF,d1
		lsr.w	#1,d1
		or.w	d1,d0

		move.w	d0,(a1)+
		dbf	d2,@ConvertToInterlacedMode
	@notTwoPlayer:
; loc_72F4:
.loadChunks:	; Uncompressed Level layouts
		movea.l	(a2)+,a0
		lea	(Chunk_Table).l,a1
		move.w	#(Chunk_Table_End-Chunk_Table)/4-1,d0
; loc_7342:
.uncompressedLoop3:
		move.l	(a0)+,(a1)+
		dbf	d0,.uncompressedLoop3
; loc_7348:
.loadLevelAndPalette:
		bsr.w	LevelLayoutLoad
		move.b	(a2),d0
		move.l	(a2)+,a1

		moveq	#0,d1
		move.b	(Current_Act).w,d1
		lsl.b	#5,d1
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		add.l	d1,a1

		tst.b	d0
		beq	@NoWater
			add.w	d2,d1
			add.l	d1,a1
			lea	Water_target_palette,a0
			lea	Water_palette,a3
			moveq	#(Water_palette_line2-Water_palette)/4-1,d0
			@WPaletteLoad:
				move.l	(a1),(a3)+
				move.l	(a1)+,(a0)+
				dbf	d0,@WPaletteLoad
			moveq	#(Water_palette_End-Water_palette_line2)/4-1,d0
			@WPaletteLoad2:
				move.l	(a1)+,(a0)+
				dbf	d0,@WPaletteLoad2

			st	(Water_flag).w	; set water flag
			move.w	(Hint_counter_reserve).w,(VDP_Control_Port).l
			move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
			move.w	#$8014,(VDP_Control_Port).l

			moveq	#0,d0
			move.b	(Current_Zone).w,d0
			lsl.w	#3,d0	; 8
			move.b	(Current_Act).w,d1
			add.b	d1,d1
			add.b	d1,d0
			lea	(WaterHeight).l,a0
			move.w	(a0,d0.w),d0

			move.w	d0,(Water_Level_1).w
			move.w	d0,(Water_Level_2).w
			move.w	d0,(Water_Level_3).w
			clr.w	(Water_routine).w
			clr.b	(Water_fullscreen_flag).w
			tst.b	(Last_LampPost_hit).w	; checkpoint
			beq.s	@NoWater
			move.b	($FFFFFE53).w,(Water_fullscreen_flag).w
	@NoWater:
		lea	Target_palette_line2,a0
		moveq	#(Normal_palette_End-Normal_palette_line2)/4-1,d0
		@PaletteLoad:
			move.l	(a1)+,(a0)+
			dbf	d0,@PaletteLoad
		move.w	(a2),d0
		beq.s	@DoNothing
		bsr.w	LoadPLC
	@DoNothing:
		rts
; End of function MainLevelLoadBlock

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load a level layout from RAM
;
; Unlike Sonic 1, this is programmed to repeat level rows until it fills up
; all of $FF8000 to $FF9000, mainly used to repeat backgrounds without having
; it bloating the ROM (the final game doesn't do this)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


LevelLayoutLoad:
		lea	(Level_Layout).w,a3
		move.w	#(Level_Layout_End-Level_Layout)/4-1,d1
		moveq	#0,d0

loc_738E:
		move.l	d0,(a3)+
		dbf	d1,loc_738E		; fill $8000-$8FFF with 0

		; interlace the foreground and background data for every row
		lea	(Level_Layout).w,a3
		moveq	#0,d1
		bsr.w	LevelLayoutLoad2
		lea	(Level_Layout+levelrowsize).w,a3
		moveq	#2,d1

LevelLayoutLoad2:
		move.w	(Current_ZoneAndAct).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0
		add.w	d1,d0
		lea	(Level_Index).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.l),a1

		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1	; load level width (in tiles)
		move.b	(a1)+,d2	; load level height (in tiles)
		move.l	d1,d5
		addq.l	#1,d5
		moveq	#0,d3
		move.w	#levelrowsize,d3	; size of each row in memory (128 chunks)
		divu.w	d5,d3		; repeat each 'source row' until the 'destination row' is filled
		subq.w	#1,d3

loc_73DE:
		movea.l	a3,a0
		move.w	d3,d4

loc_73E2:
		move.l	a1,-(sp)
		move.w	d1,d0

loc_73E6:
		move.b	(a1)+,(a0)+
		dbf	d0,loc_73E6
		movea.l	(sp)+,a1
		dbf	d4,loc_73E2
		lea	(a1,d5.w),a1
		lea	levelrowsize*2(a3),a3
		dbf	d2,loc_73DE
		rts
; End of function LevelLayoutLoad

	include	"Level\Dynamic Level Events.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; This runs the code of all the objects that are in Object_Space
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; ObjectsLoad:
RunObjects:
		lea	(Object_Space).w,a0
		moveq	#128-1,d7	; run through the object list
		moveq	#0,d0
		cmpi.b	#6,routine(a0)	; is Player 1 dead?
		bcc.s	RunObjectsWhenPlayerIsDead	; if yes, branch

; ---------------------------------------------------------------------------
; This is THE place where each individual object's code gets called from
; ---------------------------------------------------------------------------
RunObject:
		move.b	(a0),d0		; get the object's ID
		beq.s	@EmptySlot	; if it's obj00, skip it
		add.w	d0,d0
		add.w	d0,d0		; d0 = object ID * 4
		movea.l	Obj_Index-4(pc,d0.w),a1	; load the address of the object's code
		jsr	(a1)		; dynamic call! to one of the the entries in Obj_Index
		moveq	#0,d0

	@EmptySlot:
		lea	Object_RAM(a0),a0	; load obj address
		dbf	d7,RunObject
		rts
; ---------------------------------------------------------------------------
; this skips certain objects to make enemies and things pause when Sonic dies
; loc_CB5E:
RunObjectsWhenPlayerIsDead:
		moveq	#32-1,d7
		bsr.s	RunObject
		moveq	#128-32-1,d7

RunObjectsDisplayOnly:
		moveq	#0,d0
		move.b	(a0),d0		; get the object's ID
		beq.s	loc_CB74	; if it's obj00, skip it
		tst.b	render_flags(a0)	; should we render it?
		bpl.s	loc_CB74	; if not, skip it
		bsr.w	DisplaySprite

loc_CB74:
		lea	Object_RAM(a0),a0	; load obj address
		dbf	d7,RunObjectsDisplayOnly
		rts
; End of function RunObjects

; ===========================================================================

	Include	"Objects\ObjectTable.asm"

; ---------------------------------------------------------------------------
; Subroutine to make an object move and fall downward increasingly fast
; This moves the object horizontally and vertically
; and also applies gravity to its speed
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; ObjectFall:
ObjectMoveAndFall:
		move.l	x_pos(a0),d2	; load x position
		move.l	y_pos(a0),d3	; load y position
		move.w	x_vel(a0),d0	; load x speed
		ext.l	d0
		asl.l	#8,d0		; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,d2		; add x speed to x position
		move.w	y_vel(a0),d0	; load y speed
		addi.w	#$38,y_vel(a0)	; increase vertical speed (apply gravity)
		ext.l	d0
		asl.l	#8,d0		; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,d3		; add old y speed to y position
		move.l	d2,x_pos(a0)	; store new x position
		move.l	d3,y_pos(a0)	; store new y position
		rts
; End of function ObjectMoveAndFall

; ---------------------------------------------------------------------------
; Subroutine translating object speed to update object position
; This moves the object horizontally and vertically
; but does not apply gravity to it
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; SpeedToPos:
ObjectMove:
		move.l	x_pos(a0),d2	; load x position
		move.l	y_pos(a0),d3	; load y position
		move.w	x_vel(a0),d0	; load x speed
		ext.l	d0
		asl.l	#8,d0		; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,d2		; add x speed to x position
		move.w	y_vel(a0),d0	; load y speed
		ext.l	d0
		asl.l	#8,d0		; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,d3		; add old y speed to y position
		move.l	d2,x_pos(a0)	; store new x position
		move.l	d3,y_pos(a0)	; store new y position
		rts
; End of function ObjectMove

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


DisplaySprite:
		lea	(Sprite_Input_Table).w,a1
		move.w	priority(a0),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		adda.w	d0,a1
		cmpi.w	#$7E,(a1)
		bcc.s	@DoNothing
		addq.w	#2,(a1)
		adda.w	(a1),a1
		move.w	a0,(a1)
	@DoNothing:
		rts
; End of function DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a1 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; DisplayA1Sprite:
DisplayChild:
DisplaySprite2:
		lea	(Sprite_Input_Table).w,a2
		move.w	priority(a1),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		adda.w	d0,a2
		cmpi.w	#$7E,(a2)
		bcc.s	@DoNothing
		addq.w	#2,(a2)
		adda.w	(a2),a2
		move.w	a1,(a2)
	@DoNothing:
		rts
; End of function DisplaySprite2

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; Used by Objects that use the Subsprite System, where Priority is set via d0
; 
; input : d0 = (priority<<7)&$380
; ---------------------------------------------------------------------------

; DisplaySprite_Param:
DisplaySpriteSub:
		lea	(Sprite_Input_Table).w,a1
		adda.w	d0,a1
		cmpi.w	#$7E,(a1)
		bhs.s	@DoNothing
		addq.w	#2,(a1)
		adda.w	(a1),a1
		move.w	a0,(a1)
	@DoNothing:
		rts
; End of function DisplaySpriteSub

; ===========================================================================
; ---------------------------------------------------------------------------
; Routines to mark an enemy/monitor/ring/platform as destroyed
; a0 = the object
; ---------------------------------------------------------------------------

MarkObjGone:
		tst.w	(Two_player_mode).w
		beq.s	loc_CE64
		bra.w	DisplaySprite	; Don't do anything in 2 Player
; ---------------------------------------------------------------------------

loc_CE64:
		out_of_range	loc_CE7C
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_CE7C:
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		beq.s	loc_CE8E
		bclr	#7,2(a2,d0.w)

loc_CE8E:
		bra.w	DeleteObject
; ===========================================================================
; does nothing instead of calling DisplaySprite in the case of no deletion
; loc_CE92:
MarkObjGone2:
		tst.w	(Two_player_mode).w
		beq.s	loc_CE9A
		rts	; Don't do anything in 2 Player
; ---------------------------------------------------------------------------

loc_CE9A:
		out_of_range	loc_CEB0
		rts
; ---------------------------------------------------------------------------

loc_CEB0:
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		beq.s	loc_CEC2
		bclr	#7,2(a2,d0.w)

loc_CEC2:
		bra.w	DeleteObject
; ===========================================================================
; Check offscreen Remember state object
; loc_CEC6:
MarkObjGone_P1:
		tst.w	(Two_player_mode).w
		bne.s	MarkObjGone_P2
		out_of_range	loc_CF24
		bra.w	DisplaySprite
; ===========================================================================
; Check offscreen Remember state object in two player mode
; loc_CEFA:
MarkObjGone_P2:
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		move.w	d0,d1
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#320/2,d0
		bhi.s	loc_CF14
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_CF14:
		sub.w	(Camera_X_pos_coarse_P2).w,d1
		cmpi.w	#320/2,d1
		bhi.s	loc_CF24
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_CF24:
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		beq.s	loc_CF36
		bclr	#7,2(a2,d0.w)

loc_CF36:
	;	bra.w	DeleteObject	; useless branch...

; ---------------------------------------------------------------------------
; Subroutine to delete an object
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


DeleteObject:
		movea.l	a0,a1
; sub_CF3C:
DeleteChild:
DeleteObject2:
		moveq	#0,d1
		moveq	#Object_RAM/4-1,d0	; we want to clear up to the next object
		; delete the object by setting all of its bytes to 0
	@Loop:
		move.l	d1,(a1)+
		dbf	d0,@Loop
		rts
; End of function DeleteObject

; ---------------------------------------------------------------------------
; Subroutine to animate a sprite using an animation script
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


AnimateSprite:
		moveq	#0,d0
		move.b	anim(a0),d0	; move animation number to d0
		cmp.b	prev_anim(a0),d0	; is animation set to change?
		beq.s	Anim_Run	; if not, branch
		move.b	d0,prev_anim(a0)	; set previous animation to current one
		move.b	#0,anim_frame(a0)	; reset animation
		move.b	#0,anim_frame_duration(a0)	; reset frame duration
; loc_CF64:
Anim_Run:
		subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
		bpl.s	Anim_Wait	; if time remains, branch
		add.w	d0,d0
		adda.w	(a1,d0.w),a1	; calculate address of appropriate animation script
		move.b	(a1),anim_frame_duration(a0)	; load frame duration
		moveq	#0,d1
		move.b	anim_frame(a0),d1	; load current frame number
		move.b	1(a1,d1.w),d0	; read sprite number from script
		bmi.s	Anim_End_FF	; if animation is complete, branch
; loc_CF80:
Anim_Next:
		move.b	d0,d1		; move animation number to current frame number
		andi.b	#$1F,d0
		move.b	d0,mapping_frame(a0)	; load sprite number
		move.b	status(a0),d0	; match the orientation dictated by the object
		rol.b	#3,d1		; with the orientation used by the object engine
		eor.b	d0,d1
		andi.b	#3,d1
		andi.b	#$FC,render_flags(a0)
		or.b	d1,render_flags(a0)
		addq.b	#1,anim_frame(a0)	; next frame number
; locret_CFA4:
Anim_Wait:
		rts
; ===========================================================================
; loc_CFA6:
Anim_End_FF:
		addq.b	#1,d0		; is the end flag = $FF ?
		bne.s	Anim_End_FE	; if not, branch
		move.b	#0,anim_frame(a0)	; restart the animation
		move.b	1(a1),d0	; read sprite number
		bra.s	Anim_Next
; ===========================================================================
; loc_CFB6:
Anim_End_FE:
		addq.b	#1,d0		; is the end flag = $FE ?
		bne.s	Anim_End_FD	; if not, branch
		move.b	2(a1,d1.w),d0	; read the next byte in the script
		sub.b	d0,anim_frame(a0)	; jump back d0 bytes in the script
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0	; read sprite number
		bra.s	Anim_Next
; ===========================================================================
; loc_CFCA:
Anim_End_FD:
		addq.b	#1,d0		; is the end flag = $FD ?
		bne.s	Anim_End_FC	; if not, branch
		move.b	2(a1,d1.w),anim(a0)	; read next byte, run that animation
		rts
; ===========================================================================
; loc_CFD6:
Anim_End_FC:
		addq.b	#1,d0		; is the end flag = $FC ?
		bne.s	Anim_End_FB	; if not, branch
		addq.b	#2,routine(a0)	; jump to next routine
		rts
; ===========================================================================
; loc_CFE0:
Anim_End_FB:
		addq.b	#1,d0		; is the end flag = $FB ?
		bne.s	Anim_End_FA	; if not, branch
		move.b	#0,anim_frame(a0)	; reset animation
		clr.b	routine_secondary(a0)		; reset 2nd routine counter
		rts
; ===========================================================================
; loc_CFF0:
Anim_End_FA:
		addq.b	#1,d0		; is the end flag = $FA ?
		bne.s	Anim_End	; if not, branch
		addq.b	#2,routine_secondary(a0)	; jump to next routine
		rts
; ===========================================================================
; locret_CFFA:
Anim_End:
		rts
; End of function AnimateSprite
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; adjust art pointer of object at a0 for 2-player mode
; ModifySpriteAttr_2P:
Adjust2PArtPointer:
		tst.w	(Two_player_mode).w
		beq.s	@DoNothing
		move.w	art_tile(a0),d0
		andi.w	#$7FF,d0
		lsr.w	#1,d0
		andi.w	#$F800,art_tile(a0)
		add.w	d0,art_tile(a0)
	@DoNothing:
		rts
; End of function Adjust2PArtPointer


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; adjust art pointer of object at a1 for 2-player mode
; ModifyA1SpriteAttr_2P:
Adjust2PArtPointerChild:
Adjust2PArtPointer2:
		tst.w	(Two_player_mode).w
		beq.s	@DoNothing
		move.w	art_tile(a1),d0
		andi.w	#$7FF,d0
		lsr.w	#1,d0
		andi.w	#$F800,art_tile(a1)
		add.w	d0,art_tile(a1)
	@DoNothing:
		rts
; End of function Adjust2PArtPointer2

; ===========================================================================
obcunt	= 1
	rept	ObjCount-1
_temp	equs	_Obj\#obcunt

		if	strcmp("\_temp","NULL")
		elseif	filesize("Objects/\_temp\/\_temp\.asm")=-1
		inform	1, "Object not found - Objects/\_temp\ - replaced with ObjNull"
		jmp	objnull
		else
Obj\_temp:	include	"Objects/\_temp\/\_temp\.asm"
		even
		endif
obcunt	= obcunt+1
	endr
; ===========================================================================
; Sonic 1's sprite engine has the unique ability to use other camera coordinates
; to figure out where sprites should be; sadly, Sonic 2 Final removed this
BldSpr_ScrPos:	dc.l 0
		dc.l Camera_X_pos
		dc.l Camera_BG_X_pos
		dc.l Camera_BG3_X_pos
; ===========================================================================
BuildSprites:
		tst.w	(Two_player_mode).w
		bne.w	BuildSprites_2p
		lea	(Sprite_Table).w,a2
		moveq	#0,d5
		moveq	#0,d4
		tst.b	(Level_started_flag).w
		beq.s	loc_D026
		bsr.w	BuildRings

loc_D026:				; CODE XREF: BuildSprites+14j
		lea	(Sprite_Input_Table).w,a4
		moveq	#7,d7

loc_D02C:				; CODE XREF: BuildSprites+FAj
		tst.w	(a4)
		beq.w	BuildSprites_NextLevel
		moveq	#2,d6

BuildSprites_ObjLoop:				; CODE XREF: BuildSprites+F2j
		movea.w	(a4,d6.w),a0

		; These are sanity checks that stop objects with invalid IDs or
		; mappings from loading; September 14th to REV00 used the branch
		; for debugging purposes.
		tst.l	mappings(a0)
		beq.w	BuildSprites_InvalidMapping

		andi.b	#$7F,render_flags(a0) ; ''
		move.b	render_flags(a0),d0
		move.b	d0,d4
		btst	#6,d0
		bne.w	BuildSprites_MultiDraw
		andi.w	#$C,d0
		beq.s	BuildSprites_ScreenSpaceObj
		movea.l	BldSpr_ScrPos(pc,d0.w),a1
		moveq	#0,d0
		move.b	width_pixels(a0),d0
		move.w	x_pos(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	BuildSprites_NextObj
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#320,d1
		bge.w	BuildSprites_NextObj
		addi.w	#128,d3
		btst	#4,d4
		beq.s	BuildSprites_ApproxYCheck
		moveq	#0,d0
		move.b	y_radius(a0),d0
		move.w	y_pos(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	BuildSprites_NextObj
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#224,d1
		bge.s	BuildSprites_NextObj
		addi.w	#128,d2
		bra.s	BuildSprites_DrawSprite
; ===========================================================================
BuildSprites_ScreenSpaceObj:
		move.w	y_pixel(a0),d2
		move.w	x_pixel(a0),d3
		bra.s	BuildSprites_DrawSprite
; ===========================================================================
BuildSprites_ApproxYCheck:
		move.w	y_pos(a0),d2
		sub.w	4(a1),d2
		addi.w	#128,d2
		andi.w	#$7FF,d2	; Mask Y position to account for Vertical Wrapping
		cmpi.w	#-32+128,d2	; assume Y radius to be 32 pixels
		bcs.s	BuildSprites_NextObj
		cmpi.w	#32+128+224,d2
		bcc.s	BuildSprites_NextObj

BuildSprites_DrawSprite:
		movea.l	mappings(a0),a1
		moveq	#0,d1
		btst	#5,d4	; is the static mappings flag set?
		bne.s	@StaticMappingFrame	; if it is, branch
		move.b	mapping_frame(a0),d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	@NoPieces
	@StaticMappingFrame:	
		bsr.w	DrawSprite
	@NoPieces:	
		ori.b	#$80,render_flags(a0)

BuildSprites_NextObj:	
		addq.w	#2,d6
		subq.w	#2,(a4)
		bne.w	BuildSprites_ObjLoop

BuildSprites_NextLevel:				
		lea	$80(a4),a4
		dbf	d7,loc_D02C
		move.b	d5,(Sprite_count).w
		cmpi.b	#80,d5	; 'P'
		beq.s	@LimitReached
		move.l	#0,(a2)
		rts
	@LimitReached:	
		move.b	#0,-5(a2)
		rts
; ===========================================================================
; From September 14th to REV00, a debug command was added here that would
; deliberately crash the game if an object was loaded with an invalid ID
; or mappings pointer, likely to detect a bug where a sprite could delete
; itself on the same frame it queued itself for display.
;
; This bug was present for many objects in Sonic 1, but miraculously didn't
; cause any issues there as mappings are loaded using bytes. However, as
; Sonic 2 uses word-sized pointers for mappings instead, it causes the game
; to read from an odd address, causing a crash.
;
; REV01 removed this and this branch as a whole, only keeping the ID check
; in place. Despite their efforts, however, the ascending/descending metal
; platforms from Wing Fortress still have this bug, as does the Chemical Plant
; boss... well, they tried.
BuildSprites_InvalidMapping:
		bra.s	BuildSprites_NextObj
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

BuildSprites_MultiDraw:				; CODE XREF: BuildSprites+4Aj
		move.l	a4,-(sp)
		lea	(Camera_X_pos).w,a4
		movea.w	art_tile(a0),a3
		movea.l	mappings(a0),a5
		moveq	#0,d0

		; check if object is within X bounds
		move.b	mainspr_width(a0),d0
		move.w	x_pos(a0),d3
		sub.w	(a4),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	BuildSprites_MultiDraw_NextObj
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#320,d1
		bge.s	BuildSprites_MultiDraw_NextObj

		; check if object is within Y bounds
		move.w	y_pos(a0),d2
		sub.w	4(a4),d2
		addi.w	#128,d2
		cmpi.w	#-32+128,d2
		andi.w	#$7FF,d2	; Account for Vertical Wrap
		bcs.s	BuildSprites_MultiDraw_NextObj
		cmpi.w	#32+128+224,d2
		bcc.s	BuildSprites_MultiDraw_NextObj

		ori.b	#$80,render_flags(a0)
		lea	$10(a0),a6
		moveq	#0,d0
		move.b	$F(a0),d0
		subq.w	#1,d0
		bcs.s	BuildSprites_MultiDraw_NextObj

	@Loop:				
		swap	d0
		move.w	(a6)+,d3	; get X pos
		sub.w	(a4),d3
		addi.w	#128,d3
		move.w	(a6)+,d2	; get Y pos
		sub.w	4(a4),d2
		addi.w	#128,d2
		andi.w	#$7FF,d2	; Account for Vertical Wrap
		addq.w	#1,a6
		moveq	#0,d1
		move.b	(a6)+,d1	; get mapping frame
		add.w	d1,d1
		movea.l	a5,a1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	@LastPiece
		bsr.w	ChkDrawSprite

	@LastPiece:
		swap	d0
		dbf	d0,@Loop

BuildSprites_MultiDraw_NextObj:	
		movea.l	(sp)+,a4
		bra.w	BuildSprites_NextObj
; End of function BuildSprites


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

DrawSprite:				
		movea.w	art_tile(a0),a3
; End of function DrawSprite


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


ChkDrawSprite:			
		cmpi.b	#80,d5
		bhs.s	DrawSprite_Done
		btst	#0,d4
		bne.s	DrawSprite_FlipX
		btst	#1,d4
		bne.w	DrawSprite_FlipY

DrawSprite_Loop:
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+	; set Y pos
		move.b	(a1)+,(a2)+	; set sprite size
		addq.b	#1,d5
		move.b	d5,(a2)+	; set link field
		move.w	(a1)+,d0
		add.w	a3,d0
		move.w	d0,(a2)+	; set art tile and flags
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	@NoNudge
		addq.w	#1,d0	; avoid activating sprite masking

	@NoNudge:		
		move.w	d0,(a2)+
		dbf	d1,DrawSprite_Loop

DrawSprite_Done:			
		rts
; ===========================================================================

DrawSprite_FlipX:
		btst	#1,d4
		bne.w	DrawSprite_FlipXY

@loop:
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.w	(a1)+,d0
		add.w	a3,d0
		eori.w	#$800,d0
		move.w	d0,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		neg.w	d0
		move.b	CellOffsets_XFlip(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	@NoNudge
		addq.w	#1,d0
	@NoNudge:	
		move.w	d0,(a2)+
		dbf	d1,@loop
		rts
; ===========================================================================
; offsets for horizontally mirrored sprite pieces
CellOffsets_XFlip:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16
; offsets for vertically mirrored sprite pieces
CellOffsets_YFlip:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================

DrawSprite_FlipY:				; CODE XREF: ChkDrawSprite+10j ChkDrawSprite+D0j
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		move.b	CellOffsets_YFlip(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.w	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1000,d0
		move.w	d0,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	@NoNudge
		addq.w	#1,d0
	@NoNudge:
		move.w	d0,(a2)+
		dbf	d1,DrawSprite_FlipY
		rts
; ===========================================================================
; offsets for vertically mirrored sprite pieces
CellOffsets_XYFlip:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================

DrawSprite_FlipXY:
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		move.b	CellOffsets_XYFlip(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.w	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1800,d0
		move.w	d0,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		neg.w	d0
		move.b	CellOffsets_XFlip2(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	@NoNudge
		addq.w	#1,d0
	@NoNudge:
		move.w	d0,(a2)+
		dbf	d1,DrawSprite_FlipXY
		rts
; End of function ChkDrawSprite

; ===========================================================================
; offsets for horizontally mirrored sprite pieces
CellOffsets_XFlip2:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16
; ===========================================================================
BldSpr_ScrPos_2p:
		dc.l 0
		dc.l Camera_X_pos
		dc.l Camera_BG_X_pos
		dc.l Camera_BG3_X_pos
; ===========================================================================
; START	OF FUNCTION CHUNK FOR BuildSprites

BuildSprites_2p:	
		lea	(Sprite_Table).w,a2
		moveq	#2,d5
		moveq	#0,d4
		move.l	#$1D80F01,(a2)+
		move.l	#1,(a2)+
		move.l	#$1D80F02,(a2)+
		move.l	#0,(a2)+
		tst.b	(Level_started_flag).w
		beq.s	loc_D332
		bsr.w	BuildSprites2_2p

loc_D332:				; CODE XREF: BuildSprites+320j
		lea	(Sprite_Input_Table).w,a4
		moveq	#7,d7

loc_D338:				; CODE XREF: BuildSprites+408j
		move.w	(a4),d0
		beq.w	loc_D410
		move.w	d0,-(sp)
		moveq	#2,d6

loc_D342:				; CODE XREF: BuildSprites+3FEj
		movea.w	(a4,d6.w),a0
		tst.b	(a0)
		beq.w	loc_D406
		andi.b	#$7F,render_flags(a0) ; ''
		move.b	render_flags(a0),d0
		move.b	d0,d4
		btst	#6,d0
		bne.w	loc_D54A
		andi.w	#$C,d0
		beq.s	loc_D3B6
		movea.l	BldSpr_ScrPos_2p(pc,d0.w),a1
		moveq	#0,d0
		move.b	width_pixels(a0),d0
		move.w	x_pos(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_D406
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#$140,d1
		bge.s	loc_D406
		addi.w	#$80,d3	; '€'
		btst	#4,d4
		beq.s	loc_D3C4
		moveq	#0,d0
		move.b	y_radius(a0),d0
		move.w	y_pos(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	loc_D406
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#$E0,d1	; 'à'
		bge.s	loc_D406
		addi.w	#$100,d2
		bra.s	loc_D3E0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D3B6:				; CODE XREF: BuildSprites+358j
		move.w	y_pixel(a0),d2
		move.w	x_pixel(a0),d3
		addi.w	#$80,d2	; '€'
		bra.s	loc_D3E0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D3C4:				; CODE XREF: BuildSprites+384j
		move.w	y_pos(a0),d2
		sub.w	4(a1),d2
		addi.w	#$80,d2	; '€'
		cmpi.w	#$60,d2	; '`'
		bcs.s	loc_D406
		cmpi.w	#$180,d2
		bcc.s	loc_D406
		addi.w	#$80,d2	; '€'

loc_D3E0:				; CODE XREF: BuildSprites+3A8j
					; BuildSprites+3B6j
		movea.l	mappings(a0),a1
		moveq	#0,d1
		btst	#5,d4
		bne.s	loc_D3FC
		move.b	mapping_frame(a0),d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	loc_D400

loc_D3FC:				; CODE XREF: BuildSprites+3DEj
		bsr.w	sub_D6A2

loc_D400:				; CODE XREF: BuildSprites+3EEj
		ori.b	#$80,render_flags(a0)

loc_D406:				; CODE XREF: BuildSprites+33Cj
					; BuildSprites+36Ej ...
		addq.w	#2,d6
		subq.w	#2,(sp)
		bne.w	loc_D342
		addq.w	#2,sp

loc_D410:				; CODE XREF: BuildSprites+32Ej
		lea	$80(a4),a4
		dbf	d7,loc_D338
		move.b	d5,(Sprite_count).w
		cmpi.b	#$50,d5	; 'P'
		bcc.s	loc_D42A
		move.l	#0,(a2)
		bra.s	loc_D442
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D42A:				; CODE XREF: BuildSprites+414j
		move.b	#0,-5(a2)
		bra.s	loc_D442
; END OF FUNCTION CHUNK	FOR BuildSprites
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dword_D432:	dc.l 0
		dc.l Camera_X_pos_P2
		dc.l Camera_BG_X_pos_P2
		dc.l Camera_BG3_X_pos_P2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR BuildSprites

loc_D442:				; CODE XREF: BuildSprites+41Cj
					; BuildSprites+424j
		lea	(Sprite_Table_2P).w,a2
		moveq	#0,d5
		moveq	#0,d4
		tst.b	(Level_started_flag).w
		beq.s	loc_D454
		bsr.w	BuildRings_2P

loc_D454:				; CODE XREF: BuildSprites+442j
		lea	(Sprite_Input_Table).w,a4
		moveq	#7,d7

loc_D45A:				; CODE XREF: BuildSprites+520j
		tst.w	(a4)
		beq.w	loc_D528
		moveq	#2,d6

loc_D462:				; CODE XREF: BuildSprites+518j
		movea.w	(a4,d6.w),a0
		tst.b	(a0)
		beq.w	loc_D520
		move.b	render_flags(a0),d0
		move.b	d0,d4
		btst	#6,d0
		bne.w	loc_D5DA
		andi.w	#$C,d0
		beq.s	loc_D4D0
		movea.l	dword_D432(pc,d0.w),a1
		moveq	#0,d0
		move.b	width_pixels(a0),d0
		move.w	x_pos(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_D520
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#$140,d1
		bge.s	loc_D520
		addi.w	#$80,d3	; '€'
		btst	#4,d4
		beq.s	loc_D4DE
		moveq	#0,d0
		move.b	y_radius(a0),d0
		move.w	y_pos(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	loc_D520
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#$E0,d1	; 'à'
		bge.s	loc_D520
		addi.w	#$1E0,d2
		bra.s	loc_D4FA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D4D0:				; CODE XREF: BuildSprites+472j
		move.w	y_pixel(a0),d2
		move.w	x_pixel(a0),d3
		addi.w	#$160,d2
		bra.s	loc_D4FA
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D4DE:				; CODE XREF: BuildSprites+49Ej
		move.w	y_pos(a0),d2
		sub.w	4(a1),d2
		addi.w	#$80,d2	; '€'
		cmpi.w	#$60,d2	; '`'
		bcs.s	loc_D520
		cmpi.w	#$180,d2
		bcc.s	loc_D520
		addi.w	#$160,d2

loc_D4FA:				; CODE XREF: BuildSprites+4C2j
					; BuildSprites+4D0j
		movea.l	mappings(a0),a1
		moveq	#0,d1
		btst	#5,d4
		bne.s	loc_D516
		move.b	mapping_frame(a0),d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	loc_D51A

loc_D516:				; CODE XREF: BuildSprites+4F8j
		bsr.w	sub_D6A2

loc_D51A:				; CODE XREF: BuildSprites+508j
		ori.b	#$80,render_flags(a0)

loc_D520:				; CODE XREF: BuildSprites+45Cj
					; BuildSprites+488j ...
		addq.w	#2,d6
		subq.w	#2,(a4)
		bne.w	loc_D462

loc_D528:				; CODE XREF: BuildSprites+450j
		lea	$80(a4),a4
		dbf	d7,loc_D45A
		move.b	d5,(Sprite_count).w
		cmpi.b	#$50,d5	; 'P'
		beq.s	loc_D542
		move.l	#0,(a2)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D542:				; CODE XREF: BuildSprites+52Cj
		move.b	#0,-5(a2)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D54A:				; CODE XREF: BuildSprites+350j
		move.l	a4,-(sp)
		lea	(Camera_X_pos).w,a4
		movea.w	art_tile(a0),a3
		movea.l	mappings(a0),a5
		moveq	#0,d0
		move.b	$E(a0),d0
		move.w	x_pos(a0),d3
		sub.w	(a4),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_D5D4
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#$140,d1
		bge.s	loc_D5D4
		move.w	y_pos(a0),d2
		sub.w	4(a4),d2
		addi.w	#$80,d2	; '€'
		cmpi.w	#$60,d2	; '`'
		bcs.s	loc_D5D4
		cmpi.w	#$180,d2
		bcc.s	loc_D5D4
		ori.b	#$80,render_flags(a0)
		lea	$10(a0),a6
		moveq	#0,d0
		move.b	$F(a0),d0
		subq.w	#1,d0
		bcs.s	loc_D5D4

loc_D5A2:				; CODE XREF: BuildSprites+5C4j
		swap	d0
		move.w	(a6)+,d3
		sub.w	(a4),d3
		addi.w	#$80,d3	; '€'
		move.w	(a6)+,d2
		sub.w	4(a4),d2
		addi.w	#$100,d2
		addq.w	#1,a6
		moveq	#0,d1
		move.b	(a6)+,d1
		add.w	d1,d1
		movea.l	a5,a1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	loc_D5CE
		bsr.w	sub_D6A6

loc_D5CE:				; CODE XREF: BuildSprites+5BCj
		swap	d0
		dbf	d0,loc_D5A2

loc_D5D4:				; CODE XREF: BuildSprites+55Cj
					; BuildSprites+568j ...
		movea.l	(sp)+,a4
		bra.w	loc_D406
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D5DA:				; CODE XREF: BuildSprites+46Aj
		move.l	a4,-(sp)
		lea	(Camera_X_pos_P2).w,a4
		movea.w	art_tile(a0),a3
		movea.l	mappings(a0),a5
		moveq	#0,d0
		move.b	$E(a0),d0
		move.w	x_pos(a0),d3
		sub.w	(a4),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_D664
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#$140,d1
		bge.s	loc_D664
		move.w	y_pos(a0),d2
		sub.w	4(a4),d2
		addi.w	#$80,d2	; '€'
		cmpi.w	#$60,d2	; '`'
		bcs.s	loc_D664
		cmpi.w	#$180,d2
		bcc.s	loc_D664
		ori.b	#$80,render_flags(a0)
		lea	$10(a0),a6
		moveq	#0,d0
		move.b	$F(a0),d0
		subq.w	#1,d0
		bcs.s	loc_D664

loc_D632:				; CODE XREF: BuildSprites+654j
		swap	d0
		move.w	(a6)+,d3
		sub.w	(a4),d3
		addi.w	#$80,d3	; '€'
		move.w	(a6)+,d2
		sub.w	4(a4),d2
		addi.w	#$1E0,d2
		addq.w	#1,a6
		moveq	#0,d1
		move.b	(a6)+,d1
		add.w	d1,d1
		movea.l	a5,a1
		adda.w	(a1,d1.w),a1
		move.w	(a1)+,d1
		subq.w	#1,d1
		bmi.s	loc_D65E
		bsr.w	sub_D6A6

loc_D65E:				; CODE XREF: BuildSprites+64Cj
		swap	d0
		dbf	d0,loc_D632

loc_D664:				; CODE XREF: BuildSprites+5ECj
					; BuildSprites+5F8j ...
		movea.l	(sp)+,a4
		bra.w	loc_D520
; END OF FUNCTION CHUNK	FOR BuildSprites

sub_D6A2:
		movea.w	art_tile(a0),a3
; End of function sub_D6A2
sub_D6A6:	
		cmpi.b	#$50,d5	; 'P'
		bcc.s	locret_D6E6
		btst	#0,d4
		bne.s	loc_D6F8
		btst	#1,d4
		bne.w	loc_D75A

loc_D6BA:				; CODE XREF: sub_D6A6+3Cj
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	byte_D6E8(pc,d4.w),(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	a3,d0
		move.w	d0,(a2)+
		move.w	(a1)+,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D6E0
		addq.w	#1,d0

loc_D6E0:				; CODE XREF: sub_D6A6+36j
		move.w	d0,(a2)+
		dbf	d1,loc_D6BA

locret_D6E6:				; CODE XREF: sub_D6A6+4j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_D6E8:	dc.b   0,  0		; 0
		dc.b   1,  1		; 2
		dc.b   4,  4		; 4
		dc.b   5,  5		; 6
		dc.b   8,  8		; 8
		dc.b   9,  9		; 10
		dc.b  $C, $C		; 12
		dc.b  $D, $D		; 14
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D6F8:				; CODE XREF: sub_D6A6+Aj
		btst	#1,d4
		bne.w	loc_D7B6

loc_D700:				; CODE XREF: sub_D6A6+8Ej
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	byte_D6E8(pc,d4.w),(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	a3,d0
		eori.w	#$800,d0
		move.w	d0,(a2)+
		move.w	(a1)+,d0
		neg.w	d0
		move.b	byte_D73A(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D732
		addq.w	#1,d0

loc_D732:				; CODE XREF: sub_D6A6+88j
		move.w	d0,(a2)+
		dbf	d1,loc_D700
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_D73A:	dc.b   8,  8		; 0
		dc.b   8,  8		; 2
		dc.b $10,$10		; 4
		dc.b $10,$10		; 6
		dc.b $18,$18		; 8
		dc.b $18,$18		; 10
		dc.b $20,$20		; 12
		dc.b $20,$20		; 14
byte_D74A:	dc.b   8,$10,$18,$20	; 0
		dc.b   8,$10,$18,$20	; 4
		dc.b   8,$10,$18,$20	; 8
		dc.b   8,$10,$18,$20	; 12
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D75A:				; CODE XREF: sub_D6A6+10j sub_D6A6+EAj
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		move.b	byte_D74A(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	byte_D796(pc,d4.w),(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1000,d0
		move.w	d0,(a2)+
		move.w	(a1)+,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D78E
		addq.w	#1,d0

loc_D78E:				; CODE XREF: sub_D6A6+E4j
		move.w	d0,(a2)+
		dbf	d1,loc_D75A
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_D796:	dc.b   0,  0,  1,  1	; 0
		dc.b   4,  4,  5,  5	; 4
		dc.b   8,  8,  9,  9	; 8
		dc.b  $C, $C, $D, $D	; 12
byte_D7A6:	dc.b   8,$10,$18,$20	; 0
		dc.b   8,$10,$18,$20	; 4
		dc.b   8,$10,$18,$20	; 8
		dc.b   8,$10,$18,$20	; 12
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D7B6:				; CODE XREF: sub_D6A6+56j
					; sub_D6A6+14Ej
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		move.b	byte_D7A6(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	byte_D796(pc,d4.w),(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		addq.w	#2,a1
		move.w	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1800,d0
		move.w	d0,(a2)+
		move.w	(a1)+,d0
		neg.w	d0
		move.b	byte_D7FA(pc,d4.w),d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D7F2
		addq.w	#1,d0

loc_D7F2:				; CODE XREF: sub_D6A6+148j
		move.w	d0,(a2)+
		dbf	d1,loc_D7B6
		rts
; End of function sub_D6A6

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
byte_D7FA:	dc.b   8,  8,  8,  8	; 0
		dc.b $10,$10,$10,$10	; 4
		dc.b $18,$18,$18,$18	; 8
		dc.b $20,$20,$20,$20	; 12
		dc.b $30,$28,  0,  8	; 16
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		sub.w	(Camera_X_pos).w,d0
		bmi.s	loc_D82E
		cmpi.w	#$140,d0
		bge.s	loc_D82E
		move.w	y_pos(a0),d1
		sub.w	(Camera_Y_pos).w,d1
		bmi.s	loc_D82E
		cmpi.w	#$E0,d1	; 'à'
		bge.s	loc_D82E
		moveq	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D82E:				; CODE XREF: ROM:0000D812j
					; ROM:0000D818j ...
		moveq	#1,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		move.w	x_pos(a0),d0
		sub.w	(Camera_X_pos).w,d0
		add.w	d1,d0
		bmi.s	loc_D862
		add.w	d1,d1
		sub.w	d1,d0
		cmpi.w	#$140,d0
		bge.s	loc_D862
		move.w	y_pos(a0),d1
		sub.w	(Camera_Y_pos).w,d1
		bmi.s	loc_D862
		cmpi.w	#$E0,d1	; 'à'
		bge.s	loc_D862
		moveq	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_D862:				; CODE XREF: ROM:0000D842j
					; ROM:0000D84Cj ...
		moveq	#1,d0
		rts


; ============================================================================
; ----------------------------------------------------------------------------
; Pseudo-object that manages where rings are placed onscreen
; as you move through the level, and otherwise updates them.
; ----------------------------------------------------------------------------

; RingPosLoad:
RingsManager:
		moveq	#0,d0
		move.b	(Rings_manager_routine).w,d0
		move.w	RingsManager_States(pc,d0.w),d0
		jmp	RingsManager_States(pc,d0.w)
; End of function RingsManager

; ===========================================================================
; RPL_Index:
RingsManager_States:
		dc.w RingsManager_Init-RingsManager_States
		dc.w RingsManager_Main-RingsManager_States
; ===========================================================================
; RPL_Main:
RingsManager_Init:
		addq.b	#2,(Rings_manager_routine).w	; => RingsManager_Main
		bsr.w	RingsManager_Setup	; perform initial setup
		lea	(Ring_Positions).w,a1
		move.w	(Camera_X_pos).w,d4
		subq.w	#8,d4
		bhi.s	loc_D896
		moveq	#1,d4			; no negative values allowed
		bra.s	loc_D896
; ---------------------------------------------------------------------------

loc_D892:
		lea	6(a1),a1		; load next ring

loc_D896:
		cmp.w	2(a1),d4		; is the X pos of the ring < camera X pos?
		bhi.s	loc_D892		; if it is, check next ring
		move.w	a1,(Ring_start_addr).w	; set start addresses
		move.w	a1,(Ring_start_addr_P2).w
		addi.w	#$150,d4		; advance by a screen
		bra.s	loc_D8AE
; ---------------------------------------------------------------------------

loc_D8AA:
		lea	6(a1),a1		; load next ring

loc_D8AE:
		cmp.w	2(a1),d4		; is the X pos of the ring < camera X + 336?
		bhi.s	loc_D8AA		; if it is, check next ring
		move.w	a1,(Ring_end_addr).w	; set end addresses
		move.w	a1,(Ring_end_addr_P2).w
		move.b	#1,(Level_started_flag).w
		rts
; ===========================================================================
; RPL_Next:
RingsManager_Main:
		lea	(Ring_Positions).w,a1
		move.w	#$FF,d1

loc_D8CC:
		move.b	(a1),d0		; is there a ring in this slot?
		beq.s	loc_D8EA	; if not, branch
		bmi.s	loc_D8EA
		subq.b	#1,(a1)		; decrement timer
		bne.s	loc_D8EA	; if it's not 0 yet, branch
		move.b	#6,(a1)		; reset timer
		addq.b	#1,1(a1)	; increment frame
		cmpi.b	#8,1(a1)	; is it destruction time yet?
		bne.s	loc_D8EA	; if not, branch
		move.w	#-1,(a1)	; destroy ring

loc_D8EA:
		lea	6(a1),a1
		dbf	d1,loc_D8CC

		; update ring start and end addresses
		movea.w	(Ring_start_addr).w,a1
		move.w	(Camera_X_pos).w,d4
		subq.w	#8,d4
		bhi.s	loc_D906
		moveq	#1,d4
		bra.s	loc_D906
; ---------------------------------------------------------------------------

loc_D902:
		lea	6(a1),a1

loc_D906:
		cmp.w	2(a1),d4
		bhi.s	loc_D902
		bra.s	loc_D910
; ---------------------------------------------------------------------------

loc_D90E:
		subq.w	#6,a1

loc_D910:
		cmp.w	-4(a1),d4
		bls.s	loc_D90E
		move.w	a1,(Ring_start_addr).w	; update start address

		movea.w	(Ring_end_addr).w,a2
		addi.w	#$150,d4
		bra.s	loc_D928
; ---------------------------------------------------------------------------

loc_D924:
		lea	6(a2),a2

loc_D928:
		cmp.w	2(a2),d4
		bhi.s	loc_D924
		bra.s	loc_D932
; ---------------------------------------------------------------------------

loc_D930:
		subq.w	#6,a2

loc_D932:
		cmp.w	-4(a2),d4
		bls.s	loc_D930
		move.w	a2,(Ring_end_addr).w	; update end address
		tst.w	(Two_player_mode).w	; are we in 2P mode?
		bne.s	loc_D94C		; if we are, update P2 addresses
		move.w	a1,(Ring_start_addr_P2).w	; otherwise, copy over P1 addresses
		move.w	a2,(Ring_end_addr_P2).w
		rts
; ---------------------------------------------------------------------------

loc_D94C:
		; update ring start and end addresses for P2
		movea.w	(Ring_start_addr_P2).w,a1
		move.w	(Camera_X_pos_P2).w,d4
		subq.w	#8,d4
		bhi.s	loc_D960
		moveq	#1,d4
		bra.s	loc_D960
; ---------------------------------------------------------------------------

loc_D95C:
		lea	6(a1),a1

loc_D960:
		cmp.w	2(a1),d4
		bhi.s	loc_D95C
		bra.s	loc_D96A
; ---------------------------------------------------------------------------

loc_D968:
		subq.w	#6,a1

loc_D96A:
		cmp.w	-4(a1),d4
		bls.s	loc_D968
		move.w	a1,(Ring_start_addr_P2).w	; update start address

		movea.w	(Ring_end_addr_P2).w,a2
		addi.w	#$150,d4
		bra.s	loc_D982
; ---------------------------------------------------------------------------

loc_D97E:
		lea	6(a2),a2

loc_D982:
		cmp.w	2(a2),d4
		bhi.s	loc_D97E
		bra.s	loc_D98C
; ---------------------------------------------------------------------------

loc_D98A:
		subq.w	#6,a2

loc_D98C:
		cmp.w	-4(a2),d4
		bls.s	loc_D98A
		move.w	a2,(Ring_end_addr_P2).w		; update end address
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ

; BuildSprites2:
BuildRings:
		movea.w	(Ring_start_addr).w,a0
		movea.w	(Ring_end_addr).w,a4
		cmpa.l	a0,a4			; are there any rings on-screen?
		bne.s	@StartDrawingRings	; if there are, branch
		rts				; otherwise, return
	@StartDrawingRings:
		lea	(Camera_X_pos).w,a3

	@loop:
		tst.w	(a0)			; has the ring been consumed?
		bmi.w	@NextRing	; if yes, branch
		move.w	2(a0),d3		; get ring X position
		sub.w	(a3),d3			; subtract the camera's X position
		move.w	4(a0),d2		; get ring Y position
		sub.w	4(a3),d2		; subtract the camera's Y position

		addi.w	#16/2,d2
		bmi.s	@NextRing
		cmpi.w	#(224+16),d2
		bge.s	@NextRing		; if the ring is not visible, branch
		addi.w	#((224+16)/2)-8,d2	; reposition ring

		lea	(MAP_RingManager).l,a1
		moveq	#0,d1
		move.b	1(a0),d1
		bne.s	@RingCollection
		move.b	(Rings_anim_frame).w,d1	; get ring frame

	@RingCollection:
		lsl.w	#3,d1		; multiply by 8
		adda.l	d1,a1		; get frame

		move.w	d2,(a2)+	; Y position
		move.w	(a1)+,d0	; (need to align past interlace size)
		move.b	d0,(a2)+	; Size
		addq.b	#1,d5		; increased number
		move.b	d5,(a2)+	; Set link
		move.w	(a1)+,(a2)+	; VRAM settings
		addq.w	#2,a1		; skip past interlaced mode mapping
		add.w	(a1),d3		; X position
		move.w	d3,(a2)+

	@NextRing:
		lea	6(a0),a0
		cmpa.l	a0,a4
		bne.w	@loop
		rts
; End of function BuildRings

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


BuildSprites2_2p:	
		lea	(Camera_X_pos).w,a3
		move.w	#120,d6
		movea.w	(Ring_start_addr).w,a0
		movea.w	(Ring_end_addr).w,a4
		cmpa.l	a0,a4
		bne.s	BuildRings_StartDrawingRings_2P
		rts
; End of function BuildSprites2_2p


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


BuildRings_2P:		
		lea	(Camera_X_pos_P2).w,a3
		move.w	#344,d6
		movea.w	(Ring_start_addr_P2).w,a0
		movea.w	(Ring_end_addr_P2).w,a4
		cmpa.l	a0,a4
		bne.s	BuildRings_StartDrawingRings_2P
		rts
BuildRings_StartDrawingRings_2P:

	@loop:
		tst.w	(a0)			; has the ring been consumed?
		bmi.w	@NextRing	; if yes, branch
		move.w	2(a0),d3		; get ring X position
		sub.w	(a3),d3			; subtract the camera's X position
		move.w	4(a0),d2		; get ring Y position
		sub.w	4(a3),d2		; subtract the camera's Y position

		addi.w	#136,d2
		bmi.s	@NextRing
		cmpi.w	#368,d2
		bge.s	@NextRing		; if the ring is not visible, branch
		add.w	d6,d2

		lea	(MAP_RingManager).l,a1
		moveq	#0,d1
		move.b	1(a0),d1
		bne.s	@RingCollection
		move.b	(Rings_anim_frame).w,d1

	@RingCollection:
		lsl.w	#3,d1		; multiply by 8
		adda.l	d1,a1		; get frame

		move.w	d2,(a2)+	; Y position
		move.b	(a1)+,(a2)+	; get size

		addq.b	#1,d5		; increased number
		move.b	d5,(a2)+	; Set link
		addq.w	#3,a1		; skip past non-interlaced size and VRAM
		move.w	(a1)+,(a2)+	; VRAM settings
		add.w	(a1),d3		; X position
		move.w	d3,(a2)+

	@NextRing:
		lea	6(a0),a0
		cmpa.l	a0,a4
		bne.w	@loop
		rts
; End of function BuildRings_2P
; ---------------------------------------------------------------------------
; Subroutine to perform initial rings manager setup
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; RingsManager2:
RingsManager_Setup:
		lea	(Ring_Positions).w,a1
		moveq	#0,d0
		move.w	#$17F,d1

loc_DB66:
		move.l	d0,(a1)+
		dbf	d1,loc_DB66
		moveq	#0,d0
		move.w	(Current_ZoneAndAct).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		lea	(RingPos_Index).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.l),a1
		lea	(Ring_Positions+6).w,a2
; loc_DB88:
RingsMgr_NextRowOrCol:
		move.w	(a1)+,d2
		bmi.s	RingsMgr_SortRings
		move.w	(a1)+,d3
		bmi.s	RingsMgr_RingCol
		move.w	d3,d0
		rol.w	#4,d0
		andi.w	#7,d0
		andi.w	#$FFF,d3
; loc_DB9C:
RingsMgr_NextRingInRow:
		move.w	#0,(a2)+
		move.w	d2,(a2)+
		move.w	d3,(a2)+
		addi.w	#$18,d2
		dbf	d0,RingsMgr_NextRingInRow
		bra.s	RingsMgr_NextRowOrCol
; ===========================================================================
; loc_DBAE:
RingsMgr_RingCol:
		move.w	d3,d0
		rol.w	#4,d0
		andi.w	#7,d0
		andi.w	#$FFF,d3
; loc_DBBA:
RingsMgr_NextRingInCol:
		move.w	#0,(a2)+
		move.w	d2,(a2)+
		move.w	d3,(a2)+
		addi.w	#$18,d3
		dbf	d0,RingsMgr_NextRingInCol
		bra.s	RingsMgr_NextRowOrCol
; ===========================================================================
; loc_DBCC:
RingsMgr_SortRings:
		moveq	#-1,d0
		move.l	d0,(a2)+
		lea	(Ring_Positions+2).w,a1
		move.w	#$FE,d3

loc_DBD8:
		move.w	d3,d4
		lea	6(a1),a2
		move.w	(a1),d0

loc_DBE0:
		tst.w	(a2)
		beq.s	loc_DBF2
		cmp.w	(a2),d0
		bls.s	loc_DBF2
		move.l	(a1),d1
		move.l	(a2),d0
		move.l	d0,(a1)
		move.l	d1,(a2)
		swap	d0

loc_DBF2:
		lea	6(a2),a2
		dbf	d4,loc_DBE0
		lea	6(a1),a1
		dbf	d3,loc_DBD8
		rts
; End of function RingsManager_Setup

; ===========================================================================
	IndexStart	MAP_RingManager	; Ring manager has its own format

@Entry:		macro 	x,size,vram,flipx,flipy
		dc.w	(size&$FE<<8)+size	; Sprite size 
		dc.w	((0<<15)+(1<<13)++(flipy<<12)+(flipx<<11)+($D780/$20+vram))
		dc.w	((0<<15)+(1<<13)++(flipy<<12)+(flipx<<11)+(($D780/$20+vram)>>1))
		dc.w	(128+x)	; X position
		endm
	;  x-offset,	size,	vram,	flip x, y	
	@Entry	-8,	5,	0,	0, 0
	@Entry	-8,	5,	4,	0, 0
	@Entry	-4,	1,	8,	0, 0
	@Entry	-8,	5,	4,	1, 0

	@Entry	-8,	5,	10,	0, 0
	@Entry	-8,	5,	10,	1, 1
	@Entry	-8,	5,	10,	1, 0
	@Entry	-8,	5,	10,	0, 1

; ===========================================================================
; ---------------------------------------------------------------------------
; Objects Manager
; Subroutine that keeps track of any objects that need to remember
; their state, such as monitors or enemies.
;
; input variables:
;  -none-
;
; writes:
;  d0, d1
;  d2 = respawn index of object to load
;  d6 = camera position
;
;  a0 = address in object placement list
;  a2 = respawn table
; ---------------------------------------------------------------------------

; ObjPosLoad:
ObjectsManager:
		moveq	#0,d0
		move.b	(Obj_placement_routine).w,d0
		move.w	ObjectsManager_States(pc,d0.w),d0
		jmp	ObjectsManager_States(pc,d0.w)
; End of function ObjectsManager

; ===========================================================================
; OPL_Index:
ObjectsManager_States:	
		dc.w ObjectsManager_Init-ObjectsManager_States
		dc.w ObjectsManager_Main-ObjectsManager_States
		dc.w ObjectsManager_2Player-ObjectsManager_States
; ===========================================================================
; loc_DC68:
ObjectsManager_Init:
		addq.b	#2,(Obj_placement_routine).w
		move.w	(Current_ZoneAndAct).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	(ObjPos_Index).l,a0
		move.w	(a0,d0.w),d0
		lea	(a0,d0.l),a0
		move.l	a0,(Obj_load_addr_right).w
		move.l	a0,(Obj_load_addr_left).w
		move.l	a0,(Obj_load_addr_2).w
		move.l	a0,(Obj_load_addr_3).w
		lea	(Obj_respawn_index).w,a2
		move.w	#$101,(a2)+	; set initial values
		move.w	#(Obj_respawn_data_End-Obj_respawn_data)/4-1,d0
	@ClearRespawnRAM:
		clr.l	(a2)+
		dbf	d0,@ClearRespawnRAM

		lea	(Obj_respawn_index).w,a2
		moveq	#0,d2
		move.w	(Camera_X_pos).w,d6
		subi.w	#$80,d6
		bcc.s	loc_DCB4
		moveq	#0,d6
loc_DCB4:
		andi.w	#$FF80,d6
		movea.l	(Obj_load_addr_right).w,a0

loc_DCBC:
		cmp.w	(a0),d6
		bls.s	loc_DCCE
		tst.b	4(a0)
		bpl.s	loc_DCCA
		move.b	(a2),d2
		addq.b	#1,(a2)

loc_DCCA:
		addq.w	#6,a0
		bra.s	loc_DCBC
; ===========================================================================

loc_DCCE:
		move.l	a0,(Obj_load_addr_right).w
		move.l	a0,(Obj_load_addr_2).w
		movea.l	(Obj_load_addr_left).w,a0
		subi.w	#$80,d6
		bcs.s	loc_DCF2

loc_DCE0:
		cmp.w	(a0),d6
		bls.s	loc_DCF2
		tst.b	4(a0)
		bpl.s	loc_DCEE
		addq.b	#1,1(a2)

loc_DCEE:
		addq.w	#6,a0
		bra.s	loc_DCE0
; ===========================================================================

loc_DCF2:
		move.l	a0,(Obj_load_addr_left).w
		move.l	a0,(Obj_load_addr_3).w
		move.w	#-1,(Camera_X_pos_last).w
		move.w	#-1,(Camera_X_pos_last_P2).w
		tst.w	(Two_player_mode).w
		beq.s	ObjectsManager_Main
		addq.b	#2,(Obj_placement_routine).w
		bra.w	ObjectsManager_Init2Player
; ===========================================================================
; loc_DD14:
ObjectsManager_Main:
		move.w	(Camera_X_pos).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		move.w	d1,(Camera_X_pos_coarse).w
		lea	(Obj_respawn_index).w,a2
		moveq	#0,d2
		move.w	(Camera_X_pos).w,d6
		andi.w	#$FF80,d6
		cmp.w	(Camera_X_pos_last).w,d6
		beq.w	locret_DDDE
		bge.s	loc_DD9A
		move.w	d6,(Camera_X_pos_last).w
		movea.l	(Obj_load_addr_left).w,a0
		subi.w	#$80,d6
		bcs.s	loc_DD76

loc_DD4A:
		cmp.w	-6(a0),d6
		bge.s	loc_DD76
		subq.w	#6,a0
		tst.b	4(a0)
		bpl.s	loc_DD60
		subq.b	#1,1(a2)
		move.b	1(a2),d2

loc_DD60:
		bsr.w	sub_E0D2
		bne.s	loc_DD6A
		subq.w	#6,a0
		bra.s	loc_DD4A
; ===========================================================================

loc_DD6A:
		tst.b	4(a0)
		bpl.s	loc_DD74
		addq.b	#1,1(a2)

loc_DD74:
		addq.w	#6,a0

loc_DD76:
		move.l	a0,(Obj_load_addr_left).w
		movea.l	(Obj_load_addr_right).w,a0
		addi.w	#$300,d6

loc_DD82:
		cmp.w	-6(a0),d6
		bgt.s	loc_DD94
		tst.b	-2(a0)
		bpl.s	loc_DD90
		subq.b	#1,(a2)

loc_DD90:
		subq.w	#6,a0
		bra.s	loc_DD82
; ===========================================================================

loc_DD94:
		move.l	a0,(Obj_load_addr_right).w
		rts
; ===========================================================================

loc_DD9A:
		move.w	d6,(Camera_X_pos_last).w
		movea.l	(Obj_load_addr_right).w,a0
		addi.w	#$280,d6

loc_DDA6:
		cmp.w	(a0),d6
		bls.s	loc_DDBA
		tst.b	4(a0)
		bpl.s	loc_DDB4
		move.b	(a2),d2
		addq.b	#1,(a2)

loc_DDB4:
		bsr.w	sub_E0D2
		beq.s	loc_DDA6

loc_DDBA:
		move.l	a0,(Obj_load_addr_right).w
		movea.l	(Obj_load_addr_left).w,a0
		subi.w	#$300,d6
		bcs.s	loc_DDDA

loc_DDC8:
		cmp.w	(a0),d6
		bls.s	loc_DDDA
		tst.b	4(a0)
		bpl.s	loc_DDD6
		addq.b	#1,1(a2)

loc_DDD6:
		addq.w	#6,a0
		bra.s	loc_DDC8
; ===========================================================================

loc_DDDA:
		move.l	a0,(Obj_load_addr_left).w

locret_DDDE:
		rts
; ===========================================================================

ObjectsManager_Init2Player:	; 2 Player Object Manager INIT
		moveq	#-1,d0
		move.l	d0,($FFFFF780).w
		move.l	d0,($FFFFF784).w
		move.l	d0,($FFFFF788).w
		move.l	d0,(Camera_X_pos_last_P2).w
		move.w	#0,(Camera_X_pos_last).w
		move.w	#0,(Camera_X_pos_last_P2).w
		lea	(Obj_respawn_index).w,a2
		move.w	(a2),($FFFFF78E).w
		moveq	#0,d2
		lea	(Obj_respawn_index).w,a5
		lea	(Obj_load_addr_right).w,a4
		lea	($FFFFF786).w,a1
		lea	($FFFFF789).w,a6
		moveq	#-2,d6
		bsr.w	sub_DF80
		lea	($FFFFF786).w,a1
		moveq	#-1,d6
		bsr.w	sub_DF80
		lea	($FFFFF786).w,a1
		moveq	#0,d6
		bsr.w	sub_DF80
		lea	($FFFFF78E).w,a5
		lea	(Obj_load_addr_2).w,a4
		lea	($FFFFF789).w,a1
		lea	($FFFFF786).w,a6
		moveq	#-2,d6
		bsr.w	sub_DF80
		lea	($FFFFF789).w,a1
		moveq	#-1,d6
		bsr.w	sub_DF80
		lea	($FFFFF789).w,a1
		moveq	#0,d6
		bsr.w	sub_DF80

ObjectsManager_2Player:
		move.w	(Camera_X_pos).w,d1
		andi.w	#$FF00,d1
		move.w	d1,(Camera_X_pos_coarse).w
		move.w	(Camera_X_pos_P2).w,d1
		andi.w	#$FF00,d1
		move.w	d1,(Camera_X_pos_coarse_P2).w

		move.b	(Camera_X_pos).w,d6
		andi.w	#$FF,d6
		move.w	(Camera_X_pos_last).w,d0
		cmp.w	(Camera_X_pos_last).w,d6
		beq.s	loc_DE9C
		move.w	d6,(Camera_X_pos_last).w
		lea	(Obj_respawn_index).w,a5
		lea	(Obj_load_addr_right).w,a4
		lea	($FFFFF786).w,a1
		lea	($FFFFF789).w,a6
		bsr.s	sub_DED2

loc_DE9C:
		move.b	(Camera_X_pos_P2).w,d6
		andi.w	#$FF,d6
		move.w	(Camera_X_pos_last_P2).w,d0
		cmp.w	(Camera_X_pos_last_P2).w,d6
		beq.s	loc_DEC4
		move.w	d6,(Camera_X_pos_last_P2).w
		lea	($FFFFF78E).w,a5
		lea	(Obj_load_addr_2).w,a4
		lea	($FFFFF789).w,a1
		lea	($FFFFF786).w,a6
		bsr.s	sub_DED2

loc_DEC4:
	;	move.w	(Obj_respawn_index).w,($FFFFFFEC).w
	;	move.w	($FFFFF78E).w,($FFFFFFEE).w
		rts
; ===========================================================================

sub_DED2:
		lea	(Obj_respawn_index).w,a2
		moveq	#0,d2
		cmp.w	d0,d6
		beq.w	locret_DDDE
		bge.w	sub_DF80
		move.b	2(a1),d2
		move.b	1(a1),2(a1)
		move.b	(a1),1(a1)
		move.b	d6,(a1)
		cmp.b	(a6),d2
		beq.s	loc_DF08
		cmp.b	1(a6),d2
		beq.s	loc_DF08
		cmp.b	2(a6),d2
		beq.s	loc_DF08
		bsr.w	sub_E062
		bra.s	loc_DF0C
; ===========================================================================

loc_DF08:
		bsr.w	sub_E026

loc_DF0C:
		bsr.w	sub_E002
		bne.s	loc_DF30
		movea.l	4(a4),a0

loc_DF16:
		cmp.b	-6(a0),d6
		bne.s	loc_DF2A
		tst.b	-2(a0)
		bpl.s	loc_DF26
		subq.b	#1,1(a5)

loc_DF26:
		subq.w	#6,a0
		bra.s	loc_DF16
; ===========================================================================

loc_DF2A:
		move.l	a0,4(a4)
		bra.s	loc_DF66
; ===========================================================================

loc_DF30:
		movea.l	4(a4),a0
		move.b	d6,(a1)

loc_DF36:
		cmp.b	-6(a0),d6
		bne.s	loc_DF62
		subq.w	#6,a0
		tst.b	4(a0)
		bpl.s	loc_DF4C
		subq.b	#1,1(a5)
		move.b	1(a5),d2

loc_DF4C:
		bsr.w	sub_E122
		bne.s	loc_DF56
		subq.w	#6,a0
		bra.s	loc_DF36
; ===========================================================================

loc_DF56:
		tst.b	4(a0)
		bpl.s	loc_DF60
		addq.b	#1,1(a5)

loc_DF60:
		addq.w	#6,a0

loc_DF62:
		move.l	a0,4(a4)

loc_DF66:
		movea.l	(a4),a0
		addq.w	#3,d6

loc_DF6A:
		cmp.b	-6(a0),d6
		bne.s	loc_DF7C
		tst.b	-2(a0)
		bpl.s	loc_DF78
		subq.b	#1,(a5)

loc_DF78:
		subq.w	#6,a0
		bra.s	loc_DF6A
; ===========================================================================

loc_DF7C:
		move.l	a0,(a4)
		rts
; ===========================================================================

sub_DF80:
		addq.w	#2,d6
		move.b	(a1),d2
		move.b	1(a1),(a1)
		move.b	2(a1),1(a1)
		move.b	d6,2(a1)
		cmp.b	(a6),d2
		beq.s	loc_DFA8
		cmp.b	1(a6),d2
		beq.s	loc_DFA8
		cmp.b	2(a6),d2
		beq.s	loc_DFA8
		bsr.w	sub_E062
		bra.s	loc_DFAC
; ===========================================================================

loc_DFA8:
		bsr.w	sub_E026

loc_DFAC:
		bsr.w	sub_E002
		bne.s	loc_DFC8
		movea.l	(a4),a0

loc_DFB4:
		cmp.b	(a0),d6
		bne.s	loc_DFC4
		tst.b	4(a0)
		bpl.s	loc_DFC0
		addq.b	#1,(a5)

loc_DFC0:
		addq.w	#6,a0
		bra.s	loc_DFB4
; ===========================================================================

loc_DFC4:
		move.l	a0,(a4)
		bra.s	loc_DFE2
; ===========================================================================

loc_DFC8:
		movea.l	(a4),a0
		move.b	d6,(a1)

loc_DFCC:
		cmp.b	(a0),d6
		bne.s	loc_DFE0
		tst.b	4(a0)
		bpl.s	loc_DFDA
		move.b	(a5),d2
		addq.b	#1,(a5)

loc_DFDA:
		bsr.w	sub_E122
		beq.s	loc_DFCC

loc_DFE0:
		move.l	a0,(a4)

loc_DFE2:
		movea.l	4(a4),a0
		subq.w	#3,d6
		bcs.s	loc_DFFC

loc_DFEA:
		cmp.b	(a0),d6
		bne.s	loc_DFFC
		tst.b	4(a0)
		bpl.s	loc_DFF8
		addq.b	#1,1(a5)

loc_DFF8:
		addq.w	#6,a0
		bra.s	loc_DFEA
; ===========================================================================

loc_DFFC:
		move.l	a0,4(a4)
		rts
; End of function sub_DF80


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_E002:
		move.l	a1,-(sp)
		lea	($FFFFF780).w,a1
		cmp.b	(a1)+,d6
		beq.s	loc_E022
		cmp.b	(a1)+,d6
		beq.s	loc_E022
		cmp.b	(a1)+,d6
		beq.s	loc_E022
		cmp.b	(a1)+,d6
		beq.s	loc_E022
		cmp.b	(a1)+,d6
		beq.s	loc_E022
		cmp.b	(a1)+,d6
		beq.s	loc_E022
		moveq	#1,d0

loc_E022:
		movea.l	(sp)+,a1
		rts
; End of function sub_E002


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_E026:
		lea	($FFFFF780).w,a1
		lea	($FFFFBE00).w,a3
		tst.b	(a1)+
		bmi.s	loc_E05E
		lea	($FFFFC100).w,a3
		tst.b	(a1)+
		bmi.s	loc_E05E
		lea	($FFFFC400).w,a3
		tst.b	(a1)+
		bmi.s	loc_E05E
		lea	($FFFFC700).w,a3
		tst.b	(a1)+
		bmi.s	loc_E05E
		lea	($FFFFCA00).w,a3
		tst.b	(a1)+
		bmi.s	loc_E05E
		lea	($FFFFCD00).w,a3
		tst.b	(a1)+
	;	bmi.s	loc_E05E


loc_E05E:
		subq.w	#1,a1
		rts
; End of function sub_E026


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_E062:	; No clue, something related to Object Culling
		lea	($FFFFF780).w,a1
		lea	($FFFFBE00).w,a3
		cmp.b	(a1)+,d2
		beq.s	loc_E09A
		lea	($FFFFC100).w,a3
		cmp.b	(a1)+,d2
		beq.s	loc_E09A
		lea	($FFFFC400).w,a3
		cmp.b	(a1)+,d2
		beq.s	loc_E09A
		lea	($FFFFC700).w,a3
		cmp.b	(a1)+,d2
		beq.s	loc_E09A
		lea	($FFFFCA00).w,a3
		cmp.b	(a1)+,d2
		beq.s	loc_E09A
		lea	($FFFFCD00).w,a3
		cmp.b	(a1)+,d2
	;	beq.s	loc_E09A
loc_E09A:	
		move.b	#$FF,-(a1)
		movem.l	a1/a3,-(sp)
		moveq	#0,d1
		moveq	#13-1,d2

	@Loop:
		tst.b	(a3)
		beq.s	@NoObject
		movea.l	a3,a1
		moveq	#0,d0
		move.b	respawn_index(a1),d0
		beq.s	@NoRememberFlag
			bclr	#7,2(a2,d0.w)
	@NoRememberFlag:	
		moveq	#Object_RAM/4-1,d0
		@ClearObject:		
			move.l	d1,(a1)+
		dbf	d0,@ClearObject

	@NoObject:	
		lea	Object_RAM(a3),a3
		dbf	d2,@Loop
		moveq	#0,d2
		movem.l	(sp)+,a1/a3
		rts
; End of function sub_E062


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_E0D2:	
		tst.b	4(a0)
		bpl.s	loc_E0E6
		bset	#7,2(a2,d2.w)
		beq.s	loc_E0E6
		addq.w	#6,a0
		moveq	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_E0E6:	
		bsr.w	SingleObjLoad
		bne.s	locret_E120
		move.w	(a0)+,x_pos(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0
		move.w	d0,y_pos(a1)
		rol.w	#2,d1
		andi.b	#3,d1
		move.b	d1,render_flags(a1)
		move.b	d1,status(a1)
		move.b	(a0)+,d0
		bpl.s	loc_E116
		andi.b	#$7F,d0
		move.b	d2,$23(a1)

loc_E116:	
		move.b	d0,id(a1)
		move.b	(a0)+,$28(a1)
		moveq	#0,d0

locret_E120:	
		rts
; End of function sub_E0D2


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_E122:	
		tst.b	4(a0)
		bpl.s	loc_E136
		bset	#7,2(a2,d2.w)
		beq.s	loc_E136
		addq.w	#6,a0
		moveq	#0,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_E136:	
		btst	#5,2(a0)
		beq.s	loc_E146
		bsr.w	SingleObjLoad
		bne.s	locret_E180
		bra.s	loc_E14C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_E146:	
		bsr.w	SingleObjLoad3
		bne.s	locret_E180

loc_E14C:	
		move.w	(a0)+,x_pos(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0
		move.w	d0,y_pos(a1)
		rol.w	#2,d1
		andi.b	#3,d1
		move.b	d1,render_flags(a1)
		move.b	d1,status(a1)
		move.b	(a0)+,d0
		bpl.s	loc_E176
		andi.b	#$7F,d0	; ''
		move.b	d2,$23(a1)

loc_E176:	
		move.b	d0,id(a1)
		move.b	(a0)+,$28(a1)
		moveq	#0,d0

locret_E180:	
		rts
; End of function sub_E122

; ===========================================================================
; ---------------------------------------------------------------------------
; Single object loading subroutine
; Find an empty object array
; ---------------------------------------------------------------------------

; loc_E182: SingleObjectLoad:
SingleObjLoad:
		lea	(Level_Object_Space).w,a1	; a1=object
		move.w	#$60-1,d0			; search to end of table
	@Loop:
		tst.b	(a1)		; is object RAM slot empty?
		beq.s	@DoNothing	; if yes, branch
		lea	Object_RAM(a1),a1	; load obj address ; goto next object RAM slot
		dbf	d0,@Loop	; repeat until end
	@DoNothing:
		rts
; End of function SingleObjLoad

; ===========================================================================
; ---------------------------------------------------------------------------
; Single object loading subroutine
; Find an empty object array AFTER the current one in the table
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_E198: S1SingleObjectLoad2:
SingleObjLoad2:
		movea.l	a0,a1
		move.w	#(Object_Space_End&$FFFF),d0 
		sub.w	a0,d0	; subtract current object location
		lsr.w	#6,d0	; divide by $40
		subq.w	#1,d0	; (a0-Object_Space_End)-1
		bcs.s	@DoNothing	; keep from going past Object Space RAM
	@Loop:
		tst.b	(a1)		; is object RAM slot empty?
		beq.s	@DoNothing	; if yes, branch
		lea	Object_RAM(a1),a1	; load obj address ; goto next object RAM slot
		dbf	d0,@Loop	; repeat until end
	@DoNothing:
		rts
; End of function SingleObjLoad2

; ===========================================================================
; ---------------------------------------------------------------------------
; Single object loading subroutine
; Find an empty object at or within < 12 slots after a3
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E1B4:
SingleObjLoad3:
		movea.l	a3,a1
		move.w	#$B,d0

loc_E1BA:
		tst.b	(a1)		; is object RAM slot empty?
		beq.s	locret_E1C6	; if yes, branch
		lea	$40(a1),a1	; load obj address ; goto next object RAM slot
		dbf	d0,loc_E1BA	; repeat until end

locret_E1C6:
		rts
; End of function SingleObjLoad3

	include	"SpecialStage/Special Stage Routines.asm"

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


AddPoints:
		move.b	#1,(Update_HUD_score).w
		lea	(Score).w,a3
		add.l	d0,(a3)
		move.l	#999999,d1
		cmp.l	(a3),d1
		bhi.s	loc_1B214
		move.l	d1,(a3)

loc_1B214:
		move.l	(a3),d0
		cmp.l	(Next_Extra_life_score).w,d0
		bcs.s	locret_1B23C
		addi.l	#5000,(Next_Extra_life_score).w
		addq.b	#1,(Life_count).w
		addq.b	#1,(Update_HUD_lives).w
		move.w	#MusID_ExtraLife,d0
		jmp	(PlaySound).l

locret_1B23C:
		rts
; End of function AddPoints

	include	"Routines\HUD.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; PATTERN LOAD REQUEST LISTS
;
; Pattern load request lists are simple structures used to load
; Nemesis-compressed art for sprites.
;
; The decompressor predictably moves down the list, so request 0 is processed first, etc.
; This only matters if your addresses are bad and you overwrite art loaded in a previous request.
;
; NOTICE: The load queue buffer can only hold $10 (16) load requests. None of the routines
; that load PLRs into the queue do any bounds checking, so it's possible to create a buffer
; overflow and completely screw up the variables stored directly after the queue buffer.
; (in my experience this is a guaranteed crash or hang)
; ---------------------------------------------------------------------------
	IndexStart	ArtLoadCues, 1
	GenerateIndexID	PLC, Main
	GenerateIndexID	PLC, Main2
	GenerateIndexID	PLC, Explode
	GenerateIndexID	PLC, GameOver

	GenerateIndexID	PLC, S1TitleCard
	GenerateIndexID	PLC, Boss
	GenerateIndexID	PLC, Signpost
	GenerateIndexID	PLC, S1SpecialStage

	GenerateIndexID	PLC, GHZ
	GenerateIndexID	PLC, GHZ2
	GenerateIndex	PLC, CPZ
	GenerateIndex	PLC, CPZ2
	GenerateIndex	PLC, MMZ
	GenerateIndex	PLC, MMZ2
	GenerateIndex	PLC, EHZ
	GenerateIndex	PLC, EHZ2
	GenerateIndex	PLC, HPZ
	GenerateIndex	PLC, HPZ2
	GenerateIndex	PLC, HTZ
	GenerateIndex	PLC, HTZ2
	GenerateIndex	PLC, CNZ
	GenerateIndex	PLC, CNZ2

	GenerateIndexID	PLC, GHZAnimals
	GenerateIndex	PLC, CPZAnimals
	GenerateIndex	PLC, MMZAnimals
	GenerateIndex	PLC, HPZAnimals
	GenerateIndex	PLC, EHZAnimals
	GenerateIndex	PLC, HTZAnimals
	GenerateIndex	PLC, CNZAnimals

; macro for a pattern load request
PLC_Start	macro	name
		PLC_\name\:
		dc.w	((PLC_\name\_End-PLC_\name\)/6)-1
		endm
PLC_End		macro	name
		PLC_\name\_End:
		endm
PLC_Entry 	macro	toVRAMaddr,fromROMaddr
		dc.l	fromROMaddr		; art to load
		dc.w	toVRAMaddr		; VRAM address to load it at
		endm
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Standard 1 - loaded for every level
; --------------------------------------------------------------------------------------
	PLC_Start	Main
	PLC_Entry	($47C*$20),	ArtNem_Lamppost
	PLC_Entry	($6CA*$20),	ArtNem_HUD
	PLC_Entry	($7D4*$20),	ArtNem_Lives
	PLC_Entry	($6BC*$20),	ArtNem_Ring
	PLC_Entry	($4AC*$20),	ArtNem_Points
	PLC_End		Main
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Standard 2 - loaded for every level
; --------------------------------------------------------------------------------------
	PLC_Start	Main2
	PLC_Entry	($680*$20),	ArtNem_Monitor
	;PLC_Entry	($4BE*$20),	ArtNem_Shield
	PLC_Entry	($4DE*$20),	ArtNem_Invincibility
	PLC_End		Main2
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Explosion - loaded for every level AFTER the title card
; --------------------------------------------------------------------------------------
	PLC_Start	Explode
	PLC_Entry	($5A0*$20),	ArtNem_Explosion
	PLC_End		Explode
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Game/Time over
; --------------------------------------------------------------------------------------
	PLC_Start	GameOver
	PLC_Entry	($55E*$20),	ArtNem_GameOver
	PLC_End		GameOver
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Sonic 1 title card
; --------------------------------------------------------------------------------------
	PLC_Start	S1TitleCard
	PLC_Entry	$B000,		ArtNem_TitleCard
	PLC_End		S1TitleCard
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; End of zone bosses
; --------------------------------------------------------------------------------------
	PLC_Start	Boss
	PLC_Entry	($460*$20),	ArtNem_BossShip
	PLC_Entry	($4C0*$20),	ArtNem_BossEHZ
	PLC_Entry	($540*$20),	ArtNem_BossEHZBlades
	;PLC_Entry	($400*$20),	ArtNem_BossShip
	;PLC_Entry	($460*$20),	ArtNem_CPZ_ProtoBoss
	;PLC_Entry	($4D0*$20),	ArtNem_BossShipBoost
	;PLC_Entry	($4D8*$20),	ArtNem_Smoke
	;PLC_Entry	($4E8*$20),	ArtNem_EHZ_Boss
	;PLC_Entry	($568*$20),	ArtNem_EHZ_Boss_Blades
	PLC_End		Boss

; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; End of level signpost
; --------------------------------------------------------------------------------------
	PLC_Start	Signpost
	PLC_Entry	($680*$20),	ArtNem_Signpost
	PLC_Entry	($4B6*$20),	ArtNem_HiddenPoints
	;PLC_Entry	($462*$20),	ArtNem_BigFlash
	PLC_End		Signpost
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Sonic 1 Special Stage
; --------------------------------------------------------------------------------------
	PLC_Start	S1SpecialStage
	PLC_Entry	$2840,	ArtNem_SSWalls	; walls
	PLC_Entry	$4760,	ArtNem_Bumper 	; bumper
	PLC_Entry	$4A20,	ArtNem_SSGOAL 	; GOAL block
	PLC_Entry	$4C60,	ArtNem_SSUpDown 	; UP and DOWN blocks
	PLC_Entry	$5E00,	ArtNem_SSRBlock 	; R block
	PLC_Entry	$6E00,	ArtNem_SS1UpBlock 	; 1UP block
	PLC_Entry	$7E00,	ArtNem_SSEmStars	; emerald collection stars
	PLC_Entry	$8E00,	ArtNem_SSRedWhite 	; red and white	block
	PLC_Entry	$9E00,	ArtNem_SSGhost	; ghost	block
	PLC_Entry	$AE00,	ArtNem_SSWBlock	; W block
	PLC_Entry	$F400,	ArtNem_SSLBlock	; L Block
	PLC_Entry	$BE00,	ArtNem_SSGlass 	; glass	block
	PLC_Entry	$F640,	ArtNem_Ring  	; rings
	PLC_End		S1SpecialStage
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Green Hill Zone primary
; --------------------------------------------------------------------------------------
	PLC_Start	GHZ
	PLC_Entry	0,		ArtNem_GHZ
	PLC_Entry	($470*$20),	ArtNem_Chopper
	PLC_Entry	($4A0*$20),	ArtNem_UprightSpikes
	PLC_Entry	($4A8*$20),	ArtNem_VSpring
	PLC_Entry	($4B8*$20),	ArtNem_HSpring
	PLC_Entry	($4C6*$20),	ArtNem_Bridge_GHZ
	PLC_Entry	($4D0*$20),	ArtNem_SwingingPlatforms
	PLC_End		GHZ
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Green Hill Zone secondary
; --------------------------------------------------------------------------------------
	PLC_Start	GHZ2
	PLC_Entry	($4E0*$20),	ArtNem_Motobug
	PLC_Entry	($6C0*$20),	ArtNem_RockGHZ
	PLC_End		GHZ2
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Chemical Plant Zone primary
; --------------------------------------------------------------------------------------
	PLC_Start	CPZ
	PLC_Entry	0,		ArtNem_CPZ
	;PLC_Entry	($3D0*$20),	ArtNem_CPZ_Unknown	; Fake Paralax Placeholder area
	PLC_Entry	($400*$20),	ArtNem_PlatformsCPZ
	PLC_End		CPZ
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Chemical Plant Zone secondary
; --------------------------------------------------------------------------------------
	PLC_Start	CPZ2
	PLC_Entry	($434*$20),	ArtNem_UprightSpikes
	PLC_Entry	($43C*$20),	ArtNem_DSpring
	PLC_Entry	($45C*$20),	ArtNem_VSpring
	PLC_Entry	($470*$20),	ArtNem_HSpring
	PLC_End		CPZ2
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Morning Mill Zone primary
; --------------------------------------------------------------------------------------
	PLC_Start	MMZ
	PLC_Entry	0,		ArtNem_MMZ
	PLC_Entry	($400*$20),	ArtNem_PlatformsCPZ
	PLC_End		MMZ
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Morning Mill Zone secondary
; --------------------------------------------------------------------------------------
	PLC_Start	MMZ2
	PLC_Entry	($434*$20),	ArtNem_UprightSpikes
	PLC_Entry	($43C*$20),	ArtNem_DSpring
	PLC_Entry	($45C*$20),	ArtNem_VSpring
	PLC_Entry	($470*$20),	ArtNem_HSpring
	PLC_End		MMZ2
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Emerald Hill Zone primary
; --------------------------------------------------------------------------------------
	PLC_Start	EHZ
	PLC_Entry	0,		ArtNem_EHZ
	;PLC_Entry	($39E*$20),	ArtNem_Fireball
	PLC_Entry	($3AE*$20),	ArtNem_Waterfall_EHZ
	PLC_Entry	($3C6*$20),	ArtNem_Bridge_EHZ
	PLC_Entry	($3CE*$20),	ArtNem_Seesaw
	PLC_Entry	($434*$20),	ArtNem_UprightSpikes
	PLC_Entry	($43C*$20),	ArtNem_DSpring
	PLC_Entry	($45C*$20),	ArtNem_VSpring
	PLC_Entry	($470*$20),	ArtNem_HSpring
	PLC_End		EHZ
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Emerald Hill Zone secondary
; --------------------------------------------------------------------------------------
	PLC_Start	EHZ2
	PLC_Entry	($3E6*$20),	ArtNem_Buzzer
	PLC_Entry	($402*$20),	ArtNem_Motomollusk
	PLC_Entry	($41C*$20),	ArtNem_Masher
	PLC_End		EHZ2
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Hidden Palace Zone primary
; --------------------------------------------------------------------------------------
	PLC_Start	HPZ
	PLC_Entry	0,		ArtNem_HPZ
	PLC_Entry	($300*$20),	ArtNem_Bridge_HPZ
	PLC_Entry	($315*$20),	ArtNem_HPZWaterfall
	PLC_Entry	($34A*$20),	ArtNem_Platform_HPZ
	PLC_Entry	($35A*$20),	ArtNem_HPZ_PulsingBall
	PLC_Entry	($37C*$20),	ArtNem_HPZ_Various
	PLC_Entry	($392*$20),	ArtNem_HPZ_Diamond
	PLC_Entry	($400*$20),	ArtNem_WaterSurface
	PLC_End		HPZ
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Hidden Palace Zone secondary
; --------------------------------------------------------------------------------------
	PLC_Start	HPZ2
	PLC_Entry	($500*$20),	ArtNem_Redz
	PLC_Entry	($530*$20),	ArtNem_BBat
;	PLC_Entry	($300*$20),	ArtNem_Gator
;	PLC_Entry	($32C*$20),	ArtNem_Buzzer
;	PLC_Entry	($3C4*$20),	ArtNem_Stegway
	PLC_Entry	($530*$20),	ArtNem_BFish
	PLC_End		HPZ2
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Hill Top Zone primary
; --------------------------------------------------------------------------------------
	PLC_Start	HTZ
	PLC_Entry	0, 		ArtNem_HTZ
	;PLC_Entry	($500*$20), 	ArtNem_HTZ_AniPlaceholders
	;PLC_Entry	($39E*$20), 	ArtNem_Fireball_EHZ
	;PLC_Entry	($3AE*$20), 	ArtNem_Fireball_HTZ
	PLC_Entry	($3BE*$20), 	ArtNem_Door_HTZ
	PLC_Entry	($3C6*$20), 	ArtNem_Bridge_EHZ
	PLC_Entry	($3CE*$20), 	ArtNem_Seesaw
	PLC_Entry	($434*$20), 	ArtNem_UprightSpikes
	PLC_Entry	($43C*$20), 	ArtNem_DSpring
	PLC_End		HTZ
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Hill Top Zone secondary
; --------------------------------------------------------------------------------------
	PLC_Start	HTZ2
	PLC_Entry	($3E6*$20),	ArtNem_Lift_HTZ
	PLC_Entry	($45C*$20),	ArtNem_UprightSpikes
	PLC_Entry	($470*$20),	ArtNem_HSpring
	;PLC_Entry	($3E6*$20),	Nem_Buzzer
	;PLC_Entry	($402*$20),	Nem_Motomollusk
	;PLC_Entry	($41C*$20),	Nem_Masher
	PLC_End		HTZ2
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Casino Night Zone primary
; --------------------------------------------------------------------------------------
	PLC_Start	CNZ
	PLC_Entry	0,		ArtNem_CNZ
;	PLC_Entry	($3D0*$20),	ArtNem_CPZ_Unknown
;	PLC_Entry	($400*$20),	ArtNem_CPZ_FloatingPlatform
	PLC_End		CNZ
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Casino Night Zone secondary
; --------------------------------------------------------------------------------------
	PLC_Start	CNZ2
	PLC_Entry	($434*$20),	ArtNem_UprightSpikes
	PLC_Entry	($43C*$20),	ArtNem_DSpring
	PLC_Entry	($45C*$20),	ArtNem_VSpring
	PLC_Entry	($470*$20),	ArtNem_HSpring
	PLC_End		CNZ2
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Green Hill Zone animals
; --------------------------------------------------------------------------------------
	PLC_Start	GHZAnimals
	PLC_Entry	($580*$20),	ArtNem_Pocky	; Bnnuy
	PLC_Entry	($592*$20),	ArtNem_Flicky	; Really? you can't figure this one out?
	PLC_End		GHZAnimals
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Chemical Plant Zone animals
; --------------------------------------------------------------------------------------
	PLC_Start	CPZAnimals
	PLC_Entry	($580*$20),	ArtNem_Pecky	; Penguin
	PLC_Entry	($592*$20),	ArtNem_Rocky	; Seal
	PLC_End		CPZAnimals
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Morning Mill animals
; --------------------------------------------------------------------------------------
	PLC_Start	MMZAnimals
	PLC_Entry	($580*$20),	ArtNem_Ricky	; Squirrel
	PLC_Entry	($592*$20),	ArtNem_Rocky	; Seal
	PLC_End		MMZAnimals
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Emerald Hill Zone animals
; --------------------------------------------------------------------------------------
	PLC_Start	EHZAnimals
	PLC_Entry	($580*$20),	ArtNem_Picky	; Pig
	PLC_Entry	($592*$20),	ArtNem_Flicky	; I'm not gonna say it, you can figure it out
	PLC_End		EHZAnimals
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Hidden Palace Zone animals
; --------------------------------------------------------------------------------------
	PLC_Start	HPZAnimals
	PLC_Entry	($580*$20),	ArtNem_Picky	; Pig
	PLC_Entry	($592*$20),	ArtNem_Cucky	; Chicken
	PLC_End		HPZAnimals
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Hill Top Zone animals
; --------------------------------------------------------------------------------------
	PLC_Start	HTZAnimals
	PLC_Entry	($580*$20),	ArtNem_Pocky	; Bunny
	PLC_Entry	($592*$20),	ArtNem_Cucky	; I know they've been renamed to "Clucky" but I'm keeping the og cause beta slop
	PLC_End		HTZAnimals
; --------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Casino Night animals
; --------------------------------------------------------------------------------------
	PLC_Start	CNZAnimals	; I keep reading that as Carnival Night
	PLC_Entry	($580*$20),	ArtNem_Pocky	; Bunny
	PLC_Entry	($592*$20),	ArtNem_Cucky	; Chicken
	PLC_End		CNZAnimals
; --------------------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; Sega and title screen assets
; ---------------------------------------------------------------------------
	Nem_Add	SEGALogo,		Logo\Art\,	SEGALogo
	Eni_Add	SEGALogo,		Logo\Art\,	SEGALogo	
	Eni_Add	TitleMap,		Title\,		TitleMap	
	Eni_Add	TitleBg1,		Title\,		TitleBg1
	Eni_Add	TitleBg2,		Title\,		TitleBg2
	Nem_Add	Title,			Title\,		Title
	Nem_Add	TitleSonicTails,	Title\,		TitleSonicTails
; ---------------------------------------------------------------------------
S1SS_MapIndex:	include	"SpecialStage\Special Stage Mappings & VRAM Pointers.asm"
; ===========================================================================
; Rather humourously, these sprite mappings are not stored in the Sonic 1 format
; ---------------------------------------------------------------------------
	Map_Add	SS_R,		SpecialStage\Art\, R
	Map_Add	SS_Glass,	SpecialStage\Art\, Glass
	Map_Add	SS_Up,		SpecialStage\Art\, UP
	Map_Add	SS_Down,	SpecialStage\Art\, DOWN
	Map_Add	SS_Chaos,	SpecialStage\Art\, Chaos
	Map_Add	SSWalls,	SpecialStage\Art\, Walls
	Map_Add	SS_Bump,	SpecialStage\Art\, Bumper
; ---------------------------------------------------------------------------
	Nem_Add	SSWalls,	SpecialStage\Art\, Walls
	Nem_Add	Bumper,		SpecialStage\Art\, Bumper
	Nem_Add	SSGOAL,		SpecialStage\Art\, GOAL
	Nem_Add	SSUpDown,	SpecialStage\Art\, UPDOWN
	Nem_Add	SSRBlock,	SpecialStage\Art\, R
	Nem_Add	SS1UpBlock,	SpecialStage\Art\, 1UP
	Nem_Add	SSEmStars,	SpecialStage\Art\, EmeraldTwinkle
	Nem_Add	SSRedWhite,	SpecialStage\Art\, RedWhite
	Nem_Add	SSGhost,	SpecialStage\Art\, Ghost
	Nem_Add	SSWBlock,	SpecialStage\Art\, W
	Nem_Add	SSLBlock,	SpecialStage\Art\, L
	Nem_Add	SSGlass,	SpecialStage\Art\, Glass
; ---------------------------------------------------------------------------
S1SS_1:		incbin	"SpecialStage/Layout/Layout1.bin"
S1SS_2:		incbin	"SpecialStage/Layout/Layout2.bin"
S1SS_3:		incbin	"SpecialStage/Layout/Layout3.bin"
S1SS_4:		incbin	"SpecialStage/Layout/Layout4.bin"
S1SS_5:		incbin	"SpecialStage/Layout/Layout5.bin"
S1SS_6:		incbin	"SpecialStage/Layout/Layout6.bin"
S1SS_7:		incbin	"SpecialStage/Layout/Layout7.bin"
		even
; ===========================================================================
; All the Zone data you could need, all included in one neat little package!
		include	"Level\Level Data.asm"
; ---------------------------------------------------------------------------
LevelSelectText:
	dc.b "     Green Hill -Stage 1"	; Temporary
	dc.b "           Zone -Stage 2"
	dc.b "                -Stage 3"
	dc.b "                - Boss ", $0
	dc.b " Chemical Plant -Stage 1"
	dc.b "           Zone -Stage 2"
	dc.b "                -Stage 3"
	dc.b "                - Boss ", $0
	dc.b "   Morning Mill -Stage 1"
	dc.b "           Zone -Stage 2"
	dc.b "                -Stage 3"
	dc.b "                - Boss ", $0
	dc.b "   Emerald Hill -Stage 1"
	dc.b "           Zone -Stage 2"
	dc.b "                -Stage 3"
	dc.b "                - Boss ", $0
	dc.b "  Hidden Palace -Stage 1"
	dc.b "           Zone -Stage 2"
	dc.b "                -Stage 3"
	dc.b "                - Boss ", $0
	dc.b "       Hill Top -Stage 1"
	dc.b "           Zone -Stage 2"
	dc.b "                -Stage 3"
	dc.b "                - Boss ", $0
	dc.b "   Casino Night -Stage 1"
	dc.b "           Zone -Stage 2"
	dc.b "                -Stage 3"
	dc.b "                - Boss ", $0
	dc.b "  Special Stage         "
	dc.b "   Sound Select \       "
LevelSelectMax		equ	30

	Artunc_Add none, HitboxViewer,	Logo\Art\, HitboxViewer	; Hitbox Viewer
	Artunc_Add none, DebugTXT,	Routines\, DebugTXT	; Text used in Debug Mode and Error Handler

; ---------------------------------------------------------------------------
; Modified Type 1b 68000 Sound Driver
; Same as Sonic 1's
; ---------------------------------------------------------------------------
		include	"s2.sounddriver.asm"
; ---------------------------------------------------------------------------
	if	(Lockon)
; ---------------------------------------------------------------------------
c	=	$150D26-*
d	=	(c/($200000/100))
FreeROMSpace	=	FreeROMSpace+c
		inform 0,"ROM : \#c\ (\#d\%) bytes free before S3 Exploit area"
; ---------------------------------------------------------------------------
;	incbin	"EASTEREGG.ZIP"	; Easter Egg Zip file
; ---------------------------------------------------------------------------
c	=	$150D26-*
;d	=	(c/($200000/100))
;	if	($150D26>*)
;		inform 0,"ROM : \#c\ (\#d\%) bytes free after Adding Easter Egg"
;	else
;c	=	*
;		inform 3,"$\#c\ > $150D26, Zip Easter Egg too large"
;	endif	
; ---------------------------------------------------------------------------
		dcb.b	c, $FF

; Devon's Optimized Kosinski Exploit
	dc.w	%0101010101010101
	dc.b	$00		; Write "00"
	dc.b	$FF, $F8, $F3	; Copy "00" 244 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times

	rept	30
	dc.w	%0101010101010101
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	endr

	dc.w	%0101010111110101
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$FF, $F8, $FF	; Copy "00" 256 times
	dc.b	$00, $00	; Write "00 00"

	dc.w	%0010111100000000
	dc.b	$00		; Write "00"
	dc.l	(SNK_Entry+$200000)	; Write return address
	dc.b	$00, $F0, $00	; End of data
	even
; ---------------------------------------------------------------------------
	include	"SKLockon\SK.ROMandRAM.asm"
; ---------------------------------------------------------------------------
SNK_Entry:
		Disable_Ints
	;	lea	@msg1,a0
	;	lea	$FFFF0000,a1
	;	move.w	#$400,d7
	;	@loop:
	;	move.b	(a0)+,d0
	;	eor.b	#%01010101,d0	
	;	move.b	d0,(a1)+
	;	dbf	d7,@loop
	;	bra.s	offset(*)

		lea	System_Stack,sp
		move.b	#0,($A130F1).l		; Access ROM, not "SRAM"

	; Not using KtEiS2 exploit
	;	move.l	#$0584,($FFFFFFF2).w	; back to normal S&K VBI
	;	move.l	#$0D10,($FFFFFFF8).w	; back to normal S&K HBI

		jsr	SK_SndDrvInit

		lea	(vdp_data_port).l,a6

		locCRAM	0
		move.w	#cBlue,(a6)

		locCRAM	2*14
		move.w	#cBlack,(a6)
		locCRAM	2*15
		move.w	#cWhite,(a6)

		locVRAM	0+$600
		lea	(Artunc_DebugTXT+$200000).l,a0
		move.w	#(ArtSize_DebugTXT)-1,d1
	@loadgfx:
		move.l	(a0)+,(a6)
		dbf	d1,@loadgfx

		lea	(@msg1+$200000),a0
		locVRAM	(VRAM_FG+2+128*05)
		bsr	@showchars
		locVRAM	(VRAM_FG+2+128*07)
		bsr	@showchars
		locVRAM	(VRAM_FG+2+128*08)
		bsr	@showchars
		locVRAM	(VRAM_FG+2+128*11)
		bsr	@showchars
		locVRAM	(VRAM_FG+2+128*12)
		bsr	@showchars

		move.l	#$80058144,(vdp_Control_port).l	; enable display
		
		moveq	#$27,d0
		jsr	SK_Play_Music

		Enable_Ints

	@infloop:

		bra.s	@infloop

	@showchars:
		moveq	#38-1,d7
		@loopchars:
		move.w	#$8000,d0
		move.b	(a0)+,d0
		move.w	d0,(a6)
		dbf	d7,@loopchars	; repeat for number of characters
		@_end:
		rts
; ---------------------------------------------------------------------------
	@msg1:	
		dc.b	"_________<_<SORRY_NOTHING>_>__________"
		dc.b	"____<_CURRENTLY_THERE_IS_NOTHING_>____"
		dc.b	"_WHEN_CONNECTED_TO_SONIC_AND_KNUCKLES_"
		dc.b	"_____<_PLEASE_CHECK_BACK_LATER_>______"
		dc.b	"_______<_WE^RE_WORKING_ON_IT_>________"
; ---------------------------------------------------------------------------
		endif

c	=	*
d	=	(c/($200000/100))
		inform 0,"ROM : \#c\ (\#d\%) bytes before final padding"
		dcb.b	$1FFEB0-*, $FF		
	dc.b	"You've reached the end of the SLOP!"
		dcb.b	$200000-*, $69

d	=	(FreeROMSpace/($200000/100))
		inform 0,"Total free ROM space : \#FreeROMSpace\ (\#d\%) bytes. (not counting extra zip file easter egg)"
; ---------------------------------------------------------------------------

EndOfRom:	; end of 'ROM'
		END
