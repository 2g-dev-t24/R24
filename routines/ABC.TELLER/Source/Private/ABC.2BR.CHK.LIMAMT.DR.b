* @ValidationCode : MjoxNTY1MjQyNDI0OkNwMTI1MjoxNzYzNjQ5MDc5NDg3Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Nov 2025 11:31:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
SUBROUTINE ABC.2BR.CHK.LIMAMT.DR
*--------------------------------*
* This subroutine is attached to Teller,FT versions
* as Input Routine..
* checks if trans amt>ONLINE LIMIT AMT if limi present
* for debit account and sttops the transacion if greater.
*if no limit give override messages (3) if trans amt > working
*  balance
******
    $USING AC.AccountOpening
    $USING LI.Config
    $USING FT.Contract
    $USING TT.Config
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING LI.LimitTransaction
    $USING AbcTeller
    $USING EB.ErrorProcessing
******
    GOSUB INIT
    GOSUB PROCESS
    
RETURN
******
INIT:
******
    FN.ACCOUNT = "F.ACCOUNT"
    FV.ACCOUNT = ""
    EB.DataAccess.Opf(FN.ACCOUNT,FV.ACCOUNT)
    
    FN.LIMIT = 'F.LIMIT'
    FV.LIMIT = ''
    EB.DataAccess.Opf(FN.LIMIT,FV.LIMIT)
    
    FN.TELLER = 'F.TELLER'
    FV.TELLER = ''
    EB.DataAccess.Opf(FN.TELLER,FV.TELLER)
    
    FN.TELLER.TRANS = 'F.TELLER.TRANSACTION'
    FV.TELLER.TRANS = ''
    EB.DataAccess.Opf(FN.TELLER.TRANS,FV.TELLER.TRANS)
    
    ACCOUNT.ID = ''
    ST.FLAG = ''
    Y.FLG = ''
    
RETURN
**********
PROCESS:
**********
    IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
        TRANS.AMT = EB.SystemTables.getRNew(TT.Contract.Teller.TeNetAmount)
        TRANS.CODE = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)
        TRANS.IND = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrCrMarker)
        IF TRANS.IND EQ 'CREDIT' THEN
            IF NUM(EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)) THEN
                ACCOUNT.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
                Y.CURRENCY = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyTwo)
            END
        END
        IF TRANS.IND EQ 'DEBIT' THEN
            IF NUM(EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)) THEN
                ACCOUNT.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
                Y.CURRENCY = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)
            END
        END
    END
    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
        YACCT.DR = EB.SystemTables.getRNew(FT.DEBIT.ACCT.NO)
        YACCT.CR = EB.SystemTables.getRNew(FT.CREDIT.ACCT.NO)
        READ YREC.ACCT.DR FROM FV.ACCOUNT, YACCT.DR ELSE NULL
        READ YREC.ACCT.CR FROM FV.ACCOUNT, YACCT.CR ELSE NULL
        YCCY.DR = YREC.ACCT.DR<AC.AccountOpening.Account.Currency>
        YCCY.CR = YREC.ACCT.CR<AC.AccountOpening.Account.Currency>
        IF EB.SystemTables.getRNew(FT.DEBIT.AMOUNT) THEN
            TRANS.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
        END ELSE
            TRANS.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)

            IF YCCY.DR NE YCCY.CR THEN
                YY.FLAG = '' ; TRANS.AMT.OTH = TRANS.AMT
                TRANS.AMT = ''
                LI.LimitTransaction.LimitCurrConv(YCCY.CR,TRANS.AMT.OTH,YACCT.DR,TRANS.AMT,YY.FLAG)
            END
        END
    END

    MSGTEXT = ''
    AbcTeller.Abc2brChkLimamtAcct(ACCOUNT.ID,TRANS.AMT,MSGTEXT)
    IF MSGTEXT THEN
        EB.SystemTables.setEtext(MSGTEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN
******
END

