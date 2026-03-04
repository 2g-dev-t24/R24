* @ValidationCode : MjotMTYxOTM2NTg3OkNwMTI1MjoxNzYwMzI2NDAyMjY0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Oct 2025 00:33:22
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

SUBROUTINE ABC.ACT.ACCOUNT.ACT.SELECT
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
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.API
    GOSUB PROCESS

RETURN

*===============================================================================
PROCESS:
*===============================================================================
    FN.ACCOUNT = AbcCob.getFnAccountA()
    Y.SEL.LIST=''
    Y.CANT.TOT=''
    Y.SEL.CMD = "SELECT ":FN.ACCOUNT
    EB.DataAccess.Readlist(Y.SEL.CMD, Y.SEL.LIST, '', Y.CANT.TOT, Y.RET.CODE)

    EB.Service.BatchBuildList('', Y.SEL.LIST)

RETURN
*===============================================================================

END

