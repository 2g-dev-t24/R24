* @ValidationCode : MjotODQ0NTM2NjMwOkNwMTI1MjoxNzU3NjA0MjUzOTQ3Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Sep 2025 12:24:13
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

SUBROUTINE ABC.AA.L.PRE.PRO.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
    EB.SystemTables.setIdF('ID')
    EB.SystemTables.setIdT('A')
    EB.SystemTables.setIdN('60')
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition("ID.AA.PRE.PROCESS", '25', 'ANY', '')
    EB.Template.TableAddfielddefinition("STATUS.PRE.PROCESS", '25', 'ANY', '')
    EB.Template.TableAddfielddefinition("ID.AA.ARRANGEMENT", '25', 'ANY', '')
    EB.Template.TableAddfielddefinition("STATUS.AA.ARR", '25', 'ANY', '')
    EB.Template.TableAddfielddefinition("ID.ARRANGEMENT.ACT", '25', 'ANY', '')
    EB.Template.TableAddfielddefinition("STATUS.ARR.ACT", '25', 'ANY', '')
    EB.Template.TableAddfielddefinition("FECHA.INIC.PREPRO", 15, 'D', '')
    EB.Template.TableAddfielddefinition("FECHA.FIN.PREPRO", 15, 'D', '')
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
    EB.Template.TableSetauditposition()
RETURN
END
