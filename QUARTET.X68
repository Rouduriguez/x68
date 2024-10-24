*-----------------------------------------------------------
* Title      : Affiche un quartet en Hexadecimal
*-----------------------------------------------------------
    *ORG    $400
    
AFFQUARTET:    
    *MOVE.B  #$A8,D1
    *AND.B   #$0F,D1
    CMP.B   #10,D1
    BMI CHIFFRES    
LETTRES:
    ADD.B   #55,D1
    BRA SUITE
CHIFFRES:
    ADD.B #48,D1   
SUITE:
    JSR AFFCAR 
    RTS   
    *JMP FINPRG
    
    *INCLUDE 'BIBLIO.x68'
    
    *END    $400        



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
