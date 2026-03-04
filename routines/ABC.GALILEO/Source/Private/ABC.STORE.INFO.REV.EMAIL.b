* @ValidationCode : MjoyMDU5MzYzODg0OkNwMTI1MjoxNzYwMzk3NzgxODA1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Oct 2025 20:23:01
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
*-----------------------------------------------------------------------------
* <Rating>159</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
SUBROUTINE ABC.STORE.INFO.REV.EMAIL

*-----------------------------------------------------------------------------
*===============================================================================
* Nombre de Programa:   ABC.STORE.INFO.REV.EMAIL
* Objetivo:             Rutina que guarda informaci�n de los reversos ATM en
*      ABC.SMS.EMAIL.TO.SEND para el env�o de notificaci�n.
*===============================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables

    $USING FT.Contract
    $USING AbcTable
    $USING EB.LocalReferences
    $USING AbcGetGeneralParam

    GOSUB INIT

    FN.ABC.SMS.EMAIL.TO.SEND = 'F.ABC.SMS.EMAIL.TO.SEND'
    F.ABC.SMS.EMAIL.TO.SEND = ''
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.TO.SEND, F.ABC.SMS.EMAIL.TO.SEND)

    FN.ABC.EMAIL.SMS.PARAMETER = 'F.ABC.EMAIL.SMS.PARAMETER'
    F.ABC.EMAIL.SMS.PARAMETER = ''
    EB.DataAccess.Opf(FN.ABC.EMAIL.SMS.PARAMETER, F.ABC.EMAIL.SMS.PARAMETER)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    EB.DataAccess.Opf(FN.FT,F.FT)

    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FT.HIS = ''
    EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)



    Y.ID.PARAM = 'ABC.STORE.INFO.REV.EMAIL'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE "RUTA" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.RUTA = Y.LIST.VALUES<YPOS.PARAM>
    END

    LOCATE "FILE.NAME" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.FILE.NAME = Y.LIST.VALUES<YPOS.PARAM>
    END


    FECHA.FILE = FMT(OCONV(DATE(), "DD"),"2'0'R"):".":FMT(OCONV(DATE(), "DM"),"2'0'R"):".":OCONV(DATE(), "DY4")
    str_filename = Y.FILE.NAME:"." : FECHA.FILE : ".log"
    SEQ.FILE.NAME = Y.RUTA

    OPENSEQ SEQ.FILE.NAME,str_filename TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    MENSAJE = "INICIO"
    GOSUB BITACORA

    EB.DataAccess.FRead(FN.ABC.EMAIL.SMS.PARAMETER, 'SYSTEM', Y.REC.PARAM, F.ABC.EMAIL.SMS.PARAMETER, Y.ERR.PARAM)

    IF INDEX('R',EB.SystemTables.getVFunction(),1) THEN
        GOSUB TRANSACCION.ATM.SPEI.REV
    END

    MENSAJE = "INICIO"
    GOSUB BITACORA

RETURN

*************************
TRANSACCION.ATM.SPEI.REV:
*************************

    Y.ID.FT = EB.SystemTables.getIdNew()

    MENSAJE = "Y.ID.FT: ":Y.ID.FT
    GOSUB BITACORA

    Y.REFERENCE = EREPLACE(Y.ID.FT, "FT", "RV")

    EB.DataAccess.FRead(FN.FT,Y.ID.FT,REC.FT,F.FT,ERR.FT)

    IF ERR.FT THEN
        Y.ID.FT.HIS = Y.ID.FT : ";1"
        EB.DataAccess.FRead(FN.FT.HIS,Y.ID.FT.HIS,REC.FT,F.FT.HIS,ERR.FT)
    END

    Y.FT.TRANSACTION = REC.FT<FT.Contract.FundsTransfer.TransactionType>

    FIND Y.FT.TRANSACTION IN Y.REC.PARAM<AbcTable.AbcEmailSmsParameter.Transaction> SETTING Ap,Vp THEN
        Y.TRANS.TYPE = Y.REC.PARAM<AbcTable.AbcEmailSmsParameter.TranType,Vp>
    END ELSE
        Y.SALIR = 'S'
    END

    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER',"CTA.EXT.TRANSF",CTA.EXT.TRANSF.POS)

    Y.AMOUNT = REC.FT<FT.Contract.FundsTransfer.DebitAmount>
    IF Y.AMOUNT EQ '' THEN
        Y.AMOUNT = REC.FT<FT.Contract.FundsTransfer.CreditAmount>
    END

    Y.TIME = REC.FT<FT.Contract.FundsTransfer.DateTime>[7,2]:":":REC.FT<FT.Contract.FundsTransfer.DateTime>[9,2]

    IF Y.TRANS.TYPE EQ 'ATM' THEN
        IF REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>[1,3] EQ 'MXN' THEN
            Y.DEBIT.ACCT = ''
            Y.CREDIT.ACCT = REC.FT<FT.Contract.FundsTransfer.CreditAcctNo>
            Y.CUSTOMER = REC.FT<FT.Contract.FundsTransfer.CreditCustomer>
        END ELSE
            Y.DEBIT.ACCT = REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>
            Y.CUSTOMER = REC.FT<FT.Contract.FundsTransfer.DebitCustomer>

            IF REC.FT<FT.Contract.FundsTransfer.CreditAcctNo>[1,3] EQ 'MXN' THEN
                Y.CREDIT.ACCT = ''
            END ELSE
                Y.CREDIT.ACCT = REC.FT<FT.Contract.FundsTransfer.CreditAcctNo>
            END
        END
    END

    GOSUB ESCRIBE.REGISTRO

RETURN

*****************
ESCRIBE.REGISTRO:
*****************

    IF Y.SALIR EQ 'S' THEN RETURN
    Y.REC<AbcTable.AbcSmsEmailToSend.CustomerId> = Y.CUSTOMER
    Y.REC<AbcTable.AbcSmsEmailToSend.DebitAcctNo> = Y.DEBIT.ACCT
    Y.REC<AbcTable.AbcSmsEmailToSend.CreditAcctNo> = Y.CREDIT.ACCT
    Y.REC<AbcTable.AbcSmsEmailToSend.TransType> = Y.TRANS.TYPE
    Y.REC<AbcTable.AbcSmsEmailToSend.Amount> = Y.AMOUNT
    Y.REC<AbcTable.AbcSmsEmailToSend.DateTime> = Y.TIME
    Y.REC<AbcTable.AbcSmsEmailToSend.Status> = 'R'
    Y.REC<AbcTable.AbcSmsEmailToSend.OldEmail> = Y.OLD.EMAIL
    Y.REC<AbcTable.AbcSmsEmailToSend.OldMovil> = Y.OLD.MOVIL
    Y.REC<AbcTable.AbcSmsEmailToSend.NewEmail> = Y.NEW.EMAIL
    Y.REC<AbcTable.AbcSmsEmailToSend.NewMovil> = Y.NEW.MOVIL
    Y.REC<AbcTable.AbcSmsEmailToSend.ValueDate> = EB.SystemTables.getToday()
    Y.REC<AbcTable.AbcSmsEmailToSend.Inputter> = EB.SystemTables.getRNew(V - 6)
    Y.REC<AbcTable.AbcSmsEmailToSend.Authoriser> = Y.AUTH.USR

    EB.DataAccess.FWrite(FN.ABC.SMS.EMAIL.TO.SEND,Y.REFERENCE,Y.REC)

    Y.REC = ''

RETURN
*****
INIT:
*****

    Y.CUSTOMER = ''
    Y.CUST.NAME = ''

    Y.ACC.REC = ''
    Y.CREDIT.ACCT = ''
    Y.DEBIT.ACCT = ''
    Y.AMOUNT = ''
    Y.REFERENCE = ''
    Y.TIME = ''
    Y.TRANS.TYPE = ''
    Y.REC.PARAMETER = ''
    Y.REC = ''
    Y.FT.TRANSACTION = ''
    Y.SALIR = ''
    Y.JULDATE = EB.SystemTables.getRDates(EB.Utility.Dates.DatJulianDate)[3,5]
    Y.EMAIL.POS = ''
    Y.MOVIL.POS = ''
    Y.OLD.EMAIL = ''
    Y.OLD.MOVIL = ''
    Y.NEW.EMAIL = ''
    Y.NEW.MOVIL = ''
    Y.AUTH.USR = ''

    Y.CTA.TERCERO.ALTA = ''
    Y.CTA.TERCERO.MODI = ''
    Y.CTA.TERCERO.BAJA = ''
    Y.CTA.INTERBA.ALTA = ''
    Y.CTA.INTERBA.MODI = ''
    Y.CTA.INTERBA.BAJA = ''
    Y.CTA.CREDITO.ALTA = ''
    Y.CTA.CREDITO.MODI = ''
    Y.CTA.CREDITO.BAJA = ''
    Y.CTA.DEBITO.ALTA = ''
    Y.CTA.DEBITO.MODI = ''
    Y.CTA.DEBITO.BAJA = ''

    Y.CTA.CELULAR.ALTA = ''
    Y.CTA.CELULAR.MODI = ''
    Y.CTA.CELULAR.BAJA = ''
    Y.CTA.TERCERO = ''
    Y.CTA.INTERBA = ''
    Y.CTA.CREDITO = ''
    Y.CTA.DEBITO = ''
    Y.CTA.CELULAR = ''
    Y.BANDERA.REV = ''
    Y.SAVE.REF = ''

RETURN
***********

*********
BITACORA:
*********

    WRITESEQ TIMEDATE():" ":MENSAJE APPEND TO FILE.VAR1 ELSE
    END
    MENSAJE = ''
RETURN


END
