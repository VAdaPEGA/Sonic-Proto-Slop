ExplosionObjectData:
	dc.l	Map_Explosion
c	=	0
@macro	macro	VRAM, Frames, delay, width, priority, sound
	dc.w	VRAM
	dc.b	c,	Frames
	dc.b	delay,	Sound
	dc.b	width,	priority
c	=	c+Frames
	endm
	;	VRAM,	Frames,	delay,	width,	priority,sound
	@macro	$05A0,	0,	7,	$C,	1,	$C1	; Regular explosion
	@macro	$05A0,	5,	7,	$C,	1,	$C4	; Boss explosion
	@macro	$041C,	4,	9,	$C,	1,	$A5	; Buzz Bomber missile explosion