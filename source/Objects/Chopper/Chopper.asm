;----------------------------------------------------
; Object 2B - GHZ Chopper Badnik
;----------------------------------------------------

Obj2B:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj2B_Index(pc,d0.w),d1
		jsr	Obj2B_Index(pc,d1.w)
		bra.w	MarkObjGone
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj2B_Index:	dc.w loc_B72E-Obj2B_Index ; DATA XREF: ROM:Obj2B_Indexo
					; ROM:0000B72Co
		dc.w loc_B768-Obj2B_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_B72E:				; DATA XREF: ROM:Obj2B_Indexo
		addq.b	#2,routine(a0)
		move.l	#Map_Obj2B,mappings(a0)
		move.w	#$470,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#9,$20(a0)
		move.b	#$10,width_pixels(a0)
		move.w	#$F900,y_vel(a0)
		move.w	y_pos(a0),$30(a0)

loc_B768:				; DATA XREF: ROM:0000B72Co
		lea	(Ani_Obj2B).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectMove
		addi.w	#$18,y_vel(a0)
		move.w	$30(a0),d0
		cmp.w	y_pos(a0),d0
		bcc.s	loc_B790
		move.w	d0,y_pos(a0)
		move.w	#$F900,y_vel(a0)

loc_B790:				; CODE XREF: ROM:0000B784j
		move.b	#1,anim(a0)
		subi.w	#$C0,d0	; 'À'
		cmp.w	y_pos(a0),d0
		bcc.s	locret_B7B2
		move.b	#0,anim(a0)
		tst.w	y_vel(a0)
		bmi.s	locret_B7B2
		move.b	#2,anim(a0)

locret_B7B2:				; CODE XREF: ROM:0000B79Ej
					; ROM:0000B7AAj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Ani_Obj2B:	dc.w byte_B7BA-Ani_Obj2B ; DATA	XREF: ROM:loc_B768o
					; ROM:Ani_Obj2Bo ...
		dc.w byte_B7BE-Ani_Obj2B
		dc.w byte_B7C2-Ani_Obj2B
byte_B7BA:	dc.b   7,  0,  1,$FF	; 0 ; DATA XREF: ROM:Ani_Obj2Bo
byte_B7BE:	dc.b   3,  0,  1,$FF	; 0 ; DATA XREF: ROM:0000B7B6o
byte_B7C2:	dc.b   7,  0,$FF,  0	; 0 ; DATA XREF: ROM:0000B7B8o
