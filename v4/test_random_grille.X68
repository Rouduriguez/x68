*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:  
                
    MOVE.L  #GRILLE_TEST,A0
    MOVE.W  #81,NB_CASES
    MOVE.W  #10,NB_MINES
    MOVE.L  #ADJ,A2
    MOVE.W  #9,NB_COLONNES
    JSR REMPLIT_ZERO_GRILLE
    JSR PRINT
    
RANDOM_GRILLE:                  
    MOVE.L  #0,D2 * CPT MINES
BOUCLE_RANDOM:
    MOVE.L  #0,D3 * compteur attente
RANDOM_ATTENTE_1:
    ADD.L   #1,D3 
    CMP.L   #$00009ABC,D3
    BNE RANDOM_ATTENTE_1
    MOVE.L  #0,D3
    JSR GET_TIME
    AND.L   #$0000FFFF,D1
    DIVU    NB_CASES,D1
    SWAP    D1
    MOVE.W  D1,D6
    CMP.B   #66,(A0,D6) * si t[D1] = 'B', on recommence
    BEQ BOUCLE_RANDOM
    MOVE.B  #66,(A0,D6)    
    JSR CASES_ADJ
RANDOM_ADJ_INCR:
    CMP.W   #ADJ,A2
    BEQ FIN_RANDOM_ADJ
    MOVE.W  -(A2),D0   
    CMP.B   #66,(A0,D0)
    BEQ RANDOM_ADJ_INCR
    ADD.B   #1,(A0,D0)
    JSR PRINT *
    BRA RANDOM_ADJ_INCR  
FIN_RANDOM_ADJ:
    
RANDOM_ATTENTE_2:
    ADD.L   #1,D3 * compteur attente
    CMP.L   #$0000DEF0,D3
    BNE RANDOM_ATTENTE_2
    ADD.W   #1,D2 * compteur de mines
    *JSR PRINT
    CMP.W   NB_MINES,D2
    BNE BOUCLE_RANDOM
FIN_BOUCLE:


    

    JMP FINPRG  
    
PRINT:
    MOVE.W  #0,D4
    MOVE.W  #0,D5
BOUCLE_PRINT:
    MOVE.B  (A0)+,D1
    JSR AFFCAR
    ADD.W   #1,D4
    CMP.W   NB_COLONNES,D4
    BNE BOUCLE_PRINT
    MOVE.W  #0,D4
    MOVE.B  #10,D1
    JSR AFFCAR
    MOVE.B  #13,D1
    JSR AFFCAR
    ADD.W   #1,D5
    CMP.W   NB_COLONNES,D5
    BNE BOUCLE_PRINT
    MOVE.L  #GRILLE_TEST,A0
    MOVE.B  #10,D1
    JSR AFFCAR
    MOVE.B  #13,D1
    JSR AFFCAR 
    RTS

REMPLIT_ZERO_GRILLE:
    MOVE.W  #0,D0
BOUCLE_ZERO_GRILLE:
    MOVE.L  #$30303030,(A0)+
    ADD.W   #4,D0
    CMP.W   NB_CASES,D0
    BMI BOUCLE_ZERO_GRILLE
    MOVE.L  #GRILLE_TEST,A0
    RTS

    INCLUDE 'BIBPERIPH.x68'
    INCLUDE 'BIBLIO.x68'
    INCLUDE 'BIBGRAPH.x68'
    *INCLUDE 'BIB_DEMINEUR.x68'
    INCLUDE 'BIB_AFFICHEUR.x68'

CASES_ADJ: 
    MOVE.L  #0,D7
    MOVE.W  NB_COLONNES,D7
    SUB.W   #1,D7     
TEST_BORD:
    MOVE.L  #0,D5 
    MOVE.L  D6,D0
    DIVU    NB_COLONNES,D0
TEST_BORD_HB: 
    CMP.W   #0,D0
    BEQ ADD_BORD_HAUT
    CMP.W   D7,D0
    BEQ ADD_BORD_BAS
FIN_TEST_BORD_HB:

TEST_BORD_GD:
    SWAP D5
    SWAP    D0 
    CMP.W   #0,D0
    BEQ ADD_BORD_GAUCHE
    CMP.W   D7,D0
    BEQ ADD_BORD_DROIT
FIN_TEST_BORD_GD:
CMP_BORD:
    MOVE.W  D6,D0
    SWAP    D5
    CMP.B   #2,D5
    BEQ BORD_HAUT
    CMP.B   #1,D5
    BEQ BORD_BAS
    SWAP    D5
    CMP.B   #2,D5
    BEQ BORD_G
    CMP.B   #1,D5
    BEQ BORD_D      
*   8 CASES ADJACENTES
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    
TRACER_CASES_ADJ:
    RTS
    
* --------------------------------------------------

BORD_HAUT:
    SWAP    D5
    CMP.B   #2,D5
    BEQ COIN_HG
    CMP.B   #1,D5
    BEQ COIN_HD
    JSR CASES_INF
    JSR CASES_GD  
    BRA TRACER_CASES_ADJ 
    
BORD_BAS:
    SWAP    D5
    CMP.B   #2,D5
    BEQ COIN_BG
    CMP.B   #1,D5
    BEQ COIN_BD
    JSR CASES_SUP
    JSR CASES_GD
    BRA TRACER_CASES_ADJ    
    
COIN_HG:    
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASES_ADJ
    
COIN_HD:    
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASES_ADJ 
    
COIN_BG:    
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASES_ADJ 
    
COIN_BD:    
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASES_ADJ  
 
BORD_G:    
    MOVE.W  D6,D0
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASES_ADJ 
    
BORD_D:    
    MOVE.W  D6,D0
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    ADD.W   #1,D0
    MOVE.W  D0,(A2)+
    BRA TRACER_CASES_ADJ   
  
ADD_BORD_HAUT:
    ADD.B  #2,D5
    BRA FIN_TEST_BORD_HB
    
ADD_BORD_BAS:
    ADD.B  #1,D5
    BRA FIN_TEST_BORD_HB
    
ADD_BORD_GAUCHE:
    ADD.B  #2,D5
    BRA FIN_TEST_BORD_GD
    
ADD_BORD_DROIT:
    ADD.B  #1,D5
    BRA FIN_TEST_BORD_GD   
 
CASES_SUP: * i dans D6.W, retourne les cases sup dans (A2)
    MOVE.L  #0,D0    
    MOVE.W  D6,D0
    SUB.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   #2,D0
    MOVE.W  D0,(A2)+
    RTS
    
CASES_INF: * i dans D6.W, retourne les cases INF dans (A2)
    MOVE.L  #0,D0    
    MOVE.W  D6,D0
    ADD.W   NB_COLONNES,D0
    MOVE.W  D0,(A2)+
    SUB.W   #1,D0
    MOVE.W  D0,(A2)+
    ADD.W   #2,D0
    MOVE.W  D0,(A2)+
    RTS
    
CASES_GD:
    ADD.W   #1,D6
    MOVE.W  D6,(A2)+
    SUB.W   #2,D6
    MOVE.W  D6,(A2)+
    ADD.W   #1,D6
    RTS

CASES_HB:
    ADD.W   NB_COLONNES,D6
    MOVE.W  D6,(A2)+
    SUB.W   NB_COLONNES,D6
    SUB.W   NB_COLONNES,D6
    MOVE.W  D6,(A2)+
    ADD.W   NB_COLONNES,D6
    RTS
    
    
        
    ORG     $3000

NB_COLONNES:    DS.W 1
LARGEUR_CASE:   DS.W 1 * xmax / nb_col
CENTRE_CASE:    DS.W 1
RES_X:  DC.W 700
RES_Y:  DC.W 700
X_MAX:  DC.W 450 * (multiple de 45)
OX_GRILLE:  DS.W 1 * xmax / 10
OY_GRILLE:  DS.W 1 * xmax / 5
OX_AFFICHEUR_1: DS.W 1 * = ox_grille
OX_AFFICHEUR_2: DS.W 1 * ox_grille + xmax - dx_aff
OX_AFFICHEUR: DS.W 1
OX_AFFICHEUR_ACTUEL: DS.W 1
OY_AFFICHEUR: DS.W 1 * 2*OY_aff + DY_aff = OY_grille
DX_AFFICHEUR: DC.W 150 * 4*dx_num + 3*lon_seg ; * dc sinon bug mais pourquoi ?
DY_AFFICHEUR: DC.W 70
DX_NUM_AFFICHEUR: DS.W 1 * lon_seg / 2
LON_SEG:    DC.W 30
COULEUR_SEG:    DC.L $000000FF
CHRONO:  DC.W    0
* afficheur : dx = 155, dy = 70, lon_seg = 30
X:  DS.W 1
Y:  DS.W 1
BUFFER_CHRONO:  DC.L 0
COULEUR_CACHEE: DC.L $00E6E0B0
COULEUR_FLAG: DC.L $00FF00FF
COULEUR_CRAYON: DC.L $00BBBBBB
COULEUR_FOND:   DC.L $00D3D3D3
COULEUR_AFFICHEUR:  DC.L $00000000
COULEUR_RESTART:    DC.L $0000FFFF
N:  DC.W 0
NB_CASES:   DS.W 1
NB_MINES:  DS.W 1
CASES_RESTANTES: DC.W 0
ADJ:    DS.W 9
BUFFER_CLIC:    DC.B 0
MSG_VICTOIRE:   DC.B 'Bravo pour cette belle victoire !',0
MSG_DEFAITE:    DC.B 'Dommage ! C est perdu...',0
GRILLE_FACILE: DC.B 'B2B101322001B100111000000'
GRILLE_MOYENNE:	DC.B '00001110000001B210000013B20000003B30111112B20B11B1111012221000012B211111B212B11B1'
GRILLE_DIFFICILE: DC.B '0001110000000111111B211000001B2B2223B332100112B32B22BBB2121112B32224B43B2B1122B11B323B2211B2122213B311011B312B102B31102BB21B221212B113B111111B101222B200000122112B3210000112B22B3B1000001B33B213231110124B31101B2BB101B3B20001121'
CHAINE_DIFFICULTE:  DC.B 'Choix de la difficulte...',0
CHAINE_FACILE:  DC.B 'Facile',0
CHAINE_MOYEN:   DC.B 'Moyen',0
CHAINE_DIFFICILE: DC.B 'Difficile',0
GRILLE_TEST:    DS.B 255


    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
