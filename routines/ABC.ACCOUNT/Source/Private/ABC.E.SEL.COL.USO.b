* @ValidationCode : MjotODI4Nzk5NzgyOkNwMTI1MjoxNzU2MjYwMDk2OTg5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Aug 2025 23:01:36
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

SUBROUTINE ABC.E.SEL.COL.USO(ENQ.PARAM)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess

    $USING AbcTable
    $USING EB.Reports
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.COD.POST      = ""
    Y.DIR.COD.POS.ANT = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.CpFonTer)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.COD.POST = Y.DIR.COD.POS.ANT
    Y.COD.POST = FMT(Y.COD.POST,"5'0'R")

    ENQ.PARAM<2,1> = "CODIGO.POSTAL"
    ENQ.PARAM<3,1> = "EQ"
    ENQ.PARAM<4,1,1> = Y.COD.POST
    
RETURN
*-----------------------------------------------------------------------------
END