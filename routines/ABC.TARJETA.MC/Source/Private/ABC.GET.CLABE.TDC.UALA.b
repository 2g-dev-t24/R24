* @ValidationCode : MjoxMTc5MDk5MTkwOkNwMTI1MjoxNzU1NzQyODk1OTM5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Aug 2025 23:21:35
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

SUBROUTINE ABC.GET.CLABE.TDC.UALA
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING AbcGetGeneralParam
*-----------------------------------------------------------------------------
    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.CLABE.TDC.UALA = ''
    Y.ID.AC.FISERV = EB.SystemTables.getIdNew()
    Y.ID.GEN.PARAM = 'TDC.UALA'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.POS.PARAM = ''
    Y.ID.PARAM.BANXICO = ''
    Y.CODIGO.FINANT = ''

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.VPM.PARAMETROS.BANXICO = 'F.ABC.PARAMETROS.BANXICO'
    F.VPM.PARAMETROS.BANXICO = ''
    EB.DataAccess.Opf(FN.VPM.PARAMETROS.BANXICO, F.VPM.PARAMETROS.BANXICO)

    FN.ABC.TARJETA.CRED.UALA = 'F.ABC.TARJETA.CRED.UALA'
    F.ABC.TARJETA.CRED.UALA = ''
    EB.DataAccess.Opf(FN.ABC.TARJETA.CRED.UALA, F.ABC.TARJETA.CRED.UALA)

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------

    GOSUB GET.GENERAL.PARAM

    Y.ERROR = ''
    Y.ID.AC.FISERV = FMT(Y.ID.AC.FISERV,"R%11")
    Y.CLABE.TDC.UALA = Y.NUM.BANCO:Y.CODIGO.FINANT:Y.ID.AC.FISERV

* 04/03/2024 FYG - INICIO -

    GOSUB VALIDA.TDC

    IF Y.OUT.ERROR THEN
        RETURN
    END
 
* 04/03/2024 FYG - FIN -
 
    AbcTarjetaMc.AbcCalculaCcc(Y.CLABE.TDC.UALA,Y.ERROR)

    IF Y.ERROR EQ 0 THEN
        EB.SystemTables.setRNew(AbcTable.AbcTarjetaCredUala.Clabe,Y.CLABE.TDC.UALA)
    END ELSE
        ETEXT='ERROR EN LA GENERACION DE CUENTA CLABE'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

RETURN

*-------------------------------------------------------------------------------
GET.GENERAL.PARAM:
*-------------------------------------------------------------------------------

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'ID.PARAM.BANXICO' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.ID.PARAM.BANXICO = Y.LIST.VALUES<Y.POS.PARAM>
    END

    LOCATE 'CODIGO.FINAN' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.CODIGO.FINANT = Y.LIST.VALUES<Y.POS.PARAM>
    END

    GOSUB GET.PARAM.BANXICO

RETURN

*-------------------------------------------------------------------------------
GET.PARAM.BANXICO:
*-------------------------------------------------------------------------------

    R.VPM.PARAMETROS.BANXICO = ''
    ERRO.PARAM.BANXICO = ''
    Y.NUM.BANCO = ''
    EB.DataAccess.FRead(FN.VPM.PARAMETROS.BANXICO, Y.ID.PARAM.BANXICO, R.VPM.PARAMETROS.BANXICO, F.VPM.PARAMETROS.BANXICO, ERRO.PARAM.BANXICO)
    IF R.VPM.PARAMETROS.BANXICO THEN
        Y.NUM.BANCO = R.VPM.PARAMETROS.BANXICO<AbcTable.AbcParametrosBanxico.BanxicoNumBanco>
    END

RETURN

*-------------------------------------------------------------------------------
VALIDA.TDC:
*-------------------------------------------------------------------------------

    Y.OUT.ERROR = ''
    Y.ID.TARJ.TDC = Y.ID.AC.FISERV
    R.ABC.TARJETA.CRED.UALA = ''
    ERR.TDC.UALA = ''

    EB.DataAccess.FRead(FN.ABC.TARJETA.CRED.UALA,Y.ID.TARJ.TDC,R.ABC.TARJETA.CRED.UALA,F.ABC.TARJETA.CRED.UALA,ERR.TDC.UALA)

    IF R.ABC.TARJETA.CRED.UALA THEN

        Y.OUT.ERROR = 1

        Y.CLABE.UALA = ''
        Y.CLABE.UALA = R.ABC.TARJETA.CRED.UALA<AbcTable.AbcTarjetaCredUala.Clabe>

        ETEXT = 'Existe TDC CLABE ' : Y.CLABE.UALA
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()

        RETURN

    END

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

RETURN

END
