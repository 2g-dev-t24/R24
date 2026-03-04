$PACKAGE AbcTarjetaMc
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.VAL.POST.REST.CUS
*======================================================================================
* Nombre de Programa : ABC.VAL.POST.REST.CUS
* Objetivo           : Rutina que valida que el cliente de la cuenta no tenga
*                      restricciones.
*======================================================================================
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING ST.Customer
    $USING AC.Config
    $USING AbcTable

    Y.FUNCTION = EB.SystemTables.getVFunction()
    IF Y.FUNCTION EQ 'I' THEN
        GOSUB INICIALIZA
        GOSUB VALIDA.BLOQUEO
    END

    RETURN

***********
INICIALIZA:
***********

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
    FN.POSTING.RESTRICT = "F.POSTING.RESTRICT"
    F.POSTING.RESTRICT = ""
    EB.DataAccess.Opf(FN.POSTING.RESTRICT,F.POSTING.RESTRICT)

    Y.CLIENTE = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Customer)

    RETURN

***************
VALIDA.BLOQUEO:
***************
    EB.DataAccess.FRead(FN.CUSTOMER, Y.CLIENTE, R.CLIENTE, F.CUSTOMER, Y.ERR.CUS)

    IF R.CLIENTE THEN
        Y.POSTING.RESTRICT=R.CLIENTE<ST.Customer.Customer.EbCusPostingRestrict>
        EB.DataAccess.FRead(FN.POSTING.RESTRICT,Y.POSTING.RESTRICT,R.PR,F.POSTING.RESTRICT,YERR.PR)
        Y.DESCRIP.BLOQ = R.PR<AC.Config.PostingRestrict.PosDescription>
        IF Y.POSTING.RESTRICT NE "" THEN
            EB.SystemTables.setAf(AbcTable.AbcAcctLclFlds.Customer)
            ETEXT = "El cliente de la cuenta se encuentra bloqueado: ":Y.DESCRIP.BLOQ
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

    RETURN

END
