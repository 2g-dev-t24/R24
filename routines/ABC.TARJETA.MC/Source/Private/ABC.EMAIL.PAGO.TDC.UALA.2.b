* @ValidationCode : Mjo0MjIxMDcxNjpDcDEyNTI6MTc2NzY2OTYyMjY2MTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Jan 2026 00:20:22
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
$PACKAGE AbcTarjetaMc


SUBROUTINE ABC.EMAIL.PAGO.TDC.UALA.2
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING AbcGetGeneralParam
    $USING FT.Contract
    $USING AbcSpei
    $USING ST.Customer
    $USING EB.Updates
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.NO.CUENTA  = ''
    Y.TIPO.EMAIL = "EMAIL.PAGO.TDC.2"
    Y.MONTO      = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.NO.CUENTA  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.NO.REF     = EB.SystemTables.getIdNew()
    Y.DATE.TIME  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)
    Y.POS.CANAL.ACC = ''

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.ABC.SMS.EMAIL.ENVIAR = "F.ABC.SMS.EMAIL.ENVIAR"
    F.ABC.SMS.EMAIL.ENVIAR  = ""
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR)

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER  = ""
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    
    FN.ABC.ACCT.LCL.FLDS = "F.ABC.ACCT.LCL.FLDS"
    F.ABC.ACCT.LCL.FLDS  = ""
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)

   
    Y.APP = "FUNDS.TRANSFER"
    Y.FLD = "EXT.TRANS.ID"
    Y.POS.FLD = ''
    EB.Updates.MultiGetLocRef(Y.APP, Y.FLD, Y.POS.FLD)
    Y.POS.EXT.TRANS.ID = Y.POS.FLD<1,1>
   

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    GOSUB GET.FILE.PARAM

    R.ACCOUNT     = ''
    Y.ERR.ACCOUNT = ''
    Y.ID.CUS      = ''
    Y.WORKING.BALANCE = ''
    Y.CANAL.ENTIDAD   = ''

    EB.DataAccess.FRead(FN.ACCOUNT, Y.NO.CUENTA, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACCOUNT)
    IF R.ACCOUNT THEN
        
        Y.AA = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
        
        EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS, Y.AA, R.ABC.ACCT.LCL.FLDS, F.ABC.ACCT.LCL.FLDS, Y.ERR.ACCOUNT)
        
        Y.ID.CUS          = R.ACCOUNT<AC.AccountOpening.Account.Customer>
        Y.WORKING.BALANCE = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>
        Y.CANAL.ENTIDAD   = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Canal>
        Y.ALT.ACCT.ID = R.ACCOUNT<AC.AccountOpening.Account.AltAcctId>
        Y.PRN = Y.ALT.ACCT.ID<6>
    END

    Y.ID.TRANSACCION = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.EXT.TRANS.ID>

    IF Y.CANAL.ENTIDAD EQ '' THEN Y.NO.CUENTA = RIGHT(Y.NO.CUENTA,4)

    COMI = Y.ID.CUS:'*1'
    Y.NOMBRE = ''
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(COMI, Y.NOMBRE,MSG)
    

    R.CUSTOMER = ''
    Y.ERR.CUSTOMER = ''
    EB.DataAccess.FRead(FN.CUSTOMER, Y.ID.CUS, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUSTOMER)
    IF R.CUSTOMER THEN
        Y.RESUL.EMAIL = R.CUSTOMER<ST.Customer.Customer.EbCusEmailOne>
    END

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]

    GOSUB OBTIENE.ID

    REC.ABC.SMS.EMAIL.ENVIAR = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Customer>     = Y.CLIENTE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>   = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail> = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>       = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>        = Y.RESUL.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>       = Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>        = FMT(Y.MONTO, "R2,& #20")
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Hora>         = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>        = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Referencia>   = Y.NO.REF
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.FechaHora>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Canal>        = Y.CANAL.ENTIDAD
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.ExtTransId> = Y.ID.TRANSACCION
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Prn>          = Y.PRN

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

*-------------------------------------------------------------------------------
GET.FILE.PARAM:
*-------------------------------------------------------------------------------

    R.ABC.GENERAL.PARAM = ''
    ERR.PARAM = ''
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.TIPO.EMAIL,R.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM,ERR.PARAM)
    IF R.ABC.GENERAL.PARAM THEN
        Y.ASUNTO.EMAIL = R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.Modulo>
        Y.LIST.PARAMS = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>)
        Y.LIST.VALUES = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>)

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

    END

RETURN

*-------------------------------------------------------------------------------
OBTIENE.ID:
*-------------------------------------------------------------------------------

    Y.CLIENTE = ''
    Y.CLIENTE = Y.ID.CUS
    TODAY = EB.SystemTables.getToday()
    ID.ABC.SMS.EMAIL.ENVIAR  = Y.CLIENTE:"-":TODAY:".":TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR := TIMEDATE()[4,2]:TIMEDATE()[7,2]:Y.PROCESO.MILI

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------



RETURN

END


END
