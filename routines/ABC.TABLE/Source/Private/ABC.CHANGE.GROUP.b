$PACKAGE AbcTable

SUBROUTINE ABC.CHANGE.GROUP
    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING EB.Interface
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.CHANGE.GROUP')
    EB.Template.setTableTitle('ABC.CHANGE.GROUP')    ;* Screen title
    EB.Template.setTableStereotype('L')    ;* H, U, L, W or T
    EB.Template.setTableProduct('EB')      ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')     ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('INT')        ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('N')         ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')   ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('ABC.CHAN.GROUP')         ;* Use to create I_F.EB.LOG.PARAMETER
    EB.Template.setTableIdprefix('')       ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('C')         ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')        ;* Trigger field used for OPERATION style fields

RETURN
*-----------------------------------------------------------------------------
END
