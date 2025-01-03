INIT_CONST_1: * initialisation de la premiere partie des constantes
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
    MOVE.W  #0,CHRONO
    MOVE.L  #ADJ,A2
    RTS
    
INIT_CONST_2: * initialisation du reste des constantes
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

TRACER_FOND:
    MOVE.L  COULEUR_FOND,D1
    JSR SET_FILL_COLOR
    JSR RESET_D
    MOVE.W  OX_GRILLE,D3
    ASL.W   #1,D3
    ADD.W   X_MAX,D3
    MOVE.W  OY_GRILLE,D4
    ASL.W   #1,D4
    ADD.W   X_MAX,D4
    JSR DRAW_FILL_RECT 
    RTS
    
INTERFACE_DIFFICULTE:
    MOVE.L  COULEUR_CRAYON,D1
    JSR SET_PEN_COLOR
    MOVE.B #3,D1
    JSR WIDTH_PEN
    JSR TRACER_FOND
    * MESSAGE CHOIX *
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
    MOVE.W  D1,D5   * D5 = sauvegarde de D1
    * FACILE *
    MOVE.L  #$00FF0000,D1 
    JSR SET_FILL_COLOR
    MOVE.W  D5,D1
    ASL.W   #1,D2
    MOVE.W  D4,D6   * D6 = espace vertical entre 2 boutons
    MOVE.W  D2,D7   * D7 = moitie de la hauteur d'une case
    ASR.W   #1,D7
    JSR DRAW_FILL_RECT
    MOVE.W  D1,D5   
    ASR.W   #1,D1
    ADD.W   D3,D1
    ADD.W   D7,D2
    MOVE.L  #CHAINE_FACILE,A1
    JSR DRAW_STRING
    * MOYEN *
    MOVE.L  #$0000FF00,D1 
    JSR SET_FILL_COLOR
    MOVE.W  D5,D1
    SUB.W   D7,D2
    ADD.W   D6,D2
    ADD.W   D6,D4
    JSR DRAW_FILL_RECT
    MOVE.W  D1,D5
    ASR.W   #1,D1
    ADD.W   D3,D1
    ADD.W   D7,D2
    MOVE.L  #CHAINE_MOYEN,A1
    JSR DRAW_STRING
    * DIFFICILE *
    MOVE.L  #$000000FF,D1 
    JSR SET_FILL_COLOR
    MOVE.W  D5,D1
    SUB.W   D7,D2
    ADD.W   D6,D2
    ADD.W   D6,D4
    JSR DRAW_FILL_RECT
    ASR.W   #1,D1
    ADD.W   D3,D1
    ADD.W   D7,D2
    MOVE.L  #CHAINE_DIFFICILE,A1
    JSR DRAW_STRING
    RTS
    
SETUP_FACILE:    
    MOVE.L  #GRILLE_FACILE,A0
    MOVE.W  #5,NB_COLONNES
    MOVE.W  #25,NB_CASES
    MOVE.W  #3,NB_MINES
    BRA FIN_CHOIX_DIFFICULTE
    
SETUP_MOYEN: 
    MOVE.L  #GRILLE_MOYENNE,A0
    MOVE.W  #9,NB_COLONNES
    MOVE.W  #81,NB_CASES
    MOVE.W  #10,NB_MINES
    BRA FIN_CHOIX_DIFFICULTE
    
SETUP_DIFFICILE:
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
    
SET_ORIGINE_GRILLE: * corrige D1-4 en prenant en compte le decalage lie a l'interface
    ADD.W   OX_GRILLE,D1
    ADD.W   OX_GRILLE,D3
    ADD.W   OY_GRILLE,D2
    ADD.W   OY_GRILLE,D4
    RTS

INTERFACE: * dessine l'interface de jeu
    JSR TRACER_FOND
    * AFFICHEUR 1 *
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
    * AFFICHEUR 2 *
    MOVE.W  OX_AFFICHEUR_2,D1
    MOVE.W  D1,D3
    ADD.W   DX_AFFICHEUR,D3
    JSR DRAW_FILL_RECT
    MOVE.W  D1,D6 * D6 = 0.25*ecart entre les 2 afficheurs
    MOVE.W  D1,D3
    * BOUTON RESTART *
    MOVE.L  COULEUR_RESTART,D1
    JSR SET_FILL_COLOR
    MOVE.W  D5,D1
    SUB.W   D5,D6
    ASR.W   #2,D6
    ADD.W   D6,D1
    SUB.W   D6,D3
    JSR DRAW_FILL_RECT
    ADD.W   #5,OY_AFFICHEUR * ajuste position des compteurs (rustine 1)    
*    JSR COULEUR_GRILLE
    JSR TRACER_GRILLE
    JSR AFFICHE_CHRONO
    JSR AFFICHE_SCORE
    RTS
    
TRACER_GRILLE:
    MOVE.L  COULEUR_CACHEE,D1
    JSR SET_FILL_COLOR
    MOVE.W  OX_GRILLE,D1
    MOVE.W  OY_GRILLE,D2
    MOVE.W  D1,D3
    MOVE.W  D2,D4
    ADD.W   X_MAX,D3
    ADD.W   X_MAX,D4
    JSR DRAW_FILL_RECT
PRINT_LIGNES_GRILLE:
    MOVE.L COULEUR_CRAYON,D1
    JSR SET_PEN_COLOR
    MOVE.B #3,D1
    JSR WIDTH_PEN
    ADD.W   #1,NB_COLONNES * nb_lignes = nb_col + 1
    JSR RESET_D
    MOVE.W X_MAX,D4
    JSR SET_ORIGINE_GRILLE
LIGNES_VERTICALES:    
    JSR DRAW_LINE
    ADD.W LARGEUR_CASE,D1
    ADD.W LARGEUR_CASE,D3
    ADD.W #1,D5    
    CMP.W NB_COLONNES,D5
    BNE LIGNES_VERTICALES
FIN_LIGNES_VERTICALES:
    JSR RESET_D
    MOVE X_MAX,D3
    JSR SET_ORIGINE_GRILLE
LIGNES_HORIZONTALES:    
    JSR DRAW_LINE
    ADD.W LARGEUR_CASE,D2
    ADD.W LARGEUR_CASE,D4    
    ADD.W #1,D5    
    CMP.W NB_COLONNES,D5
    BNE LIGNES_HORIZONTALES
    JSR RESET_D
    SUB.W   #1,NB_COLONNES

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
    
XY_CASE: * i dans D6 -> X/Y dans D1,2/D3,4
    MOVE.L  #0,D1
    MOVE.L  D1,D2
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

COULEUR_NOMBRE: * attribue une couleur en fonction du nombre de mines adjacentes
    CMP.B   #$30,N
    BEQ COULEUR_ZERO
    CMP.B   #$31,N
    BEQ COULEUR_UN
    CMP.B   #$32,N
    BEQ COULEUR_DEUX
    CMP.B   #$33,N
    BEQ COULEUR_TROIS
    MOVE.L  #$0D30094,D1 * N >= 4, à continuer si je décide de mettre N>4 ?
    BRA FIN_COULEUR_NOMBRE 
COULEUR_ZERO:   
    MOVE.L  #$00000000,D1
    BRA FIN_COULEUR_NOMBRE   
COULEUR_UN:
    MOVE.L  #$0090EE90,D1
    BRA FIN_COULEUR_NOMBRE
COULEUR_DEUX:
    MOVE.L  #$0000CCFF,D1
    BRA FIN_COULEUR_NOMBRE
COULEUR_TROIS:
    MOVE.L  #$0000A5FF,D1
    BRA FIN_COULEUR_NOMBRE
FIN_COULEUR_NOMBRE:
    RTS 
    
COOLDOWN: * permet de temporiser
    MOVE.L  #0,D7
BOUCLE_COOLDOWN:
    ADD.L   #1,D7
    CMP.L   #$00018000,D7 * compteur seconde = environ $30000  
    BMI BOUCLE_COOLDOWN
    ADD.L   D7,BUFFER_CHRONO
    MOVE.L  BUFFER_CHRONO,D0
    CMP.L   REF_CHRONO,D0
    BMI FIN_COOLDOWN
    MOVE.L  REF_CHRONO,BUFFER_CHRONO
FIN_COOLDOWN:  
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
    
DEFAITE:
    MOVE.L  COULEUR_MINES,D1
    JSR SET_FILL_COLOR
    MOVE.W  #0,D6 * indice tableau
REVELE_MINES:    
    CMP.B   #66,(A0,D6)
    BEQ MINE
SUITE_REVELE_MINES:
    ADD.W   #1,D6
    CMP.W   NB_CASES,D6
    BNE REVELE_MINES    
    MOVE.L  #MSG_DEFAITE,A1
    MOVE.W  X_MAX,D1
    ASR.W   #2,D1    
    MOVE.W  X_MAX,D2
    ADD.W   #20,D2    
    JSR SET_ORIGINE_GRILLE
    JSR DRAW_STRING
FIN_DEFAITE: 
    BRA FIN
    
MINE:
    JSR XY_CASE
    JSR DRAW_FILL_RECT
    JSR COOLDOWN   
    BRA SUITE_REVELE_MINES

RESTART:
    SUB.W   #5,OY_AFFICHEUR * (rustine 2)
    BRA START

    
*-----------------------------------------------------------
* Retourne dans (A2).W l'indice des cases adjacentes a la case dont l'indice est dans D6.W
* D5.L = etat GD..HB -> 10..10 = coin haut gauche ; 00..00 -> pas en bordure ; 01..00 -> bord gauche etc.
* D7.W = derniere ligne ( nb_col - 1)
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
    * 8 CASES ADJACENTES *
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
FIN_CMP_BORD:
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
    BRA FIN_CMP_BORD
    
BORD_BAS:
    SWAP    D5
    CMP.B   #2,D5
    BEQ COIN_BG
    CMP.B   #1,D5
    BEQ COIN_BD
    JSR CASES_SUP
    JSR CASES_GD
    BRA FIN_CMP_BORD   
    
COIN_HG:    
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA FIN_CMP_BORD
    
COIN_HD:    
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA FIN_CMP_BORD
    
COIN_BG:    
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA FIN_CMP_BORD 
    
COIN_BD:    
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA FIN_CMP_BORD 
 
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
    BRA FIN_CMP_BORD
    
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
    BRA FIN_CMP_BORD   
  
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
