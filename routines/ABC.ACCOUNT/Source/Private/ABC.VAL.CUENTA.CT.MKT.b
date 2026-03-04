* @ValidationCode : MjoyMjAxOTg1ODU6Q3AxMjUyOjE3NTc5MDM4MjUzNzg6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Sep 2025 23:37:05
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

SUBROUTINE ABC.VAL.CUENTA.CT.MKT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING FT.Contract
    $USING AbcTable
    $USING AbcSpei
*-----------------------------------------------------------------------------

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ACC.ID = ''
    Y.ACC.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)

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
    
    AbcSpei.RtnFtCheckBalance()
RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

RETURN

END


