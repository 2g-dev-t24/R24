* @ValidationCode : Mjo3NzI2NDE1MDQ6Q3AxMjUyOjE3NTU2NTQyMjUyNjA6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Aug 2025 22:43:45
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
$PACKAGE AbcSpei
SUBROUTINE ABC.E.TASA.INTERES(R.DATA)
***********************************************************
*
***********************************************************

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AbcTable
    $USING EB.Reports
    $USING AA.Account
    $USING AbcGetGeneralParam
    $USING AA.Interest

    GOSUB INIT.VARS
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

**********
INIT.VARS:
**********

    Y.SEP        = "|"

RETURN

***********
OPEN.FILES:
***********

    SEL.FIELDS  = EB.Reports.getDFields()
    SEL.VALUES  = EB.Reports.getDRangeAndValue()

RETURN

********
PROCESS:
********

    LOCATE "CATEGORY" IN SEL.FIELDS<1> SETTING IND.POS THEN
        Y.CATEGORY = SEL.VALUES<IND.POS>
    END

    R.DATA = ""
    Y.CADENA.SALIDA = ""
    Y.ID.COM.PARAM = 'TASAS'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.COM.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE Y.CATEGORY IN Y.LIST.PARAMS SETTING POS THEN
        Y.TASAS = Y.LIST.VALUES<POS>
    END
    
    Y.CANTIDAD = DCOUNT(Y.TASAS, '*')
    
    FOR Y = 1 TO Y.CANTIDAD
        Y.CADENA.SALIDA<-1> = FIELD(Y.TASAS,'*', Y)
    NEXT Y

    R.DATA<-1> = Y.CADENA.SALIDA
   
RETURN

END
