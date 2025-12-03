; Handle Dynamic Water Level Changes
DynamicWaterHeight:
		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		lsl.w	#3,d0	; 8
		move.b	(Current_Act).w,d1
		add.b	d1,d1
		add.b	d1,d0
		move.w	DynWater_Index(pc,d0.w),d0
		jsr	DynWater_Index(pc,d0.w)
		moveq	#1,d1
		move.w	(Water_Level_3).w,d0
		sub.w	(Water_Level_2).w,d0
		beq.s	locret_40C6
		bcc.s	loc_40C2
		neg.w	d1

loc_40C2:	
		add.w	d1,(Water_Level_2).w

locret_40C6:	
		rts
; End of function DynamicWaterHeight

; ===========================================================================
	IndexStart	DynWater_Index	
	; GHZ
	GenerateIndex	 DynWater_NoChanges	; Act 1
	GenerateIndex	 DynWater_NoChanges	; Act 2
	GenerateIndex	 DynWater_NoChanges	; Act 3
	GenerateIndex	 DynWater_NoChanges	; Act Boss

	; CPZ
	GenerateIndex	 DynWater_HPZ1	; Act 1
	GenerateIndex	 DynWater_HPZ2	; Act 2
	GenerateIndex	 DynWater_HPZ3	; Act 3
	GenerateIndex	 DynWater_HPZ4	; Act Boss

	; MMZ
	GenerateIndex	 DynWater_NoChanges	; Act 1
	GenerateIndex	 DynWater_NoChanges	; Act 2
	GenerateIndex	 DynWater_NoChanges	; Act 3
	GenerateIndex	 DynWater_NoChanges	; Act Boss

	; EHZ
	GenerateIndex	 DynWater_NoChanges	; Act 1
	GenerateIndex	 DynWater_NoChanges	; Act 2
	GenerateIndex	 DynWater_NoChanges	; Act 3
	GenerateIndex	 DynWater_NoChanges	; Act Boss

	; HPZ
	GenerateIndex	 DynWater_HPZ1	; Act 1
	GenerateIndex	 DynWater_HPZ2	; Act 2
	GenerateIndex	 DynWater_HPZ3	; Act 3
	GenerateIndex	 DynWater_HPZ4	; Act Boss
; ===========================================================================

DynWater_HPZ1:
		; An interesting function that allows Tails to manipulate
		; the water level using the up/down buttons
		btst	#0,(Ctrl_2_Held).w	; is up being held?
		beq.s	loc_40E2		; if not, branch
		tst.w	(Water_Level_3).w
		beq.s	loc_40E2		; stop increasing water level if we've hit the limit
		subq.w	#1,(Water_Level_3).w	; increase water level

loc_40E2:
		btst	#1,(Ctrl_2_Held).w	; is down being held?
		beq.s	DynWater_NoChanges		; if not, branch
		cmpi.w	#$700,(Water_Level_3).w
		beq.s	DynWater_NoChanges		; stop decreasing water level if we've hit the limit
		addq.w	#1,(Water_Level_3).w	; decrease water level

DynWater_NoChanges:
		rts


S1DynWater_LZ1:				; leftover from	Sonic 1, used to be for HPZ 1
		move.w	(Camera_X_pos).w,d0
		move.w	(Water_routine).w,d2
		bne.s	loc_4164
		move.w	#$B8,d1	; '¸'
		cmpi.w	#$600,d0
		bcs.s	loc_4148
		move.w	#$108,d1
		cmpi.w	#$200,(MainCharacter+y_pos).w
		bcs.s	loc_414E
		cmpi.w	#$C00,d0
		bcs.s	loc_4148
		move.w	#$318,d1
		cmpi.w	#$1080,d0
		bcs.s	loc_4148
		move.b	#$80,($FFFFF7E5).w
		move.w	#$5C8,d1
		cmpi.w	#$1380,d0
		bcs.s	loc_4148
		move.w	#$3A8,d1
		cmp.w	(Water_Level_2).w,d1
		bne.s	loc_4148
		move.w	#1,(Water_routine).w

loc_4148:				; CODE XREF: ROM:0000410Aj
					; ROM:0000411Cj ...
		move.w	d1,(Water_Level_3).w
		rts


loc_414E:				; CODE XREF: ROM:00004116j
		cmpi.w	#$C80,d0
		bcs.s	loc_4148
		move.w	#$E8,d1	; 'è'
		cmpi.w	#$1500,d0
		bcs.s	loc_4148
		move.w	#$108,d1
		bra.s	loc_4148


loc_4164:				; CODE XREF: ROM:00004100j
		subq.b	#1,d2
		bne.s	locret_4188
		cmpi.w	#$2E0,(MainCharacter+y_pos).w
		bcc.s	locret_4188
		move.w	#$3A8,d1
		cmpi.w	#$1300,d0
		bcs.s	loc_4184
		move.w	#$108,d1
		move.w	#2,(Water_routine).w

loc_4184:				; CODE XREF: ROM:00004178j
		move.w	d1,(Water_Level_3).w

locret_4188:				; CODE XREF: ROM:00004166j
					; ROM:0000416Ej
		rts
; ===========================================================================

DynWater_HPZ2:				; DATA XREF: ROM:DynWater_Indexo
		move.w	(Camera_X_pos).w,d0 ; leftover from Sonic 1's LZ2
		move.w	#$328,d1
		cmpi.w	#$500,d0
		bcs.s	loc_41A6
		move.w	#$3C8,d1
		cmpi.w	#$B00,d0
		bcs.s	loc_41A6
		move.w	#$428,d1

loc_41A6:				; CODE XREF: ROM:00004196j
					; ROM:000041A0j
		move.w	d1,(Water_Level_3).w
		rts
; ===========================================================================

DynWater_HPZ3:				; DATA XREF: ROM:DynWater_Indexo
		move.w	(Camera_X_pos).w,d0 ; in fact, this is a leftover from Sonic 1's LZ3
		move.w	(Water_routine).w,d2
		bne.s	loc_41F2
		move.w	#$900,d1
		cmpi.w	#$600,d0
		bcs.s	loc_41E8
		cmpi.w	#$3C0,(MainCharacter+y_pos).w
		bcs.s	loc_41E8
		cmpi.w	#$600,(MainCharacter+y_pos).w
		bcc.s	loc_41E8
		move.w	#$4C8,d1
		move.b	#$4B,(Level_Layout+$206).w ; 'K'
		move.w	#1,(Water_routine).w
		move.w	#$B7,d0	; '·'
		bsr.w	PlaySound_Special

loc_41E8:				; CODE XREF: ROM:000041BEj
					; ROM:000041C6j ...
		move.w	d1,(Water_Level_3).w
		move.w	d1,(Water_Level_2).w
		rts

loc_41F2:				; CODE XREF: ROM:000041B4j
		subq.b	#1,d2
		bne.s	loc_423C
		move.w	#$4C8,d1
		cmpi.w	#$770,d0
		bcs.s	loc_4236
		move.w	#$308,d1
		cmpi.w	#$1400,d0
		bcs.s	loc_4236
		cmpi.w	#$508,(Water_Level_3).w
		beq.s	loc_4222
		cmpi.w	#$600,(MainCharacter+y_pos).w
		bcc.s	loc_4222
		cmpi.w	#$280,(MainCharacter+y_pos).w
		bcc.s	loc_4236

loc_4222:				; CODE XREF: ROM:00004210j
					; ROM:00004218j
		move.w	#$508,d1
		move.w	d1,(Water_Level_2).w
		cmpi.w	#$1770,d0
		bcs.s	loc_4236
		move.w	#2,(Water_routine).w

loc_4236:				; CODE XREF: ROM:000041FEj
					; ROM:00004208j ...
		move.w	d1,(Water_Level_3).w
		rts

loc_423C:				; CODE XREF: ROM:000041F4j
		subq.b	#1,d2
		bne.s	loc_4266
		move.w	#$508,d1
		cmpi.w	#$1860,d0
		bcs.s	loc_4260
		move.w	#$188,d1
		cmpi.w	#$1AF0,d0
		bcc.s	loc_425A
		cmp.w	(Water_Level_2).w,d1
		bne.s	loc_4260

loc_425A:				; CODE XREF: ROM:00004252j
		move.w	#3,(Water_routine).w

loc_4260:				; CODE XREF: ROM:00004248j
					; ROM:00004258j
		move.w	d1,(Water_Level_3).w
		rts

loc_4266:				; CODE XREF: ROM:0000423Ej
		subq.b	#1,d2
		bne.s	loc_42A2
		move.w	#$188,d1
		cmpi.w	#$1AF0,d0
		bcs.s	loc_4298
		move.w	#$900,d1
		cmpi.w	#$1BC0,d0
		bcs.s	loc_4298
		move.w	#4,(Water_routine).w
		move.w	#$608,(Water_Level_3).w
		move.w	#$7C0,(Water_Level_2).w
		move.b	#1,($FFFFF7E8).w
		rts

loc_4298:				; CODE XREF: ROM:00004272j
					; ROM:0000427Cj
		move.w	d1,(Water_Level_3).w
		move.w	d1,(Water_Level_2).w
		rts

loc_42A2:				; CODE XREF: ROM:00004268j
		cmpi.w	#$1E00,d0
		bcs.s	locret_42AE
		move.w	#$128,(Water_Level_3).w

locret_42AE:				; CODE XREF: ROM:000042A6j
		rts
; ===========================================================================

DynWater_HPZ4:				; DATA XREF: ROM:DynWater_Indexo
		move.w	#$228,d1	; in fact, this	is a leftover from Sonic 1's SBZ3
		cmpi.w	#$F00,(Camera_X_pos).w
		bcs.s	loc_42C0
		move.w	#$4C8,d1

loc_42C0:				; CODE XREF: ROM:000042BAj
		move.w	d1,(Water_Level_3).w
		rts
; ===========================================================================