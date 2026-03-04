$PACKAGE AbcTable

SUBROUTINE ABC.CHANGE.GROUP.FIELDS
*-----------------------------------------------------------------------------
*
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("FECHA", EB.Template.T24String)         ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('XX.ID.AA','25', 'A', '')
*-----------------------------------------------------------------------------
END

