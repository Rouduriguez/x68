RESET_D:
    MOVE.L  #0,D0
    MOVE.L  #0,D1
    MOVE.L  #0,D2
    MOVE.L  #0,D3
    MOVE.L  #0,D4
    MOVE.L  #0,D5
    MOVE.L  #0,D6
    *MOVE.L  #0,D7
    RTS

PRINT_LIGNES_GRILLE:
    JSR RESET_D
    MOVE.L #$00FFFFFF,D1
    JSR SET_PEN_COLOR
    MOVE.B #3,D1
    JSR WIDTH_PEN
    JSR RESET_D
    MOVE X_MAX,D4
LIGNES_VERTICALES:
    JSR DRAW_LINE
    ADD.W LARGEUR_CASE,D1
    ADD.W LARGEUR_CASE,D3
    ADD.W #1,D5    
    CMP.W NB_TRAITS,D5
    BNE LIGNES_VERTICALES
FIN_LIGNES_VERTICALES:
    JSR RESET_D
    MOVE X_MAX,D3
LIGNES_HORIZONTALES:
    JSR DRAW_LINE
    ADD.W LARGEUR_CASE,D2
    ADD.W LARGEUR_CASE,D4    
    ADD.W #1,D5    
    CMP.W NB_TRAITS,D5
    BNE LIGNES_HORIZONTALES
    JSR RESET_D
    RTS   
    
COULEUR_GRILLE: * compteurs : D5 pour x et D6 y
    JSR RESET_D
    MOVE.L COULEUR_CRAYON,D1
    JSR SET_PEN_COLOR
    MOVE.L COULEUR_CACHEE,D1
    JSR SET_FILL_COLOR
    JSR RESET_D
    MOVE.W  LARGEUR_CASE,D3
    MOVE.W  LARGEUR_CASE,D4   
REPETE_COULEUR_LARGEUR:  
    JSR DRAW_FILL_RECT
    ADD.W   LARGEUR_CASE,D1
    ADD.W   LARGEUR_CASE,D3
    ADD.W   #1,D5
    CMP.W   NB_COLONNES,D5
    BNE REPETE_COULEUR_LARGEUR
REPETE_COULEUR_HAUTEUR:
    MOVE.W  #0,D1 * "retour chariot"
    MOVE.W  LARGEUR_CASE,D3
    ADD.W   LARGEUR_CASE,D2
    ADD.W   LARGEUR_CASE,D4
    MOVE.W  #0,D5    
    ADD.W   #1,D6
    CMP.W   NB_COLONNES,D6
    BNE REPETE_COULEUR_LARGEUR
    JSR RESET_D
    RTS
        
GET_I: * X/Y .W -> D1.B = indice de la case cliquee    
    JSR RESET_D
    *MOVE.L  #GRILLE_SOLUTION,A0
    MOVE.W  X,D1
    MOVE.W  Y,D2
    DIVU    LARGEUR_CASE,D1 * indice x
    DIVU    LARGEUR_CASE,D2 * indice y
    MULU    NB_COLONNES,D2   
    ADD.W   D2,D1
    RTS
    
XY_CASE: * i dans D6, retourne dans D1-4
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
    RTS

COULEUR_NOMBRE:
    CMP.B   #$30,N
    BEQ ZERO
    CMP.B   #$31,N
    BEQ UN
    CMP.B   #$32,N
    BEQ DEUX
    MOVE.L  #$0000A5FF,D1 * N >= 3, à continuer si je décide de mettre N>3 ?
    BRA FIN_COULEUR_NOMBRE 
ZERO:   
    MOVE.L  #$00000000,D1
    BRA FIN_COULEUR_NOMBRE   
UN:
    MOVE.L  #$0090EE90,D1
    BRA FIN_COULEUR_NOMBRE
DEUX:
    MOVE.L  #$0000CCFF,D1
    BRA FIN_COULEUR_NOMBRE
FIN_COULEUR_NOMBRE:
    RTS 
    

VICTOIRE:
    MOVE.L  #$00FF00FF,D1
    JSR SET_FILL_COLOR
    MOVE.L  #MSG_VICTOIRE,A1
    MOVE.W  X_MAX,D1
    ASR.W   #1,D1    
    MOVE.W  X_MAX,D2
    ADD.W   #20,D2    
    JSR DRAW_STRING
    RTS

AFF_CHRONO:
    *MOVE.L #CHAINE_CHRONO,A2
REPETE_DECIMAL:
    MOVE.L  CHRONO,D7
    DIVU #10,D7 * résultat: 16 bits de poids forts = reste ; 16 bits de poids faibles = quotient
    SWAP    D7
    MOVE.B D7,(A2)+
    SWAP    D7
    CMP.B #0,D7
    BNE REPETE_DECIMAL
    SUB.L #1,A2    * compenser la dernière incrémentation     
AFFICHE_CHRONO:
    MOVE.B (A2),D1 
    ADD.B #$30,D1   
    JSR AFFCAR
    CMP.L #CHAINE_CHRONO,A2
    BEQ FIN_AFFICHE_CHRONO
    SUB.L #1,A2
    BRA AFFICHE_CHRONO
FIN_AFFICHE_CHRONO:    
    RTS

PRINT_CHAR_GRILLE: * compteurs : D3 pour x et D4 y
    JSR RESET_D
    MOVE.L  A0,A5
    MOVE.W  LARGEUR_CASE,D1
    ASR.W   #1,D1
    MOVE.W  D1,D2
    *MOVE.L #GRILLE_SOLUTION,A1
    *MOVE.L A0,A1    
REPETE_CHAR_LARGEUR:
    MOVE.B  (A5)+,(A1)
    JSR DRAW_STRING
    ADD.W   LARGEUR_CASE,D1
    ADD.W   #1,D3
    CMP.W   NB_COLONNES,D3
    BNE REPETE_CHAR_LARGEUR
REPETE_CHAR_HAUTEUR:
    MOVE.W  LARGEUR_CASE,D1 * "retour chariot"
    ASR.W   #1,D1
    ADD.W   LARGEUR_CASE,D2
    MOVE.W  #0,D3
    ADD.W   #1,D4
    CMP.W   NB_COLONNES,D4
    BNE REPETE_CHAR_LARGEUR
    JSR RESET_D
    RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
