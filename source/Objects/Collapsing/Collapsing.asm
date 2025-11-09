Obj1A:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex	2, loc_8C58
	GenerateIndex	2, loc_8CCA
	GenerateIndex	2, loc_8D02
; ===========================================================================

loc_8C58:	
		addq.b	#2,routine(a0)
		move.l	#Map_Collapsing,mappings(a0)
		move.w	#$4000,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#7,$38(a0)
		move.b	Subtype(a0),mapping_frame(a0)
		cmpi.b	#ZoneID_HPZ,(Current_Zone).w
		bne.s	loc_8CB0
		move.l	#MAP_PlatformHPZ,mappings(a0)
		move.w	#$434A,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#$30,width_pixels(a0)
		move.l	#Obj1A_Conf_HPZ,$3C(a0)
		bra.s	loc_8CCA
	loc_8CB0:	
		move.l	#Obj1A_Conf,$3C(a0)
		move.b	#$34,width_pixels(a0)
		move.b	#$38,y_radius(a0)
		bset	#4,render_flags(a0)
; ---------------------------------------------------------------------------
loc_8CCA:	
		tst.b	$3A(a0)
		beq.s	loc_8CDC
		tst.b	$38(a0)
		beq.w	loc_8E58
		subq.b	#1,$38(a0)

loc_8CDC:	
		move.b	status(a0),d0
		andi.b	#$18,d0
		beq.s	sub_8CEC
		move.b	#1,$3A(a0)

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_8CEC:
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		movea.l	$3C(a0),a2
		move.w	x_pos(a0),d4
		bsr.w	sub_F7DC
		bra.w	MarkObjGone
; ---------------------------------------------------------------------------
loc_8D02:
		tst.b	$38(a0)
		beq.s	loc_8D46
		tst.b	$3A(a0)
		bne.s	loc_8D16
		subq.b	#1,$38(a0)
		bra.w	DisplaySprite
; ---------------------------------------------------------------------------
loc_8D16:	
		bsr.w	sub_8CEC
		subq.b	#1,$38(a0)
		bne.s	locret_8D44
		lea	(MainCharacter).w,a1
		bsr.s	sub_8D2A
		lea	(Sidekick).w,a1

; ---------------------------------------------------------------------------
sub_8D2A:
		btst	#3,status(a1)
		beq.s	locret_8D44
		bclr	#3,status(a1)
		bclr	#5,status(a1)
		move.b	#1,prev_anim(a1)
locret_8D44:
		rts
; End of function sub_8D2A

; ---------------------------------------------------------------------------

loc_8D46:				; CODE XREF: ROM:00008D06j
		bsr.w	ObjectMoveAndFall
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite

; ===========================================================================
S1Obj_53:				; leftover object from Sonic 1
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	S1Obj_53_Index(pc,d0.w),d1
		jmp	S1Obj_53_Index(pc,d1.w)
; ===========================================================================
S1Obj_53_Index:	dc.w loc_8D6A-S1Obj_53_Index
		dc.w loc_8DB4-S1Obj_53_Index
		dc.w loc_8DEA-S1Obj_53_Index
; ===========================================================================

loc_8D6A:
		addq.b	#2,routine(a0)
		move.l	#MAP_CollapsingGHZ,mappings(a0)
		move.w	#$42B8,art_tile(a0)
		cmpi.b	#ZoneID_EHZ,(Current_Zone).w
		bne.s	loc_8D8E
		move.w	#$44E0,art_tile(a0)
		addq.b	#2,mapping_frame(a0)

loc_8D8E:	
		cmpi.b	#ZoneID_HTZ,(Current_Zone).w
		bne.s	loc_8D9C
		move.w	#$43F5,art_tile(a0)

loc_8D9C:	
		ori.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#7,$38(a0)
		move.b	#$44,width_pixels(a0)

loc_8DB4:
		tst.b	$3A(a0)
		beq.s	loc_8DC6
		tst.b	$38(a0)
		beq.w	loc_8E3E
		subq.b	#1,$38(a0)

loc_8DC6:	
		move.b	status(a0),d0
		andi.b	#$18,d0
		beq.s	sub_8DD6
		move.b	#1,$3A(a0)

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_8DD6:				; CODE XREF: ROM:00008DCEj
					; ROM:loc_8DFEp
		move.w	#$20,d1	; ' '
		move.w	#8,d3
		move.w	x_pos(a0),d4
		bsr.w	sub_F78A
		bra.w	MarkObjGone
; End of function sub_8DD6

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8DEA:				; DATA XREF: ROM:00008D68o
		tst.b	$38(a0)
		beq.s	loc_8E2E
		tst.b	$3A(a0)
		bne.s	loc_8DFE
		subq.b	#1,$38(a0)
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8DFE:				; CODE XREF: ROM:00008DF4j
		bsr.w	sub_8DD6
		subq.b	#1,$38(a0)
		bne.s	locret_8E2C
		lea	(MainCharacter).w,a1
		bsr.s	sub_8E12
		lea	(Sidekick).w,a1

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_8E12:				; CODE XREF: ROM:00008E0Cp
		btst	#3,status(a1)
		beq.s	locret_8E2C
		bclr	#3,status(a1)
		bclr	#5,status(a1)
		move.b	#1,prev_anim(a1)

locret_8E2C:				; CODE XREF: ROM:00008E06j sub_8E12+6j
		rts
; End of function sub_8E12

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8E2E:				; CODE XREF: ROM:00008DEEj
		bsr.w	ObjectMoveAndFall
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8E3E:				; CODE XREF: ROM:00008DBEj
		lea	(byte_8F17).l,a4
		btst	#0,$28(a0)
		beq.s	loc_8E52
		lea	(byte_8F1F).l,a4

loc_8E52:				; CODE XREF: ROM:00008E4Aj
		addq.b	#1,mapping_frame(a0)
		bra.s	loc_8E70
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8E58:				; CODE XREF: ROM:00008CD4j
		lea	(byte_8EF2).l,a4
		cmpi.b	#ZoneID_HPZ,(Current_Zone).w
		bne.s	loc_8E6C
		lea	(byte_8F0B).l,a4

loc_8E6C:				; CODE XREF: ROM:00008E64j
		addq.b	#2,mapping_frame(a0)

loc_8E70:				; CODE XREF: ROM:00008E56j
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		add.w	d0,d0
		movea.l	mappings(a0),a3
		adda.w	(a3,d0.w),a3
		move.w	(a3)+,d1
		subq.w	#1,d1
		bset	#5,render_flags(a0)
		move.b	id(a0),d4
		move.b	render_flags(a0),d5
		movea.l	a0,a1
		bra.s	loc_8E9E
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_8E96:				; CODE XREF: ROM:loc_8EE0j
		jsr	SingleObjLoad
		bne.s	loc_8EE4
		addq.w	#8,a3

loc_8E9E:				; CODE XREF: ROM:00008E94j
		move.b	#4,routine(a1)
		move.b	d4,id(a1)
		move.l	a3,mappings(a1)
		move.b	d5,render_flags(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	priority(a0),priority(a1)
		move.b	width_pixels(a0),width_pixels(a1)
		move.b	y_radius(a0),y_radius(a1)
		move.b	(a4)+,$38(a1)
		cmpa.l	a0,a1
		bcc.s	loc_8EE0
		bsr.w	DisplaySprite2

loc_8EE0:				; CODE XREF: ROM:00008EDAj
		dbf	d1,loc_8E96

loc_8EE4:				; CODE XREF: ROM:00008E9Aj
		bsr.w	DisplaySprite
		move.w	#$B9,d0	; '¹'
		jmp	(PlaySound_Special).l
