* @ValidationCode : MjotMTE5NDMxNzY5NjpDcDEyNTI6MTc2MTYyMzU4MzA2MjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Oct 2025 00:53:03
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
$PACKAGE AbcExtractGeneric

SUBROUTINE GEN.SEL.CMD.LV(Y.FIELD.LIST, Y.OPERATOR.LIST, Y.FILTER.LIST, Y.SEL.CMD)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* Nombre de Programa : GEN.SEL.CMD.LV
* Objetivo           : GENERA FILTROS DE COMANDO SELECT
* Desarrollador      : Cristian Jorge Manriquez Chacoff
* Compania           : larrainVial Ltda
* Fecha Creacion     : 2014-05-04
* Modificaciones     :
*===============================================================================
*-----------------------------------------------------------------------------

    GOSUB INITIALIZE          ;*
    GOSUB PROCESS   ;*
    GOSUB FINALIZE  ;*

RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALIZE>
INITIALIZE:
***

    Y.SEL.CMD   = ''
    Y.AND       = ' AND '
    Y.COUNT     = DCOUNT(Y.FIELD.LIST, @FM)

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
***

    FOR i = 1 TO Y.COUNT

        j  = 0

        IF Y.SEL.CMD THEN
            Y.SEL.CMD  := Y.AND
        END

        BEGIN CASE

            CASE Y.OPERATOR.LIST<i> EQ 'RG'
                IF Y.FIELD.LIST<i> EQ 'DATE.TIME' THEN
*                Y.SEL.CMD     := Y.FIELD.LIST<i>:' GE ':Y.FILTER.LIST<i,1>:']'
*                Y.SEL.CMD     := Y.AND:Y.FIELD.LIST<i>:' LE ':Y.FILTER.LIST<i,2>:']'
                    Y.SEL.CMD     := Y.FIELD.LIST<i>:' GE ':FMT(Y.FILTER.LIST<i,1>,"L%10")
                    Y.SEL.CMD     := Y.AND:Y.FIELD.LIST<i>:' LE ':FMT(Y.FILTER.LIST<i,2>,"L&9#10")

                END ELSE
                    Y.SEL.CMD     := Y.FIELD.LIST<i>:' GE ':Y.FILTER.LIST<i,1>
                    Y.SEL.CMD     := Y.AND:Y.FIELD.LIST<i>:' LE ':Y.FILTER.LIST<i,2>
                END

            CASE Y.OPERATOR.LIST<i> EQ 'CT'
                Y.SEL.CMD     := Y.FIELD.LIST<i>:' LIKE '
                LOOP
                    j    += 1
                    Y.AUX = Y.FILTER.LIST<i,j>
                WHILE Y.AUX
                    Y.SEL.CMD  := '...':Y.AUX:'...'
                REPEAT

            CASE Y.OPERATOR.LIST<i> EQ 'LK'
                Y.SEL.CMD     := Y.FIELD.LIST<i>:' LIKE '
                LOOP
                    j    += 1
                    Y.AUX = Y.FILTER.LIST<i,j>
                WHILE Y.AUX
                    Y.SEL.CMD  := Y.AUX
                REPEAT

            CASE 1
                Y.SEL.CMD     := Y.FIELD.LIST<i>
                Y.SEL.CMD     := ' ':Y.OPERATOR.LIST<i>
                LOOP
                    j    += 1
                    Y.AUX = Y.FILTER.LIST<i,j>
                WHILE Y.AUX
                    IF Y.FIELD.LIST<i> EQ 'DATE.TIME' THEN
                        Y.SEL.CMD  := ' ':Y.AUX:']'
                    END ELSE
                        Y.SEL.CMD  := ' ':Y.AUX
                    END
                REPEAT

        END CASE

    NEXT i

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= FINALIZE>
FINALIZE:
***

RETURN
*** </region>
END

