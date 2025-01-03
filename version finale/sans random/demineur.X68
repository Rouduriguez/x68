*-----------------------------------------------------------
* Description:            
*              systeme de flag a revoir, comprendre pourquoi le test de couleur fonctionne pas
*              "random" = incorporer quand tout est fini
*              cases adjacentes au clic
*-----------------------------------------------------------
*               D1-4.W = XY ; 
*               ---(D5 = cpt de cases restantes)--- ; 
*               D6.W = indice tab ; D7 = afficheur
*               A0 = grille solution
*               A1 = DRAW_STRING
*               A2 = ADJ
*               
*-----------------------------------------------------------
    ORG    $1000
START:                  
    MOVE.W  RES_X,D1 * largeur
    SWAP    D1
    MOVE.W  RES_Y,D1 * hauteur
    JSR RESOLUTION
    JSR INIT_CONST_1
    JSR INTERFACE_DIFFICULTE
CHOIX_DIFFICULTE:
    MOVE.L  #0,D1
    JSR GET_MOUSE
    AND.B   #1,D0
    CMP.B   #1,D0
    BNE CHOIX_DIFFICULTE
    SWAP    D1
    MOVE.W  D1,D2
    SWAP    D1
    JSR GET_PIX_COLOR
    MOVE.L  D0,D1
    CMP.L  #$00FF0000,D1
    BEQ SETUP_FACILE
    CMP.L  #$0000FF00,D1
    BEQ SETUP_MOYEN
    CMP.L  #$000000FF,D1
    BEQ SETUP_DIFFICILE
    BRA CHOIX_DIFFICULTE
FIN_CHOIX_DIFFICULTE:
    JSR COOLDOWN
    JSR INIT_CONST_2    
    MOVE.W  #$FF00,D1
    JSR POS_CURS * Efface l'ecran
    JSR INTERFACE  
    
BOUCLE_SOURIS:          * boucle principale
    MOVE.L  BUFFER_CHRONO,D7
    MOVE.L  #0,BUFFER_CHRONO
ATTENTE_BOUCLE_SOURIS:
    ADD.L   #1,D7    
    MOVE.L  #0,D1
    JSR GET_MOUSE
    AND.B   #3,D0
    CMP.B   #1,D0 
    BEQ CLIC_GAUCHE
    CMP.B   #2,D0 
    BEQ CLIC_DROIT
    CMP.L   REF_CHRONO,D7 * $20000 = 1 sec sur mon laptop
    BMI ATTENTE_BOUCLE_SOURIS    
    ADD.W   #1,CHRONO
    JSR AFFICHE_CHRONO    
    BRA BOUCLE_SOURIS 
    
CLIC_DROIT:
    MOVE.L  D7,BUFFER_CHRONO
    SWAP    D1
    MOVE.W  D1,D2
    SWAP    D1   
    JSR GET_PIX_COLOR  * controle la couleur de la case cliquee
    JSR GET_I        
    CMP.L   COULEUR_CACHEE,D0
    BEQ FLAG
    CMP.L   COULEUR_FLAG,D0
    BEQ DEFLAG
    BRA BOUCLE_SOURIS
FLAG:   * desactive une case
    CMP.W   #0,NB_MINES     * ignore le clic s'il n y a plus de flag disponible
    BEQ     BOUCLE_SOURIS
    SUB.W   #1,NB_MINES
    MOVE.L  COULEUR_FLAG,D1
    JSR SET_FILL_COLOR   
    BRA SUITE_DE_FLAG
DEFLAG: * la reactive
    MOVE.L  COULEUR_CACHEE,D1
    JSR SET_FILL_COLOR
    ADD.W   #1,NB_MINES
SUITE_DE_FLAG:
    MOVE.L  COULEUR_CRAYON,D1
    JSR SET_PEN_COLOR
    JSR XY_CASE
    JSR DRAW_FILL_RECT
    JSR AFFICHE_SCORE
    JSR COOLDOWN            * eviter les spam clicks
    BRA BOUCLE_SOURIS
    
CLIC_GAUCHE:
    MOVE.L  D7,BUFFER_CHRONO
    SWAP    D1
    MOVE.W  D1,D2
    SWAP    D1
    JSR GET_PIX_COLOR 
    CMP.L   COULEUR_RESTART,D0
    BEQ RESTART
    CMP.L   COULEUR_CACHEE,D0
    BNE ATTENTE_BOUCLE_SOURIS    * ignore si la case n'est pas "cliquable"
    JSR GET_I
    MOVE.B  (A0,D6),N * N = contenu de la case
    MOVE.L  COULEUR_CRAYON,D1
    JSR SET_PEN_COLOR
    MOVE.L  COULEUR_REVELEE,D1
    JSR SET_FILL_COLOR    
    JSR XY_CASE
    JSR DRAW_FILL_RECT    
    MOVE.W  D1,D3
CMP_COULEUR_CLIC:
    CMP.B   #66,N * = 'B'
    BEQ DEFAITE
    JSR COULEUR_NOMBRE
COULEUR_CLIC:
    JSR SET_FILL_COLOR
    MOVE.W  D3,D1
    ADD.W   CENTRE_CASE,D1
    ADD.W   CENTRE_CASE,D2
    JSR DRAW_STRING
    SUB.W   #1,CASES_RESTANTES
    CMP.W   #0,CASES_RESTANTES
    BNE BOUCLE_SOURIS
    JSR VICTOIRE
    BRA FIN
FIN_BOUCLE_SOURIS:   
  
FIN: * laisse peu de temps pour relancer une partie
    ADD.L   #1,D6    
    MOVE.L  #0,D1
    JSR GET_MOUSE
    AND.B   #1,D0
    CMP.B   #1,D0 
    BNE FIN
    SWAP    D1
    MOVE.W  D1,D2
    SWAP    D1
    JSR GET_PIX_COLOR
    CMP.L   COULEUR_RESTART,D0
    BEQ RESTART
    CMP.L   #$30000,D6
    BMI FIN
    
    JMP FINPRG    

    INCLUDE 'BIBLIO.x68'
    INCLUDE 'BIBPERIPH.x68'    
    INCLUDE 'BIBGRAPH.x68'
    INCLUDE 'BIB_DEMINEUR.x68'
    INCLUDE 'BIB_AFFICHEUR.x68'   
        
    ORG     $3000

NB_COLONNES:    DS.W 1
LARGEUR_CASE:   DS.W 1 * xmax / nb_col
CENTRE_CASE:    DS.W 1
RES_X:  DC.W 700
RES_Y:  DC.W 700
X_MAX:  DC.W 450 * (multiple de 45)
OX_GRILLE:  DS.W 1 * xmax / 10
OY_GRILLE:  DS.W 1 * xmax / 5
OX_AFFICHEUR_1: DS.W 1 * = ox_grille
OX_AFFICHEUR_2: DS.W 1 * ox_grille + xmax - dx_aff
OX_AFFICHEUR: DS.W 1
OX_AFFICHEUR_ACTUEL: DS.W 1
OY_AFFICHEUR: DS.W 1 * 2*OY_aff + DY_aff = OY_grille
DX_AFFICHEUR: DC.W 150 * 4*dx_num + 3*lon_seg ; * dc sinon bug mais pourquoi ?
DY_AFFICHEUR: DC.W 70
DX_NUM_AFFICHEUR: DS.W 1 * lon_seg / 2
LON_SEG:    DC.W 30
COULEUR_SEG:    DC.L $000000FF
CHRONO:  DC.W    0
BUFFER_CHRONO:  DC.L 0
REF_CHRONO:     DC.L $6000 * definit l ecoulement du temps
COULEUR_CACHEE: DC.L $00E6E0B0
COULEUR_REVELEE:    DC.L $00000000
COULEUR_MINES:  DC.L $000000FF
COULEUR_FLAG:   DC.L $00FF00FF
COULEUR_CRAYON: DC.L $00BBBBBB
COULEUR_FOND:   DC.L $00D3D3D3
COULEUR_AFFICHEUR:  DC.L $00000000
COULEUR_RESTART:    DC.L $0000FFFF
N:  DC.W 0
NB_CASES:   DS.W 1
NB_MINES:  DS.W 1
CASES_RESTANTES: DC.W 0
ADJ:    DS.W 9  * contient les indices des cases adjacentes
MSG_VICTOIRE:   DC.B 'Bravo pour cette belle victoire !',0
MSG_DEFAITE:    DC.B 'Dommage ! C est perdu...',0
GRILLE_FACILE: DC.B 'B2B101322001B100111000000'
GRILLE_MOYENNE:	DC.B '00001110000001B210000013B20000003B30111112B20B11B1111012221000012B211111B212B11B1'
GRILLE_DIFFICILE: DC.B '0001110000000111111B211000001B2B2223B332100112B32B22BBB2121112B32224B43B2B1122B11B323B2211B2122213B311011B312B102B31102BB21B221212B113B111111B101222B200000122112B3210000112B22B3B1000001B33B213231110124B31101B2BB101B3B20001121'
CHAINE_DIFFICULTE:  DC.B 'Choix de la difficulte...',0
CHAINE_FACILE:  DC.B 'Facile',0
CHAINE_MOYEN:   DC.B 'Moyen',0
CHAINE_DIFFICILE: DC.B 'Difficile',0

    END    START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
