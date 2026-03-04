* @ValidationCode : MjoyNDEzNjU5OTQ6Q3AxMjUyOjE3NjUzMDEyNzE3Mzc6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Dec 2025 14:27:51
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
$PACKAGE AbcCob
SUBROUTINE ABC.GENERA.SALDOS.PREC.LOAD

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING EB.Service
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING EB.ErrorProcessing
    
    TODAY = EB.SystemTables.getToday()
    
    GOSUB INITIALISATION      ;* file opening, variable set up
    GOSUB MAIN.PROCESS        ;* main subroutine processing

RETURN

***************
INITIALISATION:
***************

    FN.ABC.FILE.MAPPING = 'F.ABC.FILE.MAPPING'
    F.ABC.FILE.MAPPING = ''
    EB.DataAccess.Opf(FN.ABC.FILE.MAPPING,F.ABC.FILE.MAPPING)
    AbcCob.setFnAbcFileMapping(FN.ABC.FILE.MAPPING)
    AbcCob.setFAbcFileMapping(F.ABC.FILE.MAPPING)

    FN.ABC.FILE.EXPORT = 'F.ABC.FILE.EXPORT'
    F.ABC.FILE.EXPORT = ''
    EB.DataAccess.Opf(FN.ABC.FILE.EXPORT,F.ABC.FILE.EXPORT)
    AbcCob.setFnAbcFileExport(FN.ABC.FILE.EXPORT)
    AbcCob.setFAbcFileExport(F.ABC.FILE.EXPORT)

    FN.TAX = 'F.TAX'
    F.TAX = ''
    EB.DataAccess.Opf(FN.TAX,F.TAX)

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    EB.DataAccess.Opf(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.ABC.CONCAT.SALDOS = 'F.ABC.CONCAT.SALDOS'
    F.ABC.CONCAT.SALDOS = ''
    EB.DataAccess.Opf(FN.ABC.CONCAT.SALDOS, F.ABC.CONCAT.SALDOS)
    AbcCob.setFnAbcConcatSaldos(FN.ABC.CONCAT.SALDOS)
    AbcCob.setFAbcConcatSaldos(F.ABC.CONCAT.SALDOS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    AbcCob.setFnAccountSaldos(FN.ACCOUNT)
    AbcCob.setFAccountSaldos(F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)
    AbcCob.setFnCustomerSaldos(FN.CUSTOMER)
    AbcCob.setFCustomerSaldos(F.CUSTOMER)

    GOSUB SET.DATES
    Y.SPACE = ' '
    ABC.FILE.EXPORT.ID = 'IPAB'
    Y.PERIODO.ACTUAL = TODAY[1,6]
    Y.SALTO = CHAR(10)

    Y.ID.PARAM = 'SALDOS.PRECOMPENSADOS'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    GOSUB GET.MAIN.SELECT

    LOCATE "RUTA.SALDO.PRE" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.RUTA.SALDO.PRE = Y.LIST.VALUES<YPOS.PARAM>
    END
    AbcCob.setYRutaSaldoPre(Y.RUTA.SALDO.PRE)

    LOCATE "SEP.SALDO.PRE" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.SEP = Y.LIST.VALUES<YPOS.PARAM>
    END
    AbcCob.setYSep(Y.SEP)

    LOCATE "HELP.FILE.BLOQS" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.HELP.FILE = Y.LIST.VALUES<YPOS.PARAM>
    END
    AbcCob.setYHelpFile(Y.HELP.FILE)

    F.HELP.BLOQS = ''
    FN.HELP.BLOQS = Y.HELP.FILE
    OPEN FN.HELP.BLOQS TO F.HELP.BLOQS ELSE
        EB.ErrorProcessing.FatalError('Unable to open J4 file')
    END
    AbcCob.setFnHelpBloqs(FN.HELP.BLOQS)
    AbcCob.setFHelpBloqs(F.HELP.BLOQS)
    
    EB.Service.ClearFile(FN.HELP.BLOQS, F.HELP.BLOQS)
*EB.Service.ClearFile(F.HELP.BLOQS)

    EB.DataAccess.CacheRead('F.ABC.IPAB.PARAM','SYSTEM',R.ABC.IPAB.PARAM,YERR)
    TAX.ID.LIST = R.ABC.IPAB.PARAM<AbcTable.AbcIpabParam.IdIsr>
    CHANGE ',' TO @FM IN TAX.ID.LIST
    COUNT.TAX.ID = DCOUNT(TAX.ID.LIST,@FM)
    AbcCob.setTaxIdListSaldos(TAX.ID.LIST)
 
    EB.DataAccess.CacheRead(FN.ABC.FILE.EXPORT,ABC.FILE.EXPORT.ID,R.ABC.FILE.EXPORT,YERR)
    IF R.ABC.FILE.EXPORT THEN
        LISTA.FILE = R.ABC.FILE.EXPORT<AbcTable.AbcFileExport.FileMappingId>
        CHANGE @VM TO @FM IN LISTA.FILE
        LOCATE "TABLA.1" IN LISTA.FILE SETTING POS THEN
            ABC.FILE.MAPPING.ID = R.ABC.FILE.EXPORT<AbcTable.AbcFileExport.FileMappingId,POS>
            PATH.TO.CLEAR = R.ABC.FILE.EXPORT<AbcTable.AbcFileExport.FilePath,POS>
            AbcCob.setYPathToClear(PATH.TO.CLEAR)
        END
    END
    AbcCob.setRAbcFileExport(R.ABC.FILE.EXPORT)

    FOR I = 1 TO COUNT.TAX.ID
        Y.TAX.ID = TAX.ID.LIST<I>
        AbcCob.abcObtieneTax(Y.TAX.ID,TODAY,TAX)
        IF I EQ 1 THEN VAL.POR.RET = TAX
        IF I EQ 2 THEN VAL.POR.RET.INV = TAX
    NEXT I

    EB.DataAccess.CacheRead(FN.ABC.FILE.MAPPING, ABC.FILE.MAPPING.ID, R.ABC.FILE.MAPPING,YERR)
    Y.FM.MAIN.APPLICATION = R.ABC.FILE.MAPPING<AbcTable.AbcFileMapping.MainApplication>
    Y.FM.FIXED.SELECTION = Y.MAIN.SELECT
    AbcCob.setYFmMainApplication(Y.FM.MAIN.APPLICATION)

    FN.APP  = 'F.':Y.FM.MAIN.APPLICATION
    F.APP = ''

    EB.DataAccess.Opf(FN.APP,F.APP)

    IF Y.FM.FIXED.SELECTION THEN
        Y.FM.FIXED.SELECTION = Y.SPACE : CHANGE(Y.FM.FIXED.SELECTION,'!PERIODO.ACTUAL',Y.PERIODO.ACTUAL)
    END
    AbcCob.setYFmFixedSelection(Y.FM.FIXED.SELECTION)

RETURN

*************
MAIN.PROCESS:
*************

RETURN

**********
GET.MAIN.SELECT:
**********

    Y.TOT.PARAMS = ""
    Y.MAIN.SELECT = ""
    Y.TOT.PARAMS = DCOUNT(Y.LIST.PARAMS, @FM)
    FOR Y.IT = 1 TO Y.TOT.PARAMS
        IF Y.LIST.PARAMS<Y.IT> EQ "MAIN.SELECT" THEN
            Y.MAIN.SELECT := Y.LIST.VALUES<Y.IT>
        END
    NEXT Y.IT

RETURN

**********
SET.DATES:
**********

    EB.DataAccess.CacheRead('F.TSA.SERVICE','COB',R.TSA.SERVICE,YERR)

    Y.COB.STATUS = R.TSA.SERVICE<EB.Service.TsaService.TsTsmServiceControl>
    AbcCob.setYCobStatusSaldos(Y.COB.STATUS)
    IF Y.COB.STATUS EQ 'STOP' THEN
        FECHA.INI = TODAY[1,6]:'01'
        FECHA.FIN = TODAY
    END ELSE
        FECHA.INI = TODAY[1,6]:'01'

        GOSUB GET.LAST.DAY

        Y.FEC.HABIL.ANT = TODAY[1,6]:YVAR
        EB.API.Cdt('',Y.FEC.HABIL.ANT,'-1W')

        IF Y.FEC.HABIL.ANT EQ TODAY THEN
            FECHA.FIN = TODAY[1,6]:YVAR
        END ELSE
            FECHA.FIN = TODAY
        END
    END

RETURN

*************
GET.LAST.DAY:
*************

    HOLIDAY.ID = 'MX00':FECHA.INI[1,4]
    YFLD = 14

    EB.DataAccess.CacheRead('F.HOLIDAY',HOLIDAY.ID,R.HOLIDAY,YERR)
    IF R.HOLIDAY THEN
        YMTH = FECHA.INI[5,2]
        FOR J = 1 TO 12
            IF YMTH = J THEN
                YVAR = LEN(R.HOLIDAY<YFLD>)-COUNT(R.HOLIDAY<YFLD>,'X')
                EXIT
            END
            YFLD += 1
        NEXT J
    END

RETURN

END
