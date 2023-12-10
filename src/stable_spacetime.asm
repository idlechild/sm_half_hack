lorom

!SPACETIME_PRESERVE_INFOHUD = 0
!SPACETIME_PRESERVE_SPRITE_OBJECT_RAM = 1
incsrc ../resources/spacetime.asm



org $8189B5
hook_options_mode_spritemap_pointer:
    dw $D00B

org $81B40A
hook_samus_data_upper_text:
table LargeUpperChar.tbl
    dw "SPACE TIME"
warnpc $81B41E

org $81B420
hook_samus_data_lower_text:
table LargeLowerChar.tbl
    dw "SPACE TIME"
warnpc $81B434



org $82ECD9
hook_load_options_mode_draw_border:
    JSR draw_options_title_and_border

org $82EFD7
hook_return_to_options_mode_draw_border:
    JSR draw_options_title_and_border

org $82F4C4
hook_options_mode_menu_object_definition:
    dw $F363

org $82F480
hook_options_mode_init_border_draw_instruction:
    dw $D00B

org $82F488
hook_options_mode_loop_border_draw_instruction:
    dw $D00B



org $82F800
print pc, " stable_spacetime bank $82 start"

option_mode_upper_text:
table LargeUpperChar.tbl
    dw " SPACE TIME"

option_mode_lower_text:
table LargeLowerChar.tbl
    dw " SPACE TIME"

draw_options_title_and_border:
{
    LDX #$0014
  .loopUpper
    LDA.w option_mode_upper_text,X : STA $7E3054,X
    DEX : DEX : BPL .loopUpper

    LDX #$0014
  .loopLower
    LDA.w option_mode_lower_text,X : STA $7E3094,X
    DEX : DEX : BPL .loopLower

    ; Draw border
    JMP $8BCB
}

print pc, " stable_spacetime bank $82 end"

