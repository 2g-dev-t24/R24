* @ValidationCode : MjotODk2ODY1MjQyOkNwMTI1MjoxNzU5Njk2MDA1NDU1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Oct 2025 17:26:45
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
SUBROUTINE ABC.GENERA.SALDOS.PREC.SELECT

    $USING EB.DataAccess
    $USING EB.Service
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    
    GOSUB INITIALISATION      ;* file opening, variable set up
    GOSUB MAIN.PROCESS        ;* main subroutine processing

RETURN

***************
INITIALISATION:
***************

RETURN

***************
MAIN.PROCESS:
***************

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    SELECT.STATEMENT  = "SELECT " : FN.AC.LOCKED.EVENTS
    SELECT.STATEMENT := " IF DESCRIPTION LIKE 'OFC...' 'OFICIO...' 'ORDEN...' 'OFICO...'"
    SELECT.STATEMENT := " SAVING EVAL " : '"TRANS(FBNK.ACCOUNT,ACCOUNT.NUMBER,'
    SELECT.STATEMENT := "CUSTOMER,'C')" : '"'
    CLIENTES.CON.BLOQUEOS = '' ; TOT.SELECTED.BLOQS = '' ; SYSTEM.RETURN.CODE = '' ; Y.LINEA = ''
    EB.DataAccess.Readlist(SELECT.STATEMENT, CLIENTES.CON.BLOQUEOS, "", TOT.SELECTED.BLOQS, SYSTEM.RETURN.CODE)

    Y.LINEA = CLIENTES.CON.BLOQUEOS
    F.HELP.BLOQS = AbcCob.getFHelpBloqs()
    FN.HELP.BLOQS = AbcCob.getFnHelpBloqs()
    FECHA.FIN = EB.SystemTables.getToday()
    WRITE Y.LINEA TO F.HELP.BLOQS, FECHA.FIN

    Y.FM.FIXED.SELECTION = AbcCob.getYFmFixedSelection()
    SELECT.STATEMENT  = "SELECT FBNK.ACCOUNT" : Y.FM.FIXED.SELECTION
    APP.LIST = ''
    LIST.NAME = 'IPAB.SAL.COM.PRE'
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    EB.DataAccess.Readlist(SELECT.STATEMENT,APP.LIST,"",SELECTED,SYSTEM.RETURN.CODE)

    EB.Service.BatchBuildList('', APP.LIST)

RETURN

END
