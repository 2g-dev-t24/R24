* @ValidationCode : MjotOTg1OTg4NjIyOkNwMTI1MjoxNzY3NjY3MDc5NDk2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2026 23:37:59
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
$PACKAGE AbcSaldoOperPasivasAcc

SUBROUTINE ABC.SALDO.OPER.PASIVAS.ACC(Y.ACCOUNT.ID)
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
    $USING ST.Config
    $USING ST.Customer
    $USING BF.ConBalanceUpdates
    $USING AbcSpei
    $USING IC.Config
    $USING IC.InterestAndCapitalisation
    $USING EB.AbcUtil
*-----------------------------------------------------------------------------
    GOSUB INICIA
    GOSUB PROCESO

RETURN
*-------------------------------------------------------------------------------------------------------
*-------------------------------------
PROCESO:
*-------------------------------------
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS =''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)
    
    R.ACCOUNT = ''
    Y.ERR.AC = ''
    EB.DataAccess.FRead(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR.AC)
*    DEBUG
    
    Y.CONDITION.GROUP = R.ACCOUNT<AC.AccountOpening.Account.ConditionGroup>
    Y.ARRANGEMENT.ID = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
    
    PRODGUCTO.ID     = ''
    PROPERTY.LISTA  = ''
    REC.PRODUCTO    = ''
    CALL AA.GET.ARRANGEMENT.PRODUCT(Y.ARRANGEMENT.ID,DIA.EFECTIVO,REC.PRODUCTO,PRODUCTO.ID,PROPERTY.LISTA)
    Y.CADENA.LOG<-1> =  "Y.CONDITION.GROUP->" : Y.CONDITION.GROUP : "Y.ARRANGEMENT.ID->" : Y.ARRANGEMENT.ID : "Y.TIPO.PRODUCTO->" : PRODUCTO.ID
    Y.TIPO.PRODUCTO = FIELD(PRODUCTO.ID,'.',1)
;*     IF Y.CONDITION.GROUP EQ '80' OR Y.ARRANGEMENT.ID NE '' THEN
;*         RETURN
;*     END

    BEGIN CASE
        CASE Y.TIPO.PRODUCTO EQ 'DEPOSIT'        ;*INVERSIONES
            EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)
            RETURN
        CASE Y.CONDITION.GROUP EQ '80'
            EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)
            RETURN
    END CASE

    Y.NO.CLIENTE = R.ACCOUNT<AC.AccountOpening.Account.Customer>

    Y.SUCURSAL.CTA = ''
    Y.SUC.ID = SUBSTRINGS(R.ACCOUNT<AC.AccountOpening.Account.AccountOfficer>,1,5)
    R.DAO = ''
    Y.ERR.DAO = ''
    EB.DataAccess.FRead(FN.DAO,Y.SUC.ID,R.DAO,F.DA0, Y.ERR.DAO)
    Y.SUCURSAL.CTA = R.DAO<ST.Config.DeptAcctOfficer.EbDaoName>
    Y.SUCURSAL.CTA = UPCASE(Y.SUCURSAL.CTA)

    R.CUSTOMER = ''
    Y.ERR.CUS = ''
    EB.DataAccess.FRead(FN.CUSTOMER,Y.NO.CLIENTE,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUS)
    Y.LOCAL.REF = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef>
    Y.TIPO.CLIENTE = R.CUSTOMER<ST.Customer.Customer.EbCusSector>
    Y.TIPO.CLIENTE = Y.TIPO.CLIENTE[1,1]

    Y.NOM.CLIENTE = ''
    IF Y.TIPO.CLIENTE LT 3 THEN
        Y.NOM.CLIENTE  = TRIM(R.CUSTOMER<ST.Customer.Customer.EbCusShortName>):' '
        Y.NOM.CLIENTE := TRIM(R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>):' '
        Y.NOM.CLIENTE := TRIM(R.CUSTOMER<ST.Customer.Customer.EbCusNameTwo>):' '
    END ELSE
        Y.NOM.CLIENTE = Y.LOCAL.REF<Y.POS.NOM.PER.MORAL>
    END
    Y.NOM.CLIENTE = TRIM(Y.NOM.CLIENTE)

    Y.RESTRICT = ''
    Y.RESTRICT = R.CUSTOMER<ST.Customer.Customer.EbCusPostingRestrict>
    Y.STA.CUS = ''
    Y.STA.CUS = R.CUSTOMER<ST.Customer.Customer.EbCusCustomerStatus>

    IF Y.RESTRICT EQ '90' OR Y.STA.CUS EQ '2' THEN
        Y.CADENA.LOG<-1> =  "Y.RESTRICT->" : Y.RESTRICT
        Y.CADENA.LOG<-1> =  "Y.STA.CUS->" : Y.STA.CUS
        EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)
        RETURN
    END

    R.ECB =''
    Y.ERR.ECB =''
    EB.DataAccess.FRead(FN.EB.CONTRACT.BALANCES,Y.ACCOUNT.ID,R.ECB,F.EB.CONTRACT.BALANCES,Y.ERR.ECB)
    Y.SALDO.CORTE = ''
    Y.SALDO.CORTE = R.ECB<BF.ConBalanceUpdates.EbContractBalances.EcbOpenActualBal>
    Y.SALDO.CORTE = FMT(Y.SALDO.CORTE, "R2")
    TODAY = EB.SystemTables.getToday()
    Y.SALDO.BLOQ=''
    AbcSpei.AbcMontoBloqueado(Y.ACCOUNT.ID,Y.SALDO.BLOQ,TODAY)
    IF Y.SALDO.BLOQ EQ '' THEN Y.SALDO.BLOQ = 0
    Y.SALDO.BLOQ = FMT(Y.SALDO.BLOQ, "R2")

    Y.SALDO.DISP = Y.SALDO.CORTE - Y.SALDO.BLOQ
    Y.SALDO.DISP = FMT(Y.SALDO.DISP, "R2")

    Y.SALDO.PROM = ''
    AbcSaldoOperPasivasAcc.AbcRutSalPromedio(Y.ACCOUNT.ID, Y.LWD , Y.SALDO.PROM)

    Y.CTA.CG.ID = R.ACCOUNT<AC.AccountOpening.Account.ConditionGroup>
    FINDSTR Y.CTA.CG.ID:"MXN" IN CTA.GC.SEL.LIST SETTING Y.FM THEN
        Y.ID.CTA.GC.SEL.LIST = CTA.GC.SEL.LIST<Y.FM>
    END
    R.GROUP.CREDIT.INT = ''
    EB.DataAccess.FRead(FN.GROUP.CREDIT.INT, Y.ID.CTA.GC.SEL.LIST , R.GROUP.CREDIT.INT, F.GROUP.CREDIT.INT, Y.GCI.ERR)

    Y.INT.DEV = 0
    Y.TASA = 0
*CAST20250107.I
    Y.TASA = R.GROUP.CREDIT.INT<IC.Config.GroupCreditInt.GciCrIntRate,1>
*CAST20250107.F
    Y.TRANS = R.ACCOUNT<AC.AccountOpening.Account.AccrCrTrans,1>
    IF Y.TRANS EQ 380 THEN
        Y.INT.DEV = R.ACCOUNT<AC.AccountOpening.Account.AccrCrAmount,1>
*CAST20250107.I
*        Y.TASA = R.GROUP.CREDIT.INT<IC.GCI.CR.INT.RATE,1>
*CAST20250107.F
    END
    IF Y.LWD EQ Y.ULT.DIA.W THEN
        Y.STMT.ACCT.CR.ID = Y.ACCOUNT.ID : '-' : Y.ULT.DIA.C
        R.STMT.ACCT.CR = ''
        Y.ERR.STMT.ACCT.CR =''
        EB.DataAccess.FRead(FN.STMT.ACCT.CR, Y.STMT.ACCT.CR.ID , R.STMT.ACCT.CR, F.STMT.ACCT.CR, Y.ERR.STMT.ACCT.CR)
        IF R.STMT.ACCT.CR THEN
            Y.INT.DEV = R.STMT.ACCT.CR<IC.InterestAndCapitalisation.StmtAcctCr.StmcrTotalInterest>
            Y.TASA = R.STMT.ACCT.CR<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCrIntRate,1> ;*Se muestra siempre la primer tasa
        END
*CAST20250107.I
;*         ELSE
;*             Y.INT.DEV = 0
;*             Y.TASA = 0
;*         END
*CAST20250107.F
    END

    Y.FECHA.APERTURA = R.ACCOUNT<AC.AccountOpening.Account.OpeningDate>
    Y.FECHA.ULT.MOV = R.ACCOUNT<AC.AccountOpening.Account.DateLastUpdate>
    IF Y.FECHA.ULT.MOV EQ '' THEN
        Y.FECHA.CONTRATO = ''
        Y.AC.DATE.TIME = R.ACCOUNT<AC.AccountOpening.Account.DateTime>
        IF Y.AC.DATE.TIME NE '' THEN
            Y.FECHA  = Y.AC.DATE.TIME[1,6]
            Y.FECHA.CONTRATO = '20':Y.FECHA
        END
        Y.FECHA.ULT.MOV = Y.FECHA.CONTRATO
    END
    Y.EJE.ID = R.ACCOUNT<AC.AccountOpening.Account.AccountOfficer>
    R.DAO = ''
    Y.ERR.DAO = ''
    EB.DataAccess.FRead(FN.DAO,Y.EJE.ID, R.DAO, F.DAO, Y.ERR.DAO)
    Y.EJECUTIVO = UPCASE(R.DAO<ST.Config.DeptAcctOfficer.EbDaoName>)

    Y.AC.CATEGORY = ''
    Y.AC.CATEGORY = R.ACCOUNT<AC.AccountOpening.Account.Category>
    R.CATEGORY = ''; Y.CAT.ERR = '';
    EB.DataAccess.FRead(FN.CATEGORY,Y.AC.CATEGORY,R.CATEGORY,F.CATEGORY,Y.CAT.ERR)
    Y.NOM.PROD = ''
    Y.NOM.PROD = UPCASE(R.CATEGORY<ST.Config.Category.EbCatShortName,4>)
    IF Y.NOM.PROD EQ '' THEN
        Y.NOM.PROD = UPCASE(R.CATEGORY<ST.Config.Category.EbCatShortName,1>)
    END

    Y.TIPO.CLIENTE.DESC = ''
    BEGIN CASE
        CASE Y.TIPO.CLIENTE EQ 1
            Y.TIPO.CLIENTE.DESC = "PERSONA FISICA"
        CASE Y.TIPO.CLIENTE EQ 2
            Y.TIPO.CLIENTE.DESC = "PERSONA FISICA CON ACTIVIDAD EMPRESARIAL"
        CASE Y.TIPO.CLIENTE EQ 3
            Y.TIPO.CLIENTE.DESC = "PERSONA MORAL"
    END CASE

    Y.CUS.RFC = ''
    Y.CUS.RFC = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId,1>

    Y.AC.STATUS = ''
    Y.AC.STATUS = R.ACCOUNT<AC.AccountOpening.Account.PostingRestrict>
    IF Y.AC.STATUS MATCHES '82':@VM:'83' THEN
        Y.AC.STATUS = "NO ACTIVA"
    END ELSE
        Y.AC.STATUS = "ACTIVA"
    END

    Y.NUM.TARJETA.TITULAR = ''
    Y.NUM.TARJETA.ADICIONAL = ''
    Y.BANCA.ELECTRONICA = ''

    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS, Y.ACCOUNT.ID, R.INFO.ACC, F.ABC.ACCT.LCL.FLDS, ERROR.ACC)

    Y.BANCA.ELECTRONICA = R.INFO.ACC<AbcTable.AbcAcctLclFlds.AccesoInternet>
    Y.PROM.ENLACE = R.INFO.ACC<AbcTable.AbcAcctLclFlds.PromEnlace>

    Y.NO.PERSONAS.FACULTADAS = ''

    GOSUB OBTENER.NIVEL
    
    R.ABC.PROM.ENLACE=''
    Y.ERR.PROM.ENLACE=''
    EB.DataAccess.FRead(FN.ABC.PROM.ENLACE,Y.PROM.ENLACE,R.ABC.PROM.ENLACE,F.ABC.PROM.ENLACE,Y.ERR.PROM.ENLACE)
    Y.PROM.ENLACE.NOMBRE = R.ABC.PROM.ENLACE<AbcTable.AbcPromEnlace.Promotr>

*    Y.REGISTRO  = FMT(Y.ACCOUNT.ID,"%11") : Y.SEP.INI
    Y.REGISTRO  = Y.ACCOUNT.ID : Y.SEP.INI
    Y.REGISTRO := Y.NO.CLIENTE : Y.SEP.INI
    Y.REGISTRO := Y.SUCURSAL.CTA : Y.SEP.INI
    Y.REGISTRO := Y.NOM.CLIENTE : Y.SEP.INI
    Y.REGISTRO := Y.SALDO.CORTE : Y.SEP.INI
    Y.REGISTRO := Y.SALDO.BLOQ : Y.SEP.INI
    Y.REGISTRO := Y.SALDO.DISP : Y.SEP.INI
    Y.REGISTRO := Y.SALDO.PROM : Y.SEP.INI
    Y.REGISTRO := Y.INT.DEV : Y.SEP.INI
    Y.REGISTRO := Y.TASA : Y.SEP.INI
    Y.REGISTRO := Y.FECHA.APERTURA : Y.SEP.INI
    Y.REGISTRO := Y.FECHA.ULT.MOV : Y.SEP.INI
    Y.REGISTRO := Y.EJECUTIVO : Y.SEP.INI
    Y.REGISTRO := Y.NOM.PROD : Y.SEP.INI
    Y.REGISTRO := Y.TIPO.CLIENTE.DESC : Y.SEP.INI
    Y.REGISTRO := Y.CUS.RFC : Y.SEP.INI
    Y.REGISTRO := Y.AC.STATUS:Y.SEP.INI
    Y.REGISTRO := Y.NUM.TARJETA.TITULAR:Y.SEP.INI ;*CAMPO EN BLANCO
    Y.REGISTRO := Y.NUM.TARJETA.ADICIONAL:Y.SEP.INI         ;*CAMPO EN BLANCO
    Y.REGISTRO := Y.BANCA.ELECTRONICA:Y.SEP.INI
    Y.REGISTRO := Y.NO.PERSONAS.FACULTADAS:Y.SEP.INI        ;*CAMPO EN BLANCO
    Y.REGISTRO := Y.NIVEL.CTA:Y.SEP.INI
    Y.REGISTRO := Y.PROM.ENLACE.NOMBRE

    CONVERT Y.SEP.FIN TO '' IN Y.REGISTRO
    CONVERT Y.SEP.INI TO Y.SEP.FIN IN Y.REGISTRO
    
    BEGIN CASE
        CASE Y.AC.CATEGORY MATCHES Y.CATEG.CUENTA.AHORRO        ;*CUENTAS DE AHORRO
            WRITESEQ Y.REGISTRO TO CTA.STR.4 ELSE NULL
        CASE Y.AC.CATEGORY MATCHES Y.CATEG.CUENTA.SIN.CHEQUERA  ;*CUENTAS DE CHEQUES SIN CHEQUERA
            WRITESEQ Y.REGISTRO TO CTA.STR.5 ELSE NULL
        CASE Y.AC.CATEGORY MATCHES Y.CATEG.CUENTA.CON.CHEQUERA  ;*CUENTAS DE CHEQUES CON CHEQUERA
            WRITESEQ Y.REGISTRO TO CTA.STR.6 ELSE NULL
        CASE 1
            WRITESEQ Y.REGISTRO TO OTR.STR ELSE NULL  ;*OTROS
    END CASE

    CRT Y.REGISTRO

    Y.CADENA.LOG<-1> =  "Y.REGISTRO->" : Y.REGISTRO
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)
    
RETURN
*-------------------------------------------------------------------------------------------------------

*-------------------------------------

INICIA:
*-------------------------------------


    Y.CONDITION.GROUP = ''
    Y.ARRANGEMENT.ID = ''
    Y.NO.CLIENTE = ''
    Y.SUCURSAL.CTA = ''
    Y.NOM.CLIENTE = ''
    Y.SALDO.CORTE = ''
    Y.SALDO.BLOQ = ''
    Y.SALDO.DISP = ''
    Y.SALDO.PROM = ''
    Y.INT.DEV = ''
    Y.TASA = ''
    Y.FECHA.APERTURA = ''
    Y.FECHA.ULT.MOV = ''
    Y.EJECUTIVO = ''
    Y.NOM.PROD = ''
    Y.TIPO.CLIENTE.DESC = ''
    Y.CUS.RFC = ''
    Y.AC.STATUS = ''
    Y.NUM.TARJETA.TITULAR = ''
    Y.NUM.TARJETA.ADICIONAL = ''
    Y.BANCA.ELECTRONICA = ''
    Y.NO.PERSONAS.FACULTADAS = ''
    Y.SEP.INI = '*'
    Y.SEP.FIN = ','
    Y.NOMBRE.RUTINA = "ABC.SALDO.OPER.PASIVAS.ACC"

    FN.ACCOUNT                              = AbcSaldoOperPasivasAcc.getFnAccount()
    F.ACCOUNT                               = AbcSaldoOperPasivasAcc.getFAccount()
   
    FN.DAO                                  = AbcSaldoOperPasivasAcc.getFnDao()
    F.DAO                                   = AbcSaldoOperPasivasAcc.getFDao()
    
    FN.CUSTOMER                             = AbcSaldoOperPasivasAcc.getFnCustomer()
    F.CUSTOMER                              = AbcSaldoOperPasivasAcc.getFCustomer()
    
    FN.EB.CONTRACT.BALANCES                 = AbcSaldoOperPasivasAcc.getFnEbContractBalance()
    F.EB.CONTRACT.BALANCES                  = AbcSaldoOperPasivasAcc.getFEbContractBalance()
    
    FN.STMT.ACCT.CR                         = AbcSaldoOperPasivasAcc.getFnStmtAcctCr()
    F.STMT.ACCT.CR                          = AbcSaldoOperPasivasAcc.getFStmtAcctCr()
    
    FN.CATEGORY                             = AbcSaldoOperPasivasAcc.getFnCategory()
    F.CATEGORY                              = AbcSaldoOperPasivasAcc.getFCategory()
    
    FN.ABC.PROM.ENLACE                      = AbcSaldoOperPasivasAcc.getFnAbcPromEnlace()
    F.ABC.PROM.ENLACE                       = AbcSaldoOperPasivasAcc.getFAbcPromEnlace()
    
    FN.GROUP.CREDIT.INT                     = AbcSaldoOperPasivasAcc.getFnGroupCreditInt()
    F.GROUP.CREDIT.INT                      = AbcSaldoOperPasivasAcc.getFGroupCreditInt()
    
    Y.POS.CLASSIFICATION                    = AbcSaldoOperPasivasAcc.getYPosClassification()
    
    Y.POS.NOM.PER.MORAL                     = AbcSaldoOperPasivasAcc.getYPosNomPerMoral()
    Y.LWD                                   = AbcSaldoOperPasivasAcc.getYLwd()
    Y.PATH                                  = AbcSaldoOperPasivasAcc.getYPath()
    Y.CATEG.CUENTA.AHORRO                   = AbcSaldoOperPasivasAcc.getYCategCuentaAhorro()
    Y.ULT.DIA.W                             = AbcSaldoOperPasivasAcc.getYUltDiaW()
    Y.ULT.DIA.C                             = AbcSaldoOperPasivasAcc.getYUltDiaC()
    Y.NOM.PROC.OP.PAS                       = AbcSaldoOperPasivasAcc.getYNomProcOpPas()
    CTA.STR.4                               = AbcSaldoOperPasivasAcc.getCtaStr4()
    CTA.STR.5                               = AbcSaldoOperPasivasAcc.getCtaStr5()
    CTA.STR.6                               = AbcSaldoOperPasivasAcc.getCtaStr6()
    OTR.STR                                 = AbcSaldoOperPasivasAcc.getOtrStr()
    CTA.GC.NO.OF.REC                        = AbcSaldoOperPasivasAcc.getCtaGcNoOfRec()
    CTA.GC.SEL.LIST                         = AbcSaldoOperPasivasAcc.getCtaGcSelList()
    Y.CATEG.CUENTA.SIN.CHEQUERA             = AbcSaldoOperPasivasAcc.getYCategCuentaSinChequera()
    Y.CATEG.CUENTA.CON.CHEQUERA             = AbcSaldoOperPasivasAcc.getYCategCuentaConChequera()


RETURN
*-------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
LEER.PARAMETROS:
*-----------------------------------------------------------------------------

    FN.ABC.GENERAL.PARAM    = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM     = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)
    R.ABC.GENERAL.PARAM     = ''

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
********************
OBTENER.NIVEL:
********************
    Y.ACCOUNT.CATEGORY  = R.ACCOUNT<AC.AccountOpening.Account.Category>

    GOSUB LEER.PARAMETROS
    
    Y.NO.VALORES = DCOUNT(Y.LIST.PARAMS,@FM)
    FOR Y.AA=1 TO Y.NO.VALORES
        Y.PARAM = Y.LIST.PARAMS<Y.AA>
        Y.CATEGORIA = Y.LIST.VALUES<Y.AA>
        CHANGE '|' TO @FM IN Y.CATEGORIA
        LOCATE Y.ACCOUNT.CATEGORY IN Y.CATEGORIA SETTING Y.POS THEN
            Y.NIVEL.CTA = Y.PARAM
        END
    NEXT Y.AA
RETURN
END

