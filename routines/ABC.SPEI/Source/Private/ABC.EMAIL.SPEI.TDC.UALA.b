* @ValidationCode : MjoyMjYwNTI3MTQ6Q3AxMjUyOjE3Njc2Njc4MDQyNDU6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2026 23:50:04
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
*-----------------------------------------------------------------------------
* <Rating>-45</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
SUBROUTINE ABC.EMAIL.SPEI.TDC.UALA
*===============================================================================
* Nombre de Programa : ABC.EMAIL.SPEI.TDC.UALA
* Compania           : ABC Capital
* Objetivo           : Rutina que guarda informacion en ABC.SMS.EMAIL.ENVIAR para notificacion de pago de TDC UALA
* Desarrollador      :
* Fecha Creacion     :
* Modificaciones     :
*===============================================================================

    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.LocalReferences
    $USING AA.Framework
    $USING EB.Updates
    $USING  EB.Interface
    $USING FT.Contract
    $USING AbcTable
*   $INCLUDE ABC.BP I_F.ABC.GENERAL.PARAM
*   $INCLUDE ABC.BP I_F.ABC.SMS.EMAIL.ENVIAR

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

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    EB.LocalReferences.GetLocRef('ACCOUNT','CANAL',Y.POS.CANAL.ACC)
    EB.LocalReferences.GetLocRef('ACCOUNT','PRN',Y.POS.PRN)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','EXT.TRANS.ID',Y.POS.EXT.TRANS.ID)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','CTA.EXT.TRANSF',Y.POS.CTA.EXT.TRANSF)
    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","RASTREO",Y.POS.RASTREO)
    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","ID.CLIENTE.TDC",Y.POS.ID.CLIENTE.TDC)

    Y.TIPO.EMAIL = 'EMAIL.SPEI.IN.TDC.UALA'
    Y.MONTO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.DATE.TIME = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)
    Y.REFERENCIA = EB.SystemTables.getIdNew()
    
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.EXT.TRANS.ID = Y.LOCAL.REF<1,Y.POS.EXT.TRANS.ID>
    Y.NO.CUENTA.ORD = Y.LOCAL.REF<1,Y.POS.CTA.EXT.TRANSF>
    Y.RASTREO = Y.LOCAL.REF<1,Y.POS.RASTREO>

    R.DATOS = ''
    Y.ERR.PARAM = ''

    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.TIPO.EMAIL,R.DATOS,F.ABC.GENERAL.PARAM,Y.ERR.PARAM)

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

    EB.DataAccess.FRead(FN.ACCOUNT,Y.NO.CUENTA,R.CUENTA,F.ACCOUNT,Y.ERR.ACCOUNT)

    Y.WORKING.BALANCE = ''
    Y.CANAL.ENTIDAD = ''
    Y.PRN = ''

    Y.NO.CUENTA =  EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)
    Y.VAL.LEN = LEN(Y.NO.CUENTA)
    IF Y.VAL.LEN EQ 18 THEN
        Y.NO.CUENTA = Y.NO.CUENTA[7,11]
    END

    Y.ID.CUS = Y.LOCAL.REF<1,Y.POS.ID.CLIENTE.TDC>

    IF Y.CANAL.ENTIDAD EQ '' THEN
        Y.NO.CUENTA = RIGHT(Y.NO.CUENTA,4)
        Y.NO.CUENTA.ORD = RIGHT(Y.NO.CUENTA.ORD,4)
    END

    COMI = Y.ID.CUS:'*1'
*    Y.NOMBRE = EB.SystemTables.getComiEnri()
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE,MSG)

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]

    R.CLIENTE = ''
    Y.ERR.CUSTOMER = ''

    EB.DataAccess.FRead(FN.CUSTOMER,Y.ID.CUS,R.CLIENTE,F.CUSTOMER,Y.ERR.CUSTOMER)

    Y.RESUL.EMAIL = R.CLIENTE<ST.Customer.Customer.EbCusEmailOne>

    GOSUB OBTIENE.ID

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

*-----------------------------------------------------------------------------
OBTIENE.ID:
*-----------------------------------------------------------------------------

    Y.CLIENTE = ''
    Y.CLIENTE = Y.ID.CUS
    ID.ABC.SMS.EMAIL.ENVIAR  = Y.CLIENTE:'-':EB.SystemTables.getToday():'.':TIMEDATE()[1,2]
    ID.ABC.SMS.EMAIL.ENVIAR := TIMEDATE()[4,2]:TIMEDATE()[7,2]:Y.PROCESO.MILI

RETURN

*-----------------------------------------------------------------------------
FINALIZE:
*-----------------------------------------------------------------------------

RETURN

END
