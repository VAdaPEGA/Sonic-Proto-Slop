; ---------------------------------------------------------------------------
; Miscellaneous constants without dedicated pointers

; REDRAWING ROUTINES:
; This is used by stages that employ a more advanced redraw routine, basing it
; off the various background positions other than just BG1; this is to stop tiles
; from being accidentally overwritten

; Note that internally, they were called Plane B, C, and D (A is the foreground
; layer, Z was the unused effect seen in the TTS'90 demo)
static1:		equ 0
dynamic1:		equ 2
dynamic2:		equ 4
dynamic3:		equ 6
; ---------------------------------------------------------------------------
; Common VRAM addresses
VRAM_FG2P:	equ $A000	; Foreground namespace for 2P
VRAM_FG:	equ $C000	; Foreground namespace
VRAM_Dyn:	equ $D000	; Dynamic area for misc. art
VRAM_BG:	equ $E000	; Background namespace
VRAM_Sprites:	equ $F800	; Sprite table

VRAM_Plr1:	equ $F000	; Player 1 graphics
VRAM_Plr1Extra:	equ $F200	; Player 1 Extra (ex: Tails' Tails)
VRAM_Plr2:	equ $F400	; Player 2 graphics
VRAM_Plr2Extra:	equ $F600	; Player 2 Extra (ex: Tails' Tails)

VRAM_HScroll:	equ $FC00	; Horizontal scroll table
; ---------------------------------------------------------------------------
; Colours for testing purposes
cBlack:		equ $000		; colour black
cWhite:		equ $EEE		; colour white
cBlue:		equ $E00		; colour blue
cGreen:		equ $0E0		; colour green
cRed:		equ $00E		; colour red
cYellow:	equ cGreen+cRed		; colour yellow
cAqua:		equ cGreen+cBlue	; colour aqua
cMagenta:	equ cBlue+cRed		; colour magenta

; ---------------------------------------------------------------------------
; Tilemap Format
TMap_Priority:	equ	$8000
TMap_PalLine2:	equ	$2000
TMap_PalLine3:	equ	$4000
TMap_PalLine4:	equ	TMap_PalLine2+TMap_PalLine3
TMap_XFlip:	equ	$1000
TMap_YFlip:	equ	$0800

; ---------------------------------------------------------------------------
; VDP addresses
VDP_data_port:			equ $C00000 ; (8=r/w, 16=r/w)
VDP_control_port:		equ $C00004 ; (8=r/w, 16=r/w)
PSG_input:			equ $C00011

; ---------------------------------------------------------------------------
; Z80 addresses
Z80_RAM:			equ $A00000 ; start of Z80 RAM
Z80_RAM_End:			equ $A02000 ; end of non-reserved Z80 RAM
YM2612_A0:			equ $A04000
YM2612_D0:			equ $A04001
YM2612_A1:			equ $A04002
YM2612_D1:			equ $A04003
Z80_Bus_Request:		equ $A11100
Z80_Reset:			equ $A11200

; ---------------------------------------------------------------------------
; I/O Area 
HW_Version:		equ $A10001	; Mega Drive version Register
ByteIoVersion:		equ %00001111	; 0-3 System version number
BitIoVUnk		equ 4		; Unknown
BitIoVExp		equ 5		; Expansion unit
BitIoVPal		equ 6		; Clock (set if PAL)
BitIoVRegion		equ 7		; Region (set if not Japan)
HW_Port_1_Data:		equ $A10003	; Data Port 1
HW_Port_2_Data:		equ $A10005	; Data Port 2
HW_Expansion_Data:	equ $A10007	; Data Port Modem
HW_Port_1_Control:	equ $A10009	; Control Port 1
HW_Port_2_Control:	equ $A1000B	; Control Port 2
HW_Expansion_Control:	equ $A1000D	; Control Port Modem
HW_Port_1_TxData:	equ $A1000F
HW_Port_1_RxData:	equ $A10011
HW_Port_1_SCtrl:	equ $A10013
HW_Port_2_TxData:	equ $A10015
HW_Port_2_RxData:	equ $A10017
HW_Port_2_SCtrl:	equ $A10019
HW_Expansion_TxData:	equ $A1001B
HW_Expansion_RxData:	equ $A1001D
HW_Expansion_SCtrl:	equ $A1001F
HW_MARS:		equ $A130EC	; that accursed mushroom
HW_SEGA:		equ $A14000	; TMSS
HW_TMSS:		equ $A14101	; TMSS

; ---------------------------------------------------------------------------
; Joypad input
btnStart:	equ %10000000 ; Start button	($80)
btnA:		equ %01000000 ; A		($40)
btnC:		equ %00100000 ; C		($20)
btnB:		equ %00010000 ; B		($10)
btnR:		equ %00001000 ; Right		($08)
btnL:		equ %00000100 ; Left		($04)
btnDn:		equ %00000010 ; Down		($02)
btnUp:		equ %00000001 ; Up		($01)
btnDir:		equ %00001111 ; Any direction	($0F)
btnABC:		equ %01110000 ; A, B or C	($70)
btnBC:		equ %00110000 ; B or C		($30)
bitStart:	equ 7
bitA:		equ 6
bitC:		equ 5
bitB:		equ 4
bitR:		equ 3
bitL:		equ 2
bitDn:		equ 1
bitUp:		equ 0

; ---------------------------------------------------------------------------
; Extended RAM constants (for routines that would convert data for STI's use)
ConvertedChunksLoc:		equ $00FE0000
; ---------------------------------------------------------------------------
ASCII_Linebreak:		equ $0D0A
; ---------------------------------------------------------------------------
; Animation flags
afEnd:		equ -1	; $FF return to beginning of animation
afBack:		equ -2	; $FE go back (specified number) bytes
afChange:	equ -3	; $FD run specified animation
afRoutine:	equ -4	; $FC increment routine counter
afReset:	equ -5	; $FB reset animation and 2nd object routine counter
af2ndRoutine:	equ -6	; $FA increment 2nd routine counter
; ===========================================================================
; These constants will be replaced by an automated system for ease of modification
; see macros

; Music IDs
MusID__First			equ $81
MusID_GHZ:			equ ((MusPtr_GHZ-MusicIndex)/4)+MusID__First		; $81
MusID_LZ:			equ ((MusPtr_LZ-MusicIndex)/4)+MusID__First		; $82
MusID_CPZ:			equ ((MusPtr_CPZ-MusicIndex)/4)+MusID__First		; $83
MusID_EHZ:			equ ((MusPtr_EHZ-MusicIndex)/4)+MusID__First		; $84
MusID_HPZ:			equ ((MusPtr_HPZ-MusicIndex)/4)+MusID__First		; $85
MusID_HTZ:			equ ((MusPtr_HTZ-MusicIndex)/4)+MusID__First		; $86
MusID_Invincible:		equ ((MusPtr_Invincible-MusicIndex)/4)+MusID__First	; $87
MusID_ExtraLife:		equ ((MusPtr_ExtraLife-MusicIndex)/4)+MusID__First	; $88
MusID_SpecialStage:		equ ((MusPtr_SpecialStage-MusicIndex)/4)+MusID__First	; $89
MusID_Title:			equ ((MusPtr_Title-MusicIndex)/4)+MusID__First		; $8A
MusID_Ending:			equ ((MusPtr_Ending-MusicIndex)/4)+MusID__First		; $8B
MusID_Boss:			equ ((MusPtr_Boss-MusicIndex)/4)+MusID__First		; $8C


id_roll	=	2
; ===========================================================================
; Game modes
	IncludeGameMode	Logo,		Logo,		"Logo intro"
	IncludeGameMode	TitleScreen,	TitleScreen,	"Title"
	IncludeGameMode	Demo,		Level,		"Demo"
	IncludeGameMode	Level,		Level,		"Level"
	IncludeGameMode	SpecialStage,	SpecialStage,	"Special Stage"
	IncludeGameMode	Credits,	Logo,		"Credits"
	inform	0, " Game Modes : \#GamemodeCount\"

GameModeFlag_TitleCard:		equ 7 ; flag bit
GameModeID_TitleCard:		equ 1<<GameModeFlag_TitleCard			; $80 ; flag mask
; ===========================================================================
; 	Levels		folder,	water,	debug
	IncludeZone	GHZ,	0,	"Green Hill but Broken"
	IncludeZone	CPZ,	1,	"Chemical Plant"
	IncludeZone	MMZ,	0,	"Morning Mill"
	IncludeZone	EHZ,	0,	"Emerald Hill"
	IncludeZone	HPZ,	1,	"Hidden Palace"
	IncludeZone	HTZ,	0,	"Hill Top"
	IncludeZone	CNZ,	0,	"Casino Night"
	inform	0, " Zones : \#ZoneCount\"

; ===========================================================================
; Background music

;		speed up,  name		file				
;	IncludeMusic	0, Title,	gotosleep.bin,		"GO TO SLEEP [TITLE]",			ComposerVA
;	IncludeMusic	0, Menu,	menu.bin,		"HAPPY BREAK TIME [MENU]",		ComposerVA
;	IncludeMusic	0, PreBattle,	Battle/Battlepre.bin,	"WHERE'S THE TOOF? [PRE-BATTLE]",	ComposerVA
;	IncludeMusic	0, Battle,	Battle/Battle.bin,	"OH HECK HERE'S TOOF [BATTLE]",		ComposerVA
; 	IncludeMusic	0, Adrift,	Battle/Adrift.bin,	"OOF TO THE TOOF [NIGHTMARE]",		ComposerVA
;	IncludeMusic	0, AutumnCut,	RoyalPain.bin,		"ROYAL PAIN",				ComposerDAN_VA

;	IncludeMusic	0, CatstleIntro,	RoyaltyAtTheBeach.asm,	"ROYALTY AT THE BEACH",		ComposerVA
;	IncludeMusic	0, Catstle,	WalkingOnTheRoyalBeach.bin,	"WALKIN' ON THE ROYAL BEACH",	ComposerDAN_VA

;	IncludeMusic	0, BossSnow,	Battle/BossGrandma.bin,	"GOODBYE SPOILED [ADALT]",		ComposerVA
;	IncludeMusic	0, Defeat,	Fffffk.bin,		"BUT THE CAT CAME BACK [DEFEAT]",	ComposerVA
;	IncludeMusic	0, Tomypogo,	Tomypogo.asm,		"TOMYPOGO [ONLY SETS PATCHES]",	ComposerVA
;	IncludeMusic	0, SSTV,	sstvtest.asm,		"SSTV TEST",	ComposerVA

;		inform	0, " Music : \#MusicCount\"

; ---------------------------------------------------------------------------
SndID_SuperBonk	=	$A3
;	IncludeSound	$81, Jump,		Player/Jump.asm,	"TOOFSCARADE", "JUMP"
;	IncludeSound	$81, JumpSon,		Player/Jump_Son.asm,	"TOMYLOBO", "JUMP"
;	IncludeSound	$81, JumpS,		Player/Jump_S.asm,	"FORGOR", "JUMP"
;	IncludeSound	$81, JumpG,		Player/Jump_G.asm,	"G", "JUMP"
;	IncludeSound	$81, JumpSpin,		Player/Jumpspin.asm,	"TOOFSCARADE", "JUMP SPIN"
;	IncludeSound	$70, Hurt,		Player/Hurt.asm,	"HURT", ""
;	IncludeSound	$71, Roll,		Player/Roll.bin,	"TOMYLOBO", "ROLL"
;	IncludeSound	$81, Sono,		Player/CatYawn.asm,	"TOOFSCARADE", "SONO (MYAWN)"
;
;	IncludeSound	$72, Meow1,		Player/Meow1.asm,	"MIAU", ""
;	IncludeSound	$72, Meow2,		Player/Meow2.asm,	"MIAU THE SECOND", ""
;	IncludeSound	$72, MeowFussy,		Player/MeowFussy.asm,	"FUSSY MIAU", ""
;	IncludeSound	$72, MeowHurt,		Player/MeowHurt.asm,	"HURT MIAU", ""
;	IncludeSound	$72, MeowHurt2,		Player/MeowHurt2.asm,	"HURT MIAU THE SEQUEL", ""
;	IncludeSound	$72, Meow6,		Player/Meow6.asm,	"AGREEING MIAU", ""
;	IncludeSound	$72, Meow7,		Player/Meow7.asm,	"CONVERSIVE MIAU", ""
;	IncludeSound	$72, Meow8,		Player/Meow8.asm,	"LOSS MIAU", ""
;	IncludeSound	$72, Meow9,		Player/Meow9.asm,	"WIN MIAU", ""
;	IncludeSound	$72, MeowFussy2,	Player/MeowFussy2.asm,	"FUSSY MIAU : THE RETURN", ""
;	IncludeSound	$81, Purry,		Player/CatPurr.asm,	"GATO PURRY", "" ; there ya go, your only Brasil reference
;
;	IncludeSound	$71, VAdaLogo,		VAdaLogo.asm,		"VADAPEGA LOGO", ""


;	IncludeSound	$70, HDUp,		Global/HDUp.bin,		"HD UP", ""
;	IncludeSound	$70, HPUp,		Global/HPUp.bin,		"HP UP", ""
;	IncludeSound	$70, BeanIncrease,	Global/BeanIncrease.asm,	"BEAN INCREASE", ""
;	IncludeSound	$70, BeanDecrease,	Global/BeanDecrease.asm,	"BEAN DECREASE", ""
;	IncludeSound	$71, AdieHit,		Global/Adiehit.asm,		"HIT ADIE", ""
;	IncludeSound	$71, PlayerSpotted,	Global/PlayerSpotted.asm,	"PLAYER SPOTTED", ""
;	IncludeSound	$71, HLUseKey,		Global/HLUseKey.asm,		"NOT INTERACTABLE", ""
;	IncludeSound	$81, Correct,		Global/Correct.bin,		"CORRECT", ""
;	IncludeSound	$71, Yesir,		Global/Yesir.asm,		"YESIR", ""
;
;	IncludeSound	$73, confirm,		Textbox/_confirm.asm,	"CONFIRM",""
;	IncludeSound	$72, select,		Textbox/_select.asm,	"SELECT",""
;	IncludeSound	$72, menuselected,	Textbox/_Menuselected.asm,	"MENU SELECTED",""
;	IncludeSound	$73, deny,		Textbox/_deny.asm,	"DENY",""
;	IncludeSound	$70, unfortune,		Textbox/_unfortune.asm,	"UNFORTUNE",""
;
;	IncludeSound	$70, TextboxDefault,	Textbox/_Default.asm,	"TEXTBOX","DEFAULT"
;	IncludeSound	$70, TextboxHonker,	Textbox/Honker.asm,	"TEXTBOX","HONKER", snd_TextboxHonker
;	IncludeSound	$70, TextboxTomylobo,	Textbox/Tomylobo.asm,	"TEXTBOX","TOMYLOBO"
;	IncludeSound	$70, TextboxParkerat,	Textbox/Parkerat.asm,	"TEXTBOX","PARKERAT"
;	IncludeSound	$70, TextboxAutumn,	Textbox/Autumn.asm,	"TEXTBOX","AUTUMN"
;
;	IncludeSound	$81, sAttracts,		SRB2/ShieldAttract.asm,		"SRB2 ATTRACTION SHIELD", ""
;	IncludeSound	$81, sArmageds,		SRB2/ShieldArmageddon.bin,	"SRB2 ARMAGEDDON SHIELD", ""
;	IncludeSound	$81, sElements,		SRB2/ShieldElemental.bin,	"SRB2 ELEMENTAL SHIELD", ""
;	IncludeSound	$81, sWhirlwinds,	SRB2/ShieldWhirlwind.bin,	"SRB2 WHIRLWIND SHIELD", ""
;	IncludeSound	$71, AmyHammer,		SRB2/AmyHammer.asm,		"SRB2 AMY HAMMER SPRING", ""
;	IncludeSound	$71, FangSpring,	SRB2/FangSpring.bin,		"SRB2 FANG SPRING", "TINARA JUMP"
;SndID_TinaraJump	= SndID_FangSpring
;	IncludeSound	$71, FangPanic,		SRB2/FangPanic.asm,		"SRB2 FANG PANIC", "UNLEASH THE BATTLE"
;SndID_BattleStart	= SndID_FangPanic
;	IncludeSound	$71, Thok,		SRB2/THOK.bin,			"SRB2 THOK", "TINARA THROW"
;SndID_TinaraThrow	= SndID_Thok
;	IncludeSound	$81, SilverRing,	SRB2/SilverRing.asm,		"SRB2 SILVER RING", ""
;	IncludeSound	$81, SPB,		SRB2/SPB.asm,			"SRB2", "ANXIETY"
;	
;	IncludeSound	$71, Bubbles,		SRB2/Swim1.asm,			"SRB2 TAILS SWIM", "BUBBLES"
;
;	IncludeSound	$71, Bend, 		SRB2/TreeBend.asm,		"BEND", ""
;	IncludeSound	$71, WhipCrack, 	SRB2/TreeJohnnyTest.asm,	"WHIP CRACK", ""
;
;	IncludeSound	$71, dingfuuu,		DingFuuu.bin,	"DING...", "     FAA-"
;
;	IncludeSound	$71, barfk1,		barfk.asm,	"BARFK", ""
;	IncludeSound	$71, barfk2,		barfk2.asm,	"BARFK 2", ""
;	IncludeSound	$71, blockbonk,		blockbonk.asm,	"BLOCK", "BONK"
;	IncludeSound	$71, blockbreak,	blockbreak.asm,	"BLOCK", "BREAK"
;
;	IncludeSound	$71, honk,		HONK.asm,	"FUNNY HONKER NOISES", "YEAH MEEEE!"
;	IncludeSound	$71, chainrise,		chainrise.bin,	"SONIC 1 CHAIN RISE", "LIGHT SWITCH"
;	IncludeSound	$81, spring,		Spring.asm,	"BOUNCY THING", "OR SOMETHING LIKE THAT"
;
;	IncludeSound	$71, EraserBell,  	EraserBell.asm,	"ERASER COWBELL", ""
;	IncludeSound	$71, yoku,  	 	yoku.asm,	"YOKU", ""
;	IncludeSound	$75, plusfive,  	plusfive.asm,	"PLUS FIVE", ""
;
;	IncludeSound	$71, ClawSlash,  	ClawSlash.asm,	"CLAW SLASH", ""
;	IncludeSound	$81, AutumnJump,	AutumnJump.asm,	"AUTUMN", "JUMP"
;
;	IncludeSound	$81, PixyDash,		PixyDash.asm,	"PIXETTY", "DASH"
;
;	IncludeSound	$71, Collapse,  	Collapse.bin,	"VANILLA", "COLLAPSE"



;SndId_wallSmash		=	SndID_Collapse
;SndId_ConsumeBean	=	SndID_Collapse
;SndId_Unselected	=	SndID_menuselected
;SndId_BreakItem		=	SndID_Collapse 
;SndId_TSono		=	SndID_Collapse ; Tomylobo needs his own Yawn
;
;SoundCountNormal	equ	SoundCount
; ---------------------------------------------------------------------------
; Special Sound Effects
;	IncludeSound	$71, waterfall,	  	Special/waterfall.bin,	"VANILLA", "WATERFALL"
;	IncludeSound	$71, coing,	  	Special/coingleft.asm,	"COING", "LEFT"
;	IncludeSound	$71, coingright,	Special/coingright.asm,	"COING", "RIGHT"
;	IncludeSound	$71, Push,		Player/Push.asm,	"PUSH", ""
;	IncludeSound	$71, Skid,		Player/Skid.asm,	"SKID", ""
;	IncludeSound	$71, Charge,		Player/Charge.asm,	"TOMYLOBO", "CHARGE"
;
;SoundCountSpecial	equ	SoundCount-SoundCountNormal

; ---------------------------------------------------------------------------
; Music / Sound Control Flags
;		rsset	MusicCount+SoundCount+1

;bgm_Fade:	rs.b 1
;bgm_Slowest:	rs.b 1
;bgm_SSpeed:	rs.b 1
;bgm_SpdNormal:	rs.b 1
;bgm_Stop:	rs.b 1
;bgm_SpeedUp:	rs.b 1
;bgm_SpeedDown:	rs.b 1
;bgm_PitchUp:	rs.b 1
;bgm_PitchDown:	rs.b 1
;bgm_Nightcore:	rs.b 1
;bgm_Vaporwave:	rs.b 1
;bgm_SpdToPitch:	rs.b 1
;Bgm_Save:	rs.b 1
;Bgm_FadeSave:	rs.b 1
;Bgm_Load:	rs.b 1
;Bgm_FadeBack:	rs.b 1
;
;SndTestLastEntry:	equ	Bgm_FadeBack
;
;bgm_Nightmare:	rs.b bgm_Vaporwave




;		inform	0, " Sounds : \#SoundCount\ (\#SoundCountSpecial\ special)"
; ---------------------------------------------------------------------------
