* @ValidationCode : MjotNzY2NzYyNDkyOkNwMTI1MjoxNzU4ODk2MTU4NTAzOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Sep 2025 11:15:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>584</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.2BR.V.UNIT
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Display
**********
    GOSUB INIT
    GOSUB PROCESS

RETURN
**********
INIT:
**********
    TE.DENOMINATION = EB.SystemTables.getRNew(TT.Contract.Teller.TeDenomination)
    TE.DENOMINATION = TE.DENOMINATION<1>
    CNT.UNIT = DCOUNT(TE.DENOMINATION,@VM)

RETURN
**********
PROCESS:
**********
    TE.UNIT = EB.SystemTables.getRNew(TT.Contract.Teller.TeUnit)
    
    FOR NI = 1 TO CNT.UNIT
        IF TE.UNIT<1,NI> EQ '' THEN
            TE.UNIT<1,NI> = '0'
            EB.SystemTables.setRNew(TT.Contract.Teller.TeUnit, TE.UNIT)
*            CALL REFRESH.FIELD(TT.TE.UNIT:'.':NI,"")
*            FIELD.TO.REF    = TT.Contract.Teller.TeUnit:'.':NI
*            EB.Display.RefreshField(FIELD.TO.REF,"")
            EB.Display.RebuildScreen()
        END
    NEXT NI

RETURN
**********
END

