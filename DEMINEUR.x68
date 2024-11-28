*-----------------------------------------------------------
* Titre      : Projet Demineur
* Ecrit par  : Valentin et Matthieu
* Date       : 14 nov. 2024
* Description: Corriger les couleurs correspondantes, et la modularité du tracé de la grille
*-----------------------------------------------------------
    ORG    $1000
START:                  
    
    JSR PRINT_LIGNES_GRILLE
    JSR COULEUR_GRILLE
    
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
    MOVE.B  (A0,D1),D5 * D5.B = contenu de la case
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
    CMP.B   #66,D5
    BEQ BOMBE
    CMP.B   #86,D5
    BEQ VIDE
    MOVE.L  #$00ABCDEF,D1
COULEUR_CLIC:
    JSR SET_FILL_COLOR
    MOVE.W  D3,D1
    SUB.W   LARGEUR_CASE,D1
    JSR DRAW_FILL_RECT   
    BRA BOUCLE_SOURIS
FIN_BOUCLE_SOURIS:

BOMBE:
    MOVE.L  #$000000FF,D1
    BRA COULEUR_CLIC

VIDE:   
    MOVE.L  #$00FFFFFF,D1
    BRA COULEUR_CLIC
    
    
              

    JMP FINPRG
  
    INCLUDE 'BIBLIO.x68'
    INCLUDE 'BIBGRAPH.x68'
    INCLUDE 'BIBPERIPH.x68'
    INCLUDE 'BIB_DEMINEUR.x68'

    ORG $2000
    
GRILLE_SOLUTION: DC.B 'B1VVV1211VV1B1VV111VVVVVV'
*GRILLE_SOLUTION: DC.B 'B',0,'1',0,'V',0,'V',0,'V',0,'1',0,'2',0,'1',0, '1',0,'V',0,'V',0,'1',0,'B',0,'1',0,'V',0,'V',0,'1',0,'1',0,'1',0,'V',0,'V',0,'V',0,'V',0,'V',0,'V',0
X_MAX:  DC.W 200
NB_COLONNES: DC.W 10
NB_TRAITS: DC.B 11 * = nbColonnes + 1
PEN:    DC.B 2 * epaisseur du crayon
LARGEUR_CASE: DC.W 40 * X_MAX / nbColonnes
CHAINE: DC.B 'Bravo le clic gauche !',0
COULEUR_CACHEE: DC.L $00E6E0B0
COULEUR_REVELEE: DC.L $00FFFFFF
COULEUR_CRAYON: DC.L $00BBBBBB
X:  DS.W 1
Y:  DS.W 1

    END    START      

