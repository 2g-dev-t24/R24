* @ValidationCode : MjoxOTQ0NzE0NTk4OkNwMTI1MjoxNzY2NDE1MjA1MDM2Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Dec 2025 11:53:25
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
SUBROUTINE ABC.2BR.E.NOFILE.TELLER.CONSULTA(R.DATA)
*
* ------------------------------------------------------------
    $USING TT.Contract
    $USING ST.Config
    $USING FT.Contract
    $USING FT.Config
    $USING EB.Utility
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING EB.Reports
    $USING TT.Config
************************************************
    GOSUB INITIALIZE

    GOSUB PROCESS


RETURN
*----------
INITIALIZE:
*----------
    R.DATA = ''
    YT.REC = ""
    TELLER.ID = ""

    TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
    F.TELLER.TRANSACTION = ""
    EB.DataAccess.Opf(TELLER.TRANSACTION,F.TELLER.TRANSACTION)
    YR.TEL.TRAN.ID = "" ; YR.TEL.TRAN.REC = ""


    TELLER.FILE = "F.TELLER"
    F.TELLER = ""
    EB.DataAccess.Opf(TELLER.FILE, F.TELLER)
    FN.TELLER.ID = 'F.TELLER.ID'
    FV.TELLER.ID = ''
    EB.DataAccess.Opf(FN.TELLER.ID,FV.TELLER.ID)


    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    FV.FUNDS.TRANSFER = ''
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER,FV.FUNDS.TRANSFER)
    YR.REC  = ''

    YR.TEL.ID = "" ; YR.TEL.REC = ""


    FN.EB.LOOKUP = "F.EB.LOOKUP"
    F.EB.LOOKUP = ""
    EB.DataAccess.Opf(FN.EB.LOOKUP,F.EB.LOOKUP)

RETURN
************************************************
*-------
PROCESS:
*-------
*
    Y.LWORK.DAY= EB.SystemTables.getRDates(EB.Utility.Dates.DatLastWorkingDay)

    Y.FECHA.A.BORRAR = Y.LWORK.DAY
    EB.API.Cdt('',Y.FECHA.A.BORRAR,'-5C')
    Y.DEL.CMD = 'EDELETE ':FN.EB.LOOKUP:' WITH @ID LIKE ...*FT... AND DATE.TIME LT ...':Y.FECHA.A.BORRAR[3,6]:'9999'
    Y.ELU.LIST = '' ; Y.ELU.NO.SELECTED = ''
    EB.DataAccess.Readlist(Y.DEL.CMD,Y.ELU.LIST,'',Y.ELU.NO.SELECTED,'')

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


    SELECT.STM1 = "SELECT " : TELLER.TRANSACTION
    EB.DataAccess.Readlist(SELECT.STM1,TEL.TRAN.ID.LIST,'',TEL.TRAN.NO.SELECTED,'')
    IF TEL.TRAN.ID.LIST THEN
        LOOP
            YR.CR.ACCT = "" ; YR.DR.ACCT = ""
            REMOVE YR.TEL.TRAN.ID FROM TEL.TRAN.ID.LIST SETTING POS1

            SELECT.STM = "SELECT " : TELLER.FILE : " BY TELLER.ID.1"

            IF (TELLER.ID NE "") AND (TELLER.ID NE "ALL") AND (YR.TEL.TRAN.ID NE "") THEN
                SELECT.STM := " WITH (TELLER.ID.1 EQ " :DQUOTE(TELLER.ID)
                SELECT.STM := " OR WITH TELLER.ID.2 EQ ":DQUOTE(TELLER.ID)

                SELECT.STM := ") AND WITH TRANSACTION.CODE EQ " :DQUOTE(YR.TEL.TRAN.ID)

            END

            TEL.ID.LIST = '' ; TEL.NO.SELECTED = ''
            EB.DataAccess.Readlist(SELECT.STM,TEL.ID.LIST,'',TEL.NO.SELECTED,'')

            IF TEL.ID.LIST THEN

                LOOP
                    YR.CR.ACCT = "" ; YR.DR.ACCT = ""
                    REMOVE YR.TEL.ID FROM TEL.ID.LIST SETTING GO.ON
                    GOSUB READ.TELLER.FILE
                    GOSUB FORMAT.DETAILS
                    IF YR.AMOUNT1 = "" THEN
                        YR.AMOUNT1 = YR.AMOUNT
                    END ELSE
                        YR.AMOUNT1 = YR.AMOUNT1 + YR.AMOUNT
                    END
                UNTIL NOT (GO.ON)

                REPEAT

                IF YR.DR.ACCT = "" THEN
                    YR.REC = TELLER.ID.1:"*":YR.TRAN.DESC:"*":YR.CR.ACCT:"*":"":"*":YR.AMOUNT1:"*":YR.CCY:"*":TEL.NO.SELECTED
                END ELSE
                    YR.REC = TELLER.ID.1:"*":YR.TRAN.DESC:"*":YR.DR.ACCT:"*":YR.AMOUNT1:"*":"":"*":YR.CCY:"*":TEL.NO.SELECTED
                END

                IF R.DATA = "" THEN
                    R.DATA = YR.REC
                END ELSE
                    R.DATA<-1>= YR.REC
                END
            END
            YR.AMOUNT1 = ''
        UNTIL NOT (POS1)
        REPEAT
    END

    IF Y.USER.ID EQ '' THEN RETURN
    GOSUB PROCESS.FT


    IF YR.RECF THEN
        IF R.DATA = "" THEN
            R.DATA = YR.RECF
        END ELSE
            R.DATA<-1>= YR.RECF
        END

    END

RETURN
***********************************************
*--------------
FORMAT.DETAILS:
*--------------
*
    YR.REC = ""
    TWO.TRAN = "N"
    YR.AMOUNT = YR.TEL.REC<TT.Contract.Teller.TeAmountLocalOne>
    YR.TRAN.CODE = YR.TEL.REC<TT.Contract.Teller.TeTransactionCode>
    YR.TRAN.DESC = ''

    EB.DataAccess.FRead(TELLER.TRANSACTION,YR.TRAN.CODE,R.TT.TR,F.TELLER.TRANSACTION,ERR.APLI)
    YR.TRAN.DESC = R.TT.TR<TT.Config.TellerTransaction.TrShortDesc>

    YR.CCY = YR.TEL.REC<TT.Contract.Teller.TeCurrencyOne>
    TELLER.ID.1 = YR.TEL.REC<TT.Contract.Teller.TeTellerIdOne>

    IF YR.TEL.REC<TT.Contract.Teller.TeDrCrMarker> EQ "DEBIT" THEN
        IF YR.TEL.REC<TT.Contract.Teller.TeTellerIdOne> EQ TELLER.ID THEN
            YR.DR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountTwo>
            YR.CR.ACCT = ""
        END ELSE
            YR.DR.ACCT = ""
            YR.CR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountOne>
        END
    END ELSE
        IF YR.TEL.REC<TT.Contract.Teller.TeAccountOne> THEN
            YR.DR.ACCT = ""
            YR.CR.ACCT = YR.TEL.REC<TT.Contract.Teller.TeAccountOne>

        END
    END

RETURN
***********************************************
*----------------
READ.TELLER.FILE:
*----------------

    ER = ''
    EB.DataAccess.FRead(TELLER.FILE,YR.TEL.ID,YR.TEL.REC,F.TELLER,ER)

RETURN
************************************************
***********************************************
*----------------
PROCESS.FT:
*----------------

    YR.DR.AMOUNT = '' ; YR.RECF = ''

    SEL.STM = 'SELECT ' :FN.EB.LOOKUP :' WITH @ID LIKE ':Y.USER.ID:'...*FT... BY DESCRIPTION BY OTHER.INFO'

    FT.ID.LIST = '' ; FT.NO.SELECTED = ''
    EB.DataAccess.Readlist(SEL.STM,FT.ID.LIST,'',FT.NO.SELECTED,'')
    IF FT.ID.LIST THEN

        Y.TIPO.TXN = ""
        Y.TIPO.CCY = ""
        YR.DR.AMOUNT = 0
        Y.NUM.FTS = 0

        LOOP
            REMOVE YR.FT.ID FROM FT.ID.LIST SETTING GO.ON
        WHILE YR.FT.ID:GO.ON

            YR.FT.ID = FIELD(YR.FT.ID,'*',2)

            ER = ''
            EB.DataAccess.FRead(FN.FUNDS.TRANSFER ,YR.FT.ID,YR.FT.REC,FV.FUNDS.TRANSFER ,ER)

            IF YR.FT.REC EQ '' THEN
                CONTINUE
            END

            IF YR.FT.REC<FT.Contract.FundsTransfer.DebitAmount> THEN
                YFT.AMOUNT = YR.FT.REC<FT.Contract.FundsTransfer.DebitAmount>
            END ELSE
                YFT.AMOUNT = YR.FT.REC<FT.Contract.FundsTransfer.CreditAmount>
            END
            IF YR.FT.REC<FT.Contract.FundsTransfer.TransactionType>:YR.FT.REC<FT.Contract.FundsTransfer.DebitCurrency> NE Y.TIPO.TXN:Y.TIPO.CCY THEN
                IF Y.TIPO.TXN = "" THEN
                    YR.DR.AMOUNT += YFT.AMOUNT
                    Y.NUM.FTS += 1
                    Y.TIPO.TXN = YR.FT.REC<FT.Contract.FundsTransfer.TransactionType>
                    Y.TIPO.CCY = YR.FT.REC<FT.Contract.FundsTransfer.DebitCurrency>
                END ELSE
                    Y.TXN.TYPE = Y.TIPO.TXN
                    
                    EB.DataAccess.Dbr("FT.TXN.TYPE.CONDITION":@FM:FT6.SHORT.DESCR,Y.TXN.TYPE,YR.DR.TRAN.CODE)
                    
                    YR.DR.CCY = Y.TIPO.CCY
                    IF YR.RECF THEN
                        YR.RECF<-1>= TELLER.ID.1:"*":YR.DR.TRAN.CODE:"*":"":"*":YR.DR.AMOUNT:"*":YR.DR.AMOUNT:"*":YR.DR.CCY:"*":Y.NUM.FTS
                    END ELSE
                        YR.RECF = TELLER.ID.1:"*":YR.DR.TRAN.CODE:"*":"":"*":YR.DR.AMOUNT:"*":YR.DR.AMOUNT:"*":YR.DR.CCY:"*":Y.NUM.FTS
                    END
                    Y.TIPO.TXN = YR.FT.REC<FT.Contract.FundsTransfer.TransactionType>
                    Y.TIPO.CCY = YR.FT.REC<FT.Contract.FundsTransfer.DebitCurrency>
                    YR.DR.AMOUNT = YFT.AMOUNT
                    Y.NUM.FTS = 1
                END
            END ELSE
                YR.DR.AMOUNT += YFT.AMOUNT
                Y.NUM.FTS += 1
            END

        REPEAT
        YR.RECF = TELLER.ID.1:"*":YR.DR.TRAN.CODE:"*":"":"*":YR.DR.AMOUNT:"*":YR.DR.AMOUNT:"*":YR.DR.CCY:"*":FT.NO.SELECTED

    END

    IF Y.NUM.FTS THEN
        Y.TXN.TYPE = Y.TIPO.TXN
        EB.DataAccess.Dbr("FT.TXN.TYPE.CONDITION":@FM:FT6.SHORT.DESCR,Y.TXN.TYPE,YR.DR.TRAN.CODE)
        YR.DR.CCY = Y.TIPO.CCY
        IF YR.FT.REC THEN
            YR.RECF<-1>= TELLER.ID.1:"*":YR.DR.TRAN.CODE:"*":"":"*":YR.DR.AMOUNT:"*":YR.DR.AMOUNT:"*":YR.DR.CCY:"*":Y.NUM.FTS
        END ELSE
            YR.RECF = TELLER.ID.1:"*":YR.DR.TRAN.CODE:"*":"":"*":YR.DR.AMOUNT:"*":YR.DR.AMOUNT:"*":YR.DR.CCY:"*":Y.NUM.FTS
        END
    END

RETURN

END
