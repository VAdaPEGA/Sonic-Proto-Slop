; ---------------------------------------------------------------------------
; Bubble Maker
; Yay I get to put my hyperfixation of this object in a project 
; people can see the source of
; ---------------------------------------------------------------------------
S1Obj64:
		moveq	#0,d0
		move.b	Routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
		GenerateIndex	2, Bub, Main		; 0
		GenerateIndex	2, Bub, Animate		; 2
		GenerateIndex	2, Bub, ChkWater	; 4
		GenerateIndex	2, Bub, Display		; 6
		GenerateIndex	2, Bub, Delete		; 8
		GenerateIndex	2, Bub, BblMaker	; $A

bub_inhalable	= $2E		; flag set when bubble is collectable
bub_origX	= $30		; original x-axis position

bub_bigtime	= $32		; counter for the next breathable bubble to spawn (per bursts)
bub_freq	= $33		; frequency of breathable bubble spawn (per bursts)
bub_burst	= $34		; number of bubbles to spawn per burst, 0-5
bub_flags	= $36		; bubble spawn flags :
				; bit 7 - set if big bubble is to spawn
				; bit 6 - set if big bubble has already spawned
				; Has Anything - burst of bubbles ongoing
bub_time	= $38		; time until next bubble spawn
bub_chanceTable	= $3C		; address to table to determine size of bubble (small to medium)

; ===========================================================================

Bub_Main:	; Routine 0
		addq.b	#2,Routine(a0)
		move.l	#Map_Obj0A_Bubbles,mappings(a0)
		move.w	#$8348,art_tile(a0)
		jsr	Adjust2PArtPointer
		move.b	#$84,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#1,priority(a0)
		move.b	Subtype(a0),d0 ; get bubble type
		bpl.s	@Bubble		; if type is $0-$7F, branch

		addq.b	#8,Routine(a0) ; goto Bub_BblMaker next
		andi.w	#$7F,d0		; read only last 7 bits	(deduct	$80)
		move.b	d0,bub_bigtime(a0)
		move.b	d0,bub_freq(a0)	; set bubble frequency
		move.b	#6,anim(a0)
		bra.w	Bub_BblMaker
; ===========================================================================

@Bubble:
		move.b	d0,anim(a0)	; 0 = small | 1 = medium | 2 = breathable
		move.w	x_pos(a0),bub_origX(a0)
		move.w	#-$88,y_vel(a0) ; float bubble upwards
		jsr	(RandomNumber).l
		move.b	d0,Angle(a0)

Bub_Animate:	; Routine 2
		lea	(Ani_Bub).l,a1
		jsr	(AnimateSprite).l
		cmpi.b	#6,mapping_frame(a0)	; is bubble full-size?
		bne.s	Bub_ChkWater	; if not, branch

		move.b	#1,bub_inhalable(a0) ; set "inhalable" flag

Bub_ChkWater:	; Routine 4
		move.w	(Water_Level_1).w,d0
		cmp.w	y_pos(a0),d0	; is bubble underwater?
		bcs.s	@Wobble		; if yes, branch

@Burst:
		move.b	#6,Routine(a0) ; goto Bub_Display next
		addq.b	#3,anim(a0)	; run "bursting" animation
		bra.w	Bub_Display
; ===========================================================================

@Wobble:
		move.b	Angle(a0),d0
		addq.b	#1,Angle(a0)
		andi.w	#$7F,d0
		lea	(Obj0A_WobbleData).l,a1
		move.b	(a1,d0.w),d0
		ext.w	d0
		add.w	bub_origX(a0),d0
		move.w	d0,x_pos(a0)	; change bubble's x-axis position
		tst.b	bub_inhalable(a0)
		beq.s	@display

		lea	(MainCharacter).w,a1
		bsr.w	Bub_ChkPlayer	; has Player touched the bubble?
		beq.s	@display	; if not, branch

		move.w	#$AD,d0	; '­'
		jsr	(PlaySound_Special).l

		move.l	a0,-(sp)	; The only proto-slop change so far
		move.l	a1,a0
		jsr	Obj01_WaterResumeMusic	; cancel countdown music
		movea.l	(sp)+,a0

		clr.w	x_vel(a1)
		clr.w	y_vel(a1)
		clr.w	ground_speed(a1)	; stop Player
		move.b	#SonicAniID_Bubble,anim(a1)	; use bubble-collecting animation
		move.w	#35,move_lock(a1)
		move.b	#0,bub_chanceTable(a1)
		bclr	#PlayerStatusBitPush,Status(a1)
		bclr	#PlayerStatusBitRollLock,Status(a1)
		btst	#PlayerStatusBitSpin,Status(a1)
		beq.w	@Burst
		bclr	#PlayerStatusBitSpin,Status(a1)
		move.b	#19,y_radius(a1)
		move.b	#9,x_radius(a1)
		subq.w	#5,y_pos(a1)
		bra.w	@Burst

; ===========================================================================

@display:
		jsr	ObjectMove
		tst.b	render_flags(a0)
		bpl.s	@delete
		jmp	(DisplaySprite).l

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================

Bub_Display:	; Routine 6
		lea	(Ani_Bub).l,a1
		jsr	(AnimateSprite).l
		tst.b	render_flags(a0)
		bpl.s	@delete
		jmp	(DisplaySprite).l

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================

Bub_Delete:	; Routine 8
		bra.w	DeleteObject
; ===========================================================================

Bub_BblMaker:	; Routine $A
		tst.w	bub_flags(a0)		; is a burst of bubbles ongoing?
		bne.s	@WaitForTimer		; if so, branch

		move.w	(Water_Level_1).w,d0	; get water position
		cmp.w	y_pos(a0),d0		; is bubble maker underwater?
		bcc.w	@ChkDel			; if not, branch
		tst.b	render_flags(a0)		; check if on screen
		bpl.w	@ChkDel			; if not, branch

		subq.w	#1,bub_time(a0)		; subtract from timer
		bpl.w	@animate		; branch if timer hasn't expired yet
		move.w	#1,bub_flags(a0)	; set bubble burst flag

	@TryAgain:
		jsr	(RandomNumber).l	; get Random Number on d0
		move.w	d0,d1			; store copy on d1 (unecessary and makes some values unused)
		andi.w	#7,d0			; get number from 0 to 7
		cmpi.w	#6,d0			; is random number 6 or over?
		bhs.s	@TryAgain		; if yes, branch

		move.b	d0,bub_burst(a0)	; number of bubbles to spawn per burst, 1-6
		andi.w	#$C,d1			; limit to 0, 4, 8 and 12
		lea	(Bub_BblTypes).l,a1	; get chance table
		adda.w	d1,a1			; add to address
		move.l	a1,bub_chanceTable(a0)	; store address
		subq.b	#1,bub_bigtime(a0)	; subtract from counter
		bpl.s	@NotBigYet		; if positive, branch
		move.b	bub_freq(a0),bub_bigtime(a0)	; reset this counter
		bset	#7,bub_flags(a0)		; set "possibility of breathable" bit

@NotBigYet:	; dummied routine
		bra.s	@SpawnBubble
; ===========================================================================

@WaitForTimer:
		subq.w	#1,bub_time(a0)
		bpl.w	@Animate

@SpawnBubble:
		jsr	(RandomNumber).l	; get Random Number on d0
		andi.w	#$1F,d0			; 0 - 31
		move.w	d0,bub_time(a0)		; set as timer between bubbles in this burst
		jsr	SingleObjLoad		; Find Free object slot
		bne.s	@Fail			; branch if no free slot is available

		move.b	#ObjID_BubbleMaker,0(a1)	; load bubble object
		move.w	x_pos(a0),x_pos(a1)		; get Spawner's X position
		jsr	(RandomNumber).l	; get Random Number on d0
		andi.w	#$F,d0			; 15
		subq.w	#8,d0			; subtract by 8
		add.w	d0,x_pos(a1)		; random X position between -8 to 7
		move.w	y_pos(a0),y_pos(a1)		; get Spawner's Y position
		moveq	#0,d0			; clear d0
		move.b	bub_burst(a0),d0	; get current bubble
		movea.l	bub_chanceTable(a0),a2	; get stored address
		move.b	(a2,d0.w),Subtype(a1)	; get subtype


		btst	#7,bub_flags(a0)	; check bit
		beq.s	@Fail			; if clear, branch (no big bubble is to be spawned)

		jsr	(RandomNumber).l	; get Random Number on d0
		andi.w	#3,d0			; 0 - 3
		bne.s	@ChanceToFail		; if non-zero, branch
		bset	#6,bub_flags(a0)	; set "already spawned" bit
		bne.s	@Fail			; branch if Large bubble already spawned
		move.b	#2,Subtype(a1)	; spawn Large bubble (breathable)

	@ChanceToFail:
		tst.b	bub_burst(a0)		; check current bubble
		bne.s	@Fail			; if non-zero, branch
		; failsafe, to spawn a bubble regardless of dice roll result from earlier
		bset	#6,bub_flags(a0)	; set "already spawned" bit
		bne.s	@Fail			; branch if Large bubble already spawned
		move.b	#2,Subtype(a1)	; spawn Large bubble (breathable)

	@Fail:
		subq.b	#1,bub_burst(a0)	; subtract from bubble burst counter
		bpl.s	@animate		; branch if bubbles remain to be spawned
		jsr	(RandomNumber).l	; get Random Number on d0
		andi.w	#$7F,d0			; 0 - 127
		addi.w	#$80,d0			; add 128
		add.w	d0,bub_time(a0)		; add to timer
		clr.w	bub_flags(a0)		; clear flags

@animate:
		lea	(Ani_S1Obj64).l,a1
		jsr	(AnimateSprite).l

@ChkDel:
		out_of_range	DeleteObject
		move.w	(Water_Level_1).w,d0
		cmp.w	y_pos(a0),d0
		bcs.w	DisplaySprite
		rts	
; ===========================================================================
; bubble production sequence

; 0 = small bubble, 1 =	medium

Bub_BblTypes:	;	1, 2, 3		4, 5, 6
		dc.b	0, 1, 0, 	0 ;0, 0		; 4, 5 and 6 are impossible
		dc.b	0, 0, 1, 	0 ;0, 0		; Inherits from next set
		dc.b	0, 0, 0, 	1 ;0, 1		; 4, 5 and 6 are impossible
		dc.b	0, 1, 0, 	0, 1, 0	

; ===========================================================================

Bub_ChkPlayer:
		tst.b	obj_control(a1)
		bmi.s	@NoInteract
		move.w	x_pos(a1),d0
		move.w	x_pos(a0),d1
		subi.w	#$10,d1
		cmp.w	d0,d1
		bcc.s	@NoInteract
		addi.w	#$20,d1
		cmp.w	d0,d1
		bcs.s	@NoInteract
		move.w	y_pos(a1),d0
		move.w	y_pos(a0),d1
		cmp.w	d0,d1
		bcc.s	@NoInteract
		addi.w	#$10,d1
		cmp.w	d0,d1
		bcs.s	@NoInteract
		moveq	#1,d0
		rts	
; ===========================================================================

@NoInteract:
		moveq	#0,d0
		rts	