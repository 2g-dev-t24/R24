* @ValidationCode : MjotMzk5MzMyMjY1OkNwMTI1MjoxNzU5NzgxNzAxNzMyOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Oct 2025 17:15:01
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

SUBROUTINE ABC.SALDO.PROMEDIO.IPAB(ACCOUNT.NO,FECHA.INI,FECHA.FIN,CR.AV.BAL,NO.DIAS)

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING AC.AccountOpening
    $USING IC.OtherInterest
    $USING AC.BalanceUpdates
    $USING AC.HighVolume

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

RETURN

*** <region name= INITIALIZE>
INITIALIZE:
***
    END.DATE = FECHA.FIN
    START.DATE = FECHA.INI
    CURR.DATE = START.DATE
    START.YRMN = START.DATE[1,6]
    ACCREC = ""
    NO.DAYS = "C"
    ZERO.DAYS = "0"
    DR.DAYS = "0"
    CR.DAYS = "0"
    DR.AV.BAL = "0"
    CR.AV.BAL = "0"
    ACCOUNT.BAL = ""
    END.YRMN = END.DATE[1,6]
    CURRENCY = ""
    END.FLAG = 0
    CNT = 1

    TOT.CR.BAL = ''
    TOT.DR.BAL = ''


    FN.ACCOUNT = "F.ACCOUNT"
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    EB.DataAccess.FRead(FN.ACCOUNT,ACCOUNT.NO,REC,F.ACCOUNT,READ.ERR)
    CURRENCY = REC<AC.AccountOpening.Account.Currency>
    AC.BalanceUpdates.GetEnqBalance(ACCOUNT.NO,START.DATE,ACCOUNT.BAL)

RETURN
*** </region>

****************************************************
* Main process
****************************************************
*** <region name= PROCESS>
PROCESS:
***
    GOSUB GET.ACCT.ACTIVITY.DATES

    LOCATE START.YRMN IN YR.YEARM<1> BY "AR" SETTING YLOC ELSE
        NULL
    END
    LOOP
        IF YR.YEARM<YLOC> <> "" THEN
            ACCID = ACCOUNT.NO:"-":YR.YEARM<YLOC>
            ACCREC = ""
            IF REC<AC.AccountOpening.Account.HvtFlag> EQ 'YES' THEN
                LOCATE ACCID IN ACTIVITY.IDS BY 'AL' SETTING READ.POS THEN
                    ACCREC = RAISE(ACTIVITY.RECS<READ.POS>)
                END ELSE
                    AC.BalanceUpdates.EbReadAcctActivityRecord(ACCID, ACCREC, "", READ.ERR)
                END
            END ELSE
                AC.BalanceUpdates.EbReadAcctActivityRecord(ACCID, ACCREC, "", READ.ERR)
            END
            IF READ.ERR THEN
                ETEXT ="AC.RTN.NO.AC.ACTIVITY.ON.REC"
                COMI = ""
            END
            D.FLAG = 0
            CNT = 1
            LOOP WHILE ACCREC<AC.BalanceUpdates.AcctActivity.IcActDayNo,CNT> <> "" AND D.FLAG = 0
                REC.DATE = YR.YEARM<YLOC> : ACCREC<AC.BalanceUpdates.AcctActivity.IcActDayNo,CNT>
                IF REC.DATE >= START.DATE AND REC.DATE <= END.DATE THEN
                    GOSUB CALC.FIELDS
                END ELSE
                    IF REC.DATE >= START.DATE THEN
                        REC.DATE = END.DATE
                        D.FLAG = 1
                    END
                END
                CNT += 1
            REPEAT
            YLOC +=1
        END ELSE
            REC.DATE = END.DATE
            END.FLAG = 1
        END
    WHILE END.YRMN GE YR.YEARM<YLOC> AND END.FLAG = 0
    REPEAT
    REC.DATE = END.DATE
    GOSUB CALC.FIELDS
    GOSUB FINAL.CALC
RETURN
*** </region>
*
*-----------------------------------------------------------------------------
GET.ACCT.ACTIVITY.DATES:
*----------------------
    ACTIVITY.IDS = ''
    ACTIVITY.RECS = ''
    YR.YEARM = ''
    IF REC<AC.AccountOpening.Account.HvtFlag> EQ 'YES' THEN
        ACTIVITY.DETAILS = ACCOUNT.NO:@FM:"ENQUIRY-ACCT.ACTIVITY"
        AC.HighVolume.HvtMerge(ACTIVITY.DETAILS)
        ACTIVITY.IDS = RAISE(ACTIVITY.DETAILS<1>)
        ACTIVITY.RECS = RAISE(ACTIVITY.DETAILS<2>)
        YR.YEARM = RAISE(ACTIVITY.DETAILS<3>)
    END ELSE
        EB.API.GetActivityDates(ACCOUNT.NO, YR.YEARM)
    END
RETURN
*-----------------------------------------------------------------------------
*****************************
* Calculate account balances
*  cr bal, dr bal, no of days at dr, cr and zero bal
*****************************
CALC.FIELDS:
    NO.DAYS = "C"
    EB.API.Cdd("",CURR.DATE,REC.DATE,NO.DAYS)
    CURR.DATE = REC.DATE
    NEW.BAL = ACCREC<AC.BalanceUpdates.AcctActivity.IcActBalance,CNT>
    BEGIN CASE
        CASE ACCOUNT.BAL < 0
            DR.DAYS += NO.DAYS
            DR.BAL = NO.DAYS * ACCOUNT.BAL
            TOT.DR.BAL += DR.BAL
        CASE ACCOUNT.BAL = "0"
            ZERO.DAYS += NO.DAYS
        CASE ACCOUNT.BAL > 0
            CR.DAYS += NO.DAYS
            CR.BAL = NO.DAYS * ACCOUNT.BAL
            TOT.CR.BAL += CR.BAL
    END CASE
*
    ACCOUNT.BAL = NEW.BAL
RETURN
*
*--------------------------------------------------------------
FINAL.CALC:
* Credit bal - ie av credit bal for tot time in credit
    IF CR.DAYS AND CR.DAYS <> 0 THEN
        NO.DIAS = 'C'
        EB.API.Cdd("",START.DATE,END.DATE,NO.DIAS)
        CR.AV.BAL = TOT.CR.BAL/NO.DIAS
        EB.API.RoundAmount(CURRENCY,CR.AV.BAL,"","")
    END

RETURN

FINALIZE:
***
RETURN
*** </region>
END
