$PACKAGE AbcCob

SUBROUTINE ABC.IDE.CALC.IMPTO.RTN(P.CLIE, P.MTO.DEP.TOTAL, P.MTO.LINEA, P.MTO.LIMITE, P.PORC.IMPTO, X.MTO.CALC, X.MSG.PROC)

    GOSUB INICIO
    GOSUB PROCESO
    RETURN

*==========
PROCESO:
*==========
    IF (P.MTO.DEP.TOTAL + P.MTO.LINEA) > 0 THEN
        IF P.MTO.DEP.TOTAL > P.MTO.LINEA THEN
            IF P.MTO.LINEA > P.MTO.LIMITE THEN
                X.MTO.TOTAL = P.MTO.DEP.TOTAL - P.MTO.LINEA
            END ELSE
                X.MTO.TOTAL = P.MTO.DEP.TOTAL
            END

            IF X.MTO.TOTAL > P.MTO.LIMITE THEN
                X.MTO.CALC = ((X.MTO.TOTAL - P.MTO.LIMITE) * P.PORC.IMPTO)/100
                X.MTO.CALC = FMT(X.MTO.CALC, "R4")
                X.MTO.CALC = DROUND(X.MTO.CALC, 2)
                IF FIELD(X.MTO.CALC, '.', 2)[1,2] LT 51 THEN
                    X.MTO.CALC = FIELD(X.MTO.CALC, '.', 1)
                END ELSE
                    X.MTO.CALC = DROUND(X.MTO.CALC, 0)
                END

                X.MSG.PROC = "CLIENTE ": P.CLIE :", SE GENERO IMPUESTO"
            END ELSE
                X.MSG.PROC = "CLIENTE ": P.CLIE :", NO EXCEDE MONTO PARA CALCULAR IMPUESTO, OK"
            END
        END ELSE
            X.MSG.PROC = "CLIENTE ": P.CLIE :", MONTO TOTAL DEPOSITOS ES MENOR QUE DEPOSITOS EN LINEA, ERR"
        END
    END ELSE
        X.MSG.PROC = "CLIENTE ": P.CLIE :", NO EXISTEN MONTOS PARA PARA CALCULAR IDE, ERR"
    END

    RETURN

*==========
INICIO:
*==========
    X.MTO.TOTAL = 0
    X.MTO.CALC = 0
    X.MSG.PROC = ''

    RETURN

END
