* @ValidationCode : MjotNjIwNjg1NTIxOkNwMTI1MjoxNzYxMDA5NzYwMjkxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Oct 2025 22:22:40
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
*-----------------------------------------------------------------------------
$PACKAGE AbcActivityLine
*-----------------------------------------------------------------------------
SUBROUTINE ABC.LINE.MVMT.R6.SELECT


    $USING EB.Utility
    $USING AC.EntryCreation
    $USING RE.ReportGeneration
    $USING RE.Config
    $USING RE.Consolidation
    $USING EB.DataAccess
    $USING EB.Service
    $USING EB.SystemTables

* This program selects the ids from the BAM.RE.STAT.LINE.MVMT file
* The selection is only the REPORT.NAME that existis in DAILY record of RE.STAT.eREQUEST

    FN.RE.STAT.REQUEST   = AbcActivityLine.getFnReStatRequest()
    FV.RE.STAT.REQUEST   = AbcActivityLine.getFvReStatRequest()
    FN.RE.STAT.LINE.MVMT = AbcActivityLine.getFnReStatLineMvmt()

    Y.DAILY.ID = 'DAILY'
    EB.DataAccess.FRead(FN.RE.STAT.REQUEST,Y.DAILY.ID,DAILY.REC,FV.RE.STAT.REQUEST,DAILY.YERR)



    SEL.CMD  = ''
    SEL.CMD  = 'SELECT ':FN.RE.STAT.LINE.MVMT
    SEL.CMD := ' WITH (PERIOD.END.DATE LE ':DQUOTE(EB.SystemTables.getRDates(EB.Utility.Dates.DatLastPeriodEnd))
    SEL.CMD := ' AND WITH PERIOD.END.DATE GE ':DQUOTE(EB.SystemTables.getRDates(EB.Utility.Dates.DatLastWorkingDay))
    SEL.CMD := ') AND WITH ('

    SEL.CMD.REP   = ''
    Y.OR = ''
    Y.NRO.REPORTS = DCOUNT(DAILY.REC<RE.ReportGeneration.StatRequest.ReqReportName>,@VM)
    LOOP
        Y.REPORT.NAME = DAILY.REC<RE.ReportGeneration.StatRequest.ReqReportName,Y.NRO.REPORTS>
    WHILE Y.NRO.REPORTS > 0
        IF Y.REPORT.NAME EQ "BAFM" OR Y.REPORT.NAME EQ "BRES" THEN
            SEL.CMD.REP := Y.OR:" REPORT.NAME EQ '":Y.REPORT.NAME:"'"
            Y.OR = " OR "
        END
        Y.NRO.REPORTS -= 1
    REPEAT

    SEL.CMD := SEL.CMD.REP:' )'
    EB.DataAccess.Readlist(SEL.CMD,LINE.MVMT.LIST,'',NO.SEL,SEL.ERR)
    EB.Service.BatchBuildList('F.LINE.MVMT.LIST',LINE.MVMT.LIST)

RETURN


END
