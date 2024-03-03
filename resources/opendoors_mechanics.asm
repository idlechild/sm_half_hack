
!WRAM_ROOM_ID = $079B
!WRAM_ROOM_WIDTH_BLOCKS = $07A5

if defined("WRAM_DOORS_ONLY")
!WRAM_DOORS_ONLY_LONG = $7E0000+!WRAM_DOORS_ONLY
endif



org $82DE2F
hook_mask_door_orientation:
    AND #$00FB

org $82E387
hook_after_load_level_data:
    LDA #after_load_level_data

org $82E8D9
hook_load_level_exceute_room_setup_asm:
    JSR execute_room_asm_and_open_all_doors
    NOP

org $82EB8F
hook_exceute_room_setup_asm:
    JSR execute_room_asm_and_open_all_doors
    NOP



org $82FA00
print pc, " opendoors_mechanics bank $82 start"

open_all_doors_execute_plm_instruction:
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
    JSL open_all_doors_execute_plm_instruction

  .plmDelete
    STZ $1C37,X
    BRA .plmSearchResume

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

if defined("POST_OPEN_ALL_DOORS_ROUTINE")
    JSL !POST_OPEN_ALL_DOORS_ROUTINE
endif
    PLY : PLX : PLB : PLP : RTS

  .btsAmmoFound
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY_LONG : BNE .btsContinue
endif
    ; Convert BTS index to tile index
    ; Also verify this is a shootable block
    %a16() : TYA : ASL : TAX : %a8()
    LDA $0001,X : BIT #$30 : BNE .btsContinue

    ; Check if this is respawning
    LDA $6401,Y : BIT #$01 : BNE .btsConvertToShotBlock
    TDC : STA $6401,Y
    BRL .btsContinue

  .btsConvertToShotBlock
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY_LONG : BNE .btsContinue
endif
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

print pc, " opendoors_mechanics bank $82 end"



org $84C826
hook_plm_gate_entries:
    dw #plm_setup_downwards_open_gate, $BC13
    dw #plm_setup_downwards_closed_gate, $BC3A
    dw #plm_setup_upwards_open_gate, $BC61
    dw #plm_setup_upwards_closed_gate, $BC88
    dw #plm_setup_downwards_gate_shotblock, $BCAF
    dw #plm_setup_upwards_gate_shotblock, $BCDF

org $84CDF5
hook_plm_setup_speed_blocks:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDA $0A6E : CMP #$0003 : BEQ .no_collision
  .vanilla
    LDA $0A1C
    CMP #$00C9 : BCC .collision
    CMP #$00CF : BCS .collision
    BRA .no_collision
  .collision
    TDC : STA $1C37,Y
    SEC : RTS
warnpc $84CE1E

org $84CE1E
  .no_collision

org $84CE8E
hook_plm_setup_bomb_blocks:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDA $0A6E : CMP #$0003 : BEQ .no_collision
  .vanilla
    LDA $0A1C
    CMP #$0081 : BEQ .no_collision
    CMP #$0082 : BEQ .no_collision
    CMP #$00C9 : BCC .collision
    CMP #$00CF : BCS .collision
    BRA .no_collision
  .collision
    TDC : STA $1C37,Y
    SEC : RTS
warnpc $84CEC1

org $84CEC1
  .no_collision

org $84D028
hook_plm_shootable_speed_blocks:
    dw $CE1E, $C974
    dw $CE1E, $C9E4

org $84D044
hook_plm_crumble_shot_block_entries:
    dw #plm_setup_crumble_blocks, $C9F9
    dw #plm_setup_crumble_blocks, $CA1C
    dw #plm_setup_crumble_blocks, $CA41
    dw #plm_setup_crumble_blocks, $CA66
    dw #plm_setup_crumble_blocks, $CA8B
    dw #plm_setup_crumble_blocks, $CAA0
    dw #plm_setup_crumble_blocks, $CAB5
    dw #plm_setup_crumble_blocks, $CACA
    dw #plm_setup_respawn_shot_blocks, $CADF
    dw #plm_setup_respawn_shot_blocks, $CB02
    dw #plm_setup_respawn_shot_blocks, $CB27
    dw #plm_setup_respawn_shot_blocks, $CB4C
    dw #plm_setup_shot_blocks, $CBB7
    dw #plm_setup_shot_blocks, $CBCC
    dw #plm_setup_shot_blocks, $CBE1
    dw #plm_setup_shot_blocks, $CBF6
    dw #plm_setup_pb_blocks, $CB94
    dw #plm_setup_pb_blocks, $CC20
    dw #plm_setup_super_blocks, $CB71
    dw #plm_setup_super_blocks, $CC0B



org $84F400
print pc, " opendoors_mechanics bank $84 start"

plm_setup_downwards_open_gate:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BEQ plm_setup_delete
    JMP $C6D8
endif

plm_setup_downwards_closed_gate:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BEQ plm_setup_delete
    JMP $C6BE
endif

plm_setup_upwards_open_gate:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BEQ plm_setup_delete
    JMP $C6DC
endif

plm_setup_upwards_closed_gate:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BEQ plm_setup_delete
    JMP $C6CB
endif

plm_setup_downwards_gate_shotblock:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BEQ plm_setup_delete
    JMP $C6E0
endif

plm_setup_upwards_gate_shotblock:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BEQ plm_setup_delete
    JMP $C73A
endif

plm_setup_delete:
    LDA #$AAE3 : STA $1D27,Y
    RTS

plm_setup_crumble_blocks:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDA $0A6E : CMP #$0003 : BEQ .screw
  .vanilla
    JMP $CE37
  .screw
    LDX $1C87,Y : LDA $7F0002,X
    AND #$F000 : ORA #$00BC : STA $1E17,Y
    AND #$0FFF : STA $7F0002,X
    TYX : LDA #$0004 : STA $7EDE1C,X
    CLC : RTS

plm_setup_respawn_shot_blocks:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDX $1C87,Y : LDA $7F0002,X
    AND #$F000 : ORA #$0052 : STA $1E17,Y
    AND #$0FFF : STA $7F0002,X
    CLC : RTS
if defined("WRAM_DOORS_ONLY")
  .vanilla
    JMP $CE6B
endif

plm_setup_shot_blocks:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDX $1C87,Y : LDA $7F0002,X
    AND #$0FFF : STA $7F0002,X
    CLC : RTS
if defined("WRAM_DOORS_ONLY")
  .vanilla
    JMP $B3C1
endif

plm_setup_pb_blocks:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDX $1C87,Y : LDA $7F0002,X
    AND #$F000 : ORA #$0057 : STA $1E17,Y
    AND #$0FFF : STA $7F0002,X
    CLC : RTS
if defined("WRAM_DOORS_ONLY")
  .vanilla
    JMP $CF2E
endif

plm_setup_super_blocks:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDX $1C87,Y : LDA $7F0002,X
    AND #$F000 : ORA #$009F : STA $1E17,Y
    AND #$0FFF : STA $7F0002,X
    CLC : RTS
if defined("WRAM_DOORS_ONLY")
  .vanilla
    JMP $CF67
endif

print pc, " opendoors_mechanics bank $84 end"



org $90A373
hook_samus_movement_walljump:
    dw #samus_movement_walljump



org $90F900
print pc, " opendoors_mechanics bank $90 start"

samus_movement_walljump:
{
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDA $09A2 : BIT #$0008 : BEQ .not_screw
  .screw
    LDA #$0003 : STA $0A6E
    BRA .jumping_movement
if defined("WRAM_DOORS_ONLY")
  .vanilla
    LDA $0A96 : CMP #$0017 : BPL .screw
    CMP #$0003 : BMI .jumping_movement
endif
  .not_screw
    LDA $0CD0 : CMP #$003C : BMI .jumping_movement
    LDA #$0004 : STA $0A6E
  .jumping_movement
    JMP $8FB3
}

print pc, " opendoors_mechanics bank $90 end"
warnpc $90FA00



org $9494ED
samus_shotblock_horizontal_collision_pointer:
    dw #samus_shotblock_horizontal_collision

org $94950D
samus_shotblock_vertical_collision_pointer:
    dw #samus_shotblock_vertical_collision

org $94A17B
shot_special_air_horizontal_reaction_pointer:
    dw #shot_special_air_reaction

org $94A183
shot_bombable_air_horizontal_reaction_pointer:
    dw #shot_bombable_air_reaction

org $94A18B
shot_special_block_horizontal_reaction_pointer:
    dw #shot_special_block_reaction

org $94A193
shot_bombable_block_horizontal_reaction_pointer:
    dw #shot_bombable_block_reaction

org $94A19B
shot_special_air_vertical_reaction_pointer:
    dw #shot_special_air_reaction

org $94A1A3
shot_bombable_air_vertical_reaction_pointer:
    dw #shot_bombable_air_reaction

org $94A1AB
shot_special_block_vertical_reaction_pointer:
    dw #shot_special_block_reaction

org $94A1B3
shot_bombable_block_vertical_reaction_pointer:
    dw #shot_bombable_block_reaction



org $94B400
print pc, " opendoors_mechanics bank $94 start"

samus_shotblock_horizontal_collision:
{
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDA $0A6E : CMP #$0003 : BEQ .screw
    LDX $0DC4 : LDA $7F6402,X
    AND #$00FF : CMP #$0045 : BEQ .vanilla
    CMP #$0004 : BCC .respawn
  .fallback
    LDA #$D040 : BRA .plm
  .respawn
    LDA #$D038
  .plm
    JSL $8484E7 : BCC .done
  .vanilla
    JMP $8F49
  .done
    RTS
  .screw
    LDX $0DC4 : LDA $7F6402,X
    AND #$00FF : CMP #$0045 : BEQ .vanilla
    CMP #$000C : BCS .fallback
    JSR $9E73
    CLC : RTS
}

samus_shotblock_vertical_collision:
{
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDA $0A6E : CMP #$0003 : BEQ .screw
  .vanilla
    JMP $8F82
  .screw
    LDX $0DC4 : LDA $7F6402,X
    AND #$00FF : CMP #$000C : BCS .vanilla
    JSR $9E73
    CLC : RTS
}

shot_special_air_reaction:
{
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDX $0DC4 : LDA $7F6402,X : AND #$00FF
    CMP #$0008 : BCS .vanilla
    JMP $9E55
  .vanilla
    CLC : RTS
}

shot_bombable_air_reaction:
{
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDX $0DC4 : LDA $7F6402,X : AND #$00FF
    CMP #$0008 : BCS .vanilla
    JMP $9E55
  .vanilla
    JMP $9FD6
}

shot_special_block_reaction:
{
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDX $0DC4 : LDA $7F6402,X : AND #$00FF
    CMP #$0008 : BCC .crumble
    CMP #$000E : BEQ .speed_respawn
    CMP #$000F : BEQ .speed
    CMP #$0082 : BCC .vanilla
    LDA $079F : CMP #$0001 : BEQ .speed
  .vanilla
    SEC : RTS
  .crumble
    JMP $9E73
  .speed_respawn
    LDA #$D028 : JSL $8484E7
    REP #$40
    SEC : RTS
  .speed
    LDA #$D02C : JSL $8484E7
    REP #$40
    SEC : RTS
}

shot_bombable_block_reaction:
{
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BNE .vanilla
endif
    LDX $0DC4 : LDA $7F6402,X : AND #$00FF
    CMP #$0008 : BCS .vanilla
    JMP $9E73
  .vanilla
    JMP $9FF4
}

print pc, " opendoors_mechanics bank $94 end"
warnpc $94C800



org $A0D517
hook_vertical_timed_shutter_main_ai:
    dw #vertical_timed_shutter_main_ai

org $A0D557
hook_vertical_shootable_shutter_main_ai:
    dw #vertical_shootable_shutter_main_ai

org $A0D597
hook_horizontal_shootable_shutter_main_ai:
    dw #horizontal_shootable_shutter_main_ai

org $A0D5D7
hook_destructible_shutter_main_ai:
    dw #vertical_shootable_shutter_main_ai



org $A2F4C0
print pc, " opendoors_mechanics bank $A2 start"

vertical_timed_shutter_main_ai:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BEQ delete_main_ai
    JMP $EAB6
endif

vertical_shootable_shutter_main_ai:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BEQ delete_main_ai
    JMP $EED1
endif

horizontal_shootable_shutter_main_ai:
if defined("WRAM_DOORS_ONLY")
    LDA !WRAM_DOORS_ONLY : BEQ delete_main_ai
    JMP $F1DE
endif

delete_main_ai:
    LDA #$0200
    STA $0F86,X
    RTL

print pc, " opendoors_mechanics bank $A2 end"
warnpc $A2F500

