lorom

!VERSION_MAJOR = 0
!VERSION_MINOR = 1

incsrc ../resources/macros.asm
incsrc ../resources/crash.asm
incsrc ../resources/reduce_flashing.asm
incsrc ../resources/version_display.asm

!SPACETIME_PRESERVE_INFOHUD = 0
!SPACETIME_PRESERVE_SPRITE_OBJECT_RAM = 1
incsrc ../resources/spacetime.asm

!ALWAYS_DRAW_KILL_COUNTER = 1

; Stores the RAM address of the enemy kill flags
!ram_enemy_kill_flags_front_address = $C1
!ram_enemy_kill_flags_front_bank = $C3
!ram_enemy_kill_flags_back_address = $C4
!ram_enemy_kill_flags_back_bank = $C6

; Temporary variables
!ram_init_enemies_kill_flags = $C7
!ram_init_enemies_kill_bitmask = $C9

; This RAM address is also maintained in SRAM when the game is saved
; It is initialized to 1 and otherwise unused by NTSC
; (also in PAL it only makes a difference if it is 0)
; Thus we can use this to track enemy kills even if you reset and reload from a save
!ram_kill_counter = $09E6

if !ALWAYS_DRAW_KILL_COUNTER
!ram_draw_thousands = $1886
!ram_draw_hundreds = $1888
!ram_draw_tens = $188A
!ram_draw_ones = $188C
endif


org $808000
hook_copy_protection:
    db $FF

org $808262
    LDA #$0004

if !ALWAYS_DRAW_KILL_COUNTER
org $80A0A3
    JSL load_kill_counter
endif

org $80FFD8
hook_sram_size:
    db $04 ; 16kb


org $818010
    JMP save_kills

org $818094
    JMP load_kills

org $81B3B3
    TDC : TAX
new_save_loop:
    STA $7ECD52,X
    STA $7EF4A0,X
    INX : INX
    CPX #$0700 : BMI new_save_loop

org $81F000
print pc, " you_only_live_once bank $81 start"

save_kills:
{
    ASL : STA $12
    ASL : ASL : XBA : TAX
    LDY #$F4A0
  .loop
    LDA $0000,Y : STA $702000,X
    INX : INX : INY : INY
    CPY #$F978 : BMI .loop
    JMP $8013
}

load_kills:
{
    ASL : STA $12
    ASL : ASL : XBA : TAX
    LDY #$F4A0
  .loop
    LDA $702000,X : STA $0000,Y
    INX : INX : INY : INY
    CPY #$F978 : BMI .loop
    LDX $12
    JMP $8098
}

if !ALWAYS_DRAW_KILL_COUNTER
load_kill_counter:
{
    TDC : STA !ram_draw_ones : STA !ram_draw_tens
    STA !ram_draw_hundreds : STA !ram_draw_thousands
    LDA !ram_kill_counter
    DEC : BEQ .done
    STA $4204
    %a8()
    LDA #$0A : STA $4206
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : PHA ; tens
    LDA $4216 : ASL : STA !ram_draw_ones
    PLA : BEQ .done
    STA $4204
    %a8()
    LDA #$0A : STA $4206
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : PHA ; hundreds
    LDA $4216 : ASL : STA !ram_draw_tens
    PLA : BEQ .done
    STA $4204
    %a8()
    LDA #$0A : STA $4206
    %a16()
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : ASL : STA !ram_draw_thousands
    LDA $4216 : ASL : STA !ram_draw_hundreds
  .done
    JML $82E76B
}
endif

print pc, " you_only_live_once bank $81 end"


org $82EEDF
    LDA #$C100


org $86EF23
    NOP : NOP : NOP


org $8C9607
zebes_planet_tile_data:
    dw #$0E2F


if !ALWAYS_DRAW_KILL_COUNTER
org $90E6C0
	 JSR ih_draw_counter
endif


org $90FC00
print pc, " you_only_live_once bank $90 start"

OffsetHexToNumber:
    dw #$0C09, #$0C00, #$0C01, #$0C02, #$0C03, #$0C04, #$0C05, #$0C06, #$0C07, #$0C08

if !ALWAYS_DRAW_KILL_COUNTER
ih_draw_counter:
{
    LDX !ram_draw_ones
    LDA OffsetHexToNumber,X : STA $7EC6B8
    LDX !ram_draw_tens
    LDA OffsetHexToNumber,X : STA $7EC6B6
    LDX !ram_draw_hundreds
    LDA OffsetHexToNumber,X : STA $7EC6B4
    LDX !ram_draw_thousands
    LDA OffsetHexToNumber,X : STA $7EC6B2

  .end
    JMP $DCDD
}
endif

print pc, " you_only_live_once bank $90 end"


org $A08AE1
    JMP init_enemies

org $A08BCC
    JMP init_enemies_next

org $A08EED
    JMP delete_enemy

org $A08F8C
    JMP delete_enemy_offscreen

org $A0923D
    JMP delete_rinka

org $A0A3EE
    JMP enemy_death

org $A0A43F
    JMP rinka_death

org $A0F800
print pc, " you_only_live_once bank $A0 start"

init_enemies:
{
    LDA #$7E7E
    STA !ram_enemy_kill_flags_front_bank
    STA !ram_enemy_kill_flags_back_bank
    LDA.l $B80000,X
    STA !ram_enemy_kill_flags_front_address
    INC : INC : STA !ram_enemy_kill_flags_back_address
    LDA.l $A10000,X : CMP #$FFFF : BNE .start
    JMP $8BE6
  .start
    LDA [!ram_enemy_kill_flags_front_address] : STA !ram_init_enemies_kill_flags
    STZ $0E48 : TDC : TAY : INC : STA !ram_init_enemies_kill_bitmask
  .loop
    LDA !ram_init_enemies_kill_flags : BIT !ram_init_enemies_kill_bitmask : BNE .dead
    JMP $8AF3
  .dead
    TYA : CLC : ADC #$0040 : TAY
    TXA : CLC : ADC #$0010 : TAX
    LDA.l $A10000,X : CMP #$FFFF : BEQ .done
  .next
    CPY #$0400 : BNE .increment_flag
    LDA [!ram_enemy_kill_flags_back_address] : STA !ram_init_enemies_kill_flags
    LDA #$0001 : STA !ram_init_enemies_kill_bitmask
    BRA .loop
  .increment_flag
    LDA !ram_init_enemies_kill_bitmask : ASL : STA !ram_init_enemies_kill_bitmask
    BRA .loop
  .done
    JMP $8BCF
}

delete_enemy:
{
    STZ $0F78,X
    INC !ram_kill_counter
if !ALWAYS_DRAW_KILL_COUNTER
    JSR update_draw_values
endif
    LDA.l EnemyIndexToBit,X : STA !ram_init_enemies_kill_bitmask
    CPX #$0400 : BPL .back_half
    LDA [!ram_enemy_kill_flags_front_address]
    ORA !ram_init_enemies_kill_bitmask
    STA [!ram_enemy_kill_flags_front_address]
    JMP $8F54
  .back_half
    LDA [!ram_enemy_kill_flags_back_address]
    ORA !ram_init_enemies_kill_bitmask
    STA [!ram_enemy_kill_flags_back_address]
    JMP $8F54
}

delete_enemy_offscreen:
{
    STZ $0F78,X
    INC !ram_kill_counter
if !ALWAYS_DRAW_KILL_COUNTER
    JSR update_draw_values
endif
    LDA.l EnemyIndexToBit,X : STA !ram_init_enemies_kill_bitmask
    CPX #$0400 : BPL .back_half
    LDA [!ram_enemy_kill_flags_front_address]
    ORA !ram_init_enemies_kill_bitmask
    STA [!ram_enemy_kill_flags_front_address]
    JMP $8FB4
  .back_half
    LDA [!ram_enemy_kill_flags_back_address]
    ORA !ram_init_enemies_kill_bitmask
    STA [!ram_enemy_kill_flags_back_address]
    JMP $8FB4
}

delete_rinka:
{
    STZ $0F78,X
    INC !ram_kill_counter
if !ALWAYS_DRAW_KILL_COUNTER
    JSR update_draw_values
endif
    LDA.l EnemyIndexToBit,X : STA !ram_init_enemies_kill_bitmask
    CPX #$0400 : BPL .back_half
    LDA [!ram_enemy_kill_flags_front_address]
    ORA !ram_init_enemies_kill_bitmask
    STA [!ram_enemy_kill_flags_front_address]
    JMP $9240
  .back_half
    LDA [!ram_enemy_kill_flags_back_address]
    ORA !ram_init_enemies_kill_bitmask
    STA [!ram_enemy_kill_flags_back_address]
    JMP $9240
}

enemy_death:
{
    INC !ram_kill_counter
if !ALWAYS_DRAW_KILL_COUNTER
    JSR update_draw_values
endif
    LDA.l EnemyIndexToBit,X : STA !ram_init_enemies_kill_bitmask
    CPX #$0400 : BPL .back_half
    LDA [!ram_enemy_kill_flags_front_address]
    ORA !ram_init_enemies_kill_bitmask
    STA [!ram_enemy_kill_flags_front_address]
  .front_loop
    STZ $0F78,X
    INX : INX
    DEY : DEY : BPL .front_loop
    INC $0E50
    PLB : PLP : RTL
  .back_half
    LDA [!ram_enemy_kill_flags_back_address]
    ORA !ram_init_enemies_kill_bitmask
    STA [!ram_enemy_kill_flags_back_address]
  .back_loop
    STZ $0F78,X
    INX : INX
    DEY : DEY : BPL .back_loop
    INC $0E50
    PLB : PLP : RTL
}

rinka_death:
{
    INC !ram_kill_counter
if !ALWAYS_DRAW_KILL_COUNTER
    JSR update_draw_values
endif
    LDA.l EnemyIndexToBit,X : STA !ram_init_enemies_kill_bitmask
    CPX #$0400 : BPL .back_half
    LDA [!ram_enemy_kill_flags_front_address]
    ORA !ram_init_enemies_kill_bitmask
    STA [!ram_enemy_kill_flags_front_address]
  .front_loop
    STZ $0F78,X
    INX : INX
    DEY : DEY : BPL .front_loop
    PLB : PLP : RTL
  .back_half
    LDA [!ram_enemy_kill_flags_back_address]
    ORA !ram_init_enemies_kill_bitmask
    STA [!ram_enemy_kill_flags_back_address]
  .back_loop
    STZ $0F78,X
    INX : INX
    DEY : DEY : BPL .back_loop
    PLB : PLP : RTL
}

if !ALWAYS_DRAW_KILL_COUNTER
update_draw_values:
{
    LDA !ram_draw_ones : CMP #$0012 : BEQ .inc_tens
    INC : INC : STA !ram_draw_ones
    BRA .done_inc
  .inc_tens
    LDA !ram_draw_tens : CMP #$0012 : BEQ .inc_hundreds
    INC : INC : STA !ram_draw_tens
    TDC : STA !ram_draw_ones
    BRA .done_inc
  .inc_hundreds
    LDA !ram_draw_hundreds : CMP #$0012 : BEQ .inc_thousands
    INC : INC : STA !ram_draw_hundreds
    TDC : STA !ram_draw_tens : STA !ram_draw_ones
    BRA .done_inc
  .inc_thousands
    LDA !ram_draw_thousands : CMP #$0012 : BEQ .done_inc
    INC : INC : STA !ram_draw_thousands
    TDC : STA !ram_draw_hundreds : STA !ram_draw_tens : STA !ram_draw_ones
  .done_inc
    RTS
}
endif

print pc, " you_only_live_once bank $A0 end"


; Enemy population indices
org $B88000
print pc, " you_only_live_once bank $B8 start"

    dw $F4A0
org $B88002
    dw $F4A4
org $B880D5
    dw $F4A8
org $B88108
    dw $F4AC
org $B8819B
    dw $F4B0
org $B881FE
    dw $F4B4
org $B88261
    dw $F4B8
org $B88364
    dw $F4BC
org $B88427
    dw $F4C0
org $B8847A
    dw $F4C4
org $B884ED
    dw $F4C8
org $B88500
    dw $F4CC
org $B88573
    dw $F4D0
org $B88586
    dw $F4D4
org $B885A9
    dw $F4D8
org $B885AC
    dw $F4DC
org $B885AF
    dw $F4E0
org $B885B2
    dw $F4E4
org $B885D5
    dw $F4E8
org $B885D8
    dw $F4EC
org $B885DB
    dw $F4F0
org $B885DE
    dw $F4F4
org $B885E1
    dw $F4F8
org $B88684
    dw $F4FC
org $B886F7
    dw $F500
org $B886FA
    dw $F504
org $B8883D
    dw $F508
org $B88870
    dw $F50C
org $B888B3
    dw $F510
org $B888B6
    dw $F514
org $B888C9
    dw $F518
org $B8897C
    dw $F51C
org $B889DF
    dw $F520
org $B889F2
    dw $F524
org $B88A15
    dw $F528
org $B88AB8
    dw $F52C
org $B88B3B
    dw $F530
org $B88B3E
    dw $F534
org $B88B61
    dw $F538
org $B88B74
    dw $F53C
org $B88B87
    dw $F540
org $B88BCA
    dw $F544
org $B88C0D
    dw $F548
org $B88DA0
    dw $F54C
org $B88ED3
    dw $F550
org $B88F16
    dw $F554
org $B88F19
    dw $F558
org $B88F7C
    dw $F55C
org $B88FBF
    dw $F560
org $B88FC2
    dw $F564
org $B88FC5
    dw $F568
org $B89028
    dw $F56C
org $B8902B
    dw $F570
org $B8902E
    dw $F574
org $B89081
    dw $F578
org $B890C4
    dw $F57C
org $B890C7
    dw $F580
org $B8911A
    dw $F584
org $B8918D
    dw $F588
org $B89200
    dw $F58C
org $B892A3
    dw $F590
org $B89326
    dw $F594
org $B893A9
    dw $F598
org $B893AC
    dw $F59C
org $B8941F
    dw $F5A0
org $B89452
    dw $F5A4
org $B89505
    dw $F5A8
org $B89538
    dw $F5AC
org $B8953B
    dw $F5B0
org $B8953E
    dw $F5B4
org $B895E1
    dw $F5B8
org $B895E4
    dw $F5BC
org $B89617
    dw $F5C0
org $B8961A
    dw $F5C4
org $B8961D
    dw $F5C8
org $B89660
    dw $F5CC
org $B89663
    dw $F5D0
org $B89666
    dw $F5D4
org $B89669
    dw $F5D8
org $B8966C
    dw $F5DC
org $B8966F
    dw $F5E0
org $B896E2
    dw $F5E4
org $B89735
    dw $F5E8
org $B89778
    dw $F5EC
org $B897FB
    dw $F5F0
org $B8988E
    dw $F5F4
org $B898D1
    dw $F5F8
org $B898E4
    dw $F5FC
org $B898F7
    dw $F600
org $B8997A
    dw $F604
org $B89A2D
    dw $F608
org $B89A40
    dw $F60C
org $B89B13
    dw $F610
org $B89BC6
    dw $F614
org $B89CB9
    dw $F618
org $B89D5C
    dw $F61C
org $B89E2F
    dw $F620
org $B89EB2
    dw $F624
org $B89EB5
    dw $F628
org $B89F38
    dw $F62C
org $B89F3B
    dw $F630
org $B89F5E
    dw $F634
org $B89F61
    dw $F638
org $B89FA4
    dw $F63C
org $B8A057
    dw $F640
org $B8A0BA
    dw $F644
org $B8A0FD
    dw $F648
org $B8A110
    dw $F64C
org $B8A133
    dw $F650
org $B8A1D6
    dw $F654
org $B8A219
    dw $F658
org $B8A23C
    dw $F65C
org $B8A2DF
    dw $F660
org $B8A332
    dw $F664
org $B8A3F5
    dw $F668
org $B8A428
    dw $F66C
org $B8A48B
    dw $F670
org $B8A4EE
    dw $F674
org $B8A4F1
    dw $F678
org $B8A544
    dw $F67C
org $B8A557
    dw $F680
org $B8A55A
    dw $F684
org $B8A55D
    dw $F688
org $B8A560
    dw $F68C
org $B8A623
    dw $F690
org $B8A626
    dw $F694
org $B8A639
    dw $F698
org $B8A63C
    dw $F69C
org $B8A63F
    dw $F6A0
org $B8A642
    dw $F6A4
org $B8A645
    dw $F6A8
org $B8A6A8
    dw $F6AC
org $B8A7BB
    dw $F6B0
org $B8A82E
    dw $F6B4
org $B8A8E1
    dw $F6B8
org $B8A964
    dw $F6BC
org $B8A967
    dw $F6C0
org $B8A9DA
    dw $F6C4
org $B8AA8D
    dw $F6C8
org $B8AB80
    dw $F6CC
org $B8AC53
    dw $F6D0
org $B8AD06
    dw $F6D4
org $B8AD09
    dw $F6D8
org $B8AD6C
    dw $F6DC
org $B8AD8F
    dw $F6E0
org $B8AE52
    dw $F6E4
org $B8AEA5
    dw $F6E8
org $B8AEA8
    dw $F6EC
org $B8AEAB
    dw $F6F0
org $B8AEAE
    dw $F6F4
org $B8AEB1
    dw $F6F8
org $B8AEF4
    dw $F6FC
org $B8AF87
    dw $F700
org $B8AFEA
    dw $F704
org $B8B11D
    dw $F708
org $B8B1F0
    dw $F70C
org $B8B1F3
    dw $F710
org $B8B1F6
    dw $F714
org $B8B259
    dw $F718
org $B8B32C
    dw $F71C
org $B8B3BF
    dw $F720
org $B8B3C2
    dw $F724
org $B8B3C5
    dw $F728
org $B8B3D8
    dw $F72C
org $B8B45B
    dw $F730
org $B8B48E
    dw $F734
org $B8B4D1
    dw $F738
org $B8B544
    dw $F73C
org $B8B5E7
    dw $F740
org $B8B67A
    dw $F744
org $B8B6AD
    dw $F748
org $B8B720
    dw $F74C
org $B8B733
    dw $F750
org $B8B766
    dw $F754
org $B8B769
    dw $F758
org $B8B81C
    dw $F75C
org $B8B88F
    dw $F760
org $B8B912
    dw $F764
org $B8B995
    dw $F768
org $B8B9D8
    dw $F76C
org $B8BA4B
    dw $F770
org $B8BB0E
    dw $F774
org $B8BB31
    dw $F778
org $B8BB34
    dw $F77C
org $B8BBD7
    dw $F780
org $B8BC3A
    dw $F784
org $B8BC4D
    dw $F788
org $B8BCA0
    dw $F78C
org $B8BE93
    dw $F790
org $B8BFE6
    dw $F794
org $B8C139
    dw $F798
org $B8C19C
    dw $F79C
org $B8C19F
    dw $F7A0
org $B8C1A2
    dw $F7A4
org $B8C1A5
    dw $F7A8
org $B8C1A8
    dw $F7AC
org $B8C1AB
    dw $F7B0
org $B8C1AE
    dw $F7B4
org $B8C1E1
    dw $F7B8
org $B8C1E4
    dw $F7BC
org $B8C1E7
    dw $F7C0
org $B8C1EA
    dw $F7C4
org $B8C1ED
    dw $F7C8
org $B8C280
    dw $F7CC
org $B8C283
    dw $F7D0
org $B8C3E6
    dw $F7D4
org $B8C5E9
    dw $F7D8
org $B8C69C
    dw $F7DC
org $B8C69F
    dw $F7E0
org $B8C6F2
    dw $F7E4
org $B8C8C5
    dw $F7E8
org $B8CA78
    dw $F7EC
org $B8CB3B
    dw $F7F0
org $B8CBAE
    dw $F7F4
org $B8CC51
    dw $F7F8
org $B8CCD4
    dw $F7FC
org $B8CD17
    dw $F800
org $B8CE6A
    dw $F804
org $B8CF2D
    dw $F808
org $B8CF90
    dw $F80C
org $B8CFC3
    dw $F810
org $B8D006
    dw $F814
org $B8D089
    dw $F818
org $B8D10C
    dw $F81C
org $B8D10F
    dw $F820
org $B8D112
    dw $F824
org $B8D1B5
    dw $F828
org $B8D1B8
    dw $F82C
org $B8D1BB
    dw $F830
org $B8D1EE
    dw $F834
org $B8D281
    dw $F838
org $B8D314
    dw $F83C
org $B8D357
    dw $F840
org $B8D3AA
    dw $F844
org $B8D3ED
    dw $F848
org $B8D450
    dw $F84C
org $B8D453
    dw $F850
org $B8D526
    dw $F854
org $B8D529
    dw $F858
org $B8D53C
    dw $F85C
org $B8D53F
    dw $F860
org $B8D5E2
    dw $F864
org $B8D635
    dw $F868
org $B8D698
    dw $F86C
org $B8D75B
    dw $F870
org $B8D7EE
    dw $F874
org $B8D801
    dw $F878
org $B8D864
    dw $F87C
org $B8D957
    dw $F880
org $B8DA0A
    dw $F884
org $B8DA3D
    dw $F888
org $B8DAD0
    dw $F88C
org $B8DAD3
    dw $F890
org $B8DB66
    dw $F894
org $B8DBD9
    dw $F898
org $B8DC3C
    dw $F89C
org $B8DC6F
    dw $F8A0
org $B8DCE2
    dw $F8A4
org $B8DD35
    dw $F8A8
org $B8DD38
    dw $F8AC
org $B8DD9B
    dw $F8B0
org $B8DE0E
    dw $F8B4
org $B8DE11
    dw $F8B8
org $B8DE14
    dw $F8BC
org $B8DE17
    dw $F8C0
org $B8DE5A
    dw $F8C4
org $B8DE6D
    dw $F8C8
org $B8DF30
    dw $F8CC
org $B8DF63
    dw $F8D0
org $B8DF96
    dw $F8D4
org $B8DFD9
    dw $F8D8
org $B8E01C
    dw $F8DC
org $B8E07F
    dw $F8E0
org $B8E102
    dw $F8E4
org $B8E1D5
    dw $F8E8
org $B8E1D8
    dw $F8EC
org $B8E25B
    dw $F8F0
org $B8E26E
    dw $F8F4
org $B8E321
    dw $F8F8
org $B8E384
    dw $F8FC
org $B8E387
    dw $F900
org $B8E3AA
    dw $F904
org $B8E42D
    dw $F908
org $B8E440
    dw $F90C
org $B8E4A3
    dw $F910
org $B8E516
    dw $F914
org $B8E559
    dw $F918
org $B8E59C
    dw $F91C
org $B8E5BF
    dw $F920
org $B8E652
    dw $F924
org $B8E695
    dw $F928
org $B8E708
    dw $F92C
org $B8E70B
    dw $F930
org $B8E70E
    dw $F934
org $B8E791
    dw $F938
org $B8E794
    dw $F93C
org $B8E857
    dw $F940
org $B8E88A
    dw $F944
org $B8E8AD
    dw $F948
org $B8E8D0
    dw $F94C
org $B8E8F3
    dw $F950
org $B8E916
    dw $F954
org $B8E939
    dw $F958
org $B8E95C
    dw $F95C
org $B8EA2F
    dw $F960
org $B8EB02
    dw $F964
org $B8EB75
    dw $F968
org $B8EB98
    dw $F96C
org $B8EBBB
    dw $F970
org $B8EBCE
    dw $F974

org $B8F000
EnemyIndexToBit:
    dw $0001
org $B8F040
    dw $0002
org $B8F080
    dw $0004
org $B8F0C0
    dw $0008
org $B8F100
    dw $0010
org $B8F140
    dw $0020
org $B8F180
    dw $0040
org $B8F1C0
    dw $0080
org $B8F200
    dw $0100
org $B8F240
    dw $0200
org $B8F280
    dw $0400
org $B8F2C0
    dw $0800
org $B8F300
    dw $1000
org $B8F340
    dw $2000
org $B8F380
    dw $4000
org $B8F3C0
    dw $8000
org $B8F400
    dw $0001
org $B8F440
    dw $0002
org $B8F480
    dw $0004
org $B8F4C0
    dw $0008
org $B8F500
    dw $0010
org $B8F540
    dw $0020
org $B8F580
    dw $0040
org $B8F5C0
    dw $0080
org $B8F600
    dw $0100
org $B8F640
    dw $0200
org $B8F680
    dw $0400
org $B8F6C0
    dw $0800
org $B8F700
    dw $1000
org $B8F740
    dw $2000
org $B8F780
    dw $4000
org $B8F7C0
    dw $8000

print pc, " you_only_live_once bank $B8 end"

