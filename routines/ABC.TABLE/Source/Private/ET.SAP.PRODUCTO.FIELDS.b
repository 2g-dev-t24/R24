$PACKAGE AbcTable
*-----------------------------------------------------------------------------

SUBROUTINE ET.SAP.PRODUCTO.FIELDS
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24Numeric)        ;* Define Table id
    EB.SystemTables.setIdF('ID')
    EB.SystemTables.setIdT('')
    EB.SystemTables.setIdN('2')

*-----------------------------------------------------------------------------

    fieldName = 'BIN'
    fieldLength = '6'
    fieldType = ''
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'DESCRIPCION'
    fieldLength = '30'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.PERFILID'
    fieldLength = '5'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("ET.SAP.PERFIL")

    fieldName = 'T.VENCIMIENTO'
    fieldLength = '4'
    fieldType = ''
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'BAID'
    fieldLength = '10'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("CATEGORY")


    EB.Template.TableAddoptionsfield('XX<GENERA.ARCHIVOS','S_N', 'A', '')

    fieldName = 'XX-NOM.ARC.TARJETA'
    fieldLength = '30'
    fieldType = 'AMT'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX-NOM.ARC.NIP'
    fieldLength = '30'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    EB.Template.TableAddoptionsfield('XX>ENVIO.NIPS','S_N', 'A', '')

    EB.Template.TableAddoptionsfield('TIPO.REPOSICION','SIN REPOSICION_PRE-IMPRESA_PERSONALIZADA_ELECCION', 'A', '')

    fieldName = 'COSTO.REPOSI'
    fieldLength = '10'
    fieldType = 'AMT'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'NO.REP.SNCOSTO'
    fieldLength = '2'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName = 'MAX.TAR.ADIC'
    fieldLength = '2'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    EB.Template.TableAddoptionsfield('CONS.FEC.VEN','S_N', 'A', '')

    EB.Template.TableAddreservedfield("RESERVED.9")
    EB.Template.TableAddreservedfield("RESERVED.8")
    EB.Template.TableAddreservedfield("RESERVED.7")
    EB.Template.TableAddreservedfield("RESERVED.6")
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
END