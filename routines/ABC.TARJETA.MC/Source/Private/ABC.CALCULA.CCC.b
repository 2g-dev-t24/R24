* @ValidationCode : MjoxOTk3MjAxNzYzOkNwMTI1MjoxNzU1NTYxMDc3NDU2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Aug 2025 20:51:17
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
$PACKAGE AbcTarjetaMc

SUBROUTINE ABC.CALCULA.CCC(IN.CADENA,OUT.ERROR)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

***************************
*  RUTINA PARA CALCULAR EL DIGITO DE CONTROL DEL CCC (CODIGO CUENTA CLIENTE) DE BANCO DE MEXICO
*  QUE ES LA CUENTA DE 18 POSICIONES (BBBPPPCCCCCCCCCCCD) DONDE BBB ES EL CODIGO DEL BANCO, PPP
*  ES EL CODIGO DE LA PLAZA DE LA CUENTA, CCCCCCCCCCC ES EL NUMERO DE CUENTA Y D ES EL DIGITO DE
*  CONTROL
*
*  PARAMETROS DE ENTRADA:
*         IN.CADENA   QUE CONTIENE LA CADENA CON EL CODIGO CUENTA CLIENTE CON O SIN DIGITO DE CONTROL
*                     EN CASO DE CONTENER EL DIGITO, ESTA RUTINA LO DISCRIMINA Y LO CALCULA DE NUEVO
*
*  PARAMETROS DE SALIDA:
*         IN.CADENA   QUE CONTIENE LA CADENA CON EL CODIGO CUENTA CLIENTE COMPLETO YA CON EL DIGITO
*                     DE CONTROL CALCULADO POR ESTA RUTINA.
*         OUT.ERROR   CODIGO DE ERROR. 0 = NO HAY ERROR, 1 = LA CADENA CONTIENE MENOS DE 17 DIGITOS
*                     QUE ES LO MINIMO QUE SE NECESITA, 2 = LA CADENA CONTIENE CARACTERES NO NUMERICOS
***************************


***************************
*VARIABLES USADAS
***************************
    OUT.ERROR = 0

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

