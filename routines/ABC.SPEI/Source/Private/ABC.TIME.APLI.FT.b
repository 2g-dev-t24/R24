* @ValidationCode : MjotMjExMjQzODI2NDpDcDEyNTI6MTc2Mjg2ODA4NjI2ODpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Nov 2025 10:34:46
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

$PACKAGE AbcSpei

SUBROUTINE ABC.TIME.APLI.FT(Y.DT)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.DT    = EB.SystemTables.getToday()

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
* CONVERT THE DATE.TIME TO THE FORMAT YYY/MM/DD
*   EXAMPLE Y.DT = 0605041622

    Y.YEAR  = Y.DT[3,2]
    Y.MM    = Y.DT[5,2]
    Y.DAY   = Y.DT[7,2]

    Y.DT    = Y.DAY:"/":Y.MM:"/":Y.YEAR

RETURN
*-----------------------------------------------------------------------------
END
