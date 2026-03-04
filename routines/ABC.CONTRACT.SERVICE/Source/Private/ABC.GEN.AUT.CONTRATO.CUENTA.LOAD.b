* @ValidationCode : MjoxOTQ0OTcyNTQ2OkNwMTI1MjoxNzY0MzgzNjE2MDc2OlVzdWFyaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Nov 2025 20:33:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usuario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*===============================================================================
$PACKAGE AbcContractService
SUBROUTINE ABC.GEN.AUT.CONTRATO.CUENTA.LOAD
*===============================================================================
    $USING EB.DataAccess
    $USING AbcGetGeneralParam
*===============================================================================
* Desarrollador:        FyG Solutions - LUIS CRUZ
* Compania:             ABC Capital
* Fecha:                2021-04-19
* Descripci�n:          Rutina de TSA.SERVICE que lista los archivos temporales
*                       de cada cuenta creada y ejecuta el enquiry de contrato para cada uno
*===============================================================================
* Fecha Modificacion : LFCR_20240226_CARATULA
* Modificaciones     : Se modifica rutina para agregar generacion de caratula
*===============================================================================
* Fecha Modificacion : LFCR_20240604_MULTITHREAD
* Modificaciones     : Se modifica rutina para migrarla de Single a Multithread
*===============================================================================
* Subroutine Type : MULTITHREAD SERVICE ROUTINE
* Attached to : TSA.SERVICE/BATCH>ABC.GENERA.CONTRATO
* Attached as : MULTITHREAD SERVICE ROUTINE
* Primary Purpose : Rutina para ejecutar enquiry de contratos para contratos digitales
*-----------------------------------------------------------------------
* Luis Cruz
* 26/09/2025
* Revision de rutina componentizada por 2G
*-----------------------------------------------------------------------
    GOSUB INICIO
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------
    CRT "EXEX LOAD RTN TEST 1"
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
    FN.ACCOUNT.NAU = "F.ACCOUNT$NAU"
    F.ACCOUNT.NAU = ""
    EB.DataAccess.Opf(FN.ACCOUNT.NAU, F.ACCOUNT.NAU)
    
    FN.EB.LOOKUP = "F.EB.LOOKUP"
    F.EB.LOOKUP = ""
    EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)
    
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.ID.PARAM = 'ABC.PARAMETROS.REPORTES'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE "RUTA_ACCT_AUX" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TEMP.PATH = Y.LIST.VALUES<POS>
        Y.PATH.EXEC = Y.LIST.VALUES<POS>
        Y.FILE.ACCT = Y.LIST.VALUES<POS>
    END
    
    LOCATE "OFS_SOURCE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.OFS.SOURCE = Y.LIST.VALUES<POS>
    END
    CRT "EXEX LOAD RTN TEST 2"
    
    CRT "LOAD RTN OFS.SOURCE-> ": Y.OFS.SOURCE
*****
*****
    
    AbcContractService.setFnAccount(FN.ACCOUNT)
    AbcContractService.setFAccount(F.ACCOUNT)
    AbcContractService.setFnAccountNau(FN.ACCOUNT.NAU)
    AbcContractService.setFAccountNau(F.ACCOUNT.NAU)
    AbcContractService.setTempPath(Y.TEMP.PATH)
    AbcContractService.setPathExec(Y.PATH.EXEC)
    AbcContractService.setOfsSource(Y.OFS.SOURCE)
    AbcContractService.setFnFileAux(FN.FILE.AUX)
    AbcContractService.setFFileAux(F.FILE.AUX)
    AbcContractService.setFnEbLookup(FN.EB.LOOKUP)
    AbcContractService.setFEbLookup(F.EB.LOOKUP)

RETURN

*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------

RETURN