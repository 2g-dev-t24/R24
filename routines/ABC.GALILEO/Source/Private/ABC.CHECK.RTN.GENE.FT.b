*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
    SUBROUTINE ABC.CHECK.RTN.GENE.FT

    $USING EB.SystemTables
    $USING EB.Display
    $USING AbcTable

    IF EB.SystemTables.getRNew(AbcTable.AbcTempGeneFt.Status) EQ "REVERSADO" THEN
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.FecReversa, TIMEDATE())
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.Status, "")
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.MsgError, "")
        EB.Display.RebuildScreen()
    END

    RETURN
END
