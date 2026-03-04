* @ValidationCode : MjotMTQwMzIyMDc0NDpDcDEyNTI6MTc2MTAwOTgwNjg0MDpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Oct 2025 22:23:26
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
SUBROUTINE ABC.LINE.MVMT.R6(LINE.MVMT.ID)

*************************************************************************
* This program extracts the REPORT.NAME, REPORT.LINE his BALANCE LINE
* The key comprises of the following elements :-
* 1. Report Name * 2. '-' * 3. Line Number * 4. '-' * 5. Period End Date
* 6. '-'
* 7. Any of "A" - Account (STMT.ENTRY)
*           "P" - P&L (CATEG.ENTRY)
*        or "R" - Spec (RE.CONSOL.SPEC.ENTRY)
* 8. '-'
* 9. Sequence Number beginning with 1 E.g. GLSTD-1410-GBP-19970331-A-1
*************************************************************************
*
* Rutina: VPM.LINE.MVMT.R6
* Autor:
* Fecha:
* Modificaciones: Se realiza reingenier�a del proceso debido a que demora mucho su ejeucion en el COB
*-------------------------------------------------------------------------------------------------



    $USING EB.Utility
    $USING AC.EntryCreation
    $USING RE.ReportGeneration
    $USING RE.Config
    $USING RE.Consolidation
    $USING EB.DataAccess
    $USING EB.Service

    PRINT "Procesando l�nea : ":LINE.MVMT.ID

    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------------------------

*-------------------------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------------------------
*
*   Build of ID of RE.STAT.REP.LINE File
    Y.REPORT.NAME = FIELD(LINE.MVMT.ID,"-",1)
    Y.LINE.NUMBER = FIELD(LINE.MVMT.ID,"-",2)
    
    PROCESS.GOAHEAD            = AbcActivityLine.getProcessGoahead()
    STMT.Y.POS1                = AbcActivityLine.getStmtYPost1()
    STMT.Y.POS2                = AbcActivityLine.getStmtYPost2()
    CATEG.Y.POS1               = AbcActivityLine.getCategYpost1()
    CATEG.Y.POS2               = AbcActivityLine.getCategYPost2()
    CONSOL.Y.POS1              = AbcActivityLine.getConsolYPos1()
    CONSOL.Y.POS2              = AbcActivityLine.getConsolYPos2()
    FN.STMT.ENTRY              = AbcActivityLine.getFnStmtEntry()
    FV.STMT.ENTRY              = AbcActivityLine.getFvStmtEntry()
    FN.CATEG.ENTRY             = AbcActivityLine.getFnCategEntry()
    FV.CATEG.ENTRY             = AbcActivityLine.getFvCategEntry()
    FN.RE.CONSOL.SPEC.ENTRY    = AbcActivityLine.getFnReConsolSpecEntry()
    FV.RE.CONSOL.SPEC.ENTRY    = AbcActivityLine.getFvReConsolSpecEntry()
    FN.RE.STAT.LINE.MVMT       = AbcActivityLine.getFnReStatLineMvmt()
    FV.RE.STAT.LINE.MVMT       = AbcActivityLine.getFvReStatLineMvmt()
    FN.RE.STAT.REP.LINE        = AbcActivityLine.getFnReStartRepLine()
    FV.RE.STAT.REP.LINE        = AbcActivityLine.getFvReStartRepLine()
    FN.RE.STAT.REQUEST         = AbcActivityLine.getFnReStatRequest()
    FV.RE.STAT.REQUEST         = AbcActivityLine.getFvReStatRequest()
    FN.RE.CONSOL.SPEC.ENT.KEY  = AbcActivityLine.getFnReConsolSpecEntKey()
    FV.RE.CONSOL.SPEC.ENT.KEY  = AbcActivityLine.getFvReConsolSpecEntKey()
    FN.RE.CONSOL.PROFIT        = AbcActivityLine.getFnReConsolProfit()
    FV.RE.CONSOL.PROFIT        = AbcActivityLine.getFvReConsolProfit()
    FN.RE.CONSOL.STMT.ENT.KEY  = AbcActivityLine.getFnReConsolStmtEntKey()
    FV.RE.CONSOL.STMT.ENT.KEY  = AbcActivityLine.getFvReConsolStmtEntKey()
    FN.CATEG.ENTRY.DETAIL.XREF = AbcActivityLine.getFnCategEntryDetailXref()
    FV.CATEG.ENTRY.DETAIL.XREF = AbcActivityLine.getFvCategEntryDetailXref()

    IF Y.REPORT.NAME = "BAFM" AND Y.LINE.NUMBER = "9858" THEN RETURN

    Y.LINE.ID = Y.REPORT.NAME:".":Y.LINE.NUMBER


    Y.ERR=''

    EB.DataAccess.FRead(FN.RE.STAT.REP.LINE,Y.LINE.ID,LINE.REC,FV.RE.STAT.REP.LINE,Y.ERR)

    IF LINE.REC THEN

        IF LINE.REC<RE.Config.StatRepLine.SrlDesc> THEN
            Y.BALANCE.LINE = LINE.REC<RE.Config.StatRepLine.SrlDesc,1,1>
            Y.TEMP.VAL = ''
            Y.BALANCE.LINE.TEMP = ''
            FOR CNTR = 1 TO DCOUNT(Y.BALANCE.LINE,VM)
                Y.TEMP.VAL = Y.BALANCE.LINE<1,CNTR>
                IF Y.TEMP.VAL[5,1]="-" AND Y.TEMP.VAL[8,1]="-" AND Y.TEMP.VAL[11,1]="-" AND Y.TEMP.VAL[14,1]="-" AND Y.TEMP.VAL[17,1]="-" THEN
                    Y.BALANCE.LINE.TEMP = Y.TEMP.VAL
                END
            NEXT CNTR
            IF Y.BALANCE.LINE.TEMP THEN
                Y.BALANCE.LINE = Y.BALANCE.LINE.TEMP
            END ELSE
                Y.BALANCE.LINE = 'DEFINIR :':LINE.MVMT.ID
            END
        END ELSE
            Y.BALANCE.LINE = 'DEFINIR :':LINE.MVMT.ID
        END
        IF NOT(Y.BALANCE.LINE) THEN
            PRINT "*************  ERROR  *************"
            PRINT "SIN CUENTA-":Y.LINE.ID
            PRINT "***********************************"
        END

        EB.DataAccess.FRead(FN.RE.STAT.LINE.MVMT,LINE.MVMT.ID,LINE.MVMT.REC,FV.RE.STAT.LINE.MVMT,Y.ERR1)
        IF LINE.MVMT.REC THEN

            Y.NRO.ENTRIES = DCOUNT(LINE.MVMT.REC,@FM)
            YNUM.JC += Y.NRO.ENTRIES
* Identify the name of the file to process
            Y.FILE = FIELD(LINE.MVMT.ID,"-",5)
            LOOP
                Y.ID.MVMT  = LINE.MVMT.REC<Y.NRO.ENTRIES>
                ADDIT.LIST = ""
            WHILE Y.NRO.ENTRIES > 0
                BEGIN CASE
                    CASE Y.FILE EQ 'A'
                        ENT.FILE         = FV.RE.CONSOL.STMT.ENT.KEY
                        FN.FILE          = FN.RE.CONSOL.STMT.ENT.KEY
                        MVMT.FILE        = FV.STMT.ENTRY
                        FN.MVMT.FILE     = FN.STMT.ENTRY
                        YLOCAL.REF       = AC.EntryCreation.StmtEntry.SteLocalRef
                        YAMOUNT.LCY      = AC.EntryCreation.StmtEntry.SteAmountLcy
                        LRF.POS.BLINE    = STMT.Y.POS1
                        LRF.POS.SIGN     = STMT.Y.POS2
                        YSEP             = "."
                        GOSUB READ.ENT.FILE
                        GOSUB CHECK.ADDIT.LIST
                    CASE Y.FILE EQ 'P'
                        ENT.FILE         = FV.RE.CONSOL.PROFIT
                        FN.FILE          = FN.RE.CONSOL.PROFIT
                        MVMT.FILE        = FV.CATEG.ENTRY
                        FN.MVMT.FILE     = FN.CATEG.ENTRY
                        YLOCAL.REF       =  AC.EntryCreation.CategEntry.CatLocalRef
                        YAMOUNT.LCY      =  AC.EntryCreation.CategEntry.CatAmountLcy
                        LRF.POS.BLINE    = CATEG.Y.POS1
                        LRF.POS.SIGN     = CATEG.Y.POS2
                        YSEP             = ";"
                        GOSUB READ.ENT.FILE
                        GOSUB CHECK.ADDIT.LIST
                    CASE Y.FILE EQ 'R'
                        ENT.FILE         = FV.RE.CONSOL.SPEC.ENT.KEY
                        FN.FILE          = FN.RE.CONSOL.SPEC.ENT.KEY
                        MVMT.FILE        = FV.RE.CONSOL.SPEC.ENTRY
                        FN.MVMT.FILE     = FN.RE.CONSOL.SPEC.ENTRY
                        YLOCAL.REF       = AC.EntryCreation.ReConsolSpecEntry.ReCseLocalRef
                        YAMOUNT.LCY      = AC.EntryCreation.ReConsolSpecEntry.ReCseAmountLcy
                        LRF.POS.BLINE    = CONSOL.Y.POS1
                        LRF.POS.SIGN     = CONSOL.Y.POS2
                        YSEP             = "."
                        GOSUB READ.ENT.FILE
                        GOSUB CHECK.ADDIT.LIST
                END CASE
                Y.NRO.ENTRIES -= 1
            REPEAT
        END ELSE
            PRINT "*************  ERROR  *************"
            PRINT " RECORD LINE.MVMT.ID: ":LINE.MVMT.ID:" DOESN'T EXIST IN :":FN.RE.STAT.LINE.MVMT
            PRINT "***********************************"
        END
    END ELSE
        PRINT "*************  ERROR  *************"
        PRINT " RECORD Y.LINE.ID : ":Y.LINE.ID: " DOESN'T EXIST IN ":FN.RE.STAT.REP.LINE
        PRINT "***********************************"
    END
RETURN

*-------------------------------------------------------------------------------------------------
READ.ENT.FILE:
*-------------------------------------------------------------------------------------------------
   
    EB.DataAccess.FRead(FN.FILE, Y.ID.MVMT, REC.ENT.FILE, ENT.FILE, Y.ERR.PARAM)
    IF REC.ENT.FILE THEN
        YWORK.KEY = Y.ID.MVMT
        GOSUB PROCESS.ENT.FILE
    END ELSE
        PRINT "*************  ERROR  *************"
        PRINT Y.ID.MVMT:"-CLAVE.NO.ENCONTRADA-":FN.FILE:"-REGISTRO-":LINE.MVMT.ID:"-SUBVALOR-":Y.NRO.ENTRIES
        PRINT "***********************************"
    END

RETURN

*-------------------------------------------------------------------------------------------------
PROCESS.ENT.FILE:
*-------------------------------------------------------------------------------------------------
*
* THIS IS INSIDE THE CONSOL KEY RECORD

    MVMT.ID = REC.ENT.FILE
    NUM.ID  = DCOUNT(MVMT.ID,@FM)

    FOR WW = 1 TO NUM.ID
        Y.ID.ENTRY = REC.ENT.FILE<WW>
        IF Y.ID.ENTRY <> '' AND LEN(Y.ID.ENTRY) > 5 THEN
            YDOS = Y.ID.ENTRY[1,2]
            IF Y.FILE EQ "P" AND YDOS = 'AC' THEN
                GOSUB PROCESS.CATEG.ENTRY.CASE
            END ELSE
                YMOV.FILE.ID = Y.ID.ENTRY
                GOSUB UPDATE.FILE
            END
        END ELSE

            IF Y.ID.ENTRY NE '' AND Y.ID.ENTRY NE '0' AND NUM(Y.ID.ENTRY) THEN
                FOR JC.WORK = 1 TO Y.ID.ENTRY
                    ADDIT.LIST<-1> = YWORK.KEY:YSEP:JC.WORK
                NEXT JC.WORK
            END
        END
    NEXT WW

RETURN
*-------------------------------------------------------------------------------------------------
*-------------------------------------------------------------------------------------------------
PROCESS.CATEG.ENTRY.CASE:
*-------------------------------------------------------------------------------------------------
*    For CATEG.ENTRY records read CATEG.ENTRY.DETAIL.XREF table and get
*    CATEG.ENTRY ID
  
    EB.DataAccess.FRead(FN.CATEG.ENTRY.DETAIL.XREF, YY.ID.ENTRY, R.CATEG.ENTRY.DETAIL.XREF, FV.CATEG.ENTRY.DETAIL.XREF, Y.ERR.PARAM)
    IF R.CATEG.ENTRY.DETAIL.XREF THEN
        CE.MVMT.ID = R.CATEG.ENTRY.DETAIL.XREF
        CE.NUM.ID  = DCOUNT(CE.MVMT.ID,@FM)
        FOR YWW = 1 TO CE.NUM.ID
            YCE.ID.ENTRY = R.CATEG.ENTRY.DETAIL.XREF<YWW>
            IF YCE.ID.ENTRY <> '' AND LEN(YCE.ID.ENTRY) > 1 THEN
                YMOV.FILE.ID = YCE.ID.ENTRY
                GOSUB UPDATE.FILE
            END
        NEXT YWW
    END ELSE
        PRINT "*************  ERROR  *************"
        PRINT "Al actualizar tabla1 ":FN.CATEG.ENTRY.DETAIL.XREF:", no se encuentra el registro ":Y.ID.ENTRY
        PRINT Y.ID.MVMT:"-TABLA-":FN.FILE:"-REGISTRO-":LINE.MVMT.ID:"-SUBVALOR-":Y.NRO.ENTRIES
        PRINT "***********************************"
    END

RETURN
*-------------------------------------------------------------------------------------------------
UPDATE.FILE:
*-------------------------------------------------------------------------------------------------
* Read and Write the record Of STTM.ENTRY or CATEG.ENTRY or RE.CONSOL.SPEC.ENTRY file
* update the local field with the description of RE.STAT.REP.LINE file.

    
    EB.DataAccess.FRead(FN.MVMT.FILE, YMOV.FILE.ID, R.MVMT.FILE, MVMT.FILE, Y.ERR.PARAM)
    IF R.MVMT.FILE THEN
        R.MVMT.FILE<YLOCAL.REF, LRF.POS.BLINE> = Y.BALANCE.LINE
        Y.AMOUNT.LCY = R.MVMT.FILE<YAMOUNT.LCY>
        IF Y.AMOUNT.LCY GE 0 THEN
            R.MVMT.FILE<YLOCAL.REF, LRF.POS.SIGN> = 'C'
        END ELSE
            R.MVMT.FILE<YLOCAL.REF, LRF.POS.SIGN> = 'D'
        END

        WRITE R.MVMT.FILE TO MVMT.FILE, YMOV.FILE.ID ON ERROR
        
            PRINT "*************  ERROR  *************"
            PRINT " ERROR WRITING IN":MVMT.FILE:" ID : ":YMOV.FILE.ID
            PRINT "***********************************"
        END
        YNUM.ACT += 1
    END ELSE
        PRINT "*************  ERROR  *************"
        PRINT "Al actualizar tabla2 ":FN.FILE:", no se encuentra el registro ":YMOV.FILE.ID
        PRINT Y.ID.MVMT:"-TABLA-":FN.FILE:"-REGISTRO-":LINE.MVMT.ID:"-SUBVALOR-":Y.NRO.ENTRIES
        PRINT "***********************************"
    END

RETURN

*-------------------------------------------------------------------------------------------------
CHECK.ADDIT.LIST:
*-------------------------------------------------------------------------------------------------
    IF ADDIT.LIST THEN
        YNUM.ADDIT = DCOUNT(ADDIT.LIST,@FM)
        FOR JC.WORK = 1 TO YNUM.ADDIT
            IF ADDIT.LIST<JC.WORK> # "" THEN
                Y.ID.MVMT           = ADDIT.LIST<JC.WORK>
                ADDIT.LIST<JC.WORK> = ""
                GOSUB READ.ENT.FILE
            END
        NEXT JC.WORK
    END
RETURN
*-------------------------------------------------------------------------------------------------

END
