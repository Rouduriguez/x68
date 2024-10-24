*-----------------------------------------------------------
* Title      : Afficher le contenu de D0 en Binaire
*-----------------------------------------------------------

    ORG $400
    
    MOVE.B  #0,D2 * compteur
    MOVE.L  #$AAAAAAAA,D0
    MOVE.L D0,D3 * car D0 est modifié par AFFCAR
    
REPETE:
    ROL.L #1,D3    
    BCC ZERO
UN:
    MOVE.B #49,D1 * 49 = '1'
    BRA SUITE
ZERO:
    MOVE.B #48,D1 * 48 = '0'
SUITE:
    JSR AFFCAR    
    ADD.B #1,D2
    CMP.B #32,D2
    BNE REPETE
FIN_REPETE:
    
    JMP FINPRG
    
    INCLUDE 'BIBLIO.x68'
    
    END $400
