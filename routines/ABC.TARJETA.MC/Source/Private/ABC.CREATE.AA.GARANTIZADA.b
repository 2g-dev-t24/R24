* @ValidationCode : Mjo3NzUxNjkzMzM6Q3AxMjUyOjE3NTgxMjUxMjI5MDY6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Sep 2025 13:05:22
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
$PACKAGE AbcTarjetaMc
SUBROUTINE ABC.CREATE.AA.GARANTIZADA
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.API
    $USING EB.Interface
    $USING AC.AccountOpening
    $USING AA.Framework
    $USING AbcTable
    $USING EB.Updates
    $USING EB.Foundation
    $USING EB.ErrorProcessing
    
    
    GOSUB MAP.ACCOUNT ; *Mapea los campos de AA ACTIVITY
    GOSUB CREAR.OFS.ACCOUNT ; *Crea y ejecuta el OFS de AA ACTIVITY

*-----------------------------------------------------------------------------

*** <region name= MAP.ACCOUNT>
MAP.ACCOUNT:
*** <desc>Mapea los campos de AA ACTIVITY </desc>
    Y.ID.CUENTA = EB.SystemTables.getIdNew()
*Y.V.FUNCTION    = EB.SystemTables.getVFunction()
    R.AA<AA.Framework.ArrangementActivity.ArrActArrangement> = Y.ID.CUENTA
    R.AA<AA.Framework.ArrangementActivity.ArrActProduct>        = 'ABC.GAR.SAVINGS.ACCOUNT'
    R.AA<AA.Framework.ArrangementActivity.ArrActActivity>       = 'ACCOUNTS-NEW-ARRANGEMENT'
    R.AA<AA.Framework.ArrangementActivity.ArrActCurrency>       = 'MXN'
    R.AA<AA.Framework.ArrangementActivity.ArrActEffectiveDate>  = EB.SystemTables.getToday()
    R.AA<AA.Framework.ArrangementActivity.ArrActCustomer>       = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Customer)
    R.AA<AA.Framework.ArrangementActivity.ArrActFieldName>  = ""
    R.AA<AA.Framework.ArrangementActivity.ArrActFieldValue> = ""
    R.AA<AA.Framework.ArrangementActivity.ArrActProperty> = ""
    
    R.AA<AA.Framework.ArrangementActivity.ArrActProperty> = 'SETTLEMENT'
    
*    R.AA<AA.Framework.ArrangementActivity.ArrActFieldName, 1, 1> = 'DEFAULT.SETTLEMENT.ACCOUNT'
*    R.AA<AA.Framework.ArrangementActivity.ArrActFieldName,  1, 2> = 'PAYOUT.ACCOUNT'
 
    Y.FIELD.NAME = R.AA<AA.Framework.ArrangementActivity.ArrActFieldName>
    Y.FIELD.NAME<1,1>  = 'DEFAULT.SETTLEMENT.ACCOUNT'
    Y.FIELD.NAME<1,1,-1> = 'PAYOUT.ACCOUNT:1:1'
    Y.FIELD.NAME<1,1,-1> = 'PAYOUT.ACCOUNT:2:1'
    
    R.AA<AA.Framework.ArrangementActivity.ArrActFieldName> = Y.FIELD.NAME
    
  
    Y.VALUE         = R.AA<AA.Framework.ArrangementActivity.ArrActFieldValue>
    Y.VALUE<1,1>      = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.IntLiquAcct)
    Y.VALUE<1,1,-1>     = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.IntLiquAcct)
    Y.VALUE<1,1,-1>     = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.IntLiquAcct)
    
    R.AA<AA.Framework.ArrangementActivity.ArrActFieldValue> = Y.VALUE
    
*    R.AA<AA.Framework.ArrangementActivity.ArrActFieldValue, 1, 1> = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.IntLiquAcct)
*    R.AA<AA.Framework.ArrangementActivity.ArrActFieldValue, 1, 2> = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.IntLiquAcct)
    
RETURN

*-----------------------------------------------------------------------------
CREAR.OFS.ACCOUNT:
*** <desc>Crea y ejecuta el OFS de AA ACTIVITY</desc>
*-----------------------------------------------------------------------------

    Y.OFS.REQUEST   = ''
    Y.OFS.APP       = 'AA.ARRANGEMENT.ACTIVITY'
    Y.OFS.VERSION   = 'AA.ARRANGEMENT.ACTIVITY,'
    Y.ID            = ''
    Y.ID.CUSTOMER   = ''
    Y.NO.OF.AUTH    = 0
    Y.GTSMODE       = ''
    
    EB.Foundation.OfsBuildRecord(Y.OFS.APP,'I','PROCESS',Y.OFS.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.CUSTOMER,R.AA,Y.OFS.REQUEST)
    
    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)
    IF Error THEN
        EB.SystemTables.setEtext(Error)
        EB.ErrorProcessing.StoreEndError()
    END
RETURN

END
