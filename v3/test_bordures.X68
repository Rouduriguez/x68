*-----------------------------------------------------------
* Affiche pour chaque case d'une grille, ses cases adjacentes
*-----------------------------------------------------------
    ORG    $1000
START:                  
    
    MOVE.L #$00FFFFFF,D1
    JSR SET_FILL_COLOR
    MOVE.L  #0,D6
INIT:
    JSR XY_CASE
    JSR DRAW_FILL_RECT
    ADD.W   #1,D6
    CMP.W   NB_TOTAL,D6
    BNE INIT
    
    MOVE.W  CPT,D6
    MOVE.L  #$000000AA,D1
    JSR SET_FILL_COLOR
    MOVE.W  NB_COLONNES,D7
    SUB.W   #1,D7 * D7 = derniere ligne
    
    
BOUCLE_:
    MOVE.L  #ADJ,A2
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
    MOVE.W  D6,D0
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
*    MOVE.L  CLR_N,D1
*    JSR SET_FILL_COLOR   
*   8 CASES ADJACENTES
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    
TRACER_CASE_ADJ:
    MOVE.W  -(A2),D6
    JSR XY_CASE
    JSR DRAW_FILL_RECT
    CMP.W   #ADJ,A2
    BNE TRACER_CASE_ADJ
    MOVE.L  #0,D7
ATTENTE:
    ADD.L   #1,D7
    CMP.L   #$00010000,D7
    BNE ATTENTE
    ADD.W   #1,CPT
    MOVE.W  CPT,D7
    CMP.W   NB_TOTAL,D7
    BNE START
    

    JMP FINPRG
* --------------------------------------------------
BORD_HAUT:
    SWAP    D5
    CMP.B   #2,D5
    BEQ BORD_HG
    CMP.B   #1,D5
    BEQ BORD_HD
*    MOVE.L  CLR_H,D1
*    JSR SET_FILL_COLOR
    JSR CASES_INF
    JSR CASES_GD  
    BRA TRACER_CASE_ADJ
    

BORD_BAS:
    SWAP    D5
    CMP.B   #2,D5
    BEQ BORD_BG
    CMP.B   #1,D5
    BEQ BORD_BD
*    MOVE.L  CLR_B,D1
*    JSR SET_FILL_COLOR
    JSR CASES_SUP
    JSR CASES_GD
    BRA TRACER_CASE_ADJ
    
BORD_HG:    
*    MOVE.L  CLR_HG,D1
*    JSR SET_FILL_COLOR 
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASE_ADJ
BORD_HD:    
*    MOVE.L  CLR_HD,D1
*    JSR SET_FILL_COLOR
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASE_ADJ 
BORD_BG:    
*    MOVE.L  CLR_BG,D1
*    JSR SET_FILL_COLOR 
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASE_ADJ 
BORD_BD:    
*    MOVE.L  CLR_BD,D1
*    JSR SET_FILL_COLOR
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASE_ADJ   
BORD_G:    
*    MOVE.L  CLR_G,D1
*    JSR SET_FILL_COLOR
    MOVE.W  D6,D0
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASE_ADJ 
BORD_D:    
*    MOVE.L  CLR_D,D1
*    JSR SET_FILL_COLOR 
    MOVE.W  D6,D0
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASE_ADJ 
    
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
    
XY_CASE: * i dans D6.W, retourne X/Ydans D1,2/D3,4
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
    
CASES_SUP: * i dans D6.W, retourne les cases sup dans (A2)
    MOVE.L  #0,D0    
    MOVE.W  D6,D0
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   #2,D0
    MOVE.W  D0,(A2)+
    RTS
    
CASES_INF: * i dans D6.W, retourne les cases INF dans (A2)
    MOVE.L  #0,D0    
    MOVE.W  D6,D0
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   #2,D0
    MOVE.W  D0,(A2)+
    RTS
    
CASES_GD:
    ADD.W   #1,D6
    MOVE.W  D6,(A2)+
    SUB.W   #2,D6
    MOVE.W  D6,(A2)+
    ADD.W   #1,D6
    RTS

CASES_HB:
    ADD.W   NB_COLONNES,D6
    MOVE.W  D6,(A2)+
    SUB.W   NB_COLONNES,D6
    SUB.W   NB_COLONNES,D6
    MOVE.W  D6,(A2)+
    ADD.W   NB_COLONNES,D6
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
NB_COLONNES:    DC.W 7
NB_TOTAL:       DC.W 49
LARGEUR_CASE:   DC.W 50
ADJ:    DS.W 9
CPT: DC.W   0

    END    START        

