* @ValidationCode : MjoxMzUzMDYyMDgxOkNwMTI1MjoxNzYwOTgyMDUxNDA5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Oct 2025 14:40:51
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

SUBROUTINE ABC.UPD.DEP.ACC.DETAILS
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

    IF PRO.STATUS EQ 'UNAUTH' AND ACTIVITY.ID EQ "DEPOSITS-NEW-ARRANGEMENT" THEN
        EB.DataAccess.FRead(FN.CUS,CUS.ID,R.CUS.REC,F.CUS,CUS.ERR)
        EB.SystemTables.setRNew(AA.Officers.Officers.OffPrimaryOfficer,R.CUS.REC<ST.Customer.Customer.EbCusAccountOfficer>)
        OFF.ID=R.CUS.REC<ST.Customer.Customer.EbCusAccountOfficer>
    END

    IF PRO.STATUS EQ 'UNAUTH' AND ACTIVITY.ID EQ "DEPOSITS-TAKEOVER-ARRANGEMENT" THEN
        OFF.ID = EB.SystemTables.getRNew(AA.Officers.Officers.OffPrimaryOfficer)
    END

    SET.OFF.DET ='';

    EB.DataAccess.FRead(FN.SET.ACC,OFF.ID,SET.OFF.DET,F.SET.ACC,SET.OFF.ERR)

    LOCATE ARRANGEMENT.ID IN SET.OFF.DET<AbcTable.AbcClubInvstAccount.ArrangementId,1> SETTING OFF.POS ELSE
        SET.OFF.DET<AbcTable.AbcClubInvstAccount.ArrangementId,-1> = ARRANGEMENT.ID
        EB.DataAccess.FWrite(FN.SET.ACC,OFF.ID,SET.OFF.DET)
    END


RETURN

END

