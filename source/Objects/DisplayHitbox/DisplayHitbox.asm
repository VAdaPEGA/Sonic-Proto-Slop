; ===========================================================================
; Draws a Hitbox
; ===========================================================================
	move.l	#Map_DisplayHitbox,mappings(a0)
	move.b	#%01000100,render_flags(a0)
	move.b	#3,mainspr_childsprites(a0)
	move.b	#2,sub4_mapframe(a0)
	move.b	#1,sub3_mapframe(a0)
	btst.b	#0,(Vint_runcount+3)
	beq.s	@ignore
	bset	#5,art_tile(a0)
	@ignore:
	move.b	#ObjId_DeleteObject,(a0)
	moveq	#0,d0			; d0 = (priority<<7)&$380
	jmp	DisplaySpriteSub