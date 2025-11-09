; ---------------------------------------------------------------------------
; Subroutine to calculate sine and cosine of an angle
; input:
;	d0.b = angle (360 degrees == 256)
; output:
;	d0.w = 255 * cosine(angle)
;	d1.w = 255 * sine(angle)
; NOTE : It's the other way around in the vanila game
; ---------------------------------------------------------------------------
CalcSine:
		andi.w	#$FF,d0
		add.w	d0,d0
		move.w	Sine_Data(pc,d0.w),d1
		addi.w	#$40*2,d0		; $40 = 90 degrees, sin(x+90) = cos(x)
		move.w	Sine_Data(pc,d0.w),d0
		rts
; ===========================================================================
Sine_Data:	incbin	"Maths\Data\sinewave.bin"	; values for a 360º sine wave
; ===========================================================================