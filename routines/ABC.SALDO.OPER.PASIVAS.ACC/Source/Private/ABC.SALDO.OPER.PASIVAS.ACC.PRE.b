* @ValidationCode : MjotNzc1MjU1NTk6Q3AxMjUyOjE3NjY1MDUzNjA0NDg6Q8Opc2FyTWlyYW5kYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 Dec 2025 09:56:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : CésarMiranda
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSaldoOperPasivasAcc

SUBROUTINE ABC.SALDO.OPER.PASIVAS.ACC.PRE
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
    $USING EB.AbcUtil
*-----------------------------------------------------------------------------
    GOSUB INICIA
    GOSUB PROCESO

RETURN

*-------------------------------------
INICIA:
*-------------------------------------

    Y.NOMBRE.RUTINA = "ABC.SALDO.OPER.PASIVAS.ACC.PRE"
    Y.ID.GEN.PARAM = 'ABC.CATEG.SAL.OP.PAS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.SEP = '|'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'PATH' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.PATH = Y.LIST.VALUES<Y.POS.PARAM> : "/tmp/*"
    END
    
    Y.CADENA.LOG<-1> = "Y.PATH->" : Y.PATH

RETURN
*-------------------------------------

*-------------------------------------
PROCESO:
*-------------------------------------

*    EXECUTE 'CLEAR.FILE ': Y.PATH
    EXECUTE 'SH -c rm ': Y.PATH CAPTURING Y.RETURNVAL
    
    Y.CADENA.LOG<-1> = "Y.RETURNVAL->" : Y.RETURNVAL
    
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)

RETURN
*-------------------------------------


END

