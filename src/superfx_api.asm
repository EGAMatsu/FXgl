.include "hdr.asm"

.SECTION ".superFX_API_CPU" SUPERFREE

.ACCU 16
.INDEX 16
.16bit

;-------------------------------------------------------------------------------
;GSU MMIO Registers (mirrored in banks 00h-3Fh and 80h-BFh)
;During GSU operation, only SFR, SCMR, and VCR may be accessed

GSU_R0          = $3000 ;Default source/destination
GSU_R1          = $3002 ;PLOT instruction X coordinate
GSU_R2          = $3004 ;PLOT instruction Y coordinate
GSU_R3          = $3006 ;General purpose
GSU_R4          = $3008 ;LMULT instruction, lower 16 bits of result
GSU_R5          = $300a ;General purpose
GSU_R6          = $300c ;FMULT and LMULT instructions, multiplication
GSU_R7          = $300e ;MERGE instruction, source 1
GSU_R8          = $3010 ;MERGE instruction, source 2
GSU_R9          = $3012 ;General purpose
GSU_R10         = $3014 ;General purpose (stack pointer by convention)
GSU_R11         = $3016 ;LINK instruction destination
GSU_R12         = $3018 ;LOOP instruction counter
GSU_R13         = $301a ;LOOP instruction branch address
GSU_R14         = $301c ;Game Pak ROM address pointer (for GETxx instructions)
GSU_R15         = $301e ;Program counter, write MSB to start operation

GSU_SFR         = $3030 ;Status/Flag Register
GSU_PBR         = $3034 ;Program Bank Register
GSU_ROMBR       = $3036 ;Game Pak ROM Bank Register
GSU_RAMBR       = $303c ;Game Pak RAM Bank Register
GSU_CBR         = $303e ;Cache Base Register
GSU_SCBR        = $3038 ;Screen Base Register
GSU_SCMR        = $303a ;Screen Mode Register

GSU_BRAMR       = $3033 ;Back-up RAM Register
GSU_VCR         = $303b ;Version Code Register
GSU_CFGR        = $3037 ;Config Register
GSU_CLSR        = $3039 ;Clock Select Register

GSU_CACHE       = $3100 ;GSU Cache RAM

GSU_SRAM        = $700000
VRAM_SIZE       = $8000
CODE_SIZE       = $03FF

MEMLOCTST       = 0


//---------------------------------------------------------------------------------
// void copySuperFXProgram()
copySuperFXProgram:
    php                                             ; Push processor status

    ldx     #0                                              ; Initialize X register to 0
    ldy     #CODE_SIZE
    sty     MEMLOCTST

copyLoop:
    lda.l   superFX_pixel_program, x
    sta     GSU_SRAM, x                             ; Store the byte to GSU's RAM
    inx
    cpx     MEMLOCTST                               ; Compare X with the size of the program
    bne     copyLoop                                ; If not equal, repeat the loop

    plp                 ; Pull processor status
    rtl                 ; Return from subroutine

//---------------------------------------------------------------------------------
// void cleanSuperFX_RAM()
cleanSuperFX_RAM:
    php                                             ; Push processor status
    phb

    sep     #$20    ; 8 bit a

    lda      #$70
    pha
    plb                                             ; DB = $70

    ldx     #0                                      ; Initialize X register to 0
    ldy     #VRAM_SIZE
    sty     MEMLOCTST

cleanLoop:
    stz     0, x                                    ; clean the byte to GSU's RAM
    inx
    cpx     MEMLOCTST                               ; Compare X with the size of the program
    bne     cleanLoop                               ; If not equal, repeat the loop

    plb
    plp                 ; Pull processor status
    rtl                 ; Return from subroutine

//---------------------------------------------------------------------------------
// void SuperFXInit()
SuperFXInit:
    php
    phb

    sep  #$20
; 8 bit a
    lda  #$80
    pha
    plb
; DB = $80

        ;Configure GSU
        ;sep     #$30
        lda     #$70
        sta     GSU_PBR
        lda     #$10
        sta     GSU_SCBR
        lda     #%00001110
        sta     GSU_SCMR
        lda     #%10000000
        sta     GSU_CFGR
        lda     #$00
        sta     GSU_CLSR

    plb
    plp
    rtl                 ; Return from subroutine

//---------------------------------------------------------------------------------
// void executeSuperFX_asm()
executeSuperFX_asm:
    php
    phb

    sep  #$20
; 8 bit a
    lda  #$80
    pha
    plb
; DB = $80

    ldx     #$00      ; TODO, Program offsets.
    stx     (GSU_R15)

    plb
    plp
    rtl                 ; Return from subroutine

.ENDS