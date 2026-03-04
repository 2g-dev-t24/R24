* @ValidationCode : MjotODE1MjM2NTI3OkNwMTI1MjoxNzY1MTM0NjI3ODQ1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Dec 2025 16:10:27
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

SUBROUTINE GENERIC.DATA.EXTRACT.LV.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*===============================================================================
* Nombre de Programa:   GENERIC.DATA.EXTRACT.LV.LOAD
* Objetivo:             Rutina LOAD que carga las variables globales
* Desarrollador:        FyG Solutions
* Compania:             ABC Capital
* Modificaciones:
*===============================================================================
*       Autor: CAST
*       Fecha: 28/06/2022
*       Descripcion: Se agrega funcionalidad para hacer link a una aplicaci�n y extraer la informaci�n
*       Se agrega funcionalidad para ejecutar una rutina en SELECT que haga filtro de registros seleccionados.
*      CAST.20220628
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.CompanyCreation
    $USING AbcGetGeneralParam
    $USING EB.API
    $USING EB.Updates
    $USING EB.AbcUtil
    
    
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    BATCH.DETAILS = EB.SystemTables.getBatchDetails()
    Y.APLICACION = BATCH.DETAILS<3>     ;*En esta variable se envia el dato parametrizado en el campo data del Batch
*Y.APLICACION = 'COUNTRY'

    Y.TABLE.NAME = FIELD(Y.APLICACION, '-', 1)
    Y.APP.EXEC = 'TRUE'

    F.GENERIC.FILE = ''
    FN.GENERIC.FILE = 'F.' : Y.TABLE.NAME
    EB.DataAccess.Opf(FN.GENERIC.FILE,F.GENERIC.FILE)
    AbcExtractGeneric.setFnGenericFile(FN.GENERIC.FILE)
    AbcExtractGeneric.setFGenericFile(F.GENERIC.FILE)

    F.GENERIC.EXTRACT.PARAM.LV = ''
    FN.GENERIC.EXTRACT.PARAM.LV = 'F.GENERIC.EXTRACT.PARAM.LV'
    EB.DataAccess.Opf(FN.GENERIC.EXTRACT.PARAM.LV,F.GENERIC.EXTRACT.PARAM.LV)
    AbcExtractGeneric.setFnGenericExtractParamLv(FN.GENERIC.EXTRACT.PARAM.LV)
    AbcExtractGeneric.setFGenericExtractParamLv(F.GENERIC.EXTRACT.PARAM.LV)
    
    R.GENERIC.EXTRACT.PARAM.LV = ''
    EB.DataAccess.FRead(FN.GENERIC.EXTRACT.PARAM.LV,Y.APLICACION,R.GENERIC.EXTRACT.PARAM.LV,F.GENERIC.EXTRACT.PARAM.LV,ERR.GENERIC.EXTRACT.PARAM.LV)

    IF R.GENERIC.EXTRACT.PARAM.LV THEN
        Y.FLAG.HEADER        = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.Header>
        Y.SEPARADOR          = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.Separador>
        Y.FILE.PATH          = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.FilePath>
        Y.FILE.NAME          = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.FileName>
        Y.COMPANY            = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.Company>
        Y.LOAD.TYPE          = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.LoadType>
        Y.LOAD.DATE.INI      = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.LoadDateIni>
        Y.LOAD.DATE.FIN      = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.LoadDateFin>
        Y.HELP.FILE          = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.HelpFile>
        Y.FIELD.LIST         = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.Field>)
        Y.LOCAL.NAME.LIST    = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.LocalName>)
        Y.OPERADOR.LIST      = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.Operador>)
        Y.OPERANDO.LIST      = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.Operando>)
        Y.VM.SEP             = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.VmSep>
        Y.SM.SEP             = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.SmSep>
        Y.CONSTANT = 'F'      ;*Constante que indica el valor unico
        Y.SPEC.VM.SEP.LIST   = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.SpecVmSep>)
        Y.SPEC.SM.SEP.LIST   = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.SpecSmSep>)
        Y.NO.POS.VM.LIST     = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.NoPosVm>)
        Y.NO.POS.SM.LIST     = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.NoPosSm>)
        Y.VISUALIZA.LIST     = RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.Visualiza>)
        Y.LINK.APP.FIELD.LIST= RAISE(R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.LinkAppField>) ;*CAST.20220628.I
        Y.SEL.FILTER.ROUTINE = R.GENERIC.EXTRACT.PARAM.LV<AbcTable.GenericExtractParamLv.SelFilterRoutine> ;*CAST.20220628.F
        Y.NO.FILEDS = DCOUNT(Y.FIELD.LIST, @FM)
    END
    Y.LAST.WORKING.DAY= EB.SystemTables.getRDates(EB.Utility.Dates.DatLastWorkingDay)
*    Y.LAST.WORKING.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.COMPANY.ID = EB.SystemTables.getIdCompany()
    R.COMPANY = ST.CompanyCreation.Company.Read(Y.COMPANY.ID, COMP.ERR)
    Y.NOSTRO.MNEMONIC  = R.COMPANY<ST.CompanyCreation.Company.EbComNostroMnemonic>

    FIND Y.NOSTRO.MNEMONIC IN Y.COMPANY SETTING POS1, POS2 THEN
        Y.LOAD.TYPE     = Y.LOAD.TYPE<POS1, POS2>
    END ELSE
        Y.APP.EXEC  = 'FALSE'
    END

    Y.LOAD.DATE.FMT.INI = ''
    Y.LOAD.DATE.FMT.FIN = ''
    Y.ID.GEN.PARAM = "ABC.EXTRACCION.INHABIL"

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    TODAY   = EB.SystemTables.getToday()
    IF Y.LIST.VALUES THEN
        Y.PARAMETRO = Y.LIST.PARAMS
        Y.VALORES = Y.LIST.VALUES
        LOCATE Y.TABLE.NAME IN Y.VALORES SETTING POSITION THEN
            LOCATE 'DATE.TIME.INI' IN Y.PARAMETRO SETTING POSITION.INI THEN
                Y.LOAD.DATE.FMT.INI = Y.LIST.VALUES<POSITION.INI>
            END ELSE
                Y.LOAD.DATE.FMT.INI = TODAY[3,6]
            END
            LOCATE 'DATE.TIME.FIN' IN Y.PARAMETRO SETTING POSITION.FIN THEN
                Y.LOAD.DATE.FMT.FIN = Y.LIST.VALUES<POSITION.FIN>
            END ELSE
                Y.LOAD.DATE.FMT.FIN = TODAY[3,6]
            END
        END
    END

    IF Y.LOAD.DATE.FMT.FIN EQ '' THEN
        IF Y.LOAD.DATE.INI AND Y.LOAD.DATE.FIN THEN
            Y.LOAD.DATE.FMT.INI = Y.LOAD.DATE.INI[3,6]
            Y.LOAD.DATE.FMT.FIN = Y.LOAD.DATE.FIN[3,6]
        END ELSE
************************* INICIO CAMB ***************************
            Y.LOAD.DATE.FMT.INI = TODAY[3,6]
            Y.LOAD.DATE.FMT.FIN = TODAY[3,6]
*************************** FIN CAMB *****************************
        END
    END


    Y.LOCAL.FIELD.LIST = ''
    FOR Y.AA = 1 TO Y.NO.FILEDS
        IF Y.LOCAL.NAME.LIST<Y.AA> THEN
            Y.LOCAL.FIELD.LIST<1,-1> = Y.LOCAL.NAME.LIST<Y.AA>
        END
    NEXT Y.AA

    Y.TABLE.NAME = FIELD(Y.TABLE.NAME, '$', 1)
    Y.LOCAL.REF.POS = ''
    EB.Updates.MultiGetLocRef(Y.TABLE.NAME,Y.LOCAL.FIELD.LIST,Y.LOCAL.REF.POS)

    EB.API.GetStandardSelectionDets(Y.TABLE.NAME,YREC.APP.SS)

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    AbcExtractGeneric.setYFlagHeader(Y.FLAG.HEADER)
    AbcExtractGeneric.setYFilePath(Y.FILE.PATH)
    AbcExtractGeneric.setYFileName(Y.FILE.NAME)
    AbcExtractGeneric.setYLoadDateIni(Y.LOAD.DATE.INI)
    AbcExtractGeneric.setYLoadDateFin(Y.LOAD.DATE.FIN)
    AbcExtractGeneric.setYOperadorList(Y.OPERADOR.LIST)
    AbcExtractGeneric.setYOperandoList(Y.OPERANDO.LIST)
    AbcExtractGeneric.setYConstant(Y.CONSTANT)
    AbcExtractGeneric.setYSelFilterRoutine(Y.SEL.FILTER.ROUTINE)

    AbcExtractGeneric.setYLoadDateFmtIni(Y.LOAD.DATE.FMT.INI)
    AbcExtractGeneric.setYLoadDateFmtFin(Y.LOAD.DATE.FMT.FIN)
    AbcExtractGeneric.setYAppExec(Y.APP.EXEC)
    AbcExtractGeneric.setYLoadType(Y.LOAD.TYPE)
    AbcExtractGeneric.setYFieldList(Y.FIELD.LIST)
    
    AbcExtractGeneric.setYLocalFieldList(Y.LOCAL.FIELD.LIST)
    AbcExtractGeneric.setYLocalRefPos(Y.LOCAL.REF.POS)
    AbcExtractGeneric.setFDataHelpFile(Y.HELP.FILE)
    AbcExtractGeneric.setYNoFileds(Y.NO.FILEDS)
    AbcExtractGeneric.setYLocalNameList(Y.LOCAL.NAME.LIST)
    AbcExtractGeneric.setYNoPosVmList(Y.NO.POS.VM.LIST)
    AbcExtractGeneric.setYNoPosSmList(Y.NO.POS.SM.LIST)
    AbcExtractGeneric.setYVisualizaList(Y.VISUALIZA.LIST)
    
    AbcExtractGeneric.setYVmSep(Y.VM.SEP)
    AbcExtractGeneric.setYSmSep(Y.SM.SEP)
    AbcExtractGeneric.setYSpecVmSepList(Y.SPEC.VM.SEP.LIST)
    AbcExtractGeneric.setYSpecSmSepList(Y.SPEC.SM.SEP.LIST)
    AbcExtractGeneric.setYRecAppSs(YREC.APP.SS)
    AbcExtractGeneric.setYSeparador(Y.SEPARADOR)
    AbcExtractGeneric.setYLinkAppFieldList(Y.LINK.APP.FIELD.LIST)

RETURN


*-------------------------------------------------------------------------
*Last Step in Program
*-------------------------------------------------------------------------
FINALLY:
*-----------------------------------------------------------------------------

*Do Not Add Return :)

END

