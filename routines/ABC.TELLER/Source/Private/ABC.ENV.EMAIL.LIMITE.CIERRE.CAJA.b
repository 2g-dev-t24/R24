*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.ENV.EMAIL.LIMITE.CIERRE.CAJA
*===============================================================================
* Nombre de Programa : ABC.ENV.EMAIL.LIMITE.CIERRE.CAJA
* Compania           : 
* Req. Jira          : 
* Objetivo           : Rutina que guarda informacion en ABC.SMS.EMAIL.ENVIAR
*                      para notificacion de correo EMAIL.LIMITE.CAJA.BOVEDA si al
*                      momento de cierre de caja se excedio el saldo permitido
* Desarrollador      : 
* Fecha Creacion     : 
* Modificaciones:
*===============================================================================

    $USING AbcTable
    $USING BF.ConBalanceUpdates
    $USING ST.Config
    $USING TT.Contract
    $USING EB.DataAccess
    $USING AbcGetGeneralParam
    $USING EB.SystemTables
    
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

    RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    FN.ABC.SMS.EMAIL.ENVIAR = 'F.ABC.SMS.EMAIL.ENVIAR'
    F.ABC.SMS.EMAIL.ENVIAR = ''
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR,F.ABC.SMS.EMAIL.ENVIAR)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    EB.DataAccess.Opf(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    FN.DEPT.ACCT.OFFICER = "F.DEPT.ACCT.OFFICER"
    F.DEPT.ACCT.OFFICER = ""
    EB.DataAccess.Opf(FN.DEPT.ACCT.OFFICER, F.DEPT.ACCT.OFFICER)

    Y.DATE.TIME  = EB.SystemTables.getRNew(TT.Contract.TellerId.TidDateTime)
    Y.ID.DAO  = EB.SystemTables.getRNew(TT.Contract.TellerId.TidDeptCode)
    Y.STATUS.CAJA = EB.SystemTables.getRNew(TT.Contract.TellerId.TidStatus)
    Y.CTA.CAJA = ''
    Y.CANAL.ENTIDAD = ''

    GOSUB GET.DATA.PARAM

    RETURN
*-------------------------------------------------------------------------------
GET.DATA.PARAM:
*-------------------------------------------------------------------------------

    Y.ID.GEN.PARAM = 'LIMITE.CAJA.BOV'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'ABC.EMAIL.NOT.CAJA.BOVEDA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.EMAIL.NOTIF = Y.LIST.VALUES<Y.POS.PARAM>
    END

    LOCATE 'LIMITE.CAJA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.LIMITE.CAJA = Y.LIST.VALUES<Y.POS.PARAM>
    END

    LOCATE 'LIMITE.BOVEDA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.LIMITE.BOVEDA = Y.LIST.VALUES<Y.POS.PARAM>
    END

    Y.TIPO.EMAIL = "EMAIL.LIMITE.CAJA.BOVEDA"
    R.DATOS = ''
    Y.ERR.PARAM = ''

    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.TIPO.EMAIL,R.DATOS,F.ABC.GENERAL.PARAM,Y.ERR.PARAM)

    Y.ASUNTO.EMAIL = R.DATOS<AbcTable.AbcGeneralParam.Modulo>
    Y.LIST.PARAMS = RAISE(R.DATOS<AbcTable.AbcGeneralParam.NombParametro>)
    Y.LIST.VALUES = RAISE(R.DATOS<AbcTable.AbcGeneralParam.DatoParametro>)

    LOCATE 'ALERTA.CIERRE.DIA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.CADENA.EMAIL = Y.LIST.VALUES<Y.POS.PARAM>
    END

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

    R.DAO = ''
    Y.ERR.DAO = ''
    EB.DataAccess.FRead(FN.DEPT.ACCT.OFFICER, Y.ID.DAO, R.DAO, F.DEPT.ACCT.OFFICER, Y.ERR.DAO)
    IF R.DAO THEN
        Y.NOMBRE.SUCURSAL = R.DAO<ST.Config.DeptAcctOfficer.EbDaoDeliveryPoint>
    END

    Y.ID.CAJA = EB.SystemTables.getIdNew()
    Y.WORKING.BALANCE = EB.SystemTables.getRNew(TT.Contract.TellerId.TidTillClosBal) * -1

    IF (Y.STATUS.CAJA EQ 'CLOSE') AND (Y.WORKING.BALANCE GT Y.LIMITE.CAJA) THEN
        Y.NO.CUENTA = Y.CTA.CAJA
        Y.MONTO = Y.WORKING.BALANCE
        Y.BENEFICIARIO = 'Caja'
        GOSUB ESCRIBE.REGISTRO
    END

    RETURN
*-----------------------------------------------------------------------------
ESCRIBE.REGISTRO:
*-----------------------------------------------------------------------------

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]

    GOSUB OBTIENE.ID

    REC.ABC.SMS.EMAIL.ENVIAR = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>   = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail>  = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>      = Y.CADENA.EMAIL   ;*LFCR_NOTFIF_DIA_CIERRE_20250123 - S - E
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>        = Y.EMAIL.NOTIF
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NombreBen> = Y.BENEFICIARIO
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>       = Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Banco>       = Y.NOMBRE.SUCURSAL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>        = FMT(Y.MONTO, "R2,& #20")
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Hora>         = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>        = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.FechaHora>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI


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

    ID.ABC.SMS.EMAIL.ENVIAR  = Y.ID.CAJA:'-':EB.SystemTables.getToday():'.':TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR := TIMEDATE()[4,2]:TIMEDATE()[7,2]:Y.PROCESO.MILI

    RETURN

*-----------------------------------------------------------------------------
FINALIZE:
*-----------------------------------------------------------------------------

    RETURN

END
