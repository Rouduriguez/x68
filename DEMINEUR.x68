*-----------------------------------------------------------
* Titre      : Projet Demineur
* Ecrit par  : Valentin et Matthieu
* Date       : 14 nov. 2024
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  
    
    JSR PRINT_LIGNES_GRILLE
    JSR COULEUR_GRILLE
    JSR PRINT_CHAR_GRILLE  

    JMP FINPRG
    
    INCLUDE 'BIBLIO.x68'
    INCLUDE 'BIBGRAPH.x68'
    INCLUDE 'BIB_DEMINEUR.x68'

    ORG $2000
    
GRILLE_SOLUTION: DC.B 'B',0,'1',0,'V',0,'V',0,'V',0,'1',0,'2',0,'1',0, '1',0,'V',0,'V',0,'1',0,'B',0,'1',0,'V',0,'V',0,'1',0,'1',0,'1',0,'V',0,'V',0,'V',0,'V',0,'V',0,'V',0
X_MAX:  DC.W 400
NB_TRAITS: DC.B 6 * = nbColonnes + 1
PEN:    DC.B 2 * epaisseur du crayon
LARGEUR_CASE: DC.W 80 * X_MAX / nbColonnes
CHAINE: DC.B '1',0

    END    START      
