*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------

    SUBROUTINE ABC.2BR.VALIDA.REFERENCIA

*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING TT.Contract
    $USING EB.Display
    $USING EB.ErrorProcessing
***
* VER DE DONDE SALE LA VARIA ARREGLO.AVIABLE
    ARREGLO.AVIABLE = "ARREGLO.AVIABLE"
    LINK.DATA = ARREGLO.AVIABLE

****
    MESSAGE = EB.SystemTables.getMessage()
    IF MESSAGE NE 'VAL' THEN
        Y.BANCO.REF = EB.SystemTables.getComi()
        Y.BANCO.REF.AUT = LINK.DATA<7>
        IF Y.BANCO.REF NE Y.BANCO.REF.AUT THEN
            TEXT = "REFERENCIA NO CORRESPONDE CON SOLICITUD"
            EB.Display.Rem();
            ETEXT = TEXT
            EB.ErrorProcessing.StoreEndError()
        END
    END
    EB.Display.RebuildScreen()

    RETURN
**********
END



