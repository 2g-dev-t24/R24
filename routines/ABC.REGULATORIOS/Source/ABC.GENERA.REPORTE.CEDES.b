* @ValidationCode : Mjo4NDk3MzIxMTQ6Q3AxMjUyOjE3NjQxMjgyNjEyNzU6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Nov 2025 00:37:41
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
$PACKAGE AbcRegulatorios

SUBROUTINE ABC.GENERA.REPORTE.CEDES(Y.ID.TO.PROCESS)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AbcGetGeneralParam
    $USING EB.Updates
    $USING EB.Display
    $USING EB.Service
    $USING AA.Framework
    $USING AbcSaldoOperPasivasAcc
    $USING AA.ProductManagement
    $USING CG.ChargeConfig
    $USING AC.AccountOpening
    $USING AbcBi
    $USING AA.PaymentSchedule
    $USING EB.API
    $USING AbcContractService
*-----------------------------------------------------------------------------

    APPLICATION = 'ENQUIRY.SELECT'

    GOSUB PROCESA
    GOSUB FINALLY

RETURN

********
PROCESA:
********
    RUTA.PDF = AbcRegulatorios.getRutaPdf();
    RUTA.XML = AbcRegulatorios.getRutaXml();
    RUTA.JRXML = AbcRegulatorios.getRutaJrxml();

    NOMBRE.JR.PAG = AbcRegulatorios.getNombreJrPag();
    NOMBRE.PDF.PAG = AbcRegulatorios.getNombrePdfPag();

    NOMBRE.JR.F = AbcRegulatorios.getNombreJrF();
    NOMBRE.PDF.F = AbcRegulatorios.getNombrePdfF();

    NOMBRE.JR.CEDE = AbcRegulatorios.getNombreJrCede();
    NOMBRE.PDF.CEDE = AbcRegulatorios.getNombrePdfCede();

    NOMBRE.JAR = AbcRegulatorios.getNombreJar();

    RUTA.IMAGEN.JR = AbcRegulatorios.getRutaImagenJr();
    RUTA.SUBREPORTE.JR = AbcRegulatorios.getRutaSubreporteJr();
    RUTA.FICHERO.VECTOR = AbcRegulatorios.getRutaFicheroVector();
    NOMBRE.FICHERO.VECTOR = AbcRegulatorios.getNombreFicheroVector();

    FN.AA.ARR.ACT       = AbcRegulatorios.getFnAaArrAct();
    FN.ACTI.HIS         = AbcRegulatorios.getFnActiHis();
    FN.PARA.PROD        = AbcRegulatorios.getFnParaProd();
    FN.DAO              = AbcRegulatorios.getFnDao();
    FN.PRODUCTO         = AbcRegulatorios.getFnProducto();
    FN.CLIENTE          = AbcRegulatorios.getFnCliente();
    FN.CUENTA           = AbcRegulatorios.getFnCuenta();
    FN.TAX              = AbcRegulatorios.getFnTax();
    FN.AA.ARRANGEMENT   = AbcRegulatorios.getFnAaArrangement();
    FN.ACTI.HIS.HIS     = AbcRegulatorios.getFnActiHisHis();

    F.AA.ARR.ACT        = AbcRegulatorios.getFAaArrAct();
    F.ACTI.HIS          = AbcRegulatorios.getFAaActivityHistory();
    F.PARA.PROD         = AbcRegulatorios.getFAbcParamContProd();
    F.DAO               = AbcRegulatorios.getFDeptAcctOfficer();
    F.PRODUCTO          = AbcRegulatorios.getFAaProduct();
    F.CLIENTE           = AbcRegulatorios.getFCustomer();
    F.CUENTA            = AbcRegulatorios.getFAccount();
    F.TAX               = AbcRegulatorios.getFTax();
    F.AA.ARRANGEMENT    = AbcRegulatorios.getFAaArrangement();
    F.ACTI.HIS.HIS      = AbcRegulatorios.getFAaActivityHistoryHis();


    ID.ARRANGEMENT = Y.ID.TO.PROCESS
    IF ID.ARRANGEMENT NE '' THEN
        GOSUB EXTRAE.DETALLES.INV
        NOMBRE.CLIENTE = '';
        IF ID.CLIENTE NE '' THEN
            AbcSaldoOperPasivasAcc.AaCustomerImpresion(ID.CLIENTE,NOMBRE.CLIENTE)
*CALL AA.CUSTOMER.IMPRESION(ID.CLIENTE,NOMBRE.CLIENTE)
        END
        GOSUB CALCULA.GAT
        GOSUB PROYECTA.SCHEDULE
        GOSUB ARMA.PRODUCTO
        GOSUB GENERA.XML
        GOSUB GUARDA.XML
        GOSUB CREA.REPORTE
        GOSUB BORRA.XML


    END
RETURN

********************
EXTRAE.DETALLES.INV:
********************
    Y.SALTO.LINEA = CHAR(10)
    PRODUCTO.ID = ''; PROPERTY.LISTA = ''; REC.ARRANGEMENT = ''; PRODUCTO.NOMBRE = ''; ARR.STATUS = ''; ID.CLIENTE = ''; FECHA.INI.LD = '';
    TIPO.INVERSION = ''; ID.PARAM.PROD = ''
    IF ID.ARRANGEMENT NE '' THEN
        PRINT ID.ARRANGEMENT
        EB.DataAccess.FRead(FN.AA.ARRANGEMENT,ID.ARRANGEMENT,R.ARRANGEMENT,F.AA.ARRANGEMENT,ERROR.ARRANGEMENT)
        IF R.ARRANGEMENT THEN
            ARR.START.DATE = R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate>
        END ELSE
            Y.DATE.HOUR = TIMEDATE()
            Y.LOG.FINAL := Y.DATE.HOUR: ' - ':ID.ARRANGEMENT: ' - LA INVERSION INGRESADA NO EXISTE.':Y.SALTO.LINEA
            CONTADOR.NOPROCESADO = CONTADOR.NOPROCESADO +1
            Y.DATA := CONTADOR.NOPROCESADO: ','
            GOSUB CREA.LOG
            GOSUB CREA.DATA
            GOSUB FINALLY
        END
        AA.Framework.GetArrangementProduct(ID.ARRANGEMENT,effectiveDate,REC.ARRANGEMENT,PRODUCTO.ID,PROPERTY.LISTA)
*      CALL AA.GET.ARRANGEMENT.PRODUCT(ID.ARRANGEMENT,effectiveDate,REC.ARRANGEMENT,PRODUCTO.ID,PROPERTY.LISTA)
        IF REC.ARRANGEMENT NE '' THEN
            ID.CLIENTE = REC.ARRANGEMENT<1>
            ARR.STATUS = REC.ARRANGEMENT<6>
            FECHA.INI.LD = REC.ARRANGEMENT<AA.Framework.Arrangement.ArrOrigContractDate>
            IF PRODUCTO.ID NE '' THEN
                BEGIN CASE
                    CASE PRODUCTO.ID EQ 'DEPOSIT.PROMISSORY'

                        TIPO.INVERSION = '1'          ;*Pagare
                        ID.PARAM.PROD = '21004'
                        NOMBRE.JR = NOMBRE.JR.PAG
                        NOMBRE.PDF = NOMBRE.PDF.PAG

                    CASE PRODUCTO.ID EQ 'DEPOSIT.FIXED.INT'
                        TIPO.INVERSION = '2'          ;*Deposito de CD con Interes Fijo
                        ID.PARAM.PROD = '21003'
                        NOMBRE.JR = NOMBRE.JR.F
                        NOMBRE.PDF = NOMBRE.PDF.F

                    CASE PRODUCTO.ID EQ 'DEPOSIT.REVIEW.INT'
                        TIPO.INVERSION = '3'          ;*Deposito de CD con Int Revisable
                        ID.PARAM.PROD = '21005'
                        NOMBRE.JR = NOMBRE.JR.CEDE
                        NOMBRE.PDF = NOMBRE.PDF.CEDE

                    CASE PRODUCTO.ID EQ 'DEPOSIT.VAR.INT'
                        TIPO.INVERSION = '3'          ;*Depositos de CD con Tasas Variables
                        ID.PARAM.PROD = '21005'
                        NOMBRE.JR = NOMBRE.JR.CEDE
                        NOMBRE.PDF = NOMBRE.PDF.CEDE

                END CASE
                R.PRODUCTO = ''; ERROR.PRODUCTO = '';
                EB.DataAccess.FRead(FN.PRODUCTO,PRODUCTO.ID,R.PRODUCTO,F.PRODUCTO,ERROR.PRODUCTO)
                PRODUCTO.NOMBRE = R.PRODUCTO<AA.ProductManagement.Product.PdtDescription,4>
            END
        END

        SEL.ISR = ''; LISTA.ISR = ''; TOTAL.ISR = ''; ERROR.ISR = ''; TASA.ISR = '';
        SEL.ISR = 'SELECT ':FN.TAX:' WITH @ID LIKE ':DQUOTE(SQUOTE('21'):'...'): ' BY @ID'  ; * ITSS - NYADAV - Added DQUOTE / SQUOTE
        EB.DataAccess.Readlist(SEL.ISR,LISTA.ISR,'',TOTAL.ISR,ERROR.ISR)
        IF LISTA.ISR THEN
            ID.ISR = LISTA.ISR<TOTAL.ISR>
            R.TAX = ''; ER.ISR = '';
            EB.DataAccess.FRead(FN.TAX,ID.ISR,R.TAX,F.TAX,ER.ISR)
            IF R.TAX THEN
                TASA.ISR = R.TAX<CG.ChargeConfig.Tax.EbTaxBandedRate,1>
            END
        END

        CALENDARIO.DECE = ''
        INT.RATE = ''; ID.LD = ''; CAPITAL.INI.AUX = ''; YPLAZO = ''; TASA.NETA = ''; ID.CUENTA = ''; MONTO.LETRA = '';
        MONTO.LETRA = ''; MONTO.CONVIERTE = ''; TASA.MARGIN = ''; TASA.BRUTA = '';
        PROP.CLASS = "ACCOUNT":FM:"TERM.AMOUNT":FM:"INTEREST":FM:"SETTLEMENT"
        LOOP
            REMOVE CURR.PROP FROM PROP.CLASS SETTING PROP.POS
        WHILE CURR.PROP:PROP.POS
            idProperty = ''; returnIds = ''; returnConditions = ''; returnError = '';
            IF CURR.PROP EQ "INTEREST" AND TIPO.INVERSION EQ "3" THEN
                AA.Framework.GetArrangementConditions(ID.ARRANGEMENT,CURR.PROP,idProperty,ARR.START.DATE,returnIds,returnConditions,returnError)
            END ELSE
                AA.Framework.GetArrangementConditions(ID.ARRANGEMENT,CURR.PROP,idProperty,effectiveDate,returnIds,returnConditions,returnError)
            END
            IF returnConditions NE '' THEN
                returnConditions = RAISE(returnConditions)
                IF CURR.PROP EQ "TERM.AMOUNT" THEN
                    CAPITAL.INI.AUX = returnConditions<3>
                    YPLAZO = returnConditions<5>
                    IF YPLAZO NE '' THEN
                        YPLAZO = FIELD(YPLAZO,'D',1)
                    END
                END
                IF CURR.PROP EQ "ACCOUNT" THEN
                    ID.LD = returnConditions<11,1>
                END

                IF CURR.PROP EQ "INTEREST" THEN
                    TASA.BRUTA = returnConditions<22>
                    TASA.MARGIN = returnConditions<19>
                END
                IF CURR.PROP EQ "SETTLEMENT" THEN
                    REC.CONDITION = returnConditions
                    ID.CUENTA = REC.CONDITION<23>
                END
            END
        REPEAT
        R.CUENTA = ''; ER.CUENTA = ''; YEX.IMPUESTO = ''
        EB.DataAccess.FRead(FN.CUENTA,ID.CUENTA,R.CUENTA,F.CUENTA,ER.CUENTA)
        YPOS.EXENTO.IMPUESTO = AbcRegulatorios.getYposExentoImpuesto();
        IF R.CUENTA THEN
            YEX.IMPUESTO = R.CUENTA<AC.AccountOpening.Account.LocalRef,YPOS.EXENTO.IMPUESTO>
        END

        IF YEX.IMPUESTO EQ 'S' THEN
            IF TIPO.INVERSION EQ '3' THEN
                IF TASA.MARGIN NE '' THEN
                    TASA.VARIABLE  = 'CETE + ':TASA.MARGIN
                    TASA.NETA = 'CETE + ':TASA.MARGIN
                END
            END ELSE
                IF TIPO.INVERSION LT '3' THEN
                    IF TASA.BRUTA NE '' THEN
                        TASA.NETA = TASA.BRUTA
                    END
                END
            END
            TASA.ISR = 0.0
        END ELSE
            IF TIPO.INVERSION EQ '3' THEN
                IF TASA.MARGIN NE '' THEN
                    TASA.VARIABLE  = 'CETE + ':TASA.MARGIN
                    TASA.NETA = 'CETE + ':TASA.MARGIN:' - ISR'
                END
            END ELSE
                IF TIPO.INVERSION LT '3' THEN
                    IF TASA.BRUTA NE '' THEN
                        TASA.NETA = TASA.BRUTA - TASA.ISR
                    END
                END
            END
        END

        ID.INVERSION = ''
        IF ID.LD EQ '' THEN
            ID.INVERSION = ID.ARRANGEMENT
        END ELSE
            IF ID.LD[1,2] EQ 'LD' THEN
                ID.INVERSION = ID.LD
            END
        END

        PROCESS.TYPE = "INITIALISE"
        R.ACT.DET = ''
        FECHA.FIN.INV = ''
        FECHA.INI.INV = ''
        AA.PaymentSchedule.ProcessAccountDetails(ID.ARRANGEMENT,PROCESS.TYPE,'',R.ACT.DET,ERROR.ACT.DET)
*  CALL AA.PROCESS.ACCOUNT.DETAILS(ID.ARRANGEMENT,PROCESS.TYPE,'',R.ACT.DET,ERROR.ACT.DET)
        IF R.ACT.DET NE '' THEN
            FECHA.FIN.INV = R.ACT.DET<6>
            FECHA.INI.AA = R.ACT.DET<2>
        END

        PLAZO = ''
        IF FECHA.INI.LD EQ '' THEN
            FECHA.INI.INV = FECHA.INI.AA
            PLAZO = YPLAZO
        END ELSE
            FECHA.INI.INV = FECHA.INI.LD
            PLAZO = "C"
            EB.API.Cdd('',FECHA.INI.INV,FECHA.FIN.INV,PLAZO)
        END

        INV.FECHA.INI = FECHA.INI.INV[7,2]:'/':FECHA.INI.INV[5,2]:'/':FECHA.INI.INV[1,4]
        INV.FECHA.FIN = FECHA.FIN.INV[7,2]:'/':FECHA.FIN.INV[5,2]:'/':FECHA.FIN.INV[1,4]

        CURR.PROP = 'OFFICERS'; OFFICER.ID = ''; R.OFFICER.COND = ''; ACCT.ERR = '';
        ID.EJECITIVO = ''; NOMBRE.EJECUTIVO = ''; ID.SUCURSAL.CLIENTE = ''; NOMBRE.SUCURSAL = '';
        AA.Framework.GetArrangementConditions(ID.ARRANGEMENT,CURR.PROP,CURR.PROP,TODAY,OFFICER.ID,R.OFFICER.COND,ACCT.ERR)
        IF R.OFFICER.COND EQ '' THEN  AA.Framework.GetArrangementConditions(ID.ARRANGEMENT,'OFFICERS','OFFICER',TODAY,OFFICER.ID,R.OFFICER.COND,ACCT.ERR)
        IF R.OFFICER.COND NE '' THEN
            R.OFFICER.COND = RAISE(R.OFFICER.COND)
            ID.DAO = R.OFFICER.COND<3>
            ID.EJECITIVO = ID.DAO
            GOSUB LEE.DAO
            NOMBRE.EJECUTIVO     = NOMBRE.DAO
            ID.DAO               = R.OFFICER.COND<3>[1,5]
            ID.SUCURSAL.CLIENTE  = ID.DAO
            GOSUB LEE.DAO
            NOMBRE.SUCURSAL = NOMBRE.DAO
        END

        R.ACT.HIS = ''; ER.ACTI.HIS = '';
        LISTA.ACTIVITY = '';LISTA.REF.ACTI = ''; ID.ACT.REF = ''; ID.AAA = '';
        R.ARR.ACT = '';  ERR.ARR.ACT = ''; CAPITAL.INI = '';
        MONEDA = ''; DATE.TIME = '';CONPANIA = '';
        EB.DataAccess.FRead(FN.ACTI.HIS,ID.ARRANGEMENT,R.ACT.HIS,F.ACTI.HIS,ER.ACTI.HIS)
        IF R.ACT.HIS NE '' THEN
            LISTA.ACTIVITY = R.ACT.HIS<AA.Framework.ActivityHistory.AhActivity>
            LISTA.REF.ACTI = R.ACT.HIS<AA.Framework.ActivityHistory.AhActivityRef>
            LISTA.ACT.AMT  = R.ACT.HIS<AA.Framework.ActivityHistory.AhActivityAmt>
            LISTA.ACTIVITY.AMT = LISTA.ACTIVITY

            CONVERT @SM TO @FM IN LISTA.ACTIVITY
            CONVERT @SM TO @FM IN LISTA.REF.ACTI
            CONVERT @SM TO '' IN LISTA.ACT.AMT
            CONVERT @VM TO @FM IN LISTA.ACT.AMT
            CONVERT @VM TO @FM IN LISTA.ACTIVITY.AMT
            YPOS = ''; MONEDA = ''; DATE.TIME = ''; YFECHA = ''; YCONVIENTE = ''; FECHA.CONTRATO = '';
            YHORA = ''; HORA.CONTRATO = ''; FEC.HORA = ''; COMPANIA = ''; ID.AAA = '';
            FINDSTR 'DEPOSITS-NEW-ARRANGEMENT' IN LISTA.ACTIVITY SETTING YPOS THEN
                ID.AAA = LISTA.REF.ACTI<YPOS>
                GOSUB HORA.CONTRATO
            END ELSE
                FINDSTR 'DEPOSITS-TAKEOVER-ARRANGEMENT' IN LISTA.ACTIVITY SETTING YPOS THEN
                    ID.AAA = LISTA.REF.ACTI<YPOS>
                    GOSUB HORA.CONTRATO
                END
            END
            YPOS = ''
            FINDSTR 'DEPOSITS-APPLYPAYMENT-PR.DEPOSIT' IN LISTA.ACTIVITY.AMT SETTING YPOS THEN
                CAPITAL.INI = LISTA.ACT.AMT<YPOS>
            END
        END

        IF FEC.HORA EQ '' THEN
            FOR X = 1 TO 5
                ID.ARRANGEMENT.HIS = ID.ARRANGEMENT:"#":X
                EB.DataAccess.FRead(FN.ACTI.HIS.HIS,ID.ARRANGEMENT.HIS,R.ACT.HIS,F.ACTI.HIS.HIS,ER.ACTI.HIS)
                IF R.ACT.HIS NE '' THEN
                    LISTA.ACTIVITY = R.ACT.HIS<AA.Framework.ActivityHistory.AhActivity>
                    LISTA.REF.ACTI = R.ACT.HIS<AA.Framework.ActivityHistory.AhActivityRef>
                    LISTA.ACT.AMT  = R.ACT.HIS<AA.Framework.ActivityHistory.AhActivityAmt>
                    LISTA.ACTIVITY.AMT = LISTA.ACTIVITY

                    CONVERT @SM TO @FM IN LISTA.ACTIVITY
                    CONVERT @SM TO @FM IN LISTA.REF.ACTI
                    CONVERT @SM TO '' IN LISTA.ACT.AMT
                    CONVERT @VM TO @FM IN LISTA.ACT.AMT
                    CONVERT @VM TO @FM IN LISTA.ACTIVITY.AMT
                    FINDSTR 'DEPOSITS-NEW-ARRANGEMENT' IN LISTA.ACTIVITY SETTING YPOS THEN
                        ID.AAA = LISTA.REF.ACTI<YPOS>
                        GOSUB HORA.CONTRATO
                        X = 5
                    END ELSE
                        FINDSTR 'DEPOSITS-TAKEOVER-ARRANGEMENT' IN LISTA.ACTIVITY SETTING YPOS THEN
                            ID.AAA = LISTA.REF.ACTI<YPOS>
                            GOSUB HORA.CONTRATO
                            X = 5
                        END
                    END
                END
            NEXT
        END

        IF CAPITAL.INI EQ '' THEN
            CAPITAL.INI = CAPITAL.INI.AUX
        END
        MONTO.CONVIERTE = CAPITAL.INI
*CALL NUM.TO.TEXT(MONTO.CONVIERTE)
        MONTO.LETRA = MONTO.CONVIERTE
        FINDSTR 'PESOS' IN MONTO.CONVIERTE SETTING Ap, Vp THEN
            MONTO.LETRA := ' MN'
        END ELSE
            MONTO.LETRA := ' PESOS 00/100 MN'
        END
    END

RETURN
**************
HORA.CONTRATO:
**************

    IF ID.AAA NE '' THEN
        EB.DataAccess.FRead(FN.AA.ARR.ACT,ID.AAA,R.ARR.ACT,F.AA.ARR.ACT,ERR.ARR.ACT)
        IF R.ARR.ACT NE '' THEN
            MONEDA = R.ARR.ACT<AA.Framework.ArrangementActivity.ArrActCurrency>
            IF MONEDA NE '' THEN
                IF MONEDA EQ 'MXN' THEN
                    MONEDA = 'PESOS'
                END
            END
            DATE.TIME = R.ARR.ACT<AA.Framework.ArrangementActivity.ArrActDateTime>
            IF DATE.TIME NE '' THEN
                YFECHA  = DATE.TIME[1,6]
                FECHA.CONTRATO = YFECHA[5,2]:"/":YFECHA[3,2]:"/20":YFECHA[1,2]
                FECH.INI = "20":YFECHA[1,2]:YFECHA[3,2]:YFECHA[5,2]
                YHORA =  DATE.TIME[7,4]
                HORA.CONTRATO = YHORA[1,2]:':':YHORA[3,2]
                FEC.HORA = FECHA.CONTRATO:' ':HORA.CONTRATO
            END
            COMPANIA =  R.ARR.ACT<AA.Framework.ArrangementActivity.ArrActCoCode>
        END
    END

RETURN
********
LEE.DAO:
********

    ERROR.DAO  = ''
    R.INFO.DAO = ''
    NOMBRE.DAO = ''
    EB.DataAccess.FRead(FN.DAO,ID.DAO,R.INFO.DAO,F.DAO,ERROR.DAO)
    IF ERROR.DAO EQ '' THEN
        NOMBRE.DAO = TRIM(R.INFO.DAO<EB.DAO.NAME>)
    END

RETURN
************
CALCULA.GAT:
************

    GAT.NOMINAL = ''; GAT.REAL = ''; TASA.BRT = '';
    IF TASA.BRUTA NE '' AND PLAZO NE '' AND TIPO.INVERSION NE '' THEN
        TASA.BRT = TASA.BRUTA
        FECHA.INICIO = FECHA.INI.INV
        AbcBi.AbcGetGatReimpresion(TASA.BRT,PLAZO,TIPO.INVERSION,FECHA.INICIO,GAT.NOMINAL,GAT.REAL)
*  CALL ABC.GET.GAT.REIMPRESION(TASA.BRT,PLAZO,TIPO.INVERSION,FECHA.INICIO,GAT.NOMINAL,GAT.REAL)
    END

RETURN
******************
PROYECTA.SCHEDULE:
******************
    IF TIPO.INVERSION NE '' THEN
        IF TIPO.INVERSION EQ 1 THEN
            CYCLE.DATE = FECHA.FIN.INV
            DIA.REQD = FECHA.FIN.INV
        END ELSE
            CYCLE.DATE = ''
            DIA.REQD = FECHA.INI.INV:FM:FECHA.FIN.INV
        END
        YCONCEPTO = ''; INTERESES.NETOS = ''; CAPITAL.VENCIMIENTO = ''; CEDE.FIJO = ''; CEDE.REV.VAR = '';
        TOT.PAYMENT = ''; DUE.DATES = ''; DUE.TYPES = ''; DUE.METHODS = ''; DUE.TYPE.AMTS = ''; DUE.PROPS = ''; DUE.PROP.AMTS = ''; DUE.OUTS = '';
        CYCLE.DATE      = ''
        TOT.PAYMENT     = ''
        DUE.DATES       = ''
        DUE.TYPES       = ''
        DUE.METHODS     = ''
        DUE.TYPE.AMTS   = ''
        DUE.PROPS       = ''
        DUE.PROP.AMTS   = ''
        DUE.OUTS        = ''
        AA.PaymentSchedule.ScheduleProjector(ID.ARRANGEMENT,SIM.REF, '', CYCLE.DATE, TOT.PAYMENT, DUE.DATES, '', DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
        IF DUE.TYPES EQ '' AND DUE.DATES EQ '' THEN
            CYCLE.DATE = FECHA.INI.INV:FM:FECHA.FIN.INV
            DIA.REQD = ''
            AA.PaymentSchedule.ScheduleProjector(ID.ARRANGEMENT,SIM.REF, '', CYCLE.DATE, TOT.PAYMENT, DUE.DATES, '', DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
*AA.SCHEDULE.PROJECTOR(ID.ARRANGEMENT,"","",CYCLE.DATE,TOT.PAYMENT,DUE.DATES,DUE.TYPES,DUE.METHODS,DUE.TYPE.AMTS,DUE.PROPS,DUE.PROP.AMTS,DUE.OUTS)
        END


        DUE.FECHA = ''; TOT.TIPOS = ''; DUE.MONTO = ''; YPAGARE = ''; DUE.TIPO = '';
        IF TIPO.INVERSION EQ '1' THEN
            TOT.FECHA = DCOUNT(DUE.DATES,FM)
            FOR I = 1 TO TOT.FECHA
                DUE.FECHA = ''
                DUE.FECHA = DUE.DATES<I>
                TOT.TIPOS = ''
                TOT.TIPOS = COUNT(DUE.TYPES<I>,VM) + 1
                FOR II = 1 TO TOT.TIPOS
                    DUE.TIPO = ''
                    DUE.TIPO = DUE.TYPES<I,II>
                    DUE.MONTO  = ''
                    DUE.MONTO  = DUE.TYPE.AMTS<I,II>
                    IF DIA.REQD THEN
                        IF (DIA.REQD = DUE.FECHA) THEN
                            YPAGARE <-1>= DUE.TIPO:'*':DUE.MONTO
                        END
                    END
                NEXT II
            NEXT I
            YCONCEPTO = ''; INTERESES.NETOS = ''; CAPITAL.VENCIMIENTO = '';
            FINDSTR 'INTEREST' IN YPAGARE SETTING Y.POS THEN
                YCONCEPTO = YPAGARE<Y.POS>
                INTERESES.NETOS = FIELD(YCONCEPTO,'*',2)
                CAPITAL.VENCIMIENTO = CAPITAL.INI + INTERESES.NETOS
            END
        END

        TOT.DTES = ''; FECHA.INT = ''; TOT.TYPES = ''; TIPO.DUE = ''; DUE.MONTO = '';  CEDE.FIJO = '';
        IF TIPO.INVERSION EQ '2' THEN

            TOT.DTES = DCOUNT(DUE.DATES,FM)
            FECHA.ANT = ''
            FOR I  = 1 TO TOT.DTES
                FECHA.INT = ''
                FECHA.INT = DUE.DATES<I>
                CALE = ''

                IF I EQ 2 THEN
                    FECHA.ANT = FECH.INI
                END

                IF I GE 2 THEN
                    CALE = "C"
                    EB.API.Cdd('',FECHA.ANT,FECHA.INT,CALE)
                    XML = FECHA.ANT:"|":FECHA.INT
                    FECHA.ANT = FECHA.INT

                END

                TOT.TYPES = ''
                TOT.TYPES = COUNT(DUE.TYPES<I>,VM) + 1
                FOR II = 1 TO TOT.TYPES

                    TIPO.DUE = ''
                    TIPO.DUE = DUE.TYPES<I,II>
                    DUE.MONTO = ''
                    FECHA.INT.1 = FECHA.INT
                    IF TIPO.DUE EQ 'INTEREST' THEN
                        DUE.MONTO = DUE.TYPE.AMTS<I,II>
                        CEDE.FIJO <-1> = '<CEDES>'
                        CEDE.FIJO := '<DIAS_CEDE>':CALE:'</DIAS_CEDE>'
                        CEDE.FIJO := '<FECHA_I>':XML:'</FECHA_I>'
                        CEDE.FIJO := '<FECHA_CEDE>':FECHA.INT:'</FECHA_CEDE>'
                        CEDE.FIJO := '<MONTO_CEDE>':DUE.MONTO:'</MONTO_CEDE>'
                        CEDE.FIJO := '</CEDES>'

                    END
                NEXT II
            NEXT I
        END

        TOT.DTES = ''; FECHA.INT = ''; TOT.TYPES = ''; TIPO.DUE = ''; CEDE.REV.VAR = '';
        IF TIPO.INVERSION EQ '3' THEN
            TOT.DTES = DCOUNT(DUE.DATES,FM)       ;* Total Number of Schedule dates
            CONT = 0
            FECHA.ANT = ''
            FOR I  = 1 TO TOT.DTES
                FECHA.INT = ''
                FECHA.INT = DUE.DATES<I>          ;* Pick each date
                TOT.TYPES = ''
                TOT.TYPES = COUNT(DUE.TYPES<I>,VM) + 1
                FOR II = 1 TO TOT.TYPES
                    TIPO.DUE = ''
                    TIPO.DUE = DUE.TYPES<I,II>
                    CALE = ''
                    IF I EQ 2 THEN
                        FECHA.ANT = FECH.INI
                    END

                    IF I GE 2 THEN
                        CALE = "C"
                        EB.API.Cdd('',FECHA.ANT,FECHA.INT,CALE)
                        XML = FECHA.ANT:"|":FECHA.INT
                        FECHA.ANT = FECHA.INT
                    END
                    IF TIPO.DUE EQ 'INTEREST' THEN
                        CEDE.REV.VAR <-1>= '<CEDES>'
                        CEDE.REV.VAR := '<DIAS_CEDE>':CALE:'</DIAS_CEDE>'
                        CEDE.REV.VAR := '<FECHA_CEDE>':FECHA.INT:'</FECHA_CEDE>'
                        CEDE.REV.VAR := '</CEDES>'
                    END
                NEXT II
            NEXT I
        END
    END

RETURN
**************
ARMA.PRODUCTO:
**************
    IF ID.PARAM.PROD THEN
        IF ID.CLIENTE THEN
            R.CLIENTE = ''; ERR.CLIENTE = ''; TIT.GARA = '';
            EB.DataAccess.FRead(FN.CLIENTE,ID.CLIENTE,R.CLIENTE,F.CLIENTE,ERR.CLIENTE)
            IF R.CLIENTE THEN
                TIT.GARA = ''
            END
        END

        R.PARA.PROD = ''; ER.PARA.PROD = ''
        NOM.COM = ''; TIPO.OPER = ''; MED.TARJETA = '';MED.CHQ = ''; MED.BAN.INT = ''; MED.CAJERO = '';
        MED.VENT = ''; MED.AFIL = ''; MED.COMI.BAN = ''; NOMBRE.UEAU = ''; DOMI.UEAU = '';
        TEL.UEAU = ''; CORREO.UEAU = ''; PAG.UEAU = ''; TEL.CONDU = ''; PAG.CONDU = '';
        EB.DataAccess.FRead(FN.PARA.PROD,ID.PARAM.PROD,R.PARA.PROD,F.PARA.PROD,ER.PARA.PROD)
        IF R.PARA.PROD THEN
            NOM.COM      = TRIM(R.PARA.PROD<CO.PR.NOM.COMERCIAL>)
            TIPO.OPER    = TRIM(R.PARA.PROD<CO.PR.TIPO.OPER>)
            MED.TARJETA  = TRIM(R.PARA.PROD<CO.PR.MED.TARJETA>)
            MED.CHQ      = TRIM(R.PARA.PROD<CO.PR.MED.CHEQUERA>)
            MED.BAN.INT  = TRIM(R.PARA.PROD<CO.PR.MED.INTERNET>)
            MED.CAJERO   = TRIM(R.PARA.PROD<CO.PR.MED.CAJERO>)
            MED.VENT     = TRIM(R.PARA.PROD<CO.PR.MED.VENTANILLA>)
            MED.AFIL     = TRIM(R.PARA.PROD<CO.PR.MED.COMERCIO>)
            MED.COMI.BAN = TRIM(R.PARA.PROD<CO.PR.MED.DOMICILIA>)
            NOMBRE.UEAU  = TRIM(R.PARA.PROD<CO.PR.UEAU.NOMBRE>)
            DOMI.UEAU    = TRIM(R.PARA.PROD<CO.PR.DOMICILIO>)
            TEL.UEAU     = TRIM(R.PARA.PROD<CO.PR.TELEFONO>)
            CORREO.UEAU  = TRIM(R.PARA.PROD<CO.PR.CORREO>)
            PAG.UEAU     = TRIM(R.PARA.PROD<CO.PR.PAG.WEB>)
            TEL.CONDU    = TRIM(R.PARA.PROD<CO.PR.CDF.TEL>)
            PAG.CONDU    = TRIM(R.PARA.PROD<CO.PR.CDF.PAG.WEB>)
        END
    END
    Y.SEP = ','
    SALIDA.PRODUCTO = ''
    SALIDA.PRODUCTO := NOM.COM:Y.SEP:TIPO.OPER:Y.SEP:TASA.BRUTA:Y.SEP:GAT.NOMINAL:Y.SEP:GAT.REAL:Y.SEP:MED.TARJETA:Y.SEP:MED.CHQ:Y.SEP:MED.BAN.INT:Y.SEP:MED.CAJERO:Y.SEP:MED.VENT:Y.SEP:MED.AFIL:Y.SEP:MED.COMI.BAN:Y.SEP
    SALIDA.PRODUCTO := NOMBRE.UEAU:Y.SEP:DOMI.UEAU:Y.SEP:TEL.UEAU:Y.SEP:CORREO.UEAU:Y.SEP:PAG.UEAU:Y.SEP:TEL.CONDU:Y.SEP:PAG.CONDU:Y.SEP:TIT.GARA

RETURN
*************
XML.BLOQUE.DATOS:
*************
    CHANGE @FM TO '' IN CEDE.FIJO
    CHANGE @FM TO '' IN CEDE.REV.VAR

    INV.FECHA.INI = FEC.HORA

    IF TIPO.INVERSION EQ 1 THEN
        Y.XML := '<TIPO_INVERSION>':TIPO.INVERSION:'</TIPO_INVERSION>'
        Y.XML := '<ID_CLIENTE>':ID.CLIENTE:'</ID_CLIENTE>'
        Y.XML := '<NOMBRE_CLIENTE>':NOMBRE.CLIENTE:'</NOMBRE_CLIENTE>'
        Y.XML := '<ID_SUCURSAL>':ID.SUCURSAL.CLIENTE:'</ID_SUCURSAL>'
        Y.XML := '<NOMBRE_SUCURSAL>':NOMBRE.SUCURSAL:'</NOMBRE_SUCURSAL>'
        Y.XML := '<FECHA_HORA>':FEC.HORA:'</FECHA_HORA>'
        Y.XML := '<ID_CUENTA>':ID.CUENTA:'</ID_CUENTA>'
        Y.XML := '<ID_INVERSION>':ID.INVERSION:'</ID_INVERSION>'
        Y.XML := '<PLAZO>':PLAZO:'</PLAZO>'
        Y.XML := '<INV_FECHA_INI>':INV.FECHA.INI:'</INV_FECHA_INI>'
        Y.XML := '<INV_FECHA_FIN>':INV.FECHA.FIN:'</INV_FECHA_FIN>'
        Y.XML := '<MONEDA>':MONEDA:'</MONEDA>'
        Y.XML := '<TASA_BRUTA>':TASA.BRUTA:'</TASA_BRUTA>'
        Y.XML := '<TASA_ISR>':TASA.ISR:'</TASA_ISR>'
        Y.XML := '<TASA_NETA>':TASA.NETA:'</TASA_NETA>'
        Y.XML := '<GAT_NOMINAL>':GAT.NOMINAL:'</GAT_NOMINAL>'
        Y.XML := '<GAT_REAL>':GAT.REAL:'</GAT_REAL>'
        Y.XML := '<CAPITAL_INI>':CAPITAL.INI:'</CAPITAL_INI>'
        Y.XML := '<MONTO_LETRA>':MONTO.LETRA:'</MONTO_LETRA>'
        Y.XML := '<INTERESES_NETOS>':INTERESES.NETOS:'</INTERESES_NETOS>'
        Y.XML := '<CAPITAL_VENCIMIENTO>':CAPITAL.VENCIMIENTO:'</CAPITAL_VENCIMIENTO>'
        Y.XML := '<CALENDARIO_DEC>':CALENDARIO.DECE:'</CALENDARIO_DEC>'
        Y.XML := '<SALIDA_PRODUCTO>':SALIDA.PRODUCTO:'</SALIDA_PRODUCTO>'
    END

    IF TIPO.INVERSION EQ 2 THEN
        Y.XML := '<TIPO_INVERSION>':TIPO.INVERSION:'</TIPO_INVERSION>'
        Y.XML := '<ID_CLIENTE>':ID.CLIENTE:'</ID_CLIENTE>'
        Y.XML := '<NOMBRE_CLIENTE>':NOMBRE.CLIENTE:'</NOMBRE_CLIENTE>'
        Y.XML := '<ID_SUCURSAL>':ID.SUCURSAL.CLIENTE:'</ID_SUCURSAL>'
        Y.XML := '<NOMBRE_SUCURSAL>':NOMBRE.SUCURSAL:'</NOMBRE_SUCURSAL>'
        Y.XML := '<FECHA_HORA>':FEC.HORA:'</FECHA_HORA>'
        Y.XML := '<ID_CUENTA>':ID.CUENTA:'</ID_CUENTA>'
        Y.XML := '<ID_INVERSION>':ID.INVERSION:'</ID_INVERSION>'
        Y.XML := '<PLAZO>':PLAZO:'</PLAZO>'
        Y.XML := '<INV_FECHA_INI>':INV.FECHA.INI:'</INV_FECHA_INI>'
        Y.XML := '<INV_FECHA_FIN>':INV.FECHA.FIN:'</INV_FECHA_FIN>'
        Y.XML := '<MONEDA>':MONEDA:'</MONEDA>'
        Y.XML := '<TASA_BRUTA>':TASA.BRUTA:'</TASA_BRUTA>'
        Y.XML := '<TASA_ISR>':TASA.ISR:'</TASA_ISR>'
        Y.XML := '<TASA_NETA>':TASA.NETA:'</TASA_NETA>'
        Y.XML := '<GAT_NOMINAL>':GAT.NOMINAL:'</GAT_NOMINAL>'
        Y.XML := '<GAT_REAL>':GAT.REAL:'</GAT_REAL>'
        Y.XML := '<CAPITAL_INI>':CAPITAL.INI:'</CAPITAL_INI>'
        Y.XML := '<MONTO_LETRA>':MONTO.LETRA:'</MONTO_LETRA>'
        Y.XML := '<INTERESES_NETOS>':INTERESES.NETOS:'</INTERESES_NETOS>'
        Y.XML := '<CAPITAL_VENCIMIENTO>':CAPITAL.VENCIMIENTO:'</CAPITAL_VENCIMIENTO>'
        Y.XML := '<CEDE_FIJO>':CEDE.FIJO:'</CEDE_FIJO>'
        Y.XML := '<SALIDA_PRODUCTO>':SALIDA.PRODUCTO:'</SALIDA_PRODUCTO>'

    END

    IF TIPO.INVERSION EQ 3 THEN
        Y.XML := '<TIPO_INVERSION>':TIPO.INVERSION:'</TIPO_INVERSION>'
        Y.XML := '<ID_CLIENTE>':ID.CLIENTE:'</ID_CLIENTE>'
        Y.XML := '<NOMBRE_CLIENTE>':NOMBRE.CLIENTE:'</NOMBRE_CLIENTE>'
        Y.XML := '<ID_SUCURSAL>':ID.SUCURSAL.CLIENTE:'</ID_SUCURSAL>'
        Y.XML := '<NOMBRE_SUCURSAL>':NOMBRE.SUCURSAL:'</NOMBRE_SUCURSAL>'
        Y.XML := '<FECHA_HORA>':FEC.HORA:'</FECHA_HORA>'
        Y.XML := '<ID_CUENTA>':ID.CUENTA:'</ID_CUENTA>'
        Y.XML := '<ID_INVERSION>':ID.INVERSION:'</ID_INVERSION>'
        Y.XML := '<PLAZO>':PLAZO:'</PLAZO>'
        Y.XML := '<INV_FECHA_INI>':INV.FECHA.INI:'</INV_FECHA_INI>'
        Y.XML := '<INV_FECHA_FIN>':INV.FECHA.FIN:'</INV_FECHA_FIN>'
        Y.XML := '<MONEDA>':MONEDA:'</MONEDA>'
        Y.XML := '<TASA_VARIABLE>':TASA.VARIABLE:'</TASA_VARIABLE>'
        Y.XML := '<TASA_ISR>':TASA.ISR:'</TASA_ISR>'
        Y.XML := '<TASA_NETA>':TASA.NETA:'</TASA_NETA>'
        Y.XML := '<GAT_NOMINAL>':GAT.NOMINAL:'</GAT_NOMINAL>'
        Y.XML := '<GAT_REAL>':GAT.REAL:'</GAT_REAL>'
        Y.XML := '<CAPITAL_INI>':CAPITAL.INI:'</CAPITAL_INI>'
        Y.XML := '<MONTO_LETRA>':MONTO.LETRA:'</MONTO_LETRA>'
        Y.XML := '<INTERESES_NETOS>':INTERESES.NETOS:'</INTERESES_NETOS>'
        Y.XML := '<CAPITAL_VENCIMIENTO>':CAPITAL.VENCIMIENTO:'</CAPITAL_VENCIMIENTO>'
        Y.XML := '<CEDE_VARIABLE>':CEDE.REV.VAR:'</CEDE_VARIABLE>'
        Y.XML := '<SALIDA_PRODUCTO>':SALIDA.PRODUCTO:'</SALIDA_PRODUCTO>'
    END

RETURN
***********
GUARDA.XML:
***********
    NOMBRE.XML = Y.ID.TO.PROCESS:"_TEMP.xml"

    OPENSEQ RUTA.XML,NOMBRE.XML TO FILE.VAR1 THEN
        EXECUTE "rm " : RUTA.XML:NOMBRE.XML        CAPTURING Y.RESPONSE.RM
    END

    OPENSEQ RUTA.XML,NOMBRE.XML TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    WRITESEQ Y.XML APPEND TO FILE.VAR1 ELSE
    END

RETURN
***********
GENERA.XML:
***********
    Y.XML = '<?xml version="1.0" encoding="UTF-8"?>'
    Y.XML := '<Datos>'

*VA IR LO DEL XML

    GOSUB XML.BLOQUE.DATOS

    Y.XML := '<RUTA_IMAGEN_JR>':RUTA.IMAGEN.JR:'</RUTA_IMAGEN_JR>'
    Y.XML := '<RUTA_SUBREPORTE_JR>':RUTA.SUBREPORTE.JR:'</RUTA_SUBREPORTE_JR>'
    Y.XML := '</Datos>'

RETURN

*************
CREA.REPORTE:
*************
    Y.DIR = RUTA.FICHERO.VECTOR: 'data_folder.temp.txt'
    OPENSEQ Y.DIR TO ARCH.TEMP  THEN
        LOOP
            READSEQ Y.LINEA FROM ARCH.TEMP THEN STATE=STATUS() ELSE EXIT
        UNTIL STATE=1
            Y.NOMBRE.CARPETA = FIELD(Y.LINEA,'',1)
        REPEAT
        CLOSESEQ ARCH.TEMP
    END
    Y.ID.ARR = FIELD(Y.LIST,'|',I)
    Y.PARAMETROS = ''
    Y.RUTA.PDF = RUTA.FICHERO.VECTOR: Y.NOMBRE.CARPETA:"/"
    Y.RUTA.XML = RUTA.XML
    Y.RUTA.JRXML = RUTA.JRXML
    Y.NOMBRE.JR = NOMBRE.JR
    Y.NOMBRE.PDF = NOMBRE.PDF : ID.ARRANGEMENT: ".pdf"
    Y.NOMBRE.JAR = NOMBRE.JAR
    Y.NOMBRE.XML = ID.ARRANGEMENT: "_TEMP"

    Y.PARAMETROS = Y.RUTA.JRXML: "*": Y.NOMBRE.JR: "*": Y.NOMBRE.XML: "*": Y.RUTA.XML: "*":Y.RUTA.PDF: "*": Y.NOMBRE.PDF
    AbcContractService.AbcEjecutaJarGeneric(Y.PARAMETROS,Y.NOMBRE.JAR,Y.DIRECTORIO)
*CALL ABC.EJECUTA.JAR.GENERIC(Y.PARAMETROS,Y.NOMBRE.JAR,Y.DIRECTORIO)

RETURN

**************
CREA.LOG:
**************
    Y.FECHA.LOG = OCONV( DATE(), 'D4-' )
    Y.FICHERO.LOG = 'LOG_CEDES_': Y.FECHA.LOG:'.txt'
    Y.CARPETA.CEDES = AbcRegulatorios.getYCarpetaCedes();

    OPEN RUTA.FICHERO.VECTOR:Y.CARPETA.CEDES TO F.RUTA.ARCHIVO ELSE Y.RESPUES = "ERROR AL ABRIR RUTA"
    WRITE Y.LOG.FINAL TO F.RUTA.ARCHIVO,Y.FICHERO.LOG

RETURN

**************
CREA.DATA:
**************
    Y.FICHERO.DATA = 'data_temp.txt'

    OPEN RUTA.FICHERO.VECTOR TO F.RUTA ELSE Y.RESPUES = "ERROR AL ABRIR RUTA"
    WRITE Y.DATA TO F.RUTA,Y.FICHERO.DATA
RETURN

***********
BORRA.XML:
***********
    OPENSEQ RUTA.XML,NOMBRE.XML TO FILE.VAR1 THEN
        EXECUTE "rm " : RUTA.XML:NOMBRE.XML        CAPTURING Y.RESPONSE.RM
    END

RETURN
*-------------------------------------------------------------------------
*Last Step in Program
*-------------------------------------------------------------------------
FINALLY:
*-----------------------------------------------------------------------------

*Do Not Add Return :)

END

