* @ValidationCode : Mjo3NTUxNDAwODQ6Q3AxMjUyOjE3Njg4NTkwNzI1OTk6Q8Opc2FyTWlyYW5kYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Jan 2026 15:44:32
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
SUBROUTINE ABC.CREA.ARCH.CTA.REM.SELECT

    $USING EB.DataAccess
    $USING EB.Service
    $USING EB.AbcUtil
    
    GOSUB LIMPIA
    GOSUB SELECCIONA
    GOSUB FINALIZA

RETURN

*******
LIMPIA:
*******

    Y.NOMBRE.RUTINA = "ABC.CREA.ARCH.CTA.REM.SELECT"          ;*CMB 20260109

    Y.RUTA.ARCHIVO.TEMP = AbcCob.getYRutaArchivoTempRem()
    RUTA.TEMP = Y.RUTA.ARCHIVO.TEMP
*************************************** INICIO CMB 20260109 ***************************************
*    EXECUTE 'CLEAR.FILE ': RUTA.TEMP
    
    EXECUTE 'SH -c rm ': RUTA.TEMP : "/*" CAPTURING Y.RETURNVAL
    
    Y.CADENA.LOG<-1> = "Y.RETURNVAL->" : Y.RETURNVAL
***************************************** FIN CMB 20260109 ****************************************

RETURN

***********
SELECCIONA:
***********

    FN.ACCOUNT = AbcCob.getFnAccountRem()
    Y.LIST.VALUES = AbcCob.getYListValuesRem()
    LOCATE "CATEGORIAS" IN AbcCob.getYListParamsRem() SETTING POS THEN
        Y.CATEGORIAS = Y.LIST.VALUES<POS>
    END
    
    Y.SELECT.CATEGORIAS = Y.CATEGORIAS
    CHANGE "' '" TO "' OR CATEGORY EQ '" IN Y.SELECT.CATEGORIAS
    
    SEL.CMD = "SELECT ":FN.ACCOUNT : " WITH CATEGORY EQ ":Y.SELECT.CATEGORIAS
    EB.DataAccess.Readlist(SEL.CMD,ID.LIST,'',Y.NO.REC,ERR.SEL)
    
    Y.CADENA.LOG<-1> = "SEL.CMD->" : SEL.CMD            ;*CMB 20260109
    Y.CADENA.LOG<-1> = "Y.NO.REC->" : Y.NO.REC          ;*CMB 20260109
    Y.CADENA.LOG<-1> = "ID.LIST->" : ID.LIST            ;*CMB 20260109

    EB.Service.BatchBuildList('',ID.LIST)

*********
FINALIZA:
*********

    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)            ;*CMB 20260109

RETURN

END
