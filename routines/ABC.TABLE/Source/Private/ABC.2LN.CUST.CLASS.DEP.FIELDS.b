* @ValidationCode : MjoxNTg5OTYyOTIwOkNwMTI1MjoxNzU3NjI4NzIxNTIwOkx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Sep 2025 19:12:01
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

SUBROUTINE ABC.2LN.CUST.CLASS.DEP.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.Template
    $USING ST.Config
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfield          ('XX<DEP.CATEGORY'   ,6, EB.Template.FieldNoInput, '')
    EB.Template.FieldSetcheckfile      ("CATEGORY":FM:ST.Config.Category.EbCatShortName:FM:'L.A')
    EB.Template.TableAddfield          ('XX>PERCENTAGE'   ,10, EB.Template.FieldNoInput, '')
    EB.Template.TableAddfield          ('TOLERANCE'   ,2, EB.Template.FieldNoInput, '')
    EB.Template.TableSetauditposition()
END
