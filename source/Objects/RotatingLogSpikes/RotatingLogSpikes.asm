Obj17:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj17_Index(pc,d0.w),d1
		jmp	Obj17_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj17_Index:	dc.w @Init-Obj17_Index
		dc.w @Main-Obj17_Index
		dc.w loc_87AC-Obj17_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

@Init:	
		addq.b	#2,routine(a0)
		move.l	#Map_RotatingLogSpikes,mappings(a0)
		move.w	#$4398,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#7,status(a0)
		move.b	#4,render_flags(a0)
		move.b	#3,priority(a0)
		move.b	#8,width_pixels(a0)
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		move.b	id(a0),d4
		lea	$28(a0),a2
		moveq	#0,d1
		move.b	(a2),d1
		move.b	#0,(a2)+
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3
		subq.b	#2,d1
		bcs.s	@Main
		moveq	#0,d6
	@Loop:	
		jsr	SingleObjLoad2
		bne.s	@Main
		addq.b	#1,subtype(a0)
		move.w	a1,d5
		subi.w	#Object_Space,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#4,routine(a1)
		move.b	d4,id(a1)
		move.w	d2,y_pos(a1)
		move.w	d3,x_pos(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	#$4398,art_tile(a1)
		bsr.w	Adjust2PArtPointer2
		move.b	#4,render_flags(a1)
		move.b	#3,priority(a1)
		move.b	#8,width_pixels(a1)
		move.b	d6,$3E(a1)
		addq.b	#1,d6
		andi.b	#7,d6
		addi.w	#$10,d3
		cmp.w	x_pos(a0),d3
		bne.s	@loc_8746
		move.b	d6,$3E(a0)
		addq.b	#1,d6
		andi.b	#7,d6
		addi.w	#$10,d3
		addq.b	#1,subtype(a0)

	@loc_8746:	
		dbf	d1,@Loop

	@Main:	
		bsr.w	sub_878C
		out_of_range	loc_8766
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8766:	
		moveq	#0,d2
		lea	Subtype(a0),a2
		move.b	(a2)+,d2
		subq.b	#2,d2
		bcs.s	loc_8788
	loc_8772:	
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#Object_Space,d0
		movea.l	d0,a1
		bsr.w	DeleteObject2
		dbf	d2,loc_8772
	loc_8788:	
		bra.w	DeleteObject

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_878C:	
		move.b	(Logspike_anim_frame).w,d0
		move.b	#0,$20(a0)
		add.b	$3E(a0),d0
		andi.b	#7,d0
		move.b	d0,mapping_frame(a0)
		bne.s	locret_87AA
		move.b	#$84,$20(a0)

locret_87AA:	
		rts
; End of function sub_878C

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_87AC:				; DATA XREF: ROM:0000867Eo
		bsr.w	sub_878C
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
