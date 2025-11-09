; ---------------------------------------------------------------------------
; Queue Sound effect or Music
; ---------------------------------------------------------------------------
	inform	1,"TO DO : make a queue system"
PlaySound:
		move.b	d0,(Sound_Driver_RAM+SFXToPlay).w
		rts
PlaySound_Special:
		move.b	d0,(Sound_Driver_RAM+SFXToPlay2).w
		rts
PlaySound_Unk:
		move.b	d0,(Sound_Driver_RAM+SFXToPlay3).w
		rts
; ---------------------------------------------------------------------------