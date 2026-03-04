* @ValidationCode : MjotMTU5NTczNjA5NzpDcDEyNTI6MTc1NTEyMTk3Nzc3OTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Aug 2025 18:52:57
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

SUBROUTINE ABC.VAL.FLAG.UPDATE.NVL
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.LocalReferences
    $USING AA.Framework
    $USING EB.Updates
    $USING  EB.Interface
        
    
    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
    
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    EB.DataAccess.Opf(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)
    
    Y.ID.ACCOUNT = EB.SystemTables.getIdNew()
    EB.DataAccess.FRead(FN.AA.ARRANGEMENT, Y.ID.ACCOUNT, R.AA.ARRANGEMENT,F.AA.ARRANGEMENT, Y.ERR.AA.ARRANGEMENT)
    
    
    Y.ID.CUSTOMER = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrCustomer>
    EB.DataAccess.FRead(FN.CUSTOMER, Y.ID.CUSTOMER, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUSTOMER)
    
    
    
    LREF.TABLE = "CUSTOMER"
    LREF.FIELD = "L.SUBE.NVL.DIG"
    EB.Updates.MultiGetLocRef(LREF.TABLE, LREF.FIELD, LREF.POS)
    Y.POS.SUBE.NVL.DIG   = LREF.POS<1,1>

    Y.LOCAL = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef>

    Y.FLAG.SUBE.NVL.DIG = Y.LOCAL<1,Y.POS.SUBE.NVL.DIG>

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
    
    IF Y.ERR.CUSTOMER EQ '' THEN
        
        IF (Y.FLAG.SUBE.NVL.DIG NE 'S') AND (Y.FLAG.SUBE.NVL.DIG NE 'N') THEN
            ETEXT ='NO ES POSIBLE CREAR LA CUENTA, ACTUALIZAR BANDERA [SUBE.NIVEL.DIGITAL] AL CLIENTE: ':Y.ID.CUSTOMER
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

RETURN

    
END
