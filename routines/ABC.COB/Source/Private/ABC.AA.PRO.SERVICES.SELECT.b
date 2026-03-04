* @ValidationCode : MjoyMDgwNjc5MTkxOkNwMTI1MjoxNzY0Nzg5MDk3OTc5OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Dec 2025 13:11:37
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

SUBROUTINE ABC.AA.PRO.SERVICES.SELECT
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
* Descripcion:          Se agrega funcionalidad para generar archivo plano
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
    $USING EB.SystemTables
    $USING EB.Service
  
    FN.AA = AbcCob.getFnAa()
    
    SEL.CMD = 'SELECT ': FN.AA
    
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)
 
    EB.Service.BatchBuildList('',SEL.LIST)
RETURN
END
 