$PACKAGE AbcTable

SUBROUTINE ABC.IDE.PARAM
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.IDE.PARAM')
    EB.Template.setTableTitle('IDE Parametros')
    EB.Template.setTableStereotype('H')
    EB.Template.setTableProduct('EB')
    EB.Template.setTableSubproduct('')
    EB.Template.setTableClassification('INT')
    EB.Template.setTableSystemclearfile('Y')
    EB.Template.setTableRelatedfiles('')
    EB.Template.setTableIspostclosingfile('')
    EB.Template.setTableEquateprefix('ABC.IP')
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')
    EB.Template.setTableBlockedfunctions('')
    EB.Template.setTableTriggerfield('')
*-----------------------------------------------------------------------------

RETURN

END

