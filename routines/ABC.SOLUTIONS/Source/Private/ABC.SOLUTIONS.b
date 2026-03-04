$PACKAGE AbcSolutions
* @ValidationCode : MjoxNDMwNzU1MDQ4OkNwMTI1MjoxNzY0Mjk0NDk4OTAxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Nov 2025 22:48:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

SUBROUTINE ABC.SOLUTIONS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING FT.Contract
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------

    
    Y.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    
    IF (Y.CUENTA =  '1000000217') THEN
        ETEXT = "CUENTA " : Y.CUENTA : " NO ES VALIDA POR SOLUTIONS "
        EB.SystemTables.setEtext(ETEXT)
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
END




END
