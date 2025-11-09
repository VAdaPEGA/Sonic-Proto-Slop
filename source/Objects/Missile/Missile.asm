; ===========================================================================
; Object 23 - Buzz Bomber/Newtron missile
missile_parent:	equ $3C
; ---------------------------------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj23_Index(pc,d0.w),d1
		jmp	Obj23_Index(pc,d1.w)
; ===========================================================================
Obj23_Index:	dc.w Obj23_Init-Obj23_Index
		dc.w Obj23_Animate-Obj23_Index
		dc.w Obj23_Move-Obj23_Index
		dc.w Obj23_Delete-Obj23_Index
		dc.w Obj23_Newtron-Obj23_Index
; ===========================================================================
; loc_A576:
Obj23_Init:
		subq.w	#1,$32(a0)
		bpl.s	Obj23_ChkDel
		addq.b	#2,routine(a0)
		move.l	#Map_Missile,mappings(a0)
		move.w	#$2444,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#3,priority(a0)
		move.b	#8,width_pixels(a0)
		andi.b	#3,status(a0)
		tst.b	subtype(a0)	; was the object created by a Newtron?
		beq.s	Obj23_Animate	; if not, branch

		move.b	#8,routine(a0)
		move.b	#$87,$20(a0)
		move.b	#1,anim(a0)
		bra.s	Obj23_Animate2
; ===========================================================================
; loc_A5C4:
Obj23_Animate:
		movea.l	missile_parent(a0),a1
		cmpi.b	#ObjID_Buzzbomber,id(a1)	; is Buzz Bomber destroyed?
		beq.s	Obj23_Delete			; if yes, branch
		lea	(Ani_obj23).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to	check if the Buzz Bomber which fired the missile has been
; destroyed, and if it has, deletes the missile
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; loc_A5DE:
Obj23_ChkDel:
		movea.l	missile_parent(a0),a1
		cmpi.b	#ObjID_Buzzbomber,id(a1)	; is Buzz Bomber destroyed?
		beq.s	Obj23_Delete			; if yes, branch
		rts
; End of function Obj23_ChkDel

; ===========================================================================
; loc_A5EC:
Obj23_Move:
		btst	#7,status(a0)	; has the missile collided with the level? (flag never set)
		bne.s	Obj23_Explode	; if yes, branch
		move.b	#$87,$20(a0)
		move.b	#1,anim(a0)
		bsr.w	ObjectMove
		lea	(Ani_obj23).l,a1
		bsr.w	AnimateSprite
		move.w	(Camera_Max_Y_pos_now).w,d0
		addi.w	#224,d0
		cmp.w	y_pos(a0),d0
		bcs.s	Obj23_Delete
		bra.w	DisplaySprite
; ===========================================================================
; loc_A620:
Obj23_Explode:
		move.b	#ObjID_Explosion,id(a0) ; Buzz Bomber missile explosion
		clr.b	routine(a0)
		move.b	#Explosion_Ground,Subtype(a0)
		bra	ObjExplosion
; ===========================================================================
; loc_A630:
Obj23_Delete:
		bra.w	DeleteObject
; ===========================================================================
; loc_A634:
Obj23_Newtron:
		tst.b	render_flags(a0)
		bpl.s	Obj23_Delete
		bsr.w	ObjectMove
; loc_A63E:
Obj23_Animate2:
		lea	(Ani_obj23).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
