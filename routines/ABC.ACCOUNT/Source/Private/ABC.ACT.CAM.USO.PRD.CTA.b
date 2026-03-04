* @ValidationCode : MjotMTc0OTY0NjI1NDpDcDEyNTI6MTc1NTc0MTEzNzM3NTpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Aug 2025 22:52:17
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

SUBROUTINE ABC.ACT.CAM.USO.PRD.CTA
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
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    ID.NEW = EB.SystemTables.getIdNew()
    COMI = EB.SystemTables.getComi()
    AF = EB.SystemTables.getAf()
    tmp = EB.SystemTables.getT(AbcTable.AbcAcctLclFlds.UsoPretendOtr)
    
    BEGIN CASE
        CASE ID.NEW EQ COMI
            tmp<3>=""
            tmp<3>="NOINPUT"
            EB.SystemTables.setT(AbcTable.AbcAcctLclFlds.UsoPretendOtr, tmp)
            EB.Display.RebuildScreen()
        CASE AF EQ AbcTable.AbcAcctLclFlds.UsoPretendCta
            USO.PRETEND.CTA = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.UsoPretendCta)
            IF USO.PRETEND.CTA EQ '' THEN
                tmp<3>=""
                tmp<3>="NOINPUT"
                EB.SystemTables.setT(AbcTable.AbcAcctLclFlds.UsoPretendOtr, tmp)
                EB.Display.RebuildScreen()
            END
    END CASE
    
RETURN
*-----------------------------------------------------------------------------
END