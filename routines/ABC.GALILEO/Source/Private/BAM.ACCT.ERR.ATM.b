*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
    SUBROUTINE BAM.ACCT.ERR.ATM

*-------------------------------------------------------------------------------------
* Subroutine:         BAM.ACCT.ERR.ATM
* Objective:          Validate if the account exists and if POSTING.RESTRICT is not
*                     set, if so, raise an override to stop the OFS to authorize the
*                     transaction for the ATM Interface
*-------------------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.OverrideProcessing
*-----------------------------------
* Main Program Loop
*-----------------------------------
    GOSUB INITIALIZE
    GOSUB VALIDATE
    RETURN
*-----------------------------------
VALIDATE:
*-----------------------------------
    
    R.ACCOUNT = AC.AccountOpening.Account.Read(YACCOUNT.NUMBER, YF.ERROR)

    IF NOT(R.ACCOUNT) THEN
        TEXT = "Cuenta no existe"
        EB.OverrideProcessing.StoreOverride(1)
    END
    RETURN
*-----------------------------------
INITIALIZE:
*-----------------------------------
    YACCOUNT.NUMBER = EB.SystemTables.getComi()

    RETURN
END
