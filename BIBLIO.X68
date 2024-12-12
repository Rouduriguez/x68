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
    
AFFCHAINE:
    MOVE.B  (A0)+,D1
    JSR AFFCAR
    CMP #0,D1
    BNE AFFCHAINE  
    RTS

AFFCHAINE_BIS:
    MOVE.B (A0),D1
    CMP.B #0,D1
    BEQ FIN_AFFCHAINE_BIS
    JSR AFFCAR
    ADD.L #1,A0
    BRA AFFCHAINE_BIS
FIN_AFFCHAINE_BIS:
    RTS
    
AFF_DEC:
    MOVE.L #NOMBRE_DECIMAL,A1
REPETE_DECIMAL:
    DIVU #10,D2 * résultat: 16 bits de poids forts = reste ; 16 bits de poids faibles = quotient
    ROL.L #8,D2 * inverser l'ordre du résultat
    ROL.L #8,D2
    MOVE.B D2,(A1)+
    ASR.L #8,D2   
    ASR.L #8,D2
    CMP.B #0,D2
    BNE REPETE_DECIMAL
    SUB.L #1,A1    * compenser la dernière incrémentation     
AFFICHE_DECIMAL:
    MOVE.B (A1),D1 
    ADD.B #$30,D1   
    JSR AFFCAR
    CMP.L #NOMBRE_DECIMAL,A1
    BEQ FIN_AFFICHE_DECIMAL
    SUB.L #1,A1
    BRA AFFICHE_DECIMAL
FIN_AFFICHE_DECIMAL:    
    RTS
