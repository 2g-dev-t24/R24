*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------

    SUBROUTINE ABC.LIMPIA.TABLA.TMP

*-----------------------------------------------------------------------------


    $USING AbcTable
    $USING EB.SystemTables
    
    MESSAGE = EB.SystemTables.getMessage()
    IF MESSAGE NE 'VAL' THEN
* Elimino el registro de la tabla temporal.
        EXECUTE "CLEAR.FILE F.ABC.TMP.LECTORA.CHQ$NAU"
        EXECUTE "CLEAR.FILE F.ABC.TMP.LECTORA.CHQ$HIS"
        EXECUTE "DELETE F.ABC.TMP.LECTORA.CHQ SYSTEM"
    END

    RETURN
**********
END



