* @ValidationCode : Mjo2ODkwMjMxNzk6Q3AxMjUyOjE3Njc2Njk0Nzk5NjM6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Jan 2026 00:17:59
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
*-----------------------------------------------------------------------

SUBROUTINE ABC.V.FT.GIC.CR.ACCT

*-----------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.Display
    $USING EB.LocalReferences

    GOSUB PROCESS

RETURN

********
PROCESS:
********
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    IF EB.SystemTables.getMessage() EQ 'VAL' THEN RETURN

    Y.ACCOUNT = EB.SystemTables.getComi()
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACCOUNT)

    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","FT.CR.CUS.NAME",FT.CR.CUS.NAME.POS)

    Y.COMI = R.ACCOUNT<AC.AccountOpening.Account.Customer>
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE,MSG)

    Y.LOCAL.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.LOCAL.FT<1,FT.CR.CUS.NAME.POS> = Y.NOMBRE
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.FT)

    EB.Display.RebuildScreen()

RETURN
**********
END




