$PACKAGE AbcTable
SUBROUTINE ET.SAP.CARD.ID
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING EB.Interface
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ET.SAP.CARD.ID')      ;* Full application name including product prefix
    EB.Template.setTableTitle('ET.SAP.CARD.ID')    ;* Screen title
    EB.Template.setTableStereotype('H')    ;* H, U, L, W or T
    EB.Template.setTableProduct('EB')      ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')     ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('FIN')        ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('Y')         ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')   ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('ESCI')     ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')         ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('') ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

    RETURN
END