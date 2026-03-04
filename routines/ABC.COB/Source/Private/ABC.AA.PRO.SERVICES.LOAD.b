* @ValidationCode : MjoxODUxOTc5NTk5OkNwMTI1MjoxNzY0Nzg4Nzc4NzYyOkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Dec 2025 13:06:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcCob

SUBROUTINE ABC.AA.PRO.SERVICES.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* Nombre de Programa:   ABC.AA.PRO.SERVICES
* Objetivo:
* Desarrollador:        Franco Manrique - FYG Solutions
* Compania:             ABC CAPITAL
* Fecha Creacion:       2016-10-05
* Modificaciones:  Se realizan modificaciones para que sea asyncrono el proceso
*===============================================================================
* Fecha Modificacion :  14-02-2025  LFCR_20250214_InformePagareApp
* Desarrollador:        Luis Cruz - FyG Solutions
* Req. Jira:            ABCCORE-3690 Desarrollar Informe de Contratacion
* Compania:             UALA
* Descripci�n:          Se agrega funcionalidad para generar archivo plano
*                       con datos de inversion en directorio de interfaces
*-----------------------------------------------------------------------------
*********************************************************************
* Company Name      : Uala
* Developed By      : FYG Solutions
* Product Name      : EB
*--------------------------------------------------------------------------------------------
* Subroutine Type : BATCH SERVICE
* Attached to : PGM.FILE>ABC.AA.PRO.SERVICES
*               BATCH>ABC.AA.PRO.SERVICES
*               TSA.SERVICE>ABC.AA.PRO.SERVICES
* Attached as : MULTITHREAD SERVICE
* Primary Purpose : Rutina para procesar peticiones de pagare ingresadas por la tabla ABC.AA.PRE.PROCESS
*--------------------------------------------------------------------------------------------
*  Modification Details:
* -----------------------------
* 03/12/2025 - Migracion
*              Se aplican ajustes por cambio de infraestructura.
*              Se optimiza rutina para R24
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.Updates
    $USING AbcGetGeneralParam
*-----------------------------------------------------------------------------
    FN.AA= 'F.ABC.AA.PRE.PROCESS.LIST'
    F.AA= ''
    EB.DataAccess.Opf(FN.AA,F.AA)
    AbcCob.setFnAa(FN.AA)
    AbcCob.setFAa(F.AA)

    FN.PRE.PROCESS='F.ABC.AA.PRE.PROCESS$NAU'
    F.PRE.PROCESS = ''
    EB.DataAccess.Opf(FN.PRE.PROCESS,F.PRE.PROCESS)
    AbcCob.setFnPreProcess(FN.PRE.PROCESS)
    AbcCob.setFPreProcess(F.PRE.PROCESS)

    FN.PRE.PROCESS.LIV='F.ABC.AA.PRE.PROCESS'
    F.PRE.PROCESS.LIV=''
    EB.DataAccess.Opf(FN.PRE.PROCESS.LIV,F.PRE.PROCESS.LIV)
    AbcCob.setFnPreProcessLiv(FN.PRE.PROCESS.LIV)
    AbcCob.setFPreProcessLiv(F.PRE.PROCESS.LIV)
  
    FN.PRE.PROCESS.HIS='F.ABC.AA.PRE.PROCESS$HIS'
    F.PRE.PROCESS.HIS=''
    EB.DataAccess.Opf(FN.PRE.PROCESS.HIS,F.PRE.PROCESS.HIS)
    AbcCob.setFnPreProcessHis(FN.PRE.PROCESS.HIS)
    AbcCob.setFPreProcessHis(F.PRE.PROCESS.HIS)
    
    FN.ACCOUNT = "F.ACCOUNT"  ;*LFCR_20250214_InformePagareApp - S
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    AbcCob.setFnAccountServices(FN.ACCOUNT)
    AbcCob.setFAccountServices(F.ACCOUNT)
    
    FN.ABC.AA.CONCAT.PRE = 'F.ABC.AA.L.PRE.PRO'
    F.ABC.AA.CONCAT.PRE = ''
    EB.DataAccess.Opf(FN.ABC.AA.CONCAT.PRE, F.ABC.AA.CONCAT.PRE)
    AbcCob.setFnAbcAaConcatPre(FN.ABC.AA.CONCAT.PRE)
    AbcCob.setFAbcAaConcatPre(F.ABC.AA.CONCAT.PRE)

    EB.Updates.MultiGetLocRef('ABC.AA.PRE.PROCESS', 'EXT.TRANS.ID', YPOS.EXT.TRANS.ID)
    EB.Updates.MultiGetLocRef("ABC.AA.PRE.PROCESS","CANAL.ENTIDAD", YPOS.CANAL.ENT)
    AbcCob.setYPosExtTransId(YPOS.EXT.TRANS.ID)
    AbcCob.setYPosCanaEnt(YPOS.CANAL.ENT)
    
    Y.ID.GEN.PARAM = 'PAGARE.APP.PARAM'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'RUTA.INFORMES.APP' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.RUTA.INFORMES.APP = Y.LIST.VALUES<Y.POS.PARAM>
    END
    AbcCob.setRutasInformesApp(Y.RUTA.INFORMES.APP)
    
    LOCATE 'RUTA.INF.APP.RESP' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.RUTA.INF.APP.RESP = Y.LIST.VALUES<Y.POS.PARAM>
*AbcGetGeneralParam.AbcObtieneRutaAbs(Y.RUTA.INF.APP.RESP)
    END
    AbcCob.setRutaInfAppRest(Y.RUTA.INF.APP.RESP)

    LOCATE 'SEPARADOR.INFORME' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.SEPARADOR.INFORME = Y.LIST.VALUES<Y.POS.PARAM>
    END
    AbcCob.setSeparadorInforme(Y.SEPARADOR.INFORME)

    LOCATE 'MSJ.SUCCESS.INFORME' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.MSJ.SUCCESS.INFORME = Y.LIST.VALUES<Y.POS.PARAM>
    END
    AbcCob.setMsjSuccessInforme(Y.MSJ.SUCCESS.INFORME)

    LOCATE 'MSJ.ERROR.INFORME' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.MSJ.ERROR.INFORME = Y.LIST.VALUES<Y.POS.PARAM>
    END
    AbcCob.setMsjErrorInforme(Y.MSJ.ERROR.INFORME)

    LOCATE 'MSJ.SALDO.INSUFICIENTE' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.MSJ.SALDO.INSUFICIENTE = Y.LIST.VALUES<Y.POS.PARAM>
    END   ;*LFCR_20250214_InformePagareApp - E
    AbcCob.setMsjSaldoInsuficiente(Y.MSJ.SALDO.INSUFICIENTE)
RETURN
END