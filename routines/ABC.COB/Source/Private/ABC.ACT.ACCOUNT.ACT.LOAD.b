* @ValidationCode : MjoxOTg3MDY4OTE3OkNwMTI1MjoxNzYwMzI2MzAxMjE2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Oct 2025 00:31:41
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
$PACKAGE AbcCob

SUBROUTINE ABC.ACT.ACCOUNT.ACT.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* Nombre de Programa :  ABC.ACT.ACCOUNT.ACT
* Objetivo           :  Actualiza la tabla ACCOUNT.ACT para las cuentas que no se han actualizado porque se hizo el cambio de categoría durante el COB
* Requerimiento      :  AR-10328 T24 - Optimización Proceso Actualiza Cuenta Remunerada
* Desarrollador      :  CAST - F&G Solutions
* Compania           :  ABC Capital Banco
* Fecha Creacion     :  07/10/2024
*-----------------------------------------------------------------------------
    $USING EB.DataAccess

    GOSUB INITIALISE
    GOSUB OPEN.FILES

RETURN
*===============================================================================
*===============================================================================
INITIALISE:
*===============================================================================


RETURN
*===============================================================================
*===============================================================================
OPEN.FILES:
*===============================================================================

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT=''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    AbcCob.setFnAccountA(FN.ACCOUNT)
    AbcCob.setFAccountA(F.ACCOUNT)

    FN.ACCOUNT.ACT = 'F.ACCOUNT.ACT'
    F.ACCOUNT.ACT=''
    EB.DataAccess.Opf(FN.ACCOUNT.ACT,F.ACCOUNT.ACT)
    AbcCob.setFnAccountAct(FN.ACCOUNT.ACT)
    AbcCob.setFAccountAct(F.ACCOUNT.ACT)
RETURN
*===============================================================================

END

