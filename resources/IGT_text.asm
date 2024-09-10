
org $81FA00
print pc, " IGT_text bank $81 start"

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

print pc, " IGT_text bank $81 end"
warnpc $81FB00



org $8B97D2
    JSL AddSpritemapToOAMWithDataPointer

org $8BEECD
IGTCompletedSuccessfullyDefinition:

org $8BEEFD
IGTClearTimeDefinition:

org $8BF3B1
    LDY !ram_IGT_completed_text

org $8BF3CF
    LDY !ram_IGT_clear_time_text



org $8BFA00
print pc, " IGT_text bank $8B start"

IGTCompletedWithSpinLockDefinition:
    dw $F02B, $F3B9, #IGTCompletedWithSpinLockInstructions

IGTCompletedWithSpinLockInstructions:
    dw #$0008, #IGTText_C
    dw #$0008, #IGTText_Co
    dw #$0008, #IGTText_Com
    dw #$0008, #IGTText_Comp
    dw #$0008, #IGTText_Compl
    dw #$0008, #IGTText_Comple
    dw #$0008, #IGTText_Complet
    dw #$0008, #IGTText_Complete
    dw #$000B, #IGTText_Completed
    dw #$0008, #IGTText_CompletedW
    dw #$0008, #IGTText_CompletedWi
    dw #$0008, #IGTText_CompletedWit
    dw #$000B, #IGTText_CompletedWith
    dw #$0008, #IGTText_CompletedWithS
    dw #$0008, #IGTText_CompletedWithSp
    dw #$0008, #IGTText_CompletedWithSpi
    dw #$000B, #IGTText_CompletedWithSpin
    dw #$0008, #IGTText_CompletedWithSpinL
    dw #$0008, #IGTText_CompletedWithSpinLo
    dw #$0008, #IGTText_CompletedWithSpinLoc
    dw #$000D, #IGTText_CompletedWithSpinLock
    dw $F3CE
  .loop
    dw #$0008, #IGTText_CompletedWithSpinLock
    dw $94BC, #.loop

IGTGTMaxCompletionDefinition:
    dw $F02B, $F3B9, #IGTGTMaxCompletionInstructions

IGTGTMaxCompletionInstructions:
    dw #$000A, #IGTText_G
    dw #$0014, #IGTText_GT
    dw #$000A, #IGTText_GTM
    dw #$000A, #IGTText_GTMa
    dw #$0014, #IGTText_GTMax
    dw #$000A, #IGTText_GTMaxC
    dw #$000A, #IGTText_GTMaxCo
    dw #$000A, #IGTText_GTMaxCom
    dw #$000A, #IGTText_GTMaxComp
    dw #$000A, #IGTText_GTMaxCompl
    dw #$000A, #IGTText_GTMaxComple
    dw #$000A, #IGTText_GTMaxComplet
    dw #$000A, #IGTText_GTMaxCompleti
    dw #$000A, #IGTText_GTMaxCompletio
    dw #$0016, #IGTText_GTMaxCompletion
    dw $F3CE
  .loop
    dw #$0008, #IGTText_GTMaxCompletion
    dw $94BC, #.loop

IGTMapCompletionDefinition:
    dw $F02B, $F3B9, #IGTMapCompletionInstructions

IGTMapCompletionInstructions:
    dw #$000D, #IGTText_M
    dw #$000D, #IGTText_Ma
    dw #$0013, #IGTText_Map
    dw #$000D, #IGTText_MapC
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

IGTReloadCountDefinition:
    dw $F03E, $F3B9, #IGTReloadCountInstructions

IGTReloadCountInstructions:
    dw #$0008, #IGTText_R
    dw #$0008, #IGTText_Re
    dw #$0008, #IGTText_Rel
    dw #$0008, #IGTText_Relo
    dw #$0008, #IGTText_Reloa
    dw #$000B, #IGTText_Reload
    dw #$0008, #IGTText_ReloadC
    dw #$0008, #IGTText_ReloadCo
    dw #$0008, #IGTText_ReloadCou
    dw #$0008, #IGTText_ReloadCoun
    dw #$000B, #IGTText_ReloadCount
    dw $F41B
    dw #$0008, #IGTText_ReloadCount
    dw $F424
    dw #$0008, #IGTText_ReloadCount
    dw $F436
    dw #$0008, #IGTText_ReloadCount
    dw $F43F
    dw #$0080, #IGTText_ReloadCount
    dw $F448
  .loop
    dw #$000F, #IGTText_ReloadCount
    dw $94BC, #.loop

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
    dw #$000A, #IGTText_Suitless
    dw #$0008, #IGTText_SuitlessT
    dw #$0008, #IGTText_SuitlessTr
    dw #$0008, #IGTText_SuitlessTru
    dw #$000A, #IGTText_SuitlessTrue
    dw #$0008, #IGTText_SuitlessTrueC
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

IGTTrueCompletionDefinition:
    dw $F02B, $F3B9, #IGTTrueCompletionInstructions

IGTTrueCompletionInstructions:
    dw #$000C, #IGTText_T
    dw #$000C, #IGTText_Tr
    dw #$000C, #IGTText_Tru
    dw #$0013, #IGTText_True
    dw #$000C, #IGTText_TrueC
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

print pc, " IGT_text bank $8B end"



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
IGTText_G:
    dw #IGTTextData_G, #$0002
IGTText_GT:
    dw #IGTTextData_GT, #$0004
IGTText_GTM:
    dw #IGTTextData_GTM, #$0006
IGTText_GTMa:
    dw #IGTTextData_GTMa, #$0008
IGTText_GTMax:
    dw #IGTTextData_GTMax, #$000A
IGTText_GTMaxC:
    dw #IGTTextData_GTMaxC, #$000C
IGTText_GTMaxCo:
    dw #IGTTextData_GTMaxCo, #$000E
IGTText_GTMaxCom:
    dw #IGTTextData_GTMaxCom, #$0010
IGTText_GTMaxComp:
    dw #IGTTextData_GTMaxComp, #$0012
IGTText_GTMaxCompl:
    dw #IGTTextData_GTMaxCompl, #$0014
IGTText_GTMaxComple:
    dw #IGTTextData_GTMaxComple, #$0016
IGTText_GTMaxComplet:
    dw #IGTTextData_GTMaxComplet, #$0018
IGTText_GTMaxCompleti:
    dw #IGTTextData_GTMaxCompleti, #$001A
IGTText_GTMaxCompletio:
    dw #IGTTextData_GTMaxCompletio, #$001C
warnpc $8CAC91

org $8CAC91
    dw $B44B, #$0010    ; Point to 'Complete'
IGTText_R:
    dw #IGTTextData_R, #$0002
IGTText_Re:
    dw #IGTTextData_Re, #$0004
IGTText_Rel:
    dw #IGTTextData_Rel, #$0006
IGTText_Relo:
    dw #IGTTextData_Relo, #$0008
IGTText_Reloa:
    dw #IGTTextData_Reloa, #$000A
IGTText_Reload:
    dw #IGTTextData_Reload, #$000C
IGTText_ReloadC:
    dw #IGTTextData_ReloadC, #$000E
IGTText_ReloadCo:
    dw #IGTTextData_ReloadCo, #$0010
IGTText_ReloadCou:
    dw #IGTTextData_ReloadCou, #$0012
IGTText_ReloadCoun:
    dw #IGTTextData_ReloadCoun, #$0014
warnpc $8CACE3

org $8CACE3
    dw $B441, #$0012    ; Point to 'Completed'
IGTText_C:
    dw #IGTTextData_C, #$0002
IGTText_Co:
    dw #IGTTextData_Co, #$0004
IGTText_Com:
    dw #IGTTextData_Com, #$0006
IGTText_Comp:
    dw #IGTTextData_Comp, #$0008
IGTText_Compl:
    dw #IGTTextData_Compl, #$000A
IGTText_Comple:
    dw #IGTTextData_Comple, #$000C
IGTText_Complet:
    dw #IGTTextData_Complet, #$000E
IGTText_Complete:
    dw #IGTTextData_Complete, #$0010
IGTText_Completed:
    dw #IGTTextData_Completed, #$0012
IGTText_CompletedW:
    dw #IGTTextData_CompletedW, #$0014
IGTText_CompletedWi:
    dw #IGTTextData_CompletedWi, #$0016
IGTText_CompletedWit:
    dw #IGTTextData_CompletedWit, #$0018
IGTText_CompletedWith:
    dw #IGTTextData_CompletedWith, #$001A
IGTText_CompletedWithS:
    dw #IGTTextData_CompletedWithS, #$001C
IGTText_CompletedWithSp:
    dw #IGTTextData_CompletedWithSp, #$001E
IGTText_CompletedWithSpi:
    dw #IGTTextData_CompletedWithSpi, #$0020
IGTText_CompletedWithSpin:
    dw #IGTTextData_CompletedWithSpin, #$0022
IGTText_CompletedWithSpinL:
    dw #IGTTextData_CompletedWithSpinL, #$0024
IGTText_CompletedWithSpinLo:
    dw #IGTTextData_CompletedWithSpinLo, #$0026
IGTText_CompletedWithSpinLoc:
    dw #IGTTextData_CompletedWithSpinLoc, #$0028
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
print pc, " IGT_text bank $8C start"

macro IGTTextChar(xPos, yPos, cByte)
    dw <xPos>
    db <yPos>+$08
    dw $3110+<cByte>
    dw <xPos>
    db <yPos>
    dw $3100+<cByte>
endmacro

IGTText_CompletedWithSpinLock:
    dw #$002A
IGTTextData_CompletedWithSpinLock:
    %IGTTextChar($58, $10, $2A)
IGTTextData_CompletedWithSpinLoc:
    %IGTTextChar($50, $10, $22)
IGTTextData_CompletedWithSpinLo:
    %IGTTextChar($48, $10, $2E)
IGTTextData_CompletedWithSpinL:
    %IGTTextChar($40, $10, $2B)
IGTTextData_CompletedWithSpin:
    %IGTTextChar($30, $10, $2D)
IGTTextData_CompletedWithSpi:
    %IGTTextChar($28, $10, $28)
IGTTextData_CompletedWithSp:
    %IGTTextChar($20, $10, $2F)
IGTTextData_CompletedWithS:
    %IGTTextChar($18, $10, $42)
IGTTextData_CompletedWith:
    %IGTTextChar($08, $10, $27)
IGTTextData_CompletedWit:
    %IGTTextChar($00, $10, $43)
IGTTextData_CompletedWi:
    %IGTTextChar($1F8, $10, $28)
IGTTextData_CompletedW:
    %IGTTextChar($1F0, $10, $46)
IGTTextData_Completed:
    %IGTTextChar($1E0, $10, $23)
IGTTextData_Complete:
    %IGTTextChar($1D8, $10, $24)
IGTTextData_Complet:
    %IGTTextChar($1D0, $10, $43)
IGTTextData_Comple:
    %IGTTextChar($1C8, $10, $24)
IGTTextData_Compl:
    %IGTTextChar($1C0, $10, $2B)
IGTTextData_Comp:
    %IGTTextChar($1B8, $10, $2F)
IGTTextData_Com:
    %IGTTextChar($1B0, $10, $2C)
IGTTextData_Co:
    %IGTTextChar($1A8, $10, $2E)
IGTTextData_C:
    %IGTTextChar($1A0, $10, $22)

IGTText_GTMaxCompletion:
    dw #$001E
IGTTextData_GTMaxCompletion:
    %IGTTextChar($38, $10, $2D)
IGTTextData_GTMaxCompletio:
    %IGTTextChar($30, $10, $2E)
IGTTextData_GTMaxCompleti:
    %IGTTextChar($28, $10, $28)
IGTTextData_GTMaxComplet:
    %IGTTextChar($20, $10, $43)
IGTTextData_GTMaxComple:
    %IGTTextChar($18, $10, $24)
IGTTextData_GTMaxCompl:
    %IGTTextChar($10, $10, $2B)
IGTTextData_GTMaxComp:
    %IGTTextChar($08, $10, $2F)
IGTTextData_GTMaxCom:
    %IGTTextChar($00, $10, $2C)
IGTTextData_GTMaxCo:
    %IGTTextChar($1F8, $10, $2E)
IGTTextData_GTMaxC:
    %IGTTextChar($1F0, $10, $22)
IGTTextData_GTMax:
    %IGTTextChar($1E0, $10, $47)
IGTTextData_GTMa:
    %IGTTextChar($1D8, $10, $20)
IGTTextData_GTM:
    %IGTTextChar($1D0, $10, $2C)
IGTTextData_GT:
    %IGTTextChar($1C0, $10, $43)
IGTTextData_G:
    %IGTTextChar($1B8, $10, $26)

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

IGTText_ReloadCount:
    dw #$0016
IGTTextData_ReloadCount:
    %IGTTextChar($10, $F8, $43)
IGTTextData_ReloadCoun:
    %IGTTextChar($08, $F8, $2D)
IGTTextData_ReloadCou:
    %IGTTextChar($00, $F8, $44)
IGTTextData_ReloadCo:
    %IGTTextChar($1F8, $F8, $2E)
IGTTextData_ReloadC:
    %IGTTextChar($1F0, $F8, $22)
IGTTextData_Reload:
    %IGTTextChar($1E0, $F8, $23)
IGTTextData_Reloa:
    %IGTTextChar($1D8, $F8, $20)
IGTTextData_Relo:
    %IGTTextChar($1D0, $F8, $2E)
IGTTextData_Rel:
    %IGTTextChar($1C8, $F8, $2B)
IGTTextData_Re:
    %IGTTextChar($1C0, $F8, $24)
IGTTextData_R:
    %IGTTextChar($1B8, $F8, $41)

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

print pc, " IGT_text bank $8C end"

