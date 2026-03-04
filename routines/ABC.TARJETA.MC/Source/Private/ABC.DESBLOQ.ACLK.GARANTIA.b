$PACKAGE AbcTarjetaMc
*===============================================================================
    SUBROUTINE ABC.DESBLOQ.ACLK.GARANTIA
*===============================================================================
* Nombre de Programa : ABC.DESBLOQ.ACLK.GARANTIA
* Objetivo           : Rutina para generar el desbloqueo del ACLK para tarjeta garantizada
*===============================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Template
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.Foundation
    $USING EB.Interface
    $USING AbcGetGeneralParam
    $USING EB.Updates

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

    RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ID.GENE.PARAM = 'ABC.ACLK.GARANTIA'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    OFS.MSG = ''
    Y.ID.FT.ACLK = ''
    Y.ID.ACLK = ''
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","AUTH.ID",Y.POS.AUTH.ID)

    RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    EB.DataAccess.Opf(FN.AC.LOCKED.EVENTS, F.AC.LOCKED.EVENTS)

    RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------

    GOSUB GET.GENERAL.PARAM


    Y.LOCAL.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.ID.ACLK = Y.LOCAL.FT<1,Y.POS.AUTH.ID>
    Y.DEBIT.ACCT.NO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.DEBIT.AMOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
    EB.SystemTables.setAv(Y.POS.AUTH.ID)

    R.AC.LOCKED.EVENTS = ''
    ERR.ACLK = ''
    EB.DataAccess.FRead(FN.AC.LOCKED.EVENTS, Y.ID.ACLK, R.AC.LOCKED.EVENTS, F.AC.LOCKED.EVENTS, ERR.ACLK)

    IF R.AC.LOCKED.EVENTS EQ '' THEN
        ETEXT = "EL REGISTRO: " :Y.ID.ACLK: " NO EXISTE"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        Y.ACCOUNT.NUMBER = R.AC.LOCKED.EVENTS<AC.AccountOpening.LockedEvents.LckAccountNumber>
        Y.LOCKED.AMOUNT = R.AC.LOCKED.EVENTS<AC.AccountOpening.LockedEvents.LckLockedAmount>
        IF (Y.DEBIT.ACCT.NO NE Y.ACCOUNT.NUMBER) THEN
            ETEXT = "LA CUENTA ES DIFERENTE EN BLOQUEO: " :SQUOTE(Y.ID.ACLK)
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
        IF (Y.DEBIT.AMOUNT NE Y.LOCKED.AMOUNT) THEN
            ETEXT = "EL MONTO ES DIFERENTE EN BLOQUEO: " :SQUOTE(Y.ID.ACLK)
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END
    
    FUNCT  = "R"
    R.ACLK = ""

    EB.Foundation.OfsBuildRecord(APP.NAME,FUNCT,OFS.PROCESS,OFSVERSION.GARANTIA,"",NO.OF.AUTH,Y.ID.ACLK,R.ACLK,OFS.MSG)

    Y.RTN.ERR = ''
    EB.Interface.OfsAddlocalrequest(OFS.MSG, "add", Y.RTN.ERR)

    IF Y.RTN.ERR THEN
        ETEXT = "NO SE PUDO REALIZAR EL DESBLOQUEO DE SALDO: ":Y.RTN.ERR
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        AbcTarjetaMc.AbcGuardaAplicaTarjGar()
    END

    RETURN

*-------------------------------------------------------------------------------
GET.GENERAL.PARAM:
*-------------------------------------------------------------------------------

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GENE.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE "OFS.APP.NAME" IN Y.LIST.PARAMS SETTING POS THEN
        APP.NAME = Y.LIST.VALUES<POS>
    END

    LOCATE "OFS.VERSION.GARANTIA" IN Y.LIST.PARAMS SETTING POS THEN
        OFSVERSION.GARANTIA = Y.LIST.VALUES<POS>
    END

    LOCATE "OFS.NO.OF.AUTH" IN Y.LIST.PARAMS SETTING POS THEN
        NO.OF.AUTH = Y.LIST.VALUES<POS>
    END

    LOCATE "OFS.PROCESS" IN Y.LIST.PARAMS SETTING POS THEN
        OFS.PROCESS = Y.LIST.VALUES<POS>
    END


    RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------
    RETURN

END
