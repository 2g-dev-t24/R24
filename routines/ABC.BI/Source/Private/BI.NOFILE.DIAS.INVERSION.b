*-----------------------------------------------------------------------------
$PACKAGE AbcBi
*-----------------------------------------------------------------------------
    SUBROUTINE BI.NOFILE.DIAS.INVERSION(YOUT)
*----------------------------------------------------------------------------- 
* Creado por     : 
* Fecha          : 
* Descripcion    : Enquiry Nofile para consultar los numeros de dias permitidos
*                  en la apertura de inversiones, en base al tipo de tasa y grupo
*                  del cliente.
*----------------------------------------------------------------------------- 


    $USING EB.Display
    $USING EB.Reports
    $USING EB.DataAccess
    $USING AbcTable

    
    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()

    BASIC.INT = ''
    LOCATE 'BASIC.INT.KEY' IN SEL.FIELDS<1> SETTING POSITION THEN
        BASIC.INT = SEL.VALUES<POSITION>
    END ELSE
        RETURN
    END

    CUST.CLASS = ''
    LOCATE 'CUST.CLASS' IN SEL.FIELDS<1> SETTING POSITION THEN
        CUST.CLASS = SEL.VALUES<POSITION>
    END ELSE
        RETURN
    END

    GOSUB OPEN.FILES
    GOSUB INITIALISE
    GOSUB PROCESS

    IF E NE '' THEN
        ENQ.ERROR = E
        TEXT = E
        EB.Display.Rem();
        *EB.Reports.setEnqError(ENQ.ERROR)
    END
    RETURN

*---------
PROCESS:
*---------

    Y.LIST = ''
    Y.CNT = ''
    Y.ERR = ''
     SEL.CMD = "SELECT ":FN.ABC.2LN.DEPOSIT.RATES:" WITH @ID LIKE ":DQUOTE(SQUOTE(Y.ID.BASIC.INT):"...":SQUOTE(LCCY:Y.CUST.CLASS.ID)):" BY-DSND @ID"  ; * ITSS - TEJASHWINI - Added DQUOTE / SQUOTE
    EB.DataAccess.Readlist(SEL.CMD,Y.LIST,'',Y.CNT,Y.ERR)

    IF Y.LIST NE '' THEN
        READ Y.REC.TASAS FROM F.ABC.2LN.DEPOSIT.RATES, Y.LIST<1> THEN
            FOR I=1 TO DCOUNT(Y.REC.TASAS<AbcTable.Abc2lnDepositRates.DayPeriod>,@VM)

                IF FIELD(Y.REC.TASAS<AbcTable.Abc2lnDepositRates.DayPeriod>,@VM,I) EQ 'R' THEN CONTINUE

                Y.VET.TAB.VAL = FMT(FIELD(Y.REC.TASAS<AbcTable.Abc2lnDepositRates.DayPeriod>,@VM,I),"3'0'R")
                Y.VET.TAB.REM = FIELD(Y.REC.TASAS<AbcTable.Abc2lnDepositRates.DayPeriod>,@VM,I):" DIAS"
                Y.DATA<-1> = Y.VET.TAB.VAL:'*':Y.VET.TAB.REM:'*':Y.MONTO.MIN
            NEXT I

            YOUT = Y.DATA
        END ELSE
            YOUT = ''
            E = 'ERR.3 NO EXISTEN PLAZOS PARA LA TASA'
            RETURN
        END
    END

    RETURN

*----------
INITIALISE:
*----------
    E = ''
    Y.DATA = ''
    Y.CUST.CLASS.ID = CUST.CLASS
    Y.REC.TASAS = ''
    Y.VET.TAB.VAL = ''
    Y.VET.TAB.REM = ''
    Y.VAL.DIAS = ''

    Y.ID.BASIC.INT = BASIC.INT
    Y.REC.PARAM = ''
    Y.MONTO.MIN = ''

    READ Y.REC.PARAM FROM F.ABC.CLUB.INVIERTE.PARAM,Y.CUST.CLASS.ID THEN
        Y.MONTO.MIN = Y.REC.PARAM<AbcTable.AbcClubInvierteParam.ImporteMinimo>
    END

    RETURN

*----------
OPEN.FILES:
*----------
    FN.ABC.2LN.DEPOSIT.RATES = 'F.ABC.2LN.DEPOSIT.RATES'
    F.ABC.2LN.DEPOSIT.RATES = ''
    EB.DataAccess.Opf(FN.ABC.2LN.DEPOSIT.RATES,F.ABC.2LN.DEPOSIT.RATES)

    FN.ABC.CLUB.INVIERTE.PARAM = 'F.ABC.CLUB.INVIERTE.PARAM'
    F.ABC.CLUB.INVIERTE.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.CLUB.INVIERTE.PARAM,F.ABC.CLUB.INVIERTE.PARAM)


    RETURN

END
