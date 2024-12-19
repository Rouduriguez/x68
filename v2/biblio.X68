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
    
AFF_CHRONO:
    MOVE.L #CHAINE_CHRONO,A2
REPETE_DECIMAL:
    MOVE.L  CHRONO,D7
    DIVU #10,D7 * résultat: 16 bits de poids forts = reste ; 16 bits de poids faibles = quotient
    SWAP    D7
    MOVE.B D7,(A2)+
    SWAP    D7
    CMP.B #0,D7
    BNE REPETE_DECIMAL
    SUB.L #1,A2    * compenser la dernière incrémentation     
AFFICHE_CHRONO:
    MOVE.B (A2),D1 
    ADD.B #$30,D1   
    JSR AFFCAR
    CMP.L #CHAINE_CHRONO,A2
    BEQ FIN_AFFICHE_CHRONO
    SUB.L #1,A2
    BRA AFFICHE_CHRONO
FIN_AFFICHE_CHRONO:    
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
