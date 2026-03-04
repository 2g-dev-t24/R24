* @ValidationCode : MjoxMzIxNDIzNjk2OkNwMTI1MjoxNzU2OTA5MTI3ODMxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Sep 2025 11:18:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.GET.ACC.ABONO.COMERCIO.R1
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING AbcTable
    $USING AbcSpei
    $USING AbcGetGeneralParam
    $USING EB.ErrorProcessing
    $USING EB.Foundation
    $USING EB.Interface
*-----------------------------------------------------------------------------

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ID.GENE.PARAM = 'ABC.AC.COMERCIO.POSL'
    Y.ACC.ABONO = ''
    Y.TXN.TYPE = ''
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.POS.PARAM = ''

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GENE.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'CUENTA.COMERCIO' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.ACC.ABONO = Y.LIST.VALUES<Y.POS.PARAM>
    END
    LOCATE 'TXN.TYPE.COMERCIO' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.TXN.TYPE = Y.LIST.VALUES<Y.POS.PARAM>
    END

    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo,Y.ACC.ABONO)
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.TransactionType,Y.TXN.TYPE)

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------



RETURN

END

