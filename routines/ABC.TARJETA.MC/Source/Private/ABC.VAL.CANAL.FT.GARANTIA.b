$PACKAGE AbcTarjetaMc
*===============================================================================
    SUBROUTINE ABC.VAL.CANAL.FT.GARANTIA
*===============================================================================
* Nombre de Programa : ABC.VAL.CANAL.FT.GARANTIA
* Objetivo           : Rutina para validar que el canal sea 13
* Requerimiento      : Tarjetas Garantizadas
*===============================================================================

    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING FT.Contract
    $USING EB.Updates

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

    RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.CANAL.ENT = '13'
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","CANAL.ENTIDAD",Y.POS.CANAL.ENTIDAD)

    RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------
    Y.LOCALES = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.CANAL.ENT.FT = Y.LOCALES<1,Y.POS.CANAL.ENTIDAD>

    IF Y.CANAL.ENT NE Y.CANAL.ENT.FT THEN
        ETEXT = "EL CANAL REGISTRADO NO ES VALIDO: " :Y.CANAL.ENT.FT
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

    RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------
    RETURN

END
