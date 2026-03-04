* @ValidationCode : MjoyMTA2NjE4NTQxOkNwMTI1MjoxNzU1NzEyNzkxNDM1Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Aug 2025 14:59:51
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

SUBROUTINE ABC.VAL.REGIMEN.CTA
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
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
    Y.CUSTOMER.ID = ''
    Y.CLAS.PERSON = ''
    Y.REGIMEN.CTA = ''
    Y.COTIS.PORCS = ''
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.CUSTOMER.ID = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Customer)
    REG.CUSTOMER = ST.Customer.Customer.Read(Y.CUSTOMER.ID, ERR.CUST)
    
    IF REG.CUSTOMER NE '' THEN
        Y.CLAS.PERSON = REG.CUSTOMER<ST.Customer.Customer.EbCusSector>[1,1]
    END ELSE
        EB.SystemTables.setAf(AbcTable.AbcAcctLclFlds.Customer)
        ETEXT = "NO SE ENCONTRO CLIENTE " : Y.CUSTOMER.ID
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    Y.REGIMEN.CTA = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.RegimenCuenta)
    Y.NOMB.COTS = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.IdCoti)
    Y.NUM.COTITUL = DCOUNT(Y.NOMB.COTS, @VM)
    
    EB.SystemTables.setAf(AbcTable.AbcAcctLclFlds.RegimenCuenta)
    EB.SystemTables.setAv(0)
    EB.SystemTables.setAs(0)

    IF (Y.CLAS.PERSON EQ 1) OR (Y.CLAS.PERSON EQ 2) THEN
        IF (Y.REGIMEN.CTA EQ 'CS') OR (Y.REGIMEN.CTA EQ 'CM') THEN
            IF Y.NUM.COTITUL LT 1 THEN
                ETEXT = "DEBE EXISTIR AL MENOS UN COTITULAR PARA REGIMEN " : Y.REGIMEN.CTA
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END
        END

        IF Y.REGIMEN.CTA EQ 'CI' THEN
            IF Y.NUM.COTITUL GT 0 THEN
                ETEXT = "NO SE PERMITEN COTITULARES PARA REGIMEN " : Y.REGIMEN.CTA
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END
        END
    END
    
RETURN
*-----------------------------------------------------------------------------
END