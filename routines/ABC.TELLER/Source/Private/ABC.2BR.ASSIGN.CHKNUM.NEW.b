*
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------

    SUBROUTINE ABC.2BR.ASSIGN.CHKNUM.NEW

*-----------------------------------------------------------------------------

    $USING TT.Contract
    $USING EB.SystemTables
    $USING EB.Updates

    MESSAGE = EB.SystemTables.getMessage()

    IF MESSAGE EQ "VAL" THEN RETURN

    EB.Updates.MultiGetLocRef("TELLER","DRAW.CHQ.NO", Y.CHQ)
    EB.Updates.MultiGetLocRef("TELLER","DRAW.ACCT.NO", Y.ACC)
    EB.Updates.MultiGetLocRef("TELLER","DRAW.BANK", Y.BNK)

    Y.CHEQUE.NUMBER   = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.CHQ>
    EB.SystemTables.setRNew(TT.Contract.Teller.TeChequeNumber, Y.CHEQUE.NUMBER)
    Y.CHEQUE.ACCT.NO  = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.ACC>
    EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountTwo, Y.CHEQUE.ACCT.NO)
    Y.CHEQUE.BANK.CDE = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.BNK>
    EB.SystemTables.setRNew(TT.Contract.Teller.TeChequeBankCde, Y.CHEQUE.BANK.CDE)

    RETURN
**********
END


