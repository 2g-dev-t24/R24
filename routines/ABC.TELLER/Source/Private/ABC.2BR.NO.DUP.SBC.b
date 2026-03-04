*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.2BR.NO.DUP.SBC

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
*----------------------------
* Main Program Loop
*----------------------------
    IF EB.SystemTables.getVFunction() EQ "R" THEN RETURN

    GOSUB INITIALIZE
    GOSUB VALIDATE
    RETURN
*----------------------------
VALIDATE:
*----------------------------

    Y.LIST = ""; Y.NO = ""; Y.STATUS = ""
    IF EB.SystemTables.getPgmVersion() EQ ",ABC.CUADRE.CHQS" THEN
        Y.SELECT.CMD = "SELECT ":FN.TELLER:" WITH TRANSACTION.CODE EQ '16' AND CURRENCY.1 EQ 'MXN' AND TELLER.ID.1 EQ ":DQUOTE(YTELLER.ID)
    END ELSE
        IF EB.SystemTables.getPgmVersion() EQ ",ABC.2BR.CUADRE.CHQS.USD" THEN
            Y.SELECT.CMD = "SELECT ":FN.TELLER:" WITH TRANSACTION.CODE EQ '16' AND CURRENCY.1 EQ 'USD' AND TELLER.ID.1 EQ ":DQUOTE(YTELLER.ID)
        END ELSE
            Y.SELECT.CMD = "SELECT ":FN.TELLER:" WITH TRANSACTION.CODE EQ ":DQUOTE(16)  ;* ITSS - SINDHU - Added DQUOTE
        END
    END
    EB.DataAccess.Readlist(Y.SELECT.CMD,Y.LIST,"",Y.NO,Y.STATUS)
    IF Y.NO THEN
        E = "Cierre SBC ya fue realizado"
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    RETURN
*----------------------------
INITIALIZE:
*----------------------------
    FN.TELLER = "F.TELLER"
    F.TELLER  = ""
    EB.DataAccess.Opf(FN.TELLER,F.TELLER)

    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID  = ""
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    Y.OPERATOR = EB.SystemTables.getOperator()

     CMD='SSELECT ':FN.TELLER.ID:' WITH USER EQ ':DQUOTE(Y.OPERATOR)
    YLIST=''; YNO=''; YCO=''
    EB.DataAccess.Readlist(CMD,YLIST,'',YNO,YCO)

    FOR Y.CONT = 1 TO YNO
        YTELLER.ID = YLIST<Y.CONT>
    NEXT Y.CONT

    RETURN
END
