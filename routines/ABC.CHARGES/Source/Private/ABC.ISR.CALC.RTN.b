$PACKAGE AbcCharges

SUBROUTINE ABC.ISR.CALC.RTN(CHARGE.PROPERTY, R.PROPERTY.RECORD, BASE.AMOUNT, CHARGE.AMOUNT)
*-----------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.API
    $USING EB.SystemTables
    $USING AA.Interest
    $USING AA.Framework
    $USING AbcGetGeneralParam

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*---------------------------------------------------
INITIALIZE:
*---------------------------------------------------
    CHARGE.AMOUNT = 0
    
    ACCOUNT.BALANCE = 0
    PERIOD.START = ''
    PERIOD.END = ''
    DIAS.TRANSCURRIDOS = 0
    ISR.TASA = 0
    BASE.CALCULO = 365
    
    TODAY = EB.SystemTables.getToday()
    
RETURN

*---------------------------------------------------
OPEN.FILES:
*---------------------------------------------------
    
    FN.AA.INT.ACCR = 'F.AA.INTEREST.ACCRUALS'
    F.AA.INT.ACCR = ''
    EB.DataAccess.Opf(FN.AA.INT.ACCR, F.AA.INT.ACCR)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    EB.DataAccess.Opf(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)

RETURN

*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    ARRANGEMENT.ID = AA.Framework.getArrId()
    
    IF ARRANGEMENT.ID EQ '' THEN
        CHARGE.AMOUNT = 0
        RETURN
    END
    
    ACCOUNT.REF = AA.Framework.getLinkedAccount()
    
    IF ACCOUNT.REF EQ '' THEN
        CHARGE.AMOUNT = 0
        RETURN
    END

    GOSUB GET.SYSTEM.PARAMETERS

    IF ISR.TASA EQ 0 THEN
        CHARGE.AMOUNT = 0
        RETURN
    END
        
    GOSUB GET.INTEREST.PERIOD
    
    IF PERIOD.START EQ '' OR PERIOD.END EQ '' THEN
        CHARGE.AMOUNT = 0
        RETURN
    END

    IF ACCOUNT.BALANCE EQ 0 THEN
        CHARGE.AMOUNT = 0
        RETURN
    END
    
    GOSUB CALCULATE.DAYS
    
    IF DIAS.TRANSCURRIDOS EQ 0 THEN
        CHARGE.AMOUNT = 0
        RETURN
    END

    GOSUB CALCULATE.ISR

RETURN

*---------------------------------------------------
GET.SYSTEM.PARAMETERS:
*---------------------------------------------------

    EB.DataAccess.FRead(FN.AA.ARRANGEMENT, ARRANGEMENT.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, Y.ARR.ERR)
    Y.PROD.LINE = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrProductLine>
    IF Y.PROD.LINE EQ 'ACCOUNTS' THEN
        AA.INT.ID = ARRANGEMENT.ID : '-CRINTEREST'
        Y.ID.PARAM = 'ABC.ISR.CALC.ACCOUNTS'
    END
    ELSE
        AA.INT.ID = ARRANGEMENT.ID : '-DEPOSITINT'
        Y.ID.PARAM = 'ABC.ISR.CALC.DEPOSITS'
    END

    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE 'ISR.TASA' IN Y.LIST.PARAMS SETTING Y.POS THEN
        ISR.TASA = Y.LIST.VALUES<Y.POS>
        IF ISR.TASA GT 1 THEN
            ISR.TASA = ISR.TASA / 100
        END
    END
    
    LOCATE 'ISR.DAY.BASIS' IN Y.LIST.PARAMS SETTING Y.POS THEN
        BASE.CALCULO = Y.LIST.VALUES<Y.POS>
    END

RETURN

*---------------------------------------------------
GET.INTEREST.PERIOD:
*---------------------------------------------------
    
    R.AA.INT = ''
    INT.ERR = ''
    
    EB.DataAccess.CacheRead(FN.AA.INT.ACCR, AA.INT.ID, R.AA.INT, INT.ERR)
    
    IF NOT(INT.ERR) AND R.AA.INT NE '' THEN
        NO.OF.PERIODS = DCOUNT(R.AA.INT<AA.Interest.InterestAccruals.IntAccPeriodStart>, @VM)
        NO.OF.REC.DAYS = DCOUNT(R.AA.INT<AA.Interest.InterestAccruals.IntAccDays>, @VM)
        
        IF NO.OF.REC.DAYS GT 0 THEN 
            ACCOUNT.BALANCE = R.AA.INT<AA.Interest.InterestAccruals.IntAccBalance, NO.OF.REC.DAYS, 1>
        END
        
        IF NO.OF.PERIODS GT 0 THEN
            PERIOD.START = R.AA.INT<AA.Interest.InterestAccruals.IntAccPeriodStart, NO.OF.PERIODS>
            PERIOD.END = R.AA.INT<AA.Interest.InterestAccruals.IntAccPeriodEnd, NO.OF.PERIODS>
        END
    END

RETURN

*---------------------------------------------------
CALCULATE.DAYS:
*---------------------------------------------------
    
    IF PERIOD.START NE '' AND PERIOD.END NE '' THEN
        DIAS.TRANSCURRIDOS = 'C'
        EB.API.Cdd('', PERIOD.START, PERIOD.END, DIAS.TRANSCURRIDOS)
    END
    ELSE
        DIAS.TRANSCURRIDOS = 0
    END

RETURN

*---------------------------------------------------
CALCULATE.ISR:
*---------------------------------------------------
    
    IF BASE.CALCULO GT 0 THEN
        Y.DIV = DIAS.TRANSCURRIDOS / BASE.CALCULO
        CHARGE.AMOUNT = (ACCOUNT.BALANCE * ISR.TASA) * Y.DIV
    END ELSE
        CHARGE.AMOUNT = 0
    END

RETURN

END