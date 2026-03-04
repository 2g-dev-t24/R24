* @ValidationCode : MjoxMDQ0NjYyNTIyOkNwMTI1MjoxNzU0ODUyMjE3ODAwOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Aug 2025 15:56:57
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

SUBROUTINE ABC.ACCT.YAEXISTE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
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
    Y.NUM.ACCOUNT = EB.SystemTables.getComi()
    R.ACCOUNT = AC.AccountOpening.Account.Read(Y.NUM.ACCOUNT, CUST.ERR)
    
    IF R.ACCOUNT NE "" THEN
        ETEXT = "CUENTA " : Y.NUM.ACCOUNT : " YA EXISTE, USE OPCION DE ACTUALIZACION "
        EB.SystemTables.setEtext(ETEXT)
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    EB.Display.RebuildScreen()
*    CALL REFRESH.GUI.OBJECTS
    
RETURN
*-----------------------------------------------------------------------------
END