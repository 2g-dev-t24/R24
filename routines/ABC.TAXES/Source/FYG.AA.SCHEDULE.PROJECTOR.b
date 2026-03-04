* @ValidationCode : MjotMTAxMjQ0MDgyNDpDcDEyNTI6MTc1OTAwMDM4MzY5NTptYXVyaWNpby5sb3BlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Sep 2025 16:13:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>225</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTaxes
SUBROUTINE FYG.AA.SCHEDULE.PROJECTOR(ARRANGEMENT.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES)

*-----------------------------------------------------------------------------
*===============================================================================
* Nombre de Programa:   FYG.AA.SCHEDULE.PROJECTOR
* Objetivo:             Rutina que guarda obtiene las fechas de pago de una
*      inversi�n. Basada en la rutina CORE AA.SCHEDULE.PROJECTOR
* Desarrollador:        Cesar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC Capital
* Fecha Creacion:       2016-10-14
* Modificaciones:
*===============================================================================

*** <region name= Inserts>
***

    $USING AA.Framework
    $USING AF.Framework
    $USING AA.ProductFramework
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AA.PaymentSchedule
    $USING AA.TermAmount
    $USING AA.Account
    $USING AA.Tax
    
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Main Process>
***

    GOSUB INITIALISE          ;* Initialise the variables

    IF NOT(EXIT.FLAG) THEN
        GOSUB GET.PROPERTY.NAMES

        GOSUB BUILD.PAYMENT.PROPERTIES  ;* Build the different Payment Schedule Property with dates

        IF NOT(NO.RESET<2>) THEN
            GOSUB BUILD.PAST.SCHEDULES  ;* Get the past schedules from Bill details
        END

        GOSUB BUILD.DATES.AND.AMOUNT    ;* Project schedule for each Property

    END

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Initialise variables>
***
INITIALISE:

    TODAY = EB.SystemTables.getToday()

    GOSUB INIT.DUES ;* Initiate Due variables
    GOSUB RESET.DATA
    IF NOT(NO.RESET<1>) THEN
        AA.Framework.ActivityInitialise()
    END

    AF.Framework.InitPropertyCommon('', '')

    R$PROJECTED.ACCRUALS = ''
    R$STORE.PROJECTION = '1'  ;* This variable is set for Enquiry Selection.
    ADJUST.FINAL.AMOUNT = ''
    PAYM.PROP = ''
    AMEND.DATES = ''
    PAYM.RECS = ''
    CURR.DATE = ''
    PAYMENT.PROPERTIES.AMT = ''
    PAYMENT.METHODS = ''      ;* Payment methods for each payment types
    PAYMENT.BILL.TYPE = ''
    DATE.FROM = ''
    DATE.TO = ''
    CURR.OUTS = ''
    RET.ERROR = ''
    LAST.PAST.ISSUE.DATE = ''
    R.SIM.RUNNER = ''
    EXIT.FLAG = ''

    PAST.PAYMENT.TYPE.CHECK = ''
    IF DATE.RANGE THEN
        DATE.FROM = DATE.RANGE<1>       ;* Parse the Range variable
        DATE.TO = DATE.RANGE<2>
    END

    TOT.PAYMENT = ""          ;* Total payment due for each payment date

    AA.Framework.GetArrangement(ARRANGEMENT.ID, R.ARRANGEMENT, ARR.ERROR)

    IF  NOT(R.ARRANGEMENT) AND  SIMULATION.REF THEN         ;**  for pure simulation enquiry get details from AA.ARRANGEMENT.SIM
        ARR.ID = ARRANGEMENT.ID:VM:SIMULATION.REF

        AA.Framework.GetArrangement(ARR.ID, R.ARRANGEMENT, ARR.ERROR)     ;* Arrangement record to pick the Property list

    END

    FWD.DATE = ''   ;** date whcih should be used to skip forward dated amendments
    IF R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate> GT TODAY THEN
        FWD.DATE = R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate>
    END ELSE
        FWD.DATE = TODAY
    END

    IF SIMULATION.REF THEN    ;* Is it for simulated projection
        FV.SIM.RUN = '' ; ERR.RUN = ''
        EB.DataAccess.FRead('F.AA.SIMULATION.RUNNER', SIMULATION.REF, R.SIM.RUNNER, FV.SIM.RUN, ERR.RUN)    ;* Read the runner record
    END

    IF NOT(NO.RESET) THEN     ;* Dont reset Account details when common variables are not to be reset
        GOSUB SET.ARRANGEMENT.LINKED.APPL
    END

    PRODUCT.LINE = R.ARRANGEMENT<AA.Framework.Arrangement.ArrProductLine>

** If user enter the from and to date as before arrangment start date then no need to process.

    BEGIN CASE
        CASE DATE.RANGE<1>
            IF DATE.RANGE<1> LT R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate> THEN
                EXIT.FLAG = 1
            END
        CASE DATE.RANGE<2>
            IF DATE.RANGE<2> LT R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate> THEN
                EXIT.FLAG = 1
            END
        CASE DATE.RANGE<1> AND DATE.RANGE<2>
            IF DATE.RANGE<1> LT R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate> OR DATE.RANGE<2> LT R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate> THEN
                EXIT.FLAG = 1
            END
    END CASE


RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Set Linked Application>
*** <desc>Set linked Application</desc>
SET.ARRANGEMENT.LINKED.APPL:

* Load the Account details once at the AAA level.

    YI = 1
    LOOP
        LINKED.APPL = R.ARRANGEMENT<AA.Framework.Arrangement.ArrLinkedAppl,YI>

    WHILE LINKED.APPL
        BEGIN CASE
            CASE LINKED.APPL EQ "ACCOUNT"
                
                AA.Framework.setLinkedAccount(R.ARRANGEMENT<AA.Framework.Arrangement.ArrLinkedAppl,YI>)
                AA.PaymentSchedule.ProcessAccountDetails(AA$ARR.ID, "INITIALISE", "", "", "")
            CASE 1
        END CASE
        YI += 1
    REPEAT

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Get property names for Account/PS classes>
*** <desc></desc>
GET.PROPERTY.NAMES:

    R.ARRANGEMENT.DATES = '' ; ARR.DT.ERR = ''

* TODO - relook when product change is permiitted
** Product is dated, so get the correct property list
** At the moment, product change is not permitted, if permitted
** this routine should be changed to look at the correct
** properties based on the schedule dates

    CHECK.DATE = R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate> ;* For enquiry, always start from start date of the contract

    IF NOT(ARR.DT.ERR) AND R.ARRANGEMENT THEN

        LOCATE 'ACCOUNT' IN R.ARRANGEMENT<AA.Framework.Arrangement.ArrLinkedAppl,1> SETTING AC.POS THEN
            ACCOUNT.ID = R.ARRANGEMENT<AA.Framework.Arrangement.ArrLinkedApplId, AC.POS>
        END

* Forcefully append null values into ARR.INFO, so that, values are not picked from common in AA.GET.ARRANGEMENT.PROPERTIES
* This is done to avoid common variables of some other arrangement getting assinged from cache, when multiple arrangment details are accessed within
* the same session
        ARR.INFO = ARRANGEMENT.ID:FM:'':FM:'':FM:'':FM:'':FM:''
        AA.Framework.GetArrangementProperties(ARR.INFO, CHECK.DATE, R.ARRANGEMENT, PROP.LIST)
        CLASS.LIST = ''
        AA.ProductFramework.GetPropertyClass(PROP.LIST, CLASS.LIST)
        LOCATE 'PAYMENT.SCHEDULE' IN CLASS.LIST<1,1> SETTING PAYM.POS THEN
            PS.PROPERTY = PROP.LIST<1,PAYM.POS>
        END

        LOCATE 'ACCOUNT' IN CLASS.LIST<1,1> SETTING ACC.POS THEN
            ACC.PROPERTY = PROP.LIST<1,ACC.POS>
        END

        LOCATE 'TERM.AMOUNT' IN CLASS.LIST<1,1> SETTING TERM.POS THEN
            TERM.AMT.PROPERTY = PROP.LIST<1, TERM.POS>
        END

        IF NOT(DATE.FROM) THEN
            DATE.FROM = R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate>
        END

    END
    AA$ACCOUNT.DETAILS = AA.Framework.getAccountDetails()
    IF NOT(AA$ACCOUNT.DETAILS) THEN
        AA.PaymentSchedule.ProcessAccountDetails(ARRANGEMENT.ID, "INITIALISE", "", AA$ACCOUNT.DETAILS, RET.ERROR)
    END

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Check for Multiple Payment Schedules>
***
BUILD.PAYMENT.PROPERTIES:

    GOSUB GET.DEFAULT.END.DATE

    IF PROPERTY.DATES THEN
        AA$ARRANGEMENT = AA.Framework.getRArrangement()
        STAGE = AA$ARRANGEMENT
        STAGE = AA.Framework.getC_aalocarrangementrec()
        AA.Framework.BuildPropertyRecords(ARRANGEMENT.ID, PS.PROPERTY, 'PAYMENT.SCHEDULE', PROPERTY.DATES, PROPERTY.RECORDS)
        PAYM.PROP = PS.PROPERTY         ;* Store the property name here
        AMEND.DATES = LOWER(PROPERTY.DATES)       ;* These are dates on which amendments have been stated
        PAYM.RECS = LOWER(PROPERTY.RECORDS)       ;* Store the Individual records so that they need not read again
    END

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Get default end date>
***
GET.DEFAULT.END.DATE:

    IF NOT(DATE.FROM) THEN
        DATE.FROM = R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate>
    END

    IF  SIMULATION.REF THEN
        ARR.ID = ARRANGEMENT.ID:VM:SIMULATION.REF
    END ELSE
        ARR.ID = ARRANGEMENT.ID
    END

    AA.ProductFramework.GetPropertyRecord('', ARR.ID, PS.PROPERTY, DATE.FROM, 'PAYMENT.SCHEDULE', '', R.PAYMENT.SCHEDULE , REC.ERR)
    GOSUB GET.TERM.AMOUNT.DETAILS
    
    PAYMENT.END.DATE = AA$ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdPaymentEndDate>
    
    ON.MATURITY = R.TERM.AMOUNT<AA.TermAmount.TermAmount.AmtOnMaturity>         ;* Determine what to do with residual amount during Maturity Date.

    IF NOT(DATE.TO) THEN

        TERM = ""
        
        IF R.PAYMENT.SCHEDULE<AA.PaymentSchedule.PaymentSchedule.PsAmortisationTerm> THEN ;* Based on Actual Term
            TERM = R.PAYMENT.SCHEDULE<AA.PaymentSchedule.PaymentSchedule.PsAmortisationTerm>
        END

        IF NOT(TERM) THEN
            IF R.TERM.AMOUNT THEN       ;* Use Term from Term Amount property class if Amortisation Term is null
                TERM = R.TERM.AMOUNT<AA.TermAmount.TermAmount.AmtTerm>
            END
        END

        MATURITY.DATE = R.TERM.AMOUNT<AA.TermAmount.TermAmount.AmtMaturityDate>
    END

    PROPERTY.DATES = DATE.FROM

    IF NOT(DATE.TO) THEN
        DATE.TO = MATURITY.DATE
    END

    IF MATURITY.DATE LE TODAY THEN      ;*Let the projection decide which is the end date
        DATE.TO = ''
    END

    PROPERTY.DATES := FM:DATE.TO


    IF (DATE.FROM GT DATE.TO) AND DATE.TO  THEN   ;* This can happen when all details requested are PAST details and we have already loaded that
        PROPERTY.DATES = ''   ;* You dont have any work now.
    END

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Get property class record details>
*** <desc></desc>
GET.TERM.AMOUNT.DETAILS:

** Get term amount property class for the date

    R.TERM.AMOUNT = ""

    IF  SIMULATION.REF THEN
        ARR.ID = ARRANGEMENT.ID:VM:SIMULATION.REF
    END ELSE
        ARR.ID = ARRANGEMENT.ID
    END

    AA.ProductFramework.GetPropertyRecord('', ARR.ID, TERM.AMT.PROPERTY, "", "TERM.AMOUNT", "", R.TERM.AMOUNT , "")

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Pick each PAYMENT.SCHEDULE and Start Projecting>
***
BUILD.DATES.AND.AMOUNT:

* Build payment details array

    GOSUB RESET.DATA          ;* Reset the Parameter variables for each loop

    BEGIN CASE
        CASE SIMULATION.REF
            GOSUB GET.SIMULATION.DETAILS    ;* Simulation, Get from schedule details file
        CASE 1
            GOSUB GET.ARRANGEMENT.DETAILS   ;* Live arrangement, Project the details
    END CASE

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Get Simulation Details>
*** <desc> </desc>
GET.SIMULATION.DETAILS:
* TODO MLOPEZ
*    CALL AA.RETRIEVE.SIMULATION.PROJECTION(ARRANGEMENT.ID, SIMULATION.REF,PAYMENT.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, PRESENT.VALUE, RET.ERROR)
* TODO MLOPEZ
    IF PRODUCT.LINE = 'LENDING' THEN
        PRESENT.VALUE = NEGS(PRESENT.VALUE)
    END


RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Get Arrangement Details>
*** <desc> </desc>
GET.ARRANGEMENT.DETAILS:

    PAST.PROCESS = ""
    PROPERTY = PS.PROPERTY
    END.DATE = ''   ;* If there is no amendment after this date, project till final term

* Modified number of arguments, as it becomes easy for component testing
    SCHEDULE.INFO = ""
    SCHEDULE.INFO<1> = ARRANGEMENT.ID
    SCHEDULE.INFO<2> = TODAY
    SCHEDULE.INFO<3> = PROPERTY
    SCHEDULE.INFO<8> = '1'
    RET.ERROR = ""

    GOSUB CHECK.FUTURE.DATED.ARRANGEMENTS

    ADJUST.FINAL.AMOUNT = "1"

    IF DATE.RANGE<2> THEN
        END.DATE = DATE.RANGE<2>
    END

    SCHEDULE.INFO<7> = "1"    ;* flag used to get a property amount from the bill if bill issued earlier for the payment date

    START.DATE = ""
    NO.CYCLES = ""
    AA.PaymentSchedule.BuildPaymentScheduleDates(SCHEDULE.INFO, START.DATE, END.DATE, NO.CYCLES, "", PAYMENT.DATES, "", "", PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, "", "", "", "", RET.ERROR)
    
    SCHEDULE.INFO<7> = ""

    IF PRODUCT.LINE = 'LENDING' THEN
        PRESENT.VALUE = NEGS(PRESENT.VALUE)
    END

    GOSUB CONSOLIDATE.DATES   ;* Parse the Projection Details

RETURN
*** </region>
*-----------------------------------------------------------------------------

CHECK.FUTURE.DATED.ARRANGEMENTS:

*** If the arrangement is future dated one then pass the arrangement start date in SCHEDULE.INFO<2>. Other wise pass it as TODAY.

    ARRANGEMENT.START.DATE = R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate>
    IF ARRANGEMENT.START.DATE GT TODAY THEN
        SCHEDULE.INFO<2> = ARRANGEMENT.START.DATE
    END ELSE
        SCHEDULE.INFO<2> = TODAY
    END

RETURN
*** </region>
*--------------------------------------------------------------------------------

*** <region name= Start Consolidating dates from Various Schedules>
***
CONSOLIDATE.DATES:

    TOT.DTES = DCOUNT(PAYMENT.DATES,FM) ;* Count the number of schedule dates
    FOR DT.CNT = 1 TO TOT.DTES
        CURR.DATE = PAYMENT.DATES<DT.CNT>         ;* This is the due date
        CURR.OUTS = PRESENT.VALUE<DT.CNT>         ;* This is the oustanding Balance for this date

** If from date is given by user then projection should be start on from date.
        IF DATE.RANGE<1> AND CURR.DATE LT DATE.RANGE<1> THEN
            CONTINUE
        END

        IF CURR.OUTS NE '' OR TOT.DTES THEN       ;* No need to proceed further if the amount has null value
            IF NOT(PAST.PROCESS) THEN
                PAST.PAYMENT.TYPE.CHECK = ''
                LOCATE CURR.DATE IN PAST.SCHED.DATES<1> SETTING INCL.POS THEN   ;* Check if bill is present for all payment types for the date
                    PAST.PAYMENT.TYPE.CHECK = 1
                END ;* If the dates have been included in the Past details(Like ISSUED bill dates), ignore them in projection
                GOSUB PROCESS.TYPES.PROPS         ;* Now check for Types and Properties
            END ELSE
                GOSUB PROCESS.TYPES.PROPS
            END
        END
    NEXT DT.CNT

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Process Individal Types and Properties>
***
PROCESS.TYPES.PROPS:

    TOT.TYPES = DCOUNT(PAYMENT.TYPES<DT.CNT>,VM)  ;* Number of Types for this date
    FOR TYPE.CNT = 1 TO TOT.TYPES
        CURR.TYPE = PAYMENT.TYPES<DT.CNT,TYPE.CNT>          ;* This is the current type
        CURR.METHOD = PAYMENT.METHODS<DT.CNT, TYPE.CNT>
        CURR.BILL.TYPE = PAYMENT.BILL.TYPE<DT.CNT,TYPE.CNT> ;* Bill type Added to find whether it is charge/payment
* it has value only while building past schedules
*        IF NOT(DATE.FROM AND DATE.FROM GT CURR.DATE) AND NOT(DATE.TO AND DATE.TO LT CURR.DATE) THEN
        GOSUB UPDATE.DUE.DATA ;* If the Start/End dates are stated, don't waste time parsing unnecessary details
*        END
    NEXT TYPE.CNT

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Update the DUE Variables>
***
UPDATE.DUE.DATA:

    PROP.LIST = PAYMENT.PROPERTIES<DT.CNT,TYPE.CNT>         ;* This is the list of properties due for the current date
    PROP.AMTS = PAYMENT.PROPERTIES.AMT<DT.CNT,TYPE.CNT>     ;* Individual Property Amounts for this date
    TAX.DETAILS = TAX.DETAILS.LIST<DT.CNT,TYPE.CNT>         ;* List Of Tax Properties and Amount for this Date.
    GOSUB CHECK.UPDATE.REQD   ;*Check if Update is required in case payment bill is already issued.
    UPD.FLG = 1

    TOT.PROPS = DCOUNT(PROP.LIST,SM)
    FOR PCNT = 1 TO TOT.PROPS WHILE UPD.FLG
        CURR.PROP = PROP.LIST<1,1,PCNT>
        CURR.AMT = PROP.AMTS<1,1,PCNT>
        TAX.DETAIL = TAX.DETAILS<1,1,PCNT>        ;* Will be Same Postion of Property in the Array.

        LOCATE CURR.DATE IN DUE.DATES<1> BY 'AR' SETTING DTPOS THEN
            GOSUB CHECK.TYPE.PROPS      ;* If the date already exists, check if the Type/Props also exist
        END ELSE
            IF NOT(PAST.PAYMENT.TYPE.CHECK) THEN  ;* add the new date only if the date is not in past schedule
                IF DUE.DATES<DTPOS> NE '' AND DUE.BILL.TYPES<DTPOS> MATCHES "ACT.CHARGE":VM:"PR.CHARGE" THEN  ;*when their is any payment date in between the charge issue bill and makedue
                    DUE.OUTS<DTPOS> = CURR.OUTS   ;* we need to project correct outstanding amount in schedule, so that update outstanding amount according to the payment dates
                    IF DUE.METHODS<DTPOS> EQ "CAPITALISE" THEN
                        DUE.OUTS<DTPOS> += DUE.PROP.AMTS<DTPOS>*SIGN
                    END
                END
                INS CURR.DATE BEFORE DUE.DATES<DTPOS>       ;* OK..this is a new date. So Build the full details for this
                INS CURR.TYPE BEFORE DUE.TYPES<DTPOS>
                INS CURR.PROP BEFORE DUE.PROPS<DTPOS>
                INS CURR.AMT BEFORE DUE.PROP.AMTS<DTPOS>
                INS CURR.AMT BEFORE DUE.TYPE.AMTS<DTPOS>
                INS CURR.METHOD BEFORE DUE.METHODS<DTPOS>
                INS CURR.BILL.TYPE BEFORE DUE.BILL.TYPES<DTPOS>       ;* Bill type is added for Past schedules to find payment/charge type

                GOSUB BUILD.CORRECT.OUTS          ;* For Multiple PAYMENT.SCHEDULEs, Outstanding amounts may have to be found. Do it here
                INS CURR.OUTS BEFORE DUE.OUTS<DTPOS>        ;* Insert the Outstanding Amount for this date
            END
        END

    NEXT PCNT

RETURN
*-----------------------------------------------------------------------------
*** <region name= Check if update is required>
CHECK.UPDATE.REQD:

    LOCATE CURR.DATE IN PAST.SCHED.DATES<1> SETTING FM.POS THEN       ;*If already payment bill is generated
        IF CURR.TYPE MATCHES PAST.SCHED.TYPES<FM.POS> THEN  ;*Check if payment type matches
            PAST.PROPERTY = PAST.SCHED.PROPS<FM.POS>
            CONVERT SM TO VM IN PAST.PROPERTY
            CHECK.PROPERTY = 1          ;*If so set this -> check if atleast one property matches - if so quit
        END ELSE
            CHECK.PROPERTY = ''
        END
    END  ELSE
        CHECK.PROPERTY = ''
    END

RETURN
*** </region>
*-----------------------------------------------------------------------------

CHECK.TYPE.PROPS:

    PAY.TYPE.FOUND = '1'
    LOCATE CURR.TYPE IN DUE.TYPES<DTPOS,1> SETTING TYPOS ELSE         ;* See if the TYPE also already exists
        PAY.TYPE.FOUND = ''
    END

    BEGIN CASE
        CASE PAY.TYPE.FOUND       ;* If type exists, check individual properties in the DUE properties array
            LOCATE CURR.PROP IN DUE.PROPS<DTPOS,TYPOS,1> SETTING PPOS THEN          ;* See if the Property already exists
                IF CHECK.PROPERTY AND CURR.PROP MATCHES PAST.PROPERTY THEN          ;*Already processed through bills - skip
                    UPD.FLG = ''
                END ELSE
                    DUE.PROP.AMTS<DTPOS,TYPOS,PPOS> = DUE.PROP.AMTS<DTPOS,TYPOS,PPOS> + CURR.AMT ;* Got you. Add the current value to the existing position
                END
            END ELSE
                INS CURR.PROP BEFORE DUE.PROPS<DTPOS,TYPOS,PPOS>          ;* Property not found..insert it newly with Amount
                INS CURR.AMT BEFORE DUE.PROP.AMTS<DTPOS,TYPOS,PPOS>
                INS CURR.METHOD BEFORE DUE.METHODS<DTPOS,TYPOS,PPOS>
            END
            IF UPD.FLG THEN
                DUE.TYPE.AMTS<DTPOS,TYPOS> = DUE.TYPE.AMTS<DTPOS,TYPOS> + CURR.AMT          ;* Whatever the Property, this is under the same type. Add to the Amount for this Type
            END

        CASE NOT(PAY.TYPE.FOUND)  ;* If its a new payment type, add it
            INS CURR.TYPE BEFORE DUE.TYPES<DTPOS,TYPOS>         ;* Start inserting new TYPE/PROPERTY in the Date position
            INS CURR.PROP BEFORE DUE.PROPS<DTPOS,TYPOS>
            INS CURR.METHOD BEFORE DUE.METHODS<DTPOS, TYPOS>
            INS CURR.AMT BEFORE DUE.PROP.AMTS<DTPOS,TYPOS>
            INS CURR.AMT BEFORE DUE.TYPE.AMTS<DTPOS,TYPOS>

    END CASE

    GOSUB BUILD.CORRECT.OUTS  ;* For Multiple PAYMENT.SCHEDULEs, Outstanding amounts may have to be found. Do it here
    DUE.OUTS<DTPOS> = CURR.OUTS         ;* Update the Outstanding Amount for this date

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Paragraph for Future use>
***
BUILD.CORRECT.OUTS:
* When Multiple Properties of PAYMENT.SCHEDULE are defined and Schedules defined for each of these properties, then
* Schedules would be projected individually for these properties. But while collating all these, O/S balance need
* to be shown correctly. Do any operations for those here.

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Update the Tax Amounts in Due Variables>
*** <desc> Update the Tax Details below the respective Interest / Charge Property </desc>
CHECK.TYPE.TAXES:

    TAX.DETAIL = RAISE(RAISE(TAX.DETAIL))
    BASE.PROPERTY = TAX.DETAIL<1,1>     ;* First position will hold Base Property (Interest /Charge)
    TAX.PROPERTIES = TAX.DETAIL<1,2>    ;* Second Position will hold the Tax Properties.
    TAX.AMTS =  TAX.DETAIL<1,3>         ;* Third position will hold the Tax Amounts.
    TAX.TOT = DCOUNT(TAX.PROPERTIES,@SM)
    AA$SEP = '-'
    FOR TAX.CNT = 1 TO TAX.TOT
        TAX.PROP = BASE.PROPERTY:AA$SEP:TAX.PROPERTIES<1,1,TAX.CNT>
        TAX.AMT =  TAX.AMTS<1,1,TAX.CNT>
        LOCATE CURR.TYPE IN DUE.TYPES<DTPOS,1> SETTING VMPOS THEN     ;* Get the Position of Current Payment Type
            LOCATE BASE.PROPERTY IN DUE.PROPS<DTPOS,VMPOS,1> SETTING SMPOS THEN ;* See if Interest /Charge Property Already Exists.
                SMPOS = SMPOS + 1
                GOSUB PROCESS.TAX.AMOUNT
            END
        END
    NEXT TAX.CNT

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Process tax amounts>
*** <desc> Update the Tax amounts below the respective Interest / Charge Property </desc>
PROCESS.TAX.AMOUNT:

    IF TAX.AMT <> 0 THEN
        INS TAX.PROP BEFORE DUE.PROPS<DTPOS,VMPOS,SMPOS>    ;* Insert the Tax Property below the respective Interest / Charge Property.
        INS TAX.AMT BEFORE DUE.PROP.AMTS<DTPOS,VMPOS,SMPOS>
    END

    IF CURR.METHOD EQ "DUE" THEN
        DUE.TYPE.AMTS<DTPOS,VMPOS> + = TAX.AMT    ;*  If Tax Property, this is under the same type. Add the Amount for this Type
    END

    IF CURR.METHOD EQ "PAY" THEN
        DUE.TYPE.AMTS<DTPOS,VMPOS> - = TAX.AMT    ;*  If Tax Property, this is under the same type.   Sub the Amount for this Type
    END

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Build Past schedules>
*** <desc></desc>
BUILD.PAST.SCHEDULES:

** Check bill updates, if no bill then project

    LAST.PAST.DATE = DATE.FROM
    PAST.SCHED.DATES  = ''
    PAST.SCHED.TYPES = ''
    PAST.SCHED.PROPS = ''
    SAVE.PAYMENT.DATE.COUNT = ""

* Get the list of bill details and payment dates from AA.ACCOUNT.DETAILS

    PAYMENT.DATES = RAISE(AA$ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillPayDate>)
    NO.OF.PAY.DATES = DCOUNT(PAYMENT.DATES, @FM)

    SIGN = -1

    FOR PAY.CNT = 1 TO NO.OF.PAY.DATES

        DATE.PAY.PROP.I = 0   ;* maintain the payment properties counter variable by date wise
        NO.REF = DCOUNT(AA$ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillId, PAY.CNT>, @SM)

*-----------------------------------------------------------------------
* During RR, even though the bills might be issued in LIVE, they might not
* hold any relevance after RR is done. So, take the past bills only before
* start of Simulation. For anything after the start date, depend on new bills
*-----------------------------------------------------------------------

        IF SIMULATION.REF THEN
            IF PAYMENT.DATES<PAY.CNT> GE R.SIM.RUNNER<AA.Framework.SimulationRunner.SimSimRunDate> THEN
                EXIT
            END
        END
        PAYMENT.BILLS.PROCESSED = ''    ;* Flag to check whether the bill is processed or not

        FOR BILL.CNT = 1 TO NO.REF

            BEGIN CASE
                CASE AA$ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillType,PAY.CNT,BILL.CNT> EQ "PAYOFF" AND AA$ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdPayMethod,PAY.CNT,BILL.CNT> EQ "INFO"
* Do not show payoff bills in the enquiry.  Just get the outstanding amount!
                    GOSUB GET.CURRENT.OUTSTANDING.AMOUNT        ;* Get the current Outstanding Amount.

                CASE 1
                    PAYMENT.BILLS.PROCESSED = 1
                    GOSUB PROCESS.BILLS     ;* do processing for other type of bills

            END CASE

        NEXT BILL.CNT

        IF PAYMENT.BILLS.PROCESSED THEN ;* Update the past scheduled date if the bill is processed
            PAST.SCHED.DATES<PAY.CNT> = PAYMENT.DATES<PAY.CNT>
            PRESENT.VALUE<PAY.CNT> = CURR.PRESENT.VALUE     ;* The schedule on this day reduces the balances
        END ELSE
            PAYMENT.DATES<PAY.CNT> = '' ;* If there is only INFO bill on a given payment date, that payment date won't be considered
            PRESENT.VALUE<-1> = ''
        END

    NEXT PAY.CNT
    PAST.PROCESS = "1"

    GOSUB CONSOLIDATE.DATES

    IF LAST.PAST.ISSUE.DATE THEN
        LAST.PAST.DATE = LAST.PAST.ISSUE.DATE
    END
    DATE.FROM = LAST.PAST.DATE          ;* We can start projecting for future only from this date.


* Now we know the list of dates in which the property PAYMENT.SCHEDULE has been changed and the last past payment date (last bill which is made due)
* So, do not consider the amendmends done to Payment schedule before the last payment date
    LOCATE FWD.DATE IN AMEND.DATES<1,1> BY 'DR' SETTING ADATE.POS THEN NULL     ;* locate the last past due date in AMEND.DATES

    AMEND.DATES = FIELD(AMEND.DATES,VM,1,ADATE.POS)         ;* strip off unwanted dates
    PAYM.RECS = FIELD(PAYM.RECS,VM,1,ADATE.POS)

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= PROCESS.BILLS>
*** <desc>Process bills</desc>
PROCESS.BILLS:

    GOSUB GET.CURRENT.OUTSTANDING.AMOUNT          ;* Get the current Outstanding Amount.

    ADJUST.PROPERTY.FOUND = ''          ;* Flag for adjustment property
    TAX.PROPERTY.FOUND = ''   ;* Flag for tax property

    PAYMENT.TYPES<PAY.CNT,-1> = BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPaymentType>
    PAYMENT.BILL.TYPE<PAY.CNT,-1> = BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdBillType>

*** Check any Tax property or Adjusted property exist in the bill
    NO.ADJ.PROPERTIES = DCOUNT(BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdProperty>,VM)
    FOR ADJ.PROP = 1 TO NO.ADJ.PROPERTIES
        IF BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdAdjustAmt,ADJ.PROP> NE "" THEN
            ADJUST.PROPERTY.FOUND = 1
        END
    NEXT ADJ.PROP

    TYPE.TOT = DCOUNT(BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPaymentType>,VM)
    IF "PAYMENT" MATCHES BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdBillType> THEN ;*Only then update Past Details to suppress from projection
        PAST.SCHED.DATES<PAY.CNT> = PAYMENT.DATES<PAY.CNT>
        PAST.SCHED.TYPES<PAY.CNT, -1> = BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPaymentType>
        PAST.SCHED.PROPS<PAY.CNT, -1> = BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPayProperty>
    END

    FOR TYP.CNT = 1 TO TYPE.TOT
        DATE.PAY.PROP.I = DATE.PAY.PROP.I + 1     ;*increment the property counter for that date
        PAYMENT.AMOUNTS<PAY.CNT,-1> = SUM(BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdOrPrAmt,TYP.CNT>)
        PAYMENT.METHODS<PAY.CNT,-1> = BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPaymentMethod>        ;* Get the payment method from the bill
        NO.PAY.PROPERTIES = DCOUNT(BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdProperty,TYP.CNT>,@SM)
        FOR PAY.PROP = 1 TO NO.PAY.PROPERTIES

            FINDSTR AA$SEP IN BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPayProperty,TYP.CNT,PAY.PROP> SETTING POS THEN
                TAX.PROPERTY.FOUND = 1
            END
            BEGIN CASE
                CASE TAX.PROPERTY.FOUND
                    GOSUB BUILD.TAX.DETAILS
                CASE ADJUST.PROPERTY.FOUND
                    GOSUB BUILD.ADJUST.PROPERTY.AMOUNTS
                CASE 1
                    PAYMENT.PROPERTIES<PAY.CNT,DATE.PAY.PROP.I,PAY.PROP> = BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPayProperty,TYP.CNT,PAY.PROP>
                    PAYMENT.PROPERTIES.AMT<PAY.CNT,DATE.PAY.PROP.I,PAY.PROP> = (BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdOrPrAmt,TYP.CNT,PAY.PROP>) - (BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdWaivePrAmt,TYP.CNT,PAY.PROP>)
            END CASE
        NEXT PAY.PROP
    NEXT TYP.CNT

    PAY.TYPE.POS = ""
    LOCATE "RESIDUAL.PRINCIPAL" IN BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPaymentType,1> SETTING PAY.TYPE.POS THEN     ;* If any residual amount is due (when FINAL.RES.AMOUNT is due), Payment Method is set to "DUE".
        PAYMENT.METHODS<PAY.CNT,PAY.TYPE.POS> = "DUE"
    END

    BILL.AMOUNT.FOR.ACC = 0 ; CAP.AMOUNT = 0
    IF BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdBillStatus,1> = 'ISSUED' THEN    ;* This event has not happened. But Enq should reduce the outstanding for this event as well.

        LAST.PAST.ISSUE.DATE = PAYMENT.DATES<PAY.CNT>       ;* Stores payment date of bill which is issued but still not made due (will be useful when we extract previous data as per the Payment schedule changes)
* Get the original amount from the bill only for account property
        FM.POS = ""
        MV.POS = ""
        SV.POS = ""
        FIND ACC.PROPERTY IN BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPayProperty>  SETTING FM.POS, MV.POS, SV.POS THEN
            CURR.PRESENT.VALUE += BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdOrPrAmt, MV.POS, SV.POS>
        END ELSE
            CAP.POS = ""

* If payment method is set to CAPITALISE, the property amount needs to added to outstanding
            LOCATE "CAPITALISE" IN BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPaymentMethod,1> SETTING CAP.POS THEN
                CURR.PRESENT.VALUE = CURR.PRESENT.VALUE + (BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdOrPrAmt, CAP.POS,1>)*SIGN
            END
        END

    END ELSE
        LAST.PAST.DATE = PAYMENT.DATES<PAY.CNT>
    END

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= GET.CURRENT.OUTSTANDING.AMOUNT>
*** <desc>Get the Current Outstanding Amount.</desc>
GET.CURRENT.OUTSTANDING.AMOUNT:

    CURR.BILL.REFERENCE = AA$ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillId,PAY.CNT,BILL.CNT>

    BILL.DETAILS = ''
    RET.ERROR = ''
    AA.PaymentSchedule.GetBillDetails(ARRANGEMENT.ID, CURR.BILL.REFERENCE, BILL.DETAILS, RET.ERROR)

    CURR.PRESENT.VALUE = 0    ;* Temporary variable to hold the present value for a payment date
    GOSUB GET.OUTSTANDING.AMTS          ;* Get the outstanding amounts from activity balances
    CURR.PRESENT.VALUE = BAL.OUTSTANDING

RETURN

*** </region>
*-----------------------------------------------------------------------------

*** <region name= Build tax details>
*** <desc>Build tax details for the past bills</desc>
BUILD.TAX.DETAILS:

    TAX.LIST = ""
* TODO MLOPEZ
*    TAX.LIST<1,AA.Tax.TxBaseProp> = FIELD(BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPayProperty,TYP.CNT,PAY.PROP>,AA$SEP,1) ;* Base property for the tax property
*    TAX.LIST<1,AA.Tax.TxTaxProp> = FIELD(BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPayProperty,TYP.CNT,PAY.PROP>,AA$SEP,2)  ;* Take the tax property only. properties Will be seperated by "SM".
*    TAX.LIST<1,AA.Tax.TxTaxAmt> =  BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdOrPrAmt,TYP.CNT,PAY.PROP> ;* Corresponding tax amounts for the tax Properties.
*
*    TAX.LIST = LOWER(LOWER(TAX.LIST))   ;* Will be Sepreated by "VM" , needs to be at Lower Level than "SM"  to insert at Property Position.
*
*    TAX.DETAILS.LIST<PAY.CNT, TYP.CNT, PAY.PROP-1>  =  TAX.LIST
* TODO MLOPEZ
RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Build Adjust Property Amounts>
*** <desc></desc>
BUILD.ADJUST.PROPERTY.AMOUNTS:

** If any adjustment has done in the bill using the adjust bill activity then system will update the ADJ.AMT fields with the adjustment amounts
** in the Bill. So during the schedules projection adjust this adjusted amount from the OR.PR.AMT for the corresponding property

    PAY.PROPERTY = BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPayProperty,TYP.CNT,PAY.PROP>
    LOCATE PAY.PROPERTY IN BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdProperty,1> SETTING PAY.PROP.POS THEN
        ADJ.AMOUNT = SUM(BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdAdjustAmt,PAY.PROP.POS>)
        PAYMENT.PROPERTIES<PAY.CNT,DATE.PAY.PROP.I,PAY.PROP> = BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPayProperty,TYP.CNT,PAY.PROP>
        PAYMENT.PROPERTIES.AMT<PAY.CNT,DATE.PAY.PROP.I,PAY.PROP> = (BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdOrPrAmt,TYP.CNT,PAY.PROP>) - (BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdWaivePrAmt,TYP.CNT,PAY.PROP>) + ADJ.AMOUNT
    END
RETURN
*** </region>
*------------------------------------------------------------------------------

GET.OUTSTANDING.AMTS:

** For the past events, rely on the BALANCES corresponding to the property. They should be in sync
** with the Schedules that have happened. Look at ACCOUNT property's balance since Events would happen
** only on ACCOUNT property

* No need to get the Out standing amount for each and every Bill.

    IF PAY.CNT NE SAVE.PAYMENT.DATE.COUNT THEN
        VALUE.TRADE = "VALUE"
        VALUE.TRADE<2> = "ALL"          ;* Get all NAU movements
        BAL.DETS = ""
        LIFECYCLE.STATUS = 'CUR'
        BALANCE.NAME = ""

        IF AA$ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdStartDate> THEN
            BALANCE.PROPERTY = ACC.PROPERTY
        END ELSE
            BALANCE.PROPERTY = TERM.AMT.PROPERTY
        END

        
        AA.ProductFramework.PropertyGetBalanceName(ARRANGEMENT.ID, BALANCE.PROPERTY, LIFECYCLE.STATUS, "", "", BALANCE.NAME)
* Get the Actual Financial Date.

        NEW.START.DATE = ""
        
        NEW.START.DATE = BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdFinancialDate>
        SAVE.PAYMENT.DATE.COUNT = PAY.CNT

        IF NOT(NEW.START.DATE) THEN
            NEW.START.DATE = PAYMENT.DATES<PAY.CNT>
        END

        IF NEW.START.DATE LT AA$ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdStartDate> THEN
            NEW.START.DATE = AA$ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdStartDate>
        END

        END.DATE = ''
        AA.Framework.GetPeriodBalances(ACCOUNT.ID, BALANCE.NAME, VALUE.TRADE, NEW.START.DATE, END.DATE, "", BAL.DETS, ERR.PROCESS)

        IF NOT(ERR.PROCESS) THEN
            BAL.OUTSTANDING = BAL.DETS<IC.ACT.BALANCE,1>    ;* Get the outstanding balance
        END

        IF BALANCE.PROPERTY  EQ ACC.PROPERTY THEN

            VALUE.TRADE = "VALUE"
            VALUE.TRADE<2> = "ALL"      ;* Get all NAU movements
            BAL.DETS = ""
            LIFECYCLE.STATUS = 'EXP'
            BALANCE.NAME = ""
            AA.ProductFramework.PropertyGetBalanceName(ARRANGEMENT.ID, BALANCE.PROPERTY, LIFECYCLE.STATUS, "", "", BALANCE.NAME) ;* Get the ACCOUNT balance name for "EXP" lifecycle

            NEW.START.DATE = ""
            
            NEW.START.DATE = BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdFinancialDate>
            SAVE.PAYMENT.DATE.COUNT = PAY.CNT

            IF NOT(NEW.START.DATE) THEN
                NEW.START.DATE = PAYMENT.DATES<PAY.CNT>
            END

            END.DATE = ''

            IF NEW.START.DATE LT AA$ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdStartDate> THEN
                NEW.START.DATE = AA$ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdStartDate>
            END

            AA.Framework.GetPeriodBalances(ACCOUNT.ID, BALANCE.NAME, VALUE.TRADE, NEW.START.DATE, END.DATE, "", BAL.DETS, ERR.PROCESS)
            IF NOT(ERR.PROCESS) THEN
                BAL.OUTSTANDING = BAL.OUTSTANDING + ABS(BAL.DETS<IC.ACT.BALANCE,1>)    ;* For Enquiry Projection , add the EXPACCOUNT balance with CUR balance.
            END
        END
    END

RETURN
*-----------------------------------------------------------------------------

*** <region name= Reset Certain Variables>
***
RESET.DATA:

    PAYMENT.AMOUNTS = ''
    PAYMENT.DATES = ''
    PAYMENT.PROPERTIES = ''
    PAYMENT.TYPES = ''
    PAYMENT.METHODS = ''
    PAYMENT.PROPERTIES.AMT = ''
    PRESENT.VALUE = ''
    TAX.DETAILS.LIST = ''
    PAYMENT.BILL.TYPE = ''

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Initialise DUE variables>
***
INIT.DUES:

    DUE.DATES = ''
    DUE.TYPES = ''
    DUE.TYPE.AMTS = ''
    DUE.PROPS = ''
    DUE.PROP.AMTS = ''
    DUE.OUTS = ''
    CURR.OUTS = ''
    PRESENT.VALUE = ''
    DUE.METHODS = ''
    DUE.BILL.TYPES = ''

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= Build Total Payment>
*** <desc>Para to build total payment due for each payment date</desc>

BUILD.TOTAL.PAYMENT:

* For each payment date, get its payments types

    NO.OF.PAY.DATES = DCOUNT(DUE.DATES, @FM)
    FOR PAY.DATE = 1 TO NO.OF.PAY.DATES

        TOT.PAYMENT<PAY.DATE> = 0       ;* Initialise total payment array for each date
        NO.OF.PAY.TYPES = DCOUNT(DUE.TYPES<PAY.DATE>, @VM)
        FOR PAY.TYPE = 1 TO NO.OF.PAY.TYPES

* If the payment method is due for the given type then add the payment amount
            IF DUE.METHODS<PAY.DATE, PAY.TYPE, 1> MATCHES "DUE":VM:"PAY"  THEN
                IF PRODUCT.LINE EQ "LENDING" AND DUE.METHODS<PAY.DATE, PAY.TYPE, 1> EQ "PAY" THEN
                    TOT.PAYMENT<PAY.DATE> = TOT.PAYMENT<PAY.DATE> - DUE.TYPE.AMTS<PAY.DATE, PAY.TYPE>
                END ELSE
                    TOT.PAYMENT<PAY.DATE> = TOT.PAYMENT<PAY.DATE> + DUE.TYPE.AMTS<PAY.DATE, PAY.TYPE>
                END
            END ELSE

* If the payment method is capitalise, dont add capitalise amount to the total
* payment amount, but during payment end date, certain conditions needs to be checked
                IF DUE.DATES<PAY.DATE> EQ PAYMENT.END.DATE THEN

                    BEGIN CASE

* If any residual amount is due (when FINAL.RES.AMOUNT is due), this amount is due
                        CASE DUE.TYPES<PAY.DATE,PAY.TYPE> MATCHES "RESIDUAL.PRINCIPAL"
                            TOT.PAYMENT<PAY.DATE> = TOT.PAYMENT<PAY.DATE> + DUE.TYPE.AMTS<PAY.DATE, PAY.TYPE>

* If enquiry is viewed after payment end date
                        CASE ON.MATURITY EQ "DUE" AND TODAY GT PAYMENT.END.DATE

* Final capitalised amount should be added to total amount
                        CASE 1
                            TOT.PAYMENT<PAY.DATE> = TOT.PAYMENT<PAY.DATE> + DUE.TYPE.AMTS<PAY.DATE, PAY.TYPE>

                    END CASE
                END

            END
        NEXT PAY.TYPE
    NEXT PAY.DATE

RETURN
*** </region>
*-----------------------------------------------------------------------------

END
*** </region>
