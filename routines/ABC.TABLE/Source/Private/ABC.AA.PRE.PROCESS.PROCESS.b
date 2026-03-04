* @ValidationCode : Mjo3Nzk1NjU4MTk6Q3AxMjUyOjE3NTc2MDY0NTgwNTE6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Sep 2025 13:00:58
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

SUBROUTINE ABC.AA.PRE.PROCESS.PROCESS
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

    APP.FUNCTION    = EB.SystemTables.getVFunction()
    ID.NEW          = EB.SystemTables.getIdNew()

    Y.STATUS        = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.RecordStatus)
    Y.SIM.FLAG      = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.SimFlag)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF NOT (Y.SIM.FLAG ) THEN

        IF Y.STATUS EQ 'IHLD' AND APP.FUNCTION EQ 'D' THEN  ;* FGMT-20170103- SE PONE ESTA VALIDACION PARA QUE NO ENCOLE LOS REGISTRO QUE SE BORRAN Y ESTAN EN IHLD
        END ELSE
            REC.ID      = ID.NEW
            REC.UPD     = ''
            REC.DETS    = ''
            EB.DataAccess.FReadu(FN.INP,REC.ID,REC.DETS,F.INP,ERR.DETS,'')

            AA.ARRANGEMENT.ID   = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.ArrangementId)
            AA.ACT.REF.ID       = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.ActRefId)
            PGM.VERSION         = EB.SystemTables.getPgmVersion()
            
            REC.UPD<AbcTable.AbcAaPreProcessList.Rec> = APP.FUNCTION : "-": AA.ARRANGEMENT.ID : "-": AA.ACT.REF.ID:"-":PGM.VERSION
            EB.DataAccess.FWrite(FN.INP,REC.ID,REC.UPD)
        END

    END

RETURN
*-----------------------------------------------------------------------------
END