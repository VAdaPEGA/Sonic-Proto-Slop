CheckSumError:
		bsr.w	VDPSetupGame
	;	move.w	#$4EF9,(v_vbla_jmp).w			; JMP command
	;	move.l	#VBI_Standard,(v_vbla_address).w	; VBI default
		locCRAM	0 					; set VDP to CRAM write
		moveq	#$3F,d7
	@fillred:
		move.w	#cRed,(vdp_data_port).l ; fill palette with red
		dbf	d7,@fillred	; repeat $3F more times
		bsr.w	JoypadInit



		moveq	#16,d1

	;	jsr	MegaPCM_LoadDriver
	;	lea	SampleTable,a0
	;	jsr	MegaPCM_LoadSampleTable
		tst.w	d0		; was sample table loaded successfully?
		beq.s	@SampleTableOk	; if yes, branch
		illegal
	@SampleTableOk:

		@wait:
		dbf	d0,@wait
		dbf	d1,@wait
	;	jmp	GM_Piracy
		rts