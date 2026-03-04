* @ValidationCode : MjoyMDk3MDY0OTkyOkNwMTI1MjoxNzU2OTE4MjQzNTU2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Sep 2025 13:50:43
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
$PACKAGE AbcSpei

SUBROUTINE ABC.CHECK.TRAS.COMER
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.Browser
*-----------------------------------------------------------------------------
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    EB.Browser.SystemDeletevariable('CURRENT.DEBITACCTNO')
    EB.Browser.SystemDeletevariable('CURRENT.DEBITAMOUNT')
    EB.Browser.SystemDeletevariable('CURRENT.IDACLK')

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------


RETURN

END

