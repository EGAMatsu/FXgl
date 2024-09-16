
#include <snes.h>
#include <stdint.h>

#include "SuperFX.h"

extern char tilfont, palfont;

int main(void)
{
    consoleInit();

    cleanSuperFX();
    SuperFXInit();
    consoleMesenBreakpoint();
    cleanSuperFX_RAM();
    copySuperFXProgram();

    uint8_t ii;
    for (ii = 0; ii < 16; ii++) {
        setColor_forPalette(ii*16, ii*16, ii*16, 1, ii);
    }
    

    // Initialize text console with our font
    consoleSetTextVramBGAdr(0x6800);
    consoleSetTextVramAdr(0x5000);
    consoleSetTextOffset(0x0300);
    consoleInitText(0, 16 * 2, &tilfont, &palfont);

    // Init background
    bgSetGfxPtr(0, 0x2000);
    bgSetMapPtr(0, 0x6800, SC_32x32);
    bgSetGfxPtr(1, 0x0000);
    bgSetMapPtr(1, 0x7000, SC_32x32);

    // Now Put in 16 color mode and disable Bgs except current
    setMode(BG_MODE1, 0);
    bgSetDisable(2);
    bgSetScroll(1, 0, -1);

    u16 inc;
    uint8_t xx;
    uint8_t yy;
    for (xx = 0; xx < 32; xx++) {
        for (yy = 0; yy < 32; yy++) {
            canvas_tilesmap[(yy * 32) + xx] = (0) + (1 << 10);
        }
    }
    for (xx = 0; xx < 28; xx++) {
        for (yy = 0; yy < 20; yy++) {
            canvas_tilesmap[((yy+2) * 32) + (xx+4)] = (((xx * 20) + yy)+1) + (1 << 10);
        }
    }
    /*for (inc = 0x0; inc < 0x400; inc++) {
        canvas_tilesmap[inc] =  + (1 << 10);
    }*/


    consoleDrawText(4, 1, "SuperFX test");
    WaitForVBlank();
    dmaCopyVram(&canvas_tilesmap[0], 0x7000, 0x700);
    setScreenOn();

    while (1)
    {
        // for (c2 = 0; c2 < 0x08; c2++)
        //{
        plotPixel_GSU(c1/4, c1, ((c1)%14)+1);
        plotPixel_GSU(c1, c1/4, ((c1/2)%14)+1);
        plotBox_GSU(0, 0, SFX_ScreenWidth, SFX_ScreenHeight, ((c1)%14)+1);
        
        /*plotPixel_GSU(c1/4, c1, 15);
        plotPixel_GSU(c1, c1/4, 14);
        
        plotPixel_GSU(c1, 0, 10);
        plotPixel_GSU(0, c1, 12);*/

        /*plotPixel_GSU(c1, SFX_ScreenHeight/2, 4);
        plotPixel_GSU(SFX_ScreenWidth/2, c1, 5);

        plotPixel_GSU(c1, SFX_ScreenHeight, 8);
        plotPixel_GSU(SFX_ScreenWidth, c1, 6);*/
        c1++;
        //}

        WaitForVBlank();

        if ((snes_vblank_count%5) == 3) {
            uint8_t rc = 0;
            for (rc = 0; rc < 9; rc++) {                // For some reason
                dmaCopyVram(0x704000, 0x0010, 0x3C00);
            }
        }
    }
    return 0;
}