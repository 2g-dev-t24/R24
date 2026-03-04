* @ValidationCode : MjotMTAzNTkxMTAyOTpDcDEyNTI6MTc2MzY0OTI1MjAxMDpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Nov 2025 11:34:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
SUBROUTINE ABC.2BR.CHK.LIMAMT.ACCT(ACCOUNT.ID,TRANS.AMT,MSGTEXT)
*--------------------------------*
* This subroutine is called from the routine VPM.2BR.CHK.LIMAMT.DR
* and the routine used in the CECOBAN PROCESSING
* Checks if trans amt>ONLINE LIMIT AMT if limi present
* for debit account and stops the transacion if greater.
* if no limit give override messages (3) if trans amt > working
* balance
*
* Incoming:
* ---------
*
*   ACCOUNT.ID  -  Account ID to be analyzed
*   TRANS.AMT   -  Transaction Amount
*
* Outgoing:
* ---------
*
*   MSGTEXT     -  Transaction result, empty if transaction is OK.
*
* Error Variables:
* ----------------

    $USING AC.AccountOpening
    $USING LI.Config
    $USING FT.Contract
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
******
    GOSUB INIT
    IF ACCOUNT.ID EQ '' THEN RETURN
    GOSUB PROCESS

RETURN
******
INIT:
******
*
    FN.ACCOUNT = "F.ACCOUNT"
    FV.ACCOUNT = ""
    EB.DataAccess.Opf(FN.ACCOUNT,FV.ACCOUNT)
    
    FN.LIMIT = 'F.LIMIT'
    FV.LIMIT = ''
    EB.DataAccess.Opf(FN.LIMIT,FV.LIMIT)
    
    FN.TELLER = 'F.TELLER'
    FV.TELLER = ''
    EB.DataAccess.Opf(FN.TELLER,FV.TELLER)
    
    FN.TELLER.TRANS = 'F.TELLER.TRANSACTION'
    FV.TELLER.TRANS = ''
    EB.DataAccess.Opf(FN.TELLER.TRANS,FV.TELLER.TRANS)

    ST.FLAG = ''
    Y.FLG   = ''
    MSGTEXT = ''
    ETEXT   = ''
    APPLICATION = EB.SystemTables.getApplication()

RETURN
**********
PROCESS:
**********

    EB.DataAccess.FRead(FN.ACCOUNT,ACCOUNT.ID,ACCOUNT.REC,FV.ACCOUNT,ACC.ERR)
    LIMIT.REFERENCE = ACCOUNT.REC<AC.AccountOpening.Account.LimitRef>

    IF ACCOUNT.REC<AC.AccountOpening.Account.OpenValDatedBal> THEN
        AC.WRK.BAL.START.OF.TOD = ACCOUNT.REC<AC.AccountOpening.Account.OpenValDatedBal>
    END ELSE
        AC.WRK.BAL.START.OF.TOD = ACCOUNT.REC<AC.AccountOpening.Account.OpenActualBal>
    END
*------------------
* Fgv  Jan/27/2007 End
*------------------
    IF AC.WRK.BAL.START.OF.TOD = '' THEN AC.WRK.BAL.START.OF.TOD = 0
    LOCATE EB.SystemTables.getToday() IN ACCOUNT.REC<AC.AccountOpening.Account.AvailableDate,1> SETTING TOD.POS THEN
        TOD.AVAIL.BAL = ACCOUNT.REC<AC.AccountOpening.Account.AvAuthCrMvmt,TOD.POS> + AC.WRK.BAL.START.OF.TOD
        IF ACCOUNT.REC<AC.AccountOpening.Account.AvAuthDbMvmt,TOD.POS> THEN
            SUM.OF.AUTH.DB = ACCOUNT.REC<AC.AccountOpening.Account.AvAuthDbMvmt,TOD.POS>
        END ELSE
            SUM.OF.AUTH.DB = 0
        END
        IF ACCOUNT.REC<AC.AccountOpening.Account.AvNauDbMvmt,TOD.POS> THEN
            SUM.OF.NAU.DB = ACCOUNT.REC<AC.AccountOpening.Account.AvNauDbMvmt,TOD.POS>
        END ELSE
            SUM.OF.NAU.DB = 0
        END
        SUM.OF.DEBIT.TRANS.TOD = SUM.OF.AUTH.DB + SUM.OF.NAU.DB
        DIFF.IN.ACBAL = TOD.AVAIL.BAL + SUM.OF.DEBIT.TRANS.TOD
    END ELSE
        YWORK.BAL.ACCT = ACCOUNT.REC<AC.AccountOpening.Account.WorkingBalance>
        DIFF.IN.ACBAL = YWORK.BAL.ACCT
    END
    ETEXT = '' = MSGTEXT = ''
    IF LIMIT.REFERENCE NE '' AND DIFF.IN.ACBAL < 0 THEN
        CUSTOMER.ID = ACCOUNT.REC<AC.AccountOpening.Account.Customer>
        LIM.REF.VAR = FIELD(LIMIT.REFERENCE,".",1)
        LIM.REF.SEQ = FIELD(LIMIT.REFERENCE,".",2)
        LIMIT.REF.VAR1 = FMT(LIM.REF.VAR,"7'0'R")
        LIMIT.ID = CUSTOMER.ID:".":LIMIT.REF.VAR1:".":LIM.REF.SEQ
        EB.DataAccess.FRead(FN.LIMIT,LIMIT.ID,LIMIT.REC,FV.LIMIT,LIMIT.ERR)
        IF LIMIT.REC<LI.Config.LiExpiryDate> GE EB.SystemTables.getToday() THEN
            AVAIL.AMT = LIMIT.REC<LI.Config.Limit.OnlineLimit,1>
            YWORK.BAL.ACCT = ACCOUNT.REC<AC.AccountOpening.Account.WorkingBalance>
            IF AVAIL.AMT + YWORK.BAL.ACCT < 0 THEN
                IF APPLICATION EQ 'TELLER' THEN
        
                    EB.SystemTables.setAf(TT.Contract.Teller.TeAmountLocalOne)
                END ELSE
                    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
                       
                        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAmount)
                    END
                END
                MSGTEXT = 'Monto es mayor al disponible'
                RETURN
            END
        END ELSE
            AVAIL.AMT = ACCOUNT.REC<AC.AccountOpening.Account.WorkingBalance>
            IF TRANS.AMT > AVAIL.AMT AND Y.FLG = '' THEN
                IF APPLICATION EQ 'TELLER' THEN
                    EB.SystemTables.setAf(TT.Contract.Teller.TeAmountLocalOne)
                END ELSE
                    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
                        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAmount)
                    END
                END
                MSGTEXT = 'Monto es mayor al disponible'
                Y.FLG = "A"
                RETURN
            END
        END
    END ELSE
        IF DIFF.IN.ACBAL < 0 AND Y.FLG = '' THEN
            IF APPLICATION EQ 'TELLER' THEN
                EB.SystemTables.setAf(TT.Contract.Teller.TeAmountLocalOne)
            END ELSE
                IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
                    EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAmount)
                END
            END
            MSGTEXT = 'Monto es mayor al disponible'
            Y.FLG = "A"
            RETURN
        END
    END

RETURN
******

END

