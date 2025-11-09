; ===========================================================================
; ---------------------------------------------------------------------------
; Object 41 - springs
; ---------------------------------------------------------------------------

Obj41:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj41_Index(pc,d0.w),d1
		jsr	Obj41_Index(pc,d1.w)
		tst.w	(Two_player_mode).w
		beq.s	loc_E1E0
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------

loc_E1E0:
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
Obj41_Index:	dc.w Obj41_Init-Obj41_Index		; 0
		dc.w Obj41_Up-Obj41_Index		; 2
		dc.w Obj41_Horizontal-Obj41_Index	; 4
		dc.w Obj41_Down-Obj41_Index		; 6
		dc.w Obj41_DiagonallyUp-Obj41_Index	; 8
		dc.w Obj41_DiagonallyDown-Obj41_Index	; $A
; ============================================================================
; loc_E204:
Obj41_Init:
		addq.b	#2,routine(a0)
		move.l	#Map_obj41,mappings(a0)
		move.w	#$4A8,art_tile(a0)
		tst.b	(Current_Zone).w
		beq.s	loc_E22A
		move.w	#$45C,art_tile(a0)

loc_E22A:
		ori.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#4,priority(a0)
		move.b	$28(a0),d0
		lsr.w	#3,d0
		andi.w	#$E,d0
		move.w	Obj41_Init_Subtypes(pc,d0.w),d0
		jmp	Obj41_Init_Subtypes(pc,d0.w)
; ===========================================================================
Obj41_Init_Subtypes:
		dc.w Obj41_Init_Common-Obj41_Init_Subtypes
		dc.w Obj41_Init_Horizontal-Obj41_Init_Subtypes
		dc.w Obj41_Init_Down-Obj41_Init_Subtypes
		dc.w Obj41_Init_DiagonallyUp-Obj41_Init_Subtypes
		dc.w Obj41_Init_DiagonallyDown-Obj41_Init_Subtypes
; ===========================================================================
; loc_E258:
Obj41_Init_Horizontal:
		move.b	#4,routine(a0)
		move.b	#2,anim(a0)
		move.b	#3,mapping_frame(a0)
		move.w	#$4B8,art_tile(a0)
		tst.b	(Current_Zone).w
		beq.s	loc_E27C
		move.w	#$470,art_tile(a0)

loc_E27C:
		move.b	#8,width_pixels(a0)
		bra.s	Obj41_Init_Common
; ===========================================================================
; loc_E284:
Obj41_Init_Down:
		move.b	#6,routine(a0)
		move.b	#6,mapping_frame(a0)
		bset	#1,status(a0)
		bra.s	Obj41_Init_Common
; ===========================================================================
; loc_E298:
Obj41_Init_DiagonallyUp:
		move.b	#8,routine(a0)
		move.b	#4,anim(a0)
		move.b	#7,mapping_frame(a0)
		move.w	#$43C,art_tile(a0)
		bra.s	Obj41_Init_Common
; ===========================================================================
; loc_E2B2:
Obj41_Init_DiagonallyDown:
		move.b	#$A,routine(a0)
		move.b	#4,anim(a0)
		move.b	#$A,mapping_frame(a0)
		move.w	#$43C,art_tile(a0)
		bset	#1,status(a0)
; loc_E2D0:
Obj41_Init_Common:
		move.b	$28(a0),d0
		andi.w	#2,d0
		move.w	Obj41_Strengths(pc,d0.w),$30(a0)
		btst	#1,d0
		beq.s	loc_E2F8
		bset	#5,art_tile(a0)
		tst.b	(Current_Zone).w
		beq.s	loc_E2F8
		move.l	#Map_obj41a,mappings(a0)

loc_E2F8:
		bsr.w	Adjust2PArtPointer
		rts
; ===========================================================================
; word_E2FE:
Obj41_Strengths:	dc.w -$1000
			dc.w -$A00
; ===========================================================================
; loc_E302:
Obj41_Up:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	x_pos(a0),d4
		lea	(MainCharacter).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.w	SolidObject_Always_SingleCharacter
		btst	#3,status(a0)
		beq.s	loc_E32A
		bsr.s	sub_E34E

loc_E32A:
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1
		moveq	#4,d6
		bsr.w	SolidObject_Always_SingleCharacter
		btst	#4,status(a0)
		beq.s	loc_E342
		bsr.s	sub_E34E

loc_E342:
		lea	(Ani_obj41).l,a1
		bra.w	AnimateSprite
; ===========================================================================
		rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_E34E:
		move.w	#$100,anim(a0)
		addq.w	#8,y_pos(a1)
		move.w	$30(a0),y_vel(a1)
		bset	#1,status(a1)
		bclr	#3,status(a1)
		move.b	#$10,anim(a1)
		move.b	#2,routine(a1)
		move.b	$28(a0),d0
		bpl.s	loc_E382
		move.w	#0,x_vel(a1)

loc_E382:
		btst	#0,d0
		beq.s	loc_E3C2
		move.w	#1,ground_speed(a1)
		move.b	#1,flip_angle(a1)
		move.b	#0,anim(a1)
		move.b	#0,flips_remaining(a1)
		move.b	#4,flip_speed(a1)
		btst	#1,d0
		bne.s	loc_E3B2
		move.b	#1,flips_remaining(a1)

loc_E3B2:
		btst	#0,status(a1)
		beq.s	loc_E3C2
		neg.b	flip_angle(a1)
		neg.w	ground_speed(a1)

loc_E3C2:
		andi.b	#$C,d0
		cmpi.b	#4,d0
		bne.s	loc_E3D8
		move.b	#$C,top_solid_bit(a1)
		move.b	#$D,lrb_solid_bit(a1)

loc_E3D8:
		cmpi.b	#8,d0
		bne.s	loc_E3EA
		move.b	#$E,top_solid_bit(a1)
		move.b	#$F,lrb_solid_bit(a1)

loc_E3EA:
		move.w	#$CC,d0
		jmp	(PlaySound_Special).l
; End of function sub_E34E

; ===========================================================================
; loc_E3F4:
Obj41_Horizontal:
		move.w	#$13,d1
		move.w	#$E,d2
		move.w	#$F,d3
		move.w	x_pos(a0),d4
		lea	(MainCharacter).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.w	SolidObject_Always_SingleCharacter
		btst	#5,status(a0)
		beq.s	loc_E434
		move.b	status(a0),d1
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0
		bcs.s	loc_E42C
		eori.b	#1,d1

loc_E42C:
		andi.b	#1,d1
		bne.s	loc_E434
		bsr.s	sub_E474

loc_E434:
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1
		moveq	#4,d6
		bsr.w	SolidObject_Always_SingleCharacter
		btst	#6,status(a0)
		beq.s	loc_E464
		move.b	status(a0),d1
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0
		bcs.s	loc_E45C
		eori.b	#1,d1

loc_E45C:
		andi.b	#1,d1
		bne.s	loc_E464
		bsr.s	sub_E474

loc_E464:
		bsr.w	sub_E54C
		lea	(Ani_obj41).l,a1
		bra.w	AnimateSprite
; ===========================================================================
		rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_E474:
		move.w	#$300,anim(a0)
		move.w	$30(a0),x_vel(a1)
		addq.w	#8,x_pos(a1)
		bset	#0,status(a1)
		btst	#0,status(a0)
		bne.s	loc_E4A2
		bclr	#0,status(a1)
		subi.w	#$10,x_pos(a1)
		neg.w	x_vel(a1)

loc_E4A2:
		move.w	#$F,move_lock(a1)
		move.w	x_vel(a1),ground_speed(a1)
		btst	#2,status(a1)
		bne.s	loc_E4BC
		move.b	#0,anim(a1)

loc_E4BC:
		move.b	$28(a0),d0
		bpl.s	loc_E4C8
		move.w	#0,y_vel(a1)

loc_E4C8:
		btst	#0,d0
		beq.s	loc_E508
		move.w	#1,ground_speed(a1)
		move.b	#1,flip_angle(a1)
		move.b	#0,anim(a1)
		move.b	#1,flips_remaining(a1)
		move.b	#8,flip_speed(a1)
		btst	#1,d0
		bne.s	loc_E4F8
		move.b	#3,flips_remaining(a1)

loc_E4F8:
		btst	#0,status(a1)
		beq.s	loc_E508
		neg.b	flip_angle(a1)
		neg.w	ground_speed(a1)

loc_E508:
		andi.b	#$C,d0
		cmpi.b	#4,d0
		bne.s	loc_E51E
		move.b	#$C,top_solid_bit(a1)
		move.b	#$D,lrb_solid_bit(a1)

loc_E51E:
		cmpi.b	#8,d0
		bne.s	loc_E530
		move.b	#$E,top_solid_bit(a1)
		move.b	#$F,lrb_solid_bit(a1)

loc_E530:
		bclr	#5,status(a0)
		bclr	#6,status(a0)
		bclr	#5,status(a1)
		move.w	#$CC,d0
		jmp	(PlaySound_Special).l
; End of function sub_E474


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_E54C:
		cmpi.b	#3,anim(a0)
		beq.w	locret_E604
		move.w	x_pos(a0),d0
		move.w	d0,d1
		addi.w	#$28,d1
		btst	#0,status(a0)
		beq.s	loc_E56E
		move.w	d0,d1
		subi.w	#$28,d0

loc_E56E:
		move.w	y_pos(a0),d2
		move.w	d2,d3
		subi.w	#$18,d2
		addi.w	#$18,d3
		lea	(MainCharacter).w,a1
		btst	#1,status(a1)
		bne.s	loc_E5C2
		move.w	ground_speed(a1),d4
		btst	#0,status(a0)
		beq.s	loc_E596
		neg.w	d4

loc_E596:
		tst.w	d4
		bmi.s	loc_E5C2
		move.w	x_pos(a1),d4
		cmp.w	d0,d4
		bcs.w	loc_E5C2
		cmp.w	d1,d4
		bcc.w	loc_E5C2
		move.w	y_pos(a1),d4
		cmp.w	d2,d4
		bcs.w	loc_E5C2
		cmp.w	d3,d4
		bcc.w	loc_E5C2
		move.w	d0,-(sp)
		bsr.w	sub_E474
		move.w	(sp)+,d0

loc_E5C2:
		lea	(Sidekick).w,a1
		btst	#1,status(a1)
		bne.s	locret_E604
		move.w	ground_speed(a1),d4
		btst	#0,status(a0)
		beq.s	loc_E5DC
		neg.w	d4

loc_E5DC:
		tst.w	d4
		bmi.s	locret_E604
		move.w	x_pos(a1),d4
		cmp.w	d0,d4
		bcs.w	locret_E604
		cmp.w	d1,d4
		bcc.w	locret_E604
		move.w	y_pos(a1),d4
		cmp.w	d2,d4
		bcs.w	locret_E604
		cmp.w	d3,d4
		bcc.w	locret_E604
		bsr.w	sub_E474

locret_E604:
		rts
; End of function sub_E54C

; ===========================================================================
; loc_E606:
Obj41_Down:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	x_pos(a0),d4
		lea	(MainCharacter).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.w	SolidObject_Always_SingleCharacter
		cmpi.w	#-2,d4
		bne.s	loc_E62C
		bsr.s	sub_E64E

loc_E62C:
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1
		moveq	#4,d6
		bsr.w	SolidObject_Always_SingleCharacter
		cmpi.w	#-2,d4
		bne.s	loc_E642
		bsr.s	sub_E64E

loc_E642:
		lea	(Ani_obj41).l,a1
		bra.w	AnimateSprite
; ===========================================================================
		rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_E64E:
		move.w	#$100,anim(a0)
		subq.w	#8,y_pos(a1)
		move.w	$30(a0),y_vel(a1)
		neg.w	y_vel(a1)
		move.b	$28(a0),d0
		bpl.s	loc_E66E
		move.w	#0,x_vel(a1)

loc_E66E:
		btst	#0,d0
		beq.s	loc_E6AE
		move.w	#1,ground_speed(a1)
		move.b	#1,flip_angle(a1)
		move.b	#0,anim(a1)
		move.b	#0,flips_remaining(a1)
		move.b	#4,flip_speed(a1)
		btst	#1,d0
		bne.s	loc_E69E
		move.b	#1,flips_remaining(a1)

loc_E69E:
		btst	#0,status(a1)
		beq.s	loc_E6AE
		neg.b	flip_angle(a1)
		neg.w	ground_speed(a1)

loc_E6AE:
		andi.b	#$C,d0
		cmpi.b	#4,d0
		bne.s	loc_E6C4
		move.b	#$C,top_solid_bit(a1)
		move.b	#$D,lrb_solid_bit(a1)

loc_E6C4:
		cmpi.b	#8,d0
		bne.s	loc_E6D6
		move.b	#$E,top_solid_bit(a1)
		move.b	#$F,lrb_solid_bit(a1)

loc_E6D6:
		bset	#1,status(a1)
		bclr	#3,status(a1)
		move.b	#2,routine(a1)
		move.w	#$CC,d0
		jmp	(PlaySound_Special).l
; End of function sub_E64E

; ===========================================================================
; loc_E6F2:
Obj41_DiagonallyUp:
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	x_pos(a0),d4
		lea	Obj41_SlopeData_DiagUp,a2
		lea	(MainCharacter).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.w	SlopedSolid_SingleCharacter
		btst	#3,status(a0)
		beq.s	loc_E71A
		bsr.s	sub_E73E

loc_E71A:
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1
		moveq	#4,d6
		bsr.w	SlopedSolid_SingleCharacter
		btst	#4,status(a0)
		beq.s	loc_E732
		bsr.s	sub_E73E

loc_E732:
		lea	(Ani_obj41).l,a1
		bra.w	AnimateSprite
; ===========================================================================
		rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_E73E:
		btst	#0,status(a0)
		bne.s	loc_E754
		move.w	x_pos(a0),d0
		subq.w	#4,d0
		cmp.w	x_pos(a1),d0
		bcs.s	loc_E762
		rts
; ===========================================================================

loc_E754:
		move.w	x_pos(a0),d0
		addq.w	#4,d0
		cmp.w	x_pos(a1),d0
		bcc.s	loc_E762
		rts
; ===========================================================================

loc_E762:
		move.w	#$500,anim(a0)
		move.w	$30(a0),y_vel(a1)
		move.w	$30(a0),x_vel(a1)
		addq.w	#6,y_pos(a1)
		addq.w	#6,x_pos(a1)
		bset	#0,status(a1)
		btst	#0,status(a0)
		bne.s	loc_E79A
		bclr	#0,status(a1)
		subi.w	#$C,x_pos(a1)
		neg.w	x_vel(a1)

loc_E79A:
		bset	#1,status(a1)
		bclr	#3,status(a1)
		move.b	#$10,anim(a1)
		move.b	#2,routine(a1)
		move.b	$28(a0),d0
		btst	#0,d0
		beq.s	loc_E7F6
		move.w	#1,ground_speed(a1)
		move.b	#1,flip_angle(a1)
		move.b	#0,anim(a1)
		move.b	#1,flips_remaining(a1)
		move.b	#8,flip_speed(a1)
		btst	#1,d0
		bne.s	loc_E7E6
		move.b	#3,flips_remaining(a1)

loc_E7E6:
		btst	#0,status(a1)
		beq.s	loc_E7F6
		neg.b	flip_angle(a1)
		neg.w	ground_speed(a1)

loc_E7F6:
		andi.b	#$C,d0
		cmpi.b	#4,d0
		bne.s	loc_E80C
		move.b	#$C,top_solid_bit(a1)
		move.b	#$D,lrb_solid_bit(a1)

loc_E80C:
		cmpi.b	#8,d0
		bne.s	loc_E81E
		move.b	#$E,top_solid_bit(a1)
		move.b	#$F,lrb_solid_bit(a1)

loc_E81E:
		move.w	#$CC,d0
		jmp	(PlaySound_Special).l
; End of function sub_E73E

; ===========================================================================
; loc_E828:
Obj41_DiagonallyDown:
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	x_pos(a0),d4
		lea	Obj41_SlopeData_DiagDown,a2
		lea	(MainCharacter).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.w	SlopedSolid_SingleCharacter
		cmpi.w	#-2,d4
		bne.s	loc_E84E
		bsr.s	sub_E870

loc_E84E:
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1
		moveq	#4,d6
		bsr.w	SlopedSolid_SingleCharacter
		cmpi.w	#-2,d4
		bne.s	loc_E864
		bsr.s	sub_E870

loc_E864:
		lea	(Ani_obj41).l,a1
		bra.w	AnimateSprite
; ===========================================================================
		rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_E870:
		move.w	#$500,anim(a0)
		move.w	$30(a0),y_vel(a1)
		neg.w	y_vel(a1)
		move.w	$30(a0),x_vel(a1)
		subq.w	#6,y_pos(a1)
		addq.w	#6,x_pos(a1)
		bset	#0,status(a1)
		btst	#0,status(a0)
		bne.s	loc_E8AC
		bclr	#0,status(a1)
		subi.w	#$C,x_pos(a1)
		neg.w	x_vel(a1)

loc_E8AC:
		bset	#1,status(a1)
		bclr	#3,status(a1)
		move.b	#2,routine(a1)
		move.b	$28(a0),d0
		btst	#0,d0
		beq.s	loc_E902
		move.w	#1,ground_speed(a1)
		move.b	#1,flip_angle(a1)
		move.b	#0,anim(a1)
		move.b	#1,flips_remaining(a1)
		move.b	#8,flip_speed(a1)
		btst	#1,d0
		bne.s	loc_E8F2
		move.b	#3,flips_remaining(a1)

loc_E8F2:
		btst	#0,status(a1)
		beq.s	loc_E902
		neg.b	flip_angle(a1)
		neg.w	ground_speed(a1)

loc_E902:
		andi.b	#$C,d0
		cmpi.b	#4,d0
		bne.s	loc_E918
		move.b	#$C,top_solid_bit(a1)
		move.b	#$D,lrb_solid_bit(a1)

loc_E918:
		cmpi.b	#8,d0
		bne.s	loc_E92A
		move.b	#$E,top_solid_bit(a1)
		move.b	#$F,lrb_solid_bit(a1)

loc_E92A:
		move.w	#$CC,d0
		jmp	(PlaySound_Special).l
; End of function sub_E870

; ===========================================================================
