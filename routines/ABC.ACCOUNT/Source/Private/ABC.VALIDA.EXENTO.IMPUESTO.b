* @ValidationCode : MjoxODQwNzM3MDMxOkNwMTI1MjoxNzU2MTcyNDg1MzU0Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Aug 2025 22:41:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE AbcAccount

SUBROUTINE ABC.VALIDA.EXENTO.IMPUESTO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING EB.ErrorProcessing

    $USING AbcTable
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.EXENTO.IMP =''
    Y.EXENTO.IMP = EB.SystemTables.getComi()
    Y.EXENTO.IMP = Y.EXENTO.IMP[1,1]
    IF Y.EXENTO.IMP EQ '' THEN
        Y.EXENTO.IMP = 'N'
    END
    Y.ID.CUSTOMER   = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Customer)
    R.CUSTOMER      = ''
    Y.ERR.CUSTOMER  = ''
    YPOS.EX.IMP     = ''
    Y.IMP.CUS       = ''
    
    Y.APP = "CUSTOMER"
*    Y.FLD = "EXENTO.IMPUESTO"
    Y.FLD = "ITF.TAX.EXEMPT"
    Y.POS.FLD = ''
    EB.Updates.MultiGetLocRef(Y.APP, Y.FLD, Y.POS.FLD)
    YPOS.EX.IMP = Y.POS.FLD<1,1>
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    R.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CUSTOMER, Y.ERR.CUSTOMER)
    
    IF R.CUSTOMER NE '' THEN
        Y.IMP.CUS = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,YPOS.EX.IMP>
        Y.IMP.CUS = Y.IMP.CUS[1,1]
        IF Y.IMP.CUS EQ '' THEN
            Y.IMP.CUS = 'N'
        END
        IF Y.EXENTO.IMP NE Y.IMP.CUS THEN
            BEGIN CASE
                CASE Y.IMP.CUS EQ 'N'
                    ETEXT = "El cliente no es exento de impuestos"
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                CASE Y.IMP.CUS EQ 'S'
                    ETEXT = "El cliente es exento de impuestos"
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
            END CASE
        END
    END
    
RETURN
*-----------------------------------------------------------------------------
END