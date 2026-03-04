* @ValidationCode : MjoxNzg2MzYyOTQ3OkNwMTI1MjoxNzU1NzgzMzYzNzA3Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Aug 2025 10:36:03
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
*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
SUBROUTINE ABC.NIVEL.LIM.MONTO.AUT
*===============================================================================
*===============================================================================
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING EB.ErrorProcessing
    
    $USING AbcTable
    $USING AbcSpei

    GOSUB INICIALIZA
    GOSUB APERTURA.FILES
    GOSUB VALIDA.FUNCTION

RETURN

*-----------------------------------------------------------------------------
INICIALIZA:
*-----------------------------------------------------------------------------

    Y.CUENTA.CR = ''
    Y.CUENTA.DR = ''
    Y.CUENTA = ''
    Y.MONTO.TRANS = 0
    Y.TRANS.TYPE = ''
    Y.NIVEL.CR = ''
    R.ACC.CUS = ''
    YERR.ACCOUNT = ''
    R.NIVEL = ''
    YERR.NIVEL = ''
    Y.CLIENTE = ''
    Y.ID.LIMITE = ''
    Y.ID.NEW = EB.SystemTables.getIdNew()
    Y.FEC.LIMITE = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R")

RETURN
*-----------------------------------------------------------------------------
APERTURA.FILES:
*-----------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.FT.NAU = "F.FUNDS.TRANSFER$NAU"
    F.FT.NAU = ""
    EB.DataAccess.Opf(FN.FT.NAU, F.FT.NAU)

    FN.ABC.NIVEL.CUENTA = 'F.ABC.NIVEL.CUENTA'
    F.ABC.NIVEL.CUENTA = ''
    EB.DataAccess.Opf(FN.ABC.NIVEL.CUENTA,F.ABC.NIVEL.CUENTA)

    FN.ABC.MOVS.CTA.NIVEL2 = 'F.ABC.MOVS.CTA.NIVEL2'
    F.ABC.MOVS.CTA.NIVEL2 = ''
    EB.DataAccess.Opf(FN.ABC.MOVS.CTA.NIVEL2,F.ABC.MOVS.CTA.NIVEL2)

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

RETURN

*-----------------------------------------------------------------------------
VALIDA.FUNCTION:
*-----------------------------------------------------------------------------
    Y.FNCTION = EB.SystemTables.getVFunction()
    
    GOSUB LEER.PARAMETROS

    BEGIN CASE

        CASE Y.FNCTION EQ "I"
            GOSUB REGISTRA.OPERACION

        CASE Y.FNCTION EQ "D"
            GOSUB BORRA.OPERACION

        CASE Y.FNCTION EQ "A"
            RETURN

    END CASE

RETURN

*-----------------------------------------------------------------------------
LEER.PARAMETROS:
*-----------------------------------------------------------------------------

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
*-----------------------------------------------------------------------------
REGISTRA.OPERACION:
*-----------------------------------------------------------------------------

    Y.CUENTA.CR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.CUENTA.DR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.MONTO.TRANS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    IF Y.MONTO.TRANS EQ '' THEN
        Y.MONTO.TRANS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
    END
    Y.TRANS.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)

    EB.DataAccess.FRead(FN.ACCOUNT,Y.CUENTA.CR,R.ACC.CUS,F.ACCOUNT,YERR.ACCOUNT)
    IF R.ACC.CUS THEN
        Y.CLIENTE = R.ACC.CUS<AC.AccountOpening.Account.Customer>
        Y.ACCOUNT.CATEGORY = R.ACC.CUS<AC.AccountOpening.Account.Category>
    END
    Y.NO.VALORES = DCOUNT(Y.LIST.PARAMS,@FM)
    FOR Y.AA=1 TO Y.NO.VALORES
        Y.PARAM = Y.LIST.PARAMS<Y.AA>
        Y.CATEGORIA = Y.LIST.VALUES<Y.AA>
        CHANGE '|' TO @FM IN Y.CATEGORIA
        LOCATE Y.ACCOUNT.CATEGORY IN Y.CATEGORIA SETTING Y.POS THEN
            Y.NIVEL.CR = Y.PARAM
        END
    NEXT Y.AA
    
    EB.DataAccess.FRead(FN.ABC.NIVEL.CUENTA,Y.NIVEL.CR,R.NIVEL,F.ABC.NIVEL.CUENTA,YERR.NIVEL)
    IF R.NIVEL THEN
        Y.MONTO.LIMITE = R.NIVEL<AbcTable.AbcNivelCuenta.ValorLimite>
        Y.APP = R.NIVEL<AbcTable.AbcNivelCuenta.Aplicacion>
        Y.APP = RAISE(Y.APP)

        Y.APPL = EB.SystemTables.getApplication()
        LOCATE Y.APPL IN Y.APP SETTING YPOS.APP THEN
            Y.TRANS.CR = R.NIVEL<AbcTable.AbcNivelCuenta.TransaccionCr, YPOS.APP>
            CHANGE @SM TO @FM IN Y.TRANS.CR
            LOCATE Y.TRANS.TYPE IN Y.TRANS.CR SETTING YPOS.TRANS.CR THEN
                Y.ID.LIMITE = Y.CUENTA.CR:"-":Y.FEC.LIMITE
                AbcSpei.AbcValidaLimiteMonto(Y.ID.LIMITE,Y.MONTO.TRANS,Y.MONTO.LIMITE,ID.NEW,Y.CLIENTE)
            END
        END
    END

RETURN
*-----------------------------------------------------------------------------
BORRA.OPERACION:
*-----------------------------------------------------------------------------

    Y.ID.OPERACION = ''
    Y.ID.OPERACION = EB.SystemTables.getIdNew()

    REG.OPERACION = ""
    EB.DataAccess.FRead(FN.FT.NAU, Y.ID.OPERACION, REG.OPERACION, F.FT.NAU, FT.ERR)

    Y.CUENTA.CR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.ID.LIMITE = Y.CUENTA.CR:"-":Y.FEC.LIMITE
    R.MOV.CTA = '' ; Y.LISTA.OPERACIONES = ''

    EB.DataAccess.FRead(FN.ABC.MOVS.CTA.NIVEL2,Y.ID.LIMITE,R.MOV.CTA,F.ABC.MOVS.CTA.NIVEL2,YMOV.CTA)
    Y.LISTA.OPERACIONES = R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.IdOperacion>
    CHANGE @VM TO @FM IN Y.LISTA.OPERACIONES
    LOCATE Y.ID.OPERACION IN Y.LISTA.OPERACIONES SETTING POS.OPER THEN
        R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.MontoTotal> = R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.MontoTotal> - R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.MontoMov, POS.OPER>
        DEL R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.IdOperacion, POS.OPER>
        DEL R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.FechaMov, POS.OPER>
        DEL R.MOV.CTA<AbcTable.AbcMovsCtaNivel2.MontoMov, POS.OPER>
    END

    EB.DataAccess.FWrite(FN.ABC.MOVS.CTA.NIVEL2,Y.ID.LIMITE,R.MOV.CTA)
RETURN

END
