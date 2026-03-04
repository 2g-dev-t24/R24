* @ValidationCode : MjotMTg0OTY4MDAwOTpDcDEyNTI6MTc1NjkxNTc3MDIxMDpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Sep 2025 13:09:30
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

SUBROUTINE ABC.DESBLOQ.ACLK.TRAS.COMER
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING AbcTable
    $USING AbcSpei
    $USING AbcGetGeneralParam
    $USING EB.ErrorProcessing
    $USING EB.Foundation
    $USING EB.Interface
*-----------------------------------------------------------------------------
    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ID.GENE.PARAM = 'ABC.AC.COMERCIO.POSL'
    Y.OFS.SOURCE = ''
    Y.USR = ''
    Y.PWD = ''
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.POS.PARAM = ''
    OFS.MSG = ''
    Y.ID.FT.ACLK = ''
    Y.ID.ACLK = ''
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","AUTH.ID",Y.POS.AUTH.ID)

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS = ''
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER.HIS, F.FUNDS.TRANSFER.HIS)


    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    EB.DataAccess.Opf(FN.AC.LOCKED.EVENTS, F.AC.LOCKED.EVENTS)

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------

    GOSUB GET.GENERAL.PARAM

    Y.ID.FT.ACLK = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.POS.AUTH.ID>
    cuentaCargo_Debito = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)   ;* MADM
    monto_debito = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
*    AF = FT.LOCAL.REF
*    AV = Y.POS.AUTH.ID

    IF Y.ID.FT.ACLK[1,2] EQ 'FT' THEN
        R.FUNDS.TRANSFER = ''
        ERR.FT = ''
        EB.DataAccess.FRead(FN.FUNDS.TRANSFER, Y.ID.FT.ACLK, R.FUNDS.TRANSFER, F.FUNDS.TRANSFER, ERR.FT)
        IF R.FUNDS.TRANSFER EQ '' THEN
            ERR.FT = ''
            EB.DataAccess.FRead(FN.FUNDS.TRANSFER.HIS, Y.ID.FT.ACLK:";1", R.FUNDS.TRANSFER, F.FUNDS.TRANSFER.HIS, ERR.FT)
        END
        IF R.FUNDS.TRANSFER THEN
            Y.ID.ACLK = R.FUNDS.TRANSFER<FT.Contract.FundsTransfer.LocalRef,Y.POS.AUTH.ID>

            R.AC.LOCKED.EVENTS = ''
            ERR.ACLK = ''
            EB.DataAccess.FRead(FN.AC.LOCKED.EVENTS, Y.ID.ACLK, R.AC.LOCKED.EVENTS, F.AC.LOCKED.EVENTS, ERR.ACLK)
            IF R.AC.LOCKED.EVENTS EQ '' THEN
                ETEXT = "EL REGISTRO: " :Y.ID.ACLK: " NO EXISTE"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END ELSE          ;* MADM INICIA
                diCuenta_Aclk = R.AC.LOCKED.EVENTS<AC.AccountOpening.LockedEvents.LckAccountNumber>
                monto_debito_aclk = R.AC.LOCKED.EVENTS<AC.AccountOpening.LockedEvents.LckLockedAmount>
                IF (cuentaCargo_Debito NE diCuenta_Aclk) THEN
                    ETEXT = "LA CUENTA ES DIFERENTE EN BLOQUEO: " :SQUOTE(Y.ID.ACLK)
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                END
                IF (monto_debito NE monto_debito_aclk) THEN
                    ETEXT = "EL MONTO ES DIFERENTE EN BLOQUEO: " :SQUOTE(Y.ID.ACLK)
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                END
            END     ;* MADM FIN
        END ELSE
            ETEXT = "EL REGISTRO: " :Y.ID.FT.ACLK: " NO EXISTE"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END ELSE
        IF Y.ID.FT.ACLK[1,4] EQ 'ACLK' THEN
            R.AC.LOCKED.EVENTS = ''
            ERR.ACLK = ''
            EB.DataAccess.FRead(FN.AC.LOCKED.EVENTS, Y.ID.FT.ACLK, R.AC.LOCKED.EVENTS, F.AC.LOCKED.EVENTS, ERR.ACLK)
            IF R.AC.LOCKED.EVENTS THEN
                Y.ID.ACLK = Y.ID.FT.ACLK
                diCuenta_Aclk = R.AC.LOCKED.EVENTS<AC.AccountOpening.LockedEvents.LckAccountNumber>       ;* MADM INICIA
                monto_debito_aclk = R.AC.LOCKED.EVENTS<AC.AccountOpening.LockedEvents.LckLockedAmount>
                IF (cuentaCargo_Debito NE diCuenta_Aclk) THEN
                    ETEXT = "LA CUENTA ES DIFERENTE EN BLOQUEO: " :SQUOTE(Y.ID.ACLK)
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                END
                IF (monto_debito NE monto_debito_aclk) THEN
                    ETEXT = "EL MONTO ES DIFERENTE EN BLOQUEO: " :SQUOTE(Y.ID.ACLK)
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                END ;* MADM FIN
            END ELSE
                ETEXT = "EL REGISTRO: " :Y.ID.FT.ACLK: " NO EXISTE"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END
        END
    END

*    OFS.MSG  = "AC.LOCKED.EVENTS,ABC.PRES.POSL"
*    OFS.MSG := "/R/PROCESS//0,"
*    OFS.MSG := Y.USR : "/" : Y.PWD : ","
*    OFS.MSG := Y.ID.ACLK:","

    FUNCT  = "R"
    R.ACLK = ""
    EB.Foundation.OfsBuildRecord(APP.NAME,FUNCT,OFS.PROCESS,OFSVERSION.TRAS.COMER,"",NO.OF.AUTH,Y.ID.ACLK,R.ACLK,OFS.MSG)

    Y.RTN.ERR = ''
    EB.Interface.OfsAddlocalrequest(OFS.MSG, "add", Y.RTN.ERR)

    IF Y.RTN.ERR THEN
        ETEXT = "NO SE PUDO REALIZAR EL DESBLOQUEO DE SALDO: ":Y.RTN.ERR
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

RETURN

*-------------------------------------------------------------------------------
GET.GENERAL.PARAM:
*-------------------------------------------------------------------------------

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GENE.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

* Cambio MADM, Se agregan nuevos parámetros
    LOCATE "OFS.APP.NAME" IN Y.LIST.PARAMS SETTING POS THEN
        APP.NAME = Y.LIST.VALUES<POS>
    END

    LOCATE "OFS.VERSION.TRAS.COMER" IN Y.LIST.PARAMS SETTING POS THEN
        OFSVERSION.TRAS.COMER = Y.LIST.VALUES<POS>
    END

    LOCATE "OFS.NO.OF.AUTH" IN Y.LIST.PARAMS SETTING POS THEN
        NO.OF.AUTH = Y.LIST.VALUES<POS>
    END

    LOCATE "OFS.PROCESS" IN Y.LIST.PARAMS SETTING POS THEN
        OFS.PROCESS = Y.LIST.VALUES<POS>
    END
* Fin MADM

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------
RETURN

END

