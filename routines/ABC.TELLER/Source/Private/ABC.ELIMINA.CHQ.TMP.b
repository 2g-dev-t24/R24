$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.ELIMINA.CHQ.TMP
*===============================================================================
* Nombre de Programa : ABC.ELIMINA.CHQ.TMP
* Objetivo           : Rutina que elimina los registros de la tabla ABC.TMP.LECTORA.CHQ despues de que los datos ya fueron procesados
*===============================================================================

    GOSUB PROCESS
    RETURN

PROCESS:
    EXECUTE "CLEAR.FILE F.ABC.TMP.LECTORA.CHQ$NAU"
    EXECUTE "CLEAR.FILE F.ABC.TMP.LECTORA.CHQ$HIS"
    EXECUTE "CLEAR.FILE F.ABC.TMP.LECTORA.CHQ WITH @ID LIKE 'CHQ...'"
    RETURN

END
