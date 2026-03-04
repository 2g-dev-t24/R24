* @ValidationCode : MjotNDA0ODEzNDMyOkNwMTI1MjoxNzY3MzcxOTQ5NzI3Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Jan 2026 13:39:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.V.2TT.GET.TELLER.ID.2


    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.Display
    $USING AC.AccountOpening
    $USING TT.Contract


    FN.TELLER.USER = 'F.TELLER.USER'
    F.TELLER.USER = ''
    EB.DataAccess.Opf(FN.TELLER.USER, F.TELLER.USER)
    
    EB.DataAccess.CacheRead(FN.TELLER.USER,EB.SystemTables.getOperator(),R.REC.VAL,YERR)
    Y.TELLER.ID = R.REC.VAL<1>

    EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdTwo, Y.TELLER.ID )
    EB.Display.RebuildScreen()
RETURN
END
