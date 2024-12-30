*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description: gerer cas par cas, puis mettre les cases adjacentes de la case cliquee dans une file
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    MOVE.L  #0,D6
    MOVE.L  #$000000AA,D1
    JSR SET_FILL_COLOR
    MOVE.W  NB_COLONNES,D7
    SUB.W   #1,D7 * D7 = derniere ligne
    
BOUCLE_:
TEST_BORDURE:
    MOVE.L  #0,D5 * etat GD...HB -> 1010 = coin haut gauche ; 0000 -> pas en bordure ; 0100 -> bord bas etc.
    MOVE.L  D6,D0
    DIVU    NB_COLONNES,D0
TEST_LIGNE: 
    CMP.W   #0,D0
    BEQ ADD_HAUT
    CMP.W   D7,D0
    BEQ ADD_BAS
FIN_TEST_LIGNE:

TEST_COLONNE:
    SWAP D5
    SWAP    D0 
    CMP.W   #0,D0
    BEQ ADD_GAUCHE
    CMP.W   D7,D0
    BEQ ADD_DROIT
FIN_TEST_COLONNE:
TEST_COULEUR_BORD:
    SWAP    D5
    CMP.B   #2,D5
    BEQ BORD_HAUT
    CMP.B   #1,D5
    BEQ BORD_BAS
    SWAP    D5
    CMP.B   #2,D5
    BEQ BORD_G
    CMP.B   #1,D5
    BEQ BORD_D    
    MOVE.L  CLR_N,D1
    JSR SET_FILL_COLOR   
TRACER_CASE:
    JSR XY_CASE
    JSR DRAW_FILL_RECT
    ADD.W   #1,D6
    CMP.W   NB_TOTAL,D6
    BNE BOUCLE_
    

    JMP FINPRG

BORD_HAUT:
    SWAP    D5
    CMP.B   #2,D5
    BEQ BORD_HG
    CMP.B   #1,D5
    BEQ BORD_HD
    MOVE.L  CLR_H,D1
    JSR SET_FILL_COLOR
    BRA TRACER_CASE
    

BORD_BAS:
    SWAP    D5
    CMP.B   #2,D5
    BEQ BORD_BG
    CMP.B   #1,D5
    BEQ BORD_BD
    MOVE.L  CLR_B,D1
    JSR SET_FILL_COLOR
    BRA TRACER_CASE
    
BORD_HG:    
    MOVE.L  CLR_HG,D1
    JSR SET_FILL_COLOR 
    BRA TRACER_CASE
BORD_HD:    
    MOVE.L  CLR_HD,D1
    JSR SET_FILL_COLOR 
    BRA TRACER_CASE 
BORD_BG:    
    MOVE.L  CLR_BG,D1
    JSR SET_FILL_COLOR 
    BRA TRACER_CASE 
BORD_BD:    
    MOVE.L  CLR_BD,D1
    JSR SET_FILL_COLOR 
    BRA TRACER_CASE   
BORD_G:    
    MOVE.L  CLR_G,D1
    JSR SET_FILL_COLOR 
    BRA TRACER_CASE 
BORD_D:    
    MOVE.L  CLR_D,D1
    JSR SET_FILL_COLOR 
    BRA TRACER_CASE 
    
ADD_HAUT:
    ADD.B  #2,D5
    BRA FIN_TEST_LIGNE
ADD_BAS:
    ADD.B  #1,D5
    BRA FIN_TEST_LIGNE
ADD_GAUCHE:
    ADD.B  #2,D5
    BRA FIN_TEST_COLONNE
ADD_DROIT:
    ADD.B  #1,D5
    BRA FIN_TEST_COLONNE
    
XY_CASE: * i dans D6, retourne X/Ydans D1,2/D3,4
    MOVE.W  D6,D1
    AND.L   #$0000FFFF,D1
    DIVU    NB_COLONNES,D1
    MOVE.W  D1,D2
    MULU    LARGEUR_CASE,D2
    SWAP    D1
    AND.L   #$0000FFFF,D1
    MULU    LARGEUR_CASE,D1
    MOVE.W  D1,D3
    ADD.W   LARGEUR_CASE,D3
    MOVE.W  D2,D4
    ADD.W   LARGEUR_CASE,D4
    RTS
    
    INCLUDE 'BIBGRAPH.X68'
    INCLUDE 'BIBLIO.X68'


    ORG $3000
CLR_N:  DC.L $00FFFFFF
CLR_H:  DC.L $00FF0000
CLR_B:  DC.L $0000FF00
CLR_G:  DC.L $00AA0000
CLR_D:  DC.L $0000AA00
CLR_HG: DC.L $00FFAA00
CLR_HD: DC.L $00FF00AA
CLR_BG: DC.L $00AAFF00
CLR_BD: DC.L $0000FFAA
NB_COLONNES:    DC.W 4
NB_TOTAL:       DC.W 16
LARGEUR_CASE:   DC.W 50

    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
