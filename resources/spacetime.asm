
org $90ACF6
hook_load_beam_palette_external:
    JSR original_load_beam_palette

org $90AD18
hook_load_beam_palette:
    JMP spacetime_routine



org $90FA00
print pc, " spacetime bank $90 start"

original_load_beam_palette:
{
    AND #$0FFF : ASL : TAY
    LDA #$0090 : XBA : STA $01
    LDA $C3C9,Y : STA $00
    LDY #$0000
    LDX #$0000

  .loop
    LDA [$00],Y
    STA $7EC1C0,X
    INX : INX : INY : INY
    CPY #$0020 : BMI .loop
    RTS
}

spacetime_routine:
{
    ; The normal routine shouldn't come here, but sanity check just in case
    ; Also skips out if spacetime but Y value is positive
    INY : INY : CPY #$0000 : BPL .normal_load_palette

    ; Sanity check that X is 0 (if not then do the original routine)
    CPX #$0000 : BNE .normal_load_palette

    ; Check if Y will cause us to reach infohud
    TYA : CLC : ADC #($7EC608-$7EC1DE) : CMP #$0000 : BPL .normal_load_palette

    ; It will, so run our own loop
    INX : INX
  .loop_before_infohud
    LDA [$00],Y
    STA $7EC1C0,X
    INX : INX : INY : INY
    CPX #($7EC608-$7EC1C0) : BMI .loop_before_infohud
 
    ; Skip over infohud
    TXA : CLC : ADC #($7EC6C8-$7EC608) : TAX
    TYA : CLC : ADC #($7EC6C8-$7EC608) : TAY
    CPY #$0020 : BMI .check_sprite_object_ram
    RTS

  .normal_load_loop
    LDA [$00],Y
    STA $7EC1C0,X
    INY : INY
  .normal_load_palette
    INX : INX
    CPY #$0020 : BMI .normal_load_loop
    RTS

  .check_sprite_object_ram
    ; Check if Y will cause us to reach sprite object ram
    TYA : CLC : ADC #($7EEF78-$7EC6EA) : CMP #$0000 : BPL .normal_load_palette

    ; It will, so run our own loop
  .loop_before_sprite_object_ram
    LDA [$00],Y
    STA $7EC1C0,X
    INX : INX : INY : INY
    CPX #($7EEF78-$7EC1C0) : BMI .loop_before_sprite_object_ram

    ; Skip over sprite object ram and resume normal loop
    TXA : CLC : ADC #($7EF378-$7EEF78) : TAX
    TYA : CLC : ADC #($7EF378-$7EEF78) : TAY
    CPY #$0020 : BMI .normal_load_loop
    RTS
}

print pc, " spacetime bank $90 end"
