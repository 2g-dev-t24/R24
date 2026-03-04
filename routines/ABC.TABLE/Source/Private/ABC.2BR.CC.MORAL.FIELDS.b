* @ValidationCode : MjoxNDE3ODEyNDEyOkNwMTI1MjoxNzUzODQ1ODE1OTc5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 30 Jul 2025 00:23:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ClaudioGuarra
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

SUBROUTINE ABC.2BR.CC.MORAL.FIELDS
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24Numeric)        ;* Define Table id
    EB.SystemTables.setIdF('ID')
    EB.SystemTables.setIdT('A')
    EB.SystemTables.setIdN('24.1')

*-----------------------------------------------------------------------------

    fieldName = 'MNEMONIC'
    fieldLength = '10.3.C'
    fieldType = 'MNE'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX<ACCOUNT'
    fieldLength = '11.1.C'
    fieldType = 'ACC'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    EB.Template.FieldSetcheckfile("ACCOUNT":FM:AC.ACCOUNT.TITLE.1:FM:'A.')

    fieldName = 'XX>TRANSACTION'
    fieldLength = '1.1'
    fieldType = '':@FM:'Y_N'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    EB.Template.TableAddlocalreferencefield(neighbour)

*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
END