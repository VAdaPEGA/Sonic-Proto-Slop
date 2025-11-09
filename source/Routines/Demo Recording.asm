MoveSonicInDemo:
	if	(RecordDemoMode)	; unused subroutine for	recording demos
		lea	($FE8000).l,a1
loc_4474:
		move.w	($FFFFF790).w,d0
		adda.w	d0,a1
		move.b	(Ctrl_1).w,d0
		cmp.b	(a1),d0
		bne.s	loc_4490
		addq.b	#1,1(a1)
		cmpi.b	#$FF,1(a1)
		beq.s	loc_4490
		bra.s	loc_44A4
; ===========================================================================

loc_4490:				; CODE XREF: MoveSonicInDemo+1Aj
					; MoveSonicInDemo+26j
		move.b	d0,2(a1)
		move.b	#0,3(a1)
		addq.w	#2,($FFFFF790).w
		andi.w	#$3FF,($FFFFF790).w

loc_44A4:				; CODE XREF: MoveSonicInDemo+28j
		cmpi.b	#3,(Current_Zone).w
		bne.s	locret_44E2
		lea	($FEC000).l,a1
		move.w	($FFFFF740).w,d0
		adda.w	d0,a1
		move.b	(Ctrl_2).w,d0
		cmp.b	(a1),d0
		bne.s	loc_44CE
		addq.b	#1,1(a1)
		cmpi.b	#$FF,1(a1)
		beq.s	loc_44CE
		bra.s	locret_44E2
; ===========================================================================

loc_44CE:				; CODE XREF: MoveSonicInDemo+58j
					; MoveSonicInDemo+64j
		move.b	d0,2(a1)
		move.b	#0,3(a1)
		addq.w	#2,($FFFFF740).w
		andi.w	#$3FF,($FFFFF740).w

locret_44E2:	
		rts
; ===========================================================================
	else
		tst.w	(Demo_Mode_Flag).w
		beq.s	locret_4570
		tst.b	($FFFFF604).w
		bpl.s	loc_44F6
		tst.w	(Demo_Mode_Flag).w
		bmi.s	loc_44F6
		move.b	#GameModeID_TitleScreen,(Game_Mode).w

loc_44F6:
		lea	(Demo_Index).l,a1
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w
		bne.s	loc_450C
		moveq	#6,d0

loc_450C:	
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.w	($FFFFF790).w,d0
		adda.w	d0,a1
		move.b	(a1),d0
		lea	($FFFFF604).w,a0
		move.b	d0,d1
		moveq	#0,d2
		eor.b	d2,d0
		move.b	d1,(a0)+
		and.b	d1,d0
		move.b	d0,(a0)+
		subq.b	#1,($FFFFF792).w
		bcc.s	loc_453A
		move.b	3(a1),($FFFFF792).w
		addq.w	#2,($FFFFF790).w

loc_453A:	
		cmpi.b	#3,(Current_Zone).w
		bne.s	loc_4572
		lea	(Demo_2P).l,a1
		move.w	($FFFFF740).w,d0
		adda.w	d0,a1
		move.b	(a1),d0
		lea	(Ctrl_2_Held).w,a0
		move.b	d0,d1
		moveq	#0,d2
		eor.b	d2,d0
		move.b	d1,(a0)+
		and.b	d1,d0
		move.b	d0,(a0)+
		subq.b	#1,($FFFFF742).w
		bcc.s	locret_4570
		move.b	3(a1),($FFFFF742).w
		addq.w	#2,($FFFFF740).w

locret_4570:	
		rts
; ===========================================================================
loc_4572:	
		move.w	#0,(Ctrl_2_Held).w
		rts
; End of function MoveSonicInDemo
	endif
; ===========================================================================
Demo_Index:	dc.l Demo_S1GHZ
		dc.l Demo_S1GHZ
		dc.l Demo_CPZ
		dc.l Demo_EHZ
		dc.l Demo_HPZ
		dc.l Demo_HTZ
		dc.l Demo_S1SS
		dc.l Demo_S1SS
		dc.l $FE8000
		dc.l $FE8000
		dc.l $FE8000
		dc.l $FE8000
		dc.l $FE8000
		dc.l $FE8000
		dc.l $FE8000
		dc.l $FE8000
		dc.l $FE8000
; the actual ending demo index has been removed, so it instead points to
; the unused Sonic 1 TTS demo inputs
Demo_S1EndIndex:dc.l $008B0837
		dc.l $0042085C
		dc.l $006A085F
		dc.l $002F082C
		dc.l $00210803
		dc.l $28300808
		dc.l $002E0815
		dc.l $000F0846
		dc.l $001A08FF
		dc.l $08CA0000
		dc.l 0
		dc.l 0

