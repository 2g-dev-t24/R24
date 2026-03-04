* @ValidationCode : MjotMTIyNjQ5MTAxOkNwMTI1MjoxNzY5MjAxMDc0MTM5OmVuem9jb3JpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 Jan 2026 17:44:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : enzocorio
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------

SUBROUTINE ABC.2BR.NOFILE.VAULT.STOCK(R.DATA)

*===============================================================
* This is the Routine for NO FILE Enq ABC.2BR.CORTE.CAJA.VENT.NEW
*************************************************

    $USING TT.Contract
    $USING TT.Config
    $USING EB.DataAccess
    $USING ST.Config
    $USING EB.SystemTables
    $USING EB.Reports
    $USING ST.CurrencyConfig
    $USING TT.Stock
*
    GOSUB INITIALIZE
*
    GOSUB PROCESS
*
RETURN
*
************************************************
*----------
INITIALIZE:
*----------
*
    R.DATA = ''
    YT.REC = ""
    TELLER.ID = ""
*
    TT.STOCK.CONTROL = "F.TT.STOCK.CONTROL"
    F.TT.STOCK.CONTROL = ""
    EB.DataAccess.Opf(TT.STOCK.CONTROL,F.TT.STOCK.CONTROL)

*
    TELLER.FILE = "F.TELLER"
    F.TELLER = ""
    EB.DataAccess.Opf(TELLER.FILE, F.TELLER)
    YR.TEL.ID = "" ; YR.TEL.REC = ""
*
    FN.TELLER.DENOMINATION = "F.TELLER.DENOMINATION"
    FV.TELLER.DENOMINATION = ""
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION,FV.TELLER.DENOMINATION)
*
    FN.CURRENCY = "F.CURRENCY"
    FV.CURRENCY = ""
    EB.DataAccess.Opf(FN.CURRENCY,FV.CURRENCY)

    D.FIELDS              = EB.Reports.getDFields()
    D.RANGE.AND.VALUE     = EB.Reports.getDRangeAndValue()

RETURN
************************************************
*-------
PROCESS:
*-------
*
    LOCATE "TELLER.ID" IN D.FIELDS<1> SETTING POSITION THEN
        TELLER.ID = D.RANGE.AND.VALUE<POSITION>
    END
*
    LOCATE "CURRENCY" IN D.FIELDS<1> SETTING POSITION THEN
        CURRENCY = D.RANGE.AND.VALUE<POSITION>
    END

    SELECT.STM1 = "SELECT " : TT.STOCK.CONTROL : " BY @ID WITH TELLER.ID GT ": DQUOTE(8999)

    IF (TELLER.ID NE "") AND (TELLER.ID NE "ALL") THEN
        IF (CURRENCY NE "") AND (CURRENCY NE "ALL") THEN
            SELECT.STM1 = "SELECT " : TT.STOCK.CONTROL : " BY @ID "
            SELECT.STM1 :=" WITH @ID LIKE ": DQUOTE(SQUOTE(CURRENCY ):"...":SQUOTE(TELLER.ID))
        END ELSE
            SELECT.STM1 = "SELECT " : TT.STOCK.CONTROL : " BY @ID "

            SELECT.STM1 := " WITH @ID LIKE ": DQUOTE("...":SQUOTE(TELLER.ID))
        END
    END ELSE
        IF (CURRENCY NE "") AND (CURRENCY NE "ALL") THEN
            IF (TELLER.ID NE "") AND (TELLER.ID NE "ALL") THEN
                SELECT.STM1 = "SELECT " : TT.STOCK.CONTROL : " BY @ID "
                SELECT.STM1 :=" WITH @ID LIKE ": DQUOTE(SQUOTE(CURRENCY ):"...":SQUOTE(TELLER.ID))
            END ELSE
                SELECT.STM1 = "SELECT " : TT.STOCK.CONTROL : " BY @ID "
                SELECT.STM1 := " WITH @ID LIKE ": DQUOTE(SQUOTE(CURRENCY):"...")
            END
        END

    END

    TT.STOCK.LIST = '' ; STOCK.NO.SEL = ''
    EB.DataAccess.Readlist(SELECT.STM1,TT.STOCK.LIST,'',STOCK.NO.SEL,'')
    IF TT.STOCK.LIST THEN
        LOOP
            REMOVE TT.STOCK.ID FROM TT.STOCK.LIST SETTING GO.ON
            ER = ''
            EB.DataAccess.FRead(TT.STOCK.CONTROL,TT.STOCK.ID,TT.STOCK.REC,F.TT.STOCK.CONTROL,ER)
            GOSUB FORMAT.DATA

        UNTIL NOT (GO.ON)
        REPEAT
    END
RETURN

*===============================================================================
*-------
FORMAT.DATA:
*-------
    UPD.TELLER.ID = ''
    UPD.CURRENCY = ''
    TELLER.ID = TT.STOCK.ID[4]
    CURRENCY =  TT.STOCK.ID[1,3]

    IF TT.STOCK.ID[4] EQ UPD.TELLER.ID THEN TELLER.ID = ''
    IF TT.STOCK.ID[1,3] EQ UPD.CURRENCY THEN CURRENCY = ''
    CURR = CURRENCY

    SELECT.STM2 = "SELECT " : FN.TELLER.DENOMINATION : " WITH @ID LIKE ":DQUOTE(SQUOTE(CURR):"..."):" BY.DSND VALUE "  ; * ITSS - SINDHU - Added DQUOTE / SQUOTE
    DENOM.LIST = '' ; DENOM.NO.SEL = ''
    EB.DataAccess.Readlist(SELECT.STM2,DENOM.LIST,'',DENOM.NO.SEL,'')
    IF DENOM.LIST THEN
        LOOP
            REMOVE DENOM.ID FROM DENOM.LIST SETTING POS1
        WHILE DENOM.ID:POS1

            LOCATE DENOM.ID IN TT.STOCK.REC<TT.Stock.StockControl.ScDenomination,1> SETTING POSITION THEN
                DEMON = TT.STOCK.REC<TT.Stock.StockControl.ScDenomination,POSITION>
                QUANT = TT.STOCK.REC<TT.Stock.StockControl.ScQuantity,POSITION>
                R.DATA<-1> = "":"*":"":"*":DEMON:"*":QUANT
            END

        REPEAT
    END

    R.DATA<-1> = TELLER.ID:"*":CURRENCY:"*":"":"*":""
    UPD.TELLER.ID = TELLER.ID
    UPD.CURRENCY = CURRENCY

RETURN

* End Main
*===============================================================================
* Subroutines
*===============================================================================
END
