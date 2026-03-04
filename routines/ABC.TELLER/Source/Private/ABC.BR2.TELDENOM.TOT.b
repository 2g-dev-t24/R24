* @ValidationCode : MjotMjA3NDkxNjU3MTpDcDEyNTI6MTc2MzA4NDA3NDc3MDpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Nov 2025 22:34:34
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
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.BR2.TELDENOM.TOT
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.LocalReferences
    $USING EB.Display
    $USING TT.Config
**********
    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN
**********
INITIALIZE:
**********
    EB.LocalReferences.GetLocRef("TELLER","GRAN.TOTAL",Y.POS.GRAN.TOTAL)

*    ABC.UNIT.VAL    = EB.SystemTables.getComi()
    ABC.UNIT.VAL = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)
    
*    POSN            = EB.SystemTables.getAv()
*    DENOM.VAL       = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrDenom)
*    DENOM.VAL       = DENOM.VAL<1,POSN>
*    DENOM.VAL       = DENOM.VAL[4,6]
    TT.LOCAL.REF    = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
    DENOM.VAL       = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrDenom)
    
    F.TELLER.DENOMINATION = ""
    FN.TELLER.DENOMINATION = "F.TELLER.DENOMINATION"
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION,F.TELLER.DENOMINATION)
    
RETURN
**********
PROCESS:
**********
*   IF NOT(NUM(DENOM.VAL)) THEN
*       DENOM.VAL = FIELD(DENOM.VAL,',',2)
*       DENOM.VAL = 0.01 * DENOM.VAL
*   END

*    IF POSN = 1 THEN
*        TOTALVAL = ABC.UNIT.VAL * DENOM.VAL
*        TT.LOCAL.REF<1,Y.POS.GRAN.TOTAL> = TOTALVAL
*        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)
*    END ELSE
*        CURR.VAL = ABC.UNIT.VAL * DENOM.VAL
*        POSN = POSN - 1
    SUM.DR = 0
*        DENOM.VAL = ''
*        ABC.UNIT.VAL = 0
*        PREV.VAL = 0
*
*        FOR NO.OF.DENOM = 1 TO POSN
    POSN = DCOUNT(DENOM.VAL, @VM)
    FOR NO.OF.DENOM = 1 TO POSN
        DENOM.VAL.AUX = DENOM.VAL<1,NO.OF.DENOM>
        Y.REG.DENO  = ''
        EB.DataAccess.FRead(FN.TELLER.DENOMINATION, DENOM.VAL.AUX, Y.REG.DENO, F.TELLER.DENOMINATION, ERR.TT.DEN)
        IF (Y.REG.DENO) THEN
            Y.VAL.DENOM = Y.REG.DENO<TT.Config.TellerDenomination.DenValue>
*            IF NOT(NUM(DENOM.VAL)) THEN
*                DENOM.VAL = FIELD(DENOM.VAL,',',2)
*                DENOM.VAL = 0.01 * DENOM.VAL
*            END

*            ABC.UNIT.VAL = ABC.UNIT.VAL<1,NO.OF.DENOM>
            ABC.UNIT.VAL.AUX = ABC.UNIT.VAL<1,NO.OF.DENOM>

*            PREV.VAL = ABC.UNIT.VAL * DENOM.VAL
            PREV.VAL = ABC.UNIT.VAL.AUX * Y.VAL.DENOM

            SUM.DR = SUM.DR + PREV.VAL
        END

    NEXT NO.OF.DENOM
    
    TT.LOCAL.REF<1,Y.POS.GRAN.TOTAL> = SUM.DR
    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)

*        TOTALVAL = CURR.VAL + SUM.DR
*        TT.LOCAL.REF<1,Y.POS.GRAN.TOTAL> = TOTALVAL
*        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)
*    END
    
    EB.Display.RebuildScreen()

RETURN
**********
END



