;----------------------------------------------------
; Object 26 - monitor
;----------------------------------------------------

Obj26:					; DATA XREF: ROM:Obj_Indexo
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	@Index(pc,d0.w),d1
		jmp	@Index(pc,d1.w)
; ===========================================================================
		IndexStart
	GenerateIndex 2,Object26_Init
	GenerateIndex 2,Object26_Solid
	GenerateIndex 2,Object26_BreakOpen
	GenerateIndex 2,Object26_Animate
	GenerateIndex 2,Object26_Display
; -----
	GenerateIndex 2,Obj2E_Init
	GenerateIndex 2,Obj2E_Main
	GenerateIndex 2,Monitor_Disappear
	GenerateIndex 2,Monitor_Random
; ===========================================================================

Object26_Init:				; DATA XREF: ROM:Obj26_Indexo
		addq.b	#2,routine(a0)
		move.b	#28/2,y_radius(a0)
		move.b	#28/2,x_radius(a0)
		move.l	#Map_Monitor,mappings(a0)
		move.w	#$680,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#4,render_flags(a0)
		move.b	#3,priority(a0)
		move.b	#$F,width_pixels(a0)
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	@notBroken
		move.b	#8,routine(a0)		; Out of Range and Display only
		move.b	#$B,mapping_frame(a0)	; Broken Monitor frame
		rts
;----------------------------------------------------

	@notBroken:				
		move.b	#$46,collision_flags(a0)
		move.b	subtype(a0),anim(a0)

Object26_Solid:	; Routine 2
		move.b	routine_secondary(a0),d0	; Is player on top of Platform
		beq.s	@Normal				; If not, branch
		subq.b	#2,d0				; Check if it should fall
		bne.s	@Fall				; Make monitor fall

		; 2nd Routine 2
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		addi.w	#22/2,d1
		bsr.w	MonitorPlatformTopCheckPlayer	; check if player has left the monitor
		btst	#PlayerStatusBitOnObject,status(a1)
		bne.w	@OnTop
		clr.b	routine_secondary(a0)
		bra.w	Object26_Animate
;----------------------------------------------------

	@OnTop:	
		move.w	#$10,d3
		move.w	x_pos(a0),d2
		bsr.w	MvSonicOnPtfm
		bra.w	Object26_Animate
;----------------------------------------------------

	@Fall:		; 2nd Routine 4
		bsr.w	ObjectMoveAndFall
		jsr	(ObjHitFloor).l
		tst.w	d1
		bpl.w	Object26_Animate
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)
		clr.b	routine_secondary(a0)
		bra.w	Object26_Animate
;----------------------------------------------------

@Normal:		; 2nd Routine 0		; CODE XREF: ROM:0000AEDAj
		move.w	#26,d1
		move.w	#30/2,d2
		bsr.w	Obj26_SolidSides
		beq.w	loc_AFA0
		tst.w	y_vel(a1)	; check if player's moving up
		bmi.s	@MovingUpward
		cmpi.b	#2,anim(a1)	; rolling
		beq.s	loc_AFA0

@MovingUpward:	
		tst.w	d1
		bpl.s	loc_AF64
		sub.w	d3,y_pos(a1)
		; WARNING : Monitor never sets d6 prior to this point, meaning the "P1 standing on object" bit never gets set correctly
		; because of it, if you land on a monitor without rolling, you can corrupt the status bitfield with a random value at d6
		; most notably, causing the monitor to flip horizontally / vertically.
		; This was fixed in the final
		bsr.w	RideObject_SetRide	
		; lmao we're not fixing it tho
		move.b	#2,routine_secondary(a0)
		bra.w	Object26_Animate
;----------------------------------------------------
loc_AF64:
		tst.w	d0
		beq.w	loc_AF8A
		bmi.s	loc_AF74
		tst.w	x_vel(a1)
		bmi.s	loc_AF8A
		bra.s	loc_AF7A
;----------------------------------------------------
loc_AF74:
		tst.w	x_vel(a1)
		bpl.s	loc_AF8A

loc_AF7A:
		sub.w	d0,x_pos(a1)
		move.w	#0,ground_speed(a1)
		move.w	#0,x_vel(a1)

loc_AF8A:	
		btst	#1,status(a1)
		bne.s	loc_AFAE
		bset	#5,status(a1)
		bset	#5,status(a0)
		bra.s	Object26_Animate
;----------------------------------------------------
loc_AFA0:	
		btst	#StatusBitP1Push,status(a0)
		beq.s	Object26_Animate
		move.w	#1,anim(a1)	; set player animation to walking

loc_AFAE:
		bclr	#StatusBitP1Push,status(a0)
		bclr	#PlayerStatusBitPush,status(a1)
;----------------------------------------------------
Object26_Animate:
		lea	(Ani_obj26).l,a1
		bsr.w	AnimateSprite

Object26_Display:
		out_of_range	DeleteObject
		bra.w	DisplaySprite
;----------------------------------------------------

Object26_BreakOpen:
		addq.b	#2,routine(a0)
		move.b	#0,collision_flags(a0)
		jsr	SingleObjLoad
		bne.s	@FailContentSpawn
		move.b	#ObjID_Monitor,id(a1)
		move.b	#$A,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	anim(a0),anim(a1)

	@FailContentSpawn:
		jsr	SingleObjLoad
		bne.s	@FailExplosionSpawn
		move.b	#ObjID_Explosion,id(a1)
		addq.b	#2,routine(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)

	@FailExplosionSpawn:
		lea	(Object_Respawn_Table).w,a2
		moveq	#0,d0
		move.b	respawn_index(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#10,anim(a0)
		bra.w	DisplaySprite
;----------------------------------------------------
; Object 2E - monitor contents (code for power-up behavior and rising image)
;----------------------------------------------------
Obj2E_Init:	
		addq.b	#2,routine(a0)
		move.w	#$680,art_tile(a0)
		bsr.w	Adjust2PArtPointer
		move.b	#$24,render_flags(a0)
		move.b	#3,priority(a0)
		move.b	#8,width_pixels(a0)
		move.w	#-$300,y_vel(a0)
		moveq	#0,d0
		move.b	anim(a0),d0
		bne.s	@NotRandom
			addq.b	#4,routine(a0)
		@NotRandom:
		addq.b	#1,d0
		move.b	d0,mapping_frame(a0)
		movea.l	#Map_Monitor,a1
		add.b	d0,d0
		adda.w	(a1,d0.w),a1
		addq.w	#2,a1
		move.l	a1,mappings(a0)
;----------------------------------------------------		
Obj2E_Main:	
		tst.w	y_vel(a0)
		bpl.w	Monitor_GiveContent
		bsr.w	ObjectMove
		addi.w	#$18,y_vel(a0)
		bra.w	DisplaySprite
; ===========================================================================
Monitor_Random:	
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
	GenerateIndex	2, Monitor, SonicLife
	GenerateIndex	2, Monitor, Tails
	GenerateIndex	2, Monitor, Eggman
	GenerateIndex	2, Monitor, Rigns
	GenerateIndex	2, Monitor, Shoes
	GenerateIndex	2, Monitor, Boomer
	GenerateIndex	2, Monitor, Invincibility
	GenerateIndex	2, Monitor, Tammy
	GenerateIndex	2, Monitor, Hops
; ===========================================================================
Monitor_Eggman:
		move.l	a0,-(sp)
		lea	MainCharacter,a0
		jsr	HurtSonic
		move.l	(sp)+,a0
		rts
; ===========================================================================
Monitor_Tails:	

; ===========================================================================
Monitor_Tammy:	

; ===========================================================================
Monitor_Hops:	

; ===========================================================================
Monitor_Boomer:	
		move.b	#1,($FFFFFE2C).w
		move.b	#$38,(MainCharacter+$180).w
		move.w	#$AF,d0
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
		cmpi.w	#$64,(Ring_count).w ; 'd'
		bcs.s	loc_B130
		bset	#1,($FFFFFE1B).w
		beq.w	Monitor_SonicLife
		cmpi.w	#$C8,(Ring_count).w ; 'È'
		bcs.s	loc_B130
		bset	#2,($FFFFFE1B).w
		beq.w	Monitor_SonicLife

loc_B130:	
		move.w	#$B5,d0
		jmp	(PlaySound).l
; ===========================================================================

Monitor_Shoes:	
		move.b	#1,($FFFFFE2E).w
		move.w	#$4B0,(MainCharacter+speedshoes_time).w
		move.w	#$C00,(Sonic_top_speed).w
		move.w	#$18,(Sonic_acceleration).w
		move.w	#$80,(Sonic_deceleration).w
		move.w	#$E2,d0
		jmp	(PlaySound).l
; ===========================================================================

Monitor_Invincibility:			; DATA XREF: ROM:0000B0D4o
		move.b	#1,($FFFFFE2D).w
		move.w	#$4B0,(MainCharacter+invincibility_time).w
		move.b	#$38,(Object_Space+$200).w
		move.b	#1*4,(Object_Space+$200+anim).w
		move.b	#$38,(Object_Space+$240).w
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
Monitor_Disappear:	
		subq.w	#1,anim_frame_duration(a0)
		bmi.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================


Obj26_SolidSides:			; CODE XREF: ROM:0000AF38p
		lea	(MainCharacter).w,a1
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_B20E
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_B20E
		move.b	y_radius(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	y_pos(a1),d3
		sub.w	y_pos(a0),d3
		add.w	d2,d3
		bmi.s	loc_B20E
		add.w	d2,d2
		cmp.w	d2,d3
		bcc.s	loc_B20E
		tst.b	obj_control(a1)	; lock multi
		bmi.s	loc_B20E
		cmpi.b	#6,(MainCharacter+routine).w	; check if player is dead
		bcc.s	loc_B20E
		tst.w	(Debug_placement_mode).w
		bne.s	loc_B20E
		cmp.w	d0,d1
		bcc.s	loc_B204
		add.w	d1,d1
		sub.w	d1,d0

loc_B204:	
		cmpi.w	#16,d3
		bcs.s	loc_B212

loc_B20A:	
		moveq	#1,d1
		rts
; ===========================================================================
loc_B20E:	
		moveq	#0,d1
		rts
; ===========================================================================

loc_B212:	
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	x_pos(a1),d1
		sub.w	x_pos(a0),d1
		bmi.s	loc_B20A
		cmp.w	d2,d1
		bcc.s	loc_B20A
		moveq	#-1,d1
		rts
; End of function Obj26_SolidSides

