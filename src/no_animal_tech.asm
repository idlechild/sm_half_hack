lorom

incsrc ../resources/IGT_text.asm



org $858086
    JMP override_fanfare_selection
return_from_override_fanfare_selection:

org $85810B
    LDA $09C4 : BMI .override
    LDA $05F9
    RTS
  .override
    LDA #$0002
    RTS
warnpc $858119

org $858412
    ; Relocated this table to make room for more message box types
    LDA SpecialButtonTilemapOffsets,X

org $858749
original_button_tilemap_offset_table:
    ; Expand message definitions
    dw #$8436, #$8289, SaveTooLateText
    ; Currently room for seven more types
    ; The last one must remain reserved
    dw #$8436, #$8289, EndFanfareText
    dw #$8436, #$8289, EndFanfareText
    dw #$8436, #$8289, EndFanfareText
    dw #$8436, #$8289, EndFanfareText
    dw #$8436, #$8289, EndFanfareText
    dw #$8436, #$8289, EndFanfareText
    dw #$8436, #$8289, EndFanfareText
    dw #$8436, #$8289, EndFanfareText



; Message text must be listed in order
org $859643
table ../resources/HUDfont.tbl
SaveTooLateText:
    dw #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    dw #$2800|' '
    dw #$2800|' '
    dw #$2800|' '
    dw #$2800|' '
    dw #$2800|'N'
    dw #$2800|'O'
    dw #$2800|'T'
    dw #$2800|'H'
    dw #$2800|'I'
    dw #$2800|'N'
    dw #$2800|'G'
    dw #$2800|' '
    dw #$2800|'C'
    dw #$2800|'A'
    dw #$2800|'N'
    dw #$2800|' '
    dw #$2800|' '
    dw #$2800|' '
    dw #$2800|' '
    dw #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    dw #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    dw #$2800|' '
    dw #$2800|' '
    dw #$2800|' '
    dw #$2800|' '
    dw #$2800|'S'
    dw #$2800|'A'
    dw #$2800|'V'
    dw #$2800|'E'
    dw #$2800|' '
    dw #$2800|'Y'
    dw #$2800|'O'
    dw #$2800|'U'
    dw #$2800|' '
    dw #$2800|'N'
    dw #$2800|'O'
    dw #$2800|'W'
    dw #$2800|' '
    dw #$2800|' '
    dw #$2800|' '
    dw #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E

EndFanfareText:

; Recreate $8749: Special button tilemap offsets
SpecialButtonTilemapOffsets:
    dw #$0000  ; 1: Energy tank
    dw #$012A  ; 2: Missile
    dw #$012A  ; 3: Super missile
    dw #$012C  ; 4: Power bomb
    dw #$012C  ; 5: Grappling beam
    dw #$012C  ; 6: X-ray scope
    dw #$0000  ; 7: Varia suit
    dw #$0000  ; 8: Spring ball
    dw #$0000  ; 9: Morphing ball
    dw #$0000  ; Ah: Screw attack
    dw #$0000  ; Bh: Hi-jump boots
    dw #$0000  ; Ch: Space jump
    dw #$0120  ; Dh: Speed booster
    dw #$0000  ; Eh: Charge beam
    dw #$0000  ; Fh: Ice beam
    dw #$0000  ; 10h: Wave beam
    dw #$0000  ; 11h: Spazer
    dw #$0000  ; 12h: Plasma beam
    dw #$012A  ; 13h: Bomb
    dw #$0000  ; 14h: Map data access completed
    dw #$0000  ; 15h: Energy recharge completed
    dw #$0000  ; 16h: Missile reload completed
    dw #$0000  ; 17h: Would you like to save?
    dw #$0000  ; 18h: Save completed
    dw #$0000  ; 19h: Reserve tank
    dw #$0000  ; 1Ah: Gravity suit
    dw #$0000  ; 1Bh: Terminator
    dw #$000E  ; 1Ch: Would you like to save? (Used by gunship)
    dw #$000E  ; 1Dh: Reserved (Used by gunship)
    dw #$0000  ; 1Eh: Save too late
    dw #$0000  ; 1Fh:
    dw #$0000  ; 20h:
    dw #$0000  ; 21h:
    dw #$0000  ; 22h:
    dw #$0000  ; 23h:
    dw #$0000  ; 24h:
    dw #$0000  ; 25h:
    dw #$0000  ; 26h: Reserved

override_fanfare_selection:
{
    STA $1C1F
    LDA $09C4 : BMI .override
    JMP return_from_override_fanfare_selection

  .override
    LDA #$001E : STA $1C1F
    JMP return_from_override_fanfare_selection
}



org $8BDE28
    LDY #IGTNoAnimalTechniquesDefinition

org $8BF3B1
    LDY #IGTWereUsedInThisRunDefinition



org $908E75
challenge_failed_shinespark:
    LDA #$F000 : STA $09C2 : STA $09C4
    ; Overwritten code
    LDA #$0008
    RTS
warnpc $908EA9

org $90D0B1
    JSR challenge_failed_shinespark

org $90D0DD
    JSR challenge_failed_shinespark

org $90D10C
    JSR challenge_failed_shinespark



org $91EAC7
    ; Optimize three bytes
    BEQ walljump_set_left_pose
    LDA #$0083
    BRA walljump_set_pose

walljump_set_left_pose:
    LDA #$0084

walljump_set_pose:
    STA $0A28
    LDA #$0005 : STA $0A2E
    JMP challenge_failed_walljump
warnpc $91EADE

org $91EC9D
challenge_failed_walljump:
    LDA #$F000 : STA $09C2 : STA $09C4
    RTS
warnpc $91ECB4



org $AAC8CB
    ; Use a different RTS so we can overwrite the original RTS
    LDA #$C6AB

org $AAC90A
    ; Optimize one byte
    BNE check_gt_code
    JSR $C250
    JML $88DD32

check_gt_code:
    JSR $C280
    LDA $8B : CMP #$C0C0 : BNE return_gt_code

    ; GT code not allowed if challenge failed
    LDA $09C4 : BMI return_gt_code

    ; Set GT code, optimize three bytes
    LDA #$02BC : STA $09C2 : STA $09C4
    LDA #$012C : STA $09D4 : STA $09D6
    LDA #$0064 : STA $09C6 : STA $09C8
    LDA #$0014 : STA $09CA : STA $09CC
    STA $09CE : STA $09D0
    LDA #$F377 : STA $09A2 : STA $09A4
    LDA #$100F : STA $09A6 : STA $09A8

return_gt_code:
    ; Overwrite RTS that is no longer used
    RTL
warnpc $AAC95F

