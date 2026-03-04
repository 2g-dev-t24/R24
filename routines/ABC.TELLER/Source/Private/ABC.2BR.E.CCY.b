*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.2BR.E.CCY

    $USING EB.Reports

    O.DATA = EB.Reports.getOData()
    IF O.DATA[4,2] EQ 'TC' THEN
        O.DATA = O.DATA[1,5]
    END ELSE
        O.DATA = O.DATA[1,3]
    END
    EB.Reports.setOData(O.DATA)

    RETURN

END

