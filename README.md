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

- The Ring collision routine checks for Sonic 1's Ducking frame to change the bounding box, which points to a diagonal walking frame in Nick Arcade. (It points to one of Tails's Running frames that go unused in this build)
  - Tails never changes collision when ducking because the frame it checks for is out of bounds.

- Sonic's "grabbed" animation from CPZ uses the wrong frame data, erroneously using the back-left frames from the LZ/WFZ spin. Suggesting a different frame order as it's not a direct 1:1 copy from S1.
  - Curiously, the unused Leaping, Slide and shrinking animations still use the S1 frame data, completely unchanged.

- The order of Tails's frames remained mostly the same throughout Sonic 2, the animation data however, was very unfinished despite most sprites being present.
  - There are copies of Sonic's animations still in Tails's scripts, such as the Wall Recoil, suggesting it was copied after that had been implemented.
    - The Wall Recoil Animation data remains untouched in Sonic 2 Final and S3 Beta (Nov 3 1993 Proto)
      - One of the Animations remains unchanged in S3K Final, the second was replaced by hang sprite in MGZ, but the last got replaced by an unknown animation (9, $A4, $9B, $FF), likely an extra teeter animation.
    - Curiously, unlike some other animations that use placeholder frames, the shrinking animation slot uses a single death frame.
  - Rolling animation doesn't take speed into account due to a missing flag, they likely tested Tails using Sonic's object at one point and didn't want the animation data to be overwritten by the speed routine.
    - Frame data is also backwards compared to the mappings, suggesting whoever imported the frames didn't know it was meant to move to the right.
  - Balancing and Pushing seem to be test animations
    - Curiously, the Pushing set seem to encompass most of the tail idle animations but goes one over, suggesting that the tail idle used to be 6 frames.
    - Skidding has two frames, meaning the system they had going for animations may not had the correct offset