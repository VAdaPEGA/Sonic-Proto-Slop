Main	section	org(0)
	incbin	"Art/Logo.MapUnc",0		;$C000 
	dcb.b	$1000-offset(*), -1
	incbin	"Art/Logo.ArtUnc"		;$D000
	dc.b	"Oh boy, padding time!"
	dcb.b	(($F560-$C000)-offset(*)), 0
	incbin	"Art/Common.ArtUnc"		;$F560
	dc.b	"And lots more here too!"
	dcb.b	(($10000-$40-$C000)-offset(*)), 0
	incbin	"Art/HitboxViewer.ArtUnc"	; last 2 tiles
	END