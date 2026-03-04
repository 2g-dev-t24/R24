*-----------------------------------------------------------------------------
* <Rating>60</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
    SUBROUTINE ABC.ENV.EMAIL.POS.REV
*===============================================================================
* Descripción:          Rutina que guarda informacion en la tabla ABC.SMS.EMAIL.ENVIAR para
* la notificacion de correo para TIPO.EMAIL: EMAIL.POS.REV
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING AbcTable
    $USING ABC.BP

    IF EB.SystemTables.getVFunction() EQ 'R' AND EB.SystemTables.getPgmVersion() EQ ',EXPIRA.COMPRA.MC' THEN
        GOSUB INICIO
        GOSUB PROCESO
        GOSUB FINAL
    END

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

    FN.CLIENTE = 'F.CUSTOMER'
    F.CLIENTE = ''
    EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)

    FN.CUENTA = 'F.ACCOUNT'
    F.CUENTA = ''
    EB.DataAccess.Opf(FN.CUENTA,F.CUENTA)

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS, F.ABC.ACCT.LCL.FLDS)

    Y.TIPO.EMAIL = "EMAIL.POS.REV"
    Y.MONTO = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLockedAmount)
    Y.NO.CUENTA = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckAccountNumber)
    Y.NO.ACLK = EB.SystemTables.getIdNew()

    Y.LEN.CTA = LEN(Y.NO.CUENTA)
    Y.DATE.TIME = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckDateTime)

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

    EB.DataAccess.FRead(FN.CUENTA,Y.NO.CUENTA,R.CUENTA,F.CUENTA,ERR.CUENTA)
    Y.ID.CUS = R.CUENTA<AC.AccountOpening.Account.Customer>
    Y.WORKING.BALANCE = R.CUENTA<AC.AccountOpening.Account.WorkingBalance>

    Y.ID.ARRAY = R.CUENTA<AC.AccountOpening.Account.ArrangementId>
    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
    IF R.ABC.ACCT.LCL.FLDS THEN

      Y.CANAL.ENTIDAD = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Canal>
      Y.PRN           = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Prn>
    END

    Y.LOCKED.AMOUNT = R.CUENTA<AC.AccountOpening.Account.LockedAmount>

    IF Y.CANAL.ENTIDAD EQ '' THEN Y.NO.CUENTA = RIGHT(Y.NO.CUENTA,4)

    EB.SystemTables.setComi(Y.ID.CUS:'*1')
    ABC.BP.VpmVCustomerName()
    Y.NOMBRE = EB.SystemTables.getComiEnri()

    EB.DataAccess.Dbr('CUSTOMER':@FM:EB.CUS.EMAIL.1,Y.ID.CUS,Y.RESUL.EMAIL)

    GOSUB OBTIENE.ID

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]

    R.INFO.SMS.EMAIL = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Customer>   = Y.CLIENTE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>  = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail>  = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>   = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>   = Y.RESUL.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>   =  Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>   = FMT(Y.MONTO, "R2,& #20")
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Hora>    = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Referencia>   = Y.NO.ACLK
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.FechaHora>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Canal>        = Y.CANAL.ENTIDAD
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Prn>          = Y.PRN

    IF Y.CANAL.ENTIDAD NE '' THEN
        REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.SaldoCuenta> = Y.LOCKED.AMOUNT
    END

    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaEmail> = 'NO'

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

    Y.CLIENTE = ''
    Y.CLIENTE = Y.ID.CUS
    ID.ABC.SMS.EMAIL.ENVIAR = Y.CLIENTE:"-":EB.SystemTables.getToday():".":TIMEDATE()[1,2]:TIMEDATE()[4,2]:TIMEDATE()[7,2]

    RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


    RETURN
END
