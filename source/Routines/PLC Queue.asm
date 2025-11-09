; ---------------------------------------------------------------------------
; Subroutine to load pattern load cues (aka to queue pattern load requests)
; ---------------------------------------------------------------------------

; ARGUMENTS
; d0 = index of PLC list (see ArtLoadCues)

; NOTICE: This subroutine does not check for buffer overruns. The programmer
;	  (or hacker) is responsible for making sure that no more than
;	  16 load requests are copied into the buffer.
;    _________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;         (or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/6)

; PLCLoad:
LoadPLC:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		lea	(Plc_Buffer).w,a2

loc_1688:
		tst.l	(a2)
		beq.s	loc_1690
		addq.w	#6,a2
		bra.s	loc_1688
; ---------------------------------------------------------------------------

loc_1690:
		move.w	(a1)+,d0
		bmi.s	loc_169C

loc_1694:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		dbf	d0,loc_1694

loc_169C:
		movem.l	(sp)+,a1-a2
		rts
; End of function LoadPLC


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Queue pattern load requests, but clear the PLQ first

; ARGUMENTS
; d0 = index of PLC list (see ArtLoadCues)

; NOTICE: This subroutine does not check for buffer overruns. The programmer
;	  (or hacker) is responsible for making sure that no more than
;	  16 load requests are copied into the buffer.
;	  _________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;         (or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/6)

LoadPLC2:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		bsr.s	ClearPLC
		lea	(Plc_Buffer).w,a2
		move.w	(a1)+,d0
		bmi.s	loc_16C8

loc_16C0:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		dbf	d0,loc_16C0

loc_16C8:
		movem.l	(sp)+,a1-a2
		rts
; End of function LoadPLC2


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Clear the pattern load queue ($FFF680 - $FFF700)

ClearPLC:
		lea	(Plc_Buffer).w,a2
		moveq	#$1F,d0

loc_16D4:
		clr.l	(a2)+
		dbf	d0,loc_16D4
		rts
; End of function ClearPLC


; ---------------------------------------------------------------------------
; Subroutine to use graphics listed in a pattern load cue
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; RunPLC:
RunPLC_RAM:
		tst.l	(Plc_Buffer).w
		beq.s	locret_1730
		tst.w	(Plc_Buffer_Reg18).w
		bne.s	locret_1730
		movea.l	(Plc_Buffer).w,a0
		lea	NemDec_WriteAndStay(pc),a3
		nop
		lea	(Decomp_Buffer).w,a1
		move.w	(a0)+,d2
		bpl.s	loc_16FE
		adda.w	#$A,a3

loc_16FE:
		andi.w	#$7FFF,d2
		move.w	d2,(Plc_Buffer_Reg18).w
		bsr.w	NemDecPrepare
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6
		moveq	#0,d0
		move.l	a0,(Plc_Buffer).w
		move.l	a3,(Plc_Buffer_Reg0).w
		move.l	d0,(Plc_Buffer_Reg4).w
		move.l	d0,(Plc_Buffer_Reg8).w
		move.l	d0,(Plc_Buffer_RegC).w
		move.l	d5,(Plc_Buffer_Reg10).w
		move.l	d6,(Plc_Buffer_Reg14).w

locret_1730:
		rts
; End of function RunPLC_RAM


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Process one PLC from the queue

; sub_1732:
ProcessPLC:
		tst.w	(Plc_Buffer_Reg18).w
		beq.w	locret_17CA
		move.w	#9,(Plc_Buffer_Reg1A).w
		moveq	#0,d0
		move.w	(Plc_Buffer+4).w,d0
		addi.w	#$120,(Plc_Buffer+4).w
		bra.s	ProcessPLC_Main

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Process one PLC from the queue

; loc_174E:
ProcessPLC2:
		tst.w	(Plc_Buffer_Reg18).w
		beq.s	locret_17CA
		move.w	#3,(Plc_Buffer_Reg1A).w
		moveq	#0,d0
		move.w	(Plc_Buffer+4).w,d0
		addi.w	#$60,(Plc_Buffer+4).w
; loc_1766:
ProcessPLC_Main:
		lea	(VDP_control_port).l,a4
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(a4)
		subq.w	#4,a4
		movea.l	(Plc_Buffer).w,a0
		movea.l	(Plc_Buffer_Reg0).w,a3
		move.l	(Plc_Buffer_Reg4).w,d0
		move.l	(Plc_Buffer_Reg8).w,d1
		move.l	(Plc_Buffer_RegC).w,d2
		move.l	(Plc_Buffer_Reg10).w,d5
		move.l	(Plc_Buffer_Reg14).w,d6
		lea	(Decomp_Buffer).w,a1

loc_179A:
		movea.w	#8,a5
		bsr.w	NemDec_WriteIter
		subq.w	#1,(Plc_Buffer_Reg18).w
		beq.s	ProcessPLC_Pop
		subq.w	#1,(Plc_Buffer_Reg1A).w
		bne.s	loc_179A
		move.l	a0,(Plc_Buffer).w
		move.l	a3,(Plc_Buffer_Reg0).w
		move.l	d0,(Plc_Buffer_Reg4).w
		move.l	d1,(Plc_Buffer_Reg8).w
		move.l	d2,(Plc_Buffer_RegC).w
		move.l	d5,(Plc_Buffer_Reg10).w
		move.l	d6,(Plc_Buffer_Reg14).w

locret_17CA:
		rts
; ===========================================================================
; pop one request off the buffer so that the next one can be filled
; loc_17CC:
ProcessPLC_Pop:
		lea	(Plc_Buffer).w,a0
		moveq	#$15,d0

loc_17D2:
		move.l	6(a0),(a0)+
		dbf	d0,loc_17D2
		rts
; End of function ProcessPLC


; ---------------------------------------------------------------------------
; Subroutine to execute a pattern load cue directly from the ROM
; rather than loading them into the queue first
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


RunPLC_ROM:
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		move.w	(a1)+,d1

loc_17EE:
		movea.l	(a1)+,a0
		moveq	#0,d0
		move.w	(a1)+,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(VDP_control_port).l
		bsr.w	NemDec
		dbf	d1,loc_17EE
		rts
; End of function RunPLC_ROM
