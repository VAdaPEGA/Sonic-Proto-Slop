;----------------------------------------------------
; Object 36 - Spikes
;----------------------------------------------------

Obj36:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex	2, Spikes, Init
	GenerateIndexID	2, Spikes, Upright
	GenerateIndexID	2, Spikes, Sideways
	GenerateIndexID	2, Spikes, DiagonalLeft
	GenerateIndexID	2, Spikes, DiagonalRight

Spik_OrigX:		equ $30		; start X position
Spik_OrigY:		equ $32		; start Y position
Spik_Reposition:	equ $34		; Reposition
Spik_Status:		equ $36		; State of Spike

Spik_Timer:		equ $38		; Spike Timer
Spik_Timer_Reset:	equ $3A		; Spike Timer

Obj36_Conf:	
@macro	macro	Frame, Routine, Size,	time
	dc.b	Frame, Routine, Size/2, time
	endm
	;	Frame,	Routine,		Size,	Time
	@Macro	1,	SpikesID_Upright,	16,	60
	@Macro	0,	SpikesID_Upright,	32,	60
	@Macro	2,	SpikesID_Upright,	48,	60
	@Macro	3,	SpikesID_Upright,	64,	60
	@Macro	4,	SpikesID_Upright,	80,	120
	@Macro	5,	SpikesID_Upright,	112,	120

	@Macro	1,	SpikesID_Sideways,	32,	60
	@Macro	1,	SpikesID_Sideways,	32,	30
; ===========================================================================
Spikes_Init:	
		move.l	#Map_Spikes,mappings(a0)
		move.w	#$434,art_tile(a0)

		ori.b	#4,render_flags(a0)
		move.b	#4,priority(a0)
		move.b	Subtype(a0),d0
		andi.b	#$0F,Subtype(a0)
		andi.w	#$00F0,d0
		lea	Obj36_Conf(pc),a1
		lsr.w	#2,d0
		adda.w	d0,a1
		move.b	(a1)+,mapping_frame(a0)
		move.b	(a1)+,routine(a0)
		move.b	(a1)+,width_pixels(a0)
		move.b	(a1),Spik_Timer_Reset(a0)
		move.w	x_pos(a0),spik_origX(a0)
		move.w	y_pos(a0),spik_origY(a0)
		bra.w	Adjust2PArtPointer
; ===========================================================================
Spikes_Sideways:	
		bsr.w	Spike_Movement
		move.w	#$1B,d1
		move.w	#$14,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		bsr.w	SolidObject
		btst	#3,status(a0)
		bne.s	Spikes_Display
		swap	d6
		andi.w	#3,d6
		bne.s	Spikes_Hurt
		bra.s	Spikes_Display
; ===========================================================================
Spikes_Upright:
		bsr.w	Spike_Movement	
		move.w	#4,d2
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	x_pos(a0),d4
		bsr.w	SolidObject
		btst	#3,status(a0)
		bne.s	Spikes_Hurt
		swap	d6
		andi.w	#$C0,d6
		beq.s	Spikes_Display
; ===========================================================================
Spikes_DiagonalLeft:
Spikes_DiagonalRight:
		rts

Spikes_Hurt:	
		tst.b	($FFFFFE2D).w
		bne.s	Spikes_Display
		move.l	a0,-(sp)
		movea.l	a0,a2
		lea	(MainCharacter).w,a0
	;	cmpi.b	#4,routine(a0)	; useless
	;	bcc.s	@loc_C764
		move.l	y_pos(a0),d3
		move.w	y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,y_pos(a0)
		jsr	(HurtSonic).l
	@loc_C764:	
		movea.l	(sp)+,a0
; ---------------------------------------------------------------------------
Spikes_Display:	
		tst.w	(Two_player_mode).w
		bne.s	@TwoPlayer
		out_of_range	DeleteObject,spik_origX(a0)
	@TwoPlayer:	
		bra.w	DisplaySprite
; ===========================================================================
Spike_Movement:	
		moveq	#0,d0
		move.b	Subtype(a0),d0
		add.w	d0,d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart	
		GenerateIndex	2, Spike_Type00
		GenerateIndex	2, Spike_Type01
		GenerateIndex	2, Spike_Type02
		GenerateIndex	2, Spike_Type03
; ===========================================================================
Spike_Type01:	; Vertical Movement
		bsr.w	Spike_Timing
		add.w	spik_origY(a0),d0
		move.w	d0,y_pos(a0)
Spike_Type00:	; Don't move
		rts
; ---------------------------------------------------------------------------
Spike_Type02:	; Horizontal Movement
		bsr.w	Spike_Timing
		add.w	spik_origX(a0),d0
		move.w	d0,x_pos(a0)
		rts
; ---------------------------------------------------------------------------
Spike_Type03:	; Diagonal Movement
		bsr.w	Spike_Timing
		move.w	d0,d1
		add.w	spik_origX(a0),d0
		move.w	d0,x_pos(a0)
		add.w	spik_origY(a0),d1
		move.w	d1,y_pos(a0)
		rts
; ===========================================================================
Spike_Timing:	
	tst.w	Spik_Timer(a0)
	beq.s	@Movement
		subq.w	#1,Spik_Timer(a0)
		bne.s	@DoNothing
			tst.b	render_flags(a0)
			bpl.s	@DoNothing
				move.w	#$B6,d0
				jsr	(PlaySound_Special).l
				bra.s	@DoNothing
; ---------------------------------------------------------------------------
	@Movement:
	tst.b	Spik_Status(a0)
	beq.s	@MovingForward
		subi.w	#$800,Spik_Reposition(a0)	; go up / left
		bcc.s	@DoNothing
			move.w	#0,Spik_Reposition(a0)
			sf	Spik_Status(a0)
			move.w	Spik_Timer_Reset(a0),Spik_Timer(a0)
			bra.s	@DoNothing
; ---------------------------------------------------------------------------
	@MovingForward:	
		addi.w	#$800,Spik_Reposition(a0)
		cmpi.w	#$2000,Spik_Reposition(a0)
		bcs.s	@DoNothing
			move.w	#$2000,Spik_Reposition(a0)
			st	Spik_Status(a0)
			move.w	Spik_Timer_Reset(a0),Spik_Timer(a0)
; ---------------------------------------------------------------------------
	@DoNothing:
		moveq	#0,d0
		move.b	Spik_Reposition(a0),d0
		rts