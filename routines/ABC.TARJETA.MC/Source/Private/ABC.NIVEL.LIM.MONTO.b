* @ValidationCode : MjotNzU3NTY1OTEzOkNwMTI1MjoxNzU2MjIwMTU5MzMyOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Aug 2025 11:55:59
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
$PACKAGE AbcTarjetaMc

SUBROUTINE ABC.NIVEL.LIM.MONTO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING AbcTable
    $USING AbcSpei
    $USING AbcTarjetaMc
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------

    GOSUB INICIO
    GOSUB APERTURA
    GOSUB PROCESO
    
    

RETURN

*********
PROCESO:
*********

    Y.CUENTA.CR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.CUENTA.DR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.MONTO.TRANS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.TRANS.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)
    Y.APPLICATION   = EB.SystemTables.getApplication()
    Y.FUNCTION = EB.SystemTables.getVFunction()
    GOSUB LEER.PARAMETROS
    

    
    AbcTarjetaMc.AbcValCategType(Y.CUENTA.DR,Y.CUENTA.CR,Y.TRANS.TYPE)
    IF Y.MONTO.TRANS = '' THEN
        Y.MONTO.TRANS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
    END
    Y.TRANS.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)

    EB.DataAccess.FRead(FN.VPM.PARAMETROS.SPEI,Y.SPEI.ID,R.SPEI,F.VPM.PARAMETROS.SPEI,YERR.SPEI)
    IF R.SPEI THEN
        Y.CUENTA.SPEI = R.SPEI<AbcTable.AbcParametrosSpei.SpeiCtaBanxico>
    END

    IF Y.CUENTA.CR[1,3] EQ "MXN" OR Y.CUENTA.CR EQ Y.CUENTA.SPEI THEN
        
        GOSUB CR.MXN.SPEI

    END ELSE
    
        GOSUB PROCESS.ACCOUNT.NIVEL.CUENTA
       
    END

RETURN

*********************************************************************************************************************
PROCESS.ACCOUNT.NIVEL.CUENTA:
*********************************************************************************************************************
    
    EB.DataAccess.FRead(FN.ACCOUNT,Y.CUENTA.CR,R.ACCOUNT,F.ACCOUNT,YERR.ACCOUNT)
    IF R.ACCOUNT THEN
        Y.CLIENTE = R.ACCOUNT<AC.AccountOpening.Account.Customer>
        IF R.ACCOUNT THEN
            Y.CLIENTE = R.ACCOUNT<AC.AccountOpening.Account.Customer>
            Y.ACCOUNT.CATEGORY  = R.ACCOUNT<AC.AccountOpening.Account.Category>
                
                
            Y.NO.VALORES = DCOUNT(Y.LIST.PARAMS,@FM)
            FOR Y.AA=1 TO Y.NO.VALORES
                Y.PARAM = Y.LIST.PARAMS<Y.AA>
                Y.CATEGORIA = Y.LIST.VALUES<Y.AA>
                CHANGE '|' TO @FM IN Y.CATEGORIA
                LOCATE Y.ACCOUNT.CATEGORY IN Y.CATEGORIA SETTING Y.POS THEN
                    Y.NIVEL.CR = Y.PARAM
                END
            NEXT Y.AA
        END

        EB.DataAccess.FRead(FN.ABC.NIVEL.CUENTA,Y.NIVEL.CR,R.NIVEL,F.ABC.NIVEL.CUENTA,YERR.NIVEL)
        IF R.NIVEL THEN
            Y.MONTO.LIMITE = R.NIVEL<AbcTable.AbcNivelCuenta.ValorLimite>
            Y.APP = R.NIVEL<AbcTable.AbcNivelCuenta.Aplicacion>

            Y.APP = RAISE(Y.APP)
            LOCATE Y.APPLICATION IN Y.APP SETTING YPOS.APP THEN
                Y.TRANS.CR = R.NIVEL<AbcTable.AbcNivelCuenta.TransaccionCr,YPOS.APP>
                CHANGE @SM TO @FM IN Y.TRANS.CR
                LOCATE Y.TRANS.TYPE IN Y.TRANS.CR SETTING YPOS.TRANS.CR THEN
                    Y.ID.LIMITE = Y.CUENTA.CR:"-":Y.FEC.LIMITE
                    
                    IF Y.FUNCTION EQ "R" OR Y.FUNCTION EQ "D" THEN Y.MONTO.TRANS *= -1
                    AbcSpei.AbcValidaLimiteMonto(Y.ID.LIMITE,Y.MONTO.TRANS,Y.MONTO.LIMITE,ID.NEW,Y.CLIENTE)
                END
            END
        END
    END
RETURN



*********************************************************************************************************************
APERTURA:
*********************************************************************************************************************

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.ABC.NIVEL.CUENTA = 'F.ABC.NIVEL.CUENTA'
    F.ABC.NIVEL.CUENTA = ''
    EB.DataAccess.Opf(FN.ABC.NIVEL.CUENTA,F.ABC.NIVEL.CUENTA)

    FN.VPM.PARAMETROS.SPEI = 'F.ABC.PARAMETROS.SPEI'
    F.VPM.PARAMETROS.SPEI = ''
    EB.DataAccess.Opf(FN.VPM.PARAMETROS.SPEI,F.VPM.PARAMETROS.SPEI)
  
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)
*CALL GET.LOC.REF('ACCOUNT','NIVEL',YPOS.NIVEL)

RETURN

*********************************************************************************************************************
INICIO:
*********************************************************************************************************************

    Y.CUENTA.SPEI = ''
    Y.CUENTA.CR = ''
    Y.CUENTA.DR = ''
    Y.CUENTA = ''
    Y.MONTO.TRANS = 0
    Y.TRANS.TYPE = ''
    Y.NIVEL.CR = ''
    Y.NIVEL.DR = ''
    R.SPEI = ''
    YERR.SPEI = ''
    R.ACCOUNT = ''
    YERR.ACCOUNT = ''
    R.NIVEL = ''
    YERR.NIVEL = ''
    Y.SPEI.ID = "SYSTEM"
    Y.CLIENTE = ''
    Y.ID.LIMITE = ''
    TODAY = EB.SystemTables.getToday()
    Y.ANIO.MES = TODAY[1,6]
    Y.FEC.LIMITE = Y.ANIO.MES;*OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R")
    ID.NEW = EB.SystemTables.getIdNew()

RETURN
*********************************************************************************************************************
LEER.PARAMETROS:
*********************************************************************************************************************

    Y.PARAM.ID = 'ABC.NIVEL.CUENTAS'
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.PARAM.ID, R.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM, Y.ERR.PARAM)
    
    IF R.ABC.GENERAL.PARAM THEN
        Y.LIST.PARAMS = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>)
        Y.LIST.VALUES = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>)
    END ELSE
        ETEXT = 'No existe el parámetro ':Y.PARAM.ID:' en la tabla ABC.GENERAL.PARAM'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    
RETURN
  
*********************************************************************************************************************
CR.MXN.SPEI:
*********************************************************************************************************************
    EB.DataAccess.FRead(FN.ACCOUNT,Y.CUENTA.DR,R.ACCOUNT,F.ACCOUNT,YERR.ACCOUNT)
    IF R.ACCOUNT THEN
        Y.CLIENTE = R.ACCOUNT<AC.AccountOpening.Account.Customer>
        Y.ACCOUNT.CATEGORY  = R.ACCOUNT<AC.AccountOpening.Account.Category>
        Y.NO.VALORES = DCOUNT(Y.LIST.PARAMS,@FM)
        FOR Y.AA=1 TO Y.NO.VALORES
            Y.PARAM = Y.LIST.PARAMS<Y.AA>
            Y.CATEGORIA = Y.LIST.VALUES<Y.AA>
            CHANGE '|' TO @FM IN Y.CATEGORIA
            LOCATE Y.ACCOUNT.CATEGORY IN Y.CATEGORIA SETTING Y.POS THEN
                Y.NIVEL.DR = Y.PARAM
            END
        NEXT Y.AA
*            Y.NIVEL.DR = R.ACCOUNT<AC.LOCAL.REF,YPOS.NIVEL>asd
    END

    EB.DataAccess.FRead(FN.ABC.NIVEL.CUENTA,Y.NIVEL.DR,R.NIVEL,F.ABC.NIVEL.CUENTA,YERR.NIVEL)
    IF R.NIVEL THEN
        Y.MONTO.LIMITE = R.NIVEL<AbcTable.AbcNivelCuenta.ValorLimite>
        Y.APP = R.NIVEL<AbcTable.AbcNivelCuenta.Aplicacion>

        Y.APP = RAISE(Y.APP)
            
            
        LOCATE Y.APPLICATION IN Y.APP SETTING YPOS.APP THEN
            Y.TRANS.DR = R.NIVEL<AbcTable.AbcNivelCuenta.TransaccionDr,YPOS.APP>
            CHANGE @SM TO @FM IN Y.TRANS.DR
            LOCATE Y.TRANS.TYPE IN Y.TRANS.DR SETTING YPOS.TRANS.DR THEN
                Y.ID.LIMITE = Y.CUENTA.DR:"-":Y.FEC.LIMITE
                Y.MONTO.TRANS *= -1
                AbcSpei.AbcValidaLimiteMonto(Y.ID.LIMITE,Y.MONTO.TRANS,Y.MONTO.LIMITE,ID.NEW,Y.CLIENTE)
            END
        END
    END
RETURN

END