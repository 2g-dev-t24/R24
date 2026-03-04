* @ValidationCode : MjoxMjY4NTQ4ODIxOkNwMTI1MjoxNzU1NDQyOTA5MTQ1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Aug 2025 12:01:49
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

$PACKAGE AbcTarjetaMc
SUBROUTINE ABC.VAL.EXISTE.PRN
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INICIALIZA
    GOSUB VALIDA.PRN
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.ALT.ACCT = 'F.ALTERNATE.ACCOUNT'
    FV.ALT.ACCT  = ''
    EB.DataAccess.Opf(FN.ALT.ACCT, FV.ALT.ACCT)

    Y.PRN.MC  = ''
    R.PRN.ALT = ''

RETURN
*---------------------------------------------------------------
VALIDA.PRN:
*---------------------------------------------------------------

    Y.PRN.MC = EB.SystemTables.getRNew(AbcTable.AbcTarjetasMc.Prn)

    IF Y.PRN.MC NE '' THEN
        EB.DataAccess.FRead(FN.ALT.ACCT, Y.PRN.MC, R.PRN.ALT, FV.ALT.ACCT, Y.SUC.IP.ERR)
        IF R.PRN.ALT EQ '' THEN
            ETEXT = "PRN: " : Y.PRN.MC : " NO EXISTE"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END

RETURN




END
