* @ValidationCode : Mjo0MzkyNzA5OTpDcDEyNTI6MTc1OTY5OTY5MzA5NzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Oct 2025 18:28:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcCob

SUBROUTINE ABC.SALDO.PRE.COMPENSADO(CUSTOMER.ID,RESULT,VAL.POR.RET,VAL.POR.RET.INV,FECHA.INI,FECHA.FIN,AC.LOCKED.CUSTOMER.LIST,Y.SEP)

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Updates
    $USING EB.API
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING AA.Framework
    $USING AA.Interest
    $USING BF.ConBalanceUpdates
    $USING AbcTable
    $USING AbcGetGeneralParam

    GOSUB INITIALISATION
    GOSUB GET.SDO.COMPENSADO

    RESULT = UPCASE(TRIM(RESULT,'','D'))

RETURN

***************
INITIALISATION:
***************

    RESULT = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    EB.DataAccess.Opf(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ABC.SECTOR.CNBV = 'F.ABC.SECTOR.CNBV'
    F.ABC.SECTOR.CNBV = ''
    EB.DataAccess.Opf(FN.ABC.SECTOR.CNBV,F.ABC.SECTOR.CNBV)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    EB.DataAccess.Opf(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.AA.INTEREST.ACCRUALS = 'F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS = ''
    EB.DataAccess.Opf(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)

    Y.LOCAL.REF.APP   = 'CUSTOMER'
    Y.LOCAL.REF.FIELD := 'L.TIP.IPAB.GARAN':@VM:'CNBV.SECTOR'
    Y.LOCAL.REF.POS   = ''

    EB.Updates.MultiGetLocRef(Y.LOCAL.REF.APP,Y.LOCAL.REF.FIELD,Y.LOCAL.REF.POS)

    Y.TIP.IPAB.GARAN.POS = Y.LOCAL.REF.POS<1,1>
    Y.SECTOR.CNBV.POS    = Y.LOCAL.REF.POS<1,2>

    Y.ID.GEN.PARAM = 'ABC.BASE.CALCULO.DIAS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'NUM.DIAS' IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.DIAS.CALC = Y.LIST.VALUES<YPOS.PARAM>
    END

RETURN

*******************
GET.SDO.COMPENSADO:
*******************

    EB.DataAccess.CacheRead(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,YERR.CUS)
    IF R.CUSTOMER THEN
        Y.POSTING = R.CUSTOMER<ST.Customer.Customer.EbCusPostingRestrict>
        IF Y.POSTING NE 90 THEN
            GOSUB GET.SALDO.CUENTAS
            PRE.SALDO.COMPENSADO = SALDO.CUENTA
            RESULT = FMT(PRE.SALDO.COMPENSADO, "R2#20"):Y.SEP:CAUSAL.REV
        END
    END

RETURN

******************
GET.SALDO.CUENTAS:
******************

    GOSUB GET.CAUSAL.REV
    GOSUB GET.CUSTOMER.ACCOUNTS

    Y.NO.ACCOUNTS = DCOUNT(R.CUSTOMER.ACCOUNT, @FM)
    ACCOUNT.ID = ''
    SALDO.CUENTA = 0

    FOR i = 1 TO Y.NO.ACCOUNTS

        ACCOUNT.ID = R.CUSTOMER.ACCOUNT<i>

        GOSUB GET.SALDO.NETO

        SALDO.CUENTA += SALDO.NETO

    NEXT i

RETURN

***************
GET.CAUSAL.REV:
***************

    CAUSAL.REV = '0'

    EB.DataAccess.CacheRead(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,YERR)

    Y.TIP.IPAB.GARAN = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,Y.TIP.IPAB.GARAN.POS>
    Y.SECTOR.CNBV    = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,Y.SECTOR.CNBV.POS>

    GOSUB CHECK.LOCKED.EVENTS
    CAUSAL.REV = RESULT

    IF CAUSAL.REV EQ 3 THEN
        RETURN
    END

    IF Y.TIP.IPAB.GARAN <> 'NO' THEN
        ABC.SECTOR.CNBV.ID = Y.SECTOR.CNBV
        EB.DataAccess.CacheRead(FN.ABC.SECTOR.CNBV,ABC.SECTOR.CNBV.ID,R.ABC.SECTOR.CNBV,YERR)
        IF R.ABC.SECTOR.CNBV THEN
            Y.ABC.SECTOR.CNBV.TIPO.IPAB.GAR = R.ABC.SECTOR.CNBV<AbcTable.AbcSectorCnbv.TipoIpabGar>
            IF Y.ABC.SECTOR.CNBV.TIPO.IPAB.GAR <> 'NO' THEN
                CAUSAL.REV = '0'
            END
        END ELSE
            CAUSAL.REV = '0'
        END
    END

RETURN

********************
CHECK.LOCKED.EVENTS:
********************

    LOCATE CUSTOMER.ID IN AC.LOCKED.CUSTOMER.LIST SETTING POS THEN
        RESULT = '3'
    END ELSE
        RESULT = '1'
    END

RETURN

**********************
GET.CUSTOMER.ACCOUNTS:
**********************

    CUSTOMER.ACCOUNT.ID = CUSTOMER.ID

    SELECT.STATEMENT  = 'SELECT ' : FN.ACCOUNT : ' WITH CUSTOMER EQ ' : DQUOTE(CUSTOMER.ACCOUNT.ID)

    ACCOUNT.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''

    EB.DataAccess.Readlist(SELECT.STATEMENT,R.CUSTOMER.ACCOUNT,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

RETURN

***************
GET.SALDO.NETO:
***************

    SALDO = 0
    INTERESES = 0
    RETENCION.IMPUESTOS = 0
    SALDO.NETO = 0
    Y.TASA = 0
    Y.NO.DIAS = 0
    Y.ULTIMO.CORTE = ''
    MENSAJE = ''
    GOSUB GET.SALDO
    IF Y.FLAG EQ "1" THEN
        GOSUB GET.INTERESES.CUENTA
        GOSUB GET.RET.IMPUESTOS
        SALDO.NETO = 0
        SALDO.NETO = SALDO + INTERESES - RETENCION.IMPUESTOS
        MENSAJE = CUSTOMER.ID:Y.SEP:ACCOUNT.ID:Y.SEP:ARRANGEMENT.ID:Y.SEP:SALDO:Y.SEP:INTERESES:Y.SEP:RETENCION.IMPUESTOS:Y.SEP:SALDO.NETO:Y.SEP:Y.NO.DIAS:Y.SEP:Y.TASA:Y.SEP:Y.ULTIMO.CORTE
    END

    IF SALDO.NETO THEN
        RESULT = FMT(SALDO.NETO, "R2#20")
    END ELSE
        RESULT = 0
    END

RETURN

**********
GET.SALDO:
**********

    EB.DataAccess.CacheRead(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,YERR)

    Y.CATEGORIES.MATCH  = "1002" : @VM : "1004" : @VM : "1006" : @VM : "6001"
    Y.CATEGORIES.MATCH := "6002" : @VM : "6605" : @VM : "6606" : @VM : "6607" : @VM : "6608"
    Y.FLAG = "1"
    Y.CATEGORY = R.ACCOUNT<AC.AccountOpening.Account.Category>
    ARRANGEMENT.ID = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>

    IF Y.CATEGORY MATCHES Y.CATEGORIES.MATCH THEN
        IF Y.CATEGORY GE 6605 AND Y.CATEGORY LE 6608 THEN

            EB.DataAccess.CacheRead(FN.AA.ARRANGEMENT,ARRANGEMENT.ID,R.AA.ARRANGEMENT,YERR.AA)
            IF R.AA.ARRANGEMENT THEN
                Y.ARR.STATUS = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrArrStatus>
                IF Y.ARR.STATUS NE "CURRENT" THEN
                    Y.FLAG = "0"
                    RETURN
                END
            END ELSE
                Y.FLAG = "0"
                RETURN
            END
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
        END ELSE
            SALDO = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>
        END
    END

    IF SALDO THEN
        RESULT = FMT(SALDO, "R2#20")
    END ELSE
        RESULT = '0'
        SALDO = '0'
    END

RETURN

*********************
GET.INTERESES.CUENTA:
*********************

    IF NOT(ARRANGEMENT.ID) THEN
        INTERESES = R.ACCOUNT<AC.AccountOpening.Account.AccrCrAmount,1> + R.ACCOUNT<AC.AccountOpening.Account.AccrCrTwoAmount,1>
        RESULT = FMT(INTERESES, "R2#20")
    END ELSE
        GOSUB GET.INTERESES.ARR
    END

RETURN

******************
GET.INTERESES.ARR:
******************

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

    Y.NO.DIAS = DIAS.ARR
    INTERESES = INTERESES.ARR
    RESULT = FMT(INTERESES.ARR, "R2#20")

RETURN

******************
GET.RET.IMPUESTOS:
******************

    Y.ACCR.CR.AMOUN = 0
    Y.ACCR.CR2.AMO = 0
    Y.INTERES = 0

    Y.ACCR.CR.AMOUN = R.ACCOUNT<AC.AccountOpening.Account.AccrCrAmount>
    Y.ACCR.CR2.AMO = R.ACCOUNT<AC.AccountOpening.Account.AccrCrTwoAmount>
    Y.INTERES = Y.ACCR.CR.AMOUN + Y.ACCR.CR2.AMO

    IF ARRANGEMENT.ID THEN
        AA.Framework.GetArrangementConditions(ARRANGEMENT.ID,"TERM.AMOUNT",idProperty,effectiveDate,returnIds,returnConditions,returnError)
        IF returnConditions NE '' THEN
            returnConditions = RAISE(returnConditions)
            CAPITAL = returnConditions<3>
        END
    END ELSE
        GOSUB GET.SALDO.PROMEDIO
        IF Y.INTERES EQ 0 THEN
            CAPITAL = 0
        END ELSE
            CAPITAL = RESULT
        END
    END
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

    RESULT = FMT(RETENCION.IMPUESTOS, "R2#20")

RETURN

*******************
GET.SALDO.PROMEDIO:
*******************

    SALDO.PROMEDIO = 0

    Y.NO.DIAS = 0

    GOSUB OBTIENE.FECHAS.SAL.PROM

    AbcCob.abcSaldoPromedioIpab(ACCOUNT.ID,FECHA.INI.AUX,FECHA.FIN.AUX,SALDO.PROMEDIO,Y.NO.DIAS)

    IF SALDO.PROMEDIO THEN
        RESULT = FMT(SALDO.PROMEDIO, "R2#20")
    END ELSE
        RESULT = 0
    END

RETURN

************************
OBTIENE.FECHAS.SAL.PROM:
************************

    FECHA.INI.AUX = FECHA.INI
    FECHA.FIN.AUX = FECHA.FIN

    EB.API.Cdt('',FECHA.FIN.AUX,'+1W')

    IF FECHA.INI.AUX[1,6] NE FECHA.FIN.AUX[1,6] THEN FECHA.INI.AUX = FECHA.FIN.AUX

RETURN

END
