;----------------------------------------------------------------------------
; Rings (object version and spill)
;----------------------------------------------------------------------------
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex	2, RingObj,	Init
	GenerateIndex	2, RingObj,	Main
	GenerateIndex	2, RingObj,	Collect
	GenerateIndexID	2, RingObj,	Display
	GenerateIndex	2, RingObj,	DeleteObject

	GenerateIndexID	2, Ring,	Spill
	GenerateIndex	2, loc_A9FA
	GenerateIndex	2, Spill_Collect
; ---------------------------------------------------------------------------
; Distances between rings (format: horizontal, vertical)
; ---------------------------------------------------------------------------
Ring_PosData:	
		dc.b	$10,	0
		dc.b	$18,	0	
		dc.b	$20,	0
		dc.b	0,	$10	
		dc.b	0,	$18
		dc.b	0,	$20	
		dc.b	$10,	$10
		dc.b	$18,	$18	
		dc.b	$20,	$20
		dc.b	$F0,	$10	
		dc.b	$E8,	$18
		dc.b	$E0,	$20	
		dc.b	$10,	8
		dc.b	$18,	$10	
		dc.b	$F0,	8
		dc.b	$E8,	$10	
; ===========================================================================

RingXinit	=	$32
RingYinit	=	$3A
RingID		=	$34

RingObj_Init:	
		movea.l	a0,a1
		moveq	#0,d1
		move.w	x_pos(a0),d2
		move.w	y_pos(a0),d3
		bra.s	loc_A832
;----------------------------------------------------------------------------
loc_A82A:	
		swap	d1
		jsr	SingleObjLoad
		bne.s	RingObj_Main

loc_A832:	
		move.b	#ObjID_Ring,id(a1)
		addq.b	#2,routine(a1)
		move.w	d2,x_pos(a1)
		move.w	d2,RingXinit(a1)
		move.w	d3,y_pos(a1)
		move.w	d3,RingYinit(a1)
		move.l	#Map_Ring,mappings(a1)
		move.w	#$26BC,art_tile(a1)
		bsr.w	Adjust2PArtPointer2
		move.b	#4,render_flags(a1)
		move.b	#2,priority(a1)
		move.b	#$47,$20(a1) ; 'G'
		move.b	#8,width_pixels(a1)
		move.b	respawn_index(a0),respawn_index(a1)
		move.b	d1,RingID(a1)
		addq.w	#1,d1
		add.w	d5,d2
		add.w	d6,d3
		swap	d1
		dbf	d1,loc_A82A

RingObj_Main:	
		move.b	(Rings_anim_frame).w,mapping_frame(a0)

		out_of_range	RingObj_DeleteObject,RingXinit(a0)
		bra.w	DisplaySprite
;----------------------------------------------------------------------------
RingObj_Collect:	
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		move.b	RingID(a0),d1
		bset	d1,2(a2,d0.w)

Spill_Collect:
		move.b	#RingObjID_Display,routine(a0)
		move.b	#0,collision_flags(a0)
		move.b	#1,priority(a0)
		bsr.s	Collect_Single_Ring

RingObj_Display:	
		lea	(Ani_Ring).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
;----------------------------------------------------------------------------

RingObj_DeleteObject:	
		bra.w	DeleteObject

Collect_Single_Ring:	
		addq.w	#1,(Ring_count).w
		ori.b	#1,(Update_HUD_rings).w
		move.w	#$B5,d0	; Ring sound
		cmpi.w	#100,(Ring_count).w
		bcs.s	loc_A918
		bset	#1,(Extra_life_flags).w
		beq.s	loc_A90C
		cmpi.w	#200,(Ring_count).w
		bcs.s	loc_A918
		bset	#2,(Extra_life_flags).w
		bne.s	loc_A918

loc_A90C:
		addq.b	#1,(Life_count).w
		addq.b	#1,(Update_HUD_lives).w
		move.w	#MusID_ExtraLife,d0

loc_A918:
		jmp	(PlaySound_Special).l
; End of function Collect_Single_Ring

;----------------------------------------------------
; Rings flying out of you when you get hit
;----------------------------------------------------
Ring_Spill:	
		movea.l	a0,a1
		moveq	#0,d5
		move.w	(Ring_count).w,d5
		moveq	#32,d0
		cmp.w	d0,d5
		bcs.s	loc_A946
		move.w	d0,d5

loc_A946:	
		subq.w	#1,d5
		move.w	#$288,d4
		bra.s	loc_A956
;----------------------------------------------------------------------------

loc_A94E:	
		jsr	SingleObjLoad
		bne.w	loc_A9DE

loc_A956:	
		move.b	#ObjID_Ring,id(a1)
		move.b	#RingID_Spill+2,routine(a1)
		move.b	#8,y_radius(a1)
		move.b	#8,x_radius(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	#Map_Ring,mappings(a1)
		move.w	#$26BC,art_tile(a1)
		bsr.w	Adjust2PArtPointer2
		move.b	#4,render_flags(a1)
		move.b	#3,priority(a1)
		move.b	#$47,collision_flags(a1)
		move.b	#8,width_pixels(a1)
		move.b	#$FF,(Ring_spill_anim_counter).w
		tst.w	d4
		bmi.s	loc_A9CE
		move.w	d4,d0
		bsr.w	CalcSine
		move.w	d4,d2
		lsr.w	#8,d2
		asl.w	d2,d1
		asl.w	d2,d0
		move.w	d1,d2
		move.w	d0,d3
		addi.b	#$10,d4
		bcc.s	loc_A9CE
		subi.w	#$80,d4
		bcc.s	loc_A9CE
		move.w	#$288,d4

loc_A9CE:	
		move.w	d2,x_vel(a1)
		move.w	d3,y_vel(a1)
		neg.w	d2
		neg.w	d4
		dbf	d5,loc_A94E

loc_A9DE:	
		move.w	#0,(Ring_count).w
		move.b	#$80,(Update_HUD_rings).w
		move.b	#0,(Extra_life_flags).w
		move.w	#$C6,d0
		jsr	(PlaySound_Special).l

loc_A9FA:	
		move.b	(Ring_spill_anim_frame).w,mapping_frame(a0)
		bsr.w	ObjectMove
		addi.w	#$18,y_vel(a0)	; gravity I guess
		bmi.s	loc_AA34
		move.b	(Vint_runcount+3).w,d0
		add.b	d7,d0
		andi.b	#3,d0
		bne.s	loc_AA34
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.s	loc_AA34
		add.w	d1,y_pos(a0)
		move.w	y_vel(a0),d0
		asr.w	#2,d0
		sub.w	d0,y_vel(a0)
		neg.w	y_vel(a0)

loc_AA34:	
		tst.b	(Ring_spill_anim_counter).w
		beq	RingObj_DeleteObject
		move.w	(Camera_Max_Y_pos_now).w,d0
		addi.w	#224,d0
		cmp.w	y_pos(a0),d0
		bcs	RingObj_DeleteObject
		bra.w	DisplaySprite
;----------------------------------------------------------------------------