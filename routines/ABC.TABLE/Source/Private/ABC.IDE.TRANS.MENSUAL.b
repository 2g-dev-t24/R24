$PACKAGE AbcTable

SUBROUTINE ABC.IDE.TRANS.MENSUAL
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.IDE.TRANS.MENSUAL')
    EB.Template.setTableTitle('IDE Transacciones Mensual')
    EB.Template.setTableStereotype('H')
    EB.Template.setTableProduct('EB')
    EB.Template.setTableSubproduct('')
    EB.Template.setTableClassification('INT')
    EB.Template.setTableSystemclearfile('Y')
    EB.Template.setTableRelatedfiles('')
    EB.Template.setTableIspostclosingfile('')
    EB.Template.setTableEquateprefix('ABC.ITM')
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')
    EB.Template.setTableBlockedfunctions('')
    EB.Template.setTableTriggerfield('')
*-----------------------------------------------------------------------------

RETURN

END

