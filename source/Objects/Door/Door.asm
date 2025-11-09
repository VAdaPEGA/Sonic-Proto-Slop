Obj2A:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj2A_Index(pc,d0.w),d1
		jmp	Obj2A_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj2A_Index:	dc.w loc_94FE-Obj2A_Index ; DATA XREF: ROM:Obj2A_Indexo
					; ROM:000094FCo
		dc.w loc_9526-Obj2A_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_94FE:				; DATA XREF: ROM:Obj2A_Indexo
		addq.b	#2,routine(a0)
		move.l	#Map_Obj2A,mappings(a0)
		move.w	#$42E8,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#8,width_pixels(a0)
		move.b	#4,priority(a0)

loc_9526:				; DATA XREF: ROM:000094FCo
		move.w	#$40,d1	; '@'
		clr.b	anim(a0)
		move.w	(MainCharacter+x_pos).w,d0
		add.w	d1,d0
		cmp.w	x_pos(a0),d0
		bcs.s	loc_9564
		sub.w	d1,d0
		sub.w	d1,d0
		cmp.w	x_pos(a0),d0
		bcc.s	loc_9564
		add.w	d1,d0
		cmp.w	x_pos(a0),d0
		bcc.s	loc_9556
		btst	#0,status(a0)
		bne.s	loc_9564
		bra.s	loc_955E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9556:				; CODE XREF: ROM:0000954Aj
		btst	#0,status(a0)
		beq.s	loc_9564

loc_955E:				; CODE XREF: ROM:00009554j
		move.b	#1,anim(a0)

loc_9564:				; CODE XREF: ROM:00009538j
					; ROM:00009542j ...
		lea	(Ani_Obj2A).l,a1
		bsr.w	AnimateSprite
		tst.b	mapping_frame(a0)
		bne.s	loc_9588
		move.w	#$11,d1
		move.w	#$20,d2	; ' '
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		bsr.w	SolidObject

loc_9588:				; CODE XREF: ROM:00009572j
		bra.w	MarkObjGone
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Ani_Obj2A:	dc.w byte_9590-Ani_Obj2A ; DATA	XREF: ROM:loc_9564o
					; ROM:Ani_Obj2Ao ...
		dc.w byte_959C-Ani_Obj2A
byte_9590:	dc.b   0,  8,  7,  6,  5,  4,  3,  2; 0	; DATA XREF: ROM:Ani_Obj2Ao
		dc.b   1,  0,$FE,  1	; 8
byte_959C:	dc.b   0,  0,  1,  2,  3,  4,  5,  6; 0	; DATA XREF: ROM:0000958Eo
		dc.b   7,  8,$FE,  1	; 8
Map_Obj2A:	dc.w word_95BA-Map_Obj2A ; DATA	XREF: ROM:00009502o
					; ROM:Map_Obj2Ao ...
		dc.w word_95CC-Map_Obj2A
		dc.w word_95DE-Map_Obj2A
		dc.w word_95F0-Map_Obj2A
		dc.w word_9602-Map_Obj2A
		dc.w word_9614-Map_Obj2A
		dc.w word_9626-Map_Obj2A
		dc.w word_9638-Map_Obj2A
		dc.w word_964A-Map_Obj2A
word_95BA:	dc.w 2			; DATA XREF: ROM:Map_Obj2Ao
		dc.w $E007, $800, $800,$FFF8; 0
		dc.w	 7, $800, $800,$FFF8; 4
word_95CC:	dc.w 2			; DATA XREF: ROM:000095AAo
		dc.w $DC07, $800, $800,$FFF8; 0
		dc.w  $407, $800, $800,$FFF8; 4
word_95DE:	dc.w 2			; DATA XREF: ROM:000095ACo
		dc.w $D807, $800, $800,$FFF8; 0
		dc.w  $807, $800, $800,$FFF8; 4
word_95F0:	dc.w 2			; DATA XREF: ROM:000095AEo
		dc.w $D407, $800, $800,$FFF8; 0
		dc.w  $C07, $800, $800,$FFF8; 4
word_9602:	dc.w 2			; DATA XREF: ROM:000095B0o
		dc.w $D007, $800, $800,$FFF8; 0
		dc.w $1007, $800, $800,$FFF8; 4
word_9614:	dc.w 2			; DATA XREF: ROM:000095B2o
		dc.w $CC07, $800, $800,$FFF8; 0
		dc.w $1407, $800, $800,$FFF8; 4
word_9626:	dc.w 2			; DATA XREF: ROM:000095B4o
		dc.w $C807, $800, $800,$FFF8; 0
		dc.w $1807, $800, $800,$FFF8; 4
word_9638:	dc.w 2			; DATA XREF: ROM:000095B6o
		dc.w $C407, $800, $800,$FFF8; 0
		dc.w $1C07, $800, $800,$FFF8; 4
word_964A:	dc.w 2			; DATA XREF: ROM:000095B8o
		dc.w $C007, $800, $800,$FFF8; 0
		dc.w $2007, $800, $800,$FFF8; 4