* @ValidationCode : MjotMTgzMjk4ODkwOTpDcDEyNTI6MTc1OTQyOTc3MDEzNjplbnpvY29yaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Oct 2025 15:29:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : enzocorio
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcBi
*-----------------------------------------------------------------------------
SUBROUTINE ABC.V.BANCA.INT.VAL.ACCT
*-----------------------------------------------------------------------------
* Descripcion : Rutina para validar las cuentas de operacion provenientes
*               Banca por Internet
*------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING AbcTable
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.Display

    Y.CUST.CR.ACCT = ''
    Y.CUST.DB.ACCT = ''
    CTA.EXT.TRANSF.POS = ''
    Y.CLABE = ''
    Y.BANCA.REC = ''
    Y.CTA.DES.REC = ''
    Y.BANCO.PROPIO = ''
    R.VPM.PARAMETROS.BANXICO = ''
    YF.ERROR = ''

    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER',"CTA.EXT.TRANSF",CTA.EXT.TRANSF.POS)

    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.CLABE = Y.LOCAL.REF<1,CTA.EXT.TRANSF.POS>

    FN.ABC.CUENTAS.DESTINO = 'F.ABC.CUENTAS.DESTINO'
    F.ABC.CUENTAS.DESTINO = ''
    EB.DataAccess.Opf(FN.ABC.CUENTAS.DESTINO, F.ABC.CUENTAS.DESTINO)

    R.VPM.PARAMETROS.BANXICO = ''

    FN.ABC.PARAMETROS.BANXICO = 'F.ABC.PARAMETROS.BANXICO'
    F.ABC.PARAMETROS.BANXICO = ''
    EB.DataAccess.Opf(FN.ABC.PARAMETROS.BANXICO,F.ABC.PARAMETROS.BANXICO)
    
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT     = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)


    EB.DataAccess.FRead(FN.ABC.PARAMETROS.BANXICO, "SYSTEM", R.ABC.PARAMETROS.BANXICO, F.ABC.PARAMETROS.BANXICO, YF.ERROR)

    IF NOT(R.ABC.PARAMETROS.BANXICO) THEN
        Y.BANCO.PROPIO = "000"
    END ELSE
        Y.BANCO.PROPIO = R.ABC.PARAMETROS.BANXICO<AbcTable.AbcParametrosBanxico.BanxicoNumBanco>
    END

    Y.DEBIT.ACCT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    EB.DataAccess.FRead(FN.ACCOUNT, Y.DEBIT.ACCT, REC.CUENTA, F.ACCOUNT, Y.ACCT.ERR)
    Y.CUST.DB.ACCT = REC.CUENTA<AC.AccountOpening.Account.Customer>

    IF Y.CUST.DB.ACCT EQ '' THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)
        EB.SystemTables.setE("LA CUENTA DE CARGO NO EXISTE")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    PGM.VERSION = EB.SystemTables.getPgmVersion()
    IF Y.CLABE EQ '' THEN
        IF PGM.VERSION EQ ',BI.PAGO.TC' THEN
            Y.CREDIT.ACCT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditTheirRef)
            IF Y.CREDIT.ACCT EQ '' OR (Y.CREDIT.ACCT NE '' AND LEN(Y.CREDIT.ACCT) NE 16) OR (Y.CREDIT.ACCT NE '' AND NOT(ISDIGIT(Y.CREDIT.ACCT))) THEN
                EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditTheirRef)
                EB.SystemTables.setE("TARJETA DE CREDITO NO VALIDA")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END ELSE
                Y.ID.DES.REC = Y.CUST.DB.ACCT:'.':Y.CREDIT.ACCT
                EB.DataAccess.FRead(FN.ABC.CUENTAS.DESTINO, Y.ID.DES.REC, Y.CTA.DES.REC, F.ABC.CUENTAS.DESTINO, ER.CUENTAS.DESTINO)
                IF Y.CTA.DES.REC NE "" THEN
                    IF Y.CTA.DES.REC<AbcTable.AbcCuentasDestino.TipoCta> NE 'TARJETA DE CREDITO' THEN
                        EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditTheirRef)
                        EB.SystemTables.setE("LA CUENTA SELECCIONADA NO ES UNA TARJETA DE CREDITO")
                        EB.ErrorProcessing.StoreEndError()
                        RETURN
                    END
                END ELSE
                    EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditTheirRef)
                    EB.SystemTables.setE("TARJETA DE CREDITO DESTINO NO REGISTRADA")
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            END
        END ELSE

            Y.CREDIT.ACCT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
            Y.SAVE.ACCT = Y.CREDIT.ACCT

            EB.DataAccess.FRead(FN.ACCOUNT, Y.CREDIT.ACCT, REC.CUENTA, F.ACCOUNT, Y.ACCT.ERR)
            Y.CUST.CR.ACCT = REC.CUENTA<AC.AccountOpening.Account.Customer>

            IF Y.CUST.CR.ACCT EQ '' THEN
                EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo)
                EB.SystemTables.setE("LA CUENTA DE ABONO NO EXISTE")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END

            Y.PAYMENT.DETAILS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)
            IF Y.PAYMENT.DETAILS NE '' THEN
                IF LEN(Y.PAYMENT.DETAILS) EQ 10 THEN
                    Y.CREDIT.ACCT = Y.BANCO.PROPIO:Y.PAYMENT.DETAILS
                END ELSE
                    IF LEN(Y.PAYMENT.DETAILS) EQ 16 THEN
                        Y.CREDIT.ACCT = Y.PAYMENT.DETAILS
                    END
                END
            END

            IF Y.CUST.DB.ACCT NE Y.CUST.CR.ACCT THEN
                Y.ID.CTAS.DEST = Y.CUST.DB.ACCT:'.':Y.CREDIT.ACCT
                EB.DataAccess.FRead(FN.ABC.CUENTAS.DESTINO, Y.ID.CTAS.DEST, Y.CTA.DES.REC, F.ABC.CUENTAS.DESTINO, ER.CUENTAS.DESTINO)
                IF Y.CTA.DES.REC EQ '' THEN
                    EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo)
                    EB.SystemTables.setE("CUENTA TERCERO DESTINO NO REGISTRADA")
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            END

            Y.CREDIT.ACCT = Y.SAVE.ACCT
        END
    END ELSE
    
        Y.CREDIT.ACCT = Y.CLABE
        Y.ID.DES.REC = Y.CUST.DB.ACCT:'.':Y.CREDIT.ACCT
        EB.DataAccess.FRead(FN.ABC.CUENTAS.DESTINO, Y.ID.DES.REC, Y.CTA.DES.REC, F.ABC.CUENTAS.DESTINO, ER.CUENTAS.DESTINO)
        IF Y.CTA.DES.REC EQ '' THEN

            EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
            EB.SystemTables.setAv(CTA.EXT.TRANSF.POS)
            IF LEN(Y.CREDIT.ACCT) EQ 10 THEN
                EB.SystemTables.setE("CELULAR DESTINO NO REGISTRADO")
            END ELSE
                EB.SystemTables.setE("CUENTA CLABE DESTINO NO REGISTRADA")
            END
            EB.ErrorProcessing.StoreEndError()
            RETURN

        END
    END

    EB.Display.RebuildScreen()
    
RETURN
END
