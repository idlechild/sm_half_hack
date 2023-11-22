
org $8B8697
hook_version_enable_display:
    NOP

org $8B86C4
hook_version_load_number_tile:
    LDA.w version_tile_table,Y

org $8B871D
hook_version_ending_first_number:
    LDA.w version_tile_table_letters,Y

org $8B8731
hook_version_ending_second_number:
    LDA.w version_tile_table_letters,Y

org $8BF754
version_data:
    db #$40, #($30+!VERSION_MAJOR), #$2E, #($30+!VERSION_MINOR)
    db #$40, #$40, #$40, #$40, #$40, #$40, #$40, #$00



org $8BF800
print pc, " version_display bank $8B start"

version_tile_table:
    ; $30-$39 = 0-9
    dw #$39F4, #$39F5, #$39F6, #$39F7, #$39F8, #$39F9, #$39FA, #$39FB, #$39FC, #$39FD
    ; $3A-$3F = A-F
    dw #$39D0, #$39D1, #$39D2, #$39D3, #$39D4, #$39D5
version_tile_table_letters:
    ; $40 = space
    dw #$0590
    ; $41-$5A = A-Z
    dw #$39D0, #$39D1, #$39D2, #$39D3, #$39D4, #$39D5, #$39D6, #$39D7, #$39D8, #$39D9, #$39DA, #$39DB, #$39DC
    dw #$39DD, #$39DE, #$39DF, #$39E0, #$39E1, #$39E2, #$39E3, #$39E4, #$39E5, #$39E6, #$39E7, #$39E8, #$39E9

print pc, " version_display bank $8B end"

