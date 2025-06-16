
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

org $8BEB91
IGTTheOperationWasDefinition:

org $8BEECD
IGTCompletedSuccessfullyDefinition:

org $8BEEFD
IGTClearTimeDefinition:



org $8BFA00
print pc, " IGT_text bank $8B start"

IGTNoAnimalTechniquesDefinition:
    dw $F02B, $F3B9, #IGTNoAnimalTechniquesInstructions

IGTNoAnimalTechniquesInstructions:
    dw #$0007, #IGTText_N
    dw #$000C, #IGTText_No
    dw #$0007, #IGTText_NoA
    dw #$0007, #IGTText_NoAn
    dw #$0007, #IGTText_NoAni
    dw #$0007, #IGTText_NoAnim
    dw #$0007, #IGTText_NoAnima
    dw #$000C, #IGTText_NoAnimal
    dw #$0007, #IGTText_NoAnimalT
    dw #$0007, #IGTText_NoAnimalTe
    dw #$0007, #IGTText_NoAnimalTec
    dw #$0007, #IGTText_NoAnimalTech
    dw #$0007, #IGTText_NoAnimalTechn
    dw #$0007, #IGTText_NoAnimalTechni
    dw #$0007, #IGTText_NoAnimalTechniq
    dw #$0007, #IGTText_NoAnimalTechniqu
    dw #$0007, #IGTText_NoAnimalTechnique
    dw #$000C, #IGTText_NoAnimalTechniques
    dw $F3B0
  .loop
    dw #$000F, #IGTText_NoAnimalTechniques
    dw $94BC, #.loop

IGTWereUsedInThisRunDefinition:
    dw $F02B, $F3B9, #IGTWereUsedInThisRunInstructions

IGTWereUsedInThisRunInstructions:
    dw #$0008, #IGTText_W
    dw #$0008, #IGTText_We
    dw #$0008, #IGTText_Wer
    dw #$0011, #IGTText_Were
    dw #$0008, #IGTText_WereU
    dw #$0008, #IGTText_WereUs
    dw #$0008, #IGTText_WereUse
    dw #$0011, #IGTText_WereUsed
    dw #$0008, #IGTText_WereUsedI
    dw #$0011, #IGTText_WereUsedIn
    dw #$0008, #IGTText_WereUsedInT
    dw #$0008, #IGTText_WereUsedInTh
    dw #$0008, #IGTText_WereUsedInThi
    dw #$0011, #IGTText_WereUsedInThis
    dw #$0008, #IGTText_WereUsedInThisR
    dw #$0008, #IGTText_WereUsedInThisRu
    dw #$0012, #IGTText_WereUsedInThisRun
    dw $F3CE
  .loop
    dw #$0008, #IGTText_WereUsedInThisRun
    dw $94BC, #.loop

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



org $8CA69D
    dw $AB61, #$0002    ; Point to 'T'
IGTText_N:
    dw #IGTTextData_N, #$0002
IGTText_No:
    dw #IGTTextData_No, #$0004
warnpc $8CA6A9

org $8CA6A9
    dw $AB57, #$0004    ; Point to 'Th'
IGTText_NoA:
    dw #IGTTextData_NoA, #$0006
IGTText_NoAn:
    dw #IGTTextData_NoAn, #$0008
IGTText_NoAni:
    dw #IGTTextData_NoAni, #$000A
IGTText_NoAnim:
    dw #IGTTextData_NoAnim, #$000C
warnpc $8CA6BF

org $8CA6BF
    dw $AB4D, #$0006    ; Point to 'The'
IGTText_NoAnima:
    dw #IGTTextData_NoAnima, #$000E
IGTText_NoAnimal:
    dw #IGTTextData_NoAnimal, #$0010
IGTText_NoAnimalT:
    dw #IGTTextData_NoAnimalT, #$0012
IGTText_NoAnimalTe:
    dw #IGTTextData_NoAnimalTe, #$0014
IGTText_NoAnimalTec:
    dw #IGTTextData_NoAnimalTec, #$0016
IGTText_NoAnimalTech:
    dw #IGTTextData_NoAnimalTech, #$0018
IGTText_NoAnimalTechn:
    dw #IGTTextData_NoAnimalTechn, #$001A
warnpc $8CA6DF

org $8CA6DF
    dw $AB43, #$0008    ; Point to 'The O'
IGTText_NoAnimalTechni:
    dw #IGTTextData_NoAnimalTechni, #$001C
IGTText_NoAnimalTechniq:
    dw #IGTTextData_NoAnimalTechniq, #$001E
IGTText_NoAnimalTechniqu:
    dw #IGTTextData_NoAnimalTechniqu, #$0020
IGTText_NoAnimalTechnique:
    dw #IGTTextData_NoAnimalTechnique, #$0022
IGTText_W:
    dw #IGTTextData_W, #$0002
IGTText_We:
    dw #IGTTextData_We, #$0004
IGTText_Wer:
    dw #IGTTextData_Wer, #$0006
IGTText_Were:
    dw #IGTTextData_Were, #$0008
warnpc $8CA709

org $8CA709
    dw $AB39, #$000A    ; Point to 'The Op'
IGTText_WereU:
    dw #IGTTextData_WereU, #$000A
IGTText_WereUs:
    dw #IGTTextData_WereUs, #$000C
IGTText_WereUse:
    dw #IGTTextData_WereUse, #$000E
IGTText_WereUsed:
    dw #IGTTextData_WereUsed, #$0010
IGTText_WereUsedI:
    dw #IGTTextData_WereUsedI, #$0012
IGTText_WereUsedIn:
    dw #IGTTextData_WereUsedIn, #$0014
IGTText_WereUsedInT:
    dw #IGTTextData_WereUsedInT, #$0016
IGTText_WereUsedInTh:
    dw #IGTTextData_WereUsedInTh, #$0018
IGTText_WereUsedInThi:
    dw #IGTTextData_WereUsedInThi, #$001A
IGTText_WereUsedInThis:
    dw #IGTTextData_WereUsedInThis, #$001C
IGTText_WereUsedInThisR:
    dw #IGTTextData_WereUsedInThisR, #$001E
IGTText_WereUsedInThisRu:
    dw #IGTTextData_WereUsedInThisRu, #$0020
warnpc $8CA73D

org $8CA73D
    dw $AB2F, #$000C    ; Point to 'The Ope'
warnpc $8CA77B

org $8CA77B
    dw $AB25, #$000E    ; Point to 'The Oper'
warnpc $8CA7C3

org $8CA7C3
    dw $AB1B, #$0010    ; Point to 'The Opera'
warnpc $8CA815

org $8CA815
    dw $AB11, #$0012    ; Point to 'The Operat'
warnpc $8CA871

org $8CA871
    dw $AB07, #$0014    ; Point to 'The Operati'
warnpc $8CA8D7

org $8CA8D7
    dw $AAFD, #$0016    ; Point to 'The Operatio'
warnpc $8CA947

org $8CA947
    dw $AAF3, #$0018    ; Point to 'The Operation'
warnpc $8CA9C1

org $8CA9C1
    dw $AAE9, #$001A    ; Point to 'The Operation W'
warnpc $8CAA45

org $8CAA45
    dw $AADF, #$001C    ; Point to 'The Operation Wa'
warnpc $8CAAD3

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

org $8CB49B
    dw $B665, #$0002    ; Point to 'C'
warnpc $8CB4A7

org $8CB4A7
    dw $B65B, #$0004    ; Point to 'Cl'
warnpc $8CB4BD

org $8CB4BD
    dw $B651, #$0006    ; Point to 'Cle'
warnpc $8CB4DD

org $8CB4DD
    dw $B647, #$0008    ; Point to 'Clea'
warnpc $8CB507

org $8CB507
    dw $B63D, #$000A    ; Point to 'Clear'
warnpc $8CB53B

org $8CB53B
    dw $B633, #$000C    ; Point to 'Clear T'
warnpc $8CB579

org $8CB579
    dw $B629, #$000E    ; Point to 'Clear Ti'
warnpc $8CB5C1

org $8CB5C1
    dw $B61F, #$0010    ; Point to 'Clear Tim'
warnpc $8CB613



org $8CF400
print pc, " IGT_text bank $8C start"

macro IGTTextChar(xPos, yPos, cByte)
    dw <xPos>
    db <yPos>+$08
table ../resources/IGTLowerChar.tbl
    db "<cByte>"
    db $31
    dw <xPos>
    db <yPos>
table ../resources/IGTUpperChar.tbl
    db "<cByte>"
    db $31
endmacro

IGTText_NoAnimalTechniques:
    dw #$0024
IGTTextData_NoAnimalTechniques:
    %IGTTextChar($48, $F8, "S")
IGTTextData_NoAnimalTechnique:
    %IGTTextChar($40, $F8, "E")
IGTTextData_NoAnimalTechniqu:
    %IGTTextChar($38, $F8, "U")
IGTTextData_NoAnimalTechniq:
    %IGTTextChar($30, $F8, "Q")
IGTTextData_NoAnimalTechni:
    %IGTTextChar($28, $F8, "I")
IGTTextData_NoAnimalTechn:
    %IGTTextChar($20, $F8, "N")
IGTTextData_NoAnimalTech:
    %IGTTextChar($18, $F8, "H")
IGTTextData_NoAnimalTec:
    %IGTTextChar($10, $F8, "C")
IGTTextData_NoAnimalTe:
    %IGTTextChar($08, $F8, "E")
IGTTextData_NoAnimalT:
    %IGTTextChar($00, $F8, "T")
IGTTextData_NoAnimal:
    %IGTTextChar($1F0, $F8, "L")
IGTTextData_NoAnima:
    %IGTTextChar($1E8, $F8, "A")
IGTTextData_NoAnim:
    %IGTTextChar($1E0, $F8, "M")
IGTTextData_NoAni:
    %IGTTextChar($1D8, $F8, "I")
IGTTextData_NoAn:
    %IGTTextChar($1D0, $F8, "N")
IGTTextData_NoA:
    %IGTTextChar($1C8, $F8, "A")
IGTTextData_No:
    %IGTTextChar($1B8, $F8, "O")
IGTTextData_N:
    %IGTTextChar($1B0, $F8, "N")

IGTText_WereUsedInThisRun:
    dw #$0022
IGTTextData_WereUsedInThisRun:
    %IGTTextChar($50, $10, "N")
IGTTextData_WereUsedInThisRu:
    %IGTTextChar($48, $10, "U")
IGTTextData_WereUsedInThisR:
    %IGTTextChar($40, $10, "R")
IGTTextData_WereUsedInThis:
    %IGTTextChar($30, $10, "S")
IGTTextData_WereUsedInThi:
    %IGTTextChar($28, $10, "I")
IGTTextData_WereUsedInTh:
    %IGTTextChar($20, $10, "H")
IGTTextData_WereUsedInT:
    %IGTTextChar($18, $10, "T")
IGTTextData_WereUsedIn:
    %IGTTextChar($08, $10, "N")
IGTTextData_WereUsedI:
    %IGTTextChar($00, $10, "I")
IGTTextData_WereUsed:
    %IGTTextChar($1F0, $10, "D")
IGTTextData_WereUse:
    %IGTTextChar($1E8, $10, "E")
IGTTextData_WereUs:
    %IGTTextChar($1E0, $10, "S")
IGTTextData_WereU:
    %IGTTextChar($1D8, $10, "U")
IGTTextData_Were:
    %IGTTextChar($1C8, $10, "E")
IGTTextData_Wer:
    %IGTTextChar($1C0, $10, "R")
IGTTextData_We:
    %IGTTextChar($1B8, $10, "E")
IGTTextData_W:
    %IGTTextChar($1B0, $10, "W")

IGTText_CompletedWithSpinLock:
    dw #$002A
IGTTextData_CompletedWithSpinLock:
    %IGTTextChar($58, $10, "K")
IGTTextData_CompletedWithSpinLoc:
    %IGTTextChar($50, $10, "C")
IGTTextData_CompletedWithSpinLo:
    %IGTTextChar($48, $10, "O")
IGTTextData_CompletedWithSpinL:
    %IGTTextChar($40, $10, "L")
IGTTextData_CompletedWithSpin:
    %IGTTextChar($30, $10, "N")
IGTTextData_CompletedWithSpi:
    %IGTTextChar($28, $10, "I")
IGTTextData_CompletedWithSp:
    %IGTTextChar($20, $10, "P")
IGTTextData_CompletedWithS:
    %IGTTextChar($18, $10, "S")
IGTTextData_CompletedWith:
    %IGTTextChar($08, $10, "H")
IGTTextData_CompletedWit:
    %IGTTextChar($00, $10, "T")
IGTTextData_CompletedWi:
    %IGTTextChar($1F8, $10, "I")
IGTTextData_CompletedW:
    %IGTTextChar($1F0, $10, "W")
IGTTextData_Completed:
    %IGTTextChar($1E0, $10, "D")
IGTTextData_Complete:
    %IGTTextChar($1D8, $10, "E")
IGTTextData_Complet:
    %IGTTextChar($1D0, $10, "T")
IGTTextData_Comple:
    %IGTTextChar($1C8, $10, "E")
IGTTextData_Compl:
    %IGTTextChar($1C0, $10, "L")
IGTTextData_Comp:
    %IGTTextChar($1B8, $10, "P")
IGTTextData_Com:
    %IGTTextChar($1B0, $10, "M")
IGTTextData_Co:
    %IGTTextChar($1A8, $10, "O")
IGTTextData_C:
    %IGTTextChar($1A0, $10, "C")

IGTText_GTMaxCompletion:
    dw #$001E
IGTTextData_GTMaxCompletion:
    %IGTTextChar($38, $10, "N")
IGTTextData_GTMaxCompletio:
    %IGTTextChar($30, $10, "O")
IGTTextData_GTMaxCompleti:
    %IGTTextChar($28, $10, "I")
IGTTextData_GTMaxComplet:
    %IGTTextChar($20, $10, "T")
IGTTextData_GTMaxComple:
    %IGTTextChar($18, $10, "E")
IGTTextData_GTMaxCompl:
    %IGTTextChar($10, $10, "L")
IGTTextData_GTMaxComp:
    %IGTTextChar($08, $10, "P")
IGTTextData_GTMaxCom:
    %IGTTextChar($00, $10, "M")
IGTTextData_GTMaxCo:
    %IGTTextChar($1F8, $10, "O")
IGTTextData_GTMaxC:
    %IGTTextChar($1F0, $10, "C")
IGTTextData_GTMax:
    %IGTTextChar($1E0, $10, "X")
IGTTextData_GTMa:
    %IGTTextChar($1D8, $10, "A")
IGTTextData_GTM:
    %IGTTextChar($1D0, $10, "M")
IGTTextData_GT:
    %IGTTextChar($1C0, $10, "T")
IGTTextData_G:
    %IGTTextChar($1B8, $10, "G")

IGTText_MapCompletion:
    dw #$001A
IGTTextData_MapCompletion:
    %IGTTextChar($30, $10, "N")
IGTTextData_MapCompletio:
    %IGTTextChar($28, $10, "O")
IGTTextData_MapCompleti:
    %IGTTextChar($20, $10, "I")
IGTTextData_MapComplet:
    %IGTTextChar($18, $10, "T")
IGTTextData_MapComple:
    %IGTTextChar($10, $10, "E")
IGTTextData_MapCompl:
    %IGTTextChar($08, $10, "L")
IGTTextData_MapComp:
    %IGTTextChar($00, $10, "P")
IGTTextData_MapCom:
    %IGTTextChar($1F8, $10, "M")
IGTTextData_MapCo:
    %IGTTextChar($1F0, $10, "O")
IGTTextData_MapC:
    %IGTTextChar($1E8, $10, "C")
IGTTextData_Map:
    %IGTTextChar($1D8, $10, "P")
IGTTextData_Ma:
    %IGTTextChar($1D0, $10, "A")
IGTTextData_M:
    %IGTTextChar($1C8, $10, "M")

IGTText_ReloadCount:
    dw #$0016
IGTTextData_ReloadCount:
    %IGTTextChar($10, $F8, "T")
IGTTextData_ReloadCoun:
    %IGTTextChar($08, $F8, "N")
IGTTextData_ReloadCou:
    %IGTTextChar($00, $F8, "U")
IGTTextData_ReloadCo:
    %IGTTextChar($1F8, $F8, "O")
IGTTextData_ReloadC:
    %IGTTextChar($1F0, $F8, "C")
IGTTextData_Reload:
    %IGTTextChar($1E0, $F8, "D")
IGTTextData_Reloa:
    %IGTTextChar($1D8, $F8, "A")
IGTTextData_Relo:
    %IGTTextChar($1D0, $F8, "O")
IGTTextData_Rel:
    %IGTTextChar($1C8, $F8, "L")
IGTTextData_Re:
    %IGTTextChar($1C0, $F8, "E")
IGTTextData_R:
    %IGTTextChar($1B8, $F8, "R")

IGTText_SuitlessTrueCompletion:
    dw #$002C
IGTTextData_SuitlessTrueCompletion:
    %IGTTextChar($58, $10, "N")
IGTTextData_SuitlessTrueCompletio:
    %IGTTextChar($50, $10, "O")
IGTTextData_SuitlessTrueCompleti:
    %IGTTextChar($48, $10, "I")
IGTTextData_SuitlessTrueComplet:
    %IGTTextChar($40, $10, "T")
IGTTextData_SuitlessTrueComple:
    %IGTTextChar($38, $10, "E")
IGTTextData_SuitlessTrueCompl:
    %IGTTextChar($30, $10, "L")
IGTTextData_SuitlessTrueComp:
    %IGTTextChar($28, $10, "P")
IGTTextData_SuitlessTrueCom:
    %IGTTextChar($20, $10, "M")
IGTTextData_SuitlessTrueCo:
    %IGTTextChar($18, $10, "O")
IGTTextData_SuitlessTrueC:
    %IGTTextChar($10, $10, "C")
IGTTextData_SuitlessTrue:
    %IGTTextChar($00, $10, "E")
IGTTextData_SuitlessTru:
    %IGTTextChar($1F8, $10, "U")
IGTTextData_SuitlessTr:
    %IGTTextChar($1F0, $10, "R")
IGTTextData_SuitlessT:
    %IGTTextChar($1E8, $10, "T")
IGTTextData_Suitless:
    %IGTTextChar($1D8, $10, "S")
IGTTextData_Suitles:
    %IGTTextChar($1D0, $10, "S")
IGTTextData_Suitle:
    %IGTTextChar($1C8, $10, "E")
IGTTextData_Suitl:
    %IGTTextChar($1C0, $10, "L")
IGTTextData_Suit:
    %IGTTextChar($1B8, $10, "T")
IGTTextData_Sui:
    %IGTTextChar($1B0, $10, "I")
IGTTextData_Su:
    %IGTTextChar($1A8, $10, "U")
IGTTextData_S:
    %IGTTextChar($1A0, $10, "S")

IGTText_TrueCompletion:
    dw #$001C
IGTTextData_TrueCompletion:
    %IGTTextChar($30, $10, "N")
IGTTextData_TrueCompletio:
    %IGTTextChar($28, $10, "O")
IGTTextData_TrueCompleti:
    %IGTTextChar($20, $10, "I")
IGTTextData_TrueComplet:
    %IGTTextChar($18, $10, "T")
IGTTextData_TrueComple:
    %IGTTextChar($10, $10, "E")
IGTTextData_TrueCompl:
    %IGTTextChar($08, $10, "L")
IGTTextData_TrueComp:
    %IGTTextChar($00, $10, "P")
IGTTextData_TrueCom:
    %IGTTextChar($1F8, $10, "M")
IGTTextData_TrueCo:
    %IGTTextChar($1F0, $10, "O")
IGTTextData_TrueC:
    %IGTTextChar($1E8, $10, "C")
IGTTextData_True:
    %IGTTextChar($1D8, $10, "E")
IGTTextData_Tru:
    %IGTTextChar($1D0, $10, "U")
IGTTextData_Tr:
    %IGTTextChar($1C8, $10, "R")
IGTTextData_T:
    %IGTTextChar($1C0, $10, "T")

print pc, " IGT_text bank $8C end"

