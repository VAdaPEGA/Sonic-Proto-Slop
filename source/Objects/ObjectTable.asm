; ---------------------------------------------------------------------------
; OBJECT POINTER ARRAY ; object pointers ; sprite pointers ; object list ; sprite list
;
; This array contains the pointers to all the objects used in the game.
;
; The macro used here will also include all the required data from the object automatically
;
; Also what the heck was up with all the inconsistent names??? laaaads, it's not that hard to fact check this PLEASE
; ---------------------------------------------------------------------------
	IndexStart	Obj_Index
	IncludeObject				; 01
	IncludeObject				; 02
	IncludeObject	LayerSwitcher		; 03 - Collision plane/layer switcher
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject
	IncludeObject	
	IncludeObject	BubblesAndCountdown	; 0A - Small bubbles from Sonic's face while underwater
	IncludeObject	BubbleMaker		; 0B - Bubble Spawner
	IncludeObject	_WeirdPlatforms		; 0C - Strange floating/falling platform object from CPZ
	IncludeObject	SignPost		; 0D - End of level signpost
	IncludeObject	
	IncludeObject	_MappingTest		; 0F - Mappings test?
	IncludeObject
	IncludeObject	Bridge			; 11 - Bridges in GHZ, EHZ and HPZ
	IncludeObject	SmashableBlock		; 12 - Emerald from Hidden Palace Zone
	IncludeObject	HPZWaterfall		; 13 - Waterfall from Hidden Palace Zone
	IncludeObject	SeeSaw			; 14 - Seesaw from Hill Top Zone
	IncludeObject	SwingingPlatforms	; 15 - Swinging platforms in GHZ, CPZ and EHZ
	IncludeObject	LiftDiagonal		; 16 - Diagonally moving lift from HTZ
	IncludeObject	RotatingLogSpikes	; 17 - (S1) GHZ rotating log helix spikes
	IncludeObject	Platforms		; 18 - Stationary/moving platforms from GHZ and EHZ
	IncludeObject	PlatformsCPZ		; 19 - Platform from CPZ
	IncludeObject	Collapsing		; 1A - Collapsing platform from GHZ and HPZ
	IncludeObject	FlipCPZ			; 1B - Animated Flipping Platforms CPZ
	IncludeObject	Decoration		; 1C - Stage decorations in GHZ, EHZ, HTZ and HPZ
	IncludeObject	
	IncludeObject	
	IncludeObject	Crabmeat		; 1F - (S1) Crabmeat from GHZ
	IncludeObject	
	IncludeObject	HUD			; 21 - Score/Rings/Time display (HUD)
	IncludeObject	BuzzBomber		; 22 - (S1) Buzz Bomber from GHZ
	IncludeObject	Missile			; 23 - (S1) Buzz Bomber/Newtron missile
	IncludeObject
	IncludeObject	Ring			; 25 - A ring
	IncludeObject	Monitor			; 26 - Monitor
	IncludeObject	Explosion		; 27 - An explosion, giving off an animal and 100 points
	IncludeObject	AnimalsAndPoints	; 28 - Animal and the 100 points from a badnik
	IncludeObject
	IncludeObject	Door			; 2A - (S1) Small door from SBZ
	IncludeObject	Chopper			; 2B - (S1) Chopper from GHZ
	IncludeObject	Jaws			; 2C - (S1) Jaws from LZ
	IncludeObject				; 2D
	IncludeObject				; 2E
	IncludeObject				; 2F
	IncludeObject				; 30
	IncludeObject				; 31
	IncludeObject				; 32
	IncludeObject				; 33
	IncludeObject				; 34
	IncludeObject				; 35
	IncludeObject	Spikes			; 36 - Vertical spikes
	IncludeObject				; 37
	IncludeObject				; 38
	IncludeObject				; 39
	IncludeObject				; 3A
	IncludeObject	DecorationSolid		; 3B - (S1) Purple rock from GHZ
	IncludeObject	BreakableWall		; 3C - (S1) Breakable wall
	IncludeObject	
	IncludeObject	EndOfLevelCapsule	; 3E - Egg prison
	IncludeObject	
	IncludeObject	Motobug			; 40 - (S1) Motobug from GHZ
	IncludeObject	Springs			; 41 - Spring
	IncludeObject	Newtron			; 42 - (S1) Newtron from GHZ
	IncludeObject	
	IncludeObject	SolidWall		; 44 - (S1) Unbreakable wall, Solid Wall
	IncludeObject				; 45
	IncludeObject				; 46
	IncludeObject				; 47
	IncludeObject				; 48
	IncludeObject	Waterfall		; 49 - Waterfall
	IncludeObject	Octus			; 4A - Octus from HPZ
	IncludeObject	Buzzer			; 4B - Buzzer from EHZ
	IncludeObject	BBat			; 4C - BBat from HPZ
	IncludeObject	Stegway			; 4D - Stego/Stegway from HPZ
	IncludeObject	Gator			; 4E - Gator from HPZ
	IncludeObject	Redz			; 4F - Redz (dinosaur badnik) from HPZ
	IncludeObject	Aquis			; 50 - Seahorse/Aquis from HPZ
	IncludeObject	Skyhorse		; 51 - Skyhorse from HPZ
	IncludeObject	BFish			; 52 - BFish from HPZ
	IncludeObject	Masher			; 53 - Masher from EHZ
	IncludeObject	Motomollusk		; 54 - Snail badnik from EHZ
	IncludeObject	BossEHZ			; 55 - EHZ boss
	IncludeObject
	IncludeObject
	IncludeObject
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	LampPost		; 79 - Checkpoint
	IncludeObject	
	IncludeObject	
	IncludeObject	
	IncludeObject	HiddenPoints		; 7D - Hidden points at end of stage
	IncludeObject	
	IncludeObject	

	; Cannot be placed in level
	IncludeObject	_Player		; 80 - Player
	IncludeObject	_SSPlayer	; 81 - Player in the Speical Stage
	IncludeObject	WaterSurface	; 82 - Surface of the water
	IncludeObject	WaterSplash	; 83 - Water splash
	IncludeObject	Credits		; 84 - "SONIC TEAM PRESENTS" screen and credits
	IncludeObject	TitleCard	; 85 - Level title card, End of level results and Game Over/Time Over text
	IncludeObject	TitleObject	; 86 - Sonic and Tails from the title screen
	IncludeObject	Invincibility	; 87 - Invincibility Stars
	IncludeObject	BossGHZ		; 88 - GHZ boss
	IncludeObject	DisplayHitbox	; 89
	dc.l		DeleteObject
ObjCount	=	ObjCount+1
ObjId_DeleteObject	equ	ObjCount


	inform	0, " Level Objects : \#ObjCount\"

; ===========================================================================
; Blank object, if placed in-level, it crashes, so don't.
ObjNull:
		move.l	d0,-(sp)
		moveq	#$16,d0
		TRAP	#0
		move.l	(sp)+,d0
jmp_DeleteObject:
		bra.w	DeleteObject