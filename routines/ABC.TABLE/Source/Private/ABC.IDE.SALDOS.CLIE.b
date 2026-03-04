$PACKAGE AbcTable

SUBROUTINE ABC.IDE.SALDOS.CLIE
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.IDE.SALDOS.CLIE')
    EB.Template.setTableTitle('IDE Saldos Cliente')
    EB.Template.setTableStereotype('H')
    EB.Template.setTableProduct('EB')
    EB.Template.setTableSubproduct('')
    EB.Template.setTableClassification('INT')
    EB.Template.setTableSystemclearfile('Y')
    EB.Template.setTableRelatedfiles('')
    EB.Template.setTableIspostclosingfile('')
    EB.Template.setTableEquateprefix('ABC.ISC')
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')
    EB.Template.setTableBlockedfunctions('')
    EB.Template.setTableTriggerfield('')
*-----------------------------------------------------------------------------

RETURN

END
