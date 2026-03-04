* @ValidationCode : MjotMTA3MTczMzk1ODpDcDEyNTI6MTc3MjQxNDA5MTc0OTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 01 Mar 2026 22:14:51
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
*-----------------------------------------------------------------------------
SUBROUTINE ABC.START.CARAT.SERVICE
*===============================================================================
* Nombre de Programa : ABC.START.CARAT.SERVICE
* Compania           : ABC Capital
* Objetivo           : Rutina que valida que la TDD no tenga STATUS cancelada
* Desarrollador      : Luis Cruz - FyG Solutions
* Fecha Creacion     : 2024-02-26
* Modificaciones:
*===============================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AbcGetGeneralParam
    $USING EB.Service
    $USING EB.Foundation
    $USING EB.Interface

    GOSUB INICIO

    IF (Y.CATEG.CTA MATCHES Y.CATS.CTAS.CAR) AND (Y.NIVEL.CTA MATCHES Y.NIVEL.CTAS.CAR) THEN
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

    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.ID.PARAM = 'ABC.PARAMETROS.REPORTES'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE "RUTA_PDF" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TEMP.PATH = Y.LIST.VALUES<POS>
*       AbcGetGeneralParam.AbcObtieneRutaAbs(Y.TEMP.PATH)
    END

    Y.LIST.PARS.CARAT = ''
    Y.LIST.VALS.CARAT = ''
    Y.ID.PAR.CARAT = 'ABC.CATS.NIVEL.CARATULA'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PAR.CARAT, Y.LIST.PARS.CARAT, Y.LIST.VALS.CARAT)
    Y.CATS.CTAS.CAR = ''
    Y.NIVEL.CTAS.CAR = ''

    LOCATE "CATEGS_CARATULA" IN Y.LIST.PARS.CARAT SETTING POS THEN
        Y.CATS.CTAS.CAR = Y.LIST.VALS.CARAT<POS>
        CHANGE "|" TO @VM IN Y.CATS.CTAS.CAR
    END

    LOCATE "NIVELES_CARATULA" IN Y.LIST.PARS.CARAT SETTING POS THEN
        Y.NIVEL.CTAS.CAR = Y.LIST.VALS.CARAT<POS>
        CHANGE "|" TO @VM IN Y.NIVEL.CTAS.CAR
    END

    Y.CATEG.CTA = '' ; Y.NIVEL.CTA = ''
    Y.CATEG.CTA = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Category)
    Y.NIVEL.CTA = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Nivel)

RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------

    ID.CUENTA = EB.SystemTables.getIdNew()

    Y.TEMP.FILE = "CARA_" : ID.CUENTA : ".txt"
    Y.WRT.FILE = Y.TEMP.PATH : Y.TEMP.FILE

    EB.DataAccess.FRead(FN.TSA.SERVICE, Y.NOMBRE.SERV, R.TSA.SERVICE, F.TSA.SERVICE, ERR.TSA)

    ESTATUS.SERVICIO = R.TSA.SERVICE<EB.Service.TsaService.TsTsmServiceControl>
    IF ESTATUS.SERVICIO EQ 'START' THEN
        GOSUB CREA.ARCH.TEMP
    END ELSE
        GOSUB CREA.ARCH.TEMP
        GOSUB START.SERVICE
    END

RETURN
*-----------------------------------------------------------------------------
CREA.ARCH.TEMP:
*-----------------------------------------------------------------------------

    OPENSEQ Y.WRT.FILE TO ARCH.TEMP ELSE
        CREATE ARCH.TEMP ELSE
            Y.MENSAJE = "No se Consiguio Escribir el Archivo: "
            DISPLAY Y.MENSAJE
        END
    END
RETURN
*-----------------------------------------------------------------------------
START.SERVICE:
*-----------------------------------------------------------------------------

    Y.ID.TSA.SERVICE = "BNK/ABC.GENERA.CONTRATO"
    SERVICE.ID = ''

    EB.DataAccess.FRead(FN.TSA.SERVICE,Y.ID.TSA.SERVICE,R.TSA.SERVICE,F.TSA.SERVICE,Y.TSA.ERROR)
    R.TSA.SERVICE<EB.Service.TsaService.TsTsmServiceControl> = "START"

    Y.OFS.REQUEST   = ''
    Y.OFS.APP       = 'TSA.SERVICE'
    Y.OFS.FUNCTION  = 'I'
    Y.OFS.VERSION   = 'TSA.SERVICE,'
    Y.GTSMODE       = ''
    Y.NO.OF.AUTH    = 0
    Y.ID            = Y.ID.TSA.SERVICE
    Y.RECORD        = R.TSA.SERVICE
    Y.OFS.REQUEST   = ''
*    CONVERT '/' TO '^' IN Y.ID

    EB.Foundation.OfsBuildRecord(Y.OFS.APP,Y.OFS.FUNCTION,'PROCESS',Y.OFS.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID,Y.RECORD,Y.OFS.REQUEST)
    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST,'APPEND', Y.ERROR)


RETURN
*-----------------------------------------------------------------------------
FINALIZE:
*-----------------------------------------------------------------------------

END
