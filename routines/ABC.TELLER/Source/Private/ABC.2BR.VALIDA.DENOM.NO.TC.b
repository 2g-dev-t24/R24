* @ValidationCode : MjotMjEzNDY0MzkyNjpDcDEyNTI6MTc1ODg5NzU0NzAyNzpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Sep 2025 11:39:07
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
SUBROUTINE ABC.2BR.VALIDA.DENOM.NO.TC
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Security
    $USING EB.ErrorProcessing
    $USING EB.Display
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    TT.TE.UNIT  = EB.SystemTables.getRNew(TT.Contract.Teller.TeUnit)
    TT.TE.DENOM = EB.SystemTables.getRNew(TT.Contract.Teller.TeDenomination)
    
    TT.DR.UNIT  = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)
    TT.DR.DENOM = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrDenom)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.TOT.DEN   = DCOUNT(TT.TE.UNIT, @VM)
    FOR Y.CONT = 1 TO Y.TOT.DEN
        Y.NOM.DENOM     = TT.TE.DENOM<1,Y.CONT>
        Y.NOM.DENOM     = Y.NOM.DENOM[1,5]
        Y.CANT.DENOM    = TT.TE.UNIT<1,Y.CONT>
        IF (Y.NOM.DENOM[1,3] EQ "USD") AND (Y.NOM.DENOM[4,2] EQ "TC") AND (Y.CANT.DENOM NE 0) THEN
            ETEXT = "NO SE PERMITEN DENOMINACIONES DE CHEQUES DE VIAJERO"
            EB.Display.Rem();
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    NEXT Y.CONT

    Y.TOT.DEN = DCOUNT(TT.DR.UNIT, @VM)
    FOR Y.CONT = 1 TO Y.TOT.DEN
        Y.NOM.DENOM     = TT.DR.DENOM<1,Y.CONT>
        Y.NOM.DENOM     = Y.NOM.DENOM[1,5]
        Y.CANT.DENOM    = TT.DR.UNIT<1,Y.CONT>
        IF (Y.NOM.DENOM[1,3] EQ "USD") AND (Y.NOM.DENOM[4,2] EQ "TC") AND (Y.CANT.DENOM NE 0) THEN
            ETEXT = "NO SE PERMITEN DENOMINACIONES DE CHEQUES DE VIAJERO"
            EB.Display.Rem();
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    NEXT Y.CONT

RETURN
**********
END


