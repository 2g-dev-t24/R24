* @ValidationCode : MjoxMzEzMTMxNDQ6Q3AxMjUyOjE3NTg4OTYwMTMxMjk6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Sep 2025 11:13:33
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
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.2BR.TELDENOM.TOT.UNIT

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.Display
    $USING AC.AccountOpening
    $USING TT.Contract
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

RETURN
**************
INIT:
**************
    ABC.UNIT.VAL    = EB.SystemTables.getComi()
    POSN            = EB.SystemTables.getAv()
    DENOM.VAL.ALL   = EB.SystemTables.getRNew(TT.Contract.Teller.TeDenomination)
    DENOM.VAL       = DENOM.VAL.ALL<1,POSN>
    DENOM.VAL       = DENOM.VAL[4,6]
    TT.LOCAL.REF    = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
    TT.TE.UNIT      = EB.SystemTables.getRNew(TT.Contract.Teller.TeUnit)
    
    LREF.TABLE = "TELLER"
    LREF.FIELD = "GRAN.TOTAL"
    EB.Updates.MultiGetLocRef(LREF.TABLE, LREF.FIELD, LREF.POS)
    Y.POS.GRANTOT   = LREF.POS<1,1>

RETURN
**************
PROCESS:
**************
    IF NOT(NUM(DENOM.VAL)) THEN
        DENOM.VAL = FIELD(DENOM.VAL,',',2)
        DENOM.VAL = 0.01 * DENOM.VAL
    END

    IF POSN = 1 THEN
        Y.VALOR.POR = ABC.UNIT.VAL * DENOM.VAL
        TT.LOCAL.REF<1,Y.POS.GRANTOT> = Y.VALOR.POR
        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)
    END ELSE
        CURR.VAL        = ABC.UNIT.VAL * DENOM.VAL
        POSN            = POSN - 1
        SUM.DR          = 0
        DENOM.VAL       = ''
        ABC.UNIT.VAL    = 0
        PREV.VAL        = 0
        FOR NO.OF.DENOM = 1 TO POSN
            DENOM.VAL = DENOM.VAL.ALL<1,NO.OF.DENOM>
            DENOM.VAL = DENOM.VAL[4,6]
            IF NOT(NUM(DENOM.VAL)) THEN
                DENOM.VAL = FIELD(DENOM.VAL,',',2)
                DENOM.VAL = 0.01 * DENOM.VAL
            END
            ABC.UNIT.VAL = TT.TE.UNIT<1,NO.OF.DENOM>
            PREV.VAL = ABC.UNIT.VAL * DENOM.VAL
            SUM.DR += PREV.VAL
        NEXT NO.OF.DENOM
        Y.VALOR = CURR.VAL + SUM.DR
        TT.LOCAL.REF<1,Y.POS.GRANTOT> = Y.VALOR
        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)
    END
    
    EB.Display.RebuildScreen()

RETURN
**********
END


