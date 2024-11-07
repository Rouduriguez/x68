*-----------------------------------------------------------
* Title      : Afficher le contenu de D0 en Décimal (non signé)
*-----------------------------------------------------------

    ORG $400
    
    MOVE.L  #1234567,D0
    MOVE.L D0,D2 * car AFFCAR modifie D0
    MOVE.L #CHAINE,A0
REPETE:
    DIVU #10,D2 * résultat: 16 bits de poids forts = reste ; 16 bits de poids faibles = quotient
    ROL.L #8,D2 * inverser l'ordre du résultat
    ROL.L #8,D2
    MOVE.B D2,(A0)+
    ASR.L #8,D2   
    ASR.L #8,D2
    CMP.B #0,D2
    BNE REPETE
    SUB.L #1,A0    * compenser la dernière incrémentation     
AFFICHE:
    MOVE.B (A0),D1 
    ADD.B #48,D1   
    JSR AFFCAR
    CMP.L #CHAINE,A0
    BEQ FINAFFICHE
    SUB.L #1,A0
    BRA AFFICHE
FINAFFICHE:    
 
    JMP FINPRG
    
    INCLUDE 'BIBLIO.x68'
    
CHAINE: DS.B 10
       
    END $400
    
