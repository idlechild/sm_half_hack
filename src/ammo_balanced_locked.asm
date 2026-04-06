lorom

; Replace unused instructions in Bank 84
org $848A40
IncrementSupersPBs:
{
    LDA $09C8 : BNE .incSupers
    JML UnlockMissiles
  .incSupers
    LDA $09CC : BEQ .incPBs
    INC : STA $09CC
    INC $09CA
  .incPBs
    LDA $09D0 : BEQ .jump
    INC : STA $09D0
    INC $09CE
  .jump
    JMP $89A9
}
warnpc $848A64

org $848C22
IncrementMissilesPBs:
{
    LDA $09CC : BNE .incMissiles
    JML UnlockSupers
  .incMissiles
    LDA $09C8 : BEQ .incPBs
    INC : STA $09C8
    INC $09C6
  .incPBs
    LDA $09D0 : BEQ .jump
    INC : STA $09D0
    INC $09CE
  .jump
    JMP $89D2
}
warnpc $848C46

org $848C4F
IncrementMissilesSupers:
{
    LDA $09D0 : BNE .incMissiles
    JML UnlockPBs
  .incMissiles
    LDA $09C8 : BEQ .incSupers
    INC : STA $09C8
    INC $09C6
  .incSupers
    LDA $09CC : BEQ .jump
    INC : STA $09CC
    INC $09CA
  .jump
    JMP $89FB
}
warnpc $848C73

; Red door facing left hit count
org $84C32C
    db #$03

; Red door facing right hit count
org $84C38E
    db #$03

; Red door facing up hit count
org $84C3F0
    db #$03

; Red door facing down hit count
org $84C452
    db #$03

; Visible missile pack ammo routine and count
org $84E0DB
    dw IncrementSupersPBs
    dw #$0003

; Visible super missile pack ammo routine and count
org $84E100
    dw IncrementMissilesPBs
    dw #$0003

; Visible power bomb pack ammo routine and count
org $84E125
    dw IncrementMissilesSupers
    dw #$0003

; Chozo orb missile pack ammo routine and count
org $84E4A4
    dw IncrementSupersPBs
    dw #$0003

; Chozo orb super missile pack ammo routine and count
org $84E4D6
    dw IncrementMissilesPBs
    dw #$0003

; Chozo orb power bomb pack ammo routine and count
org $84E508
    dw IncrementMissilesSupers
    dw #$0003

; Hidden missile pack ammo routine and count
org $84E975
    dw IncrementSupersPBs
    dw #$0003

; Hidden super missile pack ammo routine and count
org $84E9AD
    dw IncrementMissilesPBs
    dw #$0003

; Hidden power bomb pack ammo routine and count
org $84E9E5
    dw IncrementMissilesSupers
    dw #$0003

; Use freespace in Bank 86 to do the unlock ammo math
org $86FA00
UnlockMissiles:
{
    LDA $09CC : BEQ .onlyPBs
    LDA $09D0 : BEQ .onlySupers
    CLC : ADC $09CC
    LSR : LSR
    STA $09C6 : STA $09C8
    INC $09CA : INC $09CC
    INC $09CE : INC $09D0
    JML $8489A9

  .onlyPBs
    LDA $09D0 : BEQ .jump
    SEP #$20
    STA $4202
    LDA #$56 : STA $4203
    REP #$20
    PEA $0000 : PLA
    LDA $4216
    XBA : AND #$00FF
    STA $09C6 : STA $09C8
    INC $09CE : INC $09D0
  .jump
    JML $8489A9

  .onlySupers
    LDA $09CC
    SEP #$20
    STA $4202
    LDA #$56 : STA $4203
    REP #$20
    PEA $0000 : PLA
    LDA $4216
    XBA : AND #$00FF
    STA $09C6 : STA $09C8
    INC $09CA : INC $09CC
    JML $8489A9
}

UnlockSupers:
{
    LDA $09C8 : BEQ .onlyPBs
    LDA $09D0 : BEQ .onlyMissiles
    CLC : ADC $09C8
    LSR : LSR
    STA $09CA : STA $09CC
    INC $09C6 : INC $09C8
    INC $09CE : INC $09D0
    JML $8489D2

  .onlyPBs
    LDA $09D0 : BEQ .jump
    SEP #$20
    STA $4202
    LDA #$56 : STA $4203
    REP #$20
    PEA $0000 : PLA
    LDA $4216
    XBA : AND #$00FF
    STA $09CA : STA $09CC
    INC $09CE : INC $09D0
  .jump
    JML $8489D2

  .onlyMissiles
    LDA $09C8
    SEP #$20
    STA $4202
    LDA #$56 : STA $4203
    REP #$20
    PEA $0000 : PLA
    LDA $4216
    XBA : AND #$00FF
    STA $09CA : STA $09CC
    INC $09C6 : INC $09C8
    JML $8489D2
}

UnlockPBs:
{
    LDA $09C8 : BEQ .onlySupers
    LDA $09CC : BEQ .onlyMissiles
    CLC : ADC $09C8
    LSR : LSR
    STA $09CE : STA $09D0
    INC $09C6 : INC $09C8
    INC $09CA : INC $09CC
    JML $8489FB

  .onlySupers
    LDA $09CC : BEQ .jump
    SEP #$20
    STA $4202
    LDA #$56 : STA $4203
    REP #$20
    PEA $0000 : PLA
    LDA $4216
    XBA : AND #$00FF
    STA $09CE : STA $09D0
    INC $09CA : INC $09CC
  .jump
    JML $8489FB

  .onlyMissiles
    LDA $09C8
    SEP #$20
    STA $4202
    LDA #$56 : STA $4203
    REP #$20
    PEA $0000 : PLA
    LDA $4216
    XBA : AND #$00FF
    STA $09CE : STA $09D0
    INC $09C6 : INC $09C8
    JML $8489FB
}
warnpc $86FC00

