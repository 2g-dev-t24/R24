* @ValidationCode : Mjo2NTI2NDUzMzk6Q3AxMjUyOjE3NzA2NjU3NzY0Njc6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Feb 2026 16:36:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcTarjetaMc

SUBROUTINE ABC.ENV.EMAIL.POS.DEV
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.LocalReferences
    $USING AA.Framework
    $USING EB.Updates
    $USING EB.Interface
    $USING FT.Contract
    $USING AbcTable
    $USING AbcSpei
*-----------------------------------------------------------------------------
    GOSUB INICIO
    GOSUB PROCESO
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------

    FN.ABC.SMS.EMAIL.ENVIAR = "F.ABC.SMS.EMAIL.ENVIAR"
    F.ABC.SMS.EMAIL.ENVIAR = ""
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR)

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS, F.ABC.ACCT.LCL.FLDS)

    Y.NOMBRE.APP = "FUNDS.TRANSFER"
    Y.NOMBRE.CAMPO = "RASTREO":@VM:"EXT.TRANS.ID"
    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)
    POS.RASTREO = R.POS.CAMPO<1,1>
    POS.EXT.TRANS.ID = R.POS.CAMPO<1,2>

    Y.TIPO.EMAIL = "EMAIL.POS.DEV"
    Y.MONTO     = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)    ;*R.NEW(FT.CREDIT.AMOUNT)
    Y.NO.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    ID.NEW      = EB.SystemTables.getIdNew()
    Y.RASTREO   = ID.NEW
    Y.TIENDA.DESC   = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.ExtendInfo)
    Y.FT.LOCAL.REF  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.EXT.TRANS.ID  = Y.FT.LOCAL.REF<1,POS.EXT.TRANS.ID>
    Y.DATE.TIME     = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)

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

    LOCATE "Y.CANAL.GALILEO" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CANAL.GALILEO.LISTA = Y.LIST.VALUES<POS>
        CHANGE ',' TO @FM IN Y.CANAL.GALILEO.LISTA
    END ELSE
        Y.CANAL.GALILEO.LISTA = 'VACIO'
    END

RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------

    R.CUENTA = AC.AccountOpening.Account.Read(Y.NO.CUENTA, ERR.CUENTA)
    Y.ID.CUS = R.CUENTA<AC.AccountOpening.Account.Customer>
    Y.WORKING.BALANCE = R.CUENTA<AC.AccountOpening.Account.WorkingBalance>
    Y.ID.ARRAY = R.CUENTA<AC.AccountOpening.Account.ArrangementId>
    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
    IF R.ABC.ACCT.LCL.FLDS THEN
        Y.CANAL.ENTIDAD = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Canal>
        Y.PRN           = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Prn>
    END

    IF Y.CANAL.ENTIDAD EQ '' THEN
        Y.NO.CUENTA = RIGHT(Y.NO.CUENTA,4)
    END
    
    Y.COMI = Y.ID.CUS:'*1'
    EB.SystemTables.setComi(Y.COMI)
    Y.NOMBRE = ''
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE,MSG)

    R.CLIENTE = ''
    Y.ERR.CUSTOMER = ''
    R.CLIENTE = ST.Customer.Customer.Read(Y.ID.CUS,Y.ERR.CUSTOMER)
    Y.RESUL.EMAIL = R.CLIENTE<ST.Customer.Customer.EbCusEmailOne>

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]
    
    GOSUB OBTIENE.ID

    R.INFO.SMS.EMAIL = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Customer>   = Y.CLIENTE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>  = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail>  = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>   = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>   = Y.RESUL.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>   =   Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NombreEmpresa> = Y.TIENDA.DESC
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>   = FMT(Y.MONTO, "R2,& #20")
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Hora>    = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Referencia>   = Y.RASTREO
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.FechaHora>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Canal>        = Y.CANAL.ENTIDAD
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Prn>          = Y.PRN
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.ExtTransId> = Y.EXT.TRANS.ID

    IF Y.CANAL.ENTIDAD NE '' THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.SaldoCuenta> = Y.WORKING.BALANCE
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.EMAIL.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaEmail> = 'NO'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaEmail> = 'SI'
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.ALTERNA.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaAlterna> = 'SI'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaAlterna> = 'NO'
    END

    LOCATE Y.CANAL.ENTIDAD IN Y.CANAL.GALILEO.LISTA SETTING POS THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaGalileo> = 'SI'
    END ELSE
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaGalileo> = 'NO'
    END

    EB.DataAccess.FWrite(FN.ABC.SMS.EMAIL.ENVIAR,ID.ABC.SMS.EMAIL.ENVIAR,REC.ABC.SMS.EMAIL.ENVIAR)

RETURN

*-----------------------------------------------------------------------------
OBTIENE.ID:
*-----------------------------------------------------------------------------
    TODAY = EB.SystemTables.getToday()
    Y.CLIENTE = ''
    Y.CLIENTE = Y.ID.CUS
    ID.ABC.SMS.EMAIL.ENVIAR  = Y.CLIENTE:"-":TODAY:".":TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR := TIMEDATE()[4,2]:TIMEDATE()[7,2]:RND(100)

RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


RETURN
END
*-----------------------------------------------------------------------------












END
