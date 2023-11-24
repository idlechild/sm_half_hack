lorom

!VERSION_MAJOR = 1
!VERSION_MINOR = 3

!WRAM_ROOM_ID_LONG = $7E079B
!WRAM_DOORS_ONLY = $09EA
!WRAM_SAMUS_POSE = $0A1C
!WRAM_SHINESPARK_DOOR_COUNTER = $0A70

incsrc ../resources/macros.asm

!POST_OPEN_ALL_DOORS_ROUTINE = post_open_all_doors
incsrc ../resources/opendoors_mechanics.asm

incsrc ../resources/crash.asm
incsrc ../resources/decompression.asm
;incsrc ../resources/EternalSpikeSuit.asm
incsrc ../resources/reduce_flashing.asm
;incsrc ../resources/startanywhere.asm
incsrc ../resources/vanilla_bugfix.asm
incsrc ../resources/version_display.asm

!SPACETIME_PRESERVE_INFOHUD = 1
!SPACETIME_PRESERVE_SPRITE_OBJECT_RAM = 1
incsrc ../resources/spacetime.asm

!EDITED_TILEMAP_TEXT = "DOORS_ONLY____ON______OFF_"
incsrc ../resources/SpecialSettingsMenu.asm

!SKIP_DOOR_VERIFICATION = 1
incsrc ../resources/TC_Verify.asm



org $808262
hook_load_all_demos:
    LDA #$0004

org $80AE9F
hook_door_transition_right:
    CLC : ADC !WRAM_SHINESPARK_DOOR_COUNTER
    STA $0911 : LDA $0917 : CLC : ADC #$0004
    CLC : ADC !WRAM_SHINESPARK_DOOR_COUNTER
    STA $0917 : JSL $80A3A0
    PLX : INX
    JMP finish_door_transition_right
warnpc $80AEC2

org $80AEE3
hook_door_transition_left:
    SEC : SBC !WRAM_SHINESPARK_DOOR_COUNTER
    STA $0911 : LDA $0917 : SEC : SBC #$0004
    SEC : SBC !WRAM_SHINESPARK_DOOR_COUNTER
    STA $0917 : JSL $80A3A0
    PLX : INX
    JMP finish_door_transition_left
warnpc $80AF02



org $80FD00
print pc, " opendoors bank $80 start"

DoorTransitionFrameCounterTable:
    dw #$0040, #$0033, #$002A, #$0024, #$0020, #$001C, #$0019, #$0017, #$0015, #$0013, #$0012, #$0011, #$0010, #$000F, #$000E

DoorTransitionRemainderTable:
    dw #$0000, #$0001, #$0004, #$0004, #$0000, #$0004, #$0006, #$0003, #$0004, #$0009, #$0004, #$0001, #$0000, #$0001, #$0004

finish_door_transition_right:
{
    STX $0925 : LDA !WRAM_SHINESPARK_DOOR_COUNTER : ASL
    TAX : LDA.l DoorTransitionFrameCounterTable,X
    CMP $0925 : BNE .continue
    LDA.l DoorTransitionRemainderTable,X : BEQ .done
    PHA : CLC : ADC $0911 : STA $0911
    PLA : CLC : ADC $0917 : STA $0917

  .done
    JSL $80A3A0
    SEC : RTS

  .continue
    CLC : RTS
}

finish_door_transition_left:
{
    STX $0925 : LDA !WRAM_SHINESPARK_DOOR_COUNTER : ASL
    TAX : LDA.l DoorTransitionFrameCounterTable,X
    CMP $0925 : BNE .continue
    LDA.l DoorTransitionRemainderTable,X : BEQ .done
    STA $C7 : LDA $0911 : SEC : SBC $C7 : STA $0911
    LDA $0917 : SEC : SBC $C7 : STA $0917
    JSL $80A3A0

  .done
    SEC : RTS

  .continue
    CLC : RTS
}

print pc, " opendoors bank $80 end"
warnpc $80FFC0



org $81B3A4
hook_new_game_init_data:
    ; Overwritten logic but more efficient
    STA $7ED8B0,X
    INX : INX
    CPX #$0040 : BMI $ED

    ; Set Zebes Awake
    INC : STA $7ED820

    ; Resume logic
    TDC : TAX
warnpc $81B3B6



org $828738
hook_demo_init_data:
    ; Overwritten logic but more efficient
    TDC : STA $7ED8B0,X
    INX : INX
    CPX #$0040 : BMI $E9

    ; Set Zebes Awake
    INC : STA $7ED820

    ; Resume logic
    TDC : TAX : NOP
warnpc $82874C

org $828794
hook_demo_missile_door_length:
    dw #$0149

org $8288CC
hook_demo_gauntlet_entrance_length:
    dw #$007C

org $82DE2F
hook_mask_door_orientation:
    AND #$00FB

org $82DE5A
hook_horizontal_door_speed:
    JSR calc_horizontal_door_speed

org $82E2DB
hook_door_transition_fade_out:
    JSR advance_gradual_color_change

org $82E41D
hook_decompress_CRE_tiles:
    LDA #$7E70
    JSL fast_decompress_if_fast_doors

org $82E42E
hook_decompress_tileset_tiles:
    LDA #$7E20
    JSL fast_decompress_if_fast_doors

org $82E752
hook_door_transition_fade_in:
    JSR advance_gradual_color_change

org $82E764
hook_after_room_transition:
    JMP after_room_transition

org $82EEDF
hook_skip_intro:
    LDA #$C100



org $82F800
print pc, " opendoors bank $82 start"

DoorTransitionSpeedTable:
    dw #$00C8, #$00FB, #$0131, #$0164, #$0190, #$01C9, #$0200, #$022D, #$0262, #$02A2, #$02C7, #$02F1, #$0320, #$0355, #$0392

calc_horizontal_door_speed:
{
    PHX : LDA !WRAM_SHINESPARK_DOOR_COUNTER : ASL
    TAX : LDA.l DoorTransitionSpeedTable,X : PLX
    RTS
}

fast_decompress_if_fast_doors:
{
    STZ $4C
    STA $4D
    ; decompress, but fast if fast doors, otherwise vanilla
    ; this is because the room state (e.g. rinkas in MBs room) can be affected
    ; by the timing of the decompression
    LDA !WRAM_SHINESPARK_DOOR_COUNTER : BEQ .vanilla
    JML optimized_decompression

  .vanilla
    JML $80B119
}

advance_gradual_color_change:
{
    LDA #$000C : SEC : SBC !WRAM_SHINESPARK_DOOR_COUNTER
    STA $7EC402
    JMP $DA02
}

after_room_transition:
{
    LDA !WRAM_SAMUS_POSE : CMP #$00C9 : BEQ .inc
    CMP #$00CA : BEQ .inc
    STZ !WRAM_SHINESPARK_DOOR_COUNTER

  .done
    ; Overwritten logic
    LDA #$0008 : STA $0998
    RTS

  .inc
    INC !WRAM_SHINESPARK_DOOR_COUNTER
    BRA .done
}

print pc, " opendoors bank $82 end"



org $83AA96
hook_mb_to_tourian_escape_1_door_asm:
    dw $C91F

org $83ABB6
hook_enter_ceres_ridley_door_asm:
    dw #enter_ceres_ridley_door_asm

org $83ABC2
hook_exit_ceres_ridley_door_asm:
    dw #exit_ceres_ridley_door_asm



org $8B86B1
hook_version_load_character:
    JSR version_load_character



org $8BF900
print pc, " opendoors bank $8B start"

version_data_ess:
    db #$40, #($30+!VERSION_MAJOR), #$2E, #($30+!VERSION_MINOR)
    db #$40, #$45, #$53, #$53, #$40, #$40, #$40, #$00

version_load_character:
{
    LDA.l $90D3E4 : CMP #$0002 : BCS .original
    LDA.w version_data_ess,Y
    RTS

  .original
    LDA.w version_data,Y
    RTS
}

print pc, " opendoors bank $8B end"



org $8F9EE3
hook_morphball_room_asm:
    dw #morphball_room_asm

org $8FDE5E
hook_tourian_escape_1_room_music:
    db $00, $00

org $8FDE72
hook_tourian_escape_1_room_asm:
    dw $C91E

org $8F9767
hook_pit_room_header_state_check:
    dw #room_state_check_pass

org $8F97C0
hook_morph_elevator_header_state_check:
    dw #room_state_check_pass



org $8FF400
print pc, " opendoors bank $8F start"

morphball_room_asm:
{
    ; Add back morph ball item
    PHX : PHP : %ai16()
    LDX #$86DE : JSL $84846A
    PLP : PLX : RTS
}

enter_ceres_ridley_door_asm:
{
    ; Set Layer 1 offsets
    PHP : %a16()
    LDA #$0800 : STA $091D
    LDA #$0300 : STA $091F
    STZ $B1 : STZ $B3
    BRA ceres_ridley_door_asm
}

exit_ceres_ridley_door_asm:
{
    ; Clear Ceres escape cutscene flag
    PHP : %a16()
    LDA $093F : AND #$FFFE : STA $093F
}

ceres_ridley_door_asm:
{
    ; Initialize mode 7
    LDA #$0009 : STA $07EB
    STZ $78 : STZ $7A
    STZ $7C : STZ $7E
    STZ $80 : STZ $82
    %a8() : STZ $5F
    LDA #$09 : STA $56
    PLP : RTS
}

room_state_check_pass:
{
    LDA $0000,X
    TAX
    JMP $E5E6
}

post_open_all_doors:
{
    %a16() : LDA !WRAM_ROOM_ID_LONG
    CMP #$CD13 : BEQ .phantoon
    CMP #$DDC4 : BEQ .tourianEyeDoor
    RTL

  .phantoon
    LDA #$0482 : STA $00C4
    LDA #$04A2 : STA $00E4
    LDA #$0CA2 : STA $0104
    LDA #$0C82 : STA $0124
    RTL

  .tourianEyeDoor
    LDA #$0082 : STA $037E
    LDA #$00A2 : STA $03FE
    LDA #$08A2 : STA $047E
    LDA #$0882 : STA $04FE
    RTL
}

print pc, " opendoors bank $8F end"



org $90D400
hook_set_shinespark_finish_handler:
    LDA #shinespark_finish_handler



org $90F900
print pc, " opendoors bank $90 start"

shinespark_finish_handler:
{
    STZ !WRAM_SHINESPARK_DOOR_COUNTER
    JMP $D40D
}

print pc, " opendoors bank $90 end"



org $918DFC
hook_demo_speed_booster_one_tap_length:
    dw #$0012

org $918E08
hook_demo_speed_booster_dash_length:
    dw #$00DE



org $A1E89E
hook_ceres_elevator_intro_enemies:
    dw #$037F

org $A1E8B1
hook_falling_tile_intro_enemies:
    dw #$017F, #$0000, #$A800, #$0000, #$0000, #$0000, #$E23F, #$01E0, #$017F

org $A1E8D4
hook_magnet_stairs_intro_enemies:
    dw #$027F, #$0000, #$A800, #$0000, #$0000, #$0000, #$E23F, #$00E0, #$027F

org $A1E8F7
hook_dead_scientists_intro_enemies:
    dw #$017F, #$0000, #$A800, #$0000, #$0000, #$0000, #$E23F, #$01E0, #$017F

org $A1E91A
hook_58_escape_intro_enemies:
    dw #$017F, #$0000, #$A800, #$0000, #$0000, #$0000, #$E23F, #$01E0, #$017F

org $A1E94D
hook_ceres_ridley_intro_enemies:
    dw #$017F, #$0003, #$A800, #$0000, #$0003

org $A1EAE3
hook_falling_tile_escape_enemies:
    dw #$017F, #$0000, #$A800, #$0000, #$0000, #$0000, #$E23F, #$01E0, #$017F

org $A1EB06
hook_magnet_stairs_escape_enemies:
    dw #$027F, #$0000, #$A800, #$0000, #$0000, #$0000, #$E23F, #$00E0, #$027F

org $A1EB79
hook_dead_scientists_escape_enemies:
    dw #$017F, #$0000, #$A800, #$0000, #$0000, #$0000, #$E23F, #$01E0, #$017F

org $A1EB9C
hook_58_escape_escape_enemies:
    dw #$017F, #$0000, #$A800, #$0000, #$0000, #$0000, #$E23F, #$01E0, #$017F

org $A1EBBF
hook_ceres_ridley_escape_enemies:
    dw #$017F



org $A6F53C
ceres_ridley_intro_door_instructions:
    dw $0001, $F921, $0001, $FAA7, $80ED, $F55E

