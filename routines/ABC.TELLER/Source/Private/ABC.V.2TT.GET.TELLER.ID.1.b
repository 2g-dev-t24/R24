*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.V.2TT.GET.TELLER.ID.1

    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.Display
    $USING  EB.SystemTables


    FN.TELLER.USER = 'F.TELLER.USER'
    F.TELLER.USER = ''
    EB.DataAccess.Opf(FN.TELLER.USER, F.TELLER.USER)

    EB.DataAccess.CacheRead(FN.TELLER.USER,OPERATOR,R.REC.VAL,YERR)
    Y.TELLER.ID = R.REC.VAL<1>

    EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdOne, Y.TELLER.ID)
    EB.Display.RebuildScreen()
    
    RETURN
END
