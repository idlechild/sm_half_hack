
org $8BFE00
print pc, " decompression bank $8B start"

; Decompression optimization adapted from Kejardon, with fixes by PJBoy and Maddo
; Compression format: One byte (XXX YYYYY) or two byte (111 XXX YY-YYYYYYYY) headers
; XXX = instruction, YYYYYYYYYY = counter
optimized_decompression_end:
{
    PLB : PLP
    RTL
}

optimized_decompression:
{
    PHP : %a8() : %i16()
    ; Set bank
    PHB : LDA $49 : PHA : PLB

    STZ $50 : LDY #$0000

  .nextByte
    LDA ($47)
    INC $47 : BNE .readCommand
    INC $48 : BNE .readCommand
    JSR decompression_increment_bank
  .readCommand
    STA $4A
    CMP #$FF : BEQ optimized_decompression_end
    CMP #$E0 : BCC .oneByteCommand

    ; Two byte command
    ASL : ASL : ASL
    AND #$E0 : PHA
    LDA $4A : AND #$03 : XBA

    LDA ($47)
    INC $47 : BNE .readData
    INC $48 : BNE .readData
    JSR decompression_increment_bank
    BRA .readData

  .oneByteCommand
    AND #$E0 : PHA
    TDC : LDA $4A : AND #$1F

  .readData
    TAX : INX : PLA
    BMI .option4567 : BEQ .option0
    CMP #$20 : BEQ .option1
    CMP #$40 : BEQ .option2
    BRL .option3

  .option0:
    ; Option X = 0: Directly copy Y bytes
    LDA ($47)
    INC $47 : BNE .option0_copy
    INC $48 : BNE .option0_copy
    JSR decompression_increment_bank
  .option0_copy
    STA [$4C],Y
    INY : DEX : BNE .option0
    BRL .nextByte

  .option1:
    ; Option X = 1: Copy the next byte Y times
    LDA ($47)
    INC $47 : BNE .option1_copy
    INC $48 : BNE .option1_copy
    JSR decompression_increment_bank
  .option1_copy
    STA [$4C],Y
    INY : DEX : BNE .option1_copy
    BRL .nextByte

  .option2:
    ; Option X = 2: Copy the next two bytes, one at a time, for the next Y bytes
    ; Apply PJ's fix to divide X by 2 and set carry if X was odd
    REP #$20 : TXA : LSR : TAX : SEP #$20
    LDA ($47)
    INC $47 : BNE .option2_readMSB
    INC $48 : BNE .option2_readMSB
    JSR decompression_increment_bank
  .option2_readMSB
    XBA : LDA ($47)
    INC $47 : BNE .option2_prepCopy
    INC $48 : BNE .option2_prepCopy
    JSR decompression_increment_bank
  .option2_prepCopy
    XBA
    ; Apply Maddo's fix accounting for single copy (X = 1 before divide by 2)
    INX : DEX : BEQ .option2_singleCopy
    REP #$20
  .option2_loop
    STA [$4C],Y
    INY : INY : DEX : BNE .option2_loop
    ; PJ's fix to account for case where X was odd
    SEP #$20
  .option2_singleCopy
    BCC .option2_end
    STA [$4C],Y : INY
  .option2_end
    BRL .nextByte

  .option4567:
    CMP #$C0 : AND #$20 : STA $4F : BCS .option67

    ; Option X = 4: Copy Y bytes starting from a given address in the decompressed data
    ; Option X = 5: Copy and invert (EOR #$FF) Y bytes starting from a given address in the decompressed data
    LDA ($47)
    INC $47 : BNE .option45_readMSB
    INC $48 : BNE .option45_readMSB
    JSR decompression_increment_bank
  .option45_readMSB
    XBA : LDA ($47)
    INC $47 : BNE .option45_prepDictionary
    INC $48 : BNE .option45_prepDictionary
    JSR decompression_increment_bank
  .option45_prepDictionary
    XBA : REP #$21
    ADC $4C : STY $44 : SEC

  .option_dictionary
    SBC $44 : STA $44
    SEP #$20
    LDA $4E : BCS .skip_carrySubtraction
    DEC
  .skip_carrySubtraction
    STA $46
    LDA $4F : BNE .option57_loop

  .option46_loop
    LDA [$44],Y
    STA [$4C],Y
    INY : DEX : BNE .option46_loop
    BRL .nextByte

  .option57_loop
    LDA [$44],Y
    EOR #$FF
    STA [$4C],Y
    INY : DEX : BNE .option57_loop
    BRL .nextByte

  .option67
    ; Option X = 6: Copy Y bytes starting from a given number of bytes ago in the decompressed data
    ; Option X = 7: Copy and invert (EOR #$FF) Y bytes starting from a given number of bytes ago in the decompressed data
    TDC : LDA ($47)
    INC $47 : BNE .option67_prepDictionary
    INC $48 : BNE .option67_prepDictionary
    JSR decompression_increment_bank
  .option67_prepDictionary
    REP #$20
    STA $44 : LDA $4C
    BRA .option_dictionary

  .option3
    ; Option X = 3: Incrementing fill Y bytes starting with next byte
    LDA ($47)
    INC $47 : BNE .option3_loop
    INC $48 : BNE .option3_loop
    JSR decompression_increment_bank
  .option3_loop
    STA [$4C],Y
    INC : INY : DEX : BNE .option3_loop
    BRL .nextByte
}

decompression_increment_bank:
{
    PHA
    PHB : PLA
    INC
    PHA : PLB
    LDA #$80 : STA $48
    PLA
    RTS
}

print pc, " decompression bank $8B end"

