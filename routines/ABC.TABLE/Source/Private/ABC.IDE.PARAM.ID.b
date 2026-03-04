$PACKAGE AbcTable

SUBROUTINE ABC.IDE.PARAM.ID
*-----------------------------------------------------------------------------
* Validación de ID para ABC.IDE.PARAM
* ID debe ser: MX0010001
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.ErrorProcessing

*-----------------------------------------------------------------------------
    Y.ID.NEW = EB.SystemTables.getIdNew()
    IF Y.ID.NEW NE "MX0010001" THEN
        V.ERROR.MSG = "ID DEBE SER MX0010001"
        EB.SystemTables.setE(V.ERROR.MSG)
        EB.ErrorProcessing.Err()
        RETURN
    END

END

