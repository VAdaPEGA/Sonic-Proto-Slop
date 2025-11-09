;----------------------------------------------------
; Object 13 - HPZ waterfall
;----------------------------------------------------
	inform 1, "Holy Clucky, please reprogram this to use the subsprite system"
Obj13:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj13_Index(pc,d0.w),d1
		jmp	Obj13_Index(pc,d1.w)
; ===========================================================================
Obj13_Index:	dc.w @Init-Obj13_Index
		dc.w loc_14532-Obj13_Index
		dc.w loc_145BC-Obj13_Index
; ===========================================================================
	@Init:	
		addq.b	#2,routine(a0)
		move.l	#Map_Obj13,mappings(a0)
		move.w	#$E000+$315,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#1,priority(a0)
		move.b	#$12,mapping_frame(a0)

		bsr.s	sub_144D4
		beq.s	@Child1Spawned
		subq.b	#2,routine(a0)
		rts

		@Child1Spawned:
		move.b	#$A0,y_radius(a1)
		bset	#4,render_flags(a1)
		move.l	a1,$38(a0)
		move.w	y_pos(a0),$34(a0)
		move.w	y_pos(a0),$36(a0)
		cmpi.b	#$10,subtype(a0)
		blo.s	loc_14518

		bsr.s	sub_144D4
		bne.s	@Child2Failed

		move.l	a1,$3C(a0)
		move.w	y_pos(a0),y_pos(a1)
		addi.w	#$98,y_pos(a1)
		bra.s	loc_14518

;-----------------------------------------------------------------------------
@Child2Failed:
		subq.b	#2,routine(a0)	; return as safety precaution
		movea.l	$38(a0),a1	; DELETE CHILD 1
		bra.w	DeleteObject2
;-----------------------------------------------------------------------------		

	sub_144D4:	
		jsr	(SingleObjLoad2).l
		bne.s	@ObjectSpawnFail
		move.b	#$13,id(a1)
		addq.b	#4,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	width_pixels(a0),width_pixels(a1)
		move.b	priority(a0),priority(a1)
		moveq	#0,d0
	@ObjectSpawnFail:	
		rts
; End of function sub_144D4

; ===========================================================================

loc_14518:	
		moveq	#0,d1
		move.b	subtype(a0),d1
		move.w	$34(a0),d0
		subi.w	#$78,d0
		lsl.w	#4,d1
		add.w	d1,d0
		move.w	d0,y_pos(a0)
		move.w	d0,$34(a0)

loc_14532:	; Mess with Child
		movea.l	$38(a0),a1
		move.b	#$12,mapping_frame(a0)
		move.w	$34(a0),d0
		move.w	(Water_Level_1).w,d1
		cmp.w	d0,d1
		bcc.s	loc_1454A
		move.w	d1,d0

loc_1454A:	
		move.w	d0,y_pos(a0)
		sub.w	$36(a0),d0
		addi.w	#$80,d0	; '€'
		bmi.s	loc_1459C
		lsr.w	#4,d0
		move.w	d0,d1
		cmpi.w	#$F,d0
		bcs.s	loc_14564
		moveq	#$F,d0

loc_14564:	
		move.b	d0,mapping_frame(a1)
		cmpi.b	#$10,subtype(a0)
		blo.s	loc_14584
		; mess with other child
		movea.l	$3C(a0),a1
		subi.w	#$F,d1
		bcc.s	loc_1457C
		moveq	#0,d1

loc_1457C:	
		addi.w	#$13,d1
		move.b	d1,mapping_frame(a1)

loc_14584:	
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================

loc_1459C:	
		moveq	#$13,d0
		move.b	d0,mapping_frame(a0)
		move.b	d0,mapping_frame(a1)
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ===========================================================================

loc_145BC:	
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
