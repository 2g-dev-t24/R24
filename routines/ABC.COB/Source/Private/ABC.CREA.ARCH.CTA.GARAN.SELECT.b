* @ValidationCode : MjoxMDUyMDQ5MjQ5OkNwMTI1MjoxNzY4MjQ4NDY5ODU3OkPDqXNhck1pcmFuZGE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jan 2026 14:07:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : CésarMiranda
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcCob
SUBROUTINE ABC.CREA.ARCH.CTA.GARAN.SELECT

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.API
    $USING EB.AbcUtil
    
    TODAY = EB.SystemTables.getToday()
    
    GOSUB LIMPIA
    IF YMES NE Y.MES.VALIDACION THEN    ;*CAMB 20250219
        GOSUB SELECCIONA
        GOSUB FINALIZA
    END   ;*CAMB 20250219

RETURN

*******
LIMPIA:
*******

    Y.NOMBRE.RUTINA = "ABC.CREA.ARCH.CTA.GARAN.SELECT"          ;*CMB 20260112
    
    Y.RUTA.ARCHIVO.TEMP = AbcCob.getYRutaArchivoTemp()
    RUTA.TEMP = Y.RUTA.ARCHIVO.TEMP
*************************************** INICIO CMB 20260112 ***************************************
*    EXECUTE 'CLEAR.FILE ': RUTA.TEMP
    
    EXECUTE 'SH -c rm ': RUTA.TEMP CAPTURING Y.RETURNVAL
    
    Y.CADENA.LOG<-1> = "Y.RETURNVAL->" : Y.RETURNVAL
***************************************** FIN CMB 20260112 ****************************************


    YMES = TODAY[5,2]
    Y.FECHA.VALIDACION = TODAY
    EB.API.Cdt('',Y.FECHA.VALIDACION, "-1W")
    Y.MES.VALIDACION = Y.FECHA.VALIDACION[5,2]


RETURN

***********
SELECCIONA:
***********

    FN.ACCOUNT = AbcCob.getFnAccountGaran()
    Y.LIST.VALUES = AbcCob.getYListValues()
    LOCATE "CATEGORIAS" IN AbcCob.getYListParams() SETTING POS THEN
        Y.CATEGORIAS = Y.LIST.VALUES<POS>
    END
    SEL.CMD = "SELECT ":FN.ACCOUNT : " WITH CATEGORY IN (":Y.CATEGORIAS:")"
    EB.DataAccess.Readlist(SEL.CMD,ID.LIST,'',Y.NO.REC,ERR.SEL)
    EB.Service.BatchBuildList('',ID.LIST)
    
    Y.CADENA.LOG<-1> = "SEL.CMD->" : SEL.CMD            ;*CMB 20260112
    Y.CADENA.LOG<-1> = "Y.NO.REC->" : Y.NO.REC          ;*CMB 20260112
    Y.CADENA.LOG<-1> = "ID.LIST->" : ID.LIST            ;*CMB 20260112


*********
FINALIZA:
*********

    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)            ;*CMB 20260112
RETURN

END
