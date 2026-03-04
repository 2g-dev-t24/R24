*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.FT.SPEI.DEVOL
*-----------------------------------------------------------------------------
* Descripcion de la Subrutina
* Rutina para devoluciones SPEI
* Recibe el ID del FT generado, busca el registro y toma la cuenta y el monto,
* de los campos de debito y los ingresa en el R.NEW en los campos de credito.
*-----------------------------------------------------------------------------
* Historial de Modificacion:
*-----------------------------------------------------------------------------
*
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING AbcTable
    $USING ST.Customer
    $USING EB.Security
    $USING FT.Contract
    $USING AA.PaymentSchedule
    $USING EB.Interface
    $USING EB.Updates
    $USING EB.TransactionControl
    $USING EB.ErrorProcessing
    $USING EB.Display
    
    GOSUB INITIALIZE
    GOSUB PROCESS

    RETURN

*******************
INITIALIZE:
*******************
    Y.ID.FT = EB.SystemTables.getComi()

    FN.FT = "F.FUNDS.TRANSFER"
    F.FT  = ""
    EB.DataAccess.Opf(FN.FT,F.FT)


    FN.FT.HIS = "F.FUNDS.TRANSFER$HIS"
    F.FT.HIS  = ""
    EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)

    RETURN

********
PROCESS:
********
    EB.DataAccess.FRead(FN.FT,Y.ID.FT,REC.FT,F.FT,ERR.FT)

    IF ERR.FT THEN
        Y.ID.FT.HIS = EB.SystemTables.getComi() : ";1"

        EB.DataAccess.FRead(FN.FT.HIS,Y.ID.FT.HIS,REC.FT.HIS,F.FT.HIS,ERR.FT.HIS)


        IF ERR.FT.HIS THEN
            EB.SystemTables.setComi("")
            ETEXT = "No se encuentra la transferencia: " : Y.ID.FT
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END ELSE
            Y.CUENTA.DEBIT = REC.FT.HIS<FT.Contract.FundsTransfer.DebitAcctNo>
            Y.MONTO.DEBIT  = REC.FT.HIS<FT.Contract.FundsTransfer.DebitAmount>

            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo, Y.CUENTA.DEBIT)
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAmount, Y.MONTO.DEBIT)

            EB.Display.RebuildScreen()
        END
    END ELSE
        Y.CUENTA.DEBIT = REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>
        Y.MONTO.DEBIT  = REC.FT<FT.Contract.FundsTransfer.DebitAmount>

        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo, Y.CUENTA.DEBIT)
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAmount,Y.MONTO.DEBIT)
        EB.Display.RebuildScreen()
    END

    RETURN
END
