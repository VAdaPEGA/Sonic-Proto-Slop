;----------------------------------------------------
; Object 2C - LZ Jaws Badnik
;----------------------------------------------------

Obj2C:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj2C_Index(pc,d0.w),d1
		jmp	Obj2C_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj2C_Index:	dc.w loc_B7F0-Obj2C_Index
		dc.w loc_B842-Obj2C_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_B7F0:				; DATA XREF: ROM:Obj2C_Indexo
		addq.b	#2,routine(a0)
		move.l	#Map_Obj2C,mappings(a0)
		move.w	#$2486,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#$A,$20(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsl.w	#6,d0
		subq.w	#1,d0
		move.w	d0,$30(a0)
		move.w	d0,$32(a0)
		move.w	#$FFC0,x_vel(a0)
		btst	#0,status(a0)
		beq.s	loc_B842
		neg.w	x_vel(a0)

loc_B842:				; CODE XREF: ROM:0000B83Cj
					; DATA XREF: ROM:0000B7EEo
		subq.w	#1,$30(a0)
		bpl.s	loc_B85E
		move.w	$32(a0),$30(a0)
		neg.w	x_vel(a0)
		bchg	#0,status(a0)
		move.b	#1,prev_anim(a0)

loc_B85E:				; CODE XREF: ROM:0000B846j
		lea	(Ani_Obj2C).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectMove
		bra.w	MarkObjGone
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Ani_Obj2C:	dc.b   0,  2,  7,  0,  1,  2,  3,$FF; 0	; DATA XREF: ROM:loc_B85Eo
Map_Obj2C:	dc.w word_B880-Map_Obj2C ; DATA	XREF: ROM:0000B7F4o
					; ROM:Map_Obj2Co ...
		dc.w word_B892-Map_Obj2C
		dc.w word_B8A4-Map_Obj2C
		dc.w word_B8B6-Map_Obj2C
word_B880:	dc.w 2			; DATA XREF: ROM:Map_Obj2Co
		dc.w $F40E,    0,    0,$FFF0; 0
		dc.w $F505,  $18,   $C,	 $10; 4
word_B892:	dc.w 2			; DATA XREF: ROM:0000B87Ao
		dc.w $F40E,   $C,    6,$FFF0; 0
		dc.w $F505,  $1C,   $E,	 $10; 4
word_B8A4:	dc.w 2			; DATA XREF: ROM:0000B87Co
		dc.w $F40E,    0,    0,$FFF0; 0
		dc.w $F505,$1018,$100C,	 $10; 4
word_B8B6:	dc.w 2			; DATA XREF: ROM:0000B87Eo
		dc.w $F40E,   $C,    6,$FFF0; 0
		dc.w $F505,$101C,$100E,	 $10; 4
; ===========================================================================