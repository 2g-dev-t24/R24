* @ValidationCode : MjotNTQ0MjQyOTkzOkNwMTI1MjoxNzU5NzAwMzE5OTQ0OmVuem9jb3JpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Oct 2025 18:38:39
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
SUBROUTINE ABC.BAM.SPEI.TXN.OUTGOING
*-----------------------------------------------------------------------------
* Objective:          This subroutine must be attached
*                     to the FUNDS.TRANSFER version used
*                     to input the Spei transfer in order
*                     to get it sent to the final payments
*                     system (Interpagos)
*===============================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AbcTable
    $USING AbcSpei
    $USING EB.ErrorProcessing
    $USING FT.Contract
    $USING EB.Updates
    $USING EB.Display
    $USING ST.Customer
    $USING AC.AccountOpening

*-------------------------
* Constants Used
*-------------------------
    Y.SEPARA.MESSAGE = "/"
    YCONST.FOLIO.SPEI          = "1"
    Y.RFC.ND                   ="ND"
    YFOLIO                     = 1
    YFECHA.OPER                = EB.SystemTables.getToday()
    YCONST.SIS.GENERA          = "GLO"
    YCONST.TIPO.OPER           = ""
    YCONST.TOPOLOGIA           = "V"
    YCONST.CVE.PAGO            = ""
    YCONST.CONCEPTO.2          = ""
    YCONST.REF.COBRANZA        = ""
    YCONST.PRIORIDAD           = 0
    YCONST.SEPARADOR           = ";"
    YCONST.NOMBRE.ORD          = ""
    YCONST.CTA.ORD             = ""
    YCONST.RFC.ORD             = ""
    YCONST.TIPO.CTA.ORD        = ""
    YCONST.TIPO.CTA.BENEF      = "40"
    YREF.NUM                   = ""
    YCONST.NOM.BENEF.2         = ""
    YCONST.TIPO.CTA.BENEF.2    = ""
    YCONST.CTA.BENEF.2         = ""
    YCONST.RFC.BENEF.2         = ""

    YLONG.CUENTA               = 20
    Y.TIPO.INST.DEFAULT        = "040"

*-------------------------
* Main Program Loop
*-------------------------

    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN
*-------------------------
PROCESS:
*-------------------------
    Y.ID.NEW = EB.SystemTables.getIdNew()
    YRASTREO       = Y.ID.NEW[3,LEN(Y.ID.NEW)-2]
    YNOMBRE.BENEF  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)<1,1>
    
    Y.LOCAL.REF     = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    YREF.NUM  = Y.LOCAL.REF<1,YPOS.YREF.NUM>

    YREF.NUM  = TRIM(YREF.NUM)
    YREF.NUM = YREF.NUM*1

    IF YREF.NUM EQ "" THEN
        YREF.NUM = 1
    END

    Y.CTA.BENEF.SPEUA = Y.LOCAL.REF<1,YPOS.CTA.BENEF.SPEUA>

    IF Y.CTA.BENEF.SPEUA EQ "" THEN
        Y.CAMPO = YPOS.CTA.EXT.TRANSF
        Y.CTA.EXT.TRANSF = Y.LOCAL.REF<1,YPOS.CTA.EXT.TRANSF>
        Y.ID.CTA.DES = TRIM(Y.CTA.EXT.TRANSF)
    END ELSE
        Y.CTA.EXT.TRANSF = Y.LOCAL.REF<1,YPOS.CTA.BENEF.SPEUA>
        Y.ID.CTA.DES = Y.CTA.EXT.TRANSF
        Y.CAMPO = YPOS.CTA.BENEF.SPEUA
    END

    YRFC.BENEF = Y.LOCAL.REF<1,YPOS.RFC.BENEF>

    Y.EXTEND.INFO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.ExtendInfo)
    IF LEN(Y.EXTEND.INFO) GT 40 THEN
        YCONCEPTO.PAGO = Y.EXTEND.INFO[1,40]
        YCONCEPTO.PAGO = EREPLACE(YCONCEPTO.PAGO,@VM," ")
    END ELSE
        YCONCEPTO.PAGO = Y.EXTEND.INFO
        YCONCEPTO.PAGO = EREPLACE(YCONCEPTO.PAGO,@VM," ")
    END

    YMONTO.PAGO    = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    YMONTO.IVA     = Y.LOCAL.REF<1,YPOS.IVA.BENEF>
    IF YMONTO.IVA EQ "" THEN
        YMONTO.IVA = 0
    END

    YTIPO.PAGO     = Y.LOCAL.REF<1,YPOS.TIPO.PAGO>

    IF YTIPO.PAGO EQ "1" THEN
        Y.CUENTA.CTE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
        EB.DataAccess.FRead(FN.ACCOUNT, Y.CUENTA.CTE, YREC.ACCOUNT, F.ACCOUNT, Y.ERR.ACCOUNT)
        IF YREC.ACCOUNT NE "" THEN
            Y.CLIENTE.ID = YREC.ACCOUNT<AC.AccountOpening.Account.Customer>

            EB.DataAccess.FRead(FN.CUSTOMER, Y.CLIENTE.ID, YREC.CLIENTE, F.CUSTOMER, Y.ERR.CUSTOMER)
            IF YREC.CLIENTE NE "" THEN
                IF YREC.CLIENTE<ST.Customer.Customer.EbCusExternCusId><1,1> EQ '' THEN
                    Y.RFC.ORD = Y.RFC.ND
                END ELSE
                    Y.RFC.ORD = YREC.CLIENTE<ST.Customer.Customer.EbCusExternCusId><1,1>
                END


                Y.TIPO.PER = YREC.CLIENTE<ST.Customer.Customer.EbCusSector>
                IF Y.TIPO.PER LT 3 THEN
                    Y.NOM.ORD = YREC.CLIENTE<ST.Customer.Customer.EbCusNameTwo>
                    Y.NOM.ORD := " ":YREC.CLIENTE<ST.Customer.Customer.EbCusShortName>
                    Y.NOM.ORD := " ":YREC.CLIENTE<ST.Customer.Customer.EbCusNameOne>
                END
                ELSE
                    Y.NOM.ORD = YREC.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.NOM.ORD>
                END
            END
            ELSE
                Y.NOM.ORD = YCONST.NOMBRE.ORD
                Y.CTA.ORD = YCONST.CTA.ORD
                Y.RFC.ORD = YCONST.RFC.ORD
            END
            EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
            IF R.ABC.ACCT.LCL.FLDS THEN
                Y.CTA.ORD = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Clabe>
            END

        END
        ELSE
            Y.NOM.ORD = YCONST.NOMBRE.ORD
            Y.CTA.ORD = YCONST.CTA.ORD
            Y.RFC.ORD = YCONST.RFC.ORD
        END

        Y.TIP.CTA = "40"

    END
    ELSE
        Y.NOM.ORD = YCONST.NOMBRE.ORD
        Y.CTA.ORD = YCONST.CTA.ORD
        Y.RFC.ORD = YCONST.RFC.ORD
        Y.TIP.CTA = YCONST.TIPO.CTA.ORD
    END

    GOSUB LEE.CUENTA.DESTINO

*Manda mensaje de error en caso de ocurrir y no deja continuar
    IF Y.CTA.DES.ERR NE '' THEN
        EB.SystemTables.setE(Y.CTA.DES.ERR)
        V$ERROR = 1
        EB.ErrorProcessing.Err()
    END

    GOSUB OBTEN.BANCO

    Y.HORA = TIMEDATE()
    Y.HORA = Y.HORA[1,8]
    Y.LOCAL.REF<1,YPOS.TIME.SPEUA> = Y.HORA
    Y.LOCAL.REF<1,YPOS.RASTREO> = Y.ID.NEW[3,14]
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF)

    YSTRING.ESCRIBIR  = YCONST.FOLIO.SPEI : YCONST.SEPARADOR : YFOLIO : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YFECHA.OPER : YCONST.SEPARADOR : YCONST.SIS.GENERA : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YTIPO.PAGO : YCONST.SEPARADOR : YCONST.TIPO.OPER : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YINSTITUCION : YCONST.SEPARADOR : YCONST.TOPOLOGIA : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YRASTREO : YCONST.SEPARADOR

*-- SUSTITUYE CARACTER NOMBRE ORDENANTE
    Y.NOM.ORD = EREPLACE(Y.NOM.ORD,"Ñ","N")

*-- SUSTITUYE CARACTER NOMBRE BENEFICIARIO
    YNOMBRE.BENEF = EREPLACE(YNOMBRE.BENEF,"Ñ","N")


    IF LEN(Y.NOM.ORD) GT 40 THEN
        Y.NOM.ORD = Y.NOM.ORD[1,40]
    END
    IF LEN(YNOMBRE.BENEF) GT 40 THEN
        YNOMBRE.BENEF = YNOMBRE.BENEF[1,40]
    END
    IF LEN(YCONCEPTO.PAGO) GT 40 THEN
        YCONCEPTO.PAGO = YCONCEPTO.PAGO[1,40]
    END
    IF LEN(YCONST.REF.COBRANZA) GT 40 THEN
        YCONST.REF.COBRANZA = YCONST.REF.COBRANZA[1,40]
    END

    IF LEN(Y.NOM.ORD) GT 30 THEN
        Y.NOM.ORD = Y.NOM.ORD[1,30]
    END

    YSTRING.ESCRIBIR := Y.NOM.ORD : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := Y.TIP.CTA : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := Y.CTA.ORD : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := Y.RFC.ORD : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YNOMBRE.BENEF : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YCONST.TIPO.CTA.BENEF : YCONST.SEPARADOR : YCTA.BENEF : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YRFC.BENEF : YCONST.SEPARADOR : YMONTO.PAGO : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YMONTO.IVA : YCONST.SEPARADOR : YCONCEPTO.PAGO : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YCONST.CVE.PAGO : YCONST.SEPARADOR : YCONST.CONCEPTO.2 : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YREF.NUM : YCONST.SEPARADOR : YCONST.REF.COBRANZA : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YCONST.NOM.BENEF.2 : YCONST.SEPARADOR : YCONST.TIPO.CTA.BENEF.2 : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YCONST.CTA.BENEF.2 : YCONST.SEPARADOR : YCONST.RFC.BENEF.2 : YCONST.SEPARADOR : YCONST.SEPARADOR
    YSTRING.ESCRIBIR := YCONST.PRIORIDAD

    Y.RESPONSE = ""
    AbcSpei.AbcSpeiExpressPreparaRequest(YSTRING.ESCRIBIR, Y.RESPONSE)

    Y.MENSAJE = ""
    Y.TIPO.MESSAGE = ""
    Y.DESC.MESSAGE = ""
    Y.MESSAGE.OUT = ""

    IF Y.RESPONSE EQ "" THEN
        Y.MENSAJE = "NO SE RECIBIO RESPUESTA DEL SPEI"
    END ELSE
        AbcSpei.AbcSpeiInterpretaResponse(Y.RESPONSE, Y.MESSAGE.OUT)
        Y.TIPO.MESSAGE = FIELD(Y.MESSAGE.OUT, Y.SEPARA.MESSAGE, 1)
        Y.DESC.MESSAGE = FIELD(Y.MESSAGE.OUT, Y.SEPARA.MESSAGE, 2)
        Y.MENSAJE = Y.TIPO.MESSAGE : " / " : Y.DESC.MESSAGE
    END

    IF Y.TIPO.MESSAGE NE 0 THEN
        IF Y.MENSAJE NE "" THEN
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
            EB.SystemTables.setAv(CTA.EXT.TRANSF.POS)
            PRINT Y.MENSAJE
            EB.SystemTables.setEtext(Y.MENSAJE)
            EB.SystemTables.setE(Y.MENSAJE)
            EB.ErrorProcessing.StoreEndError()
            EB.Display.RebuildScreen()
        END
    END
RETURN


*-------------------
LEE.CUENTA.DESTINO:
*-------------------

    IF Y.CLIENTE.ID EQ '' THEN
        YINSTITUCION   = Y.ID.CTA.DES[1,3]
        YCTA.BENEF = Y.ID.CTA.DES
    END ELSE
        Y.ID.ABC.CTAS = Y.CLIENTE.ID:'.':Y.ID.CTA.DES
        EB.DataAccess.FRead(FN.ABC.CUENTAS.DESTINO,Y.ID.ABC.CTAS,Y.REC.CTA.DESTINO,F.ABC.CUENTAS.DESTINO,ERR.ABC.CUENTAS.DESTINO)
        IF Y.REC.CTA.DESTINO NE '' THEN
            Y.TIP.CTA.DES = Y.REC.CTA.DESTINO<AbcTable.AbcCuentasDestino.TipoCta>
            Y.ESTATUS.CTA.DES = Y.REC.CTA.DESTINO<AbcTable.AbcCuentasDestino.Status>

            IF NOT(Y.TIP.CTA.DES MATCHES 'CLABE':@VM:'TARJETA DEBITO':@VM:'CELULAR') THEN
                Y.CTA.DES.ERR = 'TIPO DE CUENTA DESTINO NO VALIDA PARA ESTA OPERACION'
                RETURN
            END

            IF Y.ESTATUS.CTA.DES NE 'ACTIVA' THEN
                Y.CTA.DES.ERR = 'LA CUENTA DESTINO NO ESTA ACTIVA'
                RETURN
            END

            YINSTITUCION = STR("0",3-LEN(TRIM(Y.REC.CTA.DESTINO<AbcTable.AbcCuentasDestino.Banco>))):TRIM(Y.REC.CTA.DESTINO<ACD.DES.BANCO>)

            BEGIN CASE
                CASE Y.TIP.CTA.DES EQ 'CELULAR'
                    YCTA.BENEF = Y.ID.CTA.DES[4,10]
                    YCONST.TIPO.CTA.BENEF = "10"
                CASE Y.TIP.CTA.DES EQ 'TARJETA DEBITO'
                    YCTA.BENEF = Y.ID.CTA.DES
                    YCONST.TIPO.CTA.BENEF = "3"
                CASE Y.TIP.CTA.DES EQ 'CLABE'
                    YCTA.BENEF = Y.ID.CTA.DES
                    YCONST.TIPO.CTA.BENEF = "40"
                CASE 1
                    Y.CTA.DES.ERR = 'TIPO DE CUENTA NO VALIDO'
            END CASE


        END ELSE
            Y.CTA.DES.ERR = 'LA CUENTA DESTINO NO EXISTE'
        END
    END

*
RETURN


*-----------
OBTEN.BANCO:
*-----------

    Y.CLAVE.BCO = YINSTITUCION * 1
    YNO = ''
    YID = ''
    SELECT.CMD = "SELECT ":FN.ABC.BANCOS:" WITH @ID EQ ":DQUOTE(Y.CLAVE.BCO)

    EB.DataAccess.Readlist(SELECT.CMD,YID,'',YNO,'')
    YID = YID<1>
    IF YNO GT 0 THEN
        EB.DataAccess.FRead(FN.ABC.BANCOS,YID,YREC.ABC.BANCOS,F.ABC.BANCOS,ERR.ABC.BANCOS)
        IF YREC.ABC.BANCOS NE '' THEN
            Y.TIPO.INST = YREC.ABC.BANCOS<AbcTable.AbcBancos.DenomPuntoTrans>
            IF Y.TIPO.INST EQ "" THEN
                Y.TIPO.INST = Y.TIPO.INST.DEFAULT
            END
            Y.TIPO.INST = STR("0",3-LEN(Y.TIPO.INST)):Y.TIPO.INST
            YINSTITUCION = YINSTITUCION

        END
    END
    ELSE
        YINSTITUCION = Y.TIPO.INST.DEFAULT:"000"
        RETURN
    END


*
RETURN

*-------------------------
INITIALIZE:
*-------------------------

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER  = ""
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    FN.ABC.BANCOS = "F.ABC.BANCOS"
    F.ABC.BANCOS  = ""
    EB.DataAccess.Opf(FN.ABC.BANCOS,F.ABC.BANCOS)

    FN.ABC.CUENTAS.DESTINO = "F.ABC.CUENTAS.DESTINO"
    F.ABC.CUENTAS.DESTINO = ""
    EB.DataAccess.Opf(FN.ABC.CUENTAS.DESTINO,F.ABC.CUENTAS.DESTINO)

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS, F.ABC.ACCT.LCL.FLDS)

    Y.REC.CTA.DESTINO = ''
    Y.ID.CTA.DES = ''
    Y.TIP.CTA.DES = ''
    Y.ESTATUS.CTA.DES = ''
    Y.CTA.DES.ERR = ''

    YLOCAL.FIELDS = ""

    YPOS.CTA.ORD = 0

    Y.NOMBRE.APP = "CUSTOMER":@FM:"FUNDS.TRANSFER"
    Y.NOMBRE.CAMPO = "NOM.PER.MORAL":@FM:"CTA.BENEF.SPEUA":@VM:"CTA.EXT.TRANSF":@VM:"FLAG.SPEI":@VM:"RFC.BENEF.SPEI":@VM:"AMT.IVA.SPEI":@VM:"TIPO.SPEI":@VM:"REFERENCIA":@VM:"TIMESTAMP.SPEUA":@VM:"RASTREO"
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)
    YPOS.NOM.ORD = R.POS.CAMPO<1,1>
    YPOS.CTA.BENEF.SPEUA = R.POS.CAMPO<2,1>
    YPOS.CTA.EXT.TRANSF  = R.POS.CAMPO<2,2>
    YPOS.FLAG.SPEI       = R.POS.CAMPO<2,3>
    YPOS.RFC.BENEF       = R.POS.CAMPO<2,4>
    YPOS.IVA.BENEF       = R.POS.CAMPO<2,5>
    YPOS.TIPO.PAGO       = R.POS.CAMPO<2,6>
    YPOS.YREF.NUM        = R.POS.CAMPO<2,7>
    YPOS.TIME.SPEUA      = R.POS.CAMPO<2,8>
    YPOS.RASTREO         = R.POS.CAMPO<2,9>

RETURN

END
