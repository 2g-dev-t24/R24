*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
    SUBROUTINE ABC.2BR.SHOW.ATM.BAL

*-------------------------------------------------------------------
* Subroutine:         ABC.2BR.SHOW.ATM.BAL
* Objective:          Calculates the balance to be shown on the AMT
*                     transactions. Should be attached to the FUNDS.TRANSFER
*                     versions used to post the ATM transactions
*-------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING EB.LocalReferences

*--------------------------------
* Main Program Loop
*--------------------------------
    GOSUB INITIALIZE
    GOSUB PROCESS

    RETURN

*--------------------------------
PROCESS:
*--------------------------------
    
    Y.ACCOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    EB.DataAccess.FRead(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,YF.ERROR)
    IF NOT(R.ACCOUNT) THEN
        YATM.BALANCE = 0
    END ELSE
        YPOS.LOCKED.AMT = DCOUNT(RAISE(R.ACCOUNT<AC.AccountOpening.Account.FromDate>),@FM)
        YACCT.LOCKED.AMT = R.ACCOUNT<AC.AccountOpening.Account.LockedAmount,YPOS.LOCKED.AMT>
        YATM.BALANCE = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance> - YACCT.LOCKED.AMT
    END
    Y.LOCAL.REF<1,YPOS.ATM.BALANCE> = YATM.BALANCE

    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LOCAL.REF)
    RETURN

*--------------------------------
INITIALIZE:
*--------------------------------

    YPOS.ATM.BALANCE = ""
    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","ATM.BALANCE",YPOS.ATM.BALANCE)

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    RETURN

END
