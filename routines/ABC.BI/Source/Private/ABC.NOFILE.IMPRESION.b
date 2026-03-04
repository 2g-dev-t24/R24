* @ValidationCode : MjotOTg1MTk0MDYxOkNwMTI1MjoxNzY3NzE0MjUxNzM4OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Jan 2026 09:44:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
*-----------------------------------------------------------------------------
$PACKAGE AbcBi
*-----------------------------------------------------------------------------
SUBROUTINE ABC.NOFILE.IMPRESION(R.DATA)
*-----------------------------------------------------------------------------
*********************************************************************
* Company Name      : Uala
* Developed By      : FYG Solutions
* Product Name      : EB
*--------------------------------------------------------------------------------------------
* Subroutine Type : ENQUIRY NOFILE
* Attached to : STANDARD.SELECTION>NOFILE.ENQ.IMPRESION
*               ENUQIRY>ENQ.NOFILE.IMP.DOC
* Attached as : ENQUIRY NOFILE
* Primary Purpose : Extrae detalles del Arrangement tipo Deposit
*--------------------------------------------------------------------------------------------
*  Modification Details:
* -----------------------------
* 03/12/2025 - Migracion
*              Se aplican ajustes por cambio de infraestructura.
*              Se optimiza rutina para R24
*-----------------------------------------------------------------------------
    $USING EB.API
    $USING AA.PaymentSchedule
    $USING AA.Framework
    $USING AbcSaldoOperPasivasAcc
    $USING EB.Reports
    $USING EB.Updates
    $USING EB.DataAccess
    $USING CG.ChargeConfig
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING AA.ProductManagement
    $USING ST.Config
    $USING AbcTable
    $USING AA.Interest
    $USING AA.Settlement
    $USING AA.TermAmount
    $USING AA.Officers
    $USING EB.AbcUtil
*-----------------------------------------------------------------------------
    GOSUB INICIALIZA
    GOSUB PROCESA
    Y.NOMBRE.RUTINA = "ABC.NOFILE.IMPRESION"
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.DATA.LOG)
RETURN
***********
INICIALIZA:
***********
    Y.DATA.LOG<-1> = "ABC.AA.INFORME.VENCIMIENTO"
    FN.AA.ARR.ACT = 'F.AA.ARRANGEMENT.ACTIVITY';F.AA.ARR.ACT = ''; EB.DataAccess.Opf(FN.AA.ARR.ACT,F.AA.ARR.ACT)
    FN.ACTI.HIS   = 'F.AA.ACTIVITY.HISTORY'    ; F.ACTI.HIS  = ''; EB.DataAccess.Opf(FN.ACTI.HIS,F.ACTI.HIS)
    FN.PARA.PROD  = 'F.ABC.PARAM.CONT.PROD'    ; F.PARA.PROD = ''; EB.DataAccess.Opf(FN.PARA.PROD,F.PARA.PROD)
    FN.DAO        = 'F.DEPT.ACCT.OFFICER'      ; F.DAO       = ''; EB.DataAccess.Opf(FN.DAO,F.DAO)
    FN.PRODUCTO   = 'F.AA.PRODUCT'             ; F.PRODUCTO  = ''; EB.DataAccess.Opf(FN.PRODUCTO,F.PRODUCTO)
    FN.CLIENTE    = 'F.CUSTOMER'               ; F.CLIENTE   = ''; EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)
    FN.CUENTA     = 'F.ACCOUNT'                ; F.CUENTA    = ''; EB.DataAccess.Opf(FN.CUENTA,F.CUENTA)
    FN.TAX        = 'F.TAX'                    ; F.TAX       = ''; EB.DataAccess.Opf(FN.TAX,F.TAX)
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'     ; F.AA.ARRANGEMENT = ''; EB.DataAccess.Opf(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    FN.ACTI.HIS.HIS   = 'F.AA.ACTIVITY.HISTORY.HIST'; F.ACTI.HIS.HIS = ''; EB.DataAccess.Opf(FN.ACTI.HIS.HIS,F.ACTI.HIS.HIS)
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'; F.ABC.ACCT.LCL.FLDS = ''; EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)

    ID.ARRANGEMENT = ''; POSITION = '';

    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()

    LOCATE "ID.ARRANGEMENT" IN SEL.FIELDS<1> SETTING POSITION THEN
        ID.ARRANGEMENT = SEL.VALUES<POSITION>
    END
    Y.DATA.LOG<-1> = ID.ARRANGEMENT
    R.DATA = ''
    YSEP = '*'
    Y.SEP = '|'
    
RETURN
********
PROCESA:
********
    
    IF ID.ARRANGEMENT NE '' THEN
        GOSUB EXTRAE.DETALLES.INV
        NOMBRE.CLIENTE = '';
        IF ID.CLIENTE NE '' THEN
            AbcSaldoOperPasivasAcc.AaCustomerImpresion(ID.CLIENTE,NOMBRE.CLIENTE)
        END
        GOSUB CALCULA.GAT
        GOSUB PROYECTA.SCHEDULE
        GOSUB ARMA.PRODUCTO
        GOSUB ARMA.ARREGLO
    END

RETURN
********************
EXTRAE.DETALLES.INV:
********************

    PRODUCTO.ID = ''; PROPERTY.LISTA = ''; REC.ARRANGEMENT = ''; PRODUCTO.NOMBRE = ''; ARR.STATUS = ''; ID.CLIENTE = ''; FECHA.INI.LD = '';
    TIPO.INVERSION = ''; ID.PARAM.PROD = ''
    IF ID.ARRANGEMENT NE '' THEN
        EB.DataAccess.FRead(FN.AA.ARRANGEMENT,ID.ARRANGEMENT,R.ARRANGEMENT,F.AA.ARRANGEMENT,ERROR.ARRANGEMENT)
        IF R.ARRANGEMENT THEN
            ARR.START.DATE = R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate>
            MONEDA = R.ARRANGEMENT<AA.Framework.Arrangement.ArrCurrency>
            IF MONEDA NE '' THEN
                IF MONEDA EQ 'MXN' THEN
                    MONEDA = 'PESOS'
                END
            END
            Y.DATA.LOG<-1> = "ARR.START.DATE=":ARR.START.DATE
            Y.DATA.LOG<-1> = "MONEDA=":MONEDA
        END
        AA.Framework.GetArrangementProduct(ID.ARRANGEMENT,effectiveDate,REC.ARRANGEMENT,PRODUCTO.ID,PROPERTY.LISTA)
        IF REC.ARRANGEMENT NE '' THEN
            ID.CLIENTE = REC.ARRANGEMENT<AA.Framework.Arrangement.ArrCustomer>      ;*<1> - Migracion
            Y.DATA.LOG<-1> = "ID.CLIENTE=":ID.CLIENTE
            ARR.STATUS = REC.ARRANGEMENT<AA.Framework.Arrangement.ArrArrStatus>     ;*<6> - Migracion
            Y.DATA.LOG<-1> = "ARR.STATUS=":ARR.STATUS
            FECHA.INI.LD = REC.ARRANGEMENT<AA.Framework.Arrangement.ArrOrigContractDate>
            Y.DATA.LOG<-1> = "FECHA.INI.LD=":FECHA.INI.LD
            Y.DATA.LOG<-1> = "PRODUCTO.ID=":PRODUCTO.ID
            IF PRODUCTO.ID NE '' THEN
                BEGIN CASE
                    CASE PRODUCTO.ID EQ 'DEPOSIT.PROMISSORY'
                        TIPO.INVERSION = '1'          ;*Pagare
                        ID.PARAM.PROD = '21004'
                    CASE PRODUCTO.ID EQ 'DEPOSIT.FIXED.INT'
                        TIPO.INVERSION = '2'          ;*Deposito de CD con Interes Fijo
                        ID.PARAM.PROD = '21003'
                    CASE PRODUCTO.ID EQ 'DEPOSIT.REVIEW.INT'
                        TIPO.INVERSION = '3'          ;*Deposito de CD con Int Revisable
                        ID.PARAM.PROD = '21005'
                    CASE PRODUCTO.ID EQ 'DEPOSIT.VAR.INT'
                        TIPO.INVERSION = '3'          ;*Depositos de CD con Tasas Variables
                        ID.PARAM.PROD = '21005'
                END CASE
                R.PRODUCTO = ''; ERROR.PRODUCTO = '';
                EB.DataAccess.FRead(FN.PRODUCTO,PRODUCTO.ID,R.PRODUCTO,F.PRODUCTO,ERROR.PRODUCTO)
                PRODUCTO.NOMBRE = R.PRODUCTO<AA.ProductManagement.Product.PdtDescription>
            END
        END

        SEL.ISR = ''; LISTA.ISR = ''; TOTAL.ISR = ''; ERROR.ISR = ''; TASA.ISR = '';
        SEL.ISR = 'SELECT ':FN.TAX:' WITH @ID LIKE "':SQUOTE('21'):'..." BY @ID'  ; * ITSS-TEJASHWINI - Added SQUOTE
        EB.DataAccess.Readlist(SEL.ISR,LISTA.ISR,'',TOTAL.ISR,ERROR.ISR)
        IF LISTA.ISR THEN
            ID.ISR = LISTA.ISR<TOTAL.ISR>
            R.TAX = ''; ER.ISR = '';
            EB.DataAccess.FRead(FN.TAX,ID.ISR,R.TAX,F.TAX,ER.ISR)
            IF R.TAX THEN
                TASA.ISR = R.TAX<CG.ChargeConfig.Tax.EbTaxBandedRate,1>     ;* - Migracion
                Y.DATA.LOG<-1> = "TASA.ISR=":TASA.ISR
            END
        END

        CALENDARIO.DECE = ''
        INT.RATE = ''; ID.LD = ''; CAPITAL.INI.AUX = ''; YPLAZO = ''; TASA.NETA = ''; ID.CUENTA = ''; MONTO.LETRA = '';
        MONTO.LETRA = ''; MONTO.CONVIERTE = ''; TASA.MARGIN = ''; TASA.BRUTA = '';
        PROP.CLASS = "ACCOUNT":@FM:"TERM.AMOUNT":@FM:"INTEREST":@FM:"SETTLEMENT"
        LOOP
            REMOVE CURR.PROP FROM PROP.CLASS SETTING PROP.POS
        WHILE CURR.PROP:PROP.POS
            idProperty = ''; returnIds = ''; returnConditions = ''; returnError = '';
            Y.DATA.LOG<-1> = "CURR.PROP=":CURR.PROP
            IF CURR.PROP EQ "INTEREST" AND TIPO.INVERSION EQ "3" THEN
                AA.Framework.GetArrangementConditions(ID.ARRANGEMENT,CURR.PROP,idProperty,ARR.START.DATE,returnIds,returnConditions,returnError)
            END ELSE
                AA.Framework.GetArrangementConditions(ID.ARRANGEMENT,CURR.PROP,idProperty,effectiveDate,returnIds,returnConditions,returnError)
            END
            IF returnConditions NE '' THEN
                returnConditions = RAISE(returnConditions)
                BEGIN CASE
                    CASE CURR.PROP EQ "TERM.AMOUNT"
                        CAPITAL.INI.AUX = returnConditions<AA.TermAmount.TermAmount.AmtAmount>      ;*<3> - Migracion
                        Y.DATA.LOG<-1> = "CAPITAL.INI.AUX=":CAPITAL.INI.AUX
                        YPLAZO = returnConditions<AA.TermAmount.TermAmount.AmtTerm>       ;*<5> - Migracion
                        IF YPLAZO NE '' THEN
                            YPLAZO = FIELD(YPLAZO,'D',1)
                            Y.DATA.LOG<-1> = "YPLAZO=":YPLAZO
                        END
*             Migracion.S - TIPO DE VALOR DEPRECADO
*                IF CURR.PROP EQ "ACCOUNT" THEN
*                    ID.LD = returnConditions<11,1>
*                    Y.DATA.LOG<-1> = "ID.LD=":ID.LD)
*                END
*             Migracion.E - TIPO DE VALOR DEPRECADO
                    CASE CURR.PROP EQ "INTEREST"
                        TASA.BRUTA = returnConditions<AA.Interest.Interest.IntEffectiveRate,1>       ;*<22> - Migracion
                        TASA.MARGIN = returnConditions<AA.Interest.Interest.IntMarginRate>      ;*<19> - Migracion
                        Y.DATA.LOG<-1> = "TASA.BRUTA=":TASA.BRUTA
                        Y.DATA.LOG<-1> = "TASA.MARGIN=":TASA.MARGIN
                    CASE CURR.PROP EQ "SETTLEMENT"
                        REC.CONDITION = returnConditions
                        ID.CUENTA = REC.CONDITION<AA.Settlement.Settlement.SetPayoutAccount>       ;*<23> - Migracion
                        Y.DATA.LOG<-1> = "ID.CUENTA=":ID.CUENTA
                END CASE
            END
        REPEAT

        R.CUENTA = ''; ER.CUENTA = ''; YEX.IMPUESTO = 'N'
        EB.DataAccess.FRead(FN.CUENTA,ID.CUENTA,R.CUENTA,F.CUENTA,ER.CUENTA)
        IF R.CUENTA THEN
            ACC.ID.FLDS = R.CUENTA<AC.AccountOpening.Account.ArrangementId>
            EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,ACC.ID.FLDS,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,Y.ABC.ACCT.LCL.FLDS.ERR)
            IF R.ABC.ACCT.LCL.FLDS THEN
                YEX.IMPUESTO = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.ExentoImpuesto>
            END
        END
        Y.DATA.LOG<-1> = "YEX.IMPUESTO=":YEX.IMPUESTO
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
        Y.DATA.LOG<-1> = "TIPO.INVERSION=":TIPO.INVERSION
        Y.DATA.LOG<-1> = "TASA.MARGIN=":TASA.MARGIN
        Y.DATA.LOG<-1> = "TASA.VARIABLE=":TASA.VARIABLE
        Y.DATA.LOG<-1> = "TASA.NETA=":TASA.NETA
        ID.INVERSION = ''
;* Migracion - S
        ID.INVERSION = ID.ARRANGEMENT
*        IF ID.LD EQ '' THEN
*            ID.INVERSION = ID.ARRANGEMENT
*        END ELSE
*            IF ID.LD[1,2] EQ 'LD' THEN
*                ID.INVERSION = ID.LD
*            END
*        END
;* Migracion - E
        PROCESS.TYPE = "INITIALISE"
        R.ACT.DET = ''
        FECHA.FIN.INV = ''
        FECHA.INI.INV = ''
        
        AA.PaymentSchedule.ProcessAccountDetails(ID.ARRANGEMENT,PROCESS.TYPE,'',R.ACT.DET,ERROR.ACT.DET)
        IF R.ACT.DET NE '' THEN
            FECHA.FIN.INV = R.ACT.DET<AA.PaymentSchedule.AccountDetails.AdMaturityDate>       ;*<6> - Migracion
            FECHA.INI.AA = R.ACT.DET<AA.PaymentSchedule.AccountDetails.AdValueDate>            ;*<2> - Migracion
            Y.DATA.LOG<-1> = "FECHA.FIN.INV=":FECHA.FIN.INV
            Y.DATA.LOG<-1> = "FECHA.INI.AA=":FECHA.INI.AA
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
            ID.DAO = R.OFFICER.COND<AA.Officers.Officers.OffPrimaryOfficer>     ;*<3> - Migracion
            ID.EJECITIVO = ID.DAO
            GOSUB LEE.DAO
            NOMBRE.EJECUTIVO     = NOMBRE.DAO
            ID.DAO               = R.OFFICER.COND<AA.Officers.Officers.OffPrimaryOfficer>[1,5]       ;*<3>[1,5] - Migracion
            ID.SUCURSAL.CLIENTE  = ID.DAO
            GOSUB LEE.DAO
            NOMBRE.SUCURSAL = NOMBRE.DAO
        END

        R.ACT.HIS = ''; ER.ACTI.HIS = '';
        LISTA.ACTIVITY = '';LISTA.REF.ACTI = ''; ID.ACT.REF = ''; ID.AAA = '';
        R.ARR.ACT = '';  ERR.ARR.ACT = ''; CAPITAL.INI = '';
;*MONEDA = ''; - Migracion
        DATE.TIME = '';CONPANIA = '';
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
            YPOS = '' ;* MONEDA = '' - Migracion
            DATE.TIME = ''; YFECHA = ''; YCONVIENTE = ''; FECHA.CONTRATO = '';
            YHORA = ''; HORA.CONTRATO = ''; FEC.HORA = ''; COMPANIA = ''; ID.AAA = '';
            FINDSTR 'DEPOSITS-NEW-ARRANGEMENT' IN LISTA.ACTIVITY SETTING YPOS THEN
                ID.AAA = LISTA.REF.ACTI<YPOS>
                GOSUB GET.HORA.CONTRATO
            END ELSE
                FINDSTR 'DEPOSITS-TAKEOVER-ARRANGEMENT' IN LISTA.ACTIVITY SETTING YPOS THEN
                    ID.AAA = LISTA.REF.ACTI<YPOS>
                    GOSUB GET.HORA.CONTRATO
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
                        GOSUB GET.HORA.CONTRATO
                        X = 5
                    END ELSE
                        FINDSTR 'DEPOSITS-TAKEOVER-ARRANGEMENT' IN LISTA.ACTIVITY SETTING YPOS THEN
                            ID.AAA = LISTA.REF.ACTI<YPOS>
                            GOSUB GET.HORA.CONTRATO
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
        Y.DATA.LOG<-1> = "MONTO.CONVIERTE=":MONTO.CONVIERTE
        EB.AbcUtil.numToText(MONTO.CONVIERTE)
        Y.DATA.LOG<-1> = "MONTO.CONVIERTE=":MONTO.CONVIERTE
        MONTO.LETRA = MONTO.CONVIERTE
		
        FINDSTR 'PESOS' IN MONTO.CONVIERTE SETTING Ap, Vp THEN
            MONTO.LETRA := ' MN'
        END ELSE
            MONTO.LETRA := ' PESOS 00/100 MN'
        END
    END

RETURN
**************
GET.HORA.CONTRATO:
**************
    
    IF ID.AAA NE '' THEN
        EB.DataAccess.FRead(FN.AA.ARR.ACT,ID.AAA,R.ARR.ACT,F.AA.ARR.ACT,ERR.ARR.ACT)
        IF R.ARR.ACT NE '' THEN
*            Migracion - S
            IF MONEDA ELSE
                MONEDA = R.ARR.ACT<AA.Framework.RrControl.ArrActCurrency>
                IF MONEDA EQ 'MXN' THEN
                    MONEDA = 'PESOS'
                END
            END
*            Migracion - E
            IF MONEDA NE '' THEN
                IF MONEDA EQ 'MXN' THEN
                    MONEDA = 'PESOS'
                END
            END
            DATE.TIME = R.ARR.ACT<AA.Framework.ArrangementActivity.ArrActDateTime>
            IF DATE.TIME NE '' THEN
                YFECHA  = DATE.TIME[1,6]
                FECHA.CONTRATO = YFECHA[5,2]:"/":YFECHA[3,2]:"/20":YFECHA[1,2]
                YHORA =  DATE.TIME[7,4]
                HORA.CONTRATO = YHORA[1,2]:':':YHORA[3,2]
                FEC.HORA = FECHA.CONTRATO:' ':HORA.CONTRATO
            END
            COMPANIA =  R.ARR.ACT<AA.Framework.ArrangementActivity.ArrActCoCode>
        END
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
            DIA.REQD = FECHA.INI.INV:@FM:FECHA.FIN.INV
        END
        YCONCEPTO = ''; INTERESES.NETOS = ''; CAPITAL.VENCIMIENTO = ''; CEDE.FIJO = ''; CEDE.REV.VAR = '';
        TOT.PAYMENT = ''; DUE.DATES = ''; DUE.TYPES = ''; DUE.METHODS = ''; DUE.TYPE.AMTS = ''; DUE.PROPS = ''; DUE.PROP.AMTS = ''; DUE.OUTS = '';
* Migracion - S
*        AA.PaymentSchedule.ScheduleProjector(ID.ARRANGEMENT,"","",CYCLE.DATE,TOT.PAYMENT,DUE.DATES,DUE.TYPES,DUE.METHODS,DUE.TYPE.AMTS,DUE.PROPS,DUE.PROP.AMTS,DUE.OUTS)
        ArrangementId = ID.ARRANGEMENT
        SimulationRef = ''; NoReset = '';
        DateRange = CYCLE.DATE
        TotPayment = ''; DueDates = ''; DueDeferDates = ''; DueTypes = ''; DueMethods = ''; DueTypeAmts = ''; DueProps = ''; DuePropAmts = ''; DueOuts = ''
        AA.PaymentSchedule.ScheduleProjector(ArrangementId, SimulationRef, NoReset, DateRange, TotPayment, DueDates, DueDeferDates, DueTypes, DueMethods, DueTypeAmts, DueProps, DuePropAmts, DueOuts)
        DUE.TYPES = DueTypes
        DUE.DATES = DueDates
* Migracion - E
        IF DUE.TYPES EQ '' AND DUE.DATES EQ '' THEN
* Migracion - S
*            CYCLE.DATE = FECHA.INI.INV:@FM:FECHA.FIN.INV
            DateRange = FECHA.INI.INV:@FM:FECHA.FIN.INV
            DIA.REQD = ''
*            AA.PaymentSchedule.ScheduleProjector(ID.ARRANGEMENT,"","",CYCLE.DATE,TOT.PAYMENT,DUE.DATES,DUE.TYPES,DUE.METHODS,DUE.TYPE.AMTS,DUE.PROPS,DUE.PROP.AMTS,DUE.OUTS)
            AA.PaymentSchedule.ScheduleProjector(ArrangementId, SimulationRef, NoReset, DateRange, TotPayment, DueDates, DueDeferDates, DueTypes, DueMethods, DueTypeAmts, DueProps, DuePropAmts, DueOuts)
        END
        DUE.DATES = DueDates
        DUE.TYPES = DueTypes
        DUE.TYPE.AMTS = DueTypeAmts
* Migracion - E
        
        BEGIN CASE
            CASE TIPO.INVERSION EQ '1'
                DUE.FECHA = ''; TOT.TIPOS = ''; DUE.MONTO = ''; YPAGARE = ''; DUE.TIPO = '';
*           IF TIPO.INVERSION EQ '1' THEN
                TOT.FECHA = DCOUNT(DUE.DATES,@FM)
                FOR I = 1 TO TOT.FECHA
                    DUE.FECHA = ''
                    DUE.FECHA = DUE.DATES<I>
                    TOT.TIPOS = ''
                    TOT.TIPOS = COUNT(DUE.TYPES<I>,@VM) + 1
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
*        END
            CASE TIPO.INVERSION EQ '2'
                TOT.DTES = ''; FECHA.INT = ''; TOT.TYPES = ''; TIPO.DUE = ''; DUE.MONTO = '';  CEDE.FIJO = '';
*           IF TIPO.INVERSION EQ '2' THEN

                TOT.DTES = DCOUNT(DUE.DATES,@FM)
                FOR I  = 1 TO TOT.DTES
                    FECHA.INT = ''
                    FECHA.INT = DUE.DATES<I>
                    TOT.TYPES = ''
                    TOT.TYPES = COUNT(DUE.TYPES<I>,@VM) + 1
                    FOR II = 1 TO TOT.TYPES
                        TIPO.DUE = ''
                        TIPO.DUE = DUE.TYPES<I,II>
                        DUE.MONTO = ''
                        FECHA.INT.1 = FECHA.INT
                        IF TIPO.DUE EQ 'INTEREST' THEN
                            DUE.MONTO = DUE.TYPE.AMTS<I,II>
                            CEDE.FIJO <-1>= FECHA.INT:'#':DUE.MONTO:'|'
                        END
                    NEXT II
                NEXT I
*        END
            CASE TIPO.INVERSION EQ '3'
                TOT.DTES = ''; FECHA.INT = ''; TOT.TYPES = ''; TIPO.DUE = ''; CEDE.REV.VAR = '';
*           IF TIPO.INVERSION EQ '3' THEN
                TOT.DTES = DCOUNT(DUE.DATES,@FM)       ;* Total Number of Schedule dates
                FOR I  = 1 TO TOT.DTES
                    FECHA.INT = ''
                    FECHA.INT = DUE.DATES<I>          ;* Pick each date
                    TOT.TYPES = ''
                    TOT.TYPES = COUNT(DUE.TYPES<I>,@VM) + 1
                    FOR II = 1 TO TOT.TYPES
                        TIPO.DUE = ''
                        TIPO.DUE = DUE.TYPES<I,II>
                        IF TIPO.DUE EQ 'INTEREST' THEN
                            CEDE.REV.VAR <-1>= FECHA.INT:'|'
                        END
                    NEXT II
                NEXT I
*        END
        END CASE
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
            NOM.COM      = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.NomComercial>)
            TIPO.OPER    = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.TipoOper>)
            MED.TARJETA  = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.MedTarjeta>)
            MED.CHQ      = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.MedChequera>)
            MED.BAN.INT  = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.MedInternet>)
            MED.CAJERO   = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.MedCajero>)
            MED.VENT     = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.MedVentanilla>)
            MED.AFIL     = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.MedComercio>)
            MED.COMI.BAN = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.MedDomicilia>)
            NOMBRE.UEAU  = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.UeauNombre>)
            DOMI.UEAU    = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.Domicilio>)
            TEL.UEAU     = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.Telefono>)
            CORREO.UEAU  = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.Correo>)
            PAG.UEAU     = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.PagWeb>)
            TEL.CONDU    = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.CdfTel>)
            PAG.CONDU    = TRIM(R.PARA.PROD<AbcTable.AbcParamContProd.CdfPagWeb>)
        END
    END

    SALIDA.PRODUCTO = ''
    SALIDA.PRODUCTO := NOM.COM:Y.SEP:TIPO.OPER:Y.SEP:TASA.BRUTA:Y.SEP:GAT.NOMINAL:Y.SEP:GAT.REAL:Y.SEP:MED.TARJETA:Y.SEP:MED.CHQ:Y.SEP:MED.BAN.INT:Y.SEP:MED.CAJERO:Y.SEP:MED.VENT:Y.SEP:MED.AFIL:Y.SEP:MED.COMI.BAN:Y.SEP
    SALIDA.PRODUCTO := NOMBRE.UEAU:Y.SEP:DOMI.UEAU:Y.SEP:TEL.UEAU:Y.SEP:CORREO.UEAU:Y.SEP:PAG.UEAU:Y.SEP:TEL.CONDU:Y.SEP:PAG.CONDU:Y.SEP:TIT.GARA
    Y.DATA.LOG<-1> = "SALIDA.PRODUCTO=":SALIDA.PRODUCTO
RETURN
*************
ARMA.ARREGLO:
*************

    CHANGE @FM TO '' IN CEDE.FIJO
    CHANGE @FM TO '' IN CEDE.REV.VAR
* Migracion - S
    IF FEC.HORA THEN
        INV.FECHA.INI = FEC.HORA
    END
    BEGIN CASE
        CASE TIPO.INVERSION EQ 1
*    IF TIPO.INVERSION EQ 1 THEN
* Migracion - E
*1
            R.DATA := TIPO.INVERSION      :YSEP
*2
            R.DATA := ID.CLIENTE          :YSEP
*3
            R.DATA := NOMBRE.CLIENTE      :YSEP
*4
            R.DATA := ID.SUCURSAL.CLIENTE :YSEP
*5
            R.DATA := NOMBRE.SUCURSAL     :YSEP
*6
            R.DATA := FEC.HORA            :YSEP
*7
            R.DATA := ID.CUENTA           :YSEP
*8
            R.DATA := ID.INVERSION        :YSEP
*9
            R.DATA := PLAZO               :YSEP
*10
            R.DATA := INV.FECHA.INI       :YSEP
*11
            R.DATA := INV.FECHA.FIN       :YSEP
*12
            R.DATA := MONEDA              :YSEP
*13
            R.DATA := TASA.BRUTA          :YSEP
*14
            R.DATA := TASA.ISR            :YSEP
*15
            R.DATA := TASA.NETA           :YSEP
*16
            R.DATA := GAT.NOMINAL         :YSEP
*17
            R.DATA := GAT.REAL            :YSEP
*18
            R.DATA := CAPITAL.INI         :YSEP
*19
            R.DATA := MONTO.LETRA         :YSEP
*19
            R.DATA := INTERESES.NETOS     :YSEP
*20
            R.DATA := CAPITAL.VENCIMIENTO :YSEP
*21
            R.DATA := CALENDARIO.DECE     :YSEP
*22
            R.DATA := SALIDA.PRODUCTO
            
* Migracion - S
*    END
        CASE TIPO.INVERSION EQ 2
*    IF TIPO.INVERSION EQ 2 THEN
* Migracion - E
*1
            R.DATA := TIPO.INVERSION      :YSEP
*2
            R.DATA := ID.CLIENTE          :YSEP
*3
            R.DATA := NOMBRE.CLIENTE      :YSEP
*4
            R.DATA := ID.SUCURSAL.CLIENTE :YSEP
*5
            R.DATA := NOMBRE.SUCURSAL     :YSEP
*6
            R.DATA := FEC.HORA            :YSEP
*7
            R.DATA := ID.CUENTA           :YSEP
*8
            R.DATA := ID.INVERSION        :YSEP
*9
            R.DATA := PLAZO               :YSEP
*10
            R.DATA := INV.FECHA.INI       :YSEP
*11
            R.DATA := INV.FECHA.FIN       :YSEP
*12
            R.DATA := MONEDA              :YSEP
*13
            R.DATA := TASA.BRUTA          :YSEP
*14
            R.DATA := TASA.ISR            :YSEP
*15
            R.DATA := TASA.NETA           :YSEP
*16
            R.DATA := GAT.NOMINAL         :YSEP
*17
            R.DATA := GAT.REAL            :YSEP
*18
            R.DATA := CAPITAL.INI         :YSEP
*19
            R.DATA := MONTO.LETRA         :YSEP
*20
            R.DATA := INTERESES.NETOS     :YSEP
*21
            R.DATA := CAPITAL.VENCIMIENTO :YSEP
*22
            R.DATA := CEDE.FIJO           :YSEP
*23
            R.DATA := SALIDA.PRODUCTO
* Migracion - S
*    END
        CASE TIPO.INVERSION EQ 3
*    IF TIPO.INVERSION EQ 3 THEN
* Migracion - E
*1
            R.DATA := TIPO.INVERSION      :YSEP
*2
            R.DATA := ID.CLIENTE          :YSEP
*3
            R.DATA := NOMBRE.CLIENTE      :YSEP
*4
            R.DATA := ID.SUCURSAL.CLIENTE :YSEP
*5
            R.DATA := NOMBRE.SUCURSAL     :YSEP
*6
            R.DATA := FEC.HORA            :YSEP
*7
            R.DATA := ID.CUENTA           :YSEP
*8
            R.DATA := ID.INVERSION        :YSEP
*9
            R.DATA := PLAZO               :YSEP
*10
            R.DATA := INV.FECHA.INI       :YSEP
*11
            R.DATA := INV.FECHA.FIN       :YSEP
*12
            R.DATA := MONEDA              :YSEP
*13
            R.DATA := TASA.VARIABLE       :YSEP
*14
            R.DATA := TASA.ISR            :YSEP
*15
            R.DATA := TASA.NETA           :YSEP
*16
            R.DATA := GAT.NOMINAL         :YSEP
*17
            R.DATA := GAT.REAL            :YSEP
*18
            R.DATA := CAPITAL.INI         :YSEP
*19
            R.DATA := MONTO.LETRA         :YSEP
*20
            R.DATA := INTERESES.NETOS     :YSEP
*21
            R.DATA := CAPITAL.VENCIMIENTO :YSEP
*22
            R.DATA := CEDE.REV.VAR        :YSEP
*23
            R.DATA := SALIDA.PRODUCTO
* Migracion - S
*    END
    END CASE
    Y.DATA.LOG<-1> = "R.DATA=":R.DATA
* Migracion - E
RETURN
********
LEE.DAO:
********

    ERROR.DAO  = ''
    R.INFO.DAO = ''
    NOMBRE.DAO = ''
    EB.DataAccess.FRead(FN.DAO,ID.DAO,R.INFO.DAO,F.DAO,ERROR.DAO)
    IF ERROR.DAO EQ '' THEN
        NOMBRE.DAO = TRIM(R.INFO.DAO<ST.Config.DeptAcctOfficer.EbDaoName>)
    END

RETURN
**********
END
