*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
SUBROUTINE ABC.VALIDA.CUST.ENROL.TELL
*===============================================================================

    $USING ST.Customer
    $USING AC.AccountOpening
    $USING TT.Contract
    $USING EB.Template
    $USING EB.DataAccess
    $USING ABC.BP
    $USING EB.ErrorProcessing
    $USING EB.SystemTables

    GOSUB INICIALIZA
    IF (Y.NIVEL.CTA NE 'NIVEL.1') AND (Y.NIVEL.CTA NE 'NIVEL.2') THEN ;*AND (Y.NIVEL.CTA NE '') THEN
        GOSUB PROCESA
        RETURN
    END ELSE RETURN


*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'                ; F.CUSTOMER   = '' ; EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
    FN.ACCOUNT = 'F.ACCOUNT'       ; F.ACCOUNT   = '' ; EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    FN.EB.LOOKUP = 'F.EB.LOOKUP'   ; F.AB.LOOKUP = '' ; EB.DataAccess.Opf(FN.AB.LOOKUP, F.AB.LOOKUP)


    Y.NIVEL.CTA = ''
    Y.CTA.CUS = ''
    Y.ID.CUST = ''
    Y.IUB.CUS = ''
    Y.BIO.LAT = ''
    Y.BIO.LON = ''
    R.CUSTOMER = ''

*LEEMOS EL CAMPO CUSTOMER Y CUENTA
    Y.CTA.CUS = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
    Y.ID.CUST = EB.SystemTables.getRNew(TT.Contract.Teller.TeCustomerOne)

*DETERMINAMOS EL NIVEL DE LA CUENTA

    EB.DataAccess.FRead(FN.ACCOUNT, Y.ACC.CUS, R.ACC.CUS, F.ACCOUNT, ERR.FOL)

    IF R.ACC.CUS THEN
        Y.ID.CUST = R.ACC.CUS<AC.AccountOpening.Account.Customer>
        Y.ACCOUNT.CATEGORY = R.ACC.CUS<AC.AccountOpening.Account.Category>
*        GOSUB LEER.NIVEL
    END

    Y.EB.LOOKUP = "ABC.NIVEL.CUENTA*":Y.ACCOUNT.CATEGORY
    EB.DataAccess.FRead(FN.EB.LOOKUP, Y.EB.LOOKUP, R.EB.LOOKUP, F.EB.LOOKUP, ERR.EB.LOOKUP)

    IF R.EB.LOOKUP NE '' THEN
        Y.NIVEL.CTA = R.EB.LOOKUP<EB.Template.Lookup.LuDescription,1>
    END
        


RETURN
*---------------------------------------------------------------
PROCESA:
*---------------------------------------------------------------

    IF Y.ID.CUST THEN
        ABC.BP.AbcValidaClienteEnrol(Y.ID.CUST, Y.ESTATUS)
        IF Y.ESTATUS NE '' THEN
            IF Y.ESTATUS MATCHES "ENCONTRADO" THEN
                Y.IUB.CUS = FIELD(Y.ID.CUST, @FM, 2)
            END ELSE
                EB.SystemTables.setAf(TT.Contract.Teller.TeCustomerOne) ; EB.SystemTables.setAv(0); EB.SystemTables.setAs(0)
                E = Y.ESTATUS
                EB.SystemTables.setE(E)
                EB.ErrorProcessing.Err()
            END
        END
    END

RETURN
END