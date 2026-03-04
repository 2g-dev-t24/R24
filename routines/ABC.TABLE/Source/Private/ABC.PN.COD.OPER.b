* @ValidationCode : MjotNjMwMjYxODM1OkNwMTI1MjoxNzU3MzgxMDg3NDAzOm1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 08 Sep 2025 22:24:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable
*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.PN.COD.OPER

* ======================================================================
* Nombre de Programa : ABC.PN.COD.OPER
* Parametros         :
* Objetivo           : CATALOGO DE CODIGOS DE OPERACION DE PORTABILIDAD DE NOMINA
* Desarrollador      : SANDRA FIGUEROA ESQUIVEL
* Compañia           : ABC
* Fecha Creacion     : 2016/09/23
* Modificaciones     :
* ======================================================================

    $USING EB.Template

*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.PN.COD.OPER')   ;* Full application name including product prefix
    EB.Template.setTableTitle('Codigo de Operacion de PN')   ;* Screen title
    EB.Template.setTableStereotype('H')       ;* H, U, L, W or T
    EB.Template.setTableProduct('EB')      ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')        ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('CUS')     ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('N')       ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')        ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('PN.CO')   ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')        ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('')        ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN

END

