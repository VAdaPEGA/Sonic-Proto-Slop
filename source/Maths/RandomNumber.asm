; ---------------------------------------------------------------------------
; Generate a pseudo-random number and store for later randomization
; Output : d0, d1
; CAUTION : Upper word of d1 is the same as lower word of d0
; d0 is better for randomization on a byte level

; d0 = (RNG & $FFFF0000) | ((RNG*41 & $FFFF) + ((RNG*41 & $FFFF0000) >> 16))
; RNG = ((RNG*41 + ((RNG*41 & $FFFF) << 16)) & $FFFF0000) | (RNG*41 & $FFFF)
; ---------------------------------------------------------------------------
RandomNumber:
		move.l	(RNG_seed).w,d1
		bne.s	@SeedIsntZero
		move.l	#"SlOp",d1	; used to be "$2A6D365A"
	@SeedIsntZero:
		; set the high word of d0 to be the high word of the RNG
		; and multiply the RNG by 41
		move.l	d1,d0
		asl.l	#2,d1
		add.l	d0,d1
		asl.l	#3,d1
		add.l	d0,d1

		; add the low word of the RNG to the high word of the RNG
		; and set the low word of d0 to be the result
		move.w	d1,d0
		swap	d1
		add.w	d1,d0
		move.w	d0,d1
		swap	d1

		move.l	d1,(RNG_seed).w
		rts