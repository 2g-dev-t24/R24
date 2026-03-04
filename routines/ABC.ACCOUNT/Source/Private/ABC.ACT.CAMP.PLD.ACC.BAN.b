* @ValidationCode : MjotNDEwNDIxMzE6Q3AxMjUyOjE3NTU3NDExMzczMjg6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
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

SUBROUTINE ABC.ACT.CAMP.PLD.ACC.BAN
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
    ID.NEW = EB.SystemTables.getIdNew()
    PLD.ACC.BAN = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.PldAccBan)
    tmp = EB.SystemTables.getT(AbcTable.AbcAcctLclFlds.PldAccBanEsp)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF ID.NEW EQ PLD.ACC.BAN THEN
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(AbcTable.AbcAcctLclFlds.PldAccBanEsp, tmp)
    END

    IF PLD.ACC.BAN EQ 'NO' THEN
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.PldAccBanEsp, "")
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(AbcTable.AbcAcctLclFlds.PldAccBanEsp, tmp)
    END
    IF PLD.ACC.BAN EQ "" THEN
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.PldAccBanEsp, "")
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(AbcTable.AbcAcctLclFlds.PldAccBanEsp, tmp)
    END

    EB.Display.RebuildScreen()
*CALL REFRESH.GUI.OBJECTS
    
RETURN
*-----------------------------------------------------------------------------
END