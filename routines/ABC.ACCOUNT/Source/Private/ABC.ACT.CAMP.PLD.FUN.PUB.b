* @ValidationCode : MjotNjA3MTI0NDU3OkNwMTI1MjoxNzU1NzQxMTM3MzA3Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
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

SUBROUTINE ABC.ACT.CAMP.PLD.FUN.PUB
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
    PLD.FUN.PUB = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.PldFunPub)
    tmp = EB.SystemTables.getT(AbcTable.AbcAcctLclFlds.PldFunPubEsp)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF ID.NEW EQ PLD.FUN.PUB THEN
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(AbcTable.AbcAcctLclFlds.PldFunPubEsp, tmp)
    END

    IF PLD.FUN.PUB EQ 'NO' THEN
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.PldFunPubEsp, "")
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(AbcTable.AbcAcctLclFlds.PldFunPubEsp, tmp)
    END
    IF  PLD.FUN.PUB EQ '' THEN
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.PldFunPubEsp, "")
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(AbcTable.AbcAcctLclFlds.PldFunPubEsp, tmp)
    END

    EB.Display.RebuildScreen()
*CALL REFRESH.GUI.OBJECTS
    
RETURN
*-----------------------------------------------------------------------------
END