* @ValidationCode : Mjo1NzMxMzYzMDg6Q3AxMjUyOjE3Njc2Njk3Njc1OTg6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Jan 2026 00:22:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
SUBROUTINE ABC.REGISTRA.EMAIL.CHQ
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcSpei
    $USING AbcTable
    $USING AC.AccountOpening
    $USING ST.Customer

    GOSUB INICIO
    GOSUB PROCESO
    GOSUB FINAL

RETURN

*******
INICIO:
*******

    FN.ABC.SMS.EMAIL.ENVIAR = "F.ABC.SMS.EMAIL.ENVIAR"
    F.ABC.SMS.EMAIL.ENVIAR = ""
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR)

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    FN.CLIENTE = 'F.CUSTOMER'
    F.CLIENTE = ''
    EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS, F.ABC.ACCT.LCL.FLDS)

    Y.TIPO.EMAIL = "EMAIL.CHQ"
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.TIPO.EMAIL,R.DATOS,F.ABC.GENERAL.PARAM,ERR.PARAM)
    Y.ASUNTO.EMAIL = R.DATOS<AbcTable.AbcGeneralParam.Modulo>

    Y.LIST.PARAMS = RAISE(R.DATOS<AbcTable.AbcGeneralParam.NombParametro>)
    Y.LIST.VALUES = RAISE(R.DATOS<AbcTable.AbcGeneralParam.DatoParametro>)

    LOCATE "Y.CANAL.EMAIL" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CANAL.EMAIL.LISTA = Y.LIST.VALUES<POS>
        CHANGE ',' TO @FM IN Y.CANAL.EMAIL.LISTA
    END ELSE
        Y.CANAL.EMAIL.LISTA = 'VACIO'
    END

    LOCATE "Y.CANAL.ALTERNA" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CANAL.ALTERNA.LISTA = Y.LIST.VALUES<POS>
        CHANGE ',' TO @FM IN Y.CANAL.ALTERNA.LISTA
    END ELSE
        Y.CANAL.ALTERNA.LISTA = 'VACIO'
    END
    
    TODAY = EB.SystemTables.getToday()

RETURN

********
PROCESO:
********

    Y.NO.CUENTA = EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.Cuenta)
    Y.FECHA = EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.DateTime)
    Y.LONG.CTA = LEN(Y.NO.CUENTA)-3
    Y.MONTO = EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.MontoLocal)

    R.CUENTA = ''; ER.CUENTA = ''

    EB.DataAccess.FRead(FN.ACCOUNT,Y.NO.CUENTA,R.CUENTA,F.ACCOUNT,ER.CUENTA)

    IF R.CUENTA EQ '' THEN
        Y.ID.CUS = R.CUENTA<AC.AccountOpening.Account.Customer>

        ACC.ID.FLDS = R.CUENTA<AC.AccountOpening.Account.ArrangementId>

        EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,ACC.ID.FLDS,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,Y.ABC.ACCT.LCL.FLDS.ERR)
        Y.CANAL = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Canal>

    END

    Y.COMI = Y.ID.CUS:'*1'
    Y.NOMBRE = ''
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE,MSG)

    Y.RESUL.CUS = R.CUENTA<AC.AccountOpening.Account.Customer>
*    CALL DBR('CUSTOMER':FM:EB.CUS.EMAIL.1,Y.RESUL.CUS,Y.RESUL.EMAIL)
    EB.DataAccess.FRead(FN.CLIENTE,Y.ID.CUS,R.INFO.CLIENTE,F.CLIENTE,ERROR.CLIENTE)
    Y.RESUL.EMAIL = R.INFO.CLIENTE<ST.Customer.Customer.EbCusEmailOne>
    GOSUB OBTIENE.ID

    R.INFO.SMS.EMAIL = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Customer>     = Y.RESUL.CUS
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>   = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail> = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>       = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>        = Y.RESUL.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>       = Y.NO.CUENTA[Y.LONG.CTA,4]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>      = FMT(Y.MONTO, "R2,& #20")     ;*FMT(Y.MONTO, "R2#10")
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>        = '20':Y.FECHA[1,2]:'-':Y.FECHA[3,2]:'-':Y.FECHA[5,2]

    LOCATE Y.CANAL IN Y.CANAL.EMAIL.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaEmail> = 'NO'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaEmail> = 'SI'
    END

    LOCATE Y.CANAL IN Y.CANAL.ALTERNA.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaAlterna> = 'SI'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaAlterna> = 'NO'
    END

    EB.DataAccess.FWrite(FN.ABC.SMS.EMAIL.ENVIAR, ID.ABC.SMS.EMAIL.ENVIAR, REC.ABC.SMS.EMAIL.ENVIAR)

RETURN

***********
OBTIENE.ID:
***********

    ID.ABC.SMS.EMAIL.ENVIAR = Y.RESUL.CUS:"-":TODAY:".":TIMEDATE()[1,2]:TIMEDATE()[4,2]:TIMEDATE()[7,2]

RETURN

******
FINAL:
******

RETURN

END
