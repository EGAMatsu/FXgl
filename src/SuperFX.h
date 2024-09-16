#ifndef SUPERFX_H
#define SUPERFX_H

#define SFX_ScreenWidth 191
#define SFX_ScreenHeight 159

// Define the SuperFX registers
#define GSU_R15u (*(volatile uint8_t *)0x301e)
#define GSU_R15l (*(volatile uint8_t *)0x301f)
#define GSU_CBR (*(volatile uint8_t *)0x3000)
#define GSU_PBR (*(volatile uint8_t *)0x3001)
#define GSU_PBR1 (*(volatile uint8_t *)0x3002)
#define GSU_ROMBR (*(volatile uint8_t *)0x3036)

#define GSU_CFGR    (*(volatile uint8_t *)0x3037)
#define GSU_CFBR    (*(volatile uint8_t *)0x3038)
#define GSU_CLSR    (*(volatile uint8_t *)0x3039)

#define GSU_PBR     (*(volatile uint8_t *)0x3034)
#define GSU_SCMR    (*(volatile uint8_t *)0x303A)
#define GSU_CACHE   (*(volatile uint8_t *)0x3100)

#define GSU_ACTIVE_FL (*(volatile uint8_t *)0x3FFF)

u16 c1;
u8 c2;

unsigned short canvas_tilesmap[0x400];

extern void SuperFXInit();
extern void copySuperFXProgram();
extern void executeSuperFX_asm();
extern void cleanSuperFX_RAM();

void cleanSuperFX() {
    int i = 0;
    for (i = 0; i < 0xA001; i++) {
        (*(volatile uint8_t *)(0x701000 + i)) = 0; 
    }
}

// Keep these functions in here.
void setSuperFX_Function(uint16_t functionCall) {
    (*(volatile uint8_t *)0x703F00) = (functionCall);
}

void executeSuperFX() {
    executeSuperFX_asm();
    while (GSU_ACTIVE_FL)
        ;
}

void plotPixel_GSU(uint8_t x, uint8_t y, uint8_t color)
{
    uint8_t isOverX = (x > SFX_ScreenWidth);
    uint8_t isOverY = (y > SFX_ScreenHeight);

    if (isOverX) {
        x = SFX_ScreenWidth;
    }
    if (isOverY) {
        y = SFX_ScreenHeight;
    }

    if (!(isOverX || isOverY)) {
        (*(volatile uint8_t *)0x701002) = color;
        (*(volatile uint8_t *)0x701003) = x;
        (*(volatile uint8_t *)0x701004) = y;
        setSuperFX_Function(1);
            executeSuperFX();
    }
}

void plotBox_GSU(uint8_t x, uint8_t y, uint8_t w, uint8_t h, uint8_t color)
{
    uint8_t isOverX = (x > SFX_ScreenWidth);
    uint8_t isOverY = (y > SFX_ScreenHeight);

    if (isOverX) {
        x = SFX_ScreenWidth;
    }
    if (isOverY) {
        y = SFX_ScreenHeight;
    }

    uint8_t isOverXW = ((x+w) > SFX_ScreenWidth);
    uint8_t isOverYH = ((y+h) > SFX_ScreenHeight);

    if (isOverXW) {
        w = (SFX_ScreenWidth - x);
    }
    if (isOverYH) {
        h = (SFX_ScreenHeight- y);
    }

    w++;
    h++;

    if (!(isOverX || isOverY) && !(isOverXW || isOverYH)) {
        (*(volatile uint8_t *)0x701002) = color;
        (*(volatile uint8_t *)0x701003) = x;
        (*(volatile uint8_t *)0x701004) = y;
        (*(volatile uint8_t *)0x701005) = w;
        (*(volatile uint8_t *)0x701006) = h;
        setSuperFX_Function(2);
            executeSuperFX();
    }
}

void plotTriangle_GSU(uint8_t x, uint8_t y, uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2, uint8_t color)
{
    uint8_t isOverX = (x > SFX_ScreenWidth);
    uint8_t isOverY = (y > SFX_ScreenHeight);

    if (isOverX) {
        x = SFX_ScreenWidth;
    }
    if (isOverY) {
        y = SFX_ScreenHeight;
    }

    uint8_t isOverX2 = x1;
    uint8_t isOverY2 = y1;

    if (isOverX2) {
        x1 = SFX_ScreenWidth;
    }
    if (isOverY2) {
        y1 = SFX_ScreenHeight;
    }

    uint8_t isOverX3 = x1;
    uint8_t isOverY3 = y1;

    if (isOverX3) {
        x2 = SFX_ScreenWidth;
    }
    if (isOverY3) {
        y2 = SFX_ScreenHeight;
    }

    if (!(isOverX || isOverY) && !(isOverX2 || isOverY2) && !(isOverX3 || isOverY3)) {
        (*(volatile uint8_t *)0x701002) = color;
        (*(volatile uint8_t *)0x701003) = x;
        (*(volatile uint8_t *)0x701004) = y;
        (*(volatile uint8_t *)0x701005) = x1;
        (*(volatile uint8_t *)0x701006) = y1;
        (*(volatile uint8_t *)0x701007) = x2;
        (*(volatile uint8_t *)0x701008) = y2;
        setSuperFX_Function(3);
            executeSuperFX();
    }
}

void setColor_forPalette(uint8_t r, uint8_t g, uint8_t b, uint8_t palette_number, uint8_t colorNumber) {
    uint16_t color = RGB5(r/8, g/8, b/8);
    uint8_t  index = ((palette_number*16) + colorNumber);
    setPaletteColor(index, color);
}
#endif