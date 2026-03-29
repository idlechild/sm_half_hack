lorom

; Replace unused instructions in Bank 84
org $848A40
IncrementSupersPBs:
    INC $09CA
    INC $09CC
    INC $09CE
    INC $09D0
    JMP $89A9

IncrementMissilesPBs:
    INC $09C6
    INC $09C8
    INC $09CE
    INC $09D0
    JMP $89D2

IncrementMissilesSupers:
    INC $09C6
    INC $09C8
    INC $09CA
    INC $09CC
    JMP $89FB
warnpc $848A72

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

