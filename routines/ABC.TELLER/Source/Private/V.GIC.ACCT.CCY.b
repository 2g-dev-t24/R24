* @ValidationCode : MjotOTI0Njk2NTA3OkNwMTI1MjoxNzY3NjcwNDYxMTQ5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Jan 2026 00:34:21
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

$PACKAGE AbcTeller

SUBROUTINE V.GIC.ACCT.CCY
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing

    $USING TT.Contract
    $USING AbcSpei
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    APP.NAME<1>     = "TELLER"
    FIELD.NAME<1>   = "CLEARED.BAL": @VM :"DRAW.CUST.NAME"
    
    FIELD.POS = ""
    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    Y.CBAL.POS     = FIELD.POS<1,1>
    Y.DCNAME.POS   = FIELD.POS<1,2>
    
    TT.LOCAL.REF    = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
* Valida que la cuenta no este embargada.
    Y.ID.ACCT = EB.SystemTables.getComi()
    AbcSpei.AbcValPostRest(Y.ID.ACCT)
    MESSAGE = EB.SystemTables.getMessage()

    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END
    
    YR.ACCOUNT = EB.SystemTables.getComi()

    REC.CUENTA = AC.AccountOpening.Account.Read(YR.ACCOUNT, Y.ACCT.ERR)
    
    Y.LIMIT.REF = REC.CUENTA<AC.AccountOpening.Account.LimitRef>
    Y.CATEGORY = REC.CUENTA<AC.AccountOpening.Account.Category>
    Y.CUSTOMER = REC.CUENTA<AC.AccountOpening.Account.Customer>

    IF (Y.LIMIT.REF EQ 'NOSTRO') OR (Y.CATEGORY EQ 3000) THEN
        E = "CUENTA NO PERMITIDA"
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.Err()
        EB.SystemTables.setComi('')
    END ELSE
        YR.CCY = REC.CUENTA<AC.AccountOpening.Account.Currency>
        YR.BAL = REC.CUENTA<AC.AccountOpening.Account.OnlineClearedBal>

        EB.SystemTables.setRNew(TT.Contract.Teller.TeCurrencyTwo,YR.CCY)
        TT.LOCAL.REF<1,Y.CBAL.POS> = YR.BAL
        
        EB.SystemTables.setRNew(TT.Contract.Teller.TeAmountLocalOne,"")
        MSG = EB.SystemTables.getMessage()
        AbcSpei.abcVCustomerName(Y.CUSTOMER, Y.NOMBRE,MSG)

        TT.LOCAL.REF<1,Y.DCNAME.POS> = Y.NOMBRE
        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,TT.LOCAL.REF)
    END

    EB.Display.RebuildScreen()
    
RETURN
*-----------------------------------------------------------------------------
END