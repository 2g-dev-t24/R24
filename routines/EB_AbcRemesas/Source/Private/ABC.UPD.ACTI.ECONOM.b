* @ValidationCode : MjotNjgwNTI4MTMzOkNwMTI1MjoxNzU2ODQwOTk5NDI2OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 Sep 2025 14:23:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE EB.AbcRemesas
SUBROUTINE ABC.UPD.ACTI.ECONOM
*===============================================================================
* Nombre de Programa : ABC.UPD.ACTI.ECONOM
* Compania           : ABC Capital
* Req. Jira          : NA
* Objetivo           : Rutina para actualizar en registro de MXBASE.ADD.CUSTOMER.DETAILS
*                      el campo BANXICO.ECO.ACTIVITY con ID de catalogo MXBASE.REGULATORY.CODES
* Desarrollador      : Luis Cruz - Fyg Solutions
* Fecha Creacion     : 2025-08-28
* Modificaciones     :
*===============================================================================
* Subroutine Type : VERSION RTN
* Attached to : ABC.CUSTOMER.ABC.ALTA.DIGITAL.API,ABC.ACT.DAT.REME
* Attached as : Auth Rtn
* Primary Purpose : Rutina de actualizacion de registros en tablas de CUSTOMER
*-----------------------------------------------------------------------
* Luis Cruz
* 28-08-2025
* Creacion de rutina componentizada
*-----------------------------------------------------------------------
* $INSERT I_COMMON - Not Used anymore;
* $INSERT I_EQUATE - Not Used anymore;
* $INSERT I_F.AC.LOCKED.EVENTS - Not Used anymore;

    $USING EB.DataAccess
    $USING MXBASE.CustomerRegulatory
    $USING EB.Foundation
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.Interface
    $USING EB.SystemTables
    $USING AbcSpei
    $USING AbcTable
    $USING ABC.BP
    $USING EB.ErrorProcessing
    $USING EB.Template
    
    GOSUB INITIALIZE
    GOSUB FINALIZE

RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    FV.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, FV.ABC.GENERAL.PARAM)

    Y.ID.CLIENTE = ''
    Y.ID.CLIENTE = EB.SystemTables.getIdNew()
    Y.OFS.SOURCE = ''
    Y.NOMB.PARAM = ''
    Y.DATA.PARAM = ''
    Y.USR = ''
    Y.PWD = ''
    Y.VERSION = ''
    Y.APPLICATION = ''
    Y.ID.COM.PARAM = 'ABC.ACTUALIZA.CUS.PARAM'
;*AbcSpei.AbcGetGeneralParam(Y.ID.COM.PARAM, Y.NOMB.PARAM, Y.DATA.PARAM)
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.ID.COM.PARAM, R.DATOS, FV.ABC.GENERAL.PARAM, ERR.PARAM)
    Y.NOMB.PARAM = RAISE(R.DATOS<AbcTable.AbcGeneralParam.NombParametro>)
    Y.DATA.PARAM = RAISE(R.DATOS<AbcTable.AbcGeneralParam.DatoParametro>)
    
    LOCATE "OFS.SOURCE" IN Y.NOMB.PARAM SETTING POS THEN
        Y.OFS.SOURCE = Y.DATA.PARAM<POS>
    END
    
    LOCATE "APP.MXBASE.CUS" IN Y.NOMB.PARAM SETTING POS THEN
        APP.MXBASE.CUS = Y.DATA.PARAM<POS>
    END
    
    LOCATE "VERSION.MXBASE.CUS" IN Y.NOMB.PARAM SETTING POS THEN
        VERSION.MXBASE.CUS = Y.DATA.PARAM<POS>
    END
    
    LOCATE "APP.UPDATE.CUS" IN Y.NOMB.PARAM SETTING POS THEN
        APP.CUSTOMER = Y.DATA.PARAM<POS>
    END
    
    LOCATE "VERSION.UPDATE.CUS" IN Y.NOMB.PARAM SETTING POS THEN
        VERSION.UPDATE.CUS = Y.DATA.PARAM<POS>
    END
    
    Y.FLAG = 0
    Y.ACTIV.ECONO = ''
    Y.ACTIV.ECONO = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.actividadEcono)
    IF Y.ACTIV.ECONO THEN
        Y.ACTIVIDAD.ECONOMICA.ID = "BANXICO.ECO.ACTIVITY*":Y.ACTIV.ECONO
        ERR.REG.CODE = ""
        RECORD.REGULATORY.CODES = MXBASE.CustomerRegulatory.MxbaseRegulatoryCodes.Read(Y.ACTIVIDAD.ECONOMICA.ID, ERR.REG.CODE)
        IF ERR.REG.CODE THEN
            EB.SystemTables.setEtext("EB-ABC.ACTIVIDAD.NO.EXISTE")
            EB.ErrorProcessing.StoreEndError()
            GOSUB FINALIZE
        END ELSE
            GOSUB PROCESS.ACTIVIDAD.ECONOMICA
        END
    END
    Y.OCUPACION = ""
    Y.OCUPACION = EB.SystemTables.getRNew(AbcTable.AbcCustomerAbcAltaDigitalApi.occupation)
    IF Y.OCUPACION THEN
        ID.EB.LOOKUP = "ABC.OCUPACION*":Y.OCUPACION
        ERR.EB.LOOKUP = ""
        RECORD.EB.LOOKUP = EB.Template.Lookup.Read(ID.EB.LOOKUP, ERR.EB.LOOKUP)
        IF ERR.EB.LOOKUP THEN
            EB.SystemTables.setEtext("EB-ABC.OCUPACION.NO.EXISTE")
            EB.ErrorProcessing.StoreEndError()
            GOSUB FINALIZE
        END ELSE
            GOSUB PROCESS.OCUPACION
        END
    END
    

RETURN

*-----------------------------------------------------------------------------
PROCESS.ACTIVIDAD.ECONOMICA:
*-----------------------------------------------------------------------------
    ERR.CUSTOMER.DETAILS = ""
    RECORD.MXBASE = MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Read(Y.ID.CLIENTE, ERR.CUSTOMER.DETAILS)
    Y.ACTIVIDAD.ECONOMICA.ACTUAL = RECORD.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.BanxicoEcoActivity>

    IF Y.ACTIVIDAD.ECONOMICA.ID EQ Y.ACTIVIDAD.ECONOMICA.ACTUAL THEN
        Y.FLAG = 1
    END ELSE
        Record<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.BanxicoEcoActivity> = Y.ACTIVIDAD.ECONOMICA.ID
        Ofsfunct = "I"
        Process = "PROCESS"
        Y.VERSION = APP.MXBASE.CUS : VERSION.MXBASE.CUS
        Ofsrecord = ""
        EB.Foundation.OfsBuildRecord(APP.MXBASE.CUS, Ofsfunct, Process, Y.VERSION, "", "", Y.ID.CLIENTE, Record, Ofsrecord)
    
        options<1> = Y.OFS.SOURCE
        theRequest = Ofsrecord
        theResponse = ""
        txnCommitted = ""
        EB.Interface.OfsCallBulkManager(options, theRequest, theResponse, txnCommitted)
    END
RETURN
*-----------------------------------------------------------------------------
PROCESS.OCUPACION:
*-----------------------------------------------------------------------------
    ERR.CUSTOMER = ""
    REC.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CLIENTE, ERR.CUSTOMER)
    Y.OCUPACION.ACTUAL = REC.CUSTOMER<ST.Customer.Customer.EbCusOccupation,1>
    IF Y.OCUPACION.ACTUAL NE Y.OCUPACION THEN
        RECORD.CUSTOMER = ""
        RECORD.CUSTOMER<ST.Customer.Customer.EbCusOccupation,1> = Y.OCUPACION
        Ofsfunct = "I"
        Process = "PROCESS"
        Y.VERSION = APP.CUSTOMER : VERSION.UPDATE.CUS
        Record = RECORD.CUSTOMER
        Ofsrecord = ""
        EB.Foundation.OfsBuildRecord(APP.CUSTOMER, Ofsfunct, Process, Y.VERSION,"", 0, Y.ID.CLIENTE, Record, Ofsrecord)

        options<1> = Y.OFS.SOURCE
        theRequest = Ofsrecord
        theResponse = ""
        txnCommitted = ""
    
        EB.Interface.OfsCallBulkManager(options, theRequest, theResponse, txnCommitted)
    END ELSE
        IF Y.FLAG EQ 1 THEN
            EB.SystemTables.setEtext("EB-LIVE.RECORD.NOT.CHANGED")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN

*-----------------------------------------------------------------------------
FINALIZE:
*-----------------------------------------------------------------------------

RETURN

END
