* @ValidationCode : MjotMTYxNDUxMjQ4ODpDcDEyNTI6MTc2OTEzMDM0OTY4NTpFZGdhcjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Jan 2026 19:05:49
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
SUBROUTINE ABC.CAL.CAUSAL.REV(CUSTOMER.ID)
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
    $USING EB.Service
    $USING ST.Customer
*-----------------------------------------------------------------------------

    GOSUB OBTIENE.CAUSAL.REV
    GOSUB GUARDA.REGISTRO

RETURN

*******************
OBTIENE.CAUSAL.REV:
*******************

    RESULT = '0'
    FN.CUSTOMER = AbcCob.getFnCustomerRev()
    F.CUSTOMER = AbcCob.getFCustomerRev()
    IF CUSTOMER.ID ELSE
        RETURN
    END
    EB.DataAccess.CacheRead(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,YERR)
    IF R.CUSTOMER THEN
        Y.LOCAL.REF = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef>
    END
    Y.TIP.IPAB.GARAN.POS = AbcCob.getTipIpabGaranPosRev()
    Y.SECTOR.CNBV.POS = AbcCob.getSectorCnbvPosRev()
    
    Y.TIP.IPAB.GARAN =  Y.LOCAL.REF<1,Y.TIP.IPAB.GARAN.POS>
    Y.SECTOR.CNBV    = Y.LOCAL.REF<1,Y.SECTOR.CNBV.POS>
    
    FN.ABC.SDO.COMP.IPAB = AbcCob.getFnAbcSdoCompIpabRev()
    F.ABC.SDO.COMP.IPAB = AbcCob.getFAbcSdoCompIpabRev()
       
    FN.ABC.SECTOR.CNBV = AbcCob.getFnAbcSecCnbvRev()
    F.ABC.SECTOR.CNBV = AbcCob.getFAbcSecCnbvRev()

    GOSUB LOCKED.EVENTS

    IF RESULT EQ 3 THEN
        RETURN
    END

    IF Y.TIP.IPAB.GARAN NE 'NO' THEN
        ABC.SECTOR.CNBV.ID = Y.SECTOR.CNBV
        EB.DataAccess.CacheRead(FN.ABC.SECTOR.CNBV,ABC.SECTOR.CNBV.ID,R.ABC.SECTOR.CNBV,YERR)
        IF R.ABC.SECTOR.CNBV THEN
            Y.ABC.SECTOR.CNBV.TIPO.IPAB.GAR = R.ABC.SECTOR.CNBV<AbcTable.AbcSectorCnbv.TipoIpabGar>
            IF Y.ABC.SECTOR.CNBV.TIPO.IPAB.GAR NE 'NO' THEN
                RESULT = '0'
            END
        END ELSE
            RESULT = '0'
        END
    END

RETURN
 
**************
LOCKED.EVENTS:
**************
    AC.LOCKED.CUSTOMER.LIST = AbcCob.getAcLockedCustomerListRev()
    LOCATE CUSTOMER.ID IN AC.LOCKED.CUSTOMER.LIST SETTING POS THEN
        RESULT = '3'
    END ELSE
        RESULT = '1'
    END

RETURN

****************
GUARDA.REGISTRO:
****************

    R.SDO.COM<AbcTable.AbcSdoCompIpab.CausalRevision> = RESULT
    R.SDO.COM<AbcTable.AbcSdoCompIpab.SaldoNeto> = "0"
    R.SDO.COM<AbcTable.AbcSdoCompIpab.SaldoVencido> = "0"

    EB.DataAccess.FWrite(FN.ABC.SDO.COMP.IPAB, CUSTOMER.ID, R.SDO.COM)
    
RETURN

END

