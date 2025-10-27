; ---------------------------------------------------------------------------
; Subroutine for chunk related effects, such as loops and S tunnels
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

		moveq	#0,d0
		move.b	(Current_Zone).w,d0
		add.w	d0,d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
	IndexStart
	GenerateLocalIndex	2, DoNothing,	; GHZ
	GenerateLocalIndex	2, DoNothing,	; CPZ
	GenerateLocalIndex	2, DoNothing,	; MMZ
	GenerateLocalIndex	2, EHZ,		; EHZ
	GenerateLocalIndex	2, DoNothing,	; HPZ
	GenerateLocalIndex	2, IcePhysics,	; HTZ
	GenerateLocalIndex	2, DoNothing,	; CNZ
	if	(c=ZoneCount*2)
	else
		inform	1,"WARNING : Chunk Effects don't match Zone Count (\#ZoneCount\ - \#c\)"
	endif
; ===========================================================================
	@GetChunk:
		move.w	y_pos(a0),d0
		add.w	d0,d0		; y*2
		andi.w	#$F00,d0	; Masked, only upper nibble matters

		move.w	x_pos(a0),d1
		lsr.w	#7,d1		; Divide X position by 128
		andi.w	#$7F,d1		; mask

		add.w	d1,d0		; add both numbers
		lea	(Level_Layout).w,a1
		move.b	(a1,d0.w),d1	; d1 is	the Chunk Player is currently on

		; debug, check if chunk fetching is correct
;		move.w	d1,(Ring_count).w
;		st	(Update_HUD_rings).w
		rts
; ===========================================================================
	@EHZ:
		bsr.s	@GetChunk

		sub.b	#8,d1		; Is this a S tube?
		bcs.w	loc_1023A	; Force Player 1 to roll ala S1 (a.k.a wrong)
		cmpi.b	#11,d1
		bhi.s	@doNothing
		nop	; no code yet, will figure it out
; ---------------------------------------------------------------------------
@DoNothing:
		rts
; ===========================================================================
@IcePhysics:
		bsr	@GetChunk
		cmpi.b	#$0F,d1 	; is chunk 0F?
		bhi.s	@no_ice		; if not, branch
		move.b	#1,(0).w
		rts
@no_ice:
		move.b	#0,(0).w
		rts

; End of function PlayerMain_Loops
