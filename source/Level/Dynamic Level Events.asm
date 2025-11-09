; ===========================================================================
; Dynamic Level Events, DynamicLevelEvents
DynScreenResizeLoad:
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		add.w	d0,d0
		move.w	DynResize_Index(pc,d0.w),d0
		jsr	DynResize_Index(pc,d0.w)

		moveq	#2,d1
		move.w	(Camera_Max_Y_pos).w,d0
		sub.w	(Camera_Max_Y_pos_now).w,d0
		beq.s	locret_756A
		bcc.s	loc_756C
		neg.w	d1
		move.w	(Camera_Y_pos).w,d0
		cmp.w	(Camera_Max_Y_pos).w,d0
		bls.s	loc_7560
		move.w	d0,(Camera_Max_Y_pos_now).w
		andi.w	#$FFFE,(Camera_Max_Y_pos_now).w

loc_7560:
		add.w	d1,(Camera_Max_Y_pos_now).w
		move.b	#1,(Camera_Max_Y_pos_Changing).w

locret_756A:
		rts
; ===========================================================================

loc_756C:
		move.w	(Camera_Y_pos).w,d0
		addi.w	#8,d0
		cmp.w	(Camera_Max_Y_pos_now).w,d0
		bcs.s	loc_7586
		btst	#1,(MainCharacter+status).w
		beq.s	loc_7586
		add.w	d1,d1
		add.w	d1,d1

loc_7586:	
		add.w	d1,(Camera_Max_Y_pos_now).w
		move.b	#1,(Camera_Max_Y_pos_Changing).w
		rts
; End of function DynScreenResizeLoad

; ===========================================================================
		IndexStart	DynResize_Index	
	GenerateIndex 2,	DynResize_GHZ
	GenerateIndex 2,	DynResize_CPZ
	GenerateIndex 2,	DynResize_MMZ
	GenerateIndex 2,	DynResize_EHZ
	GenerateIndex 2,	DynResize_HPZ
	GenerateIndex 2,	DynResize_HTZ
	GenerateIndex 2,	DynResize_CNZ
; ===========================================================================
DynResize_GHZ:	
		moveq	#0,d0
		move.b	(Current_Act).w,d0
		add.w	d0,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,	DynResize_GHZ1
	GenerateIndex 2,	DynResize_GHZ2
	GenerateIndex 2,	DynResize_GHZ3
	GenerateIndex 2,	DynResize_GHZ_DoNothing
; ===========================================================================
DynResize_GHZ1:				
		move.w	#$300,(Camera_Max_Y_pos).w
		cmpi.w	#$1780,(Camera_X_pos).w
		bcs.s	DynResize_GHZ_DoNothing
		move.w	#$400,(Camera_Max_Y_pos).w

DynResize_GHZ_DoNothing:	
		rts
; ---------------------------------------------------------------------------
DynResize_GHZ2:	
		move.w	#$300,(Camera_Max_Y_pos).w
		cmpi.w	#$ED0,(Camera_X_pos).w
		bcs.s	@DoNothing
		move.w	#$200,(Camera_Max_Y_pos).w
		cmpi.w	#$1600,(Camera_X_pos).w
		bcs.s	@DoNothing
		move.w	#$400,(Camera_Max_Y_pos).w
		cmpi.w	#$1D60,(Camera_X_pos).w
		bcs.s	@DoNothing
		move.w	#$300,(Camera_Max_Y_pos).w
	@DoNothing:	
		rts
; ---------------------------------------------------------------------------
DynResize_GHZ3:	
		moveq	#0,d0
		move.b	(Dynamic_Resize_Routine).w,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,	DynResize_GHZ3_Main
	GenerateIndex 2,	DynResize_GHZ3_Boss
	GenerateIndex 2,	DynResize_GHZ3_End
; ===========================================================================
DynResize_GHZ3_Main:	
		move.w	#$300,(Camera_Max_Y_pos).w
		cmpi.w	#$380,(Camera_X_pos).w
		bcs.s	@DoNothing
		move.w	#$310,(Camera_Max_Y_pos).w
		cmpi.w	#$960,(Camera_X_pos).w
		bcs.s	@DoNothing
		cmpi.w	#$280,(Camera_Y_pos).w
		bcs.s	@loc_765A
		move.w	#$400,(Camera_Max_Y_pos).w
		cmpi.w	#$1380,(Camera_X_pos).w
		bcc.s	@loc_7650
		move.w	#$4C0,(Camera_Max_Y_pos).w
		move.w	#$4C0,(Camera_Max_Y_pos_now).w

	@loc_7650:	
		cmpi.w	#$1700,(Camera_X_pos).w
		bcc.s	@loc_765A
	@DoNothing:	
		rts
	@loc_765A:	
		move.w	#$300,(Camera_Max_Y_pos).w
		addq.b	#2,(Dynamic_Resize_Routine).w
		rts
; ---------------------------------------------------------------------------
DynResize_GHZ3_Boss:	
		cmpi.w	#$960,(Camera_X_pos).w
		bcc.s	loc_7672
		subq.b	#2,(Dynamic_Resize_Routine).w

loc_7672:	
		cmpi.w	#$2960,(Camera_X_pos).w
		bcs.s	locret_76AA
		jsr	SingleObjLoad
		bne.s	loc_7692
		move.b	#$3D,id(a1) ; '='
		move.w	#$2A60,x_pos(a1)
		move.w	#$280,y_pos(a1)

loc_7692:	
		move.w	#MusID_Boss,d0
		bsr.w	PlaySound
		move.b	#1,($FFFFF7AA).w
		addq.b	#2,(Dynamic_Resize_Routine).w
		moveq	#PLCID_Boss,d0
		bra.w	LoadPLC
; ---------------------------------------------------------------------------
locret_76AA:	
		rts
; ---------------------------------------------------------------------------
DynResize_GHZ3_End:	
		move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
		rts
; ---------------------------------------------------------------------------
DynResize_MMZ:	
		moveq	#0,d0
		move.b	(Current_Act).w,d0
		add.w	d0,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,	DynResize_MMZ_Null
	GenerateIndex 2,	DynResize_MMZ_Null
	GenerateIndex 2,	DynResize_MMZ3
	GenerateIndex 2,	DynResize_MMZ4
; ===========================================================================

DynResize_MMZ_Null:
		rts
; ---------------------------------------------------------------------------

DynResize_MMZ3:	
		tst.b	($FFFFF7EF).w
		beq.s	loc_76EA
		lea	(Level_Layout+$206).w,a1
		cmpi.b	#7,(a1)
		beq.s	loc_76EA
		move.b	#7,(a1)
		move.w	#$B7,d0	; '·'
		bsr.w	PlaySound_Special

loc_76EA:	
		tst.b	(Dynamic_Resize_Routine).w
		bne.s	locret_7726
		cmpi.w	#$1CA0,(Camera_X_pos).w
		bcs.s	locret_7724
		cmpi.w	#$600,(Camera_Y_pos).w
		bcc.s	locret_7724
		jsr	SingleObjLoad
		bne.s	loc_770C
		move.b	#$77,id(a1)

loc_770C:	
		move.w	#MusID_Boss,d0
		bsr.w	PlaySound
		move.b	#1,($FFFFF7AA).w
		addq.b	#2,(Dynamic_Resize_Routine).w
		moveq	#PLCID_Boss,d0
		bra.w	LoadPLC
; ---------------------------------------------------------------------------
locret_7724:	
		rts
; ---------------------------------------------------------------------------

locret_7726:	
		rts
; ---------------------------------------------------------------------------

DynResize_MMZ4:	
		cmpi.w	#$D00,(Camera_X_pos).w
		bcs.s	locret_774E
		cmpi.w	#$18,(MainCharacter+y_pos).w
		bcc.s	locret_774E
		clr.b	($FFFFFE30).w
		move.w	#1,($FFFFFE02).w
		move.w	#$502,(Current_ZoneAndAct).w
		move.b	#1,obj_control(a1)

locret_774E:	
		rts
; ===========================================================================

DynResize_CPZ:	
		moveq	#0,d0
		move.b	(Current_Act).w,d0
		add.w	d0,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,	DynResize_CPZ1
	GenerateIndex 2,	DynResize_CPZ2
	GenerateIndex 2,	DynResize_CPZ3
	GenerateIndex 2,	DynResize_CPZBoss
; ===========================================================================
DynResize_CPZ1:	
		rts
; ---------------------------------------------------------------------------
DynResize_CPZ2:	
		rts
; ---------------------------------------------------------------------------
DynResize_CPZ3:	
		rts
; ---------------------------------------------------------------------------
DynResize_CPZBoss:
		moveq	#0,d0
		move.b	(Dynamic_Resize_Routine).w,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,	DynResize_CPZBoss_BossCheck
	GenerateIndex 2,	DynResize_CPZBoss_Null
; ===========================================================================
DynResize_CPZBoss_BossCheck:
		cmpi.w	#$480,(Camera_X_pos).w
		blt.s	DynResize_CPZBoss_Null
		cmpi.w	#$740,(Camera_X_pos).w
		bgt.s	DynResize_CPZBoss_Null
		move.w	(Camera_Max_Y_pos_now).w,d0
		cmp.w	(Camera_Y_pos).w,d0
		bne.s	DynResize_CPZBoss_Null
		move.w	#$740,(Camera_Max_X_pos).w
		move.w	#$480,(Camera_Min_X_pos).w
		addq.b	#2,(Dynamic_Resize_Routine).w
		jsr	SingleObjLoad
		bne.s	DynResize_CPZBoss_Null
		move.b	#$55,id(a1)	; load Obj55 (EHZ boss, likely CPZ boss at one point)
		move.w	#$680,x_pos(a1)
		move.w	#$540,y_pos(a1)
		moveq	#PLCID_Boss,d0
		bra.w	LoadPLC
; ---------------------------------------------------------------------------
DynResize_CPZBoss_Null:
		rts

; ===========================================================================

DynResize_EHZ:	
		moveq	#0,d0
		move.b	(Current_Act).w,d0
		add.w	d0,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,	DynResize_EHZ1
	GenerateIndex 2,	DynResize_EHZ2
	GenerateIndex 2,	DynResize_EHZ3
	GenerateIndex 2,	DynResize_EHZBoss
; ===========================================================================

DynResize_EHZ1:	
		rts
; ---------------------------------------------------------------------------

DynResize_EHZ2:		
		rts
; ---------------------------------------------------------------------------

DynResize_EHZ3:	
		rts
; ---------------------------------------------------------------------------

DynResize_EHZBoss:	
		moveq	#0,d0
		move.b	(Dynamic_Resize_Routine).w,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,	DynResize_EHZBoss_01
	GenerateIndex 2,	DynResize_EHZBoss_02
	GenerateIndex 2,	DynResize_EHZBoss_03
; ===========================================================================
DynResize_EHZBoss_01:
		rts
		cmpi.w	#$26E0,(Camera_X_pos).w
		bcs.s	@DoNothing
		move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
		move.w	#$390,(Camera_Max_Y_pos).w
		move.w	#$390,(Camera_Max_Y_pos_now).w
		addq.b	#2,(Dynamic_Resize_Routine).w
		jsr	SingleObjLoad
		bne.s	@loc_7946
		move.b	#$55,(a1) ; 'U'
		move.b	#$81,$28(a1)
		move.w	#$29D0,x_pos(a1)
		move.w	#$426,y_pos(a1)

	@loc_7946:	
		move.w	#MusID_Boss,d0
		bsr.w	PlaySound
		move.b	#1,($FFFFF7AA).w
		moveq	#PLCID_Boss,d0
		bra.w	LoadPLC
; ---------------------------------------------------------------------------

	@DoNothing:	
		rts
; ---------------------------------------------------------------------------

DynResize_EHZBoss_02:	
		cmpi.w	#$2880,(Camera_X_pos).w
		bcs.s	@DoNothing
		move.w	#$2880,(Camera_Min_X_pos).w
		addq.b	#2,(Dynamic_Resize_Routine).w

	@DoNothing:		
		rts
; ---------------------------------------------------------------------------

DynResize_EHZBoss_03:	
		tst.b	($FFFFF7A7).w
		beq.s	@DoNothing
		move.b	#GameModeID_Logo,(Game_Mode).w
	@DoNothing:		
		rts
; ===========================================================================
DynResize_HPZ:	
		moveq	#0,d0
		move.b	(Current_Act).w,d0
		add.w	d0,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,	DynResize_HPZ1
	GenerateIndex 2,	DynResize_HPZ2
	GenerateIndex 2,	DynResize_HPZ3
	GenerateIndex 2,	DynResize_HPZ1
; ===========================================================================
DynResize_HPZ1:	
		rts
; ---------------------------------------------------------------------------

DynResize_HPZ2:	
		move.w	#$520,(Camera_Max_Y_pos).w
		cmpi.w	#$25A0,(Camera_X_pos).w
		bcs.s	@DoNothing
		move.w	#$420,(Camera_Max_Y_pos).w
		cmpi.w	#$4D0,(MainCharacter+y_pos).w
		bcs.s	@DoNothing
		move.w	#$520,(Camera_Max_Y_pos).w

	@DoNothing:	
		rts
; ---------------------------------------------------------------------------
DynResize_HPZ3:	
		rts
; ---------------------------------------------------------------------------
DynResize_HPZBoss:	
		moveq	#0,d0
		move.b	(Dynamic_Resize_Routine).w,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,	loc_7A30
	GenerateIndex 2,	loc_7A48
	GenerateIndex 2,	loc_7A7A
; ===========================================================================

loc_7A30:	
		cmpi.w	#$2AC0,(Camera_X_pos).w
		bcs.s	@DoNothing
		jsr	SingleObjLoad
		bne.s	@DoNothing
		move.b	#$76,(a1)
		addq.b	#2,(Dynamic_Resize_Routine).w

	@DoNothing:	
		rts
; ---------------------------------------------------------------------------

loc_7A48:	
		cmpi.w	#$2C00,(Camera_X_pos).w
		bcs.s	locret_7A78
		move.w	#$4CC,(Camera_Max_Y_pos).w
		jsr	SingleObjLoad
		bne.s	loc_7A64
		move.b	#$75,(a1) ; 'u'
		addq.b	#2,(Dynamic_Resize_Routine).w

loc_7A64:	
		move.w	#MusID_Boss,d0
		bsr.w	PlaySound
		move.b	#1,($FFFFF7AA).w
		moveq	#PLCID_Boss,d0
		bra.w	LoadPLC
; ---------------------------------------------------------------------------

locret_7A78:	
		rts
; ---------------------------------------------------------------------------

loc_7A7A:	
		move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
		rts
; ===========================================================================
DynResize_HTZ:
		moveq	#0,d0
		move.b	(Current_Act).w,d0
		add.w	d0,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,	DynResize_HTZ1
	GenerateIndex 2,	DynResize_HTZ2
	GenerateIndex 2,	DynResize_HTZ3
	GenerateIndex 2,	DynResize_HTZBoss
; ===========================================================================

DynResize_HTZ1:		
;		move.w	#$1720,(Camera_Max_Y_pos).w
;		cmpi.w	#$1880,(Camera_X_pos).w
;		bcs.s	@DoNothing
;		move.w	#$620,(Camera_Max_Y_pos).w
;		cmpi.w	#$2000,(Camera_X_pos).w
;		bcs.s	@DoNothing
;		move.w	#$2A0,(Camera_Max_Y_pos).w
	@DoNothing:	
		rts
; ---------------------------------------------------------------------------

DynResize_HTZ2:		
		moveq	#0,d0
		move.b	(Dynamic_Resize_Routine).w,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,	loc_7AD2
	GenerateIndex 2,	loc_7AF4
	GenerateIndex 2,	loc_7B12
	GenerateIndex 2,	loc_7B3A
; ===========================================================================

loc_7AD2:	
		move.w	#$800,(Camera_Max_Y_pos).w
		cmpi.w	#$1800,(Camera_X_pos).w
		bcs.s	locret_7AF2
		move.w	#$510,(Camera_Max_Y_pos).w
		cmpi.w	#$1E00,(Camera_X_pos).w
		bcs.s	locret_7AF2
		addq.b	#2,(Dynamic_Resize_Routine).w

locret_7AF2:	
		rts
; ---------------------------------------------------------------------------

loc_7AF4:	
		cmpi.w	#$1EB0,(Camera_X_pos).w
		bcs.s	locret_7B10
		jsr	SingleObjLoad
		bne.s	locret_7B10
		move.b	#$83,(a1)
		addq.b	#2,(Dynamic_Resize_Routine).w
	;	moveq	#PLCID_EndEggman,d0
	;	bra.w	LoadPLC
; ---------------------------------------------------------------------------

locret_7B10:	
		rts
; ---------------------------------------------------------------------------

loc_7B12:	
		cmpi.w	#$1F60,(Camera_X_pos).w
		bcs.s	loc_7B2E
		jsr	SingleObjLoad
		bne.s	loc_7B28
		move.b	#$82,(a1)
		addq.b	#2,(Dynamic_Resize_Routine).w

loc_7B28:	
		move.b	#1,($FFFFF7AA).w

loc_7B2E:	
		bra.s	loc_7B3A
; ---------------------------------------------------------------------------

loc_7B30:	
		cmpi.w	#$2050,(Camera_X_pos).w
		bcs.s	loc_7B3A
		rts
; ---------------------------------------------------------------------------

loc_7B3A:	
		move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
		rts
; ---------------------------------------------------------------------------
DynResize_HTZ3:
		rts
; ---------------------------------------------------------------------------
DynResize_HTZBoss:		
		moveq	#0,d0
		move.b	(Dynamic_Resize_Routine).w,d0
		move.w	@Index(pc,d0.w),d0
		jmp	@Index(pc,d0.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,	loc_7B5A
	GenerateIndex 2,	loc_7B6E
	GenerateIndex 2,	loc_7B8C
	GenerateIndex 2,	locret_7B9A
	GenerateIndex 2,	loc_7B3A
; ===========================================================================

loc_7B5A:	
		cmpi.w	#$2148,(Camera_X_pos).w
		bcs.s	loc_7B6C
		addq.b	#2,(Dynamic_Resize_Routine).w
		;moveq	#PLCID_FinalBoss,d0
		;bsr.w	LoadPLC

loc_7B6C:		
		bra.s	loc_7B3A
; ---------------------------------------------------------------------------

loc_7B6E:	
		cmpi.w	#$2300,(Camera_X_pos).w
		bcs.s	loc_7B8A
		jsr	SingleObjLoad
		bne.s	loc_7B8A
		move.b	#$85,(a1)
		addq.b	#2,(Dynamic_Resize_Routine).w
		move.b	#1,($FFFFF7AA).w

loc_7B8A:	
		bra.s	loc_7B3A
; ---------------------------------------------------------------------------

loc_7B8C:	
		cmpi.w	#$2450,(Camera_X_pos).w
		bcs.s	loc_7B98
		addq.b	#2,(Dynamic_Resize_Routine).w

loc_7B98:	
		bra.s	loc_7B3A
; ---------------------------------------------------------------------------

locret_7B9A:	
		rts
; ===========================================================================

DynResize_CNZ:	
		rts
; ===========================================================================