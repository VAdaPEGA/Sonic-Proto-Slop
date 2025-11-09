; ===========================================================================
; ---------------------------------------------------------------------------
; Solid object subroutines (includes spikes, blocks, rocks etc)
; These check collision of Sonic/Tails with objects on the screen
;
; input variables:
; d1 = object width
; d2 = object height / 2 (when jumping)
; d3 = object height / 2 (when walking)
; d4 = object x-axis position
;
; address registers:
; a0 = the object to check collision with
; a1 = sonic or tails (set inside these subroutines)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


SolidObject:
		lea	(MainCharacter).w,a1	; a1=character
		moveq	#3,d6
		movem.l	d1-d4,-(sp)	; store input registers
		bsr.s	sub_F456	; first collision check with Sonic
		movem.l	(sp)+,d1-d4	; restore input registers
		lea	(Sidekick).w,a1	; a1=character ; now check collision with Tails
		tst.b	render_flags(a1)
		bpl.w	locret_F490	; return if not Tails
		addq.b	#1,d6

sub_F456:
		btst	d6,status(a0)
		beq.w	SolidObject_OnScreenTest
		move.w	d1,d2
		add.w	d2,d2
		btst	#1,status(a1)
		bne.s	loc_F47A
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_F47A
		cmp.w	d2,d0
		bcs.s	loc_F488

loc_F47A:
		bclr	#3,status(a1)
		bclr	d6,status(a0)
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------
loc_F488:
		move.w	d4,d2
		bsr.w	MvSonicOnPtfm
		moveq	#0,d4

locret_F490:
		rts
; End of function SolidObject

; ===========================================================================
; alternate function to check for collision even if off-screen, unused
; in this build...
; SolidObject_Always:
		lea	(MainCharacter).w,a1	; a1=character
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.s	SolidObject_Always_SingleCharacter
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1	; a1=character
		addq.b	#1,d6
; loc_F4A8:
SolidObject_Always_SingleCharacter:
		btst	d6,status(a0)
		beq.w	SolidObject_cont
		move.w	d1,d2
		add.w	d2,d2
		btst	#1,status(a1)
		bne.s	loc_F4CC
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_F4CC
		cmp.w	d2,d0
		bcs.s	loc_F4DA

loc_F4CC:
		bclr	#3,status(a1)
		bclr	d6,status(a0)
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_F4DA:
		move.w	d4,d2
		bsr.w	MvSonicOnPtfm
		moveq	#0,d4
		rts
; End of function SolidObject_Always

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to collide Sonic/Tails with the top of a sloped
; solid like diagonal springs; unused in this build...
;
; input variables:
; d1 = object width
; d2 = object height / 2 (when jumping)
; d3 = object height / 2 (when walking)
; d4 = object x-axis position
;
; address registers:
; a0 = the object to check collision with
; a1 = sonic or tails (set inside these subroutines)
; a2 = height data for slope
; ---------------------------------------------------------------------------
		lea	(MainCharacter).w,a1	; a1=character
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.s	SlopedSolid_SingleCharacter
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1	; a1=character
		addq.b	#1,d6
; loc_F4FA:
SlopedSolid_SingleCharacter:
		btst	d6,status(a0)
		beq.w	SlopedSolid_cont
		move.w	d1,d2
		add.w	d2,d2
		btst	#1,status(a1)
		bne.s	loc_F51E
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_F51E
		cmp.w	d2,d0
		bcs.s	loc_F52C

loc_F51E:
		bclr	#3,status(a1)
		bclr	d6,status(a0)
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_F52C:
		move.w	d4,d2
		bsr.w	sub_F748
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------
; loc_F536:
SlopedSolid_cont:
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.w	SolidObject_TestClearPush
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.w	SolidObject_TestClearPush
		move.w	d0,d5
		btst	#0,render_flags(a0)
		beq.s	loc_F55C
		not.w	d5
		add.w	d3,d5

loc_F55C:
		lsr.w	#1,d5
		move.b	(a2,d5.w),d3
		sub.b	(a2),d3
		ext.w	d3
		move.w	y_pos(a0),d5
		sub.w	d3,d5
		move.b	y_radius(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	y_pos(a1),d3
		sub.w	d5,d3
		addq.w	#4,d3
		add.w	d2,d3
		bmi.w	SolidObject_TestClearPush
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.w	SolidObject_TestClearPush
		bra.w	SolidObject_ChkBounds
; ===========================================================================
; loc_F590:
SolidObject_OnScreenTest:
		tst.b	render_flags(a0)
		bpl.w	SolidObject_TestClearPush
; loc_F598:
SolidObject_cont:
		; We now perform the x portion of a bounding box check.  To do this, we assume a
		; coordinate system where the x origin is at the object's left edge.
		move.w	x_pos(a1),d0	; load Sonic's x position...
		sub.w	x_pos(a0),d0	; ... and calculate his x position relative to the object
		add.w	d1,d0		; assume object's left edge is at (0,0).  This is also Sonic's distance to the object's left edge.
		bmi.w	SolidObject_TestClearPush	; branch, if Sonic is outside the object's left edge
		move.w	d1,d3
		add.w	d3,d3		; calculate object's width
		cmp.w	d3,d0
		bhi.w	SolidObject_TestClearPush	; branch, if Sonic is outside the object's right edge
		; We now perform the y portion of a bounding box check.  To do this, we assume a
		; coordinate system where the y origin is at the highest y position relative to the object
		; at which Sonic would still collide with it.  This point is
		;   y_pos(object) - width(object)/2 - y_radius(Sonic) - 4,
		; where object is stored in (a0), Sonic in (a1), and height(object)/2 in d2.  This way
		; of doing it causes the object's hitbox to be vertically off-center by -4 pixels.
		move.b	y_radius(a1),d3	; load Sonic's y radius
		ext.w	d3
		add.w	d3,d2		; calculate maximum distance for a top collision
		move.w	y_pos(a1),d3	; load Sonic's y position
		sub.w	y_pos(a0),d3	; ... and calculate his y position relative to the object
		addq.w	#4,d3		; assume a slightly lower position for Sonic
		add.w	d2,d3		; assume the highest position where Sonic would still be colliding with the object to be (0,0)
		bmi.w	SolidObject_TestClearPush	; branch, if Sonic is above this point
		move.w	d2,d4
		add.w	d4,d4		; calculate minimum distance for a bottom collision
		cmp.w	d4,d3
		bcc.w	SolidObject_TestClearPush	; branch, if Sonic is below this point
; loc_F5D2:
SolidObject_ChkBounds:
		tst.b	obj_control(a1)
		bmi.w	SolidObject_TestClearPush	; branch, if object collisions are disabled for Sonic
		cmpi.b	#6,routine(a1)			; is Sonic dead?
		bcc.w	loc_F680			; if yes, branch
		tst.w	(Debug_placement_mode).w
		bne.w	loc_F680			; branch, if in Debug Mode

		move.w	d0,d5
		cmp.w	d0,d1
		bcc.s	loc_F5FA	; branch, if Sonic is to the object's left
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5		; calculate Sonic's distance to the object's right edge...
		neg.w	d5		; ... and calculate the absolute value

loc_F5FA:
		move.w	d3,d1
		cmp.w	d3,d2
		bcc.s	loc_F608
		subq.w	#4,d3
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

loc_F608:
		cmp.w	d1,d5
		bhi.w	loc_F684	; branch, if horizontal distance is greater than vertical distance

		cmpi.w	#4,d1
		bls.s	loc_F65A
		tst.w	d0
		beq.s	loc_F634
		bmi.s	loc_F622
		tst.w	x_vel(a1)
		bmi.s	loc_F634
		bra.s	loc_F628
; ===========================================================================

loc_F622:
		tst.w	x_vel(a1)
		bpl.s	loc_F634

loc_F628:
		move.w	#0,ground_speed(a1)
		move.w	#0,x_vel(a1)

loc_F634:
		sub.w	d0,x_pos(a1)
		btst	#1,status(a1)
		bne.s	loc_F65A
		move.l	d6,d4
		addq.b	#2,d4	; Character is pushing, not standing
		bset	d4,status(a0)
		bset	#5,status(a1)
		move.w	d6,d4
		addi.b	#$D,d4
		bset	d4,d6	; This sets bits 0 (Sonic) or 1 (Tails) of high word of d6
		moveq	#1,d4
		rts
; ===========================================================================

loc_F65A:
		bsr.s	sub_F678
		move.w	d6,d4
		addi.b	#$D,d4
		bset	d4,d6	; This sets bits 0 (Sonic) or 1 (Tails) of high word of d6
		moveq	#1,d4
		rts
; ===========================================================================
; loc_F668:
SolidObject_TestClearPush:
		move.l	d6,d4
		addq.b	#2,d4
		btst	d4,status(a0)
		beq.s	loc_F680
		move.w	#1,anim(a1)

sub_F678:
		move.l	d6,d4
		addq.b	#2,d4
		bclr	d4,status(a0)

loc_F680:
		moveq	#0,d4
		rts
; ===========================================================================

loc_F684:
		tst.w	d3
		bmi.s	loc_F690
		cmpi.w	#$10,d3
		bcs.s	loc_F6D2
		bra.s	SolidObject_TestClearPush
; ===========================================================================

loc_F690:
		tst.w	y_vel(a1)
		beq.s	loc_F6B2
		bpl.s	loc_F6A6
		tst.w	d3
		bpl.s	loc_F6A6
		sub.w	d3,y_pos(a1)
		move.w	#0,y_vel(a1)

loc_F6A6:
		move.w	d6,d4
		addi.b	#$F,d4
		bset	d4,d6	; This sets bits 2 (Sonic) or 3 (Tails) of high word of d6
		moveq	#-2,d4
		rts
; ===========================================================================

loc_F6B2:
		btst	#1,status(a1)
		bne.s	loc_F6A6
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(KillSonic).l
		movea.l	(sp)+,a0	; load obj address
		move.w	d6,d4
		addi.b	#$F,d4
		bset	d4,d6	; This sets bits 2 (Sonic) or 3 (Tails) of high word of d6
		moveq	#-2,d4
		rts
; ===========================================================================

loc_F6D2:
		subq.w	#4,d3
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	x_pos(a1),d1
		sub.w	x_pos(a0),d1
		bmi.s	loc_F70A
		cmp.w	d2,d1
		bcc.s	loc_F70A
		tst.w	y_vel(a1)
		bmi.s	loc_F70A
		sub.w	d3,y_pos(a1)
		subq.w	#1,y_pos(a1)
		bsr.w	RideObject_SetRide
		move.w	d6,d4
		addi.b	#$11,d4
		bset	d4,d6	; This sets bits 4 (Sonic) or 5 (Tails) of high word of d6
		moveq	#-1,d4
		rts
; ===========================================================================

loc_F70A:
		moveq	#0,d4
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to change Sonic's position with a platform
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_F70E:
MvSonicOnPtfm:
		move.w	y_pos(a0),d0
		sub.w	d3,d0
		bra.s	loc_F71E
; ===========================================================================
		; a couple lines of unused/leftover/dead code from Sonic 1 ; a0=object
		move.w	y_pos(a0),d0
		subi.w	#9,d0

loc_F71E:
		tst.b	obj_control(a1)
		bmi.s	locret_F746
		cmpi.b	#6,routine(a1)
		bcc.s	locret_F746
		tst.w	(Debug_placement_mode).w
		bne.s	locret_F746
		moveq	#0,d1
		move.b	y_radius(a1),d1
		sub.w	d1,d0
		move.w	d0,y_pos(a1)
		sub.w	x_pos(a0),d2
		sub.w	d2,x_pos(a1)

locret_F746:
		rts
; End of function MvSonicOnPtfm


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_F748:				; CODE XREF: sub_F456+D8p sub_F7F2+34p
		btst	#3,status(a1)
		beq.s	locret_F788
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		lsr.w	#1,d0
		btst	#0,render_flags(a0)
		beq.s	loc_F768
		not.w	d0
		add.w	d1,d0

loc_F768:				; CODE XREF: sub_F748+1Aj
		move.b	(a2,d0.w),d1
		ext.w	d1
		move.w	y_pos(a0),d0
		sub.w	d1,d0
		moveq	#0,d1
		move.b	y_radius(a1),d1
		sub.w	d1,d0
		move.w	d0,y_pos(a1)
		sub.w	x_pos(a0),d2
		sub.w	d2,x_pos(a1)

locret_F788:				; CODE XREF: sub_F748+6j
		rts
; End of function sub_F748


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_F78A:				; CODE XREF: ROM:000088DAp sub_8DD6+Cp ...
		lea	(MainCharacter).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.s	sub_F7A0
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1
		addq.b	#1,d6
; End of function sub_F78A


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_F7A0:				; CODE XREF: sub_F78A+Ap
		btst	d6,status(a0)
		beq.w	loc_F89E
		move.w	d1,d2
		add.w	d2,d2
		btst	#1,status(a1)
		bne.s	loc_F7C4
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_F7C4
		cmp.w	d2,d0
		bcs.s	loc_F7D2

loc_F7C4:				; CODE XREF: sub_F7A0+12j sub_F7A0+1Ej
		bclr	#3,status(a1)
		bclr	d6,status(a0)
		moveq	#0,d4
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_F7D2:				; CODE XREF: sub_F7A0+22j
		move.w	d4,d2
		bsr.w	MvSonicOnPtfm
		moveq	#0,d4
		rts
; End of function sub_F7A0


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_F7DC:				; CODE XREF: sub_8CEC+Ep ROM:00014DEEj
		lea	(MainCharacter).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.s	sub_F7F2
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1
		addq.b	#1,d6
; End of function sub_F7DC


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_F7F2:				; CODE XREF: sub_F7DC+Ap

; FUNCTION CHUNK AT 0000F968 SIZE 00000038 BYTES

		btst	d6,status(a0)
		beq.w	SlopedPlatform_cont
		move.w	d1,d2
		add.w	d2,d2
		btst	#1,status(a1)
		bne.s	loc_F816
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_F816
		cmp.w	d2,d0
		bcs.s	loc_F824

loc_F816:				; CODE XREF: sub_F7F2+12j sub_F7F2+1Ej
		bclr	#3,status(a1)
		bclr	d6,status(a0)
		moveq	#0,d4
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_F824:				; CODE XREF: sub_F7F2+22j
		move.w	d4,d2
		bsr.w	sub_F748
		moveq	#0,d4
		rts
; End of function sub_F7F2


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_F82E:				; CODE XREF: ROM:000083C2p
		lea	(MainCharacter).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		bsr.s	sub_F844
		movem.l	(sp)+,d1-d4
		lea	(Sidekick).w,a1
		addq.b	#1,d6
; End of function sub_F82E


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_F844:				; CODE XREF: sub_F82E+Ap

; FUNCTION CHUNK AT 0000F9A0 SIZE 00000028 BYTES

		btst	d6,status(a0)
		beq.w	loc_F9A0
		move.w	d1,d2
		add.w	d2,d2
		btst	#1,status(a1)
		bne.s	loc_F868
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_F868
		cmp.w	d2,d0
		bcs.s	loc_F876

loc_F868:				; CODE XREF: sub_F844+12j sub_F844+1Ej
		bclr	#3,status(a1)
		bclr	d6,status(a0)
		moveq	#0,d4
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_F876:				; CODE XREF: sub_F844+22j
		move.w	d4,d2
		bsr.w	MvSonicOnPtfm
		moveq	#0,d4
		rts
; End of function sub_F844


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_F880:				; CODE XREF: sub_7DDA+66p
		tst.w	y_vel(a1)
		bmi.w	locret_F966
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.w	locret_F966
		cmp.w	d2,d0
		bcc.w	locret_F966
		bra.s	loc_F8BC
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_F89E:				; CODE XREF: sub_F7A0+4j
		tst.w	y_vel(a1)
		bmi.w	locret_F966
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.w	locret_F966
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.w	locret_F966

loc_F8BC:				; CODE XREF: sub_F880+1Cj
		move.w	y_pos(a0),d0
		sub.w	d3,d0

loc_F8C2:				; CODE XREF: sub_F7F2+1AAj
					; sub_F844+180j
		move.w	y_pos(a1),d2
		move.b	y_radius(a1),d1
		ext.w	d1
		add.w	d2,d1
		addq.w	#4,d1
		sub.w	d1,d0
		bhi.w	locret_F966
		cmpi.w	#$FFF0,d0
		bcs.w	locret_F966
		tst.b	obj_control(a1)
		bmi.w	locret_F966
		cmpi.b	#6,routine(a1)
		bcc.w	locret_F966
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,y_pos(a1)
; sub_F8F8:
RideObject_SetRide:
		btst	#StatusBitP1Stand,status(a1)
		beq.s	loc_F916
		moveq	#0,d0
		move.b	interact(a1),d0
		lsl.w	#6,d0
		addi.l	#Object_Space,d0
		movea.l	d0,a3
		bclr	#StatusBitP1Stand,status(a3)

loc_F916:
		move.w	a0,d0
		subi.w	#Object_Space,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0
		move.b	d0,interact(a1)
		move.b	#0,angle(a1)
		move.w	#0,y_vel(a1)
		move.w	x_vel(a1),ground_speed(a1)
		btst	#PlayerStatusBitAir,status(a1)
		beq.s	loc_F95C
		move.l	a0,-(sp)
		movea.l	a1,a0
		move.w	a0,d1
		subi.w	#Object_Space,d1
		bne.s	loc_F954
		jsr	(Sonic_ResetOnFloor).l
		;bra.s	loc_F95A
; ===========================================================================

loc_F954:
		;jsr	(Tails_ResetTailsOnFloor).l

loc_F95A:
		movea.l	(sp)+,a0

loc_F95C:
		bset	#PlayerStatusBitOnObject,status(a1)
		bset	d6,status(a0)

locret_F966:
		rts
; ===========================================================================
; loc_F968:
SlopedPlatform_cont:
		tst.w	y_vel(a1)
		bmi.w	locret_F966
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	locret_F966
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.s	locret_F966
		btst	#0,render_flags(a0)
		beq.s	loc_F98E
		not.w	d0
		add.w	d1,d0

loc_F98E:
		lsr.w	#1,d0
		move.b	(a2,d0.w),d3
		ext.w	d3
		move.w	y_pos(a0),d0
		sub.w	d3,d0
		bra.w	loc_F8C2
; END OF FUNCTION CHUNK	FOR sub_F7F2
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR sub_F844

loc_F9A0:				; CODE XREF: sub_F844+4j
		tst.w	y_vel(a1)
		bmi.w	locret_F966
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.w	locret_F966
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.w	locret_F966
		move.w	y_pos(a0),d0
		sub.w	d3,d0
		bra.w	loc_F8C2
; END OF FUNCTION CHUNK	FOR sub_F844

; ===========================================================================
; This routine is only used by the monitor object
; d1 : Object width / 2
MonitorPlatformTopCheckPlayer:	; giving it the least intuitive name in the world
		move.w	d1,d2
		add.w	d2,d2
		lea	(MainCharacter).w,a1	; Only checks for one player
		btst	#PlayerStatusBitAir,status(a1)
		bne.s	@GetOffObject
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	@GetOffObject
		cmp.w	d2,d0
		bcs.s	@DoNothing
	@GetOffObject:
		bclr	#PlayerStatusBitOnObject,status(a1)
		move.b	#2,routine(a0)
		bclr	#StatusBitP1Stand,status(a0)
	@DoNothing:
		rts
; ===========================================================================
; Sonic_AnglePos:
AnglePos:
		move.l	#Primary_Collision,(Collision_addr).w
		cmpi.b	#$C,top_solid_bit(a0)
		beq.s	loc_12A14
		move.l	#Secondary_Collision,(Collision_addr).w

loc_12A14:				; CODE XREF: AnglePos+Ej
		move.b	top_solid_bit(a0),d5
		btst	#3,status(a0)
		beq.s	loc_12A2C
		moveq	#0,d0
		move.b	d0,($FFFFF768).w
		move.b	d0,($FFFFF76A).w
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12A2C:				; CODE XREF: AnglePos+22j
		moveq	#3,d0
		move.b	d0,($FFFFF768).w
		move.b	d0,($FFFFF76A).w
		move.b	angle(a0),d0
		addi.b	#$20,d0	; ' '
		bpl.s	loc_12A4E
		move.b	angle(a0),d0
		bpl.s	loc_12A48
		subq.b	#1,d0

loc_12A48:				; CODE XREF: AnglePos+48j
		addi.b	#$20,d0	; ' '
		bra.s	loc_12A5A
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12A4E:				; CODE XREF: AnglePos+42j
		move.b	angle(a0),d0
		bpl.s	loc_12A56
		addq.b	#1,d0

loc_12A56:				; CODE XREF: AnglePos+56j
		addi.b	#$1F,d0

loc_12A5A:				; CODE XREF: AnglePos+50j
		andi.b	#$C0,d0
		cmpi.b	#$40,d0	; '@'
		beq.w	Sonic_WalkVertL
		cmpi.b	#$80,d0
		beq.w	Sonic_WalkCeiling
		cmpi.b	#$C0,d0
		beq.w	Sonic_WalkVertR
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	y_radius(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	x_radius(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	y_radius(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	x_radius(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d3
		lea	($FFFFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_12AE4
		bpl.s	loc_12AE6
		cmpi.w	#$FFF2,d1
		blt.s	locret_12B0C
		add.w	d1,y_pos(a0)

locret_12AE4:				; CODE XREF: AnglePos+DAj
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12AE6:				; CODE XREF: AnglePos+DCj
		cmpi.w	#$E,d1
		bgt.s	loc_12AF2

loc_12AEC:				; CODE XREF: AnglePos+FAj
		add.w	d1,y_pos(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12AF2:				; CODE XREF: AnglePos+EEj
		tst.b	stick_to_convex(a0)
		bne.s	loc_12AEC
		bset	#1,status(a0)
		bclr	#5,status(a0)
		move.b	#1,prev_anim(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

locret_12B0C:				; CODE XREF: AnglePos+E2j
					; AnglePos+2ACj
		rts
; End of function AnglePos

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		move.l	x_pos(a0),d2
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2
		move.l	d2,x_pos(a0)
		move.w	#$38,d0	; '8'
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,y_pos(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR AnglePos

locret_12B30:				; CODE XREF: AnglePos+20Ej
					; AnglePos+34Aj
		rts
; END OF FUNCTION CHUNK	FOR AnglePos
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		move.l	y_pos(a0),d3
		move.w	y_vel(a0),d0
		subi.w	#$38,d0	; '8'
		move.w	d0,y_vel(a0)
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,y_pos(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		move.l	x_pos(a0),d2
		move.l	y_pos(a0),d3
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2
		move.w	y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d2,x_pos(a0)
		move.l	d3,y_pos(a0)
		rts

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_Angle:				; CODE XREF: AnglePos+D4p
					; AnglePos+200p ...
		move.b	($FFFFF76A).w,d2
		cmp.w	d0,d1
		ble.s	loc_12B84
		move.b	($FFFFF768).w,d2
		move.w	d0,d1

loc_12B84:				; CODE XREF: Sonic_Angle+6j
		btst	#0,d2
		bne.s	loc_12B90
		move.b	d2,angle(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12B90:				; CODE XREF: Sonic_Angle+12j
		move.b	angle(a0),d2
		addi.b	#$20,d2	; ' '
		andi.b	#$C0,d2
		move.b	d2,angle(a0)
		rts
; End of function Sonic_Angle

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR AnglePos

Sonic_WalkVertR:			; CODE XREF: AnglePos+76j
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	x_radius(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d2
		move.b	y_radius(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	x_radius(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	y_radius(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_12C12
		bpl.s	loc_12C14
		cmpi.w	#$FFF2,d1
		blt.w	locret_12B30
		add.w	d1,x_pos(a0)

locret_12C12:				; CODE XREF: AnglePos+206j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12C14:				; CODE XREF: AnglePos+208j
		cmpi.w	#$E,d1
		bgt.s	loc_12C20

loc_12C1A:				; CODE XREF: AnglePos+228j
		add.w	d1,x_pos(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12C20:				; CODE XREF: AnglePos+21Cj
		tst.b	stick_to_convex(a0)
		bne.s	loc_12C1A
		bset	#1,status(a0)
		bclr	#5,status(a0)
		move.b	#1,prev_anim(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Sonic_WalkCeiling:			; CODE XREF: AnglePos+6Ej
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	y_radius(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	x_radius(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	y_radius(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	x_radius(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	($FFFFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_12CB0
		bpl.s	loc_12CB2
		cmpi.w	#$FFF2,d1
		blt.w	locret_12B0C
		sub.w	d1,y_pos(a0)

locret_12CB0:				; CODE XREF: AnglePos+2A4j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12CB2:				; CODE XREF: AnglePos+2A6j
		cmpi.w	#$E,d1
		bgt.s	loc_12CBE

loc_12CB8:				; CODE XREF: AnglePos+2C6j
		sub.w	d1,y_pos(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12CBE:				; CODE XREF: AnglePos+2BAj
		tst.b	stick_to_convex(a0)
		bne.s	loc_12CB8
		bset	#1,status(a0)
		bclr	#5,status(a0)
		move.b	#1,prev_anim(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Sonic_WalkVertL:			; CODE XREF: AnglePos+66j
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	x_radius(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	y_radius(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	($FFFFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$400,d6
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	x_radius(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	y_radius(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	($FFFFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$400,d6
		bsr.w	FindWall
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_12D4E
		bpl.s	loc_12D50
		cmpi.w	#$FFF2,d1
		blt.w	locret_12B30
		sub.w	d1,x_pos(a0)

locret_12D4E:				; CODE XREF: AnglePos+342j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12D50:				; CODE XREF: AnglePos+344j
		cmpi.w	#$E,d1
		bgt.s	loc_12D5C

loc_12D56:				; CODE XREF: AnglePos+364j
		sub.w	d1,x_pos(a0)
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12D5C:				; CODE XREF: AnglePos+358j
		tst.b	stick_to_convex(a0)
		bne.s	loc_12D56
		bset	#1,status(a0)
		bclr	#5,status(a0)
		move.b	#1,prev_anim(a0)
		rts
; END OF FUNCTION CHUNK	FOR AnglePos

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Floor_ChkTile:	
		move.w	d2,d0
		add.w	d0,d0		; y*2
		andi.w	#$F00,d0	; Masked, only upper nibble matters
		move.w	d3,d1
		lsr.w	#7,d1		; Divide X position by 128
		andi.w	#$7F,d1		; mask
		add.w	d1,d0		; add both numbers
		moveq	#-1,d1		; ???
		lea	(Level_Layout).w,a1
		move.b	(a1,d0.w),d1	; Get current chunk

		andi.w	#$FF,d1
		lsl.w	#7,d1
		move.w	d2,d0
		andi.w	#$70,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$E,d0
		add.w	d0,d1
		movea.l	d1,a1	; block at a1
		rts
; End of function Floor_ChkTile


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


FindFloor:				; CODE XREF: AnglePos+A0p
					; AnglePos+CEp ...
		bsr.s	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$3FF,d0
		beq.s	loc_12DBE
		btst	d5,d4
		bne.s	loc_12DCC

loc_12DBE:				; CODE XREF: FindFloor+Aj
					; FindFloor+28j ...
		add.w	a3,d2
		bsr.w	FindFloor2
		sub.w	a3,d2
		addi.w	#$10,d1
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12DCC:				; CODE XREF: FindFloor+Ej
		movea.l	(Collision_addr).w,a2
		add.w	d0,d0
		move.w	(a2,d0.w),d0
		beq.s	loc_12DBE
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$A,d4
		beq.s	loc_12DF0
		not.w	d1
		neg.b	(a4)

loc_12DF0:				; CODE XREF: FindFloor+3Cj
		btst	#$B,d4
		beq.s	loc_12E00
		addi.b	#$40,(a4) ; '@'
		neg.b	(a4)
		subi.b	#$40,(a4) ; '@'

loc_12E00:				; CODE XREF: FindFloor+46j
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(ColArray1).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	loc_12E1C
		neg.w	d0

loc_12E1C:				; CODE XREF: FindFloor+6Aj
		tst.w	d0
		beq.s	loc_12DBE
		bmi.s	loc_12E38
		cmpi.b	#$10,d0
		beq.s	loc_12E44
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12E38:				; CODE XREF: FindFloor+72j
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_12DBE

loc_12E44:				; CODE XREF: FindFloor+78j
		sub.w	a3,d2
		bsr.w	FindFloor2
		add.w	a3,d2
		subi.w	#$10,d1
		rts
; End of function FindFloor


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


FindFloor2:				; CODE XREF: FindFloor+12p
					; FindFloor+98p
		bsr.w	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$3FF,d0
		beq.s	loc_12E64
		btst	d5,d4
		bne.s	loc_12E72

loc_12E64:				; CODE XREF: FindFloor2+Cj
					; FindFloor2+2Aj ...
		move.w	#$F,d1
		move.w	d2,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12E72:				; CODE XREF: FindFloor2+10j
		movea.l	(Collision_addr).w,a2
		add.w	d0,d0
		move.w	(a2,d0.w),d0
		beq.s	loc_12E64
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$A,d4
		beq.s	loc_12E96
		not.w	d1
		neg.b	(a4)

loc_12E96:				; CODE XREF: FindFloor2+3Ej
		btst	#$B,d4
		beq.s	loc_12EA6
		addi.b	#$40,(a4) ; '@'
		neg.b	(a4)
		subi.b	#$40,(a4) ; '@'

loc_12EA6:				; CODE XREF: FindFloor2+48j
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(ColArray1).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	loc_12EC2
		neg.w	d0

loc_12EC2:				; CODE XREF: FindFloor2+6Cj
		tst.w	d0
		beq.s	loc_12E64
		bmi.s	loc_12ED8
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12ED8:				; CODE XREF: FindFloor2+74j
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_12E64
		not.w	d1
		rts
; End of function FindFloor2


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


FindWall:				; CODE XREF: AnglePos+1CEp
					; AnglePos+1FAp ...
		bsr.w	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$3FF,d0
		beq.s	loc_12EFA
		btst	d5,d4
		bne.s	loc_12F08

loc_12EFA:				; CODE XREF: FindWall+Cj FindWall+2Aj	...
		add.w	a3,d3
		bsr.w	FindWall2
		sub.w	a3,d3
		addi.w	#$10,d1
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12F08:				; CODE XREF: FindWall+10j
		movea.l	(Collision_addr).w,a2
		add.w	d0,d0
		move.w	(a2,d0.w),d0
		beq.s	loc_12EFA
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$B,d4
		beq.s	loc_12F34
		not.w	d1
		addi.b	#$40,(a4) ; '@'
		neg.b	(a4)
		subi.b	#$40,(a4) ; '@'

loc_12F34:				; CODE XREF: FindWall+3Ej
		btst	#$A,d4
		beq.s	loc_12F3C
		neg.b	(a4)

loc_12F3C:				; CODE XREF: FindWall+50j
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(ColArray2).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$A,d4
		beq.s	loc_12F58
		neg.w	d0

loc_12F58:				; CODE XREF: FindWall+6Cj
		tst.w	d0
		beq.s	loc_12EFA
		bmi.s	loc_12F74
		cmpi.b	#$10,d0
		beq.s	loc_12F80
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12F74:				; CODE XREF: FindWall+74j
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_12EFA

loc_12F80:				; CODE XREF: FindWall+7Aj
		sub.w	a3,d3
		bsr.w	FindWall2
		add.w	a3,d3
		subi.w	#$10,d1
		rts
; End of function FindWall


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


FindWall2:				; CODE XREF: FindWall+14p FindWall+9Ap
		bsr.w	Floor_ChkTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$3FF,d0
		beq.s	loc_12FA0
		btst	d5,d4
		bne.s	loc_12FAE

loc_12FA0:				; CODE XREF: FindWall2+Cj
					; FindWall2+2Aj ...
		move.w	#$F,d1
		move.w	d3,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_12FAE:				; CODE XREF: FindWall2+10j
		movea.l	(Collision_addr).w,a2
		add.w	d0,d0
		move.w	(a2,d0.w),d0
		beq.s	loc_12FA0
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$B,d4
		beq.s	loc_12FDA
		not.w	d1
		addi.b	#$40,(a4) ; '@'
		neg.b	(a4)
		subi.b	#$40,(a4) ; '@'

loc_12FDA:				; CODE XREF: FindWall2+3Ej
		btst	#$A,d4
		beq.s	loc_12FE2
		neg.b	(a4)

loc_12FE2:				; CODE XREF: FindWall2+50j
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(ColArray2).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$A,d4
		beq.s	loc_12FFE
		neg.w	d0

loc_12FFE:				; CODE XREF: FindWall2+6Cj
		tst.w	d0
		beq.s	loc_12FA0
		bmi.s	loc_13014
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_13014:				; CODE XREF: FindWall2+74j
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_12FA0
		not.w	d1
		rts
; End of function FindWall2

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ

; Sonic_WalkSpeed:
CalcRoomInFront:
		move.l	#Primary_Collision,(Collision_addr).w
		cmpi.b	#$C,top_solid_bit(a0)
		beq.s	loc_13094
		move.l	#Secondary_Collision,(Collision_addr).w

loc_13094:				; CODE XREF: CalcRoomInFront+Ej
		move.b	lrb_solid_bit(a0),d5
		move.l	x_pos(a0),d3
		move.l	y_pos(a0),d2
		move.w	x_vel(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d3
		move.w	y_vel(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d2
		swap	d2
		swap	d3
		move.b	d0,($FFFFF768).w
		move.b	d0,($FFFFF76A).w
		move.b	d0,d1
		addi.b	#$20,d0	; ' '
		bpl.s	loc_130D4
		move.b	d1,d0
		bpl.s	loc_130CE
		subq.b	#1,d0

loc_130CE:				; CODE XREF: CalcRoomInFront+4Ej
		addi.b	#$20,d0	; ' '
		bra.s	loc_130DE
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_130D4:				; CODE XREF: CalcRoomInFront+4Aj
		move.b	d1,d0
		bpl.s	loc_130DA
		addq.b	#1,d0

loc_130DA:				; CODE XREF: CalcRoomInFront+5Aj
		addi.b	#$1F,d0

loc_130DE:				; CODE XREF: CalcRoomInFront+56j
		andi.b	#$C0,d0
		beq.w	loc_131DE
		cmpi.b	#$80,d0
		beq.w	loc_133B0
		andi.b	#$38,d1	; '8'
		bne.s	loc_130F6
		addq.w	#8,d2

loc_130F6:				; CODE XREF: CalcRoomInFront+76j
		cmpi.b	#$40,d0	; '@'
		beq.w	loc_13478
		bra.w	loc_132F6
; End of function CalcRoomInFront


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_13102:	; only Jump rotuine uses this
; input :
; d0 - angle
		move.l	#Primary_Collision,(Collision_addr).w
		cmpi.b	#$C,top_solid_bit(a0)
		beq.s	loc_1311A
		move.l	#Secondary_Collision,(Collision_addr).w

loc_1311A:				; CODE XREF: sub_13102+Ej
		move.b	lrb_solid_bit(a0),d5
		move.b	d0,($FFFFF768).w
		move.b	d0,($FFFFF76A).w
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_13408
		cmpi.b	#$80,d0
		beq.w	Sonic_DontRunOnWalls
		cmpi.b	#$C0,d0
		beq.w	loc_1328E

loc_13146:	
		move.l	#Primary_Collision,(Collision_addr).w
		cmpi.b	#$C,top_solid_bit(a0)
		beq.s	loc_1315E
		move.l	#Secondary_Collision,(Collision_addr).w

loc_1315E:	
		move.b	top_solid_bit(a0),d5
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	y_radius(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	x_radius(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	y_radius(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	x_radius(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	($FFFFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#0,d2

loc_131BE:				; CODE XREF: sub_13102+1E8j
					; Sonic_DontRunOnWalls+64j ...
		move.b	($FFFFF76A).w,d3
		cmp.w	d0,d1
		ble.s	loc_131CC
		move.b	($FFFFF768).w,d3
		exg	d0,d1

loc_131CC:				; CODE XREF: sub_13102+C2j
		btst	#0,d3
		beq.s	locret_131D4
		move.b	d2,d3

locret_131D4:				; CODE XREF: sub_13102+CEj
		rts
; End of function sub_13102

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
; START	OF FUNCTION CHUNK FOR CalcRoomInFront

loc_131DE:				; CODE XREF: CalcRoomInFront+66j
		addi.w	#$A,d2
		lea	($FFFFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindFloor
		move.b	#0,d2

loc_131F6:				; CODE XREF: CalcRoomInFront+292j
					; CalcRoomInFront+350j	...
		move.b	($FFFFF768).w,d3
		btst	#0,d3
		beq.s	locret_13202
		move.b	d2,d3

locret_13202:				; CODE XREF: CalcRoomInFront+182j
		rts
; END OF FUNCTION CHUNK	FOR CalcRoomInFront

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ

; Sonic_HitFloor:
ChkFloorEdge:
		move.w	x_pos(a0),d3
ChkFloorEdge_Part2:
		move.w	y_pos(a0),d2
		moveq	#0,d0
		move.b	y_radius(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.l	#Primary_Collision,(Collision_addr).w
		cmpi.b	#$C,top_solid_bit(a0)
		beq.s	loc_1322E
		move.l	#Secondary_Collision,(Collision_addr).w

loc_1322E:				; CODE XREF: ChkFloorEdge+20j
		lea	($FFFFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		move.b	top_solid_bit(a0),d5
		bsr.w	FindFloor
		move.b	($FFFFF768).w,d3
		btst	#0,d3
		beq.s	locret_13254
		move.b	#0,d3

locret_13254:				; CODE XREF: ChkFloorEdge+4Aj
		rts
; End of function ChkFloorEdge


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


ObjHitFloor:				; CODE XREF: ROM:000096A8p
					; ROM:00009796p ...
		move.w	x_pos(a0),d3

ObjHitFloor2:				; CODE XREF: ROM:loc_A224p
		move.w	y_pos(a0),d2
		moveq	#0,d0
		move.b	y_radius(a0),d0
		ext.w	d0
		add.w	d0,d2
		lea	($FFFFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$C,d5
		bsr.w	FindFloor
		move.b	($FFFFF768).w,d3
		btst	#0,d3
		beq.s	locret_1328C
		move.b	#0,d3

locret_1328C:				; CODE XREF: ObjHitFloor+30j
		rts
; End of function ObjHitFloor

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR sub_13102

loc_1328E:				; CODE XREF: sub_13102+40j
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	x_radius(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	y_radius(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	x_radius(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	y_radius(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall
		move.w	(sp)+,d0
		move.b	#$C0,d2
		bra.w	loc_131BE
; END OF FUNCTION CHUNK	FOR sub_13102

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


sub_132EE:				; CODE XREF: Sonic_DoLevelCollision:loc_10558p
					; Sonic_DoLevelCollision:loc_10658p ...
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
; End of function sub_132EE

; START	OF FUNCTION CHUNK FOR CalcRoomInFront

loc_132F6:				; CODE XREF: CalcRoomInFront+82j
		addi.w	#$A,d3
		lea	($FFFFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		bsr.w	FindWall
		move.b	#$C0,d2
		bra.w	loc_131F6
; END OF FUNCTION CHUNK	FOR CalcRoomInFront

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


ObjHitWallRight:			; CODE XREF: ROM:000153B2p
					; ROM:000153D2p
		add.w	x_pos(a0),d3
		move.w	y_pos(a0),d2
		lea	($FFFFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindWall
		move.b	($FFFFF768).w,d3
		btst	#0,d3
		beq.s	locret_1333E
		move.b	#$C0,d3

locret_1333E:				; CODE XREF: ObjHitWallRight+26j
		rts
; End of function ObjHitWallRight


; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_DontRunOnWalls:			; This label is a lie
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	y_radius(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	x_radius(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	y_radius(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	x_radius(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	($FFFFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#$80,d2
		bra.w	loc_131BE
; End of function Sonic_DontRunOnWalls

; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
; START	OF FUNCTION CHUNK FOR CalcRoomInFront

loc_133B0:				; CODE XREF: CalcRoomInFront+6Ej
		subi.w	#$A,d2
		eori.w	#$F,d2
		lea	($FFFFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		bsr.w	FindFloor
		move.b	#$80,d2
		bra.w	loc_131F6
; END OF FUNCTION CHUNK	FOR CalcRoomInFront
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ObjHitCeiling:
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	y_radius(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		lea	($FFFFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.b	($FFFFF768).w,d3
		btst	#0,d3
		beq.s	locret_13406
		move.b	#$80,d3

locret_13406:				; CODE XREF: ROM:00013400j
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; START	OF FUNCTION CHUNK FOR sub_13102

loc_13408:				; CODE XREF: sub_13102+30j
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	x_radius(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	y_radius(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	($FFFFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$400,d6
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
		moveq	#0,d0
		move.b	x_radius(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	y_radius(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	($FFFFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$400,d6
		bsr.w	FindWall
		move.w	(sp)+,d0
		move.b	#$40,d2	; '@'
		bra.w	loc_131BE
; END OF FUNCTION CHUNK	FOR sub_13102

; ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ S U B	R O U T	I N E ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ


Sonic_HitWall:				; CODE XREF: Sonic_DoLevelCollision+4Ap
					; Sonic_DoLevelCollision:loc_105E4p ...
		move.w	y_pos(a0),d2
		move.w	x_pos(a0),d3
; End of function Sonic_HitWall

; START	OF FUNCTION CHUNK FOR CalcRoomInFront

loc_13478:				; CODE XREF: CalcRoomInFront+7Ej
		subi.w	#$A,d3
		eori.w	#$F,d3
		lea	($FFFFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$400,d6
		bsr.w	FindWall
		move.b	#$40,d2	; '@'
		bra.w	loc_131F6
; END OF FUNCTION CHUNK	FOR CalcRoomInFront
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ObjHitWallLeft:
		add.w	x_pos(a0),d3
		move.w	y_pos(a0),d2
		lea	($FFFFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$FFF0,a3
		move.w	#$400,d6
		moveq	#$D,d5
		bsr.w	FindWall
		move.b	($FFFFF768).w,d3
		btst	#0,d3
		beq.s	locret_134C4
		move.b	#$40,d3	; '@'

locret_134C4:				; CODE XREF: ROM:000134BEj
		rts
