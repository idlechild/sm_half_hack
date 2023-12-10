
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
    TYA : CLC : ADC #($7EC608-$7EC1E2) : CMP #$0000 : BPL .normal_load_palette

    ; We will reach infohud, so run our own loop
    INX : INX
  .loop_before_infohud
    LDA [$00],Y
    STA $7EC1C0,X
    INX : INX : INY : INY
    CPX #($7EC608-$7EC1C0) : BMI .loop_before_infohud

if !SPACETIME_PRESERVE_INFOHUD
    ; Skip over infohud
    ; Instead of load and store, load and load
  .loop_skip_infohud
    LDA $7EC1C0,X
    LDA [$00],Y
    INX : INX : INY : INY
    CPX #($7EC6C8-$7EC1C0) : BMI .loop_skip_infohud

    ; Check if we finished spacetime while skipping over infohud
    CPY #$0020 : BMI .check_sprite_object_ram
    RTS
else
    ; Check if Y will cause us to reach sprite object ram
    TYA : CLC : ADC #($7EEF78-$7EC628) : CMP #$0000 : BMI .loop_before_sprite_object_ram
endif

  .normal_load_loop
    LDA [$00],Y
    STA $7EC1C0,X
    INY : INY
  .normal_load_palette
    INX : INX
    CPY #$0020 : BMI .normal_load_loop
    RTS

if !SPACETIME_PRESERVE_INFOHUD
  .check_sprite_object_ram
    ; Check if Y will cause us to reach sprite object ram
    TYA : CLC : ADC #($7EEF78-$7EC6E8) : CMP #$0000 : BPL .normal_load_loop
endif

    ; We will reach sprite object ram, so run our own loop
  .loop_before_sprite_object_ram
    LDA [$00],Y
    STA $7EC1C0,X
    INX : INX : INY : INY
    CPX #($7EEF78-$7EC1C0) : BMI .loop_before_sprite_object_ram

if !SPACETIME_PRESERVE_SPRITE_OBJECT_RAM
    ; Check if we are copying from unmapped memory ($004500-$007FFF range)
    ; If not then overwrite sprite object ram
    TYA : ADC $00 : CMP #$4500 : BCC .overwrite_sprite_object_ram
    CMP #$7C01 : BCS .overwrite_sprite_object_ram

    ; Skip over sprite object ram
    ; Instead of load and store, load and load
  .loop_skip_sprite_object_ram
    LDA $7EC1C0,X
    LDA [$00],Y
    INX : INX : INY : INY
    CPX #($7EF378-$7EC1C0) : BMI .loop_skip_sprite_object_ram

  .overwrite_sprite_object_ram
endif
    ; Check if we finished spacetime while reaching or skipping over sprite object ram
    CPY #$0020 : BMI .normal_load_loop
    RTS
}

print pc, " spacetime bank $90 end"

