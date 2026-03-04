* @ValidationCode : MjoxODk0NTgzNTM4OkNwMTI1MjoxNzU3NjA2NDQ4ODkzOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Sep 2025 13:00:48
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

SUBROUTINE ABC.AA.PRE.PROCESS.ID
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
    GET.REC.ID = EB.SystemTables.getComi()
    FN.CHK.LIST.FILE    = 'F.ABC.AA.PRE.PROCESS.LIST'
    F.CHK.LIST.FILE     = ''
    EB.DataAccess.Opf(FN.CHK.LIST.FILE,F.CHK.LIST.FILE)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GET.LIST.REC.DETS   = ''
    
    EB.DataAccess.FRead(FN.CHK.LIST.FILE,GET.REC.ID,GET.LIST.REC.DETS,F.CHK.LIST.FILE,CHK.ERR)
    Y.FUNCTION  = EB.SystemTables.getVFunction()
    
    IF GET.LIST.REC.DETS AND Y.FUNCTION NE 'S' THEN
        E ='Not Allowed to modify'
        EB.SystemTables.setE(E)
    END

RETURN
*-----------------------------------------------------------------------------
END