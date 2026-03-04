* @ValidationCode : MjotMTM5OTQ3MTEyOTpDcDEyNTI6MTc2OTY1MzUwNTc1NjpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Jan 2026 23:25:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcTable

SUBROUTINE EB.RHI.AC.LINE.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.Template
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('FIELD1'      ,'35'       , 'A', '')
    EB.Template.TableAddfielddefinition('FIELD2'      ,'35'       , 'A', '')
    EB.Template.TableAddfielddefinition('FIELD3'      ,'35'       , 'A', '')
    EB.Template.TableAddfielddefinition('FIELD4'      ,'35'       , 'A', '')
    EB.Template.TableAddfielddefinition('FIELD5'      ,'35'       , 'A', '')
    EB.Template.TableAddfielddefinition('FIELD6'      ,'35'       , 'A', '')
    EB.Template.TableAddfielddefinition('FIELD7'      ,'35'       , 'A', '')
    EB.Template.TableSetauditposition()
END
