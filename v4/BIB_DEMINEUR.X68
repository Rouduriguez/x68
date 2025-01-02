INIT_CONST_1:
    MOVE.W  X_MAX,D0
    DIVU    #5,D0
    MOVE.W  D0,OY_GRILLE
    ASR.W   #1,D0
    MOVE.W  D0,OX_GRILLE
    MOVE.W  OX_GRILLE,D1
    MOVE.W  D1,OX_AFFICHEUR_1
    ADD.W   X_MAX,D1
    SUB.W   DX_AFFICHEUR,D1
    MOVE.W  D1,OX_AFFICHEUR_2
    MOVE.W  OY_GRILLE,D1
    SUB.W   DY_AFFICHEUR,D1
    ASR.W   #1,D1
    MOVE.W  D1,OY_AFFICHEUR
    MOVE.W  LON_SEG,D1
    ASR.W   #1,D1
    MOVE.W  D1,DX_NUM_AFFICHEUR
*    MOVE.W  DX_NUM_AFFICHEUR,D2
*    ASL.W   #2,D2
*    ADD.W   LON_SEG,D2
*    ADD.W   LON_SEG,D2
*    ADD.W   LON_SEG,D2       
*    MOVE.W  D2,DX_AFFICHEUR

    MOVE.W  #0,CHRONO
    MOVE.L  #ADJ,A2
    RTS
    
INIT_CONST_2:
    MOVE.W  NB_CASES,D1
    SUB.W   NB_MINES,D1
    MOVE.W  D1,CASES_RESTANTES
    MOVE.L  #0,D1
    MOVE.W  X_MAX,D1
    DIVU    NB_COLONNES,D1
    MOVE.W  D1,LARGEUR_CASE
    ASR.W   #1,D1
    MOVE.W  D1,CENTRE_CASE
    MOVE.L  #N,A1 * contenu de la case
    
    RTS

INTERFACE_DIFFICULTE:
    MOVE.L  COULEUR_CRAYON,D1
    JSR SET_PEN_COLOR
    MOVE.B #3,D1
    JSR WIDTH_PEN
    MOVE.L  COULEUR_FOND,D1
    JSR SET_FILL_COLOR
    JSR RESET_D
    MOVE.W  OX_GRILLE,D3
    ASL.W   #1,D3
    ADD.W   X_MAX,D3
    MOVE.W  OY_GRILLE,D4
    ASL.W   #1,D4
    ADD.W   X_MAX,D4
    JSR DRAW_FILL_RECT * fond gris
    JSR AFF_BTN_DIFFICULTE
    RTS

AFF_BTN_DIFFICULTE:
    MOVE.L  #CHAINE_DIFFICULTE,A1
    MOVE.L  #$00000000,D1 
    JSR SET_FILL_COLOR
    MOVE.W  D3,D1
    ASR.W   #1,D1
    MOVE.W  D1,D3
    ASR.W   #1,D1    
    MOVE.W  D4,D2
    ASR.W   #2,D2
    MOVE.W  D2,D4
    ASR.W   #2,D2
    JSR DRAW_STRING
    MOVE.W  D1,D5   * save D1
    MOVE.L  #$00FF0000,D1 * FACILE
    JSR SET_FILL_COLOR
    MOVE.W  D5,D1
    ASL.W   #1,D2
    MOVE.W  D4,D6   * espace vertical entre 2 boutons
    MOVE.W  D2,D7   * milieu de la hauteur d'une case
    ASR.W   #1,D7
    JSR DRAW_FILL_RECT
    MOVE.W  D1,D5
    ASR.W   #1,D1
    ADD.W   D3,D1
    ADD.W   D7,D2
    MOVE.L  #CHAINE_FACILE,A1
    JSR DRAW_STRING
    MOVE.L  #$0000FF00,D1 * MOYEN
    JSR SET_FILL_COLOR
    MOVE.W  D5,D1
    SUB.W   D7,D2
    ADD.W   D6,D2
    ADD.W   D6,D4
    JSR DRAW_FILL_RECT
    MOVE.W  D1,D5   * save D1
    ASR.W   #1,D1
    ADD.W   D3,D1
    ADD.W   D7,D2
    MOVE.L  #CHAINE_MOYEN,A1
    JSR DRAW_STRING
    MOVE.L  #$000000FF,D1 * DIFFICILE
    JSR SET_FILL_COLOR
    MOVE.W  D5,D1
    SUB.W   D7,D2
    ADD.W   D6,D2
    ADD.W   D6,D4
    JSR DRAW_FILL_RECT
    MOVE.W  D1,D5   * save D1
    ASR.W   #1,D1
    ADD.W   D3,D1
    ADD.W   D7,D2
    MOVE.L  #CHAINE_DIFFICILE,A1
    JSR DRAW_STRING
    RTS
    
SETUP_FACILE:    * grille_facile += 25*rand(0,n-1) si on veut une grille random parmi n grilles
    MOVE.L  #GRILLE_FACILE,A0
    MOVE.W  #5,NB_COLONNES
    MOVE.W  #25,NB_CASES
    MOVE.W  #3,NB_MINES
    BRA FIN_CHOIX_DIFFICULTE
    
SETUP_MOYEN:    * grille += 100*rand(0,n-1)
    MOVE.L  #GRILLE_MOYENNE,A0
    MOVE.W  #9,NB_COLONNES
    MOVE.W  #81,NB_CASES
    MOVE.W  #10,NB_MINES
    BRA FIN_CHOIX_DIFFICULTE
    
SETUP_DIFFICILE:    * grille += 225*rand(0,n-1)
    MOVE.L  #GRILLE_DIFFICILE,A0
    MOVE.W  #15,NB_COLONNES
    MOVE.W  #225,NB_CASES
    MOVE.W  #40,NB_MINES
    BRA FIN_CHOIX_DIFFICULTE

RESET_D:
    MOVE.L  #0,D0
    MOVE.L  #0,D1
    MOVE.L  #0,D2
    MOVE.L  #0,D3
    MOVE.L  #0,D4
    MOVE.L  #0,D5
    MOVE.L  #0,D6
    *MOVE.L  #0,D7
    RTS
SET_ORIGINE_GRILLE:
    ADD.W   OX_GRILLE,D1
    ADD.W   OX_GRILLE,D3
    ADD.W   OY_GRILLE,D2
    ADD.W   OY_GRILLE,D4
    RTS

INTERFACE:
    MOVE.L  COULEUR_FOND,D1
    JSR SET_FILL_COLOR
    JSR RESET_D
    MOVE.W  OX_GRILLE,D3
    ASL.W   #1,D3
    ADD.W   X_MAX,D3
    MOVE.W  OY_GRILLE,D4
    ASL.W   #1,D4
    ADD.W   X_MAX,D4
    JSR DRAW_FILL_RECT * fond gris
    MOVE.L  COULEUR_AFFICHEUR,D1
    JSR SET_FILL_COLOR
    MOVE.W  OX_AFFICHEUR_1,D1
    MOVE.W  OY_AFFICHEUR,D2
    MOVE.W  D1,D3
    MOVE.W  D2,D4
    ADD.W   DX_AFFICHEUR,D3
    ADD.W   DY_AFFICHEUR,D4
    JSR DRAW_FILL_RECT
    MOVE.W  D3,D5 * D5 et D6 vont aider a tracer le bouton restart
    MOVE.W  OX_AFFICHEUR_2,D1
    MOVE.W  D1,D3
    ADD.W   DX_AFFICHEUR,D3
    JSR DRAW_FILL_RECT
    MOVE.W  D1,D6 * D6 = 0.25*ecart entre les 2 afficheurs
    MOVE.W  D1,D3
    MOVE.L  COULEUR_RESTART,D1
    JSR SET_FILL_COLOR
    MOVE.W  D5,D1
    SUB.W   D5,D6
    ASR.W   #2,D6
    ADD.W   D6,D1
    SUB.W   D6,D3
    JSR DRAW_FILL_RECT
    ADD.W   #5,OY_AFFICHEUR * ajuste position des compteurs (rustine 1)

    
    RTS
FIN_INTERFACE:

*PRINT_LIGNES_GRILLE:    
*    MOVE.L #$00FFFFFF,D1
*    JSR SET_PEN_COLOR
*    JSR RESET_D
*    JSR SET_ORIGINE_GRILLE
*    MOVE X_MAX,D4
*LIGNES_VERTICALES:
*    JSR DRAW_LINE
*    ADD.W LARGEUR_CASE,D1
*    ADD.W LARGEUR_CASE,D3
*    ADD.W #1,D5    
*    CMP.W NB_COLONNES,D5
*    BMI LIGNES_VERTICALES
*FIN_LIGNES_VERTICALES:
*    JSR RESET_D
*    MOVE X_MAX,D3
*    JSR SET_ORIGINE_GRILLE
*LIGNES_HORIZONTALES:
*    JSR DRAW_LINE
*    ADD.W LARGEUR_CASE,D2
*    ADD.W LARGEUR_CASE,D4    
*    ADD.W #1,D5    
*    CMP.W NB_COLONNES,D5
*    BMI LIGNES_HORIZONTALES
*    JSR RESET_D
*    RTS   
    
COULEUR_GRILLE: * compteurs : D5 pour x et D6 y
    JSR RESET_D
    MOVE.L COULEUR_CRAYON,D1
    JSR SET_PEN_COLOR
    MOVE.L COULEUR_CACHEE,D1
    JSR SET_FILL_COLOR
    JSR RESET_D
    MOVE.W  LARGEUR_CASE,D3
    MOVE.W  LARGEUR_CASE,D4   
    JSR SET_ORIGINE_GRILLE
REPETE_COULEUR_LARGEUR:  
    JSR DRAW_FILL_RECT
    ADD.W   LARGEUR_CASE,D1
    ADD.W   LARGEUR_CASE,D3
    ADD.W   #1,D5
    CMP.W   NB_COLONNES,D5
    BNE REPETE_COULEUR_LARGEUR
REPETE_COULEUR_HAUTEUR:
    MOVE.W  #0,D1 * "retour chariot"
    MOVE.W  LARGEUR_CASE,D3
    ADD.W   OX_GRILLE,D1
    ADD.W   OX_GRILLE,D3
    ADD.W   LARGEUR_CASE,D2
    ADD.W   LARGEUR_CASE,D4
    MOVE.W  #0,D5    
    ADD.W   #1,D6
    CMP.W   NB_COLONNES,D6
    BNE REPETE_COULEUR_LARGEUR
    JSR RESET_D
    RTS
        
GET_I: * D1/D2 .W -> D6.W = indice de la case cliquee 
    SUB.W   OX_GRILLE,D1
    SUB.W   OY_GRILLE,D2
    AND.L   #$0000FFFF,D1
    AND.L   #$0000FFFF,D2   
    DIVU    LARGEUR_CASE,D1 * indice x
    DIVU    LARGEUR_CASE,D2 * indice y
    MULU    NB_COLONNES,D2   
    ADD.W   D2,D1
    MOVE.W  D1,D6
    RTS
    
XY_CASE: * i dans D6, retourne X/Ydans D1,2/D3,4
    MOVE.W  D6,D1
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
    JSR SET_ORIGINE_GRILLE
    RTS

COULEUR_NOMBRE:
    CMP.B   #$30,N
    BEQ ZERO
    CMP.B   #$31,N
    BEQ UN
    CMP.B   #$32,N
    BEQ DEUX
    MOVE.L  #$0000A5FF,D1 * N >= 3, à continuer si je décide de mettre N>3 ?
    BRA FIN_COULEUR_NOMBRE 
ZERO:   
    MOVE.L  #$00000000,D1
    BRA FIN_COULEUR_NOMBRE   
UN:
    MOVE.L  #$0090EE90,D1
    BRA FIN_COULEUR_NOMBRE
DEUX:
    MOVE.L  #$0000CCFF,D1
    BRA FIN_COULEUR_NOMBRE
FIN_COULEUR_NOMBRE:
    RTS 
    

VICTOIRE:
    MOVE.L  #$00FF00FF,D1
    JSR SET_FILL_COLOR
    MOVE.L  #MSG_VICTOIRE,A1
    MOVE.W  X_MAX,D1
    ASR.W   #2,D1    
    MOVE.W  X_MAX,D2
    ADD.W   #20,D2    
    JSR SET_ORIGINE_GRILLE
    JSR DRAW_STRING
    RTS
    
*-----------------------------------------------------------
* Retourne dans (A2).W l'indice des cases adjacentes a la case dont l'indice est dans D6.W
* D5.L = etat GD..HB -> 10..10 = coin haut gauche ; 00..00 -> pas en bordure ; 01..00 -> bord gauche etc.
* D7.W = derniere ligne
*-----------------------------------------------------------
      
CASES_ADJ: 
    *MOVE.L  #0,D7
    MOVE.W  NB_COLONNES,D7
    SUB.W   #1,D7     
TEST_BORD:
    MOVE.L  #0,D5 
    MOVE.L  D6,D0
    DIVU    NB_COLONNES,D0
TEST_BORD_HB: 
    CMP.W   #0,D0
    BEQ ADD_BORD_HAUT
    CMP.W   D7,D0
    BEQ ADD_BORD_BAS
FIN_TEST_BORD_HB:

TEST_BORD_GD:
    SWAP D5
    SWAP    D0 
    CMP.W   #0,D0
    BEQ ADD_BORD_GAUCHE
    CMP.W   D7,D0
    BEQ ADD_BORD_DROIT
FIN_TEST_BORD_GD:
CMP_BORD:
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
    
TRACER_CASES_ADJ:
    RTS
    
* --------------------------------------------------

BORD_HAUT:
    SWAP    D5
    CMP.B   #2,D5
    BEQ COIN_HG
    CMP.B   #1,D5
    BEQ COIN_HD
    JSR CASES_INF
    JSR CASES_GD  
    BRA TRACER_CASES_ADJ 
    
BORD_BAS:
    SWAP    D5
    CMP.B   #2,D5
    BEQ COIN_BG
    CMP.B   #1,D5
    BEQ COIN_BD
    JSR CASES_SUP
    JSR CASES_GD
    BRA TRACER_CASES_ADJ    
    
COIN_HG:    
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASES_ADJ
    
COIN_HD:    
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASES_ADJ 
    
COIN_BG:    
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASES_ADJ 
    
COIN_BD:    
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASES_ADJ  
 
BORD_G:    
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
    BRA TRACER_CASES_ADJ 
    
BORD_D:    
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
    BRA TRACER_CASES_ADJ   
  
ADD_BORD_HAUT:
    ADD.B  #2,D5
    BRA FIN_TEST_BORD_HB
    
ADD_BORD_BAS:
    ADD.B  #1,D5
    BRA FIN_TEST_BORD_HB
    
ADD_BORD_GAUCHE:
    ADD.B  #2,D5
    BRA FIN_TEST_BORD_GD
    
ADD_BORD_DROIT:
    ADD.B  #1,D5
    BRA FIN_TEST_BORD_GD   
 
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

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
