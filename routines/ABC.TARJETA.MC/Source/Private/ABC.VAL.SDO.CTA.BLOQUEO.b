* @ValidationCode : Mjo3NzgwOTk1MjY6Q3AxMjUyOjE3Njc2NjcyNzkxOTA6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2026 23:41:19
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
$PACKAGE AbcTarjetaMc
*-----------------------------------------------------------------------------
SUBROUTINE ABC.VAL.SDO.CTA.BLOQUEO
*======================================================================================
* Nombre de Programa : ABC.VAL.SDO.CTA.BLOQUEO
* Objetivo           : Rutina que valida que el saldo disponible de la cuenta sea suficiente
*                      para realizar el bloqueo
*======================================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING AC.AccountOpening
    $USING AbcSpei

    Y.FUNCTION = EB.SystemTables.getVFunction()
    IF Y.FUNCTION EQ 'I' THEN
        GOSUB INICIALIZA
        GOSUB VALIDA.SALDO
    END

RETURN

***********
INICIALIZA:
***********

    FN.ACCOUNT = 'F.ACCOUNT' ; F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    Y.MONTO.BLOQUEO = ''
    Y.CUENTA = ''
    Y.SALDO.DISPONIBLE = ''
    Y.LOCKED.AMOUNT = ''
    Y.WORKING.BALANCE = ''

RETURN

*************
VALIDA.SALDO:
*************
    Y.MONTO.BLOQUEO = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLockedAmount)
    Y.CUENTA = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckAccountNumber)
    EB.DataAccess.FRead(FN.ACCOUNT, Y.CUENTA, R.CUENTA, F.ACCOUNT, Y.ERR)

    IF NOT(R.CUENTA) THEN
        Y.SALDO.DISPONIBLE = 0
    END ELSE
        TODAY = EB.SystemTables.getToday()
        AbcSpei.AbcMontoBloqueado(Y.CUENTA,Y.LOCKED.AMOUNT,TODAY)

        Y.WORKING.BALANCE = R.CUENTA<AC.AccountOpening.Account.WorkingBalance>
        Y.SALDO.DISPONIBLE = Y.WORKING.BALANCE - Y.LOCKED.AMOUNT
    END

    IF Y.SALDO.DISPONIBLE < Y.MONTO.BLOQUEO THEN
        EB.SystemTables.setAf(AC.AccountOpening.LockedEvents.LckLockedAmount)
        ETEXT = "Saldo insuficiente"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

RETURN

END
