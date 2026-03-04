* @ValidationCode : Mjo5MTkzNzM4NTY6Q3AxMjUyOjE3NTgwMzEwNDc3OTM6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Sep 2025 10:57:27
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
* <Rating>584</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.2BR.CHK.LIMAMT

*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING EB.Display
    $USING AC.AccountOpening
    $USING LI.Config
    $USING FT.Contract
    $USING TT.Config
    $USING TT.Contract
    $USING EB.OverrideProcessing

    GOSUB INIT
    GOSUB PROCESS

RETURN
*****
INIT:
*****
    ACCOUNT.ID  = ''
    ST.FLAG     = ''
    TODAY       = EB.SystemTables.getToday()
    APPLICATION = EB.SystemTables.getApplication()

RETURN
********
PROCESS:
********
    IF APPLICATION EQ 'TELLER' THEN
        TRANS.AMT   = EB.SystemTables.getRNew(TT.Contract.Teller.TeNetAmount)
        TRANS.CODE  = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)
        TRANS.IND   = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrCrMarker)
        
        IF TRANS.IND EQ 'CREDIT' THEN
            TT.ACCOUNT2 = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
            IF NUM(TT.ACCOUNT2) THEN
                ACCOUNT.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
            END
        END
        IF TRANS.IND EQ 'DEBIT' THEN
            TT.ACCOUNT1 = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
            IF NUM(TT.ACCOUNT1) THEN
                ACCOUNT.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
            END
        END
    END

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        TRANS.AMT   = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
        ACCOUNT.ID  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    END

    IF ACCOUNT.ID NE '' THEN
        ACCOUNT.REC = AC.AccountOpening.Account.Read(ACCOUNT.ID, ACC.ERR)
        
        LIMIT.REFERENCE = ACCOUNT.REC<AC.AccountOpening.Account.LimitRef>
        AC.WRK.BAL.START.OF.TOD = ACCOUNT.REC<AC.AccountOpening.Account.ValueDatedBal>
        
        IF AC.WRK.BAL.START.OF.TOD = '' THEN
            AC.WRK.BAL.START.OF.TOD = 0
        END
    
        AC.AVAILABLE.DATE = RAISE(ACCOUNT.REC<AC.AccountOpening.Account.AvailableDate>)
        LOCATE TODAY IN AC.AVAILABLE.DATE SETTING TOD.POS THEN
            TOD.AVAIL.BAL           = ACCOUNT.REC<AC.AccountOpening.Account.AvAuthCrMvmt,TOD.POS> + AC.WRK.BAL.START.OF.TOD
            SUM.OF.DEBIT.TRANS.TOD  = ACCOUNT.REC<AC.AccountOpening.Account.AvAuthDbMvmt,TOD.POS> + ACCOUNT.REC<AC.AccountOpening.Account.AvNauDbMvmt,TOD.POS>
            DIFF.IN.ACBAL           = TOD.AVAIL.BAL + SUM.OF.DEBIT.TRANS.TOD
        END
        
        IF LIMIT.REFERENCE NE '' AND DIFF.IN.ACBAL < 0 THEN
            CUSTOMER.ID     = ACCOUNT.REC<AC.AccountOpening.Account.Customer>
            LIM.REF.VAR     = FIELD(LIMIT.REFERENCE,".",1)
            LIM.REF.SEQ     = FIELD(LIMIT.REFERENCE,".",2)
            LIMIT.REF.VAR1  = FMT(LIM.REF.VAR,"7'0'R")
            LIMIT.ID        = CUSTOMER.ID:".":LIMIT.REF.VAR1:".":LIM.REF.SEQ
           
            LIMIT.REC = LI.Config.Limit.Read(LIMIT.ID, LIMIT.ERR)
           
            LI.EXPIRY.DATE = LIMIT.REC<LI.Config.LiExpiryDate>
            IF LI.EXPIRY.DATE GE TODAY THEN
                AVAIL.AMT = LIMIT.REC<LI.Config.Limit.OnlineLimit,1>
                
                IF APPLICATION EQ 'TELLER' THEN
                    EB.SystemTables.setAf(TT.Contract.Teller.TeAccountOne)
                END ELSE
                    EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAmount)
                END
                
                IF TRANS.AMT GT AVAIL.AMT THEN
                    ETEXT = 'TRANSACTION AMOUNT GREATER THAN THE AVAILABLE AMOUNT'
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            
            END ELSE
                AVAIL.AMT = ACCOUNT.REC<AC.AccountOpening.Account.WorkingBalance>
                
                IF TRANS.AMT GT AVAIL.AMT AND ST.FLAG EQ '' THEN
                    
                    CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride),@VM)
                    
                    TEXT = "CUENTA NO TIENE SALDO SUFICIENTE"
                    EB.SystemTables.setText(TEXT)
                    CURR.NO = CURR.NO + 1
                    EB.OverrideProcessing.StoreOverride(CURR.NO)
                    
                    TEXT = "CUENTA NO TIENE LINEA DE SOBREGIRO ASOCIADA"
                    EB.SystemTables.setText(TEXT)
                    CURR.NO = CURR.NO + 1
                    EB.OverrideProcessing.StoreOverride(CURR.NO)
                    
                    TEXT = "TRANSACCION REQUIERE AUTORIZACION ESPECIAL"
                    EB.SystemTables.setText(TEXT)
                    CURR.NO = CURR.NO + 1
                    EB.OverrideProcessing.StoreOverride(CURR.NO)
                    
                    ST.FLAG = 'Y'
                    RETURN
                END
            END

        END ELSE
            AVAIL.AMT = ACCOUNT.REC<AC.AccountOpening.Account.WorkingBalance>
            
            IF DIFF.IN.ACBAL LT 0 AND ST.FLAG EQ '' THEN
                CURR.NO = DCOUNT(EB.SystemTables.getRNew(TT.Contract.Teller.TeOverride),@VM)
                
                TEXT = "EXCESS AMOUNT"
                EB.SystemTables.setText(TEXT)
                CURR.NO = CURR.NO + 1
                EB.OverrideProcessing.StoreOverride(CURR.NO)
                
                TEXT = "CUENTA NO TIENE LINEA DE SOBREGIRO ASOCIADA"
                EB.SystemTables.setText(TEXT)
                CURR.NO = CURR.NO + 1
                EB.OverrideProcessing.StoreOverride(CURR.NO)
                
                TEXT = "TRANSACCION REQUIERE AUTORIZACION ESPECIAL"
                EB.SystemTables.setText(TEXT)
                CURR.NO = CURR.NO + 1
                EB.OverrideProcessing.StoreOverride(CURR.NO)
                
                ST.FLAG = 'Y'
                RETURN
            END
        END
    END

RETURN
**********
END

