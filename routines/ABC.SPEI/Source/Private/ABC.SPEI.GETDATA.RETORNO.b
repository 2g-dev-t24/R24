*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.SPEI.GETDATA.RETORNO(Y.IDTIPOPAGO, Y.FT.RETORNO, Y.SEP, Y.CADENA.RETORNO)
*===============================================================================
* Nombre de Programa : ABC.SPEI.GETDATA.RETORNO
* Objetivo           : Rutina obtener la informaci�n original de un Retorno SPEI
*===============================================================================

    $USING FT.Contract
    $USING EB.DataAccess
    $USING EB.Updates

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

    RETURN

***********
INITIALIZE:
***********

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    EB.DataAccess.Opf(FN.FT,F.FT)

    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FT.HIS = ''
    EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)

    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","NUM.ID",YPOS.NUM.ID)
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","FOLIO.SPEI",YPOS.FOLIO.SPEI)
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","RASTREO",YPOS.RASTREO)
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","REFERENCIA",YPOS.REFERENCIA)
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","CTA.EXT.TRANSF",YPOS.CTA.EXT.TRANSF)

    Y.ID.FT = Y.FT.RETORNO

    Y.CVERASTREO2 = ''
    Y.MONTOPAGOORI = ''
    Y.FOLIOINSTORI = ''
    Y.FOLIOPAGOORI = ''
    Y.FECORDTRANSFORI = ''
    Y.REFNUMPAGOORI = ''
    Y.TIPOCUENTAORDPAGORI = ''
    Y.CUENTAORDPAGOORI = ''
    Y.CONCEPTOPAGOORI = ''
    Y.MONTOPAGOORI = ''

    RETURN

********
PROCESS:
********



    IF Y.IDTIPOPAGO MATCHES "17":@VM:"23" THEN
        EB.DataAccess.FRead(FN.FT,Y.ID.FT,REC.FT,F.FT,ERR.FT)
    END ELSE
        EB.DataAccess.FReadHistory(FN.FT.HIS,Y.ID.FT,REC.FT,F.FT.HIS,ERR.FT)
    END

    IF REC.FT THEN
        Y.CVERASTREO2 = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.RASTREO>
        Y.MONTOPAGOORI = REC.FT<FT.Contract.FundsTransfer.CreditAmount>

        BEGIN CASE
        CASE Y.IDTIPOPAGO EQ '17'
            Y.MONTOPAGOORI = ''

        CASE Y.IDTIPOPAGO EQ '18'
            Y.FOLIOINSTORI = ''

        CASE 1
            Y.FOLIOINSTORI = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.NUM.ID>
            Y.FOLIOPAGOORI = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.FOLIO.SPEI>
            Y.FECORDTRANSFORI = REC.FT<FT.Contract.FundsTransfer.CreditValueDate>
            Y.REFNUMPAGOORI = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.REFERENCIA>
            Y.TIPOCUENTAORDPAGORI = '40'
            Y.CUENTAORDPAGOORI = REC.FT<FT.Contract.FundsTransfer.LocalRef,YPOS.CTA.EXT.TRANSF>
            Y.CONCEPTOPAGOORI = REC.FT<FT.Contract.FundsTransfer.ExtendInfo>

        END CASE
    END

    RETURN

*********
FINALIZE:
*********

    Y.CADENA.RETORNO = Y.CVERASTREO2:Y.SEP:Y.FOLIOINSTORI:Y.SEP:Y.FOLIOPAGOORI:Y.SEP:Y.FECORDTRANSFORI:Y.SEP:Y.REFNUMPAGOORI:Y.SEP
    Y.CADENA.RETORNO := Y.TIPOCUENTAORDPAGORI:Y.SEP:Y.CUENTAORDPAGOORI:Y.SEP:Y.CONCEPTOPAGOORI:Y.SEP:Y.MONTOPAGOORI

    RETURN

END
