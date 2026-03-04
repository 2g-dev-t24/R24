$PACKAGE AbcSpei
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.VALIDA.CUENTAS.FT
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING FT.Contract
    $USING EB.ErrorProcessing

    GOSUB INICIALIZA
    GOSUB VALIDA.USUARIO

    RETURN

***********
INICIALIZA:
***********

    Y.DEBIT = ''
    Y.CREDIT = ''

    RETURN

***************
VALIDA.USUARIO:
***************

    Y.DEBIT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.CREDIT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)

    IF Y.DEBIT EQ Y.CREDIT THEN
        EB.SystemTables.setEtext("LA CUENTA DE RETIRO Y LA CUENTA DE DEPOSITO NO PUEDEN SER IGUALES")
        EB.SystemTables.setE('')
        EB.ErrorProcessing.StoreEndError()
    END

    RETURN

END
