* @ValidationCode : MjotMTI2NjQyNzQ4MDpDcDEyNTI6MTc1ODU5NDE2Njg5NDpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Sep 2025 23:22:46
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
*-----------------------------------------------------------------------------
SUBROUTINE ABC.OBT.CREDIT.ACC.CTA.GAR
*======================================================================================
* Nombre de Programa : ABC.OBT.CREDIT.ACC.CTA.GAR
* Objetivo           : Rutina que obtiene la cuenta de cr�dito para el traspaso
*                      a la cuenta garantizada.
*======================================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING FT.Contract
    $USING EB.Display
    $USING EB.Template

    Y.FUNCTION = EB.SystemTables.getVFunction()
    IF Y.FUNCTION EQ 'I' THEN
        GOSUB INICIALIZA
        GOSUB OBTIENE.DATOS
    END

RETURN

***********
INICIALIZA:
***********

    FN.EB.LOOKUP = 'F.EB.LOOKUP' ; F.EB.LOOKUP = ''
    EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)

    Y.CUENTA.ORI = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.ID.EB.LOOKUP = "ACLK*":Y.CUENTA.ORI

RETURN

**************
OBTIENE.DATOS:
**************
    EB.DataAccess.FRead(FN.EB.LOOKUP, Y.ID.EB.LOOKUP, R.EB.LOOKUP, F.EB.LOOKUP, Y.ERR)

    IF R.EB.LOOKUP THEN
        Y.CUENTA.EB = R.EB.LOOKUP<EB.Template.Lookup.LuOtherInfo>
        IF Y.CUENTA.EB NE '' THEN
            
*   EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAcctNo, Y.CUENTA.EB)
            EB.SystemTables.setComi(Y.CUENTA.EB)
*   EB.Display.RebuildScreen()
        END ELSE
            EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo)
            ETEXT = "La cuenta garantizada no existe."
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END ELSE
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo)
        ETEXT = "EL REGISTRO: " :Y.ID.EB.LOOKUP: " NO EXISTE"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

RETURN

END
