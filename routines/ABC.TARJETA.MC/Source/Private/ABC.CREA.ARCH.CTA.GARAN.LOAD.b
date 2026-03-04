* @ValidationCode : MjotMTI1OTQwMjcwNDpDcDEyNTI6MTc2MDM5OTEwMDg2ODpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Oct 2025 20:45:00
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
$PACKAGE AbcTarjetaMc
*-----------------------------------------------------------------------------
SUBROUTINE ABC.CREA.ARCH.CTA.GARAN.LOAD
*===============================================================================
* Nombre de Programa : ABC.CREA.ARCH.CTA.GARAN.LOAD
* Objetivo           : Rutina que crea un archivo .txt con los intereses pagados
*                      a las cuentas garantizadas
*===============================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AbcGetGeneralParam
    $USING EB.API
    
    GOSUB INICIALIZA
    GOSUB FINALIZA
    
RETURN

***********
INICIALIZA:
***********

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.ABC.ACCT.LCL.FLDS = "F.ABC.ACCT.LCL.FLDS"
    F.ABC.ACCT.LCL.FLDS  = ""
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)

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
    
    FN.AA.INTEREST.ACCRUALS = 'F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS = ''
    EB.DataAccess.Opf(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)
    AbcTarjetaMc.setFnAaInterestAccruals(FN.AA.INTEREST.ACCRUALS)
    AbcTarjetaMc.setFAaInterestAccruals(F.AA.INTEREST.ACCRUALS)
    
    FN.STMT.ENTRY.DETAIL = 'F.STMT.ENTRY.DETAIL'
    F.STMT.ENTRY.DETAIL = ''
    EB.DataAccess.Opf(FN.STMT.ENTRY.DETAIL, F.STMT.ENTRY.DETAIL)
    AbcTarjetaMc.setFnStmtEntryDetail(FN.STMT.ENTRY.DETAIL)
    AbcTarjetaMc.setFStmtEntryDetail(F.STMT.ENTRY.DETAIL)
    
    Y.FECHA = EB.SystemTables.getToday()
    Y.FECHA.INICIO = Y.FECHA[1,6]:'01'
    EB.API.Cdt('',Y.FECHA.INICIO, "-1C")

    Y.ID.GEN.PARAM = 'ABC.REP.CTA.GARANTIZADA'

    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

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

    LOCATE "ACCOUNT.ID.TYPE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.ACCOUNT.ID.TYPE = Y.LIST.VALUES<POS>
    END

    LOCATE "TRANSACTION.TYPE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRANSACTION.TYPE = Y.LIST.VALUES<POS>
    END

    LOCATE "TRANSACTION.SUB.TYPE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRANSACTION.SUB.TYPE = Y.LIST.VALUES<POS>
        Y.TRANSACTION.SUB.TYPE = FMT(Y.TRANSACTION.SUB.TYPE,"L#3")
    END

    LOCATE "RECORD.TYPE.F" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RECORD.TYPE.F = Y.LIST.VALUES<POS>
    END

    LOCATE "TRAILER" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRAILER = Y.LIST.VALUES<POS>
    END

    LOCATE "DESC.1" IN Y.LIST.PARAMS SETTING POS THEN
        Y.DESC.1 = Y.LIST.VALUES<POS>
        CHANGE "'" TO "" IN Y.DESC.1
    END

    LOCATE "DESC.2" IN Y.LIST.PARAMS SETTING POS THEN
        Y.DESC.2 = Y.LIST.VALUES<POS>
        CHANGE "'" TO "" IN Y.DESC.2
    END

    LOCATE "DESC.3" IN Y.LIST.PARAMS SETTING POS THEN
        Y.DESC.3 = Y.LIST.VALUES<POS>
        CHANGE "'" TO "" IN Y.DESC.3
    END

    LOCATE "DESC.4" IN Y.LIST.PARAMS SETTING POS THEN
        Y.DESC.4 = Y.LIST.VALUES<POS>
        CHANGE "'" TO "" IN Y.DESC.4
    END

    Y.PROGRAM.ID = FMT("","R#10")
    Y.LOCATION.TYPE = FMT("","R#1")
    Y.LOCATION.ID = FMT("","R#20")
    Y.TRANSACTION.IDENTIFIER =FMT("","R#20")

RETURN


*********
FINALIZA:
*********
    
    AbcTarjetaMc.setFnAccount(FN.ACCOUNT)
    AbcTarjetaMc.setFAccount(F.ACCOUNT)
    AbcTarjetaMc.setFnAbcAcctLclFlds(FN.ABC.ACCT.LCL.FLDS)
    AbcTarjetaMc.setFAbcAcctLclFlds(F.ABC.ACCT.LCL.FLDS)
    AbcTarjetaMc.setFnStmt(FN.STMT)
    AbcTarjetaMc.setFStmt(F.STMT)
    AbcTarjetaMc.setFnAcctGenCondition(FN.ACCT.GEN.CONDITION)
    AbcTarjetaMc.setFAcctGenCondition(F.ACCT.GEN.CONDITION)
    AbcTarjetaMc.setFnStmt(FN.GROUP.CREDIT.INT)
    AbcTarjetaMc.setFStmt(F.GROUP.CREDIT.INT)
    AbcTarjetaMc.setFnStmtAcctCr(FN.STMT.ACCT.CR)
    AbcTarjetaMc.setFStmtAcctCr(F.STMT.ACCT.CR)
    AbcTarjetaMc.setYFecha(Y.FECHA)
    AbcTarjetaMc.setYFechaInicio(Y.FECHA.INICIO)
    AbcTarjetaMc.setYCategorias(Y.CATEGORIAS)
    AbcTarjetaMc.setYTransactionCodeList(Y.TRANSACTION.CODE.LIST)
    AbcTarjetaMc.setYMaximoRegistros(Y.MAXIMO.REGISTROS)
    AbcTarjetaMc.setYRutaArchivo(Y.RUTA.ARCHIVO)
    AbcTarjetaMc.setYRecordType(Y.RECORD.TYPE)
    AbcTarjetaMc.setYRecordTypeB(Y.RECORD.TYPE.B)
    AbcTarjetaMc.setYHeader(Y.HEADER)
    AbcTarjetaMc.setYClientId(Y.CLIENT.ID)
    AbcTarjetaMc.setYFileName(Y.FILE.NAME)
    AbcTarjetaMc.setYAccountIdType(Y.ACCOUNT.ID.TYPE)
    AbcTarjetaMc.setYTransactionType(Y.TRANSACTION.TYPE)
    AbcTarjetaMc.setYTransactionSubType(Y.TRANSACTION.SUB.TYPE)
    AbcTarjetaMc.setYRecordTypeF(Y.RECORD.TYPE.F)
    AbcTarjetaMc.setYProgramId(Y.PROGRAM.ID)
    AbcTarjetaMc.setYLocationType(Y.LOCATION.TYPE)
    AbcTarjetaMc.setYLocationId(Y.LOCATION.ID)
    AbcTarjetaMc.setYTransactionIdentifier(Y.TRANSACTION.IDENTIFIER)
    AbcTarjetaMc.setYRutaArchivoTemp(Y.RUTA.ARCHIVO.TEMP)
    AbcTarjetaMc.setYDesc1(Y.DESC.1)
    AbcTarjetaMc.setYDesc2(Y.DESC.2)
    AbcTarjetaMc.setYDesc3(Y.DESC.3)
    AbcTarjetaMc.setYDesc4(Y.DESC.4)

RETURN

END
