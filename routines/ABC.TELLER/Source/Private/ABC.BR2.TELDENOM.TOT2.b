* @ValidationCode : MjoyMDAxODA0NDMzOkNwMTI1MjoxNzYzNjA0MDk4MzQ0Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Nov 2025 23:01:38
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
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.BR2.TELDENOM.TOT2

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Display
    $USING EB.LocalReferences
    
    EB.Updates.MultiGetLocRef("TELLER","GRAN.TOTAL2",Y.POS.GRAN.TOTAL2)
    TT.LOCAL.REF = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)

    ABC.UNIT.VAL = EB.SystemTables.getComi()
    POSN = EB.SystemTables.getAv()
    DENOM.VAL = EB.SystemTables.getRNew(TT.Contract.Teller.TeDenomination)
    DENOM.VAL = DENOM.VAL<1,POSN>
    DENOM.VAL = DENOM.VAL[4,6]
    IF NOT(NUM(DENOM.VAL)) THEN
        DENOM.VAL = FIELD(DENOM.VAL,',',2)
        DENOM.VAL = 0.01 * DENOM.VAL
    END

    IF POSN = 1 THEN
        TOTALVAL = ABC.UNIT.VAL * DENOM.VAL
        TT.LOCAL.REF<1,Y.POS.GRAN.TOTAL2> = TOTALVAL
        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)
    END ELSE
        CURR.VAL = ABC.UNIT.VAL * DENOM.VAL
        POSN = POSN - 1
        SUM.DR = 0
        DENOM.VAL = ''
        ABC.UNIT.VAL = 0
        PREV.VAL = 0

        FOR NO.OF.DENOM = 1 TO POSN
            DENOM.VAL = EB.SystemTables.getRNew(TT.Contract.Teller.TeDenomination)
            DENOM.VAL = DENOM.VAL<1,NO.OF.DENOM>
            DENOM.VAL = DENOM.VAL[4,6]
            IF NOT(NUM(DENOM.VAL)) THEN
                DENOM.VAL = FIELD(DENOM.VAL,',',2)
                DENOM.VAL = 0.01 * DENOM.VAL
            END
            ABC.UNIT.VAL = EB.SystemTables.getRNew(TT.Contract.Teller.TeUnit)
            ABC.UNIT.VAL = ABC.UNIT.VAL<1,NO.OF.DENOM>
            PREV.VAL = ABC.UNIT.VAL * DENOM.VAL
            SUM.DR += PREV.VAL
        NEXT NO.OF.DENOM
        TOTALVAL = CURR.VAL + SUM.DR
        TT.LOCAL.REF<1,Y.POS.GRAN.TOTAL2> = TOTALVAL
        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)
    END
    EB.Display.RebuildScreen()

RETURN
END
