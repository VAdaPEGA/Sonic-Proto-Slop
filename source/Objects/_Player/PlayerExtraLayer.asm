; ===========================================================================
; ---------------------------------------------------------------------------
; Object 05 - Tails' tails
; ---------------------------------------------------------------------------

Obj05:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj05_Index(pc,d0.w),d1
		jmp	Obj05_Index(pc,d1.w)
; ===========================================================================
Obj05_Index:	dc.w Obj05_Init-Obj05_Index
		dc.w Obj05_Main-Obj05_Index
; ===========================================================================

Obj05_Init:
		addq.b	#2,routine(a0)
		move.l	#Map_Tails,mappings(a0)
		move.w	#VRAM_Plr2Extra/$20,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#2,priority(a0)
		move.b	#$18,width_pixels(a0)
		move.b	#4,render_flags(a0)

Obj05_Main:
		move.b	(Sidekick+$26).w,angle(a0)
		move.b	(Sidekick+status).w,status(a0)
		move.w	(Sidekick+x_pos).w,x_pos(a0)
		move.w	(Sidekick+y_pos).w,y_pos(a0)
		moveq	#0,d0
		move.b	(Sidekick+anim).w,d0
		cmp.b	$30(a0),d0
		beq.s	loc_11DE6
		move.b	d0,$30(a0)
		move.b	Obj05_Animations(pc,d0.w),anim(a0)

loc_11DE6:
		lea	(Obj05_AniData).l,a1
		bsr.w	Tails_Animate2
		bsr.w	LoadTailsTailsDynPLC
		jmp	(DisplaySprite).l
; ===========================================================================
Obj05_Animations:
		dc.b	0,	0	; 0
		dc.b	3,	3	; 2
		dc.b	0,	1	; 4
		dc.b	0,	2	; 6
		dc.b	1,	7	; 8
		dc.b	0,	0	; 10
		dc.b	0,	0	; 12
		dc.b	0,	0	; 14
		dc.b	0,	0	; 16
		dc.b	0,	0	; 18
		dc.b	0,	0	; 20
		dc.b	0,	0	; 22
		dc.b	0,	0	; 24
		dc.b	0,	0	; 26
		dc.b	0,	0	; 28
Obj05_AniData:	dc.w byte_11E2A-Obj05_AniData
		dc.w byte_11E2D-Obj05_AniData
		dc.w byte_11E34-Obj05_AniData
		dc.w byte_11E3C-Obj05_AniData
		dc.w byte_11E42-Obj05_AniData
		dc.w byte_11E48-Obj05_AniData
		dc.w byte_11E4E-Obj05_AniData
		dc.w byte_11E54-Obj05_AniData
byte_11E2A:	dc.b	$20,	0,$FF	
byte_11E2D:	dc.b	7,	9, $A, $B, $C, $D,$FF
byte_11E34:	dc.b	3,	9, $A, $B, $C, $D,$FD,  1
byte_11E3C:	dc.b	$FC,	$49,$4A,$4B,$4C,$FF
byte_11E42:	dc.b	3,	$4D,$4E,$4F,$50,$FF
byte_11E48:	dc.b	3,	$51,$52,$53,$54,$FF
byte_11E4E:	dc.b	3,	$55,$56,$57,$58,$FF
byte_11E54:	dc.b	2,	$81,$82,$83,$84,$FF
; ===========================================================================

; ===========================================================================
; ---------------------------------------------------------------------------
; Tails' Tails pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; LoadTailsDynPLC_F600:
LoadTailsTailsDynPLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		cmp.b	(TailsTails_LastLoadedDPLC).w,d0
		beq.s	locret_11D7C
		move.b	d0,(TailsTails_LastLoadedDPLC).w
		lea	(TailsDynPLC).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d5
		subq.w	#1,d5
		bmi.s	locret_11D7C
		move.w	#VRAM_Plr2Extra,d4
		bra.s	TPLC_ReadEntry
; End of function LoadTailsTailsDynPLC