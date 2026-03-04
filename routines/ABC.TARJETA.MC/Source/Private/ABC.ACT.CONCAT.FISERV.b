* @ValidationCode : MjotNjQ2Mjg3MzEyOkNwMTI1MjoxNzU1NTYzMDkyODk4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Aug 2025 21:24:52
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
$PACKAGE AbcTarjetaMc

SUBROUTINE ABC.ACT.CONCAT.FISERV
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING AbcGetGeneralParam
*-----------------------------------------------------------------------------
    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.AC.FISERV = ''
    Y.ID.FISERV = ''
    R.ABC.INFO.FISERV = ''
    Y.AC.FISERV = EB.SystemTables.getIdNew()

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.ABC.INFO.FISERV = 'F.ABC.INFO.FISERV'
    F.ABC.INFO.FISERV = ''
    EB.DataAccess.Opf(FN.ABC.INFO.FISERV, F.ABC.INFO.FISERV)

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------

    Y.ID.FISERV = EB.SystemTables.getRNew(AbcTable.AbcTarjetaCredUala.Clabe)

    R.ABC.INFO.FISERV<AbcTable.AbcInfoFiserv.CuentaFiserv> = Y.AC.FISERV
    EB.DataAccess.FWrite(FN.ABC.INFO.FISERV, Y.ID.FISERV, R.ABC.INFO.FISERV)

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------



RETURN

END

