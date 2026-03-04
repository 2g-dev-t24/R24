*-----------------------------------------------------------------------------
$PACKAGE AbcTable
SUBROUTINE ABC.PARAM.CONT.PROD.FIELDS
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24Numeric)        ;* Define Table id
*-----------------------------------------------------------------------------

    fieldName = 'RECA'
    fieldLength = '40'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'NOM.COMERCIAL'
    fieldLength = '40'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    EB.Template.TableAddoptionsfield('MED.TARJETA','S_N', '','')
    EB.Template.TableAddoptionsfield('MED.CHEQUERA','S_N', '','')
    EB.Template.TableAddoptionsfield('MED.VENTANILLA','S_N', '','')
    EB.Template.TableAddoptionsfield('MED.CAJERO','S_N', '','')
    EB.Template.TableAddoptionsfield('MED.INTERNET','S_N', '','')
    EB.Template.TableAddoptionsfield('MED.DOMICILIA','S_N', '','')
    EB.Template.TableAddoptionsfield('MED.COMERCIO','S_N', '','')
    EB.Template.TableAddoptionsfield('MED.TRANSF','S_N', '','')
    EB.Template.TableAddoptionsfield('SERV.CEDE','S_N', '','')
    EB.Template.TableAddoptionsfield('SERV.PAGARE','S_N', '','')
    EB.Template.TableAddoptionsfield('SERV.SPEI','S_N', '','')

    fieldName = 'TIPO.OPER'
    fieldLength = '50'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    EB.Template.TableAddfield("XX.COMISION", EB.Template.T24Numeric, '', '')
    EB.Template.FieldSetcheckfile("ABC.CAT.COMISIONES")

    EB.Template.TableAddfield("XX.COM.CAJERO", EB.Template.T24Numeric, '', '')
    EB.Template.FieldSetcheckfile("ABC.CAT.COMISIONES")

    fieldName = 'UEAU.NOMBRE'
    fieldLength = '50.1'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'DOMICILIO'
    fieldLength = '150.1'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'TELEFONO'
    fieldLength = '35.1'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CORREO'
    fieldLength = '50.1'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'PAG.WEB'
    fieldLength = '50.1'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CDF.TEL'
    fieldLength = '35.1'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CDF.PAG.WEB'
    fieldLength = '35.1'
    fieldType = 'A'
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