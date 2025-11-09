; ---------------------------------------------------------------------------
; Sonic	1 Object 4A - giant ring entry effect from prototype
; ---------------------------------------------------------------------------
; OST:
warp_vanishtime:	equ $30		; time for Sonic to vanish for
; ---------------------------------------------------------------------------

S1Obj4A:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	S1Obj4A_Index(pc,d0.w),d1
		jmp	S1Obj4A_Index(pc,d1.w)
; ===========================================================================
S1Obj4A_Index:	dc.w S1Obj4A_Init-S1Obj4A_Index
		dc.w S1Obj4A_RmvSonic-S1Obj4A_Index
		dc.w S1Obj4A_LoadSonic-S1Obj4A_Index
; ===========================================================================

S1Obj4A_Init:
		tst.l	(Plc_Buffer).w	; are the pattern load cues empty?
		beq.s	loc_124D4	; if yes, branch
		rts
; ---------------------------------------------------------------------------

loc_124D4:
		addq.b	#2,routine(a0)
		move.l	#Map_S1obj4A,mappings(a0)
		move.b	#4,render_flags(a0)
		move.b	#1,priority(a0)
		move.b	#$38,width_pixels(a0)
		move.w	#$541,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.w	#60*2,warp_vanishtime(a0)	; set vanishing time to 2 seconds

S1Obj4A_RmvSonic:
		move.w	(MainCharacter+x_pos).w,x_pos(a0)
		move.w	(MainCharacter+y_pos).w,y_pos(a0)
		move.b	(MainCharacter+status).w,status(a0)
		lea	(Ani_S1obj4A).l,a1
		jsr	(AnimateSprite).l
		cmpi.b	#2,mapping_frame(a0)
		bne.s	loc_1253E
		tst.b	(MainCharacter).w	; is this Sonic?
		beq.s	loc_1253E		; if not, branch
		move.b	#0,(MainCharacter).w	; set Sonic's object ID to 0
		move.w	#$A8,d0
		jsr	(PlaySound_Special).l	; play Special Stage entry sound effect

loc_1253E:
		jmp	(DisplaySprite).l
; ===========================================================================

S1Obj4A_LoadSonic:
		subq.w	#1,warp_vanishtime(a0)	; subtract 1 from vanishing time
		bne.s	locret_12556		; if there's any time left, branch
		move.b	#1,(MainCharacter).w	; set Sonic's object ID to 1
		jmp	(DeleteObject).l
; ---------------------------------------------------------------------------

locret_12556:
		rts

; animation script
Ani_S1obj4A:	dc.w byte_1278C-Ani_S1obj4A
byte_1278C:	dc.b   5,  0,  1,  0,  1,  0,  7,  1,  7,  2,  7,  3,  7,  4,  7,  5
		dc.b   7,  6,  7,$FC
