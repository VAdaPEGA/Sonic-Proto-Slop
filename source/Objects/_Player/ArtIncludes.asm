; ---
; Player Mappings

		include	"Objects/_Player/Animation Sonic.asm"
		include	"Objects/_Player/Animation Tails.asm"
		include	"Objects/_Player/Animation Boom.asm"
		include	"Objects/_Player/Animation Hops.asm"
		include	"Objects/_Player/Animation Tammy.asm"
; ---
Map_Sonic:	incbin	"Objects/_Player/ArtData/Sonic.SprMap"
		even
Map_Tails:	incbin	"Objects/_Player/ArtData/Tails.SprMap"
		even
	; These are asm files, not binary
	; I'm sure this'll be a headache for someone, sorry bout that
		include	"Objects/_Player/ArtData/Boom.SprMap"
		even
		include	"Objects/_Player/ArtData/Hops.SprMap"
		even
		include	"Objects/_Player/ArtData/Tammy.SprMap"
		even
; ---
SonicDynPLC:	incbin	"Objects/_Player/ArtData/Sonic.DPLC"
		even
TailsDynPLC:	incbin	"Objects/_Player/ArtData/Tails.DPLC"
		even
BoomDynPLC:	include	"Objects/_Player/ArtData/Boom.DPLC"
		even
HopsDynPLC:	include	"Objects/_Player/ArtData/Hops.DPLC"
		even
TammyDynPLC:	include	"Objects/_Player/ArtData/Tammy.DPLC"
		even
; ---
Art_Sonic:	incbin	"Objects/_Player/ArtData/Sonic.Artunc"
Art_Tails:	incbin	"Objects/_Player/ArtData/Tails.Artunc"
Art_Boom:	incbin	"Objects/_Player/ArtData/Boom.Artunc"
Art_Hops:	incbin	"Objects/_Player/ArtData/Hops.Artunc"
Art_Tammy:	incbin	"Objects/_Player/ArtData/Tammy.Artunc"
		even