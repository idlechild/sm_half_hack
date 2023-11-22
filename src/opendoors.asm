lorom

!VERSION_MAJOR = 1
!VERSION_MINOR = 1

!WRAM_ROOM_ID = $079B
!WRAM_ROOM_WIDTH_BLOCKS = $07A5
!WRAM_DOORS_ONLY = $09EA
!WRAM_SAMUS_POSE = $0A1C
!WRAM_SHINESPARK_DOOR_COUNTER = $0A70

!WRAM_ROOM_ID_LONG = $7E0000+!WRAM_ROOM_ID
!WRAM_DOORS_ONLY_LONG = $7E0000+!WRAM_DOORS_ONLY

incsrc ../resources/macros.asm
incsrc ../resources/crash.asm
incsrc ../resources/decompression.asm
;incsrc ../resources/EternalSpikeSuit.asm
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

org $82E387
hook_after_load_level_data:
    LDA #after_load_level_data

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

org $82E8D9
hook_load_level_exceute_room_setup_asm:
    JSR execute_room_asm_and_open_all_doors
    NOP

org $82EB8F
hook_exceute_room_setup_asm:
    JSR execute_room_asm_and_open_all_doors
    NOP

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

execute_plm_instruction:
{
    ; A = Bank 84 PLM instruction to execute
    ; $C3 already set to $84
    STA $C1
    ; PLM instruction ends with an RTS, but we need an RTL
    ; Have the RTS return to $848031 which is an RTL
    PEA $8030
    JML [$00C1]
}

after_load_level_data:
{
    JSR open_all_doors
    JMP $E38E
}

execute_room_asm_and_open_all_doors:
    ; Overwritten logic
    JSL $8FE88F

open_all_doors:
{
    PHP : PHB : PHX : PHY
    LDA #$8484 : STA $C3 : PHA : PLB : PLB

    ; First resolve all door PLMs
    LDX #$004E
  .plmSearchLoop
    LDA $1C37,X : BEQ .plmSearchDone
    LDY $1D27,X : LDA $0000,Y : CMP #$8A72 : BEQ .plmDoorFound
  .plmSearchResume
    DEX : DEX : BRA .plmSearchLoop

  .plmDoorFound
    ; Execute the next PLM instruction to set the BTS as a blue door
    LDA $0002,Y : TAY
    LDA $0000,Y : CMP #$86BC : BEQ .plmDelete
    INY : INY
    JSL execute_plm_instruction

  .plmDelete
    STZ $1C37,X
    BRA .plmSearchResume

  .phantoon
    LDA #$2482 : STA $00C4
    LDA #$24A2 : STA $00E4
    LDA #$2CA2 : STA $0104
    LDA #$2C82 : STA $0124
    BRA .done

  .plmSearchDone
    ; Now search all of the room BTS for doors
    LDA !WRAM_ROOM_WIDTH_BLOCKS : STA $C1 : ASL : STA $C3
    LDA $7F0000 : LSR : TAY
    STZ $C5 : TDC : %a8() : LDA #$7F : PHA : PLB

  .btsSearchLoop
    LDA $6401,Y : AND #$FC
    CMP #$08 : BEQ .btsAmmoFound
    CMP #$0C : BEQ .btsConvertToShotBlock
    CMP #$40 : BEQ .btsDoorFound
  .btsContinue
    DEY : BNE .btsSearchLoop

    ; All doors opened except Phantoon door
    %a16() : LDA !WRAM_ROOM_ID_LONG : CMP #$CD13 : BEQ .phantoon
  .done
    PLY : PLX : PLB : PLP : RTS

  .btsAmmoFound
    LDA !WRAM_DOORS_ONLY_LONG : BNE .btsContinue

    ; Convert BTS index to tile index
    ; Also verify this is a shootable block
    %a16() : TYA : ASL : TAX : %a8()
    LDA $0001,X : BIT #$30 : BNE .btsContinue

    ; Check if this is respawning
    LDA $6401,Y : BIT #$01 : BNE .btsConvertToShotBlock
    TDC : STA $6401,Y
    BRL .btsContinue

  .btsConvertToShotBlock
    LDA !WRAM_DOORS_ONLY_LONG : BNE .btsContinue

    ; Convert BTS index to tile index
    ; Also verify this is a shootable block
    %a16() : TYA : ASL : TAX : %a8()
    LDA $0001,X : BIT #$30 : BNE .btsContinue

    LDA #$04 : STA $6401,Y
    BRL .btsContinue

  .btsDoorFound
    ; Convert BTS index to tile index
    ; Also verify this is a door and not a slope or half-tile
    %a16() : TYA : ASL : TAX : %a8()
    LDA $0001,X : BIT #$30 : BNE .btsContinue

    ; Check what type of door we need to open
    LDA $6401,Y : BIT #$02 : BNE .btsCheckUpDown
    BIT #$01 : BEQ .btsFacingLeftRight
    LDA #$04 : STA $C6

  .btsFacingLeftRight
    %a16() : LDA #$0082 : ORA $C5 : STA $0000,X
    TXA : CLC : ADC $C3 : TAX : LDA #$00A2 : ORA $C5 : STA $0000,X
    TXA : CLC : ADC $C3 : TAX : LDA #$08A2 : ORA $C5 : STA $0000,X
    TXA : CLC : ADC $C3 : TAX : LDA #$0882 : ORA $C5 : STA $0000,X
    TDC : %a8() : STA $C6 : STA $6401,Y
    %a16() : TYA : CLC : ADC $C1 : TAX : TDC : %a8() : STA $6401,X
    %a16() : TXA : CLC : ADC $C1 : TAX : TDC : %a8() : STA $6401,X
    %a16() : TXA : CLC : ADC $C1 : TAX : TDC : %a8() : STA $6401,X
    BRL .btsContinue

  .btsCheckUpDown
    BIT #$01 : BEQ .btsFacingUpDown
    LDA #$08 : STA $C6

  .btsFacingUpDown
    %a16() : LDA #$0084 : ORA $C5 : STA $0006,X
    DEC : STA $0004,X : ORA #$0400 : STA $0002,X : INC : STA $0000,X
    TDC : %a8() : STA $C6 : STA $6401,Y
    STA $6402,Y : STA $6403,Y : STA $6404,Y
    BRL .btsContinue
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



;org $84CE9B
;plm_setup_bomb_block:
;    LDA !WRAM_DOORS_ONLY : BEQ $21
;    CMP #$00C9 : BCC $05
;    CMP #$00CF : BCC $17
;    TDC : STA $1C37,Y
;    SEC : RTS
;warnpc $84CEC1



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

org $8FDFA7
hook_falling_tile_intro_enemy_pointer:
    dw $E8CD

org $8FDFF1
hook_magnet_stairs_intro_enemy_pointer:
    dw $E8F0

org $8FE03B
hook_dead_scientists_intro_enemy_pointer:
    dw $E913

org $8FE085
hook_58_escape_intro_enemy_pointer:
    dw $E936

org $8FE652
hook_room_state_check_morph_and_missiles:
    LDA $0000,X
    TAX
    JMP $E5E6



org $8FEA00
print pc, " opendoors bank $8F start"

morphball_room_asm:
{
    ; Add back morph ball item
    PHX : PHP : %ai16()
    LDX #$86DE : JSL $84846A
    PLP : PLX : RTS
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



org $9494ED
samus_shotblock_horizontal_collision_pointer:
    dw #samus_shotblock_horizontal_collision

org $94A183
shot_bombable_air_horizontal_reaction_pointer:
    dw #shot_bombable_air_reaction

org $94A193
shot_bombable_block_horizontal_reaction_pointer:
    dw #shot_bombable_block_reaction

org $94A1A3
shot_bombable_air_vertical_reaction_pointer:
    dw #shot_bombable_air_reaction

org $94A1B3
shot_bombable_block_vertical_reaction_pointer:
    dw #shot_bombable_block_reaction



org $94B200
print pc, " opendoors bank $94 start"

samus_shotblock_horizontal_collision:
{
    LDA !WRAM_DOORS_ONLY : BNE .done
    LDX $0DC4 : LDA $7F6402,X
    AND #$00FF : CMP #$0004 : BCC .respawn
    LDA #$D040 : BRA .plm
  .respawn
    LDA #$D038
  .plm
    JSL $8484E7 : BCC .done
    JMP $8F49
  .done
    RTS
}

shot_bombable_air_reaction:
{
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
    JMP $9E55
  .vanilla
    JMP $9FD6
}

shot_bombable_block_reaction:
{
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
    LDX $0DC4 : LDA $7F6402,X : AND #$00FF
    CMP #$0008 : BCS .vanilla
    JMP $9E73
  .vanilla
    JMP $9FF4
}

print pc, " opendoors bank $94 end"
warnpc $94C800



org $A1E89A
hook_ceres_elevator_intro_enemies:
    db #$FF, #$FF, #$00

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



org $A6F542
ceres_ridley_intro_door_instructions:
    dw $F6B3, $80ED, $F55E



org $A7D4E5
hook_draw_phantoon_door:
    BRA $06

org $A7DB89
hook_restore_phantoon_door:
    BRA $06

