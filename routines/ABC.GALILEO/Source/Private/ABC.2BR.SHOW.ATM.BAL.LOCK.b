* @ValidationCode : Mjo3NjE1MjMyNzpDcDEyNTI6MTc2MzA3MDAyOTE3ODpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Nov 2025 18:40:29
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
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
SUBROUTINE ABC.2BR.SHOW.ATM.BAL.LOCK

*-------------------------------------------------------------------
* Subroutine:         ABC.2BR.SHOW.ATM.BAL.LOCK
* Objective:          Calculates the balance to be shown on the AMT
*                     transactions. Should be attached to the AC.LOCKED.EVENTS
*                     versions used to post the ATM transactions for pre-authorization
*-------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AC.AccountOpening
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
    
    Y.ACCOUNT = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckAccountNumber)
    EB.DataAccess.FRead(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,YF.ERROR)
    IF NOT(R.ACCOUNT) THEN
        YATM.BALANCE = 0
    END ELSE
        YPOS.LOCKED.AMT = DCOUNT(RAISE(R.ACCOUNT<AC.AccountOpening.Account.FromDate>),@FM)
        YACCT.LOCKED.AMT = R.ACCOUNT<AC.AccountOpening.Account.LockedAmount,YPOS.LOCKED.AMT>
        YATM.BALANCE = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance> - YACCT.LOCKED.AMT
    END
    Y.LOCAL.REF<1,YPOS.ATM.BALANCE> = YATM.BALANCE

    EB.SystemTables.setRNew(AC.AccountOpening.LockedEvents.LckLocalRef,Y.LOCAL.REF)
RETURN

*--------------------------------
INITIALIZE:
*--------------------------------

    YPOS.ATM.BALANCE = ""
    EB.LocalReferences.GetLocRef("AC.LOCKED.EVENTS","ATM.BALANCE",YPOS.ATM.BALANCE)

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    Y.LOCAL.REF = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLocalRef)
RETURN

END
