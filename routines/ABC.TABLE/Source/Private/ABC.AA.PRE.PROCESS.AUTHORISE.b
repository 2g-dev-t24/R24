* @ValidationCode : MjotODkxNzI3MzQ6Q3AxMjUyOjE3NTc2MDU1NjYyMDA6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Sep 2025 12:46:06
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

$PACKAGE AbcTable

SUBROUTINE ABC.AA.PRE.PROCESS.AUTHORISE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING AbcTable
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.INP = 'F.ABC.AA.PRE.PROCESS.LIST'
    F.INP = ''
    EB.DataAccess.Opf(FN.INP,F.INP)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    APP.FUNCTION = EB.SystemTables.getVFunction()

    REC.ID          = EB.SystemTables.getIdNew()
    R.GET.DETS      = ''
    REC.UPD         = ''
    
    Y.SIM.FLAG      = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.SimFlag)
    ARRANGEMENT.ID  = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.ArrangementId)
    AA.ACT.REF.ID   = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.ActRefId)
    PGM.VERSION     = EB.SystemTables.getPgmVersion()

    IF NOT (Y.SIM.FLAG ) THEN
        EB.DataAccess.FReadu(FN.INP,REC.ID,R.GET.DETS,F.INP,INP.ERR,'')

        REC.UPD<AbcTable.AbcAaPreProcessList.Rec> = APP.FUNCTION : "-": ARRANGEMENT.ID : "-": AA.ACT.REF.ID:"-":PGM.VERSION
        EB.DataAccess.FWrite(FN.INP,REC.ID,REC.UPD)
    END
    
RETURN
*-----------------------------------------------------------------------------
END