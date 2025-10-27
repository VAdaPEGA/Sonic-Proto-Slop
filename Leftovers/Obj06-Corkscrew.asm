;----------------------------------------------------
; Object 06 - spiral loop in EHZ
;----------------------------------------------------
Obj06:	
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj06_Index(pc,d0.w),d1
		jsr	Obj06_Index(pc,d1.w)
		tst.w	(Two_player_mode).w
		bne.s	@2Player
		out_of_range	@Delete
	@2Player:
		rts
; ----------------------------------------------------
@Delete:	
		jmp	(DeleteObject).l
; ===========================================================================
Obj06_Index:	dc.w Obj06_Init-Obj06_Index
		dc.w Obj06_Main-Obj06_Index
; ===========================================================================
Obj06_Init:	
	addq.b	#2,routine(a0)
	move.b	#208,width_pixels(a0)
; ----------------------------------------------------
Corkscrew_Length	=	(128*3)	; 3 chunks wide

Obj06_Main:	
	lea	(MainCharacter).w,a1
	moveq	#StatusBitP1Stand,d6
	bsr.s	@CheckPlayer1
		lea	(Sidekick).w,a1
		addq.b	#1,d6	; check player 2
	@CheckPlayer1:	
	btst	d6,status(a0)	; is player on object?
	bne.w	@OnCorkscrew		; if yes, branch
		btst	#PlayerStatusBitAir,status(a1)
		bne.w	@DoNothing
			btst	#PlayerStatusBitOnObject,status(a1)
			bne.s	@EnterFromAnotherCorkscrew
				; attempt to get player on Corkscrew
				move.w	x_pos(a1),d0	
				sub.w	x_pos(a0),d0	; get X position difference
				tst.w	x_vel(a1)	; check speed
				bmi.s	@EnterFromRight
					cmpi.w	#-(((Corkscrew_Length)/2)-32),d0
					bgt.s	@DoNothing
						cmpi.w	#-(((Corkscrew_Length)/2)+16),d0
						bge.s	@CheckYPosition
							rts
; ----------------------------------------------------
			@EnterFromRight:				
				cmpi.w	#(((Corkscrew_Length)/2)-32),d0
				blt.s	@DoNothing
					cmpi.w	#(((Corkscrew_Length)/2)+16),d0
					bgt.s	@DoNothing
						@CheckYPosition:
						move.w	y_pos(a1),d1
						sub.w	y_pos(a0),d1
						subi.w	#16,d1
						cmpi.w	#(32+16),d1
						bcc.s	@DoNothing
							bsr.w	RideObject_SetRide	; get on the Corkscrew
						rts
; ===========================================================================
		@EnterFromAnotherCorkscrew:
			move.w	x_pos(a1),d0
			sub.w	x_pos(a0),d0
			tst.w	x_vel(a1)
			bmi.s	@EnterFromRightCorkscrew
				cmpi.w	#-(((Corkscrew_Length)/2)-16),d0
				bgt.s	@DoNothing
					cmpi.w	#-((Corkscrew_Length)/2),d0
					blt.s	@DoNothing
						bra.s	@CheckYPosition
; ----------------------------------------------------
		@EnterFromRightCorkscrew:	
			cmpi.w	#(((Corkscrew_Length)/2)-16),d0
			blt.s	@DoNothing
				cmpi.w	#(Corkscrew_Length)/2,d0
				ble.s	@CheckYPosition
	@DoNothing:
		rts
; ===========================================================================
@OnCorkscrew:
	move.w	ground_speed(a1),d0	; get ground speed
	bpl.s	@PositiveSpeed
		neg.w	d0	; remove negative sign cause we don't need it
	@PositiveSpeed:
		cmpi.w	#$480,d0		; is player moving fast enough?
		bcs.s	@GetOffCorkscrew	; if not, branch
			btst	#PlayerStatusBitAir,status(a1)	; is player in the air?
			bne.s	@GetOffCorkscrew		; if so, branch
				move.w	x_pos(a1),d0
				sub.w	x_pos(a0),d0
				addi.w	#((Corkscrew_Length)+16)/2,d0
				bmi.s	@GetOffCorkscrew
				cmpi.w	#(Corkscrew_Length)+16,d0
				bcs.s	@HandlePositionAndFlipma

	@GetOffCorkscrew:
		bclr	#PlayerStatusBitOnObject,status(a0)
		bclr	d6,status(a0)	; clear "Player is Standing on object" bit
		move.b	#0,flips_remaining(a0)
		move.b	#4,flip_speed(a0)
		move.b	#0,flip_angle(a0)
		rts
; ===========================================================================
	@HandlePositionAndFlipma:
		btst	#PlayerStatusBitOnObject,status(a0)
		beq.s	@DoNothing2
		move.b	Obj06_PlayerDeltaYArray(pc,d0.w),d1
		ext.w	d1
		move.w	y_pos(a0),d2
		add.w	d1,d2
		moveq	#0,d1
		move.b	y_radius(a1),d1	; get player size
		subi.w	#19,d1		; move upwards
		sub.w	d1,d2		; 
		move.w	d2,y_pos(a1)
		lsr.w	#5,d0
		andi.w	#$F,d0
		move.b	Obj06_PlayerAngleArray(pc,d0.w),flip_angle(a1)
		@DoNothing2:
		rts
; End of function sub_149BC

; ===========================================================================
Obj06_PlayerAngleArray:
	dc.b	$01	; Padding
	dc.b	$16, $2C, $42, $58
	dc.b	$6E, $84, $9A, $B0
	dc.b	$C6, $DC, $F2, $01
	dc.b	$01	; Padding
Obj06_PlayerDeltaYArray:
	dc.b	 32, 32, 32, 32, 32, 32, 32, 32	; Padding
	dc.b	 32, 32, 32, 32, 32, 32, 32, 32

	dc.b	 32, 32, 32, 32, 32, 32, 32, 32	; 0
	dc.b	 32, 32, 32, 32, 32, 32, 31, 31
	dc.b	 31, 31, 31, 31, 31, 31, 31, 31
	dc.b	 31, 31, 31, 31, 31, 30, 30, 30
	dc.b	 30, 30, 30, 30, 30, 30, 29, 29
	dc.b	 29, 29, 29, 28, 28, 28, 28, 27
	dc.b	 27, 27, 27, 26, 26, 26, 25, 25
	dc.b	 25, 24, 24, 24, 23, 23, 22, 22
	dc.b	 21, 21, 20, 20, 19, 18, 18, 17
	dc.b	 16, 16, 15, 14, 14, 13, 12, 12
	dc.b	 11, 10, 10,  9,  8,  8,  7,  6
	dc.b	  6,  5,  4,  4,  3,  2,  2,  1
	dc.b	  0, -1, -2, -2, -3, -4, -4, -5
	dc.b	 -6, -7, -7, -8, -9, -9,-10,-10
	dc.b	-11,-11,-12,-12,-13,-14,-14,-15
	dc.b	-15,-16,-16,-17,-17,-18,-18,-19

	dc.b	-19,-19,-20,-21,-21,-22,-22,-23	; 128
	dc.b	-23,-24,-24,-25,-25,-26,-26,-27
	dc.b	-27,-28,-28,-28,-29,-29,-30,-30
	dc.b	-30,-31,-31,-31,-32,-32,-32,-33
	dc.b	-33,-33,-33,-34,-34,-34,-35,-35
	dc.b	-35,-35,-35,-35,-35,-35,-36,-36
	dc.b	-36,-36,-36,-36,-36,-36,-36,-37
	dc.b	-37,-37,-37,-37,-37,-37,-37,-37
	dc.b	-37,-37,-37,-37,-37,-37,-37,-37
	dc.b	-37,-37,-37,-37,-37,-37,-37,-37
	dc.b	-37,-37,-37,-37,-36,-36,-36,-36
	dc.b	-36,-36,-36,-35,-35,-35,-35,-35
	dc.b	-35,-35,-35,-34,-34,-34,-33,-33
	dc.b	-33,-33,-32,-32,-32,-31,-31,-31
	dc.b	-30,-30,-30,-29,-29,-28,-28,-28
	dc.b	-27,-27,-26,-26,-25,-25,-24,-24

	dc.b	-23,-23,-22,-22,-21,-21,-20,-19	; 256
	dc.b	-19,-18,-18,-17,-16,-16,-15,-14
	dc.b	-14,-13,-12,-11,-11,-10, -9, -8
	dc.b	 -7, -7, -6, -5, -4, -3, -2, -1
	dc.b	  0,  1,  2,  3,  4,  5,  6,  7
	dc.b	  8,  8,  9, 10, 10, 11, 12, 13
	dc.b	 13, 14, 14, 15, 15, 16, 16, 17
	dc.b	 17, 18, 18, 19, 19, 20, 20, 21
	dc.b	 21, 22, 22, 23, 23, 24, 24, 24
	dc.b	 25, 25, 25, 25, 26, 26, 26, 26
	dc.b	 27, 27, 27, 27, 28, 28, 28, 28
	dc.b	 28, 28, 29, 29, 29, 29, 29, 29
	dc.b	 29, 30, 30, 30, 30, 30, 30, 30
	dc.b	 31, 31, 31, 31, 31, 31, 31, 31
	dc.b	 31, 31, 32, 32, 32, 32, 32, 32
	dc.b	 32, 32, 32, 32, 32, 32, 32, 32

	dc.b	 32, 32, 32, 32, 32, 32, 32, 32	; Padding
	dc.b	 32, 32, 32, 32, 32, 32, 32, 32
; ===========================================================================