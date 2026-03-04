* @ValidationCode : MjozODg3Mzc1MzA6Q3AxMjUyOjE3Njc2Njc2NDEzNDM6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2026 23:47:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcBi
*-----------------------------------------------------------------------------
SUBROUTINE ABC.V.GET.NAME
*----------------------------------------------------------------
* It will populate the complete Name of the Customer for enquiry
*----------------------------------------------------------------

    $USING AbcSpei
    $USING EB.Reports
    $USING EB.SystemTables

    Y.DATA = EB.Reports.getOData()
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(Y.DATA, Y.NOMBRE,MSG)
    EB.Reports.setOData(Y.NOMBRE)


END
