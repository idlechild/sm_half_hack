
org $80ADB5
hook_scroll_down_offsets:
    JSR fix_scroll_down_offsets

org $80AE29
hook_scroll_offsets:
    JSR fix_scroll_offsets




org $80FC00
print pc, " vanilla_bugfix bank $80 start"

fix_scroll_offsets:
{
    LDA $B3 : AND #$FF00 : STA $B3
    LDA $B1 : AND #$FF00 : SEC
    RTS
}

fix_scroll_down_offsets:
{
    LDA $B3 : AND #$FF00 : ORA #$0020 : STA $B3
    LDA $B1 : AND #$FF00 : SEC
    JMP $AE2C
}

print pc, " vanilla_bugfix bank $80 end"



org $8C9607
hook_zebes_planet_tile_data:
    dw #$0E2F



org $90E908
hook_preserve_escape_timer:
    JSR preserve_escape_timer

org $90EA7F
low_health_check:
{
    LDA $0592 : BMI .done
    LDA $09C2 : CLC : ADC $09D6 : CMP #$001E : BPL .turn_off
    LDA $0A6A : BNE .done
    INC : STA $0A6A : INC
  .queue_sound
    JSL $80914D
  .done
    RTS

  .turn_off
    LDA $0A6A : BEQ .done
    TDC : STA $0A6A
    INC : BRA .queue_sound
}

warnpc $90EAAB

org $90F331
hook_queue_low_health_and_grapple_sound:
    JSR low_health_check
    BRA $0A



org $90F800
print pc, " vanilla_bugfix bank $90 start"

preserve_escape_timer:
{
    ; check if timer is active
    LDA $0943 : AND #$0006 : BEQ .done
    JSL $809F6C ; Draw timer

  .done
    JMP $EA7F ; overwritten code
}

clear_escape_timer:
{
    ; clear timer status
    STZ $0943

    ; overwritten code
    LDA #$AC1B
    STA $0FB2,X
    STZ $0DEC
    RTL
}

print pc, " vanilla_bugfix bank $90 end"



org $9181A4
hook_shinespark_determine_prospective_pose:
    JSR $81AD



org $91E6CF
hook_item_change_update_healthalarm:
    PLB : PLP
    JML $90EAAB



org $A2ABFD
hook_clear_escape_timer:
    JML clear_escape_timer

