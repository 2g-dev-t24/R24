* @ValidationCode : MjoxOTMyODA1MzY6Q3AxMjUyOjE3NjkxMzI3OTAxNDI6Q8Opc2FyTWlyYW5kYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Jan 2026 19:46:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : C�sarMiranda
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE EB.AbcUtil
SUBROUTINE ABC.ESCRIBE.LOG.GENERICO(Y.RTN.NAME, Y.DATA.LOG)
* ======================================================================
* Nombre de Programa : ABC.ESCRIBE.LOG.GENERIC
* Objetivo           : rutina que genera un archivo LOG
* Desarrollador      : Luis Cruz - Fyg Solutions
* Compania           : Uala
* Fecha Creacion     : 2025/11/19
* Modificaciones     :
* ======================================================================
* Subroutine Type : CALL ROUTINE
* Attached to : Called from many routines
* Attached as : Call Routine
* Primary Purpose : Rutina para generar Logs desde otras rutinas
*-----------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AbcGetGeneralParam

    GOSUB INITIALIZE
    IF Y.BANDERA.LOG EQ 1 THEN
        GOSUB PROCESS
    END
    GOSUB FINALLY

RETURN

*-----------------------------------------------------------------------------
* Seccion Inicial
*-----------------------------------------------------------------------------
INITIALIZE:
    
    
    FN.ABC.GEN.PAR = "F.ABC.GENERAL.PARAM"
    F.ABC.GEN.PAR = ""
    EB.DataAccess.Opf(FN.ABC.GEN.PAR, F.ABC.GEN.PAR)
    
    Y.TODAY = EB.SystemTables.getToday()
    Y.CADENA.LOG = ""
    Y.NOMBRE.LOG = ""
    
    Y.ID.LOG.PARAM = 'ESCRIBE.LOG.PARAM'
    Y.NOMB.PARAM = ''
    Y.DATA.PARAM = ''
    Y.RUTA.LOG = ''
    Y.BANDERA.LOG = ''
    Y.REC.PARAM.LOG = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.LOG.PARAM, Y.NOMB.PARAM, Y.DATA.PARAM)
    
    LOCATE "RUTA.LOG" IN Y.NOMB.PARAM SETTING POS THEN
        Y.RUTA.LOG = Y.DATA.PARAM<POS>
    END
    
    LOCATE FIELD(Y.RTN.NAME,"_",1) IN Y.DATA.PARAM SETTING POS THEN
        Y.BANDERA.LOG = 1
    END
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    
    Y.SALTO = CHAR(10) : "    "
    Y.NOMBRE.LOG = Y.RTN.NAME : "_" : Y.TODAY : ".txt"
    str_path = Y.RUTA.LOG
    str_filename = Y.NOMBRE.LOG
    TEMP.FILE = str_path : "/" : str_filename
    OPENSEQ TEMP.FILE TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END
    
    argumentoEntrada = Y.DATA.LOG
    CHANGE @FM TO Y.SALTO IN argumentoEntrada
    DISPLAY argumentoEntrada
    CRT "argumentoEntrada->" : argumentoEntrada

* Escribe LOG
    Y.CADENA = TIMEDATE() : Y.SALTO : argumentoEntrada
    
    WRITESEQ Y.CADENA APPEND TO FILE.VAR1 ELSE
        Y.MENSAJE = "No se Consiguio Escribir el Archivo: " : TEMP.FILE
        DISPLAY Y.MENSAJE
    END
    CLOSESEQ FILE.VAR1
    
RETURN
*-----------------------------------------------------------------------------
* Seccion final de la rutina
*-----------------------------------------------------------------------------
FINALLY:
RETURN
END
