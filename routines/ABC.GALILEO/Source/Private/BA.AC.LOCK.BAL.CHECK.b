*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
    SUBROUTINE BA.AC.LOCK.BAL.CHECK
*----------------------------------------------------------------

    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING AbcAccount
    $USING EB.ErrorProcessing


    YIN.CUENTA = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckAccountNumber)
    YIN.MONTO = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLockedAmount)
    YIN.COMISION = 0
    YOUT = ''

    PGM.VERSION = EB.SystemTables.getPgmVersion()

    IF PGM.VERSION EQ ",BA.POS.LOCK.ACT" THEN
        YOLD.AMT = EB.SystemTables.getROld(AC.AccountOpening.LockedEvents.LckLockedAmount)

        IF YIN.MONTO GT YOLD.AMT THEN
            YIN.MONTO = YIN.MONTO - YOLD.AMT
        END ELSE
            RETURN
        END
    END

    AbcAccount.SapCheckBalCashWthd(YIN.CUENTA,YIN.MONTO,YIN.COMISION,YOUT)

    IF YOUT NE '' THEN
        EB.SystemTables.setEtext(YOUT)
        EB.ErrorProcessing.StoreEndError()
    END


    RETURN
END
