*-----------------------------------------------------------
* Titre      : Projet Demineur
* Ecrit par  : Valentin et Matthieu
* Date       : 14 nov. 2024
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  
    
    *JSR PRINT_LIGNES_GRILLE
    *JSR COULEUR_GRILLE
    
    MOVE.L  #GRILLE_SOLUTION,A0
    MOVE.W  cor_x,D1
    MOVE.W  cor_y,D2
    DIVU    LARGEUR_CASE,D1 * indice x
    DIVU    LARGEUR_CASE,D2 * indice y
    MOVE.W  D2,D3 * D3 = indice dans le tableau
    MULU    NB_COLONNES,D3
    ADD.W   D1,D3
    MOVE.B  (A0,D3),D1
    JSR     AFFCAR
              

    JMP FINPRG
    
  
    
   
    
    JSR PRINT_CHAR_GRILLE
    


    
    INCLUDE 'BIBLIO.x68'
    INCLUDE 'BIBGRAPH.x68'
    INCLUDE 'BIBPERIPH.x68'
    INCLUDE 'BIB_DEMINEUR.x68'

    ORG $2000
    
GRILLE_SOLUTION: DC.B 'B1VVV1211VV1B1VV111VVVVVV'
*GRILLE_SOLUTION: DC.B 'B',0,'1',0,'V',0,'V',0,'V',0,'1',0,'2',0,'1',0, '1',0,'V',0,'V',0,'1',0,'B',0,'1',0,'V',0,'V',0,'1',0,'1',0,'1',0,'V',0,'V',0,'V',0,'V',0,'V',0,'V',0
X_MAX:  DC.W 400
NB_COLONNES: DC.W 5
NB_TRAITS: DC.B 6 * = nbColonnes + 1
PEN:    DC.B 2 * epaisseur du crayon
LARGEUR_CASE: DC.W 80 * X_MAX / nbColonnes
CHAINE: DC.B 'Bravo le clic gauche !',0
COULEUR_CACHEE: DC.L $00E6E0B0
COULEUR_REVELEE: DC.L $00FFFFFF
COULEUR_CRAYON: DC.L $00BBBBBB
cor_X:  DC.W 330
cor_Y:  DC.W 118

    END    START      
