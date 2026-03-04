* @ValidationCode : MjoxNjQ4MzI3Nzc4OkNwMTI1MjoxNzcyMDYyNjgwNjExOkPDqXNhck1pcmFuZGE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Feb 2026 17:38:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : CésarMiranda
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.ENV.EMAIL.CASHIN.BBVA
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING AbcTable
    $USING ST.Customer
    $USING EB.Updates
    $USING AA.Framework
    $USING AA.Account
    $USING EB.LocalReferences
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    GOSUB FINALIZE
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.ABC.SMS.EMAIL.ENVIAR = 'F.ABC.SMS.EMAIL.ENVIAR'
    F.ABC.SMS.EMAIL.ENVIAR = ''
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR)

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM   = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)
    
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS   = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS, F.ABC.ACCT.LCL.FLDS)
    
    TODAY = EB.SystemTables.getToday()

***************************************INICIO 20260225 CAMB***************************************
*    APP.NAME<2> = "FUNDS.TRANSFER"
*    FIELD.NAME<2> = "EXT.TRANS.ID": @VM :"ID.ADMIN": @VM :"ID.COMI"
*
*    FIELD.POS = ""
*    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
*    Y.POS.EXT.TRANS.ID  = FIELD.POS<1,1>
*    Y.POS.ID.ADMIN      = FIELD.POS<1,2>
*    Y.POS.ID.COMI       = FIELD.POS<1,3>
    
    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","ID.ADMIN", Y.POS.ID.ADMIN)
    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","ID.COMI", Y.POS.ID.COMI)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','EXT.TRANS.ID', Y.POS.EXT.TRANS.ID)
*****************************************FIN 20260225 CAMB*****************************************
    
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)

    Y.MONTO     = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.NO.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.NO.REF    = EB.SystemTables.getIdNew()
    Y.DATE.TIME = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)
    Y.ID.TRANSACCION = Y.LOCAL.REF<1,Y.POS.EXT.TRANS.ID>

    Y.ADMIN.ID = ''
    Y.ADMIN.ID = Y.LOCAL.REF<1,Y.POS.ID.ADMIN>

    Y.COMI.ID = ''
    Y.COMI.ID = Y.LOCAL.REF<1,Y.POS.ID.COMI>

    Y.TYPE = ''

    IF Y.ADMIN.ID THEN
        Y.TYPE = Y.ADMIN.ID
    END ELSE
        Y.TYPE = Y.COMI.ID
    END

    Y.TIPO.EMAIL = 'EMAIL.BBVA.CASH.IN'
    R.DATOS = ''
    Y.ERR.PARAM = ''

    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.TIPO.EMAIL, R.DATOS, F.ABC.GENERAL.PARAM, Y.ERR.PARAM)

    Y.ASUNTO.EMAIL = R.DATOS<AbcTable.AbcGeneralParam.Modulo>
    Y.LIST.PARAMS = RAISE(R.DATOS<AbcTable.AbcGeneralParam.NombParametro>)
    Y.LIST.VALUES = RAISE(R.DATOS<AbcTable.AbcGeneralParam.DatoParametro>)

    LOCATE 'Y.CANAL.EMAIL' IN Y.LIST.PARAMS SETTING POS THEN
        Y.CANAL.EMAIL.LISTA = Y.LIST.VALUES<POS>
        CHANGE ',' TO @FM IN Y.CANAL.EMAIL.LISTA
    END ELSE
        Y.CANAL.EMAIL.LISTA = 'VACIO'
    END

    LOCATE 'Y.CANAL.ALTERNA' IN Y.LIST.PARAMS SETTING POS THEN
        Y.CANAL.ALTERNA.LISTA = Y.LIST.VALUES<POS>
        CHANGE ',' TO @FM IN Y.CANAL.ALTERNA.LISTA
    END ELSE
        Y.CANAL.ALTERNA.LISTA = 'VACIO'
    END

    LOCATE 'Y.CANAL.GALILEO' IN Y.LIST.PARAMS SETTING POS THEN
        Y.CANAL.GALILEO.LISTA = Y.LIST.VALUES<POS>
        CHANGE ',' TO @FM IN Y.CANAL.GALILEO.LISTA
    END ELSE
        Y.CANAL.GALILEO.LISTA = 'VACIO'
    END

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    R.CUENTA = ''
    Y.ERR.ACCOUNT = ''
    R.CUENTA = AC.AccountOpening.Account.Read(Y.NO.CUENTA, Y.ERR.ACCOUNT)

    Y.ID.CUS = R.CUENTA<AC.AccountOpening.Account.Customer>
    Y.WORKING.BALANCE = R.CUENTA<AC.AccountOpening.Account.WorkingBalance>
    Y.ID.ARRAY = R.CUENTA<AC.AccountOpening.Account.ArrangementId>
    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
***************************************INICIO 20260225 CAMB***************************************
*    IF R.ABC.ACCT.LCL.FLDS THEN
*        Y.CANAL.ENTIDAD = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Canal>
*        Y.PRN = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Prn>
*    END
    APP.NAME = 'AA.ARR.ACCOUNT'
    FIELD.NAME ='L.CANAL'
    FIELD.POS = '';
    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    L.CANAL.POS   = FIELD.POS<1,1>
    
    EFF.DATE = ''
    R.SETT.ID = ''
    R.SETT.COND = ''
    SETT.ERR = ''
    AA.Framework.GetArrangementConditions(Y.ID.ARRAY,'ACCOUNT','',EFF.DATE,R.SETT.ID,R.SETT.COND,SETT.ERR)
    
    R.SETT.COND = RAISE(R.SETT.COND)
    Y.LOCAL.ARR.ACCOUNT = R.SETT.COND<AA.Account.Account.AcLocalRef>
    
    Y.CANAL.ENTIDAD = Y.LOCAL.ARR.ACCOUNT<1,L.CANAL.POS>
    
    Y.ALT.ACCT.TYPE = R.CUENTA<AC.AccountOpening.Account.AltAcctType>
    Y.ALT.ACCT.ID = R.CUENTA<AC.AccountOpening.Account.AltAcctId>
    CHANGE @VM TO @FM IN Y.ALT.ACCT.TYPE
    CHANGE @VM TO @FM IN Y.ALT.ACCT.ID
        
    LOCATE "PRN" IN Y.ALT.ACCT.TYPE SETTING POS1 THEN
        Y.PRN = Y.ALT.ACCT.ID<POS1>
    END
*****************************************FIN 20260225 CAMB*****************************************

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

    REC.ABC.SMS.EMAIL.ENVIAR = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Customer>       = Y.CLIENTE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>      = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail>    = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>         = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>          = Y.RESUL.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>         = Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>          = FMT(Y.MONTO, 'R2,& #20')
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Hora>           = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>          = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Referencia>     = Y.NO.REF:' ':Y.TYPE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.FechaHora>      = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:'T':OCONV(TIME(), 'MTS'):'.':Y.PROCESO.MILI
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Canal>          = Y.CANAL.ENTIDAD
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.ExtTransId>     = Y.ID.TRANSACCION
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Prn>            = Y.PRN

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

    
*    WRITE REC.ABC.SMS.EMAIL.ENVIAR TO F.ABC.SMS.EMAIL.ENVIAR, ID.ABC.SMS.EMAIL.ENVIAR
    EB.DataAccess.FWrite(FN.ABC.SMS.EMAIL.ENVIAR, ID.ABC.SMS.EMAIL.ENVIAR, REC.ABC.SMS.EMAIL.ENVIAR)
    
RETURN
*-----------------------------------------------------------------------------
OBTIENE.ID:
*-----------------------------------------------------------------------------

    Y.CLIENTE = ''
    Y.CLIENTE = Y.ID.CUS
    ID.ABC.SMS.EMAIL.ENVIAR  = Y.CLIENTE:'-':TODAY:'.':TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR := TIMEDATE()[4,2]:TIMEDATE()[7,2]:Y.PROCESO.MILI

RETURN
*-----------------------------------------------------------------------------
FINALIZE:
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END