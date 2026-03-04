* @ValidationCode : MjotODI3OTk1ODMzOkNwMTI1MjoxNzY2NDEzNTU0MjIwOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Dec 2025 11:25:54
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
SUBROUTINE ABC.2BR.E.NOFILE.TT.STOCK(R.DATA)

*===============================================================

    $USING TT.Contract
    $USING ST.CurrencyConfig
    $USING TT.Stock
    $USING TT.Config
    $USING EB.DataAccess
    $USING EB.Reports
*************************************************

    GOSUB INITIALIZE

    GOSUB PROCESS

RETURN

************************************************
*----------
INITIALIZE:
*----------
*

    R.DATA = ""
    YT.REC = ""
    TELLER.ID = ""

    TT.STOCK.CONTROL    = "F.TT.STOCK.CONTROL"
    F.TT.STOCK.CONTROL  = ""
    EB.DataAccess.Opf(TT.STOCK.CONTROL,F.TT.STOCK.CONTROL)

    TELLER.FILE = "F.TELLER"
    F.TELLER    = ""
    EB.DataAccess.Opf(TELLER.FILE, F.TELLER)
    YR.TEL.ID = "" ; YR.TEL.REC = ""

    FN.TELLER.DENOMINATION = "F.TELLER.DENOMINATION"
    FV.TELLER.DENOMINATION = ""
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION,FV.TELLER.DENOMINATION)

    FN.CURRENCY = "F.CURRENCY"
    FV.CURRENCY = ""
    EB.DataAccess.Opf(FN.CURRENCY,FV.CURRENCY)

RETURN
************************************************
*-------
PROCESS:
*-------
    D.FIELDS              = EB.Reports.getDFields()
    D.RANGE.AND.VALUE     = EB.Reports.getDRangeAndValue()
    LOCATE "TELLER.ID" IN D.FIELDS<1> SETTING POSITION THEN
        TELLER.ID = D.RANGE.AND.VALUE<POSITION>
    END

    LOCATE "CURRENCY" IN D.FIELDS<1> SETTING POSITION THEN
        CURRENCY = D.RANGE.AND.VALUE<POSITION>
    END

    ENQ.SELECTION    = EB.Reports.getEnqSelection()
    IF ENQ.SELECTION EQ 'ABC.2BR.CORTE.CAJA.VENT.NEW' THEN
        SELECT.STM1 = "SELECT " : TT.STOCK.CONTROL : " BY @ID WITH TELLER.ID LT '9500'"   ;* ITSS - NYADAV - Added '
    END ELSE
        SELECT.STM1 = "SELECT " : TT.STOCK.CONTROL : " BY @ID WITH TELLER.ID GT '9499'"   ;* ITSS - NYADAV - Added '
    END

    IF (TELLER.ID NE "") AND (TELLER.ID NE "ALL") THEN
        IF (CURRENCY NE "") AND (CURRENCY NE "ALL") THEN
            SELECT.STM1 = "SELECT " : TT.STOCK.CONTROL : " BY @ID "
            SELECT.STM1 := " WITH @ID LIKE ": DQUOTE("'":CURRENCY:"'...'":TELLER.ID:"'")  ;* ITSS - NYADAV - Added DQUOTE / '
        END ELSE
            SELECT.STM1 = "SELECT " : TT.STOCK.CONTROL : " BY @ID "

            SELECT.STM1 := " WITH @ID LIKE ":DQUOTE("...":SQUOTE(TELLER.ID))    ;* ITSS - NYADAV - Added DQUOTE / SQUOTE
        END
    END ELSE
        IF (CURRENCY NE "") AND (CURRENCY NE "ALL") THEN
            IF (TELLER.ID NE "") AND (TELLER.ID NE "ALL") THEN
                SELECT.STM1 = "SELECT " : TT.STOCK.CONTROL : " BY @ID "
                SELECT.STM1 := " WITH @ID LIKE ":  DQUOTE("'":CURRENCY:"'...'":TELLER.ID:"'")       ;* ITSS - NYADAV - Added DQUOTE / '
            END ELSE
                SELECT.STM1 = "SELECT " : TT.STOCK.CONTROL : " BY @ID "
                SELECT.STM1 := " WITH @ID LIKE ":DQUOTE(SQUOTE(CURRENCY):"...") ;* ITSS - NYADAV - Added DQUOTE / SQUOTE
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

    SELECT.STM2 = "SELECT " : FN.TELLER.DENOMINATION : " WITH @ID LIKE ":DQUOTE(SQUOTE(CURR):"..."):" BY.DSND VALUE"    ;* ITSS - NYADAV - Added DQUOTE / SQUOTE
    DENOM.LIST = '' ; DENOM.NO.SEL = '' ; DENOM.SORT = ''
    EB.DataAccess.Readlist(SELECT.STM2,DENOM.LIST,'',DENOM.NO.SEL,'')

    IF DENOM.LIST THEN
        LOOP
            REMOVE DENOM.ID FROM DENOM.LIST SETTING POS1
        WHILE DENOM.ID:POS1
            EB.DataAccess.FRead(FN.TELLER.DENOMINATION, DENOM.ID, R.TELL.DENOM, FV.TELLER.DENOMINATION, ERR.DENOM)
            CURR.VALUE = R.TELL.DENOM<TT.Config.TellerDenomination.DenValue>

            LOCATE DENOM.ID IN TT.STOCK.REC<TT.Stock.StockControl.ScDenomination,1> SETTING POSITION THEN
                DEMON = TT.STOCK.REC<TT.Stock.StockControl.ScDenomination,POSITION>
                QUANT = TT.STOCK.REC<TT.Stock.StockControl.ScQuantity>

                IF QUANT NE "0" AND QUANT NE "" THEN ;* The return array only build when the denomination has an value.
                    LOCATE CURR.VALUE IN DENOM.SORT<1> BY "DR" SETTING DENOMPOS ELSE      ;* The denomination list maintained only for the available list of denomination.
                        INS CURR.VALUE BEFORE DENOM.SORT<DENOMPOS>
                    END

                    DENOM.VALUES = "":"*":"":"*":DEMON:"*":QUANT
                    INS DENOM.VALUES BEFORE R.DATA<DENOMPOS>
                END
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
