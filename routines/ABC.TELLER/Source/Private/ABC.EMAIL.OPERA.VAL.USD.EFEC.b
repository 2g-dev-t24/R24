* @ValidationCode : MjoyMDUwNzE5OTkzOkNwMTI1MjoxNzY3NjY5NzAwNTc1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Jan 2026 00:21:40
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

SUBROUTINE ABC.EMAIL.OPERA.VAL.USD.EFEC
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING TT.Contract
    $USING AbcTable
    $USING AbcSpei
    $USING AbcGetGeneralParam
    $USING ST.Config
*-----------------------------------------------------------------------------
    AbcTeller.AbcValAmtUsdEmailAuth(Y.FLAG)
    IF Y.FLAG THEN
        GOSUB INITIALISE
        GOSUB OPEN.FILES
        GOSUB PROCESS
        GOSUB FINAL
    END
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.NO.CUENTA         = ''
    Y.TIPO.EMAIL        = "EMAIL.OPERACION.VAL.USD.EFECTIVO"
    Y.ID.EMAIL.PARAM    = 'ABC.EMAIL.OPER.EFEC'

    Y.MONTO             = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
    Y.NO.REF            = EB.SystemTables.getIdNew()
    Y.DATE.TIME         = EB.SystemTables.getRNew(TT.Contract.Teller.TeDateTime)
    Y.ID.DAO            = EB.SystemTables.getRNew(TT.Contract.Teller.TeDeptCode)
    Y.TRANSACTION.CODE  = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)

    Y.POS.CANAL.ACC = ''
    TODAY           = EB.SystemTables.getToday()
    Y.RESUL.EMAIL   = ''
    Y.TRANS.CODE.RETIRO     = ''
    Y.TRANS.CODE.DEPOSITO   = ''
    
RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
    FN.ABC.SMS.EMAIL.ENVIAR = 'F.ABC.SMS.EMAIL.ENVIAR'
    F.ABC.SMS.EMAIL.ENVIAR = ''
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR)

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)

    FN.DEPT.ACCT.OFFICER = 'F.DEPT.ACCT.OFFICER'
    F.DEPT.ACCT.OFFICER = ''
    EB.DataAccess.Opf(FN.DEPT.ACCT.OFFICER, F.DEPT.ACCT.OFFICER)
    
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS, F.ABC.ACCT.LCL.FLDS)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB GET.FILE.PARAM

    IF Y.TRANSACTION.CODE EQ Y.TRANS.CODE.RETIRO THEN
        Y.NO.CUENTA = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
    END ELSE
        IF Y.TRANSACTION.CODE EQ Y.TRANS.CODE.DEPOSITO THEN
            Y.NO.CUENTA = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
        END
    END
    
    R.CUENTA = AC.AccountOpening.Account.Read(Y.NO.CUENTA, Y.ERR.ACCOUNT)
    IF R.CUENTA NE '' THEN
        Y.ID.CUS = R.CUENTA<AC.AccountOpening.Account.Customer>
        Y.WORKING.BALANCE = R.CUENTA<AC.AccountOpening.Account.WorkingBalance>
        AC.LOCAL.REF = R.CUENTA<AC.AccountOpening.Account.LocalRef>
        
        Y.NO.CUENTA.LOC = R.CUENTA<AC.AccountOpening.Account.ArrangementId
        EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS, Y.NO.CUENTA.LOC, R.CUENTA.LOC, F.ABC.ACCT.LCL.FLDS, Y.ERR.CTA.LOC)
        Y.CANAL.ENTIDAD = R.CUENTA.LOC<AbcTable.AbcAcctLclFlds.Canal>
        Y.PRN           = R.CUENTA.LOC<AbcTable.AbcAcctLclFlds.Prn>
    END
    
    EB.DataAccess.FRead(FN.DEPT.ACCT.OFFICER, Y.ID.DAO, R.DAO, F.DEPT.ACCT.OFFICER, Y.ERR.DAO)
    IF R.DAO NE '' THEN
        Y.NOMBRE.SUCURSAL = R.DAO<ST.Config.DeptAcctOfficer.EbDaoDeliveryPoint>
    END

    Y.COMI = Y.ID.CUS:'*1'
    EB.SystemTables.setComi(Y.COMI)
    Y.NOMBRE = ''
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE,MSG)

*    RECORD.VAL = ST.Customer.Customer.Read(Y.ID.CUS, Y.ERR.CUS)
*    Y.RESUL.EMAIL = RECORD.VAL<ST.Customer.Customer.EbCusEmailOne>

    GOSUB OBTIENE.ID

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]

    REC.ABC.SMS.EMAIL.ENVIAR = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Customer>    = Y.ID.CUS
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>   = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail> = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>      = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>       = Y.RESUL.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>      = Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Banco>       = Y.NOMBRE.SUCURSAL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>       = FMT(Y.MONTO, "R2,& #20")
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Hora>        = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>       = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.FechaHora>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Referencia>  = Y.NO.REF
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Canal>       = Y.CANAL.ENTIDAD
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Prn>         = Y.PRN
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
*-------------------------------------------------------------------------------
GET.FILE.PARAM:
*-------------------------------------------------------------------------------
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.EMAIL.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE 'ABC.EMAIL.PLD' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.RESUL.EMAIL = Y.LIST.VALUES<Y.POS>
    END
    LOCATE 'TRANS.CODE.RETIRO.EFECTIVO' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.TRANS.CODE.RETIRO = Y.LIST.VALUES<Y.POS>
    END
    LOCATE 'TRANS.CODE.DEPOSITO.EFECTIVO' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.TRANS.CODE.DEPOSITO = Y.LIST.VALUES<Y.POS>
    END
    
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.TIPO.EMAIL, R.DATOS, F.ABC.GENERAL.PARAM, Y.ERR.PARAM)
    
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
OBTIENE.ID:
*-----------------------------------------------------------------------------
    ID.ABC.SMS.EMAIL.ENVIAR = Y.ID.CUS:"-":TODAY:".":TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR := TIMEDATE()[4,2]:TIMEDATE()[7,2]
RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
