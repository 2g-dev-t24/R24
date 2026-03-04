* @ValidationCode : Mjo5NTI5ODA4NjM6Q3AxMjUyOjE3NjQzODYwMjc5ODI6VXN1YXJpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Nov 2025 21:13:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usuario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
.
*-----------------------------------------------------------------------------
* <Rating>-51</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcContractService
SUBROUTINE ABC.START.CARAT.SERVICE
*===============================================================================
* Nombre de Programa : ABC.START.CARAT.SERVICE
* Compania           : ABC Capital
* Objetivo           : Rutina que inicia el servicio para generar Caratulas
* Desarrollador      : Luis Cruz - FyG Solutions
* Fecha Creacion     : 2024-02-26
* Modificaciones:
*===============================================================================
* Subroutine Type : AUTH RTN
* Attached to : VERSION>AA.ARRANGEMENT.ACTIVITY,ABC.CUENTA.NIVEL.4L
* Attached as : VERSION RTN
* Primary Purpose : Rutina que crea un archivo plano con ID de cuenta creada e
*                   inicia el servicio para generar contrato
*-----------------------------------------------------------------------
* Luis Cruz
* 13/10/2025
* Revision de rutina componentizada por 2G
*-----------------------------------------------------------------------

* $INSERT I_COMMON - Not Used anymore;
* $INSERT I_EQUATE - Not Used anymore;
* $INSERT I_F.ACCOUNT - Not Used anymore;
* $INSERT I_F.TSA.SERVICE - Not Used anymore;
    
    $USING EB.DataAccess
    $USING EB.Service
    $USING EB.Interface
    $USING AbcGetGeneralParam
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING AA.Framework
    $USING EB.Template
    $USING AA.Account

    GOSUB INICIO

    IF Y.VERSION.GARAN MATCHES Y.VERSIONS.CARAT THEN
        GOSUB PROCESO
        GOSUB FINALIZE
    END

RETURN
*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------
    
    ID.CUENTA = ""
    Y.TEMP.FILE = ""
    Y.NOMBRE.SERV = "ABC.GENERA.CONTRATO"

    FN.TSA.SERVICE = 'F.TSA.SERVICE'
    F.TSA.SERVICE = ''
    EB.DataAccess.Opf(FN.TSA.SERVICE,F.TSA.SERVICE)
    
    FN.EB.LOOKUP = 'F.EB.LOOKUP' ; F.EB.LOOKUP = ''
    EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)

    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.ID.PARAM = 'ABC.PARAMETROS.REPORTES'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE "RUTA_PDF" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TEMP.PATH = Y.LIST.VALUES<POS>
    END

    Y.LIST.PARS.CARAT = '' ; Y.LIST.VALS.CARAT = ''
    Y.ID.PAR.CARAT = 'ABC.CATS.NIVEL.CARATULA'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PAR.CARAT, Y.LIST.PARS.CARAT, Y.LIST.VALS.CARAT)
    Y.CATS.CTAS.CAR = '' ; Y.NIVEL.CTAS.CAR = ''
    Y.VERSION.CARAT = ''

    LOCATE "CATEGS_CARATULA" IN Y.LIST.PARS.CARAT SETTING POS THEN
        Y.CATS.CTAS.CAR = Y.LIST.VALS.CARAT<POS>
        CHANGE "|" TO @VM IN Y.CATS.CTAS.CAR
    END
    
    LOCATE "VERSION_CARATULA" IN Y.LIST.PARS.CARAT SETTING POS THEN
        Y.VERSIONS.CARAT = Y.LIST.VALS.CARAT<POS>
        CHANGE "|" TO @VM IN Y.CATS.CTAS.CAR
    END

    
    Y.VERSION.GARAN = ''
    Y.VERSION.GARAN = EB.SystemTables.getPgmVersion()

RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------
    
    ID.CUENTA = EB.SystemTables.getIdNew()
    Y.ID.CUENTA.CARA = "CARA_" : ID.CUENTA

    R.TSA.SERVICE = EB.Service.TsaService.Read(Y.NOMBRE.SERV, ERR.TSA)
* Before incorporation : CALL F.READ(FN.TSA.SERVICE, Y.NOMBRE.SERV, R.TSA.SERVICE, F.TSA.SERVICE, ERR.TSA)
    ESTATUS.SERVICIO = R.TSA.SERVICE<EB.Service.TsaService.TsTsmServiceControl>
    IF ESTATUS.SERVICIO EQ 'START' THEN
        GOSUB CREA.REG.LOOKUP
    END ELSE
        GOSUB CREA.REG.LOOKUP
        GOSUB START.SERVICE
    END

RETURN
*-----------------------------------------------------------------------------
CREA.REG.LOOKUP:
*-----------------------------------------------------------------------------

    Y.ID.EB.LOOKUP = "PDF*" : Y.ID.CUENTA.CARA
    R.EB.LOOKUP<EB.Template.Lookup.LuDescription> = 'CONTRATO'
    EB.DataAccess.FWrite(FN.EB.LOOKUP,Y.ID.EB.LOOKUP,R.EB.LOOKUP)
    
RETURN
*-----------------------------------------------------------------------------
START.SERVICE:
*-----------------------------------------------------------------------------

    TS.ID = "ABC.GENERA.CONTRATO"
    SERVICE.ID = ''
    EB.Service.ServiceControl(TS.ID,'START',SERVICE.ID)
*TS.ID should be a valid @id of TSA.SERVICE

RETURN
*-----------------------------------------------------------------------------
FINALIZE:
*-----------------------------------------------------------------------------

END
