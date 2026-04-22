;----------------------------------------------------
; Object 26 - monitor
;----------------------------------------------------
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	@Index(pc,d0.w),d1
	jsr	@Index(pc,d1.w)
	bra.w	DisplaySprite
; ===========================================================================
		IndexStart
	GenerateIndexID	Monitor, Init
	GenerateIndexID	Monitor, Solid
	GenerateIndexID	Monitor, BreakOpen
	GenerateIndexID	Monitor, Animate
	GenerateIndexID	Monitor, Display
; -----
	GenerateIndexID	Monitor, ContentMoveUp
	GenerateIndex	Monitor, ContentDisappear
	GenerateIndex	Monitor, ContentRandom
; ===========================================================================
Monitor_Init:	
	addq.b	#MonitorID_Solid,routine(a0)
	move.b	#28/2,y_radius(a0)
	move.b	#28/2,x_radius(a0)
	move.l	#Map_Monitor,mappings(a0)
	move.w	#$680,art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	move.b	#30/2,width_pixels(a0)

	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	bclr	#7,2(a2,d0.w)		; clear respawn flag (so it can respawn)
	btst	#0,2(a2,d0.w)		; check saved bit
	beq.s	@notBroken
		addq.b	#MonitorID_Animate-MonitorID_Solid,routine(a0)	; Animate Breaking Monitor
		tst.b	anim(a0)
		bne	Monitor_Animate
			move.b	#$B,mapping_frame(a0)	; If it's not meant to animate, use Broken Monitor frame
			addq.b	#MonitorID_Display-MonitorID_Animate,routine(a0)	; Out of Range and Display only
			rts
;----------------------------------------------------
	@notBroken:				
	move.b	#$46,collision_flags(a0)
	move.b	subtype(a0),anim(a0)
; ===========================================================================
Monitor_Solid:	; Routine 2
	move.b	routine_secondary(a0),d0	; Is player on top of Platform
	beq.s	@Normal				; If not, branch
		subq.b	#2,d0				; Check if it should fall
		bne.s	@Fall				; Make monitor fall
			;----------------------------------------------------
			; 2nd Routine 2 : Player is on top of monitor, walking
			moveq	#0,d1	
			move.b	width_pixels(a0),d1
			addi.w	#22/2,d1
			bsr.w	MonitorPlatformTopCheckPlayer	; check if player has left the monitor
			btst	#BitPlayerStatusOnObject,status(a1)
			bne.w	@OnTop
				clr.b	routine_secondary(a0)
				bra.w	Monitor_Animate
			@OnTop:	
			move.w	#32/2,d3
			move.w	x_pos(a0),d2
			bsr.w	MvSonicOnPtfm
			bra.w	Monitor_Animate
			;----------------------------------------------------
		@Fall:	; 2nd Routine 4 : Monitor is set to fall
		bsr.w	ObjectMoveAndFall
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.w	Monitor_Animate
			add.w	d1,y_pos(a0)
			clr.w	y_vel(a0)
			clr.b	routine_secondary(a0)
			bra.w	Monitor_Animate
			;----------------------------------------------------
	@Normal:	; 2nd Routine 0	: Monitor checks for player collision
		move.w	#(30+18+4)/2,d1		; Monitor Width + Player Width + something?
		move.w	#30/2,d2		; Monitor Height
		bsr.w	Monitor_SolidSides	; Check solid collision of monitor
		beq.w	@NoCollision		; If not touching, exit
			tst.w	y_vel(a1)	; check if player's moving up
			bmi.s	@MovingUpward
				cmpi.b	#2,anim(a1)	; rolling
				beq.s	@NoCollision
			@MovingUpward:	
			tst.w	d1
			bpl.s	@PlayerIsToBePushed
				sub.w	d3,y_pos(a1)	; offset player to the top of monitor
	; WARNING : Monitor never sets d6 prior to this point, meaning the "P1 standing on object" bit never gets set correctly
	; because of it, if you land on a monitor without rolling, you can corrupt the status bitfield with a random value at d6
	; most notably, causing the monitor to flip horizontally / vertically.
	; This was fixed in the final
				bsr.w	RideObject_SetRide	
	; lmao we're not fixing it tho
				move.b	#2,routine_secondary(a0)
				bra.w	Monitor_Animate
;----------------------------------------------------
@PlayerIsToBePushed:	
	tst.w	d0	; check distance
	beq.w	@PlayerIsPushing
	bmi.s	@PlayerToTheRight
		tst.w	x_vel(a1)	; is player moving?
		bmi.s	@PlayerIsPushing	; if moving left, branch
		bra.s	@MovePlayerAway		; if right, branch here
;----------------------------------------------------
@PlayerToTheRight:
	tst.w	x_vel(a1)
	; The player is able to stand inside the monitor if they don't move left
	; this can be fixed by adding the following line:
	; beq.s	@MovePlayerAway
	bpl.s	@PlayerIsPushing
@MovePlayerAway:	
		sub.w	d0,x_pos(a1)	
		move.w	#0,ground_speed(a1)	
		move.w	#0,x_vel(a1)
@PlayerIsPushing:	
		btst	#BitPlayerStatusAir,status(a1)
		bne.s	@OnlyClearPush
			bset	#BitStatusP1Push,status(a0)
			bset	#BitPlayerStatusPush,status(a1)
			bra.s	Monitor_Animate
;----------------------------------------------------
@NoCollision:	
	btst	#BitStatusP1Push,status(a0)
	beq.s	Monitor_Animate			; Branch if player wasn't pushing
		move.w	#1,anim(a1)	; set player animation to "walking" (this is part of the cause for the "jump walk" bug)
@OnlyClearPush:	bclr	#BitStatusP1Push,status(a0)
		bclr	#BitPlayerStatusPush,status(a1)
;----------------------------------------------------
Monitor_Animate:
	lea	(Ani_Monitor).l,a1
	bsr.w	AnimateSprite
; ===========================================================================
Monitor_Display:
	out_of_range	DeleteObject
	rts
; ===========================================================================
Monitor_ContentDisappear:	
	subq.w	#1,anim_frame_duration(a0)
	bmi.w	DeleteObject
		rts
; ===========================================================================
Monitor_BreakOpen:
	; Attempt to spawn explosion
	jsr	SingleObjLoad
	bne.s	@FailSpawn
		move.b	#ObjID_Explosion,id(a1)
		addq.b	#2,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		sub.w	#8,y_pos(a1)
		; Attempt to spawn Breaking monitor anim
		jsr	SingleNextObjLoad	; The reason it's "SingleNext" instead of the previous
		bne.s	@FailSpawn		; is to keep it from blinking for a single frame
		; You see, when you fetch for any empty slot, it can be one before this object
		; meaning the code for displaying the sprite will be too late, it needs to be
		; an object who's located AFTER this one in RAM so it can be executed on the same frame
			move.b	#ObjID_Monitor,id(a1)
			move.w	x_pos(a0),x_pos(a1)
			move.w	y_pos(a0),y_pos(a1)
			move.b	respawn_index(a0),respawn_index(a1)
			move.b	#10,anim(a1)

	@FailSpawn:
	; monitor contents (code for power-up behavior and rising image)
	addq.b	#MonitorID_ContentMoveUp-MonitorID_BreakOpen,routine(a0)
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	d0,collision_flags(a0)	; make sure collision is turned off
	move.b	respawn_index(a0),d0
	bset	#0,2(a2,d0.w)

	move.b	#$24,render_flags(a0)	; $20 = single sprite piece render
	move.b	#3,priority(a0)
	move.b	#8,width_pixels(a0)
	move.w	#-$300,y_vel(a0)
	move.b	anim(a0),d0
	bne.s	@NotRandom
		addq.b	#4,routine(a0)
	@NotRandom:
	addq.b	#1,d0
	move.b	d0,mapping_frame(a0)
	move.l	mappings(a0),a1
	add.b	d0,d0
	adda.w	(a1,d0.w),a1
	addq.w	#2,a1	; skip first two bytes
	move.l	a1,mappings(a0)
; ===========================================================================	
Monitor_ContentMoveUp:	
	tst.w	y_vel(a0)
	bpl.w	Monitor_GiveContent
		bsr.w	ObjectMove
		addi.w	#$18,y_vel(a0)
		rts
; ===========================================================================
Monitor_ContentRandom:	
	move.w	#$E0,d0	; Mess with Jeff
	jmp	(PlaySound).l
; ===========================================================================
Monitor_GiveContent:	
	addq.b	#2,routine(a0)
	move.w	#$1D,anim_frame_duration(a0)
	moveq	#0,d0
	move.b	anim(a0),d0
	add.w	d0,d0
	move.w	Monitor_Subroutines-2(pc,d0.w),d0
	jmp	Monitor_Subroutines(pc,d0.w)
; ===========================================================================
	IndexStart	Monitor_Subroutines
	GenerateIndex	 Monitor, SonicLife
	GenerateIndex	 Monitor, Tails
	GenerateIndex	 Monitor, Eggman
	GenerateIndex	 Monitor, Rigns
	GenerateIndex	 Monitor, Shoes
	GenerateIndex	 Monitor, Boomer
	GenerateIndex	 Monitor, Invincibility
	GenerateIndex	 Monitor, Tammy
	GenerateIndex	 Monitor, Hops
; ===========================================================================
Monitor_Eggman:
	move.l	a0,-(sp)
	lea	MainCharacter,a0
	jsr	HurtSonic
	move.l	(sp)+,a0
	rts
; ===========================================================================
Monitor_Tails:
	moveq	#16*2,d0
	bra.s	MonitorCharPlaySnd
; ===========================================================================
Monitor_Tammy:
	moveq	#16*4,d0
	bra.s	MonitorCharPlaySnd
; ===========================================================================
Monitor_Hops:
	moveq	#16*3,d0
	bra.s	MonitorCharPlaySnd
; ===========================================================================
Monitor_Boomer:	
	moveq	#16,d0
MonitorCharPlaySnd:
	move.b	d0,(MainCharacter+Character).w
	move.b	#$AF,d0
	jmp	(PlaySound).l
; ===========================================================================
Monitor_SonicLife:
	addq.b	#1,(Life_count).w
	addq.b	#1,(Update_HUD_lives).w
	move.w	#MusID_ExtraLife,d0
	jmp	(PlaySound).l
; ===========================================================================

Monitor_Rigns:	
	addi.w	#$A,(Ring_count).w
	ori.b	#1,(Update_HUD_rings).w
	cmpi.w	#100,(Ring_count).w
	bcs.s	loc_B130
		bset	#1,($FFFFFE1B).w
		beq.w	Monitor_SonicLife
			cmpi.w	#200,(Ring_count).w
			bcs.s	loc_B130
				bset	#2,($FFFFFE1B).w
				beq.w	Monitor_SonicLife
loc_B130:	
	move.w	#$B5,d0
	jmp	(PlaySound).l
; ===========================================================================

Monitor_Shoes:	
	move.w	#$4B0,(MainCharacter+speedshoes_time).w
	move.w	#$E2,d0
	jmp	(PlaySound).l
; ===========================================================================

Monitor_Invincibility:	
	move.w	#$4B0+60,(MainCharacter+invincibility_time).w
	move.b	#ObjID_Invincibility,(Object_Space+$200).w
	move.b	#1*4,(Object_Space+$200+anim).w
	move.b	#ObjID_Invincibility,(Object_Space+$240).w
	move.b	#2*4,(Object_Space+$240+anim).w
	tst.b	($FFFFF7AA).w
	bne.s	@NoMusic
		cmpi.w	#$C,($FFFFFE14).w
		bls.s	@NoMusic
			move.w	#MusID_Invincible,d0
			jmp	(PlaySound).l
	@NoMusic:
	rts
; ===========================================================================
; Routine to handle only side collision of a given object (note : only handles Player 1)
; input:
;	d1 = (Width + Player Width) / 2
;	d2 = Height / 2
; output:
;	d0 = distance between objects horizontally relative to their hitboxes
;	d1 = 0 if no collision | 1 if player is bellow | -1 if player is above
;	d2 = trash
;	d3 = distance between objects vertically relative to their bottom
; *checks S1 disassembly*
; I'M SO MAD, HOW AM I THE ONLY ONE WHO'S ATTEMPTED TO DOCUMENT THIS??? FHNUIPFESFFEHIFOA
; ===========================================================================
Monitor_SolidSides:
	lea	(MainCharacter).w,a1
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0	; relative distance between both objects
	add.w	d1,d0
	bmi.s	@NoCollision	; if negative, player is to the very left and not touching
		; curiously, it doesn't account for the player's width (unlike height), opting to bake it into d1
		; likely a small optimization since the player's hitbox never changes horizontally
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	@NoCollision	; branch if too far to the right
			move.b	y_radius(a1),d3	; get player's height
			ext.w	d3
			add.w	d3,d2
			move.w	y_pos(a1),d3
			sub.w	y_pos(a0),d3
			add.w	d2,d3
			bmi.s	@NoCollision	; branch if too high to count
				add.w	d2,d2
				cmp.w	d2,d3
				bhs.s	@NoCollision	; branch if too low to count
					tst.b	obj_control(a1)	; lock multi
					bmi.s	@NoCollision
						cmpi.b	#6,(MainCharacter+routine).w	; check if player has perished
						bhs.s	@NoCollision
							tst.w	(Debug_placement_mode).w
							bne.s	@NoCollision
								cmp.w	d0,d1	; is hitbox 
								bhs.s	@PlayerToTheRight
									add.w	d1,d1
									sub.w	d1,d0	; subtract, player is to the left
								@PlayerToTheRight:	
								cmpi.w	#16,d3	; OOF, HARDCODED NUMBER (half of monitor if I had to guess)
								blo.s	@PlayerAtTop	; branch if player's bottom is above roughly half the height
								@PlayerNotInside:
									moveq	#1,d1
									rts
	@NoCollision:	
	moveq	#0,d1
	rts
								@PlayerAtTop:	
								moveq	#0,d1
								move.b	width_pixels(a0),d1
								addq.w	#4,d1
								move.w	d1,d2
								add.w	d2,d2
								add.w	x_pos(a1),d1
								sub.w	x_pos(a0),d1
								bmi.s	@PlayerNotInside
									cmp.w	d2,d1
									bhs.s	@PlayerNotInside
										moveq	#-1,d1
										rts
; End of function Monitor_SolidSides
; ===========================================================================