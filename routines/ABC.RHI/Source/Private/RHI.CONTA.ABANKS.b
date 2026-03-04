* @ValidationCode : Mjo1OTQ4OTI5ODA6Q3AxMjUyOjE3NzIzMzE5Mzc2NzU6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Feb 2026 23:25:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcRhi

SUBROUTINE RHI.CONTA.ABANKS(Y.PARAM.ID)
*************************************************************
* Extractor Routine - Contable24
********************************
*
* Created By: Rhino Systems
* Created Date: 2024/03
* Programer: Nims.
*
* Notes:
* For details consider the documentation
*
* Modifiction History
*************************************************************
* 20240430 - Nims(Rhino Systems)
*          - Seperate missing homologador and missing line balance message
*          - if condition IF RHI.AC.LINE.PROCESS.ID.TMP THEN (MSGCODE/01) Else (MESCODE/02)
* 20240506 - pick the BOOKING.DATE(not VALUE.DATE), IF BOOKING.DATE NE LAST.WORKING.DAY then skip and write MXGCODE/04 into log file
* 20240614 - minor Correction of log message in log file (MSGCODE/01) - missing label "Tabla" in the message
*            0237  .... en Tabla Homologador(EB.RHI.AC.LINE.PARAMETER)' ......
*************************************************************
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING EB.Utility
    $USING AC.EntryCreation
    $USING RE.Config
    $USING EB.Updates
    $USING EB.AbcUtil
    $USING EB.Service
    
    GOSUB VARIABLES.COMMON
    IF LEN(Y.PARAM.ID) LT 15 THEN RETURN
    CONTROL.LIST = AbcRhi.getControlList()
    Y.CONTROL.LIST = CONTROL.LIST<1,1>

    BEGIN CASE
        CASE Y.CONTROL.LIST = "ST"
            GOSUB STMT.PROCESS
        CASE Y.CONTROL.LIST = "RE"
            GOSUB SPEC.PROCESS
        CASE Y.CONTROL.LIST = "CAT"
            GOSUB CATEG.PROCESS
    END CASE

RETURN

STMT.PROCESS:

    READ Y.REC.STMT.ENTRY FROM F.STMT.ENTRY,Y.PARAM.ID THEN

        Y.PARAM.ID.ACNO =  Y.REC.STMT.ENTRY<AC.EntryCreation.StmtEntry.SteAccountNumber>
        RHI.AC.LINE.PROCESS.ID.TMP = Y.REC.STMT.ENTRY<AC.EntryCreation.StmtEntry.SteLocalRef,Y.STMT.BAL.LINE.POS>
        IF Y.PARAM.ID.ACNO[1,3] EQ "MXN" THEN
            RHI.AC.LINE.PROCESS.ID = Y.PARAM.ID.ACNO
        END ELSE
            RHI.AC.LINE.PROCESS.ID = RHI.AC.LINE.PROCESS.ID.TMP
        END
        RHI.AC.LINE.ST.RE.CAT.DC = Y.REC.STMT.ENTRY<AC.EntryCreation.StmtEntry.SteLocalRef,Y.STMT.DC.POS>

        IF (Y.PARAM.ID[1,2] EQ "S!") AND LEN(Y.PARAM.ID) GT 22 THEN   ;*Currently, Only consolidation of ENTRY.TYPE S non-forward is used.
            GOSUB STMT.DETAIL.PROCESS
        END ELSE
            RHI.AC.LINE.BOOKING.DATE = Y.REC.STMT.ENTRY<AC.EntryCreation.StmtEntry.SteBookingDate>
            RHI.AC.LINE.CURRENCY =  Y.REC.STMT.ENTRY<AC.EntryCreation.StmtEntry.SteCurrency>
            RHI.AC.LINE.AMOUNT.LCY = Y.REC.STMT.ENTRY<AC.EntryCreation.StmtEntry.SteAmountLcy>
            RHI.AC.LINE.TRAN.CODE = Y.REC.STMT.ENTRY<AC.EntryCreation.StmtEntry.SteTransactionCode>
            EB.DataAccess.CacheRead(FN.TRANSACTION,RHI.AC.LINE.TRAN.CODE,Y.REC.TRANSACTION,ERR.TRANSACTION)
*CALL CACHE.READ(FN.TRANSACTION,RHI.AC.LINE.TRAN.CODE,Y.REC.TRANSACTION,ERR.TRANSACTION)
            RHI.AC.LINE.TRAN.DESC = Y.REC.TRANSACTION<1,1>
            RHI.AC.LINE.CAT.ST.STD.RE = "ST"
            RHI.AC.LINE.ST.STMT.ID = Y.PARAM.ID
            RHI.AC.LINE.TRANS.REFERENCE = Y.REC.STMT.ENTRY<AC.EntryCreation.StmtEntry.SteTransReference>
            RHI.AC.LINE.OUR.REFERENCE = Y.REC.STMT.ENTRY<AC.EntryCreation.StmtEntry.SteOurReference>
            RHI.AC.LINE.THEIR.REFERENCE = Y.REC.STMT.ENTRY<AC.EntryCreation.StmtEntry.SteTheirReference>
            RHI.AC.LINE.CUSID = Y.REC.STMT.ENTRY<AC.EntryCreation.StmtEntry.SteCustomerId>
            RHI.AC.LINE.PL.CAT = ''
            RHI.AC.LINE.PRODUCT.CAT = Y.REC.STMT.ENTRY<AC.EntryCreation.StmtEntry.SteProductCategory>

            GOSUB RHI.AC.LINE.PROCESS
        END
    END
RETURN

STMT.DETAIL.PROCESS:

*/ Note: 1. it is expected that id sequence value 1000 is enough for consolidation, and
*/       2. there is RETURN statement that breaks the loop when the sequence KKEY.CNT breaks or it is not continuous

    FOR KKEY.CNT = 1 TO 1000
        READ Y.REC.STMT.ENTRY.DETAIL.XREF FROM F.STMT.ENTRY.DETAIL.XREF,Y.PARAM.ID:"-":KKEY.CNT THEN
            Y.CNT.STMT.ENTRY.DETAIL.XREF = DCOUNT(Y.REC.STMT.ENTRY.DETAIL.XREF,@FM)
            FOR YKEY.XREF = 1 TO Y.CNT.STMT.ENTRY.DETAIL.XREF
                Y.STMT.DETAIL.ID = Y.REC.STMT.ENTRY.DETAIL.XREF<YKEY.XREF>

                IF LEN(Y.STMT.DETAIL.ID) LT 15 THEN CONTINUE      ;* Continues the Loop

                READ Y.REC.STMT.ENTRY.DETAIL FROM F.STMT.ENTRY.DETAIL,Y.STMT.DETAIL.ID THEN
                    RHI.AC.LINE.BOOKING.DATE = Y.REC.STMT.ENTRY.DETAIL<AC.EntryCreation.StmtEntry.SteBookingDate>
                    RHI.AC.LINE.CURRENCY =  Y.REC.STMT.ENTRY.DETAIL<AC.EntryCreation.StmtEntry.SteCurrency>
                    RHI.AC.LINE.AMOUNT.LCY = Y.REC.STMT.ENTRY.DETAIL<AC.EntryCreation.StmtEntry.SteAmountLcy>
                    RHI.AC.LINE.TRAN.CODE = Y.REC.STMT.ENTRY.DETAIL<AC.EntryCreation.StmtEntry.SteTransactionCode>
                    EB.DataAccess.CacheRead(FN.TRANSACTION,RHI.AC.LINE.TRAN.CODE,Y.REC.TRANSACTION,ERR.TRANSACTION)
                    RHI.AC.LINE.TRAN.DESC = Y.REC.TRANSACTION<1,1>
                    RHI.AC.LINE.CAT.ST.STD.RE = "STD"
                    RHI.AC.LINE.ST.STMT.ID = Y.STMT.DETAIL.ID
                    RHI.AC.LINE.TRANS.REFERENCE = Y.REC.STMT.ENTRY.DETAIL<AC.EntryCreation.StmtEntry.SteTransReference>
                    RHI.AC.LINE.OUR.REFERENCE = Y.REC.STMT.ENTRY.DETAIL<AC.EntryCreation.StmtEntry.SteOurReference>
                    RHI.AC.LINE.THEIR.REFERENCE = Y.REC.STMT.ENTRY.DETAIL<AC.EntryCreation.StmtEntry.SteTheirReference>
                    RHI.AC.LINE.CUSID = Y.REC.STMT.ENTRY.DETAIL<AC.EntryCreation.StmtEntry.SteCustomerId>
                    RHI.AC.LINE.PL.CAT = ''
                    RHI.AC.LINE.PRODUCT.CAT = Y.REC.STMT.ENTRY.DETAIL<AC.EntryCreation.StmtEntry.SteProductCategory>

                    GOSUB RHI.AC.LINE.PROCESS
                END
            NEXT YKEY.XREF
        END ELSE
            RETURN        ;* BREAKS the loop when continuous sequence id breaks or dont find the id
        END
    NEXT KKEY.CNT

RETURN

SPEC.PROCESS:

    READ Y.REC.SPEC.ENTRY FROM F.RE.CONSOL.SPEC.ENTRY,Y.PARAM.ID THEN

        Y.PARAM.ID.ACNO =  Y.REC.SPEC.ENTRY<AC.EntryCreation.ReConsolSpecEntry.ReCseDealNumber>
        RHI.AC.LINE.PROCESS.ID.TMP = Y.REC.SPEC.ENTRY<AC.EntryCreation.ReConsolSpecEntry.ReCseLocalRef,Y.SPEC.BAL.LINE.POS>
        IF Y.PARAM.ID.ACNO[1,3] EQ "MXN" THEN
            RHI.AC.LINE.PROCESS.ID = Y.PARAM.ID.ACNO
        END ELSE
            RHI.AC.LINE.PROCESS.ID = RHI.AC.LINE.PROCESS.ID.TMP
        END
        RHI.AC.LINE.ST.RE.CAT.DC = Y.REC.SPEC.ENTRY<AC.EntryCreation.ReConsolSpecEntry.ReCseLocalRef,Y.SPEC.DC.POS>
        RHI.AC.LINE.BOOKING.DATE = Y.REC.SPEC.ENTRY<AC.EntryCreation.ReConsolSpecEntry.ReCseBookingDate>
        RHI.AC.LINE.CURRENCY =  Y.REC.SPEC.ENTRY<AC.EntryCreation.ReConsolSpecEntry.ReCseCurrency>
        RHI.AC.LINE.AMOUNT.LCY = Y.REC.SPEC.ENTRY<AC.EntryCreation.ReConsolSpecEntry.ReCseAmountLcy>
        RHI.AC.LINE.TRAN.CODE = Y.REC.SPEC.ENTRY<AC.EntryCreation.StmtEntry.SteTransactionCode>
        EB.DataAccess.CacheRead(FN.RE.TXN.CODE,RHI.AC.LINE.TRAN.CODE,Y.REC.RE.TXN.CODE,ERR.RE.TXN.CODE)
        RHI.AC.LINE.TRAN.DESC = Y.REC.RE.TXN.CODE<1,1>
        RHI.AC.LINE.CAT.ST.STD.RE = "RE"
        RHI.AC.LINE.ST.STMT.ID = Y.PARAM.ID
        RHI.AC.LINE.TRANS.REFERENCE = Y.REC.SPEC.ENTRY<AC.EntryCreation.ReConsolSpecEntry.ReCseTransReference>
        RHI.AC.LINE.OUR.REFERENCE = Y.REC.SPEC.ENTRY<AC.EntryCreation.ReConsolSpecEntry.ReCseOurReference>
        RHI.AC.LINE.THEIR.REFERENCE = ""
        RHI.AC.LINE.CUSID = Y.REC.SPEC.ENTRY<AC.EntryCreation.ReConsolSpecEntry.ReCseCustomerId>
        RHI.AC.LINE.PL.CAT = ''
        RHI.AC.LINE.PRODUCT.CAT = Y.REC.SPEC.ENTRY<AC.EntryCreation.ReConsolSpecEntry.ReCseProductCategory>

        GOSUB RHI.AC.LINE.PROCESS
    END

RETURN

CATEG.PROCESS:

    READ Y.REC.CATEG.ENTRY FROM F.CATEG.ENTRY,Y.PARAM.ID THEN

        Y.PARAM.ID.ACNO =  Y.REC.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatAccountNumber>
        RHI.AC.LINE.PROCESS.ID.TMP = Y.REC.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatLocalRef,Y.CATEG.BAL.LINE.POS>
        IF Y.PARAM.ID.ACNO[1,3] EQ "MXN" THEN
            RHI.AC.LINE.PROCESS.ID = Y.PARAM.ID.ACNO
        END ELSE
            RHI.AC.LINE.PROCESS.ID = RHI.AC.LINE.PROCESS.ID.TMP
        END
        RHI.AC.LINE.ST.RE.CAT.DC = Y.REC.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatLocalRef,Y.CATEG.DC.POS>
        RHI.AC.LINE.BOOKING.DATE = Y.REC.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatBookingDate>
        RHI.AC.LINE.CURRENCY =  Y.REC.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatCrfCurrency>
        RHI.AC.LINE.AMOUNT.LCY = Y.REC.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatAmountLcy>
        RHI.AC.LINE.TRAN.CODE = Y.REC.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatTransactionCode>
        EB.DataAccess.CacheRead(FN.TRANSACTION,RHI.AC.LINE.TRAN.CODE,Y.REC.TRANSACTION,ERR.TRANSACTION)
        RHI.AC.LINE.TRAN.DESC = Y.REC.TRANSACTION<1,1>
        RHI.AC.LINE.CAT.ST.STD.RE = "CAT"
        RHI.AC.LINE.ST.STMT.ID = Y.PARAM.ID
        RHI.AC.LINE.TRANS.REFERENCE = Y.REC.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatTransReference>
        RHI.AC.LINE.OUR.REFERENCE = Y.REC.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatOurReference>
        RHI.AC.LINE.THEIR.REFERENCE = Y.REC.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatTheirReference>
        RHI.AC.LINE.CUSID = Y.REC.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatCustomerId>
        RHI.AC.LINE.PL.CAT = Y.REC.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatPlCategory>
        RHI.AC.LINE.PRODUCT.CAT = ''

        GOSUB RHI.AC.LINE.PROCESS
    END

RETURN

RHI.AC.LINE.PROCESS:

*/ Apply Filter
    IF RHI.AC.LINE.PROCESS.ID.TMP MATCHES Y.FILTER.LINE THEN RETURN

    IF RHI.AC.LINE.PRODUCT.CAT MATCHES Y.FILTER.PRODUCT.CATEGORY THEN
        IF RHI.AC.LINE.TRAN.CODE EQ 'MVT' THEN
            IF RHI.AC.LINE.PROCESS.ID.TMP MATCHES Y.FILTER.EXTRA.LINE THEN RETURN
        END ELSE
            IF NOT(RHI.AC.LINE.TRAN.CODE MATCHES Y.FILTER.TRANSACTION.CODE) THEN RETURN
        END
    END
*/ End

    Y.REC.EB.RHI.AC.LINE.FIELD = ''
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = 'NEW'
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = '300000002296001'

*/ Apply Booking Date Filter and write Log (MSGCODE/04)
    IF RHI.AC.LINE.BOOKING.DATE NE Y.DATES.LWKDAY THEN
        Y.REC.EB.RHI.AC.LINE.FIELD.LOG = '(MSGCODE/04) : ':Y.CONTROL.LIST:'.':Y.PARAM.ID:'-':Y.PARAM.ID.ACNO:' AMOUNT.LCY|':RHI.AC.LINE.AMOUNT.LCY
        Y.REC.EB.RHI.AC.LINE.FIELD.LOG := '| BOOKING.DATE(':RHI.AC.LINE.BOOKING.DATE:') La Fecha no es igual a LAST.WORKING.DAY(':Y.DATES.LWKDAY:')'

        GOSUB WRITE.LOG.FILE        ;* If no need log write (MSGCODE/04 BOOKING.DATE NE LAST.WORKING.DAY) comment this line
        RETURN  ;* Dont write to extractor file
    END
*/ End
    RHI.AC.LINE.BOOKING.DATE = RHI.AC.LINE.BOOKING.DATE[1,4]:'/':RHI.AC.LINE.BOOKING.DATE[5,2]:'/':RHI.AC.LINE.BOOKING.DATE[7,2]
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.BOOKING.DATE
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = 'T24'
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = 'T24_DIARIO'
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.CURRENCY
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.BOOKING.DATE
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = 'A'

    READ Y.REC.EB.RHI.AC.LINE.PARAMETER FROM F.EB.RHI.AC.LINE.PARAMETER, RHI.AC.LINE.PROCESS.ID THEN
        Y.REC.EB.RHI.AC.LINE.FIELD<-1> = Y.REC.EB.RHI.AC.LINE.PARAMETER<1>
        Y.REC.EB.RHI.AC.LINE.FIELD<-1> = Y.REC.EB.RHI.AC.LINE.PARAMETER<2>
        Y.REC.EB.RHI.AC.LINE.FIELD<-1> = Y.REC.EB.RHI.AC.LINE.PARAMETER<3>
        Y.REC.EB.RHI.AC.LINE.FIELD<-1> = Y.REC.EB.RHI.AC.LINE.PARAMETER<4>
        Y.REC.EB.RHI.AC.LINE.FIELD<-1> = Y.REC.EB.RHI.AC.LINE.PARAMETER<5>
        Y.REC.EB.RHI.AC.LINE.FIELD<-1> = Y.REC.EB.RHI.AC.LINE.PARAMETER<6>
        Y.REC.EB.RHI.AC.LINE.FIELD<-1> = Y.REC.EB.RHI.AC.LINE.PARAMETER<7>
    END ELSE
        IF Y.PARAM.ID.ACNO[1,3] EQ 'MXN' THEN
            Y.REC.EB.RHI.AC.LINE.FIELD.LOG = '(MSGCODE/01) : ':Y.CONTROL.LIST:'.':Y.PARAM.ID:'-':Y.PARAM.ID.ACNO:' AMOUNT.LCY|':RHI.AC.LINE.AMOUNT.LCY:'| NO Existe Definicion en Tabla Homologador(EB.RHI.AC.LINE.PARAMETER)'
        END ELSE
            IF RHI.AC.LINE.PROCESS.ID.TMP THEN
                Y.REC.EB.RHI.AC.LINE.FIELD.LOG = '(MSGCODE/01) : ':Y.CONTROL.LIST:'.':Y.PARAM.ID:'-':Y.PARAM.ID.ACNO:' AMOUNT.LCY|':RHI.AC.LINE.AMOUNT.LCY:'| NO Existe Definicion en Tabla Homologador(EB.RHI.AC.LINE.PARAMETER)'
            END ELSE
                Y.REC.EB.RHI.AC.LINE.FIELD.LOG = '(MSGCODE/02) : ':Y.CONTROL.LIST:'.':Y.PARAM.ID:'-':Y.PARAM.ID.ACNO:' AMOUNT.LCY|':RHI.AC.LINE.AMOUNT.LCY:'| NO Existe Definicion en Campo BALANCE.LINE(STMT.ENTRY/CATEG.ENTRY/RE.CONSOL.SPEC.ENTRY)'
            END
        END
        GOSUB WRITE.LOG.FILE
        RETURN  ;* Dont write to extractor file
    END

    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.PROCESS.ID
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = ',,,,,,,,,,,,,,,,,,,,,'

    RHI.AC.LINE.AMT.LCY.C1 = 0
    RHI.AC.LINE.AMT.LCY.C2 = 0
    RHI.AC.LINE.AMT.LCY.D1 = 0
    RHI.AC.LINE.AMT.LCY.D2 = 0

    BEGIN CASE
        CASE NOT(RHI.AC.LINE.AMOUNT.LCY)
            Y.REC.EB.RHI.AC.LINE.FIELD.LOG = '(MSGCODE/03) : ':Y.CONTROL.LIST:'.':Y.PARAM.ID:'-':Y.PARAM.ID.ACNO:' AMOUNT.LCY|':RHI.AC.LINE.AMOUNT.LCY:'| AMOUNT.LCY Es 0/NULL'
            GOSUB WRITE.LOG.FILE
            RETURN  ;* Dont write to extractor file
        CASE RHI.AC.LINE.ST.RE.CAT.DC EQ 'C'
            RHI.AC.LINE.AMT.LCY.C1 = ABS(RHI.AC.LINE.AMOUNT.LCY)
            RHI.AC.LINE.AMT.LCY.C2 = RHI.AC.LINE.AMT.LCY.C1
        CASE RHI.AC.LINE.ST.RE.CAT.DC EQ 'D'
            RHI.AC.LINE.AMT.LCY.D1 = ABS(RHI.AC.LINE.AMOUNT.LCY)
            RHI.AC.LINE.AMT.LCY.D2 = RHI.AC.LINE.AMT.LCY.D1
        CASE RHI.AC.LINE.AMOUNT.LCY GT 0
            RHI.AC.LINE.AMT.LCY.C1 = ABS(RHI.AC.LINE.AMOUNT.LCY)
            RHI.AC.LINE.AMT.LCY.C2 = RHI.AC.LINE.AMT.LCY.C1
        CASE RHI.AC.LINE.AMOUNT.LCY LT 0
            RHI.AC.LINE.AMT.LCY.D1 = ABS(RHI.AC.LINE.AMOUNT.LCY)
            RHI.AC.LINE.AMT.LCY.D2 = RHI.AC.LINE.AMT.LCY.D1
    END CASE

    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.AMT.LCY.D1
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.AMT.LCY.C1
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.AMT.LCY.D2
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.AMT.LCY.C2
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = ',,,,,,,,'
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.TRAN.DESC
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = ',,,,,,,,,,'
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = 'User'
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = ',,'
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.CAT.ST.STD.RE
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.ST.STMT.ID
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.TRAN.CODE

    BEGIN CASE
        CASE RHI.AC.LINE.TRANS.REFERENCE
            Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.TRANS.REFERENCE
        CASE RHI.AC.LINE.OUR.REFERENCE
            Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.OUR.REFERENCE
        CASE RHI.AC.LINE.THEIR.REFERENCE
            Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.THEIR.REFERENCE
    END CASE

    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.CUSID
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.PL.CAT
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = RHI.AC.LINE.PRODUCT.CAT
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = ',,,,,,,,,,,,,,,,'
    Y.REC.EB.RHI.AC.LINE.FIELD<-1> = 'END'

    CONVERT @FM TO ',' IN Y.REC.EB.RHI.AC.LINE.FIELD

* When building id variable Y.ID.TO.WRITE.LINE, make a concat with first position the field that you want to order in the extractor report, and SORT in the .SELECT routine.
    Y.ID.TO.WRITE.LINE = RHI.AC.LINE.CAT.ST.STD.RE:"-":Y.PARAM.ID:"-":TIMESTAMP():"-":RND(10000000000)
*
    AGENT.NUMBER    = EB.Service.getAgentNumber()
    Y.DIRECTORY.DATA.FILE.TMP =  Y.DATAFILE.TMP :"/DATAFILE.TMP-":TIMESTAMP():"-":RND(10000000000)
    DEBUG
    OPENSEQ Y.DIRECTORY.DATA.FILE.TMP TO Y.DATAFILE.TMP.F ELSE
        CREATE Y.DATAFILE.TMP.F ELSE
        END
    END

    
    WRITESEQ Y.REC.EB.RHI.AC.LINE.FIELD APPEND ON Y.DATAFILE.TMP.F ELSE
        DISPLAY "ERROR AL ESCIBIR Y.DATAFILE.TMP.F"
    END

RETURN

WRITE.LOG.FILE:
    
    AGENT.NUMBER    = EB.Service.getAgentNumber()
    Y.DIRECTORY.LOG.FILE.TMP =  Y.LOGFILE.TMP :"/LOGFILE.TMP-":TIMESTAMP():"-":RND(10000000000)
    DEBUG
    OPENSEQ Y.DIRECTORY.LOG.FILE.TMP TO Y.LOGFILE.TMP.F ELSE
        CREATE Y.LOGFILE.TMP.F ELSE
        END
    END
    
    WRITESEQ Y.REC.EB.RHI.AC.LINE.FIELD.LOG APPEND ON Y.LOGFILE.TMP.F ELSE
        DISPLAY "ERROR AL ESCIBIR Y.LOGFILE.TMP.F"
    END

RETURN

VARIABLES.COMMON:
    FN.ABC.GENERAL.PARAM = AbcRhi.getFnAbcGeneralParam();
    F.ABC.GENERAL.PARAM = AbcRhi.getFAbcGeneralParam();

    FN.CATEG.ENT.ACTIVITY = AbcRhi.getFnCategEntActivity();
    F.CATEG.ENT.ACTIVITY = AbcRhi.getFCategEntActivity();

    FN.ACCT.ENT.LWORK.DAY = AbcRhi.getFnAcctEntLworkDay();
    F.ACCT.ENT.LWORK.DAY = AbcRhi.getFAcctEntLworkDay();

    FN.RE.CONSOL.SPEC.ENT.KEY = AbcRhi.getFnReConsolSpecEntKey();
    F.RE.CONSOL.SPEC.ENT.KEY = AbcRhi.getFReConsolSpecEntKey();

    FN.ACCOUNT.CLOSED = AbcRhi.getFnAccountClosed();
    F.ACCOUNT.CLOSED = AbcRhi.getFAccountClosed();

    FN.EB.RHI.AC.LINE.FILTER = AbcRhi.getFnEbRhiAcLineFilter();
    F.EB.RHI.AC.LINE.FILTER = AbcRhi.getFEbRhiAcLineFilter();

    FN.EB.RHI.AC.LINE.PARAMETER = AbcRhi.getFnEbRhiAcLineParameter();
    F.EB.RHI.AC.LINE.PARAMETER = AbcRhi.getFEbRhiAcLineParameter();

    FN.STMT.ENTRY = AbcRhi.getFnStmtEntry();
    F.STMT.ENTRY = AbcRhi.getFStmtEntry();

    FN.STMT.ENTRY.DETAIL = AbcRhi.getFnStmtEntryDetail();
    F.STMT.ENTRY.DETAIL = AbcRhi.getFStmtEntryDetail();

    FN.STMT.ENTRY.DETAIL.XREF = AbcRhi.getFnStmtEntryDetailXref();
    F.STMT.ENTRY.DETAIL.XREF = AbcRhi.getFStmtEntryDetailXref();

    FN.CATEG.ENTRY = AbcRhi.getFnCategEntry();
    F.CATEG.ENTRY = AbcRhi.getFCategEntry();

    FN.CATEG.ENTRY.DETAIL = AbcRhi.getFnCategEntryDetail();
    F.CATEG.ENTRY.DETAIL = AbcRhi.getFCategEntryDetail();

    FN.RE.CONSOL.SPEC.ENTRY = AbcRhi.getFnReConsolSpecEntry();
    F.RE.CONSOL.SPEC.ENTRY = AbcRhi.getFReConsolSpecEntry();

    FN.RE.SPEC.ENTRY.DETAIL = AbcRhi.getFnReSpecEntryDetail();
    F.RE.SPEC.ENTRY.DETAIL = AbcRhi.getFReSpecEntryDetail();

    FN.RE.TXN.CODE = AbcRhi.getFnReTxnCode();
    F.RE.TXN.CODE = AbcRhi.getFReTxnCode();

    FN.TRANSACTION = AbcRhi.getFnTransaction();
    F.TRANSACTION = AbcRhi.getFTransaction();

    Y.BASE.FILE.DIRECTORY = AbcRhi.getFileDirectory();
    Y.BASE.DATAFILE.NAME = AbcRhi.getDatafileName();
    Y.BASE.DATAFILE.EXT = AbcRhi.getDatafileExt();
    Y.BASE.LOGFILE.NAME = AbcRhi.getLogfileName();
    Y.BASE.LOGFILE.EXT = AbcRhi.getLogfileExt();

    Y.STMT.BAL.LINE.POS = AbcRhi.getStmtBalLinePos();
    Y.STMT.DC.POS = AbcRhi.getStmtDcPos();
    Y.SPEC.BAL.LINE.POS = AbcRhi.getSpecBalLinePos();
    Y.SPEC.DC.POS = AbcRhi.getSpecDcPos();
    Y.CATEG.BAL.LINE.POS = AbcRhi.getCategBalLinePos();
    Y.CATEG.DC.POS = AbcRhi.getCategDcPos();
    Y.DATAFILE.TMP = AbcRhi.getYDatafileTmp();
    Y.DATAFILE.TMP.F = AbcRhi.getYDatafileTmpF();
    Y.LOGFILE.TMP.F = AbcRhi.getYLogfileTmpF();
    Y.LOGFILE.TMP = AbcRhi.getYLogfileTmp();
    Y.FILTER.LINE = AbcRhi.getYFilterLine()
    Y.FILTER.PRODUCT.CATEGORY = AbcRhi.getYFilterProductCategory()
    Y.FILTER.EXTRA.LINE = AbcRhi.getYFilterExtraLine()
    Y.DATES.LWKDAY = AbcRhi.getYDatesLwkday()
    Y.FILTER.TRANSACTION.CODE = AbcRhi.getYFilterTransactionCode()
RETURN



END

