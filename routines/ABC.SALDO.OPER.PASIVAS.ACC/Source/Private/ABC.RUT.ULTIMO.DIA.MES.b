* @ValidationCode : MjotMTMxOTA4NDUxOTpDcDEyNTI6MTc1OTAwMjc0MTQzMzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Sep 2025 16:52:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSaldoOperPasivasAcc

SUBROUTINE ABC.RUT.ULTIMO.DIA.MES(IN.ANIO.MES, IN.WOC, OUT.FECHA, OUT.ERROR)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AbcGetGeneralParam
    $USING AbcTable
*-----------------------------------------------------------------------------

    GOSUB INICIALIZACION
    GOSUB VALIDA.DATOS.IN

    IF OUT.ERROR NE '' THEN RETURN

    GOSUB ABRIR.ARCHIVO
    GOSUB PROCESO

RETURN

INICIALIZACION:

    RS.HOL = ''

    OUT.ERROR = ''
    OUT.FECHA = ''

RETURN

VALIDA.DATOS.IN:

    IF LEN(IN.ANIO.MES) NE 6 THEN

        OUT.ERROR = 'ERROR 001: EL TAMAÑO DE LA FECHA INTRODUCIDA NO ES CORRRECTO'
        RETURN

    END

    IF NOT (ISDIGIT(IN.ANIO.MES)) THEN

        OUT.ERROR = 'ERROR 002: LA FECHA INTRODUCIDA DEBE TENER SOLO NUMEROS'
        RETURN

    END

    IF IN.ANIO.MES[5,2] LT 1 OR IN.ANIO.MES[5,2] GT 12 THEN

        OUT.ERROR = 'ERROR 003: LA FECHA INTODUCIDA TIENE UN MES INCORRECTO'
        RETURN

    END

    IF NOT(IN.WOC EQ 'W' OR IN.WOC EQ 'C' ) THEN

        OUT.ERROR = 'ERROR 004: SE DEBE DE PONER W O C EN EL SEGUNDO PARAMETRO'
        RETURN

    END

RETURN

ABRIR.ARCHIVO:

    FN.HOL = 'F.HOLIDAY'
    F.HOL = ''
    EB.DataAccess.Opf(FN.HOL, F.HOL)

RETURN

PROCESO:
    Y.ID.HOL = 'MX00' : IN.ANIO.MES[1,4]

    EB.DataAccess.FRead(FN.HOL,Y.ID.HOL,RS.HOL,F.HOL,YF.ERR)
    IF RS.HOL NE '' THEN

        A.CAMPO.MES = 13 + IN.ANIO.MES[5,2]

        A.DIAS.MES = LEN(RS.HOL<A.CAMPO.MES>) - COUNT(RS.HOL<A.CAMPO.MES>, 'X')
*        CRT  COUNT(RS.HOL<A.CAMPO.MES>, 'X')
*        CRT  LEN(RS.HOL<A.CAMPO.MES>)

        IF IN.WOC EQ 'C' THEN

            OUT.FECHA = IN.ANIO.MES:A.DIAS.MES

            RETURN

        END

        IF IN.WOC EQ 'W' THEN

            LOOP


            WHILE SUBSTRINGS (RS.HOL<A.CAMPO.MES>, A.DIAS.MES, 1) EQ 'H'

                A.DIAS.MES -= 1

            REPEAT

            IF A.DIAS.MES LT 10 THEN

                OUT.FECHA = IN.ANIO.MES : '0' : A.DIAS.MES

            END ELSE

                OUT.FECHA = IN.ANIO.MES : A.DIAS.MES

            END

        END
    END


RETURN

END

