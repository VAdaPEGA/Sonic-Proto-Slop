A ROM Hack based on the Nick Arcade Prototype of S2.

Many things planned, stay tunned.

While working on this, here's a bunch of stuff we found:

- The leaning forward running animations for Sonic is a direct consequence of the 12 frame walk cycle to reallign the angled sprites without needing an extra routine (12/3 = 4, 3 running sets)
  - Undone after it's been readjusted to 8 frames (which dimplified the math compared to S1)

- Monitors flip if you land on top of it without rolling depending on the last state of d6
  - Fixed when Tails' interaction with the monitors were implemented (Censor)

- When too many sprite pieces are being displayed, it starts corrupting Water palette data
  - Hackjob fixed in Sonic 2 (after Beta 8, Final) by moving the palette address away, but still affects normal palette if the last drawn sprite has 16 pieces or more
  - Fixed in S3 (Nov 3 1993 Proto) when sprite drawing routine was revamped, freeing RAM

- Bridge object overwrites RAM when near all object slots are filled, destroying Path A collision
  - Same appliest to the Waterfalls in Hidden Palace
  - Circumvented accidentally in Sonic 2 (After Beta 4, around Beta 5) with Reserved slots following level object RAM, causing instead to mess up and delete Tails' Tails
  - Hackjob fixed in S3 (Nov 3 1993 Proto) with a dummy reserved object slot but can still cause the game to crash

- Path swappers support 8 objects (Only Player 1 and 2 are used) and only function when EXITING a collision box (16 wide/high depending on orientation)
  - Changed in a later prototype (Sep 14, 1992 Proto), dropping the 8 object support and making it based on the center point

- Buzzer's shot Hitbox is misplaced, visually mapped to come from the cannon but collision is based on Buzzer's center point
  - Partially Fixed in Simon Wai, never corrected in the final, still off by 8 pixels I'm SO MAD

- In the Object Place Mode list for GHZ, Lamp Post uses the same VRAM location as the rings, meaning they used the Lamp Post as the basis for the creation of the Path/Layer Switcher Object
  - Additionally, for CPZ / LZ, the first Path/Layer Swapper entry uses the Ring's Sparkle as the VRAM location in Sonic 1
    - Likely another leftover from when MZ occupied Zone Slot 1 as there's also an entry for the Sonic 1 Springs before going into CPZ objects
    - There's also a test version of the CPZ Platform using the Swinging Platform object, the mappings nearly match asside VRAM location being offset by 8
      - The unknown test platform object (Obj0C) happens to be 8 tiles big and uses the same VRAM location in the list

- EHZ was once the object playground for everything, with unreferenced Object Place mode entries for Badniks meant for HPZ and HTZ