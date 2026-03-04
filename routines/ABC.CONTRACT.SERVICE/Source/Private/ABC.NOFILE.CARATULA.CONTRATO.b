* @ValidationCode : MjotMTA1NjQzNDE4OkNwMTI1MjoxNzY0NjM0NDYyODI0OlVzdWFyaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 01 Dec 2025 18:14:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usuario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*===============================================================================
$PACKAGE AbcContractService
SUBROUTINE ABC.NOFILE.CARATULA.CONTRATO(R.DATA)
*===============================================================================
* Desarrollador:        FyG Solutions - LUIS CRUZ
* Compania:             ABC Capital
* Fecha:                2024-02-26
* Descripci�n:          Rutina nofile para generacion automatica de Caratula de Contratos
*===============================================================================
* Fecha Modificacion : LFCR_20240425_TASA_GAT
* Modificaciones     : Se modifica rutina para cambiar seleccion de tasa en GROUP.CREDIT.INT
*                      por el primer multivalor para categories dentro de parametro: CATEGORIES_REMUNERADA
*======================================================================================
* Subroutine Type : NOFILE RTN
* Attached to : ENQUIRY>ENQ.NOFILE.REP.CONT.CAR
*               STANDARD.SELECTION>NOFILE.CONTRATO.CARATU
*               RUTINA NOFILE>ABC.NOFILE.CARATULA.CONTRATO
* Attached as : NOFILE RTN
* Primary Purpose : Rutina nofile de generacion de caratulas garantizada
*-----------------------------------------------------------------------
* Luis Cruz
* 27-11-2025
* Revision de rutina componentizada por 2G
*-----------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.Reports
    $USING EB.LocalReferences
    $USING EB.SystemTables
    $USING AbcGetGeneralParam
    $USING AbcContractService
    $USING AbcTable
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING ST.Config
    $USING IC.Config
    $USING AA.Framework
    $USING AA.Interest
    $USING AA.Account
    $USING EB.Updates

    GOSUB INICIALIZA
    GOSUB LEE.LOCAL.REF
    GOSUB LEE.CUENTA
    GOSUB OBTIENE.PARAM.REPORTES
    GOSUB GENERA.XML
    GOSUB GUARDA.XML
    GOSUB CREA.REPORTE
    GOSUB BORRA.XML

RETURN

***********
INICIALIZA:
***********

    FN.CUENTA.NAU= 'F.ACCOUNT$NAU'                         ; F.CUENTA.NAU= ''             ; EB.DataAccess.Opf(FN.CUENTA.NAU,F.CUENTA.NAU)
    FN.CUENTA    = 'F.ACCOUNT'                             ; F.CUENTA    = ''             ; EB.DataAccess.Opf(FN.CUENTA,F.CUENTA)
    FN.CLIENTE   = 'F.CUSTOMER'                            ; F.CLIENTE   = ''             ; EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)
    FN.CATEGORY  = 'F.CATEGORY'                            ; F.CATEGORY  = ''             ; EB.DataAccess.Opf(FN.CATEGORY,F.CATEGORY)
    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'             ; F.GROUP.CREDIT.INT = ''      ; EB.DataAccess.Opf(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'; F.ABC.ACCT.LCL.FLDS = '' ; EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS, F.ABC.ACCT.LCL.FLDS)
    
    D.FIELDS = EB.Reports.getDFields()
    D.RANGE.AND.VALUE = EB.Reports.getDRangeAndValue()

    LOCATE "ID.CUENTA" IN D.FIELDS<1> SETTING POSITION THEN
        ID.CUENTA = D.RANGE.AND.VALUE<POSITION>
        ID.CUENTA = TRIM(ID.CUENTA)
        CHANGE "'" TO "" IN ID.CUENTA
        ID.CUENTA = FMT(ID.CUENTA,"11'0'R")
    END

    YSEP.1 = '|'
    Y.AMP   = '&'

    Y.LIST.PARS.CARAT = '' ; Y.LIST.VALS.CARAT = ''
    Y.ID.PAR.CARAT = 'ABC.CATS.NIVEL.CARATULA'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PAR.CARAT, Y.LIST.PARS.CARAT, Y.LIST.VALS.CARAT)
    Y.CATS.CTAS.CAR = '' ; Y.NIVEL.CTAS.CAR = ''

    LOCATE "CATEGS_CARATULA" IN Y.LIST.PARS.CARAT SETTING POS THEN
        Y.CATS.CTAS.CAR = Y.LIST.VALS.CARAT<POS>
        CHANGE "|" TO @VM IN Y.CATS.CTAS.CAR
    END

    LOCATE "NIVELES_CARATULA" IN Y.LIST.PARS.CARAT SETTING POS THEN
        Y.NIVEL.CTAS.CAR = Y.LIST.VALS.CARAT<POS>
        CHANGE "|" TO @VM IN Y.NIVEL.CTAS.CAR
    END
    
    Y.LIST.PARAM.CONDI = '' ; Y.LIST.VALUES.CONDI = ''
    Y.VALS.N2 = '' ; Y.VALS.N4L = ''
    Y.NIVELES.UALA = '' ; Y.CATEGS.UALA = '' ; Y.CANALES.UALA = ''
    Y.CATEGS.REMUN = '' ; Y.NIVELES.NAU = '' ; Y.CATS.NAU = ''
    Y.ID.PARM.CONDICIONES = 'ABC.CONDICIONES.CONTRATOS.PARAM'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARM.CONDICIONES, Y.LIST.PARAM.CONDI, Y.LIST.VALUES.CONDI)
    
    LOCATE "VALORES_NIVEL.2" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.VALS.N2 = Y.LIST.VALUES.CONDI<POS>
        Y.NIVS.N2 = FIELD(Y.VALS.N2, '|', 1)
        Y.CATS.N2 = FIELD(Y.VALS.N2, '|', 2)
        CHANGE ',' TO @VM IN Y.NIVS.N2
        CHANGE ',' TO @VM IN Y.CATS.N2
    END

    LOCATE "VALORES_NIVEL.4" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.VALS.N4L = Y.LIST.VALUES.CONDI<POS>
        Y.NIVS.N4 = FIELD(Y.VALS.N4L, '|', 1)
        Y.CATS.N4 = FIELD(Y.VALS.N4L, '|', 2)
        CHANGE ',' TO @VM IN Y.NIVS.N4
        CHANGE ',' TO @VM IN Y.CATS.N4
    END

    LOCATE "CATEGORIES_UALA" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.CATEGS.UALA = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.CATEGS.UALA
    END

    LOCATE "CANALES_UALA" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.CANALES.UALA = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.CANALES.UALA
    END

    LOCATE "CATEGORIES_REMUNERADA" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.CATEGS.REMUN = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.CATEGS.REMUN
    END

    LOCATE "NIVELES_GEN_CONT_NAU" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.NIVELES.NAU = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.NIVELES.NAU
    END

    LOCATE "CATEGORIES_GEN_CONT_NAU" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.CATS.NAU = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.CATS.NAU
    END
    
    LOCATE "CATEGORIES_UALA_N2" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.CATEGS.UALA.N2 = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.CATEGS.UALA.N2
    END
    
    LOCATE "CATEGORIES_UALA_N4" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.CATEGS.UALA.N4 = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.CATEGS.UALA.N4
    END

RETURN

***********
LEE.CUENTA:
***********

    TIPO.PRODUCTO = ""  ; TIPO.SERVICIO = ""       ; ID.CLIENTE = "" ; REGIMEN.CTA = ""
    CATEGORIA.CTA = ""  ; NOMB.CAT.CTA = "" ; NIVEL = ""IVA.G = ""
    Y.CANAL.CTA = ""

    IF ID.CUENTA THEN
        
        R.INFO.CUENTA = AC.AccountOpening.Account.Read(ID.CUENTA, ERROR.CUENTA)
        IF R.INFO.CUENTA EQ "" THEN
            EB.DataAccess.FRead(FN.CUENTA.NAU, ID.CUENTA, R.INFO.CUENTA, F.CUENTA.NAU, ERR.CTA.NAU)
        END
        IF R.INFO.CUENTA EQ "" THEN
            Y.STATUS = "La cuenta ingresada no existe."
            R.DATA=  YSEP.1:YSEP.1:Y.STATUS
            GOTO FIN
        END ELSE
            GOSUB OBTEN.INFO.CUENTA
        END
    END

RETURN

***********
OBTEN.INFO.CUENTA:
***********
    
    Y.NOMBRE.RUTINA = "ABC.NOFILE.CARATULA.CONTRATO"
    Y.CADENA.LOG<-1> =  "***OBTEN.INFO.CUENTA***"
    
    IF R.INFO.CUENTA THEN
        ID.CLIENTE = R.INFO.CUENTA<AC.AccountOpening.Account.Customer>
        IF ID.CLIENTE THEN
            GOSUB LEE.CLIENTE
        END
        ID.ARRANGEMENT = R.INFO.CUENTA<AC.AccountOpening.Account.ArrangementId>
        EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS, ID.ARRANGEMENT, R.INFO.CUENTA.LT, F.ABC.ACCT.LCL.FLDS, ERR.ACLT)
        Y.ACC.TITLE          = R.INFO.CUENTA<AC.AccountOpening.Account.AccountTitleOne>
        NIVEL                = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.Nivel>
        CATEGORIA.CTA        = R.INFO.CUENTA<AC.AccountOpening.Account.Category>
        Y.CATEGORIA.CTA.CREA.REP = CATEGORIA.CTA
        FECHA.APERTURA       = R.INFO.CUENTA<AC.AccountOpening.Account.OpeningDate>
        
        Y.CADENA.LOG<-1> =  "CATEGORIA.CTA->" : CATEGORIA.CTA
        Y.CADENA.LOG<-1> =  "Y.CATEGORIA.CTA.CREA.REP->" : Y.CATEGORIA.CTA.CREA.REP
        Y.CADENA.LOG<-1> =  "Y.ACC.TITLE->" : Y.ACC.TITLE
;*Y.CANAL.CTA          = R.INFO.CUENTA<AC.AccountOpening.Account.LocalRef, Y.POS.CANAL.ACC>
        CORREO.CLIENTE = R.INFO.CLIENTE<ST.Customer.Customer.EbCusEmailOne,1>
        NAME.PROD.COMECIAL = ''
        
        GOSUB OBTIENE.PARAM.RECA

        IF NOT(CATEGORIA.CTA MATCHES Y.CATEGS.REMUN) THEN
            BAND.PRINT.GAT = "NO"
            IVA.G = "0.0"
            GAT.NOM = "0.0"
            GAT.R = "0.0"
        END

        IF CATEGORIA.CTA MATCHES Y.CATEGS.REMUN THEN
            LOCATE "DIAS_" : CATEGORIA.CTA IN Y.LIST.PARAM.CONDI SETTING POS THEN
                Y.DIAS = Y.LIST.VALUES.CONDI<POS>
            END
            BAND.PRINT.GAT = "SI"
            GRUPO.COND           = R.INFO.CUENTA<AC.AccountOpening.Account.ConditionGroup>
            GOSUB LEE.IVA
            IVA.DIAS = '364'
            IVA.G = IVA.GRUPO
            Y.FECHA = FECHA.APERTURA
            FECHA.ACT = Y.FECHA[0,6]
            Y.TIPO = 1
            AbcContractService.AbcNewGetGat(FECHA.ACT,IVA.G,Y.DIAS,Y.TIPO,GAT.NOMINAL,GAT.REAL)

            GAT.NOM = GAT.NOMINAL
            GAT.R = GAT.REAL
            IVA.G = FMT(IVA.G, "R1")
        END

        EB.DataAccess.FRead(FN.CATEGORY,CATEGORIA.CTA,R.INFO.CAT.CTA,F.CATEGORY,ERROR.CAT.CTA)
        IF R.INFO.CAT.CTA THEN
            NOMB.CAT.CTA = R.INFO.CAT.CTA<ST.Config.Category.EbCatDescription>
            Y.NO.VAL.NOMB.CAT.CTA = DCOUNT(NOMB.CAT.CTA,@VM)
            NOMB.CAT.CTA = NOMB.CAT.CTA<1,Y.NO.VAL.NOMB.CAT.CTA>
        END
    END
RETURN
************
LEE.CLIENTE:
************
    
    TIPO.FORMATO = "" ; APELLIDO.P = "" ; APELLIDO.M = "" ; NOMBRE.1 = "" ; NOMBRE.CLIENTE = ""
    
    Y.CADENA.LOG<-1> =  "***LEE.CLIENTE***"
        
    IF ID.CLIENTE THEN
        
        EB.DataAccess.FRead(FN.CLIENTE,ID.CLIENTE,R.INFO.CLIENTE,F.CLIENTE,ERROR.CLIENTE)
        IF R.INFO.CLIENTE THEN
            CLASSIFICATION = R.INFO.CLIENTE<ST.Customer.Customer.EbCusSector>
            DOMI.EMPRESA   = ""
            RAZON.SOCIAL   = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.NOM.PER.MORAL>
            GARAN.IPAB      = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.TIP.IPAB.GARAN>
            Y.CADENA.LOG<-1> =  "RAZON.SOCIAL->" : RAZON.SOCIAL
            Y.CADENA.LOG<-1> =  "GARAN.IPAB->" : GARAN.IPAB
            IF GARAN.IPAB NE 'SI' THEN
                GARAN.IPAB = 0
            END

            IF RAZON.SOCIAL EQ '' THEN
                RAZON.SOCIAL   = R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameOne>
            END
            Y.CADENA.LOG<-1> =  "RAZON.SOCIAL->" : RAZON.SOCIAL
            IF Y.ACC.TITLE NE '' THEN
                RAZON.SOCIAL = Y.ACC.TITLE
            END
            
            IF CLASSIFICATION LT 2001 THEN
                IF CLASSIFICATION EQ 1001 THEN TIPO.FORMATO = '1' ELSE TIPO.FORMATO = '2'
                APELLIDO.P     = R.INFO.CLIENTE<ST.Customer.Customer.EbCusShortName>
                IF APELLIDO.P EQ 'XXX'THEN APELLIDO.P = ''
                APELLIDO.M     = R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameOne>
                IF APELLIDO.M EQ 'XXX' THEN APELLIDO.M = ''
                NOMBRE.1       = R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameTwo>
                NOMBRE.CLIENTE = TRIM(NOMBRE.1:' ':APELLIDO.P:' ':APELLIDO.M)
                CHANGE "," TO "" IN NOMBRE.CLIENTE
            END ELSE
                IF CLASSIFICATION GE 2014 THEN
                    TIPO.FORMATO       = '3'
                    NOMBRE.CLIENTE     = TRIM(R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameOne>)
                END
            END
        END
    END

RETURN
***********
LEE.IVA:
***********
    
    ARR.ID = R.INFO.CUENTA<AC.AccountOpening.Account.ArrangementId>
    Y.TODAY = EB.SystemTables.getToday()
    EFF.DATE = Y.TODAY
    EFF.RATE=''
    IntCondition= ''
    Y.CADENA.LOG<-1> =  "***LEE.IVA***"
    Y.CADENA.LOG<-1> =  "Y.TODAY->" : Y.TODAY
    Y.CADENA.LOG<-1> =  "EFF.DATE->" : EFF.DATE
            
    AA.Framework.GetArrangementConditions(ARR.ID, 'INTEREST', '', EFF.DATE, r.int.Ids, IntCondition, r.Error)
    IntCondition = RAISE(IntCondition)
    EFF.RATE   = IntCondition<AA.Interest.Interest.IntEffectiveRate> ;*<AA.INT.EFFECTIVE.RATE>
    EFF.RATE   = EFF.RATE<1,1>
    
    IVA.GRUPO = EFF.RATE
    
    MNT.IVA.GRUPO = IVA.GRUPO
    Y.CADENA.LOG<-1> =  "IVA.GRUPO->" : IVA.GRUPO
    Y.CADENA.LOG<-1> =  "MNT.IVA.GRUPO->" : MNT.IVA.GRUPO
    
*    Y.SELECT = "SELECT ": FN.GROUP.CREDIT.INT : " WITH @ID LIKE ": GRUPO.COND : "MXN... BY-DSND @ID"
*    Y.LIST = "" ; IVA.GRUPO = "" ; R.INFO.IVA = "" ; MNT.IVA.GRUPO = ""
*
*    EB.DataAccess.Readlist(Y.SELECT,Y.LIST,"",Y.TOT.REC,Y.ERROR)
*
*    IF Y.LIST THEN
*        Y.ID.IVA = Y.LIST<1>
*        EB.DataAccess.FRead(FN.GROUP.CREDIT.INT,Y.ID.IVA,R.INFO.IVA,F.GROUP.CREDIT.INT,Y.ERR.IVA)
*        IF R.INFO.IVA THEN
*            Y.IVA.CAMPO = R.INFO.IVA<IC.Config.GroupCreditInt.GciCrIntRate>
*            Y.NO.VAL = DCOUNT(Y.IVA.CAMPO,@VM)
*            IF BAND.PRINT.GAT EQ "SI" THEN        ;* LFCR_20240425_TASA_GAT - S
*                IVA.GRUPO = Y.IVA.CAMPO<1,1>
*            END ELSE
*                IVA.GRUPO = Y.IVA.CAMPO<1,Y.NO.VAL>
*            END
**IVA.GRUPO = Y.IVA.CAMPO<1,Y.NO.VAL> ;* LFCR_20240425_TASA_GAT - E
*            Y.IVA.MNT.CAMP = R.INFO.IVA<IC.Config.GroupCreditInt.GciCrLimitAmt>
*            Y.NO.VAL.MNT = DCOUNT(Y.IVA.MNT.CAMP,@VM) - 1
*            MNT.IVA.GRUPO = Y.IVA.MNT.CAMP<1,Y.NO.VAL.MNT> + 0.01
*        END
*
*    END

RETURN
***********
GENERA.XML:
***********
    
    Y.XML = '<?xml version="1.0" encoding="UTF-8"?>'
    Y.XML := '<Datos>'
    Y.XML := '<TIPO_FORMATO>':TIPO.FORMATO:'</TIPO_FORMATO>'
    Y.CADENA.LOG<-1> =  "***GENERA.XML***"
    Y.CADENA.LOG<-1> =  "TIPO_FORMATO->" : TIPO.FORMATO

    GOSUB XML.BLOQUE.INICIO
    Y.CADENA.LOG<-1> =  "CLASSIFICATION->" : CLASSIFICATION
    IF CLASSIFICATION LT 2001 THEN
        GOSUB XML.BLOQUE.PF
        GOSUB XML.ANEXO.PF
    END ELSE
        GOSUB XML.BLOQUE.PM
    END

    GOSUB XML.BLOQUE.FINAL

    Y.XML := '</Datos>'

RETURN
******************
XML.BLOQUE.INICIO:
******************

    Y.XML := '<ID_CLIENTE>':ID.CLIENTE:'</ID_CLIENTE>'
    Y.XML := '<ID_CUENTA>':ID.CUENTA:'</ID_CUENTA>'
    Y.XML := '<CATEGORIA_CTA>':CATEGORIA.CTA:'</CATEGORIA_CTA>'
    Y.XML := '<CANAL_CTA>':Y.CANAL.CTA:'</CANAL_CTA>'
    Y.XML := '<NOM_COMERCIAL_PROD>':NAME.PROD.COMECIAL:'</NOM_COMERCIAL_PROD>'

    Y.XML := '<NUMERO_RECA>':Y.NUMERO.RECA:'</NUMERO_RECA>'
    Y.XML := '<CORREO_CLIENTE>':CORREO.CLIENTE:'</CORREO_CLIENTE>'

    Y.XML := '<FECHA_APERTURA>':FECHA.APERTURA:'</FECHA_APERTURA>'
    Y.XML := '<FECHA_IMPRESION>':EB.SystemTables.getToday():'</FECHA_IMPRESION>'
    
    Y.CADENA.LOG<-1> =  "***XML.BLOQUE.INICIO***"
    Y.CADENA.LOG<-1> =  "Y.NUMERO.RECA->" : Y.NUMERO.RECA
    Y.CADENA.LOG<-1> =  "NAME.PROD.COMECIAL->" : NAME.PROD.COMECIAL
    
RETURN

**************
XML.BLOQUE.PF:
**************
    
    Y.XML := '<NOMBRE_CLIENTE>':NOMBRE.CLIENTE:'</NOMBRE_CLIENTE>'
    
    Y.CADENA.LOG<-1> =  "***XML.BLOQUE.PF***"
    Y.CADENA.LOG<-1> =  "NOMBRE.CLIENTE->" : NOMBRE.CLIENTE

RETURN

**************
XML.ANEXO.PF:
**************
    
    Y.XML := '<NIVEL>':NIVEL:'</NIVEL>'
    
    Y.CADENA.LOG<-1> =  "***XML.ANEXO.PF***"
    Y.CADENA.LOG<-1> =  "NIVEL->" : NIVEL

RETURN
*****************
XML.BLOQUE.FINAL:
*****************

    Y.XML := '<CATEGORIA_CTA>':CATEGORIA.CTA:'</CATEGORIA_CTA>'
    Y.XML := '<RUTA_IMAGEN_JR>':RUTA.IMAGEN.JR:'</RUTA_IMAGEN_JR>'
    Y.XML := '<RUTA_SUBREPORTE_JR>':RUTA.SUBREPORTE.JR:'</RUTA_SUBREPORTE_JR>'
    Y.XML := '<IMPRIME_GAT>':BAND.PRINT.GAT:'</IMPRIME_GAT>'
    Y.XML := '<GARAN_IPAB>':GARAN.IPAB:'</GARAN_IPAB>'
    Y.XML := '<IVA_DATO>':IVA.G:'</IVA_DATO>'
    Y.XML := '<IVA_MONTO>':MNT.IVA.GRUPO:'</IVA_MONTO>'
    Y.XML := '<IVA_DIAS>':IVA.DIAS:'</IVA_DIAS>'
    Y.XML := '<GAT_NOMINAL>':GAT.NOM:'</GAT_NOMINAL>'
    Y.XML := '<GAT_REAL>':GAT.R:'</GAT_REAL>'
    Y.XML := '<NOMB_CAT_CTA>':NOMB.CAT.CTA:'</NOMB_CAT_CTA>'
    Y.XML := '<NIVEL>':NIVEL:'</NIVEL>'

RETURN
**************
XML.BLOQUE.PM:
**************
    
    Y.XML := '<NOMBRE_CLIENTE>':RAZON.SOCIAL:'</NOMBRE_CLIENTE>'
    
    Y.CADENA.LOG<-1> =  "***XML.BLOQUE.PM***"
    Y.CADENA.LOG<-1> =  "RAZON.SOCIAL->" : RAZON.SOCIAL

RETURN
**************
OBTIENE.PARAM.REPORTES:
**************

    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.ID.PARAM = 'ABC.PARAMETROS.REPORTES'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    NUM.LINEAS = DCOUNT(Y.LIST.PARAMS,@FM)

    LOCATE "RUTA_PDF" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.PDF = Y.LIST.VALUES<POS>
*AbcContractService.AbcObtieneRutaAbs(RUTA.PDF)
    END

    LOCATE "RUTA_XML" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.XML = Y.LIST.VALUES<POS>
*AbcContractService.AbcObtieneRutaAbs(RUTA.XML)
    END

    LOCATE "RUTA_JRXML" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.JRXML = Y.LIST.VALUES<POS>
*AbcContractService.AbcObtieneRutaAbs(RUTA.JRXML)
    END

    LOCATE "NOMBRE_JR_CARAT_6008" IN Y.LIST.PARAMS SETTING POS THEN
        NOMBRE.JR = Y.LIST.VALUES<POS>
    END

    LOCATE "NOMBRE_PDF_CARAT" IN Y.LIST.PARAMS SETTING POS THEN
        NOMBRE.PDF = Y.LIST.VALUES<POS>
    END

    LOCATE "NOMBRE_JAR" IN Y.LIST.PARAMS SETTING POS THEN
        NOMBRE.JAR = Y.LIST.VALUES<POS>
    END

    LOCATE "RUTA_IMAGEN_JR" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.IMAGEN.JR = Y.LIST.VALUES<POS>
*AbcContractService.AbcObtieneRutaAbs(RUTA.IMAGEN.JR)
    END

    LOCATE "RUTA_SUBREPORTE_JR" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.SUBREPORTE.JR = Y.LIST.VALUES<POS>
*AbcContractService.AbcObtieneRutaAbs(RUTA.SUBREPORTE.JR)
    END
    Y.NOMBRE.RUTINA = "ABC.NOFILE.CARATULA.CONTRATO"
    Y.CADENA.LOG<-1> =  "RUTA.PDF->" : RUTA.PDF
    Y.CADENA.LOG<-1> =  "RUTA.PDF.NIVEL->" : RUTA.PDF.NIVEL
    Y.CADENA.LOG<-1> =  "IVA.G->" : IVA.G
    Y.CADENA.LOG<-1> =  "IVA.DIAS->" : IVA.DIAS
            
RETURN
**************
OBTIENE.PARAM.RECA:
**************

    Y.LIST.PARAMS.RECA = ''
    Y.LIST.VALUES.RECA = ''
    Y.NUMERO.RECA = ''
    Y.ID.PARAM = 'ABC.PARAM.REPO.RECA'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS.RECA, Y.LIST.VALUES.RECA)
    NUM.LINEAS = DCOUNT(Y.LIST.PARAMS.RECA,@FM)

    LOCATE CATEGORIA.CTA IN Y.LIST.PARAMS.RECA SETTING POS THEN
        Y.VALORES.PARA = Y.LIST.VALUES.RECA<POS>
    END
    Y.NUMERO.RECA      = FIELD(Y.VALORES.PARA,"|",1)
    NAME.PROD.COMECIAL = FIELD(Y.VALORES.PARA,"|",2)

RETURN
***********
GUARDA.XML:
***********

    NOMBRE.XML = ID.CUENTA:"_TEMP.xml"

    OPENSEQ RUTA.XML,NOMBRE.XML TO FILE.VAR1 THEN
        EXECUTE "SH -c rm " : RUTA.XML:NOMBRE.XML        CAPTURING Y.RESPONSE.RM
    END

    OPENSEQ RUTA.XML,NOMBRE.XML TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    Y.XML = EREPLACE(Y.XML,Y.AMP,'&amp;')

    WRITESEQ Y.XML APPEND TO FILE.VAR1 ELSE
    END

RETURN
*************
CREA.REPORTE:
*************
    
    GOSUB SELEC.CARPETA.DESTINO
    Y.RUTA.PDF = RUTA.PDF
    Y.RUTA.XML = RUTA.XML
    Y.RUTA.JRXML = RUTA.JRXML
    Y.NOMBRE.JR = NOMBRE.JR
    Y.NOMBRE.PDF = NOMBRE.PDF : ID.CUENTA: ".pdf"
    Y.NOMBRE.JAR = NOMBRE.JAR
    Y.NOMBRE.XML = ID.CUENTA : "_TEMP"

    Y.PARAMETROS = Y.RUTA.JRXML: "*": Y.NOMBRE.JR: "*": Y.NOMBRE.XML: "*": Y.RUTA.XML: "*": Y.RUTA.PDF: "*": Y.NOMBRE.PDF
    DISPLAY Y.PARAMETROS
    
    OPENSEQ Y.RUTA.PDF,Y.NOMBRE.PDF TO FILE.VAR1 THEN
        EXECUTE "SH -c rm " : Y.RUTA.PDF:"/":Y.NOMBRE.PDF        CAPTURING Y.RESPONSE.RM
    END
    
    AbcContractService.AbcEjecutaJarGeneric(Y.PARAMETROS,Y.NOMBRE.JAR,Y.DIRECTORIO)

    Y.STATUS = ""
    Y.RUTA.FIN = ""
*    IF Y.DIRECTORIO EQ '' THEN
*        Y.STATUS = "NO DISPONIBLE"
*    END
*    IF Y.DIRECTORIO NE '' THEN
*        Y.STATUS = "OPERACION EXITOSA"
*    END
    
    FINDSTR "Exception" IN Y.DIRECTORIO SETTING AP THEN
        Y.STATUS = "NO DISPONIBLE"
        Y.DIR = ''
        Y.DIRECTORIO = ''
    END ELSE
        Y.STATUS = "OPERACION EXITOSA"
        Y.DIR = Y.DIRECTORIO
    END
    
    R.DATA= ID.CUENTA:YSEP.1:Y.DIRECTORIO:YSEP.1:Y.STATUS:YSEP.1:Y.DIR

RETURN
*************
SELEC.CARPETA.DESTINO:
*************
    
    GOSUB OBTENER.CTA.LIQUI.NIVEL
    Y.CARPETA.DESTINO = ''
        
    IF Y.NIVEL.CTA.LIQUI NE "" THEN
        LOCATE "RUTA_PDF_CARAT_" : Y.NIVEL.CTA.LIQUI IN Y.LIST.PARAMS SETTING POS THEN
            RUTA.PDF.NIVEL = Y.LIST.VALUES<POS>
        END
    END ELSE
    
        LOCATE "RUTA_PDF"  IN Y.LIST.PARAMS SETTING POS THEN
            RUTA.PDF.NIVEL = Y.LIST.VALUES<POS>
        END
    END
    
    RUTA.PDF = RUTA.PDF.NIVEL

RETURN
**************
OBTENER.CTA.LIQUI.NIVEL:
**************
    
    Y.ID.ACCT.LIQUI = ''
    R.INFO.CTA.LIQUI = ''
    Y.CATEG.CTA.LIQUI = ''
    Y.NIVEL.CTA.LIQUI = ''
    ID.ARRANGEMENT = R.INFO.CUENTA<AC.AccountOpening.Account.ArrangementId> ;* R.INFO.CUENTA<AC.AccountOpening.Account.ArrangementId>
    GOSUB LEE.ACCT.LCL.FLDS
    IF R.INFO.CUENTA.LT NE "" THEN
        Y.ID.ACCT.LIQUI = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.IntLiquAcct>
        Y.NIVEL.CTA.LIQUI = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.Nivel>
    END

RETURN
***********
LEE.ACCT.LCL.FLDS:
***********
    
    IF ID.ARRANGEMENT NE "" THEN
        EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS, ID.ARRANGEMENT, R.INFO.CUENTA.LT, F.ABC.ACCT.LCL.FLDS, ERR.ACLT)
    END

RETURN
***********
BORRA.XML:
***********
    
    OPENSEQ RUTA.XML,NOMBRE.XML TO FILE.VAR1 THEN
        EXECUTE "SH -c rm " : RUTA.XML:NOMBRE.XML        CAPTURING Y.RESPONSE.RM
    END

RETURN

**************
LEE.LOCAL.REF:
**************
    
    YPOS.NOM.PER.MORAL = ''
    YPOS.TIP.IPAB.GARAN = ''
*    EB.LocalReferences.GetLocRef('CUSTOMER','L.NOM.PER.MORAL',YPOS.NOM.PER.MORAL)
*    EB.LocalReferences.GetLocRef('CUSTOMER','L.TIP.IPAB.GARAN',YPOS.TIP.IPAB.GARAN)
*;*EB.LocalReferences.GetLocRef('ACCOUNT', 'CANAL', Y.POS.CANAL.ACC)

    applications<1>  = "CUSTOMER"
    fields<1,1>      = "L.NOM.PER.MORAL"
    fields<1,2>      = "L.TIP.IPAB.GARAN"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications,fields,field_Positions)
    YPOS.NOM.PER.MORAL = field_Positions<1,1>
    YPOS.TIP.IPAB.GARAN = field_Positions<1,2>

RETURN
    
****
FIN:
****

RETURN TO FIN

END