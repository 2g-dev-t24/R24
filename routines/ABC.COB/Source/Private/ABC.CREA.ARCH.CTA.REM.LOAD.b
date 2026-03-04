* @ValidationCode : MjoxNDE5NzcxMzk2OkNwMTI1MjoxNzY4ODM3NDMxMDg2OkPDqXNhck1pcmFuZGE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jan 2026 09:43:51
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
SUBROUTINE ABC.CREA.ARCH.CTA.REM.LOAD

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING EB.Updates
    $USING AbcGetGeneralParam
    $USING EB.AbcUtil
    
    TODAY = EB.SystemTables.getToday()
    
    GOSUB INICIALIZA
    GOSUB VALIDA.RUTAS
    GOSUB FINALIZA

RETURN

***********
INICIALIZA:
***********

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    AbcCob.setFnAccountRem(FN.ACCOUNT)
    AbcCob.setFAccountRem(F.ACCOUNT)

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
    AbcCob.setFnStmtAcctCrRem(FN.STMT.ACCT.CR)
    AbcCob.setFStmtAcctCrRem(F.STMT.ACCT.CR)

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)
    AbcCob.setFnAbcAcctLclFldsRem(FN.ABC.ACCT.LCL.FLDS)
    AbcCob.setFAbcAcctLclFldsRem(F.ABC.ACCT.LCL.FLDS)
    
    FN.AA.INTEREST.ACCRUALS = 'F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS = ''
    EB.DataAccess.Opf(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)
    AbcCob.setFnAaInterestAccruals(FN.AA.INTEREST.ACCRUALS)
    AbcCob.setFAaInterestAccruals(F.AA.INTEREST.ACCRUALS)

    FN.STMT.ENTRY.DETAIL = 'F.STMT.ENTRY.DETAIL'
    F.STMT.ENTRY.DETAIL = ''
    EB.DataAccess.Opf(FN.STMT.ENTRY.DETAIL, F.STMT.ENTRY.DETAIL)
    AbcCob.setFnStmtEntryDetail(FN.STMT.ENTRY.DETAIL)
    AbcCob.setFStmtEntryDetail(F.STMT.ENTRY.DETAIL)

*************************************** INICIO CMB 20260119 ***************************************
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    EB.DataAccess.Opf(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
    AbcCob.setFnAaAccountDetails(FN.AA.ACCOUNT.DETAILS)
    AbcCob.setFAaAccountDetails(F.AA.ACCOUNT.DETAILS)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    EB.DataAccess.Opf(FN.AA.BILL.DETAILS, F.AA.BILL.DETAILS)
    AbcCob.setFnAaBillDetails(FN.AA.BILL.DETAILS)
    AbcCob.setFAaBillDetails(F.AA.BILL.DETAILS)
***************************************** FIN CMB 20260119 ****************************************

    Y.FECHA = TODAY
    Y.FECHA.INICIO = TODAY
    EB.API.Cdt('',Y.FECHA.INICIO, "-1W")
    AbcCob.setYFechaInicioRem(Y.FECHA.INICIO)

    Y.FECHA.AUX = Y.FECHA.INICIO
    Y.FECHAS = ''
    Y.NUM.FECHAS = 0
    

    LOOP
    WHILE Y.FECHA.AUX LT Y.FECHA DO
        Y.FECHAS<-1> = Y.FECHA.AUX
        Y.NUM.FECHAS += 1
        EB.API.Cdt('',Y.FECHA.AUX, "+1C")
        PRINT 'FECHAS: ':Y.NUM.FECHAS:', ':Y.FECHAS:', ':Y.FECHA.AUX
        Y.CADENA.LOG<-1> = 'FECHAS: ':Y.NUM.FECHAS:', ':Y.FECHAS:', ':Y.FECHA.AUX
    REPEAT

    Y.ID.GEN.PARAM = 'ABC.REP.CTA.REMUNERADA'
    AbcCob.setYIdGenParamRem(Y.ID.GEN.PARAM)

    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    AbcCob.setYListParamsRem(Y.LIST.PARAMS)
    AbcCob.setYListValuesRem(Y.LIST.VALUES)

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
    AbcCob.setYMaximoRegistrosRem(Y.MAXIMO.REGISTROS)

    LOCATE "RUTA.ARCHIVO" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RUTA.ARCHIVO = Y.LIST.VALUES<POS>
    END
    AbcCob.setYRutaArchivoRem(Y.RUTA.ARCHIVO)

    LOCATE "RUTA.ARCHIVO.TEMP" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RUTA.ARCHIVO.TEMP = Y.LIST.VALUES<POS>
    END
    AbcCob.setYRutaArchivoTempRem(Y.RUTA.ARCHIVO.TEMP)

    LOCATE "RECORD.TYPE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RECORD.TYPE = Y.LIST.VALUES<POS>
    END
    AbcCob.setYRecordTypeRem(Y.RECORD.TYPE)

    LOCATE "HEADER" IN Y.LIST.PARAMS SETTING POS THEN
        Y.HEADER = Y.LIST.VALUES<POS>
    END
    AbcCob.setYHeaderRem(Y.HEADER)

    LOCATE "CLIENT.ID" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CLIENT.ID = Y.LIST.VALUES<POS>
        Y.CLIENT.ID = FMT(Y.CLIENT.ID,"R%10")
    END
    AbcCob.setYClientIdRem(Y.CLIENT.ID)

    LOCATE "FILE.NAME" IN Y.LIST.PARAMS SETTING POS THEN
        Y.FILE.NAME = Y.LIST.VALUES<POS>
    END
    AbcCob.setYFileNameRem(Y.FILE.NAME)

    LOCATE "RECORD.TYPE.B" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RECORD.TYPE.B = Y.LIST.VALUES<POS>
    END
    AbcCob.setYRecordTypeBRem(Y.RECORD.TYPE.B)

    LOCATE "ACCOUNT.ID.TYPE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.ACCOUNT.ID.TYPE = Y.LIST.VALUES<POS>
    END
    AbcCob.setYAccountIdTypeRem(Y.ACCOUNT.ID.TYPE)

    LOCATE "TRANSACTION.TYPE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRANSACTION.TYPE = Y.LIST.VALUES<POS>
    END
    AbcCob.setYTransactionTypeRem(Y.TRANSACTION.TYPE)

    LOCATE "TRANSACTION.SUB.TYPE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRANSACTION.SUB.TYPE = Y.LIST.VALUES<POS>
        Y.TRANSACTION.SUB.TYPE = FMT(Y.TRANSACTION.SUB.TYPE,"L#3")
    END
    AbcCob.setYTransactionSubTypeRem(Y.TRANSACTION.SUB.TYPE)

    LOCATE "RECORD.TYPE.F" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RECORD.TYPE.F = Y.LIST.VALUES<POS>
    END
    AbcCob.setYRecordTypeFRem(Y.RECORD.TYPE.F)

    LOCATE "TRAILER" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRAILER = Y.LIST.VALUES<POS>
    END
    AbcCob.setYTrailerRem(Y.TRAILER)

    LOCATE "DESC.1" IN Y.LIST.PARAMS SETTING POS THEN
        Y.DESC.1 = Y.LIST.VALUES<POS>
        CHANGE "'" TO "" IN Y.DESC.1
    END
    AbcCob.setYDesc1Rem(Y.DESC.1)

    LOCATE "DESC.2" IN Y.LIST.PARAMS SETTING POS THEN
        Y.DESC.2 = Y.LIST.VALUES<POS>
        CHANGE "'" TO "" IN Y.DESC.2
    END
    AbcCob.setYDesc2Rem(Y.DESC.2)

    LOCATE "DESC.3" IN Y.LIST.PARAMS SETTING POS THEN
        Y.DESC.3 = Y.LIST.VALUES<POS>
        CHANGE "'" TO "" IN Y.DESC.3
    END
    AbcCob.setYDesc3Rem(Y.DESC.3)

    LOCATE "DESC.4" IN Y.LIST.PARAMS SETTING POS THEN
        Y.DESC.4 = Y.LIST.VALUES<POS>
        CHANGE "'" TO "" IN Y.DESC.4
    END
    AbcCob.setYDesc4Rem(Y.DESC.4)

    Y.PROGRAM.ID = FMT("","R#10")
    Y.LOCATION.TYPE = FMT("","R#1")
    Y.LOCATION.ID = FMT("","R#20")
    Y.TRANSACTION.IDENTIFIER =FMT("","R#20")
    AbcCob.setYProgramIdRem(Y.PROGRAM.ID)
    AbcCob.setYLocationTypeRem(Y.LOCATION.TYPE)
    AbcCob.setYLocationIdRem(Y.LOCATION.ID)
    AbcCob.setYTransactionIdentifierRem(Y.TRANSACTION.IDENTIFIER)
    AbcCob.setYNumFechasRem(Y.NUM.FECHAS)
    AbcCob.setYFechasRem(Y.FECHAS)
    
    Y.NOMBRE.RUTINA = "ABC.CREA.ARCH.CTA.REM.LOAD"          ;*CMB 20260109
    
RETURN

*************************************** INICIO CMB 20260109 ***************************************
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
***************************************** FIN CMB 20260109 ****************************************

*********
FINALIZA:
*********

    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)         ;*CMB 20260109
    
RETURN

END
