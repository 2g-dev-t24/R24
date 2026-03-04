* @ValidationCode : MjoxNTcxNjM4OTMzOkNwMTI1MjoxNzY5MTI0NTQxNjQ5OkVkZ2FyIFNhbmNoZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2026 17:29:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar Sanchez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
 


*=============================================================================
*       Req:         Parametrización del número de días para base de cálculo
*       Banco:       ABCCAPITAL
*       Autor:       César Miranda (CAMB) FYG
*       Fecha:       21 Junio 2019
*       Descripcion: Se modifica la Rutina para que el número de días se obtengan
*                    del registro ABC.BASE.CALCULO.DIAS de la aplicación
*                    ABC.GENERAL.PARAM
*=============================================================================
*       Req:         Parametrización monto exento ISR
*       Banco:       ABCCAPITAL
*       Autor:       César Miranda (CAMB) FYG
*       Fecha:       24 Agosto 2024
*       Descripcion: Se modifica la Rutina para validar si el saldo promedio de la
*                    cuenta es mayor al parametrizado en el registro ISR.VALOR.EXENTO.[AÑO AAAA]
*                     de ABC.GENERAL.PARAM
*=============================================================================
*       Autor:       César Miranda (CAMB) FYG
*       Fecha:       21 Julio 2025
*       Descripcion: Se modifica la rutina para que se calcule la retención con
*                    base al saldo con el que se calculó el interes pagado.
*=============================================================================

$PACKAGE AbcTaxes

SUBROUTINE ABC.TAX.ISR(PASS.CUSTOMER,PASS.DEAL.AMOUNT,PASS.DEAL.CCY,PASS.CCY.MKT,PASS.CROSS.RATE,PASS.CROSS.CCY,PASS.DWN.CCY,PASS.DATA,PASS.CUST.CDN,R.TAX,CHARGE.AMOUNT)

    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING AC.AccountOpening
    $USING CG.ChargeConfig
    $USING AbcGetGeneralParam
    $USING IC.Config
    $USING AC.EntryCreation
    $USING EB.SystemTables
    $USING AC.ModelBank
    $USING EB.API
    $USING EB.Reports
    $USING AbcTable

    GOSUB INITIALISATION
    GOSUB PROCESA

RETURN
********
PROCESA:
********

    Y.FIELD.EXENTO = ''; YERROR = ''; Y.REC.ACCT = '';
    EB.DataAccess.FRead(FN.ACCOUNT,Y.PASS.DATA.ACCT,Y.REC.ACCT,F.ACCOUNT,YERROR)
    Y.FIELD.EXENTO = ''; YOPEN.ACCOUNT = ''; YNUM.DIAS = 0;
    IF NOT(YERROR) THEN
        Y.ARR.ID = Y.REC.ACCT<AC.AccountOpening.Account.ArrangementId>
        R.ABC.ACCT.LCL.FLDS = AbcTable.AbcAcctLclFlds.Read(Y.ARR.ID,Y.ERROR.LCL)
        IF Y.ERROR.LCL EQ '' THEN
            Y.FIELD.EXENTO = R.ABC.ACCT.LCL.FLDS <AbcTable.AbcAcctLclFlds.ExentoImpuesto>
            Y.CONDITION.GROUP = Y.REC.ACCT<AC.AccountOpening.Account.ConditionGroup>  ;*CAMB 20250721
        END
    END

************************************ INICIO CAMB 20250721 ************************************
    Y.SELECT = "SELECT ": FN.GROUP.CREDIT.INT : " WITH @ID LIKE ": Y.CONDITION.GROUP : "MXN... BY-DSND @ID"
    Y.LIST = "" ; IVA.GRUPO = "" ; R.INFO.IVA = "" ; MNT.IVA.GRUPO = ""

    EB.DataAccess.Readlist(Y.SELECT,Y.LIST,"",Y.TOT.REC,Y.ERROR)
    IF Y.LIST THEN
        Y.GROUP.CREDIT.INT = Y.LIST<1>
        R.GROUP.CREDIT.INT = IC.Config.GroupCreditInt.Read(Y.GROUP.CREDIT.INT, Y.ERR.INT)
* Before incorporation : CALL F.READ(FN.GROUP.CREDIT.INT,Y.GROUP.CREDIT.INT,R.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT,Y.ERR.INT)
        IF R.GROUP.CREDIT.INT THEN
            Y.INT.RATE = R.GROUP.CREDIT.INT<IC.Config.GroupCreditInt.GciCrIntRate>
            Y.LIMIT.AMT = R.GROUP.CREDIT.INT<IC.Config.GroupCreditInt.GciCrLimitAmt>
            Y.LIMIT.AMT = RAISE(Y.LIMIT.AMT)
            Y.NO.VAL = DCOUNT(Y.INT.RATE,@VM)

            Y.INT.RATE.LIMITE = Y.INT.RATE<Y.NO.VAL>
            IF Y.INT.RATE.LIMITE GT 0 THEN
                Y.LIMITE.MONTO = Y.LIMIT.AMT<Y.NO.VAL>
            END ELSE
                Y.POS = Y.NO.VAL - 1
                Y.LIMITE.MONTO = Y.LIMIT.AMT<Y.POS>
            END
        END
    END
************************************* FIN CAMB 20250721 *************************************

    IF Y.FIELD.EXENTO EQ 'S' THEN
        CHARGE.AMOUNT = 0
    END ELSE
        GOSUB CALCULATE.ISR.TAX
        IF CHARGE.AMOUNT GE PASS.DEAL.AMOUNT THEN
            CHARGE.AMOUNT = PASS.DEAL.AMOUNT
        END
    END

RETURN
******************
CALCULATE.ISR.TAX:
******************
    LCCY = EB.SystemTables.getLccy()
    IF Y.REC.ACCT<AC.AccountOpening.Account.Currency> = LCCY THEN
        YPOS = ''
        LOCATE LCCY IN R.TAX<CG.ChargeConfig.Tax.EbTaxCurrency,1> SETTING YPOS THEN
            IF NOT(YERROR) THEN
                YTAX.RATE = ''; Y.TAX.FACTOR = '';
                YTAX.RATE = RAISE(R.TAX<CG.ChargeConfig.Tax.EbTaxBandedRate>)
                Y.TAX.FACTOR = (((YTAX.RATE/BASE.DE.CALCULO) * Y.BASE) / Y.BASE)
                SALDO.PROMEDIO.CUENTA = ''; YTAX.ISR = 0;
                IF Y.PASS.DATA.ACCT NE '' THEN
                    GOSUB SDO.PROMEDIO
                END
************************************ INICIO CAMB 20250721 ************************************
                IF Y.LIMITE.MONTO EQ '' THEN
                    Y.SALDO.CALCULO = SALDO.PROMEDIO.CUENTA
                END ELSE
                    IF SALDO.PROMEDIO.CUENTA LE Y.LIMITE.MONTO THEN
                        Y.SALDO.CALCULO = SALDO.PROMEDIO.CUENTA
                    END ELSE
                        Y.SALDO.CALCULO = Y.LIMITE.MONTO
                    END
                END

*    YTAX.ISR = (SALDO.PROMEDIO.CUENTA * Y.TAX.FACTOR * TOTAL.DIAS.DIVISION)
                YTAX.ISR = (Y.SALDO.CALCULO * Y.TAX.FACTOR * TOTAL.DIAS.DIVISION)

                IF Y.SALDO.CALCULO GT ISR.VALOR.EXENTO THEN
************************************* FIN CAMB 20250721 *************************************
                    CHARGE.AMOUNT = YTAX.ISR
                END ELSE
                    CHARGE.AMOUNT = 0
                END
            END ELSE
                CHARGE.AMOUNT = 0
            END
        END
    END

RETURN
*************
SDO.PROMEDIO:
*************

    YSEP = '*'; MOV.CUENTA = ''; SALDO.DIA  = ''; LISTA.STMT = '';
    GOSUB LEE.CUENTA
    D.FIELDS='ACCOUNT':@FM:'BOOKING.DATE'
    D.RANGE.AND.VALUE  = Y.PASS.DATA.ACCT:@FM:Y.PASS.DATA.MATURITY.BEGIN:@SM:Y.PASS.DATA.MATURITY.END
    D.LOGICAL.OPERANDS = '1':@FM:'2'
    AC.ModelBank.EStmtEnqByConcat(LISTA.STMT)
    TOTAL.STMT = ''
    TOTAL.STMT = DCOUNT(LISTA.STMT,@FM)
    SALDO.INICIAL = 0
    IF TOTAL.STMT GE 1 THEN
        LINEA.STMT = LISTA.STMT<1>
        SALDO.INICIAL = FIELD(LINEA.STMT,'*',3)
    END
    FOR J = 1 TO TOTAL.STMT
        LINEA.STMT = ''
        LINEA.STMT = LISTA.STMT<J>
        ID.STMT = FIELD(LINEA.STMT,'*',2)
        ERROR.STMT = ''; FECHA.STMT = ''; IMPORTE.STMT = '';
        EB.DataAccess.FRead(FN.STMT,ID.STMT,R.INFO.STMT,F.STMT,ERROR.STMT)
        IF ERROR.STMT EQ '' THEN
            FECHA.STMT = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteValueDate>
            IMPORTE.STMT = R.INFO.STMT<AC.EntryCreation.StmtEntry.SteAmountLcy>
            MOVIMIENTOS.CUENTA<-1> = FECHA.STMT:YSEP:Y.PASS.DATA.ACCT:YSEP:IMPORTE.STMT
        END
    NEXT J

    MOVIMIENTOS.CUENTA = SORT(MOVIMIENTOS.CUENTA)
    TOTAL.MOVIMIENTOS = ''
    TOTAL.MOVIMIENTOS = DCOUNT(MOVIMIENTOS.CUENTA,@FM)
    FECHA.MOV.ANT     = FIELD(MOVIMIENTOS.CUENTA<1>,YSEP,1)
    IMPORTE.MOV.ANT   = 0
    JJ = 1
    IF TOTAL.MOVIMIENTOS GT 1 THEN
        FOR JJ = 1 TO TOTAL.MOVIMIENTOS
            LINEA.MOV =  ''
            LINEA.MOV = MOVIMIENTOS.CUENTA<JJ>
            FECHA.MOV = FIELD(LINEA.MOV,YSEP,1)
            IMPORTE.MOV = FIELD(LINEA.MOV,YSEP,3)
            IF FECHA.MOV EQ FECHA.MOV.ANT THEN
                IMPORTE.MOV.ANT += IMPORTE.MOV
            END ELSE
                MOV.CUENTA<-1> = FECHA.MOV.ANT:YSEP:Y.PASS.DATA.ACCT:YSEP:IMPORTE.MOV.ANT
                FECHA.MOV.ANT = FECHA.MOV
                IMPORTE.MOV.ANT = IMPORTE.MOV
            END
        NEXT JJ
    END ELSE
        IF TOTAL.MOVIMIENTOS NE 0 THEN
            IMPORTE.MOV.ANT = FIELD(MOVIMIENTOS.CUENTA<1>,YSEP,3)
            MOV.CUENTA<-1> = FECHA.MOV.ANT:YSEP:Y.PASS.DATA.ACCT:YSEP:IMPORTE.MOV.ANT
        END
    END
    IF JJ NE 1 THEN
        MOV.CUENTA<-1>  = FECHA.MOV.ANT:YSEP:Y.PASS.DATA.ACCT:YSEP:IMPORTE.MOV.ANT
    END
    GOSUB OBTEN.SALDO.PROMEDIO

RETURN
*********************
OBTEN.SALDO.PROMEDIO:
*********************

    SALDO.PROMEDIO = SALDO.INICIAL
    SALDO.DIA      = SALDO.INICIAL
    SALDO.DIARIO   = ''
    JI = 1
    FOR II = 1 TO TOTAL.DIAS.MES
        LINEA.MOV.DIA  = MOV.CUENTA<JI>
        MOVIMIENTO.DIA = FIELD(LINEA.MOV.DIA,YSEP,3)
        FECHA.DIA      = FIELD(LINEA.MOV.DIA,YSEP,1)
        DIA.MOV        = FECHA.DIA[7,2]
        DIA.MOV       *= 1
        IF DIA.MOV EQ II THEN ;* HUBO MOV ESE DIA
            SALDO.DIA += MOVIMIENTO.DIA
            SALDO.DIARIO<-1> = SALDO.DIA
            JI +=1
        END ELSE
            SALDO.DIARIO<-1> = SALDO.DIA
        END
    NEXT II
    CONVERT @FM TO @VM IN SALDO.DIARIO
    SALDO.PROMEDIO.CUENTA  = SUM(SALDO.DIARIO)
    IF Y.PASS.DATA.MATURITY.BEGIN LE FECHA.APERTURA.CUENTA AND Y.PASS.DATA.MATURITY.END GE FECHA.APERTURA.CUENTA THEN
        DIA.APERTURA = ''; TOTAL.DIAS.DIVISION = '';
        DIA.APERTURA = FECHA.APERTURA.CUENTA[7,2]
        TOTAL.DIAS.DIVISION = (TOTAL.DIAS.MES - DIA.APERTURA) + 1
    END ELSE
        TOTAL.DIAS.DIVISION = TOTAL.DIAS.MES
    END

    SALDO.PROMEDIO.CUENTA /= TOTAL.DIAS.DIVISION
    SALDO.PROMEDIO.CUENTA = FMT(SALDO.PROMEDIO.CUENTA,"2")

RETURN
***********
LEE.CUENTA:
***********

    ERROR.CUENTA = ''; FECHA.APERTURA.CUENTA = '';
    EB.DataAccess.FRead(FN.ACCOUNT,Y.PASS.DATA.ACCT,R.INFO.CUENTA,F.ACCOUNT,ERROR.CUENTA)
    IF ERROR.CUENTA EQ '' THEN
        FECHA.APERTURA.CUENTA = R.INFO.CUENTA<AC.AccountOpening.Account.OpeningDate>
    END

RETURN
***************
INITIALISATION:
***************

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''; EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT);
    FN.STMT     = 'F.STMT.ENTRY'       ; F.STMT     = '' ; EB.DataAccess.Opf(FN.STMT,F.STMT)
    FN.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'; F.ACCT.ACTIVITY = ''; EB.DataAccess.Opf(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY);
    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'; F.EB.CONTRACT.BALANCES = ''; EB.DataAccess.Opf(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES);
    



    Y.ID.GEN.PARAM = 'ABC.BASE.CALCULO.DIAS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'NUM.DIAS' IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        BASE.DE.CALCULO = Y.LIST.VALUES<YPOS.PARAM>
    END

********************************* INICIA CMB 20240924 ********************************
    TODAY = EB.SystemTables.getToday()
    Y.ID.GEN.PARAM = 'ISR.VALOR.EXENTO.':TODAY[1,4]
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'VALOR' IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        ISR.VALOR.EXENTO = Y.LIST.VALUES<YPOS.PARAM>
    END
*********************************** FIN CMB 20240924 *********************************


*    BASE.DE.CALCULO = 36000
    BASE.DE.CALCULO *= 100
    Y.BASE = 1000000
    Y.PASS.DATA.ACCT = FIELD(PASS.DATA,@FM,38)
    Y.PASS.DATA.MATURITY.BEGIN = FIELD(PASS.DATA,@FM,39)
    Y.PASS.DATA.MATURITY.END = FIELD(PASS.DATA,@FM,40)

    Y.YEAR.BEGIN  = Y.PASS.DATA.MATURITY.BEGIN[1,4]
    Y.MONTH.BEGIN = Y.PASS.DATA.MATURITY.BEGIN[5,2]
    Y.DAY.BEGIN   = Y.PASS.DATA.MATURITY.BEGIN[7,2]

    Y.YEAR.END  = Y.PASS.DATA.MATURITY.END[1,4]
    Y.MONTH.END = Y.PASS.DATA.MATURITY.END[5,2]
    Y.DAY.END   = Y.PASS.DATA.MATURITY.END[7,2]

    TOTAL.DIAS.MES = Y.DAY.END
    CHARGE.AMOUNT = 0

    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'; F.GROUP.CREDIT.INT = ''; EB.DataAccess.Opf(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)         ;*CAMB 20250513

RETURN
**********
END

