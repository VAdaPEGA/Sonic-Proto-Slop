;----------------------------------------------------
; Object 04 - water surface
;----------------------------------------------------

Obj04:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj04_Index(pc,d0.w),d1
		jmp	Obj04_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj04_Index:	dc.w Obj04_Init-Obj04_Index
		dc.w Obj04_Main-Obj04_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj04_Init:				; DATA XREF: ROM:Obj04_Indexo
		addq.b	#2,routine(a0)
		move.l	#Map_Obj04,mappings(a0)
		move.w	#$8400,art_tile(a0)
		jsr	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$80,width_pixels(a0)
		move.w	x_pos(a0),$30(a0)

Obj04_Main:				; DATA XREF: ROM:000154E4o
		move.w	(Water_Level_1).w,d1
		move.w	d1,y_pos(a0)
		tst.b	$32(a0)
		bne.s	loc_15530
		btst	#7,(Ctrl_1_Press).w
		beq.s	loc_15540
		addq.b	#3,mapping_frame(a0)
		move.b	#1,$32(a0)
		bra.s	loc_15540
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_15530:				; CODE XREF: ROM:0001551Aj
		tst.w	(Game_paused).w
		bne.s	loc_15540
		move.b	#0,$32(a0)
		subq.b	#3,mapping_frame(a0)

loc_15540:				; CODE XREF: ROM:00015522j
					; ROM:0001552Ej ...
		lea	(Obj04_FrameData).l,a1
		moveq	#0,d1
		move.b	anim_frame(a0),d1
		move.b	(a1,d1.w),mapping_frame(a0)
		addq.b	#1,anim_frame(a0)
		andi.b	#$3F,anim_frame(a0) ; '?'
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj04_FrameData:dc.b   0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1; 0
					; DATA XREF: ROM:loc_15540o
		dc.b   1,  2,  1,  2,  1,  2,  1,  2,  1,  2,  1,  2,  1,  2,  1,  2; 16
		dc.b   2,  1,  2,  1,  2,  1,  2,  1,  2,  1,  2,  1,  2,  1,  2,  1; 32
		dc.b   1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0; 48
Map_Obj04:	dc.w word_155AC-Map_Obj04 ; DATA XREF: ROM:000154EAo
					; ROM:Map_Obj04o ...
		dc.w word_155C6-Map_Obj04
		dc.w word_155E0-Map_Obj04
		dc.w word_155FA-Map_Obj04
		dc.w word_1562C-Map_Obj04
		dc.w word_1565E-Map_Obj04
word_155AC:	dc.w 3			; DATA XREF: ROM:Map_Obj04o
		dc.w $F80D,    0,    0,$FFA0; 0
		dc.w $F80D,    0,    0,$FFE0; 4
		dc.w $F80D,    0,    0,	 $20; 8
word_155C6:	dc.w 3			; DATA XREF: ROM:000155A2o
		dc.w $F80D,    8,    4,$FFA0; 0
		dc.w $F80D,    8,    4,$FFE0; 4
		dc.w $F80D,    8,    4,	 $20; 8
word_155E0:	dc.w 3			; DATA XREF: ROM:000155A4o
		dc.w $F80D,  $10,    8,$FFA0; 0
		dc.w $F80D,  $10,    8,$FFE0; 4
		dc.w $F80D,  $10,    8,	 $20; 8
word_155FA:	dc.w 6			; DATA XREF: ROM:000155A6o
		dc.w $F80D,    0,    0,$FFA0; 0
		dc.w $F80D,    8,    4,$FFC0; 4
		dc.w $F80D,    0,    0,$FFE0; 8
		dc.w $F80D,    8,    4,	   0; 12
		dc.w $F80D,    0,    0,	 $20; 16
		dc.w $F80D,    8,    4,	 $40; 20
word_1562C:	dc.w 6			; DATA XREF: ROM:000155A8o
		dc.w $F80D,    8,    4,$FFA0; 0
		dc.w $F80D,  $10,    8,$FFC0; 4
		dc.w $F80D,    8,    4,$FFE0; 8
		dc.w $F80D,  $10,    8,	   0; 12
		dc.w $F80D,    8,    4,	 $20; 16
		dc.w $F80D,  $10,    8,	 $40; 20
word_1565E:	dc.w 6			; DATA XREF: ROM:000155AAo
		dc.w $F80D,  $10,    8,$FFA0; 0
		dc.w $F80D,    8,    4,$FFC0; 4
		dc.w $F80D,  $10,    8,$FFE0; 8
		dc.w $F80D,    8,    4,	   0; 12
		dc.w $F80D,  $10,    8,	 $20; 16
		dc.w $F80D,    8,    4,	 $40; 20
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ