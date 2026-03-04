*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------

    SUBROUTINE ABC.2BR.DESINHIBE.LECTOR

*-----------------------------------------------------------------------------

    $USING TT.Contract
    $USING AC.AccountOpening
    $USING EB.Updates
    $USING EB.Display
    $USING EB.DataAccess
    $USING EB.API
    $USING EB.SystemTables

    Y.MSG = ""
    Y.SV = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeNarrativeOne),@SM)
    FOR I = 1 TO Y.SV
        Y.MSG := EB.SystemTables.getRNew(TT.Contract.Teller.TeNarrativeOne)<1,1,I>
    NEXT I
    LOOP
    WHILE Y.MSG DO
        XX    = INDEX(Y.MSG,";;",1)
        CAMPO = Y.MSG[1,XX-1]
        YY       = INDEX(CAMPO,"=",1)
        FIELD.NO = CAMPO[1,YY-1]
        FIELD.XX = CAMPO[1,YY-1]
        SS.ID    = "TELLER"
        DATOS    = CAMPO[YY+1,-1]
* de donde sale esto
        EB.API.FindFieldNo(SS.ID, FIELD.NO)

        IF NOT(FIELD.NO) THEN
            EB.Updates.MultiGetLocRef("TELLER",FIELD.XX, Y.POS)
            IF FIELD.XX = "DRAW.BANK" THEN
                DATOS = FMT(DATOS,"LZ")
            END
            Y.DATOS<1,Y.POS> = DATOS
            EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, Y.DATOS)
        END ELSE
*            R.NEW(FIELD.NO) = DATOS
        END
        IF XX THEN
            Y.MSG = Y.MSG[XX+2,-1]
        END ELSE
            Y.MSG = ''
        END
    REPEAT

 
    EB.SystemTables.setRNew(TT.Contract.Teller.TeNarrativeOne, "")

    GOSUB VAL.CTA
    EB.Display.RebuildScreen()


    RETURN
*************
ORIGINAL.SUB:
*************
    tmp=EB.SystemTables.getTLocref()
    EB.Updates.MultiGetLocRef("TELLER","DRAW.CHQ.NO", Y.POS)
    tmp<Y.POS,7> = ""
    EB.Updates.MultiGetLocRef("TELLER","DRAW.ACCT.NO", Y.POS)
    tmp<Y.POS,7> = ""
    EB.Updates.MultiGetLocRef("TELLER","DRAW.BANK", Y.POS)
    tmp<Y.POS,7> = ""
    EB.SystemTables.setTLocref(tmp)
    tmp<3>=""
    EB.SystemTables.setT(TT.Contract.Teller.TeAmountLocalOne, tmp)
    EB.SystemTables.setT(TT.Contract.Teller.TeAccountOne, tmp)
    EB.SystemTables.setT(TT.Contract.Teller.TeAccountTwo, tmp)
    EB.SystemTables.setT(TT.Contract.Teller.TeChequeNumber, tmp)
    IF EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne) NE "MXN" THEN
        EB.SystemTables.setT(TT.Contract.Teller.TeAmountFcyOne, tmp)
    END

    EB.SystemTables.setT(TT.Contract.Teller.TeCurrencyOne, tmp)

    RETURN
********
VAL.CTA:
********

    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    EB.DataAccess.Opf(FN.ACC,F.ACC)

    FN.ACC.ALT = 'F.ALTERNATE.ACCOUNT'
    F.ACC.ALT = ''
    EB.DataAccess.Opf(FN.ACC.ALT,F.ACC.ALT)

    Y.CTA.CHQ = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)

    READ REC.CTA FROM F.ACC, Y.CTA.CHQ THEN
        ID.ACC.CLI = Y.CTA.CHQ
        Y.CUSTOMER = REC.CTA<AC.AccountOpening.Account.Customer>
    END ELSE
        READ REC.ACC.ALT FROM F.ACC.ALT, Y.CTA.CHQ THEN
            ID.ACC.CLI = REC.ACC.ALT<AC.AccountOpening.AlternateAccount.AacGlobusAcctNumber>

            EB.DataAccess.FRead(FN.ACC,ID.ACC.CLI,R.ACC,F.ACC,ERR.ACC)
            Y.CUSTOMER = R.ACC<AC.AccountOpening.Account.Customer>

            EB.Updates.MultiGetLocRef("TELLER","DRAW.ACCT.NO", Y.POS.ACCT.NO)
            TT.LOCAL.REF<1,Y.POS.ACCT.NO> = Y.CTA.CHQ
            EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF<1,Y.POS.ACCT.NO>)
            
        END
    END

    SAVE.AMOUNT = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
    SAVE.COMI = EB.SystemTables.getComi()
    COMI = ID.ACC.CLI
    AbcTeller.VGicAcctCcy()
    COMI = SAVE.COMI

    EB.SystemTables.setRNew(TT.Contract.Teller.TeCustomerOne, Y.CUSTOMER)
    EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountOne, ID.ACC.CLI)
    EB.SystemTables.setRNew(TT.Contract.Teller.TeAmountLocalOne, SAVE.AMOUNT)
    tmp<3>="NOINPUT"
    EB.SystemTables.setT(TT.Contract.Teller.TeAmountLocalOne, tmp)
    
    RETURN
*******
PRUEBA:
*******

    FN.TELL.DEN = 'F.TELLER.DENOMINATION'
    F.TELL.DEN = ''
    EB.DataAccess.Opf(FN.TELL.DEN,F.TELL.DEN)

    CMD.SEL.DEN = "SELECT ":FN.TELL.DEN:" WITH @ID LIKE ":DQUOTE(SQUOTE("MXN"):"..."):" BY-DSND VALUE"  ; *ITSS-NYADAV - Added DQUOTE / SQUOTE
    YLIST.DEN = "" ; YNO.DEN = 0 ; YCO.DEN = ""
    EB.DataAccess.Readlist(CMD.SEL.DEN,YLIST.DEN,"",YNO.DEN,YCO.DEN)

    FOR YNO.YLIST.DEN = 1 TO YNO.DEN
        ID.TELL.DEN = FIELD(YLIST.DEN,FM,YNO.YLIST.DEN)
        Y.DENOMINATION<1,YNO.YLIST.DEN> = ID.TELL.DEN
        EB.SystemTables.setRNew(TT.Contract.Teller.TeDenomination, Y.DENOMINATION<1,YNO.YLIST.DEN>)
        Y.UNIT<1,YNO.YLIST.DEN> = 0
        EB.SystemTables.setRNew(TT.Contract.Teller.TeUnit, Y.UNIT<1,YNO.YLIST.DEN>)
        Y.DR.DENOM<1,YNO.YLIST.DEN> = ID.TELL.DEN
        EB.SystemTables.setRNew(TT.Contract.Teller.TeDrDenom, Y.DR.DENOM<1,YNO.YLIST.DEN>)
        Y.DR.UNIT<1,YNO.YLIST.DEN> = 0
        EB.SystemTables.setRNew(TT.Contract.Teller.TeDrUnit, Y.DR.UNIT<1,YNO.YLIST.DEN>)

    NEXT YNO.YLIST.DEN

    AbcTeller.AbcV2ttGetTellerIdOne()
    AbcTeller.AbcV2ttGetTellerId2()

    RETURN
**********
END






