
; Super Metroid
; True Completion Verification Hack

pushtable

table HUDfont.tbl

!ram_MissingTiles = $0A02
!ram_IGTText = $0DF8
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
    ; default to original IGT text
    LDA #$EECD : STA !ram_IGTText

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
if defined("SKIP_DOOR_VERIFICATION")
else
    JSR VerifyDoors : BCS .draw
endif
    JSR VerifyItems : BCS .draw
    ; if we haven't, then we have a successful map only run
    LDA #IGTMapCompletionDefinition : STA !ram_IGTText
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
    JSR VerifySuitless
    BCS .suitless
    JSR VerifyItems
    BCS .checks_passed
    ; failed item collection check
    LDY #$000A : BRA .draw

  .suitless
    LDA #IGTSuitlessTrueCompletionDefinition : STA !ram_IGTText
    LDY #$0010
    BRA .draw

  .checks_passed
    LDA #IGTTrueCompletionDefinition : STA !ram_IGTText
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

VerifySuitless:
{
    LDX #$D870 : LDY #$0000

  .loop
    LDA $7E0000,X : CMP.w Verified_Suitless,Y : BNE .failed
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
    LDA #$003C : STA $14
    CPY #$000E : BNE .prepare_loop
    LDA #$002C : STA $14

  .prepare_loop
    SEP #$20
    LDY #$0000 : TYX

  .loop
    LDA ($12),Y : CMP #$FF : BEQ .done
    STA $7EC6B0,X : INX
    LDA $14 : STA $7EC6B0,X : INX
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
    dw #SuccessSuitless

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

SuccessSuitless:
    db "SUITL", $FF

Verified_Events:
    db $E5, $FF, $2F, $00 ; dummy byte for word access

Verified_Bosses:
    db $04, $03, $07, $01, $03, $02, $01, $00 ; dummy byte for word access

Verified_Items:
    db $FF, $FF, $EF, $FF, $FE, $1F, $FF, $FF, $DF, $FE, $01, $00, $00, $00, $00, $00
    db $FF, $FF, $FF, $05

Verified_Suitless:
    db $FF, $FF, $EF, $FF, $FE, $1F, $FE, $FF, $DF, $FE, $01, $00, $00, $00, $00, $00
    db $7F, $FF, $FF, $05

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


org $81FA00
print pc, " TC_Verify bank $81 start"

AddSpritemapToOAMWithDataPointer:
{
    LDA $0000,Y : BEQ .done : BMI .pointer
    ; Return to vanilla method before loading size
    PHX : JMP $87AA

  .done
    RTL

  .pointer
    ; Set size and then return to vanilla method
    PHX : TAX
    LDA $0002,Y : STA $18
    TXY : JMP $87AE
}

print pc, " TC_Verify bank $81 end"
warnpc $81FF00


org $8B97D2
    JSL AddSpritemapToOAMWithDataPointer

org $8BF3B1
    LDY !ram_IGTText

org $8BFA00
print pc, " TC_Verify bank $8B start"

IGTSuitlessTrueCompletionDefinition:
    dw $F02B, $F3B9, #IGTSuitlessTrueCompletionInstructions

IGTSuitlessTrueCompletionInstructions:
    dw #$0008, #IGTText_S
    dw #$0008, #IGTText_Su
    dw #$0008, #IGTText_Sui
    dw #$0008, #IGTText_Suit
    dw #$0008, #IGTText_Suitl
    dw #$0008, #IGTText_Suitle
    dw #$0008, #IGTText_Suitles
    dw #$0008, #IGTText_Suitless
    dw #$000A, #IGTText_SuitlessT
    dw #$0008, #IGTText_SuitlessTr
    dw #$0008, #IGTText_SuitlessTru
    dw #$0008, #IGTText_SuitlessTrue
    dw #$000A, #IGTText_SuitlessTrueC
    dw #$0008, #IGTText_SuitlessTrueCo
    dw #$0008, #IGTText_SuitlessTrueCom
    dw #$0008, #IGTText_SuitlessTrueComp
    dw #$0008, #IGTText_SuitlessTrueCompl
    dw #$0008, #IGTText_SuitlessTrueComple
    dw #$0008, #IGTText_SuitlessTrueComplet
    dw #$0008, #IGTText_SuitlessTrueCompleti
    dw #$0008, #IGTText_SuitlessTrueCompletio
    dw #$000A, #IGTText_SuitlessTrueCompletion
    dw $F3CE
  .loop
    dw #$0008, #IGTText_SuitlessTrueCompletion
    dw $94BC, #.loop

IGTMapCompletionDefinition:
    dw $F02B, $F3B9, #IGTMapCompletionInstructions

IGTMapCompletionInstructions:
    dw #$000D, #IGTText_M
    dw #$000D, #IGTText_Ma
    dw #$000D, #IGTText_Map
    dw #$0013, #IGTText_MapC
    dw #$000D, #IGTText_MapCo
    dw #$000D, #IGTText_MapCom
    dw #$000D, #IGTText_MapComp
    dw #$000D, #IGTText_MapCompl
    dw #$000D, #IGTText_MapComple
    dw #$000D, #IGTText_MapComplet
    dw #$000D, #IGTText_MapCompleti
    dw #$000D, #IGTText_MapCompletio
    dw #$0014, #IGTText_MapCompletion
    dw $F3CE
  .loop
    dw #$0008, #IGTText_MapCompletion
    dw $94BC, #.loop

IGTTrueCompletionDefinition:
    dw $F02B, $F3B9, #IGTTrueCompletionInstructions

IGTTrueCompletionInstructions:
    dw #$000C, #IGTText_T
    dw #$000C, #IGTText_Tr
    dw #$000C, #IGTText_Tru
    dw #$000C, #IGTText_True
    dw #$0013, #IGTText_TrueC
    dw #$000C, #IGTText_TrueCo
    dw #$000C, #IGTText_TrueCom
    dw #$000C, #IGTText_TrueComp
    dw #$000C, #IGTText_TrueCompl
    dw #$000C, #IGTText_TrueComple
    dw #$000C, #IGTText_TrueComplet
    dw #$000C, #IGTText_TrueCompleti
    dw #$000C, #IGTText_TrueCompletio
    dw #$0013, #IGTText_TrueCompletion
    dw $F3CE
  .loop
    dw #$0008, #IGTText_TrueCompletion
    dw $94BC, #.loop

print pc, " TC_Verify bank $8B end"


org $8CAB6B
    dw $B491, #$0002    ; Point to 'C'
IGTText_S:
    dw #IGTTextData_S, #$0002
IGTText_Su:
    dw #IGTTextData_Su, #$0004
warnpc $8CAB77

org $8CAB77
    dw $B487, #$0004    ; Point to 'Co'
IGTText_Sui:
    dw #IGTTextData_Sui, #$0006
IGTText_Suit:
    dw #IGTTextData_Suit, #$0008
IGTText_Suitl:
    dw #IGTTextData_Suitl, #$000A
IGTText_Suitle:
    dw #IGTTextData_Suitle, #$000C
warnpc $8CAB8D

org $8CAB8D
    dw $B47D, #$0006    ; Point to 'Com'
IGTText_Suitles:
    dw #IGTTextData_Suitles, #$000E
IGTText_Suitless:
    dw #IGTTextData_Suitless, #$0010
IGTText_SuitlessT:
    dw #IGTTextData_SuitlessT, #$0012
IGTText_SuitlessTr:
    dw #IGTTextData_SuitlessTr, #$0014
IGTText_SuitlessTru:
    dw #IGTTextData_SuitlessTru, #$0016
IGTText_SuitlessTrue:
    dw #IGTTextData_SuitlessTrue, #$0018
IGTText_SuitlessTrueC:
    dw #IGTTextData_SuitlessTrueC, #$001A
warnpc $8CABAD

org $8CABAD
    dw $B473, #$0008    ; Point to 'Comp'
IGTText_SuitlessTrueCo:
    dw #IGTTextData_SuitlessTrueCo, #$001C
IGTText_SuitlessTrueCom:
    dw #IGTTextData_SuitlessTrueCom, #$001E
IGTText_SuitlessTrueComp:
    dw #IGTTextData_SuitlessTrueComp, #$0020
IGTText_SuitlessTrueCompl:
    dw #IGTTextData_SuitlessTrueCompl, #$0022
IGTText_SuitlessTrueComple:
    dw #IGTTextData_SuitlessTrueComple, #$0024
IGTText_SuitlessTrueComplet:
    dw #IGTTextData_SuitlessTrueComplet, #$0026
IGTText_SuitlessTrueCompleti:
    dw #IGTTextData_SuitlessTrueCompleti, #$0028
IGTText_SuitlessTrueCompletio:
    dw #IGTTextData_SuitlessTrueCompletio, #$002A
warnpc $8CABD7

org $8CABD7
    dw $B469, #$000A    ; Point to 'Compl'
IGTText_M:
    dw #IGTTextData_M, #$0002
IGTText_Ma:
    dw #IGTTextData_Ma, #$0004
IGTText_Map:
    dw #IGTTextData_Map, #$0006
IGTText_MapC:
    dw #IGTTextData_MapC, #$0008
IGTText_MapCo:
    dw #IGTTextData_MapCo, #$000A
IGTText_MapCom:
    dw #IGTTextData_MapCom, #$000C
IGTText_MapComp:
    dw #IGTTextData_MapComp, #$000E
IGTText_MapCompl:
    dw #IGTTextData_MapCompl, #$0010
IGTText_MapComple:
    dw #IGTTextData_MapComple, #$0012
IGTText_MapComplet:
    dw #IGTTextData_MapComplet, #$0014
IGTText_MapCompleti:
    dw #IGTTextData_MapCompleti, #$0016
IGTText_MapCompletio:
    dw #IGTTextData_MapCompletio, #$0018
warnpc $8CAC0B

org $8CAC0B
    dw $B45F, #$000C    ; Point to 'Comple'
IGTText_T:
    dw #IGTTextData_T, #$0002
IGTText_Tr:
    dw #IGTTextData_Tr, #$0004
IGTText_Tru:
    dw #IGTTextData_Tru, #$0006
IGTText_True:
    dw #IGTTextData_True, #$0008
IGTText_TrueC:
    dw #IGTTextData_TrueC, #$000A
IGTText_TrueCo:
    dw #IGTTextData_TrueCo, #$000C
IGTText_TrueCom:
    dw #IGTTextData_TrueCom, #$000E
IGTText_TrueComp:
    dw #IGTTextData_TrueComp, #$0010
IGTText_TrueCompl:
    dw #IGTTextData_TrueCompl, #$0012
IGTText_TrueComple:
    dw #IGTTextData_TrueComple, #$0014
IGTText_TrueComplet:
    dw #IGTTextData_TrueComplet, #$0016
IGTText_TrueCompleti:
    dw #IGTTextData_TrueCompleti, #$0018
IGTText_TrueCompletio:
    dw #IGTTextData_TrueCompletio, #$001A
warnpc $8CAC49

org $8CAC49
    dw $B455, #$000E    ; Point to 'Complet'
warnpc $8CAC91

org $8CAC91
    dw $B44B, #$0010    ; Point to 'Complete'
warnpc $8CACE3

org $8CACE3
    dw $B441, #$0012    ; Point to 'Completed'
warnpc $8CAD3F

org $8CAD3F
    dw $B437, #$0014    ; Point to 'Completed S'
warnpc $8CADA5

org $8CADA5
    dw $B42D, #$0016    ; Point to 'Completed Su'
warnpc $8CAE15

org $8CAE15
    dw $B423, #$0018    ; Point to 'Completed Suc'
warnpc $8CAE8F

org $8CAE8F
    dw $B419, #$001A    ; Point to 'Completed Succ'
warnpc $8CAF13

org $8CAF13
    dw $B40F, #$001C    ; Point to 'Completed Succe'
warnpc $8CAFA1

org $8CAFA1
    dw $B405, #$001E    ; Point to 'Completed Succes'
warnpc $8CB039

org $8CB039
    dw $B3FB, #$0020    ; Point to 'Completed Success'
warnpc $8CB0DB

org $8CB0DB
    dw $B3F1, #$0022    ; Point to 'Completed Successf'
warnpc $8CB187

org $8CB187
    dw $B3E7, #$0024    ; Point to 'Completed Successfu'
warnpc $8CB23D

org $8CB23D
    dw $B3DD, #$0026    ; Point to 'Completed Successful'
warnpc $8CB2FD

org $8CB2FD
    dw $B3D3, #$0028    ; Point to 'Completed Successfull'
warnpc $8CB3C7

org $8CF400
print pc, " TC_Verify bank $8C start"

macro IGTTextChar(xPos, yPos, cByte)
    dw <xPos>
    db <yPos>+$08
    dw $3110+<cByte>
    dw <xPos>
    db <yPos>
    dw $3100+<cByte>
endmacro

IGTText_SuitlessTrueCompletion:
    dw #$002C
IGTTextData_SuitlessTrueCompletion:
    %IGTTextChar($58, $10, $2D)
IGTTextData_SuitlessTrueCompletio:
    %IGTTextChar($50, $10, $2E)
IGTTextData_SuitlessTrueCompleti:
    %IGTTextChar($48, $10, $28)
IGTTextData_SuitlessTrueComplet:
    %IGTTextChar($40, $10, $43)
IGTTextData_SuitlessTrueComple:
    %IGTTextChar($38, $10, $24)
IGTTextData_SuitlessTrueCompl:
    %IGTTextChar($30, $10, $2B)
IGTTextData_SuitlessTrueComp:
    %IGTTextChar($28, $10, $2F)
IGTTextData_SuitlessTrueCom:
    %IGTTextChar($20, $10, $2C)
IGTTextData_SuitlessTrueCo:
    %IGTTextChar($18, $10, $2E)
IGTTextData_SuitlessTrueC:
    %IGTTextChar($10, $10, $22)
IGTTextData_SuitlessTrue:
    %IGTTextChar($00, $10, $24)
IGTTextData_SuitlessTru:
    %IGTTextChar($1F8, $10, $44)
IGTTextData_SuitlessTr:
    %IGTTextChar($1F0, $10, $41)
IGTTextData_SuitlessT:
    %IGTTextChar($1E8, $10, $43)
IGTTextData_Suitless:
    %IGTTextChar($1D8, $10, $42)
IGTTextData_Suitles:
    %IGTTextChar($1D0, $10, $42)
IGTTextData_Suitle:
    %IGTTextChar($1C8, $10, $24)
IGTTextData_Suitl:
    %IGTTextChar($1C0, $10, $2B)
IGTTextData_Suit:
    %IGTTextChar($1B8, $10, $43)
IGTTextData_Sui:
    %IGTTextChar($1B0, $10, $28)
IGTTextData_Su:
    %IGTTextChar($1A8, $10, $44)
IGTTextData_S:
    %IGTTextChar($1A0, $10, $42)

IGTText_MapCompletion:
    dw #$001A
IGTTextData_MapCompletion:
    %IGTTextChar($30, $10, $2D)
IGTTextData_MapCompletio:
    %IGTTextChar($28, $10, $2E)
IGTTextData_MapCompleti:
    %IGTTextChar($20, $10, $28)
IGTTextData_MapComplet:
    %IGTTextChar($18, $10, $43)
IGTTextData_MapComple:
    %IGTTextChar($10, $10, $24)
IGTTextData_MapCompl:
    %IGTTextChar($08, $10, $2B)
IGTTextData_MapComp:
    %IGTTextChar($00, $10, $2F)
IGTTextData_MapCom:
    %IGTTextChar($1F8, $10, $2C)
IGTTextData_MapCo:
    %IGTTextChar($1F0, $10, $2E)
IGTTextData_MapC:
    %IGTTextChar($1E8, $10, $22)
IGTTextData_Map:
    %IGTTextChar($1D8, $10, $2F)
IGTTextData_Ma:
    %IGTTextChar($1D0, $10, $20)
IGTTextData_M:
    %IGTTextChar($1C8, $10, $2C)

IGTText_TrueCompletion:
    dw #$001C
IGTTextData_TrueCompletion:
    %IGTTextChar($30, $10, $2D)
IGTTextData_TrueCompletio:
    %IGTTextChar($28, $10, $2E)
IGTTextData_TrueCompleti:
    %IGTTextChar($20, $10, $28)
IGTTextData_TrueComplet:
    %IGTTextChar($18, $10, $43)
IGTTextData_TrueComple:
    %IGTTextChar($10, $10, $24)
IGTTextData_TrueCompl:
    %IGTTextChar($08, $10, $2B)
IGTTextData_TrueComp:
    %IGTTextChar($00, $10, $2F)
IGTTextData_TrueCom:
    %IGTTextChar($1F8, $10, $2C)
IGTTextData_TrueCo:
    %IGTTextChar($1F0, $10, $2E)
IGTTextData_TrueC:
    %IGTTextChar($1E8, $10, $22)
IGTTextData_True:
    %IGTTextChar($1D8, $10, $24)
IGTTextData_Tru:
    %IGTTextChar($1D0, $10, $44)
IGTTextData_Tr:
    %IGTTextChar($1C8, $10, $41)
IGTTextData_T:
    %IGTTextChar($1C0, $10, $43)

print pc, " TC_Verify bank $8C end"

pulltable
