$PACKAGE AbcTable

SUBROUTINE ABC.FILE.MAPPING.FIELDS
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("FILE.MAPPING.ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition("FIELD.MARKER", "5", "ANY", "")
    EB.Template.TableAddfield("MAIN.APPLICATION", EB.Template.T24String, "", "")
    EB.Template.FieldSetcheckfile('STANDARD.SELECTION')
    EB.Template.TableAddfielddefinition('FIXED.SELECTION', "250", "ANY","")
    EB.Template.TableAddfield("XX<FIELD.NAME", EB.Template.T24BigString, "", "")
    EB.Template.TableAddfield("XX-OPERATION", EB.Template.T24BigString, "", "")
    EB.Template.TableAddfield("XX-CONVERSION", EB.Template.T24BigString, "", "")
    EB.Template.TableAddoptionsfield("XX>SHOW", 'YES_NO', '', '')

    EB.Template.TableAddreservedfield('RESERVED.10')
    EB.Template.TableAddreservedfield('RESERVED.09')
    EB.Template.TableAddreservedfield('RESERVED.08')
    EB.Template.TableAddreservedfield('RESERVED.07')
    EB.Template.TableAddreservedfield('RESERVED.06')
    EB.Template.TableAddreservedfield('RESERVED.05')
    EB.Template.TableAddreservedfield('RESERVED.04')
    EB.Template.TableAddreservedfield('RESERVED.03')
    EB.Template.TableAddreservedfield('RESERVED.02')
    EB.Template.TableAddreservedfield('RESERVED.01')

    EB.Template.TableAddlocalreferencefield(neighbour)

*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
END