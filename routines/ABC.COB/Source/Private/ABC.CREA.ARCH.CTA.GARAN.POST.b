* @ValidationCode : MjoxNTA2OTYzMzpDcDEyNTI6MTc2ODQwNjA0NzI4ODpDw6lzYXJNaXJhbmRhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jan 2026 09:54:07
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
SUBROUTINE ABC.CREA.ARCH.CTA.GARAN.POST

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING EB.Updates
    $USING EB.Service
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING EB.AbcUtil
    
    TODAY = EB.SystemTables.getToday()
    
    GOSUB INITIALIZE
    IF YMES NE Y.MES.VALIDACION THEN    ;*CAMB 20250219
        GOSUB PROCESS
    END   ;*CAMB 20250219
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

    YMES = TODAY[5,2]
    Y.FECHA.VALIDACION = TODAY
    EB.API.Cdt('',Y.FECHA.VALIDACION, "-1W")
    Y.MES.VALIDACION = Y.FECHA.VALIDACION[5,2]

    Y.NO.ARCH = 1

    Y.ID.GEN.PARAM = 'ABC.REP.CTA.GARANTIZADA'

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
    
*************************************** INICIO CMB 20260112 ***************************************
    LOCATE "PATH.S3" IN Y.LIST.PARAMS SETTING POS THEN
        Y.PATH.S3 = Y.LIST.VALUES<POS>
    END
***************************************** FIN CMB 20260112 ****************************************

    Y.PROGRAM.ID = FMT("","R#10")
    
    Y.NOMBRE.RUTINA = "ABC.CREA.ARCH.CTA.GARAN.POST"          ;*CMB 20260112

RETURN

********
PROCESS:
********

    SEL.CMD = "SELECT ":Y.RUTA.ARCHIVO.TEMP
    EB.DataAccess.Readlist(SEL.CMD,ID.LIST,'',Y.NO.REC,ERR.SEL)
    
    Y.CADENA.LOG<-1> = "ID.LIST->" : ID.LIST            ;*CMB 20260112

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

    yIdParamConsecutivo = 'ABC.REP.CTA.GAR.REM'
    yParametros = ''
    yValores = ''
    AbcGetGeneralParam.AbcGetGeneralParam(yIdParamConsecutivo, yParametros, yValores)

    LOCATE "CONSECUTIVO" IN yParametros SETTING posCon THEN
        yNumeroConsecutivo = TRIM(yValores<posCon>)
    END
    LOCATE "FECHA.DIA" IN yParametros SETTING posFec THEN
        yFechaDia = TRIM(yValores<posFec>)
        IF (yFechaDia NE Y.FECHA) THEN
            yFechaDia = Y.FECHA
            yNumeroConsecutivo = 1
        END
    END
    CHANGE 'NNNN' TO FMT(yNumeroConsecutivo,"R%4") IN str_filename

    str_filename.aux = FMT(str_filename,"R#50")

    R.HEADER = Y.RECORD.TYPE : Y.HEADER : Y.CLIENT.ID : Y.PROGRAM.ID : str_filename.aux : Y.FECHA[5,2] : Y.FECHA[7,2] : Y.FECHA[1,4] : CHAR(10)

    R.TRAILER = Y.RECORD.TYPE.F : Y.TRAILER : Y.NO.MOVIMIENTOS.AUX

    OPENSEQ SEQ.FILE.NAME,str_filename TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    WRITESEQ R.HEADER : R.MOVIMIENTOS : R.TRAILER TO FILE.VAR1 THEN
        registroAbcGeneralParam = ''
        EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, yIdParamConsecutivo,registroAbcGeneralParam,F.ABC.GENERAL.PARAM,ERR.GP)
        yNumeroConsecutivo += 1
        registroAbcGeneralParam<AbcTable.AbcGeneralParam.DatoParametro,posCon> = yNumeroConsecutivo
        registroAbcGeneralParam<AbcTable.AbcGeneralParam.DatoParametro,posFec> = yFechaDia
        EB.DataAccess.FWrite(FN.ABC.GENERAL.PARAM, yIdParamConsecutivo,registroAbcGeneralParam)
    END ELSE
    END

    CLOSESEQ FILE.VAR1
    
*************************************** INICIO CMB 20260112 ***************************************
    Y.CADENA.LOG<-1> = "SEQ.FILE.NAME->" : SEQ.FILE.NAME
    Y.CADENA.LOG<-1> = "Y.PATH.S3->" : Y.PATH.S3
    Y.CADENA.LOG<-1> = "str_filename->" : str_filename
    EB.AbcUtil.abcMoveFileToS3(SEQ.FILE.NAME, Y.PATH.S3, str_filename)
***************************************** FIN CMB 20260112 ****************************************

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
    
*************************************** INICIO CMB 20260112 ***************************************
    Y.CADENA.LOG<-1> = "Y.PATH->" : Y.PATH
    Y.CADENA.LOG<-1> = "Y.PATH.S3->" : Y.PATH.S3
    Y.CADENA.LOG<-1> = "Y.NOM.FILE->" : Y.NOM.FILE
    EB.AbcUtil.abcMoveFileToS3(Y.PATH, Y.PATH.S3, Y.NOM.FILE)
***************************************** FIN CMB 20260112 ****************************************

RETURN

*********
FINALIZE:
*********

    RUTA.TEMP = @PATH : "/" : Y.RUTA.ARCHIVO.TEMP
*************************************** INICIO CMB 20260109 ***************************************
*    EXECUTE 'CLEAR.FILE ': RUTA.TEMP
    
    EXECUTE 'SH -c rm ': RUTA.TEMP CAPTURING Y.RETURNVAL
    
    Y.CADENA.LOG<-1> = "Y.RETURNVAL->" : Y.RETURNVAL
***************************************** FIN CMB 20260109 ****************************************

RETURN

END
