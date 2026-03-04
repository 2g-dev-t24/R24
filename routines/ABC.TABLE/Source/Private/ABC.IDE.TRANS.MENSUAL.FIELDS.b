* @ValidationCode : MjotMTY4ODA2NjA1OTpDcDEyNTI6MTc1OTc4MDQ4MTk5NjpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Oct 2025 16:54:41
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

SUBROUTINE ABC.IDE.TRANS.MENSUAL.FIELDS
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition('MONEDA'            , '3' , 'A'  , '')
    
    
    EB.Template.TableAddfielddefinition('XX<COD.TRANS', '3', '', '')
    EB.Template.TableAddfielddefinition('XX-NO.TRANS', '5', '', '')
    EB.Template.TableAddfielddefinition('XX>MTO.TRANS', '35', 'AMT', '')
    EB.Template.TableAddfielddefinition('XX<COD.TRANS.LN', '3', '', '')
    EB.Template.TableAddfielddefinition('XX-MTO.TRANS.LN', '35', 'AMT', '')
    EB.Template.TableAddfielddefinition('XX-FOL.TRANS.LN', '35', 'A', '')
    EB.Template.TableAddfielddefinition('XX-IDE.TRANS.LN', '19', 'AMT', '')
    EB.Template.TableAddfielddefinition('XX>FEC.TRANS.LN', '8', 'D', '')
    EB.Template.TableAddfielddefinition('XX.MOV.DEP', '50', '', '')

    EB.Template.TableAddreservedfield('RESERVADO.10')
    EB.Template.TableAddreservedfield('RESERVADO.09')
    EB.Template.TableAddreservedfield('RESERVADO.08')
    EB.Template.TableAddreservedfield('RESERVADO.07')
    EB.Template.TableAddreservedfield('RESERVADO.06')
    EB.Template.TableAddreservedfield('RESERVADO.05')
    EB.Template.TableAddreservedfield('RESERVADO.04')
    EB.Template.TableAddreservedfield('RESERVADO.03')
    EB.Template.TableAddreservedfield('RESERVADO.02')
    EB.Template.TableAddreservedfield('RESERVADO.01')

    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()
RETURN
*-----------------------------------------------------------------------------
END

