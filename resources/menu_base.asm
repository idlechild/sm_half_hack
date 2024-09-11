
!ACTION_TOGGLE              = #$0000
!ACTION_TOGGLE_BIT          = #$0002
!ACTION_TOGGLE_INVERTED     = #$0004
!ACTION_TOGGLE_BIT_INVERTED = #$0006
!ACTION_NUMFIELD            = #$0008
!ACTION_NUMFIELD_HEX        = #$000A
!ACTION_NUMFIELD_WORD       = #$000C
!ACTION_NUMFIELD_HEX_WORD   = #$000E
!ACTION_NUMFIELD_READONLY   = #$0010
!ACTION_NUMFIELD_COLOR      = #$0012
!ACTION_NUMFIELD_SOUND      = #$0014
!ACTION_CHOICE              = #$0016
!ACTION_CHOICE_JSL_TEXT     = #$0018
!ACTION_CTRL_SHORTCUT       = #$001A
!ACTION_CTRL_INPUT          = #$001C
!ACTION_JSL                 = #$001E
!ACTION_JSL_SUBMENU         = #$0020
!ACTION_CUSTOM_PRESET       = #$0022
!ACTION_RAM_WATCH           = #$0024
!ACTION_DYNAMIC             = #$0026
!ACTION_MANAGE_PRESETS      = #$0028
!ACTION_SUBHEADER           = #$002A

!CTRL_B           = #$8000
!CTRL_Y           = #$4000
!CTRL_SELECT      = #$2000
!CTRL_START       = #$1000
!CTRL_UPDOWN      = #$0C00
!CTRL_UP          = #$0800
!CTRL_DOWN        = #$0400
!CTRL_LEFTRIGHT   = #$0300
!CTRL_LEFT        = #$0200
!CTRL_RIGHT       = #$0100
!CTRL_A           = #$0080
!CTRL_X           = #$0040
!CTRL_L           = #$0020
!CTRL_R           = #$0010
!CTRL_INPUT_HELD  = #$0001 ; used by menu

!MENU_CLEAR       = #$000E
!MENU_BLANK       = #$281F
!MENU_SLASH       = #$287F
!MENU_ARROW_RIGHT = #$3880



macro cm_header(title)
; outlined text to be drawn above the menu items
  .dm_header
table ../resources/menu_header.tbl
    db #$28, "<title>", #$FF
table ../resources/menu_normal.tbl
endmacro

macro cm_subheader(title)
; Allows editing a 16-bit value at the specified address
  .dm_action
    dw !ACTION_SUBHEADER
  .dm_text
table ../resources/menu_header.tbl
    db #$28, "<title>", #$FF
table ../resources/menu_normal.tbl
endmacro

macro cm_footer(title)
; optional outlined text below the menu items
  .dm_footer
table ../resources/menu_header.tbl
    dw #$F007 : db #$28, "<title>", #$FF
table ../resources/menu_normal.tbl
endmacro

macro cm_toggle(title, addr, value, jsltarget)
; toggle between zero (OFF) and value (ON)
  .dm_action
    dw !ACTION_TOGGLE
  .dm_addr
    dl <addr> ; 24bit RAM address to display/manipulate
  .dm_value
    db <value> ; value to write when toggled on
  .dm_jsl
    dw <jsltarget> ; 16bit address to code in the same bank as current menu/submenu
  .dm_text
table ../resources/menu_normal.tbl
    db #$28, "<title>", #$FF
endmacro

macro cm_toggle_inverted(title, addr, value, jsltarget)
; for toggles where zero = ON
  .dm_action
    dw !ACTION_TOGGLE_INVERTED
  .dm_addr
    dl <addr> ; 24bit RAM address to display/manipulate
  .dm_value
    db <value> ; value to write when toggled off
  .dm_jsl
    dw <jsltarget> ; 16bit address to code in the same bank as current menu/submenu
  .dm_text
table ../resources/menu_normal.tbl
    db #$28, "<title>", #$FF
endmacro

macro cm_toggle_bit(title, addr, mask, jsltarget)
; toggle specific bits, draw OFF if bits cleared
  .dm_action
    dw !ACTION_TOGGLE_BIT
  .dm_addr
    dl <addr> ; 24bit RAM address to display/manipulate
  .dm_bitmask
    dw <mask> ; which bits to flip
  .dm_jsl
    dw <jsltarget> ; 16bit address to code in the same bank as current menu/submenu
  .dm_text
table ../resources/menu_normal.tbl
    db #$28, "<title>", #$FF
endmacro

macro cm_toggle_bit_inverted(title, addr, mask, jsltarget)
; toggle specific bits, draw ON if bits cleared
  .dm_action
    dw !ACTION_TOGGLE_BIT_INVERTED
  .dm_addr
    dl <addr> ; 24bit RAM address to display/manipulate
  .dm_bitmask
    dw <mask> ; which bits to flip
  .dm_jsl
    dw <jsltarget> ; 16bit address to code in the same bank as current menu/submenu
  .dm_text
table ../resources/menu_normal.tbl
    db #$28, "<title>", #$FF
endmacro

macro cm_jsl(title, routine, argument)
; run code when menu item executed
  .dm_action
    dw !ACTION_JSL
  .dm_jsl
    dw <routine> ; 16bit address to code in the same bank as current menu/submenu
  .dm_arg
    dw <argument> ; value passed to routine in Y
  .dm_text
table ../resources/menu_normal.tbl
    db #$28, "<title>", #$FF
endmacro

macro cm_jsl_submenu(title, routine, argument)
; only used within submenu and mainmenu macros
  .dm_action
    dw !ACTION_JSL_SUBMENU
  .dm_jsl
    dw <routine> ; 16bit address to code in the same bank as current menu/submenu
  .dm_arg
    dw <argument> ; value passed to routine in Y
  .dm_text
table ../resources/menu_normal.tbl
    db #$28, "<title>", #$FF
endmacro

macro cm_mainmenu(title, target)
; runs action_mainmenu to set the bank of the next menu and continue into action_submenu
; can only used for submenus listed on the mainmenu
    %cm_jsl("<title>", #action_mainmenu, <target>)
endmacro

macro cm_submenu(title, target)
; run action_submenu to load the next menu from the same bank
    %cm_jsl_submenu("<title>", #action_submenu, <target>)
endmacro

macro cm_adjacent_submenu(title, target)
; return to previous menu and then runs action_submenu
; can only used for submenus and when already on a submenu
    %cm_jsl("<title>", #.routine, <target>)
  .routine
    JSL cm_previous_menu
    JML action_submenu
endmacro

macro cm_ctrl_shortcut(title, shadow, sram)
; configure controller shortcuts
  .dm_action
    dw !ACTION_CTRL_SHORTCUT
  .dm_shadow_addr
    dl <shadow> ; 24bit shadow RAM address to display/manipulate
  .dm_sram_addr
    dl <sram> ; 24bit SRAM address to store result
  .dm_text
table ../resources/menu_normal.tbl
    db #$28, "<title>", #$FF
endmacro

macro cm_ctrl_input(title, addr, routine, argument)
; set a single controller binding
  .dm_action
    dw !ACTION_CTRL_INPUT
  .dm_addr
    dl <addr> ; 24bit RAM address to display/manipulate
  .dm_jsl
    dw <routine> ; 16bit address to code in the same bank as current menu/submenu
  .dm_arg
    dw <argument> ; value passed to routine in Y
  .dm_text
table ../resources/menu_normal.tbl
    db #$28, "<title>", #$FF
endmacro

macro item_index_to_vram_index()
; find screen position from Y (item number)
    TYA : ASL #5
    CLC : ADC #$0146 : TAX
endmacro

macro sfxbeep() ; Minimap Movement Beep
    LDA #$0036 : JSL $80903F
endmacro

macro sfxclick() ; Click
    LDA #$0037 : JSL $80903F
endmacro

macro sfxconfirm() ; Confirm Selection
    LDA #$0028 : JSL $80903F
endmacro

macro sfxfail() ; Grapple End
    LDA #$0007 : JSL $80903F
endmacro

macro sfxgoback() ; Go Back
    LDA #$0007 : JSL $80903F
endmacro

macro sfxmove() ; Move Cursor
    LDA #$0037 : JSL $80903F
endmacro

macro sfxnumber() ; Number Selection
    LDA #$0038 : JSL $80903F
endmacro

macro sfxreset() ; Earthquake
    LDA #$001E : JSL $809143
endmacro

macro sfxtoggle() ; Toggle
    LDA #$002A : JSL $80903F
endmacro



org $85FD00
print pc, " menu_base bank $85 start"

initialize_ppu_long:
    PHP : %a16()
    LDA $7E33EA : STA !ram_cgram_cache+$2E
    PLP
    JSR $8143
    RTL

restore_ppu_long:
    JSR $861A
    PHP : %a16()
    LDA !ram_cgram_cache+$2E : STA $7E33EA
    PLP
    RTL

play_music_long:
    JSR $8574
    RTL

maybe_trigger_pause_long:
    JSR $80FA
    RTL

print pc, " menu_base bank $85 end"
warnpc $85FE00



org $89B000
print pc, " menu_base bank $89 start"

; ----------
; Resources
; ----------

cm_hud_table:
    incbin ../resources/cm_gfx.bin

HexMenuGFXTable:
    dw $2C70, $2C71, $2C72, $2C73, $2C74, $2C75, $2C76, $2C77, $2C78, $2C79, $2C50, $2C51, $2C52, $2C53, $2C54, $2C55


; ----------
; Drawing
; ----------

cm_transfer_custom_tileset:
{
    PHP
    %a16()

    LDA $079B : CMP #$A59F : BEQ .kraid_vram

    ; Load custom vram to normal BG3 location
    %a8()
    LDA #$80 : STA $2100 ; enable forced blanking
    LDA #$04 : STA $210C ; BG3 starts at $4000 (8000 in vram)
    LDA #$80 : STA $2115 ; word-access, incr by 1
    LDX #$4000 : STX $2116 ; VRAM address (8000 in vram)
    LDX #cm_hud_table : STX $4302 ; Source offset
    LDA #cm_hud_table>>16 : STA $4304 ; Source bank
    LDX #$1000 : STX $4305 ; Size (0x10 = 1 tile)
    LDA #$01 : STA $4300 ; word, normal increment (DMA MODE)
    LDA #$18 : STA $4301 ; destination (VRAM write)
    LDA #$01 : STA $420B ; initiate DMA (channel 1)
    LDA #$0F : STA $2100 ; disable forced blanking
    PLP
    RTL

  .kraid_vram
    ; Load custom vram to kraid BG3 location
    %a8()
    LDA #$80 : STA $2100 ; enable forced blanking
    LDA #$02 : STA $210C ; BG3 starts at $2000 (4000 in vram)
    LDA #$80 : STA $2115 ; word-access, incr by 1
    LDX #$2000 : STX $2116 ; VRAM address (4000 in vram)
    LDX #cm_hud_table : STX $4302 ; Source offset
    LDA #cm_hud_table>>16 : STA $4304 ; Source bank
    LDX #$1000 : STX $4305 ; Size (0x10 = 1 tile)
    LDA #$01 : STA $4300 ; word, normal increment (DMA MODE)
    LDA #$18 : STA $4301 ; destination (VRAM write)
    LDA #$01 : STA $420B ; initiate DMA (channel 1)
    LDA #$0F : STA $2100 ; disable forced blanking
    PLP
    RTL
}

cm_transfer_original_tileset:
{
    PHP
    %a16()
    LDA $079B : CMP #$A59F : BEQ .kraid_vram

    ; Load in minimap vram to normal BG3 location
    %a8()
    LDA #$80 : STA $2100 ; enable forced blanking
    LDA #$04 : STA $210C ; BG3 starts at $4000 (8000 in vram)
    LDA #$80 : STA $2115 ; word-access, incr by 1
    LDX #$4000 : STX $2116 ; VRAM address (8000 in vram)
    LDX.w #mapgfx_bin : STX $4302 ; Source offset
    LDA.b #mapgfx_bin>>16 : STA $4304 ; Source bank
    LDX #$1000 : STX $4305 ; Size (0x10 = 1 tile)
    LDA #$01 : STA $4300 ; word, normal increment (DMA MODE)
    LDA #$18 : STA $4301 ; destination (VRAM write)
    LDA #$01 : STA $420B ; initiate DMA (channel 1)
    LDA #$0F : STA $2100 ; disable forced blanking
    PLP
    RTL

  .kraid_vram
    ; Load in minimap vram to kraid BG3 location
    %a8()
    LDA #$80 : STA $2100 ; enable forced blanking
    LDA #$02 : STA $210C ; BG3 starts at $2000 (4000 in vram)
    LDA #$80 : STA $2115 ; word-access, incr by 1
    LDX #$2000 : STX $2116 ; VRAM address (4000 in vram)
    LDX.w #mapgfx_bin : STX $4302 ; Source offset
    LDA.b #mapgfx_bin>>16 : STA $4304 ; Source bank
    LDX #$1000 : STX $4305 ; Size (0x10 = 1 tile)
    LDA #$01 : STA $4300 ; word, normal increment (DMA MODE)
    LDA #$18 : STA $4301 ; destination (VRAM write)
    LDA #$01 : STA $420B ; initiate DMA (channel 1)
    LDA #$0F : STA $2100 ; disable forced blanking
    PLP
    RTL
}

cm_transfer_custom_cgram:
; $0A = Border & OFF   $7277
; $12 = Header         $48F3
; $1A = Num            $0000, $7FFF
; $32 = ON / Sel Num   $4376
; $34 = Selected item  $761F
; $3A = Sel Num        $0000, $761F
{
    PHP : %ai16()
    ; Backup gameplay palette
    LDA $7EC00A : STA !ram_cgram_cache
    LDA $7EC00E : STA !ram_cgram_cache+$02
    LDA $7EC012 : STA !ram_cgram_cache+$04
    LDA $7EC014 : STA !ram_cgram_cache+$06
    LDA $7EC016 : STA !ram_cgram_cache+$08
    LDA $7EC01A : STA !ram_cgram_cache+$0A
    LDA $7EC01C : STA !ram_cgram_cache+$0C
    LDA $7EC01E : STA !ram_cgram_cache+$0E
    LDA $7EC032 : STA !ram_cgram_cache+$10
    LDA $7EC034 : STA !ram_cgram_cache+$12
    LDA $7EC036 : STA !ram_cgram_cache+$14
    LDA $7EC03A : STA !ram_cgram_cache+$16
    LDA $7EC03C : STA !ram_cgram_cache+$18
    LDA $7EC03E : STA !ram_cgram_cache+$1A

    ; Set menu palette
    LDA #$0000 : STA $7EC000
    LDA #$7277 : STA $7EC00A  ; border
    LDA #$0000 : STA $7EC00E  ; background
    LDA #$48F3 : STA $7EC012  ; headeroutline
    LDA #$7FFF : STA $7EC014  ; text
    LDA #$0000 : STA $7EC016  ; background
    LDA #$0000 : STA $7EC01A  ; numoutline
    LDA #$7FFF : STA $7EC01C  ; numfill
    LDA #$0000 : STA $7EC01E  ; background
    LDA #$4376 : STA $7EC032  ; toggleon
    LDA #$761F : STA $7EC034  ; seltext
    LDA #$0000 : STA $7EC036  ; seltextbg
    LDA #$0000 : STA $7EC03A  ; numseloutline
    LDA #$761F : STA $7EC03C  ; numsel
    LDA #$0000 : STA $7EC03E  ; seltextbg

    JSL transfer_cgram_long
    PLP
    RTL
}

cm_transfer_original_cgram:
{
    PHP
    %a16()

    ; Restore gameplay palette
    LDA !ram_cgram_cache : STA $7EC00A
    LDA !ram_cgram_cache+$02 : STA $7EC00E
    LDA !ram_cgram_cache+$04 : STA $7EC012
    LDA !ram_cgram_cache+$06 : STA $7EC014
    LDA !ram_cgram_cache+$08 : STA $7EC016
    LDA !ram_cgram_cache+$0A : STA $7EC01A
    LDA !ram_cgram_cache+$0C : STA $7EC01C
    LDA !ram_cgram_cache+$0E : STA $7EC01E
    LDA !ram_cgram_cache+$10 : STA $7EC032
    LDA !ram_cgram_cache+$12 : STA $7EC034
    LDA !ram_cgram_cache+$14 : STA $7EC036
    LDA !ram_cgram_cache+$16 : STA $7EC03A
    LDA !ram_cgram_cache+$18 : STA $7EC03C
    LDA !ram_cgram_cache+$1A : STA $7EC03E

    JSL transfer_cgram_long
    PLP
    RTL
}

cm_draw:
{
    PHP
    %ai16()
    JSR cm_tilemap_bg
    JSR cm_tilemap_menu
    JSR cm_tilemap_transfer
    PLP
    RTL
}

cm_tilemap_bg:
{
    ; Empty out BG3 tilemap
if defined("MENU_BLOCK_FULLSCREEN")
    LDA !MENU_BLANK ; background tile
else
    LDA !MENU_CLEAR ; transparent tile
endif
    LDX #$07FE ; size = $800 bytes

  .loopClearBG3
    STA !ram_tilemap_buffer,X
    DEX #2 : BPL .loopClearBG3

if defined("MENU_BLOCK_FULLSCREEN")
    ; Keep the top line transparent due to the
    ; VRAM transfer in $809A79 routine being incomplete
    LDA !MENU_CLEAR
    LDX #$003E

  .loopTopLineBG3
    STA !ram_tilemap_buffer,X
    DEX #2 : BPL .loopTopLineBG3
else
    ; Vertical edges
    LDX #$0000
    LDY #$0018 ; 24 rows

  .loopVertical
    LDA #$647A : STA !ram_tilemap_buffer+$082,X
    LDA #$247A : STA !ram_tilemap_buffer+$0BC,X
    TXA : CLC : ADC #$0040 : TAX
    DEY : BPL .loopVertical

    ; Horizontal edges
    LDX #$0000
    LDY #$001B ; 28 columns

  .loopHorizontal
    LDA #$A47B : STA !ram_tilemap_buffer+$044,X
    LDA #$247B : STA !ram_tilemap_buffer+$6C4,X
    INX #2
    DEY : BPL .loopHorizontal

    ; Fill interior
    LDX #$0000
    LDY #$001B ; 28 columns
    LDA !MENU_BLANK ; blank background tile

  .loopBackground
    STA !ram_tilemap_buffer+$084,X
    STA !ram_tilemap_buffer+$0C4,X
    STA !ram_tilemap_buffer+$104,X
    STA !ram_tilemap_buffer+$144,X
    STA !ram_tilemap_buffer+$184,X
    STA !ram_tilemap_buffer+$1C4,X
    STA !ram_tilemap_buffer+$204,X
    STA !ram_tilemap_buffer+$244,X
    STA !ram_tilemap_buffer+$284,X
    STA !ram_tilemap_buffer+$2C4,X
    STA !ram_tilemap_buffer+$304,X
    STA !ram_tilemap_buffer+$344,X
    STA !ram_tilemap_buffer+$384,X
    STA !ram_tilemap_buffer+$3C4,X
    STA !ram_tilemap_buffer+$404,X
    STA !ram_tilemap_buffer+$444,X
    STA !ram_tilemap_buffer+$484,X
    STA !ram_tilemap_buffer+$4C4,X
    STA !ram_tilemap_buffer+$504,X
    STA !ram_tilemap_buffer+$544,X
    STA !ram_tilemap_buffer+$584,X
    STA !ram_tilemap_buffer+$5C4,X
    STA !ram_tilemap_buffer+$604,X
    STA !ram_tilemap_buffer+$644,X
    STA !ram_tilemap_buffer+$684,X
    INX #2
    DEY : BPL .loopBackground

  .done
endif
    RTS
}

cm_tilemap_menu:
{
    LDX !ram_cm_stack_index
    LDA !ram_cm_menu_stack,X : STA !DP_MenuIndices
    LDA !ram_cm_menu_bank : STA !DP_MenuIndices+2 : STA !DP_CurrentMenu+2

    LDY #$0000 ; Y = menu item index
  .loop
    ; highlight if selected row
    TYA : CMP !ram_cm_cursor_stack,X : BEQ .selected
    LDA #$0000
    BRA .continue

  .selected
    LDA #$0010

  .continue
    ; later ORA'd with tile attributes
    STA !DP_Palette

    ; check for special entries (header/blank lines)
    LDA [!DP_MenuIndices],Y : BEQ .header
    CMP #$FFFF : BEQ .blank
    ; store menu item pointer
    STA !DP_CurrentMenu

    PHY : PHX

    ; X = action index (action type)
    LDA [!DP_CurrentMenu] : TAX

    ; !DP_CurrentMenu points to data after the action type index
    INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; draw menu item
    JSR (cm_draw_action_table,X)

    PLX : PLY

  .blank
    ; skip drawing blank lines
    INY #2
    BRA .loop

  .header
    STZ !DP_Palette
    ; menu pointer + index + 2 = header
    TYA : CLC : ADC !DP_MenuIndices : INC #2 : STA !DP_CurrentMenu
    LDX #$00C6
    JSR cm_draw_text

  .footer
    ; menu pointer + header pointer + 1 = footer
    TYA : CLC : ADC !DP_CurrentMenu : INC : STA !DP_CurrentMenu
    ; optional footer
    LDA [!DP_CurrentMenu] : CMP #$F007 : BNE .done

    ; INC past #$F007
    INC !DP_CurrentMenu : INC !DP_CurrentMenu : STZ !DP_Palette
    LDX #$0646 ; footer tilemap position
    JSR cm_draw_text
    RTS

  .done
    ; no footer, back up two bytes
    DEC !DP_CurrentMenu : DEC !DP_CurrentMenu
    RTS
}

cm_tilemap_transfer:
{
    JSR cm_wait_for_lag_frame  ; Wait for lag frame

    %a16()
    LDA #$5800 : STA $2116 ; VRAM addr
    LDA #$1801 : STA $4310 ; VRAM write
    LDA.w #!ram_tilemap_buffer : STA $4312 ; src addr
    LDA.w #!ram_tilemap_buffer>>16 : STA $4314 ; src bank
    LDA #$0800 : STA $4315 ; size
    STZ $4317 : STZ $4319 ; clear HDMA registers
    %a8()
    LDA #$80 : STA $2115 ; INC mode
    LDA #$02 : STA $420B ; enable DMA, channel 1
    JSL $808F0C ; handle music queue
    JSL $8289EF ; handle sfx
    %a16()
    RTS
}

cm_draw_action_table:
    dw draw_toggle
    dw draw_toggle_bit
    dw draw_toggle_inverted
    dw draw_toggle_bit_inverted
    dw draw_numfield
    dw draw_numfield_hex
    dw draw_numfield_word
    dw draw_numfield_hex_word
    dw draw_numfield_word
    dw draw_numfield_color
    dw draw_numfield_sound
    dw draw_choice
    dw draw_choice_jsl_text
    dw draw_ctrl_shortcut
    dw draw_controller_input
    dw draw_jsl
    dw draw_submenu
    dw draw_custom_preset
    dw draw_ram_watch
    dw draw_dynamic
    dw draw_manage_presets
    dw draw_subheader

draw_toggle:
{
    ; grab the memory address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; grab the toggle value
    LDA [!DP_CurrentMenu] : AND #$00FF : INC !DP_CurrentMenu : STA !DP_ToggleValue

    ; increment past JSL
    INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; Draw the text
    %item_index_to_vram_index()
    PHX : JSR cm_draw_text : PLX

    ; Set position for ON/OFF
    TXA : CLC : ADC #$002E : TAX

    %a8()
    ; set palette
    LDA !DP_Palette
    STA !ram_tilemap_buffer+1,X
    STA !ram_tilemap_buffer+3,X
    STA !ram_tilemap_buffer+5,X

    ; grab the value at that memory address
    LDA [!DP_Address] : CMP !DP_ToggleValue : BEQ .checked

    ; Off
    %a16()
    LDA #$244B : STA !ram_tilemap_buffer+0,X
    LDA #$244D : STA !ram_tilemap_buffer+2,X
    LDA #$244D : STA !ram_tilemap_buffer+4,X
    RTS

  .checked
    ; On
    %a16()
    LDA #$384B : STA !ram_tilemap_buffer+2,X
    LDA #$384C : STA !ram_tilemap_buffer+4,X
    RTS
}

draw_toggle_bit:
{
    ; grab the memory address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; grab bitmask
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_ToggleValue

    ; increment past JSL
    INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; Draw the text
    %item_index_to_vram_index()
    PHX : JSR cm_draw_text : PLX

    ; Set position for ON/OFF
    TXA : CLC : ADC #$002E : TAX

    ; grab the value at that memory address
    LDA [!DP_Address] : AND !DP_ToggleValue : BNE .checked

    ; Off
    LDA #$244B : STA !ram_tilemap_buffer+0,X
    LDA #$244D : STA !ram_tilemap_buffer+2,X
    LDA #$244D : STA !ram_tilemap_buffer+4,X
    RTS

  .checked
    ; On
    %a16()
    LDA #$384B : STA !ram_tilemap_buffer+2,X
    LDA #$384C : STA !ram_tilemap_buffer+4,X
    RTS
}

draw_toggle_inverted:
{
    ; grab the memory address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; grab the toggle value
    LDA [!DP_CurrentMenu] : AND #$00FF : INC !DP_CurrentMenu : STA !DP_ToggleValue

    ; increment past JSL
    INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; Draw the text
    %item_index_to_vram_index()
    PHX : JSR cm_draw_text : PLX

    ; Set position for ON/OFF
    TXA : CLC : ADC #$002E : TAX

    %a8()
    ; set palette
    LDA !DP_Palette
    STA !ram_tilemap_buffer+1,X
    STA !ram_tilemap_buffer+3,X
    STA !ram_tilemap_buffer+5,X

    ; grab the value at that memory address
    LDA [!DP_Address] : CMP !DP_ToggleValue : BNE .checked

    ; Off
    %a16()
    LDA #$244B : STA !ram_tilemap_buffer+0,X
    LDA #$244D : STA !ram_tilemap_buffer+2,X
    LDA #$244D : STA !ram_tilemap_buffer+4,X
    RTS

  .checked
    ; On
    %a16()
    LDA #$384B : STA !ram_tilemap_buffer+2,X
    LDA #$384C : STA !ram_tilemap_buffer+4,X
    RTS
}

draw_toggle_bit_inverted:
{
    ; grab the memory address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; grab bitmask
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_ToggleValue

    ; increment past JSL
    INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; Draw the text
    %item_index_to_vram_index()
    PHX : JSR cm_draw_text : PLX

    ; Set position for ON/OFF
    TXA : CLC : ADC #$002C : TAX

    ; grab the value at that memory address
    LDA [!DP_Address] : AND !DP_ToggleValue : BEQ .checked

    ; Off
    LDA #$244B : STA !ram_tilemap_buffer+2,X
    LDA #$244D : STA !ram_tilemap_buffer+4,X
    LDA #$244D : STA !ram_tilemap_buffer+6,X
    RTS

  .checked
    ; On
    %a16()
    LDA #$384B : STA !ram_tilemap_buffer+4,X
    LDA #$384C : STA !ram_tilemap_buffer+6,X
    RTS
}

draw_choice:
{
    ; grab the memory address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; skip the JSL target
    INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; Draw the text first
    %item_index_to_vram_index()
    PHX : JSR cm_draw_text : PLX

    ; set position for choice
    TXA : CLC : ADC #$001E : TAX

    ; grab the value at that memory address
    LDA [!DP_Address] : TAY

    ; find the correct text that should be drawn (the selected choice)
    ; skipping the first text that we already drew
    INY #2

  .loop_choices
    DEY : BEQ .found

  .loop_text
    LDA [!DP_CurrentMenu] : %a16() : INC !DP_CurrentMenu : %a8()
    CMP #$FF : BEQ .loop_choices
    BRA .loop_text

  .found
    %a16()
    JSR cm_draw_text
    RTS
}

draw_choice_jsl_text:
{
    ; grab the memory address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; skip the JSL target
    INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; set position for choice
    %item_index_to_vram_index()

    ; grab the value at that memory address
    LDA [!DP_Address] : TAY

    ; find the correct text that should be drawn (the selected choice)
    BEQ .found

  .loop_jsl_text
    INC !DP_CurrentMenu : INC !DP_CurrentMenu
    DEY : BNE .loop_jsl_text

  .found
    ; go to jsl text
    %a16()
    LDA [!DP_CurrentMenu] : INC #6 : STA !DP_CurrentMenu
    JSR cm_draw_text
    RTS
}

draw_ctrl_shortcut:
{
    ; grab the shadow address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; skip over sram address (long)
    INC !DP_CurrentMenu : INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; draw the text
    %item_index_to_vram_index()
    PHX
    JSR cm_draw_text

    ; set position of inputs
    PLA : CLC : ADC #$0022 : TAX

    ; draw the inputs
    LDA [!DP_Address]
    JSR menu_ctrl_input_display

    RTS
}

draw_controller_input:
{
    ; grab the memory address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    STA !ram_cm_ctrl_assign
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; skip JSL target + argument
    INC !DP_CurrentMenu : INC !DP_CurrentMenu : INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; Draw the text
    %item_index_to_vram_index()
    PHX : JSR cm_draw_text : PLX

    ; set position for the input
    TXA : CLC : ADC #$0020 : TAX

    ; check if anything to draw
    LDA (!DP_Address) : AND #$E0F0 : BEQ .unbound

    ; determine which input to draw, using Y to refresh A
    TAY : AND !CTRL_A : BEQ .check_b : LDY #$0000 : BRA .draw
  .check_b
    TYA : AND !CTRL_B : BEQ .check_x : LDY #$0002 : BRA .draw
  .check_x
    TYA : AND !CTRL_X : BEQ .check_y : LDY #$0004 : BRA .draw
  .check_y
    TYA : AND !CTRL_Y : BEQ .check_l : LDY #$0006 : BRA .draw
  .check_l
    TYA : AND !CTRL_L : BEQ .check_r : LDY #$0008 : BRA .draw
  .check_r
    TYA : AND !CTRL_R : BEQ .check_s : LDY #$000A : BRA .draw
  .check_s
    TYA : AND !CTRL_SELECT : BEQ .unbound : LDY #$000C

  .draw
    LDA.w .CtrlMenuGFXTable,Y : STA !ram_tilemap_buffer,X
    RTS

  .unbound
    LDA !MENU_BLANK : STA !ram_tilemap_buffer,X
    RTS

  .CtrlMenuGFXTable
    ;    A      B      X      Y      L      R    Select
    ;  $0080  $8000  $0040  $4000  $0020  $0010  $2000
    dw $288F, $2887, $288E, $2886, $288D, $288C, $2885
}

draw_jsl:
draw_submenu:
{
    ; skip JSL address
    INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; skip argument
    INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; draw text normally
    %item_index_to_vram_index()
    JSR cm_draw_text
    RTS
}

draw_dynamic:
{
    ; grab the memory address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; grab the value at that memory address
    LDA [!DP_Address] : TAX

    ; find the correct item that should be drawn (the selected choice)
    BEQ .found

  .loop
    INC !DP_CurrentMenu : INC !DP_CurrentMenu
    DEX : BNE .loop

  .found
    LDA [!DP_CurrentMenu] : BEQ .skip
    STA !DP_CurrentMenu

    ; X = action index (action type)
    LDA [!DP_CurrentMenu] : TAX

    ; !DP_CurrentMenu points to data after the action type index
    INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; draw menu item
    JMP (cm_draw_action_table,X)

  .skip
    RTS
}

draw_subheader:
{
    ; Draw the text
    %item_index_to_vram_index()
    PHX : JSR cm_draw_text : PLX
    RTS
}

cm_draw_text:
; X = pointer to tilemap area (STA !ram_tilemap_buffer,X)
{
    %a8()
    LDY #$0000
    ; terminator
    LDA [!DP_CurrentMenu],Y : INY : CMP #$FF : BEQ .end
    ; ORA with palette info
    ORA !DP_Palette : STA !DP_Palette

  .loop
    LDA [!DP_CurrentMenu],Y : CMP #$FF : BEQ .end       ; terminator
    STA !ram_tilemap_buffer,X : INX                     ; tile
    LDA !DP_Palette : STA !ram_tilemap_buffer,X : INX   ; palette
    INY : BRA .loop

  .end
    %a16()
    RTS
}


; --------------
; Input Display
; --------------

menu_ctrl_input_display:
; X = pointer to tilemap area (STA !ram_tilemap_buffer,X)
; A = Controller word
{
    JSR menu_ctrl_clear_input_display

    XBA
    LDY #$0000
  .loop
    PHA
    BIT #$0001 : BEQ .no_draw

    TYA : CLC : ADC #$0080
    XBA : ORA !DP_Palette : XBA
    STA !ram_tilemap_buffer,X : INX #2

  .no_draw
    PLA
    INY : LSR : BNE .loop

  .done
    RTS
}

menu_ctrl_clear_input_display:
{
    ; X = pointer to tilemap area
    PHA
    LDA !MENU_BLANK
    STA !ram_tilemap_buffer+0,X
    STA !ram_tilemap_buffer+2,X
    STA !ram_tilemap_buffer+4,X
    STA !ram_tilemap_buffer+6,X
    STA !ram_tilemap_buffer+8,X
    STA !ram_tilemap_buffer+10,X
    STA !ram_tilemap_buffer+12,X
    STA !ram_tilemap_buffer+14,X
    STA !ram_tilemap_buffer+16,X
    PLA
    RTS
}


; ---------
; Logic
; ---------

cm_start:
{
    PHP : %ai16()
    PHB : PHX : PHY
    PHK : PLB

    ; Ensure sound is enabled when menu is open
    LDA $05F5 : PHA
    STZ $05F5
    LDA $0592 : PHA
    STZ $0592
    JSL $82BE17 ; Cancel sound effects

    JSR cm_init
    JSL cm_draw
    JSL play_music_long ; Play 2 lag frames of music and sound effects

    JSL init_wram_before_menu
    JSR cm_loop         ; Handle message box interaction
    JSL init_wram_after_menu

    ; Restore sounds variables
    PLA : STA $0592
    PLA : STA $05F5
    ; Makes the game check Samus' health again, to see if we need annoying sound
    STZ $0A6A

    JSL cm_transfer_original_tileset
    JSL cm_transfer_original_cgram

    ; Update HUD (in case we added missiles etc.)
    %a8()
    LDA #$80 : STA $2100 ; Enable forced blank
    JSL $809A79 ; Initialize HUD
    LDA #$0F : STA $2100 ; Disable forced blank

    ; Restore PPU registers and tilemaps
    JSL restore_ppu_long

    ; skip sound effects if not gameplay ($7-13 allowed)
    %ai16()
    LDA $0998 : CMP #$0006 : BMI .skipSFX
    CMP #$0014 : BPL .skipSFX
    JSL $82BE2F ; Queue Samus movement sound effects

  .skipSFX
    JSL play_music_long ; Play 2 lag frames of music and sound effects
    JSL maybe_trigger_pause_long ; Maybe trigger pause screen or return save confirmation selection

    PLY : PLX : PLB
    PLP
    RTL
}

cm_init:
{
    ; Setup registers
    %a8()
    STZ $420C ; disable HDMAs
    LDA #$80 : STA $2100 ; enable forced blanking
    LDA #$A1 : STA $4200 ; enable NMI, v-IRQ, and auto-joy read
    LDA #$09 : STA $2105 ; BG Mode 1, enable BG3 priority
    LDA #$0F : STA $2100 ; disable forced blanking
    %a16()

    JSL initialize_ppu_long   ; Initialise PPU for message boxes
    JSL cm_transfer_custom_tileset
    JSL cm_transfer_custom_cgram

    ; Set up menu state
    %a16()
    LDA #$0000
    STA !ram_cm_stack_index : STA !ram_cm_cursor_stack
    STA !ram_cm_horizontal_cursor
    STA !ram_cm_leave
    STA !ram_cm_ctrl_mode : STA !ram_cm_ctrl_timer
    STA $8F : STA $8B

    LDA $05B6 : STA !ram_cm_input_frame_counter
    LDA.w #MainMenu : STA !ram_cm_menu_stack
    LDA.w #MainMenu>>16 : STA !ram_cm_menu_bank
    RTS
}

cm_wait_for_lag_frame:
{
    PHP : %ai16()
    LDA $05B8   ; lag frame counter
                ; (it's only 8 bits, but it's OK if we mix it up with the variable after)
  .loop
    CMP $05B8
    BEQ .loop

    PLP : RTS
}

cm_loop:
{
    %ai16()
    JSR cm_wait_for_lag_frame
    JSL $808F0C ; Music queue
    JSL $8289EF ; Sound fx queue

    LDA !ram_cm_leave : BEQ .check_ctrl_mode
    RTS ; Exit menu loop

  .check_ctrl_mode
    LDA !ram_cm_ctrl_mode : BMI .single_digit_editing : BEQ .get_player_inputs
    ; editing controller shortcut
    JSR cm_ctrl_mode
    BRA cm_loop

  .single_digit_editing
    JSR cm_edit_digits
    BRA cm_loop

  .get_player_inputs
    JSR cm_get_inputs : STA !ram_cm_controller : BEQ cm_loop
    BIT !CTRL_A : BNE .pressedA
    BIT !CTRL_B : BNE .pressedB
    BIT !CTRL_X : BNE .pressedX
    BIT !CTRL_Y : BNE .pressedY
    BIT !CTRL_SELECT : BNE .pressedSelect
    BIT !CTRL_START : BNE .pressedStart
    BIT !CTRL_UP : BNE .pressedUp
    BIT !CTRL_DOWN : BNE .pressedDown
    BIT !CTRL_RIGHT : BNE .pressedRight
    BIT !CTRL_LEFT : BNE .pressedLeft
    BIT !CTRL_L : BNE .pressedL
    BIT !CTRL_R : BNE .pressedR
    BRA cm_loop

  .pressedB
    JSL cm_previous_menu
    BRA .redraw

  .pressedDown
    LDA #$0002
    JSR cm_move
    BRA .redraw

  .pressedUp
    LDA #$FFFE
    JSR cm_move
    BRA .redraw

  .pressedL
    ; jump to top menu item
    LDX !ram_cm_stack_index
    LDA #$0000 : STA !ram_cm_cursor_stack,X
    %sfxmove()
    BRA .redraw

  .pressedR
    ; jump to bottom menu item
    LDX !ram_cm_stack_index
    LDA !ram_cm_cursor_max : DEC #2 : STA !ram_cm_cursor_stack,X
    %sfxmove()
    BRA .redraw

  .pressedA
  .pressedX
  .pressedY
  .pressedLeft
  .pressedRight
    JSR cm_execute
    BRA .redraw

  .pressedStart
  .pressedSelect
    LDA #$0001 : STA !ram_cm_leave
    JMP cm_loop

  .redraw
    JSL cm_draw
    JMP cm_loop
}

cm_ctrl_mode:
; This routine cuts off input handling in cm_loop to keep focus on the selected controller shortcut
; Held inputs are displayed until held for 120 frames
{
    JSL $809459 ; Read controller input
    LDA $8B

    ; set palette
    %a8() : LDA #$28 : STA !DP_Palette : %a16()

    LDA $8B : BEQ .clear_and_draw
    CMP !ram_cm_ctrl_last_input : BNE .clear_and_draw

    ; Holding an input for more than one second
    LDA !ram_cm_ctrl_timer : INC : STA !ram_cm_ctrl_timer
    CMP.w #0060 : BNE .next_frame

    ; disallow inputs that match the menu shortcut
    LDA !DP_CtrlShadow : CMP.w #!ram_shadow_ctrl_menu : BEQ .store
    LDA $8B : CMP !ram_shadow_ctrl_menu : BNE .store
    %sfxfail()
    ; set cursor position to 0 (menu shortcut)
    LDX !ram_cm_stack_index
    LDA #$0000 : STA !ram_cm_cursor_stack,X
    BRA .exit

  .store
    ; Store controller input to SRAM
    LDA $8B : STA [!DP_CtrlShadow] : STA [!DP_CtrlSram]
    %sfxconfirm()
    BRA .exit

  .clear_and_draw
    STA !ram_cm_ctrl_last_input
    LDA #$0000 : STA !ram_cm_ctrl_timer

    ; Put text cursor in X
    LDX !ram_cm_stack_index
    LDA !ram_cm_cursor_stack,X : ASL #5 : CLC : ADC #$0168 : TAX

    ; Input display
    LDA $8B
    JSR menu_ctrl_input_display
    JSR cm_tilemap_transfer

  .next_frame
    RTS

  .exit
    LDA #$0000
    STA !ram_cm_ctrl_last_input
    STA !ram_cm_ctrl_mode
    STA !ram_cm_ctrl_timer
    JSL cm_draw
    RTS
}

cm_previous_menu:
{
    JSL cm_go_back
    JML cm_calculate_max
}

cm_go_back:
{
    ; make sure next time we go to a submenu, we start on the first line.
    LDX !ram_cm_stack_index
    LDA #$0000 : STA !ram_cm_cursor_stack,X

    ; make sure we dont set a negative number
    DEX #2 : BPL .done

    ; leave menu 
    LDA #$0001 : STA !ram_cm_leave

    LDX #$0000
  .done
    STX !ram_cm_stack_index : BNE .end

    ; Reset submenu bank when back at main menu
    LDA.w #MainMenu>>16 : STA !ram_cm_menu_bank

  .end
    %sfxgoback()
    RTL
}

cm_calculate_max:
{
    LDX !ram_cm_stack_index
    LDA !ram_cm_menu_stack,X : STA !DP_MenuIndices
    LDA !ram_cm_menu_bank : STA !DP_MenuIndices+2

    LDX #$0000
  .loop
    LDA [!DP_MenuIndices] : BEQ .done
    INC !DP_MenuIndices : INC !DP_MenuIndices
    INX #2 ; count menu items in X
    BRA .loop

  .done
    ; store total menu items +2
    TXA : STA !ram_cm_cursor_max
    RTL
}

cm_get_inputs:
{
    !input_held_delay = #$000C

    ; Make sure we don't read joysticks twice in the same frame
    LDA $05B6 : CMP !ram_cm_input_frame_counter
    PHP : STA !ram_cm_input_frame_counter : PLP : BNE .input_read

    JSL $809459 ; Read controller input

  .input_read
    LDA $8F : BEQ .check_holding

    LDA !input_held_delay : STA !ram_cm_input_timer

    ; Check if fast scroll button is held
    LDA $8B : AND !CTRL_Y : BEQ .return_input

    ; Reduce delay to double the scroll delay
    LDA #$0004 : CMP !input_held_delay : BPL .return_input
    STA !ram_cm_input_timer

  .return_input
    ; Return the new input
    LDA $8F
    RTS

  .check_holding
    ; Check if we're holding the dpad
    LDA $8B : AND #$0F00 : BEQ .noinput

    ; Decrement delay timer and check if it's zero
    LDA !ram_cm_input_timer : DEC : STA !ram_cm_input_timer : BNE .noinput

    ; Set scroll delay
    LDA #$0002 : STA !ram_cm_input_timer

    ; Return held input
    LDA $8B : AND #$0F00 : ORA !CTRL_INPUT_HELD
    RTS

  .noinput
    LDA #$0000
    RTS
}

cm_move:
{
    STA !DP_Temp
    LDX !ram_cm_stack_index
    LDA !DP_Temp : CLC : ADC !ram_cm_cursor_stack,X : BPL .positive
    LDA !ram_cm_cursor_max : DEC #2 : BRA .inBounds

  .positive
    CMP !ram_cm_cursor_max : BNE .inBounds
    LDA #$0000

  .inBounds
    STA !ram_cm_cursor_stack,X : TAY

    ; check for blank menu line ($FFFF)
    LDA [!DP_MenuIndices],Y : CMP #$FFFF : BNE .checkDynamic

  .repeat
    ; repeat move to skip blank line
    LDA !DP_Temp : BRA cm_move

  .checkDynamic
    STA !DP_CurrentMenu : LDA [!DP_CurrentMenu]
    CMP !ACTION_SUBHEADER : BEQ .repeat
    CMP !ACTION_DYNAMIC : BNE .end

    ; grab the memory address (long)
    INC !DP_CurrentMenu : INC !DP_CurrentMenu
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; grab the value at that memory address
    LDA [!DP_Address] : TAX

    ; find the correct item
    BEQ .dynamicFound

  .dynamicLoop
    INC !DP_CurrentMenu : INC !DP_CurrentMenu
    DEX : BNE .dynamicLoop

  .dynamicFound
    ; check if the item should be skipped
    LDA [!DP_CurrentMenu] : BEQ .repeat

  .end
    %sfxmove()
    RTS
}


; --------
; Execute
; --------

cm_execute:
{
    LDX !ram_cm_stack_index
    LDA !ram_cm_menu_stack,X : STA !DP_CurrentMenu
    LDA !ram_cm_menu_bank : STA !DP_CurrentMenu+2
    LDA !ram_cm_cursor_stack,X : TAY
    LDA [!DP_CurrentMenu],Y : STA !DP_CurrentMenu

    ; Safety net incase blank line selected
    CMP #$FFFF : BEQ .end

    ; X = action index (action type)
    LDA [!DP_CurrentMenu] : TAX

    ; !DP_CurrentMenu points to data after the action type index
    INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; Execute action
    JSR (cm_execute_action_table,X)

  .end
    RTS
}

cm_execute_action_table:
    dw execute_toggle
    dw execute_toggle_bit
    dw execute_toggle ; inverted
    dw execute_toggle_bit ; inverted
    dw execute_numfield
    dw execute_numfield_hex
    dw execute_numfield_word
    dw execute_numfield_hex_word
    dw execute_nop
    dw execute_numfield_color
    dw execute_numfield_sound
    dw execute_choice
    dw execute_choice_jsl_text
    dw execute_ctrl_shortcut
    dw execute_controller_input
    dw execute_jsl
    dw execute_submenu
    dw execute_custom_preset
    dw execute_nop
    dw execute_dynamic
    dw execute_manage_presets
    dw execute_nop

execute_nop:
    RTS

execute_toggle:
{
    ; Grab address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; Grab toggle value
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : AND #$00FF : STA !DP_ToggleValue

    ; Grab JSL target
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_JSLTarget

    %a8()
    LDA [!DP_Address] : CMP !DP_ToggleValue : BEQ .toggleOff
    ; toggle on
    LDA !DP_ToggleValue : STA [!DP_Address]
    BRA .jsl

  .toggleOff
    LDA #$00 : STA [!DP_Address]

  .jsl
    %a16()
    ; skip if JSL target is zero
    LDA !DP_JSLTarget : BEQ .end

    ; Set return address for indirect JSL
    LDA !ram_cm_menu_bank : STA !DP_JSLTarget+2
    PHK : PEA .end-1

    ; addr in A
    LDA [!DP_Address] : LDX #$0000
    JML.w [!DP_JSLTarget]

  .end
    %ai16()
    %sfxtoggle()
    RTS
}

execute_toggle_bit:
{
    ; Load the address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; Load which bit(s) to toggle
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_ToggleValue

    ; Load JSL target
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_JSLTarget

    ; Toggle the bit
    LDA [!DP_Address] : EOR !DP_ToggleValue : STA [!DP_Address]

    ; skip if JSL target is zero
    LDA !DP_JSLTarget : BEQ .end

    ; Set return address for indirect JSL
    LDA !ram_cm_menu_bank : STA !DP_JSLTarget+2
    PHK : PEA .end-1

    ; addr in A
    LDA [!DP_Address] : LDX #$0000
    JML.w [!DP_JSLTarget]

 .end
    %ai16()
    %sfxtoggle()
    RTS
}

execute_choice:
{
    ; grab the memory address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_JSLTarget

    ; we either increment or decrement
    LDA !ram_cm_controller : BIT #$0200 : BNE .pressed_left
    ; pressed right
    LDA [!DP_Address] : INC : BRA .bounds_check

  .pressed_left
    LDA [!DP_Address] : DEC

  .bounds_check
    TAX         ; X = new value
    LDY #$0000  ; Y will be set to max
    %a8()

  .loop_choices
    LDA [!DP_CurrentMenu] : %a16() : INC !DP_CurrentMenu : %a8() : CMP #$FF : BEQ .loop_done

  .loop_text
    LDA [!DP_CurrentMenu] : %a16() : INC !DP_CurrentMenu : %a8()
    CMP #$FF : BNE .loop_text
    INY : BRA .loop_choices

  .loop_done
    ; Y = maximum + 2
    ; for convenience so we can use BCS. We do one more DEC in `.set_to_max`
    ; in order to get the actual max.
    DEY

    %a16()
    ; X = new value (might be out of bounds)
    TXA : BMI .set_to_max
    TYA : STA !DP_Maximum
    TXA : CMP !DP_Maximum : BCS .set_to_zero

    BRA .store

  .set_to_zero
    LDA #$0000 : BRA .store

  .set_to_max
    TYA : DEC

  .store
    STA [!DP_Address]

    ; skip if JSL target is zero
    LDA !DP_JSLTarget : BEQ .end

    ; Set return address for indirect JSL
    LDA !ram_cm_menu_bank : STA !DP_JSLTarget+2
    PHK : PEA .end-1

    ; addr in A
    LDA [!DP_Address] : LDX #$0000
    JML.w [!DP_JSLTarget]

  .end
    %ai16()
    %sfxtoggle()
    RTS
}

execute_choice_jsl_text:
{
    ; grab the memory address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_JSLTarget

    ; we either increment or decrement
    LDA !ram_cm_controller : BIT #$0200 : BNE .pressed_left
    ; pressed right
    LDA [!DP_Address] : INC : BRA .bounds_check

  .pressed_left
    LDA [!DP_Address] : DEC

  .bounds_check
    TAX         ; X = new value
    LDY #$0000  ; Y will be set to max

  .loop_jsl_text
    INY : INC !DP_CurrentMenu : INC !DP_CurrentMenu
    LDA [!DP_CurrentMenu] : BNE .loop_jsl_text

  .loop_done
    ; Y = maximum + 1
    ; for convenience so we can use BCS. We do one more DEC in `.set_to_max`
    ; in order to get the actual max.
    INY : DEY

    %a16()
    ; X = new value (might be out of bounds)
    TXA : BMI .set_to_max
    TYA : STA !DP_Maximum
    TXA : CMP !DP_Maximum : BCS .set_to_zero

    BRA .store

  .set_to_zero
    LDA #$0000 : BRA .store

  .set_to_max
    TYA : DEC

  .store
    STA [!DP_Address]

    ; skip if JSL target is zero
    LDA !DP_JSLTarget : BEQ .end

    ; Set return address for indirect JSL
    LDA !ram_cm_menu_bank : STA !DP_JSLTarget+2
    PHK : PEA .end-1

    ; addr in A
    LDA [!DP_Address] : LDX #$0000
    JML.w [!DP_JSLTarget]

  .end
    %ai16()
    %sfxtoggle()
    RTS
}

execute_ctrl_shortcut:
{
    ; < and > should do nothing here
    ; also ignore the input held flag
    LDA !ram_cm_controller : BIT #$0301 : BNE .end

    ; grab shadow address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_CtrlShadow
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_CtrlShadow+2

    ; grab sram address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_CtrlSram
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_CtrlSram+2

    ; press X to delete a shortcut
    LDA !ram_cm_controller : BIT !CTRL_X : BNE .reset_shortcut

    ; enable ctrl mode to edit shortcuts
    LDA #$0001 : STA !ram_cm_ctrl_mode
    LDA #$0000 : STA !ram_cm_ctrl_timer
    RTS

  .reset_shortcut
    LDA.w #!ram_shadow_ctrl_menu : CMP !DP_CtrlShadow : BEQ .end
    %sfxconfirm()

    TDC : STA [!DP_CtrlShadow] : STA [!DP_CtrlSram]

  .end
    RTS
}

execute_controller_input:
{
    ; <, > and X should do nothing here
    ; also ignore input held flag
    LDA !ram_cm_controller : BIT #$0341 : BNE .end

    ; store long address as short address for now
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : INC !DP_CurrentMenu
    STA !ram_cm_ctrl_assign

    ; !DP_JSLTarget = JSL target
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_JSLTarget

    ; Use bank of action_submenu
    ; instead of new menu's bank
    LDA.w #action_submenu>>16 : STA !DP_JSLTarget+2

    ; Set return address for indirect JSL
    PHK : PEA .end-1

    ; Y = Argument
    LDA [!DP_CurrentMenu] : TAY

    LDX #$0000
    JML.w [!DP_JSLTarget]

  .end
    %ai16()
    RTS
}

execute_jsl:
{
    ; <, > and X should do nothing here
    ; also ignore input held flag
    LDA !ram_cm_controller : BIT #$0341 : BNE .end

    ; !DP_JSLTarget = JSL target
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_JSLTarget

    ; Set return address for indirect JSL
    LDA !ram_cm_menu_bank : STA !DP_JSLTarget+2
    PHK : PEA .end-1

    ; Y = Argument
    LDA [!DP_CurrentMenu] : TAY

    LDX #$0000
    JML.w [!DP_JSLTarget]

  .end
    %ai16()
    RTS
}

execute_submenu:
{
    ; <, > and X should do nothing here
    ; also ignore input held flag
    LDA !ram_cm_controller : BIT #$0341 : BNE .end

    ; !DP_JSLTarget = JSL target
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_JSLTarget

    ; Set bank of action_submenu
    ; instead of the new menu's bank
    LDA.w #action_submenu>>16 : STA !DP_JSLTarget+2

    ; Set return address for indirect JSL
    PHK : PEA .end-1

    ; Y = Argument
    LDA [!DP_CurrentMenu] : TAY

    LDX #$0000
    JML.w [!DP_JSLTarget]

  .end
    %ai16()
    RTS
}

execute_dynamic:
{
    ; grab the memory address (long)
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : INC !DP_CurrentMenu : STA !DP_Address
    LDA [!DP_CurrentMenu] : INC !DP_CurrentMenu : STA !DP_Address+2

    ; grab the value at that memory address
    LDA [!DP_Address] : TAX

    ; find the correct item that should be executed (the selected choice)
    BEQ .found

  .loop
    INC !DP_CurrentMenu : INC !DP_CurrentMenu
    DEX : BNE .loop

  .found
    LDA [!DP_CurrentMenu] : BEQ .skip
    STA !DP_CurrentMenu

    ; X = action index (action type)
    LDA [!DP_CurrentMenu] : TAX

    ; !DP_CurrentMenu points to data after the action type index
    INC !DP_CurrentMenu : INC !DP_CurrentMenu

    ; Execute action
    JMP (cm_execute_action_table,X)

  .skip
    RTS
}

print pc, " menu_base bank $89 end"
warnpc $89E000

