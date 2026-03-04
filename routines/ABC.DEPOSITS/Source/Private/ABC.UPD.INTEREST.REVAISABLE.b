* @ValidationCode : MjoxOTUwNzg0NTI4OkNwMTI1MjoxNzYwOTg0NzcwNjQ4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Oct 2025 15:26:10
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

SUBROUTINE ABC.UPD.INTEREST.REVAISABLE
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
    $USING EB.Updates
*-----------------------------------------------------------------------------

    FN.REV.RATE='F.REVAISABLE.INTEREST'
    F.REV.RATE = ''
    EB.DataAccess.Opf(FN.REV.RATE,F.REV.RATE)
    
    EFFECTIVE.DATE = AA.Framework.getC_aalocactivityeffdate()
    INT.RATE = '';
    
    INT.PROP.REC = AA.Framework.getProdPropRecord()
    

    APP.NAME = 'AA.ARRANGEMENT.ACTIVITY':@FM:'AA.ARR.INTEREST'
    FIELD.NAME ='SETTLE.ACCT':@FM:'CLUB.INV.RATE'

    FIELD.POS = '';

    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    SET.ACC.POS   = FIELD.POS<1,1>
    INVEST.ID.POS = FIELD.POS<2,1>

    INT.LOCAL.RATE = INT.PROP.REC<AA.Interest.Interest.IntLocalRef,INVEST.ID.POS>

    IF INT.LOCAL.RATE EQ '304' THEN GOSUB REVAISABLE.RATE.SET

RETURN
REVAISABLE.RATE.SET:




    REV.SEL.CMD=''
    REV.SEL.LIST ='';
    REV.SEL.CMD = 'SELECT ' : FN.REV.RATE :' WITH @ID LIKE "' : SQUOTE(INT.LOCAL.RATE :'MXN'):'..." BY-DSND @ID'  ; * ITSS - ADOLFO - Added " / SQUOTE
    REV.FORM.ID = INT.LOCAL.RATE : 'MXN': EFFECTIVE.DATE
    EB.DataAccess.Readlist(REV.SEL.CMD,REV.SEL.LIST,'',REV.NO.OF.REC,REV.ERR)

    LOCATE REV.FORM.ID IN REV.SEL.LIST BY 'DL' SETTING REV.POS THEN
    END

    EB.DataAccess.FRead(FN.REV.RATE,REV.SEL.LIST<REV.POS>,REC.REV.DETAILS,F.REV.RATE,REV.ERR.REC)

    EB.SystemTables.setRNew(AA.Interest.Interest.IntFixedRate,REC.REV.DETAILS<AbcTable.RevaisableInterest.InterestRate>)
    NEW.RATE = '';
    NEW.RATE = REC.REV.DETAILS<AbcTable.RevaisableInterest.InterestRate>
RETURN
END

