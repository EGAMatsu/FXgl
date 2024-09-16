.MEMORYMAP
    SLOTSIZE $8000
    DEFAULTSLOT 0
    SLOT 0 $0000
.ENDME

.ROMBANKSIZE $8000
.ROMBANKS 1

.BANK 0 SLOT 0

;================================
;   Notes:
;       $3F00 is the program function switch, 0 would go to endProgram, and 1 would go to plotPixel for instance.
;================================

DesFunc = $3F00

;   Return to entrypoint macro
.macro return
    lm      R11, (returnToEntry)
    nop
    jmp     r11
.endm

;   Compare and jump macro, for the entrypoint so I don't have too like, have huge chunks of code bloating up the "clean-level" of the source.
.macro compare_and_jump isolated ARGS COMPARE, FUNCTION
    nop
    iwt     R5,         #COMPARE
    with    R3
    cmp     R5
        beq             (FUNCTION)
.endm

; The actual chip code.
.SECTION ".superFX_PixelPlot" SUPERFREE
    
    ;   This is the entry point, it will call all functions.
    Entry:
        ibt     R0,     #$FF        ; Set flag in RAM for the GPU being active.
        sm      ($3FFF), r0
        lm      R3,    (DesFunc)    ; LOAD the desired func.

        ; Do Comparisons and jumps
        compare_and_jump(#$01,   plotPixel  )
        compare_and_jump(#$02,   plotBox    )

        return
        
;=======================================================================
    plotPixel:
        rpix                    ; Flush Pixel Cache

        lm      R0, ($1002)     ; This is the color.
        color
        lm      R1, ($1003)     ; X Position for plot
        lm      R2, ($1004)     ; Y Position for plot.
        nop
        plot                    ; Plot Pixel
    
        return

;=======================================================================
    ;   Return to entry.
    returnToEntry:
        ibt     R0,     #$00    ; Set flag in RAM for the GPU being inactive.
        sm      ($3FFF), r0
        ibt     R3,     #$FF    ; Set desired program.
        sm      (DesFunc), r3
        nop
        bra Entry

;=======================================================================
    ;   End all execution and turn off chip
    endProgram:
        ibt     R0,     #$00    ; Set flag in RAM for the GPU being inactive.
        sm      ($3FFF), r0
        stop

;=======================================================================
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                       Plot a BOX. (Outline)
; r0     = colour
; r1,r2 = x,y
; r3,r4 = width,height
; r3-r10/r14 unchanged
    plotBox:
        rpix
        
        lm      R0, ($1002)     ; This is the color.
        color
        lm      R1, ($1003)     ; X Position for plot
        lm      R2, ($1004)     ; Y Position for plot.
        lm      R3, ($1005)     ; X Width for plot
        lm      R4, ($1006)     ; Y Height for plot.

        move    r12,r3    ; set loop size to width of box
        move    r13,r15    ; start of loop
        loop        ; draw the top line
        plot        ; commands are usually done in pairs so even though 
                    ; the plot command is after the loop end it still gets called

        move    r12,r4
        dec    r12
        dec    r12    ; height-2
        move    r13,r15
    ; vertical line loop
        inc    r2    ; inc y
        with    r1
        sub    r3
        plot        ; plot left side
        with    r1
        add    r3
        dec    r1
        dec    r1
        loop
        plot

        with    r1
        sub    r3    ; subtract width from x
        inc    r2
        move    r12,r3    ; width
        move    r13,r15
        loop        ; draw the bottom line
        plot

        return

;=======================================================================
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                       Plot a Triangle. (Outline)
; r0     = colour
; r1,r2 = x1, y1
; r3,r4 = x2, y2
; r5,r6 = x3, y3
; r3-r10/r14 unchanged
plotTriangle:
    rpix
    
    lm      R0, ($1002)     ; This is the color.
    color
    lm      R1, ($1003)     ; X1 Position for plot
    lm      R2, ($1004)     ; Y1 Position for plot.
    lm      R3, ($1005)     ; X2 Position for plot
    lm      R4, ($1006)     ; Y2 Position for plot.
    lm      R5, ($1007)     ; X3 Position for plot
    lm      R6, ($1008)     ; Y3 Position for plot.

    loop                    ; Render loop
        bra triangleRenderLoop_Filled_End

    triangleRenderLoop_Filled_End:
        return

.ENDS