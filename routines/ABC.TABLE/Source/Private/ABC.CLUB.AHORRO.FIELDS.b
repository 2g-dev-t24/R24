* @ValidationCode : MjotNDM0NDgwODk5OkNwMTI1MjoxNzU3NjI3ODE3MDcwOkx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Sep 2025 18:56:57
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

SUBROUTINE ABC.CLUB.AHORRO.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING AbcTable
    $USING EB.Template
    $USING AC.AccountOpening
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('NOMBRE.GRUPO'      ,'50'       , 'A', '')
    
    fieldName = "GROUP.CLASSIFIC"
    fieldLength = "4.1"
    fieldType = ""
    neighbour = ""
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CHECK.FILE.GPO.CLASSIFIC = "ABC.2BR.CUSTOMER.GROUPS":@FM:AbcTable.Abc2brCustomerGroups.Description:@FM:'A.'
    EB.Template.FieldSetcheckfile(CHECK.FILE.GPO.CLASSIFIC)

    fieldName = "XX<CUENTA"
    fieldLength = "35.1"
    fieldType = "ACC"
    neighbour = ""
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CHECK.FILE.CUENTA = "ACCOUNT":@FM:AC.AccountOpening.Account.AccountTitleOne:@FM:'A.'
    EB.Template.FieldSetcheckfile(CHECK.FILE.CUENTA)

    EB.Template.TableAddfield          ('XX-CLIENTE'   ,EB.Template.T24String, EB.Template.FieldNoInput, '')
    
    EB.Template.TableAddoptionsfield   ('XX-ES.TITULAR'       ,'SI_NO'    , 'A', '')
    
    EB.Template.TableAddfield          ('XX-EMPLEADO'   ,EB.Template.T24String, EB.Template.FieldNoInput, '')
    
    Fieldname = "XX-PARENTESCO"
    Table = "ABC.PARENTESCO"
    fieldLength = "20"
    fieldType<1> = "A"
    neighbour = ""
    EB.Template.TableAddfieldwitheblookup(Fieldname, Table, Neighbour)

    EB.Template.TableAddfield          ('XX>ACCIONISTA'   ,50, EB.Template.FieldNoInput, '')
    
    EB.Template.TableAddreservedfield('RESERVED.5')
    EB.Template.TableAddreservedfield('RESERVED.4')
    EB.Template.TableAddreservedfield('RESERVED.3')
    EB.Template.TableAddreservedfield('RESERVED.2')
    EB.Template.TableAddreservedfield('RESERVED.1')
*****************************************************************************
    EB.Template.TableSetauditposition()
    
END
