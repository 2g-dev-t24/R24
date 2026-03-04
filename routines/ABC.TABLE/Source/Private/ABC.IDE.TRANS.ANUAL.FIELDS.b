* @ValidationCode : MjotNDQwMjY1ODYyOkNwMTI1MjoxNzY0MDA1ODY2Mjg2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Nov 2025 14:37:46
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
SUBROUTINE ABC.IDE.TRANS.ANUAL.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)
    
    
    EB.Template.TableAddfielddefinition('CURRENCY', 3, 'A', '')
    EB.Template.FieldSetcheckfile("CURRENCY")
        
    
    EB.Template.TableAddfielddefinition('XX<MES'               ,'2'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX-XX<COD.TRANS'      ,'3'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX-XX-NO.TRANS'       ,'5'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX-XX>MTO.TRANS'      ,'35'      , 'A', '')
    EB.Template.TableAddfielddefinition('XX-XX<COD.TRANS.LN'   ,'3'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX-XX-MTO.TRANS.LN'   ,'35'      , 'A', '')
    EB.Template.TableAddfielddefinition('XX-XX-FOL.TRANS.LN'   ,'35'      , 'A', '')
    EB.Template.TableAddfielddefinition('XX-XX>FEC.TRANS.LN'   ,'8'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX>XX.MOV.DEP'        ,'50'      , 'A', '')

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
