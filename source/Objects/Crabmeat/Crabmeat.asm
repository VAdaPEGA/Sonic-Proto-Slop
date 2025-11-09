; ===========================================================================
; ---------------------------------------------------------------------------
; Object 1F - Crabmeat from GHZ
; ---------------------------------------------------------------------------
; OST:
obj1F_timer:	equ $30	; time to wait for performing an action
obj1F_status:	equ $32	; 0 = moving, 1 = firing
; ---------------------------------------------------------------------------

Obj1F:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj1F_Index(pc,d0.w),d1
		jmp	Obj1F_Index(pc,d1.w)
; ===========================================================================
Obj1F_Index:	dc.w Obj1F_Init-Obj1F_Index
		dc.w Obj1F_Main-Obj1F_Index
		dc.w Obj1F_Delete-Obj1F_Index
		dc.w Obj1F_BallInit-Obj1F_Index
		dc.w Obj1F_BallMove-Obj1F_Index
; ===========================================================================
; loc_A0E8:
Obj1F_Init:
		move.b	#$10,y_radius(a0)
		move.b	#8,x_radius(a0)
		move.l	#Map_Crabmeat,mappings(a0)
		move.w	#$400,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#3,priority(a0)
		move.b	#6,$20(a0)
		move.b	#$15,width_pixels(a0)
		bsr.w	ObjectMoveAndFall
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	locret_A13E
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		move.w	#0,y_vel(a0)
		addq.b	#2,routine(a0)

locret_A13E:
		rts
; ===========================================================================
; loc_A140:
Obj1F_Main:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj1F_Main_Index(pc,d0.w),d1
		jsr	Obj1F_Main_Index(pc,d1.w)
		lea	(Ani_obj1F).l,a1
		bsr.w	AnimateSprite
		bra.w	MarkObjGone
; ===========================================================================
Obj1F_Main_Index:	dc.w Obj1F_WaitMove-Obj1F_Main_Index
			dc.w Obj1F_WalkOnFloor-Obj1F_Main_Index
; ===========================================================================
; loc_A160:
Obj1F_WaitMove:
		subq.w	#1,obj1F_timer(a0)
		bpl.s	locret_A19A
		tst.b	render_flags(a0)
		bpl.s	Obj1F_Move
		bchg	#1,obj1F_status(a0)
		bne.s	Obj1F_MakeFire
; loc_A174:
Obj1F_Move:
		addq.b	#2,routine_secondary(a0)
		move.w	#$7F,obj1F_timer(a0)
		move.w	#$80,x_vel(a0)
		bsr.w	Obj1F_SetAni
		addq.b	#3,d0
		move.b	d0,anim(a0)
		bchg	#0,status(a0)
		bne.s	locret_A19A
		neg.w	x_vel(a0)

locret_A19A:
		rts
; ===========================================================================
; loc_A19C:
Obj1F_MakeFire:
		move.w	#$3B,obj1F_timer(a0)
		move.b	#6,anim(a0)
		jsr	SingleObjLoad
		bne.s	Obj1F_MakeFire2
		move.b	#ObjID_Crabmeat,(a1)
		move.b	#6,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		subi.w	#$10,x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	#-$100,x_vel(a1)
; loc_A1D2:
Obj1F_MakeFire2:
		jsr	SingleObjLoad
		bne.s	locret_A1FC
		move.b	#ObjID_Crabmeat,(a1)
		move.b	#6,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		addi.w	#$10,x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	#$100,x_vel(a1)

locret_A1FC:
		rts
; ===========================================================================
; loc_A1FE:
Obj1F_WalkOnFloor:
		subq.w	#1,obj1F_timer(a0)
		bmi.s	loc_A252
		bsr.w	ObjectMove
		bchg	#0,obj1F_status(a0)
		bne.s	loc_A238
		move.w	x_pos(a0),d3
		addi.w	#$10,d3
		btst	#0,status(a0)
		beq.s	loc_A224
		subi.w	#$20,d3

loc_A224:
		jsr	(ObjHitFloor2).l
		cmpi.w	#-8,d1
		blt.s	loc_A252
		cmpi.w	#$C,d1
		bge.s	loc_A252
		rts
; ===========================================================================

loc_A238:
		jsr	(ObjHitFloor).l
		add.w	d1,y_pos(a0)
		move.b	d3,angle(a0)
		bsr.w	Obj1F_SetAni
		addq.b	#3,d0
		move.b	d0,anim(a0)
		rts
; ===========================================================================

loc_A252:
		subq.b	#2,routine_secondary(a0)
		move.w	#$3B,obj1F_timer(a0)
		move.w	#0,x_vel(a0)
		bsr.w	Obj1F_SetAni
		move.b	d0,anim(a0)
		rts

; ---------------------------------------------------------------------------
; Subroutine to	set the	correct	animation for a	Crabmeat
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; sub_A26C:
Obj1F_SetAni:
		moveq	#0,d0
		move.b	angle(a0),d3
		bmi.s	loc_A288
		cmpi.b	#6,d3
		bcs.s	locret_A286
		moveq	#1,d0
		btst	#0,status(a0)
		bne.s	locret_A286
		moveq	#2,d0

locret_A286:
		rts
; ===========================================================================

loc_A288:
		cmpi.b	#-6,d3
		bhi.s	locret_A29A
		moveq	#2,d0
		btst	#0,status(a0)
		bne.s	locret_A29A
		moveq	#1,d0

locret_A29A:
		rts
; End of function Obj1F_SetAni

; ===========================================================================
; loc_A29C:
Obj1F_Delete:
		bra.w	DeleteObject
; ===========================================================================
; loc_A2A0:
Obj1F_BallInit:
		addq.b	#2,routine(a0)
		move.l	#Map_Crabmeat,mappings(a0)
		move.w	#$400,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#3,priority(a0)
		move.b	#$87,$20(a0)
		move.b	#8,width_pixels(a0)
		move.w	#$FC00,y_vel(a0)
		move.b	#7,anim(a0)
; loc_A2DA:
Obj1F_BallMove:
		lea	(Ani_obj1F).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectMoveAndFall
		move.w	(Camera_Max_Y_pos_now).w,d0
		addi.w	#224,d0
		cmp.w	y_pos(a0),d0
		bcs.w	DeleteObject
		bra.w	DisplaySprite
