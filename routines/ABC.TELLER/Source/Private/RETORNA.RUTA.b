$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
    SUBROUTINE RETORNA.RUTA
    $USING EB.Reports
    
    RUTA.AREA = @PATH
    EB.Reports.setOData(RUTA.AREA)

    RETURN
END
