
org $9181B0
    JSL hook_spin_lock



org $859800
print pc, " spin_lock bank $85 start"

hook_spin_lock:
{
    LDA !ram_spin_lock : BEQ .skip
    LDA $0A1F : AND #$00FF
    CMP #$0003  ; spin-jumping movement type
    BEQ .disable_up_down
    CMP #$0014  ; wall-jumping movement type
    BNE .skip

  .disable_up_down:
    ; Override up/down inputs to be treated as not held
    LDA $14 : ORA #$0C00 : STA $14

    ; Override up/down inputs to be treated as not newly pressed
    LDA $12 : ORA #$0C00 : LDA $12

  .skip:
    ; run hi-jacked instructions
    LDA $0A1C : ASL
    RTL
}

print pc, " spin_lock bank $85 end"
warnpc $859880

