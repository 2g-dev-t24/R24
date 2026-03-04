$PACKAGE AbcTable

SUBROUTINE ABC.SECTOR.CNBV.FIELDS
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------

    EB.SystemTables.setIdF('ID')
    EB.SystemTables.setIdT('A')
    EB.SystemTables.setIdN('2.1')

*-----------------------------------------------------------------------------

    fieldName = 'SECTOR'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    EB.Template.TableAddoptionsfield('TIPO.IPAB.GAR', 'SI_NO', '', '')

    EB.Template.TableAddreservedfield('RESERVED.05')
    EB.Template.TableAddreservedfield('RESERVED.04')
    EB.Template.TableAddreservedfield('RESERVED.03')
    EB.Template.TableAddreservedfield('RESERVED.02')
    EB.Template.TableAddreservedfield('RESERVED.01')

    EB.Template.TableAddlocalreferencefield(neighbour)

*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
END
