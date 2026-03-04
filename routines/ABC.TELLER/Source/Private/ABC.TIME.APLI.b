* @ValidationCode : MjotMTI3NDQ4MDExOkNwMTI1MjoxNzYxNjE2ODI3NzE4Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Oct 2025 23:00:27
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
SUBROUTINE ABC.TIME.APLI(Y.DT)
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
***************************
    GOSUB PROCESS

RETURN
***************************
PROCESS:
***************************
*   EXAMPLE Y.DT = 0605041622

    Y.DT = EB.SystemTables.getToday()
    Y.YEAR = Y.DT[3,2]
    Y.MM   = Y.DT[5,2]
    Y.DAY  = Y.DT[7,2]

    Y.DT = "Fecha de Aplicacion ":Y.DAY:"/":Y.MM:"/":Y.YEAR
    
RETURN
***************************
END
