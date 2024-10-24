*-----------------------------------------------------------
* Title      : Afficher le contenu de D0 en Hexa
*-----------------------------------------------------------
    ORG    $400
    
    MOVE.B  #0,D2 * compteur
    MOVE.L  #0,D3 * quartet 1
    MOVE.L  #0,D4 * quartet 2
    MOVE.L  #$6789ABCD,D0
    MOVE.L #$1000,A0
    MOVE.L  D0,(A0)
REPETE: 
    MOVE.B (A0)+,D3
    MOVE.B  D3,D4
    AND.B   #$F0,D3
    LSR.B   #4,D3   * décalage à droite 2^4 = 16
    AND.B   #$0F,D4
    MOVE.B  D3,D1
    JSR AFFQUARTET
    MOVE.B  D4,D1
    JSR AFFQUARTET
    
    ADD.B   #1,D2
    CMP.B   #4,D2
    BNE REPETE  
    
FIN_REPETE:
   
    JMP FINPRG    
    
    INCLUDE 'BIBLIO.x68'
    INCLUDE 'QUARTET.x68'
    INCLUDE 'AFFCHAINE.x68'

    ORG $600
QUARTET_1:
    DS.B    1
QUARTET_2:   
    DS.B    1 
    END    $400        


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
