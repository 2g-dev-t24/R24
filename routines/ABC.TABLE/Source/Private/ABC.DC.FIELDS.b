* @ValidationCode : MjotMTE3MTgxMDQyMjpDcDEyNTI6MTc1NTAwNjY0MTc1MDpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Aug 2025 10:50:41
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

SUBROUTINE ABC.DC.FIELDS
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('VALUE.DATE', '8', 'D', '')
    EB.Template.TableAddfielddefinition('NOMBRE.ARCH', '65', 'A', '')

    EB.Template.TableAddoptionsfield("SIGN.D", "D_C", "", "")

    EB.Template.TableAddfielddefinition('XX<TRANSACTION.CODE.D', '3', '', '')
    EB.Template.FieldSetcheckfile('TRANSACTION')
    EB.Template.TableAddfielddefinition('XX-ACCOUNT.NUMBER.D', '12', 'A', '')
    EB.Template.FieldSetcheckfile('ACCOUNT')
    EB.Template.TableAddfielddefinition('XX-CATEGORY.PL.D', '5', 'A', '')
    EB.Template.FieldSetcheckfile('CATEGORY')
    EB.Template.TableAddfielddefinition('XX-CATEGORY.PROD.D', '5', 'A', '')
    EB.Template.FieldSetcheckfile('CATEGORY')
    EB.Template.TableAddfielddefinition('XX-CUSTOMER.D', '10', 'A', '')
    EB.Template.FieldSetcheckfile('CUSTOMER')
    EB.Template.TableAddfielddefinition('XX-DEPT.OFF.D', '15', 'A', '')
    EB.Template.FieldSetcheckfile('DEPT.ACCT.OFFICER')
    EB.Template.TableAddfielddefinition('XX-AMOUNT.LCY.D', '13', 'AMT', '')
    EB.Template.TableAddfielddefinition('XX>NARRATIVE.D', '34', 'A', '')

    EB.Template.TableAddoptionsfield("SIGN.C", "D_C", "", "")

    EB.Template.TableAddfielddefinition('XX<TRANSACTION.CODE.C', '3', '', '')
    EB.Template.FieldSetcheckfile('TRANSACTION')
    EB.Template.TableAddfielddefinition('XX-ACCOUNT.NUMBER.C', '12', 'A', '')
    EB.Template.FieldSetcheckfile('ACCOUNT')
    EB.Template.TableAddfielddefinition('XX-CATEGORY.PL.C', '5', 'A', '')
    EB.Template.FieldSetcheckfile('CATEGORY')
    EB.Template.TableAddfielddefinition('XX-CATEGORY.PROD.C', '5', 'A', '')
    EB.Template.FieldSetcheckfile('CATEGORY')
    EB.Template.TableAddfielddefinition('XX-CUSTOMER.C', '10', 'A', '')
    EB.Template.FieldSetcheckfile('CUSTOMER')
    EB.Template.TableAddfielddefinition('XX-DEPT.OFF.C', '15', 'A', '')
    EB.Template.FieldSetcheckfile('DEPT.ACCT.OFFICER')
    EB.Template.TableAddfielddefinition('XX-AMOUNT.LCY.C', '13', 'AMT', '')
    EB.Template.TableAddfielddefinition('XX>NARRATIVE.C', '34', 'A', '')

    EB.Template.TableAddfielddefinition('STATUS', '3', 'A', '')
    EB.Template.FieldSetcheckfile('PBS.DC.STATUS')
    EB.Template.TableAddfielddefinition('TOTAL.AMT.D', '15', '', '')
    EB.Template.TableAddfielddefinition('TOTAL.AMT.C', '15', '', '')
    EB.Template.TableAddfielddefinition('XX.ID.DC', '15', 'A', '')
    EB.Template.TableAddfielddefinition('DESCRIPCION', '200', 'A', '')

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
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
END