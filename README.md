Brainstorm
====

Chipmunk. Jam.

Chimpunks love to collect things, run into their burrows with full cheecks, and
store away for the long Canadian winter.

This could work as a top-down style game using the mouse. You're in a constant
state of running through various bush/burrows/rocks, collecting things, filling
up your cheecks. The "jam" comes where other chipmunks can get in your way, or
other animals in general. A SNAKE OH MAN

The concept is simple. You use your mouse to move the chipmunk. It'll run to
that point at a speed slightler faster than the scrolling. The idea being is you
could run ahead if you want to beat other animals that are coming into the path
that you're aiming for. If you hit a wall, you're reset! Chipmunks have 3 lives
for some reason.

The game could simply last forever by randomly generating the upcoming
obstacles. "Levels" can be triggered, which may increase the density of other
things while lowering the availability of tunnels.

First steps:

* Constant movement of the screen with random, simple tiles placed on the map.
* Squirrel on screen follows mouse click. Does not have to finish before moving
  onto a new click.

Tile Placements
-------

What could occur here is we place a new tile down as soon as the top X of the
last one is below the viewport. This allows us to keep a constant stream of
tiles. The idea is that we randomly decide where to place openings. This value
is more prevelant early on, but as the game hits "levels", the amount of tunnels
decreases, eventually we only have ONE.

When we place a blocker, we can decide to keep it going, or end it there.
Perhaps a tile should have attributes that if it's "continued", then it keeps
going for that range specified. It can also have an end tile. Basically, we'd be
creating classes of tiles.

