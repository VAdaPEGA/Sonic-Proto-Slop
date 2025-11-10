TouchResponse:				; a.k.a ReactToItem in S1 disassemblies
		bsr	Touch_Rings
		move.w	x_pos(a0),d2
		move.w	y_pos(a0),d3
		subi.w	#8,d2
		moveq	#0,d5
		move.b	y_radius(a0),d5
		subq.b	#3,d5
		sub.w	d5,d3
		cmpi.b	#SonicAniID_Duck,anim(a0)	; Ducking
		bne.s	@NotDucking
		addi.w	#12,d3
		moveq	#10,d5
	@NotDucking:	
		move.w	#$10,d4
		add.w	d5,d5
		lea	(Level_Object_Space).w,a1
		move.w	#128-32-1,d6	; 

loc_19820:				
		move.b	collision_flags(a1),d0
		bne.s	Touch_Height

Touch_Failed:				
		lea	Object_RAM(a1),a1
		dbf	d6,loc_19820
		moveq	#0,d0
		rts
; ===========================================================================
Touch_Sizes:	;	width 	height	; Badn	Powerup	Hurt	Special
		dc.b	$14,	$14	; $01	$41	$81 	$C1
		dc.b	 $C,	$14	; $02	$42	$82 	$C2
		dc.b	$14,	 $C	; $03	$43	$83 	$C3
		dc.b	  4,	$10	; $04	$44	$84 	$C4
		dc.b	 $C,	$12	; $05	$45	$85 	$C5
		dc.b	$10,	$10	; $06	$46	$86 	$C6
		dc.b	  6,	  6	; $07	$47	$87 	$C7
		dc.b	$18,	 $C	; $08	$48	$88 	$C8
		dc.b	 $C,	$10	; $09	$49	$89 	$C9
		dc.b	$10,	 $C	; $0A	$4A	$8A 	$CA
		dc.b	  8,	  8	; $0B	$4B	$8B 	$CB
		dc.b	$14,	$10	; $0C	$4C	$8C 	$CC
		dc.b	$14,	  8	; $0D	$4D	$8D 	$CD
		dc.b	 $E,	 $E	; $0E	$4E	$8E 	$CE
		dc.b	$18,	$18	; $0F	$4F	$8F 	$CF
		dc.b	$28,	$10	; $10	$50	$90 	$D0
		dc.b	$10,	$18	; $11	$51	$91 	$D1
		dc.b	  8,	$10	; $12	$52	$92 	$D2
		dc.b	$20,	$70	; $13	$53	$93 	$D3
		dc.b	$40,	$20	; $14	$54	$94 	$D4
		dc.b	$80,	$20	; $15	$55	$95 	$D5
		dc.b	$20,	$20	; $16	$56	$96 	$D6
		dc.b	  8,	  8	; $17	$57	$97 	$D7
		dc.b	  4,	  4	; $18	$58	$98 	$D8
		dc.b	$20,	  8	; $19	$59	$99 	$D9
		dc.b	 $C,	 $C	; $1A	$5A	$9A 	$DA
		dc.b	  8,	  4	; $1B	$5B	$9B 	$DB
		dc.b	$18,	  4	; $1C	$5C	$9C 	$DC
		dc.b	$28,	  4	; $1D	$5D	$9D 	$DD
		dc.b	  4,	  8	; $1E	$5E	$9E 	$DE
		dc.b	  4,	$18	; $1F	$5F	$9F 	$DF
		dc.b	  4,	$28	; $20	$60	$A0 	$E0
		dc.b	  4,	$20	; $21	$61	$A1 	$E1
		dc.b	$18,	$18	; $22	$62	$A2 	$E2
		dc.b	 $C,	$18	; $23	$63	$A3 	$E3
		dc.b	$48,	  8	; $24	$64	$A4 	$E4
; ===========================================================================

Touch_Height:	
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	Touch_Sizes-2(pc,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1

	if	(DevHitboxes)
		movem.l	a0-a1,-(sp)
		move.l	a1,a0
		jsr	SingleObjLoad2
		bne.s	@Devfailsafe2
		move.b	#ObjId_DisplayHitbox,(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	x_pos(a1),sub2_x_pos(a1)
		move.w	y_pos(a1),sub2_y_pos(a1)
		move.w	x_pos(a1),sub3_x_pos(a1)
		move.w	y_pos(a1),sub3_y_pos(a1)
		move.w	x_pos(a0),sub4_x_pos(a1)
		move.w	y_pos(a0),sub4_y_pos(a1)
		move.b	(a2),d0
		sub.w	d1,sub2_x_pos(a1)
		sub.w	d0,sub2_y_pos(a1)
		add.w	d1,sub3_x_pos(a1)
		add.w	d0,sub3_y_pos(a1)
		@Devfailsafe2:
		movem.l	(sp)+,a0-a1
	endif	

		move.w	x_pos(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	loc_1989C
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_198A2
		bra.w	Touch_Failed
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1989C:				; CODE XREF: TouchResponse+A8j
		cmp.w	d4,d0
		bhi.w	Touch_Failed

loc_198A2:				; CODE XREF: TouchResponse+AEj
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	y_pos(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	loc_198BA
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_198C0
		bra.w	Touch_Failed
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_198BA:				; CODE XREF: TouchResponse+C6j
		cmp.w	d5,d0
		bhi.w	Touch_Failed

loc_198C0:				; CODE XREF: TouchResponse+CCj
		move.b	collision_flags(a1),d1
		andi.b	#$C0,d1
		beq.w	loc_1993A
		cmpi.b	#$C0,d1
		beq.w	Touch_Special
		tst.b	d1
		bmi.w	loc_199F2
		move.b	collision_flags(a1),d0
		andi.b	#$3F,d0	; '?'
		cmpi.b	#6,d0
		beq.s	loc_198FA
		cmpi.w	#$5A,invulnerable_time(a0) ; 'Z'
		bcc.w	locret_198F8
		move.b	#4,routine(a1)

locret_198F8:				; CODE XREF: TouchResponse+106j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_198FA:				; CODE XREF: TouchResponse+FEj
		tst.w	y_vel(a0)
		bpl.s	loc_19926
		move.w	y_pos(a0),d0
		subi.w	#$10,d0
		cmp.w	y_pos(a1),d0
		bcs.s	locret_19938

loc_1990E:
		neg.w	y_vel(a0)

loc_19912:
		move.w	#$FE80,y_vel(a1)
		tst.b	routine_secondary(a1)
		bne.s	locret_19938
		move.b	#4,routine_secondary(a1)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_19926:				; CODE XREF: TouchResponse+116j
		cmpi.b	#2,anim(a0)
		bne.s	locret_19938
		neg.w	y_vel(a0)
		move.b	#4,routine(a1)

locret_19938:				; CODE XREF: TouchResponse+124j
					; TouchResponse+134j ...
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1993A:				; CODE XREF: TouchResponse+E0j
					; TouchResponse:loc_19B56j
		tst.b	($FFFFFE2D).w
		bne.s	loc_19952
		cmpi.b	#9,anim(a0)
		beq.s	loc_19952
		cmpi.b	#2,anim(a0)
		bne.w	loc_199F2

loc_19952:				; CODE XREF: TouchResponse+156j
					; TouchResponse+15Ej
		tst.b	collision_property(a1)
		beq.s	Touch_KillEnemy
		neg.w	x_vel(a0)
		neg.w	y_vel(a0)
		asr	x_vel(a0)
		asr	y_vel(a0)
		move.b	#0,collision_flags(a1)
		subq.b	#1,collision_property(a1)
		bne.s	locret_1997A
		bset	#7,status(a1)

locret_1997A:				; CODE XREF: TouchResponse+18Aj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Touch_KillEnemy:			; CODE XREF: TouchResponse+16Ej
		bset	#7,status(a1)
		moveq	#0,d0
		move.w	($FFFFF7D0).w,d0
		addq.w	#2,($FFFFF7D0).w
		cmpi.w	#6,d0
		bcs.s	loc_19994
		moveq	#6,d0

loc_19994:				; CODE XREF: TouchResponse+1A8j
		move.w	d0,$3E(a1)
		move.w	Enemy_Points(pc,d0.w),d0
		cmpi.w	#$20,($FFFFF7D0).w ; ' '
		bcs.s	loc_199AE
		move.w	#$3E8,d0
		move.w	#$A,$3E(a1)

loc_199AE:				; CODE XREF: TouchResponse+1BAj
		bsr.w	AddPoints
		move.b	#$27,id(a1) ; '''
		move.b	#0,routine(a1)
		tst.w	y_vel(a0)
		bmi.s	loc_199D4
		move.w	y_pos(a0),d0
		cmp.w	y_pos(a1),d0
		bcc.s	loc_199DC
		neg.w	y_vel(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_199D4:				; CODE XREF: TouchResponse+1DAj
		addi.w	#$100,y_vel(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_199DC:				; CODE XREF: TouchResponse+1E4j
		subi.w	#$100,y_vel(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Enemy_Points:
		dc.w	10,   20,   50,	 100; 0
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_199EC:				; CODE XREF: TouchResponse:Touch_Caterkillerj
		bset	#7,status(a1)

loc_199F2:				; CODE XREF: TouchResponse+EEj
					; TouchResponse+166j ...
		tst.b	($FFFFFE2D).w
		beq.s	Touch_Hurt

loc_199F8:				; CODE XREF: TouchResponse+21Aj
		moveq	#-1,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Touch_Hurt:	
		tst.w	invulnerable_time(a0)
		bne.s	loc_199F8
		movea.l	a1,a2
; End of function TouchResponse


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


HurtSonic:				; CODE XREF: ROM:0000C75Ep
		tst.b	(Partner).w
		bne.s	HurtShield
		tst.w	(Ring_count).w

loc_19A10:
		beq.w	Hurt_NoRings
		jsr	(SingleObjLoad).l
		bne.s	HurtShield
		move.b	#ObjID_Ring,id(a1)
		move.b	#RingID_Spill,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)

HurtShield:	
		move.b	#0,(Partner).w
		move.b	#4,routine(a0)
		bsr.w	j_Sonic_ResetOnFloor
		bset	#1,status(a0)
		move.w	#$FC00,y_vel(a0)
		move.w	#$FE00,x_vel(a0)
		btst	#6,status(a0)
		beq.s	Hurt_Reverse
		move.w	#$FE00,y_vel(a0)
		move.w	#$FF00,x_vel(a0)

Hurt_Reverse:	
		move.w	x_pos(a0),d0
		cmp.w	x_pos(a2),d0
		bcs.s	Hurt_ChkSpikes
		neg.w	x_vel(a0)

Hurt_ChkSpikes:		
		move.w	#0,ground_speed(a0)
		move.b	#$1A,anim(a0)
		move.w	#$78,invulnerable_time(a0)
		move.w	#$A3,d0
		cmpi.b	#$36,(a2)
		bne.s	loc_19A98
		cmpi.b	#$16,(a2)
		bne.s	loc_19A98
		move.w	#$A6,d0	; '¦'

loc_19A98:				; CODE XREF: HurtSonic+86j
					; HurtSonic+8Cj
		jsr	(PlaySound_Special).l
		moveq	#$FFFFFFFF,d0
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Hurt_NoRings:				; CODE XREF: HurtSonic:loc_19A10j
		tst.w	(Debug_mode_flag).w
		bne.w	HurtShield
; End of function HurtSonic


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


KillSonic:				; CODE XREF: sub_F456+268p
					; Sonic_LevelBound:JmpTo_KillSonicj ...
		tst.w	(Debug_placement_mode).w
		bne.s	Kill_NoDeath
		move.b	#0,($FFFFFE2D).w
		move.b	#6,routine(a0)
		bsr.w	j_Sonic_ResetOnFloor
		bset	#1,status(a0)
		move.w	#$F900,y_vel(a0)
		move.w	#0,x_vel(a0)
		move.w	#0,ground_speed(a0)
		move.w	y_pos(a0),$38(a0)
		move.b	#$18,anim(a0)
		bset	#7,art_tile(a0)
		move.w	#$A3,d0	; '£'
		cmpi.b	#$36,(a2) ; '6'
		bne.s	loc_19AF8
		move.w	#$A6,d0	; '¦'

loc_19AF8:				; CODE XREF: KillSonic+48j
		jsr	(PlaySound_Special).l

Kill_NoDeath:				; CODE XREF: KillSonic+4j
		moveq	#$FFFFFFFF,d0
		rts
; End of function KillSonic

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR TouchResponse

Touch_Special:				; CODE XREF: TouchResponse+E8j
		move.b	$20(a1),d1
		andi.b	#$3F,d1	; '?'
		cmpi.b	#$B,d1
		beq.s	Touch_Caterkiller
		cmpi.b	#$C,d1
		beq.s	Touch_Yadrin
		cmpi.b	#$17,d1
		beq.s	Touch_D7
		cmpi.b	#$21,d1	; '!'
		beq.s	Touch_E1
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Touch_Caterkiller:			; CODE XREF: TouchResponse+326j
		bra.w	loc_199EC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Touch_Yadrin:				; CODE XREF: TouchResponse+32Cj
		sub.w	d0,d5
		cmpi.w	#8,d5
		bcc.s	loc_19B56
		move.w	x_pos(a1),d0
		subq.w	#4,d0
		btst	#0,status(a1)
		beq.s	loc_19B42
		subi.w	#$10,d0

loc_19B42:				; CODE XREF: TouchResponse+354j
		sub.w	d2,d0
		bcc.s	loc_19B4E
		addi.w	#$18,d0
		bcs.s	loc_19B52
		bra.s	loc_19B56
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_19B4E:				; CODE XREF: TouchResponse+35Cj
		cmp.w	d4,d0
		bhi.s	loc_19B56

loc_19B52:				; CODE XREF: TouchResponse+362j
		bra.w	loc_199F2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_19B56:				; CODE XREF: TouchResponse+346j
					; TouchResponse+364j ...
		bra.w	loc_1993A
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Touch_D7:				; CODE XREF: TouchResponse+332j
		move.w	a0,d1
		subi.w	#Object_Space,d1
		beq.s	loc_19B66
		addq.b	#1,$21(a1)

loc_19B66:				; CODE XREF: TouchResponse+378j
		addq.b	#1,$21(a1)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Touch_E1:				; CODE XREF: TouchResponse+338j
		addq.b	#1,$21(a1)
		rts

j_Sonic_ResetOnFloor:
		jmp	(Sonic_ResetOnFloor).l


; ---------------------------------------------------------------------------
; Subroutine to handle ring collision
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; sub_D998:
Touch_Rings:
		movea.w	(Ring_start_addr).w,a1
		movea.w	(Ring_end_addr).w,a2
		cmpa.w	#MainCharacter,a0
		beq.s	@Player1
		movea.w	(Ring_start_addr_P2).w,a1
		movea.w	(Ring_end_addr_P2).w,a2

	@Player1:
		cmpa.l	a1,a2
		beq.w	locret_DA36
		cmpi.w	#$5A,invulnerable_time(a0)
		bcc.s	locret_DA36
		move.w	x_pos(a0),d2
		move.w	y_pos(a0),d3
		subi.w	#8,d2
		moveq	#0,d5
		move.b	y_radius(a0),d5
		subq.b	#3,d5
		sub.w	d5,d3

		cmpi.b	#SonicAniID_Duck,anim(a0)	; Check Ducking
		bne.s	loc_D9E0
		addi.w	#$C,d3
		moveq	#$A,d5

loc_D9E0:				; CODE XREF: Touch_Rings+40j
		move.w	#6,d1
		move.w	#$C,d6
		move.w	#$10,d4
		add.w	d5,d5

loc_D9EE:				; CODE XREF: Touch_Rings+9Aj
		tst.w	(a1)
		bne.w	loc_DA2C
		move.w	2(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	loc_DA06
		add.w	d6,d0
		bcs.s	loc_DA0C
		bra.w	loc_DA2C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_DA06:				; CODE XREF: Touch_Rings+64j
		cmp.w	d4,d0
		bhi.w	loc_DA2C

loc_DA0C:				; CODE XREF: Touch_Rings+68j
		move.w	4(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	loc_DA1E
		add.w	d6,d0
		bcs.s	loc_DA24
		bra.w	loc_DA2C
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_DA1E:				; CODE XREF: Touch_Rings+7Cj
		cmp.w	d5,d0
		bhi.w	loc_DA2C

loc_DA24:				; CODE XREF: Touch_Rings+80j
		move.w	#$604,(a1)
		jsr	Collect_Single_Ring

loc_DA2C:				; CODE XREF: Touch_Rings+58j Touch_Rings+6Aj ...
		lea	6(a1),a1
		cmpa.l	a1,a2
		bne.w	loc_D9EE

locret_DA36:				; CODE XREF: Touch_Rings+18j Touch_Rings+22j
		rts
; End of function Touch_Rings