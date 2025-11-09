; ---
; Player Mappings

		include	"Objects/_Player/Animation Sonic.asm"
		include	"Objects/_Player/Animation Tails.asm"

Map_Sonic:	incbin	"Objects/_Player/Sonic.SprMap"
Map_Tails:	incbin	"Objects/_Player/Tails.SprMap"

SonicDynPLC:	incbin	"Objects/_Player/Sonic.DPLC"
		even
TailsDynPLC:	incbin	"Objects/_Player/Tails.DPLC"
		even

Art_Sonic:	incbin	"Objects/_Player/Sonic.Artunc"
Art_Tails:	incbin	"Objects/_Player/Tails.Artunc"
		even