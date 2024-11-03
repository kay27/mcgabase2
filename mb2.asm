        TITLE   MB2

        .286

DATA    SEGMENT WORD PUBLIC

        EXTRN   gr256_col:BYTE,kp:BYTE,ek:BYTE,keyv:BYTE
        EXTRN   pixsizex:BYTE,pixsizey:BYTE
        EXTRN   key_left,key_right,key_up,key_down:BYTE

DATA    ENDS

CODE    SEGMENT BYTE PUBLIC

        ASSUME  CS:CODE,DS:DATA

        PUBLIC  Sgn,Color,Igraph,Clgraph,Cls
        PUBLIC  Clear,Plot,Setpal,Getpal,Key
        PUBLIC  Line,Point,Scan,Waiting,Mshow
        PUBLIC  Mhide,Rmouse,Mxr,Myr,Lp,Rp
        PUBLIC  Mcrd,Mset,Mpage,Pause,Circle
        PUBLIC  Print,Mwaitoff,Putpixel,Printsize
        PUBLIC  Chide,Cshow,Border,Textxy
        PUBLIC  Vset,Fill,Linec,Pixmethod

Sgn:
        Mov     BX,SP
        Mov     AX,SS:[BX+4]
        Or      AL,AH
        Jz      ENDSG
        Add     AH,AH
        Sbb     AL,AL
        Jc      ENDSG
        Inc     AL
ENDSG:  Retf    2

Color:
        Mov     BX,SP
        Mov     AX,SS:[BX+4]
        Mov     gr256_col,AL
        Retf    2

Igraph:
        Mov     AX,19
        Int     10h
        Retf

Clgraph:
        Mov     AX,3
        Int     10h
        Retf

Cls:
        Cld
        Mov     AX,Word Ptr gr256_col
        Mov     CX,0A000h
        Mov     AH,AL
        Mov     ES,CX
        Mov     CH,7Dh
        Sub     DI,DI
    REP Stosw
        Retf

Clear:
        Push    BP
        Cld
        Mov     BP,SP
        Mov     BX,[BP+6]
        Mov     BH,[BP+10]
        Cmp     BH,BL
        Jc      NOS1
        Xchg    BH,BL
NOS1:   Mov     SI,[BP+12]
        Mov     CX,[BP+8]
        Cmp     SI,CX
        Jle     NOS2
        Xchg    CX,SI
NOS2:   Mov     AX,Word Ptr gr256_col
        Mov     DX,0A000h
        Mov     AH,AL
        Mov     ES,DX
        Mov     DH,BH
        Mov     DI,DX
        Ror     DI,2
        Add     DI,DX
        Neg     DH
        Add     DH,BL
        Inc     DH
        Mov     BX,CX
        Mov     CX,SI
        Add     DI,SI
        Neg     SI
        Add     SI,BX
        Inc     SI
        Neg     BX
        Add     BX,320
        Add     BX,CX
        Dec     BX
        Shr     SI,1
        Jnc     CL1
CL2:    Mov     CX,SI
        Jcxz    CL3
REP     Stosw
CL3:    Stosb
        Add     DI,BX
        Dec     DH
        Jnz     CL2
        Jmp     CLEEND
CL1:    Mov     CX,SI
REP     Stosw
        Add     DI,BX
        Dec     DH
        Jnz     CL1
CLEEND: Pop     BP
        Retf    8

Plot:
        Mov     BX,SP
        Mov     CX,0A000h
        Mov     AX,SS:[BX+4]
        Mov     ES,CX
        Mov     CH,SS:[BX+6]
        Mov     BX,SS:[BX+8]
        Add     BH,CH
        Ror     CX,2
        Add     BX,CX
Plotex: Mov     ES:[BX],AL
        Retf    6

Setpal:
        Mov     BX,SP
        Mov     DX,3C8h
        Mov     AX,SS:[BX+10]
        Out     DX,AL
        Inc     DL
        Mov     AX,SS:[BX+8]
        Out     DX,AL
        Mov     AX,SS:[BX+6]
        Out     DX,AL
        Mov     AX,SS:[BX+4]
        Out     DX,AL
        Retf    8

Getpal:
        Mov     DX,3C7h
        Mov     BX,SP
        Mov     AX,SS:[BX+16]
        Out     DX,AL
        Mov     DL,0C9h
        Push    DS
        Lds     SI,SS:[BX+12]
        In      AL,DX
        Mov     [SI],AL
        In      AL,DX
        Lds     SI,SS:[BX+8]
        Mov     [SI],AL
        In      AL,DX
        Lds     SI,SS:[BX+4]
        Mov     [SI],AL
        Pop     DS
        Retf    14

Key:
        Xor     CX,CX
        Mov     AH,1h
        Int     16h
        Jz      KEYL1
        Xor     AX,AX
        Int     16h
        Inc     CX
KEYL1:  Mov     AX,CX
        Retf

Line:
        Push    BP
        Mov     AX,Word Ptr gr256_col
        Mov     BP,SP
Lineex1:Mov     Byte Ptr CS:[LNCOL],AL
        Mov     AX,0A000h
        Mov     DX,[BP+8]
        Mov     ES,AX
        Sub     DX,[BP+12]
        Mov     CX,[BP+6]
        Sub     CX,[BP+10]

        Or      DX,DX
        Jnz     LNL1

        Mov     Byte Ptr CS:[LND1X],90h
        Jmp     LNL2
LNL1:   Mov     Byte Ptr CS:[LND1X],48h
        Test    DX,8000h
        Jnz     LNL2
        Mov     Byte Ptr CS:[LND1X],40h
LNL2:   Jcxz    LNL3
        Mov     Word Ptr CS:[LND1Y],0CDFEh
        Test    CX,8000h
        Jnz     LNL4
        Mov     Word Ptr CS:[LND1Y],0C5FEh
        Jmp     LNL4
LNL3:   Mov     Word Ptr CS:[LND1Y],9090h
LNL4:   Mov     AL,Byte Ptr CS:[LND1X]
        Mov     Byte Ptr CS:[LND2X],AL
        Mov     Word Ptr CS:[LND2Y],9090h
        Mov     DI,DX
        Test    DI,8000h
        Jz      LNL5
        Neg     DI
LNL5:   Mov     SI,CX
        Test    SI,8000h
        Jz      LNL6
        Neg     SI
LNL6:   Cmp     SI,DI
        Jl      LNL7
        Mov     Byte Ptr CS:[LND2X],90h
        Mov     AX,Word Ptr CS:[LND1Y]
        Mov     Word Ptr CS:[LND2Y],AX
        Xchg    SI,DI
LNL7:   Mov     DX,DI
        Shr     DX,1
        Mov     Word Ptr CS:[LNCNT],0
        Mov     AX,[BP+12]
        Mov     CH,[BP+10]
        Xor     CL,CL
LNL8:   Mov     BX,CX
        Ror     BX,2
        Add     BH,CH
        Add     BX,AX
Lineex: Mov     Byte Ptr ES:[BX],123
LNCOL   EQU     $ - 1
        Inc     Word Ptr CS:[LNCNT]
        Add     DX,SI
        Cmp     DX,DI
        Jl      LND2X
        Sub     DX,DI
LND1X:  Nop
LND1Y:  Nop
        Nop
        Jmp     LNFIN
LND2X:  Nop
LND2Y:  Nop
        Nop
LNFIN:  Cmp     DI,12345
LNCNT   EQU     $ - 2
        Jge     LNL8

        Pop     BP
        Retf    8

Point:
        Mov     BX,SP
        Mov     CX,0A000h
        Mov     ES,CX
        Mov     CH,SS:[BX+4]
        Mov     BX,SS:[BX+6]
        Add     BH,CH
        Ror     CX,2
        Add     BX,CX
        Mov     AL,ES:[BX]
        Retf    4

Scan:
        Mov     AH,1h
        Int     16h
        Mov     kp,0
        Mov     key_left,0
        Mov     key_right,0
        Mov     key_up,0
        Mov     key_down,0
        Jz      SCNL1
        Inc     kp
        Xor     AH,AH
        Int     16h
        Mov     ek,0
        Or      AL,AL
        Jnz     SCNL2
        Inc     ek
        Mov     AL,AH
        Cmp     AH,4BH
        Jnz     SCNL5
        Mov     key_left,1
        Jmp     SCNL2
SCNL5:
        Cmp     AH,4DH
        Jnz     SCNL4
        Mov     key_right,1
        Jmp     SCNL2
SCNL4:
        Cmp     AH,48H
        Jnz     SCNL3
        Mov     key_up,1
        Jmp     SCNL2
SCNL3:
        Cmp     AH,50H
        Jnz     SCNL2
        Mov     key_down,1
SCNL2:  Mov     keyv,AL
SCNL1:  Retf

Waiting:
        Mov     DX,3DAh
W0:     In      AL,DX
        Test    AL,8h
        Jnz     W0
W1:     In      AL,DX
        Test    AL,8h
        Jz      W1
        Retf

Mshow:
        Mov     AX,1
        Int     33h
        Retf

Mhide:
        Mov     AX,2
        Int     33h
        Retf

Rmouse:
        Xor     AX,AX
        Int     33h
        Or      AL,AH
        Jz      RM1
        Mov     AL,1
RM1:    Retf

Mxr:
        Mov     BX,SP
        Mov     AX,7
        Mov     DX,SS:[BX+4]
        Mov     CX,SS:[BX+6]
        Int     33h
        Retf    4

Myr:
        Mov     AX,8
        Mov     BX,SP
        Mov     DX,SS:[BX+4]
        Mov     CX,SS:[BX+6]
        Int     33h
        Retf    4

Lp:
        Mov     AX,3
        Int     33h
        And     BL,1
        Mov     AL,BL
        Retf

Rp:
        Mov     AX,3
        Int     33h
        And     BL,2
        Shr     BL,1
        Mov     AL,BL
        Retf

Mcrd:
        Push    BP
        Mov     BP,SP
        Mov     AX,3
        Int     33h
        Les     SI,[BP+6]
        Mov     ES:[SI],DX
        Les     SI,[BP+10]
        Mov     ES:[SI],CX
        Pop     BP
        Retf    8

Mset:
        Mov     BX,SP
        Mov     AX,4
        Mov     CX,SS:[BX+6]
        Mov     DX,SS:[BX+4]
        Int     33h
        Retf    4

Mpage:
        Mov     BX,SP
        Mov     BX,SS:[BX]
        Mov     AX,1Dh
        Int     33h
        Retf

Pause:
        Xor     AH,AH
        Int     16h
        Retf

Circle:
        Push    BP
        Mov     BP,SP
        Mov     DX,[BP+8]
        Mov     AX,0A000h
        Mov     ES,AX
        Xor     SI,SI
        Mov     AL,gr256_col
        Mov     Byte Ptr CS:[CCLR],AL
        Mov     AX,[BP+6]
        Mov     DI,AX
        Mov     BP,[BP+10]
CCSKIP: Add     AX,AX
        Neg     AX
        Add     AX,3
CCWRKM: Mov     Byte Ptr CS:[RESTAL],AL
        Mov     AL,123
CCLR    EQU     $ - 1
        Mov     CX,BP
        Add     CX,SI
        Cmp     CX,320
        Jnc     CSKIP1
        Mov     BX,DX
        Add     BX,DI
        Cmp     BX,200
        Jnc     CSKIP1
        Xchg    BH,BL
        Add     CH,BH
        Ror     BX,2
        Add     BX,CX
Circex1:Mov     ES:[BX],AL
CSKIP1: Mov     CX,DI
        Add     CX,BP
        Cmp     CX,320
        Jnc     CSKIP2
        Mov     BX,SI
        Add     BX,DX
        Cmp     BX,200
        Jnc     CSKIP2
        Xchg    BH,BL
        Add     CH,BH
        Ror     BX,2
        Add     BX,CX
Circex2:Mov     ES:[BX],AL
CSKIP2: Mov     CX,DI
        Add     CX,BP
        Cmp     CX,320
        Jnc     CSKIP3
        Mov     BX,DX
        Sub     BX,SI
        Cmp     BX,200
        Jnc     CSKIP3
        Add     CH,BL
        Xchg    BH,BL
        Ror     BX,2
        Add     BX,CX
Circex3:Mov     ES:[BX],AL
CSKIP3: Mov     CX,BP
        Add     CX,SI
        Cmp     CX,320
        Jnc     CSKIP4
        Mov     BX,DX
        Sub     BX,DI
        Cmp     BX,200
        Jnc     CSKIP4
        Xchg    BH,BL
        Add     CH,BH
        Ror     BX,2
        Add     BX,CX
Circex4:Mov     ES:[BX],AL
CSKIP4: Mov     CX,BP
        Sub     CX,SI
        Cmp     CX,320
        Jnc     CSKIP5
        Mov     BX,DX
        Sub     BX,DI
        Cmp     BX,200
        Jnc     CSKIP5
        Add     CH,BL
        Xchg    BH,BL
        Ror     BX,2
        Add     BX,CX
Circex5:Mov     ES:[BX],AL
CSKIP5: Mov     CX,BP
        Sub     CX,DI
        Cmp     CX,320
        Jnc     CSKIP6
        Mov     BX,DX
        Sub     BX,SI
        Cmp     BX,200
        Jnc     CSKIP6
        Add     CH,BL
        Xchg    BH,BL
        Ror     BX,2
        Add     BX,CX
Circex6:Mov     ES:[BX],AL
CSKIP6: Mov     CX,BP
        Sub     CX,DI
        Cmp     CX,320
        Jnc     CSKIP7
        Mov     BX,DX
        Add     BX,SI
        Cmp     BX,200
        Jnc     CSKIP7
        Xchg    BH,BL
        Add     CH,BH
        Ror     BX,2
        Add     BX,CX
Circex7:Mov     ES:[BX],AL
CSKIP7: Mov     CX,BP
        Sub     CX,SI
        Cmp     CX,320
        Jnc     CSKIP8
        Mov     BX,DX
        Add     BX,DI
        Cmp     BX,200
        Jnc     CSKIP8
        Xchg    BH,BL
        Add     CH,BH
        Ror     BX,2
        Add     BX,CX
Circex8:Mov     ES:[BX],AL
CSKIP8: Mov     AL,123
RESTAL  EQU     $ - 1
        Test    AX,8000h
        Jz      CCWRK3
        Mov     CX,SI
        Shl     CX,2
        Add     AX,CX
        Add     AX,6
        Jmp     CCWRK4
CCWRK3: Mov     CX,SI
        Sub     CX,DI
        Shl     CX,2
        Add     AX,CX
        Add     AX,10
        Dec     DI
CCWRK4: Inc     SI
        Cmp     SI,DI
        Jg      TEMPOL2
        Jmp     Far Ptr CCWRKM
TEMPOL2:Pop     BP
        Retf    6

Print:
        Push    BP
        Mov     BP,SP
        Push    DS
        Mov     AL,Pixsizex
        Sub     AH,AH
        Mov     Word Ptr CS:[PRLABX],AX
        Mov     Word Ptr CS:[PRLABX2],AX
        Mov     AH,Pixsizey
        Mov     Word Ptr CS:[PRLABXY],AX
        Sub     AL,AL
        Xchg    AL,AH
        Mov     Word Ptr CS:[PRLABY],AX
        Mov     AL,gr256_col
        Mov     Byte Ptr CS:[PRLABC],AL
        Lds     BX,[BP+6]
        Mov     SI,[BP+12]
        Mov     DX,[BP+10]
        Mov     CL,[BX]
        Sub     CH,CH
        Jcxz    PREXT
PRIL1:  Inc     BX
        Mov     AL,[BX]
        Push    DS
        Push    BX
        Push    CX
        Sub     AH,AH
        Shl     AX,3
        Cmp     AX,400h
        Jc      PRIL2
        Sub     BX,BX
        Mov     ES,BX
        Les     BX,ES:[7Ch]
        And     AX,3FFh
        Add     BX,AX
        Jmp     PRIL3
PRIL2:  Mov     BX,0F000h
        Mov     ES,BX
        Mov     BX,0FA6Eh
        Add     BX,AX
PRIL3:  Mov     CX,0A000h
        Mov     DS,CX
        Mov     AH,123
PRLABC  EQU     $-1
        Mov     CH,8
        Mov     Word Ptr CS:[PRLAB1],SI
PR1C:   Mov     AL,Byte Ptr ES:[BX]
        Mov     CL,8
PR2C:   Add     AL,AL
        Jnc     PR3C
        Mov     BP,12345
PRLABXY EQU     $-2
        Mov     Word Ptr CS:[PRLAB2],SI
        Mov     Word Ptr CS:[PRLAB3],DX
PR4C:   Cmp     DX,200
        Jnc     PR5C
        Cmp     SI,320
        Jnc     PR5C
        Xchg    DH,DL
        Mov     DI,DX
        Ror     DI,2
        Add     DI,DX
        Xchg    DH,DL
        Add     DI,SI
Prinex: Mov     [DI],AH
PR5C:   Inc     SI
        Dec     BP
        Test    BP,255
        Jnz     PR4C
        Jmp     PRCNT
PRIL1T: Jmp     PRIL1
PREXT:  Jmp     PREX
PRCNT:  Add     BP,12345
PRLABX  EQU     $-2
        Mov     SI,12345
PRLAB2  EQU     $-2
        Inc     DX
        Sub     BP,256
        Test    BP,0FF00h
        Jnz     PR4C
        Mov     DX,12345
PRLAB3  EQU     $-2
PR3C:   Add     SI,12345
PRLABX2 EQU     $-2
        Dec     CL
        Jnz     PR2C
        Mov     SI,12345
PRLAB1  EQU     $-2
        Add     DX,12345
PRLABY  EQU     $-2
        Inc     BX
        Dec     CH
        Jnz     PR1C
        Mov     BX,Word Ptr CS:[PRLABX2]
        Shl     BX,3
        Add     SI,BX
        Mov     BX,Word Ptr CS:[PRLABY]
        Shl     BX,3
        Sub     DX,BX
        Pop     CX
        Pop     BX
        Pop     DS
        Loop    PRIL1T
PREX:   Pop     DS
        Pop     BP
        Retf    8

Mwaitoff:
MWOL1:  Mov     AX,3
        Int     33h
        And     BL,3
        Jnz     MWOL1
        Retf

Putpixel:
        Mov     BX,SP
        Mov     DX,SS:[BX+8]
        Cmp     DX,320
        Jnc     PLEX
        Mov     CX,0A000h
        Mov     ES,CX
        Mov     CX,SS:[BX+6]
        Cmp     CX,200
        Jnc     PLEX
        Mov     AL,SS:[BX+4]
        Mov     BH,CL
        Sub     BL,BL
        Ror     BX,2
        Add     BH,CL
        Add     BX,DX
Putpex: Mov     ES:[BX],AL
PLEX:   Retf    6

Printsize:
        Mov     BX,SP
        Mov     AL,SS:[BX+6]
        Mov     pixsizex,AL
        Mov     AL,SS:[BX+4]
        Mov     pixsizey,AL
        Retf    4

Chide:
        Sub     AX,AX
        Mov     ES,AX
        Mov     BH,ES:[462h]
        Mov     AH,3
        Int     10h
        Mov     AH,1
        Or      CH,30h
        Int     10h
        Retf

Cshow:
        Int     11h
        And     AL,30h
        Mov     CX,0B0Dh
        Cmp     AL,30h
        Je      CRSOSC
        Mov     CX,607h
CRSOSC: Mov     AX,40h
        Mov     ES,AX
        Mov     AH,1
        Int     10h
        Retf

Border:
        Mov     BX,SP
        Mov     AX,1001h
        Mov     BH,SS:[BX+4]
        Int     10h
        Retf    2

Textxy:
        Push    BP
        Mov     DX,0B800h
        Mov     BP,SP
        Mov     ES,DX
        Push    DS
        Mov     AH,gr256_col
        Mov     DI,[BP+12]
        Mov     DH,[BP+10]
        Add     DI,DI
        Mov     CX,DX
        Lds     BX,[BP+6]
        Ror     DX,1
        Add     DI,DX
        Ror     CX,3
        Add     DI,CX
        Xor     CX,CX
        Mov     CL,[BX]
        Jcxz    Wre1
        Inc     BX
Wre2:   Mov     AL,[BX]
        Mov     ES:[DI],AX
        Inc     BX
        Add     DI,2
        Loop    Wre2
Wre1:   Pop     DS
        Pop     BP
        Retf    8

Vset:
        Mov     AL,13
        Mov     BX,SP
        Mov     DX,3D4h
        Mov     AH,SS:[BX+4]
        Out     DX,AX
        Dec     AL
        Mov     AH,SS:[BX+5]
        Out     DX,AX
        Retf    2

Fill:
        Mov     BX,SP
        Push    DS
        Xor     CX,CX
        Mov     CH,SS:[BX+4]
        Mov     SI,CX
        Ror     CX,2
        Add     SI,SS:[BX+6]
        Mov     AL,gr256_col
        Add     SI,CX
        Mov     BYTE PTR CS:[F_VOLTA],AL
        Mov     DX,0A000h
        Mov     AX,0FFFFh
        Mov     DS,DX
        Push    AX
        mov     BL,[SI]
        mov     BYTE PTR CS:[F_CVT],BL
        Inc     SI
        mov     BYTE PTR CS:[F_CVT1],BL
        mov     BYTE PTR CS:[F_CVT2],BL
        mov     BYTE PTR CS:[F_CVT3],BL
F_LLA:  Dec     SI
F_L1:   Dec     SI
        Cmp     BYTE PTR [SI],123
F_CVT   EQU     $-1
        Jz      F_L1
        Inc     SI
        Xor     DX,DX
F_LH:   Sub     SI,320
        Cmp     BYTE PTR [SI],123
F_CVT1  EQU     $-1
        Jz      F_L2
        Or      DH,DH
        Jz      F_L3
        Dec     DH
        Jmp     F_L3
F_L2:   Or      DH,DH
        Jnz     F_L3
        Push    SI
        Inc     DH
F_L3:   Add     SI,640
        Cmp     BYTE PTR [SI],123
F_CVT2  EQU     $-1
        Jz      F_L4
        Or      DL,DL
        Jz      F_L5
        Dec     DL
        Jmp     F_L5
F_L4:   Or      DL,DL
        Jnz     F_L5
        Push    SI
        Inc     DL
F_L5:   Sub     SI,320
        Mov     BYTE PTR [SI],15
F_VOLTA EQU     $-1
        Inc     SI
        Cmp     BYTE PTR [SI],123
F_CVT3  EQU     $-1
        Jz      F_LH

        Pop     SI
        Inc     SI
        Jnz     F_LLA
        Pop     DS
        Retf    4

Linec:
        Mov     AL,Gr256_col
        Push    BP
        Mov     BYTE PTR CS:[LPL_COL],AL
        Mov     BP,SP
        Mov     SI,[BP+12]
        Mov     DI,[BP+10]
        Mov     AX,[BP+8]
        Mov     DX,[BP+6]
        Sub     AX,SI
        Sub     DX,DI
        Cmp     AH,80h
        Sbb     CX,CX
        Cmp     DH,80h
        Sbb     CL,CL
        Not     CX
        Cmp     AH,80h
        Adc     CH,0
        Cmp     DH,80h
        Adc     CL,0
        Cmp     AX,8000h
        Sbb     BX,BX
        Not     BX
        Xor     AX,BX
        Sub     AX,BX
        Cmp     DX,8000h
        Sbb     BX,BX
        Not     BX
        Xor     DX,BX
        Sub     DX,BX
        Cmp     AX,DX
        Jl      L_DYDX
        Mov     BX,CX
        Mov     WORD PTR CS:[LPL_HI],AX
        Mov     WORD PTR CS:[LPL_LO],DX
        Xor     CL,CL
        Mov     DX,AX
        Shr     AX,1
        Inc     DX
        Mov     WORD PTR CS:[LPL_SUM],AX
        Mov     WORD PTR CS:[LPL_CNT],DX
        Jmp     L_CONT1
L_DYDX: Mov     BX,CX
        Mov     WORD PTR CS:[LPL_HI],DX
        Mov     WORD PTR CS:[LPL_LO],AX
        Xor     CH,CH
        Mov     AX,DX
        Shr     DX,1
        Inc     AX
        Mov     WORD PTR CS:[LPL_SUM],DX
        Mov     WORD PTR CS:[LPL_CNT],AX
L_CONT1:Mov     DX,BX
        Push    0A000h
        Pop     ES
L_LOOP: Cmp     SI,320
        Jnc     L_SKIP
        Cmp     DI,200
        Jnc     L_SKIP
        Xor     BX,BX
        Mov     AX,DI
        Mov     BH,AL
        Ror     BX,2
        Add     BH,AL
        Add     BX,SI
Linecex:Mov     BYTE PTR ES:[BX],12h
LPL_COL EQU     $-1h
L_SKIP: Mov     AX,1234h
LPL_SUM EQU     $-2h
        Mov     BX,1234h
LPL_HI  EQU     $-2h
        Add     AX,1234h
LPL_LO  EQU     $-2h
        Cmp     AX,BX
        Jnc     L_JUMP
        Mov     WORD PTR CS:[LPL_SUM],AX
        Mov     AL,CH
        Cbw
        Add     SI,AX
        Mov     AL,CL
        Cbw
        Add     DI,AX
        Jmp     L_READY
L_JUMP: Sub     AX,BX
        Mov     WORD PTR CS:[LPL_SUM],AX
        Mov     AL,DH
        Cbw
        Add     SI,AX
        Mov     AL,DL
        Cbw
        Add     DI,AX
L_READY:Mov     AX,1234h
LPL_CNT EQU     $-2h
        Dec     AX
        Mov     WORD PTR CS:[LPL_CNT],AX
        Jnz     L_LOOP
        Pop     BP
        Retf    8

Pixmethod:
        Xor     BX,BX
        Mov     SI,SP
        Mov     BL,SS:[SI+4]
        Mov     DI,offset Met_Tab
        Shl     BX,3
        Mov     AX,CS:[DI+BX]
        Mov     SI,CS:[DI+BX+2]
        Mov     CX,CS:[DI+BX+4]
        Mov     BX,CS:[DI+BX+6]
        Mov     WORD PTR CS:[Plotex+1],AX
        Mov     WORD PTR CS:[Circex1+1],AX
        Mov     WORD PTR CS:[Circex2+1],AX
        Mov     WORD PTR CS:[Circex3+1],AX
        Mov     WORD PTR CS:[Circex4+1],AX
        Mov     WORD PTR CS:[Circex5+1],AX
        Mov     WORD PTR CS:[Circex6+1],AX
        Mov     WORD PTR CS:[Circex7+1],AX
        Mov     WORD PTR CS:[Circex8+1],AX
        Mov     WORD PTR CS:[Putpex+1],AX
        Mov     WORD PTR CS:[Prinex],CX
        Mov     WORD PTR CS:[Lineex+1],SI
        Mov     BYTE PTR CS:[Lineex+3],BH
        Mov     BYTE PTR CS:[Lineex1],BL
        Retf    2
Met_Tab:DW      0788h,07C6h,2588h,2Eh
        DW      0730h,3780h,2530h,2Eh
        DW      0708h,0F80h,2508h,2Eh
        DW      0720h,2780h,2520h,2Eh
        DW      0738h,3F80h,0538h,9022h
        DW      07FEh,07FEh,05FEh,9022h
        DW      0FFEh,0FFEh,0DFEh,9022h
        DW      17F6h,17F6h,15FFh,9022h

CODE    ENDS

        END
