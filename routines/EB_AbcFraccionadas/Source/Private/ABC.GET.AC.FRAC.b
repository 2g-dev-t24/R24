* @ValidationCode : MjotMTkzNjM0ODIwMjpDcDEyNTI6MTc3MDQwMjgzOTIxODpmZXJuYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Feb 2026 12:33:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ferna
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE EB.AbcFraccionadas
SUBROUTINE ABC.GET.AC.FRAC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*       Rutina:      ABC.GET.AC.FRAC
*       Req:         Banca Empresarial
*       Autor:       FyG
*       Fecha:       28 Octubre 2025
*       Tipo:        ROUTINE
*       Descripcion: Rutina para Asignar la cuenta
*-----------------------------------------------------------------------------

* $INSERT I_COMMON - Not Used anymore;
* $INSERT I_EQUATE - Not Used anymore;
* $INSERT I_F.FUNDS.TRANSFER - Not Used anymore;
* $INSERT I_F.ACCOUNT - Not Used anymore;
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING AbcGetGeneralParam
    

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

RETURN

*---------------------------------------------------------------
INITIALIZE:
*---------------------------------------------------------------

    Y.ID.GEN.PARAM = "ABC.CTA.FRAC.UALA.2"
    Y.LIST.PARAMS = ''  ;  Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    Y.CTA.DEBIT = ''
    Y.ERROR = ''

RETURN

*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    Y.CUENTA = ''
    Y.CUENTA = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)

    IF Y.CUENTA THEN
        RETURN
    END

    LOCATE "DEBIT.ACCT" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CTA.DEBIT = Y.LIST.VALUES<POS>
    END ELSE
        Y.ERROR = "NO SE ENCONTRO CUENTA PARAMETRIZADA"
    END

    IF Y.ERROR NE '' THEN
        EB.SystemTables.setEtext(Y.ERROR)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAcctNo, Y.CTA.DEBIT)
        EB.Display.RebuildScreen()
    END

RETURN

*---------------------------------------------------------------
FINALIZE:
*---------------------------------------------------------------

RETURN

END
