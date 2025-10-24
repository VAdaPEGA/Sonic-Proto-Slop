A ROM Hack based on the Nick Arcade Prototype of S2.

Many things planned, stay tunned.

While working on this, here's a bunch of stuff we found:

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