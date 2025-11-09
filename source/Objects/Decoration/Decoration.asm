; ===========================================================================
; Basic Sprite based Decorations
;----------------------------------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex	2, Decoration, INIT
	GenerateIndex	2, Decoration, DrawStill
	GenerateIndex	2, Decoration, DrawAnimated
Obj1C_Conf:	
@macro	macro	Mappings, Frame, VRAM, Width, Priority
	dc.l Mappings+Frame<<24	; Mappings
	dc.w VRAM		; VRAM
	dc.b Width,  Priority	; Width, Priority
	endm
	;	Mappings,		Frame,	VRAM,	Width,	Priority
	@macro	Map_Bridge_HPZ,		3,	$6300,	4,	1
	@macro	Map_Decoration,		0,	$E35A,	16,	1
	@macro	Map_Bridge_EHZ,		1,	$43C6,	4,	1
	@macro	Map_Bridge_GHZ,		1,	$44C6,	16,	1
	@macro	Map_LiftDiagonal,	1,	$43E6,	8,	4
	@macro	Map_LiftDiagonal,	2,	$43E6,	8,	4
; ===========================================================================
Decoration_INIT:	
		addq.b	#2,routine(a0)
		move.b	subtype(a0),d0
		move.b	d0,d1
		andi.w	#$F0,d0
		beq.s	@NotAnimated
			addq.b	#2,routine(a0)
			lsr.b	#4,d0
			subq.b	#1,d0
			move.b	d0,anim(a0)
	@NotAnimated:
		andi.w	#$000F,d1
		lsl.w	#3,d1
		lea	Obj1C_Conf(pc,d1.w),a1
		move.b	(a1),mapping_frame(a0)
		move.l	(a1)+,mappings(a0)
		move.w	(a1)+,art_tile(a0)
		move.b	(a1)+,width_pixels(a0)
		move.b	(a1),priority(a0)
		ori.b	#4,render_flags(a0)
		bra.w	Adjust2PArtPointer
; ===========================================================================
Decoration_DrawAnimated:	
		lea	(Ani_Obj1C).l,a1
		bsr.w	AnimateSprite
Decoration_DrawStill:
		tst.w	(Two_player_mode).w
		bne.w	DisplaySprite
		out_of_range	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
