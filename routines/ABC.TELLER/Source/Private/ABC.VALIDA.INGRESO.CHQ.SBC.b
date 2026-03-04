*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------

    SUBROUTINE ABC.VALIDA.INGRESO.CHQ.SBC

*-----------------------------------------------------------------------------

    $USING TT.Contract
    $USING AbcTable
    $USING EB.Updates
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AbcSpei
    $USING EB.ErrorProcessing
    
    GOSUB INIT
    GOSUB PROCESO

    RETURN
*****
INIT:
*****

    LREF.TABLE  = "TELLER"
    LREF.FIELD  = ""
    LREF.FIELD := "DRAW.CHQ.NO"  : @VM
    LREF.FIELD := "DRAW.ACCT.NO" : @VM
    LREF.FIELD := "DRAW.BANK"
    LREF.POS = ""

    EB.Updates.MultiGetLocRef(LREF.TABLE, LREF.FIELD, LREF.POS)

    Y.POS.DRAW.CHQ.NO  = LREF.POS<1,1>
    Y.POS.DRAW.ACCT.NO = LREF.POS<1,2>
    Y.POS.DRAW.BANK    = LREF.POS<1,3>

    FN.TT = "F.TELLER"
    F.TT  = ""
    EB.DataAccess.Opf(FN.TT,F.TT)

    FN.TMP.LEC = "F.ABC.TMP.LECTORA.CHQ"
    F.TMP.LEC  = ""
    EB.DataAccess.Opf(FN.TMP.LEC,F.TMP.LEC)

    RETURN
********
PROCESO:
********

    Y.DRAW.CHQ.NO  = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.POS.DRAW.CHQ.NO>
    Y.DRAW.ACCT.NO = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.POS.DRAW.ACCT.NO>
    Y.DRAW.BANK    = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.POS.DRAW.BANK>

    Y.LIST.TT = ""
    Y.NO.TT   = ""
    Y.CO.TT   = ""

    Y.SELECT.TT = "SSELECT " :FN.TT: " WITH DRAW.CHQ.NO EQ " :DQUOTE(Y.DRAW.CHQ.NO): " AND WITH  DRAW.ACCT.NO EQ " :DQUOTE(Y.DRAW.ACCT.NO): " AND WITH DRAW.BANK EQ " :DQUOTE(Y.DRAW.BANK)  ; * ITSS - SUNDRAM - Added DQUOTE
    EB.DataAccess.Readlist(Y.SELECT.TT,Y.LIST.TT,"",Y.NO.TT,Y.CO.TT)

    IF Y.NO.TT GE 1 THEN
        Y.MODULO    = "IP.CAJA"
        Y.SEPARADOR = "#"
        Y.OPERATOR  = EB.SystemTables.getOperator()
        Y.CAMPOS    = ""
        Y.CAMPOS   := Y.OPERATOR : Y.SEPARADOR
        AbcSpei.AbcTraeGeneralParam(Y.MODULO, Y.CAMPOS, Y.DATOS)
        Y.ID.TMP.LEC = FIELD(Y.DATOS,Y.SEPARADOR,1)

        EXECUTE "DELETE " : FN.TMP.LEC :" ": Y.ID.TMP.LEC
        Y.ID.EXISTE = Y.LIST.TT<1,1>
        E = "Este Cheque ya se Capturo en la Transaccion Numero: " : Y.ID.EXISTE
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.StoreEndError()
    END

    RETURN
**********
END



