; ===========================================================================
; Smashable Objects such as the HPZ Diamond
SmBlock_Width		= $30		; (2 bytes)	Width
SmBlock_PlayerAniSave	= $32		; (1 byte)	Player's current animation number
SmBlock_Speeds		= $34		; (2 bytes)	Speed Table (and pieces)
; ===========================================================================
		tst.b	routine(a0)
		bmi	@FallingPiece	; Falling Pieces if negative
		beq	SmBlock_Init	; Normal
;----------------------------------------------------
	@Display:
		move.b	(MainCharacter+Anim).w,SmBlock_PlayerAniSave(a0) ; store animation number
		move.w	SmBlock_Width(a0),d1	; Width
		move.w	y_radius(a0),d2		; Height
		move.w	d2,d3
		move.w	x_pos(a0),d4
		jsr	SolidObject
		btst	#StatusBitP1Stand,status(a0)	; has Player landed on the block?
		bne.s	@smash				; if yes, branch

		out_of_range	DeleteObject
	@notspinning:
		bra.w	DisplaySprite
;----------------------------------------------------
	@smash:
		lea	MainCharacter,a1
		cmpi.b	#SonicAniID_Roll,SmBlock_PlayerAniSave(a0) ; is Player rolling/jumping?
		bne.s	@notspinning	; if not, branch

		bset	#PlayerStatusBitSpin,status(a1)
		move.b	#$E,y_radius(a1)
		move.b	#7,x_radius(a1)
		move.b	#SonicAniID_Roll,anim(a1)	; make Player roll
		move.w	#-$300,y_vel(a1)		; rebound Player
		bset	#PlayerStatusBitAir,status(a1)
		bclr	#PlayerStatusBitOnObject,status(a1)

		bclr	#StatusBitP1Stand,status(a0)
		move.b	#1,mapping_frame(a0)
		move.l	SmBlock_Speeds(a0),a4	; load broken fragment speed data
		move.w	(a4)+,d1	; set number of	fragments
		move.w	#$38,d2
		st	routine(a0)
		bsr.w	SmashObject	; Present in "Objects\BreakableWall"
	@FallingPiece:
		bsr.w	ObjectMoveAndFall
		tst.b	render_flags(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
SmBlock_Init:
		addq.b	#2,routine(a0)
		move.b	#4,render_flags(a0)
		move.b	#4,priority(a0)

		move.b	subtype(a0),d0
		move.b	d0,Mapping_Frame(a0)
		lsl.w	#2,d0	; multiply by 4

		lea	DecorationSolid_Data,a1
		move.l	(a1)+,mappings(a0)
		add.l	d0,a1
		move.w	(a1)+,art_tile(a0)
		move.b	(a1)+,SmBlock_Width+1(a0)
		move.b	(a1)+,y_radius+1(a0)
		move.b	(a1),width_pixels(a0)
		move.l	(a1),SmBlock_Speeds(a0)
		bra.w	Adjust2PArtPointer
; ===========================================================================
