lorom

; This RAM address is also maintained in SRAM when the game is saved
; It is initialized to 1 and otherwise unused by NTSC
; (also in PAL it only makes a difference if it is 0)
; Thus we can use this to track drops even if you reset and reload from a save
;
; For efficiency, the counter will be used as a direct index to the number table,
; which means we increment it by two each time a drop is collected,
; and we max out the counter at 199 (index to number 99) since we only draw two digits
!ram_drop_counter = $09E6

; Bank 90 logic
org $90B8C2       ; hijack, fire uncharged beam
    JSR ih_fire_beam

org $90B9B9       ; hijack, fire charged beam
    JSR ih_fire_beam

org $90BCF0       ; hijack, fire hyper beam
    JSR ih_fire_beam

org $90E6C0       ; hijack, handle HUD specific behaviour and projectiles
	 JSR ih_draw_counter



; Bank 90 freespace
org $90F700
print pc, " bsc_2digits bank $90 start"

ih_fire_beam:
{
    LDA !ram_drop_counter : CMP #$00C7 : BPL .end
    INC : INC : STA !ram_drop_counter

  .end
    LDA #$000A    ; overwritten code
    RTS
}

ih_draw_counter:
{
    LDX !ram_drop_counter
    LDA OffsetHexToTensDigit,X : STA $7EC6B2
    LDA OffsetHexToOnesDigit,X : STA $7EC6B4

  .end
    JMP $DCDD     ; overwritten code
}

OffsetHexToTensDigit:
    db #$00
    dw #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F, #$2C0F
    dw #$0C00, #$0C00, #$0C00, #$0C00, #$0C00, #$0C00, #$0C00, #$0C00, #$0C00, #$0C00
    dw #$0C01, #$0C01, #$0C01, #$0C01, #$0C01, #$0C01, #$0C01, #$0C01, #$0C01, #$0C01
    dw #$0C02, #$0C02, #$0C02, #$0C02, #$0C02, #$0C02, #$0C02, #$0C02, #$0C02, #$0C02
    dw #$0C03, #$0C03, #$0C03, #$0C03, #$0C03, #$0C03, #$0C03, #$0C03, #$0C03, #$0C03
    dw #$0C04, #$0C04, #$0C04, #$0C04, #$0C04, #$0C04, #$0C04, #$0C04, #$0C04, #$0C04
    dw #$0C05, #$0C05, #$0C05, #$0C05, #$0C05, #$0C05, #$0C05, #$0C05, #$0C05, #$0C05
    dw #$0C06, #$0C06, #$0C06, #$0C06, #$0C06, #$0C06, #$0C06, #$0C06, #$0C06, #$0C06
    dw #$0C07, #$0C07, #$0C07, #$0C07, #$0C07, #$0C07, #$0C07, #$0C07, #$0C07, #$0C07
    dw #$0C08, #$0C08, #$0C08, #$0C08, #$0C08, #$0C08, #$0C08, #$0C08, #$0C08, #$0C08

OffsetHexToOnesDigit:
    db #$00
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08

print pc, " bsc_2digits bank $90 end"

