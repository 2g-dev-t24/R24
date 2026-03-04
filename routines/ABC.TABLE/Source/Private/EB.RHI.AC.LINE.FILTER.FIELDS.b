* @ValidationCode : MjotMTU4NTUyMjk3MTpDcDEyNTI6MTc2NDAwNjY5NDk3NDpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Nov 2025 14:51:34
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

SUBROUTINE EB.RHI.AC.LINE.FILTER.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
    $USING AC.AccountOpening
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('DESCRIPTION'      ,'35'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX<VARIABLE.NAME'      ,'35'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX-XX.NOTE'      ,'50'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX>XX.VARIABLE.VALUE'      ,'35'       , 'A', '')
    
    
    EB.Template.TableSetauditposition()
END
