* @ValidationCode : MjotMTk4MTI5OTAzMjpDcDEyNTI6MTc1NjkwODMzODk2OTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Sep 2025 11:05:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-29</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.2BR.V.CCY.TELLER.SBC

*-----------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING EB.Display
    $USING AC.AccountOpening
    $USING TT.Contract
    $USING AbcTable

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
********
PROCESS:
********

    IF EB.SystemTables.getMessage() NE 'VAL' THEN
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(TT.Contract.Teller.TeCurrencyOne, tmp)
        RETURN
    END

    YTXN.CDE = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)
    YTXN.CDE = YTXN.CDE[1,6]
    IF NOT(EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)) AND EB.SystemTables.getMessage() EQ 'VAL' THEN
        TEXT = "DEBE INGRESAR EL IMPORTE"
        EB.Display.Rem();
*        CALL TRANSACTION.ABORT
        EB.SystemTables.setMessage("RET")
        RETURN
    END

    IF (YACCOUNT.CCY NE EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)) AND (YTXN.CDE NE "MASTER") THEN
        ETEXT = "Moneda cta y cheque diferentes"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    IF EB.SystemTables.getComi() EQ "MXN" THEN
        EB.SystemTables.setRNew(TT.Contract.Teller.TeTransactionCode,YTXN.MXN)
    END ELSE
        EB.SystemTables.setRNew(TT.Contract.Teller.TeCurrMarketOne,"1")
    END
    tmp<3>="NOINPUT"
    EB.SystemTables.setT(TT.Contract.Teller.TeCurrencyOne, tmp)
    EB.SystemTables.setT(TT.Contract.Teller.TeCurrencyTwo, tmp)

*    CALL REBUILD.SCREEN

RETURN
***********
INITIALISE:
***********

    FN.ABC.PARAMETROS.BANXICO  = "F.ABC.PARAMETROS.BANXICO "
    F.ABC.PARAMETROS.BANXICO   = ""
    EB.DataAccess.Opf(FN.ABC.PARAMETROS.BANXICO ,F.ABC.PARAMETROS.BANXICO )

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT   = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    YREC.ABC.PARAMETROS.BANXICO  = ""
    YF.ERR = ""
    EB.DataAccess.FRead(FN.ABC.PARAMETROS.BANXICO , "SYSTEM", YREC.ABC.PARAMETROS.BANXICO , F.ABC.PARAMETROS.BANXICO , YF.ERR)

    IF YREC.ABC.PARAMETROS.BANXICO  EQ "" THEN
        ETEXT = "Error al leer parametros banxico"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        YTXN.MXN = YREC.ABC.PARAMETROS.BANXICO<AbcTable.AbcParametrosBanxico.TtTxnDepMxn>
        YTXN.USD = YREC.ABC.PARAMETROS.BANXICO<AbcTable.AbcParametrosBanxico.TtTxnDepUsd>
    END

    YREC.ACCOUNT = ""
    YF.ERR = ""

    YACCOUNT = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
    EB.DataAccess.FRead(FN.ACCOUNT, YACCOUNT, YREC.ACCOUNT, F.ACCOUNT, YF.ERR)

    YACCOUNT.CCY = YREC.ACCOUNT<AC.AccountOpening.Account.Currency>

RETURN
**********
END




