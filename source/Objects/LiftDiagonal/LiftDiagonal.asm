;----------------------------------------------------
; Object 16 - the HTZ platform that goes down diagonally
;	      and stops	after a	while (in final, it falls)
;----------------------------------------------------

Obj16:	
		moveq	#0,d0

loc_15106:
		move.b	routine(a0),d0
		move.w	Obj16_Index(pc,d0.w),d1
		jmp	Obj16_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj16_Index:	dc.w Obj16_Init-Obj16_Index
		dc.w Obj16_Main-Obj16_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj16_Init:				; DATA XREF: ROM:Obj16_Indexo
		addq.b	#2,routine(a0)
		move.l	#Map_Obj16,mappings(a0)
		move.w	#$43E6,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$20,width_pixels(a0) ; ' '
		move.b	#0,mapping_frame(a0)
		move.b	#1,priority(a0)
		move.w	x_pos(a0),$30(a0)
		move.w	y_pos(a0),$32(a0)

Obj16_Main:				; DATA XREF: ROM:00015114o
		move.w	x_pos(a0),-(sp)
		bsr.w	sub_15184
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		move.w	#$FFD8,d3
		move.w	(sp)+,d4
		bsr.w	sub_F78A
		move.w	$30(a0),d0
		move.w	x_pos(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_152AA
		jmp	(DisplaySprite).l
loc_152AA:		
		jmp	(DeleteObject).l
; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_15184:			
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	Obj16_SubIndex(pc,d0.w),d1
		jmp	Obj16_SubIndex(pc,d1.w)
; End of function sub_15184

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj16_SubIndex:	dc.w Obj16_InitMove-Obj16_SubIndex
		dc.w Obj16_Move-Obj16_SubIndex
		dc.w Obj16_NoMove-Obj16_SubIndex
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj16_InitMove:				; DATA XREF: ROM:Obj16_SubIndexo
		move.b	status(a0),d0
		andi.b	#$18,d0
		beq.s	locret_151BE
		addq.b	#1,$28(a0)
		move.w	#$200,x_vel(a0)
		move.w	#$100,y_vel(a0)
		move.w	#$A0,$34(a0) ; ' '

locret_151BE:				; CODE XREF: ROM:000151A6j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj16_Move:				; DATA XREF: ROM:0001519Ao
		bsr	ObjectMove
		subq.w	#1,$34(a0)
		bne.s	locret_151CE
		addq.b	#1,$28(a0)

locret_151CE:				; CODE XREF: ROM:000151C8j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Obj16_NoMove:				; DATA XREF: ROM:0001519Co
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ