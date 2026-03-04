* @ValidationCode : Mjo3MzMwMzk4NTA6Q3AxMjUyOjE3NjY0MTU5MDcwMDY6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Dec 2025 12:05:07
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
$PACKAGE AbcTeller

SUBROUTINE ABC.2BR.E.NOFILE.TT.REVERSO.OPER(R.DATA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Updates
    $USING TT.Contract
    $USING FT.Contract
    $USING EB.Reports
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
*
    R.DATA = ''
    YT.REC = ""
    TELLER.ID = ""
*
    TELLER.FILE = "F.TELLER$HIS"
    F.TELLER = ""
    EB.DataAccess.Opf(TELLER.FILE, F.TELLER)

    FN.TELLER.ID = 'F.TELLER.ID'
    FV.TELLER.ID = ''
    EB.DataAccess.Opf(FN.TELLER.ID,FV.TELLER.ID)

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
    
    D.FIELDS              = EB.Reports.getDFields()
    D.RANGE.AND.VALUE     = EB.Reports.getDRangeAndValue()

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*
    TELLER.ID = ''
    LOCATE "TELLER.ID" IN D.FIELDS<1> SETTING POSITION THEN
        TELLER.ID = D.RANGE.AND.VALUE<POSITION>
    END

    TRANSACTION.NUMBER = ''
    LOCATE "TRANSACTION.NUMBER" IN D.FIELDS<1> SETTING POSITION THEN
        TRANSACTION.NUMBER = D.RANGE.AND.VALUE<POSITION>
    END

    TELLER.ID = STR("0",4-LEN(TELLER.ID)):TELLER.ID
    Y.USER.ID = ''
    EB.DataAccess.Dbr("TELLER.ID":@FM:TT.TID.USER,TELLER.ID,Y.USER.ID)

*
    SELECT.STM = "SELECT " : TELLER.FILE : " BY TRANSACTION.CODE BY DATE.TIME"
*
    IF (TELLER.ID NE "") AND (TELLER.ID NE "ALL") THEN
        SELECT.STM := " WITH (TELLER.ID.1 EQ " : DQUOTE(TELLER.ID)  ; * ITSS - NYADAV - Added DQUOTE
        SELECT.STM := " OR WITH TELLER.ID.2 EQ ": DQUOTE(TELLER.ID):")"   ; * ITSS - NYADAV - Added DQUOTE
        SELECT.STM := " AND RECORD.STATUS EQ 'REVE'"   ; * ITSS - NYADAV - Added '
    END
*

    TEL.ID.LIST = '' ; TEL.NO.SELECTED = ''
    EB.DataAccess.Readlist(SELECT.STM,TEL.ID.LIST,'',TEL.NO.SELECTED,'')
*

    IF Y.USER.ID EQ '' THEN RETURN
    TR.ID.LIST = ''
    TR.ID.LIST = TEL.ID.LIST
    SEL.STM = 'SELECT ' :FN.FUNDS.TRANSFER :' WITH INPUTTER LIKE ':DQUOTE('...':SQUOTE(Y.USER.ID):'...'):'  AND RECORD.STATUS EQ "REVE"'   ; * ITSS - NYADAV - Added DQUOTE / SQUOTE / "
    IF (TRANSACTION.NUMBER NE "") THEN
        SEL.STM := ' AND @ID LIKE ':DQUOTE(SQUOTE(TRANSACTION.NUMBER):'...')   ; * ITSS - NYADAV - Added DQUOTE / SQUOTE
    END
    SEL.STM := ' BY TRANSACTION.TYPE BY DATE.TIME'

    FT.ID.LIST = '' ; FT.NO.SELECTED = ''
    EB.DataAccess.Readlist(SEL.STM,FT.ID.LIST,'',FT.NO.SELECTED,'')
    IF FT.ID.LIST THEN
        IF TR.ID.LIST EQ '' THEN
            TR.ID.LIST = FT.ID.LIST
        END ELSE
            TR.ID.LIST := @FM:FT.ID.LIST
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
                CASE YR.TR.ID[1,2] EQ 'FT'
                    GOSUB READ.FT.FILE
            END CASE
            IF R.DATA = '' THEN
                R.DATA = YR.REC
            END ELSE
                R.DATA := @FM:YR.REC
            END
        UNTIL NOT (GO.ON)
        REPEAT
    END

*
RETURN
***********************************************
*--------------
FORMAT.DETAILS:
*--------------
*

    YR.REC = ''
    Y.TRANSACTION.NUMBER = YR.TR.ID
    Y.INPUTTER = YR.TEL.REC<TT.Contract.Teller.TeInputter>
    Y.AUTHORISER = YR.TEL.REC<TT.Contract.Teller.TeAuthoriser>
    Y.DATE.TIME = YR.TEL.REC<TT.Contract.Teller.TeDateTime>
*     TELLER.TIME2 = TELLER.TIME1[7,2]
*     TELLER.TIME3 = TELLER.TIME1[9,2]
*     Y.DATE.TIME = TELLER.TIME2 : ":" : TELLER.TIME3
    Y.DEPT.CODE = YR.TEL.REC<TT.Contract.Teller.TeDeptCode>

    YR.REC = Y.TRANSACTION.NUMBER:"*":Y.INPUTTER:"*":Y.AUTHORISER:"*":Y.DATE.TIME:"*":Y.DEPT.CODE

RETURN
***********************************************
*----------------
READ.TELLER.FILE:
*----------------
*
    ER = ''
    EB.DataAccess.FRead(TELLER.FILE,YR.TR.ID,YR.TEL.REC,F.TELLER,ER)
*
RETURN
************************************************
*----------------
READ.FT.FILE:
*----------------
*
    ER = ''
    EB.DataAccess.FRead(FN.FUNDS.TRANSFER ,YR.TR.ID,YR.FT.REC,FV.FUNDS.TRANSFER ,ER)
*
    YR.REC = ''
    Y.TRANSACTION.NUMBER = YR.TR.ID
    Y.INPUTTER = YR.FT.REC<FT.Contract.FundsTransfer.Inputter>
    Y.AUTHORISER = YR.FT.REC<FT.Contract.FundsTransfer.Authoriser>
    Y.DATE.TIME = YR.FT.REC<FT.Contract.FundsTransfer.DateTime>
*     FT.TIME2 = TELLER.TIME1[7,2]
*     FT.TIME3 = TELLER.TIME1[9,2]
*     Y.DATE.TIME = TELLER.TIME2 : ":" : TELLER.TIME3
    Y.DEPT.CODE = YR.FT.REC<FT.Contract.FundsTransfer.DeptCode>

    YR.REC = Y.TRANSACTION.NUMBER:"*":Y.INPUTTER:"*":Y.AUTHORISER:"*":Y.DATE.TIME:"*":Y.DEPT.CODE

RETURN
************************************************
*
*---------------This is the Final End Statement----------------
*
END
