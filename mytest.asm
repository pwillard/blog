;-------------------------------------------
; Use Color Computer 80 Column mode from ASM
;-------------------------------------------
; Defines color palette values for background and foreground colors
; this stuff comes from George Jannsen
;-------------------------------------------
Black	equ	$00
Blue	equ	$08
Gray	equ	$38
Green	equ	$10
Orange	equ	$34
Red	    equ	$20
White	equ	$3F
Yellow	equ	$36
;--------------------------------------------
;  Palette information
;--------------------------------------------
;       Background 0-7
;       $FFB0 = $00 = Black
;       $FFB1 = $08 = Blue
;       $FFB2 = $07 = Gray
;       $FFB3 = $10 = Green
;       $FFB4 = $34 = Orange
;       $FFB5 = $20 = Red
;       $FFB6 = $3F = White
;       $FFB7 = $36 = Yellow
;
;       Foreground 8-F
;       $FFB8 = $00 = Black
;       $FFB9 = $08 = Blue
;       $FFBA = $38 = Gray
;       $FFBB = $10 = Green
;       $FFBC = $34 = Orange
;       $FFBD = $20 = Red
;       $FFBE = $3F = White
;       $FFBF = $36 = Yellow 
;--------------------------------------------
; MMU REGS
;--------------------------------------------
MM0	equ	$FFA0		; $0000 - $1FFF
MM1	equ	$FFA1		; $2000 - $3FFF
MM2	equ	$FFA2		; $4000 - $5FFF
MM3	equ	$FFA3		; $6000 - $7FFF
MM4	equ	$FFA4		; $8000 - $9FFF
MM5	equ	$FFA5		; $A000 - $BFFF
MM6	equ	$FFA6		; $C000 - $DFFF
MM7	equ	$FFA7		; $E000 - $FFFF
;--------------------------------------------
        org     $E00    ; start of PMODE screen code
start   clra            ; set a register to 0
        sta     $FFB0   ; set palette register 0 to 0 9 (black)
        lda     #White  ; Load the a register with 63
        sta     $FFB8   ; set the palette register 8 with 63 (white)
; Initialization complete, on to the screen
        lda     #$7E    ; Value for 80 column mode
        sta     $FF90   ; hi res
        lda     #$7B
        sta     $FF98   ; video mode
        lda     #$1F    ;
        sta     $FF99   ; video resolution
;--------------------------------------------
; Video display offset
        lda     #$36    ; MMU BLOCK ($6C000) 
        sta     MM2     ; ($4000 area)
; Set video offset to $D8
; Clear accumulator and store to video offset high byte
;--------------------------------------------
        lda     #$D8
        sta     $FF9D   ; Video Offset
        clra
        sta     $FF9E
;--------------------------------------------
; clear screen routine
;--------------------------------------------
        lda     #$20    ; 20 = space character
        ldb     #$00    ; Attribute
        ldx     #$4000  ; Start of video area
cls     std     ,x++    ; D register = A+B. Store D to X register
        cmpx    #$4F00  ; end of screen reached?
        bne     cls     ; Branch back to continue if "no"
;--------------------------------------------
        ldx     #TEXT   ; Get what we want to print
        ldy     #$4000  ; Start of video area
        ldb     #$20    ; length of TEXT string below
; TLOOP Transfers bytes from address in X to address in Y,
; decrementing B after each byte, repeating until B=0
tloop   lda     ,x+
        sta     ,y++
        decb
        bne     tloop
;--------------------------------------------
; infinite loop
;--------------------------------------------
loop    jmp     loop
;--------------------------------------------
; data
;---------------------------------------------
TEXT    fcc     'This is a test of 80 column mode'
        end     start
