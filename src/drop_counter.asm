lorom

; This RAM address is also maintained in SRAM when the game is saved
; It is initialized to 1 and otherwise unused by NTSC
; (also in PAL it only makes a difference if it is 0)
; Thus we can use this to track drops even if you reset and reload from a save
;
; For efficiency, the counter will be used as a direct index to the number table,
; which means we increment it by two each time a drop is collected,
; and we max out the counter at 19 (index to number 9) since we only draw a single digit
!ram_drop_counter = $09E6

; Bank 86 logic
org $86F027       ; hijack, collect drops using grapple
    JSR ih_collect_drop

org $86F08E       ; hijack, collect drops normally
    JSR ih_collect_drop



; Bank 86 freespace
org $86F500
print pc, " drop_counter bank $86 start"

ih_collect_drop:
{
    LDA !ram_drop_counter : CMP #$0013 : BPL .end
    INC : INC : STA !ram_drop_counter

  .end
    JMP ($F0AD,X) ; overwritten code
}

print pc, " drop_counter bank $86 end"



; Bank 90 logic
org $90E6C0       ; hijack, handle HUD specific behaviour and projectiles
	 JSR ih_draw_counter



; Bank 90 freespace
org $90F700
print pc, " drop_counter bank $90 start"

ih_draw_counter:
{
    LDX !ram_drop_counter
    LDA OffsetHexToNumber,X : STA $7EC6B4

  .end
    JMP $DCDD     ; overwritten code
}

OffsetHexToNumber:
    db #$00
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08

print pc, " drop_counter bank $90 end"

