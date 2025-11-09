SmashObject:	
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		add.w	d0,d0
		movea.l	mappings(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#2,a3
		bset	#5,render_flags(a0)
		move.b	id(a0),d4
		move.b	render_flags(a0),d5
		movea.l	a0,a1
		bra.s	loc_C9CA
; ---------------------------------------------------------------------------
loc_C9C2:	
		jsr	SingleObjLoad
		bne.s	loc_CA1C
		addq.w	#8,a3

loc_C9CA:	
		move.b	routine(a0),routine(a1)
		move.b	d4,id(a1)
		move.l	a3,mappings(a1)
		move.b	d5,render_flags(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	priority(a0),priority(a1)
		move.b	width_pixels(a0),width_pixels(a1)
		move.w	(a4)+,x_vel(a1)
		move.w	(a4)+,y_vel(a1)
		cmpa.l	a0,a1
		bcc.s	loc_CA18
		move.l	a0,-(sp)
		movea.l	a1,a0
		bsr.w	ObjectMove
		add.w	d2,y_vel(a0)
		movea.l	(sp)+,a0
		bsr.w	DisplaySprite2

loc_CA18:				; CODE XREF: SmashObject+66j
		dbf	d1,loc_C9C2

loc_CA1C:				; CODE XREF: SmashObject+28j
		move.w	#$CB,d0	; 'Ë'
		jmp	(PlaySound_Special).l
; ---------------------------------------------------------------------------