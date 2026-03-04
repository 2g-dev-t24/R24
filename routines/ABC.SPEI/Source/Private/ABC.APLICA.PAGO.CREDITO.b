* @ValidationCode : MjotMjA4NjI1NTY3ODpDcDEyNTI6MTc2NzY2NzEzNDUxNDpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2026 23:38:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.APLICA.PAGO.CREDITO
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
    GOSUB INIT
    GOSUB PROCESS

RETURN
INIT:
    Y.TXN.AMT = ''
    Y.ACCOUNT = ''
    Y.AVAIL.BAL = ''
    YPOS.LOCKED.AMT = ''
    YACCT.LOCKED.AMT = ''

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    Y.TXN.AMT = EB.SystemTables.getComi()
    Y.ACCOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    R.ACCOUNT = ''
    Y.FERROR = ''
    ETEXT=''
RETURN
PROCESS:
    
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, Y.ERR.PARAM)
    IF R.ACCOUNT EQ '' THEN
        ETEXT = "La cuenta de cargo no existe"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
*Si la cuenta de cargo es cuenta interna, no validamos el saldo
    IF Y.ACCOUNT[1,3] MATCHES "MXN":@VM:"USD" THEN RETURN
    Y.AVAIL.BAL = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>
    IF Y.AVAIL.BAL LE 0 THEN
        GOSUB ERROR
        RETURN
    END ELSE
        TODAY = EB.SystemTables.getToday()
        AbcSpei.AbcMontoBloqueado(Y.ACCOUNT,YACCT.LOCKED.AMT,TODAY)
        Y.AVAIL.BAL = Y.AVAIL.BAL - YACCT.LOCKED.AMT
*Si el saldo disponible es menor al solicitado se aplica por el monto que tiene
        IF Y.AVAIL.BAL LE 0 THEN
            GOSUB ERROR
        END ELSE
            IF Y.AVAIL.BAL LT Y.TXN.AMT THEN
*                            COMI=Y.AVAIL.BAL
                GOSUB ERROR
                RETURN
            END
        END
    END
    AbcSpei.AbcValPostRest(Y.ACCOUNT)

RETURN
ERROR:
    ETEXT=''
    ETEXT = "51|Saldo Insuficiente|"
    EB.SystemTables.setEtext(ETEXT)
    EB.ErrorProcessing.StoreEndError()
RETURN
**********
END


