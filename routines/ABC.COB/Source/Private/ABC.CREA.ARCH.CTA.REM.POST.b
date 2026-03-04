* @ValidationCode : MjotODk2OTA2MzkzOkNwMTI1MjoxNzY5MTMyOTY5NTA5OkPDqXNhck1pcmFuZGE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2026 19:49:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : CÈsarMiranda
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcCob
SUBROUTINE ABC.CREA.ARCH.CTA.REM.POST

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING EB.Updates
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING EB.AbcUtil
    
    TODAY = EB.SystemTables.getToday()
    
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

RETURN

***********
INITIALIZE:
***********

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.STMT = 'F.STMT.ENTRY'
    F.STMT = ''
    EB.DataAccess.Opf(FN.STMT,F.STMT)

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    Y.FECHA = TODAY
    EB.API.Cdt('',Y.FECHA, "-1W")

    Y.NO.ARCH = 1

    Y.ID.GEN.PARAM = 'ABC.REP.CTA.REMUNERADA'
    Y.ID.GEN.PARAM.CONSECUTIVO = 'ABC.REP.CTA.GAR.REM'

    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE "MAXIMO.REGISTROS" IN Y.LIST.PARAMS SETTING POS THEN
        Y.MAXIMO.REGISTROS = Y.LIST.VALUES<POS>
    END

    LOCATE "RUTA.ARCHIVO" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RUTA.ARCHIVO = Y.LIST.VALUES<POS>
    END

    LOCATE "RUTA.ARCHIVO.TEMP" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RUTA.ARCHIVO.TEMP = Y.LIST.VALUES<POS>
    END

    LOCATE "RECORD.TYPE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RECORD.TYPE = Y.LIST.VALUES<POS>
    END

    LOCATE "HEADER" IN Y.LIST.PARAMS SETTING POS THEN
        Y.HEADER = Y.LIST.VALUES<POS>
    END

    LOCATE "CLIENT.ID" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CLIENT.ID = Y.LIST.VALUES<POS>
        Y.CLIENT.ID = FMT(Y.CLIENT.ID,"R%10")
    END

    LOCATE "FILE.NAME" IN Y.LIST.PARAMS SETTING POS THEN
        Y.FILE.NAME = Y.LIST.VALUES<POS>
    END

    LOCATE "RECORD.TYPE.B" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RECORD.TYPE.B = Y.LIST.VALUES<POS>
    END

    LOCATE "RECORD.TYPE.F" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RECORD.TYPE.F = Y.LIST.VALUES<POS>
    END

    LOCATE "TRAILER" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRAILER = Y.LIST.VALUES<POS>
    END

    LOCATE "SHELL" IN Y.LIST.PARAMS SETTING POS THEN
        Y.SHELL = Y.LIST.VALUES<POS>
    END

    LOCATE "RUTA.DIR" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RUTA.DIR = Y.LIST.VALUES<POS>
    END

    LOCATE "RUTA.PGP" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RUTA.PGP = Y.LIST.VALUES<POS>
    END

    LOCATE "ID.KEY" IN Y.LIST.PARAMS SETTING POS THEN
        Y.ID.KEY = Y.LIST.VALUES<POS>
    END

    LOCATE "ENCRIPTA" IN Y.LIST.PARAMS SETTING POS THEN
        Y.ENCRIPTA = Y.LIST.VALUES<POS>
    END
    
*************************************** INICIO CMB 20260109 ***************************************
    LOCATE "PATH.S3" IN Y.LIST.PARAMS SETTING POS THEN
        Y.PATH.S3 = Y.LIST.VALUES<POS>
    END
***************************************** FIN CMB 20260109 ****************************************

    Y.PROGRAM.ID = FMT("","R#10")
    
    Y.NOMBRE.RUTINA = "ABC.CREA.ARCH.CTA.REM.POST"          ;*CMB 20260109

RETURN

********
PROCESS:
********

    SEL.CMD = "SELECT ":Y.RUTA.ARCHIVO.TEMP
    EB.DataAccess.Readlist(SEL.CMD,ID.LIST,'',Y.NO.REC,ERR.SEL)
    
    Y.CADENA.LOG<-1> = "ID.LIST->" : ID.LIST            ;*CMB 20260109

    FOR REC.REG = 1 TO Y.NO.REC
        EOF = ''
        Y.ID = ID.LIST<REC.REG>
        OPENSEQ Y.RUTA.ARCHIVO.TEMP,Y.ID TO Y.PUNTERO THEN
            LOOP
            WHILE NOT(EOF) DO
                READSEQ REC.LINE FROM Y.PUNTERO THEN
                    Y.NO.MOVIMIENTOS += 1
                    Y.NO.MOVIMIENTOS.AUX = FMT(Y.NO.MOVIMIENTOS,"R%6")
                    R.MOVIMIENTOS := Y.RECORD.TYPE.B : Y.NO.MOVIMIENTOS.AUX : REC.LINE : CHAR(10)
                    IF Y.NO.MOVIMIENTOS EQ Y.MAXIMO.REGISTROS THEN
                        GOSUB ESCRIBE.ARCHIVO
                        R.MOVIMIENTOS = ''
                        Y.NO.MOVIMIENTOS = 0
                        Y.NO.ARCH += 1
                    END
                END ELSE
                    EOF = 1
                END
            REPEAT
        END
    NEXT REC.REG
    PRINT R.MOVIMIENTOS

    GOSUB ESCRIBE.ARCHIVO

RETURN

******************
ESCRIBE.ARCHIVO:
*****************

    str_filename = Y.FILE.NAME
    SEQ.FILE.NAME = Y.RUTA.ARCHIVO

    Y.NO.ARCH.AUX = FMT(Y.NO.ARCH,"R%4")
    CHANGE 'YYYYMMDD' TO Y.FECHA IN str_filename
    CHANGE 'NNNN' TO Y.NO.ARCH.AUX IN str_filename

    str_filename.aux = FMT(str_filename,"R#50")

    R.HEADER = Y.RECORD.TYPE : Y.HEADER : Y.CLIENT.ID : Y.PROGRAM.ID : str_filename.aux : Y.FECHA[5,2] : Y.FECHA[7,2] : Y.FECHA[1,4] : CHAR(10)

    R.TRAILER = Y.RECORD.TYPE.F : Y.TRAILER : Y.NO.MOVIMIENTOS.AUX

    OPENSEQ SEQ.FILE.NAME,str_filename TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    WRITESEQ R.HEADER : R.MOVIMIENTOS : R.TRAILER TO FILE.VAR1 ELSE
    END

    CLOSESEQ FILE.VAR1

*************************************** INICIO CMB 20260109 ***************************************
    Y.CADENA.LOG<-1> = "SEQ.FILE.NAME->" : SEQ.FILE.NAME
    Y.CADENA.LOG<-1> = "Y.PATH.S3->" : Y.PATH.S3
    Y.CADENA.LOG<-1> = "str_filename->" : str_filename
    EB.AbcUtil.abcMoveFileToS3(SEQ.FILE.NAME, Y.PATH.S3, str_filename)
***************************************** FIN CMB 20260109 ****************************************

    IF Y.ENCRIPTA EQ 'SI' THEN GOSUB ENCRIPTA.ARCHIVO       ;* 20250128 CMB Se parametriza la encriptaci√≥n del archivo de salida

RETURN

*****************
ENCRIPTA.ARCHIVO:
*****************

    Y.SCRIPT = Y.SHELL:' "':Y.RUTA.DIR:'" "':str_filename:'" "':Y.ID.KEY:'" "':Y.RUTA.PGP:'"'
    EXECUTE Y.SCRIPT CAPTURING Y.LOG

    str_filename.log = str_filename
    CHANGE '.txt' TO '.log' IN str_filename.log

    RUTA.LOG = @PATH : "/" : Y.RUTA.ARCHIVO : "/" : str_filename.log
    OPENSEQ RUTA.LOG TO FILE.TEXT ELSE
        CREATE FILE.TEXT ELSE NULL
    END
    
    Y.PATH = @PATH : "/" : Y.RUTA.ARCHIVO : "/"
    Y.NOM.FILE = str_filename.log

    Y.RENGLON = "*******************************"
    CONVERT @FM TO CHAR(13) IN Y.LOG
    WRITESEQ Y.RENGLON TO FILE.TEXT ELSE NULL
    WRITESEQ Y.LOG TO FILE.TEXT ELSE NULL
    WRITESEQ Y.RENGLON TO FILE.TEXT ELSE NULL

    CLOSESEQ FILE.TEXT

*************************************** INICIO CMB 20260109 ***************************************
    Y.CADENA.LOG<-1> = "Y.PATH->" : Y.PATH
    Y.CADENA.LOG<-1> = "Y.PATH.S3->" : Y.PATH.S3
    Y.CADENA.LOG<-1> = "Y.NOM.FILE->" : Y.NOM.FILE
    EB.AbcUtil.abcMoveFileToS3(Y.PATH, Y.PATH.S3, Y.NOM.FILE)
***************************************** FIN CMB 20260109 ****************************************

RETURN

*********
FINALIZE:
*********

    RUTA.TEMP = Y.RUTA.ARCHIVO.TEMP
*************************************** INICIO CMB 20260109 ***************************************
*    EXECUTE 'CLEAR.FILE ': RUTA.TEMP
*
*    EXECUTE 'SH -c rm ': RUTA.TEMP : "/*" CAPTURING Y.RETURNVAL
*
*    Y.CADENA.LOG<-1> = "Y.RETURNVAL->" : Y.RETURNVAL
***************************************** FIN CMB 20260109 ****************************************

    Y.LIST.PARAMS.CON = ''
    Y.LIST.VALUES.CON = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM.CONSECUTIVO, Y.LIST.PARAMS.CON, Y.LIST.VALUES.CON)

    LOCATE "CONSECUTIVO" IN Y.LIST.PARAMS.CON SETTING POS.CON THEN
    END

    LOCATE "FECHA.DIA" IN Y.LIST.PARAMS.CON SETTING POS.FEC THEN
    END

    R.GEN.PARAM.CONSECUTIVO = ''
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.ID.GEN.PARAM.CONSECUTIVO,R.GEN.PARAM.CONSECUTIVO,F.ABC.GENERAL.PARAM,ERR.GP)
    Y.NO.ARCH += 1
    R.GEN.PARAM.CONSECUTIVO<AbcTable.AbcGeneralParam.DatoParametro,POS.CON> = Y.NO.ARCH
    R.GEN.PARAM.CONSECUTIVO<AbcTable.AbcGeneralParam.DatoParametro,POS.FEC> = Y.FECHA
    EB.DataAccess.FWrite(FN.ABC.GENERAL.PARAM, Y.ID.GEN.PARAM.CONSECUTIVO,R.GEN.PARAM.CONSECUTIVO)
    
    Y.CADENA.LOG<-1> = "Y.NO.ARCH->" : Y.NO.ARCH            ;*CMB 20260109
    Y.CADENA.LOG<-1> = "Y.FECHA->" : Y.FECHA                ;*CMB 20260109
    
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)

RETURN

END
