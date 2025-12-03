;----------------------------------------------------
; Object 0A - drowning bubbles and countdown numbers
;----------------------------------------------------

Obj0A:		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex	 Obj0A, Init
	GenerateIndex	 Obj0A, Animate
	GenerateIndex	 Obj0A, ChkWater
	GenerateIndex	 Obj0A, Display
	GenerateIndex	 Obj0A, Delete
	GenerateIndex	 Obj0A, Countdown
	GenerateIndex	 Obj0A, AirLeft
	GenerateIndex	 Obj0A, Display
	GenerateIndex	 Obj0A, Delete
; ===========================================================================
Obj0A_AirCountdown			=	$32	; (1 byte)
Obj0A_ResetForAirCountdown		=	$33	; (1 byte) set by Subtype, not used in practice
Obj0A_CountdownForAirCountdown		=	$2C	; (2 bytes), resets to 120 (2 seconds)
Obj0A_Init:
		addq.b	#2,routine(a0)
		move.l	#Map_Obj0A_Bubbles,mappings(a0)
		move.w	#$8348,art_tile(a0)
		move.b	#$84,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#1,priority(a0)
		move.b	subtype(a0),d0	; WHY DOES THE SUBTYPE DETERMINE HOW FAST YOU DROWN???
		bpl.s	loc_11ECC
		addq.b	#8,routine(a0)
		move.l	#Map_Obj0A_Countdown,mappings(a0)
		move.w	#$440,art_tile(a0)
		andi.w	#$7F,d0
		move.b	d0,Obj0A_ResetForAirCountdown(a0)
		bra.w	Obj0A_Countdown
; ===========================================================================

loc_11ECC:	
		move.b	d0,anim(a0)
		bsr.w	Adjust2PArtPointer
		move.w	x_pos(a0),$30(a0)
		move.w	#-$88,y_vel(a0)

Obj0A_Animate:	
		lea	(Ani_Obj0A).l,a1
		jsr	(AnimateSprite).l

Obj0A_ChkWater:	
		move.w	(Water_Level_1).w,d0
		cmp.w	y_pos(a0),d0
		bcs.s	loc_11F0A
		move.b	#6,routine(a0)
		addq.b	#7,anim(a0)
		cmpi.b	#$D,anim(a0)
		beq.s	Obj0A_Display
		bra.s	Obj0A_Display
; ===========================================================================

loc_11F0A:	
		tst.b	($FFFFF7C7).w
		beq.s	loc_11F14
		addq.w	#4,$30(a0)

loc_11F14:	
		move.b	angle(a0),d0
		addq.b	#1,angle(a0)
		andi.w	#$7F,d0
		lea	(Obj0A_WobbleData).l,a1
		move.b	(a1,d0.w),d0
		ext.w	d0
		add.w	$30(a0),d0
		move.w	d0,x_pos(a0)
		bsr.s	Obj0A_ShowNumber
		jsr	(ObjectMove).l
		tst.b	render_flags(a0)
		bpl.s	Obj0A_Delete
		jmp	(DisplaySprite).l
; ===========================================================================

Obj0A_Display:	
		bsr.s	Obj0A_ShowNumber
		lea	(Ani_Obj0A).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

Obj0A_Delete:	
		jmp	(DeleteObject).l
; ===========================================================================

Obj0A_AirLeft:	
		cmpi.b	#12,(MainCharacter+Air_Left).w
		bhi.s	loc_11F9A
		subq.w	#1,$38(a0)
		bne.s	loc_11F82
		move.b	#$E,routine(a0)
		addq.b	#7,anim(a0)
		bra.s	Obj0A_Display
; ===========================================================================

loc_11F82:	
		lea	(Ani_Obj0A).l,a1
		jsr	(AnimateSprite).l
		tst.b	render_flags(a0)
		bpl.s	loc_11F9A
		jmp	(DisplaySprite).l
; ===========================================================================

loc_11F9A:	
		jmp	(DeleteObject).l

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj0A_ShowNumber:	
		tst.w	$38(a0)
		beq.s	locret_11FEA
		subq.w	#1,$38(a0)
		bne.s	locret_11FEA
		cmpi.b	#7,anim(a0)
		bcc.s	locret_11FEA
		move.w	#$F,$38(a0)
		clr.w	y_vel(a0)
		move.b	#$80,render_flags(a0)
		move.w	x_pos(a0),d0
		sub.w	(Camera_X_pos).w,d0
		addi.w	#$80,d0	; '€'
		move.w	d0,x_pos(a0)
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0	; '€'
		move.w	d0,x_sub(a0)
		move.b	#$C,routine(a0)

locret_11FEA:	
		rts

Obj0A_Countdown:	
		tst.w	Obj0A_CountdownForAirCountdown(a0)		; THERE ARE THREE COUNTDOWNS???
		bne.w	loc_121D6
		cmpi.b	#6,(MainCharacter+routine).w
		bcc.s	locret_11FEA
		btst	#6,(MainCharacter+status).w
		beq.s	locret_11FEA
		subq.w	#1,$38(a0)
		bpl.w	loc_121FC
		move.w	#$3B,$38(a0)
		move.w	#1,$36(a0)
		jsr	(RandomNumber).l
		andi.w	#1,d0
		move.b	d0,$34(a0)
		move.b	(MainCharacter+Air_Left).w,d0
		cmpi.w	#25,d0			; WHAT IS THIS YANDERE DEV-ASS CODE???
		beq.s	Obj0A_PlayDing
		cmpi.w	#20,d0
		beq.s	Obj0A_PlayDing
		cmpi.w	#15,d0
		beq.s	Obj0A_PlayDing
		cmpi.w	#12,d0
		bhi.s	Obj0A_CountAirDown
		bne.s	Obj0A_CountdownCountdown
		move.w	#$92,d0			; Drown Countdown Music
		jsr	(PlaySound).l

Obj0A_CountdownCountdown:	; I had no other name for it, it is what it is ok? shut up
		subq.b	#1,Obj0A_AirCountdown(a0)
		bpl.s	Obj0A_CountAirDown
		move.b	Obj0A_ResetForAirCountdown(a0),Obj0A_AirCountdown(a0)
		bset	#7,$36(a0)
		bra.s	Obj0A_CountAirDown
; ===========================================================================

Obj0A_PlayDing:	
		move.w	#$C2,d0
		jsr	(PlaySound_Special).l

Obj0A_CountAirDown:	
		subq.b	#1,(MainCharacter+Air_Left).w
		bcc.w	loc_1220C
		
		move.w	#$B2,d0	; '²'
		jsr	(PlaySound_Special).l
		move.b	#$A,$34(a0)
		move.w	#1,$36(a0)
		move.w	#120,Obj0A_CountdownForAirCountdown(a0)
		move.l	a0,-(sp)
		lea	(MainCharacter).w,a0
		jsr	Obj01_WaterResumeMusic
		jsr	Sonic_ResetOnFloor
		move.b	#$17,anim(a0)
		bset	#1,status(a0)
		bset	#7,art_tile(a0)
		move.w	#0,y_vel(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,ground_speed(a0)
		move.b	#1,($FFFFEEDC).w
		move.b	#$81,obj_control(a0)
		movea.l	(sp)+,a0
		rts
; ===========================================================================
loc_121D6:	
		subq.w	#1,Obj0A_CountdownForAirCountdown(a0)
		bne.s	loc_121E4
		move.b	#6,(MainCharacter+routine).w
		rts
; ===========================================================================

loc_121E4:	
		move.l	a0,-(sp)
		lea	(MainCharacter).w,a0
		jsr	(ObjectMove).l
		addi.w	#$10,y_vel(a0)
		movea.l	(sp)+,a0
		;bra.s	loc_121FC
; ===========================================================================
loc_121FC:	
		tst.w	$36(a0)
		beq.w	locret_122DC
		subq.w	#1,$3A(a0)
		bpl.w	locret_122DC

loc_1220C:	
		jsr	(RandomNumber).l
		andi.w	#$F,d0
		move.w	d0,$3A(a0)
		jsr	(SingleObjLoad).l
		bne.w	locret_122DC
		move.b	#$A,id(a1)
		move.w	(MainCharacter+x_pos).w,x_pos(a1)
		moveq	#6,d0
		btst	#0,(MainCharacter+status).w
		beq.s	loc_12242
		neg.w	d0
		move.b	#$40,angle(a1)

loc_12242:	
		add.w	d0,x_pos(a1)
		move.w	(MainCharacter+y_pos).w,y_pos(a1)
		move.b	#6,$28(a1)
		tst.w	Obj0A_CountdownForAirCountdown(a0)
		beq.w	loc_1228E
		andi.w	#7,$3A(a0)
		addi.w	#0,$3A(a0)
		move.w	(MainCharacter+y_pos).w,d0
		subi.w	#$C,d0
		move.w	d0,y_pos(a1)
		jsr	(RandomNumber).l
		move.b	d0,angle(a1)
		move.w	($FFFFFE04).w,d0
		andi.b	#3,d0
		bne.s	loc_122D2
		move.b	#$E,$28(a1)
		bra.s	loc_122D2
; ===========================================================================
loc_1228E:	
		btst	#7,$36(a0)
		beq.s	loc_122D2
		move.b	(MainCharacter+Air_Left).w,d2
		lsr.w	#1,d2
		jsr	(RandomNumber).l
		andi.w	#3,d0
		bne.s	loc_122BA
		bset	#6,$36(a0)
		bne.s	loc_122D2
		move.b	d2,$28(a1)
		move.w	#$1C,$38(a1)

loc_122BA:	
		tst.b	$34(a0)
		bne.s	loc_122D2
		bset	#6,$36(a0)
		bne.s	loc_122D2
		move.b	d2,$28(a1)
		move.w	#$1C,$38(a1)

loc_122D2:	
		subq.b	#1,$34(a0)
		bpl.s	locret_122DC
		clr.w	$36(a0)

locret_122DC:	
		rts
; ===========================================================================

