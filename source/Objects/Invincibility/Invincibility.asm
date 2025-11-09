; ===========================================================================
; shield and invincibility stars
; ---------------------------------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj38_Index(pc,d0.w),d1
		jmp	Obj38_Index(pc,d1.w)
; ===========================================================================
Obj38_Index:	dc.w Obj38_Init-Obj38_Index
		dc.w Obj38_Shield-Obj38_Index
		dc.w Obj38_Stars-Obj38_Index
; ===========================================================================

Obj38_Init:
		addq.b	#2,routine(a0)
		;move.l	#Map_obj38,mappings(a0)
		move.b	#4,render_flags(a0)
		move.b	#1,priority(a0)
		move.b	#$18,width_pixels(a0)
		tst.b	anim(a0)	; is this the shield?
		bne.s	loc_1240C	; if not, branch
		move.w	#$4BE,art_tile(a0)

loc_12406:
		jmp	Adjust2PArtPointer
; ===========================================================================

loc_1240C:
		addq.b	#2,routine(a0)
		move.l	#Map_Sonic,mappings(a0)
		move.w	#VRAM_Plr1/$20,art_tile(a0)
		move.b	#2,priority(a0)
		jmp	Adjust2PArtPointer
; ===========================================================================

Obj38_Shield:
		tst.b	($FFFFFE2D).w	; is Sonic invincible?
		bne.s	locret_1245A	; if yes, branch
		tst.b	($FFFFFE2C).w	; does Sonic have a shield?
		beq.s	Obj38_Delete	; if not, branch
		move.w	(MainCharacter+x_pos).w,x_pos(a0)
		move.w	(MainCharacter+y_pos).w,y_pos(a0)
		move.b	(MainCharacter+status).w,status(a0)
		;lea	(Ani_obj38).l,a1
		;jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------

locret_1245A:
		rts
; ===========================================================================
; loc_1245C:
Obj38_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
; This code has some connection to Unused_RecordPos, as both use Tails'
; position buffer for something

Obj38_Stars:
		tst.b	($FFFFFE2D).w	; is Sonic invincible?
		beq.s	Obj38_Delete	; if not, branch
		move.w	(Sonic_Pos_Record_Index).w,d0
		move.b	anim(a0),d1
		move.b	d0,d2
		add.b	d1,d2
		and.b	#4,d2
		beq.s	locret_1245A
		;subq.b	#1,d1
		;move.b	#$3F,d1
		;lsl.b	#2,d1
		addi.b	#4,d1
		sub.b	d1,d0
		lea	(Sonic_Pos_Record_Buf).w,a1	; position buffer
		lea	(a1,d0.w),a1
		move.w	(a1)+,d0
		andi.w	#$3FFF,d0
		move.w	d0,x_pos(a0)
		move.w	(a1)+,d0
		andi.w	#$7FF,d0
		move.w	d0,y_pos(a0)
		move.b	(MainCharacter+status).w,status(a0)
		move.b	(MainCharacter+mapping_frame).w,mapping_frame(a0)
		move.b	(MainCharacter+render_flags).w,render_flags(a0)
		move.w	(MainCharacter+art_tile).w,art_tile(a0)
		jmp	(DisplaySprite).l

;Obj38_Stars:
;		tst.b	($FFFFFE2D).w	; is Sonic invincible?
;		beq.s	Obj38_Delete	; if not, branch
;
;
;		lea	(MainCharacter).w,a1
;		move.w	x_pos(a1),x_pos(a0)
;		move.w	y_pos(a1),y_pos(a0)
;		move.b	render_flags(a1),render_flags(a0)
;		jmp	(DisplaySprite).l

; ===========================================================================
