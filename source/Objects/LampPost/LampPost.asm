;----------------------------------------------------
; Object 79 - lamppost
;----------------------------------------------------
Obj79:	
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj79_Index(pc,d0.w),d1
		jsr	Obj79_Index(pc,d1.w)
		jmp	(MarkObjGone).l
; ===========================================================================
Obj79_Index:	dc.w Obj79_Init-Obj79_Index
		dc.w Obj79_Main-Obj79_Index
		dc.w Obj79_AfterHit-Obj79_Index
; ===========================================================================
Obj79_Init:
		addq.b	#2,routine(a0)
		move.l	#Map_LampPost,mappings(a0)
		move.w	#$47C,art_tile(a0)
		jsr	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#8,width_pixels(a0)
		move.b	#5,priority(a0)
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		bne.s	loc_13536
		move.b	(Last_LampPost_hit).w,d1
		andi.b	#$7F,d1
		move.b	subtype(a0),d2
		andi.b	#$7F,d2
		cmp.b	d2,d1
		bcs.s	Obj79_Main

loc_13536:	
		bset	#0,2(a2,d0.w)
		move.b	#4,routine(a0)
		rts
; ===========================================================================

Obj79_Main:		
		tst.w	(Debug_placement_mode).w
		bne.w	locret_135CA
		tst.b	obj_control(a1)
		bmi.w	locret_135CA
		move.b	(Last_LampPost_hit).w,d1
		andi.b	#$7F,d1
		move.b	subtype(a0),d2
		andi.b	#$7F,d2
		cmp.b	d2,d1
		bcs.s	Obj79_HitLamp
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#4,routine(a0)
		bra.w	locret_135CA
; ===========================================================================

Obj79_HitLamp:		
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		addi.w	#8,d0
		cmpi.w	#$10,d0
		bcc.w	locret_135CA
		move.w	(MainCharacter+y_pos).w,d0
		sub.w	y_pos(a0),d0
		addi.w	#$40,d0
		cmpi.w	#$68,d0
		bcc.s	locret_135CA
		move.w	#$A1,d0
		jsr	(PlaySound_Special).l
		addq.b	#2,routine(a0)
		jsr	Lamppost_StoreInfo
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		bset	#0,2(a2,d0.w)

locret_135CA:	
		rts
; ===========================================================================

Obj79_AfterHit:	
		move.b	(Vint_runcount+3).w,d0
		lsr.b	#1,d0
		andi.b	#7,d0
		move.b	d0,mapping_frame(a0)
		rts
; ===========================================================================
