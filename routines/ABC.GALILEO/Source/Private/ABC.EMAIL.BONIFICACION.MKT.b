* @ValidationCode : Mjo1MzcxNjAwMzg6Q3AxMjUyOjE3NzA2NTczMTYxMDk6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Feb 2026 14:15:16
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
*===============================================================================
* <Rating>40</Rating>
*===============================================================================
$PACKAGE AbcGalileo
SUBROUTINE ABC.EMAIL.BONIFICACION.MKT
*===============================================================================
* Nombre de Programa : ABC.EMAIL.BONIFICACION.MKT
* Objetivo           : Rutina que guarda informacion en la tabla ABC.SMS.EMAIL.ENVIAR
*                      para la notificacion de Bonificacion MKT
*===============================================================================
* Modificaciones:
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING AbcTable
    $USING ABC.BP
    $USING ST.Customer
    $USING AbcSpei
    $USING FT.Contract
    
    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.NO.CUENTA  = ''
    Y.TIPO.EMAIL = "EMAIL.BONIFICA.MKT"
    Y.MONTO      = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.NO.CUENTA  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
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

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS   = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS, F.ABC.ACCT.LCL.FLDS)

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

    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.NO.CUENTA, Y.ERR.ACCOUNT)
    Y.ID.CUS          = R.ACCOUNT<AC.AccountOpening.Account.Customer>
    Y.WORKING.BALANCE = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>
    Y.ID.ARRAY = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
    IF R.ABC.ACCT.LCL.FLDS THEN
        Y.CANAL.ENTIDAD = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Canal>
    END

    IF Y.CANAL.ENTIDAD EQ '' THEN Y.NO.CUENTA = RIGHT(Y.NO.CUENTA,4)

*    EB.SystemTables.setComi(Y.ID.CUS:'*1')
*    ABC.BP.VpmVCustomerName()
*    Y.NOMBRE = EB.SystemTables.getComiEnri()
    Y.COMI = Y.ID.CUS:'*1'
    EB.SystemTables.setComi(Y.COMI)
    MSG = EB.SystemTables.getMessage()
    Y.NOMBRE    = ""
    AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE,MSG)

    R.CUSTOMER = ''
    Y.ERR.CUSTOMER = ''
    R.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CUS,Y.ERR.CUSTOMER)
    Y.RESUL.EMAIL = R.CUSTOMER<ST.Customer.Customer.EbCusEmailOne>

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
    ID.ABC.SMS.EMAIL.ENVIAR  = Y.CLIENTE:"-":EB.SystemTables.getToday():".":TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR := TIMEDATE()[4,2]:TIMEDATE()[7,2] :Y.PROCESO.MILI

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------


RETURN

END
