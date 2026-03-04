* @ValidationCode : MjoxNzc4MTI5MTM0OkNwMTI1MjoxNzY2MTU2MDAxNzQwOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2025 11:53:21
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
$PACKAGE AbcDeposits

SUBROUTINE ABC.TERM.AMOUNT.UPD.INTEREST
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* This routine has been developed to store the details of  the arrangement id in a LIVE file during INAU stage itself.
* Deletails will be stored in this table AA.CLUB.INVST.ACCOUNT
*=============================================================================
* MODIFICACION
* DESCRIPCION: Actualizacion de la tasa tomando el grupo no autorizado.
* FECHA:  16.08.2016
* AUTOR:       Jesus Hernandez JHF FyG Solutions
*=============================================================================
*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AA.Framework
    $USING AC.AccountOpening
    $USING EB.Updates
    $USING AA.Interest
    $USING AA.ProductFramework
    $USING AA.TermAmount
    $USING AA.ChangeProduct
    $USING AA.Settlement
    
    GOSUB INIT
RETURN

INIT:
    

*   PRO.STATUS = c_arrActivityStatus["-",1,1]
    PRO.STATUS = AA.Framework.getC_aalocactivitystatus()["-",1,1]
    
    R.ARRANGEMENT.ACTIVITY = AA.Framework.getRArrangementActivity()
    IF R.ARRANGEMENT.ACTIVITY<35> THEN
*   IF AA$R.ARRANGEMENT.ACTIVITY<35> THEN
        
        
*ARRANGEMENT.ID = AA$ARR.ID      ;* Arrangement contract Id
        
        ARRANGEMENT.ID = AA.Framework.getArrId()      ;* Arrangement contract Id
        ARRANGEMENT.ID<1,2>='YES'
    END ELSE
*ARRANGEMENT.ID = AA$ARR.ID      ;* Arrangement contract Id
        ARRANGEMENT.ID = AA.Framework.getArrId()

    END


*ACTIVITY.ID = AA$CURR.ACTIVITY
    ACTIVITY.ID = AA.Framework.getC_aaloccurractivity()
*    EFFECTIVE.DATE = AA$ACTIVITY.EFF.DATE
    EFFECTIVE.DATE =AA.Framework.getC_aalocactivityeffdate()
    

    FN.CLUB = 'F.ABC.CLUB.AHORRO'
    F.CLUB = ''
    EB.DataAccess.Opf(FN.CLUB,F.CLUB)

    FN.SET.ACC= 'F.ABC.CLUB.INVST.ACCOUNT'
    F.SET.ACC= ''
    EB.DataAccess.Opf(FN.SET.ACC,F.SET.ACC)

    FN.INT = 'F.ABC.2LN.DEPOSIT.RATES'
    F.INT = '';
    EB.DataAccess.Opf(FN.INT,F.INT)


    FN.AA.SET = 'F.AA.ARR.SETTLEMENT'
    F.AA.SET = ''
    EB.DataAccess.Opf(FN.AA.SET,F.AA.SET)

    FN.REV.RATE='F.REVAISABLE.INTEREST'
    F.REV.RATE = ''
    EB.DataAccess.Opf(FN.REV.RATE,F.REV.RATE)
    
    FN.AA.PRD.DES.INTEREST='F.AA.PRD.DES.INTEREST'
    F.AA.PRD.DES.INTEREST = ''
    EB.DataAccess.Opf(FN.AA.PRD.DES.INTEREST,F.AA.PRD.DES.INTEREST)

    APP.NAME = 'AA.ARRANGEMENT.ACTIVITY':@FM:'AA.ARR.INTEREST'
    FIELD.NAME ='SETTLE.ACCT':@FM:'CLUB.INV.RATE'

    FIELD.POS = '';

    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    SET.ACC.POS   = FIELD.POS<1,1>
    INVEST.ID.POS = FIELD.POS<2,1>
    BEGIN CASE

        CASE PRO.STATUS EQ "UNAUTH" AND ACTIVITY.ID EQ "DEPOSITS-NEW-ARRANGEMENT"
            GOSUB INPUT.PROCESS
        CASE PRO.STATUS EQ "AUTH" AND ACTIVITY.ID EQ "DEPOSITS-NEW-ARRANGEMENT"
            GOSUB INPUT.PROCESS
        CASE PRO.STATUS EQ "AUTH" OR PRO.STATUS EQ "UNAUTH" AND ACTIVITY.ID EQ "DEPOSITS-CHANGE-DEPOSITINT"
            GOSUB INPUT.PROCESS
        CASE PRO.STATUS EQ 'UNAUTH' AND ACTIVITY.ID EQ 'DEPOSITS-MATURE-ARRANGEMENT'
            GOSUB DEL.PROCESS

        CASE PRO.STATUS EQ 'AUTH' AND ACTIVITY.ID EQ 'DEPOSITS-MATURE-ARRANGEMENT'
            GOSUB DEL.PROCESS

    END CASE

RETURN

INPUT.PROCESS:
    
    
*  ACC.NO = AA$R.ARRANGEMENT.ACTIVITY
  
    ACC.NO = AA.Framework.getRArrangementActivity()
    R.ARRANGEMENT.ACTIVITY = AA.Framework.getRArrangementActivity()
* AA.ARR.ACT.LOCAL.REF
    ACC.NO = ACC.NO<AA.Framework.ArrangementActivity.ArrActLocalRef,SET.ACC.POS>

    SEL.LIST = ''
    SEL.CMD = 'SELECT ':FN.CLUB : ' WITH CUENTA EQ ': DQUOTE(ACC.NO)  ; * ITSS - NYADAV - Added DQUOTE
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)

    IF NO.OF.REC GE 1 THEN
        GOSUB UPDATE.INTEREST
        GOSUB UPDATE.RECORD
    END ELSE
        GOSUB GET.CURRENT.ARR.AMT.DAYS
        GOSUB FIND.INTEREST
        GOSUB UPDATE.RECORD
    END
RETURN

NEW.FIND.INTEREST:
    NO.OF.REC.AMT = DCOUNT(AMOUNT<1,DAYS.POS>,@SM)

    LOCATE TOT IN AMOUNT<1,DAYS.POS,1> BY 'AN' SETTING AMT.DETS THEN
        AA.INT.FLOATING.INDEX = EB.SystemTables.getRNew(AA.Interest.Interest.IntFloatingIndex)
        IF AA.INT.FLOATING.INDEX EQ '' AND INT.LOCAL.RATE NE '304' THEN
            AMT.RATE = REC.IN.DETAILS<3,DAYS.POS,AMT.DETS>
            Y.FIXED.RATE.REC.IN.DETAILSINTEREST = REC.IN.DETAILS<AbcTable.Abc2lnDepositRates.Percentage,DAYS.POS,AMT.DETS>
            EB.SystemTables.setRNew(AA.Interest.Interest.IntFixedRate,Y.FIXED.RATE.REC.IN.DETAILSINTEREST)

            
        END ELSE
            INT.RATE = REC.IN.DETAILS<AbcTable.Abc2lnDepositRates.Percentage,DAYS.POS,AMT.DETS>
            IF INT.RATE[1,1] EQ "-" THEN
                R.MARGIN<AA.Interest.Interest.IntMarginOper,1,1> = 'SUB'
                EB.SystemTables.setRNew(AA.Interest.Interest.IntMarginOper,R.MARGIN)
                INT.RATE = EREPLACE(INT.RATE,'-','')
                R.MARGIN.RATE<AA.Interest.Interest.IntMarginRate,1,1> = INT.RATE
                EB.SystemTables.setRNew(AA.Interest.Interest.IntMarginRate,R.MARGIN.RATE)
            END ELSE
                R.MARGIN.RATE<AA.Interest.Interest.IntMarginRate,1,1> = REC.IN.DETAILS<AbcTable.Abc2lnDepositRates.Percentage,DAYS.POS,AMT.DETS>
                EB.SystemTables.setRNew(AA.Interest.Interest.IntMarginRate,R.MARGIN.RATE)

            END
        END

    END ELSE
        IF AMT.DETS NE '1' THEN AMT.DETS = AMT.DETS-1
        IF EB.SystemTables.getRNew(AA.Interest.Interest.IntFloatingIndex) EQ '' AND INT.LOCAL.RATE NE '304' THEN
            Y.FIXED.RATE.NEW = REC.IN.DETAILS<AbcTable.Abc2lnDepositRates.Percentage,DAYS.POS,AMT.DETS>
            EB.SystemTables.setRNew(AA.Interest.Interest.IntFixedRate,Y.FIXED.RATE.NEW)
        END ELSE
            IF INT.RATE[1,1] EQ "-" THEN
                R.MARGIN<AA.Interest.Interest.IntMarginOper,1,1> = 'SUB'
                EB.SystemTables.setRNew(AA.Interest.Interest.IntMarginOper,R.MARGIN)
                INT.RATE = EREPLACE(INT.RATE,'-','')
                R.MARGIN.RATE<AA.Interest.Interest.IntMarginRate,1,1> = INT.RATE
                EB.SystemTables.setRNew(AA.Interest.Interest.IntMarginRate,R.MARGIN.RATE)
            END ELSE
                R.MARGIN.RATE<AA.Interest.Interest.IntMarginRate,1,1> = REC.IN.DETAILS<AbcTable.Abc2lnDepositRates.Percentage,DAYS.POS,AMT.DETS>
                EB.SystemTables.setRNew(AA.Interest.Interest.IntMarginRate,R.MARGIN.RATE)
            END
        END
    END

RETURN

REVAISABLE.RATE.SET:
    REV.SEL.CMD=''
    REV.SEL.LIST ='';
    REV.SEL.CMD = 'SELECT ' : FN.REV.RATE :' WITH @ID LIKE ' : DQUOTE(SQUOTE(INT.LOCAL.RATE:'MXN'):"...") :' BY-DSND @ID'  ; * ITSS - NYADAV - Added DQUOTE / SQUOTE
    REV.FORM.ID = INT.LOCAL.RATE : 'MXN': EFFECTIVE.DATE
    EB.DataAccess.Readlist(REV.SEL.CMD,REV.SEL.LIST,'',REV.NO.OF.REC,REV.ERR)

    LOCATE REV.FORM.ID IN REV.SEL.LIST BY 'DL' SETTING REV.POS THEN
    END

    EB.DataAccess.FRead(FN.REV.RATE,REV.SEL.LIST<REV.POS>,REC.REV.DETAILS,F.REV.RATE,REV.ERR.REC)
    EB.SystemTables.setRNew((AA.INT.FIXED.RATE),REC.REV.DETAILS<1>)

RETURN
FIND.INTEREST:


    INT.RATE = '';
    
    PRODUCT = R.ARRANGEMENT.ACTIVITY<AA.Framework.ArrangementActivity.ArrActProduct>
    BEGIN CASE
        CASE PRODUCT EQ 'DEPOSIT.PROMISSORY'
            INT.LOCAL.RATE = '301'
        CASE PRODUCT EQ 'DEPOSIT.FIXED.INT'
            INT.LOCAL.RATE = '302'
        CASE PRODUCT EQ 'DEPOSIT.VAR.INT'
            INT.LOCAL.RATE = '303'
            
        CASE PRODUCT EQ 'DEPOSIT.REVIEW.INT'
            INT.LOCAL.RATE = '304'
            
    END CASE
    IF INT.LOCAL.RATE EQ '304' THEN GOSUB REVAISABLE.RATE.SET

    IF GROUP.ID THEN
        SEL.INT.CMD = 'SELECT ' : FN.INT : ' WITH @ID LIKE "' : SQUOTE(INT.LOCAL.RATE) : '...':SQUOTE('MXN' : GROUP.ID) : '" BY-DSND @ID'   ;*ITSS - NYADAV - Added " / SQUOTE
        FORM.ID = INT.LOCAL.RATE:EFFECTIVE.DATE : 'MXN' :GROUP.ID
    END ELSE
        SEL.INT.CMD = 'SELECT ' : FN.INT : ' WITH @ID LIKE "' : SQUOTE(INT.LOCAL.RATE) : '...':SQUOTE('MXN') : '" BY-DSND @ID'    ;*ITSS - NYADAV - Added " / SQUOTE ;* LFCR_20250217_ContratacionPagareApp - E
        FORM.ID = INT.LOCAL.RATE:EFFECTIVE.DATE : 'MXN'
    END
    
    SEL.INT.LIST = ''
    EB.DataAccess.Readlist(SEL.INT.CMD,SEL.INT.LIST,'',NO.OF.REC,INT.ERR)

    LOCATE FORM.ID IN SEL.INT.LIST BY 'DL' SETTING POS1 THEN
        CRT POS1
    END
    ID.INT  = SEL.INT.LIST<POS1>
    EB.DataAccess.FRead(FN.INT,ID.INT,REC.IN.DETAILS,F.INT,INT.ERR.REC)

    TOTAL.DAYS = REC.IN.DETAILS<AbcTable.Abc2lnDepositRates.DayPeriod>
    AMOUNT = REC.IN.DETAILS<AbcTable.Abc2lnDepositRates.Amount>
    LOCATE NO.OF.DAYS IN TOTAL.DAYS<1,1> BY 'AN' SETTING DAYS.POS THEN
        GOSUB NEW.FIND.INTEREST
    END ELSE
        IF DAYS.POS NE '1' THEN DAYS.POS = DAYS.POS -1;
        GOSUB NEW.FIND.INTEREST
    END

RETURN

GET.CURRENT.ARR.AMT.DAYS:
    TM.RECORD  = '';
* ARRANGEMENT.ID<1,2> = 'YES'
    AA.ProductFramework.GetPropertyRecord('', ARRANGEMENT.ID, 'COMMITMENT', EFFECTIVE.DATE, 'TERM.AMOUNT', '', TM.RECORD, TM.ERR)
    NO.OF.DAYS = TM.RECORD<AA.TermAmount.TermAmount.AmtTerm>
    NO.OF.DAYS = EREPLACE(NO.OF.DAYS,'D','')
    IF NO.OF.DAYS ELSE
        TM.RECORD.CP='';
        AA.ProductFramework.GetPropertyRecord('', ARRANGEMENT.ID, 'RENEWAL', EFFECTIVE.DATE, 'CHANGE.PRODUCT', '', TM.RECORD.CP, TM.ERR)
        NO.OF.DAYS = TM.RECORD.CP<AA.ChangeProduct.ChangeProduct.CpChangeDate>
    END

    CURR.AMT = TM.RECORD<AA.TermAmount.TermAmount.AmtAmount>

    IF Y.FLAG.ID EQ 0 THEN    ;* JHF FyG 16.08.2016
        TOT + = CURR.AMT
    END

RETURN

UPDATE.INTEREST:

    GOSUB GET.GROUP.DETAILS
    GOSUB GET.CURRENT.ARR.AMT.DAYS
    GOSUB FIND.INTEREST

RETURN

CAL.TOTAL.AMOUNT:
    LOOP
        REMOVE ARR.GET.ID.GRP FROM SET.ACC.DET SETTING ARR.POS
    WHILE ARR.GET.ID.GRP : ARR.POS
        AmtCondition = '';
        AA.ProductFramework.GetPropertyRecord("",ARR.GET.ID.GRP, "", "", "TERM.AMOUNT", "",AmtCondition, errMsg)
        TOT+= AmtCondition<AA.TermAmount.TermAmount.AmtAmount>
    REPEAT
RETURN

GET.GROUP.DETAILS:
    GROUP.ID = '';
    Y.FLAG.ID = 0   ;* JHF 16.08.2016
    EB.DataAccess.FRead(FN.CLUB,SEL.LIST,R.CLUB.DETS,F.CLUB,CLUB.ERR)
    ACC.DETS = R.CLUB.DETS<AbcTable.AbcClubAhorro.Cuenta>
    GROUP.ID = R.CLUB.DETS<AbcTable.AbcClubAhorro.GroupClssific>
    LOOP
        REMOVE ACC.ID FROM ACC.DETS SETTING ACC.POS
    WHILE ACC.ID : ACC.POS
        SET.ACC.DET = '';

        EB.DataAccess.FRead(FN.SET.ACC,ACC.ID,SET.ACC.DET,F.SET.ACC,SET.ACC.ERR)

        Y.ARR.SET.ACC.DET = SET.ACC.DET ;* JHF FyG 16.08.2016

        CHANGE @VM TO @FM IN Y.ARR.SET.ACC.DET      ;* JHF FyG 16.08.2016

        LOCATE ARRANGEMENT.ID IN Y.ARR.SET.ACC.DET SETTING Y.ARR.POS THEN       ;* JHF FyG 16.08.2016
            Y.FLAG.ID = 1
        END

        GOSUB CAL.TOTAL.AMOUNT

    REPEAT

RETURN
UPDATE.RECORD:
    SET.ACC.NO = '';
    SET.ACC.NO = ACC.NO

    EB.DataAccess.FRead(FN.SET.ACC,SET.ACC.NO,SET.ACC.DET,F.SET.ACC,SET.ACC.ERR)
    LOCATE ARRANGEMENT.ID IN SET.ACC.DET<1,1> SETTING ARR.POS ELSE
        SET.ACC.DET<1,-1> = ARRANGEMENT.ID
        EB.DataAccess.FWrite(FN.SET.ACC,SET.ACC.NO,SET.ACC.DET)
    END

RETURN

DEL.PROCESS:

    SET.ACC.NO = '';
    SET.ACC.NO = ACC.NO
    AA.ProductFramework.GetPropertyRecord('', ARRANGEMENT.ID, 'SETTLEMENT', EFFECTIVE.DATE, 'SETTLEMENT', '', SETTLEMENT.RECORD, SETT.ERR)
    SETTLEMENT.RECORD = RAISE(SETTLEMENT.RECORD)
    ACC.NO = SETTLEMENT.RECORD<AA.Settlement.Settlement.SetPayinAccount>

    EB.DataAccess.FRead(FN.SET.ACC,SET.ACC.NO,SET.ACC.DET,F.SET.ACC,SET.ACC.ERR)

    LOCATE ARRANGEMENT.ID IN SET.ACC.DET<1,1> SETTING ARR.POS THEN
        DEL SET.ACC.DET<1,ARR.POS>
        EB.DataAccess.FWrite(FN.SET.ACC,SET.ACC.NO,SET.ACC.DET)
    END
RETURN

END
