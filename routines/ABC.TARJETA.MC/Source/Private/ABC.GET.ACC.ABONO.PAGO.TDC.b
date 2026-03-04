* @ValidationCode : Mjo0Mzg3Nzg0ODg6Q3AxMjUyOjE3NTU1NjM3NzI2MTY6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Aug 2025 21:36:12
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
$PACKAGE AbcTarjetaMc


SUBROUTINE ABC.GET.ACC.ABONO.PAGO.TDC
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING AbcGetGeneralParam
    $USING FT.Contract
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ID.GENE.PARAM = 'TDC.UALA'
    Y.ACC.ABONO = ''
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.POS.PARAM = ''

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GENE.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'CUENTA.ABONO.PAGO.TDC' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.ACC.ABONO = Y.LIST.VALUES<Y.POS.PARAM>
    END

    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo,Y.ACC.ABONO)

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------



RETURN

END

