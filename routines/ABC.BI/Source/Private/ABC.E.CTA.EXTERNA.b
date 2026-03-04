$PACKAGE AbcBi
*-----------------------------------------------------------------------------
SUBROUTINE ABC.E.CTA.EXTERNA(ENQ.PARAM)

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening

    Y.CTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)

    F.ACCOUNT = ""
    FN.ACCOUNT = "F.ACCOUNT"
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    YEXISTE.CTA = 1

    EB.DataAccess.FRead(FN.ACCOUNT, Y.CTA, YREC.ACCOUNT, F.ACCOUNT, Y.ERR.PARAM)
    IF YREC.ACCOUNT EQ '' THEN
        YEXISTE.CTA = 0
    END

    Y.CTE = YREC.ACCOUNT<AC.AccountOpening.Account.Customer>

    ENQ.PARAM<2,1> = 'CTE.GLOBUS'
    ENQ.PARAM<3,1> = 'EQ'
    ENQ.PARAM<4,1,1> = Y.CTE

RETURN

END
