*------------------------------------------------------------------------
* <Rating>-1</Rating>
*------------------------------------------------------------------------
*========================================================================
$PACKAGE AbcSpei
    SUBROUTINE ABC.VALIDA.CTA.POST.REST
*========================================================================
*   Creado por  : 
*   Fecha       : 
*   Descripcion : No Permite Retirar de las cuentas si estan Embargadas.
*
*========================================================================
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.LocalReferences
    $USING AA.Framework
    $USING EB.Updates
    $USING  EB.Interface
    $USING FT.Contract
*************************************************************************

* Valida que la cuenta no este embargada.
    AbcSpei.abcUpdateDcAccEnri()
    Y.ID.ACCT = EB.SystemTables.getComi()
    AbcSpei.AbcValPostRest(Y.ID.ACCT)


    RETURN
END
