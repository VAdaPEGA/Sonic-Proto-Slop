; ===========================================================================
; 2 Player Mappings test
; ---------------------------------------------------------------------------

Obj0F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	@Index(pc,d0.w),d1
	jmp	@Index(pc,d1.w)
; ===========================================================================
	IndexStart
	GenerateLocalIndex Init
	GenerateLocalIndex Main
; ===========================================================================
@Init:
	addq.b	#2,routine(a0)
	move.w	#128+16,x_pixel(a0)
	move.w	#128+16,y_pixel(a0)
	move.l	#Map_Obj0F,mappings(a0)
	move.w	#VRAM_Dyn/$20,art_tile(a0)
	bsr.w	Adjust2PArtPointer
@Main:
	move.b	(Ctrl_1_Press).w,d0
	btst	#bitC,d0	; has C been pressed?
	beq.s	@NoFrameChange	; if not, branch
		addq.b	#1,mapping_frame(a0)	; increment mappings
		andi.b	#$F,mapping_frame(a0)	; if above $F, reset
	@NoFrameChange:
	btst	#bitB,d0	; has B been pressed?
	beq.s	@DoNothing	; if not, branch
		bchg	#0,(Two_player_mode+1).w	; set unused variable... which crashes the game?
	@DoNothing:
		bra.w	DisplaySprite
