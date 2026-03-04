* @ValidationCode : MjoxMjc0MDI4MDUxOkNwMTI1MjoxNzU2OTA3OTg0MjMzOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Sep 2025 10:59:44
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
*===============================================================================
* <Rating>-32</Rating>
*===============================================================================

SUBROUTINE ABC.GET.ACC.SPEI.IN.TDC
*===============================================================================
* Nombre de Programa : ABC.GET.ACC.SPEI.IN.TDC
* Objetivo           : Rutina para llenar el campo de CREDIT.ACCT.NO Y DEBIT.ACCT.NO con base a la paremetrizacion
* Requerimiento      : Pago SPEI IN TDC UALA
* Desarrollador      :
* Compania           : ABC Capital
* Fecha Creacion     :
*===============================================================================
* Modificaciones:
*===============================================================================
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING FT.Contract
    $USING AbcGetGeneralParam
    $USING EB.Display

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ID.GENE.PARAM = 'ABC.CUENTAS.SPEI.IN.TDC'
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

    LOCATE 'AC.CARGO.SPEI.TDC' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.AC.CARGO.SPEI.TDC = Y.LIST.VALUES<Y.POS.PARAM>
    END
    LOCATE 'AC.ABONO.SPEI.TDC' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.AC.ABONO.SPEI.TDC = Y.LIST.VALUES<Y.POS.PARAM>
    END

    LOCATE 'FT.TRANSACTION.TYPE' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.TransactionType, Y.LIST.VALUES<Y.POS.PARAM>)
    END


    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAcctNo, Y.AC.CARGO.SPEI.TDC)

    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo, Y.AC.ABONO.SPEI.TDC)
    EB.Display.RebuildScreen()

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------



RETURN

END
