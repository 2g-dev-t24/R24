* @ValidationCode : MjozMzYyNDAxNjI6Q3AxMjUyOjE3NjIyOTMyNzk4NzE6VXN1YXJpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Nov 2025 15:54:39
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
$PACKAGE AbcContractService
SUBROUTINE ABC.EJECUTA.JAR.GENERIC(Y.DATA,Y.NAME,Y.RETURNVAL)
* ======================================================================
* Nombre de Programa : ABC.EJECUTA.JAR.GENERIC
* Objetivo           : rutina que ejecuta desde t24 un archivo JAR
* Desarrollador      : ROBERTO COTO - Fyg Solutions
* Compania           : ABC CAPITAL
* Fecha Creacion     : 2017/09/13
* Modificaciones     :
* ======================================================================
* Fecha Modificacion : 22/09/2025
* Desarrollador      : Luis Cruz - FyG 20250922PARAM
* Compania           : Uala
* Modificaciones     : Se agrega parametrizacion para ruta de creacion y
*                      ejecucion de script sh
* ======================================================================
* Subroutine Type : CALL ROUTINE
* Attached to : Called from many routines
* Attached as : Call Routine
* Primary Purpose : Rutina para ejecutar JARs llamada desde otras rutinas
*-----------------------------------------------------------------------
* Luis Cruz
* 22/09/2025
* Revision de rutina componentizada por 2G
*-----------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcGetGeneralParam

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-----------------------------------------------------------------------------
* Seccion Inicial
*-----------------------------------------------------------------------------
INITIALIZE:
    
    Y.PARAMETROS = ""
    Y.NOMBRE.JAR = ""
    Y.VALOR.RETORNO = ""
    
    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM" ;* 20250922PARAM - S
    FV.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, FV.ABC.GENERAL.PARAM)
    
    Y.ID.COM.PARAM = 'ABC.EJECUTA.JAR.PARAM'
    Y.RUTA.EJECUTA.SH = ''
    Y.RUTA.EJECUTA.JAR = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.COM.PARAM, Y.NOMB.PARAM, Y.DATA.PARAM)
    
    LOCATE "RUTA.EJECUTA.SH" IN Y.NOMB.PARAM SETTING POS THEN
        Y.RUTA.EJECUTA.SH = Y.DATA.PARAM<POS>
    END
    
    LOCATE "RUTA.EJECUTA.JAR" IN Y.NOMB.PARAM SETTING POS THEN
        Y.RUTA.EJECUTA.JAR = Y.DATA.PARAM<POS>
    END;* 20250922PARAM - E
RETURN
*-----------------------------------------------------------------------------
* Seccion principal del proceso
*-----------------------------------------------------------------------------
PROCESS:
    
    Y.SALTO = CHAR(10)
    Y.PARAMETROS = Y.DATA
    Y.NOMBRE.JAR = Y.NAME
;*str_path = '/shares/tafjud/ABC.CONTRATOS' ;* Se desestima ruta hardcodeada
    str_path = Y.RUTA.EJECUTA.SH ;* 20250922PARAM - S - E
    str_filename = "ABC.EJECUTA.JAR.GEN.":RND(2000000):TIME():".sh"
    TEMP.FILE = str_path : "/" : str_filename
    
    OPENSEQ TEMP.FILE TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END
    
    argumentoEntrada = Y.PARAMETROS
    DISPLAY argumentoEntrada
    Y.CADENA = 'java -jar ': Y.NOMBRE.JAR:'.jar "': argumentoEntrada:'"'
    Y.MENSAJE = Y.CADENA
    CRT "Y.MENSAJE->" : Y.MENSAJE

* Armo Archivo
    Y.SHELL = "cd " : Y.RUTA.EJECUTA.JAR : Y.SALTO
    Y.SHELL := Y.CADENA : Y.SALTO
    Y.SHELL := "exit" : Y.SALTO
    Y.SHELL := "EOT"
    
    WRITESEQ Y.SHELL APPEND TO FILE.VAR1 ELSE
        Y.MENSAJE = "No se Consiguio Escribir el Archivo: " : TEMP.FILE
        DISPLAY Y.MENSAJE
    END
    CLOSESEQ FILE.VAR1

    EXECUTE "SH -c chmod 777 " : TEMP.FILE CAPTURING Y.RESPONSE.CHMOD
    EXECUTE "SH -c " : TEMP.FILE            CAPTURING Y.RETURNVAL
    CRT "Y.RETURNVAL->" : Y.RETURNVAL
    EXECUTE "SH -c rm " : TEMP.FILE        CAPTURING Y.RESPONSE.RM
    
;*Y.VALOR.RETORNO = Y.RETURNVAL
    
RETURN
*-----------------------------------------------------------------------------
* Seccion final de la rutina
*-----------------------------------------------------------------------------
FINALLY:
RETURN
END
