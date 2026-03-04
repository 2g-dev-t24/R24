* @ValidationCode : MjotODI0NjU5MDM4OkNwMTI1MjoxNzU1NDU4MDA5OTA1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Feb 2026 12:13:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : C�sarMiranda
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.ENV.EMAIL.BONIF
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING CG.ChargeConfig
    $USING AbcTable
    $USING FT.Contract
    $USING EB.DataAccess
    $USING AbcGetGeneralParam
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING ST.Customer
*-----------------------------------------------------------------------------
    GOSUB INICIO
    GOSUB PROCESO
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------

    FN.ABC.SMS.EMAIL.ENVIAR = "F.ABC.SMS.EMAIL.ENVIAR"
    FV.ABC.SMS.EMAIL.ENVIAR = ""
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR, FV.ABC.SMS.EMAIL.ENVIAR)

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    FV.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, FV.ABC.GENERAL.PARAM)

    FN.CLIENTE = 'F.CUSTOMER'
    FV.CLIENTE = ''
    EB.DataAccess.Opf(FN.CLIENTE, FV.CLIENTE)

    FN.CUENTA = 'F.ACCOUNT'
    FV.CUENTA = ''
    EB.DataAccess.Opf(FN.CUENTA, FV.CUENTA)

*    CALL GET.LOCAL.REFM("ACCOUNT", "CANAL", Y.POS.CANAL.ACC) TENGO QEU CAMBIAR ESTO

    Y.TIPO.EMAIL = "EMAIL.BONIFICACION"
    Y.MONTO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.NO.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.NO.REF = EB.SystemTables.getIdNew()
    Y.DATE.TIME = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)

    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.TIPO.EMAIL, R.DATOS, FV.ABC.GENERAL.PARAM, ERR.PARAM)
    Y.ASUNTO.EMAIL = R.DATOS<AbcTable.AbcGeneralParam.Modulo>
    Y.LIST.PARAMS = RAISE(R.DATOS<PBS.GEN.PARAM.NOMB.PARAMETRO>)
    Y.LIST.VALUES = RAISE(R.DATOS<PBS.GEN.PARAM.DATO.PARAMETRO>)

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

    EB.DataAccess.FRead(FN.CUENTA, Y.NO.CUENTA, R.CUENTA, FV.CUENTA, ERR.CUENTA)
    Y.ID.CUS = R.CUENTA<AC.AccountOpening.Account.Customer>
    Y.WORKING.BALANCE = R.CUENTA<AC.AccountOpening.Account.WorkingBalance>
*   Y.CANAL.ENTIDAD = R.CUENTA<AC.LOCAL.REF, Y.POS.CANAL.ACC>
    Y.CANAL.ENTIDAD = 13
    IF Y.CANAL.ENTIDAD EQ '' THEN Y.NO.CUENTA = RIGHT(Y.NO.CUENTA,4)
    
    Y.COMI = Y.ID.CUS:'*1'
    EB.SystemTables.setComi(Y.COMI)
    Y.NOMBRE = ''
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE,MSG)
    
    EB.DataAccess.FRead(FN.CLIENTE, Y.ID.CUS, R.CUSTOMER, FV.CLIENTE, ERR.PARAM)
    Y.RESUL.EMAIL = R.CUSTOMER<ST.Customer.Customer.EbCusEmailOne>
    GOSUB OBTIENE.ID

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]

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

    WRITE REC.ABC.SMS.EMAIL.ENVIAR TO FV.ABC.SMS.EMAIL.ENVIAR, ID.ABC.SMS.EMAIL.ENVIAR

RETURN

*-----------------------------------------------------------------------------
OBTIENE.ID:
*-----------------------------------------------------------------------------

    Y.CLIENTE = ''
    Y.CLIENTE = Y.ID.CUS
    TODAY = EB.SystemTables.getToday()
    ID.ABC.SMS.EMAIL.ENVIAR  = Y.CLIENTE:"-":TODAY:".":TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR := TIMEDATE()[4,2]:TIMEDATE()[7,2]

RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


RETURN
END
*-----------------------------------------------------------------------------

END
