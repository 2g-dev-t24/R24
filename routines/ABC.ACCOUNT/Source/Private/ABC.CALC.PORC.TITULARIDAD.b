* @ValidationCode : MjotMTE1Mjc2NzQzMTpDcDEyNTI6MTc1NTc0MTEzNzI2OTpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Aug 2025 22:52:17
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

SUBROUTINE ABC.CALC.PORC.TITULARIDAD
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
    Y.NOM.VERSION = ''
    Y.POR.TITULAR = ''
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
    Y.COTIS.PORCS = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.AsigIntCoti)
    Y.NUM.COTITUL = DCOUNT(Y.NOMB.COTS, @VM)

    IF (Y.CLAS.PERSON EQ 1) OR (Y.CLAS.PERSON EQ 2) THEN
        GOSUB CALCULA.PORCENTAJE
    END

    IF Y.POR.TITULAR NE '' THEN
        Y.POR.TITULAR = DROUND(Y.POR.TITULAR, 2)
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.TitPorc, Y.POR.TITULAR)
        EB.Display.RebuildScreen()
    END
    
RETURN
*-----------------------------------------------------------------------------
CALCULA.PORCENTAJE:
*-----------------------------------------------------------------------------
    Y.SUMA.PORCS = ''

    BEGIN CASE

        CASE Y.REGIMEN.CTA EQ 'CI'
            Y.POR.TITULAR = 100

        CASE Y.REGIMEN.CTA EQ 'CS'
            Y.POR.TITULAR = 100 / (Y.NUM.COTITUL + 1)

            COT.PORS = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.AsigIntCoti)
            FOR ITER.TIT = 1 TO Y.NUM.COTITUL
                COT.PORS<1,ITER.TIT> = DROUND(Y.POR.TITULAR, 2)
            NEXT ITER.TIT
            EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.AsigIntCoti, COT.PORS)
            
            tmp = EB.SystemTables.getT(AbcTable.AbcAcctLclFlds.AsigIntCoti)
            tmp<3>="NOINPUT"
            EB.SystemTables.setT(AbcTable.AbcAcctLclFlds.AsigIntCoti, tmp)

        CASE Y.REGIMEN.CTA EQ 'CM'

            GOSUB SUMA.PORCENTAJES
            IF Y.SUMA.PORCS EQ 0 THEN
                Y.POR.TITULAR = 100 / (Y.NUM.COTITUL + 1)
            END ELSE
                Y.POR.TITULAR = 100 - Y.SUMA.PORCS
            END
    END CASE
    
RETURN
*-----------------------------------------------------------------------------
SUMA.PORCENTAJES:
*-----------------------------------------------------------------------------
    FOR ITER.TIT = 1 TO Y.NUM.COTITUL
        Y.PORC.TITULAR = ''
        Y.PORC.TITULAR = FIELD(Y.COTIS.PORCS, @VM, ITER.TIT)
        Y.SUMA.PORCS += Y.PORC.TITULAR
    NEXT ITER.TIT
    
RETURN
*-----------------------------------------------------------------------------
END