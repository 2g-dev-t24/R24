* @ValidationCode : MjotMzkzNzcwMzpDcDEyNTI6MTc1NDkzOTM3MzExNTpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Aug 2025 16:09:33
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

$PACKAGE AbcAssign
SUBROUTINE ABC.ASSIGN.DAO.ACCT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING AbcTable
    $USING EB.Security
*-----------------------------------------------------------------------------
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    R.USER = EB.SystemTables.getRUser()
    DEPARTMENT.CODE = R.USER<EB.Security.User.UseDepartmentCode>
    EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.AccountOfficer, DEPARTMENT.CODE)
    EB.Display.RebuildScreen()
    
RETURN
*-----------------------------------------------------------------------------
END