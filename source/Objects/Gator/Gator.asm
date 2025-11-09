;----------------------------------------------------
; Object 4E - Aligator badnik from HPZ
;----------------------------------------------------
Obj4E:		
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jsr	@Index(pc,d1.w)

		lea	(Ani_Obj4E).l,a1
		jsr	AnimateSprite
		jmp	MarkObjGone
; ===========================================================================
		IndexStart	
	GenerateIndex	2, Obj4E_Init
	GenerateIndex	2, Obj4E_Main
	GenerateIndex	2, loc_1727E
; ===========================================================================
Obj4E_Init:	
		move.l	#Map_Gator,mappings(a0)
		move.w	#$2300,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#$A,collision_flags(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#8,x_radius(a0)
		bsr	ObjectMoveAndFall
		jsr	ObjHitFloor
		tst.w	d1
		bpl.s	@DoNothing
		add.w	d1,y_pos(a0)
		move.w	#0,y_vel(a0)
		addq.b	#2,routine(a0)
	@DoNothing:	
		rts
; ===========================================================================

Obj4E_Main:
		subq.w	#1,$30(a0)
		bpl.s	@DoNothing
		addq.b	#2,routine(a0)
		move.w	#$FF40,x_vel(a0)
		move.b	#0,anim(a0)
		bchg	#0,status(a0)
		bne.s	@DoNothing
		neg.w	x_vel(a0)
	@DoNothing:	
		rts
; ===========================================================================

loc_1727E:				; DATA XREF: ROM:00017258o
		bsr	sub_172B6
		bsr	ObjectMove
		jsr	(ObjHitFloor).l
		cmpi.w	#$FFF8,d1
		blt.s	loc_1729E
		cmpi.w	#$C,d1
		bge.s	loc_1729E
		add.w	d1,y_pos(a0)
		rts
; ===========================================================================

loc_1729E:	
		subq.b	#2,routine(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,x_vel(a0)
		move.b	#1,anim(a0)
		rts

; ===========================================================================


sub_172B6:				; CODE XREF: ROM:loc_1727Ep
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		bmi.s	loc_172D0
		cmpi.w	#$40,d0	; '@'
		bgt.s	loc_172E6
		btst	#0,status(a0)
		beq.s	loc_172DE
		rts
; ===========================================================================

loc_172D0:	
		cmpi.w	#$FFC0,d0
		blt.s	loc_172E6
		btst	#0,status(a0)
		beq.s	loc_172E6

loc_172DE:	
		move.b	#2,anim(a0)
		rts
; ===========================================================================
loc_172E6:	
		move.b	#0,anim(a0)
		rts