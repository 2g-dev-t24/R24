* @ValidationCode : MjotNDMyNTk0MTA0OkNwMTI1MjoxNzYyOTE4MjExODc5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Nov 2025 00:30:11
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

SUBROUTINE BMV.2BR.V.DENOM.REC

*-------------------------------------------------------------------------

* Esta rutina llena denominaci�n recibido igual  denominacion

    $USING AbcTable
    $USING EB.Display
    $USING EB.SystemTables
    
* Loop para 14 denominaciones

    MONTO.DENOM     = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.MontoDenom)
    MONTO.DENOM.REC = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.MontoDenomRec)
    
    FOR NI = 1 TO 14
        MONTO.DENOM.REC<1,NI> = MONTO.DENOM<1,NI>
    NEXT NI
    EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.MontoDenomRec, Y.MONTO)
        
    EB.Display.RebuildScreen()

***********
END

