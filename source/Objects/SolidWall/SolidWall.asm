; ===========================================================================
; Object 44 - GHZ wall
; ---------------------------------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex	 Obj44, Init
	GenerateIndex	 Obj44, Main
	GenerateIndex	 Obj44, Display
; ===========================================================================
Obj44_Init:
		addq.b	#2,routine(a0)
		move.l	#Map_SolidWall_GHZ,mappings(a0)
		move.w	#$434C,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#8,width_pixels(a0)
		move.b	#6,priority(a0)
		move.b	subtype(a0),mapping_frame(a0)
		bclr	#4,mapping_frame(a0)
		beq	Adjust2PArtPointer
		addq.b	#2,routine(a0)
		bra	Adjust2PArtPointer
; ===========================================================================
Obj44_Main:
		move.w	#$13,d1
		move.w	#$28,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		bsr.w	SolidObject
Obj44_Display:
		out_of_range	DeleteObject
		bra.w	DisplaySprite