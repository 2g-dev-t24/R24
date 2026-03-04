* @ValidationCode : MjoyMTI5MTQ2NjQ5OkNwMTI1MjoxNzY2OTQ5MjU5ODQ3Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Dec 2025 16:14:19
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
$PACKAGE AbcAccount

SUBROUTINE ABC.INT.UPDATE(ACC.NO,EFFECTIVE.DATE,NO.OF.DAYS,CURR.AMT,PRODUCT,RET.ARRAY)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING AC.AccountOpening
    $USING EB.Display
    $USING ST.Customer
    $USING EB.Foundation
    $USING EB.Interface
    $USING EB.ErrorProcessing
    $USING AA.Framework
    $USING AA.TermAmount
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    TODAY   = EB.SystemTables.getToday()
    TOT     = 0
    
    FN.CLUB = 'F.ABC.CLUB.AHORRO'
    F.CLUB  = ''
    EB.DataAccess.Opf(FN.CLUB,F.CLUB)

    FN.SET.ACC  = 'F.ABC.CLUB.INVST.ACCOUNT'
    F.SET.ACC   = ''
    EB.DataAccess.Opf(FN.SET.ACC,F.SET.ACC)

    FN.INT  = 'F.ABC.2LN.DEPOSIT.RATES'
    F.INT   = ''
    EB.DataAccess.Opf(FN.INT,F.INT)

    FN.BASIC.INT    = 'F.BASIC.INTEREST'
    F.BASIC.INT     = ''
    EB.DataAccess.Opf(FN.BASIC.INT,F.BASIC.INT)

    FN.REV.RATE = 'F.REVAISABLE.INTEREST'
    F.REV.RATE  = ''
    EB.DataAccess.Opf(FN.REV.RATE,F.REV.RATE)

    BEGIN CASE
        CASE PRODUCT EQ 'DEPOSIT.PROMISSORY'
            INT.LOCAL.RATE = '301'
        CASE PRODUCT EQ 'DEPOSIT.FIXED.INT'
            INT.LOCAL.RATE = '302'
        CASE PRODUCT EQ 'DEPOSIT.VAR.INT'
            INT.LOCAL.RATE = '303'
            GOSUB GET.BASE.RATE
        CASE PRODUCT EQ 'DEPOSIT.REVIEW.INT'
            INT.LOCAL.RATE = '304'
            GOSUB REVAISABLE.RATE.SET
    END CASE

RETURN
*-----------------------------------------------------------------------------
GET.BASE.RATE:
*-----------------------------------------------------------------------------
    SEL.INT.BAS.CMD     = ''
    SEL.INT.BAS.LIST    = ''

    SEL.INT.BAS.CMD = 'SELECT ' : FN.BASIC.INT :' WITH @ID LIKE "' : SQUOTE(INT.LOCAL.RATE :"MXN" : TODAY[1,6]):'..." BY-DSND @ID'          ;*ITSS - NYADAV - Added " / SQUOTE
    EB.DataAccess.Readlist(SEL.INT.BAS.CMD,SEL.INT.BAS.LIST,'',NO.OF.INT.REC,REC.ERR)
    IF SEL.INT.BAS.LIST EQ '' THEN
        SEL.INT.BAS.CMD = 'SELECT ' : FN.BASIC.INT :' WITH @ID LIKE "' : SQUOTE(INT.LOCAL.RATE :"MXN" : TODAY[1,4]):'..." BY-DSND @ID'      ;*ITSS - NYADAV - Added " / SQUOTE
        EB.DataAccess.Readlist(SEL.INT.BAS.CMD,SEL.INT.BAS.LIST,'',NO.OF.INT.REC,REC.ERR)
        IF SEL.INT.BAS.LIST EQ '' THEN
            SEL.INT.BAS.CMD = 'SELECT ' : FN.BASIC.INT :' WITH @ID LIKE "' : SQUOTE(INT.LOCAL.RATE :"MXN") :'..." BY-DSND @ID'    ;*ITSS - NYADAV - Added " / SQUOTE
            EB.DataAccess.Readlist(SEL.INT.BAS.CMD,SEL.INT.BAS.LIST,'',NO.OF.INT.REC,REC.ERR)
        END
    END
    BASIC.INT.ID = INT.LOCAL.RATE:"MXN":TODAY

    LOCATE BASIC.INT.ID IN SEL.INT.BAS.LIST BY 'DL' SETTING BAS.POS ELSE
    END
    BAS.INT.RATE    = ''
    ID.BASIC.INT    = SEL.INT.BAS.LIST<BAS.POS>
    EB.DataAccess.FRead(FN.BASIC.INT,ID.BASIC.INT,REC.BASIC.INTEREST,F.BASIC.INT,BASIC.ERR)
    BAS.INT.RATE = REC.BASIC.INTEREST<1>

RETURN
*-----------------------------------------------------------------------------
REVAISABLE.RATE.SET:
*-----------------------------------------------------------------------------
    REV.SEL.CMD     = ''
    REV.SEL.LIST    = ''
    REV.SEL.CMD     = 'SELECT ' : FN.REV.RATE :' WITH @ID LIKE "' :SQUOTE(INT.LOCAL.RATE:'MXN'):'..." BY-DSND @ID'          ;*ITSS - NYADAV - Added " / SQUOTE
    REV.FORM.ID     = INT.LOCAL.RATE : 'MXN': TODAY
    EB.DataAccess.Readlist(REV.SEL.CMD,REV.SEL.LIST,'',REV.NO.OF.REC,REV.ERR)

    LOCATE REV.FORM.ID IN REV.SEL.LIST BY 'DL' SETTING REV.POS THEN
    END

    BAS.INT.RATE    = ''
    ID.REV.RATE     = REV.SEL.LIST<REV.POS>
    EB.DataAccess.FRead(FN.REV.RATE,ID.REV.RATE,REC.REV.DETAILS,F.REV.RATE,REV.ERR.REC)
    BAS.INT.RATE    = REC.REV.DETAILS<1>

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    SEL.LIST    = ''
    SEL.CMD     = "SELECT ":FN.CLUB : " WITH CUENTA EQ ": DQUOTE(ACC.NO)  ;*ITSS - NYADAV - Added DQUOTE
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)
    IF NO.OF.REC GE 1 THEN
        GOSUB UPDATE.INTEREST
    END ELSE
        GOSUB GET.CURRENT.ARR.AMT.DAYS
        GOSUB FIND.INTEREST
    END
    GOSUB CONCAT.BASE.RATE
    
RETURN
*-----------------------------------------------------------------------------
UPDATE.INTEREST:
*-----------------------------------------------------------------------------
    GOSUB GET.GROUP.DETAILS
    GOSUB GET.CURRENT.ARR.AMT.DAYS
    GOSUB FIND.INTEREST

RETURN
*-----------------------------------------------------------------------------
GET.GROUP.DETAILS:
*-----------------------------------------------------------------------------
    GROUP.ID    = ''
    ID.CLUB     = SEL.LIST<1>
    EB.DataAccess.FRead(FN.CLUB,ID.CLUB,R.CLUB.DETS,F.CLUB,CLUB.ERR)
    ACC.DETS = R.CLUB.DETS<3>
    GROUP.ID = R.CLUB.DETS<2>
    LOOP
        REMOVE ACC.ID FROM ACC.DETS SETTING ACC.POS
    WHILE ACC.ID : ACC.POS

        ACC.ID = ACC.ID
        EB.DataAccess.FRead(FN.SET.ACC,ACC.ID,SET.ACC.DET,F.SET.ACC,SET.ACC.ERR)

        GOSUB CAL.TOTAL.AMOUNT
    REPEAT

RETURN
*-----------------------------------------------------------------------------
CAL.TOTAL.AMOUNT:
*-----------------------------------------------------------------------------
    LOOP
        REMOVE ARR.GET.ID FROM SET.ACC.DET SETTING ARR.POS
    WHILE ARR.GET.ID : ARR.POS
        ARR.GET.ID = FIELD(ARR.GET.ID,'-',1,1)

*    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.GET.ID, 'TERM.AMOUNT', '', '', r.Ids, custCondition, r.Error)
        AA.Framework.GetArrangementConditions(ARR.GET.ID, 'TERM.AMOUNT', '', '', r.Ids, custCondition, r.Error)
        custCondition = RAISE(custCondition)

        AMT.AMOUNT = custCondition<AA.TermAmount.TermAmount.AmtAmount>
        TOT+= AMT.AMOUNT

    REPEAT

RETURN
*-----------------------------------------------------------------------------
GET.CURRENT.ARR.AMT.DAYS:
*-----------------------------------------------------------------------------
    NO.OF.DAYS = EREPLACE(NO.OF.DAYS,'D','')
    TOT + = CURR.AMT

RETURN
*-----------------------------------------------------------------------------
FIND.INTEREST:
*-----------------------------------------------------------------------------
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

    TOTAL.DAYS  = REC.IN.DETAILS<1>
    AMOUNT      = REC.IN.DETAILS<2>

    LOCATE NO.OF.DAYS IN TOTAL.DAYS<1,1> BY 'AN' SETTING DAYS.POS THEN
        NO.OF.REC.AMT = DCOUNT(AMOUNT<1,DAYS.POS>,SM)

        LOCATE TOT IN AMOUNT<1,DAYS.POS,1> BY 'AN' SETTING AMT.DETS THEN
            AMT.RATE = REC.IN.DETAILS<3,DAYS.POS,AMT.DETS>
            RET.ARRAY          = REC.IN.DETAILS<3,DAYS.POS,AMT.DETS>

        END ELSE
            IF AMT.DETS NE '1' THEN AMT.DETS = AMT.DETS-1
            RET.ARRAY                      = REC.IN.DETAILS<3,DAYS.POS,AMT.DETS>
        END
    END ELSE
        IF DAYS.POS NE '1' THEN DAYS.POS = DAYS.POS-1
        NO.OF.REC.AMT = DCOUNT(AMOUNT<1,DAYS.POS>,SM)
        LOCATE TOT IN AMOUNT<1,DAYS.POS,1> BY 'AN' SETTING AMT.DETS THEN
            AMT.RATE = REC.IN.DETAILS<3,DAYS.POS,AMT.DETS>
            RET.ARRAY          = REC.IN.DETAILS<3,DAYS.POS,AMT.DETS>
        END ELSE
            IF AMT.DETS NE '1' THEN AMT.DETS = AMT.DETS-1
            RET.ARRAY                      = REC.IN.DETAILS<3,DAYS.POS,AMT.DETS>
        END

    END

RETURN
*-----------------------------------------------------------------------------
CONCAT.BASE.RATE:
*-----------------------------------------------------------------------------
    IF INT.LOCAL.RATE EQ '303' OR INT.LOCAL.RATE EQ '304' THEN
        IF RET.ARRAY[1,1] EQ '-' THEN
            BAS.INT.RATE = BAS.INT.RATE - RET.ARRAY[2,99]
        END ELSE
            BAS.INT.RATE = BAS.INT.RATE + RET.ARRAY
        END
        RET.ARRAY = BAS.INT.RATE
    END
    
RETURN
*-----------------------------------------------------------------------------
END

