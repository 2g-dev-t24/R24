* @ValidationCode : Mjo5NDM3ODM0OTg6Q3AxMjUyOjE3NTc1OTk4NjgyNzk6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Sep 2025 11:11:08
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
$PACKAGE AbcTable

SUBROUTINE ABC.AA.PRE.PROCESS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING EB.Interface
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.AA.PRE.PROCESS')       ;* Full application name including product prefix
    EB.Template.setTableTitle('AA Contract Details')   ;* Screen title
    EB.Template.setTableStereotype('H')    ;* H, U, L, W or T
    EB.Template.setTableProduct('EB')      ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')     ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('FIN')        ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('Y')         ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')   ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('ABC.AA')          ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')       ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('')         ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN

END