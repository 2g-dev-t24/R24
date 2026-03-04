* @ValidationCode : Mjo2MjE4MDE2Mzg6Q3AxMjUyOjE3NTc5NjMyNzEzMzA6RWRnYXIgU2FuY2hlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 15 Sep 2025 14:07:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar Sanchez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE EB.AbcRemesas
SUBROUTINE ABC.LLENA.DEBIT.REMESAS
*===============================================================================
* Nombre de Programa : ABC.LLENA.DEBIT.REMESAS
* Compania           : ABC Capital
* Req. Jira          : NA
* Objetivo           : Autom Fld rtn para llenar la DEBIT.ACCT.NO en la version
*                      FUNDS.TRANSFER,ABC.REMESAS a partir de la parametrizacion
*                      ABC.REMESAS.PARAM
* Desarrollador      : Luis Cruz - Fyg Solutions
* Fecha Creacion     : 2025-09-04
* Modificaciones     :
*===============================================================================
* Subroutine Type : VERSION RTN
* Attached to : FUNDS.TRANSFER,ABC.REMESAS
* Attached as : Autom Fld rtn
* Primary Purpose : Rutina de llenado de DEBIT.ACCT.NO
*-----------------------------------------------------------------------
* Luis Cruz
* 04-09-2025
* Creacion de rutina componentizada
*-----------------------------------------------------------------------
* $INSERT I_COMMON - Not Used anymore;
* $INSERT I_EQUATE - Not Used anymore;
* $INSERT I_F.FUNDS.TRANSFER - Not Used anymore;
* $INSERT I_F.ACCOUNT - Not Used anymore;

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING FT.Contract
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.Template
    $USING EB.Display
    
    GOSUB INICIALIZA
    GOSUB GET.DEBIT.ACCT

RETURN
*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    FV.ABC.GENERAL.PARAM = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, FV.ABC.GENERAL.PARAM)

    Y.ID.GEN.PARAM = "ABC.REMESAS.PARAM"
    Y.LIST.PARAMS = ''  ;  Y.LIST.VALUES = ''
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.ID.GEN.PARAM, R.DATOS, FV.ABC.GENERAL.PARAM, ERR.PARAM)
    Y.LIST.PARAMS = RAISE(R.DATOS<AbcTable.AbcGeneralParam.NombParametro>)
    Y.LIST.VALUES = RAISE(R.DATOS<AbcTable.AbcGeneralParam.DatoParametro>)

    Y.CTA.DEBIT = ''
    Y.ERROR = ''

RETURN
*---------------------------------------------------------------
GET.DEBIT.ACCT:
*---------------------------------------------------------------
    LOCATE "DEBIT.ACCT" IN Y.LIST.PARAMS SETTING POS THEN
        Y.CTA.DEBIT = Y.LIST.VALUES<POS>
    END ELSE
        Y.ERROR = "NO EXISTE CUENTA PARAMETRIZADA EN REGISTRO"
    END

    IF Y.ERROR NE '' THEN
        EB.SystemTables.setEtext(Y.ERROR)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        R.NEW(FT.Contract.FundsTransfer.DebitAcctNo) = Y.CTA.DEBIT
        EB.Display.RebuildScreen()
    END

RETURN

END
