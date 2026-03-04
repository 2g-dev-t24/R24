*-----------------------------------------------------------------------------
$PACKAGE AbcBi
*-----------------------------------------------------------------------------
    SUBROUTINE FILTO.CTAS.DESTINO(ENQ)
*-----------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING EB.Updates
    $USING EB.Display
    $USING EB.Reports


    FIND "@ID" IN ENQ SETTING Ap, Vp THEN


        Y.VALOR.LONG = 0 ; Y.VALOR.LONG = ENQ<4,Vp>

        Y.V.LEN = LEN(Y.VALOR.LONG)
        IF Y.V.LEN GT 10 THEN
        END ELSE
            CHANGE 'EQ' TO 'LK' IN ENQ<3,Vp>
            ENQ<4,Vp> = ENQ<4,Vp>:'....'
        END

    END

    FIND "TIPO.CTA" IN ENQ SETTING Ap, Vp THEN
        Y.VALOR = ENQ<4,Vp>

        BEGIN CASE
        CASE Y.VALOR EQ 'TARJETA DEBITO'
            CHANGE 'EQ' TO 'LK' IN ENQ<3,Vp>
            CHANGE 'TARJETA DEBITO' TO 'TARJETA...DEBITO' IN ENQ
        CASE Y.VALOR EQ 'TARJETA DE CREDITO'
            CHANGE 'EQ' TO 'LK' IN ENQ<3,Vp>
            CHANGE 'TARJETA DE CREDITO' TO 'TARJETA...CREDITO' IN ENQ
        END CASE

    END


    RETURN
END
