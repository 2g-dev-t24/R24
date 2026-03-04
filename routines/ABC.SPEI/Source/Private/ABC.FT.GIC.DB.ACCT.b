* @ValidationCode : MjoxMzg5NzA1MzQzOkNwMTI1MjoxNzY3NjY5MTI2NTgxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Jan 2026 00:12:06
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
$PACKAGE AbcSpei
SUBROUTINE ABC.FT.GIC.DB.ACCT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING AbcSpei
    $USING EB.Display

    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getMessage() EQ 'VAL' THEN RETURN

    Y.ACCOUNT = EB.SystemTables.getComi()
    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.ACCOUNT, Y.ERR.ACCOUNT)
    IF R.ACCOUNT THEN
        Y.CUSTOMER = R.ACCOUNT<AC.AccountOpening.Account.Customer>
        Y.COMI = Y.CUSTOMER
        Y.NOMBRE = ''
        MSG = EB.SystemTables.getMessage()
        AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE,MSG)
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.OrderingCust, Y.NOMBRE)
        EB.Display.RebuildScreen()
    END
RETURN

END