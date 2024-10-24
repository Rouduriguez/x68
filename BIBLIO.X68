AFFCAR: 
    MOVE #6,D0
    TRAP #15
    RTS
    
SAISCAR: 
    MOVE #5,D0
    TRAP #15
    RTS
    
FINPRG:
    MOVE #9,D0
    TRAP #15
    RTS

GET_TIME: 
    MOVE #8,D0
    TRAP #15
    RTS
    
POS_CURS:
    MOVE #11,D0
    TRAP #15
    RTS
    
GET_AFFCAR:
    MOVE #22,D0
    TRAP #15
    RTS

    


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
