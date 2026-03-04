* @ValidationCode : MjoxMjQ5NjczOTAzOkNwMTI1MjoxNzY3NjY3NTI5NDU0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2026 23:45:29
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
$PACKAGE AbcBi
*-----------------------------------------------------------------------------
SUBROUTINE ABC.ENV.EMAIL.ACT.CONTACTO
*===============================================================================
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING AbcTable
    $USING EB.Updates
    $USING AbcSpei

    GOSUB INICIO
    GOSUB PROCESO
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------

    FN.ABC.SMS.EMAIL.ENVIAR = "F.ABC.SMS.EMAIL.ENVIAR"
    F.ABC.SMS.EMAIL.ENVIAR = ""
    EB.DataAccess.Opf(FN.ABC.SMS.EMAIL.ENVIAR, F.ABC.SMS.EMAIL.ENVIAR)

    FN.ALTER.ACCT = "F.ALTERNATE.ACCOUNT"
    F.ALTER.ACCT = ""
    EB.DataAccess.Opf(FN.ALTER.ACCT, F.ALTER.ACCT)

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, FV.ABC.GENERAL.PARAM)

    FN.CLIENTE = 'F.CUSTOMER'
    F.CLIENTE = ''
    EB.DataAccess.Opf(FN.CLIENTE, F.CLIENTE)

    FN.CUENTA = 'F.ACCOUNT'
    FV.CUENTA = ''
    EB.DataAccess.Opf(FN.CUENTA, F.CUENTA)


    Y.NOMBRE.CAMPO     = 'LOCALIDAD'

    EB.Updates.MultiGetLocRef("CUSTOMER", Y.NOMBRE.CAMPO, R.POS.CAMPO)
    
    POS.LOCALIDAD     = R.POS.CAMPO<1,1>


    Y.TEL.NEW = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSmsOne)
    Y.TEL.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusSmsOne)

    Y.EMAIL.NEW = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusEmailOne)
    Y.EMAIL.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusEmailOne)
    Y.EMAIL.NOTIF = '' ; SE.ACTUALIZA.EMAIL = ''

    Y.CALLE.NEW = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusStreet)
    Y.CALLE.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusStreet)
    Y.NUM.EXT.NEW = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusAddress)
    Y.NUM.EXT.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusAddress)
    Y.NUM.INT.NEW = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusAddress)
    Y.NUM.INT.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusAddress)
    Y.COD.POST.NEW = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusPostCode)
    Y.COD.POST.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusPostCode)

    Y.LOCAL.REF     = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    Y.LOCAL.REF.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusLocalRef)


    Y.COLONIA.NEW = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusSubDepartment)
    Y.COLONIA.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusSubDepartment)
    Y.DELEG.NEW = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDepartment)
    Y.DELEG.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusDepartment)
    Y.CIUDAD.NEW = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusTownCountry)
    Y.CIUDAD.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusTownCountry)
    Y.ESTADO.NEW = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusCountrySubdivision)
    Y.ESTADO.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusCountrySubdivision)
    Y.PAIS.NEW = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusCountry)
    Y.PAIS.OLD = EB.SystemTables.getROld(ST.Customer.Customer.EbCusCountry)
    Y.LOCAL.BAN.NEW = Y.LOCAL.REF<1,POS.LOCALIDAD>
    Y.LOCAL.BAN.OLD = Y.LOCAL.REF.OLD<1,POS.LOCALIDAD>

    GOSUB ARMA.CADENA.DATOS

    Y.DATE.TIME = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusDateTime)

    Y.TIPO.EMAIL = "EMAIL.ACT.CONTACTO.DIR"
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.TIPO.EMAIL, R.DATOS, F.ABC.GENERAL.PARAM, ERR.PARAM)

    Y.ASUNTO.EMAIL = R.DATOS<AbcTable.AbcGeneralParam.Modulo>
    Y.LIST.PARAMS = RAISE(R.DATOS<AbcTable.AbcGeneralParam.NombParametro>)
    Y.LIST.VALUES = RAISE(R.DATOS<AbcTable.AbcGeneralParam.DatoParametro>)

RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------

    Y.ID.CUS = EB.SystemTables.getIdNew()
    Y.NO.CUENTA = RIGHT(Y.NO.CUENTA,4)

    Y.COMI = Y.ID.CUS:'*1'
    Y.NOMBRE = ''
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE,MSG)

    Y.EMAIL.NOTIF = Y.EMAIL.NEW
    GOSUB CREA.NOTIFICACION   ;*LFCR_20240610_ACT-EMAIL S-E

    IF SE.ACTUALIZA.EMAIL EQ 1 THEN
        Y.EMAIL.NOTIF = Y.EMAIL.OLD
        GOSUB CREA.NOTIFICACION
    END

RETURN
*-----------------------------------------------------------------------------
ARMA.CADENA.DATOS:
*-----------------------------------------------------------------------------

    Y.CADENA.DATOS = "" ; Y.DOMICILIO.NEW = "" ; Y.DOMICILIO.OLD = "" ; Y.SEP = "|"

    Y.DOMICILIO.NEW  = Y.CALLE.NEW : Y.SEP : Y.NUM.EXT.NEW : Y.SEP : Y.NUM.INT.NEW : Y.SEP : Y.COD.POST.NEW : Y.SEP : Y.COLONIA.NEW
    Y.DOMICILIO.NEW := Y.SEP : Y.DELEG.NEW : Y.SEP : Y.CIUDAD.NEW : Y.SEP : Y.ESTADO.NEW : Y.SEP : Y.PAIS.NEW : Y.SEP : Y.LOCAL.BAN.NEW

    Y.DOMICILIO.OLD  = Y.CALLE.OLD : Y.SEP : Y.NUM.EXT.OLD : Y.SEP : Y.NUM.INT.OLD : Y.SEP : Y.COD.POST.OLD : Y.SEP : Y.COLONIA.OLD
    Y.DOMICILIO.OLD := Y.SEP : Y.DELEG.OLD : Y.SEP : Y.CIUDAD.OLD : Y.SEP : Y.ESTADO.OLD : Y.SEP : Y.PAIS.OLD : Y.SEP : Y.LOCAL.BAN.OLD

    IF Y.TEL.NEW NE Y.TEL.OLD THEN
        Y.CADENA.DATOS := "Tel":UTF8('�'):"fono"
    END

    IF Y.EMAIL.NEW NE Y.EMAIL.OLD THEN
        Y.EMAIL.NOTIF = Y.EMAIL.NEW
        SE.ACTUALIZA.EMAIL = 1
        IF Y.CADENA.DATOS NE "" THEN
            Y.CADENA.DATOS := ", "
        END
        Y.CADENA.DATOS := "Email"
    END

    IF Y.DOMICILIO.NEW NE Y.DOMICILIO.OLD THEN
        IF Y.CADENA.DATOS NE "" THEN
            Y.CADENA.DATOS := ", "
        END
        Y.CADENA.DATOS := "Domicilio"
    END

RETURN
*-----------------------------------------------------------------------------
OBTIENE.ID:
*-----------------------------------------------------------------------------

    Y.PROCESO.MILI = FIELD(TIMESTAMP(),'.',2)
    Y.PROCESO.MILI = Y.PROCESO.MILI [1,3]

    TODAY   = EB.SystemTables.getToday()

    Y.CLIENTE = ''
    Y.CLIENTE = Y.ID.CUS
    ID.ABC.SMS.EMAIL.ENVIAR = Y.CLIENTE:"-":TODAY:".":TIMEDATE()[1,2]:TIMEDATE()[4,2]:TIMEDATE()[7,2]:Y.PROCESO.MILI

RETURN
*-----------------------------------------------------------------------------
CREA.NOTIFICACION:
*-----------------------------------------------------------------------------

    GOSUB OBTIENE.ID
    REC.ABC.SMS.EMAIL.ENVIAR = ''
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Customer>     = Y.CLIENTE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.TipoEmail>   = Y.TIPO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.AsuntoEmail> = Y.ASUNTO.EMAIL
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Nombre>       = Y.NOMBRE
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Email>        = Y.EMAIL.NOTIF    ;*Y.EMAIL.NEW
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Cuenta>       = Y.NO.CUENTA
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.CuentaCliente>   = Y.CADENA.DATOS
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Hora>         = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.Fecha>        = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.FechaHora>   = '20':Y.DATE.TIME[1,2]:'-':Y.DATE.TIME[3,2]:'-':Y.DATE.TIME[5,2]:"T":OCONV(TIME(), "MTS"):'.':Y.PROCESO.MILI
    REC.ABC.SMS.EMAIL.ENVIAR<AbcTable.AbcSmsEmailEnviar.NotificaEmail> = 'SI'

    EB.DataAccess.FWrite(FN.ABC.SMS.EMAIL.ENVIAR, ID.ABC.SMS.EMAIL.ENVIAR, REC.ABC.SMS.EMAIL.ENVIAR)

RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


RETURN
END
*-----------------------------------------------------------------------------
