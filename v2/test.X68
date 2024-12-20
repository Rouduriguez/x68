*-----------------------------------------------------------
* Title      : Trace la grille en fonction de la difficulte choisie
* Written by :
* Date       :
* Description: 'B' = $42 ; '0' = $30
*-----------------------------------------------------------
    ORG    $1000
START:                  

    MOVE.L  #GRILLE_SOLUTION,A0
PRINT_DIFFICULTE:
    MOVE.L  #$00FF0000,D1
    JSR SET_FILL_COLOR
    MOVE.W  #100,D1
    MOVE.W  #100,D2
    MOVE.W  #200,D3
    MOVE.W  #150,D4
    JSR DRAW_FILL_RECT
    MOVE.L  #$0000FF00,D1
    JSR SET_FILL_COLOR
    MOVE.W  D3,D1
    ADD.W  #50,D1 * car D3 = D1 + 100
    ADD.W  #150,D3
    JSR DRAW_FILL_RECT
    MOVE.L  #$000000FF,D1
    JSR SET_FILL_COLOR
    MOVE.W  D3,D1
    ADD.W  #50,D1 
    ADD.W  #150,D3
    JSR DRAW_FILL_RECT
FIN_PRINT_BOUTONS:
    
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
    BEQ FACILE
    CMP.L  #$0000FF00,D1
    BEQ MOYEN
    CMP.L  #$000000FF,D1
    BEQ DIFFICILE
    BRA CHOIX_DIFFICULTE
FIN_CHOIX_DIFFICULTE
    MOVE.W  NB_COLONNES,NB_TRAITS
    ADD.W  #1,NB_TRAITS
    MOVE.W  #$FF00,D1
    JSR POS_CURS * Efface l'ecran
    JSR PRINT_LIGNES_GRILLE
    JSR COULEUR_GRILLE
    

    
    JMP FINPRG
    
FACILE:
    ADD.L  #0,A0
    MOVE.W  #5,NB_COLONNES
    MOVE.W  #80,LARGEUR_CASE
    BRA FIN_CHOIX_DIFFICULTE
MOYEN:
    ADD.L  #10,A0
    MOVE.W  #10,NB_COLONNES
    MOVE.W  #40,LARGEUR_CASE
    BRA FIN_CHOIX_DIFFICULTE
DIFFICILE:
    ADD.L   #30,A0
    MOVE.W  #16,NB_COLONNES
    MOVE.W  #25,LARGEUR_CASE
    BRA FIN_CHOIX_DIFFICULTE
    

    INCLUDE 'BIBPERIPH.x68'
    INCLUDE 'BIBLIO.x68'
    INCLUDE 'BIBGRAPH.x68'
    INCLUDE 'BIB_DEMINEUR.x68'
    
        
    ORG     $3000

NB_COLONNES:    DS.W 1
NB_TRAITS: DS.W 1
LARGEUR_CASE:   DS.W 1
CENTRE_CASE:    DS.W 1
X_MAX:  DC.W 400
X:  DS.W 1
Y:  DS.W 1
COULEUR_CACHEE: DC.L $00E6E0B0
COULEUR_CRAYON: DC.L $00BBBBBB
CHRONO: DC.L 0
CHAINE_CHRONO:  DS.B 4 
CHAINE: DS.B 200
EASY:   DC.B 'Easy...',0
MEDIUM: DC.B 'Medium.',0
HARD:   DC.B 'Hard !',0
N:  DC.B 'N'
MSG_VICTOIRE:   DC.B 'Bravo pour cette belle victoire !',0
MSG_DEFAITE:    DC.B 'Dommage ! C est perdu...',0
GRILLE_SOLUTION:    DC.B '123456789 123456789 123456789 123456789 123456789 123456789',0

    END    START   
