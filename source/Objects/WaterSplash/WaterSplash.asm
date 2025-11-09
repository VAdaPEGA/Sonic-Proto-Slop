; ---------------------------------------------------------------------------
; Object 08 - water splash
; ---------------------------------------------------------------------------

Obj08:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj08_Index(pc,d0.w),d1
		jmp	Obj08_Index(pc,d1.w)
; ===========================================================================
Obj08_Index:	dc.w Obj08_Init-Obj08_Index
		dc.w Obj08_Display-Obj08_Index
		dc.w Obj08_Delete-Obj08_Index
; ===========================================================================

Obj08_Init:
		addq.b	#2,routine(a0)
		move.l	#Map_WaterSplash,mappings(a0)
		ori.b	#4,render_flags(a0)
		move.b	#1,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.w	#$4259,art_tile(a0)
		jsr	Adjust2PArtPointer
		move.w	(MainCharacter+x_pos).w,x_pos(a0)

Obj08_Display:
		move.w	(Water_Level_1).w,y_pos(a0)
		lea	(Ani_WaterSplash).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

Obj08_Delete:
		jmp	(DeleteObject).l