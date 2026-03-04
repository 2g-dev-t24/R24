* @ValidationCode : MjotMTY3MzkwMDM4NzpDcDEyNTI6MTc2MTcwODQ0NjkyMjpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 29 Oct 2025 00:27:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable

SUBROUTINE ABC.REP.R24.PARAM.FIELDS
    $USING EB.SystemTables
    $USING EB.Template
    $USING ST.Config
*-----------------------------------------------------------------------------

    EB.SystemTables.setIdF('ID')
    EB.SystemTables.setIdT('A')
    EB.SystemTables.setIdN('6.4')

*-----------------------------------------------------------------------------

    fieldName = 'XX.CATEGORY'
    fieldLength = '10'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("CATEGORY")

    fieldName = 'XX<CLAVE.DEP'
    fieldLength = '10'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>XX.TRANS.DEP'
    fieldLength = '10'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("TRANSACTION")

    fieldName = 'XX<CLAVE.RET'
    fieldLength = '10'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>XX.TRANS.RET'
    fieldLength = '10'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("TRANSACTION")

    fieldName = 'RUTA'
    fieldLength = '255'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'NOMBRE.ARCHIVO'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'EXTENSION'
    fieldLength = '4'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

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
