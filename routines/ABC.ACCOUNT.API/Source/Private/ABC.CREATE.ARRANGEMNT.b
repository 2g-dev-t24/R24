* @ValidationCode : MjotMTg5NzM1NDY0NjpDcDEyNTI6MTc1NzAwOTkzNjU5NjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Sep 2025 15:18:56
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
$PACKAGE AbcAccountApi


SUBROUTINE ABC.CREATE.ARRANGEMNT
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
    
    Y.V.FUNCTION    = EB.SystemTables.getVFunction()
    IF (Y.V.FUNCTION EQ 'A') THEN
        GOSUB MAP.ACCOUNT ; *Mapea los campos de AA ACTIVITY
        GOSUB CREAR.OFS.ACCOUNT ; *Crea y ejecuta el OFS de AA ACTIVITY
    END
*-----------------------------------------------------------------------------

*** <region name= MAP.ACCOUNT>
MAP.ACCOUNT:
*** <desc>Mapea los campos de AA ACTIVITY </desc>

    Y.ID.CUENTA = EB.SystemTables.getIdNew()
    
    
    R.AA<AA.Framework.ArrangementActivity.ArrActArrangement> = Y.ID.CUENTA
        
    
    R.AA<AA.Framework.ArrangementActivity.ArrActProduct>        = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Producto)
    R.AA<AA.Framework.ArrangementActivity.ArrActActivity>       = 'ACCOUNTS-NEW-ARRANGEMENT'
    R.AA<AA.Framework.ArrangementActivity.ArrActCurrency>       = 'MXN';*EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Currency)
    R.AA<AA.Framework.ArrangementActivity.ArrActCustomer>       = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Customer)
    R.AA<AA.Framework.ArrangementActivity.ArrActCustomerRole>   = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Rol)
        
    R.AA<AA.Framework.ArrangementActivity.ArrActProperty>       = 'BALANCE'
        
    Y.FILD.NAME1 = R.AA<AA.Framework.ArrangementActivity.ArrActFieldName>
    Y.FIELD.NAME1 = 'ALT.ID:5:1'
    R.AA<AA.Framework.ArrangementActivity.ArrActFieldName> = Y.FIELD.NAME1
        
    Y.VALUE  = R.AA<AA.Framework.ArrangementActivity.ArrActFieldValue>
    Y.VALUE  = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Celular)
    R.AA<AA.Framework.ArrangementActivity.ArrActFieldValue> = Y.VALUE
        
    
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
