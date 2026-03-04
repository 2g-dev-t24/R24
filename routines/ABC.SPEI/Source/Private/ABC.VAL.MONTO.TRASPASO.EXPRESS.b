* @ValidationCode : MjoyMDY4MTIxOTU2OkNwMTI1MjoxNzY3NjY3MTkxNTIwOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2026 23:39:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcSpei
*===============================================================================
SUBROUTINE ABC.VAL.MONTO.TRASPASO.EXPRESS
*===============================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING FT.Contract
    $USING AbcGetGeneralParam
    $USING AC.AccountOpening
    
    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.MONTO = EB.SystemTables.getComi()
    Y.CUENTA.ORDEN = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    R.ACCOUNT = ''
    Y.ERR.ACC = ''
    Y.MONTO.MAX.EXP = ''
    Y.WORKING.BALANCE = ''
    Y.ACCT.LOCKED.AMT = ''
    Y.AMOUNT.AVAIL = ''
    Y.ID.PARAM.LIMIT = 'ABC.LIMITE.MONTOS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM.LIMIT, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'LIMITE.OPER.TRANSFER.EXPRESS' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.MONTO.MAX.EXP = Y.LIST.VALUES<Y.POS>
    END

    IF Y.MONTO LE 0 THEN
        ETEXT = "Monto a transferir debe ser mayor a 0"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    IF Y.MONTO.MAX.EXP NE "" THEN
        IF Y.MONTO GT Y.MONTO.MAX.EXP THEN
            ETEXT = "Solo se permite hasta: ":Y.MONTO.MAX.EXP
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END

    TODAY = EB.SystemTables.getToday()
    AbcSpei.AbcMontoBloqueado(Y.CUENTA.ORDEN,Y.ACCT.LOCKED.AMT,TODAY)

    EB.DataAccess.FRead(FN.ACCOUNT, Y.CUENTA.ORDEN, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACC)

    IF R.ACCOUNT THEN
        Y.WORKING.BALANCE = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>
        Y.AMOUNT.AVAIL = Y.WORKING.BALANCE - Y.ACCT.LOCKED.AMT
        IF (Y.WORKING.BALANCE LE 0) OR (Y.MONTO GT Y.WORKING.BALANCE)  OR (Y.MONTO GT Y.AMOUNT.AVAIL) THEN
            ETEXT = 'Saldo insuficiente'
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

RETURN

END
