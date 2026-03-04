* @ValidationCode : Mjo5NjA3NjE3NTc6Q3AxMjUyOjE3NjgyNDgxNzMzNzI6Q8Opc2FyTWlyYW5kYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2026 14:02:53
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
SUBROUTINE ABC.CREA.ARCH.CTA.GARAN.LOAD

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING EB.Updates
    $USING AbcGetGeneralParam
    $USING EB.AbcUtil
    
    TODAY = EB.SystemTables.getToday()
    
    GOSUB INICIALIZA
    GOSUB FINALIZA

RETURN

***********
INICIALIZA:
***********

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    AbcCob.setFnAccountGaran(FN.ACCOUNT)
    AbcCob.setFAccountGaran(F.ACCOUNT)

    FN.STMT = 'F.STMT.ENTRY'
    F.STMT = ''
    EB.DataAccess.Opf(FN.STMT,F.STMT)

    FN.ACCT.GEN.CONDITION = 'F.ACCT.GEN.CONDITION'
    F.ACCT.GEN.CONDITION = ''
    EB.DataAccess.Opf(FN.ACCT.GEN.CONDITION,F.ACCT.GEN.CONDITION)

    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'
    F.GROUP.CREDIT.INT = ''
    EB.DataAccess.Opf(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)

    FN.STMT.ACCT.CR = 'F.STMT.ACCT.CR'
    F.STMT.ACCT.CR = ''
    EB.DataAccess.Opf(FN.STMT.ACCT.CR,F.STMT.ACCT.CR)
    AbcCob.setFnStmtAcctCr(FN.STMT.ACCT.CR)
    AbcCob.setFStmtAcctCr(F.STMT.ACCT.CR)
 
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)
    AbcCob.setFnAbcAcctLclFldsGaran(FN.ABC.ACCT.LCL.FLDS)
    AbcCob.setFAbcAcctLclFldsGaran(F.ABC.ACCT.LCL.FLDS)
    
    FN.AA.INTEREST.ACCRUALS = 'F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS = ''
    

    Y.FECHA = TODAY
    Y.FECHA.INICIO = TODAY[1,6]:'01'
    EB.API.Cdt('',Y.FECHA.INICIO, "-1C")
    AbcCob.setYFechaInicio(Y.FECHA.INICIO)

    Y.ID.GEN.PARAM = 'ABC.REP.CTA.GARANTIZADA'
    AbcCob.setYIdGenParam(Y.ID.GEN.PARAM)

    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    AbcCob.setYListParams(Y.LIST.PARAMS)
    AbcCob.setYListValues(Y.LIST.VALUES)

    LOCATE "CATEGORIAS" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CATEGORIAS = Y.LIST.VALUES<POS>
    END

    LOCATE "TRANSACTION.CODE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRANSACTION.CODE.LIST = Y.LIST.VALUES<POS>
        CHANGE ',' TO @VM IN Y.TRANSACTION.CODE.LIST
    END

    LOCATE "MAXIMO.REGISTROS" IN Y.LIST.PARAMS SETTING POS THEN
        Y.MAXIMO.REGISTROS = Y.LIST.VALUES<POS>
    END
    AbcCob.setYMaximoRegistros(Y.MAXIMO.REGISTROS)

    LOCATE "RUTA.ARCHIVO" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RUTA.ARCHIVO = Y.LIST.VALUES<POS>
    END
    AbcCob.setYRutaArchivo(Y.RUTA.ARCHIVO)

    LOCATE "RUTA.ARCHIVO.TEMP" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RUTA.ARCHIVO.TEMP = Y.LIST.VALUES<POS>
    END
    AbcCob.setYRutaArchivoTemp(Y.RUTA.ARCHIVO.TEMP)

    LOCATE "RECORD.TYPE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RECORD.TYPE = Y.LIST.VALUES<POS>
    END
    AbcCob.setYRecordType(Y.RECORD.TYPE)

    LOCATE "HEADER" IN Y.LIST.PARAMS SETTING POS THEN
        Y.HEADER = Y.LIST.VALUES<POS>
    END
    AbcCob.setYHeader(Y.HEADER)

    LOCATE "CLIENT.ID" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CLIENT.ID = Y.LIST.VALUES<POS>
        Y.CLIENT.ID = FMT(Y.CLIENT.ID,"R%10")
    END
    AbcCob.setYClientId(Y.CLIENT.ID)

    LOCATE "FILE.NAME" IN Y.LIST.PARAMS SETTING POS THEN
        Y.FILE.NAME = Y.LIST.VALUES<POS>
    END
    AbcCob.setYFileName(Y.FILE.NAME)

    LOCATE "RECORD.TYPE.B" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RECORD.TYPE.B = Y.LIST.VALUES<POS>
    END
    AbcCob.setYRecordTypeB(Y.RECORD.TYPE.B)

    LOCATE "ACCOUNT.ID.TYPE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.ACCOUNT.ID.TYPE = Y.LIST.VALUES<POS>
    END
    AbcCob.setYAccountIdType(Y.ACCOUNT.ID.TYPE)

    LOCATE "TRANSACTION.TYPE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRANSACTION.TYPE = Y.LIST.VALUES<POS>
    END
    AbcCob.setYTransactionType(Y.TRANSACTION.TYPE)

    LOCATE "TRANSACTION.SUB.TYPE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRANSACTION.SUB.TYPE = Y.LIST.VALUES<POS>
        Y.TRANSACTION.SUB.TYPE = FMT(Y.TRANSACTION.SUB.TYPE,"L#3")
    END
    AbcCob.setYTransactionSubType(Y.TRANSACTION.SUB.TYPE)

    LOCATE "RECORD.TYPE.F" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RECORD.TYPE.F = Y.LIST.VALUES<POS>
    END
    AbcCob.setYRecordTypeF(Y.RECORD.TYPE.F)

    LOCATE "TRAILER" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRAILER = Y.LIST.VALUES<POS>
    END
    AbcCob.setYTrailer(Y.TRAILER)

    LOCATE "DESC.1" IN Y.LIST.PARAMS SETTING POS THEN
        Y.DESC.1 = Y.LIST.VALUES<POS>
        CHANGE "'" TO "" IN Y.DESC.1
    END
    AbcCob.setYDesc1(Y.DESC.1)

    LOCATE "DESC.2" IN Y.LIST.PARAMS SETTING POS THEN
        Y.DESC.2 = Y.LIST.VALUES<POS>
        CHANGE "'" TO "" IN Y.DESC.2
    END
    AbcCob.setYDesc2(Y.DESC.2)

    LOCATE "DESC.3" IN Y.LIST.PARAMS SETTING POS THEN
        Y.DESC.3 = Y.LIST.VALUES<POS>
        CHANGE "'" TO "" IN Y.DESC.3
    END
    AbcCob.setYDesc3(Y.DESC.3)

    LOCATE "DESC.4" IN Y.LIST.PARAMS SETTING POS THEN
        Y.DESC.4 = Y.LIST.VALUES<POS>
        CHANGE "'" TO "" IN Y.DESC.4
    END
    AbcCob.setYDesc4(Y.DESC.4)

    Y.PROGRAM.ID = FMT("","R#10")
    Y.LOCATION.TYPE = FMT("","R#1")
    Y.LOCATION.ID = FMT("","R#20")
    Y.TRANSACTION.IDENTIFIER =FMT("","R#20")
    AbcCob.setYProgramId(Y.PROGRAM.ID)
    AbcCob.setYLocationType(Y.LOCATION.TYPE)
    AbcCob.setYLocationId(Y.LOCATION.ID)
    AbcCob.setYTransactionIdentifier(Y.TRANSACTION.IDENTIFIER)
    
    Y.NOMBRE.RUTINA = "ABC.CREA.ARCH.CTA.GARAN.LOAD"          ;*CMB 20260112

RETURN

*************************************** INICIO CMB 20260112 ***************************************
*************
VALIDA.RUTAS:
*************

    IF CHDIR (Y.RUTA.ARCHIVO) THEN
        Y.CADENA.LOG<-1> = "Directorio origen existente " : Y.RUTA.ARCHIVO
    END ELSE
        Y.CADENA.LOG<-1> = "No existe el directorio origen " : Y.RUTA.ARCHIVO
        EXECUTE 'SH -c mkdir ': Y.RUTA.ARCHIVO CAPTURING Y.RETURNVAL.ORI
        Y.CADENA.LOG<-1> = "Y.RETURNVAL.ORI->" : Y.RETURNVAL.ORI
    END
    
    IF CHDIR (Y.RUTA.ARCHIVO.TEMP) THEN
        Y.CADENA.LOG<-1> = "Directorio tmp existente " : Y.RUTA.ARCHIVO.TEMP
    END ELSE
        Y.CADENA.LOG<-1> = "No existe el directorio tmp " : Y.RUTA.ARCHIVO.TEMP
        EXECUTE 'SH -c mkdir ': Y.RUTA.ARCHIVO.TEMP CAPTURING Y.RETURNVAL
        Y.CADENA.LOG<-1> = "Y.RETURNVAL->" : Y.RETURNVAL
    END
    
RETURN
***************************************** FIN CMB 20260112 ****************************************


*********
FINALIZA:
*********

    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)         ;*CMB 20260112

RETURN

END
