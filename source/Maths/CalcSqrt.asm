; ---------------------------------------------------------------------------
; Subroutine calculate a square root (from S1 Rev00 and Protos)
;
; input:	d0.w = number
; output:	d0.b = square root of number (no decimal point)
; note : result will always be byte sized since the square root of 65535 ($FFFF) is ~255
; results may not be great for smaller numbers though due to it being a set loop
; ---------------------------------------------------------------------------
CalcSqrt:
		movem.l	d1-d2,-(sp)

		move.w	d0,d1		; 
		swap	d1		; make copy at d1 and send to upper word
		moveq	#0,d0		; clear d0 (this is where we store the result)
		move.w	d0,d1		; clear lower word of d1
		moveq	#(16/2)-1,d2	; 16 bits, 2 at a time
	@NextBits:
		rol.l	#2,d1		; check 2 bits at a time
		add.w	d0,d0		; double previous result
		addq.w	#1,d0		; add 1
		sub.w	d0,d1		; compare with input
		bhs.s	@IncrementRoot	; if result isn't larger, branch

		add.w	d0,d1		; 
		subq.w	#1,d0		; undo last two operations
		; check end
		dbf	d2,@NextBits	; d0*2
		lsr.w	#1,d0		; divide result by 2
		movem.l	(sp)+,d1-d2
		rts
; ---------------------------------------------------------------------------
	@IncrementRoot:
		addq.w	#1,d0		; Increase Root
		; check end
		dbf	d2,@NextBits	; d0*2+2
		; Max number here is $1FE
		lsr.w	#1,d0		; divide result by 2
		; Max number is exactly $FF
		movem.l	(sp)+,d1-d2
		rts