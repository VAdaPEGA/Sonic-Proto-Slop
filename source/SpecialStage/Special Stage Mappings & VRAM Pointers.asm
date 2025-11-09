; ---------------------------------------------------------------------------
; Special stage	mappings and VRAM pointers
; ---------------------------------------------------------------------------
SS_Mappings	macro	Map, Frame, VRAM, priority, pal, flipx, flipy, name
		dc.l	Map+(frame<<24)
		dc.w	((priority<<15)+(pal<<13)++(flipy<<12)+(flipx<<11)+VRAM)
		if	(narg=8)
SSBlockID_\name:	equ	c
		endif
c	=	c+1
		endm
	; First 36(9*4) blocks are just walls of different colours
	dc.l	Map_SSWalls
	dc.w	(2840/$20)
	dc.w	(2840/$20)+(1<<13)
	dc.w	(2840/$20)+(2<<13)
	dc.w	(2840/$20)+(3<<13)

c	=	(9*4)+1

	; 		Mappings,	Frame,	VRAM,	Pri,Pal,Flipx, y, ID	
	SS_Mappings	Map_SS_Bump,	0,	$023B,	0,   0,     0, 0, Bumper	; $25 (Bumper)
	SS_Mappings	Map_SS_R,	0,	$0570,	0,   1,     0, 0, W		; $26 (W)
	SS_Mappings	Map_SS_R,	0,	$0251,	0,   0,     0, 0, Goal		; $27
	SS_Mappings	Map_SS_R,	0,	$0370,	0,   0,     0, 0, 1up		; $28
	SS_Mappings	Map_SS_Up,	0,	$0263,	0,   0,     0, 0, Up		; $29
	SS_Mappings	Map_SS_Down,	0,	$0263,	0,   0,     0, 0, Down		; $2A
	SS_Mappings	Map_SS_R,	0,	$02F0,	0,   1,     0, 0, Rotate	; $2B
	SS_Mappings	Map_SS_Glass,	0,	$0470,	0,   0,     0, 0, Peppermint	; $2C
	SS_Mappings	Map_SS_Glass,	0,	$05F0,	0,   0,     0, 0, Glass		; $2D
	SS_Mappings	Map_SS_Glass,	0,	$05F0,	0,   3,     0, 0 		; $2E
	SS_Mappings	Map_SS_Glass,	0,	$05F0,	0,   1,     0, 0		; $2F
	SS_Mappings	Map_SS_Glass,	0,	$05F0,	0,   2,     0, 0		; $30
	SS_Mappings	Map_SS_R,	0,	$02F0,	0,   0,     0, 0, 		; $31
	SS_Mappings	Map_SS_Bump,	1,	$023B,	0,   0,     0, 0		; $32
	SS_Mappings	Map_SS_Bump,	2,	$023B,	0,   0,     0, 0		; $33
	SS_Mappings	Map_SS_R,	0,	$0797,	0,   0,     0, 0		; $34 unused
	SS_Mappings	Map_SS_R,	0,	$07A0,	0,   0,     0, 0		; $35 L
	SS_Mappings	Map_SS_R,	0,	$07A9,	0,   0,     0, 0		; $36 unused
	SS_Mappings	Map_SS_R,	0,	$0797,	0,   0,     0, 0		; $37 unused
	SS_Mappings	Map_SS_R,	0,	$07A0,	0,   0,     0, 1		; $38 L but upside-down
	SS_Mappings	Map_SS_R,	0,	$07A9,	0,   0,     0, 0		; $39 unused
	SS_Mappings	Map_Ring,	0,	$07B2,	0,   1,     0, 0, Ring		; $3A
	SS_Mappings	Map_SS_Chaos,	0,	$0770,	0,   3,     0, 0, Emerald	; $3B (Emerald)	
	SS_Mappings	Map_SS_Chaos,	0,	$0770,	0,   1,     0, 0		; $3C (Gold)
	SS_Mappings	Map_SS_Chaos,	0,	$0770,	0,   0,     0, 0		; $3D (Lapis)
	SS_Mappings	Map_SS_Chaos,	0,	$0770,	0,   0,     0, 0		; $3E (Redstone)		
	SS_Mappings	Map_SS_Chaos,	0,	$0770,	0,   1,     0, 0		; $3F (Diamond)	
	SS_Mappings	Map_SS_Chaos,	0,	$0770,	0,   0,     0, 0		; $40 (Quarz)	
	SS_Mappings	Map_SS_R,	0,	$04F0,	0,   0,     0, 0, Ghost		; $41
	SS_Mappings	Map_Ring,	4,	$07B2,	0,   1,     0, 0		; $42
	SS_Mappings	Map_Ring,	5,	$07B2,	0,   1,     0, 0		; $43
	SS_Mappings	Map_Ring,	6,	$07B2,	0,   1,     0, 0		; $44
	SS_Mappings	Map_Ring,	7,	$07B2,	0,   1,     0, 0		; $45
	SS_Mappings	Map_SS_Glass,	0,	$03F0,	0,   1,     0, 0		; $46
	SS_Mappings	Map_SS_Glass,	1,	$03F0,	0,   1,     0, 0		; $47
	SS_Mappings	Map_SS_Glass,	2,	$03F0,	0,   1,     0, 0		; $48
	SS_Mappings	Map_SS_Glass,	3,	$03F0,	0,   1,     0, 0		; $49
	SS_Mappings	Map_SS_R,	2,	$04F0,	0,   0,     0, 0, GhostTrigger	; $4A
	SS_Mappings	Map_SS_Glass,	0,	$05F0,	0,   0,     0, 0		; $4B
	SS_Mappings	Map_SS_Glass,	0,	$05F0,	0,   3,     0, 0		; $4C
	SS_Mappings	Map_SS_Glass,	0,	$05F0,	0,   1,     0, 0		; $4D
	SS_Mappings	Map_SS_Glass,	0,	$05F0,	0,   2,     0, 0		; $4E

SSBlockID_Last	equ	c