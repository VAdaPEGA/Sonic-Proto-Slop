;----------------------------------------------------
; Object 19 - CPZ platforms moving side	to side
;----------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj19_Index(pc,d0.w),d1
		jmp	Obj19_Index(pc,d1.w)
; ===========================================================================
Obj19_Index:	dc.w Obj19_Init-Obj19_Index
		dc.w Obj19_Main-Obj19_Index
Obj19_WidthArray:
		;	Width,	Frame
		dc.b	$20,	0
		dc.b	$20,	2
		dc.b	$20,	1
		dc.b	$40,	3
		dc.b	$30,	4
; ===========================================================================
Obj19_Init:				; DATA XREF: ROM:Obj19_Indexo
		addq.b	#2,routine(a0)
		move.l	#Map_PlatformsCPZ,mappings(a0)
		move.w	#$6400,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	Obj19_WidthArray(pc,d0.w),a2
		move.b	(a2)+,width_pixels(a0)
		move.b	(a2)+,mapping_frame(a0)
		move.b	#4,priority(a0)
		move.w	x_pos(a0),$30(a0)
		move.w	y_pos(a0),$32(a0)
		andi.b	#$F,$28(a0)

Obj19_Main:				; DATA XREF: ROM:000152C8o
		move.w	x_pos(a0),-(sp)
		bsr.w	Obj19_Modes
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		move.w	#$10,d3
		move.w	(sp)+,d4
		bsr.w	sub_F78A
		move.w	$30(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_154C6
		bra.w	loc_154C0

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Obj19_Modes:				; CODE XREF: ROM:00015324p
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	Obj19_SubIndex(pc,d0.w),d1
		jmp	Obj19_SubIndex(pc,d1.w)
; End of function Obj19_Modes

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj19_SubIndex:	dc.w locret_1537A-Obj19_SubIndex ; DATA	XREF: ROM:Obj19_SubIndexo
					; ROM:00015366o ...
		dc.w loc_1537C-Obj19_SubIndex
		dc.w loc_1539C-Obj19_SubIndex
		dc.w loc_153AC-Obj19_SubIndex
		dc.w loc_1539C-Obj19_SubIndex
		dc.w loc_153CC-Obj19_SubIndex
		dc.w loc_153EC-Obj19_SubIndex
		dc.w loc_1540E-Obj19_SubIndex
		dc.w loc_15430-Obj19_SubIndex
		dc.w loc_1539C-Obj19_SubIndex
		dc.w loc_15450-Obj19_SubIndex
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_1537A:				; DATA XREF: ROM:Obj19_SubIndexo
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1537C:				; DATA XREF: ROM:00015366o
		move.b	($FFFFFE6C).w,d0
		move.w	#$60,d1	; '`'
		btst	#0,status(a0)
		beq.s	loc_15390
		neg.w	d0
		add.w	d1,d0

loc_15390:				; CODE XREF: ROM:0001538Aj
		move.w	$30(a0),d1
		sub.w	d0,d1
		move.w	d1,x_pos(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1539C:				; DATA XREF: ROM:00015368o
					; ROM:0001536Co ...
		move.b	status(a0),d0
		andi.b	#$18,d0
		beq.s	locret_153AA
		addq.b	#1,$28(a0)

locret_153AA:				; CODE XREF: ROM:000153A4j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_153AC:				; DATA XREF: ROM:0001536Ao
		moveq	#0,d3
		move.b	width_pixels(a0),d3
		bsr.w	ObjHitWallRight
		tst.w	d1
		bmi.s	loc_153C6
		addq.w	#1,x_pos(a0)
		move.w	x_pos(a0),$30(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_153C6:				; CODE XREF: ROM:000153B8j
		clr.b	$28(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_153CC:				; DATA XREF: ROM:0001536Eo
		moveq	#0,d3
		move.b	width_pixels(a0),d3
		bsr.w	ObjHitWallRight
		tst.w	d1
		bmi.s	loc_153E6
		addq.w	#1,x_pos(a0)
		move.w	x_pos(a0),$30(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_153E6:				; CODE XREF: ROM:000153D8j
		addq.b	#1,$28(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_153EC:				; DATA XREF: ROM:00015370o
		bsr.w	j_ObjectMove_1
		addi.w	#$18,y_vel(a0)
		bsr.w	ObjHitFloor
		tst.w	d1
		bpl.w	locret_1540C
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)
		clr.b	$28(a0)

locret_1540C:				; CODE XREF: ROM:000153FCj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1540E:				; DATA XREF: ROM:00015372o
		tst.b	($FFFFF7E2).w
		beq.s	loc_15418
		subq.b	#3,$28(a0)

loc_15418:				; CODE XREF: ROM:00015412j
		addq.l	#6,sp
		move.w	$30(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_154C6
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_15430:				; DATA XREF: ROM:00015374o
		move.b	($FFFFFE7C).w,d0
		move.w	#$80,d1	; '€'
		btst	#0,status(a0)
		beq.s	loc_15444
		neg.w	d0
		add.w	d1,d0

loc_15444:				; CODE XREF: ROM:0001543Ej
		move.w	$32(a0),d1
		sub.w	d0,d1
		move.w	d1,y_pos(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_15450:				; DATA XREF: ROM:00015378o
		moveq	#0,d3
		move.b	width_pixels(a0),d3
		add.w	d3,d3
		moveq	#8,d1
		btst	#0,status(a0)
		beq.s	loc_15466
		neg.w	d1
		neg.w	d3

loc_15466:				; CODE XREF: ROM:00015460j
		tst.w	$36(a0)
		bne.s	loc_15492
		move.w	x_pos(a0),d0
		sub.w	$30(a0),d0
		cmp.w	d3,d0
		beq.s	loc_15484
		add.w	d1,x_pos(a0)
		move.w	#$12C,$34(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_15484:				; CODE XREF: ROM:00015476j
		subq.w	#1,$34(a0)
		bne.s	locret_15490
		move.w	#1,$36(a0)

locret_15490:				; CODE XREF: ROM:00015488j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_15492:				; CODE XREF: ROM:0001546Aj
		move.w	x_pos(a0),d0
		sub.w	$30(a0),d0
		beq.s	loc_154A2
		sub.w	d1,x_pos(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_154A2:				; CODE XREF: ROM:0001549Aj
		clr.w	$36(a0)
		subq.b	#1,$28(a0)
		rts

loc_154C0:				; CODE XREF: ROM:0001534Cj
		jmp	(DisplaySprite).l

loc_154C6:				; CODE XREF: ROM:00015348j
					; ROM:0001542Aj
		jmp	(DeleteObject).l

j_ObjectMove_1:				; CODE XREF: ROM:loc_153ECp
		jmp	(ObjectMove).l