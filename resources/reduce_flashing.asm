
; Non-flashing palette instruction
; Overwriting unused C19A-C2E8 space
org $8DC19A
crateria_1_palette_fx_preinstruction:
{
    ; Start with copy of original preinstruction at $8DEC59
    LDA $0AFA : CMP #$0380 : BCS .end
    LDA #$0001 : STA $1ECD,X
    LDA #crateria_1_palette_loop : STA $1EBD,X
  .end
    RTS
}

crateria_1_set_fx_preinstruction:
{
    LDA #crateria_1_palette_fx_preinstruction : STA $1EAD,X
    RTS
}

crateria_1_palette:
    dw #crateria_1_set_fx_preinstruction
    dw $C655, $00A8
crateria_1_palette_loop:
    dw $00F0, $2D6C, $294B, $252A, $2109, $1CE8, $18C7, $14A6, $1085, $C595
    dw $C61E, #crateria_1_palette_loop

escape_flashing_palette_color_index:
{
    ; Start with copy of original logic at $8DC655
    LDA $0000,Y : STA $1E8D,X
    INY : INY : INY : INY
    RTS
}

tourian_10_palette:
    dw #escape_flashing_palette_color_index
    dw $0070, $F895
tourian_10_palette_loop:
    dw $0004, $1471, $104C, $0848, $0422, $C595
    dw $C61E, #tourian_10_palette_loop

tourian_20_palette:
    dw #escape_flashing_palette_color_index
    dw $00A8, $F94D
tourian_20_palette_loop:
    dw $0002, $4636, $2D70, $18C9, $0844, $080D, $0809, $C5AB, $6B5F, $C595
    dw $C61E, #tourian_20_palette_loop

tourian_40_palette:
    dw #escape_flashing_palette_color_index
    dw $00E8, $F94D
tourian_40_palette_loop:
    dw $0002, $4636, $2D70, $18C9, $0844, $080D, $0809, $C5AB, $6B5F, $C595
    dw $C61E, #tourian_40_palette_loop

crateria_8_palette:
    dw #escape_flashing_palette_color_index
    dw $00A2, $FA6D
crateria_8_palette_loop:
    dw $0003, $4E14, $396E, $24C8, $C5AB, $0014, $000E, $4900, $1C60, $C599, $6F3C, $C595
    dw $C61E, #crateria_8_palette_loop

crateria_10_palette:
    dw #escape_flashing_palette_color_index
    dw $00D2, $FBC5
crateria_10_palette_loop:
    dw $0010, $35AD, $1CE7, $0C63, $C595
    dw $C61E, #crateria_10_palette_loop

crateria_20_palette:
    dw #escape_flashing_palette_color_index
    dw $00A8, $FC63
crateria_20_palette_loop:
    dw $00AA, $28C8, $2484, $1C61, $C595
    dw $C61E, #crateria_20_palette_loop

crateria_2_palette:
    dw #escape_flashing_palette_color_index
    dw $0082, $FD01
crateria_2_palette_loop:
    dw $0008, $1DAB, $1149, $10C5, $2D0F, $2D0B, $28C7, $0845, $C595
    dw $C61E, #crateria_2_palette_loop

crateria_4_palette:
    dw #escape_flashing_palette_color_index
    dw $00A2, $FE05
crateria_4_palette_loop:
    dw $0031, $48D5, $38B0, $286A, $2488, $2067, $1846, $1425, $1024, $0C23, $0C03, $0802, $C595
    dw $C61E, #crateria_4_palette_loop

warnpc $8DC2E9



org $8DF767
hook_crateria_1_palette_fx_object:
    dw #crateria_1_palette

org $8DFFCF
hook_tourian_crateria_palette_fx_objects:
    dw #tourian_10_palette
    dw $C685, #tourian_20_palette
    dw $C685, #tourian_40_palette
    dw $C685, #crateria_8_palette
    dw $C685, #crateria_10_palette
    dw $C685, #crateria_20_palette
    dw $C685, #crateria_2_palette
    dw $C685, #crateria_4_palette



org $A9CFFD
hook_cutscenes_mb_begin_screen_flashing:
    LDA #$0000

