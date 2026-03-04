* @ValidationCode : MjoxNjQ2MDk4NjcxOkNwMTI1MjoxNzY1NDU4NzQ1MjY0Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Dec 2025 10:12:25
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

SUBROUTINE ABC.2BR.RECIBE.DATA

*-----------------------------------------------------------------------------

    $USING TT.Contract
    $USING TT.Config
    $USING EB.DataAccess
    $USING ST.Config
    $USING EB.SystemTables
    $USING EB.Display
    $USING ST.CurrencyConfig
    $USING AbcTeller
    $USING EB.Updates
    
    $USING EB.Browser
    
    ARREGLO.AVIABLE = AbcTeller.getarregloAviable()
    LINK.DATA       = ARREGLO.AVIABLE
    PGM.VERSION     = EB.SystemTables.getPgmVersion()

    IF LINK.DATA<9> NE "" THEN
        F.TELLER.TRANSACTION = ""
        FN.TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
        EB.DataAccess.Opf(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

        F.TRANSACTION = ""
        FN.TRANSACTION = "F.TRANSACTION"
        EB.DataAccess.Opf(FN.TRANSACTION,F.TRANSACTION)

        Y.TRAN.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)
        Y.TELL.TRAN.REG = ''
        EB.DataAccess.FRead(FN.TELLER.TRANSACTION, Y.TRAN.ID, Y.TELL.TRAN.REG, F.TELLER.TRANSACTION, Y.ERR.TT)
        
        IF (Y.TELL.TRAN.REG) THEN
            Y.TXN.1 = Y.TELL.TRAN.REG<TT.Config.TellerTransaction.TrTransactionCodeOne>
            Y.CAT.1 = Y.TELL.TRAN.REG<TT.Config.TellerTransaction.TrCatDeptCodeOne>
            Y.TXN.2 = Y.TELL.TRAN.REG<TT.Config.TellerTransaction.TrTransactionCodeTwo>
            Y.CAT.2 = Y.TELL.TRAN.REG<TT.Config.TellerTransaction.TrCatDeptCodeTwo>

            READ Y.TRAN.REG FROM F.TRANSACTION, Y.TXN.1 THEN
                Y.TIPO.1 = Y.TRAN.REG<ST.Config.Transaction.AcTraDebitCreditInd>
            END

            IF Y.TIPO.1 EQ "DEBIT" THEN
                Y.CAT.DEBIT = Y.CAT.1
                Y.CAT.CREDIT = Y.CAT.2
            END ELSE
                Y.CAT.DEBIT = Y.CAT.2
                Y.CAT.CREDIT = Y.CAT.1
            END
        END

        IF PGM.VERSION EQ ",ABC.2BR.EM.TILLCONCEN.BOV" THEN
            EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdOne,LINK.DATA<8>)
            Y.CTA.DEBIT = LINK.DATA<10>:Y.CAT.DEBIT:LINK.DATA<8>
            Y.CTA.CREDIT = LINK.DATA<10>:Y.CAT.CREDIT:"0001"
            Y.ID.SOL = '.':LINK.DATA<7>
        END ELSE
            IF PGM.VERSION EQ ",ABC.2BR.EM.TILLDOTACION.BOV" THEN
                Y.CTA.DEBIT = LINK.DATA<10>:Y.CAT.DEBIT:"0001"
                Y.CTA.CREDIT = LINK.DATA<6>
                Y.CAT.CREDIT = LINK.DATA<6>
                Y.ID.SOL = ',':LINK.DATA<7>
            END ELSE
                IF PGM.VERSION EQ ",ABC.2BR.EM.TILLDOTACION.1.BOV" THEN
                    Y.CTA.DEBIT = LINK.DATA<10>:Y.CAT.DEBIT:"0001"
                    Y.CTA.CREDIT = LINK.DATA<10>:Y.CAT.CREDIT:LINK.DATA<8>
                    Y.ID.SOL = LINK.DATA<7>:'.'
                END ELSE
                    IF PGM.VERSION EQ ",ABC.2BR.EM.TILLCONCEN.1.BOV" THEN
                        Y.CTA.CREDIT = LINK.DATA<10>:Y.CAT.CREDIT:"0001"
                        Y.CTA.DEBIT = LINK.DATA<6>
                        IF LINK.DATA<6> = "MXN100009999" THEN
                            Y.CAT.DEBIT = 10000
                        END ELSE
                            Y.CAT.DEBIT = LINK.DATA<6>
                        END
                        Y.ID.SOL = LINK.DATA<7>:','
                    END ELSE
                        IF PGM.VERSION EQ ",ABC.2BR.EM.TILLDOTACION.BOV.INT" THEN
                            Y.CTA.DEBIT = LINK.DATA<10>:Y.CAT.DEBIT:"0001"
                            Y.CTA.CREDIT = LINK.DATA<6>
                            Y.CAT.CREDIT = "10000"
                            Y.ID.SOL = LINK.DATA<7>
                        END
                    END
                END
            END
        END
        
        EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountOne,Y.CTA.DEBIT)
        EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountTwo,Y.CTA.CREDIT)
        
        EB.SystemTables.setRNew(TT.Contract.Teller.TeCurrencyOne,LINK.DATA<10>)

        IF LINK.DATA<10> EQ "MXN" THEN
            EB.SystemTables.setRNew(TT.Contract.Teller.TeAmountLocalOne,LINK.DATA<11>)
        END ELSE
            F.CURRENCY = ""
            FN.CURRENCY = "F.CURRENCY"
            EB.DataAccess.Opf(FN.CURRENCY,F.CURRENCY)
            
            Y.CURR.ID       = LINK.DATA<10>
            Y.REG.CURRENCY  = ''
            EB.DataAccess.FRead(FN.CURRENCY, Y.CURR.ID, Y.REG.CURRENCY, F.CURRENCY, Y.ERR.CU)
        
            IF (Y.REG.CURRENCY) THEN
                CURR.RATE   = Y.REG.CURRENCY<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
                Y.TOTAL = DCOUNT(CURR.RATE, @VM)
                Y.TC = CURR.RATE<1, Y.TOTAL>
                Y.MONTO.FCY = LINK.DATA<11>
                Y.AM.LOC.ONE = (Y.MONTO.FCY * Y.TC)
                EB.SystemTables.setRNew(TT.Contract.Teller.TeAmountLocalOne,Y.AM.LOC.ONE)
            END

            EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountOne,"")
            EB.SystemTables.setRNew(TT.Contract.Teller.TeAmountFcyOne,LINK.DATA<11>)
        END
        
        tmp = EB.SystemTables.getT(TT.Contract.Teller.TeCurrencyOne)
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(TT.Contract.Teller.TeCurrencyOne, tmp)
        

        tmp = EB.SystemTables.getT(TT.Contract.Teller.TeAmountLocalOne)
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(TT.Contract.Teller.TeAmountLocalOne, tmp)
        

        tmp = EB.SystemTables.getT(TT.Contract.Teller.TeAmountFcyOne)
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(TT.Contract.Teller.TeAmountFcyOne, tmp)
        
        Y.DEN = LINK.DATA<13>
        Y.CAN = LINK.DATA<14>

        CONVERT "|" TO @FM IN Y.DEN
        CONVERT "|" TO @FM IN Y.CAN
        
        TT.DR.DENOM = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrDenom)
        TT.DR.UNIT  = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)
        
        TT.DENOM    = EB.SystemTables.getRNew(TT.Contract.Teller.TeDenomination)
        TT.UNIT     = EB.SystemTables.getRNew(TT.Contract.Teller.TeUnit)

        FOR Y.CONT = 1 TO LINK.DATA<12>
            IF Y.CAT.DEBIT EQ 10000 THEN
                TT.DR.DENOM<1,Y.CONT> = Y.DEN<Y.CONT>
                TT.DR.UNIT<1,Y.CONT> = Y.CAN<Y.CONT>
            END ELSE
                IF Y.CAT.DEBIT NE 10000 THEN
                    TT.DR.DENOM<1,Y.CONT> = Y.DEN<Y.CONT>
					TT.DR.UNIT<1,Y.CONT> = Y.CAN<Y.CONT>
                END
            END
            IF Y.CAT.CREDIT EQ 10000 THEN
                TT.DENOM<1,Y.CONT> = Y.DEN<Y.CONT>
                TT.UNIT<1,Y.CONT> = Y.CAN<Y.CONT>
            END ELSE
                IF Y.CAT.CREDIT NE 10000 THEN
                    TT.DENOM<1,Y.CONT> = Y.DEN<Y.CONT>
					TT.UNIT<1,Y.CONT> = Y.CAN<Y.CONT>
                END
            END
            EB.SystemTables.setRNew(TT.Contract.Teller.TeDrDenom, TT.DR.DENOM)
            EB.SystemTables.setRNew(TT.Contract.Teller.TeDrUnit, TT.DR.UNIT)
        
            EB.SystemTables.setRNew(TT.Contract.Teller.TeDenomination, TT.DENOM)
            EB.SystemTables.setRNew(TT.Contract.Teller.TeUnit, TT.UNIT)
        
        NEXT Y.CONT

        IF PGM.VERSION EQ ",ABC.2BR.EM.TILLCONCEN.1.BOV" THEN
            tmp = EB.SystemTables.getT(TT.Contract.Teller.TeDrUnit)
            tmp<3>="NOINPUT"
            EB.SystemTables.setT(TT.Contract.Teller.TeDrUnit, tmp)
        END

        EB.Updates.MultiGetLocRef("TELLER", "GRAN.TOTAL", Y.POS)
        TT.LOCAL.REF    = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
        Y.MONTO.GRAN.TOTAL  = LINK.DATA<11>
        Y.MONTO.GRAN.TOTAL  = Y.MONTO.GRAN.TOTAL<1,1,1>
        Y.MONTO.GRAN.TOTAL  = FIELDS(Y.MONTO.GRAN.TOTAL," ",1)
        TT.LOCAL.REF<1,Y.POS> = Y.MONTO.GRAN.TOTAL * 1
        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)

        Y.ID.SALIDA = ''
        Y.ID.SALIDA = LINK.DATA<7>
        Y.SU.REF    = ''
        EB.SystemTables.setRNew(TT.Contract.Teller.TeOurReference,Y.ID.SOL)
        Y.SU.REF = LINK.DATA<5>

        LINK.DATA = ""
        ARREGLO.AVIABLE = ''

        LINK.DATA<1> = Y.ID.SALIDA
        IF Y.CAT.DEBIT EQ 10000 THEN
            LINK.DATA<3> = Y.CTA.DEBIT
        END
        IF Y.CAT.CREDIT EQ 10000 THEN
            LINK.DATA<4> = Y.CTA.CREDIT
        END
        CONVERT @FM TO "|" IN Y.DEN
        CONVERT @FM TO "|" IN Y.CAN
        LINK.DATA<5> = Y.DEN
        LINK.DATA<6> = Y.CAN
        LINK.DATA<7> = Y.SU.REF
        ARREGLO.AVIABLE = LINK.DATA
        AbcTeller.setarregloAviable(ARREGLO.AVIABLE)
        
        CONVERT @FM TO "*" IN LINK.DATA
        Y.VAR.NAME = 'CURRENT.LINK.DATA'
        EB.Browser.SystemSetvariable(Y.VAR.NAME,LINK.DATA)
        
    END

    EB.Display.RebuildScreen()

RETURN
**************
END

