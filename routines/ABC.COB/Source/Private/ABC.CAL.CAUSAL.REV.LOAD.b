* @ValidationCode : Mjo0MjA0OTM2MzE6Q3AxMjUyOjE3NjkxMDk4MTA1MDc6RWRnYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2026 13:23:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcCob
SUBROUTINE ABC.CAL.CAUSAL.REV.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING EB.Updates
    $USING AbcTable
*-----------------------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)
    AbcCob.setFnCustomerRev(FN.CUSTOMER)
    AbcCob.setFCustomerRev(F.CUSTOMER)
 
    FN.ABC.SECTOR.CNBV = 'F.ABC.SECTOR.CNBV'
    F.ABC.SECTOR.CNBV = ''
    EB.DataAccess.Opf(FN.ABC.SECTOR.CNBV,F.ABC.SECTOR.CNBV)
    AbcCob.setFnAbcSecCnbvRev(FN.ABC.SECTOR.CNBV)
    AbcCob.setFAbcSecCnbvRev(F.ABC.SECTOR.CNBV)

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    EB.DataAccess.Opf(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)
    AbcCob.setFnAcLockedEventsRev(FN.AC.LOCKED.EVENTS)
    AbcCob.setFAcLockedEventsRev(F.AC.LOCKED.EVENTS)

    FN.ABC.SDO.COMP.IPAB = 'F.ABC.SDO.COMP.IPAB'
    F.ABC.SDO.COMP.IPAB = ''
    EB.DataAccess.Opf(FN.ABC.SDO.COMP.IPAB,F.ABC.SDO.COMP.IPAB)
    AbcCob.setFnAbcSdoCompIpabRev(FN.ABC.SDO.COMP.IPAB)
    AbcCob.setFAbcSdoCompIpabRev(F.ABC.SDO.COMP.IPAB)

    Y.LOCAL.REF.APP   = 'CUSTOMER'
    Y.LOCAL.REF.FIELD =  'L.TIP.IPAB.GARAN':@VM:'CNBV.SECTOR'

    Y.LOCAL.REF.POS   = ''

    EB.Updates.MultiGetLocRef(Y.LOCAL.REF.APP,Y.LOCAL.REF.FIELD,Y.LOCAL.REF.POS)

    Y.TIP.IPAB.GARAN.POS = Y.LOCAL.REF.POS<1,1>
    Y.SECTOR.CNBV.POS    = Y.LOCAL.REF.POS<1,2>
    AbcCob.setTipIpabGaranPosRev(Y.TIP.IPAB.GARAN.POS)
    AbcCob.setSectorCnbvPosRev(Y.SECTOR.CNBV.POS)
RETURN

END

