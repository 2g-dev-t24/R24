$PACKAGE AbcTarjetaMc
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.GUARDA.APLICA.TARJ.GAR
*======================================================================================
* Nombre de Programa : ABC.GUARDA.APLICA.TARJ.GAR
* Objetivo           : Rutina que guarda la aplicaci�n de la garant�a
*                      el proceso invocado.
*======================================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Template
    $USING FT.Contract


    Y.FUNCTION = EB.SystemTables.getVFunction()
    IF Y.FUNCTION EQ 'I' THEN
        GOSUB INICIALIZA
        GOSUB GUARDA.BLOQUEO
    END

    RETURN

***********
INICIALIZA:
***********

    FN.ACCOUNT = 'F.ACCOUNT' ; F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    FN.EB.LOOKUP = 'F.EB.LOOKUP' ; F.EB.LOOKUP = ''
    EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)

    RETURN

***************
GUARDA.BLOQUEO:
***************

    Y.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.ID.EB.LOOKUP = "ACLK*":Y.CUENTA

    EB.DataAccess.FRead(FN.EB.LOOKUP, Y.ID.EB.LOOKUP, R.EB.LOOKUP, F.EB.LOOKUP, Y.ERR)

    IF R.EB.LOOKUP THEN
        R.EB.LOOKUP<EB.Template.Lookup.LuDescription> = 'APLICADA'
        R.EB.LOOKUP<EB.Template.Lookup.LuDataValue> = EB.SystemTables.getIdNew()
        EB.DataAccess.FWrite(FN.EB.LOOKUP,Y.ID.EB.LOOKUP,R.EB.LOOKUP)
    END ELSE
        ETEXT = "NO SE PUEDE OBTENER INFORMACION DE LA GARANTIA: " :Y.ID.EB.LOOKUP
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    RETURN

END
