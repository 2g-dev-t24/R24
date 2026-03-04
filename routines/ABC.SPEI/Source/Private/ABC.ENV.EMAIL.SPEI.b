* @ValidationCode : MjotMjEwNjcxMTEwOkNwMTI1MjoxNzcxODkyMjcxNDU2OkPDqXNhck1pcmFuZGE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 Feb 2026 18:17:51
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

*-----------------------------------------------------------------------------
* <Rating>-86</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei

SUBROUTINE ABC.ENV.EMAIL.SPEI
*===============================================================================
* Desarrollador:
* Compania:
* Fecha:
* Descripciï¿½n:          Rutina que guarda informacion en la tabla ABC.SMS.EMAIL.ENVIAR para la notificacion de correo
*===============================================================================


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
    $USING AA.Account

    GOSUB INICIO
    GOSUB PROCESO
    GOSUB FINAL

RETURN

*********************************************
INICIO:
*********************************************

    FN.ABC.SMS.EMAIL.ENVIAR = "F.ABC.SMS.EMAIL.ENVIAR"
    F.ABC.SMS.EMAIL.ENVIAR = ""
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR)

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    FN.CLIENTE = 'F.CUSTOMER'
    F.CLIENTE = ''
    EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)

    FN.CUENTA = 'F.ACCOUNT'
    F.CUENTA = ''
    EB.DataAccess.Opf(FN.CUENTA,F.CUENTA)

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)


    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","RASTREO", POS.RASTREO)
    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","REFERENCIA", POS.REFERENCIA)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','EXT.TRANS.ID', POS.EXT.TRANS.ID)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','CTA.EXT.TRANSF', POS.CTA.EXT.TRANSF)
    
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    BEGIN CASE
        CASE EB.SystemTables.getPgmVersion() EQ ',ABC.FAST.FUNDS'         ;*(GAAB) INI
            Y.TIPO.EMAIL = "EMAIL.FAST.FUNDS"
            Y.MONTO  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
            Y.NO.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
            Y.RASTREO = EB.SystemTables.getIdNew()
        CASE EB.SystemTables.getPgmVersion() EQ ',ABC.ABONO.CODI'
            Y.TIPO.EMAIL = "EMAIL.COBRO.DIGITAL"
            Y.MONTO  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
            Y.NO.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)

            Y.RASTREO = Y.LOCAL.REF<1,POS.RASTREO>
        CASE EB.SystemTables.getPgmVersion() EQ ',ABC.OFS.SPEI.REC'
            GOSUB VALIDA.TIPO.SPEI
            Y.TIPO.EMAIL = Y.TIPO.EMAIL.SPEI
*            Y.MONTO  =   135                                                               ;* CAMB 20260223
            Y.MONTO  =  EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)     ;* CAMB 20260223
            Y.NO.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
            Y.EXT.TRANS.ID = Y.LOCAL.REF<1,POS.RASTREO>
            Y.RASTREO = EB.SystemTables.getIdNew()
        CASE EB.SystemTables.getPgmVersion() EQ ',BI.PAGO.TC'
            Y.TIPO.EMAIL = "EMAIL.PAGO.TC"
            Y.MONTO  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
            Y.NO.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)

            Y.RASTREO = EB.SystemTables.getIdNew()
    END CASE

    Y.DATE.TIME = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)
    IF Y.EXT.TRANS.ID EQ '' THEN
        Y.EXT.TRANS.ID = Y.LOCAL.REF<1,POS.EXT.TRANS.ID>
    END
    Y.NO.CUENTA.ORD = Y.LOCAL.REF<1,POS.CTA.EXT.TRANSF>

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

*********************************************
PROCESO:
*********************************************

    EB.DataAccess.FRead(FN.CUENTA,Y.NO.CUENTA,R.CUENTA,F.CUENTA,ERR.CUENTA)
    Y.ID.CUS = R.CUENTA<AC.AccountOpening.Account.Customer>
    Y.WORKING.BALANCE = R.CUENTA<AC.AccountOpening.Account.WorkingBalance>
    Y.ID.ARRAY = R.CUENTA<AC.AccountOpening.Account.ArrangementId>
    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
    
    APP.NAME = 'AA.ARR.ACCOUNT'
    FIELD.NAME ='L.CANAL'
    FIELD.POS = '';
    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    L.CANAL.POS   = FIELD.POS<1,1>
    
    FN.AA.ARR.ACCOUNT = 'F.AA.ARR.ACCOUNT'
    F.AA.ARR.ACCOUNT = ''
    EB.DataAccess.Opf(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)

***************************************INICIO 20260223 CAMB***************************************
*    SELECT.STATEMENT  = 'SELECT ' : FN.AA.ARR.ACCOUNT : ' WITH @ID LIKE ':Y.ID.ARRAY:'...'
*    ACCOUNT.LIST = ''; LIST.NAME = '': SELECTED = ''; SYSTEM.RETURN.CODE = ''
*    EB.DataAccess.Readlist(SELECT.STATEMENT,ACCOUNT.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
*
*    ID.ARR = ACCOUNT.LIST<1>
*    EB.DataAccess.FRead(FN.AA.ARR.ACCOUNT,ID.ARR,R.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT,AA.ARR.ACCOUNT.ERR)
*
*    Y.LOCAL.ARR.ACCOUNT = R.AA.ARR.ACCOUNT<AA.Account.Account.AcLocalRef>
*
*    Y.CANAL.ENTIDAD = Y.LOCAL.ARR.ACCOUNT<1,L.CANAL.POS>

    EFF.DATE = ''
    R.SETT.ID = ''
    R.SETT.COND = ''
    SETT.ERR = ''
    AA.Framework.GetArrangementConditions(Y.ID.ARRAY,'ACCOUNT','',EFF.DATE,R.SETT.ID,R.SETT.COND,SETT.ERR)
    
    R.SETT.COND = RAISE(R.SETT.COND)
    Y.LOCAL.ARR.ACCOUNT = R.SETT.COND<AA.Account.Account.AcLocalRef>
    
    Y.CANAL.ENTIDAD = Y.LOCAL.ARR.ACCOUNT<1,L.CANAL.POS>
*****************************************FIN 20260223 CAMB*****************************************

    Y.ALT.ACCT.TYPE = R.CUENTA<AC.AccountOpening.Account.AltAcctType>
    Y.ALT.ACCT.ID = R.CUENTA<AC.AccountOpening.Account.AltAcctId>
    CHANGE @VM TO @FM IN Y.ALT.ACCT.TYPE
    CHANGE @VM TO @FM IN Y.ALT.ACCT.ID
        
    LOCATE "PRN" IN Y.ALT.ACCT.TYPE SETTING POS1 THEN
        Y.PRN = Y.ALT.ACCT.ID<POS1>
    END
    
    Y.PRN = FMT(Y.PRN,"R#50")
    
    IF Y.CANAL.ENTIDAD EQ '' THEN
        Y.NO.CUENTA = RIGHT(Y.NO.CUENTA,4)
        Y.NO.CUENTA.ORD = RIGHT(Y.NO.CUENTA.ORD,4)
    END
 
*    COMI = Y.ID.CUS:'*1'                                                               ;* CAMB 20260223
*    Y.NOMBRE = EB.SystemTables.getComiEnri()                                           ;* CAMB 20260223
    Y.COMI = Y.ID.CUS:'*1'                                                              ;* CAMB 20260223
    EB.SystemTables.setComi(Y.COMI)                                                     ;* CAMB 20260223
    Y.NOMBRE    = ""                                                                    ;* CAMB 20260223
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(Y.COMI,Y.NOMBRE,MSG)

    EB.DataAccess.FRead(FN.CLIENTE,Y.ID.CUS,R.INFO.CLIENTE,F.CLIENTE,ERROR.CLIENTE)
    Y.RESUL.EMAIL = R.INFO.CLIENTE<ST.Customer.Customer.EbCusEmailOne>

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]

    GOSUB OBTIENE.ID
    Y.REFERENCIA = EB.SystemTables.getIdNew()
    R.INFO.SMS.EMAIL = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Customer>   = Y.ID.CUS
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>  = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail>  = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>   = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>   = Y.RESUL.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>   =  Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.CuentaCliente>   =  Y.NO.CUENTA.ORD
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>   = FMT(Y.MONTO, "R2,& #20")
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Hora>    = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Referencia>   = Y.REFERENCIA
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

    EB.DataAccess.FWrite(FN.ABC.SMS.EMAIL.ENVIAR, ID.ABC.SMS.EMAIL.ENVIAR, REC.ABC.SMS.EMAIL.ENVIAR)

RETURN

*********************************************
OBTIENE.ID:
*********************************************

    Y.CLIENTE = ''
    Y.CLIENTE = Y.ID.CUS
    ID.ABC.SMS.EMAIL.ENVIAR = Y.CLIENTE:"-":EB.SystemTables.getToday():".":TIMEDATE()[1,2]:TIMEDATE()[4,2]:TIMEDATE()[7,2]:Y.PROCESO.MILI

RETURN
*********************************************
VALIDA.TIPO.SPEI:
*********************************************

    Y.TIPO.EMAIL.SPEI = ''
    Y.PAYMENT.DETAILS = ''
    Y.EXTEND.INFO = ''
    Y.EMAIL.SPEI.PN.PARAM = "EMAIL.SPEI.PN"
    Y.PAYMENT.DETAILS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)<1,1>
    Y.PAYMENT.DETAILS = UPCASE(Y.PAYMENT.DETAILS)
    Y.EXTEND.INFO =  EB.SystemTables.getRNew(FT.Contract.FundsTransfer.ExtendInfo)
    Y.EXTEND.INFO = UPCASE(Y.EXTEND.INFO)

    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.EMAIL.SPEI.PN.PARAM, R.DATOS.SPEI.PN, F.ABC.GENERAL.PARAM, ERR.PARAM)
    Y.SPEI.PN.PARAMS = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>)
    Y.SPEI.PN.VALUES = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>)

    LOCATE "SPEI.PN.CADENA" IN Y.SPEI.PN.PARAMS SETTING POS THEN
        Y.STRING.PORT.NOMINA = Y.SPEI.PN.VALUES<POS>
        CHANGE '|' TO @VM IN Y.STRING.PORT.NOMINA
    END

    IF (Y.PAYMENT.DETAILS MATCHES Y.STRING.PORT.NOMINA) OR (Y.EXTEND.INFO MATCHES Y.STRING.PORT.NOMINA) THEN
        Y.TIPO.EMAIL.SPEI = Y.EMAIL.SPEI.PN.PARAM
    END ELSE
        Y.TIPO.EMAIL.SPEI = "EMAIL.SPEI.IN"
    END

RETURN
*********************************************
FINAL:
*********************************************


RETURN

END
