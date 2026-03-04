* @ValidationCode : MjoxNDM3NzI4Mzg2OkNwMTI1MjoxNzU0OTIwMzQ5MTQ5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Aug 2025 10:52:29
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

SUBROUTINE ABC.BENEFICIARIO.PORCJ
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING EB.ErrorProcessing

    $USING AbcTable
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.TOT.PORCJ = 0
    Y.ARR.PORCJ = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.BenPorcentaje)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.ARR.PORCJ THEN
        Y.CON.PORCJ = DCOUNT(Y.ARR.PORCJ,@VM)
        FOR Y = 1 TO Y.CON.PORCJ
            Y.PORCENTAJE = FIELD(Y.ARR.PORCJ,@VM,Y)
            DISPLAY Y.PORCENTAJE
            Y.TOT.PORCJ += Y.PORCENTAJE
        NEXT Y

        IF Y.TOT.PORCJ NE 100 THEN
            ETEXT = 'LA SUMATORIA DE PORCENTAJE BENEFICIARIO ES DIFERENTE AL 100%'
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END ELSE
        ETEXT = 'EL PORCENTAJE BENEFICIARIO NO PUEDE ESTAR VACIO'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
RETURN
*-----------------------------------------------------------------------------
END