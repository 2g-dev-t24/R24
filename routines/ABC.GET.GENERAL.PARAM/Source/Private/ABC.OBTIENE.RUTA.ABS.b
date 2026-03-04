$PACKAGE AbcGetGeneralParam
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.OBTIENE.RUTA.ABS(Y.RUTA)
*-----------------------------------------------------------------------------

    Y.SEP = "/"

    PATH.AUX = @PATH
    Y.RUTA.AUX = Y.RUTA
    CONT.NIVEL = DCOUNT(Y.RUTA,Y.SEP)
    CONT.PATH = DCOUNT(PATH.AUX,Y.SEP)

    FOR I = 1 TO CONT.NIVEL
        Y.NIVEL = FIELD(Y.RUTA,Y.SEP,I)
        IF Y.NIVEL EQ ".." THEN
            GOSUB CAMBIO.NIVEL
        END
    NEXT I

    Y.RUTA = PATH.AUX:Y.RUTA.AUX

    RETURN

*************
CAMBIO.NIVEL:
*************

    Y.RUTA.AUX = ""
    PATH.AUX = ""

    FOR I.CAMBIO = I + 1 TO CONT.NIVEL
        Y.RUTA.AUX := FIELD(Y.RUTA,Y.SEP,I.CAMBIO):Y.SEP
    NEXT I.CAMBIO

    FOR I.PATH = 1 TO CONT.PATH - I
        PATH.AUX := FIELD(@PATH,Y.SEP,I.PATH):Y.SEP
    NEXT I.PATH

    RETURN

END
