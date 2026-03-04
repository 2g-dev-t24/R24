*-----------------------------------------------------------------------------
$PACKAGE AbcTable
SUBROUTINE ABC.CAPTURA.INFLACION.FIELDS
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24Numeric)        ;* Define Table id
*-----------------------------------------------------------------------------

    fieldName = 'INFLACION'
    fieldLength = '10..C'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ULT.MODIF'
    fieldLength = '10'
    fieldType<1> = 'D'
    fieldType<3> = 'NOINPUT'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableAddlocalreferencefield(neighbour)
    EB.Template.TableAddoverridefield()

*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
END