; ===========================================================================
; Object 4B - Buzzer from EHZ
buzzer_parent:	equ $2A
; ---------------------------------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex	 Obj4B, Init
	GenerateIndex	 Obj4B, Main
	GenerateIndex	 Obj4B, Flame
	GenerateIndex	 Obj4B, Projectile
; ===========================================================================
; loc_167AA:
Obj4B_Projectile:
		bsr	ObjectMove
		lea	(Ani_obj4B).l,a1
		bra.w	Obj4B_Draw
; ===========================================================================
; loc_167BC:
Obj4B_Flame:
		movea.l	buzzer_parent(a0),a1
		tst.b	(a1)
		beq.s	loc_16A74
		tst.w	$30(a1)
		bmi.s	loc_167CE
		rts
loc_16A74:
		jmp	(DeleteObject).l
; ---------------------------------------------------------------------------

loc_167CE:
		move.w	x_pos(a1),x_pos(a0)
		move.w	y_pos(a1),y_pos(a0)
		move.b	status(a1),status(a0)
		move.b	render_flags(a1),render_flags(a0)
		lea	(Ani_obj4B).l,a1
		bra.w	Obj4B_Draw
; ===========================================================================

Obj4B_Init:
		move.l	#Map_Buzzer,mappings(a0)
		move.w	#$3E6,art_tile(a0)
		jsr	(Adjust2PArtPointer).l
		ori.b	#4,render_flags(a0)
		move.b	#$A,$20(a0)
		move.b	#4,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#$10,y_radius(a0)
		move.b	#$18,x_radius(a0)
		move.b	#3,priority(a0)
		addq.b	#2,routine(a0)	; => Obj4B_Main

		; load exhaust flame object
		jsr	SingleObjLoad2
		bne.s	locret_1689E

		move.b	#$4B,id(a1)	; load obj4B
		move.b	#4,routine(a1)	; => Obj4B_Flame
		move.l	#Map_Buzzer,mappings(a1)
		move.w	#$3E6,art_tile(a1)
		bsr	Adjust2PArtPointer2
		move.b	#4,priority(a1)
		move.b	#$10,width_pixels(a1)
		move.b	status(a0),status(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	#1,anim(a1)
		move.l	a0,buzzer_parent(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	#$100,$2E(a0)
		move.w	#-$100,x_vel(a0)
		btst	#0,render_flags(a0)
		beq.s	locret_1689E
		neg.w	x_vel(a0)

locret_1689E:
		rts
; ===========================================================================

Obj4B_Main:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj4B_Main_Index(pc,d0.w),d1
		jsr	Obj4B_Main_Index(pc,d1.w)
		lea	(Ani_obj4B).l,a1
Obj4B_Draw:
		jsr	(Adjust2PArtPointer2).l
		jmp	(MarkObjGone_P1).l
; ===========================================================================
Obj4B_Main_Index:	dc.w Obj4B_Roaming-Obj4B_Main_Index
			dc.w Obj4B_Shooting-Obj4B_Main_Index
; ===========================================================================
; loc_168C0:
Obj4B_Roaming:
		bsr.w	Obj4B_ChkPlayers
		subq.w	#1,$30(a0)
		move.w	$30(a0),d0
		cmpi.w	#$F,d0
		beq.s	Obj4B_TurnAround
		tst.w	d0
		bpl.s	@DoNothing
		subq.w	#1,$2E(a0)
		bgt	ObjectMove
		move.w	#$1E,$30(a0)
	@DoNothing:
		rts
; ---------------------------------------------------------------------------
; loc_168E6:
Obj4B_TurnAround:
		sf	$32(a0)	; reenable shooting
		neg.w	x_vel(a0)	; reverse movement direction
		bchg	#0,render_flags(a0)
		bchg	#0,status(a0)
		move.w	#$100,$2E(a0)
		rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16902:
Obj4B_ChkPlayers:
		tst.b	$32(a0)
		bne.w	locret_1694E	; branch, if shooting is disabled
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0	; a1=character
		move.w	d0,d1
		bpl.s	loc_16918
		neg.w	d0

loc_16918:
		; test if player is inside an 8 pixel wide strip
		cmpi.w	#$28,d0
		blt.s	locret_1694E
		cmpi.w	#$30,d0
		bgt.s	locret_1694E

		tst.w	d1			; test sign of distance
		bpl.s	Obj4B_PlayerIsLeft	; branch, if player is left from object
		btst	#0,render_flags(a0)
		beq.s	locret_1694E		; branch, if object is facing right
		bra.s	Obj4B_ReadyToShoot
; ---------------------------------------------------------------------------
; loc_16932:
Obj4B_PlayerIsLeft:
		btst	#0,render_flags(a0)
		bne.s	locret_1694E	; branch, if object is facing left
; loc_1693A:
Obj4B_ReadyToShoot:
		st	$32(a0)		; disable shooting
		addq.b	#2,routine_secondary(a0)	; => Obj4B_Shooting
		move.b	#3,anim(a0)	; play shooting animation
		move.w	#$32,$34(a0)

locret_1694E:
		rts
; End of function Obj4B_ChkPlayers

; ===========================================================================
; loc_16950:
Obj4B_Shooting:
		move.w	$34(a0),d0		; get timer value
		subq.w	#1,d0			; decrement
		blt.s	Obj4B_DoneShooting	; branch, if timer has expired
		move.w	d0,$34(a0)		; update timer value
		cmpi.w	#$14,d0			; has timer reached a certain value?
		beq.s	Obj4B_ShootProjectile	; if yes, branch
		rts
; ===========================================================================
; loc_16964:
Obj4B_DoneShooting:
		subq.b	#2,routine_secondary(a0)	; => Obj4B_Roaming
		rts
; ===========================================================================
; loc_1696A:
Obj4B_ShootProjectile:
		jsr	(SingleObjLoad2).l
		bne.s	locret_169D8

		move.b	#$4B,id(a1) ; load obj4B
		move.b	#6,routine(a1)	; => Obj4B_Projectile
		move.l	#Map_Buzzer,mappings(a1)
		move.w	#$3E6,art_tile(a1)
		bsr.w	Adjust2PArtPointer2
		move.b	#4,priority(a1)
		move.b	#$98,$20(a1)
		move.b	#$10,width_pixels(a1)
		move.b	status(a0),status(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	#2,anim(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	#$180,y_vel(a1)
		move.w	#-$180,x_vel(a1)
		btst	#0,render_flags(a1)	; is object facing left?
		beq.s	locret_169D8	; if not, branch
		neg.w	x_vel(a1)		; move in other direction

locret_169D8:
		rts
; ===========================================================================
; animation script
; off_169DA:
Ani_obj4B:	dc.w byte_169E2-Ani_obj4B
		dc.w byte_169E5-Ani_obj4B
		dc.w byte_169E9-Ani_obj4B
		dc.w byte_169ED-Ani_obj4B
byte_169E2:	dc.b  $F,  0,$FF
byte_169E5:	dc.b   2,  3,  4,$FF
byte_169E9:	dc.b   3,  5,  6,$FF
byte_169ED:	dc.b   9,  1,  1,  1,  1,  1,$FD,  0,  0

		