$PACKAGE AbcSpei
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.VAL.DAT.BEN.PRN
*-----------------------------------------------------------------------------
	$USING EB.SystemTables
	$USING EB.Updates
    $USING FT.Contract
    $USING EB.ErrorProcessing

	Y.NOMBRE.APP = "FUNDS.TRANSFER"
    Y.NOMBRE.CAMPO = "TIPO.CTA.BEN" : @VM : "RFC.BENEF.SPEI"

	EB.Updates.MultiGetLocRef(Y.NOMBRE.APP,Y.NOMBRE.CAMPO,R.POS.CAMPO)
	Y.POS.TIPO.CTA.BEN = R.POS.CAMPO<1,1>
	Y.POS.RFC.BEN = R.POS.CAMPO<1,2>

    Y.LOCAL.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.RFC.BENEF.SPEI = Y.LOCAL.FT<1,Y.POS.RFC.BEN>
    Y.TIPO.CTA.BEN = Y.LOCAL.FT<1,Y.POS.TIPO.CTA.BEN>
    Y.PAYMENT.DETAILS= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)

    IF Y.PAYMENT.DETAILS EQ '' THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.PaymentDetails)
        ETEXT = "NO EXISTE INFORMACION SOBRE EL NOMBRE DEL BENEFICIARIO"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
        IF Y.RFC.BENEF.SPEI EQ '' THEN
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
            EB.SystemTables.setAv(Y.POS.RFC.BEN)
            ETEXT = "NO EXISTE INFORMACION SOBRE EL RFC DEL BENEFICIARIO"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END ELSE
            IF Y.TIPO.CTA.BEN EQ '' THEN
                EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
                EB.SystemTables.setAv(Y.POS.TIPO.CTA.BEN)
                ETEXT = "NO EXISTE INFORMACION SOBRE EL TIPO DE CUENTA DEL BENEFICIARIO"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END
        END
    END

    RETURN

END
