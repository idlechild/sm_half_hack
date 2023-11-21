
; Special Settings Menu ASM
; Use this ASM to replace the Icon Cancel menu option with your own setting
; Intended for use with asar v1.81 assembler
; Thanks to P.JBoy's bank logs https://patrickjohnston.org/bank/82

pushtable

macro DoubleRowText(text)
table LargeUpperChar.tbl
  ..upper
    db "<text>", $FF
table LargeLowerChar.tbl
  ..lower
    db "<text>", $FF
endmacro


org $82F0AE
SpecialSettingsAddressTable:
; Any two addresses in bank $7E    <------------------------ SET THE ADDRESS OF YOUR SETTINGS
; IconCancel, MoonWalk
    dw $09EA, $09E4
warnpc $82F0B2


org $82FD90 ;    <------------------------------------------ SET TO $C8 BYTES OF FREESPACE IN BANK $82
print pc, " SpecialSettingsMenu bank $82 start"

EditedTilemap:
; Setting name can be up to 13 characters long      ┌------- NAME YOUR SETTINGS
; Enabled and disabled text is 6 characters each    |
; The bracketed area represents which tiles will    |
; have their palettes adjusted when toggled         |
; Spaces are used at the end to overwrite tiles     V
  .opt0
if defined("EDITED_TILEMAP_TEXT")
    %DoubleRowText("!EDITED_TILEMAP_TEXT")
else
    %DoubleRowText("CUSTOM THING  ON      OFF ")
endif
;                   [           ][    ] [    ]
  .opt1
    %DoubleRowText("MOON WALK     ON      OFF ")
;                   [           ][    ] [    ]

EditSpecOptTilemap:
; This routine edits the tilemap after decompression

; Set this to 1 if you want to clear out the    <----------- ARE YOU REPLACING MOON WALK?
; (SHOT HOLD+dpad) description text under Moon Walk
!CLEAR_MOONWALK_DESCRIPTION = 0

if !CLEAR_MOONWALK_DESCRIPTION
    LDA #$000F
    LDX #$03C4
  .clear_moonwalk_loop
    STA $7E3000,X
    INX #2 : CPX #$0420 : BNE .clear_moonwalk_loop
endif

    SEP #$20
    LDX #$01C6
    LDY #$0000
  .upper_0_loop
    LDA.w EditedTilemap_opt0_upper,Y : CMP #$FF : BEQ .lower_0
    STA $7E3000,X
    INX #2 : INY
    BRA .upper_0_loop

  .lower_0
    LDX #$0206
    LDY #$0000
  .lower_0_loop
    LDA.w EditedTilemap_opt0_lower,Y : CMP #$FF : BEQ .upper_1
    STA $7E3000,X
    INX #2 : INY
    BRA .lower_0_loop

  .upper_1
    LDX #$0346
    LDY #$0000
  .upper_1_loop
    LDA.w EditedTilemap_opt1_upper,Y : CMP #$FF : BEQ .lower_1
    STA $7E3000,X
    INX #2 : INY
    BRA .upper_1_loop

  .lower_1
    LDX #$0386
    LDY #$0000
  .lower_1_loop
    LDA.w EditedTilemap_opt1_lower,Y : CMP #$FF : BEQ .done
    STA $7E3000,X
    INX #2 : INY
    BRA .lower_1_loop

  .done
    REP #$20
    RTS

print pc, " SpecialSettingsMenu bank $82 end"


org $82EF84
; Skip Japanese branch
    NOP : NOP

org $82EFA6
; Slip in our hijack after freeing up 3 bytes
    JSR EditSpecOptTilemap
    STZ $099E
    JSR $F0B9
    INC $099E ; Replaces LDA #$0001 : STA $099E
warnpc $82EFB2


org $90AD6E
; Disable Icon Cancel
    BRA $06
warnpc $90AD70

pulltable
