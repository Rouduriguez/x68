*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    MOVE.B  CR,D1
    SUB.B   #1,CR
    MOVE.B  CR,D2
    CMP.B   #0,CR
    SUB.B   #1,CR
    MOVE.B  CR,D3
    CMP.B   #0,CR
    SUB.B   #1,CR
    MOVE.B  CR,D4
    CMP.B   #0,CR
    SUB.B   #1,CR
    MOVE.B  CR,D5
    CMP.B   #0,CR
    SUB.B   #1,CR
    MOVE.B  CR,D6
    CMP.B   #0,CR
    JMP FINPRG

FINPRG:
    MOVE #9,D0
    TRAP #15
    RTS
    
AFFCAR: 
    MOVE #6,D0
    TRAP #15
    RTS

CR: DC.B 5

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
