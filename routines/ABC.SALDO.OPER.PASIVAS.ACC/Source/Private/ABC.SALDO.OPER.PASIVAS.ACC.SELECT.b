* @ValidationCode : MjotMTY2MDU5NTA3OTpDcDEyNTI6MTc2NjEwMDc5NDk2NDpDw6lzYXJNaXJhbmRhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Dec 2025 17:33:14
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

SUBROUTINE ABC.SALDO.OPER.PASIVAS.ACC.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.API
    $USING EB.AbcUtil
    
    GOSUB INICIA
    GOSUB PROCESO

RETURN
*-------------------------------------
*-------------------------------------
INICIA:
*-------------------------------------

    Y.SEL.CMD = ''
    Y.SEL.LIST = ''
    Y.NO.OF.REC = ''
    Y.RET.CODE = ''

RETURN
*-------------------------------------

*-------------------------------------
PROCESO:
*-------------------------------------
    FN.ACCOUNT = AbcSaldoOperPasivasAcc.getFnAccount()
    
    Y.SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH (@ID UNLIKE USD...) AND (@ID UNLIKE MXN...)"
    EB.DataAccess.Readlist(Y.SEL.CMD,Y.SEL.LIST, '', Y.NO.OF.REC, Y.RET.CODE)

    EB.Service.BatchBuildList('', Y.SEL.LIST)
    
    Y.NOMBRE.RUTINA = "ABC.SALDO.OPER.PASIVAS.ACC.SELECT"
    Y.CADENA.LOG<-1> = "Y.SEL.CMD->" : Y.SEL.CMD
    Y.CADENA.LOG<-1> = "Y.SEL.LIST->" : Y.SEL.LIST
    
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)

RETURN
*-------------------------------------


END
