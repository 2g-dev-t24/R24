* @ValidationCode : MjotNTg2OTIyMzA2OkNwMTI1MjoxNzY3NjY3NjAwMzk5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2026 23:46:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
*-----------------------------------------------------------------------------
$PACKAGE AbcBi
*-----------------------------------------------------------------------------
SUBROUTINE ABC.V.FT.GIC.DB.ACCT
*-----------------------------------------------------------------------
*
* This subroutine has to be Attached to the teller APPLICATION so that
* the currency will default to the accounts currency
*-----------------------------------------------------------------------------

*------------------------------------------------------------------------


    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.Display
    $USING EB.LocalReferences
    $USING AbcSpei

*------ Main Processing Section

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------
    FN.CUENTA = 'F.ACCOUNT'
    F.CUENTA = ''
    EB.DataAccess.Opf(FN.CUENTA, F.CUENTA)

    MESSAGE = EB.SystemTables.getMessage()
    IF MESSAGE EQ 'VAL' THEN RETURN

    Y.NO.CUENTA = EB.SystemTables.getComi()

*    EB.DataAccess.Dbr('ACCOUNT':@FM:AC.CUSTOMER,YR.ACCOUNT,Y.CUSTOMER)
    EB.DataAccess.FRead(FN.CUENTA,Y.NO.CUENTA,R.CUENTA,F.CUENTA,ERR.CUENTA)
    Y.CUSTOMER = R.CUENTA<AC.AccountOpening.Account.Customer>
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(Y.CUSTOMER,Y.NOM.CLIENTE,MSG)
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.OrderingCust, Y.NOM.CLIENTE)

    EB.Display.RebuildScreen()

RETURN

END
