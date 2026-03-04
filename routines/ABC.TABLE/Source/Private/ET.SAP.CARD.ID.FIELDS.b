*-----------------------------------------------------------------------------
$PACKAGE AbcTable
SUBROUTINE ET.SAP.CARD.ID.FIELDS
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    ID.F = "CARD.NUMBER"
    ID.T = ''
    ID.N = '16.1'
    EB.Template.TableDefineid("CARD.NUMBER", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    fieldName = 'ID.ET.SAP'
    fieldLength = '20'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)


*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
END