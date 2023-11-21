
; Shinesparks no longer drain energy
org $90D0C9 ; vertical
    CMP #$0001
    BMI $08
    LDA $09C2

org $90D0F8 ; diagonal
    CMP #$0001
    BMI $08
    LDA $09C2

org $90D124 ; horizontal
    CMP #$0001
    BMI $08
    LDA $09C2

; Shinesparks no longer have a minimum health
org $90D2BD
    CMP #$0001

; Skip echo "swirl" animation before they get sent off
org $90D396
    BRA $27

; Timer for shinespark crash, $0AA2
org $90D3E3
    LDA #$0001

; "Super jump timer" during crash animation
org $90D3F3
    LDA #$0001

; hijack, runs on gamestate = 08 (main gameplay), handles most updating HUD information
org $90E6AA
    JSL ih_room_timer_code : NOP : NOP



; Main bank stuff
org $DFE000
print pc, " eternal spikesuit bank $DF start"

ih_room_timer_code:
{
    PHA

    ; spike suit per frame
    LDA #$0001
    STA $0A68

    PLA
    ; overwritten code
    STZ $0A30
    STZ $0A32
    RTL
}

print pc, " eternal spikesuit bank $DF end"

