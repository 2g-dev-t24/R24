*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.FILTRA.CLABE.TDC(ENQ)
*-----------------------------------------------------------------------------
* Modificado por : 
* Fecha          : 
* Descripcion    : Toma el dato y obtiene las posiciones del ID de la tabla de TDC UALA
*-----------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING EB.Updates
    $USING EB.Display
    $USING EB.Reports


    FIND "@ID" IN ENQ SETTING Ap, Vp THEN
        Y.VALOR.LONG = 0
        Y.VALOR.LONG = ENQ<4,Vp>
        Y.V.LEN = LEN(Y.VALOR.LONG)
        IF Y.V.LEN EQ 18 THEN
            ENQ<4,Vp> = ENQ<4,Vp>[7,11]
        END
    END

    RETURN
END
