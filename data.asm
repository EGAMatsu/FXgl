.include "hdr.asm"

.section ".rodata0" superfree

tilfont:
    .incbin "pvsneslibfont.pic"

palfont:
    .incbin "pvsneslibfont.pal"

.ends

.section ".superFX_code" superfree

superFX_pixel_program:
    .incbin "superfx/plotPixel.bin"

.ends