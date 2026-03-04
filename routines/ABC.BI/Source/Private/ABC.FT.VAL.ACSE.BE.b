$PACKAGE AbcBi
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING FT.Contract
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.FT.VAL.ACSE.BE
*=============================================================================
*       Descripcion: Rutina que valida el Transaction Type igual a ACSE
*                    de los Registros de la tabla F.FUNDS.TRANSFER
*                    de BANCA EMPRESARIAL
*=============================================================================

    GOSUB INICIA
    GOSUB OPEN.FILES
    GOSUB PROCESS

    RETURN

*------
INICIA:
*------

    Y.ID.FT = EB.SystemTables.getIdNew()

    RETURN

*----------
OPEN.FILES:
*----------

    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER$NAU"
    F.FUNDS.TRANSFER  = ""
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER", "CANAL", YPOS.CANAL)

    RETURN

*-------
PROCESS:
*-------

    EB.DataAccess.FRead(FN.FUNDS.TRANSFER,Y.ID.FT,R.REG.FT,F.FUNDS.TRANSFER,ERR.FT)
    Y.TRAN.TYPE = R.REG.FT<FT.Contract.FundsTransfer.TransactionType>
    Y.CANAL.BE  = R.REG.FT<FT.Contract.FundsTransfer.LocalRef, YPOS.CANAL>

    IF Y.TRAN.TYPE EQ 'ACSE' AND Y.CANAL.BE EQ 2 THEN
        AbcBi.AbcBamSpeiTxnOutgoing()
    END

    RETURN

END
