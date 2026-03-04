$PACKAGE EB.AbcRemesas
* @ValidationCode : MjotMjA5NzE3MzQzNzpDcDEyNTI6MTc2OTI4Njc5NTU3MzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jan 2026 17:33:15
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


SUBROUTINE ABC.ENV.EMAIL.REMESA
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*===============================================================================
* Desarrollador:        Luis Cruz - FyG Solutions
* Compania:             ABC Capital
* Req. Jira:            NA
* Fecha:                2022-02-17
* Descripcion:          Rutina que guarda informacion en la tabla ABC.SMS.EMAIL.ENVIAR
* para la notificacion de correo para EMAIL.REMESAS
*===============================================================================
* Subroutine Type : VERSION RTN
* Attached to : FUNDS.TRANSFER,ABC.REMESAS
* Attached as : Auth Rtn
* Primary Purpose : Rutina de notificacion
*-----------------------------------------------------------------------
* Luis Cruz
* 19-08-2025
* Se realiza componetizacion de codigo
*-----------------------------------------------------------------------

* $INSERT I_COMMON - Not Used anymore;
* $INSERT I_EQUATE - Not Used anymore;
* $INSERT I_F.CUSTOMER - Not Used anymore;
* $INSERT I_F.ACCOUNT - Not Used anymore;
* $INSERT I_F.FUNDS.TRANSFER - Not Used anymore;
* $INSERT ABC.BP I_F.ABC.GENERAL.PARAM
* $INSERT ABC.BP I_F.ABC.SMS.EMAIL.ENVIAR
    
    $USING EB.DataAccess
    $USING EB.Updates
    $USING ST.Customer
    $USING AC.AccountOpening
    $USING EB.SystemTables
    $USING FT.Contract
    $USING AbcSpei
    $USING AbcTable
    $USING ABC.BP

    GOSUB INICIO
    GOSUB PROCESO
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    FV.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, FV.ABC.GENERAL.PARAM)
    
    applications     = ""
    fields           = ""
    applications<1>  = "ACCOUNT"
    fields<1,1>      = "CANAL"
    fields<1,2>      = "PRN"
    applications<2>  = "FUNDS.TRANSFER"
    fields<2,1>      = "EXT.TRANS.ID"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications,fields,field_Positions)
    Y.POS.CANAL.ACC = field_Positions<1,1>
    Y.POS.PRN = field_Positions<1,2>
    Y.POS.EXT.TRANS.ID = field_Positions<2,1>

    Y.TIPO.EMAIL = "EMAIL.REMESAS"
    Y.MONTO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.NO.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.NO.REF = EB.SystemTables.getIdNew()
    Y.DATE.TIME = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)
    
    Y.ID.TRANSACCION = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.EXT.TRANS.ID>
    
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.TIPO.EMAIL, R.DATOS, FV.ABC.GENERAL.PARAM, ERR.PARAM)
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
    Y.CANAL.ENTIDAD = R.CUENTA<AC.AccountOpening.Account.LocalRef, Y.POS.CANAL.ACC>
    Y.PRN = R.CUENTA<AC.AccountOpening.Account.LocalRef, Y.POS.PRN>

    IF Y.CANAL.ENTIDAD EQ '' THEN Y.NO.CUENTA = RIGHT(Y.NO.CUENTA,4)

    Y.COMI = Y.ID.CUS:'*1'
    EB.SystemTables.setComi(Y.COMI)
    Y.NOMBRE = ''
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE,MSG)

    R.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CUS, ERR.PARAM)
    Y.RESUL.EMAIL = R.CUSTOMER<ST.Customer.Customer.EbCusEmailOne>

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]

    GOSUB OBTIENE.ID

    REC.ABC.SMS.EMAIL.ENVIAR = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Customer>     = Y.CLIENTE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>   = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail> = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>       = Y.NOMBRE ;*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.NOMBRE>       = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>        = Y.RESUL.EMAIL ;*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.EMAIL>        = Y.RESUL.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>       = Y.NO.CUENTA ;*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.CUENTA>       = Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Monto>        = FMT(Y.MONTO, "R2,& #20") ;*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.MONTO>        = FMT(Y.MONTO, "R2,& #20")
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Hora>         = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2] ;*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.HORA>         = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>        = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2] ;*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.FECHA>        = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Referencia>   = Y.NO.REF ;*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.REFERENCIA>   = Y.NO.REF
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.FechaHora>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI ;*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.FECHA.HORA>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Canal>        = Y.CANAL.ENTIDAD ;*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.CANAL>        = Y.CANAL.ENTIDAD
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.ExtTransId> = Y.ID.TRANSACCION ;*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.EXT.TRANS.ID> = Y.ID.TRANSACCION
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Prn>          = Y.PRN ;*REC.ABC.SMS.EMAIL.ENVIAR<ABC.EMA.PRN>          = Y.PRN

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

    AbcTable.AbcSmsEmailEnviar.Write(ID.ABC.SMS.EMAIL.ENVIAR, REC.ABC.SMS.EMAIL.ENVIAR)

RETURN

*-----------------------------------------------------------------------------
OBTIENE.ID:
*-----------------------------------------------------------------------------

    Y.CLIENTE = ''
    Y.CLIENTE = Y.ID.CUS
    ID.ABC.SMS.EMAIL.ENVIAR = Y.CLIENTE:"-":EB.SystemTables.getToday():".":TIMEDATE()[1,2]:TIMEDATE()[4,2]:TIMEDATE()[7,2]:Y.PROCESO.MILI

RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


RETURN
END
*-----------------------------------------------------------------------------
