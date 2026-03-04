* @ValidationCode : MjotMTgwNjYxMDQyODpDcDEyNTI6MTc3MjQxNjQ1MjEzNjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 01 Mar 2026 22:54:12
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
$PACKAGE AbcAccount

SUBROUTINE ABC.VALIDA.CUENTA
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
    $USING EB.AbcUtil
    $USING AbcSpei
    $USING AbcContractService
*-----------------------------------------------------------------------------
    MESSAGE     = EB.SystemTables.getMessage()
    INT.BANKING = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.InternetBanking)

    IF (MESSAGE = "VAL") AND (INT.BANKING NE 'YES') THEN
        RETURN
    END
    
    GOSUB INIT
    GOSUB PROC
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    LEN.ACC     = ''
    R.ACC       = ''
    Y.ACC.ERR   = ''
    ACC.ID      = ''
    ACCT.ID     = ''
    Y.ALLOWED.CANALES   = ''
    Y.ALLOWED.CATS = ''
    Y.ACCT.CANAL        = ''
    Y.CAT.ACCT = ''
    ACCT.ID = EB.SystemTables.getComi()
    
    GOSUB OPEN.FILES
    
RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)
    
    Y.ID.GEN.PARAM = 'PAGARE.APP.PARAM'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE 'CANAL.CTA.PAGARE' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.ALLOWED.CANALES = Y.LIST.VALUES<Y.POS.PARAM>
        CHANGE '|' TO @VM IN Y.ALLOWED.CANALES
    END
    
    LOCATE 'CATS.APP.PAGARE' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.ALLOWED.CATS = Y.LIST.VALUES<Y.POS.PARAM>
        CHANGE '|' TO @VM IN Y.ALLOWED.CATS
    END

RETURN
*-----------------------------------------------------------------------------
PROC:
*-----------------------------------------------------------------------------
    
    CUS.ID  = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.CustomerId)
    
    IF ACCT.ID NE '' THEN
*        LEN.ACC = LEN(ACCT.ID)
*        IF LEN.ACC < 11 THEN
*            ACC.ID = STR("0",11-LEN.ACC):ACCT.ID
*        END ELSE
*            ACC.ID=ACCT.ID
*        END
        ACC.ID=ACCT.ID
        
        R.ACC = AC.AccountOpening.Account.Read(ACC.ID, Y.ACC.ERR)
        AC.CUSTOMER = R.ACC<AC.AccountOpening.Account.Customer>
        Y.CAT.ACCT  = R.ACC<AC.AccountOpening.Account.Category>

        IF CUS.ID <> AC.CUSTOMER THEN
            ETEXT = "CUENTA DE OTRO CLIENTE"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    
        ACC.ID.FLDS = R.ACC<AC.AccountOpening.Account.ArrangementId>
    
        EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,ACC.ID.FLDS,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,Y.ABC.ACCT.LCL.FLDS.ERR)
        
        Y.GPO.CLUB.AHORRO   = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.GpoClubAhorro>
        Y.CANAL             = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Canal>
        
        Y.NOMBRE.RUTINA = "ABC.VALIDA.CUENTA" ;* aqui va el nombre de su rutina desde la que ejecutan la call rtn
        Y.CADENA.LOG<-1> =  "ID.NEW->" : EB.SystemTables.getIdNew()
        Y.CADENA.LOG<-1> =  "AC.CUSTOMER->" : AC.CUSTOMER
        Y.CADENA.LOG<-1> =  "Y.CAT.ACCT->" : Y.CAT.ACCT
        Y.CADENA.LOG<-1> =  "CUS.ID->" : CUS.ID
        Y.CADENA.LOG<-1> =  "Y.GPO.CLUB.AHORRO->" : Y.GPO.CLUB.AHORRO
        Y.CADENA.LOG<-1> =  "Y.ALLOWED.CANALES->" : Y.ALLOWED.CANALES
        Y.CADENA.LOG<-1> =  "Y.ALLOWED.CATS->" : Y.ALLOWED.CATS
        Y.CADENA.LOG<-1> =  "E->" : EB.SystemTables.getE()
        Y.CADENA.LOG<-1> =  "ETEXT->" : EB.SystemTables.getEtext()
        EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)
        
        IF (Y.GPO.CLUB.AHORRO EQ '') AND NOT(Y.CAT.ACCT MATCHES Y.ALLOWED.CATS) THEN
            ETEXT = "CUENTA NO ASOCIADA A UN CLUB INVIERTE"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    
        AbcSpei.AbcValPostRest(ACC.ID)

    END

RETURN

*-----------------------------------------------------------------------------
END
