*-----------------------------------------------------------------------------
$PACKAGE AbcActivityLine
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.LINE.MVMT.R6.LOAD

    $USING EB.DataAccess
    $USING EB.Updates
    $USING AC.EntryCreation
    $USING RE.ReportGeneration
    $USING RE.Config
    $USING RE.Consolidation

    
    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS

    RETURN
*----------
INITIALIZE:
*----------

    PROCESS.GOAHEAD = 1
    STMT.Y.POS1 = ''
    STMT.Y.POS2 = ''
    CATEG.Y.POS1 = ''
    CATEG.Y.POS2 = ''
    CONSOL.Y.POS1 = ''
    CONSOL.Y.POS2 = ''

    RETURN
*----------
OPEN.FILES:
*----------

*Open the STMT.ENTRY File
    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    FV.STMT.ENTRY = ''
    EB.DataAccess.Opf(FN.STMT.ENTRY,FV.STMT.ENTRY)

*Open the CATEG.ENRTY File
    FN.CATEG.ENTRY = 'F.CATEG.ENTRY'
    FV.CATEG.ENTRY = ''
    EB.DataAccess.Opf(FN.CATEG.ENTRY,FV.CATEG.ENTRY)

*Open the RE.CONSOL.SPEC.ENTRY File
    FN.RE.CONSOL.SPEC.ENTRY = 'F.RE.CONSOL.SPEC.ENTRY'
    FV.RE.CONSOL.SPEC.ENTRY = ''
    EB.DataAccess.Opf(FN.RE.CONSOL.SPEC.ENTRY,FV.RE.CONSOL.SPEC.ENTRY)

*Open the RE.STAT.LINE.MVMT File
    FN.RE.STAT.LINE.MVMT = 'F.RE.STAT.LINE.MVMT'
    FV.RE.STAT.LINE.MVMT = ''
    EB.DataAccess.Opf(FN.RE.STAT.LINE.MVMT,FV.RE.STAT.LINE.MVMT)

* Open the RE.STAT.REP.LINE File
    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'
    FV.RE.STAT.REP.LINE = ''
    EB.DataAccess.Opf(FN.RE.STAT.REP.LINE,FV.RE.STAT.REP.LINE)

* Open the RE.STAT.REQUEST File
    FN.RE.STAT.REQUEST = 'F.RE.STAT.REQUEST'
    FV.RE.STAT.REQUEST = ''
    EB.DataAccess.Opf(FN.RE.STAT.REQUEST,FV.RE.STAT.REQUEST)

*Open the RE.CONSOL.SPEC.ENT.KEY File
    FN.RE.CONSOL.SPEC.ENT.KEY = 'F.RE.CONSOL.SPEC.ENT.KEY'
    FV.RE.CONSOL.SPEC.ENT.KEY = ''
    EB.DataAccess.Opf(FN.RE.CONSOL.SPEC.ENT.KEY,FV.RE.CONSOL.SPEC.ENT.KEY)

*Open the RE.CONSOL.PROFIT File
    FN.RE.CONSOL.PROFIT = 'F.RE.CONSOL.PROFIT'
    FV.RE.CONSOL.PROFIT = ''
    EB.DataAccess.Opf(FN.RE.CONSOL.PROFIT,FV.RE.CONSOL.PROFIT)

*Open the RE.CONSOL.STMT.ENT.KEY File
    FN.RE.CONSOL.STMT.ENT.KEY = 'F.RE.CONSOL.STMT.ENT.KEY'
    FV.RE.CONSOL.STMT.ENT.KEY = ''
    EB.DataAccess.Opf(FN.RE.CONSOL.STMT.ENT.KEY,FV.RE.CONSOL.STMT.ENT.KEY)

* Open the CATEG.ENRTY.DETAIL.XREF File
    FN.CATEG.ENTRY.DETAIL.XREF = 'F.CATEG.ENTRY.DETAIL.XREF'
    FV.CATEG.ENTRY.DETAIL.XREF = ''
    EB.DataAccess.Opf(FN.CATEG.ENTRY.DETAIL.XREF,FV.CATEG.ENTRY.DETAIL.XREF)

    RETURN
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------

    EB.Updates.MultiGetLocRef("STMT.ENTRY","BALANCE.LINE",STMT.Y.POS1)
    EB.Updates.MultiGetLocRef("STMT.ENTRY","DEBIT.CREDIT",STMT.Y.POS2)
    EB.Updates.MultiGetLocRef("CATEG.ENTRY","BALANCE.LINE",CATEG.Y.POS1)
    EB.Updates.MultiGetLocRef("CATEG.ENTRY","DEBIT.CREDIT",CATEG.Y.POS2)
    EB.Updates.MultiGetLocRef("RE.CONSOL.SPEC.ENTRY","BALANCE.LINE",CONSOL.Y.POS1)
    EB.Updates.MultiGetLocRef("RE.CONSOL.SPEC.ENTRY","DEBIT.CREDIT",CONSOL.Y.POS2)

    AbcActivityLine.setProcessGoahead(PROCESS.GOAHEAD)
    AbcActivityLine.setStmtYPost1(STMT.Y.POS1)
    AbcActivityLine.setStmtYPost2(STMT.Y.POS2)
    AbcActivityLine.setCategYpost1(CATEG.Y.POS1)
    AbcActivityLine.setCategYPost2(CATEG.Y.POS2)
    AbcActivityLine.setConsolYPos1(CONSOL.Y.POS1)
    AbcActivityLine.setConsolYPos2(CONSOL.Y.POS2)
    AbcActivityLine.setFnStmtEntry(FN.STMT.ENTRY)
    AbcActivityLine.setFvStmtEntry(FV.STMT.ENTRY)
    AbcActivityLine.setFnCategEntry(FN.CATEG.ENTRY)
    AbcActivityLine.setFvCategEntry(FV.CATEG.ENTRY)
    AbcActivityLine.setFnReConsolSpecEntry(FN.RE.CONSOL.SPEC.ENTRY)
    AbcActivityLine.setFvReConsolSpecEntry(FV.RE.CONSOL.SPEC.ENTRY)
    AbcActivityLine.setFnReStatLineMvmt(FN.RE.STAT.LINE.MVMT)
    AbcActivityLine.setFvReStatLineMvmt(FV.RE.STAT.LINE.MVMT)
    AbcActivityLine.setFnReStartRepLine(FN.RE.STAT.REP.LINE)
    AbcActivityLine.setFvReStartRepLine(FV.RE.STAT.REP.LINE)
    AbcActivityLine.setFnReStatRequest(FN.RE.STAT.REQUEST)
    AbcActivityLine.setFvReStatRequest(FV.RE.STAT.REQUEST)
    AbcActivityLine.setFnReConsolSpecEntKey(FN.RE.CONSOL.SPEC.ENT.KEY)
    AbcActivityLine.setFvReConsolSpecEntKey(FV.RE.CONSOL.SPEC.ENT.KEY)
    AbcActivityLine.setFnReConsolProfit(FN.RE.CONSOL.PROFIT)
    AbcActivityLine.setFvReConsolProfit(FV.RE.CONSOL.PROFIT)
    AbcActivityLine.setFnReConsolStmtEntKey(FN.RE.CONSOL.STMT.ENT.KEY)
    AbcActivityLine.setFvReConsolStmtEntKey(FV.RE.CONSOL.STMT.ENT.KEY)
    AbcActivityLine.setFnCategEntryDetailXref(FN.CATEG.ENTRY.DETAIL.XREF)
    AbcActivityLine.setFvCategEntryDetailXref(FV.CATEG.ENTRY.DETAIL.XREF)

    RETURN
************************************************

END
