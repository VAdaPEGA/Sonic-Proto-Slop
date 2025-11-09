;----------------------------------------------------
; Object 0E - Sonic and Tails from the title screen
;----------------------------------------------------

Obj0E:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj0E_Index(pc,d0.w),d1
		jmp	Obj0E_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Obj0E_Index:	dc.w loc_B38E-Obj0E_Index
		dc.w loc_B3D0-Obj0E_Index
		dc.w loc_B3E4-Obj0E_Index
		dc.w loc_B3FA-Obj0E_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_B38E:				; DATA XREF: ROM:Obj0E_Indexo
		addq.b	#2,routine(a0)
		move.w	#$148,x_pixel(a0)
		move.w	#$C4,y_pixel(a0) ; 'Ä'
		move.l	#Map_Obj0E,mappings(a0)
		move.w	#$4200,art_tile(a0)
		move.b	#1,priority(a0)
		move.b	#$1D,anim_frame_duration+1(a0)
		tst.b	mapping_frame(a0)
		beq.s	loc_B3D0
		move.w	#$FC,x_pixel(a0) ; 'ü'
		move.w	#$CC,y_pixel(a0) ; 'Ì'
		move.w	#$2200,art_tile(a0)

loc_B3D0:	
		jmp	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		subq.b	#1,anim_frame_duration+1(a0)
		bpl.s	locret_B3E2
		addq.b	#2,routine(a0)
		bra.s	loc_B3D0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_B3E2:				; CODE XREF: ROM:0000B3D8j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_B3E4:				; DATA XREF: ROM:0000B38Ao
		subi.w	#8,y_pixel(a0)
		cmpi.w	#$96,y_pixel(a0) ; '–'
		bne.s	loc_B3F6
		addq.b	#2,routine(a0)

loc_B3F6:				; CODE XREF: ROM:0000B3F0j
		bra.s	loc_B3D0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_B3FA:				; DATA XREF: ROM:0000B38Co
		bra.s	loc_B3D0