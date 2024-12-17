*-----------------------------------------------------------
* Titre      : Projet Demineur
* Ecrit par  : Valentin et Matthieu
* Date       : 14 nov. 2024
* Description: Ecran de Victoire / Defaite, Chrono, Selection de la difficulté et Map random
*               SFX, Leaderboard, plusieurs grilles
*               D1-4 = XY ; D5 = cpt de cases restantes ; 
*               D6 = indice tab ; D7 = attente (combiner avec D0 ?)
*-----------------------------------------------------------
    ORG    $1000
START:                  
    
    JSR PRINT_LIGNES_GRILLE
    MOVE.L  #TEST,A1
    JSR RESET_D
    MOVE.W  LARGEUR_CASE,D1
    ASR.W   #1,D1
    MOVE.W  D1,D2
    JSR DRAW_STRING
    JSR COULEUR_GRILLE
    MOVE.B  #22,D7
    
BOUCLE_SOURIS:
    MOVE.L  #0,D1
    JSR GET_MOUSE
    AND.B   #1,D0
    CMP.B   #1,D0
    BNE BOUCLE_SOURIS
CLIC_GAUCHE:
    MOVE.W  X_MAX,D2
    CMP.W   D2,D1
    BPL BOUCLE_SOURIS
    MOVE.W  D1,X    
    SWAP    D1
    CMP.W   D2,D1
    BPL BOUCLE_SOURIS
    MOVE.W  D1,Y    
    
    JSR GET_I
    AND.L   #$000000FF,D1
    ASL.B   #1,D1 * double l'index car pour chaque char il y a un 0
    MOVE.B  D1,D6 * D6 = index (changer get_i pour qu'il retourne dans D6)
    MOVE.B  (A0,D1),N * N = contenu de la case
    ASR.B   #1,D1
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
CMP_COULEUR_CLIC:
    CMP.B   #66,N
    BEQ DEFAITE
    CMP.B   #$30,N
    BEQ VIDE
    BRA NOMBRE
COULEUR_CLIC:
    JSR SET_FILL_COLOR
    MOVE.W  D3,D1
    SUB.W   CENTRE_CASE,D1
    ADD.W   CENTRE_CASE,D2
    MOVE.L  #GRILLE_SOLUTION,A1
    AND.L   #$000000FF,D6
    ADD.L   D6,A1
    JSR DRAW_STRING
    
    *JSR DRAW_FILL_RECT
    *SUB.B   #1,CASES_RESTANTES
    *MOVE.B  CASES_RESTANTES,D5
    SUB.B   #1,D7
    CMP.B   #0,D7
    BNE BOUCLE_SOURIS    
FIN_BOUCLE_SOURIS:
VICTOIRE:
    MOVE.L  #$000000FF,D1
    JSR SET_FILL_COLOR
    MOVE.L  #MSG_VICTOIRE,A1
    MOVE.W  X_MAX,D1
    ASR.W   #1,D1    
    MOVE.W  X_MAX,D2
    ADD.W   #20,D2    
    JSR DRAW_STRING
    JMP FINPRG
    

VIDE:   
    MOVE.L  #$00000000,D1
    BRA COULEUR_CLIC
    
NOMBRE:
    CMP.B   #$31,N
    BEQ UN
    CMP.B   #$32,N
    BEQ DEUX
    MOVE.L  #$0000A5FF,D1 * N = 3, à continuer si je décide de mettre N>3 ?
    BRA COULEUR_CLIC    
UN:
    MOVE.L  #$0090EE90,D1
    BRA COULEUR_CLIC
DEUX:
    MOVE.L  #$0000FFFF,D1
    BRA COULEUR_CLIC
FIN_NOMBRE:  

BOMBE:
    MOVE.W  D6,D1
    ASR.W   #1,D1 * car D6 = 2*i a cause des 0
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
    JSR DRAW_FILL_RECT
    
    BRA SUITE_REVELE_BOMBES

DEFAITE:
    MOVE.L  #$000000FF,D1
    JSR SET_FILL_COLOR
    *MOVE.W  D3,D1
    *SUB.W   LARGEUR_CASE,D1
    *JSR DRAW_FILL_RECT
    MOVE.L  #GRILLE_SOLUTION,A0
    MOVE.B  #0,D6 * indice tableau
REVELE_BOMBES:    
    CMP.B   #66,(A0,D6)
    BEQ BOMBE
SUITE_REVELE_BOMBES:
    ADD.B   #2,D6
    CMP.B   #50,D6
    BNE REVELE_BOMBES
    
    MOVE.L  #MSG_DEFAITE,A1
    MOVE.W  X_MAX,D1
    ASR.W   #1,D1    
    MOVE.W  X_MAX,D2
    ADD.W   #20,D2    
    JSR DRAW_STRING      

    JMP FINPRG
    
    
    MOVE.L  #0,D6
    MOVE.L  #0,D7   
ATTENTE:
    ADD.L   #1,D6
    CMP.L   #10000,D6
    BNE ATTENTE
    MOVE.L  #0,D6
    ADD.L   #1,D7
    BRA ATTENTE
FIN_ATTENTE:
  
    INCLUDE 'BIBLIO.x68'
    INCLUDE 'BIBGRAPH.x68'
    INCLUDE 'BIBPERIPH.x68'
    INCLUDE 'BIB_DEMINEUR.x68'

    ORG $2000
    
*GRILLE_SOLUTION: DC.B 'B10001211001B100111B0B000'
GRILLE_SOLUTION: DC.B 'B',0,'2',0,'B',0,'1',0,'0',0,'1',0,'3',0,'2',0, '2',0,'0',0,'0',0,'1',0,'B',0,'1',0,'0',0,'0',0,'1',0,'1',0,'1',0,'0',0,'0',0,'0',0,'0',0,'0',0,'0',0
X_MAX:  DC.W 400 * nb_colonnes * largeur_case
LARGEUR_CASE: DC.W 80 * X_MAX / nbColonnes
CENTRE_CASE: DC.W 40 * largeur_case / 2
NB_COLONNES: DC.W 5
NB_TRAITS: DC.W 6 * = nbColonnes + 1
PEN:    DC.B 2 * epaisseur du crayon

CHAINE: DC.B 'Bravo le clic gauche !',0
COULEUR_CACHEE: DC.L $00E6E0B0
COULEUR_CRAYON: DC.L $00BBBBBB
X:  DS.W 1
Y:  DS.W 1
N:  DC.B 'N' * nombre de bombes à proximité
CASES_RESTANTES:    DC.B 22 * nbCases - nbBombes
MSG_VICTOIRE:   DC.B 'Bravo pour cette belle victoire !',0
MSG_DEFAITE:    DC.B 'Dommage ! C est perdu...',0
NOMBRE_DECIMAL: DS.B 10
TEST:   DC.B '1',0

    END    START      
