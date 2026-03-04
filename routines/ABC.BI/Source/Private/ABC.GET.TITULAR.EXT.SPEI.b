* @ValidationCode : MjoxNDU2MTE2ODE4OkNwMTI1MjoxNzU5NDI5NTEwNTg5OmVuem9jb3JpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Oct 2025 15:25:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : enzocorio
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcBi
*-----------------------------------------------------------------------------
SUBROUTINE ABC.GET.TITULAR.EXT.SPEI

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING AbcTable
    $USING AbcSpei
    $USING EB.Updates
    $USING EB.Display


    Y.COMI = EB.SystemTables.getComi()
    IF Y.COMI = "" THEN
        RETURN
    END
    AbcSpei.AbcValidaCccSpei()

    YPOS.CTA.BENEF.SPEUA = 0
    YPOS.RFC.BENEF.SPEI = 0

    NOM.CAMPOS     = 'CTA.BENEF.SPEUA':@VM:'RFC.BENEF.SPEI'
    POS.CAMP.LOCAL = ""
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER",NOM.CAMPOS,POS.CAMP.LOCAL)
    YPOS.CTA.BENEF.SPEUA = POS.CAMP.LOCAL<1,1>
    YPOS.RFC.BENEF.SPEI = POS.CAMP.LOCAL<1,2>

    YCTA.BENEF = EB.SystemTables.getComi()

    F.ABC.CTAS.AUTORIZADAS = ""
    FN.ABC.CTAS.AUTORIZADAS = "F.ABC.CTAS.AUTORIZADAS"

    EB.DataAccess.Opf(FN.ABC.CTAS.AUTORIZADAS,F.ABC.CTAS.AUTORIZADAS)

    YACCOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)

    F.ACCOUNT = ""
    FN.ACCOUNT = "F.ACCOUNT"
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    EB.DataAccess.FRead(FN.ACCOUNT,YACCOUNT,YREC.ACCOUNT,F.ACCOUNT,ERR.ACCT)

    YCUSTOMER = YREC.ACCOUNT<AC.AccountOpening.Account.Customer>

    YREC.ABC.CTAS.AUTORIZADAS = ""

    EB.DataAccess.FRead(FN.ABC.CTAS.AUTORIZADAS,YCUSTOMER,YREC.ABC.CTAS.AUTORIZADAS,F.ABC.CTAS.AUTORIZADAS,ERR.AUT)

    FIND YCTA.BENEF IN YREC.ABC.CTAS.AUTORIZADAS<AbcTable.AbcCtasAutorizadas.CtaClabe> SETTING YCAMPO, YPOSICION ELSE
        YCAMPO = 0
        YPOSICION = 0
    END

    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.LOCAL.REF<1,YPOS.CTA.BENEF.SPEUA> = ""
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF)
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CommissionAmt, "")

    IF YPOSICION NE 0 THEN
        YAPE.PATERNO = TRIM(TRIM(YREC.ABC.CTAS.AUTORIZADAS<AbcTable.AbcCtasAutorizadas.ApePaterno><1,YPOSICION>," ","T")," ","L")
        YAPE.MATERNO = TRIM(TRIM(YREC.ABC.CTAS.AUTORIZADAS<AbcTable.AbcCtasAutorizadas.ApeMaterno><1,YPOSICION>," ","T")," ","L")
        YNOMBRE      = TRIM(TRIM(YREC.ABC.CTAS.AUTORIZADAS<AbcTable.AbcCtasAutorizadas.Nombre><1,YPOSICION>," ","T")," ","L")
        YRFC         = TRIM(TRIM(YREC.ABC.CTAS.AUTORIZADAS<AbcTable.AbcCtasAutorizadas.Rfc><1,YPOSICION>," ","T")," ","L")
        YCURP        = TRIM(TRIM(YREC.ABC.CTAS.AUTORIZADAS<AbcTable.AbcCtasAutorizadas.Curp><1,YPOSICION>," ","T")," ","L")
        YBENEF.NAME = YAPE.PATERNO
        IF YAPE.MATERNO NE "" THEN
            YBENEF.NAME := " ":YAPE.MATERNO
        END
        IF YNOMBRE NE "" THEN
            YBENEF.NAME := " ":YNOMBRE
        END

        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, YBENEF.NAME)

        Y.LOCAL.REF2 = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
        IF YRFC NE "" THEN
            Y.LOCAL.REF2<1,YPOS.RFC.BENEF.SPEI> = YRFC
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF2)
        END ELSE
            Y.LOCAL.REF2<1,YPOS.RFC.BENEF.SPEI> = YCURP
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF2)
        END
    END ELSE
        Y.MESSAGE = EB.SystemTables.getMessage()
        IF Y.MESSAGE NE "VAL" THEN
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, "")
            Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
            Y.LOCAL.REF<1,YPOS.RFC.BENEF.SPEI> = ""
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF)
        END
    END

    EB.Display.RebuildScreen()

RETURN

END
