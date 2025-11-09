hitboxmap:	dc.w	@hitboxmap1-hitboxmap
		dc.w	@hitboxmap2-hitboxmap
		dc.w	@hitboxmap3-hitboxmap
	@hitboxmap1: 	dc.w 1
	MAP_Entry	0,0,0,($FF80/$20),1,0,0,0
	@hitboxmap2: 	dc.w 1
	MAP_Entry	-8,-8,0,($FF80/$20),1,0,1,1
	@hitboxmap3: 	dc.w 1
	MAP_Entry	-3,-3,0,($FF80/$20+2),1,0,0,0