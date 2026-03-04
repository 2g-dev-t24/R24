* @ValidationCode : Mjo2OTk3ODU4OTE6Q3AxMjUyOjE3NzIwNDY4ODIwNzA6RWRnYXIgU2FuY2hlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Feb 2026 13:14:42
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
$PACKAGE AbcCob
SUBROUTINE ABC.AA.PRO.SERVICES(REC.ID)
*-----------------------------------------------------------------------------
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
*===============================================================================
* Fecha Modificacion :  20-05-2025  LFCR_20250214_Pagare_Futuro
* Desarrollador:        Luis Cruz - FyG Solutions
*                       Se agrega validaci�n sobre el campo EFFECTIVE.DATE de
*                       ABC.AA.PRE.PROCESS para tomar solo los registros con fecha
*                       igual a TODAY, los que tengan una fecha mayor se ignoran
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
    $USING EB.API
    $USING EB.Updates
    $USING AbcTable
    $USING EB.Service
    $USING EB.ErrorProcessing
    $USING EB.Foundation
    $USING EB.Interface
    $USING AA.Framework
    $USING AC.AccountOpening
    $USING AbcSpei
    $USING AbcBi
    $USING EB.Reports
    $USING EB.AbcUtil
*-----------------------------------------------------------------------------
    FN.PRE.PROCESS = AbcCob.getFnPreProcess()
    F.PRE.PROCESS  = AbcCob.getFPreProcess()
    
    FN.PRE.PROCESS.LIV = AbcCob.getFnPreProcessLiv()
    F.PRE.PROCESS.LIV = AbcCob.getFPreProcessLiv()
    
    FN.PRE.PROCESS.HIS = AbcCob.getFnPreProcessHis()
    F.PRE.PROCESS.HIS = AbcCob.getFPreProcessHis()
    
    FN.ACCOUNT = AbcCob.getFnAccountServices()
    F.ACCOUNT = AbcCob.getFAccountServices()

    FN.ABC.AA.CONCAT.PRE = AbcCob.getFnAbcAaConcatPre()
    F.ABC.AA.CONCAT.PRE = AbcCob.getFAbcAaConcatPre()
    
    YPOS.EXT.TRANS.ID = AbcCob.getYPosExtTransId()
    YPOS.CANAL.ENT = AbcCob.getYPosCanaEnt()

    FN.AA = AbcCob.getFnAa()
    F.AA = AbcCob.getFAa()
*-----------------------------------------------------------------------------
    Y.RUTA.INFORMES.APP      = AbcCob.getRutasInformesApp()
    Y.RUTA.INF.APP.RESP      = AbcCob.getRutaInfAppRest()
    Y.SEPARADOR.INFORME      = AbcCob.getSeparadorInforme()
    Y.MSJ.SUCCESS.INFORME    = AbcCob.getMsjSuccessInforme()
    Y.MSJ.ERROR.INFORME      = AbcCob.getMsjErrorInforme()
    Y.MSJ.SALDO.INSUFICIENTE = AbcCob.getMsjSaldoInsuficiente()
*-----------------------------------------------------------------------------
    EB.DataAccess.FReadu(FN.AA,REC.ID,AA.CON.REC,F.AA,AA.ERR,'')
    Y.SALDO.INSUFICIENTE = ''
    Y.ES.OPE.FUTURA = ''
    Y.DATA.LOG<-1> = "Processing ":REC.ID
    Y.TODAY   = EB.SystemTables.getToday()
*-----------------------------------------------------------------------------
    GOSUB PROCESS
*-----------------------------------------------------------------------------
    IF Y.ES.OPE.FUTURA EQ 1 THEN        ;*LFCR_20250214_Pagare_Futuro - S
        Y.DATA.LOG<-1> = REC.ID:"-ES.OPE.FUTURA=":Y.FECHA.INICIO.PAGA
        RETURN
    END   ;*LFCR_20250214_Pagare_Futuro -E
    
    IF AA.ARRANGEMENT.ID THEN
        Y.DATA.LOG<-1> = "Deleting end process ":REC.ID
        EB.DataAccess.FDelete(FN.AA,REC.ID)
    END ELSE
        EB.DataAccess.FRelease(FN.AA,REC.ID,F.AA)
        Y.DATA.LOG<-1> = "Not deleted Arrangement Error " : REC.ID
    END
    Y.NOMBRE.RUTINA = "ABC.AA.PRO.SERVICES"
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.DATA.LOG)
    GOSUB END.PRO

RETURN
*---------
PROCESS:
*---------

    PROCESS.VERSION = '';AA.ARRANGEMENT.ID='';
    PROCESS.VERSION = FIELD(AA.CON.REC,'-',4,1)
    
    R.PRE.PROCESS = '';
    EB.DataAccess.FReadu(FN.PRE.PROCESS,REC.ID,R.PRE.PROCESS,F.PRE.PROCESS,ERR,'')

    IF R.PRE.PROCESS EQ '' THEN
        EB.DataAccess.FRelease(FN.PRE.PROCESS,REC.ID,F.PRE.PROCESS)
        EB.DataAccess.FReadu(FN.PRE.PROCESS.LIV,REC.ID,R.PRE.PROCESS,F.PRE.PROCESS.LIV,ERR,'')
        IF R.PRE.PROCESS EQ '' THEN
            EB.DataAccess.FRelease(FN.PRE.PROCESS.LIV,REC.ID,F.PRE.PROCESS.LIV)
            EB.DataAccess.ReadHistoryRec(F.PRE.PROCESS.HIS,REC.ID, R.PRE.PROCESS, YERROR)
            REC.ID = FIELD(REC.ID,';',1,1)
        END
    END
    
    Y.FECHA.HOY = Y.TODAY       ;*LFCR_20250214_Pagare_Futuro-S
    Y.FECHA.INICIO.PAGA = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.EffectiveDate>
    
    IF Y.FECHA.INICIO.PAGA GT Y.FECHA.HOY THEN
        Y.ES.OPE.FUTURA = 1
        Y.DATA.LOG<-1> = REC.ID:"-ES.OPE.FUTURA=":Y.FECHA.INICIO.PAGA
        RETURN
    END   ;*LFCR_20250214_Pagare_Futuro-E

    yInput = FIELD(AA.CON.REC,'-',1,1)
    R.SIM.FLAG = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.SimFlag>
    Y.DATA.LOG<-1>  = "yInput Case -> " : yInput
    Y.DATA.LOG<-1> = "R.SIM.FLAG -> " : R.SIM.FLAG
    BEGIN CASE
              
        CASE FIELD(AA.CON.REC,'-',1,1) EQ 'I' AND R.PRE.PROCESS<AbcTable.AbcAaPreProcess.SimFlag> NE 'YES'
            FUNCT=FIELD(AA.CON.REC,'-',1,1)
            Y.DATA.LOG<-1> = " GOSUB INP.PROCESS "
            GOSUB INP.PROCESS
        CASE FIELD(AA.CON.REC,'-',1,1) EQ 'I' AND R.PRE.PROCESS<AbcTable.AbcAaPreProcess.SimFlag> EQ 'YES'
            FUNCT=FIELD(AA.CON.REC,'-',1,1)
            Y.DATA.LOG<-1> = "GOSUB SIM.INP.PROCESS "
            GOSUB SIM.INP.PROCESS
        CASE FIELD(AA.CON.REC,'-',1,1) EQ 'A'
            Y.DATA.LOG<-1> = "GOSUB AUTH.PROCESS"
            GOSUB AUTH.PROCESS
        CASE FIELD(AA.CON.REC,'-',1,1) EQ 'D'
            GOSUB AUTH.PROCESS
        CASE FIELD(AA.CON.REC,'-',1,1) EQ 'R'
            GOSUB AUTH.PROCESS
    END CASE

RETURN
*---------
REV.PROCESS:
*---------
RETURN
*---------
DEL.PROCESS:
*---------
RETURN
*---------
AUTH.PROCESS:
*---------

    Y.DATA.LOG<-1> = "AUTH.PROCESS"
    ARR.ACTIVITY.ID = '';

    OFS.RECORD = ''
    NO.OF.AUTH = "1"
    FUNCT=FIELD(AA.CON.REC,'-',1,1)
    Y.DATA.LOG<-1> = "PROCESS.VERSION -> " : PROCESS.VERSION
    IF PROCESS.VERSION EQ ',PRE.PROCESS' THEN
        APP.NAME ='ABC.AA.PRE.PROCESS'
        OFSVERSION = APP.NAME:","
        ARR.ACTIVITY.ID = REC.ID
    END ELSE
        GOSUB LIMPIA.VARS.CADENA
        AMT = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.Amount>
        ACC = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.AccountId>
        Y.EXT.TRANS.ID = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.LocalRef, YPOS.EXT.TRANS.ID>     ;* LFCR_20250214_InformePagareApp - S
        Y.CANAL.PAGARE = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.LocalRef, YPOS.CANAL.ENT>        ;* LFCR_20250214_InformePagareApp - S
        APP.NAME = "AA.ARRANGEMENT.ACTIVITY"
        OFSVERSION = APP.NAME:","
        ARR.ACTIVITY.ID = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.ActRefId>
        IF ARR.ACTIVITY.ID EQ '' THEN ARR.ACTIVITY.ID = FIELD(AA.CON.REC,'-',3,1)
        IF ARR.ACTIVITY.ID EQ '' THEN
            TEXT = " No Activity Reference id for this Investment " : REC.ID :' For Authoraization'
            Y.DATA.LOG<-1> = TEXT
*            EB.ErrorProcessing.FatalError(ABC.AA.PRO.SERVICES)
        END
    END

    AAA.REQUEST = '';

    EB.Foundation.OfsBuildRecord(APP.NAME, FUNCT, "PROCESS", OFSVERSION, "", NO.OF.AUTH, ARR.ACTIVITY.ID, AAA.REQUEST, OFS.RECORD)
    OFS.REQ = OFS.RECORD
    Y.DATA.LOG<-1> = "OFS.REQ -> " : OFS.REQ
    Y.DATA.LOG<-1> = "End OFS.REQ"

    theResponse = ""
    txnCommitted = ""
    options = ''
    options<1> = "AA.COB"
    EB.Interface.OfsCallBulkManager(options,OFS.REQ,theResponse,txnCommitted)
    
    RES = theResponse
    
    Y.DATA.LOG<-1> = "Response OFS" : RES
    Y.DATA.LOG<-1> = "End Response OFS"
    OFS.PROP = ''
* Migracion - S
    TEMP1 = FIELD (RES,'/',3)
    TEMP2 = FIELD (TEMP1,',',1)
    
    Y.DATA.LOG<-1> = "TEMP1 -> " : TEMP1
    Y.DATA.LOG<-1> = "TEMP2 -> " : TEMP2
* Migracion - E
    RESPONSE = FIELD(RES,',',2)
    AA.ARRANGEMENT.ID=FIELD (RESPONSE,'=',2,1)


    Y.OFS.ONE =FIELD (RESPONSE,',',1,1)
    Y.OFS.ONE =FIELD (Y.OFS.ONE,'/',3,1)
    Y.OFS.RESULT = TEMP2;*FIELD (RES<1>,'/',2,1) - Migracion
    Y.DATA.LOG<-1> = "AA.ARRANGEMENT.ID -> " : AA.ARRANGEMENT.ID
    Y.DATA.LOG<-1> = "Y.OFS.RESULT -> " : Y.OFS.RESULT
    IF Y.OFS.RESULT EQ 1 THEN
        Y.RESPUESTA.OFS = Y.MSJ.SUCCESS.INFORME
        Y.EXT.TRANS.ID = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.LocalRef, YPOS.EXT.TRANS.ID>
        Y.ID.CUSTOMER = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.CustomerId>
        Y.FECHA.CONTR = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.EffectiveDate>
        Y.ID.ABC.PRE.PROCESS = REC.ID
        Y.PLAZO = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.Term>
        Y.DATE.TIME = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.DateTime>
        Y.FECHA.FIN = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.MatDate>
        Y.CURRENCY.DESC = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.Currency>
        Y.TASA.INT = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.InterestRate>
        Y.ID.ARRANGEMENT = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.ArrangementId>
        GOSUB GET.DATA.ENQ.COMPROBANTE
    END ELSE
        Y.RESPUESTA.OFS = Y.MSJ.ERROR.INFORME
        Y.MSJ.ERROR = ""
        Y.DATA.LOG<-1> = "Y.RESPUESTA.OFS -> " : Y.RESPUESTA.OFS
    END
    Y.DATA.LOG<-1> = "Y.CANAL.PAGARE" : Y.CANAL.PAGARE
    IF Y.CANAL.PAGARE EQ 13 THEN
        Y.DATA.LOG<-1> = "Genera Cadena/Informe"
        GOSUB ARMA.CADENA.INFORME
        GOSUB GENERA.ARCHIVO.INFORME
    END
    Y.DATA.LOG<-1> = "End AUTH.PROCESS "
RETURN
*---------
SIM.INP.PROCESS:
*---------
    INT.RATE = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.InterestRate>        ;*<8>
    INT.RATE.VERSION = FIELD(AA.CON.REC,'-',4,1)
    AAA.REQUEST = '';

    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActArrangement> = "NEW"
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActActivity> = "DEPOSITS-NEW-ARRANGEMENT"
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActEffectiveDate> = R.PRE.PROCESS<3>
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActCustomer> = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.CustomerId>
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActProduct> = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.Product>
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActInitiationType,1> = "USER"
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActCurrency> = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.Currency>
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActAutoRun> = 'SIMULATE'
    AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActLocalRef,1> =R.PRE.PROCESS<AbcTable.AbcAaPreProcess.AccountId>

    AMT = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.Amount>
    TERM = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.MatDate>
    ACC = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.AccountId>
    INT.RATE = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.NewInterestRate>
    INT.RATE.VERSION = FIELD(AA.CON.REC,'-',4,1)
    GOSUB AMT.FORM
    GOSUB SET.ACC.FORM
    GOSUB SIM.BUILD.RECORD
    GOSUB UPDATE.OUT.AA.SIDE
RETURN
*---------
INP.PROCESS:
*---------
    INT.RATE = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.NewInterestRate>
    INT.RATE.VERSION = FIELD(AA.CON.REC,'-',4,1)
    AAA.REQUEST = '';
    Y.DATA.LOG<-1>  = "INT.RATE.VERSION -> " : INT.RATE.VERSION
    IF INT.RATE.VERSION NE ',AA' THEN
        Y.DATA.LOG<-1>  = "R.PRE.PROCESS -> " : R.PRE.PROCESS
        IF R.PRE.PROCESS<AbcTable.AbcAaPreProcess.ArrangementId> EQ '' THEN
            AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActArrangement> = "NEW"
            AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActActivity> = "DEPOSITS-NEW-ARRANGEMENT"
            AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActEffectiveDate> = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.EffectiveDate>
            AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActCustomer> = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.CustomerId>
            AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActProduct> = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.Product>
            AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActInitiationType,1> = "USER"
            AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActCurrency> = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.Currency>
            AAA.REQUEST<AA.Framework.ArrangementActivity.ArrActLocalRef,1> =R.PRE.PROCESS<AbcTable.AbcAaPreProcess.AccountId>

            GOSUB LIMPIA.VARS.CADENA    ;*LFCR_20250214_InformePagareApp - S - E
            AMT = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.Amount>
            TERM = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.MatDate>
            ACC = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.AccountId>
            INT.RATE = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.NewInterestRate>
            INT.RATE.VERSION = FIELD(AA.CON.REC,'-',4,1)
            Y.EXT.TRANS.ID = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.LocalRef, YPOS.EXT.TRANS.ID> ;*LFCR_20250214_InformePagareApp - S - E

            GOSUB AMT.FORM
            GOSUB SET.ACC.FORM
            Y.CAPITAL.VALUE = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.Capitalization>
            Y.DATA.LOG<-1> = "Y.CAPITAL.VALUE ->" : Y.CAPITAL.VALUE
            IF R.PRE.PROCESS<AbcTable.AbcAaPreProcess.Capitalization> EQ 'YES' THEN
                GOSUB SET.PAYMENT.SCHEDULE
            END
            GOSUB VALIDA.SALDO.CUENTA   ;*LFCR_20250214_InformePagareApp - S
            Y.DATA.LOG<-1> = "Y.SALDO.INSUFICIENTE -> ": Y.SALDO.INSUFICIENTE
            IF Y.SALDO.INSUFICIENTE EQ 1 THEN
                Y.RESPUESTA.OFS = Y.MSJ.ERROR.INFORME
                Y.MSG.ERROR = Y.MSJ.SALDO.INSUFICIENTE
                Y.DATA.LOG<-1> = "Y.POS.CANAL.ENTIDAD -> " : YPOS.CANAL.ENT
                Y.DATA.LOG<-1> = "Y.CANAL.PAGARE EQ 13 ->  ": Y.CANAL.PAGARE
                IF Y.CANAL.PAGARE EQ 13 THEN
                    GOSUB ARMA.CADENA.INFORME
                    GOSUB GENERA.ARCHIVO.INFORME
                    Y.DATA.LOG<-1> = "Deleting ":REC.ID
                    EB.DataAccess.FDelete(FN.AA,REC.ID)
                END
                Y.DATA.LOG<-1> = 'RETURN por CANAL.PAGARE NE 13 -> ' :Y.CANAL.PAGARE
                RETURN
            END ELSE          ;*LFCR_20250214_InformePagareApp - E
                Y.DATA.LOG<-1> = 'Entry case GEN.OFS'
                GOSUB BUILD.RECORD
                GOSUB GEN.OFS.MESSAGE
                GOSUB UPDATE.OUT.AA.SIDE
            END

        END ELSE
            YTEXT = ' Arrangement Record Already processed ' : R.PRE.PROCESS<AbcTable.AbcAaPreProcess.ArrangementId> : " Pre Process Id is " : REC.ID
            Y.DATA.LOG<-1> = "TEXT=":YTEXT
*            EB.ErrorProcessing.FatalError(ABC.AA.PRO.SERVICES)
        END
    END ELSE
*   This case will execute only for Interest rate chnage (adding Spread Manualyy)
        Y.DATA.LOG<-1> = "ELSE -> INT.RATE.VERSION NE ',AA' "
        ARR.ACTIVITY.ID = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.ActRefId>
        Y.DATA.LOG<-1> =  "ARR.ACTIVITY.ID ->" : ARR.ACTIVITY.ID
        GOSUB SET.INT.RATE
        GOSUB BUILD.RECORD
        GOSUB GEN.OFS.MESSAGE
    END
    Y.DATA.LOG<-1> = "End PROCESS"
RETURN
*---------
AMT.FORM:
*---------
    Y.DATA.LOG<-1> = 'AMT.FORM '
    OFS.AMT.PROP='';
    OFS.AMT.PROP = "PROPERTY:1=COMMITMENT,FIELD.NAME:1:1=AMOUNT,FIELD.VALUE:1:1=":AMT:",FIELD.NAME:1:2=MATURITY.DATE,FIELD.VALUE:1:2=":TERM:","

RETURN
*---------
SET.ACC.FORM:
*---------
    Y.DATA.LOG<-1> = 'SET.ACC.FORM'
    OFS.SET.PROP = '';
    OFS.SET.PROP = "PROPERTY:2=SETTLEMENT,FIELD.NAME:2:1=PAYIN.ACCOUNT,FIELD.VALUE:2:1=":ACC:",FIELD.NAME:2:2=PAYOUT.ACCOUNT,FIELD.VALUE:2:2=":ACC:","
RETURN
*---------
SET.PAYMENT.SCHEDULE:
*---------
    Y.DATA.LOG<-1> = 'SET.PAYMENT.SCHEDULE'
    OFS.PAY.SCH='';
    OFS.PAY.SCH ="PROPERTY:3=SCHEDULE,FIELD.NAME:3:1=PAYMENT.TYPE,FIELD.VALUE:3:1=INTEREST,FIELD.NAME:3:2=PAYMENT.METHOD,FIELD.VALUE:3:2=CAPITALISE,"
RETURN
*---------
SET.INT.RATE:
*---------
* Conditin added for both fixed & variable Rate & R.PRE.PROCESS<ABC.AA.CAPITALIZATION> eq yes then it will be vaiable rate product

    INT.SET.PROP = ''; OFS.PROP = '' ;OFS.SET.PROP = '';
    IF INT.RATE.VERSION EQ ',AA' AND R.PRE.PROCESS<AbcTable.AbcAaPreProcess.Capitalization> EQ 'YES' THEN
        INT.SET.PROP = "PROPERTY:4=DEPOSITINT,FIELD.NAME:4:1=MARGIN.TYPE,FIELD.VALUE:4:1:=SINGLE,"
        INT.SET.PROP:="FIELD.NAME:4:2=MARGIN.OPER,FIELD.VALUE:4:2=ADD,FIELD.NAME:4:3=MARGIN.RATE,FIELD.VALUE:4:3=":INT.RATE:","
    END ELSE
        INT.SET.PROP = "PROPERTY:3=DEPOSITINT,FIELD.NAME:3:1=MARGIN.TYPE,FIELD.VALUE:3:1:=SINGLE,"
        INT.SET.PROP:="FIELD.NAME:3:2=MARGIN.OPER,FIELD.VALUE:3:2=ADD,FIELD.NAME:3:3=MARGIN.RATE,FIELD.VALUE:3:3=":INT.RATE:","
    END

RETURN
*---------
SIM.BUILD.RECORD:
*---------
    APP.NAME = "AA.SIMULATION.CAPTURE"
    OFS.RECORD = ''
    OFSVERSION = APP.NAME:","
    NO.OF.AUTH = "0"
    EB.Foundation.OfsBuildRecord(APP.NAME, FUNCT, "PROCESS", OFSVERSION, "", NO.OF.AUTH, ARR.ACTIVITY.ID, AAA.REQUEST, OFS.RECORD)

    OFS.REQ = OFS.RECORD:OFS.PROP :OFS.SET.PROP : INT.SET.PROP : OFS.SET.PROP
    OFS.REQ = OFS.RECORD:OFS.AMT.PROP : OFS.SET.PROP : OFS.PAY.SCH: INT.SET.PROP

    theResponse = ""
    txnCommitted = ""
    options = ''
    options<1> = "AA.COB"
    options<4> = "HLD"
    EB.Interface.OfsCallBulkManager(options,OFS.REQ,theResponse,txnCommitted)
    RES = theResponse
    OFS.PROP = ''
    RESPONSE = FIELD(RES,',',2)
    AA.ARRANGEMENT.ID=FIELD (RESPONSE,'=',2,1)
RETURN

*---------
BUILD.RECORD:
*---------
    APP.NAME = "AA.ARRANGEMENT.ACTIVITY"
    OFS.RECORD = '';
    OFSVERSION = APP.NAME:","
    NO.OF.AUTH = "1"
    EB.Foundation.OfsBuildRecord(APP.NAME, FUNCT, "PROCESS", OFSVERSION, "", NO.OF.AUTH, ARR.ACTIVITY.ID, AAA.REQUEST, OFS.RECORD)
    OFS.REQ = OFS.RECORD:OFS.AMT.PROP:OFS.SET.PROP : OFS.PAY.SCH : INT.SET.PROP
    Y.DATA.LOG<-1> = "OFS Build -> ": OFS.REQ
RETURN

*---------
GEN.OFS.MESSAGE:
*---------
    Y.DATA.LOG<-1> = 'GEN.OFS.MESSAGE'
    theResponse = ""
    txnCommitted = ""
    options = ''
    options<1> = "AA.COB"
    options<4> = "HLD"
    Y.DATA.LOG<-1> = 'options OFS -> ' : options
    
    Y.DATA.LOG<-1> = 'GEN.OFS.MESSAGE  ' : OFS.REQ
    EB.Interface.OfsCallBulkManager(options,OFS.REQ,theResponse,txnCommitted)
    Y.DATA.LOG<-1> = 'theResponseOFS -> ': theResponse
    Y.DATA.LOG<-1> = "End theResponse"
    RES = theResponse
    TEMP1 = FIELD (RES,'/',3)
    TEMP2 = FIELD (TEMP1,',',1)
    OFS.PROP = ''
* Migracion - S
    Y.DATA.LOG<-1> = "TEMP1 -> " : TEMP1
    Y.DATA.LOG<-1> = "TEMP2 -> " : TEMP2
    IF TEMP2 EQ 1 THEN
        RESPONSE = FIELD(RES,',',2)
        AA.ARRANGEMENT.ID=FIELD (RESPONSE,'=',2,1)
        CRT "AA.ARRANGEMENT.ID=":AA.ARRANGEMENT.ID
        Y.DATA.LOG<-1> = "AA.ARRANGEMENT.ID -> ":AA.ARRANGEMENT.ID
    END ELSE
        ERROR.RESPONSE = FIELD (RESPONSE,'=',2,1)
        CRT "ERROR.RESPONSE =":ERROR.RESPONSE
        Y.DATA.LOG<-1>  = "ERROR.RESPONSE =":ERROR.RESPONSE
    END
    Y.DATA.LOG<-1> = "End GEN.OFS.MESSAGE "
* Migracion - E
RETURN
*---------
UPDATE.OUT.AA.SIDE:
*---------
    Y.DATA.LOG<-1> = "UPDATE.OUT.AA.SIDE"
    R.SIM.FLAG = R.PRE.PROCESS<AbcTable.AbcAaPreProcess.SimFlag>
    Y.DATA.LOG<-1> = "R.SIM.FLAG -> " : R.SIM.FLAG
    Y.DATA.LOG<-1> = "ID.ARRANGEMENT -> " : AA.ARRANGEMENT.ID
    IF AA.ARRANGEMENT.ID NE 'NEW' ELSE
        IF R.PRE.PROCESS<AbcTable.AbcAaPreProcess.SimFlag> NE 'YES' THEN
            EB.DataAccess.FRelease(FN.PRE.PROCESS,REC.ID,F.PRE.PROCESS)
        END ELSE
            EB.DataAccess.FRelease(FN.PRE.PROCESS.LIV,REC.ID,F.PRE.PROCESS.LIV)
        END
        Y.DATA.LOG<-1> = "Entry Case ID.ARRANGEMENT = " : AA.ARRANGEMENT.ID
        Y.DATA.LOG<-1> = "No se genera ARRANGEMENT.ID -> RETURN"
        RETURN
    END

    RRR = RES<1>
    Y.DATA.LOG<-1> = "RRR -> " : RRR
    RAW = FIELD(RRR,"/",1,1)
    Y.DATA.LOG<-1> = "RAW ->" : RAW
    RAW = FIELD(RAW,"<request>",2,1)
    Y.DATA.LOG<-1> = "RAW 2" : RAW
    RRR = FIELD(RRR,'/',3,1)
    Y.DATA.LOG<-1> = "RRR 2 -> " : RRR
    
    
   
    RRR = FIELD(RRR,'/',3,1)
    Y.DATA.LOG<-1> = "RRR 3 -> " : RRR
    R.PRE.PROCESS<AbcTable.AbcAaPreProcess.ArrangementId> = AA.ARRANGEMENT.ID
    R.PRE.PROCESS<AbcTable.AbcAaPreProcess.ActRefId> = RAW
    Y.DATA.LOG<-1> = "R.PRE.PROCESS -> " : R.PRE.PROCESS
    
    Y.DATA.LOG<-1> = "End R.PRE.PROCESS "
    
    IF R.PRE.PROCESS<AbcTable.AbcAaPreProcess.SimFlag> NE 'YES' THEN
        EB.DataAccess.FWrite(FN.PRE.PROCESS,REC.ID,R.PRE.PROCESS)
        Y.DATA.LOG<-1> = "R.SIM.FLAG NE YES"
    END ELSE
        Y.DATA.LOG<-1> = "R.SIM.FLAG EQ YES"
        EB.DataAccess.FWrite(FN.PRE.PROCESS.LIV,REC.ID,R.PRE.PROCESS)
    END
    Y.DATA.LOG<-1> = "End UPDATE.OUT.AA.SIDE"
RETURN
*----------------------------------------------------------------------------- ;*LFCR_20250214_InformePagareApp - S
VALIDA.SALDO.CUENTA:
*-----------------------------------------------------------------------------

    Y.DATA.LOG<-1> = 'VALIDA.SALDO.CUENTA'
    Y.AMT.PAGARE = AMT
    Y.ACCOUNT = ACC
    EB.DataAccess.FRead(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,Y.FERROR)

    Y.AVAIL.BAL = R.ACCOUNT<AC.AccountOpening.Account.WorkingBalance>

    IF Y.AVAIL.BAL LE 0 THEN
        Y.SALDO.INSUFICIENTE = 1
        RETURN
    END

    AbcSpei.AbcMontoBloqueado(Y.ACCOUNT, YACCT.LOCKED.AMT,Y.TODAY)
    Y.AVAIL.BAL = Y.AVAIL.BAL - YACCT.LOCKED.AMT

    IF Y.AVAIL.BAL LT Y.AMT.PAGARE THEN
        Y.SALDO.INSUFICIENTE = 1
        RETURN
    END

RETURN
*-----------------------------------------------------------------------------
GET.DATA.ENQ.COMPROBANTE:
*-----------------------------------------------------------------------------
    Y.DATA.LOG<-1> = "GET.DATA.ENQ.COMPROBANTE"
    YSEP = '*'
* Migracion - S
    EB.Reports.setDRangeAndValue(Y.ID.ARRANGEMENT)
    EB.Reports.setDFields('ID.ARRANGEMENT')
    EB.Reports.setLogicalOperands(1)
* Migracion - E
    AbcBi.AbcNofileImpresion(R.DATA)
    IF R.DATA NE '' THEN
        Y.ID.CLIENTE = FIELD(R.DATA,YSEP,2)
        Y.ID.ARRANGEMENT = FIELD(R.DATA,YSEP,8)
        Y.PLAZO = FIELD(R.DATA,YSEP,9)
        Y.FECHA.INICIO = FIELD(R.DATA,YSEP,10)
        Y.FECHA.FIN = FIELD(R.DATA,YSEP,11)
        Y.MONEDA = FIELD(R.DATA,YSEP,12)
        Y.TASA.BRUTA = FIELD(R.DATA,YSEP,13)
        Y.PORC.ISR = FIELD(R.DATA,YSEP,14)
        Y.PORC.NETO = FIELD(R.DATA,YSEP,15)
        Y.GANANCIA.ANUAL = FIELD(R.DATA,YSEP,16)
        Y.GANACIA.REAL = FIELD(R.DATA,YSEP,17)
        Y.MONTO.INICIAL = FIELD(R.DATA,YSEP,18)
        Y.INTERES.TOTAL = FIELD(R.DATA,YSEP,20)
        Y.MONTO.VENCIMIENTO = FIELD(R.DATA,YSEP,21)
* Migracion - S
        Y.DATA.LOG<-1> = "Y.ID.CLIENTE=":Y.ID.CLIENTE
        Y.DATA.LOG<-1> = "Y.ID.ARRANGEMENT=":Y.ID.ARRANGEMENT
        Y.DATA.LOG<-1> = "Y.PLAZO=":Y.PLAZO
        Y.DATA.LOG<-1> = "Y.FECHA.INICIO=":Y.FECHA.INICIO
        Y.DATA.LOG<-1> = "Y.FECHA.FIN=":Y.FECHA.FIN
        Y.DATA.LOG<-1> = "Y.MONEDA=":Y.MONEDA
        Y.DATA.LOG<-1> = "Y.TASA.BRUTA=":Y.TASA.BRUTA
        Y.DATA.LOG<-1> = "Y.PORC.ISR=":Y.PORC.ISR
        Y.DATA.LOG<-1> = "Y.PORC.NETO=":Y.PORC.NETO
        Y.DATA.LOG<-1> = "Y.GANANCIA.ANUAL=":Y.GANANCIA.ANUAL
        Y.DATA.LOG<-1> = "Y.GANACIA.REAL=":Y.GANACIA.REAL
        Y.DATA.LOG<-1> = "Y.MONTO.INICIAL=":Y.MONTO.INICIAL
        Y.DATA.LOG<-1> = "Y.INTERES.TOTAL=":Y.INTERES.TOTAL
        Y.DATA.LOG<-1> = "Y.MONTO.VENCIMIENTO=":Y.MONTO.VENCIMIENTO
* Migracion - E
    END

RETURN
*-----------------------------------------------------------------------------
LIMPIA.VARS.CADENA:
*-----------------------------------------------------------------------------
    Y.DATA.LOG<-1> = 'Limpio variables cadena'
    Y.RESPUESTA.OFS = '' ; Y.EXT.TRANS.ID = '' ; Y.ID.CUSTOMER = '' ; Y.ID.ABC.PRE.PROCESS = ''
    Y.PLAZO = '' ; Y.DATE.TIME = '' ; Y.FECHA.FIN = '' ; Y.CURRENCY.DESC = ''
    Y.TASA.INT = '' ; Y.PORC.ISR = '' ; Y.PORC.NETO = '' ; Y.GANANCIA.ANUAL = ''
    Y.GANACIA.REAL = '' ; Y.MONTO.INICIAL = '' ; Y.INTERES.TOTAL = '' ; Y.MONTO.VENCIMIENTO = ''

RETURN
*-----------------------------------------------------------------------------
ARMA.CADENA.INFORME:
*-----------------------------------------------------------------------------

    Y.CADENA.SALIDA = ''
    BEGIN CASE
        CASE Y.RESPUESTA.OFS EQ Y.MSJ.ERROR.INFORME
            Y.CADENA.SALIDA  = Y.RESPUESTA.OFS : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.EXT.TRANS.ID : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.MSG.ERROR

        CASE Y.RESPUESTA.OFS EQ Y.MSJ.SUCCESS.INFORME
            Y.CADENA.SALIDA  = Y.RESPUESTA.OFS : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.EXT.TRANS.ID : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.ID.CUSTOMER : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.ID.ARRANGEMENT : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.PLAZO : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.DATE.TIME : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.FECHA.FIN : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.CURRENCY.DESC : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.TASA.BRUTA : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.PORC.ISR : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.PORC.NETO : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.GANANCIA.ANUAL : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.GANACIA.REAL : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.MONTO.INICIAL : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.INTERES.TOTAL : Y.SEPARADOR.INFORME
            Y.CADENA.SALIDA := Y.MONTO.VENCIMIENTO

    END CASE

RETURN
*-----------------------------------------------------------------------------
GENERA.ARCHIVO.INFORME:
*-----------------------------------------------------------------------------
    Y.DATA.LOG<-1> = "GENERA.ARCHIVO.INFORME"
    NOMBRE.ARCHIVO = REC.ID
    Y.RUTA.INFORMES.APP = Y.RUTA.INFORMES.APP:'/'
    OPENSEQ Y.RUTA.INFORMES.APP,NOMBRE.ARCHIVO TO FILE.VAR1 THEN
        EXECUTE "rm " : Y.RUTA.INFORMES.APP:NOMBRE.ARCHIVO        CAPTURING Y.RESPONSE.RM
    END
    Y.DATA.LOG<-1> =  "Y.RESPONSE.RM -> " : Y.RESPONSE.RM
    OPENSEQ Y.RUTA.INFORMES.APP,NOMBRE.ARCHIVO TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
            MENS.ERROR = "No se pudo crear en ruta ":Y.RUTA.INFORMES.APP
            DISPLAY MENS.ERROR
            Y.DATA.LOG<-1> = MENS.ERROR
            FILE.VAR1 = ''
            RUTA.INF.APP.RESP = RUTA.INF.APP.RESP:'/'
            OPENSEQ Y.RUTA.INF.APP.RESP,NOMBRE.ARCHIVO TO FILE.VAR1 ELSE
                CREATE FILE.VAR1 ELSE
                    MENS.ERROR = "No se pudo crear en ruta de respaldo ":NOMBRE.ARCHIVO
                    DISPLAY MENS.ERROR
                    Y.DATA.LOG<-1> = MENS.ERROR
                END
            END
        END
    END

    WRITESEQ Y.CADENA.SALIDA APPEND TO FILE.VAR1 ELSE
        DISPLAY "No se pudo escribir en: " : FILE.VAR1
        Y.DATA.LOG<-1> = "No se pudo escribir en: " : FILE.VAR1
    END
    CLOSESEQ FILE.VAR1      ;** Migracion
    Y.DATA.LOG<-1> = "End GENERA.ARCHIVO.INFORME"
RETURN

*----------------
END.PRO:
*----------------
RETURN
END