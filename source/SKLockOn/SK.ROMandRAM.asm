; S&K constants
SK_RAM_Start			equ	$FFFF0000
SK_Game_mode			equ	$FFFFF600
SK_TargetPal			equ	$FFFFFC80
SK_BS_mode			equ	$FFFFFFA0	; 0 = single stage, 1 = full game
SK_BS_progress			equ	$FFFFFFAB	; 0 = normal, -1 = disabled (single stage mode or using a code from single stage mode)
SK_alone_flag			equ	$FFFFFFAE	; -1 if Sonic 3 isn't locked on (which it isn't)
SK_Player_mode			equ	$FFFFFF08
; ---
; Jump locations
SK_Clear_DisplayData		equ	$000011CA

SK_SndDrvInit			equ	$000012CE

SK_Play_Music			equ	$00001358
SK_Play_SFX			equ	$00001380

SK_Clear_Nem_Queue		equ	$00001772
SK_Nem_Decomp			equ	$000015BA
SK_Nem_Decomp_To_RAM		equ	$000015CC
SK_Process_Nem_Queue_Init	equ	$00001780

SK_Add_To_DMA_Queue		equ	$00001526
SK_Load_PLC			equ	$000016FA
SK_Load_PLC_Raw			equ	$0000172C	; Loads a raw PLC from ROM | Input: a1 = address of the PLC

SK_Eni_Decomp			equ	$000018B4
SK_Kos_Decomp			equ	$00001A32

SK_Pal_FadeToBlack		equ	$00003BE4
SK_Pal_FadeToWhite		equ	$00003D30
SK_LoadPalette			equ	$00003DBE

SK_Wait_VSync			equ	$00001D18

SK_Perform_DPLC			equ	$00085022
SK_MoveSprite2			equ	$0001AB52
SK_Draw_Sprite			equ	$0001ABC6
SK_HurtCharacter		equ	$00010294
SK_Create_New_Sprite3		equ	$0001BAFA
SK_Reset_Player_Position_Array	equ	$00010DDA

; ---------------------------------------------------------------------------
; Object Status Table offsets
; ---------------------------------------------------------------------------
; universally followed object conventions:
SK_render_flags =		  4 ; bitfield ; refer to SCHG for details
SK_height_pixels =		  6 ; byte
SK_width_pixels =		  7 ; byte
SK_priority =			 8 ; word ; in units of $80
SK_art_tile =			$A ; word ; PCCVH AAAAAAAAAAA ; P = priority, CC = palette line, V = y-flip; H = x-flip, A = starting cell index of art
SK_mappings =			$C ; long
SK_x_pos =			$10 ; word, or long when extra precision is required
SK_y_pos =			$14 ; word, or long when extra precision is required
SK_mapping_frame =		$22 ; byte
; ---------------------------------------------------------------------------
; conventions followed by most objects:
SK_routine =		  5 ; byte
SK_x_vel =			$18 ; word
SK_y_vel =			$1A ; word
SK_y_radius =		$1E ; byte ; collision height / 2
SK_x_radius =		$1F ; byte ; collision width / 2
SK_anim =			$20 ; byte
SK_prev_anim =		$21 ; byte ; when this isn't equal to anim the animation restarts
SK_anim_frame =		$23 ; byte
SK_anim_frame_timer =	$24 ; byte
SK_angle =			$26 ; byte ; angle about axis into plane of the screen (00 = vertical, 360 degrees = 256)
SK_status =		$2A ; bitfield ; refer to SCHG for details
SK_lastFrame =		$3A ; last frame to compare for DPLC
; ---------------------------------------------------------------------------
; conventions followed by many objects but not Sonic/Tails/Knuckles:
SK_x_pixel =		x_pos ; word ; x-coordinate for objects using screen positioning
SK_y_pixel =		y_pos ; word ; y-coordinate for objects using screen positioning
SK_collision_flags =	$28 ; byte ; TT SSSSSS ; TT = collision type, SSSSSS = size
SK_collision_property =	$29 ; byte ; usage varies, bosses use it as a hit counter
SK_shield_reaction =	$2B ; byte ; bit 3 = bounces off shield, bit 4 = negated by fire shield, bit 5 = negated by lightning shield, bit 6 = negated by bubble shield
SK_subtype =		$2C ; byte
SK_ros_bit =		$3B ; byte ; the bit to be cleared when an object is destroyed if the ROS flag is set
SK_ros_addr =		$3C ; word ; the RAM address whose bit to clear when an object is destroyed if the ROS flag is set
SK_routine_secondary =	$3C ; byte ; used by monitors for this purpose at least
SK_vram_art =		$40 ; word ; address of art in VRAM (same as art_tile * $20)
SK_parent =		$42 ; word ; address of the object that owns or spawned this one, if applicable
SK_child_dx = 		$42 ; byte ; X offset of child relative to parent
SK_child_dy = 		$43 ; byte ; Y offset of child relative to parent
SK_parent3 = 		$46 ; word ; parent of child objects
SK_parent2 =		$48 ; word ; several objects use this instead
SK_respawn_addr =		$48 ; word ; the address of this object's entry in the respawn table
; ---------------------------------------------------------------------------
; conventions specific to Sonic/Tails/Knuckles:
SK_ground_vel =		$1C ; word ; overall velocity along ground, not updated when in the air
SK_double_jump_property =	$25 ; byte ; remaining frames of flight / 2 for Tails, gliding-related for Knuckles
SK_flip_angle =		$27 ; byte ; angle about horizontal axis (360 degrees = 256)
SK_status_secondary =	$2B ; byte ; see SCHG for details
SK_air_left =		$2C ; byte
SK_flip_type =		$2D ; byte ; bit 7 set means flipping is inverted, lower bits control flipping type
SK_object_control =	$2E ; byte ; bit 0 set means character can jump out, bit 7 set means he can't
SK_double_jump_flag =	$2F ; byte ; meaning depends on current character, see SCHG for details
SK_flips_remaining =	$30 ; byte
SK_flip_speed =		$31 ; byte
SK_move_lock =		$32 ; word ; horizontal control lock, counts down to 0
SK_invulnerability_timer =	$34 ; byte ; decremented every frame
SK_invincibility_timer =	$35 ; byte ; decremented every 8 frames
SK_speed_shoes_timer =	$36 ; byte ; decremented every 8 frames
SK_status_tertiary =	$37 ; byte ; see SCHG for details
SK_character_id =		$38 ; byte ; 0 for Sonic, 1 for Tails, 2 for Knuckles
SK_scroll_delay_counter =	$39 ; byte ; incremented each frame the character is looking up/down, camera starts scrolling when this reaches 120
SK_next_tilt =		$3A ; byte ; angle on ground in front of character
SK_tilt =			$3B ; byte ; angle on ground
SK_stick_to_convex =	$3C ; byte ; used to make character stick to convex surfaces such as the rotating discs in CNZ
SK_spin_dash_flag =	$3D ; byte ; bit 1 indicates spin dash, bit 7 indicates forced roll
SK_spin_dash_counter =	$3E ; word
SK_jumping =		$40 ; byte
SK_interact =		$42 ; word ; RAM address of the last object the character stood on
SK_default_y_radius =	$44 ; byte ; default value of y_radius
SK_default_x_radius =	$45 ; byte ; default value of x_radius
SK_top_solid_bit =		$46 ; byte ; the bit to check for top solidity (either $C or $E)
SK_lrb_solid_bit =		$47 ; byte ; the bit to check for left/right/bottom solidity (either $D or $F)


; ---------------------------------------------------------------------------
; Player Status Variables
SK_Status_Facing       = 0
SK_Status_InAir        = 1
SK_Status_Roll         = 2
SK_Status_OnObj        = 3
SK_Status_RollJump     = 4
SK_Status_Push         = 5
SK_Status_Underwater   = 6

; ---------------------------------------------------------------------------
; Player status_secondary variables
SK_Status_Shield       = 0
SK_Status_Invincible   = 1
SK_Status_SpeedShoes   = 2

SK_Status_FireShield   = 4
SK_Status_LtngShield   = 5
SK_Status_BublShield   = 6

; ---------------------------------------------------------------------------
; Elemental Shield DPLC variables
SK_shield_prev_frame   = $34
SK_shield_art          = $38
SK_shield_plc          = $3C

; ---------------------------------------------------------------------------
SK_Debug_placement_mode	=	$FFFFFE08
SK_Debug_placement_type	=	$FFFFFE09
SK_Debug_Mode_Flag	=	$FFFFFFDA

SK_Ctrl_1_logical	=	$FFFFF602   ; both held and pressed
SK_Ctrl_1_held_logical	=	$FFFFF602   
SK_Ctrl_1_pressed_logical =	$FFFFF603   
SK_Ctrl_1		=	$FFFFF604   ; both held and pressed
SK_Ctrl_1_held		=	$FFFFF604   ; all held buttons
SK_Ctrl_1_pressed	=	$FFFFF605 
SK_Ctrl_1_LOCKED	= 	$FFFFF7CA


SK_MAX_SPEED		=	$FFFFF760
SK_ACCELERATION		=	$FFFFF762
SK_DECELERATION		=	$FFFFF764
SK_ArtTile_Player_1	=	$0680
SK_ArtTile_Player_2	=	$06A0
SK_Super_Sonic_Knux_flag =	$FFFFFE19

SK_Camera_X_pos_copy	=	$FFFFEE80
SK_Camera_Y_pos_copy	=	$FFFFEE84
SK_Screen_Y_wrap_value	=	$FFFFEEAA

SK_last_star_post_hit		= $FFFFFE2A
SK_special_bonus_entry_flag	= $FFFFFE48 

SK_Level_frame_counter		= $FFFFFE04


SK_Saved_last_star_post_hit	= $FFFFFE2B
SK_Saved_zone_and_act		= $FFFFFE2C
SK_Saved_X_pos			= $FFFFFE2E
SK_Saved_Y_pos			= $FFFFFE30
SK_Saved_ring_count		= $FFFFFE32
SK_Saved_timer			= $FFFFFE34
SK_Saved_art_tile		= $FFFFFE38
SK_Saved_solid_bits		= $FFFFFE3A	; copy of Player 1's top_solid_bit and lrb_solid_bit
SK_Saved_camera_X_pos		= $FFFFFE3C
SK_Saved_camera_Y_pos		= $FFFFFE3E
SK_Saved_mean_water_level	= $FFFFFE40
SK_Saved_water_full_screen_flag	= $FFFFFE42
SK_Saved_extra_life_flags	= $FFFFFE43
SK_Saved_camera_max_Y_pos	= $FFFFFE44
SK_Saved_dynamic_resize_routine	= $FFFFFE46
SK_Saved_status_secondary	= $FFFFFE47
SK_Special_bonus_entry_flag	= $FFFFFE48



SK_Camera_min_Y_pos 	=	$FFFFEE18

SK_Screen_Y_wrap_value	=	$FFFFEEAA

SK_Primary_Angle	=	$FFFFF768
SK_Secondary_Angle	=	$FFFFF76A
SK_reverse_gravity_flag	=	$FFFFF7C6
SK_windtunnel_flag	=	$FFFFF7C8

SK_Super_Stars		=	$FFFFCBC0

SK_PlayerAbility1	=	SK_spin_dash_counter
SK_PlayerAbility2	=	SK_spin_dash_counter+1

SK_Ring_count		=	$FFFFFE20

SK_object_size		=	$4A

SK_Player_1		=	$FFFFB000
SK_Player_2		=	SK_Player_1+SK_object_size
SK_Reserved_object_3	=	SK_Player_2+SK_object_size
SK_Dynamic_object_RAM	= 	SK_Reserved_object_3+SK_object_size*90

; ---------------------------------------------------------------------------