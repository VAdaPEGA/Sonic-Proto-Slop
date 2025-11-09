; ===========================================================================
; Masher from EHZ, the silly fish
Obj53_InitY	=	$30	; (2 bytes)
; ---------------------------------------------------------------------------
	tst.b	routine(a0)
	beq.s	@Init
; ---------------------------------------------------------------------------
	lea	(Ani_obj53).l,a1
	jsr	AnimateSprite
	jsr	ObjectMove
	addi.w	#$0018,y_vel(a0)
	move.w	Obj53_InitY(a0),d0
	cmp.w	y_pos(a0),d0
	bcc.s	@loc_17548
		move.w	d0,y_pos(a0)
		move.w	#-$500,y_vel(a0)
	@loc_17548:
	move.b	#1,anim(a0)
	subi.w	#$C0,d0
	cmp.w	y_pos(a0),d0
	bcc.s	@DoNothing
		move.b	#0,anim(a0)
		tst.w	y_vel(a0)
		bmi.s	@DoNothing
			move.b	#2,anim(a0)
	@DoNothing:
	jmp	(MarkObjGone).l
; ===========================================================================
@Init:
	st	routine(a0)
	move.l	#Map_Masher,mappings(a0)
	move.w	#$41C,art_tile(a0)
	jsr	Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#9,collision_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.w	#-$400,y_vel(a0)
	move.w	y_pos(a0),Obj53_InitY(a0)
	rts