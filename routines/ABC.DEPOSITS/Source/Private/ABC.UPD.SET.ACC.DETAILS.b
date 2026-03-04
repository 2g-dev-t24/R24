* @ValidationCode : MjotNTQxMDQzODc2OkNwMTI1MjoxNzYwOTgyMzc4NzI2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Oct 2025 14:46:18
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

SUBROUTINE ABC.UPD.SET.ACC.DETAILS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcTable
    $USING AA.Framework
    $USING AA.Interest
    $USING AA.ProductFramework
    $USING AA.TermAmount
    $USING EB.SystemTables
    $USING AA.Settlement
    $USING EB.Updates

*-----------------------------------------------------------------------------

    GOSUB INIT
    IF ACC.NO NE '' THEN GOSUB UPDATE.SET.ACC
RETURN

INIT:


    PRO.STATUS = AA.Framework.getC_aalocactivitystatus()["-",1,1]
    ARRANGEMENT.ID = AA.Framework.getArrId()         ;* Arrangement contract Id
    ACTIVITY.ID = AA.Framework.getC_aaloccurractivity()
    EFFECTIVE.DATE = AA.Framework.getC_aalocactivityeffdate()

    APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
    FIELD.NAME ='SETTLE.ACCT'
    FIELD.POS = '';
    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    SET.ACC.POS   = FIELD.POS<1,1>
    
    ACC.NO = AA.Framework.getRArrangementActivity()
    ACC.NO = ACC.NO<AA.Framework.ArrangementActivity.ArrActLocalRef>
RETURN

UPDATE.SET.ACC:
    EB.SystemTables.setRNew(AA.Settlement.Settlement.SetPayinAccount,ACC.NO)
    EB.SystemTables.setRNew(AA.Settlement.Settlement.SetPayoutAccount,ACC.NO)
RETURN
END

