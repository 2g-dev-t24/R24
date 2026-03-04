* @ValidationCode : MjotMTIxNzkwMTkyMjpDcDEyNTI6MTc2MTI1OTQ0NzM3NjpVc3VhcmlvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 Oct 2025 17:44:07
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
SUBROUTINE ABC.GEN.AUT.CONTRATO.CUENTA.SELECT
*===============================================================================
    $USING EB.DataAccess
    $USING EB.Service
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
    GOSUB PROCESO
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------
    
    Y.FN.EBLOOKUP = AbcContractService.getFnEbLookup();*AbcContractService.getPathExec()
    
    CRT "EXEC SELECT RTNE"
    CRT "Y.FN.EBLOOKUP-> ": Y.FN.EBLOOKUP
    Y.TMP.FILES.LST = ""
    Y.TMP.FILES.TOT = ""

;*SEL.CMD = "SELECT " : FN.EB.LOOKUP : " WITH @ID LIKE 'PDF*...'" ;*: " WITH @ID LIKE " : DQUOTE("...":SQUOTE("acct"))      ;* ITSS - SINDHU - Added DQUOTE / SQUOTE
    SEL.CMD = "SELECT " : Y.FN.EBLOOKUP : " WITH @ID LIKE 'PDF*...'"
    CRT "SEL.CMD-> ": SEL.CMD
    EB.DataAccess.Readlist(SEL.CMD, Y.TMP.FILES.LST, '', Y.TMP.FILES.TOT, ERR.FILE)
    CRT "Y.TMP.FILES.TOT-> ": Y.TMP.FILES.TOT

*****
*****
    
    EB.Service.BatchBuildList('', Y.TMP.FILES.LST)

RETURN

*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------

RETURN
