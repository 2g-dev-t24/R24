* @ValidationCode : MjotMjExMDA0MDM2OTpDcDEyNTI6MTc2MjQ4Mjg4ODg3NDpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Nov 2025 23:34:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable
*-----------------------------------------------------------------------------

SUBROUTINE ABC.2BR.BOVEDAS.FIELDS
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.SystemTables.setIdF('ID')
    idType      = ''
    idType<1>   = 'A'
    idType<4>   = "L######/#####/#####"
    EB.SystemTables.setIdT(idType)
    EB.SystemTables.setIdN('18.1')
    EB.SystemTables.setIdConcatfile("AR")
*-----------------------------------------------------------------------------
    fieldName = 'REFERENCIA'
    fieldLength = '30'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'SOLICITANTE'
    fieldLength = '4'
    fieldType = ''
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FECHA.SOLICITUD'
    fieldLength = '8'
    fieldType = 'D'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'HORA.SOLICITUD'
    fieldLength = '8'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'USR.SOLICITA'
    fieldLength = '16'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FECHA.LIQUIDACION'
    fieldLength = '8'
    fieldType = 'D'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'HORA.LIQUIDACION'
    fieldLength = '8'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'USR.APRUEBA'
    fieldLength = '16'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FECHA.RECEPCION'
    fieldLength = '8'
    fieldType = 'D'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'HORA.RECEPCION'
    fieldLength = '8'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'USR.RECIBE'
    fieldLength = '16'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FECHA.RECHAZO'
    fieldLength = '8'
    fieldType = 'D'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'HORA.RECHAZO'
    fieldLength = '8'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'USR.RECHAZA'
    fieldLength = '16'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'MONEDA'
    fieldLength = '03.1'
    fieldType<1> = 'CCY'
    fieldType<3> = 'NOCHANGE'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("CURRENCY")

    fieldName = 'MONTO'
    fieldLength = '15'
    fieldType = 'AMT'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX<DENOMINACION'
    fieldLength = '30'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX-MONTO.DENOM'
    fieldLength = '10'
    fieldType = 'AMT'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>MONTO.DENOM.REC'
    fieldLength = '10'
    fieldType = 'AMT'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ESTADO'
    fieldLength = '1'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'TIPO'
    fieldLength = '1'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CTA.NOSTRO'
    fieldLength = '16'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("ACCOUNT")

    fieldName = 'ORIGEN'
    fieldLength = '1'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CONTADOR'
    fieldLength = '4'
    fieldType = ''
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'MONTO.RECIBIDO'
    fieldLength = '15'
    fieldType = 'AMT'
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
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
END