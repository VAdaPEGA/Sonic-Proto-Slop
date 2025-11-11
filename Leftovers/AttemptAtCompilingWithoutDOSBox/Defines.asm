; -----------------------------------
; Memory
.MEMORYMAP
SLOTSIZE $8000
DEFAULTSLOT 0
SLOT 0 $0000	; RAM
SLOT 1 $8000	; ROM
SLOTSIZE $8000
.ENDME

.ROMBANKMAP
BANKSTOTAL 4
BANKSIZE $8000-$2000
BANKS 1
BANKSIZE $8000-1
BANKS 3
.ENDRO

.EMPTYFILL $00
; -----------------------------------
; Registers
.DEF PPU_CTRL_REG1	$2000
.DEF PPU_CTRL_REG2	$2001
.DEF PPU_STATUS		$2002
.DEF PPU_SPR_ADDR	$2003
.DEF PPU_SPR_DATA	$2004
.DEF PPU_SCROLL_REG	$2005
.DEF PPU_ADDRESS	$2006
.DEF PPU_DATA		$2007

.DEF SND_REGISTER	$4000
.DEF SND_SQUARE1_REG	$4000
.DEF SND_SQUARE2_REG	$4004
.DEF SND_TRIANGLE_REG	$4008
.DEF SND_NOISE_REG	$400c
.DEF SND_DELTA_REG	$4010
.DEF SND_MASTERCTRL_REG	$4015

.DEF SPR_DMA		$4014
.DEF JOYPAD_PORT	$4016
.DEF JOYPAD_PORT1	$4016
.DEF JOYPAD_PORT2	$4017
; -----------------------------------
;.STRUCT game_object
;x DB
;y DB
;.ENDST

;.RAMSECTION "vars 1" BANK 0 SLOT 0
;moomin    DW
;phantom   DB
;nyanko    DB
;enemy     INSTANCEOF game_object
;.ENDS
; -----------------------------------
	.def TopScoreDisplay	$07d7	
; -----------------------------------
; Controller
	.DEF BtnA	%10000000
	.DEF BtnB	%01000000
	.DEF BtnSelect	%00100000
	.DEF BtnStart	%00010000
	.DEF BtnUp	%00001000
	.DEF BtnDn	%00000100
	.DEF BtnL	%00000010
	.DEF BtnR	%00000001
; -----------------------------------
; MMC1 Mapper
	.DEF MMC1_Ctrl	$8008
	.DEF PGRBank	$EAAE
	.DEF CHRBank0	$BEEF
	.DEF CHRBank1	$DEE5
; -----------------------------------