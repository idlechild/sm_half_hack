;
; Patches to support starting at any given location in the game
; by injecting a save station at X/Y coordinates in the specified room.
;
; Requires adding a new save station with ID: 7 for the correct region in the save station table as well.
;

!START_ROOM_ID = $B6C1
!START_ROOM_REGION = $0002
!START_ROOM_DOOR = $988E
!START_ROOM_SCREEN_X = $0000
!START_ROOM_SCREEN_Y = $0200
!START_ROOM_SAMUS_Y = $0160
!START_ROOM_SAMUS_X_OFFSET = $0000
!START_ROOM_MAP_X = $00A0
!START_ROOM_MAP_Y = $0088
!START_ROOM_TILE_XY = $2B07

!START_SAVESTATION_ID = $0007



org $809AF3
hook_init_minimap:
    JSL init_minimap_and_gt_code

org $80C527
crateria_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80C631
brinstar_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80C73B
norfair_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80C87D
wrecked_ship_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80C979
maridia_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80CA91
tourian_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80CB8D
ceres_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET

org $80CC7B
debug_start_load_station:
    dw !START_ROOM_ID
    dw !START_ROOM_DOOR
    dw $0000
    dw !START_ROOM_SCREEN_X
    dw !START_ROOM_SCREEN_Y
    dw !START_ROOM_SAMUS_Y
    dw !START_ROOM_SAMUS_X_OFFSET



org $82804E
hook_start_anywhere:
    JSR start_anywhere

org $82C86F
crateria_map_icon_save_point_start:
    dw !START_ROOM_MAP_X
    dw !START_ROOM_MAP_Y

org $82C8D9
brinstar_map_icon_save_point_start:
    dw !START_ROOM_MAP_X
    dw !START_ROOM_MAP_Y

org $82C93F
norfair_map_icon_save_point_start:
    dw !START_ROOM_MAP_X
    dw !START_ROOM_MAP_Y

org $82C9AD
wrecked_ship_map_icon_save_point_start:
    dw !START_ROOM_MAP_X
    dw !START_ROOM_MAP_Y

org $82CA0F
maridia_map_icon_save_point_start:
    dw !START_ROOM_MAP_X
    dw !START_ROOM_MAP_Y

org $82CA6D
tourian_map_icon_save_point_start:
    dw !START_ROOM_MAP_X
    dw !START_ROOM_MAP_Y



org $82FD00
print pc, " startanywhere bank $82 start"

start_anywhere:
{
    LDA #!START_ROOM_ID : BEQ .done
    LDA $7E0998 : CMP #$001F : BNE .done

    LDA #!START_ROOM_REGION : STA $079F
    lda #!START_SAVESTATION_ID : STA $078B

  .done
    JMP $819B
}

init_minimap_and_gt_code:
{
    JSL $AAC91E
    JML $90A8EF
}

print pc, " startanywhere bank $82 end"



org $AAC91E
gt_code_starting_health:
    LDA #$05DB    ; starting health

org $AAC927
gt_code_starting_reserves:
    LDA #$0190    ; starting reserves

org $AAC930
gt_code_starting_missiles:
    LDA #$00E6    ; starting missiles

org $AAC939
gt_code_starting_supers_and_pbs:
    LDA #$0032    ; starting supers/pbs

org $AAC942
;hook_gt_code_init_equipment:
    ; To avoid glitched beam we need to turn off spazer
    ; Combine Supers and PBs assignments to make room for the OR instruction
;    STA $09CE
;    STA $09D0
;    LDA #$F32F    ; starting equipment
;    STA $09A2
;    STA $09A4
;    LDA #$100B    ; starting beams
;    STA $09A6
;    ORA #$0004    ; collect spazer
warnpc $AAC95A

