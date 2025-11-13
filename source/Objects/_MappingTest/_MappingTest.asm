; ===========================================================================
; Object 0F - Mappings test?
; ---------------------------------------------------------------------------

Obj0F:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj0F_Index(pc,d0.w),d1
		jsr	Obj0F_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
Obj0F_Index:	dc.w loc_B416-Obj0F_Index
		dc.w loc_B438-Obj0F_Index
		dc.w loc_B438-Obj0F_Index
; ===========================================================================

loc_B416:
		addq.b	#2,routine(a0)
		move.w	#$90,x_pixel(a0)
		move.w	#$90,y_pixel(a0)
		move.l	#Map_Obj0F,mappings(a0)
		move.w	#$680,art_tile(a0)
		bsr.w	Adjust2PArtPointer

loc_B438:
		move.b	(Ctrl_1_Press).w,d0
		btst	#5,d0		; has C been pressed?
		beq.s	loc_B44C	; if not, branch
		addq.b	#1,mapping_frame(a0)	; increment mappings
		andi.b	#$F,mapping_frame(a0)	; if above $F, reset

loc_B44C:
		btst	#4,d0		; has B been pressed?
		beq.s	locret_B458	; if not, branch
		bchg	#0,(Two_player_mode+1).w	; set unused variable... which crashes the game?

locret_B458:
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
