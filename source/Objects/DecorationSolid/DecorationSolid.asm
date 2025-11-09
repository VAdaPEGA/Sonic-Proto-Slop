; ===========================================================================
; Solid Objects such as GHZ Purple Rock
Deco_Width	= $30	; (2 bytes)	Width of object
; ===========================================================================
		tst.b	routine(a0)
		beq	SmBlock_Init		; Inherited from Object\SmashableSolid
		out_of_range	DeleteObject
		move.w	Deco_Width(a0),d1	; Width
		move.w	y_radius(a0),d2		; Height
		move.w	d2,d3
		move.w	x_pos(a0),d4
		bsr	SolidObject
		bra	DisplaySprite
; ---------------------------------------------------------------------------