* @ValidationCode : MjozOTMxNzUyOTpDcDEyNTI6MTc2MDM5ODkzNTMxOTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Oct 2025 20:42:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTarjetaMc
*-----------------------------------------------------------------------------
SUBROUTINE ABC.CREA.ARCH.CTA.GARAN.SELECT
*===============================================================================
* Nombre de Programa : ABC.CREA.ARCH.CTA.GARAN.SELECT
* Objetivo           : Rutina que crea un archivo .txt con los intereses pagados
*                      a las cuentas garantizadas
*===============================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.API
    $USING AbcGetGeneralParam



    GOSUB INIC


**    IF YMES NE Y.MES.VALIDACION THEN
    GOSUB SELECCIONA
    GOSUB FINALIZA
**    END
 
RETURN

*******
INIC:
*******

    FN.ACCOUNT    = AbcTarjetaMc.getFnAccount()
    F.ACCOUNT     = AbcTarjetaMc.getFAccount()
    Y.RUTA.ARCHIVO.TEMP = AbcTarjetaMc.getYRutaArchivoTemp()
    Y.CATEGORIAS = AbcTarjetaMc.getYCategorias()

    Y.ID.PARAM = 'ABC.REP.CTA.GARANTIZADA'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE "RUTA.SELECT" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.RUTA.SELECT = Y.LIST.VALUES<YPOS.PARAM>
    END


    RUTA.TEMP = Y.RUTA.SELECT : "/" : Y.RUTA.ARCHIVO.TEMP
    EXECUTE 'CLEAR.FILE ': RUTA.TEMP

    TODAY = EB.SystemTables.getToday()
    YMES = TODAY[5,2]
    Y.FECHA.VALIDACION = TODAY
    EB.API.Cdt('',Y.FECHA.VALIDACION, "-1W")
    X.FECHA.VALIDA = Y.FECHA.VALIDACION
    Y.MES.VALIDACION = Y.FECHA.VALIDACION[5,2]


RETURN

***********
SELECCIONA:
***********

    SEL.CMD = "SELECT ":FN.ACCOUNT : " WITH CATEGORY EQ ":Y.CATEGORIAS:

    EB.DataAccess.Readlist(SEL.CMD,ID.LIST,'',Y.NO.REC,ERR.SEL)

    EB.Service.BatchBuildList('',ID.LIST)

*********
FINALIZA:
*********

RETURN

END
