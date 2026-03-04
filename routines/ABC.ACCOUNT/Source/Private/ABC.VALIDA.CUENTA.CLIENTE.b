* @ValidationCode : MjotNDkwMjQzMTA5OkNwMTI1MjoxNzU3NjQ4NTg3MDUzOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Sep 2025 00:43:07
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

SUBROUTINE ABC.VALIDA.CUENTA.CLIENTE
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
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING AbcSpei
*-----------------------------------------------------------------------------
    MESSAGE = EB.SystemTables.getMessage()
    
*    IF MESSAGE = "VAL" THEN
*        RETURN
*    END
    
    GOSUB INIT
    GOSUB PROC
    
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    LEN.ACC     = ''
    R.ACC       = ''
    Y.ACC.ERR   = ''
    ACC.ID      = ''
    ACCT.ID     = ''
    
RETURN
*-----------------------------------------------------------------------------
PROC:
*-----------------------------------------------------------------------------
    CUS.ID = EB.SystemTables.getComi()

    ACCT.ID =EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.AccountId)
    
    IF CUS.ID NE '' THEN
        IF ACCT.ID NE '' THEN
*            LEN.ACC=LEN(ACCT.ID)
*            IF LEN.ACC < 11 THEN
*                ACC.ID = STR("0",11-LEN.ACC):ACCT.ID
*            END ELSE
*                ACC.ID=ACCT.ID
*            END
            ACC.ID=ACCT.ID

            R.ACC = AC.AccountOpening.Account.Read(ACC.ID, Y.ACC.ERR)
            AC.CUSTOMER = R.ACC<AC.AccountOpening.Account.Customer>
            IF CUS.ID  <> AC.CUSTOMER THEN
                ETEXT = "CUENTA DE OTRO CLIENTE"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END
        END

    END ELSE
        ETEXT = "CLIENTE NO EXISTE"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN
*-----------------------------------------------------------------------------
END
