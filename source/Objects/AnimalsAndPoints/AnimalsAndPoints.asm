;----------------------------------------------------
; Object 28 - animals
;----------------------------------------------------
Obj28:	
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
		GenerateIndex	2, Anml, Ending
		GenerateIndex	2, loc_9CB8
		GenerateIndex	2, Anml, Flightless	; Pocky (Bunny)
		GenerateIndex	2, Anml, Birds		; Cucky (Chicken)
		GenerateIndex	2, Anml, Flightless	; Pecky (Penguin)
		GenerateIndex	2, Anml, Flightless	; Rocky (Seal)
		GenerateIndex	2, Anml, Flightless	; Picky (Pig)
		GenerateIndex	2, Anml, Birds		; Flicky (Do I even need to write this one down?)
		GenerateIndex	2, Anml, Flightless	; Ricky (Squirrel)

		GenerateIndex	2, loc_9DCE

		GenerateIndexID	2, Anml, loc_9DEE
		GenerateIndex	2, Anml, loc_9DEE

		GenerateIndex	2, loc_9E0E
		GenerateIndex	2, loc_9E48
		GenerateIndex	2, loc_9EA2
		GenerateIndex	2, loc_9EC0
		GenerateIndex	2, loc_9EA2
		GenerateIndex	2, loc_9EC0
		GenerateIndex	2, loc_9EA2
		GenerateIndex	2, loc_9EFE
		GenerateIndex	2, loc_9E64

		GenerateIndexID	2, Points, Main

Anml_StoreType	equ	$30
Anml_InitXVel	equ	$32
Anml_InitYVel	equ	$34
Anml_Valentine	equ	$36


; ===========================================================================

Anml_VarIndex:	dc.b	0,  5	; GHZ	- Pocky, Flicky
		dc.b	2,  3	; LZ	- Pecky, Rocky
		dc.b	6,  3	; MZ	- Ricky, Rocky
		dc.b	4,  5	; SLZ	- Picky, Flicky
		dc.b	4,  1	; SYZ	- Picky, Cucky
		dc.b	0,  1	; SBZ	- Pocky, Cucky
		dc.b	0,  5	; END	- Pocky, Flicky

Anml_Variables:
@Animal_Setup	macro	hspeed,vspeed,mappings
		dc.w	hspeed, vspeed
		dc.l	mappings
		endm

		;speed	x,	y, 	mappings
	@Animal_Setup	$200,	-$400,	Map_Animal1	; Pocky
	@Animal_Setup	$200,	-$300,	Map_Animal2	; Cucky
	@Animal_Setup	$180,	-$300,	Map_Animal1	; Pecky
	@Animal_Setup	$140,	-$180,	Map_Animal2	; Rocky
	@Animal_Setup	$1C0,	-$300,	Map_Animal3	; Picky
	@Animal_Setup	$300,	-$400,	Map_Animal2	; Flicky
	@Animal_Setup	$280,	-$380,	Map_Animal3	; Ricky

Anml_EndSpeed:	
		dc.w $FBC0, $FC00
		dc.w $FBC0, $FC00
		dc.w $FBC0, $FC00
		dc.w $FD00, $FC00
		dc.w $FD00, $FC00
		dc.w $FE80, $FD00
		dc.w $FE80, $FD00
		dc.w $FEC0, $FE80
		dc.w $FE40, $FD00
		dc.w $FE00, $FD00
		dc.w $FD80, $FC80


Anml_EndMap:	dc.l	Map_Animal2,	Map_Animal2
		dc.l	Map_Animal2,	Map_Animal1
		dc.l	Map_Animal1,	Map_Animal1
		dc.l	Map_Animal1,	Map_Animal2
		dc.l	Map_Animal3,	Map_Animal2
		dc.l	Map_Animal3,	Map_Animal2

Anml_EndVram:	dc.w	$5A5,	$5A5
		dc.w	$5A5,	$553
		dc.w	$553,	$573
		dc.w	$573,	$585
		dc.w	$593,	$565
		dc.w	$5B3,	$565
; ===========================================================================

Anml_Ending:	
	tst.b	Subtype(a0)
	beq.w	Anml_FromEnemy	; Subtype 0 = Animal from Enemy
		moveq	#0,d0
		move.b	Subtype(a0),d0
		add.w	d0,d0
		move.b	d0,routine(a0)
		subi.w	#$14,d0
		move.w	Anml_EndVram(pc,d0.w),art_tile(a0)
		add.w	d0,d0
		move.l	Anml_EndMap(pc,d0.w),mappings(a0)
		lea	Anml_EndSpeed(pc),a1
		move.w	(a1,d0.w),Anml_InitXVel(a0)
		move.w	(a1,d0.w),x_vel(a0)
		move.w	2(a1,d0.w),Anml_InitYVel(a0)
		move.w	2(a1,d0.w),y_vel(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#$C,y_radius(a0)
		move.b	#4,render_flags(a0)
		bset	#0,render_flags(a0)
		move.b	#6,priority(a0)
		move.b	#8,width_pixels(a0)
		move.b	#7,anim_frame_duration(a0)
		jmp	DisplaySprite
; ===========================================================================

Anml_FromEnemy:	
		addq.b	#2,routine(a0)
		jsr	RandomNumber
		andi.w	#1,d0
		moveq	#0,d1
		move.b	(Current_Zone).w,d1
		add.w	d1,d1
		add.w	d0,d1
		lea	Anml_VarIndex(pc),a1
		move.b	(a1,d1.w),d0
		move.b	d0,Anml_StoreType(a0)
		lsl.w	#3,d0
		lea	Anml_Variables(pc),a1
		adda.w	d0,a1
		move.w	(a1)+,Anml_InitXVel(a0)
		move.w	(a1)+,Anml_InitYVel(a0)
		move.l	(a1)+,mappings(a0)
		move.w	#$580,art_tile(a0)
		btst	#0,Anml_StoreType(a0)
		beq.s	loc_9C4A
		move.w	#$592,art_tile(a0)

loc_9C4A:				; CODE XREF: ROM:00009C42j
		bsr.w	Adjust2PArtPointer
		move.b	#$C,y_radius(a0)
		move.b	#4,render_flags(a0)
		bset	#0,render_flags(a0)
		move.b	#6,priority(a0)
		move.b	#8,width_pixels(a0)
		move.b	#7,anim_frame_duration(a0)
		move.b	#2,mapping_frame(a0)
		move.w	#-$400,y_vel(a0)
		tst.b	($FFFFF7A7).w
		bne.s	loc_9CAA
		jsr	SingleObjLoad
		bne.s	Anml_Display
		move.b	#ObjID_AnimalsAndPoints,id(a1)

		move.l	#Map_Points,mappings(a1)
		move.b	#PointsID_Main,Routine(a1)
		move.w	#$4AC,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.b	#1,priority(a1)
		move.b	#8,width_pixels(a1)
		move.w	#-$300,y_vel(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	$3E(a0),d0
		lsr.w	#1,d0
		move.b	d0,mapping_frame(a1)
		bsr.w	Adjust2PArtPointerChild

Anml_Display:	
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9CAA:				; CODE XREF: ROM:00009C82j
		move.b	#$12,routine(a0)
		clr.w	x_vel(a0)
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9CB8:				; DATA XREF: ROM:off_9AB6o
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bsr.w	ObjectMoveAndFall

		tst.w	y_vel(a0)		; check Y speed
		bmi.s	loc_9D0E		; if going upward, branch
		jsr	(ObjHitFloor).l		; 
		tst.w	d1
		bpl.s	loc_9D0E
		add.w	d1,y_pos(a0)
		move.w	Anml_InitXVel(a0),x_vel(a0)
		move.w	Anml_InitYVel(a0),y_vel(a0)
		move.b	#1,mapping_frame(a0)	; animal has landed
		move.b	Anml_StoreType(a0),d0
		add.b	d0,d0
		addq.b	#4,d0			; 4 + 2*Animaltype
		move.b	d0,routine(a0)
		tst.b	($FFFFF7A7).w		; is this after a boss?
		beq.s	loc_9D0E		; if not, branch
		btst	#4,(Vint_runcount+3).w	; check bit from frame counter
		beq.s	loc_9D0E
		neg.w	x_vel(a0)		; turn animal around
		bchg	#0,render_flags(a0)

loc_9D0E:	
		bra.w	DisplaySprite
; ----------------------------------------------------------------------------
; Check for Valentines partner

Anml_FindPartner:
		lea	(Level_Object_Space).w,a1	; begin checking object RAM
		move.w	#(128-32)-1,d6
	@Loop:
		cmpi.b	#Objid_AnimalsAndPoints,(a1)	; is this an animal?
		bne.s	@next			; if not, branch
		move.w	a1,d0			
		cmp.w	a0,d0			; is this you?
		beq.s	@next			; if so, branch
		tst.b	Anml_Valentine(a1)	; are they single?
		bne.s	@next			; if not, branch
		move.w	a0,Anml_Valentine(a1)	; give them your number
		move.w	d0,Anml_Valentine(a0)	; tell em to call you ;)
		bra.w	DisplaySprite
	@next:
		lea	Object_RAM(a1),a1	; check	next object
		dbf	d6,@Loop		; repeat $5F times
		bra.w	DisplaySprite
; ----------------------------------------------------------------------------
Anml_Flightless:	
		bsr.s	Anml_CheckPartner
		bsr.w	ObjectMoveAndFall
		move.b	#1,mapping_frame(a0)
		tst.w	y_vel(a0)
		bmi.s	loc_9D3C
		move.b	#0,mapping_frame(a0)
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_9D3C
		add.w	d1,y_pos(a0)
		move.w	Anml_InitYVel(a0),y_vel(a0)
	loc_9D3C:	
		tst.b	Subtype(a0)
		bne	loc_9DB2
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
Anml_CheckPartner:
		tst.b	Anml_Valentine(a0)		; do we have a partner?
		bpl.s	@doNothing	; if not, branch (Object RAM start at $D800, so it's all negative)
		lea	(-1).w,a1	; clear a1
		move.w	Anml_Valentine(a0),a1	; get partner's address
		move.w	X_Pos(a1),d0	; get partner's X position
		sub.w	X_Pos(a0),d0	; get distance
		bmi.s	@negative
	@return:
		cmpi.w	#16,d0		; are animals 16 pixels appart from each other?
		bcc	@doNothing	; if not, branch

		clr.w	X_Vel(a0)		; stop horizontally
		move.b	#4,Routine(a0)		; normal gravity
		move.w	#-$180,Anml_InitYVel(a0)		; low hops
		move.b	#1,Anml_Valentine(a0)		; end of partner finding routine
	;	clr.w	X_Vel(a1)		; stop horizontally
	;	move.b	#4,obRoutine(a1)	; normal gravity
	;	move.w	#-$180,Anml_InitYVel(a1)		; low hops
	;	move.b	#1,Anml_Valentine(a1)	; end of partner finding routine
		; bad, the animal doesn't turn around if it falls on top, creating a very unfortunate pose...
	@doNothing:
		rts
	@negative:
		neg.w	d0	; relative distance
		tst.w	X_Vel(a0)	; is animal going to the left?
		bmi.s	@return		; if so, branch
		neg.w	X_Vel(a0)	; move left
		bchg	#0,render_flags(a0)	; turn sprite around
		bra.s	@return
; ===========================================================================
Anml_Birds:	
		bsr.s	Anml_CheckPartner
		bsr.w	ObjectMove
		addi.w	#$18,y_vel(a0)
		tst.w	y_vel(a0)
		bmi.s	loc_9D8A
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_9D8A
		add.w	d1,y_pos(a0)
		move.w	Anml_InitYVel(a0),y_vel(a0)
		tst.b	Subtype(a0)
		beq.s	loc_9D8A
		cmpi.b	#$A,Subtype(a0)
		beq.s	loc_9D8A
		neg.w	x_vel(a0)
		bchg	#0,render_flags(a0)

loc_9D8A:
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	loc_9DA0
		move.b	#1,anim_frame_duration(a0)
		addq.b	#1,mapping_frame(a0)
		andi.b	#1,mapping_frame(a0)

loc_9DA0:				; CODE XREF: ROM:00009D8Ej
		tst.b	Subtype(a0)
		bne.s	loc_9DB2
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9DB2:	
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		bcs.s	loc_9DCA
		subi.w	#$180,d0
		bpl.s	loc_9DCA
		tst.b	render_flags(a0)
		bpl.w	DeleteObject

loc_9DCA:	
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9DCE:				; DATA XREF: ROM:off_9AB6o
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		subq.w	#1,$36(a0)
		bne.w	loc_9DEA
		move.b	#2,routine(a0)
		move.b	#3,priority(a0)

loc_9DEA:				; CODE XREF: ROM:00009DDAj
		bra.w	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Anml_loc_9DEE:				; DATA XREF: ROM:off_9AB6o
		bsr.w	sub_9F92
		bcc.s	loc_9E0A
		move.w	Anml_InitXVel(a0),x_vel(a0)
		move.w	Anml_InitYVel(a0),y_vel(a0)
		move.b	#$E,routine(a0)
		bra.w	Anml_Birds
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9E0A:				; CODE XREF: ROM:00009DF2j
		bra.w	loc_9DB2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9E0E:				; DATA XREF: ROM:off_9AB6o
		bsr.w	sub_9F92
		bpl.s	loc_9E44
		clr.w	x_vel(a0)
		clr.w	Anml_InitXVel(a0)
		bsr.w	ObjectMove
		addi.w	#$18,y_vel(a0)
		bsr.w	sub_9F52
		bsr.w	sub_9F7A
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	loc_9E44
		move.b	#1,anim_frame_duration(a0)
		addq.b	#1,mapping_frame(a0)
		andi.b	#1,mapping_frame(a0)

loc_9E44:				; CODE XREF: ROM:00009E12j
					; ROM:00009E32j
		bra.w	loc_9DB2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9E48:				; DATA XREF: ROM:off_9AB6o
		bsr.w	sub_9F92
		bpl.s	loc_9E9E
		move.w	Anml_InitXVel(a0),x_vel(a0)
		move.w	Anml_InitYVel(a0),y_vel(a0)
		move.b	#4,routine(a0)
		bra.w	Anml_Flightless
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9E64:				; DATA XREF: ROM:off_9AB6o
		bsr.w	ObjectMoveAndFall
		move.b	#1,mapping_frame(a0)
		tst.w	y_vel(a0)
		bmi.s	loc_9E9E
		move.b	#0,mapping_frame(a0)
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_9E9E
		not.b	$29(a0)
		bne.s	loc_9E94
		neg.w	x_vel(a0)
		bchg	#0,render_flags(a0)

loc_9E94:				; CODE XREF: ROM:00009E88j
		add.w	d1,y_pos(a0)
		move.w	Anml_InitYVel(a0),y_vel(a0)

loc_9E9E:				; CODE XREF: ROM:00009E4Cj
					; ROM:00009E72j ...
		bra.w	loc_9DB2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9EA2:				; DATA XREF: ROM:off_9AB6o
		bsr.w	sub_9F92
		bpl.s	loc_9EBC
		clr.w	x_vel(a0)
		clr.w	Anml_InitXVel(a0)
		bsr.w	ObjectMoveAndFall
		bsr.w	sub_9F52
		bsr.w	sub_9F7A

loc_9EBC:				; CODE XREF: ROM:00009EA6j
		bra.w	loc_9DB2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9EC0:				; DATA XREF: ROM:off_9AB6o
		bsr.w	sub_9F92
		bpl.s	loc_9EFA
		bsr.w	ObjectMoveAndFall
		move.b	#1,mapping_frame(a0)
		tst.w	y_vel(a0)
		bmi.s	loc_9EFA
		move.b	#0,mapping_frame(a0)
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_9EFA
		neg.w	x_vel(a0)
		bchg	#0,render_flags(a0)
		add.w	d1,y_pos(a0)
		move.w	Anml_InitYVel(a0),y_vel(a0)

loc_9EFA:				; CODE XREF: ROM:00009EC4j
					; ROM:00009ED4j ...
		bra.w	loc_9DB2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_9EFE:				; DATA XREF: ROM:off_9AB6o
		bsr.w	sub_9F92
		bpl.s	loc_9F4E
		bsr.w	ObjectMove
		addi.w	#$18,y_vel(a0)
		tst.w	y_vel(a0)
		bmi.s	loc_9F38
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_9F38
		not.b	$29(a0)
		bne.s	loc_9F2E
		neg.w	x_vel(a0)
		bchg	#0,render_flags(a0)

loc_9F2E:				; CODE XREF: ROM:00009F22j
		add.w	d1,y_pos(a0)
		move.w	Anml_InitYVel(a0),y_vel(a0)

loc_9F38:				; CODE XREF: ROM:00009F12j
					; ROM:00009F1Cj
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	loc_9F4E
		move.b	#1,anim_frame_duration(a0)
		addq.b	#1,mapping_frame(a0)
		andi.b	#1,mapping_frame(a0)

loc_9F4E:				; CODE XREF: ROM:00009F02j
					; ROM:00009F3Cj
		bra.w	loc_9DB2

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_9F52:				; CODE XREF: ROM:00009E26p
					; ROM:00009EB4p
		move.b	#1,mapping_frame(a0)
		tst.w	y_vel(a0)
		bmi.s	locret_9F78
		move.b	#0,mapping_frame(a0)
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	locret_9F78
		add.w	d1,y_pos(a0)
		move.w	Anml_InitYVel(a0),y_vel(a0)

locret_9F78:				; CODE XREF: sub_9F52+Aj sub_9F52+1Aj
		rts
; End of function sub_9F52


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_9F7A:				; CODE XREF: ROM:00009E2Ap
					; ROM:00009EB8p
		bset	#0,render_flags(a0)
		move.w	x_pos(a0),d0
		sub.w	(MainCharacter+x_pos).w,d0
		bcc.s	locret_9F90
		bclr	#0,render_flags(a0)

locret_9F90:				; CODE XREF: sub_9F7A+Ej
		rts
; End of function sub_9F7A


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_9F92:	
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		subi.w	#$B8,d0
		rts

; End of function sub_9F92
; ===========================================================================

;----------------------------------------------------
; Object 29 - points that appear when you destroy something
;----------------------------------------------------
Points_Main:	
		tst.w	y_vel(a0)
		bpl	DeleteObject
		bsr	ObjectMove
		addi.w	#$18,y_vel(a0)	; slow down ascention
		bra	DisplaySprite