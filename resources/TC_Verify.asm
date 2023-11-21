
; Super Metroid
; True Completion Verification Hack

pushtable

table HUDfont.tbl

!ram_MissingTiles = $0A02
!ram_RidleyDefeated = $7ED910
!ram_RidleyMapExplored = $7ED912
!ram_FailAddress = $7ED824
!ram_FailValue = $7ED826


; Hijack ship function for final verification
org $A2AA56
    JMP VerifyTrueCompletion

; Hijack Ridley function when Baby Metroid dropped
org $A6A709
    JMP CeresRidleyDefeated

; Hijack Ceres elevator to check for Ridley's map tile
org $89AD0A
    JSL VerifyCeresRidleyMap


org $A2F500
print pc, " TC_Verify bank $A2 start"

VerifyTrueCompletion:
{
    ; check if Zebes timebomb set
    LDA $7ED821 : BIT #$0040 : BNE .verify_map
    ; overwritten code
    LDA #$AA5D : STA $0FB2,X
    RTL

  .verify_map
    JSR VerifyMapTiles
    BCS .verify_ceres_ridley
    ; failed map tile check
    ; was it even close?
    LDA !ram_MissingTiles : CMP #$0064 : BPL .ignore
    LDY #$0000
    JSR DrawHUD
    JSR DrawMissingTiles

  .ignore
    ; overwritten code
    LDX #$0000 : TXY
    LDA #$AA5D : STA $0FB2,X
    RTL

  .verify_ceres_ridley
    LDA !ram_RidleyDefeated : CMP #$DEAD : BEQ .verify_events
    ; failed Ceres Ridley check
    LDY #$0002
    ; check if we have passed anything else
    JSR VerifyEvents : BCS .draw
    JSR VerifyMapStations : BCS .draw
    JSR VerifyDoors : BCS .draw
    JSR VerifyItems : BCS .draw
    ; if we haven't, then we have a succesful map only run
    LDY #$000E
    BRA .draw

  .verify_events
    JSR VerifyEvents
    BCS .verify_map_stations
    ; failed events check
    LDY #$0004 : BRA .draw

  .verify_map_stations
    JSR VerifyMapStations
    BCS .verify_doors
    ; failed map station check
    LDY #$0006 : BRA .draw

  .verify_doors
    JSR VerifyDoors
    BCS .verify_items
    ; failed door check
    LDY #$0008 : BRA .draw

  .verify_items
    JSR VerifyItems
    BCS .checks_passed
    ; failed item collection check
    LDY #$000A : BRA .draw

  .checks_passed
    LDY #$000C

  .draw
    JSR DrawHUD
    ; overwritten code
    LDX #$0000 : TXY
    LDA #$AA5D : STA $0FB2,X
    RTL
}

VerifyMapTiles:
{
    LDA #$0000 : STA !ram_MissingTiles

    ; verify Ceres Ridley map tile explored
    LDA !ram_RidleyMapExplored : BNE .verify_current
    INC !ram_MissingTiles

  .verify_current
    ; verify current area (first 80 bytes)
    LDX #$07F7 : LDY #$0000
  .loop_current
    LDA $7E0000,X : CMP.w Verified_CurrentMapTiles,Y : BNE .failed_current
    INY #2
    INX #2 : CPX #$08B7 : BMI .loop_current

    ; verify saved areas (excluding some unused bytes and crateria)
    LDX #$CE52 : LDY #$0000
  .loop_saved
    LDA $7E0000,X : CMP.w Verified_MapTiles,Y : BNE .failed_saved
    INY #2
    INX #2 : CPX #$D2B2 : BMI .loop_saved

    ; Verified
    LDA !ram_MissingTiles : BNE .missing_tiles
    SEC : RTS

  .failed_current
    ; count missing tiles in A
    EOR Verified_CurrentMapTiles,Y : CLC
  .failed_current_loop
    ASL : BCS .failed_current_inc : BNE .failed_current_loop
    INY #2
    INX #2 : CPX #$08B7 : BMI .loop_current
    ; jump to next loop
    LDX #$CD22 : LDY #$0000 : BRA .loop_saved

  .failed_current_inc
    INC !ram_MissingTiles
    BRA .failed_current_loop

  .failed_saved
    ; count missing tiles in A
    EOR Verified_MapTiles,Y : CLC
  .failed_saved_loop
    ASL : BCS .failed_saved_inc : BNE .failed_saved_loop
    INY #2
    INX #2 : CPX #$D2B2 : BMI .loop_saved

  .missing_tiles
    CLC : RTS

  .failed_saved_inc
    INC !ram_MissingTiles
    BRA .failed_saved_loop
}

VerifyEvents:
{
    LDA $7ED820 : CMP Verified_Events : BNE .failed
    LDA $7ED822 : CMP Verified_Events+2 : BNE .failed

    ; Verified
    SEC : RTS

  .failed
    CLC : RTS
}

VerifyMapStations:
{
    LDA $7ED908 : CMP #$FFFF : BNE .failed
    LDA $7ED90A : CMP #$FFFF : BNE .failed
    LDA $7ED90C : CMP #$FFFF : BNE .failed

    ; Verified
    SEC : RTS

  .failed
    CLC : RTS
}

VerifyBosses:
{
    LDX #$D828 : LDY #$0000

  .loop
    LDA $7E0000,X : CMP.w Verified_Bosses,Y : BNE .failed
    INY #2
    INX #2 : CPX #$D831 : BMI .loop

    ; Verified
    SEC : RTS

  .failed
    STA !ram_FailValue
    TXA : STA !ram_FailAddress
    CLC : RTS
}

VerifyDoors:
{
if defined("SKIP_DOOR_VERIFICATION")
    SEC : RTS
endif

    LDX #$D8B0 : LDY #$0000

  .loop
    LDA $7E0000,X : CMP.w Verified_Doors,Y : BNE .failed
    INY #2
    INX #2 : CPX #$D8C6 : BMI .loop

    ; Verified
    SEC : RTS

  .failed
    STA !ram_FailValue
    TXA : STA !ram_FailAddress
    CLC : RTS
}

VerifyItems:
{
    LDX #$D870 : LDY #$0000

  .loop
    LDA $7E0000,X : CMP.w Verified_Items,Y : BNE .failed
    INY #2
    INX #2 : CPX #$D884 : BMI .loop

    ; Verified
    SEC : RTS

  .failed
    STA !ram_FailValue
    TXA : STA !ram_FailAddress
    CLC : RTS
}

VerifyCeresRidleyMap:
{
    ; check if Ridley's map tile was explored
    LDA $083D : BIT #$0008 : BEQ .failed
    STA !ram_RidleyMapExplored
    ; overwritten code
    LDA #$0002 : JML $90F084

  .failed
    STA !ram_FailValue
    LDA #$083D : STA !ram_FailAddress
    ; overwritten code
    LDA #$0002 : JML $90F084
}

DrawHUD:
{
    PHP

    LDA.w HUDTextLookupTable,Y : STA $12

    SEP #$20
    LDY #$0000 : TYX

  .loop
    LDA ($12),Y : CMP #$FF : BEQ .done
    STA $7EC6B0,X : INX
    LDA #$2C : STA $7EC6B0,X : INX
    INY : BRA .loop

  .done
    PLP
    RTS
}

DrawMissingTiles:
{
    LDA !ram_MissingTiles : STA $4204
    SEP #$20
    ; divide by 10
    LDA #$0A : STA $4206
    REP #$20
    PEA $0000 : PLA ; wait for CPU math
    LDA $4214 : PHA ; tens

    ; Ones digit
    LDA $4216 : ASL : TAY
    LDA.w NumberGFXTable,Y : STA $7EC6B8

    ; Tens digit
    PLA : BEQ .blanktens
    ASL : TAY
    LDA.w NumberGFXTable,Y : STA $7EC6B6
    RTS

  .blanktens
    ; draw hyphen
    LDA #$2CCF : STA $7EC6B6
    RTS
}

HUDTextLookupTable:
    dw #Fail_MapTiles
    dw #Fail_CeresRidley
    dw #Fail_Events
    dw #Fail_MapStations
    dw #Fail_Doors
    dw #Fail_ItemCollection
    dw #Success
    dw #SuccessMapOnly

Fail_MapTiles:
    db "MAP", $FF

Fail_CeresRidley:
    db "CERES", $FF

Fail_Events:
    db "EVENT", $FF

Fail_MapStations:
    db "MAP S", $FF

Fail_Doors:
    db "DOORS", $FF

Fail_ItemCollection:
    db "ITEMS", $FF

Success:
    db "VALID", $FF

SuccessMapOnly:
    db " 1244", $FF

Verified_Events:
    db $E5, $FF, $2F, $00 ; dummy byte for word access

Verified_Bosses:
    db $04, $03, $07, $01, $03, $02, $01, $00 ; dummy byte for word access

Verified_Items:
    db $FF, $FF, $EF, $FF, $FE, $1F, $FF, $FF, $DF, $FE, $01, $00, $00, $00, $00, $00
    db $FF, $FF, $FF, $05

Verified_Doors:
    db $23, $F0, $09, $FE, $6F, $FF, $FF, $FF, $FF, $FE, $FF, $FF, $01, $00, $00, $00
    db $7C, $FF, $FF, $FD, $AF, $03

Verified_MapStations:
    db $FF, $FF, $FF, $FF, $FF, $FF, $00, $00

Verified_CurrentMapTiles: ; (Crateria)
    db $00, $00, $00, $00, $00, $00, $00, $7F, $00, $00, $00, $7F, $00, $1F, $FF, $FF
    db $00, $10, $00, $7F, $00, $11, $FF, $FF, $00, $17, $94, $00, $00, $1E, $37, $C0
    db $00, $10, $FF, $00, $03, $FF, $D0, $00, $00, $00, $5F, $80, $00, $00, $10, $80
    db $00, $00, $10, $80, $00, $00, $10, $80, $00, $00, $10, $80, $00, $00, $10, $80
    db $00, $00, $10, $80, $00, $00, $1F, $80, $00, $00, $3F, $00, $00, $00, $08, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $03, $FC, $00, $00, $C3, $FC, $00, $00, $03, $F0, $00, $00
    db $03, $F0, $00, $00, $FF, $FC, $7F, $80, $2F, $FC, $7F, $80, $20, $00, $00, $80
    db $20, $00, $00, $80, $00, $00, $07, $80, $00, $00, $0F, $80, $00, $00, $08, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Verified_MapTiles:
  .Brinstar
    db $00, $00, $00, $00, $00, $40, $00, $00, $00, $40, $03, $80, $00, $40, $02, $80
    db $00, $78, $02, $80, $07, $FF, $FE, $80, $00, $C0, $60, $80, $03, $FF, $E0, $80
    db $07, $7B, $F8, $80, $00, $53, $FC, $A7, $00, $52, $7F, $A0, $07, $F2, $7F, $FF
    db $07, $F3, $DE, $0C, $00, $7F, $07, $80, $00, $FF, $01, $FF, $00, $00, $00, $00
    db $00, $00, $01, $FF, $00, $00, $00, $66, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $04, $00, $00, $00, $04, $00, $00, $00, $04, $00, $00, $00
    db $1F, $00, $00, $00, $96, $00, $00, $00, $FC, $00, $00, $00, $C4, $00, $00, $00
    db $7C, $00, $00, $00, $40, $00, $00, $00, $C0, $00, $00, $00, $40, $00, $00, $00
    db $C0, $00, $00, $00, $40, $00, $00, $00, $4E, $00, $00, $00, $FC, $7F, $C7, $80
    db $00, $7F, $FF, $C0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .Norfair
    db $00, $00, $00, $00, $00, $20, $00, $00, $1E, $20, $00, $FE, $1E, $20, $3F, $8F
    db $1F, $FF, $87, $FE, $3E, $7F, $FF, $FE, $20, $FF, $FF, $FF, $21, $BE, $1E, $FC
    db $3F, $1F, $13, $04, $03, $C1, $93, $FC, $00, $FF, $FF, $E6, $00, $7F, $FF, $EF
    db $00, $38, $05, $C7, $03, $E0, $05, $FF, $03, $E1, $FF, $C3, $1E, $21, $8F, $FE
    db $1F, $BF, $FC, $00, $1F, $A0, $39, $FF, $0F, $F0, $03, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FC, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $FC, $00, $00, $00, $7C, $00, $00, $00
    db $08, $00, $00, $00, $08, $00, $00, $00, $FC, $00, $00, $00, $FC, $00, $00, $00
    db $FC, $00, $00, $00, $F8, $00, $00, $00, $FC, $00, $00, $00, $FC, $00, $00, $00
    db $40, $00, $00, $00, $C0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .WreckedShip
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0F, $FC, $00
    db $00, $0F, $80, $00, $00, $3F, $80, $00, $00, $3F, $BC, $00, $00, $0F, $FC, $00
    db $00, $00, $FC, $00, $00, $0F, $80, $00, $00, $01, $FC, $00, $00, $00, $80, $00
    db $00, $07, $F0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .Maridia
    db $00, $00, $00, $00, $00, $00, $00, $78, $00, $00, $00, $58, $00, $00, $01, $D8
    db $00, $00, $01, $C0, $00, $0E, $3F, $C0, $00, $0B, $FF, $FF, $00, $08, $3B, $FF
    db $00, $0E, $23, $FF, $00, $02, $2F, $FF, $00, $3F, $EF, $CC, $00, $3F, $FF, $FC
    db $00, $3F, $9F, $C0, $00, $37, $B7, $00, $00, $37, $B7, $30, $00, $37, $BF, $B0
    db $00, $3F, $FF, $BF, $00, $3F, $FF, $F0, $00, $1F, $C0, $00, $00, $38, $00, $00
    db $00, $18, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $20, $00, $00, $00, $20, $00, $00, $00, $20, $00, $00, $00
    db $20, $00, $00, $00, $30, $00, $00, $00, $E0, $00, $00, $00, $FF, $E0, $00, $00
    db $FF, $E0, $00, $00, $FE, $40, $00, $00, $01, $C0, $00, $00, $03, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $80, $00, $00, $00, $C0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  .Tourian
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $08, $00, $00, $00, $08, $00
    db $00, $00, $08, $00, $00, $07, $FC, $00, $00, $07, $F8, $00, $00, $00, $08, $00
    db $00, $0F, $F8, $00, $00, $1F, $F8, $00, $00, $00, $F8, $00, $00, $1F, $F8, $00
    db $00, $1F, $F8, $00, $00, $1F, $F8, $00, $00, $00, $38, $00, $00, $00, $00, $00

NumberGFXTable:
    dw #$2C45, #$2C3C, #$2C3D, #$2C3E, #$2C3F, #$2C40, #$2C41, #$2C42, #$2C43, #$2C44

print pc, " TC_Verify bank $A2 end"


org $A6FF00
print pc, " TC_Verify bank $A6 start"

CeresRidleyDefeated:
{
    LDA #$DEAD : STA !ram_RidleyDefeated

    ; overwritten code
    LDA #$0000 : STA $7E7802
    LDA #$BD9A : STA $0FA8
    JMP $BD9A
}

print pc, " TC_Verify bank $A6 end"

pulltable
