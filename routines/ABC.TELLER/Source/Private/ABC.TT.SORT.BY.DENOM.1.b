* @ValidationCode : MjoxMDMyMTMyNDYwOkNwMTI1MjoxNzY5MDg4NDc5NTc0OmVuem9jb3JpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Jan 2026 10:27:59
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
SUBROUTINE ABC.TT.SORT.BY.DENOM.1
*
* This subroutine will sort the denomination,serial.no in ascending order
* of the denominations.

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Reports
    $USING TT.Stock

    GOSUB INITIALISE
    GOSUB DENOM.SORT
*
RETURN
*
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

*
    STOCK.ID = ''
    STOCK.ID = EB.Reports.getOData()
    CURR = STOCK.ID[1,3]
    FN.TT.STOCK.CNT = 'F.TT.STOCK.CONTROL'
    FV.TT.STOCK.CNT = ''
    EB.DataAccess.Opf(FN.TT.STOCK.CNT,FV.TT.STOCK.CNT)

    FN.TELLER.DENOMINATION = 'F.TELLER.DENOMINATION'
    F.TELLER.DENOMINATION = ''
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION,FV.TELLER.DENOMINATION)
    TT.STOCK.REC = ''
RETURN

*-----------------------------------------------------------------------------
DENOM.SORT:
*-----------------------------------------------------------------------------
    
    EB.DataAccess.FRead(FN.TT.STOCK.CNT,STOCK.ID,TT.STOCK.REC,FV.TT.STOCK.CNT,ERR3)

    IF STOCK.ID[4,5] EQ 10000 THEN
        SELECT.STM2 = "SELECT " : FN.TELLER.DENOMINATION : " WITH @ID LIKE ":DQUOTE(SQUOTE(CURR):"..."):" AND WITH @ID UNLIKE ": DQUOTE("...":SQUOTE("TC"):"...") :"BY.DSND VALUE "  ; *ITSS-SINDHU - Added DQUOTE / SQUOTE
    END ELSE
        SELECT.STM2 = "SELECT " : FN.TELLER.DENOMINATION : " WITH @ID LIKE ":DQUOTE(SQUOTE(CURR):"...":SQUOTE("TC"):"..."):" BY.DSND VALUE "  ; *ITSS-SINDHU - Added DQUOTE / SQUOTE
    END

    TT.STK.TEMP.REC.DENOM = ''
    TT.STK.TEMP.REC.QTY = ''
    TT.STK.TEMP.REC.SER = ''


    DENOM.LIST = '' ; DENOM.NO.SEL = ''
    EB.DataAccess.Readlist(SELECT.STM2,DENOM.LIST,'',DENOM.NO.SEL,'')

    IF DENOM.LIST THEN
        LOOP
            REMOVE DENOM.ID FROM DENOM.LIST SETTING POS1
        WHILE DENOM.ID:POS1

            LOCATE DENOM.ID IN TT.STOCK.REC<TT.Stock.StockControl.ScDenomination,1> SETTING POSITION THEN
                TT.STK.TEMP.REC.DENOM<-1> = TT.STOCK.REC<TT.Stock.StockControl.ScDenomination, POSITION>
                TT.STK.TEMP.REC.QTY<-1> = TT.STOCK.REC<TT.Stock.StockControl.ScQuantity,POSITION>
                TT.STK.TEMP.REC.SER<-1> = TT.STOCK.REC<TT.Stock.StockControl.ScSerialNo,POSITION>
            END

        REPEAT
    END


    CONVERT @FM TO @VM IN TT.STK.TEMP.REC.DENOM
    CONVERT @FM TO @VM IN TT.STK.TEMP.REC.QTY
    CONVERT @FM TO @VM IN TT.STK.TEMP.REC.SER

    VM.COUNT = DCOUNT(TT.STK.TEMP.REC.DENOM,@VM)
    SM.COUNT = DCOUNT(TT.STK.TEMP.REC.SER,@SM)
*

    R.RECORD<1> = TT.STK.TEMP.REC.DENOM
    R.RECORD<2> = TT.STK.TEMP.REC.QTY
    R.RECORD<3> = TT.STK.TEMP.REC.SER
    EB.Reports.setRRecord(R.RECORD)
*
RETURN
END
