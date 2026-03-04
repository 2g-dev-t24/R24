* @ValidationCode : MjotMTEyMzgwNTY5OTpDcDEyNTI6MTc2NzY3MDQyMTMwNTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Jan 2026 00:33:41
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

$PACKAGE AbcTeller

SUBROUTINE ABC.V.ACCT.CCY
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING TT.Contract
    $USING EB.Updates
    $USING AbcTeller
    $USING EB.ErrorProcessing
    $USING AC.AccountOpening
    $USING AbcSpei
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    ID.NEW      = EB.SystemTables.getIdNew()
    MESSAGE     = EB.SystemTables.getMessage()
    COMI        = EB.SystemTables.getComi()
    APPLICATION = EB.SystemTables.getApplication()
    PGM.VERSION = EB.SystemTables.getPgmVersion()
    
    GOSUB GET.LOCAL.REF.POSITIONS
    TT.TE.LOCAL.REF     = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    YMULTI.TELLER.ID = FIELD(ID.NEW,"-",2) * 1

    IF ((YMULTI.TELLER.ID = 1) AND (MESSAGE <> 'VAL') AND (MESSAGE <> 'RET')) OR ((YMULTI.TELLER.ID > 1) AND (MESSAGE = 'VAL')) THEN

        DRAW.CHQ.NO         = TT.TE.LOCAL.REF<1,Y.DRAW.CHQ.NO>
        DRAW.BANK           = TT.TE.LOCAL.REF<1,Y.DRAW.BANK>
        DRAW.ACCT.NO        = TT.TE.LOCAL.REF<1,Y.DRAW.ACCT.NO>
        TT.TE.ACCOUNT.2     = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
        TT.TE.CURRENCY.1    = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)
        TT.TE.AMOUNT.LOCAL.1    = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
        
        IF NOT(DRAW.CHQ.NO) OR NOT(DRAW.BANK) OR NOT(DRAW.ACCT.NO) OR (NOT(TT.TE.ACCOUNT.2) AND (NOT(COMI))) OR NOT(TT.TE.CURRENCY.1) OR NOT(TT.TE.AMOUNT.LOCAL.1) THEN
            EB.SystemTables.setAf(TT.Contract.Teller.TeAccountTwo)
            TEXT = "Debe ingresar todos los valores"
            EB.SystemTables.setText(TEXT)
            EB.Display.Rem()
*            CALL TRANSACTION.ABORT
            MESSAGE = "RET"
            EB.SystemTables.setMessage(MESSAGE)
            RETURN
        END
    END
    AbcTeller.Bam2brValCheckDup()
    Y.E = EB.SystemTables.getE()

    IF Y.E THEN
*        CALL TRANSACTION.ABORT

        MESSAGE = "REPEAT"
        EB.SystemTables.setMessage(MESSAGE)
        EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountTwo , "")
        FIELD.TO.REF    = TT.Contract.Teller.TeAccountTwo
        ENRI.TO.REF     = ''
        EB.Display.RefreshField(FIELD.TO.REF,ENRI.TO.REF)
        Y.E = EB.SystemTables.getE()
        ETEXT = Y.E
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

    YR.ACCOUNT = COMI
    Y.ID.ACCT = COMI

    R.ACC.VAL = AC.AccountOpening.Account.Read(YR.ACCOUNT, ER.ACC)
    YR.BAL = R.ACC.VAL<AC.AccountOpening.Account.OnlineClearedBal>
    Y.CUSTOMER = R.ACC.VAL<AC.AccountOpening.Account.Customer>

    COMI = Y.CUSTOMER
    EB.SystemTables.setComi(COMI)
    MSG = EB.SystemTables.getMessage()
    AbcSpei.abcVCustomerName(COMI, COMI.ENRI,MSG)
    
    TT.TE.LOCAL.REF<1,Y.DRAW.CUST.NAME> = COMI.ENRI
    COMI = YR.ACCOUNT
    EB.SystemTables.setComi(COMI)

    TT.TE.LOCAL.REF<1,Y.CLEARED.BAL> = YR.BAL
    
    tmp = EB.SystemTables.getT(TT.Contract.Teller.TeCurrencyTwo)
    tmp<3>=""
    tmp<3>="NOINPUT"
    EB.SystemTables.setT(TT.Contract.Teller.TeCurrencyTwo, tmp)
    
    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.TE.LOCAL.REF)

    EB.Display.RebuildScreen()

    IF APPLICATION EQ "TELLER" AND PGM.VERSION[1,8] EQ ",ABC.CC." THEN
        AbcSpei.AbcCcCheckCustnoDr()
        Y.E = EB.SystemTables.getE()
        IF Y.E THEN
            COMI = ""
            EB.SystemTables.setComi(COMI)
        END
    END

    IF PGM.VERSION EQ ",ABC.CHQDEPT+1" THEN
        AbcSpei.AbcValPostRest(Y.ID.ACCT)
        AbcTeller.AbcTraeDatosLectora(Y.ID.ACCT)
    END

RETURN
*-----------------------------------------------------------------------------
GET.LOCAL.REF.POSITIONS:
*-----------------------------------------------------------------------------
    Y.APP       = "TELLER"
    Y.FLD       = "DRAW.CHQ.NO" :@VM: "DRAW.BANK" :@VM: "DRAW.ACCT.NO" :@VM: "DRAW.CUST.NAME" :@VM: "CLEARED.BAL"
    Y.POS.FLD   = ''
    EB.Updates.MultiGetLocRef(Y.APP, Y.FLD, Y.POS.FLD)
    
    Y.DRAW.CHQ.NO    = Y.POS.FLD<1,1>
    Y.DRAW.BANK      = Y.POS.FLD<1,2>
    Y.DRAW.ACCT.NO   = Y.POS.FLD<1,3>
    Y.DRAW.CUST.NAME = Y.POS.FLD<1,4>
    Y.CLEARED.BAL    = Y.POS.FLD<1,5>
    
RETURN
*-----------------------------------------------------------------------------
END