; ---------------------------------------------------------------------------
; Macros
align macro
	cnop 0,\1
	endm

stopZ80 macro
	move.w	#$100,(Z80_Bus_Request).l
@loop:	btst	#0,(Z80_Bus_Request).l
	bne.s	@loop
	endm

startZ80 macro
	move.w	#0,(Z80_Bus_Request).l
	endm

; ---------------------------------------------------------------------------
; Get Date	
; ---------------------------------------------------------------------------
GetDate:	macro
_getyear	=	_year-100
		dc.b "20\#_getyear-"
		if (strlen("\#_month")=2)
		dc.b "\#_month-"
		else
		dc.b "0\#_month-"
		endc
		if (strlen("\#_day")=2)
		dc.b "\#_day "
		else
		dc.b "0\#_day "
		endc
		if (strlen("\#_hours")=2)
		dc.b "\#_hours:"
		else
		dc.b "0\#_hours:"
		endc
		if (strlen("\#_minutes")=2)
		dc.b "\#_minutes"
		else
		dc.b "0\#_minutes"
		endc
		endm
; ---------------------------------------------------------------------------
; Lagometer (uses Window Layer)
; ---------------------------------------------------------------------------
LagOn	macro
	if	(lagometer)
	move.w	#$9193,(vdp_control_port).l
	endif
	endm
LagOff	macro
	if	(lagometer)
	move.w	#$9100,(vdp_control_port).l
	endif
	endm