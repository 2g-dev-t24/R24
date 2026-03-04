$PACKAGE AbcTeller
    SUBROUTINE ABC.2BR.TT.CLOSE.2
*=======================================================================
*
*    First Release : 
*    Developed for : 
*    Date          : 
*
*
*=======================================================================
*
* This is Auhorisation routine attached to Teller.id versions
* checks if there is Overage or Shortage when Till is closed
* if so then reverse the Overage or Shortage and book it to  9999,
* This Routine also Updates TT.STOCK.CONTROL when Till is Closed.
*

*
*=======================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Security
    $USING AbcTable
    $USING EB.Display
    $USING AC.AccountOpening
    $USING TT.Config
    $USING AC.EntryCreation
    $USING TT.Stock
    $USING ST.CompanyCreation
    $USING EB.LocalReferences
    $USING AC.API

    GOSUB INIT
    GOSUB PROCESS

    RETURN
*=======================================================================

************
INIT:
************

    FN.TELLER.ID = 'F.TELLER.ID'
    FV.TELLER.ID = ''
    EB.DataAccess.Opf(FN.TELLER.ID,FV.TELLER.ID)

    FN.ACCOUNT = 'F.ACCOUNT'
    FV.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,FV.ACCOUNT)

    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    FV.TELLER.PARAMETER = ''
    EB.DataAccess.Opf(FN.TELLER.PARAMETER,FV.TELLER.PARAMETER)

    FN.USER = 'F.USER'
    FV.USER = ''
    EB.DataAccess.Opf(FN.USER,FV.USER)

    FN.TT.STOCK.CONTROL = 'F.TT.STOCK.CONTROL'
    FV.TT.STOCK.CONTROL = ''
    EB.DataAccess.Opf(FN.TT.STOCK.CONTROL,FV.TT.STOCK.CONTROL)
    CRACCT1 = ''
    DBACCT1 = ''


    LR.STMT.NOS.POS = ''
    EB.LocalReferences.GetLocRef('TELLER.ID','LR.STMT.NOS',LR.STMT.NOS.POS)

    RETURN
*=======================================================================

**************
PROCESS:
**************

    Y.ID.PARAM = EB.SystemTables.getIdCompany()
    ST.CompanyCreation.EbReadParameter(FN.TELLER.PARAMETER,'N','',TELLER.PARAMETER.REC,Y.ID.PARAM,FV.TELLER.PARAMETER,Y.ERROR)

    EB.DataAccess.FRead(FN.TELLER.ID,EB.SystemTables.getIdNew(),TELLER.ID.REC,FV.TELLER.ID,TELL.ID.ERR)
    IF EB.SystemTables.getRNew(TT.Contract.TellerId.TidStatus) NE 'CLOSE' THEN
     RETURN
    END

    USER.ID = EB.SystemTables.getRNew(TT.Contract.TellerId.TidUser)
    EB.DataAccess.FRead(FN.USER,USER.ID,USER.REC,FV.USER,USER.ERR)
    T.USER.NAME = USER.REC<EB.Security.User.UseUserName>


    CNT.CURR = DCOUNT(EB.SystemTables.getRNew(TT.Contract.TellerId.TidCurrency),@VM)
    FOR CURR.NO = 1 TO CNT.CURR

        CLOS.BAL= EB.SystemTables.getRNew(TT.Contract.TellerId.TidTillClosBal)<1,CURR.NO>
        TILL.BAL= EB.SystemTables.getRNew(TT.Contract.TellerId.TidTillBalance)<1,CURR.NO>

        DIFF.AMT =  TILL.BAL - ABS(CLOS.BAL)


        STOCK.CATEGORY  = EB.SystemTables.getRNew(TT.Contract.TellerId.TidCategory)<1,CURR.NO>
        STOCK.CONTROL.ID = EB.SystemTables.getRNew(TT.Contract.TellerId.TidCurrency)<1,CURR.NO> : STOCK.CATEGORY : EB.SystemTables.getIdNew()
        EB.DataAccess.FRead(FN.TT.STOCK.CONTROL,STOCK.CONTROL.ID,STOCK.CONTROL.REC,FV.TT.STOCK.CONTROL,STOCK.CONTROL.ERR)

        CNT.DENOM = DCOUNT(EB.SystemTables.getRNew(TT.Contract.TellerId.TidDenomination),@SM)
        FOR DENOM.NO = 1 TO CNT.DENOM
            CURR.DENOM = EB.SystemTables.getRNew(TT.Contract.TellerId.TidDenomination)<1,CURR.NO,DENOM.NO>
            CURR.UNIT = EB.SystemTables.getRNew(TT.Contract.TellerId.TidUnit)<1,CURR.NO,DENOM.NO>

            LOCATE CURR.DENOM IN STOCK.CONTROL.REC<TT.Stock.StockControl.ScDenomination,1> SETTING POS1 THEN
                STOCK.CONTROL.REC<TT.Stock.StockControl.ScQuantity,POS1> = CURR.UNIT
            END ELSE
                STOCK.CONTROL.REC<TT.Stock.StockControl.ScDenomination,-1> = CURR.DENOM
                STOCK.CONTROL.REC<TT.Stock.StockControl.ScQuantity,-1> = CURR.UNIT
            END

        NEXT DENOM.NO

        EB.DataAccess.FWrite(FN.TT.STOCK.CONTROL,STOCK.CONTROL.ID,STOCK.CONTROL.REC)

        IF DIFF.AMT > 0 THEN
            CRAMT = TILL.BAL - ABS(CLOS.BAL)
            CRAMT = CRAMT * -1
            VER = 1
            GOSUB BASE.ENTRY
            GOSUB CR.ENTRY
            GOSUB DB.ENTRY
            GOSUB WRITE.PARA
            VER = 0
        END ELSE
            IF DIFF.AMT < 0 THEN
                CRAMT = TILL.BAL - ABS(CLOS.BAL)
                SHORT = 1
                GOSUB BASE.ENTRY
                GOSUB CR.ENTRY
                GOSUB DB.ENTRY
                GOSUB WRITE.PARA
                SHORT = 0
            END
        END
    NEXT CURR.NO

    RETURN

*=======================================================================

*************
BASE.ENTRY:
*************
    BASE.ENTRY = ""
    YENTRY.REC = ""
    BASE.ENTRY<AC.EntryCreation.StmtEntry.SteCompanyCode> =EB.SystemTables.getIdCompany()
    BASE.ENTRY<AC.EntryCreation.StmtEntry.SteSystemId> = "AC"
    BASE.ENTRY<AC.EntryCreation.StmtEntry.SteBookingDate> = EB.SystemTables.getToday()
    BASE.ENTRY<AC.EntryCreation.StmtEntry.SteExposureDate> = EB.SystemTables.getToday()
    BASE.ENTRY<AC.EntryCreation.StmtEntry.StePositionType> = "TR"
    BASE.ENTRY<AC.EntryCreation.StmtEntry.SteCurrencyMarket> = "1"
    BASE.ENTRY<AC.EntryCreation.StmtEntry.SteCurrency> = TELLER.ID.REC<TT.Contract.TellerId.TidCurrency,CURR.NO>
    BASE.ENTRY<AC.EntryCreation.StmtEntry.SteAccountOfficer> = '1000'
    BASE.ENTRY<AC.EntryCreation.StmtEntry.SteTransReference> = EB.SystemTables.getIdNew()
    BASE.ENTRY<AC.EntryCreation.StmtEntry.SteOurReference> = EB.SystemTables.getIdNew()
    BASE.ENTRY<AC.EntryCreation.StmtEntry.SteTheirReference> = EB.SystemTables.getIdNew()
    BASE.ENTRY<AC.EntryCreation.StmtEntry.SteNarrative>= T.USER.NAME

    RETURN

*=======================================================================

**************************
CR.ENTRY:
**************************
    ENTRY.REC = BASE.ENTRY
    ENTRY.REC<AC.EntryCreation.StmtEntry.SteValueDate> = EB.SystemTables.getToday()
    ENTRY.REC<AC.EntryCreation.StmtEntry.StePlCategory> = ''
    IF VER THEN
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteTransactionCode> = TELLER.PARAMETER.REC<TT.Config.TellerParameter.ParOverCategory>
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteProductCategory> = TELLER.PARAMETER.REC<TT.Config.TellerParameter.ParShortCategory>
        CRACCT1 = TELLER.ID.REC<TT.Contract.TellerId.TidCurrency,CURR.NO> : TELLER.PARAMETER.REC<TT.Config.TellerParameter.ParShortCategory> : EB.SystemTables.getIdNew()
    END ELSE
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteTransactionCode> = TELLER.PARAMETER.REC<TT.Config.TellerParameter.ParTranCodeShort>
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteProductCategory> = TELLER.PARAMETER.REC<TT.Config.TellerParameter.ParShortCategory>
        CRACCT1 = TELLER.ID.REC<TT.Contract.TellerId.TidCurrency,CURR.NO> : TELLER.PARAMETER.REC<TT.Config.TellerParameter.ParShortCategory> : 9999
    END
    ENTRY.REC<AC.EntryCreation.StmtEntry.SteAccountNumber> = CRACCT1
    IF TELLER.ID.REC<TT.Contract.TellerId.TidCurrency,CURR.NO> EQ 'LCCY' THEN
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteAmountLcy> = CRAMT
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteAmountFcy> = ''
    END ELSE
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteAmountLcy> = CRAMT
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteAmountFcy> = ''
    END
    YENTRY.REC<-1> = LOWER(ENTRY.REC)

    RETURN

*=======================================================================

***************************
DB.ENTRY:
****************************
    ENTRY.REC = BASE.ENTRY
    ENTRY.REC<AC.EntryCreation.StmtEntry.SteValueDate> = EB.SystemTables.getToday()
    IF TELLER.ID.REC<TT.Contract.TellerId.TidCurrency,CURR.NO> EQ 'LCCY' THEN
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteAmountLcy> = CRAMT * -1
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteAmountFcy> = ''
    END ELSE
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteAmountFcy> =  CRAMT * -1
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteAmountFcy> = ''
    END
    ENTRY.REC<AC.EntryCreation.StmtEntry.StePlCategory> = ''
    IF SHORT THEN
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteTransactionCode> = TELLER.PARAMETER.REC<TT.Config.TellerParameter.ParTranCodeShort>
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteProductCategory> = TELLER.PARAMETER.REC<TT.Config.TellerParameter.ParShortCategory>
        DBACCT1 = TELLER.ID.REC<TT.Contract.TellerId.TidCurrency,CURR.NO> : TELLER.PARAMETER.REC<TT.Config.TellerParameter.ParShortCategory> : EB.SystemTables.getIdNew()
    END ELSE
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteTransactionCode> = TELLER.PARAMETER.REC<TT.Config.TellerParameter.ParTranCodeOver>
        ENTRY.REC<AC.EntryCreation.StmtEntry.SteProductCategory> = TELLER.PARAMETER.REC<TT.Config.TellerParameter.ParShortCategory>
        DBACCT1 = TELLER.ID.REC<TT.Contract.TellerId.TidCurrency,CURR.NO> : TELLER.PARAMETER.REC<TT.Config.TellerParameter.ParShortCategory> : 9999
    END

    ENTRY.REC<AC.EntryCreation.StmtEntry.SteAccountNumber> = DBACCT1
    YENTRY.REC<-1> = LOWER(ENTRY.REC)

    RETURN

*=======================================================================

****************************
WRITE.PARA:
****************************
    SAVE.STMT.NOS = EB.SystemTables.getRNew(V-10)         

    AC.API.EbAccounting("AC","SAO",YENTRY.REC,"")
    Y.LOCAL.REF(TT.Contract.TellerId.TidLocalRef)<1,LR.STMT.NOS.POS> = LOWER(EB.SystemTables.getRNew(V-10)) 
    EB.SystemTables.setRNew(TT.Contract.TellerId.TidLocalRef,Y.LOCAL.REF)
*    R.NEW(V-10) = SAVE.STMT.NOS         



    RETURN

END

