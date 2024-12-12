*-----------------------------------------------------------
* Titre      : Projet Demineur
* Ecrit par  : Valentin et Matthieu
* Date       : 14 nov. 2024
* Description: Ecran de Victoire / Defaite, Chrono, Selection de la difficulté et Map random 
*-----------------------------------------------------------
    ORG    $1000
START:                  
    
    


    JSR PRINT_LIGNES_GRILLE
    JSR COULEUR_GRILLE
    *MOVE.L  #MSG_VICTOIRE,A1
    *MOVE.W  X_MAX,D1
    *ASR.W   #1,D1    
    *MOVE.W  X_MAX,D2
    *ADD.W   #20,D2    
    *JSR DRAW_STRING
    

    
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
    *ASL.B   #1,D1 * double l'index car pour chaque char il y a un 0 
    MOVE.B  (A0,D1),D5 * D5.B = contenu de la case
    MOVE.B  D5,N
    *ASR.B   #1,D1
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
    BEQ DEFAITE
    CMP.B   #$30,D5
    BEQ VIDE
    BRA NOMBRE
COULEUR_CLIC:
    JSR SET_FILL_COLOR
    MOVE.W  D3,D1
    SUB.W   LARGEUR_CASE,D1
    JSR DRAW_FILL_RECT   
    BRA BOUCLE_SOURIS
    *MOVE.W  D3,D1
    *MOVE.W  D4,D1
    *MOVE.L  #N,A1
    *SUB.W   CENTRE_CASE,D1
    *SUB.W   CENTRE_CASE,D2
    *JSR DRAW_STRING    
FIN_BOUCLE_SOURIS:

VIDE:   
    MOVE.L  #$00FFFFFF,D1
    BRA COULEUR_CLIC
    
NOMBRE:
    CMP.B   #$31,D5
    BEQ UN
    CMP.B   #$32,D5
    BEQ DEUX
    MOVE.L  #$0000A5FF,D1
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
    MOVE.W  D3,D1
    SUB.W   LARGEUR_CASE,D1
    JSR DRAW_FILL_RECT
    MOVE.B  #0,D6 * indice tableau
REVELE_BOMBES:    
    CMP.B   #66,(A0,D6)
    BEQ BOMBE
SUITE_REVELE_BOMBES:
    ADD.B   #1,D6
    CMP.B   #25,D6
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
    
GRILLE_SOLUTION: DC.B 'B10001211001B100111B0B000'
*GRILLE_SOLUTION: DC.B 'B',0,'2',0,'B',0,'1',0,'0',0,'1',0,'3',0,'2',0, '2',0,'0',0,'0',0,'1',0,'B',0,'1',0,'0',0,'0',0,'1',0,'1',0,'1',0,'0',0,'0',0,'0',0,'0',0,'0',0,'0',0
X_MAX:  DC.W 400 * nb_colonnes * largeur_case
LARGEUR_CASE: DC.W 80 * X_MAX / nbColonnes
*CENTRE_CASE: DC.W 20 * largeur_case / 2
NB_COLONNES: DC.W 5
NB_TRAITS: DC.B 6 * = nbColonnes + 1
PEN:    DC.B 2 * epaisseur du crayon

CHAINE: DC.B 'Bravo le clic gauche !',0
COULEUR_CACHEE: DC.L $00E6E0B0
COULEUR_REVELEE: DC.L $00FFFFFF
COULEUR_CRAYON: DC.L $00BBBBBB
X:  DS.W 1
Y:  DS.W 1
N:  DC.B 'N',0 * nombre de bombes à proximité
MSG_VICTOIRE:   DC.B 'Bravo pour cette belle victoire !',0
MSG_DEFAITE:    DC.B 'Dommage ! C est perdu...',0
NOMBRE_DECIMAL: DS.B 10

    END    START      
