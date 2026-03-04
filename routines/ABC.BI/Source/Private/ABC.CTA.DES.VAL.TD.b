$PACKAGE AbcBi
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.CTA.DES.VAL.TD

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING AbcTable

    FN.ET.SAP.TARJETA = 'F.ET.SAP.TARJETA'
    F.ET.SAP.TARJETA = ''
    EB.DataAccess.Opf(FN.ET.SAP.TARJETA,F.ET.SAP.TARJETA)

    FN.ET.SAP.CARD.ID = 'F.ET.SAP.CARD.ID'
    F.ET.SAP.CARD.ID = ''
    EB.DataAccess.Opf(FN.ET.SAP.CARD.ID,F.ET.SAP.CARD.ID)

    FN.ET.SAP.PRODUCTO = 'F.ET.SAP.PRODUCTO'
    F.ET.SAP.PRODUCTO = ''
    EB.DataAccess.Opf(FN.ET.SAP.PRODUCTO,F.ET.SAP.PRODUCTO)

    Y.TARJETA = EB.SystemTables.getComi()
    IF NOT(ISDIGIT(Y.TARJETA)) OR LEN(Y.TARJETA) NE 16  THEN
        EB.SystemTables.setE('CUENTA INVALIDA')
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

* Realiza un Select para traer los BINES registrados en la tabla ET.SAP.PRODUCTO
    Y.BIN.LIS = ''
    Y.BIN.CNT = ''
    Y.BIN.ERR = ''
    SEL.CMD = "SELECT " : FN.ET.SAP.PRODUCTO : " SAVING UNIQUE BIN BY BIN"
    EB.DataAccess.Readlist(SEL.CMD, Y.BIN.LIS, '', Y.BIN.CNT, Y.BIN.ERR)

    CONVERT @FM TO @VM IN Y.BIN.LIS

* Busca el BIN de la tarjeta ingresada en la lista del SELECT
    IF Y.TARJETA[1,6] MATCHES Y.BIN.LIS THEN

* Busca la tarjeta ingresada en la tabla ET.SAP.CARD.ID
        Y.ID.TMP = Y.TARJETA
        EB.DataAccess.FRead(FN.ET.SAP.CARD.ID, Y.ID.TMP, Y.TARJETA.REC, F.ET.SAP.CARD.ID, Y.ERR.ET.SAP.CARD.ID)
        IF Y.TARJETA.REC EQ '' THEN
            Y.TARJETA.ERR = 'LA TARJETA NO EXISTE'
            EB.SystemTables.setE(Y.TARJETA.ERR)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END

* Atrapa el valor del campo ID.ET.SAP de la tabla ET.SAP.CARD.ID
        Y.ID.TMP = Y.TARJETA.REC<AbcTable.EtSapCardId.Descripcion>
* Utiliza el valor del campo ID.ET.SAP como ID en la tabla ET.SAP.TARJETA
        EB.DataAccess.FRead(FN.ET.SAP.TARJETA, Y.ID.TMP, Y.TARJETA.REC, F.ET.SAP.TARJETA, Y.ERR.ET.SAP.TARJETA)
        IF Y.TARJETA.REC EQ '' THEN
            Y.TARJETA.ERR = 'LA TARJETA NO EXISTE'
            EB.SystemTables.setE(Y.TARJETA.ERR)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END

* Lee el estatus de la tarjeta y si es "ACTIVA" trae el valor de la Cuenta.
        IF Y.TARJETA.REC<AbcTable.EtSapTarjeta.EdoTarjeta> NE 'ACTIVA' THEN
            Y.TARJETA.ERR = 'LA TARJETA NO ESTA ACTIVA'
            EB.SystemTables.setE(Y.TARJETA.ERR)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END ELSE
            Y.COMI = Y.TARJETA.REC<AbcTable.EtSapTarjeta.AccountId>
            EB.SystemTables.setComi(Y.COMI)
        END

    END ELSE
        EB.SystemTables.setE('UTILICE OPERACION DE SPEI PARA TARJETAS DE OTROS BANCOS')
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    RETURN
    END
END
