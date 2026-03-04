* @ValidationCode : Mjo1MjEwNjYzMjQ6Q3AxMjUyOjE3NTczODY2NDg1NjA6bWF1cmljaW8ubG9wZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Sep 2025 23:57:28
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
SUBROUTINE ABC.PORTABILIDAD.NOMINA

* ======================================================================
* Nombre de Programa : ABC.PORTABILIDAD.NOMINA
* Parametros         :
* Objetivo           : REGISTRAR LAS SOLICITUDES DE PORTABILIDAD DE NOMINA
* Desarrollador      : SANDRA FIGUEROA ESQUIVEL
* Compania           : ABC
* Fecha Creacion     : 2016/09/22
* Modificaciones     :
* ======================================================================

    $USING EB.Template

*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.PORTABILIDAD.NOMINA')     ;* Full application name including product prefix
    EB.Template.setTableTitle('ABC.PORTABILIDAD.NOMINA')     ;* Screen title
    EB.Template.setTableStereotype('H')       ;* H, U, L, W or T
    EB.Template.setTableProduct('EB')      ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')        ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('CUS')     ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('N')       ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')        ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('PN')      ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')        ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('')        ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN

END
