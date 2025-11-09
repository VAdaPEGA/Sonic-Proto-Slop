;----------------------------------------------------
; Object 7D - hidden points at the end of a level
;----------------------------------------------------

Obj7D:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj7D_Index(pc,d0.w),d1
		jmp	Obj7D_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj7D_Index:	dc.w Obj7D_Main-Obj7D_Index ; DATA XREF: ROM:Obj7D_Indexo
					; ROM:00013780o
		dc.w Obj7D_DelayDelete-Obj7D_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj7D_Main:				; DATA XREF: ROM:Obj7D_Indexo
		moveq	#$10,d2
		move.w	d2,d3
		add.w	d3,d3
		lea	(MainCharacter).w,a1
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d2,d0
		cmp.w	d3,d0
		bcc.s	loc_13804
		move.w	y_pos(a1),d1
		sub.w	y_pos(a0),d1
		add.w	d2,d1
		cmp.w	d3,d1
		bcc.s	loc_13804
		tst.w	(Debug_placement_mode).w
		bne.s	loc_13804
		tst.b	($FFFFF7CD).w
		bne.s	loc_13804
		addq.b	#2,routine(a0)
		move.l	#Map_Obj7D,mappings(a0)
		move.w	#$84B6,art_tile(a0)
		jsr	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#0,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	$28(a0),mapping_frame(a0)
		move.w	#$77,$30(a0) ; 'w'
		move.w	#$C9,d0	; 'É'
		jsr	(PlaySound_Special).l
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		move.w	Obj7D_Points(pc,d0.w),d0
		jsr	(AddPoints).l

loc_13804:				; CODE XREF: ROM:00013798j
					; ROM:000137A6j ...
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	loc_13818
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_13818:				; CODE XREF: ROM:00013814j
		jmp	(DeleteObject).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj7D_Points:	dc.w	 0, 1000,  100,	   1; 0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj7D_DelayDelete:			; DATA XREF: ROM:00013780o
		subq.w	#1,$30(a0)
		bmi.s	loc_13844
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	loc_13844
		jmp	(DisplaySprite).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_13844:				; CODE XREF: ROM:0001382Aj
					; ROM:0001383Cj
		jmp	(DeleteObject).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Map_Obj7D:	dc.w word_13852-Map_Obj7D ; DATA XREF: ROM:000137B8o
					; ROM:Map_Obj7Do ...
		dc.w word_13854-Map_Obj7D
		dc.w word_1385E-Map_Obj7D
		dc.w word_13868-Map_Obj7D
word_13852:	dc.w 0			; DATA XREF: ROM:Map_Obj7Do
word_13854:	dc.w 1			; DATA XREF: ROM:0001384Co
		dc.w $F40E,    0,    0,$FFF0; 0
word_1385E:	dc.w 1			; DATA XREF: ROM:0001384Eo
		dc.w $F40E,   $C,    6,$FFF0; 0
word_13868:	dc.w 1			; DATA XREF: ROM:00013850o
		dc.w $F40E,  $18,   $C,$FFF0; 0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ