; ===========================================================================
; ---------------------------------------------------------------------------
; Object 0D - End of level signpost
; ---------------------------------------------------------------------------

Obj0D:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj0D_Index(pc,d0.w),d1
		jsr	Obj0D_Index(pc,d1.w)
		lea	(Ani_obj0D).l,a1
		bsr.w	AnimateSprite
		out_of_range	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
Obj0D_Index:	dc.w Obj0D_Init-Obj0D_Index
		dc.w Obj0D_Main-Obj0D_Index
		dc.w Obj0D_Spin-Obj0D_Index
		dc.w Obj0D_EndLevel-Obj0D_Index
		dc.w locret_F18A-Obj0D_Index
; ===========================================================================
; loc_EFD6:
Obj0D_Init:
		addq.b	#2,routine(a0)
		move.l	#Map_SignPost,mappings(a0)
		move.w	#$680,art_tile(a0)
		bsr	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#$18,width_pixels(a0)
		move.b	#4,priority(a0)
; loc_EFFE:
Obj0D_Main:
		move.w	(MainCharacter+x_pos).w,d0
		sub.w	x_pos(a0),d0
		bcs.s	@DoNothing
		cmpi.w	#$20,d0
		bcc.s	@DoNothing
		move.w	#$CF,d0
		jsr	(PlaySound).l
		clr.b	(Update_HUD_timer).w
		move.w	(Camera_Max_X_pos).w,(Camera_Min_X_pos).w
		addq.b	#2,routine(a0)

	@DoNothing:
		rts
; ===========================================================================
; loc_F028:
Obj0D_Spin:
		subq.w	#1,$30(a0)
		bpl.s	Obj0D_Sparkle
		move.w	#$3C,$30(a0)
		addq.b	#1,anim(a0)
		cmpi.b	#3,anim(a0)
		bne.s	Obj0D_Sparkle
		addq.b	#2,routine(a0)
; loc_F044:
Obj0D_Sparkle:
		subq.w	#1,$32(a0)
		bpl.s	@NoFreeObjectSlot
		move.w	#$B,$32(a0)
		moveq	#0,d0
		move.b	$34(a0),d0
		addq.b	#2,$34(a0)
		andi.b	#$E,$34(a0)
		lea	Obj0D_RingSparklePositions(pc,d0.w),a2
		jsr	SingleObjLoad
		bne.s	@NoFreeObjectSlot
		move.b	#ObjID_Ring,id(a1)
		move.b	#6,routine(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	x_pos(a0),d0
		move.w	d0,x_pos(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	y_pos(a0),d0
		move.w	d0,y_pos(a1)
		move.l	#Map_Ring,mappings(a1)
		move.w	#$27B2,art_tile(a1)
		bsr.w	Adjust2PArtPointer2
		move.b	#4,render_flags(a1)
		move.b	#2,priority(a1)
		move.b	#8,width_pixels(a1)
	@NoFreeObjectSlot:
		rts
; ===========================================================================
; dword_F0B4:
Obj0D_RingSparklePositions:
		dc.l $E8F00808
		dc.l $F00018F8
		dc.l $F81000
		dc.l $E8081810
; ===========================================================================
; loc_F0C4:
Obj0D_EndLevel:
		tst.w	(Debug_placement_mode).w
		bne.w	locret_F15E
		btst	#1,(MainCharacter+status).w
		bne.s	loc_F0E0
		move.b	#1,($FFFFF7CC).w
		move.w	#btnR<<8,(Ctrl_1_Held_Logical).w	; force right input

loc_F0E0:
		; This check here is for S1's Big Ring, which would set Sonic's Object ID to 0
		tst.b	(MainCharacter).w
		beq.s	loc_F0F6
		move.w	(MainCharacter+x_pos).w,d0
		move.w	(Camera_Max_X_pos).w,d1
		addi.w	#$128,d1
		cmp.w	d1,d0
		bcs.s	locret_F15E

loc_F0F6:
		addq.b	#2,routine(a0)

; ---------------------------------------------------------------------------
; Subroutine to load the end of act results screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; GotThroughAct:
Load_EndOfAct:
		tst.b	(End_Of_act_Title_Card).w
		bne.s	locret_F15E
		move.w	(Camera_Max_X_pos).w,(Camera_Min_X_pos).w
		clr.b	($FFFFFE2D).w
		clr.b	(Update_HUD_timer).w
		move.b	#ObjID_TitleCard,(End_Of_act_Title_Card).w
		move.b	#8,(End_Of_act_Title_Card+routine).w
		moveq	#PLCID_S1TitleCard,d0
		jsr	(LoadPLC2).l
		move.b	#1,(Update_Bonus_score).w
		moveq	#0,d0
		move.b	(Timer_minute).w,d0
		mulu.w	#$3C,d0
		moveq	#0,d1
		move.b	(Timer_second).w,d1
		add.w	d1,d0
		divu.w	#$F,d0
		moveq	#$14,d1
		cmp.w	d1,d0
		bcs.s	loc_F140
		move.w	d1,d0

loc_F140:
		add.w	d0,d0
		move.w	TimeBonuses(pc,d0.w),(Bonus_Countdown_1).w
		move.w	(Ring_count).w,d0
		mulu.w	#$A,d0
		move.w	d0,(Bonus_Countdown_2).w
		move.w	#$8E,d0
		jsr	(PlaySound_Special).l

locret_F15E:
		rts
; End of function Load_EndOfAct

; ===========================================================================
; word_F160:
TimeBonuses:	dc.w  5000, 5000, 1000,	 500
		dc.w   400,  400,  300,	 300
		dc.w   200,  200,  200,	 200
		dc.w   100,  100,  100,	 100
		dc.w	50,   50,   50,	  50
		dc.w	 0
; ===========================================================================

locret_F18A:
		rts
; ===========================================================================
; animation script
; off_F18C:
Ani_obj0D:	dc.w byte_F194-Ani_obj0D
		dc.w byte_F197-Ani_obj0D
		dc.w byte_F1A5-Ani_obj0D
		dc.w byte_F1B3-Ani_obj0D
byte_F194:	dc.b  $F,  2,$FF
byte_F197:	dc.b   1,  2,  3,  4,  5,  1,  3,  4
		dc.b   5,  0,  3,  4,  5,$FF
byte_F1A5:	dc.b   1,  2,  3,  4,  5,  1,  3,  4
		dc.b   5,  0,  3,  4,  5,$FF
byte_F1B3:	dc.b  $F,  0,$FF
		even
