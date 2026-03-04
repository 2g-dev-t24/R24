$PACKAGE AbcTable
SUBROUTINE ABC.CTAS.AUTORIZADAS.INT.FIELDS

*---------------------------------------------------------------------------------------------------
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
 
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
    EB.SystemTables.setIdF('ID')
    EB.SystemTables.setIdT('A')
    EB.SystemTables.setIdN('18.18')
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition('XX.CTE.GLOBUS','10', 'CUS', '')

    EB.Template.TableAddreservedfield("RESERVED.6")
    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")

	EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
END