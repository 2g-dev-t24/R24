* @ValidationCode : Mjo2OTUxMjMwMDQ6Q3AxMjUyOjE3NzI0MTUxMDkzNjE6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 01 Mar 2026 22:31:49
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
SUBROUTINE ABC.CREA.ARCH.CTA.GARAN.POST
*===============================================================================
* Nombre de Programa : ABC.CREA.ARCH.CTA.GARAN.POST
* Objetivo           : Rutina que crea un archivo .txt con los intereses pagados
*                      a las cuentas garantizadas
*===============================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING EB.API

    GOSUB INITIALIZE

*    IF YMES NE Y.MES.VALIDACION THEN
    GOSUB PROCESS
*    END
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

    TODAY = EB.SystemTables.getToday()
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
    LOCATE "RUTA.SELECT" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RUTA.SELECT = Y.LIST.VALUES<POS>
    END
    Y.PROGRAM.ID = FMT("","R#10")

RETURN

********
PROCESS:
********
    SEL.CMD = "SELECT ":Y.RUTA.ARCHIVO.TEMP
    EB.DataAccess.Readlist(SEL.CMD,ID.LIST,'',Y.NO.REC,ERR.SEL)

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
    SEQ.FILE.NAME = Y.RUTA.SELECT : "/" : Y.RUTA.ARCHIVO

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
* FIN MADM

    str_filename.aux = FMT(str_filename,"R#50")

    R.HEADER = Y.RECORD.TYPE : Y.HEADER : Y.CLIENT.ID : Y.PROGRAM.ID : str_filename.aux : Y.FECHA[5,2] : Y.FECHA[7,2] : Y.FECHA[1,4] : CHAR(10)

    R.TRAILER = Y.RECORD.TYPE.F : Y.TRAILER : Y.NO.MOVIMIENTOS.AUX

    OPENSEQ SEQ.FILE.NAME,str_filename TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    WRITESEQ R.HEADER : R.MOVIMIENTOS : R.TRAILER TO FILE.VAR1 THEN
        registroAbcGeneralParam = ''
        EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, yIdParamConsecutivo, registroAbcGeneralParam,F.ABC.GENERAL.PARAM,ERR.GP)
        yNumeroConsecutivo += 1
        registroAbcGeneralParam<AbcTable.AbcGeneralParam.DatoParametro,posCon> = yNumeroConsecutivo
        registroAbcGeneralParam<AbcTable.AbcGeneralParam.DatoParametro,posFec> = yFechaDia
        EB.DataAccess.FWrite(FN.ABC.GENERAL.PARAM, yIdParamConsecutivo, registroAbcGeneralParam)
    END ELSE
    END

    CLOSESEQ FILE.VAR1

    IF Y.ENCRIPTA EQ 'SI' THEN GOSUB ENCRIPTA.ARCHIVO

RETURN

*****************
ENCRIPTA.ARCHIVO:
*****************

    Y.SCRIPT = Y.SHELL:' "':Y.RUTA.DIR:'" "':str_filename:'" "':Y.ID.KEY:'" "':Y.RUTA.PGP:'"'
    EXECUTE Y.SCRIPT CAPTURING Y.LOG

    str_filename.log = str_filename
    CHANGE '.txt' TO '.log' IN str_filename.log

    RUTA.LOG = Y.RUTA.SELECT : "/" : Y.RUTA.ARCHIVO : "/" : str_filename.log

    OPENSEQ RUTA.LOG TO FILE.TEXT ELSE
        CREATE FILE.TEXT ELSE NULL
    END

    Y.RENGLON = "*******************************"
    CONVERT @FM TO CHAR(13) IN Y.LOG
    WRITESEQ Y.RENGLON TO FILE.TEXT ELSE NULL
    WRITESEQ Y.LOG TO FILE.TEXT ELSE NULL
    WRITESEQ Y.RENGLON TO FILE.TEXT ELSE NULL

    CLOSESEQ FILE.TEXT

RETURN

*********
FINALIZE:
*********

    RUTA.TEMP = Y.RUTA.ARCHIVO.TEMP
    EXECUTE 'CLEAR.FILE ': RUTA.TEMP

RETURN

END
