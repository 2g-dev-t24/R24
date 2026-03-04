* @ValidationCode : MjoxNTIxODY5MjA6Q3AxMjUyOjE3NTQ5NDI2OTg2MzU6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Aug 2025 17:04:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE AbcAccount

SUBROUTINE ABC.CALCULA.TES(IN.CADENA,OUT.ERROR)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING AC.AccountOpening
    $USING EB.OverrideProcessing

    $USING AbcTable
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    OUT.ERROR = 0
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF LEN(IN.CADENA)<17 THEN
        OUT.ERROR = 1
        RETURN
    END ELSE
        IF LEN(IN.CADENA)>17 THEN
            IN.CADENA = SUBSTRINGS(IN.CADENA,1,17)
        END
    END

    YERROR = 0

    FOR YI = 1 TO 17
        IF NOT(NUM(IN.CADENA<YI>)) THEN
            YERROR = 1
        END
    NEXT

    IF YERROR THEN
        OUT.ERROR = 2
        RETURN
    END

    YBANCO = IN.CADENA[1,3]
    YPLAZA = IN.CADENA[4,3]
    YCUENTA = IN.CADENA[7,11]

    YPESO = "37137137137137137"

    YMULTIPLICACION = ""

    FOR YI=1 TO 17
        YMULTIPLICACION<YI> = MOD(IN.CADENA[YI,1]*YPESO[YI,1],10)
    NEXT

    YCADENA.MULT = ""
    FOR YI= 1 TO 17
        YCADENA.MULT = YCADENA.MULT:YMULTIPLICACION<YI>
    NEXT

    YSUMA = 0

    FOR YI= 1 TO 17
        YSUMA = YSUMA + YMULTIPLICACION<YI>
    NEXT

    YDIGITO = MOD(YSUMA,10)

    YDIGITO = 10 - YDIGITO

    IF YDIGITO = 10 THEN
        YDIGITO = 0
    END

    IN.CADENA = IN.CADENA:YDIGITO
    
RETURN
*-----------------------------------------------------------------------------
END