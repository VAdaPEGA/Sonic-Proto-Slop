c		=	0
		rept	ZoneCount
_temp	equs	_ZoneFolder\#c
	; Act 1
	if	(filesize("\_temp\Data/SizeTopLeft_1.bin")=-1)
		dc.w	$0000
		else
		incbin	"\_temp\Data/SizeTopLeft_1.bin", 0, 2
		even
	endif
	if	(filesize("\_temp\Data/SizeBottomRight_1.bin")=-1)
		dc.w	$3FFF
		else
		incbin	"\_temp\Data/SizeBottomRight_1.bin", 0, 2
		even
	endif
	if	(filesize("\_temp\VWrap1.asm")=-1)
		if	(filesize("\_temp\Data/SizeTopLeft_1.bin")=-1)
			dc.w	$0000
			else
			incbin	"\_temp\Data/SizeTopLeft_1.bin", 2, 2
			even
		endif
	else
		dc.w	-$1000
	endif
	if	(filesize("\_temp\Data/SizeBottomRight_1.bin")=-1)
		dc.w	$0720
		else
		incbin	"\_temp\Data/SizeBottomRight_1.bin", 2, 2
		even
	endif
	; Act 2
	if	(filesize("\_temp\Data/SizeTopLeft_2.bin")=-1)
		dc.w	$0000
		else
		incbin	"\_temp\Data/SizeTopLeft_2.bin", 0, 2
		even
	endif
	if	(filesize("\_temp\Data/SizeBottomRight_2.bin")=-1)
		dc.w	$3FFF
		else
		incbin	"\_temp\Data/SizeBottomRight_2.bin", 0, 2
		even
	endif
	if	(filesize("\_temp\VWrap2.asm")=-1)
		if	(filesize("\_temp\Data/SizeTopLeft_2.bin")=-1)
			dc.w	$0000
			else
			incbin	"\_temp\Data/SizeTopLeft_2.bin", 2, 2
			even
		endif
	else
		dc.w	-$1000
	endif
	if	(filesize("\_temp\Data/SizeBottomRight_2.bin")=-1)
		dc.w	$0720
		else
		incbin	"\_temp\Data/SizeBottomRight_2.bin", 2, 2
		even
	endif
	; Act 3
	if	(filesize("\_temp\Data/SizeTopLeft_3.bin")=-1)
		dc.w	$0000
		else
		incbin	"\_temp\Data/SizeTopLeft_3.bin", 0, 2
		even
	endif
	if	(filesize("\_temp\Data/SizeBottomRight_3.bin")=-1)
		dc.w	$3FFF
		else
		incbin	"\_temp\Data/SizeBottomRight_3.bin", 0, 2
		even
	endif
	if	(filesize("\_temp\VWrap3.asm")=-1)
		if	(filesize("\_temp\Data/SizeTopLeft_3.bin")=-1)
			dc.w	$0000
			else
			incbin	"\_temp\Data/SizeTopLeft_3.bin", 2, 2
			even
		endif
	else
		dc.w	-$1000
	endif
	if	(filesize("\_temp\Data/SizeBottomRight_3.bin")=-1)
		dc.w	$0720
		else
		incbin	"\_temp\Data/SizeBottomRight_3.bin", 2, 2
		even
	endif
	; Boss Act
	if	(filesize("\_temp\Data/SizeTopLeft_Boss.bin")=-1)
		dc.w	$0000
		else
		incbin	"\_temp\Data/SizeTopLeft_Boss.bin", 0, 2
		even
	endif
	if	(filesize("\_temp\Data/SizeBottomRight_Boss.bin")=-1)
		dc.w	$3FFF
		else
		incbin	"\_temp\Data/SizeBottomRight_Boss.bin", 0, 2
		even
	endif
	if	(filesize("\_temp\VWrapBoss.asm")=-1)
		if	(filesize("\_temp\Data/SizeTopLeft_Boss.bin")=-1)
			dc.w	$0000
			else
			incbin	"\_temp\Data/SizeTopLeft_Boss.bin", 2, 2
			even
		endif
	else
		dc.w	-$1000
	endif
	if	(filesize("\_temp\Data/SizeBottomRight_Boss.bin")=-1)
		dc.w	$0720
		else
		incbin	"\_temp\Data/SizeBottomRight_Boss.bin", 2, 2
		even
	endif

c		=	c+1
		endr