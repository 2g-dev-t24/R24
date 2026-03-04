* @ValidationCode : MjoxMjQ5NTk4NDYxOkNwMTI1MjoxNzcyNDE2NzA2MTYwOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 01 Mar 2026 22:58:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcContractService
SUBROUTINE ABC.START.CONTRCT.SERVICE
*===============================================================================
* Desarrollador:        FyG Solutions - LUIS CRUZ
* Compania:             ABC Capital
* Fecha:                2021-04-19
* Descripci�n:          Rutina que inicia el servicio para generar contrato
*===============================================================================
* Subroutine Type : AUTH RTN
* Attached to : VERSION>AA.ARRANGEMENT.ACTIVITY,ABC.CHANGE.PRODUCT.1.0.0
* Attached as : VERSION RTN
* Primary Purpose : Rutina que crea un registro EB.LOOKUP con ID de cuenta creada e
*                   inicia el servicio para generar contrato
*-----------------------------------------------------------------------
* Luis Cruz
* 13/10/2025
* Revision de rutina componentizada por 2G
*-----------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.Service
    $USING EB.Interface
    $USING AbcGetGeneralParam
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING AA.Framework
    $USING EB.Template
    $USING AA.Account
    $USING EB.AbcUtil
    
    GOSUB INICIO
    GOSUB PROCESO
    GOSUB FINALIZE

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------
    
    ID.CUENTA = ""
    Y.NOMBRE.SERV = "ABC.GENERA.CONTRATO"

    FN.TSA.SERVICE = 'F.TSA.SERVICE'
    F.TSA.SERVICE = ''
    EB.DataAccess.Opf(FN.TSA.SERVICE,F.TSA.SERVICE)
    
    FN.EB.LOOKUP = 'F.EB.LOOKUP' ; F.EB.LOOKUP = ''
    EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)
    
    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AAA = ''
    EB.DataAccess.Opf(FN.AAA, F.AAA)


RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------
    
    Y.NOMBRE.RUTINA = "ABC.START.CONTRCT.SERVICE"
;*Y.OFS.REQ = EB.Interface.getOfsParentReq()
    
    Y.APPLICATION.INP = ''
    Y.CATEGORIE.ACC = ''
    Y.APPLICATION.INP = EB.SystemTables.getApplication()
    Y.CATEGORIE.ACC = EB.SystemTables.getRNew(AC.AccountOpening.Account.Category)
    Y.ID.NEW = EB.SystemTables.getIdNew()
    
    Y.CADENA.LOG<-1> =  "Y.APPLICATION.INP->" : Y.APPLICATION.INP
    Y.CADENA.LOG<-1> =  "Y.CATEGORIE.ACC->" : Y.CATEGORIE.ACC
    Y.CADENA.LOG<-1> =  "Y.ID.NEW->" : Y.ID.NEW
    BEGIN CASE

        CASE Y.APPLICATION.INP EQ 'ACCOUNT'
            ID.CUENTA = Y.ID.NEW
            
        CASE Y.APPLICATION.INP EQ 'AA.ARRANGEMENT.ACTIVITY'
            ID.CUENTA = EB.SystemTables.getRNew(AA.Framework.AaArrangement)
        
        CASE Y.APPLICATION.INP EQ 'ABC.ACCT.LCL.FLDS'
            ID.CUENTA = Y.ID.NEW
    
    END CASE
    
    EB.DataAccess.FRead(FN.TSA.SERVICE, Y.NOMBRE.SERV, R.TSA.SERVICE, F.TSA.SERVICE, ERR.TSA)
    ESTATUS.SERVICIO = R.TSA.SERVICE<EB.Service.TsaService.TsTsmServiceControl>
    
    Y.CADENA.LOG<-1> =  "ESTATUS.SERVICIO->" : ESTATUS.SERVICIO
    
    IF ESTATUS.SERVICIO EQ 'START' THEN
        GOSUB CREA.REG.LOOKUP
    END ELSE
        GOSUB CREA.REG.LOOKUP ;*ARCH.TEMP
        GOSUB START.SERVICE
    END
    
RETURN
*-----------------------------------------------------------------------------
CREA.REG.LOOKUP:
*-----------------------------------------------------------------------------
    
    Y.ID.EB.LOOKUP = "PDF*" : ID.CUENTA
    R.EB.LOOKUP<EB.Template.Lookup.LuDescription> = 'CONTRATO'
    EB.DataAccess.FWrite(FN.EB.LOOKUP,Y.ID.EB.LOOKUP,R.EB.LOOKUP)
    Y.CADENA.LOG<-1> =  "Y.ID.EB.LOOKUP->" : Y.ID.EB.LOOKUP

RETURN
*-----------------------------------------------------------------------------
START.SERVICE:
*-----------------------------------------------------------------------------
    
    TS.ID = "ABC.GENERA.CONTRATO"
    SERVICE.ID = ''
    EB.Service.ServiceControl(TS.ID,'START',SERVICE.ID)
    
    Y.CADENA.LOG<-1> =  "TS.ID->" : TS.ID
    Y.CADENA.LOG<-1> =  "EB.Service.ServiceControl->START"
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)

RETURN
*-----------------------------------------------------------------------------
FINALIZE:
*-----------------------------------------------------------------------------

END
