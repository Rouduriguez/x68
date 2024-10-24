*-----------------------------------------------------------
* Title      : Saisir une chaine de caractères terminée par ';'
*-----------------------------------------------------------
    ORG    $400
    MOVE.L  #CHAINE,A0
    
REPETE:
    JSR SAISCAR
    CMP.B #59,D1 * #59 = ';'
    BEQ FIN_REPETE  
    MOVE.B  D1,(A0)+
    BRA REPETE
FIN_REPETE
    MOVE.B #0,(A0) * désigne fin de chaine pour affchaine
    
NEW_LINE:
    MOVE #13,D1 * carriage return
    JSR AFFCAR
    MOVE #10,D1 * new line
    JSR AFFCAR
    
PRINT:
    MOVE.L  #CHAINE,A0
    
REPETE_PRINT:
    MOVE.B  (A0)+,D1
    JSR AFFCAR
    CMP #0,D1
    BNE REPETE_PRINT
    
    JMP FINPRG
    
    INCLUDE 'BIBLIO.x68'

    ORG $1000
    
CHAINE: DC.B 100 

    END    $400        



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
