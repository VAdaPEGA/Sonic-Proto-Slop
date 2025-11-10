; ===========================================================================
; ---------------------------------------------------------------------------
; Object 0F - Mappings test?
; ---------------------------------------------------------------------------

Obj0F:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj0F_Index(pc,d0.w),d1
		jsr	Obj0F_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
Obj0F_Index:	dc.w loc_B416-Obj0F_Index
		dc.w loc_B438-Obj0F_Index
		dc.w loc_B438-Obj0F_Index
; ===========================================================================

loc_B416:
		addq.b	#2,routine(a0)
		move.w	#$90,x_pixel(a0)
		move.w	#$90,y_pixel(a0)
		move.l	#Map_Obj0F,mappings(a0)
		move.w	#$680,art_tile(a0)
		bsr.w	Adjust2PArtPointer

loc_B438:
		move.b	(Ctrl_1_Press).w,d0
		btst	#5,d0		; has C been pressed?
		beq.s	loc_B44C	; if not, branch
		addq.b	#1,mapping_frame(a0)	; increment mappings
		andi.b	#$F,mapping_frame(a0)	; if above $F, reset

loc_B44C:
		btst	#4,d0		; has B been pressed?
		beq.s	locret_B458	; if not, branch
		bchg	#0,(Two_player_mode+1).w	; set unused variable... which crashes the game?

locret_B458:
		rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Map_Obj0F:	dc.w word_B47A-Map_Obj0F ; DATA	XREF: ROM:0000B426o
					; ROM:Map_Obj0Fo ...
		dc.w word_B484-Map_Obj0F
		dc.w word_B48E-Map_Obj0F
		dc.w word_B498-Map_Obj0F
		dc.w word_B4A2-Map_Obj0F
		dc.w word_B4AC-Map_Obj0F
		dc.w word_B4B6-Map_Obj0F
		dc.w word_B4C0-Map_Obj0F
		dc.w word_B4CA-Map_Obj0F
		dc.w word_B4D4-Map_Obj0F
		dc.w word_B4DE-Map_Obj0F
		dc.w word_B4E8-Map_Obj0F
		dc.w word_B4F2-Map_Obj0F
		dc.w word_B4FC-Map_Obj0F
		dc.w word_B506-Map_Obj0F
		dc.w word_B510-Map_Obj0F
word_B47A:	dc.w 1			; DATA XREF: ROM:Map_Obj0Fo
		dc.w	 0,    0,    0,	   0; 0
word_B484:	dc.w 1			; DATA XREF: ROM:0000B45Co
		dc.w	 1,    0,    0,	   0; 0
word_B48E:	dc.w 1			; DATA XREF: ROM:0000B45Eo
		dc.w	 2,    0,    0,	   0; 0
word_B498:	dc.w 1			; DATA XREF: ROM:0000B460o
		dc.w	 3,    0,    0,	   0; 0
word_B4A2:	dc.w 1			; DATA XREF: ROM:0000B462o
		dc.w	 4,    0,    0,	   0; 0
word_B4AC:	dc.w 1			; DATA XREF: ROM:0000B464o
		dc.w	 5,    0,    0,	   0; 0
word_B4B6:	dc.w 1			; DATA XREF: ROM:0000B466o
		dc.w	 6,    0,    0,	   0; 0
word_B4C0:	dc.w 1			; DATA XREF: ROM:0000B468o
		dc.w	 7,    0,    0,	   0; 0
word_B4CA:	dc.w 1			; DATA XREF: ROM:0000B46Ao
		dc.w	 8,    0,    0,	   0; 0
word_B4D4:	dc.w 1			; DATA XREF: ROM:0000B46Co
		dc.w	 9,    0,    0,	   0; 0
word_B4DE:	dc.w 1			; DATA XREF: ROM:0000B46Eo
		dc.w	$A,    0,    0,	   0; 0
word_B4E8:	dc.w 1			; DATA XREF: ROM:0000B470o
		dc.w	$B,    0,    0,	   0; 0
word_B4F2:	dc.w 1			; DATA XREF: ROM:0000B472o
		dc.b   0, $C,  0,  0	; 0
		dc.b   0,  0,  0,  0	; 4
word_B4FC:	dc.w 1			; DATA XREF: ROM:0000B474o
		dc.b   0, $D,  0,  0	; 0
		dc.b   0,  0,  0,  0	; 4
word_B506:	dc.w 1			; DATA XREF: ROM:0000B476o
		dc.w	$E,    0,    0,	   0; 0
word_B510:	dc.w 1			; DATA XREF: ROM:0000B478o
		dc.w	$F,    0,    0,	   0; 0
off_B51A:	dc.w byte_B51C-off_B51A	; DATA XREF: ROM:off_B51Ao
byte_B51C:	dc.b   7,  0,  1,  2,  3,  4,  5,  6; 0	; DATA XREF: ROM:off_B51Ao
		dc.b   7,$FE,  2,  0	; 8
off_B528:	dc.w byte_B52A-off_B528	; DATA XREF: ROM:off_B528o
byte_B52A:	dc.b $1F,  0,  1,$FF	; 0 ; DATA XREF: ROM:off_B528o
Map_S1Obj0F:	dc.w word_B536-Map_S1Obj0F ; DATA XREF:	ROM:Map_S1Obj0Fo
					; ROM:0000B530o ...
					; leftover from	Sonic 1
		dc.w word_B538-Map_S1Obj0F ; leftover from Sonic 1
		dc.w word_B56A-Map_S1Obj0F ; leftover from Sonic 1
		dc.w word_B65C-Map_S1Obj0F ; leftover from Sonic 1
word_B536:	dc.w 0			; DATA XREF: ROM:Map_S1Obj0Fo
word_B538:	dc.w 6			; DATA XREF: ROM:0000B530o
		dc.w	$C,  $F0,  $78,	   0; 0
		dc.w	 0,  $F3,  $79,	 $20; 4
		dc.w	 0,  $F3,  $79,	 $30; 8
		dc.w	$C,  $F4,  $7A,	 $38; 12
		dc.w	 8,  $F8,  $7C,	 $60; 16
		dc.w	 8,  $FB,  $7D,	 $78; 20
word_B56A:	dc.w $1E		; DATA XREF: ROM:0000B532o
		dc.w $B80F,    0,    0,$FF80; 0
		dc.w $B80F,    0,    0,$FF80; 4
		dc.w $B80F,    0,    0,$FF80; 8
		dc.w $B80F,    0,    0,$FF80; 12
		dc.w $B80F,    0,    0,$FF80; 16
		dc.w $B80F,    0,    0,$FF80; 20
		dc.w $B80F,    0,    0,$FF80; 24
		dc.w $B80F,    0,    0,$FF80; 28
		dc.w $B80F,    0,    0,$FF80; 32
		dc.w $B80F,    0,    0,$FF80; 36
		dc.w $D80F,    0,    0,$FF80; 40
		dc.w $D80F,    0,    0,$FF80; 44
		dc.w $D80F,    0,    0,$FF80; 48
		dc.w $D80F,    0,    0,$FF80; 52
		dc.w $D80F,    0,    0,$FF80; 56
		dc.w $D80F,    0,    0,$FF80; 60
		dc.w $D80F,    0,    0,$FF80; 64
		dc.w $D80F,    0,    0,$FF80; 68
		dc.w $D80F,    0,    0,$FF80; 72
		dc.w $D80F,    0,    0,$FF80; 76
		dc.w $F80F,    0,    0,$FF80; 80
		dc.w $F80F,    0,    0,$FF80; 84
		dc.w $F80F,    0,    0,$FF80; 88
		dc.w $F80F,    0,    0,$FF80; 92
		dc.w $F80F,    0,    0,$FF80; 96
		dc.w $F80F,    0,    0,$FF80; 100
		dc.w $F80F,    0,    0,$FF80; 104
		dc.w $F80F,    0,    0,$FF80; 108
		dc.w $F80F,    0,    0,$FF80; 112
		dc.w $F80F,    0,    0,$FF80; 116
word_B65C:	dc.w 1			; DATA XREF: ROM:0000B534o
		dc.w $FC04,    0,    0,$FFF8; 0