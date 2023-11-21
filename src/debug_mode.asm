lorom

org $808004
    dw $0101, $0101  ; enable debug mode and scrolling

org $809490
    JMP $9497        ; skip resetting player 2 inputs

org $8094DF
    PLP              ; patch out resetting of controller 2 buttons and enable debug mode
    RTL

org $81B363
    STZ $09E6        ; allow Samus positioning in demo recorder
    LDA #$0001

org $82EDB4
    BRA $07          ; allow game to start in ceres in debug mode

