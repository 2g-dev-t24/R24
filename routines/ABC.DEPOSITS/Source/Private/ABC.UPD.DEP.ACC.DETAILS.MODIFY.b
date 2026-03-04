* @ValidationCode : MjoxMzMzNDU2MjUzOkNwMTI1MjoxNzYwOTg2MzU0NzY2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Oct 2025 15:52:34
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

SUBROUTINE ABC.UPD.DEP.ACC.DETAILS.MODIFY
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
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
    $USING ST.Customer
    $USING AA.Officers
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB UPDATE.OFF.DETAILS
RETURN

INIT:

    FN.CUS = 'F.CUSTOMER'
    F.CUS =''
    EB.DataAccess.Opf(FN.CUS,F.CUS)

    FN.CLUB = 'F.ABC.CLUB.AHORRO'
    F.CLUB = ''
    EB.DataAccess.Opf(FN.CLUB,F.CLUB)

    FN.SET.ACC = 'F.ABC.CLUB.INVST.ACCOUNT'
    F.SET.ACC='';
    EB.DataAccess.Opf(FN.SET.ACC,F.SET.ACC)

    PRO.STATUS = AA.Framework.getC_aalocactivitystatus()["-",1,1]
    ARRANGEMENT.ID = AA.Framework.getArrId()         ;* Arrangement contract Id
    ACTIVITY.ID = AA.Framework.getC_aaloccurractivity()
    EFFECTIVE.DATE = AA.Framework.getC_aalocactivityeffdate()
    AAA.REF = AA.Framework.getRArrangementActivity()
    CUS.ID = AAA.REF<AA.Framework.ArrangementActivity.ArrActCustomer>
RETURN

UPDATE.OFF.DETAILS:

    IF ACTIVITY.ID EQ "DEPOSITS-UPDATE-OFFICER" THEN
        EB.DataAccess.FRead(FN.CUS,CUS.ID,R.CUS.REC,F.CUS,CUS.ERR)
        EB.SystemTables.setRNew(AA.Officers.Officers.OffPrimaryOfficer,R.CUS.REC<ST.Customer.Customer.EbCusAccountOfficer>)
        OFF.ID=R.CUS.REC<ST.Customer.Customer.EbCusAccountOfficer>


        SET.OFF.DET ='';

        EB.DataAccess.FRead(FN.SET.ACC,OFF.ID,SET.OFF.DET,F.SET.ACC,SET.OFF.ERR)

        LOCATE ARRANGEMENT.ID IN SET.OFF.DET<AbcTable.AbcClubInvstAccount.ArrangementId,1> SETTING OFF.POS ELSE
            SET.OFF.DET<AbcTable.AbcClubInvstAccount.ArrangementId,-1> = ARRANGEMENT.ID
            EB.DataAccess.FWrite(FN.SET.ACC,OFF.ID,SET.OFF.DET)
        END
        GOSUB GET.OLD.CONDITION
    END
RETURN
GET.OLD.CONDITION:
    AA.Framework.GetArrangementConditions(ARRANGEMENT.ID, 'OFFICERS', '', '', o.Ids, offCondition, o.Error)
    
    offCondition = RAISE(offCondition)
    OFF.NO = offCondition<AA.Officers.Officers.OffPrimaryOfficer>

    SET.OFF.DET.OLD ='';

    EB.DataAccess.FRead(FN.SET.ACC,OFF.NO,SET.OFF.DET.OLD,F.SET.ACC,SET.OFF.ERR.OLD)

    LOCATE ARRANGEMENT.ID IN SET.OFF.DET.OLD<AbcTable.AbcClubInvstAccount.ArrangementId,1> SETTING OFF.POS.OLD THEN
        DEL SET.OFF.DET.OLD<AbcTable.AbcClubInvstAccount.ArrangementId,OFF.POS.OLD>
        IF SET.OFF.DET.OLD EQ '' THEN
            EB.DataAccess.FDelete(FN.SET.ACC,OFF.NO)
        END ELSE
            EB.DataAccess.FWrite(FN.SET.ACC,OFF.NO,SET.OFF.DET.OLD)
        END

        RETURN
    END

