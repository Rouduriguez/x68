*-----------------------------------------------------------
* Titre      : Projet Demineur
* Ecrit par  : Valentin et Matthieu
* Date       : créé le 14 nov. 2024, mis à jour le 19 déc. 2024
* Description: Ecran de Victoire / Defaite, Chrono, 
*               Selection de la difficulté avec pix color
*               et Map random
*               SFX, Leaderboard, plusieurs grilles
*               desactiver les cases cliquees
*               D1-4 = XY ; D5 = cpt de cases restantes ; 
*               D6 = indice tab ; D7 = attente (combiner avec D0 ?)
*               A0 = grille solution ; A1 =  message fin de partie
*               A2 = timer
*               A3 = chaine_clic
*               
*-----------------------------------------------------------
    ORG    $1000
START:                  
    
    JSR PRINT_LIGNES_GRILLE
    JSR COULEUR_GRILLE
    MOVE.L  #0,D7
    MOVE.L  #CHAINE_CLIC,A3
BOUCLE_SOURIS:
ATTENTE:
    *ADD.L   #1,D7
    *CMP.L   #$00008000,D7 * compteur seconde = environ $30000
    *BMI ATTENTE
    *ADD.L   #1,CHRONO
    *JSR AFF_CHRONO
    MOVE.L  #0,D7
    MOVE.L  #0,D1
    JSR GET_MOUSE
    AND.B   #1,D0
    CMP.B   #1,D0
    BNE BOUCLE_SOURIS
CLICK_CHECK: * verifie si le clic est dans la grille
    MOVE.W  X_MAX,D2
    CMP.W   D2,D1
    BPL BOUCLE_SOURIS
    MOVE.W  D1,X    
    SWAP    D1
    CMP.W   D2,D1
    BPL BOUCLE_SOURIS
    MOVE.W  D1,Y
FIN_CLICK_CHECK:
*CASE_DEJA_REVELEE:
*    MOVE.W  X,D1
*    MOVE.W  Y,D2
*    JSR GET_PIX_COLOR
*    MOVE.L  D0,D5
*    CMP.L   $0000FF00,D5
*    BEQ BOUCLE_SOURIS
*FIN_CASE_DEJA_REVELEE: 
    JSR GET_I
CASE_DEJA_CLIQUEE:
    AND.L   #$000000FF,D1
    MOVE.B  (A3,D1),D0
    CMP.B   #1,D0
    BEQ BOUCLE_SOURIS
    MOVE.B  #1,(A3,D1)
FIN_CASE_DEJA_CLIQUEE:

    ASL.B   #1,D1 * double l'index car pour chaque char il y a un 0
    MOVE.B  D1,D6 * D6 = index (changer get_i pour qu'il retourne dans D6)
    MOVE.B  (A0,D1),N * N = contenu de la case
    MOVE.L  #$00000000,D1
    JSR SET_FILL_COLOR
    JSR XY_CASE
    JSR DRAW_FILL_RECT
CMP_COULEUR_CLIC:
    CMP.B   #66,N
    BEQ DEFAITE
    JSR COULEUR_NOMBRE
COULEUR_CLIC:
    JSR SET_FILL_COLOR
    MOVE.W  D3,D1
    SUB.W   CENTRE_CASE,D1
    ADD.W   CENTRE_CASE,D2
    MOVE.L  #GRILLE_SOLUTION,A1
    AND.L   #$000000FF,D6
    ADD.L   D6,A1
    JSR DRAW_STRING
    
    SUB.B   #1,CR
    MOVE.B  CR,D5
    CMP.B   #1,CR
    BPL BOUCLE_SOURIS
    JSR VICTOIRE
    BRA FIN
FIN_BOUCLE_SOURIS: 

BOMBE:
    JSR XY_CASE
    JSR DRAW_FILL_RECT    
    BRA SUITE_REVELE_BOMBES

DEFAITE:
    MOVE.L  #$000000FF,D1
    JSR SET_FILL_COLOR
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
FIN_DEFAITE:  
    BRA FIN
    
FIN:
    JMP FINPRG

    
    
  
    INCLUDE 'BIBLIO.x68'
    INCLUDE 'BIBGRAPH.x68'
    INCLUDE 'BIBPERIPH.x68'
    INCLUDE 'BIB_DEMINEUR.x68'

    ORG $3000
    
GRILLE_SOLUTION: DC.B 'B',0,'2',0,'B',0,'1',0,'0',0,'1',0,'3',0,'2',0, '2',0,'0',0,'0',0,'1',0,'B',0,'1',0,'0',0,'0',0,'1',0,'1',0,'1',0,'0',0,'0',0,'0',0,'0',0,'0',0,'0',0
X_MAX:  DC.W 400 * nb_colonnes * largeur_case
LARGEUR_CASE: DC.W 80 * X_MAX / nbColonnes
CENTRE_CASE: DC.W 40 * largeur_case / 2
NB_COLONNES: DC.W 5
NB_TRAITS: DC.W 6 * = nbColonnes + 1
CHRONO: DC.L 0
CHAINE_CHRONO:  DS.B 4  
COULEUR_CACHEE: DC.L $00E6E0B0
COULEUR_CRAYON: DC.L $00BBBBBB
COULEUR_REVELEE: DC.L $0000FF00
X:  DS.W 1
Y:  DS.W 1
N:  DC.B 'N' * nombre de bombes à proximité
CR: DC.B 4 * cpt cases restantes
MSG_VICTOIRE:   DC.B 'Bravo pour cette belle victoire !',0
MSG_DEFAITE:    DC.B 'Dommage ! C est perdu...',0
NOMBRE_DECIMAL: DS.B 10
CHAINE_CLIC:   DC.B '0000000000000000000000000'

    END    START      
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
