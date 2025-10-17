; ---------------------------------------------------------------------------
; Main RAM
; ---------------------------------------------------------------------------
		rsset $FF0000|$FF000000
; ---------------------------------------------------------------------------
; LEVEL LAYOUTS
Chunk_Table:			rs.b $8000
Chunk_Table_End:		equ __rs

levelrowsize:		equ 128		; maximum width of a level layout in chunks
levelrowcount:		equ 32		; maximum height of a level layout in chunks			

Level_Layout:			rs.b levelrowsize*levelrowcount	; level layout; each row is $80 bytes
Level_Layout_End:		equ __rs

Block_Table:			rs.w $C00
Block_Table_End:		equ __rs
; ---------------------------------------------------------------------------
TempArray_LayerDef:		rs.b $200		; used by some layer deformation routines
Decomp_Buffer:			rs.b $200		; used by Nemesis as a temporary buffer before it is uploaded to VRAM

Sprite_Input_Table:		rs.b $400
Sprite_Input_Table_End:		equ __rs

; ---------------------------------------------------------------------------
; Object Status Table offsets
; ---------------------------------------------------------------------------
Object_RAM:		equ $40		; RAM per object
; universally followed object conventions:
id:			equ 0		; object ID
render_flags:		equ 1		; bitfield ; bit 7 = onscreen flag, bit 0 = x mirror, bit 1 = y mirror, bit 2 = coordinate system, bit 6 = render subobjects
art_tile:		equ 2		; 2 bytes - ; start of sprite's art
mappings:		equ 4		; 4 bytes -
x_pos:			equ 8		; 2 bytes - ... some objects use $A and $B as well when extra precision is required (see ObjectMove) ... for screen-space objects this is called x_pixel instead
x_sub:			equ $A		; 2 bytes -
y_pos:			equ $C		; 2 bytes - ... some objects use $E and $F as well when extra precision is required ... screen-space objects use y_pixel instead
y_sub:			equ $E		; 2 bytes -
x_vel:			equ $10		; 2 bytes - horizontal velocity
y_vel:			equ $12		; 2 bytes - vertical velocity
y_radius:		equ $16		; collision height / 2
x_radius:		equ $17		; collision width / 2
priority:		equ $18		; 0 = front
width_pixels:		equ $19
mapping_frame:		equ $1A
anim_frame:		equ $1B
anim:			equ $1C
prev_anim:		equ $1D
anim_frame_duration:	equ $1E
status:			equ $22		; note: exact meaning depends on the object... 
;for Player: 
PlayerStatusBitHFlip	equ	0	; left-facing. 
PlayerStatusBitAir	equ	1	; in-air. 
PlayerStatusBitSpin	equ	2	; spinning. 
PlayerStatusBitOnObject	equ	3	; on-object. 
PlayerStatusBitRollLock	equ	4	; roll-jumping. 
PlayerStatusBitPush	equ	5	; pushing. 
PlayerStatusBitWater	equ	6	; underwater.
PlayerStatusBitUnused	equ	7	; unused.
;for anything else (generally): 
StatusBitHFlip		equ	0	; left-facing. 
StatusBitVFlip		equ	1	; upside-down facing. 
StatusBit2		equ	2	; ?. 
StatusBitP1Stand	equ	3	; Player 1 stands on this object. 
StatusBitP2Stand	equ	4	; Player 2 stands on this object. 
StatusBitP1Push		equ	5	; Player 1 is pushing on this object. 
StatusBitP2Push		equ	6	; Player 2 is pushing on this object. 
StatusBit7		equ	7	; Object specific

routine:		equ $24
routine_secondary:	equ $25
angle:			equ $26		; angle about the z axis (360 degrees = 256)

x_pixel:		equ x_pos	; 2 bytes ; x coordinate for objects using screen-space coordinate system
y_pixel:		equ 2+x_pos	; 2 bytes ; y coordinate for objects using screen-space coordinate system
; conventions followed by many objects but NOT Sonic/Tails:
collision_flags:	equ $20
collision_property:	equ $21
respawn_index:		equ $23
subtype:		equ $28
; conventions mostly shared by Player Objects (Obj01, Obj02, and Obj09).
; Special Stage Sonic uses some different conventions
ground_speed:		equ $14		; 2 bytes ; directionless representation of speed... not updated in the air
flip_angle:		equ $27		; angle about the x axis (360 degrees = 256) (twist/tumble)
flips_remaining:	equ $2C		; number of flip revolutions remaining
flip_speed:		equ $2D		; number of flip revolutions per frame / 256
move_lock:		equ $2E		; 2 bytes ; horizontal control lock, counts down to 0
invulnerable_time:	equ $30		; 2 bytes ; time remaining until you stop blinking
invincibility_time:	equ $32		; 2 bytes ; remaining
speedshoes_time:	equ $34		; 2 bytes ; remaining
next_tilt:		equ $36		; angle on ground in front of sprite
tilt:			equ $37		; angle on ground
stick_to_convex:	equ $38		; 0 for normal, 1 to make Sonic stick to convex surfaces like the rotating discs in Sonic 1 and 3
spindash_flag:		equ $39		; 0 for normal, 1 for charging a spindash
jumping:		equ $3C
interact:		equ $3D		; RAM address of the last object Sonic stood on, minus $FFFFB000 and divided by $40
top_solid_bit:		equ $3E		; the bit to check for top solidity (either $C or $E)
lrb_solid_bit:		equ $3F		; the bit to check for left/right/bottom solidity (either $D or $F)

; Subsprite System
mainspr_mapframe	equ $B
mainspr_width		equ $E
mainspr_childsprites 	equ $F	; amount of child sprites
mainspr_height		equ $14
sub2_x_pos		equ $10	;x_vel
sub2_y_pos		equ $12	;y_vel
sub2_mapframe		equ $15
sub3_x_pos		equ $16	;y_radius
sub3_y_pos		equ $18	;priority
sub3_mapframe		equ $1B	;anim_frame
sub4_x_pos		equ $1C	;anim
sub4_y_pos		equ $1E	;anim_frame_duration
sub4_mapframe		equ $21	;collision_property
sub5_x_pos		equ $22	;status
sub5_y_pos		equ $24	;routine
sub5_mapframe		equ $27
sub6_x_pos		equ $28	;subtype
sub6_y_pos		equ $2A
sub6_mapframe		equ $2D
sub7_x_pos		equ $2E
sub7_y_pos		equ $30
sub7_mapframe		equ $33
sub8_x_pos		equ $34
sub8_y_pos		equ $36
sub8_mapframe		equ $39
sub9_x_pos		equ $3A
sub9_y_pos		equ $3C
sub9_mapframe		equ $3F
next_subspr		equ $6

; ---------------------------------------------------------------------------
Object_Space:			equ __rs	; Start of Object RAM

MainCharacter:			rs.b Object_RAM	; Player 1
Sidekick:			rs.b Object_RAM	; Player 2
Reserved_Object_02:		rs.b Object_RAM
Reserved_Object_03:		rs.b Object_RAM
Reserved_Object_04:		rs.b Object_RAM
Reserved_Object_05:		rs.b Object_RAM
Reserved_Object_06:		rs.b Object_RAM
Reserved_Object_07:		rs.b Object_RAM
Reserved_Object_08:		rs.b Object_RAM
Reserved_Object_09:		rs.b Object_RAM
Reserved_Object_10:		rs.b Object_RAM
Reserved_Object_11:		rs.b Object_RAM
Reserved_Object_12:		rs.b Object_RAM
Reserved_Object_13:		rs.b Object_RAM
Reserved_Object_14:		rs.b Object_RAM
Reserved_Object_15:		rs.b Object_RAM
Reserved_Object_16:		rs.b Object_RAM
Reserved_Object_17:		rs.b Object_RAM
Reserved_Object_18:		rs.b Object_RAM
Reserved_Object_19:		rs.b Object_RAM
Reserved_Object_20:		rs.b Object_RAM
Reserved_Object_21:		rs.b Object_RAM
Reserved_Object_22:		rs.b Object_RAM
Reserved_Object_23:		rs.b Object_RAM
Reserved_Object_24:		rs.b Object_RAM
Reserved_Object_25:		rs.b Object_RAM
Reserved_Object_26:		rs.b Object_RAM
Reserved_Object_27:		rs.b Object_RAM
Reserved_Object_28:		rs.b Object_RAM
Reserved_Object_29:		rs.b Object_RAM
Reserved_Object_30:		rs.b Object_RAM
Reserved_Object_31:		rs.b Object_RAM

Level_Object_Space:		rs.b Object_RAM*(128-32)	; Objects spawned in level

Object_Space_End:	equ __rs

; ---------------------------------------------------------------------------

Primary_Collision:		equ $FFFFD000	; hilariously innefficient
Secondary_Collision:		equ $FFFFD600

VDP_Command_Buffer:		equ $FFFFDC00
VDP_Command_Buffer_Slot:	equ $FFFFDCFC

Sonic_Stat_Record_Buf:		equ $FFFFE400
Sonic_Pos_Record_Buf:		equ $FFFFE500
Tails_Pos_Record_Buf:		equ $FFFFE600

Ring_Positions:			equ $FFFFE800

Camera_RAM:			equ $FFFFEE00
Camera_X_pos:			equ Camera_RAM
Camera_Y_pos:			equ Camera_RAM+4
Camera_BG_X_pos:		equ Camera_RAM+8
Camera_BG_Y_pos:		equ Camera_RAM+$C
Camera_BG2_X_pos:		equ Camera_RAM+$10
Camera_BG2_Y_pos:		equ Camera_RAM+$14
Camera_BG3_X_pos:		equ Camera_RAM+$18
Camera_BG3_Y_pos:		equ Camera_RAM+$1C

Camera_X_pos_P2:		equ Camera_RAM+$20
Camera_Y_pos_P2:		equ Camera_RAM+$24
Camera_BG_X_pos_P2:		equ Camera_RAM+$28	; only used sometimes as the layer deformation makes it sort of redundant
Camera_BG_Y_pos_P2:		equ Camera_RAM+$2C
Camera_BG2_X_pos_P2:		equ Camera_RAM+$30	; unused (only initialised at beginning of level)?
			;	equ Camera_RAM+$32	; $FFFFEE32-$FFFFEE33 ; seems unused
Camera_BG2_Y_pos_P2:		equ Camera_RAM+$34
Camera_BG3_X_pos_P2:		equ Camera_RAM+$38	; unused (only initialised at beginning of level)?
			;	equ Camera_RAM+$3A	; $FFFFEE3A-$FFFFEE3B ; seems unused
Camera_BG3_Y_pos_P2:		equ Camera_RAM+$3C


Horiz_block_crossed_flag:	equ Camera_RAM+$40
Verti_block_crossed_flag:	equ Camera_RAM+$41
Horiz_block_crossed_flag_BG:	equ Camera_RAM+$42
Verti_block_crossed_flag_BG:	equ Camera_RAM+$43
Horiz_block_crossed_flag_BG2:	equ Camera_RAM+$44
Horiz_block_crossed_flag_BG3:	equ Camera_RAM+$46
Horiz_block_crossed_flag_P2:	equ Camera_RAM+$48
Verti_block_crossed_flag_P2:	equ Camera_RAM+$49
				

Scroll_flags:			equ Camera_RAM+$50
Scroll_flags_BG:		equ Camera_RAM+$52
Scroll_flags_BG2:		equ Camera_RAM+$54
Scroll_flags_BG3:		equ Camera_RAM+$56
Scroll_flags_P2:		equ Camera_RAM+$58
Scroll_flags_BG_P2:		equ Camera_RAM+$5A
Scroll_flags_BG2_P2:		equ Camera_RAM+$5C
Scroll_flags_BG3_P2:		equ Camera_RAM+$5E

Camera_X_pos_diff      		equ Camera_RAM+$B0   
Camera_Y_pos_diff:		equ Camera_RAM+$B2           
Camera_BG_X_pos_diff:		equ Camera_RAM+$B4           
Camera_BG_Y_pos_diff:		equ Camera_RAM+$B6       
Camera_X_pos_diff_P2:		equ Camera_RAM+$B8	; (new X pos - old X pos) * 256
Camera_Y_pos_diff_P2:		equ Camera_RAM+$BA

Camera_Max_Y_pos:		equ Camera_RAM+$C6
Camera_Min_X_pos:		equ Camera_RAM+$C8
Camera_Max_X_pos:		equ Camera_RAM+$CA
Camera_Min_Y_pos:		equ Camera_RAM+$CC
Camera_Max_Y_pos_now:		equ Camera_RAM+$CE

Camera_Y_pos_bias:		equ Camera_RAM+$D8
Camera_Y_pos_bias_P2:		equ Camera_RAM+$DA

Camera_Max_Y_Pos_Changing:	equ Camera_RAM+$DE

Camera_Min_X_pos_P2:		equ Camera_RAM+$F8
Camera_Max_X_pos_P2:		equ Camera_RAM+$FA
Camera_Min_Y_pos_P2:		equ Camera_RAM+$FC
Camera_Max_Y_pos_P2:		equ Camera_RAM+$FE




Horiz_scroll_delay_val:		equ $FFFFEED0
Sonic_Pos_Record_Index:		equ $FFFFEED2

Game_Mode:			equ $FFFFF600

Ctrl_1_Logical:		
Ctrl_1_Held_Logical:		equ $FFFFF602
Ctrl_1_Press_Logical:		equ $FFFFF603
Ctrl_1:			
Ctrl_1_Held:			equ $FFFFF604
Ctrl_1_Press:			equ $FFFFF605
Ctrl_2:			
Ctrl_2_Held:			equ $FFFFF606
Ctrl_2_Press:			equ $FFFFF607


VDP_Reg1_val:			equ $FFFFF60C

Demo_Time_left:			equ $FFFFF614

Vscroll_Factor:			equ $FFFFF616

Hint_counter_reserve:		equ $FFFFF624
Vint_routine:			equ $FFFFF62A

Sprite_count:			equ $FFFFF62C

PalCycle_Frame:			equ $FFFFF632
PalCycle_Timer:			equ $FFFFF634

Game_paused:			equ $FFFFF63A

DMA_data_thunk:			equ $FFFFF640
Hint_flag:			equ $FFFFF644
Water_fullscreen_flag:		equ $FFFFF64E
Do_Updates_in_H_int:		equ $FFFFF64F

Plc_Buffer:			equ $FFFFF680

Plc_Buffer_Reg0:		equ $FFFFF6E0
Plc_Buffer_Reg4:		equ $FFFFF6E4
Plc_Buffer_Reg8:		equ $FFFFF6E8
Plc_Buffer_RegC:		equ $FFFFF6EC
Plc_Buffer_Reg10:		equ $FFFFF6F0
Plc_Buffer_Reg14:		equ $FFFFF6F4
Plc_Buffer_Reg18:		equ $FFFFF6F8
Plc_Buffer_Reg1A:		equ $FFFFF6FA

unk_F700:			equ $FFFFF700
Tails_control_counter:		equ $FFFFF702
unk_F706:			equ $FFFFF706
Tails_CPU_routine:		equ $FFFFF708

Rings_manager_routine:		equ $FFFFF710
Level_started_flag:		equ $FFFFF711
Ring_start_addr:		equ $FFFFF712
Ring_end_addr:			equ $FFFFF714
Ring_start_addr_P2:		equ $FFFFF716
Ring_end_addr_P2:		equ $FFFFF718

Water_flag:			equ $FFFFF730

Sonic_top_speed:		equ $FFFFF760
Sonic_acceleration:		equ $FFFFF762
Sonic_deceleration:		equ $FFFFF764
Sonic_LastLoadedDPLC:		equ $FFFFF766

Obj_placement_routine:		equ $FFFFF76C
Camera_X_pos_last:		equ $FFFFF76E
Obj_load_addr_right:		equ $FFFFF770
Obj_load_addr_left:		equ $FFFFF774
Obj_load_addr_2:		equ $FFFFF778
Obj_load_addr_3:		equ $FFFFF77C

Camera_X_pos_last_P2:		equ $FFFFF78C

Collision_addr:  		equ $FFFFF796

Bonus_Countdown_1:		equ $FFFFF7D2
Bonus_Countdown_2:		equ $FFFFF7D4
Update_Bonus_score:		equ $FFFFF7D6

Camera_X_pos_coarse:		equ $FFFFF7DA
Camera_X_pos_coarse_P2:		equ $FFFFF7DC



Tails_LastLoadedDPLC:		equ $FFFFF7DE
TailsTails_LastLoadedDPLC:	equ $FFFFF7DF

Anim_Counters:			equ $FFFFF7F0

Sprite_Table:			equ $FFFFF800

Underwater_target_palette:		equ $FFFFFA00     ; This is used by the screen-fading subroutines.
Underwater_target_palette_line2:	equ $FFFFFA20     ; While Underwater_palette contains the blacked-out palette caused by the fading,
Underwater_target_palette_line3:	equ $FFFFFA40     ; Underwater_target_palette will contain the palette the screen will ultimately fade in to.
Underwater_target_palette_line4:	equ $FFFFFA60             

Underwater_palette:		equ $FFFFFA80	; main palette for underwater parts of the screen
Underwater_palette_line2:	equ $FFFFFAA0
Underwater_palette_line3:	equ $FFFFFAC0
Underwater_palette_line4:	equ $FFFFFAE0
               
Normal_palette:			equ $FFFFFB00	; main palette for non-underwater parts of the screen
Normal_palette_line2:		equ $FFFFFB20
Normal_palette_line3:		equ $FFFFFB40
Normal_palette_line4:		equ $FFFFFB60
Normal_palette_End:		equ Normal_palette+$80

Target_palette:			equ $FFFFFB80	; This is used by the screen-fading subroutines.
Target_palette_line2:		equ $FFFFFBA0	; While Normal_palette contains the blacked-out palette caused by the fading,
Target_palette_line3:		equ $FFFFFBC0	; Target_palette will contain the palette the screen will ultimately fade in to.
Target_palette_line4:		equ $FFFFFBE0
Target_palette_End:		equ Target_palette+$80

Error_Registers:		equ $FFFFFC00	; stores registers d0-a7 during an error event ($40 bytes)
Error_Stack_Pointer:		equ $FFFFFC40	; stores most recent sp address (4 bytes)
Error_Type:			equ $FFFFFC44	; error type

Debug_object:			equ $FFFFFE06
Debug_placement_mode:		equ $FFFFFE08
Debug_Accel_Timer:		equ $FFFFFE0A
Debug_Speed:			equ $FFFFFE0B

Vint_runcount:			equ $FFFFFE0C

Current_ZoneAndAct:		equ $FFFFFE10
Current_Zone:			equ $FFFFFE10
Current_Act:			equ $FFFFFE11

Life_count:			equ $FFFFFE12

Update_HUD_lives:		equ $FFFFFE1C 
Update_HUD_rings:		equ $FFFFFE1D 
Update_HUD_timer:		equ $FFFFFE1E
Update_HUD_score:		equ $FFFFFE1F

Ring_count:			equ $FFFFFE20 
Timer:				equ $FFFFFE22
Timer_minute:			equ Timer+1
Timer_second:			equ Timer+2
Timer_frame:			equ Timer+3

Score:				equ $FFFFFE26

Camera_Min_Y_pos_copy:		equ $FFFFFEF0	; used by debug mode
Camera_Max_Y_pos_copy:		equ $FFFFFEF2

Next_Extra_life_score:		equ $FFFFFFC0

Two_player_mode:		equ $FFFFFFE8

Debug_mode_flag:		equ $FFFFFFFA