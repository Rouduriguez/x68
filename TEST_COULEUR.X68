    ORG    $400

    MOVE.L #$00FF5500,D1
    JSR SET_FILL_COLOR
    MOVE.L  #0,D1
    JSR POT_DE_PEINTURE
    
    INCLUDE 'BIBGRAPH.X68'
    END    $400  

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
