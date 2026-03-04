$PACKAGE AbcBi
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.CTA.DES.VAL.TEL.MOV
*----------------------------------------------------------------
* Descripcion  : Rutina para validar celular en cuentas destino
*----------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AbcTable
    $USING EB.ErrorProcessing

	MESSAGE = EB.SystemTables.getMessage()
    Y.MOVIL = ''
    IF MESSAGE EQ 'VAL' THEN
        Y.EMAIL =  EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Movil)
    END ELSE
        Y.MOVIL = EB.SystemTables.getComi()
    END

    IF Y.MOVIL EQ '' THEN
        RETURN
    END

    IF NOT(ISDIGIT(Y.MOVIL)) THEN
        EB.SystemTables.setAf(AbcTable.AbcCuentasDestino.Movil)
        ETEXT='EL TELEFONO TIENE UN CARACTER'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END


END
