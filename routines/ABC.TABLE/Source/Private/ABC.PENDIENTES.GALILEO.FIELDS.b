* @ValidationCode : MjotMTQ2MzExMDM3MzpDcDEyNTI6MTc1MzMxMzY3ODQxNjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Aug 2025 20:34:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Claudio Guarra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable

SUBROUTINE ABC.PENDIENTES.GALILEO.FIELDS
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("AUTH.ID", EB.Template.T24String)
*-----------------------------------------------------------------------------

    fieldName = 'TIPO.TRANS'
    fieldLength = 10
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'DESCRIPCION'
    fieldLength = 35
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CUENTA.CLIENTE'
    fieldLength = 35
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'MONTO.LOCAL'
    fieldLength = 10
    fieldType = 'AMT'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'COMISION'
    fieldLength = 10
    fieldType = 'AMT'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'MONTO.ORIG'
    fieldLength = 10
    fieldType = 'AMT'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'MONEDA.ORIG'
    fieldLength = 10
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ACLK.ID'
    fieldLength = 35
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FECHA.INGRESO'
    fieldLength = 8
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'HORA.INGRESO'
    fieldLength = 8
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ESTATUS'
    fieldLength = 35
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FECHA.APLI'
    fieldLength = 8
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'HORA.APLI'
    fieldLength = 8
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'MSG.ERROR'
    fieldLength = 100
    fieldType = 'ANY'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

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
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------
    RETURN
*-----------------------------------------------------------------------------
END
