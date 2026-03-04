* @ValidationCode : MjotMTg0MDY5NzU4NTpDcDEyNTI6MTc1ODg5NDY3MzcxOTpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Sep 2025 10:51:13
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
*=======================================================================
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.2BR.TT.TILL.TO.TILL.1
*=======================================================================
*
*
*    First Release : Banco Ve por Mas
*    Developed for : Banco Ve por Mas
*    Developed by  :
*    Date          :
*
*
*=======================================================================
*
* This routine updates the Denomenations both DR and CR sides
* when transfer is done from Till to till or Till to Vault
*
*=======================================================================
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Display
    $USING AbcTeller
*=======================================================================
    GOSUB INIT
    GOSUB PROCESS

RETURN
*=======================================================================
INIT:
*=======================================================================
    DENOM   = EB.SystemTables.getComi()
    AV      = EB.SystemTables.getAv()
 
RETURN
*=======================================================================
PROCESS:
*=======================================================================
    TT.CR.MARKER    = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrCrMarker)
    TT.TE.UNIT      = EB.SystemTables.getRNew(TT.Contract.Teller.TeUnit)
    TT.DR.UNIT      = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)
    
    IF TT.CR.MARKER EQ 'CREDIT' THEN
        TT.TE.UNIT<1,AV> = DENOM
        EB.SystemTables.setRNew(TT.Contract.Teller.TeUnit, TT.TE.UNIT)
    END ELSE
        TT.DR.UNIT <1,AV> = DENOM
        EB.SystemTables.setRNew(TT.Contract.Teller.TeDrUnit, TT.DR.UNIT)
    END
    
    EB.Display.RebuildScreen()

    AbcTeller.Abc2brTeldenomTotUnit()

RETURN
*=======================================================================
END
