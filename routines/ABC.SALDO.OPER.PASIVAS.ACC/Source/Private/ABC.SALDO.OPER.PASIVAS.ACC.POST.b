* @ValidationCode : MjoxNjkxODQzNDQwOkNwMTI1MjoxNzY2MTkyNTM5MzU1OkPDqXNhck1pcmFuZGE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2025 19:02:19
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


SUBROUTINE ABC.SALDO.OPER.PASIVAS.ACC.POST
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
    $USING EB.Utility
    $USING EB.AbcUtil
*-----------------------------------------------------------------------------

    GOSUB INICIALIZACION
    GOSUB ABRIR.ARCHIVO
    GOSUB PROCESO

RETURN
*-------------------------------------
*-------------------------------------
INICIALIZACION:
*-------------------------------------

    Y.NOMBRE.RUTINA = "ABC.SALDO.OPER.PASIVAS.ACC.POST"

RETURN
*-------------------------------------
*-------------------------------------
ABRIR.ARCHIVO:
*-------------------------------------
    
    Y.DIA.ANT = EB.SystemTables.getRDates(EB.Utility.Dates.DatLastWorkingDay)
    
    Y.ID.GEN.PARAM = 'ABC.CATEG.SAL.OP.PAS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'PATH' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.PATH = Y.LIST.VALUES<Y.POS.PARAM>
    END

    LOCATE 'NOM.ARCH.SAL.OPERA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.NOM.ARCH.SAL.OPER = Y.LIST.VALUES<Y.POS.PARAM>
    END
    
    LOCATE 'SCRIPT.ARCHIVO.ACCT' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.SCRIPT.GEN.ARCH = Y.LIST.VALUES<Y.POS.PARAM>
    END
    
    LOCATE 'PATH.S3' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.PATH.S3 = Y.LIST.VALUES<Y.POS.PARAM>
    END
    
    Y.PATH.TEMP = Y.PATH:"/tmp/"
    
    CTA.NOM.FILE.TEMP = "Cuentas.csv"
    CTA.NOM.FILE = Y.DIA.ANT:".":Y.NOM.ARCH.SAL.OPER:CTA.NOM.FILE.TEMP
    CTA.FILE.PATH = Y.PATH:'/':CTA.NOM.FILE

    OTR.NOM.FILE.TEMP = "Otros.csv"
    OTR.NOM.FILE = Y.DIA.ANT:".":Y.NOM.ARCH.SAL.OPER:OTR.NOM.FILE.TEMP
    OTR.FILE.PATH = Y.PATH:'/':OTR.NOM.FILE
    
    Y.CADENA.LOG<-1> = "Y.PATH.TEMP->" : Y.PATH.TEMP
    Y.CADENA.LOG<-1> = "CTA.NOM.FILE.TEMP->" : CTA.NOM.FILE.TEMP
    Y.CADENA.LOG<-1> = "CTA.NOM.FILE->" : CTA.NOM.FILE
    Y.CADENA.LOG<-1> = "CTA.FILE.PATH->" : CTA.FILE.PATH
    Y.CADENA.LOG<-1> = "OTR.NOM.FILE.TEMP->" : OTR.NOM.FILE.TEMP
    Y.CADENA.LOG<-1> = "OTR.NOM.FILE->" : OTR.NOM.FILE
    Y.CADENA.LOG<-1> = "OTR.FILE.PATH->" : OTR.FILE.PATH
    Y.CADENA.LOG<-1> = "Y.PATH.S3->" : Y.PATH.S3

RETURN
*-------------------------------------
*-------------------------------------
PROCESO:
*-------------------------------------

    Y.SH.CMD= "SH -c sh ":Y.SCRIPT.GEN.ARCH :" ":Y.PATH.TEMP:" ":Y.DIA.ANT:" ":OTR.FILE.PATH:" ":CTA.FILE.PATH
    EXECUTE Y.SH.CMD

    Y.CADENA.LOG<-1> = "Y.SH.CMD->" : Y.SH.CMD
    
    Y.CADENA.LOG<-1> = "Y.PATH->" : Y.PATH
    Y.CADENA.LOG<-1> = "Y.PATH.S3->" : Y.PATH.S3
    Y.CADENA.LOG<-1> = "CTA.NOM.FILE->" : CTA.NOM.FILE
    EB.AbcUtil.abcMoveFileToS3(Y.PATH, Y.PATH.S3, CTA.NOM.FILE)
    
    Y.CADENA.LOG<-1> = "Y.PATH->" : Y.PATH
    Y.CADENA.LOG<-1> = "Y.PATH.S3->" : Y.PATH.S3
    Y.CADENA.LOG<-1> = "OTR.NOM.FILE->" : OTR.NOM.FILE
    EB.AbcUtil.abcMoveFileToS3(Y.PATH, Y.PATH.S3, OTR.NOM.FILE)
    
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)

RETURN
*-------------------------------------

END

