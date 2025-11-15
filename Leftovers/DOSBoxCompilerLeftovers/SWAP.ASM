PPU_CTRL_REG1		= $2000
PPU_CTRL_REG2		= $2001
PPU_STATUS		= $2002
PPU_SPR_ADDR		= $2003
PPU_SPR_DATA		= $2004
PPU_SCROLL_REG		= $2005
PPU_ADDRESS		= $2006
PPU_DATA		= $2007

SND_REGISTER		= $4000
SND_SQUARE1_REG		= $4000
SND_SQUARE2_REG		= $4004
SND_TRIANGLE_REG	= $4008
SND_NOISE_REG		= $400c
SND_DELTA_REG		= $4010
SND_MASTERCTRL_REG	= $4015

SPR_DMA			= $4014
JOYPAD_PORT		= $4016
JOYPAD_PORT1		= $4016
JOYPAD_PORT2		= $4017

TopScoreDisplay       = $07d7	

BtnA		= %10000000
BtnB		= %01000000
BtnSelect	= %00100000
BtnStart	= %00010000
BtnUp		= %00001000
BtnDn		= %00000100
BtnL		= %00000010
BtnR		= %00000001

; MMC1
MMC1_Ctrl	= $8008
PGRBank		= $EAAE
CHRBank0	= $BEEF
CHRBank1	= $DEE5
;-------------------------------------------------------------------------------------
;DIRECTIVES

	.index 8
	.mem 8

	.org 	$8000+$2000

;-------------------------------------------------------------------------------------
; Initialization
;-------------------------------------------------------------------------------------
init:
		sei	; Disable interrupts
;-------------------------------------------------------------------------------------
; Store code in RAM and run
;-------------------------------------------------------------------------------------
		ldx	#(SwapChrEnd-SwapChr)-1
loop:		lda	SwapChr,x
		sta	TopScoreDisplay,x	; store code here so game knows it's a cold boot
		dex	
		bpl	loop
		jmp	TopScoreDisplay
;-------------------------------------------------------------------------------------
SwapChr:	lda	#$80
		sta	$8008
		sta	$EAAE
	
		lda	#%00010
		sta	$8008
		lsr	a
		sta	$8008
		lsr	a
		sta	$8008
		lsr	a
		sta	$8008
		lsr	a
		sta	$8008
	
		lda	#2
		sta	$EAAE
		lsr	a
		sta	$EAAE
		lsr	a
		sta	$EAAE
		sta	$EAAE
		sta	$EAAE
		jmp $8128
SwapChrEnd:
;-------------------------------------------------------------------------------------