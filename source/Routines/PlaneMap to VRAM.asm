; ---------------------------------------------------------------------------
; Subroutines to transfer a plane map to VRAM
; ---------------------------------------------------------------------------
; control register:
;    CD1 CD0 A13 A12 A11 A10 A09 A08     (D31-D24)
;    A07 A06 A05 A04 A03 A02 A01 A00     (D23-D16)
;     ?   ?   ?   ?   ?   ?   ?   ?      (D15-D8)
;    CD5 CD4 CD3 CD2  ?   ?  A15 A14     (D7-D0)
;
;	A00-A15 - address
;	CD0-CD3 - code
;	CD4 - 1 if VRAM copy DMA mode. 0 otherwise.
;	CD5 - DMA operation
;
;	Bits CD3-CD0:
;	0000 - VRAM read
;	0001 - VRAM write
;	0011 - CRAM write
;	0100 - VSRAM read
;	0101 - VSRAM write
;	1000 - CRAM read
;
; d0 = control register
; d1 = width
; d2 = heigth
; a1 = source address
; ---------------------------------------------------------------------------

PlaneMapToVRAM_H20:
		move.l	#$400000,d4
		bra.s	PlaneMapToVRAM_StartLoop
PlaneMapToVRAM_H40:
		move.l	#$800000,d4
PlaneMapToVRAM_StartLoop:
		lea	(VDP_data_port).l,a6	
	@LineLoop:
		move.l	d0,4(a6)
		move.w	d1,d3

	@TileLoop:
		move.w	(a1)+,(a6)
		dbf	d3,@TileLoop
		add.l	d4,d0
		dbf	d2,@LineLoop
		rts