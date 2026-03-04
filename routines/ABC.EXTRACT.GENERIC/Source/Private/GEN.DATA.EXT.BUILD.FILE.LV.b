* @ValidationCode : MjotMTM2NjkxODU1NTpDcDEyNTI6MTc2MTYyMzQ3NjQxODpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Oct 2025 00:51:16
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
$PACKAGE AbcExtractGeneric

SUBROUTINE GEN.DATA.EXT.BUILD.FILE.LV
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*===============================================================================
* Nombre de Programa:   GEN.DATA.EXT.BUILD.FILE.LV
* Objetivo:             Rutina que lee los registros procesados para escribir un archivo plano
* Desarrollador:        Franco Manrique
* Compania:             larrainVial Ltda
* Fecha Creacion:       2014-01-27
* Modificaciones:       Se agrega funcion LATIN1 para que se visualice correctamente los registros en los
*                       archivos generados.
* Desarrollador:        Roberto Antonio Coto Ixtepan (F&G Solutions)
* Compania:             ABC CAPITAL
* Fecha Mod:            2017-07-21
*===============================================================================
* Modificaciones:       Se modifica funci�n para cambiar el "LOAD.TYPE" de "ALL" a "CHANGED" agregando bandera para excluir tablas que
*      se encuentren dentro de la parametrizaci�n de "ABC.EXTRACCION"
* Desarrollador:        Christian L�pez (F&G Solutions)
* Compania:             ABC CAPITAL
* Fecha Mod:            2017-04-12
*===============================================================================
* Modificaciones:       Se agrega funcionalidad para permitir definir un formato de salida de los datos
* mediante el campo HEADER, para hacer un substring del dato se define #<indice.inicio>,<caracteres.tomados>
* Desarrollador:        Luis Cruz (F&G Solutions)
* Compania:             ABC CAPITAL
* Fecha Mod:            2021-03-04  (LFCR_20210304)
*===============================================================================
* Modificaciones     : Se a�ade validacion en la informacion
* Desarrollador      : F&G Solutions
* Compania           : ABC CAPITAL
* Fecha Mod          : 2024-09-30
*================================================================================================================
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING EB.Service
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.CompanyCreation
    $USING AbcGetGeneralParam
    $USING EB.API
    $USING EB.Updates
    $USING EB.AbcUtil
    
    GOSUB INITIALIZE

    IF Y.APP.EXEC = 'TRUE' THEN
        GOSUB PROCESS
        GOSUB FINALLY
    END

RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

* Y.APLICACION = 'CUSTOMER'
    Y.NOMBRE.RUTINA = "GEN.DATA.EXT.BUILD.FILE.LV"
    Y.CADENA.LOG =  ""
    Y.LINEA.LOG = "" ; Y.SEP.SPC = " "

    BATCH.DETAILS = EB.SystemTables.getBatchDetails()
    Y.APLICACION = BATCH.DETAILS<3>     ;*En esta variable se envia el dato parametrizado en el campo data del Batch
    Y.APP.EXEC = 'TRUE'

    Y.TABLE.NAME = FIELD(Y.APLICACION, '-', 1)

    F.GENERIC.EXTRACT.PARAM.LV = ''
    FN.GENERIC.EXTRACT.PARAM.LV = 'F.GENERIC.EXTRACT.PARAM.LV'
    EB.DataAccess.Opf(FN.GENERIC.EXTRACT.PARAM.LV,F.GENERIC.EXTRACT.PARAM.LV)

    R.GENERIC.EXTRACT.PARAM.LV = ''
    EB.DataAccess.FRead(FN.GENERIC.EXTRACT.PARAM.LV,Y.APLICACION,R.GENERIC.EXTRACT.PARAM.LV,F.GENERIC.EXTRACT.PARAM.LV,ERR.GENERIC.EXTRACT.PARAM.LV)

    IF R.GENERIC.EXTRACT.PARAM.LV THEN

        Y.FLAG.HEADER   = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.Header>
        Y.SEPARADOR     = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.Separador>
        Y.FILE.PATH     = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.FilePath>
        Y.FILE.NAME     = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.FileName>
        Y.FILE.EXT      = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.FileExt>
        Y.COMPANY       = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.Company>
        Y.LOAD.TYPE     = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.LoadType>
        Y.HELP.FILE     = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.HelpFile>
        Y.LOAD.DATE.INI = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.LoadDateIni>
        Y.LOAD.DATE.FIN = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.LoadDateFin>

        Y.FIELD.LIST      = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.Field>)
        Y.LOCAL.NAME.LIST = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.LocalName>)
        Y.VM.SEP.LIST     = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.VmSep>)
        Y.SM.SEP.LIST     = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.SmSep>)
        Y.SPEC.VM.SP.LIST = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.SpecVmSep>)      ;*LFCR_20210304
        Y.SPEC.SM.SP.LIST = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.SpecSmSep>)      ;*LFCR_20210304
        Y.FLD.HEADER.NAME.LIST = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.FldHedrName>)

        Y.NO.FILEDS = DCOUNT(Y.FIELD.LIST,@FM)
        Y.NO.HEADER = DCOUNT(Y.FLD.HEADER.NAME.LIST,@FM)
    END
    
    Y.CADENA.LOG<-1> =  "Y.NO.FILEDS->" : Y.NO.FILEDS
    Y.CADENA.LOG<-1> =  "Y.NO.HEADER->" : Y.NO.HEADER
    Y.LAST.WORKING.DAY= EB.SystemTables.getRDates(EB.Utility.Dates.DatLastWorkingDay)
*    Y.LAST.WORKING.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.COMPANY.ID = EB.SystemTables.getIdCompany()
    R.COMPANY = ST.CompanyCreation.Company.Read(Y.COMPANY.ID, COMP.ERR)
    Y.NOSTRO.MNEMONIC  = R.COMPANY<ST.CompanyCreation.Company.EbComNostroMnemonic>

    FIND Y.NOSTRO.MNEMONIC IN Y.COMPANY SETTING POS1, POS2 THEN
        Y.LOAD.TYPE       = Y.LOAD.TYPE<POS1, POS2>

        Y.LOAD.DATE.FMT.INI = ''
        Y.LOAD.DATE.FMT.FIN = ''
************************* INICIO RCOTO ***************************
*         IF Y.LOAD.DATE.INI AND Y.LOAD.DATE.FIN THEN
*             Y.LOAD.DATE.FMT.INI = Y.LOAD.DATE.INI[3,6]
*             Y.LOAD.DATE.FMT.FIN = Y.LOAD.DATE.FIN[3,6]
*         END ELSE
*             Y.LOAD.DATE.FMT.INI = Y.LAST.WORKING.DAY[3,6]
*             Y.LOAD.DATE.FMT.FIN = Y.LAST.WORKING.DAY[3,6]
*         END
        TODAY   = EB.SystemTables.getToday()
        Y.FILE.NAME.DATE.INI = TODAY
        Y.FILE.NAME.DATE.FIN = TODAY

*         IF Y.LOAD.TYPE EQ 'CHANGED' THEN
*             Y.FILE.NAME.DATE.INI = Y.LOAD.DATE.FMT.INI
*             Y.FILE.NAME.DATE.FIN = Y.LOAD.DATE.FMT.FIN
*         END
*************************** FIN RCOTO *****************************
        ID.COMPANY = EB.SystemTables.getIdCompany()
        Y.ID.COMPANY = ID.COMPANY


*Y.FILE.NAME = ;Y.ID.COMPANY : '_' : Y.FILE.NAME : '_' : Y.NOSTRO.MNEMONIC : '_' : Y.LOAD.TYPE : '_' : Y.FILE.NAME.DATE.INI : '_' : Y.FILE.NAME.DATE.FIN :: '.' : Y.FILE.EXT
        Y.FILE.NAME = Y.FILE.NAME: '_' : Y.FILE.NAME.DATE.INI :: '.' : Y.FILE.EXT

;*         DISPLAY "Abriendo archivo de entrada: " : Y.HELP.FILE
;*         OPENSEQ Y.HELP.FILE,'' TO HELP.SEQ.FILE.POINTER ELSE
;*             CRT "********************  ERROR  ******************************"
;*             CRT "NO SE PUDO ABRIR ARCHIVO DE ENTRADA: " : Y.HELP.FILE
;*             CRT "***********************************************************"
;*             RETURN
;*         END

        DISPLAY "Abriendo archivo de entrada: " : Y.HELP.FILE
        HELP.SEQ.FILE.POINTER        = ''
        FN.DATA.HELP.FILE       = Y.HELP.FILE
        OPEN FN.DATA.HELP.FILE TO HELP.SEQ.FILE.POINTER ELSE
            EB.ErrorProcessing.FatalError("NO SE PUDO ABRIR ARCHIVO DE ENTRADA: " : Y.HELP.FILE)
        END
        
        IF CHDIR (Y.FILE.PATH) THEN
            Y.CADENA.LOG<-1> = "Directorio origen existente " : Y.FILE.PATH
        END ELSE
            Y.CADENA.LOG<-1> = "No existe el directorio origen " : Y.FILE.PATH
            EXECUTE 'SH -c mkdir ': Y.FILE.PATH CAPTURING Y.RETURNVAL.ORI
            Y.CADENA.LOG<-1> = "Y.RETURNVAL.ORI->" : Y.RETURNVAL.ORI
        END

        OPENSEQ Y.FILE.PATH,Y.FILE.NAME  TO SEQ.FILE.POINTER ELSE
            CREATE SEQ.FILE.POINTER ELSE
                CRT "********************  ERROR  ******************************"
                CRT "NO SE PUDO CREAR EL ARCHIVO ": Y.FILE.PATH : Y.FILE.NAME
                CRT "***********************************************************"
                EB.ErrorProcessing.FatalError("NO SE PUDO CREAR EL ARCHIVO ": Y.FILE.PATH : Y.FILE.NAME)
            END
        END

        IF Y.FLAG.HEADER EQ 'Y' THEN
            Y.LINE.HEADER = ''
            Y.FORMAT.HEDR = ''

            FOR Y.AA = 1 TO Y.NO.FILEDS
                Y.HEADER = Y.FLD.HEADER.NAME.LIST<Y.AA>
                IF INDEX(Y.HEADER, '#' , 1) THEN
                    Y.LINE.HEADER<-1> := FIELD(Y.HEADER, '#', 1)
                    Y.FORMAT.HEDR<-1> := FIELD(Y.HEADER, '#', 2)
                END ELSE
                    Y.LINE.HEADER<-1> := Y.HEADER
                    Y.FORMAT.HEDR<-1> := '-'
                END
            NEXT Y.AA

        END
    END ELSE
        Y.APP.EXEC = 'FALSE'
    END

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.NO.ELEMS = 0
    Y.EOF = 0
    Y.HEADER.WRITTEN = 0
    
    Y.LIST = ''
    Y.NO.ELEMS = ''
    SEL.CMD = 'SELECT ' : FN.DATA.HELP.FILE
    EB.DataAccess.Readlist(SEL.CMD, Y.LIST, '', Y.NO.ELEMS, '')
    
    Y.CADENA.LOG<-1> =  "SEL.CMD->" : SEL.CMD
    Y.CADENA.LOG<-1> =  "Y.LIST->" : Y.LIST
    Y.CADENA.LOG<-1> =  "Y.NO.ELEMS->" : Y.NO.ELEMS
    
    IF Y.NO.ELEMS GT 0 THEN   ;*Si hay registros a procesar escribe el header para que se cree el archivo
        Y.LINE = ''
        Y.LINE = EREPLACE (Y.LINE.HEADER, @FM, Y.SEPARADOR)
        GOSUB WRITE.FILE
    END
    
    FOR Y.AA = 1 TO Y.NO.ELEMS
        Y.ID.GEN.RECORD = Y.LIST<Y.AA>

        READ R.GEN.RECORD FROM HELP.SEQ.FILE.POINTER, Y.ID.GEN.RECORD THEN

            IF Y.TABLE.NAME NE 'LOCAL.TABLE' THEN
                Y.LINE = ''
                Y.LINE = LATIN1(R.GEN.RECORD<1>)
                GOSUB FORMAT.CAMPO      ;*LFCR_20210304
                GOSUB VALIDA.DATOS      ;*FYG20240930
                GOSUB WRITE.FILE
            END ELSE

                Y.NO.LINES = DCOUNT(R.GEN.RECORD, @FM)
                FOR Y.COUNT.LINE = 1 TO Y.NO.LINES
                    Y.LINE = ''
                    Y.LINE = LATIN1(R.GEN.RECORD<Y.COUNT.LINE>)
                    GOSUB WRITE.FILE
                NEXT Y.COUNT.LINE
            END
        END
    NEXT Y.AA
    
;*     LOOP
;*         ;*READSEQ Y.INPUT.LINE FROM HELP.SEQ.FILE.POINTER ELSE Y.EOF = 1
;*         READ Y.INPUT.LINE FROM HELP.SEQ.FILE.POINTER ELSE Y.EOF = 1
;*     WHILE NOT(Y.EOF)
;*         
;*         Y.NO.ELEMS += 1
;*         
;*         
;*         IF Y.HEADER.WRITTEN EQ 0 THEN
;*             Y.HEADER.WRITTEN = 1
;*             Y.LINE = ''
;*             Y.LINE = EREPLACE (Y.LINE.HEADER, @FM, Y.SEPARADOR)
;*             GOSUB WRITE.FILE
;*         END
;*         
;*         IF Y.TABLE.NAME NE 'LOCAL.TABLE' THEN
;*             Y.LINE = ''
;*             Y.LINE = LATIN1(Y.INPUT.LINE)
;*             GOSUB FORMAT.CAMPO      ;*LFCR_20210304
;*             GOSUB VALIDA.DATOS      ;*FYG20240930
;*             GOSUB WRITE.FILE
;*         END ELSE
;*             Y.NO.LINES = DCOUNT(Y.INPUT.LINE, @FM)
;*             FOR Y.COUNT.LINE = 1 TO Y.NO.LINES
;*                 Y.LINE = ''
;*                 Y.LINE = LATIN1(Y.INPUT.LINE<Y.COUNT.LINE>)
;*                 GOSUB WRITE.FILE
;*             NEXT Y.COUNT.LINE
;*         END
;*         
;*     REPEAT
    
    ;*CLOSESEQ HELP.SEQ.FILE.POINTER
    CLOSE SEQ.FILE.POINTER
    
    DISPLAY "TOTAL REGISTROS PROCESADOS: " : Y.NO.ELEMS

RETURN

*FYG20240930 - INICIO -
*-----------------------------------------------------------------------------
VALIDA.DATOS:
*-----------------------------------------------------------------------------

    Y.NEW.LINE = ''
    Y.NEW.FLAG = ''

    Y.FIELD.DATA = ''
    Y.FIELD.DATA = Y.LINE     ;* SE OBTIENE LA INFORMACION
    Y.FIELD.DATA = EREPLACE (Y.FIELD.DATA, Y.SEPARADOR, @FM)

    Y.NO.LINEAS = ''
    Y.NO.LINEAS = DCOUNT(Y.FIELD.DATA, @FM)

    FOR Y.LINS = 1 TO Y.NO.LINEAS

        Y.LINEA = ''
        Y.LINEA = Y.FIELD.DATA<Y.LINS>

        Y.NO.LEN = ''
        Y.NO.LEN = LEN(Y.LINEA)

        Y.NO.DATO = ''
        Y.NO.DATO = Y.LINEA[Y.NO.LEN,1]

        IF Y.NO.DATO THEN     ;* SE VALIDA LA INFORMACION
            IF NOT (ISALNUM(Y.NO.DATO)) THEN
                Y.DATA.FIELD = ''
                Y.DATA.FIELD = Y.LINEA[1,Y.NO.LEN - 1]      ;* SE MODIFICA LA INFORMACION
                Y.NEW.LINE<-1> = Y.DATA.FIELD
                Y.NEW.FLAG = Y.NEW.FLAG + 1
            END ELSE
                Y.NEW.LINE<-1> = Y.LINEA
            END
        END ELSE
            Y.NEW.LINE<-1> = Y.LINEA
        END

    NEXT Y.LINS

    IF Y.NEW.FLAG THEN        ;* SE ACTUALIZA LA INFORMACION
        Y.NEW.LINE = EREPLACE (Y.NEW.LINE, @FM, Y.SEPARADOR)
        Y.LINE = Y.NEW.LINE
    END

RETURN

*-----------------------------------------------------------------------------
*FYG20240930 - FIN -

*-----------------------------------------------------------------------------
WRITE.FILE:
*-----------------------------------------------------------------------------

    WRITESEQ Y.LINE APPEND TO SEQ.FILE.POINTER ELSE
        DISPLAY "NO SE PUDO ESCRIBIR EN EL TEXTO ": Y.FILE.NAME
    END

RETURN

*-----------------------------------------------------------------------------LFCR_20210304-S
FORMAT.CAMPO:
*-----------------------------------------------------------------------------

    Y.PATT.FORMAT = "1N','1N" : @VM : "1N','2N" : @VM : "2N','1N" : @VM : "2N','2N" : @VM : "1N','1A" : @VM : "2N','1A"
    Y.FLAG.FINAL = 0

    CHANGE Y.SEPARADOR TO @FM IN Y.LINE

    FOR Y.ITER.FM = 1 TO Y.NO.FILEDS
        Y.FIELD.S.FMT = ''
        Y.FIELD.C.FMT = ''
        Y.FLAG.FINAL = 0

        IF Y.FORMAT.HEDR<Y.ITER.FM> MATCHES Y.PATT.FORMAT THEN
            Y.INI = FIELD(Y.FORMAT.HEDR<Y.ITER.FM>, ',', 1)
            Y.FIN = FIELD(Y.FORMAT.HEDR<Y.ITER.FM>, ',', 2)
            IF Y.FIN EQ 'E' THEN
                Y.FLAG.FINAL = 1
            END
            Y.FIELD.S.FMT = FIELD(Y.LINE, @FM, Y.ITER.FM)

            Y.SEP.VM.FIELD = ''
            IF Y.SPEC.VM.SP.LIST<Y.ITER.FM> EQ Y.VM.SEP.LIST THEN
                Y.SEP.VM.FIELD = Y.VM.SEP.LIST
            END ELSE
                IF Y.SPEC.VM.SP.LIST<Y.ITER.FM> EQ '' THEN
                    Y.SEP.VM.FIELD = 'SEPM'
                END ELSE
                    Y.SEP.VM.FIELD = Y.SPEC.VM.SP.LIST<Y.ITER.FM>
                END
            END

            IF (INDEX(Y.FIELD.S.FMT, Y.VM.SEP.LIST, 1)) OR (INDEX(Y.FIELD.S.FMT, Y.SEP.VM.FIELD, 1)) THEN
                Y.SEP.VM = ''
                IF INDEX(Y.FIELD.S.FMT, Y.SEP.VM.FIELD, 1) THEN
                    Y.SEP.VM = Y.SEP.VM.FIELD
                END ELSE
                    Y.SEP.VM = Y.VM.SEP.LIST
                END
                Y.TOT.VM.FIELD = DCOUNT(Y.FIELD.S.FMT, Y.SEP.VM)
                Y.AUX.FIELD.S.FMT = Y.FIELD.S.FMT

                FOR Y.ITER.VM = 1 TO Y.TOT.VM.FIELD
                    Y.VM.FIELD.S.FMT = ''
                    Y.VM.FIELD.C.FMT = ''

                    Y.VM.FIELD.S.FMT = FIELD(Y.FIELD.S.FMT, Y.SEP.VM, Y.ITER.VM)
                    Y.SEP.SM.FIELD = ''
                    IF Y.SPEC.SM.SP.LIST<Y.ITER.FM> EQ Y.SM.SEP.LIST THEN
                        Y.SEP.SM.FIELD = Y.SM.SEP.LIST
                    END ELSE
                        IF Y.SPEC.SM.SP.LIST<Y.ITER.FM> EQ '' THEN
                            Y.SEP.SM.FIELD = 'SEPS'
                        END ELSE
                            Y.SEP.SM.FIELD = Y.SPEC.SM.SP.LIST<Y.ITER.FM>
                        END
                    END

                    IF (INDEX(Y.VM.FIELD.S.FMT, Y.SM.SEP.LIST, 1)) OR (INDEX(Y.VM.FIELD.S.FMT, Y.SEP.SM.FIELD, 1)) THEN
                        Y.SEP.SM = ''
                        IF INDEX(Y.VM.FIELD.S.FMT, Y.SEP.SM.FIELD, 1) THEN
                            Y.SEP.SM = Y.SEP.SM.FIELD
                        END ELSE
                            Y.SEP.SM = Y.VM.SEP.LIST
                        END
                        Y.TOT.SM.FIELD = DCOUNT(Y.VM.FIELD.S.FMT, Y.SEP.SM)
                        Y.AUX.VM.FIELD.S.FMT = Y.VM.FIELD.S.FMT

                        FOR Y.ITER.SM = 1 TO Y.TOT.SM.FIELD

                            Y.SM.FIELD.S.FMT = ''
                            Y.SM.FIELD.C.FMT = ''

                            IF Y.FLAG.FINAL EQ 1 THEN
                                Y.FIN = LEN(Y.SM.FIELD.S.FMT)
                            END

                            Y.SM.FIELD.S.FMT = FIELD(Y.VM.FIELD.S.FMT, Y.SEP.SM, Y.ITER.SM)
                            Y.SM.FIELD.C.FMT = Y.SM.FIELD.S.FMT[Y.INI, Y.FIN]
                            CHANGE Y.SM.FIELD.S.FMT TO Y.SM.FIELD.C.FMT IN Y.AUX.VM.FIELD.S.FMT

                        NEXT Y.ITER.SM
                        Y.VM.FIELD.C.FMT = Y.AUX.VM.FIELD.S.FMT

                    END ELSE
                        IF Y.FLAG.FINAL EQ 1 THEN
                            Y.FIN = LEN(Y.VM.FIELD.S.FMT)
                        END
                        Y.VM.FIELD.C.FMT = Y.VM.FIELD.S.FMT[Y.INI, Y.FIN]
                    END
                    CHANGE Y.VM.FIELD.S.FMT TO Y.VM.FIELD.C.FMT IN Y.AUX.FIELD.S.FMT

                NEXT Y.ITER.VM
                Y.FIELD.C.FMT = Y.AUX.FIELD.S.FMT

            END ELSE
                IF Y.FLAG.FINAL EQ 1 THEN
                    Y.FIN = LEN(Y.FIELD.S.FMT)
                END
                Y.FIELD.C.FMT = Y.FIELD.S.FMT[Y.INI, Y.FIN]
            END

            Y.LINE = REPLACE(Y.LINE, Y.ITER.FM; Y.FIELD.C.FMT)
        END
    NEXT Y.ITER.FM
    CHANGE @FM TO Y.SEPARADOR IN Y.LINE

RETURN

*-------------------------------------------------------------------------
FINALLY:
*-----------------------------------------------------------------------------

    Y.ID.NOMB = "ABC.EXTRACCION"
    Y.CHANGED.FLAG = 0

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.NOMB, Y.LIST.PARAMS, Y.LIST.VALUES)
    IF Y.LIST.VALUES THEN
        Y.VALORES = Y.LIST.VALUES
    END

    LOCATE Y.APLICACION IN Y.VALORES SETTING POSITION ELSE
        Y.CHANGED.FLAG = 1
    END

    IF Y.LOAD.TYPE EQ 'ALL' AND Y.CHANGED.FLAG EQ 1 THEN
        R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.LoadType, POS2> = 'CHANGED'
        EB.DataAccess.FWrite(FN.GENERIC.EXTRACT.PARAM.LV,Y.APLICACION,R.GENERIC.EXTRACT.PARAM.LV)
    END
    
    Y.RUTA.LOCAL = Y.FILE.PATH
    
    LOCATE "RUTA.MOVER.S3.ARCH" IN Y.LIST.PARAMS SETTING POSITION THEN
        Y.RUTA.S3 = Y.LIST.VALUES<POSITION>
    END

    ;*Y.RUTA.LOCAL = '/shares/interfaces/GEN.DATA.EXTRACT'
    ;*Y.RUTA.S3    = '/mnt/transact-contratos/interfaces/GEN.DATA.EXTRACT'
    CLOSESEQ SEQ.FILE.POINTER

    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)
    
    EB.AbcUtil.abcMoveFileToS3(Y.RUTA.LOCAL,Y.RUTA.S3,Y.FILE.NAME)
    CLOSESEQ SEQ.FILE.POINTER

END

