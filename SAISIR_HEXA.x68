*-----------------------------------------------------------
* Title      : Saisir un nombre en hexa
*-----------------------------------------------------------

    ORG $400
       
    MOVE.L #TAB,A0
    MOVE.L #0,D2
    MOVE.L #0,D3 * compteur
    
REPETE:
    JSR SAISCAR
    CMP.B #58,D1 * 57 = '9'
    BMI CHIFFRES    
LETTRES:
    SUB.B   #55,D1
    BRA REMPLIR_TAB
CHIFFRES:
    SUB.B #48,D1
REMPLIR_TAB: 
    MOVE.B D1,(A0)+
    ADD.B #1,D3
    CMP #7,D3
    BNE REPETE
SUITE:
    

    
 
    JMP FINPRG
    
    INCLUDE 'BIBLIO.x68'
    
TAB: DS.B 8
*CPT:    DC.B 0
       
    END $400
    

