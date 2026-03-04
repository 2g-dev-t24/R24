$PACKAGE AbcBi
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing

*-----------------------------------------------------------------------------

    SUBROUTINE ABC.BAN.INT.VAL.ID

    FN.BAN.INT = "F.ABC.BANCA.INTERNET"
    F.BAN.INT = ""
    EB.DataAccess.Opf(FN.BAN.INT,F.BAN.INT)

    Y.VERSION    = EB.SystemTables.getPgmVersion()
    Y.V.FUNCTION = EB.SystemTables.getVFunction()
    Y.COMI       = EB.SystemTables.getComi()


    IF Y.VERSION NE ',CTAS.TER.INTERBAN' AND Y.VERSION NE ',CTAS.TER.INTERBAN.AUT' THEN
        EB.DataAccess.FRead(FN.BAN.INT, Y.COMI, REC.BAN.INT, F.BAN.INT, BAN.INT.ERR)
        IF REC.BAN.INT EQ '' THEN
            EB.SystemTables.setE("EL CLIENTE NO TIENE CONTRATO - FAVOR DE DAR DE ALTA AL CLIENTE EN BANCA ELECTRONICA")
            EB.ErrorProcessing.StoreEndError()
        END
    END ELSE
        IF Y.VERSION EQ ',CTAS.TER.INTERBAN' OR Y.VERSION EQ ',CTAS.TER.INTERBAN.MTO.OP' THEN
            IF NOT(INDEX("ISL",Y.V.FUNCTION,1)) THEN
                EB.SystemTables.setE("LA FUNCION NO ESTA PERMITIDA")
                EB.ErrorProcessing.StoreEndError()
            END
        END ELSE
            IF NOT(INDEX("ASE",Y.V.FUNCTION,1)) THEN
                EB.SystemTables.setE("LA FUNCION NO ESTA PERMITIDA")
                EB.ErrorProcessing.StoreEndError()
            END
        END
    END
*******************************************************************************
*******************************************************************************
END
