.include    "Defines.asm"
;-------------------------------------------------------------------------------------
.BANK 0 SLOT 1
.ORGA $8000+$2000
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