; ---------------------------------------------------------------------------
; Subroutine calculate an angle (calculate arctangent of y/x)

; input:	d1.w = x-axis distance
;		d2.w = y-axis distance

; output:	d0.b = angle (360 degrees == 256)
; ---------------------------------------------------------------------------
CalcAngle:
		movem.l	d3-d4,-(sp)
		moveq	#0,d3
		moveq	#0,d4
		move.w	d1,d3
		move.w	d2,d4
		or.w	d3,d4
		beq.s	CalcAngle_Zero
		move.w	d2,d4
		; calculate absolute value of x
		tst.w	d3
		bpl.w	@AbsoluteX
		neg.w	d3
	@AbsoluteX:
		; calculate absolute value of y
		tst.w	d4		
		bpl.w	@AbsoluteY
		neg.w	d4

	@AbsoluteY:
		cmp.w	d3,d4
		bcc.w	loc_2F82
		lsl.l	#8,d4
		divu.w	d3,d4
		moveq	#0,d0
		move.b	Angle_Data(pc,d4.w),d0
		bra.s	loc_2F8C
; ---------------------------------------------------------------------------

loc_2F82:
		lsl.l	#8,d3
		divu.w	d4,d3
		moveq	#$40,d0
		sub.b	Angle_Data(pc,d3.w),d0

loc_2F8C:
		tst.w	d1
		bpl.w	loc_2F98
		neg.w	d0
		addi.w	#$80,d0

loc_2F98:
		tst.w	d2
		bpl.w	loc_2FA4
		neg.w	d0
		addi.w	#$100,d0

loc_2FA4:
		movem.l	(sp)+,d3-d4
		rts
; ===========================================================================
; loc_2FAA:
CalcAngle_Zero:
		move.w	#$40,d0
		movem.l	(sp)+,d3-d4
		rts
; End of function CalcAngle
; ===========================================================================
Angle_Data:	incbin	"Maths\Data\angles.bin"
; ===========================================================================