*-----------------------------------------------------------
* Title      : Saisir un nombre Décimal (pas trop grand)
*-----------------------------------------------------------

    ORG $400
    
    MOVE.L #0,D2 *
    MOVE.L #CHAINE,A0
 
SAISIE:
    JSR SAISCAR
    CMP.B #13,D1 *
    BEQ FIN_SAISIE  
    MOVE.B  D1,(A0)+
    BRA SAISIE
FIN_SAISIE
    MOVE.B #0,(A0) * désigne fin de chaine pour affchaine
    MOVE.L  #CHAINE,A0
    
CONVERSION:
    ADD.B  (A0),D2
    SUB.B   #48,D2
    ADD.L   #1,A0
    CMP.B   #0,(A0)
    BEQ FIN
    MULU    #10,D2    
    BRA CONVERSION    
FIN
    
    JMP FINPRG
    
    INCLUDE 'BIBLIO.x68'
    
CHAINE: DS.B 20
       
    END $400
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
