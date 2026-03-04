* @ValidationCode : MjotMTM3NjI0NTgyNjpDcDEyNTI6MTc1NzM4MzM4MDYwMTptYXVyaWNpby5sb3BlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Sep 2025 23:03:00
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
SUBROUTINE ABC.PN.CODIGOS

* ======================================================================
* Nombre de Programa : ABC.PN.CODIGOS
* Parametros         :
* Objetivo           : CATALOGO DE CODIGOS DE RESPUESTA A SOLICITUD DE PORTABILIDAD DE NOMINA
* Desarrollador      : SANDRA FIGUEROA ESQUIVEL
* Compania           : ABC
* Fecha Creacion     : 2016/09/23
* Modificaciones     :
* ======================================================================

    $USING EB.Template

*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.PN.CODIGOS')    ;* Full application name including product prefix
    EB.Template.setTableTitle('Estatus de la Solicitud de PN')         ;* Screen title
    EB.Template.setTableStereotype('H')       ;* H, U, L, W or T
    EB.Template.setTableProduct('EB')      ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')        ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('CUS')     ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('N')       ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')        ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('PN.CR')   ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')        ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('')        ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN

END
