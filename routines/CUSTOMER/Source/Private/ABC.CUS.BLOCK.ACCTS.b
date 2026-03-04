$PACKAGE ABC.BP

    SUBROUTINE ABC.CUS.BLOCK.ACCTS
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.Interface
    $USING EB.ErrorProcessing
    $USING ST.Customer
    $USING AC.AccountOpening
    $USING AA.Framework

*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    ID.NEW = EB.SystemTables.getIdNew()

    FN.CUSTOMER.ACCOUNT = "F.CUSTOMER.ACCOUNT"
    F.CUSTOMER.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    EB.DataAccess.Opf(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)
    
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.POSTING = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusPostingRestrict)

    IF Y.POSTING ELSE
        Y.POSTING = ''
    END 

    EB.DataAccess.FRead(FN.CUSTOMER.ACCOUNT,ID.NEW,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUS.ACC.ERR)

    IF R.CUSTOMER.ACCOUNT THEN
        NO.OF.AC = ''
        NO.OF.AC = DCOUNT(R.CUSTOMER.ACCOUNT,@FM)
        FOR Y.AC.LIST = 1 TO NO.OF.AC
            
            Y.AC.ID = ''
            Y.AC.ID = R.CUSTOMER.ACCOUNT<Y.AC.LIST>
            
            IF Y.AC.ID THEN
                EB.DataAccess.FRead(FN.ACCOUNT, Y.AC.ID, R.ACCOUNT, F.ACCOUNT, Y.ACCT.ERR)
                
                IF R.ACCOUNT THEN
                    Y.ARRANGEMENT.ID = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
                    EB.DataAccess.FRead(FN.AA.ARRANGEMENT, Y.ARRANGEMENT.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, Y.ARR.ERR)
                    Y.PROD.LINE = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrProductLine>
                    IF Y.PROD.LINE EQ 'ACCOUNTS' THEN
                        R.AA = ''
                        R.AA<AA.Framework.ArrangementActivity.ArrActArrangement> = Y.ARRANGEMENT.ID
                        R.AA<AA.Framework.ArrangementActivity.ArrActProperty> = 'BALANCE'
                        R.AA<AA.Framework.ArrangementActivity.ArrActActivity> = 'ACCOUNTS-UPDATE-BALANCE'
                        R.AA<AA.Framework.ArrangementActivity.ArrActCustomer> = ID.NEW
                        R.AA<AA.Framework.ArrangementActivity.ArrActFieldName> = 'POSTING.RESTRICT'
                        R.AA<AA.Framework.ArrangementActivity.ArrActFieldValue> = Y.POSTING

                        GOSUB CREAR.OFS.ACCOUNT
                    END
                END
            END
            
        NEXT Y.AC.LIST
    END
    
RETURN
*-----------------------------------------------------------------------------
CREAR.OFS.ACCOUNT:
*-----------------------------------------------------------------------------
    
    Y.OFS.REQUEST = ''
    Y.OFS.APP = 'AA.ARRANGEMENT.ACTIVITY'
    Y.OFS.VERSION = 'AA.ARRANGEMENT.ACTIVITY,'
    Y.ID = ''
    Y.NO.OF.AUTH = 0
    Y.GTSMODE = ''
    
    EB.Foundation.OfsBuildRecord(Y.OFS.APP, 'I', 'PROCESS', Y.OFS.VERSION, Y.GTSMODE, Y.NO.OF.AUTH, Y.ID, R.AA, Y.OFS.REQUEST)
    
    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)
    IF Error THEN
        ETEXT = "Error al bloquear cuenta ":Y.AC.ID:" - ":Error
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN
*-----------------------------------------------------------------------------
END