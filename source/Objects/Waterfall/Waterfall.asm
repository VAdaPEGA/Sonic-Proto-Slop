;----------------------------------------------------
; Object 49 - EHZ waterfalls
;----------------------------------------------------

Obj49:	
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj49_Index(pc,d0.w),d1
		jmp	Obj49_Index(pc,d1.w)
; ===========================================================================
Obj49_Index:	dc.w Obj49_Init-Obj49_Index
		dc.w Obj49_Main-Obj49_Index
; ===========================================================================
Obj49_Init:			
		addq.b	#2,routine(a0)
		move.l	#Map_Waterfall_EHZ,mappings(a0)
		move.w	#$23AE,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$20,width_pixels(a0)
		move.w	x_pos(a0),$30(a0)
		move.b	#0,priority(a0)
		move.b	#$80,y_radius(a0)
		bset	#4,render_flags(a0)
Obj49_Main:	
		tst.w	(Two_player_mode).w
		bne.s	loc_156F6
		out_of_range	loc_1586E
loc_156F6:	
		move.w	x_pos(a0),d1
		move.w	d1,d2
		subi.w	#$40,d1	; '@'
		addi.w	#$40,d2	; '@'
		move.b	$28(a0),d3
		move.b	#0,mapping_frame(a0)
		move.w	(MainCharacter+x_pos).w,d0
		cmp.w	d1,d0
		bcs.s	loc_15728
		cmp.w	d2,d0
		bcc.s	loc_15728
		move.b	#1,mapping_frame(a0)
		add.b	d3,mapping_frame(a0)
		jmp	(DisplaySprite).l
loc_1586E:	
		jmp	(DeleteObject).l
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_15728:	
		move.w	(Sidekick+x_pos).w,d0
		cmp.w	d1,d0
		bcs.s	loc_1573A
		cmp.w	d2,d0
		bcc.s	loc_1573A
		move.b	#1,mapping_frame(a0)

loc_1573A:	
		add.b	d3,mapping_frame(a0)
		jmp	(DisplaySprite).l
