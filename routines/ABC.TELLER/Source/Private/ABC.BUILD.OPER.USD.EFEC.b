*===============================================================================
$PACKAGE AbcTeller
*===============================================================================
    SUBROUTINE ABC.BUILD.OPER.USD.EFEC(ENQ.PARAM)
*===============================================================================
* Nombre de Programa : ABC.BUILD.OPER.USD.EFEC
* Objetivo           : Rutina para agregar criterio de seleccion a las consultas
*                    : de retiro en efectivo especial para validacion de monto USD
* Requerimiento      : Autorización de operación en efectivo

*===============================================================================
* Modificaciones:
*===============================================================================

    $USING EB.DataAccess
    $USING ST.CurrencyConfig
    $USING AbcGetGeneralParam
    
    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

    RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ID.GEN.PARAM = 'LIMITE.MONTO.USD'
    Y.LIST.PARAMS  = ''
    Y.LIST.VALUES  = ''
    Y.POS.PARAM    = ''
    Y.VALOR.MAX.USD = ''
    Y.ID.MONEDA = ''
    R.CURRENCY = ''
    ERR.CURRENCY = ''
    Y.MONTO.VAL = ''
    Y.VALOR.USD = ''
    Y.MERCADO.DIVISA = ''

    RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    EB.DataAccess.Opf(FN.CURRENCY, F.CURRENCY)

    RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------

    GOSUB GET.GENERAL.PARAM

    EB.DataAccess.FRead(FN.CURRENCY, Y.ID.MONEDA, R.CURRENCY, F.CURRENCY, ERR.CURRENCY)
    IF R.CURRENCY THEN
        Y.VALOR.USD = R.CURRENCY<ST.CurrencyConfig.Currency.EbCurBuyRate><1,Y.MERCADO.DIVISA>
        Y.MONTO.VAL = Y.VALOR.USD*Y.VALOR.MAX.USD

        ENQ.PARAM<2,1> = 'AMOUNT.LOCAL.1'
        ENQ.PARAM<3,1> = 'GE'
        ENQ.PARAM<4,1,1> = Y.MONTO.VAL
    END

    RETURN

*-------------------------------------------------------------------------------
GET.GENERAL.PARAM:
*-------------------------------------------------------------------------------

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'ID.MONEDA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.ID.MONEDA = Y.LIST.VALUES<Y.POS.PARAM>
    END

    LOCATE 'VALOR.MAX.USD' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.VALOR.MAX.USD = Y.LIST.VALUES<Y.POS.PARAM>
    END

    LOCATE 'MERCADO.DIVISA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.MERCADO.DIVISA = Y.LIST.VALUES<Y.POS.PARAM>
    END

    RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------



    RETURN

END

