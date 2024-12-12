*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                 
    MOVE.L  #GRILLE_SOLUTION,A0
    MOVE.B  #0,D3
BOUCLE:
    MOVE.L  #0,D6
    JSR GET_TIME
    AND.L   #$0000FFFF,D1
    DIVU    NB_CASES,D1
    SWAP    D1
    CMP.B   #66,(A0,D1) * si t[D1] = 'B', on recommence
    BEQ BOUCLE 
    MOVE.B  #66,(A0,D1)
    MOVE.B  D1,D2
    JSR AFF_DEC
    MOVE.B  #$20,D1
    JSR AFFCAR
ATTENTE:
    ADD.L   #1,D6 * compteur attente
    CMP.L   #$0008ABCD,D6
    BNE ATTENTE
    ADD.B   #1,D7 * compteur de nombre
    CMP.B   NB_BOMBES,D7
    BNE BOUCLE
FIN_BOUCLE:
    JSR AFFCHAINE_BIS

    JMP FINPRG
    
    INCLUDE 'BIBLIO.x68'
    INCLUDE 'BIB_DEMINEUR.x68'
    
    ORG $2000

GRILLE_SOLUTION: DC.B '0000000000000000000000000',0
NB_BOMBES:  DC.B 3
NB_CASES:   DC.W 25
NOMBRE_DECIMAL: DS.B 10

    END    START        
