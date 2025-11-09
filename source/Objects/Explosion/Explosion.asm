; ===========================================================================
; Different types of Explosion effects
Explosion_Boss		equ	4
Explosion_Ground	equ	8
@ResetTime	=	$30
@EndFrame	=	$32
@Score		=	$3E
;----------------------------------------------------
		tst.b	routine(a0)
		beq.s	@SpawnAnimal
		bpl.s	@Init

		move.b	anim_frame_duration(a0),d0
		subq.b	#1,d0
		bpl.s	@DoNothing
		move.b	@ResetTime(a0),d0
		move.b	mapping_frame(a0),d1
		addq.b	#1,d1
		cmp.b	@EndFrame(a0),d1	; Has animation reached past its end?
		beq.w	DeleteObject		; If so, delete
		move.b	d1,mapping_frame(a0)
	@DoNothing:	
		move.b	d0,anim_frame_duration(a0)
		bra.w	DisplaySprite
;----------------------------------------------------
	@SpawnAnimal:
		addq.b	#2,routine(a0)
		clr.b	subtype(a0)	; clear subtype
		jsr	SingleObjLoad
		bne.s	@Init
		move.b	#ObjID_AnimalsAndPoints,id(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	@Score(a0),@Score(a1)	; pass score on
;----------------------------------------------------
	@Init:	
		addq.b	#2,routine(a0)
		move.b	#4,render_flags(a0)
		move.b	#0,collision_flags(a0)

		lea	ExplosionObjectData,a1
		move.l	(a1)+,mappings(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#3,d0
		add.l	d0,a1

		move.w	(a1)+,art_tile(a0)
		move.b	(a1)+,mapping_frame(a0)
		move.b	(a1)+,@EndFrame(a0)
		move.b	(a1),@ResetTime(a0)
		move.b	(a1)+,anim_frame_duration(a0)
		move.b	(a1)+,width_pixels(a0)
		move.b	(a1)+,priority(a0)
		move.b	(a1),d0
		jsr	PlaySound_Special
		bra	Adjust2PArtPointer
;----------------------------------------------------
