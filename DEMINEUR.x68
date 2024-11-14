*-----------------------------------------------------------
* Titre      : Projet Démineur
* Écrit par  : Valentin et Matthieu
* Date       : 14 nov. 2024
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  
    
PRINT_GRILLE:  
    MOVE.L #$00FFFFFF,D1
    JSR SET_PEN_COLOR
    MOVE.B LARGEUR,D1
    JSR WIDTH_PEN
    JSR RESET_D
    MOVE X_MAX,D4
VERTICAL:
    JSR DRAW_LINE
    ADD.W LARGEUR,D1
    ADD.W LARGEUR,D3
    ADD.B #1,D5    
    CMP.B NB_TRAITS,D5
    BNE  VERTICAL
FIN_VERTICAL:
    JSR RESET_D
    MOVE X_MAX,D3
HORIZONTAL:
    JSR DRAW_LINE
    ADD.W LARGEUR,D2
    ADD.W LARGEUR,D4    
    ADD.B #1,D5    
    CMP.B NB_TRAITS,D5
    BNE HORIZONTAL
FIN_HORIZONTAL:
FIN_PRINT_GRILLE:

    MOVE.W #25,D1
    MOVE.W #75,D2
    MOVE.L #CHAINE,A1
    JSR DRAW_STRING
  

    JMP FINPRG
    
    INCLUDE 'BIBLIO.x68'
    INCLUDE 'BIBGRAPH.x68'
    
RESET_D:
    MOVE #0,D1
    MOVE #0,D2
    MOVE #0,D3
    MOVE #0,D4
    MOVE #0,D5
    RTS

    ORG $2000
    
GRILLE_SOLUTION: DC.B '',0
X_MAX:  DC.W 500
NB_TRAITS: DC.B 11 * = nbColonnes + 1
PEN:    DC.W 10 * épaisseur du crayon
LARGEUR: DC.W 50 * X_MAX / nbColonnes
CHAINE: DC.B '1',0

    END    START       
