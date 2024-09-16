
# FXgl
A (Attempt at a) OpenGL-styled framework for rendering with the SuperFX GSU for the SNES with a C API (For use with DevKitSnes/pvsneslib)
## Some info
I really want the SuperFX to be accessable, especially the 3D functionality, hints this project.
Also before you ask about some of the weird choices here, (eg. putting code in header files)
I mostly started this as a attempt to make a SNES part of my game engine, I still want it to be flexable enough where you can install this as a sorta runtime/backend for the SNES.
Eg. If you have a GBA game engine, you can use this as the base for a SNES backend, even for 3D projects, hints the idea of OpenGL styled/exact syntax.

## How to compile
First, install [pvsneslib](https://github.com/alekmaul/pvsneslib), then inside the bin folder of devkitsnes (inside the pvsneslib root folder), install WLA-SuperFX from [here](https://github.com/vhelin/wla-dx/releases).

Then just run ``make`` within the root directory, else go into ``/superFX`` and run make there.
## Issues
It doesn't run on bsnes-plus/accurate, nor snes9x, which will be (and is) a issue.
Only tested to work in and on Mesen 2 and Ares.
