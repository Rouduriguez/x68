*-----------------------------------------------------------
* Title      : Afficher une chaine de caractères terminée par 0
*-----------------------------------------------------------
    ORG    $400
    MOVE.L  #CHAINE,A0
    
REPETE:
    MOVE.B  (A0)+,D1
    JSR AFFCAR
    CMP #0,D1
    BNE REPETE  
    
    JMP FINPRG
    
    INCLUDE 'BIBLIO.x68'
    
    ORG $1000
    
CHAINE: DC.B 'bonjour 007 blablabla',0

    END    $400        


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
