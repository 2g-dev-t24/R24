* @ValidationCode : MjotMTEyNDI5NDM4MjpDcDEyNTI6MTc1NDkxOTY1OTk1NTpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Aug 2025 10:40:59
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

$PACKAGE AbcAccount

SUBROUTINE ABC.ACT.VALIDA.TODO(Y.VAL.ACTUAL, Y.ORIGEN)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING AbcTable
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    GOSUB MANTEN.REGISTRO
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.GENERICO = ""
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    BEGIN CASE
        CASE Y.ORIGEN EQ "ACT.OFF"
            Y.ACT.OFF = Y.VAL.ACTUAL
    END CASE
    
RETURN
*-----------------------------------------------------------------------------
MANTEN.REGISTRO:
*-----------------------------------------------------------------------------
    IF Y.ACT.OFF EQ "" THEN
        Y.ACT.OFF = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.AccountOfficer)

        IF Y.ACT.OFF = "" THEN
            Y.ACT.OFF = "10104"
        END
    END
    EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.AccountOfficer, Y.ACT.OFF)
    
    EB.Display.RebuildScreen()
    
RETURN
*-----------------------------------------------------------------------------
END