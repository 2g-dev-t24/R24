* @ValidationCode : MjozNTYyNzM4ODpDcDEyNTI6MTc1NzM2OTE2NjY0NTptYXV1YjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Sep 2025 19:06:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ClauGuarra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>80</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
SUBROUTINE ABC.CALC.TIPO.CAMBIO
*===============================================================================
* Nombre de Programa : ABC.CALC.TIPO.CAMBIO
* Objetivo           : Rutina para retiro de cajero que calcula el tipo de cambio.
* Cuando ocurre un retiro en cajero propio u otro se deber� calcular el tipo de cambio
* Tipo de cambio= (Monto en pesos - Comisi�n cobrada por el cajero)/ Monto en moneda original
*===============================================================================

    $USING EB.Updates
    $USING EB.SystemTables
    $USING FT.Contract

    GOSUB INICIALIZA
    GOSUB CALC.TIPO.CAMBIO
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------
    
    LREF.TABLE = "FUNDS.TRANSFER"
    LREF.FIELD = "ORIG.AMOUNT":@VM:"ORIG.CURRENCY":@VM:"COMISION":@VM:"TIPO.CAMB"
    EB.Updates.MultiGetLocRef(LREF.TABLE, LREF.FIELD, LREF.POS)
    POS.ORIG.MONTO   = LREF.POS<1,1>
    POS.ORIG.CURRN   = LREF.POS<1,1>
    POS.COMI.CAJERO   = LREF.POS<1,1>
    POS.TIPO.CAMB   = LREF.POS<1,1>

    Y.MONTO.MXN = ''
    Y.MONTO.ORI = ''
    Y.MONED.ORI = ''
    Y.TIPO.CAMB = ''
    Y.COMISION  = ''
    Y.CAMB.DETA = ''


RETURN
*---------------------------------------------------------------
CALC.TIPO.CAMBIO:
*---------------------------------------------------------------
    Y.MONTO.ORI = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, POS.ORIG.MONTO>
    Y.MONED.ORI = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, POS.ORIG.CURRN>
    Y.COMISION  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, POS.COMI.CAJERO>
    Y.MONTO.MXN = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)

    IF EB.SystemTables.getVFunction() EQ 'R' THEN RETURN ELSE
        IF (Y.MONTO.ORI NE '') AND (Y.MONED.ORI NE '') THEN
            Y.TIPO.CAMB = (Y.MONTO.MXN - Y.COMISION) / Y.MONTO.ORI
            Y.TIPO.CAMB = DROUND(Y.TIPO.CAMB, 2)

            Y.LOCAL.REF<1, POS.TIPO.CAMB> = Y.TIPO.CAMB
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF)
        END ELSE
            Y.LOCAL.REF<1, POS.ORIG.CURRN> = ''
            Y.LOCAL.REF<1, POS.ORIG.MONTO> = ''
            Y.LOCAL.REF<1, POS.COMI.CAJERO> = ''
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF)
        END
    END

RETURN
