* @ValidationCode : Mjo4NzUyMjU1NjU6Q3AxMjUyOjE3NjA0MDIyMTIxMjc6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Oct 2025 21:36:52
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
$PACKAGE AbcSaldoOperPasivasAcc

SUBROUTINE ABC.REP.SALDO.OPER.PASIVAS.PRE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING EB.Updates
*-----------------------------------------------------------------------------
    FN.INF = 'F.TMP.REP.SAL.OP'
    F.INF = ''
    EB.DataAccess.Opf(FN.INF, F.INF)
    
    
    Y.ID.PARAM = 'ABC.REP.SALDO.OPER.PASIVAS.PRE'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE "RUTA" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.RUTA = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    
    Y.TMP.PATH = Y.RUTA

    GOSUB PROCESO

RETURN
********
PROCESO:
********

    EXECUTE 'CLEAR.FILE ': FN.INF
    EXECUTE 'CLEAR.FILE ': Y.TMP.PATH

RETURN
**********
END
