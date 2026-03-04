* @ValidationCode : MjotMjA1ODc0NTk4MDpDcDEyNTI6MTc1NjkxNjEzMTY0MzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Sep 2025 13:15:31
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

SUBROUTINE ABC.GET.ACC.CANCEL.DESEMBOLSO
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

    Y.ID.GENE.PARAM = 'ABC.CANCEL.COMERCIO.POSL'
    Y.ACC.CARGO = ''
    Y.TXN.TYPE = ''
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.POS.PARAM = ''

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GENE.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'ACC.CANCEL.DESEMBOLSO' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.ACC.CARGO = Y.LIST.VALUES<Y.POS.PARAM>
    END
    LOCATE 'TXN.TYPE.CANCEL.DESEMBOLSO' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.TXN.TYPE = Y.LIST.VALUES<Y.POS.PARAM>
    END

    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo,Y.ACC.CARGO)
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.TransactionType,Y.TXN.TYPE)


RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------



RETURN

END


