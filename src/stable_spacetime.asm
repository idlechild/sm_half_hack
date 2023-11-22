lorom

!SPACETIME_PRESERVE_INFOHUD = 0
!SPACETIME_PRESERVE_SPRITE_OBJECT_RAM = 1
incsrc ../resources/spacetime.asm

org $81B40A
hook_samus_data_text:
    ;      S      P      A      C      E      _      T      I      M      E
    dw $202B, $200D, $200A, $200C, $200E, $200F, $202C, $2022, $2026, $200E, $FFFE
    dw $203B, $2038, $201A, $201C, $201E, $200F, $2011, $2011, $2036, $201E, $FFFF

