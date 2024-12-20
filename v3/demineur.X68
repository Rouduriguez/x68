*-----------------------------------------------------------
* Description: centrer l'affichage des N
*               la win condition grrrr
*              garder Xmax constant, ou le modifier en fonction de la difficulte ?
*              creer des sous routines
*              "random"
*              imiter l'interface du demineur OG !!!
*-----------------------------------------------------------
*               D1-4 = XY ; 
*               (D5 = cpt de cases restantes) ; 
*               D6 = indice tab ; D7 = attente (combiner avec D0 ?)
*               A0 = grille solution
*               A1 = DRAW_STRING
*               A2 = timer
*               A3 = chaine_clic
*-----------------------------------------------------------
    ORG    $1000
START:                  
    MOVE.W  #675,D1
    SWAP    D1
    MOVE.W  #720,D1
    JSR RESOLUTION
    
    MOVE.L  #N,A1
    MOVE.L  #CHAINE_CHRONO,A2
    MOVE.L  #CHAINE_CLIC,A3
PRINT_DIFFICULTE: * soigner l'ecran de selection
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
FIN_CHOIX_DIFFICULTE:
ATTENTE: * delai avant de pouvoir jouer
    ADD.L   #1,D7
    CMP.L   #$00030000,D7 * compteur seconde = environ $30000
    BMI ATTENTE
FIN_ATTENTE:
    MOVE.W  NB_COLONNES,NB_TRAITS
    ADD.W  #1,NB_TRAITS
    *MOVE.B  NB_CASES,D1
    *SUB.B   NB_BOMBES,D1
    MOVE.B  D1,CASES_RESTANTES
    MOVE.W  #$FF00,D1
    JSR POS_CURS * Efface l'ecran
    JSR PRINT_LIGNES_GRILLE
    JSR COULEUR_GRILLE
    *JSR PRINT_CHAR_GRILLE  

BOUCLE_SOURIS:
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
    JSR GET_I
CASE_DEJA_CLIQUEE:
    AND.L   #$000000FF,D1
    MOVE.B  (A3,D1),D0
    CMP.B   #1,D0
    BEQ BOUCLE_SOURIS
    MOVE.B  #1,(A3,D1)
FIN_CASE_DEJA_CLIQUEE:

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
    JSR DRAW_STRING
    
    SUB.B   #1,CASES_RESTANTES
    MOVE.B  CASES_RESTANTES,D5
    CMP.B   #0,CASES_RESTANTES
    BNE BOUCLE_SOURIS
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
    MOVE.B  #0,D6 * indice tableau
REVELE_BOMBES:    
    CMP.B   #66,(A0,D6)
    BEQ BOMBE
SUITE_REVELE_BOMBES:
    ADD.B   #1,D6
    CMP.B   NB_CASES,D6
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
    
FACILE:
    * grille_facile += 25*rand(0,n-1) si on veut une grille random parmi n grilles
    MOVE.L  #GRILLE_FACILE,A0
    MOVE.W  #5,NB_COLONNES
    MOVE.W  #135,LARGEUR_CASE
    MOVE.B  #25,NB_CASES
    MOVE.B  #3,NB_BOMBES
    MOVE.B  #22,CASES_RESTANTES * affectation manuelle car bug sinon
    
    BRA FIN_CHOIX_DIFFICULTE
MOYEN:
    * grille += 100*rand(0,n-1)
    MOVE.L  #GRILLE_MOYENNE,A0
    MOVE.W  #9,NB_COLONNES
    MOVE.W  #75,LARGEUR_CASE
    MOVE.B  #100,NB_CASES
    MOVE.B  #10,NB_BOMBES
    MOVE.B  #90,CASES_RESTANTES
    
    BRA FIN_CHOIX_DIFFICULTE
DIFFICILE:
    * grille += 225*rand(0,n-1)
    MOVE.L  #GRILLE_DIFFICILE,A0
    MOVE.W  #15,NB_COLONNES
    MOVE.W  #45,LARGEUR_CASE
    MOVE.B  #225,NB_CASES
    MOVE.B  #40,NB_BOMBES
    MOVE.B  #185,CASES_RESTANTES
    
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
X_MAX:  DC.W 675 * (multiple de 45)
X:  DS.W 1
Y:  DS.W 1
COULEUR_CACHEE: DC.L $00E6E0B0
COULEUR_CRAYON: DC.L $00BBBBBB
CHRONO: DC.L 0
CHAR:   DC.W 0
N:  DC.W 0
CHAINE_CHRONO:  DS.B 4 
CHAINE: DS.B 200
NB_CASES:   DS.B 1
NB_BOMBES:  DS.B 1
CASES_RESTANTES: DC.B 0
MSG_VICTOIRE:   DC.B 'Bravo pour cette belle victoire !',0
MSG_DEFAITE:    DC.B 'Dommage ! C est perdu...',0
GRILLE_FACILE: DC.B 'B2B101322001B100111000000'
GRILLE_MOYENNE:	DC.B '00001110000001B210000013B20000003B30111112B20B11B1111012221000012B211111B212B11B1'
GRILLE_DIFFICILE: DC.B '0001110000000111111B211000001B2B2223B332100112B32B22BBB2121112B32224B43B2B1122B11B323B2211B2122213B311011B312B102B31102BB21B221212B113B111111B101222B200000122112B3210000112B22B3B1000001B33B213231110124B31101B2BB101B3B20001121'
CHAINE_CLIC:      DC.B '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
    END    START 

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
