;----------------------------------------------------
; Object 52 - Piranha badnik
;----------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj52_Index(pc,d0.w),d1
		jmp	Obj52_Index(pc,d1.w)
; ===========================================================================
Obj52_Index:	dc.w Obj52_Init-Obj52_Index
		dc.w Obj52_Main-Obj52_Index
		dc.w loc_15C48-Obj52_Index
; ===========================================================================
Obj52_Init:	
		addq.b	#2,routine(a0)
		move.l	#Map_BFish,mappings(a0)
		move.w	#$2530,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$A,$20(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		move.b	d0,d1
		andi.w	#$F0,d1	; 'ð'
		add.w	d1,d1
		add.w	d1,d1
		move.w	d1,$3A(a0)
		move.w	d1,$3C(a0)
		andi.w	#$F,d0
		lsl.w	#6,d0
		subq.w	#1,d0
		move.w	d0,$30(a0)
		move.w	d0,$32(a0)
		move.w	#$FF80,x_vel(a0)
		move.l	#$FFFB8000,$36(a0)
		move.w	y_pos(a0),$34(a0)
		bset	#6,status(a0)
		btst	#0,status(a0)
		beq.s	Obj52_Main
		neg.w	x_vel(a0)

Obj52_Main:	
		cmpi.w	#$FFFF,$3A(a0)
		beq.s	loc_15BE4
		subq.w	#1,$3A(a0)

loc_15BE4:				; CODE XREF: ROM:00015BDEj
		subq.w	#1,$30(a0)
		bpl.s	loc_15C06
		move.w	$32(a0),$30(a0)
		neg.w	x_vel(a0)
		bchg	#0,status(a0)
		move.b	#1,prev_anim(a0)
		move.w	$3C(a0),$3A(a0)

loc_15C06:				; CODE XREF: ROM:00015BE8j
		lea	(Ani_Obj52).l,a1
		jsr	AnimateSprite
		jsr	ObjectMove
		tst.w	$3A(a0)
		bgt.w	loc_15D90
		cmpi.w	#$FFFF,$3A(a0)
		beq.w	loc_15D90
		move.l	#$FFFB8000,$36(a0)
		addq.b	#2,routine(a0)
		move.w	#$FFFF,$3A(a0)
		move.b	#2,anim(a0)
		move.w	#1,$3E(a0)
		bra.w	loc_15D90
; ===========================================================================

loc_15C48:				; DATA XREF: ROM:00015B5Eo
		move.w	#$390,(Water_Level_1).w
		lea	(Ani_Obj52).l,a1
		jsr	AnimateSprite
		move.w	$3E(a0),d0
		sub.w	d0,$30(a0)
		bsr.w	sub_15CF8
		tst.l	$36(a0)
		bpl.s	loc_15CA0
		move.w	y_pos(a0),d0
		cmp.w	(Water_Level_1).w,d0
		bgt.w	loc_15D90
		move.b	#3,anim(a0)
		bclr	#6,status(a0)
		tst.b	$2A(a0)
		bne.w	loc_15D90
		move.w	x_vel(a0),d0
		asl.w	#1,d0
		move.w	d0,x_vel(a0)
		addq.w	#1,$3E(a0)
		st	$2A(a0)
		bra.w	loc_15D90
; ===========================================================================

loc_15CA0:				; CODE XREF: ROM:00015C68j
		move.w	y_pos(a0),d0
		cmp.w	(Water_Level_1).w,d0
		bgt.s	loc_15CB4
		move.b	#1,anim(a0)
		bra.w	loc_15D90
; ===========================================================================

loc_15CB4:				; CODE XREF: ROM:00015CA8j
		move.b	#0,anim(a0)
		bset	#6,status(a0)
		bne.s	loc_15CCE
		move.l	$36(a0),d0
		asr.l	#1,d0
		move.l	d0,$36(a0)
		nop

loc_15CCE:				; CODE XREF: ROM:00015CC0j
		move.w	$34(a0),d0
		cmp.w	y_pos(a0),d0
		bgt.w	loc_15D90
		subq.b	#2,routine(a0)
		tst.b	$2A(a0)
		beq.w	loc_15D90
		move.w	x_vel(a0),d0
		asr.w	#1,d0
		move.w	d0,x_vel(a0)
		sf	$2A(a0)
loc_15D90:	
		jmp	(MarkObjGone).l

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
sub_15CF8:				; CODE XREF: ROM:00015C60p
		move.l	x_pos(a0),d2
		move.l	y_pos(a0),d3
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		add.l	$36(a0),d3
		btst	#6,status(a0)
		beq.s	loc_15D34
		tst.l	$36(a0)
		bpl.s	loc_15D2C
		addi.l	#$1000,$36(a0)
		addi.l	#$1000,$36(a0)

loc_15D2C:				; CODE XREF: sub_15CF8+22j
		subi.l	#$1000,$36(a0)

loc_15D34:				; CODE XREF: sub_15CF8+1Cj
		addi.l	#$1800,$36(a0)
		move.l	d2,x_pos(a0)
		move.l	d3,y_pos(a0)
		rts
; End of function sub_15CF8

