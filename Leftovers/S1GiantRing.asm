;----------------------------------------------------
; Sonic	1 Object 4B - leftover giant ring code
;----------------------------------------------------

S1Obj4B:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	S1Obj4B_Index(pc,d0.w),d1
		jmp	S1Obj4B_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
S1Obj4B_Index:	dc.w loc_AA88-S1Obj4B_Index ; DATA XREF: ROM:S1Obj4B_Indexo
					; ROM:0000AA82o ...
		dc.w loc_AAD6-S1Obj4B_Index
		dc.w loc_AAF4-S1Obj4B_Index
		dc.w loc_AB38-S1Obj4B_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_AA88:				; DATA XREF: ROM:S1Obj4B_Indexo
		move.l	#Map_S1Obj4B,mappings(a0)
		move.w	#$2400,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#$40,width_pixels(a0) ; '@'
		tst.b	render_flags(a0)
		bpl.s	loc_AAD6
		cmpi.b	#6,($FFFFFE57).w
		beq.w	loc_AB38
		cmpi.w	#$32,(Ring_count).w ; '2'
		bcc.s	loc_AAC0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_AAC0:				; CODE XREF: ROM:0000AABCj
		addq.b	#2,routine(a0)
		move.b	#2,priority(a0)
		move.b	#$52,$20(a0) ; 'R'
		move.w	#$C40,($FFFFF7BE).w

loc_AAD6:				; CODE XREF: ROM:0000AAAAj
					; ROM:0000AB36j
					; DATA XREF: ...
		move.b	(Rings_anim_frame).w,mapping_frame(a0)
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_AAF4:				; DATA XREF: ROM:0000AA84o
		subq.b	#2,routine(a0)
		move.b	#0,$20(a0)
		jsr	SingleObjLoad
		bne.w	loc_AB2C
		move.b	#$7C,id(a1) ; '|'
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	a0,$3C(a1)
		move.w	(MainCharacter+x_pos).w,d0
		cmp.w	x_pos(a0),d0
		bcs.s	loc_AB2C
		bset	#0,render_flags(a1)

loc_AB2C:				; CODE XREF: ROM:0000AB02j
					; ROM:0000AB24j
		move.w	#$C3,d0	; 'Ã'
		jsr	(PlaySound_Special).l
		bra.s	loc_AAD6
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_AB38:				; CODE XREF: ROM:0000AAB2j
					; DATA XREF: ROM:0000AA86o
		bra.w	DeleteObject
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------
; Sonic	1 Object 7C - leftover giant flash when	you
;   collected the giant	ring
;----------------------------------------------------

Obj_S1Obj7C:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_S1Obj7C_Index(pc,d0.w),d1
		jmp	Obj_S1Obj7C_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj_S1Obj7C_Index:dc.w loc_AB50-Obj_S1Obj7C_Index ; DATA XREF: ROM:Obj_S1Obj7C_Indexo
					; ROM:0000AB4Co ...
		dc.w loc_AB7E-Obj_S1Obj7C_Index
		dc.w loc_ABE6-Obj_S1Obj7C_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_AB50:				; DATA XREF: ROM:Obj_S1Obj7C_Indexo
		addq.b	#2,routine(a0)
		move.l	#Map_S1Obj7C,mappings(a0)
		move.w	#$2462,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		ori.b	#4,render_flags(a0)
		move.b	#0,priority(a0)
		move.b	#$20,width_pixels(a0) ; ' '
		move.b	#$FF,mapping_frame(a0)

loc_AB7E:				; DATA XREF: ROM:0000AB4Co
		bsr.s	sub_AB98
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_AB98:				; CODE XREF: ROM:loc_AB7Ep
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	locret_ABD6
		move.b	#1,anim_frame_duration(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#8,mapping_frame(a0)
		bcc.s	loc_ABD8
		cmpi.b	#3,mapping_frame(a0)
		bne.s	locret_ABD6
		movea.l	$3C(a0),a1
		move.b	#6,routine(a1)
		move.b	#$1C,(MainCharacter+anim).w
		move.b	#1,($FFFFF7CD).w
		clr.b	($FFFFFE2D).w
		clr.b	($FFFFFE2C).w

locret_ABD6:				; CODE XREF: sub_AB98+4j sub_AB98+1Ej
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_ABD8:				; CODE XREF: sub_AB98+16j
		addq.b	#2,routine(a0)
		move.w	#0,(MainCharacter).w
		addq.l	#4,sp
		rts
; End of function sub_AB98

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_ABE6:				; DATA XREF: ROM:0000AB4Eo
		bra.w	DeleteObject
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Ani_Obj25:	dc.w byte_ABEC-Ani_Obj25 ; DATA	XREF: ROM:loc_A8CCo
					; ROM:loc_AA60o ...
byte_ABEC:	dc.b   5,  4,  5,  6,  7,$FC; 0	; DATA XREF: ROM:Ani_Obj25o
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------

Map_S1Obj4B:	dc.w word_AC5E-Map_S1Obj4B ; DATA XREF:	ROM:loc_AA88o
					; ROM:Map_S1Obj4Bo ...
		dc.w word_ACB0-Map_S1Obj4B
		dc.w word_ACF2-Map_S1Obj4B
		dc.w word_AD14-Map_S1Obj4B
word_AC5E:	dc.w $A			; DATA XREF: ROM:Map_S1Obj4Bo
		dc.w $E008,    0,    0,$FFE8; 0
		dc.w $E008,    3,    1,	   0; 4
		dc.w $E80C,    6,    3,$FFE0; 8
		dc.w $E80C,   $A,    5,	   0; 12
		dc.w $F007,   $E,    7,$FFE0; 16
		dc.w $F007,  $16,   $B,	 $10; 20
		dc.w $100C,  $1E,   $F,$FFE0; 24
		dc.w $100C,  $22,  $11,	   0; 28
		dc.w $1808,  $26,  $13,$FFE8; 32
		dc.w $1808,  $29,  $14,	   0; 36
word_ACB0:	dc.w 8			; DATA XREF: ROM:0000AC58o
		dc.w $E00C,  $2C,  $16,$FFF0; 0
		dc.w $E808,  $30,  $18,$FFE8; 4
		dc.w $E809,  $33,  $19,	   0; 8
		dc.w $F007,  $39,  $1C,$FFE8; 12
		dc.w $F805,  $41,  $20,	   8; 16
		dc.w  $809,  $45,  $22,	   0; 20
		dc.w $1008,  $4B,  $25,$FFE8; 24
		dc.w $180C,  $4E,  $27,$FFF0; 28
word_ACF2:	dc.w 4			; DATA XREF: ROM:0000AC5Ao
		dc.w $E007,  $52,  $29,$FFF4; 0
		dc.w $E003, $852, $829,	   4; 4
		dc.w	 7,  $5A,  $2D,$FFF4; 8
		dc.w	 3, $85A, $82D,	   4; 12
word_AD14:	dc.w 8			; DATA XREF: ROM:0000AC5Co
		dc.w $E00C, $82C, $816,$FFF0; 0
		dc.w $E808, $830, $818,	   0; 4
		dc.w $E809, $833, $819,$FFE8; 8
		dc.w $F007, $839, $81C,	   8; 12
		dc.w $F805, $841, $820,$FFE8; 16
		dc.w  $809, $845, $822,$FFE8; 20
		dc.w $1008, $84B, $825,	   0; 24
		dc.w $180C, $84E, $827,$FFF0; 28
Map_S1Obj7C:	dc.w word_AD66-Map_S1Obj7C ; DATA XREF:	ROM:0000AB54o
					; ROM:Map_S1Obj7Co ...
		dc.w word_AD78-Map_S1Obj7C
		dc.w word_AD9A-Map_S1Obj7C
		dc.w word_ADBC-Map_S1Obj7C
		dc.w word_ADDE-Map_S1Obj7C
		dc.w word_AE00-Map_S1Obj7C
		dc.w word_AE22-Map_S1Obj7C
		dc.w word_AE34-Map_S1Obj7C
word_AD66:	dc.w 2			; DATA XREF: ROM:Map_S1Obj7Co
		dc.w $E00F,    0,    0,	   0; 0
		dc.w	$F,$1000,$1000,	   0; 4
word_AD78:	dc.w 4			; DATA XREF: ROM:0000AD58o
		dc.w $E00F,  $10,    8,$FFF0; 0
		dc.w $E007,  $20,  $10,	 $10; 4
		dc.w	$F,$1010,$1008,$FFF0; 8
		dc.w	 7,$1020,$1010,	 $10; 12
word_AD9A:	dc.w 4			; DATA XREF: ROM:0000AD5Ao
		dc.w $E00F,  $28,  $14,$FFE8; 0
		dc.w $E00B,  $38,  $1C,	   8; 4
		dc.w	$F,$1028,$1014,$FFE8; 8
		dc.w	$B,$1038,$101C,	   8; 12
word_ADBC:	dc.w 4			; DATA XREF: ROM:0000AD5Co
		dc.w $E00F, $834, $81A,$FFE0; 0
		dc.w $E00F,  $34,  $1A,	   0; 4
		dc.w	$F,$1834,$181A,$FFE0; 8
		dc.w	$F,$1034,$101A,	   0; 12
word_ADDE:	dc.w 4			; DATA XREF: ROM:0000AD5Eo
		dc.w $E00B, $838, $81C,$FFE0; 0
		dc.w $E00F, $828, $814,$FFF8; 4
		dc.w	$B,$1838,$181C,$FFE0; 8
		dc.w	$F,$1828,$1814,$FFF8; 12
word_AE00:	dc.w 4			; DATA XREF: ROM:0000AD60o
		dc.w $E007, $820, $810,$FFE0; 0
		dc.w $E00F, $810, $808,$FFF0; 4
		dc.w	 7,$1820,$1810,$FFE0; 8
		dc.w	$F,$1810,$1808,$FFF0; 12
word_AE22:	dc.w 2			; DATA XREF: ROM:0000AD62o
		dc.w $E00F, $800, $800,$FFE0; 0
		dc.w	$F,$1800,$1800,$FFE0; 4
word_AE34:	dc.w 4			; DATA XREF: ROM:0000AD64o
		dc.w $E00F,  $44,  $22,$FFE0; 0
		dc.w $E00F, $844, $822,	   0; 4
		dc.w	$F,$1044,$1022,$FFE0; 8
		dc.w	$F,$1844,$1822,	   0; 12

