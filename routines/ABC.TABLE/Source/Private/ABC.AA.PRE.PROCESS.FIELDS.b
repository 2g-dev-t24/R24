* @ValidationCode : MjoxMzAzNzExMDAyOkNwMTI1MjoxNzU3NTk5NzA0MjEwOkx1Y2FzRmVycmFyaTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Sep 2025 11:08:24
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

SUBROUTINE ABC.AA.PRE.PROCESS.FIELDS
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
    EB.SystemTables.setIdF('PREPROCESS.ID')
    EB.SystemTables.setIdT('A')
    EB.SystemTables.setIdN('19')

*-----------------------------------------------------------------------------

    fieldName = 'CUSTOMER.ID'
    fieldLength = '15'
    fieldType = ''
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("CUSTOMER")

    fieldName = 'CURRENCY'
    fieldLength = '15'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("CURRENCY")
    
    fieldName = 'EFFECTIVE.DATE'
    fieldLength = '15'
    fieldType = 'D'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ACCOUNT.ID'
    fieldLength = '19'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("ACCOUNT")
    
    fieldName = 'PRODUCT'
    fieldLength = '25'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("AA.PRODUCT")
    
    fieldName = 'AMOUNT'
    fieldLength = '19'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    
    fieldName = 'TERM'
    fieldLength = '15'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'SIM.FLAG'
    options = 'YES_NO'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddoptionsfield(fieldName, options, fieldType, neighbour)

    fieldName = 'NEW.INTEREST.RATE'
    fieldLength = '19'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    
    fieldName = 'MARGIN.OPER'
    fieldLength = '19'
    fieldType = ''
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'MARGIN.RATE'
    fieldLength = '19'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ARRANGEMENT.ID'
    fieldLength = '17'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    
    fieldName = 'ACT.REF.ID'
    fieldLength = '25'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'REV.FLAG'
    fieldLength = '1'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'INTEREST.RATE'
    fieldLength = '15'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    
    fieldName = 'MAT.DATE'
    fieldLength = '15'
    fieldType = 'D'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'DATE.CONVENTION'
    options = 'SIGUIENTE_ANTERIOR'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddoptionsfield(fieldName, options, fieldType, neighbour)

    fieldName = 'CAPITALIZATION'
    options = 'YES_NO'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddoptionsfield(fieldName, options, fieldType, neighbour)
    
    fieldName = 'INTERNET.BANKING'
    options = 'YES_NO'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddoptionsfield(fieldName, options, fieldType, neighbour)


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

*-----------------------------------------------------------------------------
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
    EB.SystemTables.setCNsOperation("ALL")
*-----------------------------------------------------------------------------
END