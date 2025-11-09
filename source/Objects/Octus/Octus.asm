; ---------------------------------------------------------------------------
; Object 4A - Octopus badnik
; ---------------------------------------------------------------------------

Obj4A:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj4A_Index(pc,d0.w),d1
		jmp	Obj4A_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj4A_Index:	dc.w loc_16ADE-Obj4A_Index
		dc.w loc_16B44-Obj4A_Index
		dc.w loc_16AD2-Obj4A_Index
		dc.w loc_16AB6-Obj4A_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16AB6:				; DATA XREF: ROM:00016AB4o
		subi.w	#1,$2C(a0)
		bmi.s	loc_16AC0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16AC0:				; CODE XREF: ROM:00016ABCj
		bsr.w	j_ObjectMoveAndFall_3
		lea	(Ani_Obj4A).l,a1
		bsr.w	j_AnimateSprite_5
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16AD2:				; DATA XREF: ROM:00016AB2o
		subq.w	#1,$2C(a0)
		beq.s	loc_16D36
		jmp	(DisplaySprite).l
loc_16D36:				; CODE XREF: ROM:00016AD6j
		jmp	DeleteObject
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16ADE:				; DATA XREF: ROM:Obj4A_Indexo
		move.l	#Map_Obj4A,mappings(a0)
		move.w	#$238A,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$A,$20(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#8,x_radius(a0)
		bsr.s	j_ObjectMoveAndFall_3
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_16B3C
		add.w	d1,y_pos(a0)
		move.w	#0,y_vel(a0)
		addq.b	#2,routine(a0)
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		bpl.s	loc_16B3C
		bchg	#0,status(a0)

loc_16B3C:				; CODE XREF: ROM:00016B1Cj
					; ROM:00016B34j
		move.w	y_pos(a0),$2A(a0)
		rts
j_ObjectMoveAndFall_3:
		jmp	ObjectMoveAndFall
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16B44:				; DATA XREF: ROM:00016AB0o
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj4A_SubIndex(pc,d0.w),d1
		jsr	Obj4A_SubIndex(pc,d1.w)
		lea	(Ani_Obj4A).l,a1
		j_AnimateSprite_5:
		jsr	AnimateSprite
		bra.w	loc_16D3C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj4A_SubIndex:	dc.w Obj4A_Init-Obj4A_SubIndex ; DATA XREF: ROM:Obj4A_SubIndexo
					; ROM:00016B62o ...
		dc.w Obj4A_Main-Obj4A_SubIndex
		dc.w loc_16BAA-Obj4A_SubIndex
		dc.w loc_16C7C-Obj4A_SubIndex
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj4A_Init:				; DATA XREF: ROM:Obj4A_SubIndexo
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		cmpi.w	#$80,d0	; '€'
		bgt.s	locret_16B86
		cmpi.w	#$FF80,d0
		blt.s	locret_16B86
		addq.b	#2,routine_secondary(a0)
		move.b	#1,anim(a0)

locret_16B86:				; CODE XREF: ROM:00016B74j
					; ROM:00016B7Aj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj4A_Main:				; DATA XREF: ROM:00016B62o
		subi.l	#$18000,y_pos(a0)
		move.w	$2A(a0),d0
		sub.w	y_pos(a0),d0
		cmpi.w	#$20,d0	; ' '
		ble.s	locret_16BA8
		addq.b	#2,routine_secondary(a0)
		move.w	#0,$2C(a0)

locret_16BA8:				; CODE XREF: ROM:00016B9Cj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16BAA:				; DATA XREF: ROM:00016B64o
		subi.w	#1,$2C(a0)
		beq.w	loc_16C76
		bpl.w	locret_16C74
		move.w	#$1E,$2C(a0)
		jsr	(SingleObjLoad).l
		bne.s	loc_16C10
		move.b	#$4A,id(a1) ; 'J'
		move.b	#4,routine(a1)
		move.l	#Map_Obj4A,mappings(a1)
		move.b	#4,mapping_frame(a1)
		move.w	#$24C6,art_tile(a1)
		move.b	#3,priority(a1)
		move.b	#$10,width_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	#$1E,$2C(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	status(a0),status(a1)

loc_16C10:				; CODE XREF: ROM:00016BC4j
		jsr	(SingleObjLoad).l
		bne.s	locret_16C74
		move.b	#$4A,id(a1) ; 'J'
		move.b	#6,routine(a1)
		move.l	#Map_Obj4A,mappings(a1)
		move.w	#$24C6,art_tile(a1)
		move.b	#4,priority(a1)
		move.b	#$10,width_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	#$F,$2C(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	status(a0),status(a1)
		move.b	#2,anim(a1)
		move.w	#$FA80,x_vel(a1)
		btst	#0,render_flags(a1)
		beq.s	locret_16C74
		neg.w	x_vel(a1)

locret_16C74:				; CODE XREF: ROM:00016BB4j
					; ROM:00016C16j ...
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16C76:				; CODE XREF: ROM:00016BB0j
		addq.b	#2,routine_secondary(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_16C7C:				; DATA XREF: ROM:00016B66o
		move.w	#$FFFA,d0
		btst	#0,render_flags(a0)
		beq.s	loc_16C8A
		neg.w	d0

loc_16C8A:				; CODE XREF: ROM:00016C86j
		add.w	d0,x_pos(a0)
loc_16D3C:	
		jmp	MarkObjGone
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Ani_Obj4A:	dc.w byte_16C98-Ani_Obj4A ; DATA XREF: ROM:00016AC4o
					; ROM:00016B52o ...
		dc.w byte_16C9B-Ani_Obj4A
		dc.w byte_16CA0-Ani_Obj4A
byte_16C98:	dc.b  $F,  0,$FF	; 0 ; DATA XREF: ROM:Ani_Obj4Ao
byte_16C9B:	dc.b   3,  1,  2,  3,$FF; 0 ; DATA XREF: ROM:00016C94o
byte_16CA0:	dc.b   2,  5,  6,$FF	; 0 ; DATA XREF: ROM:00016C96o
