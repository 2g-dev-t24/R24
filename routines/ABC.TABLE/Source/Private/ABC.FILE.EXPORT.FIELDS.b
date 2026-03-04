$PACKAGE AbcTable

SUBROUTINE ABC.FILE.EXPORT.FIELDS
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("FILE.EXPORT.ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfield("XX<FILE.MAPPING.ID", EB.Template.T24String, "","")
    EB.Template.TableAddfielddefinition("XX-FILE.NAME", "65", "ANY", "")
    EB.Template.TableAddfielddefinition("XX>FILE.PATH", "65", "ANY", "")

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
