$PACKAGE AbcTable
*-----------------------------------------------------------------------------

SUBROUTINE ET.SAP.TARJETA.FIELDS
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
    EB.SystemTables.setIdF('ID')
    EB.SystemTables.setIdT('A')
    EB.SystemTables.setIdN('20')

*-----------------------------------------------------------------------------

    fieldName = 'NUMERO'
    fieldLength = '16'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CUSTOMER.ID'
    fieldLength = '10'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'NOMBRE.PROPIETARIO'
    fieldLength = '24'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FECHA.EMISION'
    fieldLength = '8'
    fieldType = 'D'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CTE.DESDE'
    fieldLength = '8'
    fieldType = 'D'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'RESGUARDO.ID'
    fieldLength = '5'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("ET.SAP.SUCURSAL")

    EB.Template.TableAddoptionsfield('TIPO.TARJETA','TITULAR_ADICIONAL', 'A', '')
    EB.Template.TableAddoptionsfield('EDO.TARJETA','GENERADA_SOLICITADA_IMPRESA_ASIGNADA_ACTIVA_BLOQUEADA_CANCELADA_RETENIDA_DESTRUIDA', 'A', '')

    fieldName = 'CAUSA.EDO'
    fieldLength = '40'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CVE.SEG'
    fieldLength = '10'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ACCOUNT.ID'
    fieldLength = '16'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.PERFIL.ID'
    fieldLength = '5'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("ET.SAP.PERFIL")

    fieldName = 'EXCP.DESDE'
    fieldLength = '20'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'EXCP.HASTA'
    fieldLength = '20'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'EXCP.PERFIL.ID'
    fieldLength = '5'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("ET.SAP.PERFIL")

    fieldName = 'PRODUCTO.ID'
    fieldLength = '16'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("ET.SAP.PRODUCTO")

    fieldName = 'FECHA.VTO'
    fieldLength = '8'
    fieldType = 'D'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ID.BIN'
    fieldLength = '6'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CANTIDAD'
    fieldLength = '3'
    fieldType = ''
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'SUCURSAL.ID'
    fieldLength = '5'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("ET.SAP.SUCURSAL")

    fieldName = 'NIP'
    fieldLength = '4'
    fieldType = 'PASSWD'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'NO.LOTE'
    fieldLength = '14'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'TITULAR.ID'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CALLE.PROPIETARIO'
    fieldLength = '26'
    fieldType = 'TLX'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'NEXT.PROPIETARIO'
    fieldLength = '5'
    fieldType = ''
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'NINT.PROPIETARIO'
    fieldLength = '5'
    fieldType = ''
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'COLONIA.PROPIETARIO'
    fieldLength = '26'
    fieldType = 'TLX'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'DEL.MUN.PROPIETARIO'
    fieldLength = '26'
    fieldType = 'TLX'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ESTADO.PROPIETARIO'
    fieldLength = '16'
    fieldType = 'TLX'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'PAIS.PROPIETARIO'
    fieldLength = '30'
    fieldType = 'TLX'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CP.PROPIETARIO'
    fieldLength = '5'
    fieldType = ''
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'SECUENCIA'
    fieldLength = '6'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    
    fieldName = 'MAX.EFECTIVO'
    fieldLength = '11'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    EB.Template.TableAddoptionsfield('MAX.EFE.VERS','ACT_LIM', 'A', '')
    
    EB.Template.TableAddfield('TIPO.REPOSICION',EB.Template.T24String, EB.Template.FieldNoInput, '')

    fieldType = 'A'
    fieldType<3> = 'NOINPUT'
    EB.Template.TableAddoptionsfield('ELECCION','PRE-IMPRESA_PERSONALIZADA', fieldType, '')

    EB.Template.TableAddfield('FOLIO.REP',EB.Template.T24String, EB.Template.FieldNoInput, '')

    fieldName = 'CANAL'
    fieldLength = '40'
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("ABC.CANAL")

    EB.Template.TableAddoptionsfield('VIRTUAL','ACTIVO_INACTIVO', fieldType, '')

    EB.Template.TableAddoptionsfield('ON.OFF','ACTIVO_INACTIVO', fieldType, '')

    EB.Template.TableAddreservedfield("RESERVED.10")
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