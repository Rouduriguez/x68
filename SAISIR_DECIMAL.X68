*-----------------------------------------------------------
* Title      : Saisir un nombre Décimal non signé (pas trop grand)
*-----------------------------------------------------------

    ORG $400
    
    MOVE.L #0,D1 *
    MOVE.L #CHAINE,A0
 
SAISIE:
    JSR SAISCAR
    CMP.B #13,D1 * entree
    BEQ FIN_SAISIE
    CMP.B   #8,D1 * back space
    BEQ BACKSPACE
    MOVE.B  D1,(A0)+
    BRA SAISIE
    
BACKSPACE:
    CMP.L   #CHAINE,A0
    BEQ SAISIE
    MOVE.B   #32,D1 * space
    JSR AFFCAR
    MOVE.B   #8,D1
    JSR AFFCAR
    SUB.L   #1,A0
    BRA SAISIE
    
FIN_SAISIE
    MOVE.B #0,(A0) * désigne fin de chaine pour affchaine
    MOVE.L  #CHAINE,A0
    
    MOVE.L  #0,D1
CONVERSION:
    ADD.B  (A0)+,D1
    SUB.B   #48,D1
    *ADD.L   #1,A0
    CMP.B   #0,(A0)
    BEQ FIN
    MULU    #10,D1    
    BRA CONVERSION    
FIN
    
    JMP FINPRG
    
    INCLUDE 'BIBLIO.x68'
    
CHAINE: DS.B 20
       
    END $400
