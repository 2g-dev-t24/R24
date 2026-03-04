* @ValidationCode : Mjo2NzM3MTAwMjY6Q3AxMjUyOjE3NjkyMDYyMDQxOTc6RWRnYXIgU2FuY2hlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 Jan 2026 16:10:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar Sanchez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcCob

SUBROUTINE ABC.CAL.SDO.NETO(ACCOUNT.ID)

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING AA.Framework
    $USING AA.Interest
    $USING BF.ConBalanceUpdates
    $USING AbcTable
    $USING EB.AbcUtil
    
    GOSUB CONSULTA.RESTRICCIONES
    IF Y.RESTRICCION NE 1 THEN
        GOSUB OBTIENE.SALDO.NETO
        GOSUB OBTIENE.PORC.SALDO.NETO
    END
    
    GOSUB ESCRIBE.LOG

RETURN

***********************
CONSULTA.RESTRICCIONES:
***********************
    yDataLog<-1> = '------START------'
    
    SALDO.NETO = 0
    Y.RESTRICCION = '0'
    FN.ACCOUNT = AbcCob.getFnAccount()
    FN.CUSTOMER = AbcCob.getFnCustomer()
    FN.AA.ARRANGEMENT = AbcCob.getFnAaArrangement()
    FN.AA.INTEREST.ACCRUALS = AbcCob.getFnAaInterestAccruals()
    FN.ABC.ACCT.LCL.FLDS = AbcCob.getFnAbcAcctLclFlds()
    EB.DataAccess.CacheRead(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,YERR)

    CUSTOMER.ID = R.ACCOUNT<AC.AccountOpening.Account.Customer>
    ARRANGEMENT.ID = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
    Y.CATEGORY = R.ACCOUNT<AC.AccountOpening.Account.Category>

    EB.DataAccess.CacheRead(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,YERR)

    Y.POSTING = R.CUSTOMER<ST.Customer.Customer.EbCusPostingRestrict>

    IF Y.POSTING NE 90 THEN
        IF Y.CATEGORY GE 6605 AND Y.CATEGORY LE 6608 THEN
            EB.DataAccess.CacheRead(FN.AA.ARRANGEMENT,ARRANGEMENT.ID,R.AA.ARRANGEMENT,YERR.AA)
            IF R.AA.ARRANGEMENT THEN
                Y.ARR.STATUS = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrArrStatus>
                IF Y.ARR.STATUS NE "CURRENT" THEN
                    Y.RESTRICCION = '1'
                END
            END ELSE
                Y.RESTRICCION = '1'
            END
        END
    END
    ELSE
        Y.RESTRICCION = '1'
    END

RETURN

*******************
OBTIENE.SALDO.NETO:
*******************

    GOSUB OBTIENE.SALDO
    GOSUB OBTIENE.INTERESES.CUENTA
    GOSUB OBTIENE.RET.IMPUESTOS

    SALDO.NETO = 0
    RETENCION.IMPUESTOS = FMT(RETENCION.IMPUESTOS, "R2#20")
    SALDO.NETO = SALDO + INTERESES - RETENCION.IMPUESTOS
    yDataLog<-1> = "Oper SALDO.NETO -> ": SALDO : " + Intereses: " : INTERESES  : " - Retencion Impuestos: " : RETENCION.IMPUESTOS
    
    IF SALDO.NETO THEN
    END ELSE
        SALDO.NETO = 0
    END
    yDataLog<-1> = "SALDO.NETO -> ": SALDO.NETO
RETURN

**************
OBTIENE.SALDO:
**************

    Y.CATEGORY = R.ACCOUNT<AC.AccountOpening.Account.Category>

    IF Y.CATEGORY GE 6605 AND Y.CATEGORY LE 6608 THEN
        FN.EB.CONTRACT.BALANCES = AbcCob.getFnEbContractBalances()
        EB.DataAccess.CacheRead(FN.EB.CONTRACT.BALANCES,ACCOUNT.ID,R.EB.CONTRACT.BALANCES,YERR)
        LIST.TYPE.SYSDATE = R.EB.CONTRACT.BALANCES<BF.ConBalanceUpdates.EbContractBalances.EcbTypeSysdate>
        LIST.OPEN.BALANCE = R.EB.CONTRACT.BALANCES<BF.ConBalanceUpdates.EbContractBalances.EcbOpenBalance>
        LIST.CREDIT.MVMT = R.EB.CONTRACT.BALANCES<BF.ConBalanceUpdates.EbContractBalances.EcbCreditMvmt>

        CONVERT @VM TO @FM IN LIST.TYPE.SYSDATE
        CONVERT @VM TO @FM IN LIST.OPEN.BALANCE
        CONVERT @VM TO @FM IN LIST.CREDIT.MVMT

        FINDSTR 'TOTCOMMITMENT' IN LIST.TYPE.SYSDATE SETTING YPOSICION THEN
            IF LIST.OPEN.BALANCE<YPOSICION> NE '' THEN
                SALDO = LIST.OPEN.BALANCE<YPOSICION>
            END ELSE
                SALDO = LIST.CREDIT.MVMT<YPOSICION>
            END
        END

        FINDSTR 'EXPACCOUNT' IN LIST.TYPE.SYSDATE SETTING YPOSICION THEN
            IF LIST.OPEN.BALANCE<YPOSICION> NE '' THEN
                SALDO += LIST.OPEN.BALANCE<YPOSICION>
            END
        END
    END ELSE
        SALDO = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>
    END
   
    yDataLog<-1> = "SALDO: " : SALDO : " CUSTOMER: " : CUSTOMER.ID :  " CUENTA: ":  ACCOUNT.ID : " CATEG: " : Y.CATEGORY

    IF (Y.CATEGORY GE 5000) AND (Y.CATEGORY LE 5010) THEN
        SALDO = '0'
        RETURN
    END

    IF SALDO THEN
    END ELSE
        SALDO = '0'
    END

RETURN

*************************
OBTIENE.INTERESES.CUENTA:
*************************

    ARRANGEMENT.ID = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>

    IF NOT(ARRANGEMENT.ID) THEN
        INTERESES = R.ACCOUNT<AC.AccountOpening.Account.AccrCrAmount,1> + R.ACCOUNT<AC.AccountOpening.Account.AccrCrTwoAmount,1>
    END ELSE
        GOSUB OBTIENE.INTERESES.ARR
    END

RETURN

**********************
OBTIENE.INTERESES.ARR:
**********************

    EB.DataAccess.CacheRead('F.TSA.SERVICE','COB',R.TSA.SERVICE,YERR)
    Y.COB.STATUS = R.TSA.SERVICE<EB.Service.TsaService.TsTsmServiceControl>

    INTERESES.ARR.POST = 0
    AA.INTEREST.ACCRUALS.ID = ARRANGEMENT.ID : '-DEPOSITINT'

    EB.DataAccess.CacheRead(FN.AA.INTEREST.ACCRUALS,AA.INTEREST.ACCRUALS.ID,R.AA.INTEREST.ACCRUALS,YERR)

    NO.OF.REC = DCOUNT(R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccTotAccrAmt>,@VM)
    NO.OF.REC.DAYS = DCOUNT(R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccDays>,@VM)

    IF R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccFromDate,1,1>[1,6] GT EB.SystemTables.getToday()[1,6] THEN
        INTERESES.ARR.POST = R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccAccrualAmt,1,1>
        Y.TASA = R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccRate,2,1>
    END ELSE
        Y.TASA = R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccRate,1,1>
    END

    IF Y.COB.STATUS EQ 'STOP' AND R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccPeriodStart,NO.OF.REC+1> EQ EB.SystemTables.getToday() THEN
        INTERESES.ARR = 0
        DIAS.ARR = 0
        Y.ULTIMO.CORTE = ""
    END ELSE
        INTERESES.ARR = R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccTotAccrAmt,NO.OF.REC> - R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccTotRpyAmt,NO.OF.REC> - INTERESES.ARR.POST
        Y.ULTIMO.CORTE = R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccPeriodStart,NO.OF.REC>

        IF NO.OF.REC EQ 1 THEN
            DIAS.ARR = 0
            FOR NO.DAYS = 1 TO NO.OF.REC.DAYS
                DIAS.ARR += R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccDays,NO.DAYS,1>
                Y.ULTIMO.CORTE = ""
            NEXT NO.DAYS
        END ELSE
            DIAS.ARR = 0
            FOR NO.DAYS = 1 TO NO.OF.REC.DAYS
                DIAS.ARR += R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccDays,NO.DAYS,1>
                IF R.AA.INTEREST.ACCRUALS<AA.Interest.InterestAccruals.IntAccFromDate,NO.DAYS> EQ Y.ULTIMO.CORTE THEN
                    NO.DAYS = NO.OF.REC.DAYS
                END
            NEXT NO.DAYS
        END
    END

    yDataLog<-1> = "INTERESES ARR: " : INTERESES.ARR

    INTERESES = INTERESES.ARR

RETURN

**********************
OBTIENE.RET.IMPUESTOS:
**********************

    ARRANGEMENT.ID = ''
    Y.ACCR.CR.AMOUN = 0
    Y.ACCR.CR2.AMO = 0
    Y.INTERES = 0
    CUSTOMER.ID = ''

    ARRANGEMENT.ID = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
    Y.ACCR.CR.AMOUN = R.ACCOUNT<AC.AccountOpening.Account.AccrCrAmount>
    Y.ACCR.CR2.AMO = R.ACCOUNT<AC.AccountOpening.Account.AccrCrTwoAmount>
    Y.INTERES = Y.ACCR.CR.AMOUN + Y.ACCR.CR2.AMO
    CUSTOMER.ID = R.ACCOUNT<AC.AccountOpening.Account.Customer>
    
    GOSUB OBTIENE.NO.DIAS     ;*
    yDataLog<-1> = "DIAS.PLAZO: " : Y.NO.DIAS

    IF ARRANGEMENT.ID THEN
        AA.Framework.GetArrangementConditions(ARRANGEMENT.ID,"TERM.AMOUNT",idProperty,effectiveDate,returnIds,returnConditions,returnError)
        IF returnConditions NE '' THEN
            returnConditions = RAISE(returnConditions)
            CAPITAL = returnConditions<3>
        END
        yDataLog<-1> = "ACCOUNT: ": ACCOUNT.ID : " ARR.ID: ": ARRANGEMENT.ID
        yDataLog<-1> = "CAPITAL AA: " : CAPITAL
    END ELSE
        IF Y.INTERES EQ 0 THEN
            CAPITAL = 0
        END ELSE
            CAPITAL = SALDO.PROMEDIO
        END
        yDataLog<-1> = "CAPITAL: " : CAPITAL
    END

    VAL.POR.RET = AbcCob.getValPorRet()
    VAL.POR.RET.INV = AbcCob.getValPorRetInv()
    Y.DIAS.CALC = AbcCob.getYDiasCalc()

    IF VAL.POR.RET EQ '' THEN
        VAL.POR.RET = 0
    END

    IF VAL.POR.RET.INV EQ '' THEN
        VAL.POR.RET.INV = 0
    END

    IF Y.NO.DIAS EQ '' THEN
        Y.NO.DIAS = 0
    END

    IF ARRANGEMENT.ID EQ "" THEN
        RETENCION.IMPUESTOS = ((CAPITAL * (VAL.POR.RET/100)) / Y.DIAS.CALC) * (Y.NO.DIAS)
    END ELSE
        RETENCION.IMPUESTOS = ((CAPITAL * (VAL.POR.RET.INV/100)) / Y.DIAS.CALC) * (Y.NO.DIAS)
    END
    yDataLog<-1> = "TAX: " : VAL.POR.RET.INV : " DIAS.CALC: " : Y.DIAS.CALC : " DIAS.PLAZO: " : Y.NO.DIAS
    yDataLog<-1> = "RETENCION IMP: " : RETENCION.IMPUESTOS

    GOSUB OBTIENE.SUJETO.RET

    IF RESULT EQ 'N' THEN
        RETENCION.IMPUESTOS = 0
    END

RETURN

****************
OBTIENE.NO.DIAS:
****************

    ARRANGEMENT.ID = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>

    IF NOT(ARRANGEMENT.ID) THEN
        GOSUB OBTIENE.SALDO.PROMEDIO
    END ELSE
        Y.NO.DIAS = DIAS.ARR
    END

RETURN

***********************
OBTIENE.SALDO.PROMEDIO:
***********************

    FECHA.INI = AbcCob.getFechaIni()
    FECHA.FIN = AbcCob.getFechaFin()
    SALDO.PROMEDIO = 0

    Y.NO.DIAS = 0

    IF NOT(RUNNING.UNDER.BATCH) THEN
        FECHA.INI.SP = EB.SystemTables.getToday()[1,6]:'01'
        FECHA.FIN.SP = EB.SystemTables.getToday()
    END ELSE
        FECHA.INI.SP = FECHA.INI
        FECHA.FIN.SP = FECHA.FIN
    END

    AbcCob.abcSaldoPromedioIpab(ACCOUNT.ID,FECHA.INI.SP,FECHA.FIN.SP,SALDO.PROMEDIO,Y.NO.DIAS)

    IF SALDO.PROMEDIO THEN
        SALDO.PROMEDIO = FMT(SALDO.PROMEDIO, "R2#20")
    END ELSE
        SALDO.PROMEDIO = 0
    END

RETURN

*******************
OBTIENE.SUJETO.RET:
*******************
    
    RESULT = 'S'

    POS.EXENTO.IVA = AbcCob.getPosExentoIva()
    Y.EXENTO.IMPUESTO = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,POS.EXENTO.IVA>
   
    IF Y.EXENTO.IMPUESTO EQ 'YES' THEN
        RESULT = 'N'
    END
    yDataLog<-1> = "POS.EXENTO.IVA: ": POS.EXENTO.IVA
    yDataLog<-1> = 'EXENTO.IMPUESTO: ' : Y.EXENTO.IMPUESTO : ' PAGA IMPUESTO: ': RESULT
RETURN

************************
OBTIENE.PORC.SALDO.NETO:
************************

    IF ARRANGEMENT.ID THEN
        Y.SALDO.NETO = SALDO.NETO
        Y.ID.SDO.COMP = CUSTOMER.ID
        GOSUB GUARDA.REGISTRO
*    END ELSE
        EB.DataAccess.CacheRead(FN.ABC.ACCT.LCL.FLDS,ARRANGEMENT.ID,R.ABC.ACCT.LCL.FLDS,YERR.LCL)
        Y.PORCENTAJE.TITULAR = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.TitPorc>
        Y.ID.COTITULARES = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.IdCoti>
        Y.PORCENTAJE.COTITULARES = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.AsigIntCoti>
        IF Y.PORCENTAJE.TITULAR NE '' AND Y.ID.COTITULARES NE '' AND Y.PORCENTAJE.COTITULARES NE '' THEN
            yDataLog<-1> =  'Entre Cotitular'
            CHANGE @SM TO @FM IN Y.ID.COTITULARES
            CHANGE @SM TO @FM IN Y.PORCENTAJE.COTITULARES
            
            Y.NUM.COTITUL = DCOUNT(Y.ID.COTITULARES, @FM)
            yDataLog<-1> = ' Y.NUM.COTITUL: ' : Y.NUM.COTITUL
            Y.SALDO.NETO = (SALDO.NETO * Y.PORCENTAJE.TITULAR) / 100
            yDataLog<-1> = 'Y.SALDO.NETO.TITULAR PORC: ' : Y.SALDO.NETO
            
            GOSUB GUARDA.REGISTRO

            FOR X = 1 TO Y.NUM.COTITUL
                Y.PORC.COTITULAR = 0
                Y.ID.COTITULAR = ''
                SALDO.NETO.COTITULAR = 0
                Y.PORC.COTITULAR = Y.PORCENTAJE.COTITULARES<X>
                Y.ID.COTITULAR = Y.ID.COTITULARES<X>
                Y.SALDO.NETO = (SALDO.NETO * Y.PORC.COTITULAR) / 100
                yDataLog<-1> = 'Y.PORC.COTITULAR: ': Y.PORC.COTITULAR : 'ID: ' : X
                Y.ID.SDO.COMP = Y.ID.COTITULAR
                yDataLog<-1> = 'Y.ID.COTITULAR: ': Y.ID.COTITULAR
                yDataLog<-1> = 'Y.SALDO.NETO.COTITULAR: ': Y.SALDO.NETO : 'ID: ' : X
                GOSUB GUARDA.REGISTRO
            NEXT X
        END
    END

RETURN

****************
GUARDA.REGISTRO:
****************
    yDataLog<-1> = "SALDO.NETO: " : Y.SALDO.NETO
    FN.ABC.SDO.COMP.IPAB = AbcCob.getFnAbcSdoCompIpab()
    F.ABC.SDO.COMP.IPAB = AbcCob.getFAbcSdoCompIpab()
    R.SDO.COMP = ''
    R.SDO.COMP = AbcTable.AbcSdoCompIpab.Read(Y.ID.SDO.COMP,ERROR.SDO.COMP)
*    EB.DataAccess.FReadu(FN.ABC.SDO.COMP.IPAB,Y.ID.SDO.COMP,R.SDO.COMP,F.ABC.SDO.COMP.IPAB,ERROR.SDO.COMP,'')
    IF R.SDO.COMP NE '' THEN
        Y.SDO.NETO.TOTAL = R.SDO.COMP<AbcTable.AbcSdoCompIpab.SaldoNeto>
        yDataLog<-1> = 'Y.SDO.NETO.TOTAL.ANT:  ': Y.SDO.NETO.TOTAL
        IF Y.SDO.NETO.TOTAL EQ '' THEN
            Y.SDO.NETO.TOTAL = Y.SALDO.NETO
        END ELSE
            yDataLog<-1> = 'Y.SDO.NETO.TOTAL PREV SUMA:  ' :Y.SDO.NETO.TOTAL
            Y.SDO.NETO.TOTAL += Y.SALDO.NETO
            yDataLog<-1> = 'Y.SDO.NETO.TOTAL RESULT SUMA:  ' :Y.SDO.NETO.TOTAL
        END
        yDataLog<-1> = 'Y.SDO.NETO.TOTAL DATO QUE SE ESCRIBE:  ' :Y.SDO.NETO.TOTAL
        R.SDO.COMP<AbcTable.AbcSdoCompIpab.SaldoNeto> = Y.SDO.NETO.TOTAL
        AbcTable.AbcSdoCompIpab.Write(Y.ID.SDO.COMP,R.SDO.COMP)
    END
    
RETURN
****************
ESCRIBE.LOG:
****************
    yDataLog<-1> = '------END------'
    
    yRtnName = 'ABC.CAL.SDO.NETO'
    EB.AbcUtil.abcEscribeLogGenerico(yRtnName, yDataLog)
RETURN

END
