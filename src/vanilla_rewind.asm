lorom

!VERSION_MAJOR = 1
!VERSION_MINOR = 0

!SRAM_VERSION = #$3232

!DP_ToggleValue                     = $39
!DP_Palette                         = $3E
!DP_Temp                            = $40
!DP_Maximum                         = $42
!DP_MenuIndices                     = $9B
!DP_CurrentMenu                     = $9F
!DP_Address                         = $C1
!DP_JSLTarget                       = $C5
!DP_CtrlShadow                      = $C9
!DP_CtrlSram                        = $CC

!ram_cm_stack_index                 = $0332

!ram_shadow_ctrl_menu               = $0362
!ram_shadow_ctrl_load_state         = $0364
!ram_shadow_ctrl_auto_save_state    = $0366
!ram_shadow_ctrl_toggle_spin_lock   = $0368
!ram_IGT_completed_text             = $036A
!ram_IGT_clear_time_text            = $036C

!ram_ceres_intro                    = $1886
!ram_spin_lock                      = $1888
!ram_auto_save_state                = $188A
!ram_igt_reload_count_thousands     = $1892
!ram_igt_reload_count_hundreds      = $1894
!ram_igt_reload_count_tens          = $1896
!ram_igt_reload_count_ones          = $1898

!sram_initialized                   = $702000
!sram_ctrl_menu                     = $702002
!sram_ctrl_load_state               = $702004
!sram_ctrl_auto_save_state          = $702006
!sram_ctrl_toggle_spin_lock         = $702008

!sram_reload_count_in_savestate     = $71387E

!SRAM_DMA_BANK                      = $737000
!SRAM_SAVED_SP                      = $737F00
!SRAM_SAVED_STATE                   = $737F02
!SRAM_MUSIC_DATA                    = $737F80
!SRAM_MUSIC_TRACK                   = $737F82
!SRAM_SOUND_TIMER                   = $737F84

!ram_spin_lock_ever_used            = $7ED87C
!ram_reload_count                   = $7ED87E

!ram_tilemap_buffer                 = $7EF500

!ram_cm_menu_stack                  = $7EFE00
!ram_cm_cursor_stack                = $7EFE10
!ram_cm_cursor_max                  = $7EFE20
!ram_cm_horizontal_cursor           = $7EFE22
!ram_cm_input_timer                 = $7EFE24
!ram_cm_controller                  = $7EFE26
!ram_cm_menu_bank                   = $7EFE28
!ram_cm_leave                       = $7EFE2A
!ram_cm_input_frame_counter         = $7EFE2C
!ram_cm_ctrl_mode                   = $7EFE30
!ram_cm_ctrl_timer                  = $7EFE32
!ram_cm_ctrl_last_input             = $7EFE34
!ram_cm_ctrl_assign                 = $7EFE36
!ram_cm_keyboard_buffer             = $7EFEB0
!ram_cgram_cache                    = $7EFED0

incsrc ../resources/macros.asm
incsrc ../resources/IGT_text.asm
incsrc ../resources/spin_lock.asm
incsrc ../resources/tinystates.asm
incsrc ../resources/version_display.asm

!MENU_BLOCK_FULLSCREEN = 1
incsrc ../resources/menu_base.asm



; Patch out copy protection
org $808000
hook_copy_protection:
    db $FF

; hijack, runs as game is starting, JSR to RAM initialization to avoid bad values
org $808455
    JML init_code

; hijack when clearing bank 7E
org $808490
clear_bank_7E:
{
    LDX #$3FFE
  .clear_bank_loop
    STZ $0000,X
    STZ $4000,X
    STZ $8000,X
    STZ $C000,X
    DEX : DEX
    BPL .clear_bank_loop
    JSL init_wram_based_on_sram
    BRA .end_clear_bank
warnpc $8084AF

org $8084AF
  .end_clear_bank
}



org $80FC00
print pc, " vanilla_rewind bank $80 start"

transfer_cgram_long:
{
    PHP
    %a16() : %i8()
    LDX #$80 : STX $2100 ; forced blanking
    JSR $933A
    LDX #$0F : STX $2100
    PLP
    RTL
}

print pc, " vanilla_rewind bank $80 end"
warnpc $80FFC0



; Set SRAM size
org $80FFD8
hook_sram_size:
    db $07 ; 128kb



org $82894B
    ; gamemode_shortcuts will either CLC or SEC
    ; to control if normal gameplay will happen on this frame
    JSL gamemode_start : BCC resume_gameplay
    BRA end_of_normal_gameplay
resume_gameplay:

org $82896E
end_of_normal_gameplay:

org $828B18
hook_door_transition_load_sprites:
    JML gamemode_door_transtion_load_sprites

org $82E4A2
    LDA #hook_door_transition_load_sprites

org $82EEDF
    LDA #cutscenes_load_intro



org $82FC00
print pc, " vanilla_rewind bank $82 start"

print pc, " vanilla_rewind bank $82 end"
warnpc $82FE00



org $83B400
print pc, " vanilla_rewind bank $83 start"

init_code:
{
    REP #$30
    PHA

    ; Check if we should initialize SRAM
    LDA !sram_initialized : CMP !SRAM_VERSION : BEQ .sram_initialized
    JSL init_sram

  .sram_initialized
    PLA
    ; Execute overwritten logic and return
    JSL $8B9146
    JML $808459
}

init_sram:
{
    LDA #$3000 : STA !sram_ctrl_menu                  ; Start + Select
    LDA #$6020 : STA !sram_ctrl_load_state            ; Select + Y + L
    LDA #$6010 : STA !sram_ctrl_auto_save_state       ; Select + Y + R
    LDA #$0000 : STA !sram_ctrl_toggle_spin_lock
    LDA !SRAM_VERSION : STA !sram_initialized
    RTL
}

init_wram_before_menu:
init_wram_after_menu:
{
    PHP
    %a16()
    LDA !ram_spin_lock : BEQ .done_spin_lock
    STA !ram_spin_lock_ever_used

  .done_spin_lock
    PLP
    ; Fallthrough to init shadow ram
}

init_wram_based_on_sram:
{
    LDA !sram_ctrl_menu : STA !ram_shadow_ctrl_menu
    LDA !sram_ctrl_load_state : STA !ram_shadow_ctrl_load_state
    LDA !sram_ctrl_auto_save_state : STA !ram_shadow_ctrl_auto_save_state
    LDA !sram_ctrl_toggle_spin_lock : STA !ram_shadow_ctrl_toggle_spin_lock
    RTL
}

stop_all_sounds:
{
    ; If sounds are not enabled, the game won't clear the sounds
    LDA $05F5 : PHA
    STZ $05F5
    JSL $82BE17
    PLA : STA $05F5

    ; Makes the game check Samus' health again, to see if we need annoying sound
    STZ $0A6A
    RTL
}

gamemode_start:
{
    PHB
    PHK : PLB

    JSR gamemode_shortcuts
  .return
    %ai16()
    PHP
    BCS .skip_gameplay

    ; Overwritten logic
    JSL $8884B9
    JSL $808111
    PLP
    PLB
    RTL

  .skip_gameplay
    ; If we are skipping gameplay this frame and not loading a preset,
    ; it's not fair to still increment timers at the end of the frame,
    ; so decrement timers here to compensate
    DEC $05B5
    PLP
    PLB
    RTL
}

; If the current shortcut (register A) contains start,
; and the current game mode is $C (fading out to pause), set it to $8 (normal),
; so that shortcuts involving the start button don't trigger accidental pauses.
; Called after handling most controller shortcuts, except save/load state
; (because the user might want to practice gravity jumps or something)
; and load preset (because presets reset the game mode anyway).
skip_pause:
{
    PHP ; preserve carry
    BIT #$1000 : BEQ .done
    LDA $0998 : CMP #$000C : BNE .done
    LDA #$0008 : STA $0998
    STZ $0723   ; Screen fade delay = 0
    STZ $0725   ; Screen fade counter = 0
    LDA $51 : ORA #$000F
    STA $51   ; Brightness = $F (max)
  .done
    PLP
    RTS
}

gamemode_door_transtion_load_sprites:
{
    ; Check for auto-save mid-transition
    LDA !ram_auto_save_state : BEQ .done : BMI .auto_save
    TDC : STA !ram_auto_save_state
  .auto_save
    PHP : PHB
    PHK : PLB
    JSL save_state
    PLB : PLP
  .done
    JML $82E4A9
}

gamemode_shortcuts:
{
    LDA $8F : BNE .check_shortcuts
    CLC : RTS

  .check_shortcuts
    LDA $8B : CMP !ram_shadow_ctrl_load_state : BNE .skip_load_state
    AND $8F : BEQ .skip_load_state
    BRA .load_state
  .skip_load_state

    ; Skip other shortcuts if in a door transition
    LDA $0998 : CMP #$0009 : BMI .check_other_shortcuts
    CMP #$000C : BMI .skip_toggle_spin_lock

  .check_other_shortcuts
    LDA $8B : CMP !ram_shadow_ctrl_menu : BNE .skip_menu
    AND $8F : BEQ .skip_menu
    BRA .menu
  .skip_menu

    LDA $8B : CMP !ram_shadow_ctrl_auto_save_state : BNE .skip_auto_save_state
    AND $8F : BEQ .skip_auto_save_state
    BRA .auto_save_state
  .skip_auto_save_state

    LDA $8B : CMP !ram_shadow_ctrl_toggle_spin_lock : BNE .skip_toggle_spin_lock
    AND $8F : BEQ .skip_toggle_spin_lock
    BRA .toggle_spin_lock
  .skip_toggle_spin_lock

    ; No shortcuts matched, CLC so we won't skip normal gameplay
    CLC : RTS

  .load_state
    ; check if a saved state exists
    LDA !SRAM_SAVED_STATE : CMP #$5AFE : BNE .load_state_fail
    ; update the load counter in the save state before loading it
    LDA !sram_reload_count_in_savestate : CMP #$270F : BCS .load_state_jsl
    INC : STA !sram_reload_count_in_savestate
  .load_state_jsl
    JSL load_state
    ; SEC to skip normal gameplay for one frame after loading state
    SEC : RTS

  .load_state_fail
    ; CLC to continue normal gameplay
    LDA !ram_shadow_ctrl_load_state
    CLC : JMP skip_pause

  .menu
    ; Set IRQ vector
    LDA $AB : PHA
    LDA #$0004 : STA $AB

    LDA !ram_shadow_ctrl_menu
    JSR skip_pause

    ; Enter MainMenu
    JSL cm_start

    ; Restore IRQ vector
    PLA : STA $AB

    ; SEC to skip normal gameplay for one frame after handling the menu
    SEC : RTS

  .auto_save_state
    LDA #$0001 : STA !ram_auto_save_state
    ; CLC to continue normal gameplay after setting savestate flag
    LDA !ram_shadow_ctrl_auto_save_state
    CLC : JMP skip_pause

  .toggle_spin_lock
    LDA !ram_spin_lock : BEQ .turn_on_spin_lock
    TDC
    BRA .set_spin_lock
  .turn_on_spin_lock
    TDC : INC
    STA !ram_spin_lock_ever_used
  .set_spin_lock
    STA !ram_spin_lock
    ; CLC to continue normal gameplay after turning on or off spin lock
    LDA !ram_shadow_ctrl_toggle_spin_lock
    CLC : JMP skip_pause
}

print pc, " vanilla_rewind bank $83 end"



org $89E000
print pc, " vanilla_rewind bank $89 start"

; ----------------
; Main menu
; ----------------

action_mainmenu:
{
    ; Set bank of new menu
    LDA.w #MainMenu>>16 : STA !ram_cm_menu_bank
    STA !DP_MenuIndices+2 : STA !DP_CurrentMenu+2

    ; continue into action_submenu
}

action_submenu:
{
    ; Increment stack pointer by 2, then store current menu
    LDA !ram_cm_stack_index : INC #2 : STA !ram_cm_stack_index : TAX
    TYA : STA !ram_cm_menu_stack,X

    ; Set cursor to top for new menus
    LDA #$0000 : STA !ram_cm_cursor_stack,X

    %sfxmove()
    JSL cm_calculate_max
    JML cm_draw
}

draw_numfield:
draw_numfield_hex:
draw_numfield_sound:
draw_numfield_word:
draw_numfield_hex_word:
draw_numfield_color:
draw_custom_preset:
draw_manage_presets:
draw_ram_watch:
    RTS

cm_edit_digits:
    RTS

execute_numfield_sound:
execute_numfield_hex:
execute_numfield:
execute_numfield_word:
execute_numfield_hex_word:
execute_numfield_color:
execute_custom_preset:
execute_manage_presets:
    RTS

MainMenu:
    dw #mm_ceres_intro
    dw #mm_auto_save_state
    dw #mm_spin_lock
    dw #$FFFF
    dw #$FFFF
    dw #$FFFF
    dw #$FFFF
    dw #$FFFF
    dw #$FFFF
    dw #$FFFF
    dw #mm_ctrl_shortcuts
    dw #$FFFF
    dw #mm_ctrl_menu
    dw #mm_ctrl_load_state
    dw #mm_ctrl_auto_save_state
    dw #mm_ctrl_toggle_spin_lock
    dw #$FFFF
    dw #mm_ctrl_clear_shortcuts
    dw #mm_ctrl_reset_defaults
    dw #$0000
    table ../resources/menu_header.tbl
    db #$28, "SM VANILLA REWIND !VERSION_MAJOR.!VERSION_MINOR", #$FF
    table ../resources/menu_normal.tbl
    %cm_footer("PRESS AND HOLD FOR 2 SEC")

mm_ceres_intro:
    %cm_toggle("Ceres Intro", !ram_ceres_intro, #$0001, #0)

mm_auto_save_state:
    %cm_toggle("Auto-Save Next Door", !ram_auto_save_state, #$0001, #0)

mm_spin_lock:
    %cm_toggle("Spin Lock", !ram_spin_lock, #$0001, #0)

mm_ctrl_shortcuts:
    %cm_subheader("CONTROLLER SHORTCUTS")

mm_ctrl_menu:
    %cm_ctrl_shortcut("Main Menu", !ram_shadow_ctrl_menu, !sram_ctrl_menu)

mm_ctrl_load_state:
    %cm_ctrl_shortcut("Load State", !ram_shadow_ctrl_load_state, !sram_ctrl_load_state)

mm_ctrl_auto_save_state:
    %cm_ctrl_shortcut("Auto Save State", !ram_shadow_ctrl_auto_save_state, !sram_ctrl_auto_save_state)

mm_ctrl_toggle_spin_lock:
    %cm_ctrl_shortcut("Toggle Spin Lock", !ram_shadow_ctrl_toggle_spin_lock, !sram_ctrl_toggle_spin_lock)

mm_ctrl_clear_shortcuts:
    %cm_jsl("Clear All Shortcuts", .routine, #$0000)
  .routine
    TYA
    STA !sram_ctrl_load_state
    STA !sram_ctrl_auto_save_state
    STA !sram_ctrl_toggle_spin_lock
    ; menu to default, Start + Select
    LDA #$3000 : STA !sram_ctrl_menu
    %sfxconfirm()
    JML init_wram_based_on_sram

mm_ctrl_reset_defaults:
    %cm_jsl("Reset To Defaults", .routine, #$0000)
  .routine
    JSL init_sram
    %sfxreset()
    JML init_wram_based_on_sram

print pc, " vanilla_rewind bank $89 end"



org $8BEF03
hook_init_clear_time_hours_tens:
    dw #igt_init_reload_count_thousands

org $8BEF09
hook_init_clear_time_hours_ones:
    dw #igt_init_reload_count_hundreds

org $8BEF15
hook_init_clear_time_minutes_tens:
    dw #igt_init_reload_count_tens

org $8BEF1B
hook_init_clear_time_minutes_ones:
    dw #igt_init_reload_count_ones



org $8BF900
print pc, " vanilla_rewind bank $8B start"

cutscenes_load_intro:
{
    LDA !ram_ceres_intro : BNE .keep_intro

    ; Skip intro and ceres arrival
    LDA #$C100
    STA $1F51
    JMP ($1F51)

  .keep_intro
    LDA #$A395
    STA $1F51
    JMP ($1F51)
}

igt_init_reload_count_thousands:
{
    LDA !ram_igt_reload_count_thousands
    JSR $F0A3
    LDA #$00A4 : STA $1A7D,Y
    JMP $F051
}

igt_init_reload_count_hundreds:
{
    LDA !ram_igt_reload_count_hundreds
    JSR $F0A3
    LDA #$00AC : STA $1A7D,Y
    JMP $F051
}

igt_init_reload_count_tens:
{
    LDA !ram_igt_reload_count_tens
    JSR $F0A3
    LDA #$00B4 : STA $1A7D,Y
    JMP $F051
}

igt_init_reload_count_ones:
{
    LDA !ram_igt_reload_count_ones
    JSR $F0A3
    LDA #$00BC : STA $1A7D,Y
    JMP $F051
}

print pc, " vanilla_rewind bank $8B end"
warnpc $8BFA00



org $8C9607
hook_zebes_planet_tile_data:
    dw #$0E2F



org $9AB200      ; vanilla graphics
mapgfx_bin:



org $A2AA56
    JMP set_igt_text



org $A2F500
print pc, " vanilla_rewind bank $A2 start"

set_igt_text:
{
    LDA $7ED821 : BIT #$0040 : BNE .set_text

  .done
    ; overwritten code
    LDA #$AA5D : STA $0FB2,X
    RTL

  .set_text
    LDA #IGTReloadCountDefinition : STA !ram_IGT_clear_time_text
    LDA !ram_spin_lock_ever_used : BNE .spin_lock
    LDA !ram_spin_lock : BNE .spin_lock
    LDA #IGTCompletedSuccessfullyDefinition : STA !ram_IGT_completed_text
    BRA .set_reload_count

  .spin_lock
    LDA #IGTCompletedWithSpinLockDefinition : STA !ram_IGT_completed_text

  .set_reload_count
    TDC : STA !ram_igt_reload_count_tens
    STA !ram_igt_reload_count_hundreds
    STA !ram_igt_reload_count_thousands    

    LDA !ram_reload_count : STA $4204
    %a8()
    LDA #$0A : STA $4206   ; divide by 10
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : STA !DP_Temp

    ; Ones digit
    LDA $4216 : STA !ram_igt_reload_count_ones

    LDA !DP_Temp : BEQ .done
    STA $4204
    %a8()
    LDA #$0A : STA $4206   ; divide by 10
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : STA !DP_Temp

    ; Tens digit
    LDA $4216 : STA !ram_igt_reload_count_tens

    LDA !DP_Temp : BEQ .done
    STA $4204
    %a8()
    LDA #$0A : STA $4206   ; divide by 10
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : STA !ram_igt_reload_count_thousands

    ; Hundreds digit
    LDA $4216 : STA !ram_igt_reload_count_hundreds
    BRL .done
}

print pc, " vanilla_rewind bank $A2 end"

