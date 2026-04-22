; ===========================================================================
; Smashable wall like the ones found in GHZ
; 
; ===========================================================================
Obj3C:	
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	@Index(pc,d0.w),d1
	jsr	@Index(pc,d1.w)
	bra.w	MarkObjGone
; ===========================================================================
	IndexStart
	GenerateIndex	@Init
	GenerateIndex	@Main
	GenerateIndex	@Piece
; ===========================================================================
	@Init:	
	addq.b	#2,routine(a0)
	move.l	#Map_Obj3C,mappings(a0)
	move.w	#ByteGfxPal2+$590,art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#ByteRenderCoord,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.b	subtype(a0),mapping_frame(a0)
; ---------------------------------------------------------------------------
	@Main:	
	move.w	(MainCharacter+x_vel).w,$30(a0)
	move.w	#$1B,d1
	move.w	#$20,d2
	move.w	#$20,d3
	move.w	x_pos(a0),d4
	bsr.w	SolidObject
	lea	(MainCharacter).w,a1
	cmpi.b	#SonicAniID_Roll,anim(a1)
	bne.s	@DoNothing
		tst.w	x_vel(a1)
		beq.s	@CheckSpeed
		; Hey, if you're implementing knuckles, this is
		; the right spot to add a check for him, wink wink!
	@DoNothing:	
	rts
; ---------------------------------------------------------------------------
	@CheckSpeed:	
	move.w	$30(a0),d0
	bpl.s	@MovingRight
		neg.w	d0
	@MovingRight:
	cmpi.w	#$480,d0	; check player's speed
	bcs.s	@DoNothing	; branch if too slow
		move.w	$30(a0),x_vel(a1)
		addq.w	#4,x_pos(a1)
		lea	(Obj3C_FragSpdRight).l,a4
		move.w	x_pos(a0),d0
		cmp.w	x_pos(a1),d0
		bcs.s	@PushBackRight
			subi.w	#8,x_pos(a1)
			lea	(Obj3C_FragSpdLeft).l,a4
		@PushBackRight:	
		addq.b	#2,routine(a0)
		move.w	x_vel(a1),ground_speed(a1)
		bclr	#BitStatusP1Push,status(a0)
		bclr	#BitPlayerStatusPush,status(a1)
		moveq	#8-1,d1	; Number of pieces
		move.w	#$70,d2	; gravity of pieces
		bsr.s	SmashObject
; ---------------------------------------------------------------------------
	@Piece:	
	bsr.w	ObjectMove
	addi.w	#$70,y_vel(a0)
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
	bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		include	"Objects\BreakableWall\SmashObject.asm"
; ---------------------------------------------------------------------------