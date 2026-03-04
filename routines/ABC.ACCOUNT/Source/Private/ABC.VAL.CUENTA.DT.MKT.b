* @ValidationCode : MjoxOTg3MTA4Mzg4OkNwMTI1MjoxNzU3ODk5NjM4NDc2Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Sep 2025 22:27:18
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
$PACKAGE AbcAccount

SUBROUTINE ABC.VAL.CUENTA.DT.MKT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING EB.ErrorProcessing
    $USING FT.Contract
*-----------------------------------------------------------------------------
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN
*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------
    Y.ACC.ID = ''
    Y.ACC.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)

RETURN
*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
*Si la cuenta de retiro es cuenta interna
    IF Y.ACC.ID[1,3] NE "MXN" THEN
        ETEXT = 'Tipo de cuenta invalida : ' : Y.ACC.ID
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

RETURN
*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------
RETURN
*-------------------------------------------------------------------------------
END

