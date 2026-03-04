* @ValidationCode : MjotNzgwMzYxOTI5OkNwMTI1MjoxNzYzNDI5NDExOTM0Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Nov 2025 22:30:11
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

SUBROUTINE ABC.2BR.SUM.TOT.DENOM

*-----------------------------------------------------------------------------

    $USING TT.Contract
    $USING TT.Config
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Display
    $USING EB.Updates
    
    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN
***********
INITIALIZE:
***********

    Y.TOTAL = 0

    FN.TELLER.DENOMINATION = "F.TELLER.DENOMINATION"
    F.TELLER.DENOMINATION  = ""
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION,F.TELLER.DENOMINATION)

    Y.TXN.CCY   = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)
    Y.TT.DENOM  = EB.SystemTables.getRNew(TT.Contract.Teller.TeDenomination)
    Y.TT.UNIT   = EB.SystemTables.getRNew(TT.Contract.Teller.TeUnit)
    Y.COMI      = EB.SystemTables.getComi()

*    YSELECT.CMD = "SSELECT ":FN.TELLER.DENOMINATION:" WITH @ID LIKE ":DQUOTE(SQUOTE(Y.TXN.CCY):"...")
*    YLIST = ""; YNO = ""; YCO = ""
*    EB.DataAccess.Readlist(YSELECT.CMD,YLIST,"",YNO,YCO)

    EB.Updates.MultiGetLocRef("TELLER","GRAN.TOTAL",Y.POS.TOTAL)

RETURN

********
PROCESS:
********

    Y.DENOM.NO = EB.SystemTables.getAv()
    Y.TOT = 0
    FOR Y.IND = 1 TO Y.DENOM.NO
        Y.DENOM.ID =  Y.TT.DENOM
        Y.DENOM.ID = Y.DENOM.ID<1,Y.IND>
        EB.DataAccess.FRead(FN.TELLER.DENOMINATION,Y.DENOM.ID,TELLER.DENOMINATION.REC,F.TELLER.DENOMINATION,YF.ERR)
        IF NOT(TELLER.DENOMINATION.REC) THEN RETURN
        TT.DEN.VALUE    = TELLER.DENOMINATION.REC<TT.Config.TellerDenomination.DenValue>
        IF Y.IND NE Y.DENOM.NO THEN
            Y.TOT = Y.TT.UNIT<1,Y.IND> * TT.DEN.VALUE
        END ELSE
            Y.TOT = Y.COMI * TT.DEN.VALUE
        END
        Y.TOTAL += Y.TOT
    NEXT Y.IND
    
    TT.LOCAL.REF    = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
    TT.LOCAL.REF<1,Y.POS.TOTAL> = Y.TOTAL
    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)
    EB.Display.RebuildScreen()

RETURN
**********
END


