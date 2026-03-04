* @ValidationCode : MjoxMTg0MzEyMzU2OkNwMTI1MjoxNzYwOTgxMTk4OTYxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Oct 2025 14:26:38
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

SUBROUTINE ABC.TO.UPD.INVST.ACCOUNT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

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
    $USING EB.API
    
    
    
    GOSUB INIT

    GOSUB UPD.ACC.DETS

RETURN

INIT:
    PRO.STATUS = AA.Framework.getC_aalocactivitystatus()["-",1,1]
    
    ARRANGEMENT.ID = AA.Framework.getArrId()           ;* Arrangement contract Id
    ACTIVITY.ID = AA.Framework.getC_aaloccurractivity()
    EFFECTIVE.DATE = AA.Framework.getC_aalocactivityeffdate()

    FN.CLUB = 'F.ABC.CLUB.AHORRO'
    F.CLUB = ''
    EB.DataAccess.Opf(FN.CLUB,F.CLUB)

    FN.SET.ACC= 'F.ABC.CLUB.INVST.ACCOUNT'
    F.SET.ACC= ''
    EB.DataAccess.Opf(FN.SET.ACC,F.SET.ACC)


RETURN

UPD.ACC.DETS:

    ACC.NO = EB.SystemTables.getRNew(AA.Settlement.Settlement.SetPayinAccount)
    IF ACC.NO EQ '' THEN ACC.NO = EB.SystemTables.getRNew(AA.Settlement.Settlement.SetPayinAccount)


    GOSUB UPDATE.RECORD

RETURN

UPDATE.RECORD:

    EB.DataAccess.FRead(FN.SET.ACC,ACC.NO,SET.ACC.DET,F.SET.ACC,SET.ACC.ERR)
    LOCATE ARRANGEMENT.ID IN SET.ACC.DET<AbcTable.AbcClubInvstAccount.ArrangementId,1> SETTING ARR.POS ELSE
        SET.ACC.DET<AbcTable.AbcClubInvstAccount.ArrangementId,-1> = ARRANGEMENT.ID
        EB.DataAccess.FWrite(FN.SET.ACC,ACC.NO,SET.ACC.DET)
    END


RETURN
UPDATE.NO.OF.DAYS:

    FN.ABC.LEG.NO.OF.DAYS='F.ABC.LEG.NO.OF.DAYS'
    F.ABC.LEG.NO.OF.DAYS='';
    EB.DataAccess.Opf(FN.ABC.LEG.NO.OF.DAYS,F.ABC.LEG.NO.OF.DAYS)

    ABC.LEG.NO.OF.DAYS.ID=AA.Framework.getArrId()     ;* Arrangement contract Id
    ORIGINAL.FROM.DATE =AA.Framework.getRArrangementActivity()
    ORIGINAL.FROM.DATE = ORIGINAL.FROM.DATE<15>

    AA.ProductFramework.GetPropertyRecord('', ARRANGEMENT.ID, 'COMMITMENT', EFFECTIVE.DATE, 'TERM.AMOUNT', '', TM.RECORD, TM.ERR)
    FINAL.MAT.DATE = TM.RECORD<AA.TermAmount.TermAmount.AmtMaturityDate>
    NEW.NO.OF.DAYS='C';

    EB.API.Cdd('',ORIGINAL.FROM.DATE,FINAL.MAT.DATE,NEW.NO.OF.DAYS)
    ABC.LEG.NO.OF.DAYS.RECORD='';
    ABC.LEG.NO.OF.DAYS.RECORD=NEW.NO.OF.DAYS;


    EB.DataAccess.FWrite(FN.ABC.LEG.NO.OF.DAYS,ABC.LEG.NO.OF.DAYS.ID,ABC.LEG.NO.OF.DAYS.RECORD)

RETURN

END

