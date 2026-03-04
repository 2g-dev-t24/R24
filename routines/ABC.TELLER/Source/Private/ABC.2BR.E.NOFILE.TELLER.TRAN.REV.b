* @ValidationCode : MjoxMDQ1MzU4NDkwOkNwMTI1MjoxNzY2NDE1MDQyMjc5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Dec 2025 11:50:42
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
*
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
SUBROUTINE ABC.2BR.E.NOFILE.TELLER.TRAN.REV(R.DATA)
*
* ------------------------------------------------------------
    $USING TT.Contract
    $USING ST.Config
    $USING FT.Contract
    $USING LD.Contract
    $USING FT.Config
    $USING EB.DataAccess
    $USING EB.Reports
    $USING TT.Config
************************************************
    GOSUB INITIALIZE

    GOSUB PROCESS

RETURN
************************************************
*----------
INITIALIZE:
*----------

    R.DATA = ''
    YT.REC = ""
    TELLER.ID = ""

    TELLER.FILE = "F.TELLER$HIS"
    F.TELLER = ""
    EB.DataAccess.Opf(TELLER.FILE, F.TELLER)

    FN.TELLER.ID = 'F.TELLER.ID'
    FV.TELLER.ID = ''
    EB.DataAccess.Opf(FN.TELLER.ID,FV.TELLER.ID)


    FN.LD.LOANS.AND.DEPOSITS = 'F.LD.LOANS.AND.DEPOSITS'
    FV.LD.LOANS.AND.DEPOSITS = ''
    EB.DataAccess.Opf(FN.LD.LOANS.AND.DEPOSITS,FV.LD.LOANS.AND.DEPOSITS)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER$HIS'
    FV.FUNDS.TRANSFER = ''
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER,FV.FUNDS.TRANSFER)

    TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
    F.TELLER.TRANSACTION = ""
    EB.DataAccess.Opf(TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FT.TXN.TYPE.CONDITION = "F.FT.TXN.TYPE.CONDITION"
    F.FT.TXN.TYPE.CONDITION = ""
    EB.DataAccess.Opf(FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    YR.TEL.ID = "" ; YR.TEL.REC = ""
    YR.REC  = '' ; R.DATA = ''

RETURN
************************************************
*-------
PROCESS:
*-------
    D.FIELDS              = EB.Reports.getDFields()
    D.RANGE.AND.VALUE     = EB.Reports.getDRangeAndValue()

    TELLER.ID = ''
    LOCATE "TELLER.ID" IN D.FIELDS<1> SETTING POSITION THEN
        TELLER.ID = D.RANGE.AND.VALUE<POSITION>
    END

    TELLER.ID = STR("0",4-LEN(TELLER.ID)):TELLER.ID
    Y.USER.ID = ''

    EB.DataAccess.FRead(FN.TELLER.ID,TELLER.ID,R.TT.TID,FV.TELLER.ID,ERR.APLI)
    Y.USER.ID= R.TT.TID<TT.Contract.TellerId.TidUser>

    SELECT.STM = "SELECT " : TELLER.FILE : " BY TRANSACTION.CODE BY DATE.TIME"

    IF (TELLER.ID NE "") AND (TELLER.ID NE "ALL") THEN
        SELECT.STM := " WITH (TELLER.ID.1 EQ " : DQUOTE(TELLER.ID)  ; * ITSS - NYADAV - Added DQUOTE
        SELECT.STM := " OR WITH TELLER.ID.2 EQ ": DQUOTE(TELLER.ID):")"   ; * ITSS - NYADAV - Added DQUOTE
        SELECT.STM := " AND RECORD.STATUS EQ 'REVE' AND VALUE.DATE.1 EQ ":DQUOTE(TODAY)   ; * ITSS - NYADAV - Added DQUOTE
    END


    TEL.ID.LIST = '' ; TEL.NO.SELECTED = ''
    EB.DataAccess.Readlist(SELECT.STM,TEL.ID.LIST,'',TEL.NO.SELECTED,'')


    IF Y.USER.ID EQ '' THEN RETURN
    TR.ID.LIST = ''
    TR.ID.LIST = TEL.ID.LIST
    SEL.STM = 'SELECT ' :FN.FUNDS.TRANSFER :' WITH INPUTTER LIKE ':DQUOTE('...':SQUOTE(Y.USER.ID)):' AND WITH VALUE.DATE EQ ':DQUOTE(TODAY) : ' BY DATE.TIME'   ; * ITSS - NYADAV - Added DQUOTE / SQUOTE
    LD.ID.LIST = '' ; LD.NO.SELECTED = ''

    IF LD.ID.LIST THEN
        IF TR.ID.LIST EQ '' THEN
            TR.ID.LIST = LD.ID.LIST
        END ELSE
            TR.ID.LIST := FM:LD.ID.LIST
        END
    END

    SEL.STM = 'SELECT ' :FN.FUNDS.TRANSFER :' WITH INPUTTER LIKE ':DQUOTE('...':SQUOTE(Y.USER.ID):'...'):' AND RECORD.STATUS EQ "REVE" AND DEBIT.VALUE.DATE EQ ':DQUOTE(TODAY):' BY TRANSACTION.TYPE BY DATE.TIME'  ; * ITSS - NYADAV - Added DQUOTE

    FT.ID.LIST = '' ; FT.NO.SELECTED = ''
    EB.DataAccess.Readlist(SEL.STM,FT.ID.LIST,'',FT.NO.SELECTED,'')
    IF FT.ID.LIST THEN
        IF TR.ID.LIST EQ '' THEN
            TR.ID.LIST = FT.ID.LIST
        END ELSE
            TR.ID.LIST := FM:FT.ID.LIST
        END
    END

    IF TR.ID.LIST THEN
        LOOP
            REMOVE YR.TR.ID FROM TR.ID.LIST SETTING GO.ON
            YR.REC = ''
            BEGIN CASE
                CASE YR.TR.ID[1,2] EQ 'TT'
                    GOSUB READ.TELLER.FILE
                    GOSUB FORMAT.DETAILS
                CASE YR.TR.ID[1,2] EQ 'LD'
                    GOSUB READ.LD.FILE
                CASE YR.TR.ID[1,2] EQ 'FT'
                    GOSUB READ.FT.FILE
            END CASE
            IF R.DATA = '' THEN
                R.DATA = YR.REC
            END ELSE
                R.DATA := FM:YR.REC
            END
        UNTIL NOT (GO.ON)
        REPEAT
    END

RETURN
***********************************************
*--------------
FORMAT.DETAILS:
*--------------
    YR.REC = ''
    TWO.TRAN = "N"
    YR.AMOUNT = YR.TEL.REC<TT.Contract.Teller.TeAmountLocalOne>
    YR.TRAN.CODE = YR.TEL.REC<TT.Contract.Teller.TeTransactionCode>
    YR.TRAN.DESC = ''

    EB.DataAccess.FRead(TELLER.TRANSACTION,YR.TRAN.CODE,R.TT.TR,F.TELLER.TRANSACTION,ERR.APLI)
    YR.TRAN.DESC = R.TT.TR<TT.Config.TellerTransaction.TrShortDesc>

    YR.CCY = YR.TEL.REC<TT.Contract.Teller.TeCurrencyOne>
    TELLER.TIME1 = YR.TEL.REC<TT.Contract.Teller.TeDateTime>
    TELLER.TIME2 = TELLER.TIME1[7,2]
    TELLER.TIME3 = TELLER.TIME1[9,2]
    TELLER.TIME = TELLER.TIME2 : ":" : TELLER.TIME3
    REFERENCE = YR.TEL.REC<TT.Contract.Teller.TeChequeNumber>
    COD.TRANS = YR.TRAN.CODE

    IF REFERENCE EQ "" THEN
        REFERENCE = "00000"
    END

    IF YR.TEL.REC<TT.Contract.Teller.TeDrCrMarker> = "DEBIT" THEN
        IF YR.TEL.REC<TT.Contract.Teller.TeAccountOne> THEN
            IF YR.TEL.REC<TT.Contract.Teller.TeAccountTwo> THEN
                YR.DR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountOne>
                YR.CR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountTwo>
                TWO.TRAN = "Y"
            END ELSE
                YR.DR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountOne>
                YR.CR.ACCT = ""
            END
        END ELSE
            IF YR.TEL.REC<TT.Contract.Teller.TeAccountTwo> THEN
                YR.DR.ACCT = ""
                YR.CR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountTwo>
            END ELSE
                YR.DR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountTwo>
                YR.CR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountOne>
                TWO.TRAN = "Y"
            END
        END
    END ELSE
        IF YR.TEL.REC<TT.Contract.Teller.TeAccountOne> THEN
            IF YR.TEL.REC<TT.Contract.Teller.TeAccountTwo> THEN
                YR.DR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountTwo>
                YR.CR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountOne>
                TWO.TRAN = "Y"
            END ELSE
                YR.DR.ACCT = ""
                YR.CR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountOne>
            END
        END ELSE
            IF YR.TEL.REC<TT.Contract.Teller.TeAccountTwo> THEN
                YR.DR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountTwo>
                YR.CR.ACCT = ""
            END ELSE
                YR.DR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountOne>
                YR.CR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountTwo>
                TWO.TRAN = "Y"
            END
        END
    END

    IF TWO.TRAN EQ "Y" THEN
        YR.REC = TELLER.ID:"*":YR.TRAN.DESC:"*":YR.DR.ACCT:"*":YR.CR.ACCT:"*":YR.AMOUNT:"*":YR.CCY:"*":YR.TR.ID:"*":TELLER.TIME:"*":REFERENCE:"*":COD.TRANS
    END ELSE
        IF YR.DR.ACCT = "" THEN
            YR.REC = TELLER.ID:"*":YR.TRAN.DESC:"*":YR.DR.ACCT:"*":YR.CR.ACCT:"*":YR.AMOUNT:"*":YR.CCY:"*":YR.TR.ID:"*":TELLER.TIME:"*":REFERENCE:"*":COD.TRANS
        END ELSE
            YR.REC = TELLER.ID:"*":YR.TRAN.DESC:"*":YR.DR.ACCT:"*":YR.CR.ACCT:"*":YR.AMOUNT:"*":YR.CCY:"*":YR.TR.ID:"*":TELLER.TIME:"*":REFERENCE:"*":COD.TRANS
        END
    END

RETURN
***********************************************
*----------------
READ.TELLER.FILE:
*----------------

    ER = ''
    EB.DataAccess.FRead(TELLER.FILE,YR.TR.ID,YR.TEL.REC,F.TELLER,ER)

RETURN
************************************************
*----------------
READ.FT.FILE:
*----------------

    ER = ''
    EB.DataAccess.FRead(FN.FUNDS.TRANSFER ,YR.TR.ID,YR.FT.REC,FV.FUNDS.TRANSFER ,ER)

    YR.REC = ''
    TWO.TRAN = "N"
    YR.DR.CCY = YR.FT.REC<FT.Contract.FundsTransfer.DebitCurrency>
    YR.CR.CCY = YR.FT.REC<FT.Contract.FundsTransfer.CreditCurrency>
    YR.DR.AMOUNT = YR.FT.REC<FT.Contract.FundsTransfer.DebitAmount>

    Y.TXN.TYPE = YR.FT.REC<FT.Contract.FundsTransfer.TransactionType>
    EB.DataAccess.Dbr("FT.TXN.TYPE.CONDITION":FM:FT6.DESCRIPTION,Y.TXN.TYPE,YR.DR.TRAN.CODE)
    COD.TRANS = Y.TXN.TYPE

    FT.TIME1 = YR.FT.REC<FT.Contract.FundsTransfer.DateTime>
    FT.TIME2 = FT.TIME1[7,2]
    FT.TIME3 = FT.TIME1[9,2]
    FT.TIME = FT.TIME2 : ":" : FT.TIME3
    REFERENCE = ''
    IF REFERENCE EQ "" THEN
        REFERENCE = "00000"
    END
    YR.DR.ACCT = YR.FT.REC<FT.Contract.FundsTransfer.DebitAcctNo>
    YR.CR.ACCT = YR.FT.REC<FT.Contract.FundsTransfer.CreditAcctNo>
    YR.CR.AMOUNT = YR.FT.REC<FT.Contract.FundsTransfer.CreditAmount>
    IF YR.CR.AMOUNT EQ '' THEN
        YR.CR.AMOUNT = YR.DR.AMOUNT
    END
    TWO.TRAN = "Y"
    IF TWO.TRAN EQ "Y" THEN
        YR.REC = TELLER.ID:"*":YR.DR.TRAN.CODE:"*":YR.DR.ACCT:"*":YR.CR.ACCT:"*":YR.CR.AMOUNT:"*":YR.DR.CCY:"*":YR.TR.ID:"*":FT.TIME:"*":REFERENCE:"*":COD.TRANS
    END

RETURN
************************************************

*----------------
READ.LD.FILE:
*----------------

    ER = ''
    EB.DataAccess.FRead(FN.LD.LOANS.AND.DEPOSITS ,YR.TR.ID,YR.LD.REC,FV.LD.LOANS.AND.DEPOSITS ,ER)

    YR.REC = ''
    TWO.TRAN = "N"

    YR.CCY = YR.LD.REC<LD.Contract.LoansAndDeposits.Currency>
    YR.CAT = YR.LD.REC<LD.Contract.LoansAndDeposits.Category>
    EB.DataAccess.CacheRead("F.CATEGORY", YR.CAT, R.CAT, ERR.APLI)  ; * ITSS - NYADAV
    IF YR.CAT LE 21049 THEN
        YR.DR.AMOUNT = YR.LD.REC<LD.Contract.LoansAndDeposits.Amount>
        YR.CR.AMOUNT = YR.LD.REC<LD.Contract.LoansAndDeposits.Amount>
        YR.TRAN.CODE= R.CAT<ST.Config.Category.EbCatShortName>  ; * ITSS - NYADAV
        YR.DR.ACCT = YR.CAT
        YR.CR.ACCT = YR.LD.REC<LD.Contract.LoansAndDeposits.DrawdownAccount>
    END ELSE
        YR.DR.AMOUNT = YR.LD.REC<LD.Contract.LoansAndDeposits.Amount>
        YR.CR.AMOUNT = YR.LD.REC<LD.Contract.LoansAndDeposits.Amount>
        YR.TRAN.CODE = R.CAT<ST.Config.Category.EbCatShortName>  ; * ITSS - NYADAV
        YR.CR.ACCT = YR.CAT
        YR.DR.ACCT = YR.LD.REC<LD.Contract.LoansAndDeposits.DrawdownAccount>
    END


    COD.TRANS = ''

    LD.TIME1 = YR.LD.REC<LD.Contract.LoansAndDeposits.DateTime>
    LD.TIME2 = LD.TIME1[7,2]
    LD.TIME3 = LD.TIME1[9,2]
    LD.TIME = LD.TIME2 : ":" : LD.TIME3
    REFERENCE = ''
    IF REFERENCE EQ "" THEN
        REFERENCE = "00000"
    END



    TWO.TRAN = "Y"

    YR.REC = TELLER.ID:"*":YR.TRAN.CODE:"*":YR.DR.ACCT:"*":YR.CR.ACCT:"*":YR.CR.AMOUNT:"*":YR.CCY:"*":YR.TR.ID:"*":LD.TIME:"*":REFERENCE:"*":COD.TRANS


RETURN
************************************************

*
*---------------This is the Final End Statement----------------
*
END
