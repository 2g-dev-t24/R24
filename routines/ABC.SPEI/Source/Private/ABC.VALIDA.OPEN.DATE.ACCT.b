$PACKAGE AbcSpei
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.VALIDA.OPEN.DATE.ACCT
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING AbcGetGeneralParam
    $USING EB.ErrorProcessing
    $USING EB.API

    GOSUB INICIALIZA
    GOSUB CHECK.OPEN.DATE
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.CUENTA = 'F.ACCOUNT'
    F.CUENTA = ''
    EB.DataAccess.Opf(FN.CUENTA, F.CUENTA)

    Y.ID.GEN.PARAM = 'SPEI.DIAS.APERTURA.CTA'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    NUM.DIAS.MINIMOS = ''
    LOCATE 'NUM.DIAS' IN Y.LIST.PARAMS SETTING POS.NUM.DIAS THEN
        NUM.DIAS.MINIMOS = Y.LIST.VALUES<POS.NUM.DIAS>
    END

    Y.ID.CUENTA = ''
    Y.FECHA.APERT.CTA = ''
    Y.FECHA.ACTUAL = EB.SystemTables.getToday()
    DAYS = "C"

    RETURN
*---------------------------------------------------------------
CHECK.OPEN.DATE:
*---------------------------------------------------------------

    Y.ID.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    REG.CUENTA = ""

    EB.DataAccess.FRead(FN.CUENTA, Y.ID.CUENTA, REG.CUENTA, F.CUENTA, ERR.CTA)

    IF REG.CUENTA NE '' THEN
        Y.FECHA.APERT.CTA = REG.CUENTA<AC.AccountOpening.Account.OpeningDate>

        EB.API.Cdd('',Y.FECHA.APERT.CTA, Y.FECHA.ACTUAL, DAYS)
        IF DAYS LT NUM.DIAS.MINIMOS THEN
            EB.SystemTables.setE("CUENTA AUN NO CUMPLE PLAZO MINIMO PARA ESTA OPERACION")
            EB.ErrorProcessing.Err()
        END
    END

    RETURN

END
