;----------------------------------------------------
; Sonic	1 Object 1E - leftover Ballhog object
;----------------------------------------------------

S1Obj_1E:				; leftover from	Sonic 1
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	S1Obj_1E_Index(pc,d0.w),d1
		jmp	S1Obj_1E_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
S1Obj_1E_Index:	dc.w loc_966E-S1Obj_1E_Index
		dc.w loc_96C2-S1Obj_1E_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_966E:				; DATA XREF: ROM:S1Obj_1E_Indexo
		move.b	#$13,y_radius(a0)
		move.b	#8,x_radius(a0)
		move.l	#Map_S1Obj1E,mappings(a0)
		move.w	#$2302,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	#5,$20(a0)
		move.b	#$C,width_pixels(a0)
		bsr.w	ObjectMoveAndFall
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	locret_96C0
		add.w	d1,y_pos(a0)
		move.w	#0,y_vel(a0)
		addq.b	#2,routine(a0)

locret_96C0:				; CODE XREF: ROM:000096B0j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_96C2:				; DATA XREF: ROM:0000966Co
		lea	(Ani_S1Obj1E).l,a1
		bsr.w	AnimateSprite
		cmpi.b	#1,mapping_frame(a0)
		bne.s	loc_96DC
		tst.b	$32(a0)
		beq.s	loc_96E4
		bra.s	loc_96E0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_96DC:				; CODE XREF: ROM:000096D2j
		clr.b	$32(a0)

loc_96E0:				; CODE XREF: ROM:000096DAj
					; ROM:loc_972Ej
		bra.w	MarkObjGone
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_96E4:				; CODE XREF: ROM:000096D8j
		move.b	#1,$32(a0)
		bsr.w	SingleObjLoad
		bne.s	loc_972E
		move.b	#$20,id(a1) ; ' '
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	#-$100,x_vel(a1)
		move.w	#0,y_vel(a1)
		moveq	#-4,d0
		btst	#0,status(a0)
		beq.s	loc_971E
		neg.w	d0
		neg.w	x_vel(a1)

loc_971E:				; CODE XREF: ROM:00009716j
		add.w	d0,x_pos(a1)
		addi.w	#$C,y_pos(a1)
		move.b	$28(a0),$28(a1)

loc_972E:				; CODE XREF: ROM:000096EEj
		bra.s	loc_96E0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------
; Sonic	1 Object 20 - leftover object for the
;  ball	that S1	Ballhog	throws
;----------------------------------------------------

S1Obj20:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	S1Obj20_Index(pc,d0.w),d1
		jmp	S1Obj20_Index(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
S1Obj20_Index:	dc.w loc_9742-S1Obj20_Index ; DATA XREF: ROM:S1Obj20_Indexo
					; ROM:00009740o
		dc.w loc_978A-S1Obj20_Index
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9742:				; DATA XREF: ROM:S1Obj20_Indexo
		addq.b	#2,routine(a0)
		move.b	#7,y_radius(a0)
		move.l	#Map_S1Obj1E,mappings(a0)
		move.w	#$2302,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#3,priority(a0)
		move.b	#$87,$20(a0)
		move.b	#8,width_pixels(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		mulu.w	#$3C,d0	; '<'
		move.w	d0,$30(a0)
		move.b	#4,mapping_frame(a0)

loc_978A:				; DATA XREF: ROM:00009740o
		jsr	(ObjectMoveAndFall).l
		tst.w	y_vel(a0)
		bmi.s	loc_97C6
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_97C6
		add.w	d1,y_pos(a0)
		move.w	#$FD00,y_vel(a0)
		tst.b	d3
		beq.s	loc_97C6
		bmi.s	loc_97BC
		tst.w	x_vel(a0)
		bpl.s	loc_97C6
		neg.w	x_vel(a0)
		bra.s	loc_97C6
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_97BC:				; CODE XREF: ROM:000097AEj
		tst.w	x_vel(a0)
		bmi.s	loc_97C6
		neg.w	x_vel(a0)

loc_97C6:				; CODE XREF: ROM:00009794j
					; ROM:0000979Ej ...
		subq.w	#1,$30(a0)
		bpl.s	loc_97E2
		move.b	#$24,id(a0) ; '$'
		move.b	#$3F,id(a0) ; '?'
		move.b	#0,routine(a0)
		bra.w	Obj3F		; explosion object
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_97E2:				; CODE XREF: ROM:000097CAj
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	loc_97F4
		move.b	#5,anim_frame_duration(a0)
		bchg	#0,mapping_frame(a0)

loc_97F4:				; CODE XREF: ROM:000097E6j
		move.w	(Camera_Max_Y_pos_now).w,d0
		addi.w	#224,d0	; 'à'
		cmp.w	y_pos(a0),d0
		bcs.w	DeleteObject
		bra.w	DisplaySprite