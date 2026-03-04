* @ValidationCode : MjoxNDQ3MTY3MzY1OkNwMTI1MjoxNzU3NTIxNDE5NzMzOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Sep 2025 13:23:39
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

SUBROUTINE ABC.LLENA.CREDIT.ACCT.SERVS
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
    $USING EB.Interface
*-----------------------------------------------------------------------------
   
    GOSUB INICIALIZA
    GOSUB VALIDA.SERVICE
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","BILLER",Y.POS.BILLER)
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","SERVICE",Y.POS.SERVICE)
    
    Y.ID.GEN.PARAM = "CUENTAS.ABONO.SERVICIOS"
    Y.LIST.PARAMS = ''  ;  Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    Y.SERVICE.TYPE = ''
    Y.ID.BILLER = ''
    Y.PORC.BILLER = ''
    Y.ERROR = ''
    Y.NOMBRE.PARAM.CTA = ''

RETURN

*---------------------------------------------------------------
VALIDA.SERVICE:
*---------------------------------------------------------------
    FT.LOCALREF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    
    Y.SERVICE.TYPE = EB.SystemTables.getComi()

    IF Y.SERVICE.TYPE EQ '' THEN
        Y.SERVICE.TYPE = FT.LOCALREF<1, Y.POS.SERVICE>
	END
	Y.SERVICE.TYPE = FT.LOCALREF<1, Y.POS.SERVICE>
    Y.ID.BILLER = FT.LOCALREF<1, Y.POS.BILLER>
    Y.CTA.CREDIT = ''

    BEGIN CASE

        CASE Y.SERVICE.TYPE EQ "RECHARGE"
            GOSUB GET.PORCENTAJE.BILLER
            GOSUB GET.CTA.CREDIT

        CASE Y.SERVICE.TYPE EQ "BILL PAYMENT"
            Y.NOMBRE.PARAM.CTA = Y.SERVICE.TYPE
            GOSUB GET.CTA.CREDIT

    END CASE

    IF Y.ERROR NE '' THEN
        ETEXT = Y.ERROR
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo,Y.CTA.CREDIT)


RETURN
*---------------------------------------------------------------
GET.PORCENTAJE.BILLER:
*---------------------------------------------------------------

    FINDSTR Y.ID.BILLER IN Y.LIST.PARAMS SETTING POS.VAL, POS.SUB THEN
        Y.PORC.BILLER = Y.LIST.VALUES<POS.VAL, POS.SUB>
        Y.NOMBRE.PARAM.CTA = "CUENTA." : Y.PORC.BILLER
    END

RETURN
*---------------------------------------------------------------
GET.CTA.CREDIT:
*---------------------------------------------------------------

    FINDSTR Y.NOMBRE.PARAM.CTA IN Y.LIST.PARAMS SETTING POS.VAL, POS.SUB THEN
        Y.CTA.CREDIT = Y.LIST.VALUES<POS.VAL, POS.SUB>
    END ELSE
        Y.ERROR = "NO SE ENCONTRO CUENTA PARAMETRIZADA"
    END

RETURN
END
