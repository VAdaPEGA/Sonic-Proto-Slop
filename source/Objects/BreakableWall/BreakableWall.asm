; ===========================================================================
; Smashable wall like the ones found in GHZ
; 
; ===========================================================================
Obj3C:	
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj3C_Index(pc,d0.w),d1
		jsr	Obj3C_Index(pc,d1.w)
		bra.w	MarkObjGone
; ===========================================================================
Obj3C_Index:	dc.w loc_C8DC-Obj3C_Index
		dc.w loc_C90A-Obj3C_Index
		dc.w loc_C988-Obj3C_Index
; ===========================================================================

loc_C8DC:	
		addq.b	#2,routine(a0)
		move.l	#Map_Obj3C,mappings(a0)
		move.w	#$4590,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#4,priority(a0)
		move.b	$28(a0),mapping_frame(a0)

loc_C90A:	
		move.w	(MainCharacter+x_vel).w,$30(a0)
		move.w	#$1B,d1
		move.w	#$20,d2	; ' '
		move.w	#$20,d3	; ' '
		move.w	x_pos(a0),d4
		bsr.w	SolidObject
		btst	#5,status(a0)
		bne.s	loc_C92E

locret_C92C:	
		rts
; ---------------------------------------------------------------------------

loc_C92E:	
		lea	(MainCharacter).w,a1
		cmpi.b	#2,anim(a1)
		bne.s	locret_C92C
		move.w	$30(a0),d0
		bpl.s	loc_C942
		neg.w	d0

loc_C942:	
		cmpi.w	#$480,d0
		bcs.s	locret_C92C
		move.w	$30(a0),x_vel(a1)
		addq.w	#4,x_pos(a1)
		lea	(Obj3C_FragSpdRight).l,a4
		move.w	x_pos(a0),d0
		cmp.w	x_pos(a1),d0
		bcs.s	loc_C96E
		subi.w	#8,x_pos(a1)
		lea	(Obj3C_FragSpdLeft).l,a4

loc_C96E:	
		move.w	x_vel(a1),ground_speed(a1)
		bclr	#5,status(a0)
		bclr	#5,status(a1)
		moveq	#7,d1
		move.w	#$70,d2	; 'p'
		bsr.s	SmashObject

loc_C988:	
		bsr.w	ObjectMove
		addi.w	#$70,y_vel(a0)
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
		include	"Objects\BreakableWall\SmashObject.asm"
; ---------------------------------------------------------------------------