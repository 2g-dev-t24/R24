* @ValidationCode : MjotMzYzNjc3MzA2OkNwMTI1MjoxNzcyNDE2NjY1OTcxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 01 Mar 2026 22:57:45
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
SUBROUTINE ABC.NOFILE.REPORTE.CONTRATOS(DATOS)
*======================================================================================
* Nombre de Programa : ABC.NOFILE.REPORTE.CONTRATOS
* Objetivo           : Rutina nofile para el uso de generacion de contratos
* Desarrollador      : Cesar Miranda - FyG Solutions
* Fecha Creacion     : 2017-09-21
* Modificaciones     : Roberto Coto: se modifica estructura del xml para subreportes
* Fecha Modificacion : 2017-10-16
* Desarrollador      : Claudia Catalina Benitez Cerrillo - F&GSolutions
* Modificaciones     : Mapeo Cta. Fiduciaria,Nombre Cliente, Razon social,RECA
*                      Impresion de contratos vacios (se comenta para liberar)
* Fecha Modificacion : CCBC_20180212
* Modificaciones     : Se cambia logica para impresion de formatos anexos CRS,FATCA
*                      y AUTO CERTIFICACION
* Fecha Modificacion : CCBC_20180406
* Modificaciones     : Se asigna logica de variable para nombre comercial del producto
* Fecha Modificacion : CCBC_20180503
* Modificaciones     : Se asigna logica para caratulas adicionales y calculo de interes
* Fecha Modificacion : CCBC_20180515
* Modificaciones     : Se asigna logica contrato persona moral Fiducuiaria
* Fecha Modificacion : CCBC_20180522
* Modificaciones     : Se modifica fecha de calculo de generacion de contrato a fecha
*                      de apertura
* Fecha Modificacion : CCBC_20180611
* Modificaciones     : Se modifica campo de regimen de cuenta
* Fecha Modificacion : CCBC_20180711
* Modificaciones     : Si el cliente no tiene profesion se coloca la ocupacion
* Fecha Modificacion : CCBC_20180712
* Modificaciones     : Obtiene nombre de producto y adicionales en un solo campo para clausulado.
* Fecha Modificacion : ROHH_20180814
* Modificaciones     : Modificacion para obtener giro mercantil de personas morales.
* Fecha Modificacion : ROHH_20180830
* Modificaciones     : Modificacion para el obtener tipo de firma de representantes legales, y administradores de banca electronica para personas morales y fisicas con actividad empresarial.
* Fecha Modificacion : ROHH_20180906
* Modificaciones     : Modificacion para generar etiqueta NUM_SUCURSALES en todos los tipos de personas
* Fecha Modificacion : ROHH_20181127
* Modificaciones     : Modificacion para extraer correctamente fecha de nac en cotitulares y propietario real, actividad de propietario real
*                      utilizar primer multivalor de employers name en PF y PFAE, extraer descripcion de la tabla RELATION para tipo
*                      de persona expuesta.
* Fecha Modificacion : ROHH_20181224
* Modificaciones     : Se modifica rutina para la obtencie la descripcie comprobante de domicilio tomada desde tabla de catgo
*                      asomo tambila cobertura geogrca, estado civil y tipo de empleo de EB.LOOKUP
* Fecha Modificacion : COLL_20190218
* Fecha Modificacion : LFCR_20200823
* Modificaciones     : Se agrega la obtenci�n de los campos faltantes para accionista(RFC, Nacionalidad, Pa�s de residencia)
* Fecha Modificacion : LFCR_20201105
* Modificaciones     : Se agrega la opcion de leer registro de ACCOUNT desde $NAU para obtener los datos para el contrato: PF CUENTA N2
* Fecha Modificacion : LFCR_20210416
* Modificaciones     : Se agrega la opcion de leer registro de ACCOUNT desde $NAU para obtener los datos para el contrato: FINTECH y para
*                      ubicar todos los contratos generados por el proceso automatico en una carpeta diferente
* Fecha Modificacion : LFCR_20210817
* Modificaciones     : Se agrega la obtencion de porcentaje de titularidad para cada cotitular mediante la etiqueta PORC_COT
* Fecha Modificacion : LFCR_20211118_UALA
* Modificaciones     : Se agrega la generaci�n de contrato UALA con su propia parametrizaci�n
* Fecha Modificacion : LFCR_20220728
* Modificaciones     : Se agrega campo CANAL a XML de salida de contrato, se corrige variable repetida de campo local PLD.FUN.PUB de ACCOUNT y CUSTOMER
* Fecha Modificacion : LFCR_20221108
* Modificaciones     : Se cambia obtencion de datos de COTITULAR de campos locales en ACCOUNT a registro en CUSTOMER
* Fecha Modificacion : LFCR_20221216_N4L
* Modificaciones     : Se agrega la generaci�n de contrato N4 Lite con condiciones NIVEL.4 y category 1014
* Fecha Modificacion : LFCR_20230321_GAT
* Modificaciones     : Se modifica condicion para calculo de GAT para categories parametrizadas en ABC.CATS.CALC.GAT.PARAM y
*                      se agrega la etiqueta IMPRIME_GAT para generacion de contratos PDF
* Fecha Modificacion : LFCR_20230327_REMU
* Modificaciones     : Se agrega la generaci�n de caratula de cuenta remunerada para las categories parametrizadas en ABC.CATS.CALC.GAT.PARAM
*                      en el parametro CATS_UALA_REM
* Fecha Modificacion : LFCR_20230508_TASA
* Modificaciones     : Se agrega formateo de dato de TASA en rutina para quitarlo de plantilla jrxml, se maneja formato de 1 decimal�
*                      la plantilla unicamente agrega el "%"
* Fecha Modificacion : LFCR_20230509_RUTA
* Modificaciones     : Se implementa funcionalidad para depositar contratos generados desde version de alta digital en subcarpeta de CANAL/NIVEL
*                      Se retira validacion de firmante = 8 para depositar todos los contratos en la carpeta correspondiente a su canal
* Fecha Modificacion : LFCR_20230821_RESTRICCION
* Modificaciones     : Se modifica rutina para agregar validacion por parametrizacion de contratos permitidos para su generacion
*                      Parametrizacion: ABC.CONDICIONES.CONTRATOS.PARAM
* Fecha Modificacion : LFCR_20240319_GARANTIZADA
* Modificaciones     : Se modifica rutina para agregar generacion de contrato de cuenta garantizada
* Fecha Modificacion : LFCR_20240425_TASA_GAT
* Modificaciones     : Se modifica rutina para cambiar seleccion de tasa en GROUP.CREDIT.INT
*                      por el primer multivalor para categories dentro de parametro: CATEGORIES_REMUNERADA
* Fecha Modificacion :  20241029_RZN.SCL
* Descripcion        :  Se agrega la funcionalidad para leer cadena de RAZON.SOCIAL
*                       mediante una call rtn
* Fecha Modificacion :  LFCR_20250929_LCLFLDS
* Descripcion        :  Se agrega la funcionalidad para leer el registro de campos locales desde la nueva
*                       tabla ABC.ACCT.LCL.FLDS
* Fecha Modificacion :  LFCR_20251006_SECTOR_MXBASE
* Descripcion        :  Se cambia la obtencion de datos de actividad economica de SECTOR a MXBASE.ADD.CUSTOMER.DETAILS
*======================================================================================
* Subroutine Type : NOFILE RTN
* Attached to : STANDARD.SELECTION>NOFILE.REPORTES.CONTRATOS
*               ENQUIRY>ENQ.NOFILE.REP.CONT
* Attached as : NOFILE RTN
* Primary Purpose : Rutina nofile de generacion de contratos pdf
*-----------------------------------------------------------------------
* Luis Cruz
* 23-09-2025
* Revision de rutina componentizada por 2G
*-----------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcGetGeneralParam
    $USING AC.AccountOpening
    $USING MXBASE.CustomerRegulatory
    $USING ST.Customer
    $USING EB.Reports
    $USING AbcTable
    $USING EB.LocalReferences
    $USING IC.Config
    $USING ST.Config
    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING AA.Interest
    $USING AA.Account
    $USING AbcContractService
    $USING EB.AbcUtil
    
    GOSUB INICIALIZA
    GOSUB LEE.LOCAL.REF
    GOSUB LEE.CUENTA
    GOSUB VALIDA.TIPO.CONTRATO          ;* LFCR_20230821_RESTRICCION S-E
    GOSUB OBTIENE.FIRMANTES
    GOSUB OBTIENE.PARAM.REPORTES
    IF ERROR.CONTRATO NE '' THEN        ;* LFCR_20230821_RESTRICCION S
        EB.Reports.setEnqError(ERROR.CONTRATO)
        RETURN
    END   ;* LFCR_20230821_RESTRICCION E
    GOSUB GENERA.XML
    GOSUB GUARDA.XML
    GOSUB CREA.REPORTE
    GOSUB BORRA.XML

RETURN

***********
INICIALIZA:
***********
    
    TIP                 = ""
    SALIDA.BENEFICIARIO = ""

    FN.CUENTA.NAU= 'F.ACCOUNT$NAU'                         ; F.CUENTA.NAU= ''             ; EB.DataAccess.Opf(FN.CUENTA.NAU,F.CUENTA.NAU)  ;*LFCR_20201105-S-E
    FN.SECTOR    = 'F.SECTOR'                              ; F.SECTOR    = ''             ; EB.DataAccess.Opf(FN.SECTOR,F.SECTOR)
    FN.CUENTA    = 'F.ACCOUNT'                             ; F.CUENTA    = ''             ; EB.DataAccess.Opf(FN.CUENTA,F.CUENTA)
    FN.PAIS      = 'F.COUNTRY'                             ; F.PAIS      = ''             ; EB.DataAccess.Opf(FN.PAIS,F.PAIS)
    FN.CLIENTE   = 'F.CUSTOMER'                            ; F.CLIENTE   = ''             ; EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)
    FN.INDUSTRIA = 'F.INDUSTRY'                            ; F.INDUSTRIA = ''             ; EB.DataAccess.Opf(FN.INDUSTRIA,F.INDUSTRIA)
    FN.CATEGORY  = 'F.CATEGORY'                            ; F.CATEGORY  = ''             ; EB.DataAccess.Opf(FN.CATEGORY,F.CATEGORY)
    FN.LOOKUP    = 'F.EB.LOOKUP'                           ; F.LOOKUP    = ''             ; EB.DataAccess.Opf(FN.LOOKUP,F.LOOKUP)
    FN.CIUDAD    = 'F.ABC.CIUDAD'                          ; F.CIUDAD    = ''             ; EB.DataAccess.Opf(FN.CIUDAD,F.CIUDAD)
    FN.ESTADO    = 'F.ABC.ESTADO'                          ; F.ESTADO    = ''             ; EB.DataAccess.Opf(FN.ESTADO,F.ESTADO)
*    FN.BANCOS    = 'F.ABC.BANCOS'                          ; F.BANCOS    = ''             ; EB.DataAccess.Opf(FN.BANCOS,F.BANCOS) ;* SE CAMBIA POR EB.LOOKUP>CLB.BANK.CODE
    FN.COLONIA   = 'F.ABC.COLONIA'                         ; F.COLONIA   = ''             ; EB.DataAccess.Opf(FN.COLONIA,F.COLONIA)
    FN.MUNICIPIO = 'F.ABC.MUNICIPIO'                       ; F.MUNICIPIO = ''             ; EB.DataAccess.Opf(FN.MUNICIPIO,F.MUNICIPIO)
    FN.SEC.ECO   = 'F.SECTOR.ECONOMICO'                    ; F.SEC.ECO   = ''             ; EB.DataAccess.Opf(FN.SEC.ECO,F.SEC.ECO)
    FN.CAT.RAN   = 'F.ABC.CATAG.RANGOS'                    ; F.CAT.RAN   = ''             ; EB.DataAccess.Opf(FN.CAT.RAN,F.CAT.RAN)
    FN.DAO       = 'F.DEPT.ACCT.OFFICER'                   ; F.DAO       = ''             ; EB.DataAccess.Opf(FN.DAO,F.DAO)
**    FN.TIP.CTA   = 'F.VPM.TIPO.DE.CUENTA'                  ; F.TIP.CTA   = ''             ; EB.DataAccess.Opf(FN.TIP.CTA,F.TIP.CTA)
    FN.CONT.PROD = 'F.ABC.PARAM.CONT.PROD'                 ; F.CONT.PROD = ''             ; EB.DataAccess.Opf(FN.CONT.PROD,F.CONT.PROD)
    FN.ACT.ECO   = 'F.ABC.ACTIVIDAD.ECONOMICA'             ; F.ACT.ECO   = ''             ; EB.DataAccess.Opf(FN.ACT.ECO,F.ACT.ECO)
    FN.BA.AC.SUCURSALES = 'F.BA.AC.SUCURSALES'             ; F.BA.AC.SUCURSALES = ''      ; EB.DataAccess.Opf (FN.BA.AC.SUCURSALES,F.BA.AC.SUCURSALES)
    FN.ABC.FIRMANTE.CONTRATO = 'F.ABC.FIRMANTE.CONTRATO'   ; F.ABC.FIRMANTE.CONTRATO = '' ; EB.DataAccess.Opf(FN.ABC.FIRMANTE.CONTRATO,F.ABC.FIRMANTE.CONTRATO)
    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'             ; F.GROUP.CREDIT.INT = ''      ; EB.DataAccess.Opf(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)
    FN.ABC.BANCA.INTERNET = 'F.ABC.BANCA.INTERNET'         ; F.ABC.BANCA.INTERNET = ''    ; EB.DataAccess.Opf(FN.ABC.BANCA.INTERNET,F.ABC.BANCA.INTERNET)
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'; F.ABC.GENERAL.PARAM = '' ; EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'; F.ABC.ACCT.LCL.FLDS = '' ; EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS, F.ABC.ACCT.LCL.FLDS)
    FN.JOB.TITLE = 'F.JOB.TITLE'; F.JOB.TITLE = '' ; EB.DataAccess.Opf(FN.JOB.TITLE, F.JOB.TITLE)
    FN.RELATION = 'F.RELATION'; F.RELATION = ''; EB.DataAccess.Opf(FN.RELATION, F.RELATION)

    FIRMANTE.CONT = 1

    SEL.FIELDS          = EB.Reports.getDFields()
    SEL.RANGE.AND.VALUE = EB.Reports.getDRangeAndValue()
    
    LOCATE "ID.CUENTA" IN SEL.FIELDS<1> SETTING POSITION THEN

        ID.CUENTA = SEL.RANGE.AND.VALUE<POSITION>
        ID.CUENTA = TRIM(ID.CUENTA)     ;*ROHH_20181224
        CHANGE "'" TO "" IN ID.CUENTA

        Y.IMP.FLAG = FIELD(ID.CUENTA,"-",3)
        Y.CATEGORIA.CTA = FIELD(ID.CUENTA,"-",2)
        ID.CUENTA = FIELD(ID.CUENTA,"-",1)
        IF ID.CUENTA MATCHES("1":@VM:"2":@VM:"3") THEN
            TIPO.FORMATO = ID.CUENTA
        END ELSE
;*ID.CUENTA = FMT(ID.CUENTA,"11'0'R")
        END

    END

    YSEP   = '*'
    YSEP.1 = '|'
    YSEP.2 = ' '
    CAA = 1
    CFA = 1
    CDIF = 1

    Y.QUOTE = '"'   ;*AAR-20191002 - S
    Y.GT    = '>'
    Y.LT    = '<'
    Y.AMP   = '&'
    Y.APOS  = "'"   ;*AAR-20191002 - E

    Y.LIST.PARAM.CONDI = '' ; Y.LIST.VALUES.CONDI = ''      ;* LFCR_20230821_RESTRICCION S
    Y.VALS.N2 = '' ; Y.VALS.N4L = ''
    Y.NIVELES.UALA = '' ; Y.CATEGS.UALA.N2 = '' ; Y.CATEGS.UALA.N4 = '' ; Y.CANALES.UALA = ''
    Y.CATEGS.REMUN = '' ; Y.NIVELES.NAU = '' ; Y.CATS.NAU = ''
    Y.CATEGS.GARAN = ''       ;* LFCR_20240319_GARANTIZADA S - E

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

    LOCATE "CATEGORIES_UALA_N2" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.CATEGS.UALA.N2 = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.CATEGS.UALA.N2
    END
    
    LOCATE "CATEGORIES_UALA_N4" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.CATEGS.UALA.N4 = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.CATEGS.UALA.N4
    END

    LOCATE "CANALES_UALA" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.CANALES.UALA = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.CANALES.UALA
    END

    LOCATE "CATEGORIES_REMUNERADA" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.CATEGS.REMUN = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.CATEGS.REMUN
    END

    LOCATE "CATEGORIES_GARANTIZADA" IN Y.LIST.PARAM.CONDI SETTING POS THEN      ;* LFCR_20240319_GARANTIZADA - S
        Y.CATEGS.GARAN = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.CATEGS.GARAN
    END   ;* LFCR_20240319_GARANTIZADA - E

    LOCATE "NIVELES_GEN_CONT_NAU" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.NIVELES.NAU = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.NIVELES.NAU
    END

    LOCATE "CATEGORIES_GEN_CONT_NAU" IN Y.LIST.PARAM.CONDI SETTING POS THEN
        Y.CATS.NAU = Y.LIST.VALUES.CONDI<POS>
        CHANGE "," TO @VM IN Y.CATS.NAU
    END

*20241029_RZN.SCL - S

    Y.RAZON.SOCIAL.FULL = '' ; Y.RAZON.SOCIAL.SHORT = '' ; Y.DIR.SITIO.WEB = ''
    Y.ID.PARAM.RZN.SCL = 'RAZON.SOCIAL.PARAM' ; Y.LIST.PARAM.RZN.SCL = '' ; Y.VALUES.RZN.SCL = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM.RZN.SCL, Y.LIST.PARAM.RZN.SCL, Y.VALUES.RZN.SCL)

    LOCATE "RAZON.SOCIAL.FULL" IN Y.LIST.PARAM.RZN.SCL SETTING POS THEN
        Y.RAZON.SOCIAL.FULL = Y.VALUES.RZN.SCL<POS>
    END

    LOCATE "RAZON.SOCIAL.SHORT" IN Y.LIST.PARAM.RZN.SCL SETTING POS THEN
        Y.RAZON.SOCIAL.SHORT = Y.VALUES.RZN.SCL<POS>
    END

    LOCATE "DIR.SITIO.WEB" IN Y.LIST.PARAM.RZN.SCL SETTING POS THEN
        Y.DIR.SITIO.WEB = Y.VALUES.RZN.SCL<POS>
    END
*20241029_RZN.SCL - E

RETURN          ;* LFCR_20230821_RESTRICCION E

******************
OBTIENE.FIRMANTES:
******************

    LOCATE "FIRMANTE.1" IN SEL.FIELDS<1> SETTING POSITION THEN
        ID.FIRMANTE = SEL.RANGE.AND.VALUE<POSITION>
        GOSUB LEE.FIRM.CONT
        FIRMANTE = DES.FIRMANTE
        GOSUB GENERA.FIRMANTES
    END

    LOCATE "FIRMANTE.2" IN SEL.FIELDS<1> SETTING POSITION THEN
        ID.FIRMANTE = SEL.RANGE.AND.VALUE<POSITION>
        GOSUB LEE.FIRM.CONT
        FIRMANTE = DES.FIRMANTE
        GOSUB GENERA.FIRMANTES
    END

    LOCATE "FIRMANTE.3" IN SEL.FIELDS<1> SETTING POSITION THEN
        ID.FIRMANTE = SEL.RANGE.AND.VALUE<POSITION>
        GOSUB LEE.FIRM.CONT
        FIRMANTE = DES.FIRMANTE
        GOSUB GENERA.FIRMANTES
    END

    LOCATE "FIRMANTE.4" IN SEL.FIELDS<1> SETTING POSITION THEN
        ID.FIRMANTE = SEL.RANGE.AND.VALUE<POSITION>
        GOSUB LEE.FIRM.CONT
        FIRMANTE = DES.FIRMANTE
        GOSUB GENERA.FIRMANTES
    END

    LOCATE "FIRMANTE.5" IN SEL.FIELDS<1> SETTING POSITION THEN
        ID.FIRMANTE = SEL.RANGE.AND.VALUE<POSITION>
        GOSUB LEE.FIRM.CONT
        FIRMANTE = DES.FIRMANTE
        GOSUB GENERA.FIRMANTES
    END

RETURN

*****************
GENERA.FIRMANTES:
*****************
    Y.CADENA.LOG<-1> = "--GENERA.FIRMANTES--"
    CHANGE @SM TO ' ' IN FIRMANTE
    Y.CADENA.LOG<-1> = "FIRMANTE" : FIRMANTE
    FIRMANTES := '<NOMBRE_FIRMANTE_':FIRMANTE.CONT:'>':FIRMANTE:'</NOMBRE_FIRMANTE_':FIRMANTE.CONT:'>'
    Y.CADENA.LOG<-1> = "FIRMANTES" : FIRMANTES

    FIRMANTE.CONT += 1

RETURN

***********
LEE.CUENTA:
***********
    
    TIPO.PRODUCTO = ""  ; TIPO.SERVICIO = ""       ; ID.CLIENTE = ""           ; NUM.EJECUTIVO = ""        ; ID.DAO = ""
    NOM.SUCURSAL = ""   ; CTA.CLABE = ""           ; FECHA.APERTURA = ""       ; REGIMEN.CTA = ""          ; USO.CUENTA = ""
    CATEGORIA.CTA = ""  ; NOMB.CAT.CTA = ""        ; PROCEDENCIA.RECURSOS = "" ; OTRA.PROCEDENCIA = ""     ; RELACION.CLIENTE = ""
    SEL.SERVICIO = ""   ; MED.DISPOSICION = ""     ; FACULTADOS = ""           ; REG.FIRMAS.TEMP = ""      ; FUNCIONARIO.PUB = ""
    ACCIONISTA.ABC = "" ; ACCIONISTA.ABC.ESP = ""  ; COMBINA.FIRMAS = ""       ; GRUPO.COND = ""           ; LISTA.FEC.INSCR.REG = ""
    ID.CIUDAD.COT = ""  ; DESCR.CIUDAD = ""        ; REG.PUB = ""              ; Y.STATUS = ""             ; LISTA.NOMBRE.REG = ""
    Y.FECHA = ""        ; Y.FIDUCIARIA = ""        ; Y.ACC.TITLE = ""          ; NOM.EJECUTIVO = ""        ; NUM.SUCURSAL = ""
    OTRO.USO.CTA = ""   ; NIVEL = ""               ; REFERENCIA.PROVEDOR = ""  ; FUNCIONARIO.PUB.ESP = ""  ; FUNCIONARIO.PUB.ESP = ""
    ID.SUC = ""         ; TOTAL.APOD.LEGA.REG = "" ; IVA.G = ""                ; Y.FLAG.FIDUCIARIA = ""    ; REPRESENTANTE_LEGAL = ""
    Y.FINTECH = ""      ; Y.FLAG.FINTECH = ""     ;*LFCR_20200823-S-E
    Y.FLAG.GEN.NAU = "" ; Y.CANAL.CTA = ""        ;*LFCR_20210416-S-E
    ALT.IDS.CTA = ""

    
    IF ID.CUENTA THEN
        R.INFO.CUENTA = AC.AccountOpening.Account.Read(ID.CUENTA, ERROR.CUENTA)
        IF R.INFO.CUENTA EQ "" THEN
            EB.DataAccess.FRead(FN.CUENTA.NAU, ID.CUENTA, R.INFO.CUENTA, F.CUENTA.NAU, ERR.CTA.NAU)         ;*LFCR_20201105-S
            ID.ARRANGEMENT = R.INFO.CUENTA<AC.AccountOpening.Account.ArrangementId>
            GOSUB LEE.ACCT.LCL.FLDS

            IF R.INFO.CUENTA EQ "" THEN ;*LFCR_20201105-E
                Y.STATUS = "La cuenta ingresada no existe."
                DATOS =  YSEP.1:YSEP.1:Y.STATUS

                IF ID.CUENTA MATCHES("1":@VM:"2":@VM:"3") THEN
                    CLASSIFICATION = ID.CUENTA
                    BEGIN CASE
                        CASE Y.IMP.FLAG EQ 1
                            Y.FLAG.FIDUCIARIA = Y.IMP.FLAG

                        CASE Y.IMP.FLAG EQ 2
                            Y.FLAG.NIVEL2 = 1

                        CASE Y.IMP.FLAG EQ 3
                            Y.FLAG.FINTECH = 1

                        CASE Y.IMP.FLAG EQ 4          ;*---------------LFCR_20211118_UALA - S-E
                            Y.FLAG.UALA = 1
                            Y.FLAG.NIVEL2 = 1
*----------------------------------------------------------------------LFCR_20201105-E
                    END CASE
*Y.FLAG.FIDUCIARIA = Y.IMP.FLAG
                    CATEGORIA.CTA = Y.CATEGORIA.CTA
                    GOSUB OBTIENE.PARAM.RECA
                    NAME.PROD.COMECIAL = ''
                    GOSUB OBTIENE.PARAM.REPORTES
                    SALIDA.ANEXO.A = '<ANEXO ID="1"><NUMERO_RECA>':Y.NUMERO.RECA:'</NUMERO_RECA></ANEXO>'
                    MNT.IVA.GRUPO = 0
                    GOSUB GENERA.XML
                    GOSUB GUARDA.XML
                    GOSUB CREA.REPORTE
                    GOSUB BORRA.XML
                END
*----------------------------------------------------------------------------E
                GOTO FIN
            END     ;*LFCR_20201105-S
            IF R.INFO.CUENTA THEN
                GOSUB VERIFICA.NAU
                IF Y.FLAG.GEN.NAU EQ 1 THEN
                    GOSUB OBTEN.INFO.CUENTA
                END ELSE
                    Y.STATUS = "La cuenta ingresada no existe."
                    DATOS =  YSEP.1:YSEP.1:Y.STATUS
                    GOTO FIN
                END
            END     ;*LFCR_20201105-E
        END
        IF R.INFO.CUENTA THEN
            GOSUB OBTEN.INFO.CUENTA
        END
    END

RETURN

***********  ;*LFCR_20210416-S
VERIFICA.NAU:
***********

    IF R.INFO.CUENTA.LT NE "" THEN
        NIVEL = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.Nivel>
        CATEGORIA.CTA = R.INFO.CUENTA<AC.AccountOpening.Account.Category>
    END

    IF (NIVEL MATCHES Y.NIVELES.NAU) AND (CATEGORIA.CTA MATCHES Y.CATS.NAU) THEN
        Y.FLAG.GEN.NAU = 1
    END

RETURN

***********  ;*LFCR_20201105-S
OBTEN.INFO.CUENTA:
***********
    
    IF R.INFO.CUENTA THEN
        
        ID.CLIENTE = R.INFO.CUENTA<AC.AccountOpening.Account.Customer>
        IF ID.CLIENTE THEN
            GOSUB LEE.CLIENTE
        END
        
        ID.ARRANGEMENT = R.INFO.CUENTA<AC.AccountOpening.Account.ArrangementId>
*        ALT.IDS.CTA     = R.INFO.CUENTA<AC.AccountOpening.Account.AltAcctType>
*        Y.CADENA.LOG<-1> =  "ALT.IDS.CTA->" : ALT.IDS.CTA
*
*        CHANGE @VM TO @FM IN ALT.IDS.CTA
*        LOCATE "CLABE" IN  ALT.IDS.CTA SETTING POS THEN
*            CTA.CLABE     = R.INFO.CUENTA<AC.AccountOpening.Account.AltAcctId><1, POS>
*            Y.CADENA.LOG<-1> =  "CTA.CLABE->" : CTA.CLABE
*        END
    
;*IF CTA.CLABE EQ "" THEN
        ARR.ID = ID.ARRANGEMENT
        EFF.DATE = EB.SystemTables.getToday()
        AA.Framework.GetArrangementConditions(ARR.ID, 'ACCOUNT', '', EFF.DATE, r.int.Ids, IntCondition, r.Error)
        IntCondition = RAISE(IntCondition)
        ALTER.IDS.TYPE.AA   = IntCondition<AA.Account.Account.AcAltIdType>
        ALTER.IDS.AA   = IntCondition<AA.Account.Account.AcAltId>
        CHANGE @VM TO @FM IN ALTER.IDS.TYPE.AA
        LOCATE "CLABE" IN  ALTER.IDS.TYPE.AA SETTING POS THEN
            CTA.CLABE     = ALTER.IDS.AA<1, POS>
        END
;*END
        
        GOSUB LEE.ACCT.LCL.FLDS
        
        IF R.INFO.CUENTA.LT NE "" THEN
            Y.FIDUCIARIA = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.Fiduciaria>
            IF Y.FIDUCIARIA NE '' AND Y.FIDUCIARIA MATCHES('SI') THEN
                Y.ACC.TITLE = R.INFO.CUENTA<AC.AccountOpening.Account.AccountTitleOne>
                Y.FLAG.FIDUCIARIA = '1'
            END
            Y.FINTECH = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.Fintech>
            IF Y.FINTECH NE '' AND Y.FINTECH MATCHES('SI') THEN
                Y.FLAG.FINTECH = '1'
            END
;*CTA.CLABE            = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.Clabe> ;* SE REEMPLAZA POR ALT ID EN ACCOUNT
            REGIMEN.CTA          = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.RegimenCuenta>         ;*CCBC_20180711
            TIT.TIPO.FIRMA       = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.TitTipoFirma>
            LIST.COMBINA.FIRMAS  = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.CombinaFirmas>
            USO.CUENTA           = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.UsoPretendCta>
            USO.CUENTA           = FIELD(USO.CUENTA,@SM,1)
            OTRO.USO.CTA         = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.UsoPretendOtr>
            NIVEL                = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.Nivel>
            Y.NIVEL.CREA.REP     = NIVEL
            Y.CANAL.CTA          = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.Canal>
            
            Y.AC.CELULAR.ASOCIADO= R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.Celular>  ;*ROHH_20180906   Extrtae numero celular asociado a cuenta
            
            PROCEDENCIA.RECURSOS = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.ProcedenRecurs>
            OTRA.PROCEDENCIA     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.Procedenotr>
            FUNCIONARIO.PUB      = TRIM(R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PldFunPub>)

            IF FUNCIONARIO.PUB NE "SI" THEN
                FUNCIONARIO.PUB = "NO"
            END
            FUNCIONARIO.PUB.ESP  = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PldFunPubEsp>
            ACCIONISTA.ABC       = TRIM(R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PldAccBan>)
            IF ACCIONISTA.ABC NE "SI" THEN
                ACCIONISTA.ABC = "NO"
            END
*------------------------------------------------------------------------------ E
            ACCIONISTA.ABC.ESP   = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PldAccBanEsp>

            SOCIEDAD.GRAVAMEN    = ""; SALIDA.ANEXO.A = "";

            CHANGE @SM TO @FM IN LIST.COMBINA.FIRMAS
            NO.COMBINA.FIRMAS = DCOUNT(LIST.COMBINA.FIRMAS, @FM)
            COM.FIRMAS.CONT = 0

            FOR I.CF = 1 TO NO.COMBINA.FIRMAS
                IF LIST.COMBINA.FIRMAS<I.CF> NE '' THEN
                    COM.FIRMAS.CONT += 1
                    COMBINA.FIRMAS := '<COMBINA_FIRMAS>':LIST.COMBINA.FIRMAS<I.CF>:'</COMBINA_FIRMAS>'
                END
            NEXT I.CF
        END
        NUM.EJECUTIVO = R.INFO.CUENTA<AC.AccountOpening.Account.AccountOfficer>
        ID.DAO = NUM.EJECUTIVO
        GOSUB LEE.DAO
        NOM.EJECUTIVO = UPCASE(NOMBRE.DAO)
        NUM.SUCURSAL  = R.INFO.CUENTA<AC.AccountOpening.Account.AccountOfficer>[1,5]
        ID.DAO = ""
        ID.DAO = NUM.SUCURSAL
        GOSUB LEE.DAO
        NOM.SUCURSAL         = NOMBRE.DAO
        ID.SUC               = NUM.SUCURSAL
        
        GOSUB LEE.DIR.SUC
        
        ID.CIUDAD.COT            = DESCRIP.ID.EDO
        GOSUB LEE.CIUDAD
        DESCR.CIUDAD    = DES.CIUDAD
        
        
        FECHA.APERTURA       = R.INFO.CUENTA<AC.AccountOpening.Account.OpeningDate>
        CATEGORIA.CTA        = R.INFO.CUENTA<AC.AccountOpening.Account.Category>
        Y.CATEGORIA.CTA.CREA.REP = CATEGORIA.CTA
        
;*Y.CANAL.CTA          = R.INFO.CUENTA<AC.AccountOpening.Account.LocalRef, Y.POS.CANAL.ACC>

        NAME.PROD.COMECIAL = ''
        GOSUB OBTIENE.PARAM.RECA
        
        IF NOT(CATEGORIA.CTA MATCHES Y.CATEGS.REMUN) THEN   ;*LFCR_20230321_GAT - S-E
            BAND.PRINT.GAT = "NO"       ;*LFCR_20230321_GAT - S-E
            IVA.G = "0.0"
            GAT.NOM = "0.0"
            GAT.R = "0.0"
        END
        IF CATEGORIA.CTA MATCHES Y.CATEGS.REMUN THEN
            LOCATE "DIAS_" : CATEGORIA.CTA IN Y.LIST.PARAM.CONDI SETTING POS THEN
                Y.DIAS = Y.LIST.VALUES.CONDI<POS>
            END
            BAND.PRINT.GAT = "SI"       ;*LFCR_20230321_GAT - S-E
;*GRUPO.COND           = R.INFO.CUENTA<AC.AccountOpening.Account.ConditionGroup>
            GOSUB LEE.IVA
            IVA.DIAS = '364'
            IVA.G = IVA.GRUPO
            Y.FECHA = FECHA.APERTURA    ;* CCBC_20180611
            FECHA.ACT = Y.FECHA[0,6]
*Y.DIAS = 30
            
            Y.TIPO = 1
            Y.NOMBRE.RUTINA = "ABC.NOFILE.REPORTE.CONTRATOS"
            Y.CADENA.LOG<-1> =  "FECHA.ACT->" : FECHA.ACT
            Y.CADENA.LOG<-1> =  "Y.FECHA->" : Y.FECHA
            Y.CADENA.LOG<-1> =  "IVA.G->" : IVA.G
            Y.CADENA.LOG<-1> =  "IVA.DIAS->" : IVA.DIAS
            AbcContractService.AbcNewGetGat(FECHA.ACT,IVA.G,Y.DIAS,Y.TIPO,GAT.NOMINAL,GAT.REAL)
            
            Y.NOMBRE.RUTINA = "ABC.NOFILE.REPORTE.CONTRATOS"
            Y.CADENA.LOG<-1> =  "GAT.NOMINAL->" : GAT.NOMINAL
            Y.CADENA.LOG<-1> =  "GAT.REAL->" : GAT.REAL

            GAT.NOM = GAT.NOMINAL
            GAT.R = GAT.REAL

            IVA.G = FMT(IVA.G, "R1")    ;*LFCR_20230508_TASA - S-E
        END

        EB.DataAccess.FRead(FN.CATEGORY,CATEGORIA.CTA,R.INFO.CAT.CTA,F.CATEGORY,ERROR.CAT.CTA)
        IF R.INFO.CAT.CTA THEN
            NOMB.CAT.CTA = R.INFO.CAT.CTA<ST.Config.Category.EbCatDescription>
            Y.NO.VAL.NOMB.CAT.CTA = DCOUNT(NOMB.CAT.CTA, @VM)
            NOMB.CAT.CTA = NOMB.CAT.CTA<1,Y.NO.VAL.NOMB.CAT.CTA>
        END

        IF CLASSIFICATION LT 2001 THEN
*IF CLASSIFICATION LT 3 THEN
            GOSUB LEE.BENEFICIARIO
        END ELSE
            IF CLASSIFICATION GE 2014 THEN
*IF CLASSIFICATION GE 3 THEN
                GOSUB LEE.ACCIONISTAS
            END
        END
        GOSUB LEE.FIRMAS.AUTO
        GOSUB REF.PERSONAL
        GOSUB LEE.FIRMAS
        GOSUB REF.BANCARIA
        GOSUB LEE.COTITULARES
        GOSUB LEE.TERCERO
        GOSUB LEE.PER.FACUL
    END


    Y.ID.CONT.PROD = ''; REC.CONT.PROD = '';
    Y.ID.CONT.PROD = CATEGORIA.CTA
    
    EB.DataAccess.FRead(FN.CONT.PROD,Y.ID.CONT.PROD,REC.CONT.PROD,F.CONT.PROD,ERR.CONT.PROD)
    IF REC.CONT.PROD THEN
        MED.TARJETA = REC.CONT.PROD<AbcTable.AbcParamContProd.MedTarjeta>
        MED.CHEQUERA  = REC.CONT.PROD<AbcTable.AbcParamContProd.MedChequera>
        MED.VENTANILLA= REC.CONT.PROD<AbcTable.AbcParamContProd.MedVentanilla>
        MED.CAJERO    = REC.CONT.PROD<AbcTable.AbcParamContProd.MedCajero>
        MED.INTERNET  = REC.CONT.PROD<AbcTable.AbcParamContProd.MedInternet>
        MED.DOMICILIA = REC.CONT.PROD<AbcTable.AbcParamContProd.MedDomicilia>
        MED.COMERCIO  = REC.CONT.PROD<AbcTable.AbcParamContProd.MedComercio>
        MED.TRANSF    = REC.CONT.PROD<AbcTable.AbcParamContProd.MedTransf>

        SERV.CEDE      = REC.CONT.PROD<AbcTable.AbcParamContProd.ServCede>
        SERV.PAGARE    = REC.CONT.PROD<AbcTable.AbcParamContProd.ServPagare>
        SERV.SPEI      = REC.CONT.PROD<AbcTable.AbcParamContProd.ServSpei>

        IF MED.TARJETA EQ "S" THEN
            MED.TARJETA = "TARJETA |"
        END ELSE
            MED.TARJETA = ""
        END

        IF MED.CHEQUERA EQ "S" THEN
            MED.CHEQUERA = "CHEQUERA |"
        END ELSE
            MED.CHEQUERA = ""
        END

        IF MED.VENTANILLA EQ "S" THEN
            MED.VENTANILLA = "VENTANILLA |"
        END ELSE
            MED.VENTANILLA = ""
        END

        IF MED.CAJERO EQ "S" THEN
            MED.CAJERO = "CAJERO |"
        END ELSE
            MED.CAJERO = ""
        END

        IF MED.INTERNET EQ "S" THEN
            MED.INTERNET = "INTERNET |"
        END ELSE
            MED.INTERNET = ""
        END

        IF MED.DOMICILIA EQ "S" THEN
            MED.DOMICILIA = "DOMICILIA |"
        END ELSE
            MED.DOMICILIA = ""
        END

        IF MED.COMERCIO EQ "S" THEN
            MED.COMERCIO = "COMERCIO |"
        END ELSE
            MED.COMERCIO = ""
        END

        IF MED.TRANSF EQ "S" THEN
            MED.TRANSF = "TRANSF"
        END ELSE
            MED.TRANSF = ""
        END

        MED.DISPOSICION.AUX = MED.TARJETA : MED.CHEQUERA : MED.VENTANILLA : MED.CAJERO : MED.INTERNET : MED.DOMICILIA : MED.COMERCIO : MED.TRANSF

        MED.DISPOSICION = ""
        DISPOSICION.CONT = 0
        CHANGE "|" TO @FM IN MED.DISPOSICION.AUX
        NO.MED.DISPOSICION = DCOUNT(MED.DISPOSICION.AUX, @FM)
        FOR I.MD = 1 TO NO.MED.DISPOSICION
            IF MED.DISPOSICION.AUX<I.MD> NE '' THEN
                DISPOSICION.CONT += 1

                MED.DISPOSICION := '<MED_DISPOSICION ID="':DISPOSICION.CONT:'">':MED.DISPOSICION.AUX<I.MD>:'</MED_DISPOSICION>'

            END
        NEXT I.MD

        IF SERV.CEDE EQ "S" THEN
            SERV.CEDE = "CERTIFICADO DE DEPOSITO |"
        END ELSE
            SERV.CEDE = ""
        END

        IF SERV.PAGARE EQ "S" THEN
            SERV.PAGARE = "PAGARE |"
        END ELSE
            SERV.PAGARE = ""
        END

        IF SERV.SPEI EQ "S" THEN
            SERV.SPEI = "SPEI"
        END ELSE
            SERV.SPEI = ""
        END

        SEL.SERVICIO.AUX = SERV.CEDE : SERV.PAGARE : SERV.SPEI

        SEL.SERVICIO = ""
        SERVICIO.CONT = 0
        CHANGE "|" TO @FM IN SEL.SERVICIO.AUX
        NO.SEL.SERVICIO = DCOUNT(SEL.SERVICIO.AUX, @FM)
        FOR I.SS = 1 TO NO.SEL.SERVICIO
            IF SEL.SERVICIO.AUX<I.SS> NE '' THEN
                SERVICIO.CONT += 1
                SEL.SERVICIO := '<SERVICIO ID="':SERVICIO.CONT:'">'
                SEL.SERVICIO := '<SEL_SERVICIO>':SEL.SERVICIO.AUX<I.SS>:'</SEL_SERVICIO>'
                SEL.SERVICIO := '</SERVICIO>'
            END
        NEXT I.SS

    END

********************************************************************************
* Actividad economica Vulnerable

;*EB.DataAccess.FRead(FN.ACT.ECO,ID.ACT.ECO,REC.ACT.ECO,F.ACT.ECO,ERR.ACT.ECO)
    REC.ACT.ECO = MXBASE.CustomerRegulatory.MxbaseRegulatoryCodes.Read(ID.ACT.ECO, ERROR.ACT.ECO)
;*Y.VULNERABLE = REC.ACT.ECO<MXBASE.CustomerRegulatory.MxbaseRegulatoryCodes. ;*<AbcTable.AbcActividadEconomica.Vulnerable>

    IF TRIM(Y.VULNERABLE) NE "SI" THEN
        Y.VULNERABLE = "NO"
    END

    ACT.VULNERABLE = Y.VULNERABLE

********************************************************************************
* Numero de Empleados

    IF NUM.EMPLEADOS NE "" THEN
        ID.EB.LOOKUP = 'ABC.RANGO.EMPLEADOS*':NUM.EMPLEADOS
        EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
        IF ERROR.LOOKUP EQ '' THEN
            NUM.EMPLEADOS = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        END
    END

********************************************************************************
* Numero de Sucursales

    ERROR.LOOKUP = "" ; R.INFO.LOOKUP = "" ; NUM.DE.SUCUR = ''
    ID.EB.LOOKUP = 'ABC.RANGO.SUCURSAL*':NUM.DE.SUCUR
    EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
    IF ERROR.LOOKUP EQ '' THEN
        NUM.DE.SUCUR = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
    END

********************************************************************************
* Monto Mensual Depositos/Retiros

    Y.ID.MON.MEN = ''; REC.MON.MEN = '';
    ERROR.LOOKUP = "" ; R.INFO.LOOKUP = "" ;
    
    IF DEPOS.APRX.MEN NE "" THEN
        Y.ID.MON.MEN = DEPOS.APRX.MEN
        ID.EB.LOOKUP = 'ABC.VPM.MONTO.MENSUAL*':Y.ID.MON.MEN
        EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
        IF ERROR.LOOKUP EQ '' THEN
            DEPOS.APRX.MEN = ''
            DEPOS.APRX.MEN = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        END
    END

    Y.ID.MON.MEN = ''; REC.MON.MEN = '';
    ERROR.LOOKUP = "" ; R.INFO.LOOKUP = "" ;

    IF RETIR.APRX.MEN NE "" THEN
        Y.ID.MON.MEN = RETIR.APRX.MEN
        ID.EB.LOOKUP = 'ABC.VPM.MONTO.MENSUAL*':Y.ID.MON.MEN
        EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
        IF ERROR.LOOKUP EQ '' THEN
            RETIR.APRX.MEN = ''
            RETIR.APRX.MEN = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        END
    END

********************************************************************************
* Numero de Depositos/Retiros

    Y.ID.CAT.RAN = ''; REC.CAT.RAN = '';
    IF DEPOS.NUM.MEN NE "" THEN
        Y.ID.CAT.RAN = DEPOS.NUM.MEN
        ID.EB.LOOKUP = 'ABC.CATAG.RANGOS*':Y.ID.CAT.RAN
        EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
        IF ERROR.LOOKUP EQ '' THEN
            DEPOS.NUM.MEN = ''
            DEPOS.NUM.MEN = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        END
    END
    

    IF RETIR.NUM.MEN NE "" THEN
        Y.ID.CAT.RAN = RETIR.NUM.MEN
        ID.EB.LOOKUP = 'ABC.CATAG.RANGOS*':Y.ID.CAT.RAN
        EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
        IF ERROR.LOOKUP EQ '' THEN
            RETIR.NUM.MEN = ''
            RETIR.NUM.MEN = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        END
    END

    NOM.EMPRESA      = EREPLACE(NOM.EMPRESA,",","")
    NOMBRE.CLIENTE   = EREPLACE(NOMBRE.CLIENTE,",","")
    NOMBRE.CONYUGE   = EREPLACE(NOMBRE.CONYUGE,",","")
    RAZON.SOCIAL     = EREPLACE(RAZON.SOCIAL,",","")

    IF CLASSIFICATION GE 2014 THEN
*IF CLASSIFICATION GE 3 THEN
        Y.PROCED.REC = PROCEDENCIA.RECURSOS
        Y.OTRA.PROCED = OTRA.PROCEDENCIA
        IF PROCEDENCIA.RECURSOS EQ '' THEN
            Y.PROCED.REC = PROCED.RECURSOS
            Y.OTRA.PROCED = OTRA.PROCED
        END
    END


RETURN
***********;* LFCR_20250929_LCLFLDS S
LEE.ACCT.LCL.FLDS:
***********

    IF ID.ARRANGEMENT NE "" THEN
        EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS, ID.ARRANGEMENT, R.INFO.CUENTA.LT, F.ABC.ACCT.LCL.FLDS, ERR.ACLT)
    END

RETURN ;* LFCR_20250929_LCLFLDS E
***********  ;* LFCR_20230821_RESTRICCION S
VALIDA.TIPO.CONTRATO:
***********
    
    IF CATEGORIA.CTA MATCHES Y.CATEGS.GARAN THEN  ;* LFCR_20240319_GARANTIZADA - S
        Y.FLAG.GARANTIZADA = 1
    END   ;* LFCR_20240319_GARANTIZADA - E

    IF CLASSIFICATION EQ 1001 THEN
*IF CLASSIFICATION EQ 1 THEN
        
        Y.FLAG.NIVEL2 = '' ; Y.FLAG.NIVEL4L = '' ; Y.FLAG.REMUN = '' ; Y.FLAG.UALA = ''
        Y.NOMBRE.CONTRATO = '' ; ERROR.CONTRATO = ''
        Y.LISTA.CATS.GAT = "" ;*LFCR_20230321_GAT - S

        Y.LISTA.CATS.GAT = Y.CATEGS.REMUN

*        IF (NIVEL MATCHES Y.NIVS.N2)  AND (CATEGORIA.CTA MATCHES  Y.CATS.N2) THEN
*            Y.FLAG.NIVEL2 = 1
*            IF Y.CANAL.CTA MATCHES Y.CANALES.UALA THEN
*                Y.FLAG.UALA = 1
*            END
        IF CATEGORIA.CTA MATCHES Y.CATEGS.UALA.N2 THEN
            Y.FLAG.NIVEL2 = 1
            Y.FLAG.UALA = 1
        END

;*IF (NIVEL MATCHES Y.NIVS.N4) AND (CATEGORIA.CTA MATCHES Y.CATS.N4) THEN
        IF CATEGORIA.CTA MATCHES Y.CATEGS.UALA.N4 THEN
            Y.FLAG.NIVEL4L = 1
        END

;*IF (NIVEL MATCHES (Y.NIVS.N2:@VM:Y.NIVS.N4)) AND (CATEGORIA.CTA MATCHES Y.LISTA.CATS.GAT) AND (Y.CANAL.CTA MATCHES Y.CANALES.UALA) THEN        ;* LFCR_20230327_REMU - S
        IF CATEGORIA.CTA MATCHES Y.LISTA.CATS.GAT THEN
            Y.FLAG.REMUN = 1
        END         ;* LFCR_20230327_REMU - E
    END


RETURN          ;* LFCR_20230821_RESTRICCION E
****************
LEE.FIRMAS.AUTO:
****************
    
    LISTA.PER.AUTO = ''; LISTA.PER.AUT.NOMBRE = ''; LISTA.PER.AUT.APE.PAT = ''; LISTA.PER.AUT.APE.MAT = ''; LISTA.PER.AUT.TIP.FIR = ''; LISTA.PER.AUT.LUG.NACI = '';
    LISTA.PER.AUT.FEC.NACIM = ''; LISTA.PER.AUT.RFC = ''; LISTA.PER.AUT.NACIONA = ''; LISTA.PER.AUT.CURP = ''; LISTA.PER.AUT.TIP.IDENTI = ''; LISTA.PER.AUT.NUM.IDENTI = '';
    LISTA.PER.AUT.TELEFONO = ''; LISTA.PER.AUT.TEL.CELUL = ''; LISTA.PER.AUT.CORREO = ''; LISTA.PER.AUT.NOM.EMP = ''; LISTA.PER.AUT.PROFES = ''; LISTA.PER.AUT.OCUPAC = '';
    LISTA.PER.AUT.ACT.ECO = ''; LISTA.PER.AUT.CALLE = ''; LISTA.PER.AUT.NUM.EXT = ''; LISTA.PER.AUT.NUM.INT = ''; LISTA.PER.AUT.ESTADO = ''; LISTA.PER.AUT.MUNIC = '';
    LISTA.PER.AUT.COLONIA = ''; LISTA.PER.AUT.COD.POS = ''; LISTA.PARENT.TER.AUT = ''; LISTA.PER.AUT.PAIS.NA = ''; LISTA.PER.AUT.CD = '';
    ID.CIUDAD.COT = ''
    CIUDAD.TER = ''
    IF R.INFO.CUENTA.LT NE "" THEN
        LISTA.PER.AUTO = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutNombre>
        CONVERT @SM TO @FM IN LISTA.PER.AUTO
        TOTAL.PER.AUTO = DCOUNT(LISTA.PER.AUTO, @FM)
        IF TOTAL.PER.AUTO GT 0 THEN
            LISTA.PER.AUT.NOMBRE = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutNombre>
            LISTA.PER.AUT.APE.PAT = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutApePat>
            LISTA.PER.AUT.APE.MAT = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutApeMat>
            LISTA.PER.AUT.TIP.FIR = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutTipFir>
            LISTA.PER.AUT.PAIS.NA = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutPais>
            LISTA.PER.AUT.FEC.NACIM = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutFecNac>
            LISTA.PER.AUT.RFC = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutRfc>
            LISTA.PER.AUT.NACIONA = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutNaci>
            LISTA.PER.AUT.CURP = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutCurp>
            LISTA.PER.AUT.TIP.IDENTI = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutIdentif>
            LISTA.PER.AUT.NUM.IDENTI = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutNroIde>
            LISTA.PER.AUT.TELEFONO = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutTel>
            LISTA.PER.AUT.TEL.CELUL = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutTelCel>
            LISTA.PER.AUT.CORREO = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutEmail>
            LISTA.PER.AUT.NOM.EMP = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutNomEmp>
            LISTA.PER.AUT.PROFES = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutProPue>
            LISTA.PER.AUT.OCUPAC = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutOcuAct>
            LISTA.PER.AUT.ACT.ECO = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutActEco>
            LISTA.PER.AUT.CALLE = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutCalle>
            LISTA.PER.AUT.NUM.EXT = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutNumExt>
            LISTA.PER.AUT.NUM.INT = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutNumInt>
            LISTA.PER.AUT.ESTADO = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutEstado>
            LISTA.PER.AUT.MUNIC = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutMun>
            LISTA.PER.AUT.COLONIA = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutCol>
            LISTA.PER.AUT.COD.POS = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutCp>
            LISTA.PARENT.TER.AUT = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.ParentTerAut>
            LISTA.PER.AUT.LUG.NACI = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutPaisNa>
            LISTA.PER.AUT.CD = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutCd>


            CONVERT @SM TO @FM IN LISTA.PER.AUT.NOMBRE
            CONVERT @SM TO @FM IN LISTA.PER.AUT.APE.PAT
            CONVERT @SM TO @FM IN LISTA.PER.AUT.APE.MAT
            CONVERT @SM TO @FM IN LISTA.PER.AUT.TIP.FIR
            CONVERT @SM TO @FM IN LISTA.PER.AUT.LUG.NACI
            CONVERT @SM TO @FM IN LISTA.PER.AUT.FEC.NACIM
            CONVERT @SM TO @FM IN LISTA.PER.AUT.RFC
            CONVERT @SM TO @FM IN LISTA.PER.AUT.NACIONA
            CONVERT @SM TO @FM IN LISTA.PER.AUT.CURP
            CONVERT @SM TO @FM IN LISTA.PER.AUT.TIP.IDENTI
            CONVERT @SM TO @FM IN LISTA.PER.AUT.NUM.IDENTI
            CONVERT @SM TO @FM IN LISTA.PER.AUT.TELEFONO
            CONVERT @SM TO @FM IN LISTA.PER.AUT.TEL.CELUL
            CONVERT @SM TO @FM IN LISTA.PER.AUT.CORREO
            CONVERT @SM TO @FM IN LISTA.PER.AUT.NOM.EMP
            CONVERT @SM TO @FM IN LISTA.PER.AUT.PROFES
            CONVERT @SM TO @FM IN LISTA.PER.AUT.OCUPAC
            CONVERT @SM TO @FM IN LISTA.PER.AUT.ACT.ECO
            CONVERT @SM TO @FM IN LISTA.PER.AUT.CALLE
            CONVERT @SM TO @FM IN LISTA.PER.AUT.NUM.EXT
            CONVERT @SM TO @FM IN LISTA.PER.AUT.NUM.INT
            CONVERT @SM TO @FM IN LISTA.PER.AUT.ESTADO
            CONVERT @SM TO @FM IN LISTA.PER.AUT.MUNIC
            CONVERT @SM TO @FM IN LISTA.PER.AUT.COLONIA
            CONVERT @SM TO @FM IN LISTA.PER.AUT.COD.POS
            CONVERT @SM TO @FM IN LISTA.PARENT.TER.AUT
            CONVERT @SM TO @FM IN LISTA.PER.AUT.PAIS.NA
            CONVERT @SM TO @FM IN LISTA.PER.AUT.CD
            ID.TIPO.IDENTIF = ''
            DES.TIP.IDENT = ''
            PER.CALLE.NUM = ''
            FOR PER.AUT = 1 TO TOTAL.PER.AUTO
                PER.AUT.NOMBRE = ''; PER.AUT.APE.PAT = ''; PER.AUT.APE.MAT = ''; PER.AUT.TIP.FIR = ''; PER.AUT.LUG.NACIMTO = ''; PER.AUT.FECHA.NACIM = ''; PER.AUT.RFC = '';
                PER.AUT.NACIONALIDAD = ''; PER.AUT.CURP = ''; PER.AUT.DOMICILIO = ''; PER.AUT.TIP.FIR.CTA = ''; PER.AUT.TIP.IDENTI = ''; PER.AUT.NUM.IDENTI = ''; PER.AUT.TELEFONO = '';
                PER.AUT.TEL.CELUL = ''; PER.AUT.CORREO = ''; PER.AUT.NOM.EMP = ''; PER.AUT.PROFES = ''; PER.AUT.OCUPAC = ''; PER.AUT.ACT.ECO = ''; PER.AUT.CALLE = '';
                PER.AUT.NUM.EXT = ''; PER.AUT.NUM.INT = ''; PER.AUT.ESTADO = ''; PER.AUT.MUNIC = ''; PER.AUT.COLONIA = ''; PER.AUT.COD.POS = '';
                PER.AUT.NOMBRE.COMPLETO = ''; PER.AUT.DOMICILIO = ''; PARENT.TER.AUT = ''; PER.AUT.PAIS.NA = ''; PER.AUT.CD = '';

                PER.AUT.NOMBRE  = LISTA.PER.AUT.NOMBRE<PER.AUT>
                PER.AUT.APE.PAT = LISTA.PER.AUT.APE.PAT<PER.AUT>
                IF PER.AUT.APE.PAT EQ 'XXX' THEN
                    PER.AUT.APE.PAT = ''
                END
                PER.AUT.APE.MAT = LISTA.PER.AUT.APE.MAT<PER.AUT>
                IF PER.AUT.APE.MAT EQ 'XXX' THEN
                    PER.AUT.APE.MAT = ''
                END
                PER.AUT.NOMBRE.COMPLETO = PER.AUT.NOMBRE:' ':PER.AUT.APE.PAT:' ':PER.AUT.APE.MAT
                PER.AUT.NOMBRE.COMPLETO = TRIM(PER.AUT.NOMBRE.COMPLETO)
                PER.AUT.TIP.FIR = LISTA.PER.AUT.TIP.FIR<PER.AUT>
                ID.PAIS = LISTA.PER.AUT.LUG.NACI<PER.AUT>
                GOSUB LEE.PAIS
                PER.AUT.LUG.NACIMTO = DES.PAIS
                PER.AUT.FECHA.NACIM = LISTA.PER.AUT.FEC.NACIM<PER.AUT>
                PER.AUT.RFC = LISTA.PER.AUT.RFC<PER.AUT>
                ID.PAIS = LISTA.PER.AUT.NACIONA<PER.AUT>
                GOSUB LEE.PAIS
                PER.AUT.NACIONALIDAD = DES.PAIS
                PER.AUT.CURP = LISTA.PER.AUT.CURP<PER.AUT>

                ID.PAIS = LISTA.PER.AUT.PAIS.NA<PER.AUT>
                GOSUB LEE.PAIS
                PER.PAIS.ANEXO = DES.PAIS

                PER.AUT.TIP.IDENTI = LISTA.PER.AUT.TIP.IDENTI<PER.AUT>
                ID.TIPO.IDENTIF = PER.AUT.TIP.IDENTI
                GOSUB LEE.TIPO.IDENTIF
                DES.TIP.IDENT = DES.TIPO.IDENTIF
                PER.AUT.NUM.IDENTI = LISTA.PER.AUT.NUM.IDENTI<PER.AUT>
                PER.AUT.TELEFONO = LISTA.PER.AUT.TELEFONO<PER.AUT>
                PER.AUT.TEL.CELUL = LISTA.PER.AUT.TEL.CELUL<PER.AUT>
                PER.AUT.CORREO = LISTA.PER.AUT.CORREO<PER.AUT>
                PER.AUT.NOM.EMP = LISTA.PER.AUT.NOM.EMP<PER.AUT>
                PER.AUT.PROFES = LISTA.PER.AUT.PROFES<PER.AUT>
                ID.OCUPACION   = LISTA.PER.AUT.OCUPAC<PER.AUT>
                GOSUB LEE.OCUPACION
                PER.AUT.OCUPAC = DES.OCUPACION
                ID.ACT.ECO =  LISTA.PER.AUT.ACT.ECO<PER.AUT>
                GOSUB LEE.ACT.ECO
                PER.AUT.ACT.ECO = DES.ACT.ECO

                PER.AUT.CALLE = LISTA.PER.AUT.CALLE<PER.AUT>
                PER.AUT.NUM.EXT = LISTA.PER.AUT.NUM.EXT<PER.AUT>
                PER.AUT.NUM.INT = LISTA.PER.AUT.NUM.INT<PER.AUT>
                IF PER.AUT.NUM.EXT EQ '' THEN
                    PER.CALLE.NUM = PER.AUT.CALLE: ", No. Int. ": PER.AUT.NUM.INT
                END
                IF PER.AUT.NUM.INT EQ '' THEN
                    PER.CALLE.NUM = PER.AUT.CALLE: ", No. Ext. ": PER.AUT.NUM.EXT
                END
                IF PER.AUT.NUM.EXT NE '' AND PER.AUT.NUM.INT NE '' THEN
                    PER.CALLE.NUM = PER.AUT.CALLE: ", No. Ext. ": PER.AUT.NUM.EXT: ", No. Int. ": PER.AUT.NUM.INT
                END
                IF PER.AUT.CALLE EQ '' AND PER.AUT.NUM.EXT EQ '' AND PER.AUT.NUM.INT EQ '' THEN
                    PER.CALLE.NUM = ''
                END
                ID.ESTADO = LISTA.PER.AUT.ESTADO<PER.AUT>
                GOSUB LEE.ESTADO
                PER.AUT.ESTADO = DES.ESTADO
                ID.MUNICIPIO = LISTA.PER.AUT.MUNIC<PER.AUT>
                GOSUB LEE.MUNICIPIO
                PER.AUT.MUNIC = DES.MUNICIPIO
                ID.COLONIA = LISTA.PER.AUT.COLONIA<PER.AUT>
                GOSUB LEE.COLONIA
                PER.AUT.COLONIA = DES.COLONIA
                PER.AUT.COD.POS = LISTA.PER.AUT.COD.POS<PER.AUT>
                PER.AUT.DOMICILIO = PER.AUT.CALLE:' ':PER.AUT.NUM.EXT:' ':PER.AUT.NUM.INT:' ':PER.AUT.COLONIA:' ':PER.AUT.MUNIC:' ':PER.AUT.ESTADO:' ':PER.AUT.COD.POS
                PER.AUT.DOMICILIO = TRIM(PER.AUT.DOMICILIO)
                PARENT.TER.AUT = LISTA.PARENT.TER.AUT<PER.AUT>
                PER.AUT.PAIS.NA = LISTA.PER.AUT.PAIS.NA<PER.AUT>
                PER.AUT.CD = LISTA.PER.AUT.CD<PER.AUT>
                ID.CIUDAD.COT    = LISTA.PER.AUT.CD<PER.AUT>
                GOSUB LEE.CIUDAD
                CIUDAD.TER    = DES.CIUDAD
                SALIDA.ANEXO.TEMP =''
                SALIDA.ANEXO.TEMP = '<ANEXO ID="':CAA:'">'
                SALIDA.ANEXO.TEMP := '<TIPO_ANEXO>':"TERCEROS AUTORIZADOS":'</TIPO_ANEXO>'
                SALIDA.ANEXO.TEMP := '<NOMBRE_ANEXO>':PER.AUT.NOMBRE.COMPLETO:'</NOMBRE_ANEXO>'
                SALIDA.ANEXO.TEMP := '<LUG_NAC_ANEXO>':PER.AUT.LUG.NACIMTO:'</LUG_NAC_ANEXO>'
                SALIDA.ANEXO.TEMP := '<FEC_NAC_ANEXO>':PER.AUT.FECHA.NACIM:'</FEC_NAC_ANEXO>'
                SALIDA.ANEXO.TEMP := '<RFC_ANEXO>':PER.AUT.RFC:'</RFC_ANEXO>'
                SALIDA.ANEXO.TEMP := '<NACIONAL_ANEXO>':PER.AUT.NACIONALIDAD:'</NACIONAL_ANEXO>'
                SALIDA.ANEXO.TEMP := '<CURP_ANEXO>':PER.AUT.CURP:'</CURP_ANEXO>'
                SALIDA.ANEXO.TEMP := '<CALLE_ANEXO>':PER.CALLE.NUM:'</CALLE_ANEXO>'
                SALIDA.ANEXO.TEMP := '<NUM_EXT_ANEXO>':PER.AUT.NUM.EXT:'</NUM_EXT_ANEXO>'
                SALIDA.ANEXO.TEMP := '<NUM_INT_ANEXO>':PER.AUT.NUM.INT:'</NUM_INT_ANEXO>'
                SALIDA.ANEXO.TEMP := '<COLONIA_ANEXO>':PER.AUT.COLONIA:'</COLONIA_ANEXO>'
                SALIDA.ANEXO.TEMP := '<MUNICIPIO_ANEXO>':PER.AUT.MUNIC:'</MUNICIPIO_ANEXO>'
                SALIDA.ANEXO.TEMP := '<ESTADO_ANEXO>':PER.AUT.ESTADO:'</ESTADO_ANEXO>'
                SALIDA.ANEXO.TEMP := '<CIUDAD_ANEXO>':CIUDAD.TER:'</CIUDAD_ANEXO>'
                SALIDA.ANEXO.TEMP := '<CODIGO_POSTAL_ANEXO>':PER.AUT.COD.POS:'</CODIGO_POSTAL_ANEXO>'
                SALIDA.ANEXO.TEMP := '<PAIS_ANEXO>':PER.PAIS.ANEXO:'</PAIS_ANEXO>'
                SALIDA.ANEXO.TEMP := '<TIPO_FIR_ANEXO>':PER.AUT.TIP.FIR:'</TIPO_FIR_ANEXO>'
                SALIDA.ANEXO.TEMP := '<TIPO_IDEN_ANEXO>':DES.TIP.IDENT:'</TIPO_IDEN_ANEXO>'
                SALIDA.ANEXO.TEMP := '<NUM_IDEN_ANEXO>':PER.AUT.NUM.IDENTI:'</NUM_IDEN_ANEXO>'
                SALIDA.ANEXO.TEMP := '<TELEFONO_ANEXO>':PER.AUT.TELEFONO:'</TELEFONO_ANEXO>'
                SALIDA.ANEXO.TEMP := '<CELULAR_ANEXO>':PER.AUT.TEL.CELUL:'</CELULAR_ANEXO>'
                SALIDA.ANEXO.TEMP := '<CORREO_ANEXO>':PER.AUT.CORREO:'</CORREO_ANEXO>'
                SALIDA.ANEXO.TEMP := '<NOM_EMP_ANEXO>':PER.AUT.NOM.EMP:'</NOM_EMP_ANEXO>'
                SALIDA.ANEXO.TEMP := '<PUESTO_ANEXO>':PER.AUT.PROFES:'</PUESTO_ANEXO>'
                SALIDA.ANEXO.TEMP := '<ACT_ECO_ANEXO>':PER.AUT.ACT.ECO:'</ACT_ECO_ANEXO>'
                SALIDA.ANEXO.TEMP := '<NUMERO_RECA>':Y.NUMERO.RECA:'</NUMERO_RECA>'

                IF PER.AUT.CORREO AND CDIF LE 2 THEN  ;**CCBC_20180522**
                    Y.CORREO.FID     := '<CORREO_FIDU_':CDIF:'>':PER.AUT.CORREO:'</CORREO_FIDU_':CDIF:'>'
                    CDIF +=1
                END
                SALIDA.ANEXO.TEMP := '</ANEXO>'

                SALIDA.ANEXO.A := SALIDA.ANEXO.TEMP

                CAA += 1

                FACULTADOS := '<PERSONA_FACULTADA ID="':CFA:'">'
                FACULTADOS := '<NOMBRE_FACU>':PER.AUT.NOMBRE.COMPLETO:'</NOMBRE_FACU>'
                FACULTADOS := '<RELACION_FACU>':PARENT.TER.AUT:'</RELACION_FACU>'
                FACULTADOS := '<TIPO_FACU>':'TERCEROS AUTORIZADOS':'</TIPO_FACU>'
                FACULTADOS := '</PERSONA_FACULTADA>'

                REG.FIRMAS.TEMP := '<NOMBRE_COMPLETO_FIRMANTE_':CFA:'>':PER.AUT.NOMBRE.COMPLETO:'</NOMBRE_COMPLETO_FIRMANTE_':CFA:'>'
                REG.FIRMAS.TEMP := '<TIPO_FIR_':CFA:'>':PER.AUT.TIP.FIR:'</TIPO_FIR_':CFA:'>'
                CFA += 1
            NEXT PER.AUT
        END
    END

RETURN
**************
LEE.PER.FACUL:
**************
    
    LISTA.NUM.ESCR = "" ; LISTA.NO.NOTARIO = "" ; LISTA.NOM.NOTARIO = "" ; LISTA.ENT.NOTARIO = "" ; LISTA.FEC.INSCR = "" ; LISTA.LUGAR.INSCR = ""
    LISTA.REG.PUB = "" ; LISTA.NOMBRE = "" ; LISTA.A.PATER = "" ; LISTA.A.MATER = "" ; LISTA.FEC.NAC = "" ; LISTA.RFC = "" ; LISTA.NACIONA = ""
    LISTA.LUG.NACI = "" ; LISTA.TELEFONO = "" ; LISTA.CORREO = "" ; LISTA.CURP = "" ; LISTA.IDENTIFICA = "" ; LISTA.NO.IDENT = ""
    TOTAL.APOD.LEGA = "" ; LISTA.TIPO.FIRMA = "" ; LISTA.TEL.CEL = "" ; LISTA.PUESTO = "" ; LISTA.FACU.NOM.NOTAR = ""

    IF R.INFO.CUENTA.LT NE "" THEN
        LISTA.NUM.ESCR    = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuNumEscCo>
        CONVERT @SM TO @FM IN LISTA.NUM.ESCR
        LISTA.FECHA.ESCR  = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuFecEscCo>
        CONVERT @SM TO @FM IN LISTA.FECHA.ESCR
        LISTA.NO.NOTARIO  = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuNumNotar>
        CONVERT @SM TO @FM IN LISTA.NO.NOTARIO
        LISTA.NOM.NOTARIO  = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuNomNotar>
        CONVERT @SM TO @FM IN LISTA.NOM.NOTARIO
        LISTA.ENT.NOTARIO = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuEntNotar>
        CONVERT @SM TO @FM IN LISTA.ENT.NOTARIO
        LISTA.FEC.INSCR   = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuFecReg>
        CONVERT @SM TO @FM IN LISTA.FEC.INSCR
        LISTA.LUGAR.INSCR = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuEntReg>
        CONVERT @SM TO @FM IN LISTA.LUGAR.INSCR
        LISTA.REG.PUB     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuNumReg>
        CONVERT @SM TO @FM IN LISTA.REG.PUB
        LISTA.NOMBRE      = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuNombre>
        CONVERT @SM TO @FM IN LISTA.NOMBRE
        LISTA.A.PATER     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuApePatern>
        CONVERT @SM TO @FM IN LISTA.A.PATER
        LISTA.A.MATER     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuApeMatern>
        CONVERT @SM TO @FM IN LISTA.A.MATER
        LISTA.FEC.NAC     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuFecNac>
        CONVERT @SM TO @FM IN LISTA.FEC.NAC
        LISTA.RFC         = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuRfcReg>
        CONVERT @SM TO @FM IN LISTA.RFC
        LISTA.NACIONA     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuNaciReg>
        CONVERT @SM TO @FM IN LISTA.NACIONA
        LISTA.LUG.NACI    = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuPaisNac>
        CONVERT @SM TO @FM IN LISTA.LUG.NACI
        LISTA.TELEFONO    = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuTel>
        CONVERT @SM TO @FM IN LISTA.TELEFONO
        LISTA.CORREO      = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuEmail>
        CONVERT @SM TO @FM IN LISTA.CORREO
        LISTA.CURP        = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuCurpReg>
        CONVERT @SM TO @FM IN LISTA.CURP
        LISTA.IDENTIFICA  = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuIndetifica>
        CONVERT @SM TO @FM IN LISTA.IDENTIFICA
        LISTA.NO.IDENT    = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuNroIdenti>
        CONVERT @SM TO @FM IN LISTA.NO.IDENT
        LISTA.TIPO.FIRMA  = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuTipoFirma>
        CONVERT @SM TO @FM IN LISTA.TIPO.FIRMA
        LISTA.TEL.CEL     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuTelCel>
        CONVERT @SM TO @FM IN LISTA.TEL.CEL
        LISTA.PUESTO     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuStatus>
        CONVERT @SM TO @FM IN LISTA.PUESTO
        LISTA.FACU.NOM.NOTAR= R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuNomNotar>
        CONVERT @SM TO @FM IN LISTA.FACU.NOM.NOTAR
    END
    


    TOTAL.APOD.LEGA = DCOUNT(LISTA.NOMBRE, @FM)
    IF TOTAL.APOD.LEGA GT 0 THEN
        FOR FACU = 1 TO TOTAL.APOD.LEGA
            NUME.ESCRI = ""      ; FECHA.ESCRI = ""        ; NUM.NOTARIO = ""    ; NOMBRE.NOTARIO = "" ; ENT.NOTARIO = ""  ;
            FECHA.INSCR = ""     ; LUGAR.INSCR = ""        ; NUM.REG.PUB = ""    ; NOMBRE.FACU = ""    ; A.PATER.FACU = "" ;
            A.MATER.FACU = ""    ; NOMBRE.FACULTADO = ""   ; FECHA.NAC.FACU = "" ; RFC.FACULT = ""     ; NACIONALIDAD.FACU = "" ;
            LUG.NACIM.FACU = ""  ; TELEFONO.FACU = ""      ; CORREO.FACU = ""    ; CURP.FACU = ""      ; IDENTIFICA.FACU = "" ;
            NO.IDENT.FACU = ""   ; TIPO.FIRMA.FACU = ""    ; TEL.CEL.FACU = ""   ; PUESTO.FACU = ""    ; NOM.NOTAR.FACU = "" ;
            ID.TIPO.IDENTIF = '' ; DES.TIP.IDENT.FACU = ""

            NUME.ESCRI         = LISTA.NUM.ESCR<FACU>
            FECHA.ESCRI        = LISTA.FECHA.ESCR<FACU>
            NUM.NOTARIO        = LISTA.NO.NOTARIO<FACU>
            NOMBRE.NOTARIO     = LISTA.NOM.NOTARIO<FACU>
            ID.ESTADO          = LISTA.ENT.NOTARIO<FACU>
            GOSUB LEE.ESTADO
            ENT.NOTARIO        = DES.ESTADO
            FECHA.INSCR        = LISTA.FEC.INSCR<FACU>
            ID.ESTADO          = LISTA.LUGAR.INSCR<FACU>
            GOSUB LEE.ESTADO
            LUGAR.INSCR        = DES.ESTADO
            NUM.REG.PUB        = LISTA.REG.PUB<FACU>
            NOMBRE.FACU        = LISTA.NOMBRE<FACU>
            A.PATER.FACU       = LISTA.A.PATER<FACU>
            IF A.PATER.FACU EQ 'XXX' THEN
                A.PATER.FACU = ''
            END
            A.MATER.FACU       = LISTA.A.MATER<FACU>
            IF A.MATER.FACU EQ 'XXX' THEN
                A.MATER.FACU = ''
            END
            NOMBRE.FACULTADO   = TRIM(NOMBRE.FACU:' ':A.PATER.FACU:' ':A.MATER.FACU)
            FECHA.NAC.FACU     = LISTA.FEC.NAC<FACU>
            RFC.FACULT         = LISTA.RFC<FACU>
            ID.PAIS = LISTA.NACIONA<FACU>
            GOSUB LEE.PAIS
            NACIONALIDAD.FACU  = DES.PAIS
            ID.PAIS = LISTA.LUG.NACI<FACU>
            GOSUB LEE.PAIS
            LUG.NACIM.FACU     = DES.PAIS
            TELEFONO.FACU      = LISTA.TELEFONO<FACU>
            CORREO.FACU        = LISTA.CORREO<FACU>
            CURP.FACU          = LISTA.CURP<FACU>
            IDENTIFICA.FACU    = LISTA.IDENTIFICA<FACU>
            ID.TIPO.IDENTIF = IDENTIFICA.FACU
            GOSUB LEE.TIPO.IDENTIF
            DES.TIP.IDENT.FACU = DES.TIPO.IDENTIF
            NO.IDENT.FACU      = LISTA.NO.IDENT<FACU>
            TIPO.FIRMA.FACU    = LISTA.TIPO.FIRMA<FACU>
            TEL.CEL.FACU       = LISTA.TEL.CEL<FACU>
            PUESTO.FACU        = LISTA.PUESTO<FACU>
            NUM.ID.FISCAL.FACU = ""
            RESIDEN.FACU       = ""
            SEXO.FACU          = ""
            DOMICILIO.FACU     = ""
            DOMICILIO.2.FACU   = ""
            ESTADO.CIVIL.FACU  = ""
            NUM.REG.NOTA       = ""
            TOMO.LIB.FACU      = ""
            NOM.NOTAR.FACU      = LISTA.FACU.NOM.NOTAR<FACU>

****************AGREGAR A LA VARIABLE SALIDA.ANEXO.A LOS DATOS DE APODERADO**************++
            SALIDA.ANEXO.TEMP =''
            SALIDA.ANEXO.TEMP = '<ANEXO ID="':CAA:'">'
            SALIDA.ANEXO.TEMP := '<TIPO_ANEXO>':"APODERADO":'</TIPO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NOMBRE_ANEXO>':NOMBRE.FACULTADO:'</NOMBRE_ANEXO>'
            SALIDA.ANEXO.TEMP := '<LUG_NAC_ANEXO>':LUG.NACIM.FACU:'</LUG_NAC_ANEXO>'
            SALIDA.ANEXO.TEMP := '<FEC_NAC_ANEXO>':FECHA.NAC.FACU:'</FEC_NAC_ANEXO>'
            SALIDA.ANEXO.TEMP := '<RFC_ANEXO>':RFC.FACULT:'</RFC_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NACIONAL_ANEXO>':NACIONALIDAD.FACU:'</NACIONAL_ANEXO>'
            SALIDA.ANEXO.TEMP := '<CURP_ANEXO>':CURP.FACU:'</CURP_ANEXO>'
            SALIDA.ANEXO.TEMP := '<CALLE_ANEXO>'::'</CALLE_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NUM_EXT_ANEXO>'::'</NUM_EXT_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NUM_INT_ANEXO>'::'</NUM_INT_ANEXO>'
            SALIDA.ANEXO.TEMP := '<COLONIA_ANEXO>'::'</COLONIA_ANEXO>'
            SALIDA.ANEXO.TEMP := '<MUNICIPIO_ANEXO>'::'</MUNICIPIO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<ESTADO_ANEXO>'::'</ESTADO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<CIUDAD_ANEXO>'::'</CIUDAD_ANEXO>'
            SALIDA.ANEXO.TEMP := '<PAIS_ANEXO>'::'</PAIS_ANEXO>'
            SALIDA.ANEXO.TEMP := '<TIPO_FIR_ANEXO>':TIPO.FIRMA.FACU:'</TIPO_FIR_ANEXO>'
            SALIDA.ANEXO.TEMP := '<TIPO_IDEN_ANEXO>':DES.TIP.IDENT.FACU:'</TIPO_IDEN_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NUM_IDEN_ANEXO>':NO.IDENT.FACU:'</NUM_IDEN_ANEXO>'
            SALIDA.ANEXO.TEMP := '<TELEFONO_ANEXO>':TELEFONO.FACU:'</TELEFONO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<CELULAR_ANEXO>':TEL.CEL.FACU:'</CELULAR_ANEXO>'
            SALIDA.ANEXO.TEMP := '<CORREO_ANEXO>':CORREO.FACU:'</CORREO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NOM_EMP_ANEXO>'::'</NOM_EMP_ANEXO>'
            SALIDA.ANEXO.TEMP := '<PUESTO_ANEXO>':PUESTO.FACU:'</PUESTO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<ACT_ECO_ANEXO>'::'</ACT_ECO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<ESCRITURA_NUM_ANEXO>':NUME.ESCRI:'</ESCRITURA_NUM_ANEXO>'
            SALIDA.ANEXO.TEMP := '<FECHA_ESCRITURA_ANEXO>':FECHA.ESCRI:'</FECHA_ESCRITURA_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NOMBRE_NOTARIO_ANEXO>':NOMBRE.NOTARIO:'</NOMBRE_NOTARIO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NUMERO_NOTARIO_ANEXO>':NUM.NOTARIO:'</NUMERO_NOTARIO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<CIUDAD_NOTARIO_ANEXO>':ENT.NOTARIO:'</CIUDAD_NOTARIO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<FECHA_INSC_RPC_ANEXO>':FECHA.INSCR:'</FECHA_INSC_RPC_ANEXO>'
            SALIDA.ANEXO.TEMP := '<LUGAR_INSC_RPC_ANEXO>':LUGAR.INSCR:'</LUGAR_INSC_RPC_ANEXO>'
            SALIDA.ANEXO.TEMP := '<FOLIO_MERC_RPC_ANEXO>'::'</FOLIO_MERC_RPC_ANEXO>'
            SALIDA.ANEXO.TEMP := '<TOMO_RPC_ANEXO>':NUM.REG.PUB:'</TOMO_RPC_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NUMERO_RECA>':Y.NUMERO.RECA:'</NUMERO_RECA>'
            SALIDA.ANEXO.TEMP := '</ANEXO>'

            SALIDA.ANEXO.A := SALIDA.ANEXO.TEMP

            CAA += 1

            FACULTADOS := '<PERSONA_FACULTADA ID="':CFA:'">'
            FACULTADOS := '<NOMBRE_FACU>':NOMBRE.FACULTADO:'</NOMBRE_FACU>'
            FACULTADOS := '<RELACION_FACU>':PUESTO.FACU:'</RELACION_FACU>'
            FACULTADOS := '<TIPO_FACU>':'APODERADO':'</TIPO_FACU>'
            FACULTADOS := '</PERSONA_FACULTADA>'
********************************************************************************************ROHH_20180906 extrae solo valores necesarios para alta de banca electronica
            Y.UNICO.FACULTADO    = ''
            REPRESENTANTE_LEGAL := '<REPRESENTANTE_LEGAL ID="':CFA:'">'
            REPRESENTANTE_LEGAL := '<NOMBRE_FACU>':NOMBRE.FACULTADO:'</NOMBRE_FACU>'
            REPRESENTANTE_LEGAL := '<TIPO_FIR>':TIPO.FIRMA.FACU:'</TIPO_FIR>'
            REPRESENTANTE_LEGAL := '</REPRESENTANTE_LEGAL>'
            IF TOTAL.APOD.LEGA EQ 1 THEN
                Y.UNICO.FACULTADO = NOMBRE.FACULTADO        ;**************************************Extrae e imprime en formato de banca electronica al representante legal, si solo existe uno, de existir mas no imprime ninguno
            END
********************************************************************************************para personas morales y fisicas con actividad empresarial.

            Y.NOM.REL.FID := '<RELACION_FIDE>':PUESTO.FACU:'</RELACION_FIDE>'   ;**CCBC_20180522**
            Y.NOM.REL.FID := '<NOMBRE_FIDE>':NOMBRE.FACULTADO:'</NOMBRE_FIDE>'
            Y.NOM.REL.FID := '<NUM_ESCRITURA_FID>':NUME.ESCRI:'</NUM_ESCRITURA_FID>'      ;**CCBC_20180522**
            REG.FIRMAS.TEMP := '<NOMBRE_COMPLETO_FIRMANTE_':CFA:'>':NOMBRE.FACULTADO:'</NOMBRE_COMPLETO_FIRMANTE_':CFA:'>'
            REG.FIRMAS.TEMP := '<TIPO_FIR_':CFA:'>':TIPO.FIRMA.FACU:'</TIPO_FIR_':CFA:'>'

            CFA += 1
        NEXT FACU
    END

RETURN

**************
LEE.COTITULARES:
**************

    COT.AP.PARETNO = "" ; COT.AP.MATERNO = "" ; COT.NOMBRES = "" ; COT.ASIG.INT = "" ; TOTAL.COTITULAR = "";
    COT.PAIS.NAC = ""   ; COT.FECHA.NAC = ""  ; COT.RFC = ""     ; COT.NACIONAL = "" ; COT.CURP = ""       ;
    COT.CALLE = ""      ; COT.NUM.EXT = ""    ; COT.NUM.INT = "" ; COT.ESTADO = ""   ; COT.MUNICIPIO = ""  ;
    COT.COLONIA = ""    ; COT.CIUDAD = ""     ; COT.COD.POT = "" ; COT.PAIS = ""     ; COT.INDENTI = ""    ;
    COT.NRO.IDENT = ""  ; COT.TEL = ""        ; COT.TEL.CEL = "" ; COT.EMAIL = ""    ; COT.ACT.ECO = ""    ;
    COT.NOM.EMP = ""    ; COT.PROF.PUES = ""  ; COT.TIPO.FIR = "";
    PARENTESCO.COT = "" ; COT.OCUP.ACT = ""   ;

    IF R.INFO.CUENTA.LT NE "" THEN
        COT.ASIG.INT   = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.AsigIntCoti>
        CONVERT @SM TO @FM IN COT.ASIG.INT
        PARENTESCO.COT = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.ParentescoCoti>
        CONVERT @SM TO @FM IN PARENTESCO.COT
        COT.TIPO.FIR   = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.TipoFirmaCoti>
        CONVERT @SM TO @FM IN COT.TIPO.FIR
*LFCR_20221108-S
        Y.IDS.COTITULARES = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.IdCoti>
        CONVERT @SM TO @FM IN Y.IDS.COTITULARES
        TOTAL.COTITULAR = DCOUNT(Y.IDS.COTITULARES, @FM)
        FOR Y.ITER.COT = 1 TO TOTAL.COTITULAR
            Y.ID.COTITULAR = ""
            Y.ID.COTITULAR = Y.IDS.COTITULARES<Y.ITER.COT>
            GOSUB LEE.COTITULAR.CUSTOMER
        NEXT Y.ITER.COT
*LFCR_20221108-E
    END

    IF TOTAL.COTITULAR GT 0 THEN
        FOR CT = 1 TO TOTAL.COTITULAR
            ID.TIPO.IDENTIF = ''
            DES.TIP.IDENT.COT = ''
            CALLE.COT.NUM = ''
            AP.PART.COT = ''; AP.MATE.COT = ''; NOMBRES.COT = ''; NOMBRE.COMPLETO.COT = ''; PORCENT.COT = '';
            AP.PART.COT = COT.AP.PARETNO<CT>
            IF AP.PART.COT EQ 'XXX' THEN
                AP.PART.COT = ''
            END
            AP.MATE.COT = COT.AP.MATERNO<CT>
            IF AP.MATE.COT EQ 'XXX' THEN
                AP.MATE.COT = ''
            END
            NOMBRES.COT = COT.NOMBRES<CT>
            NOMBRE.COMPLETO.COT = TRIM(NOMBRES.COT:' ':AP.PART.COT:' ':AP.MATE.COT)
            PORCENT.COT = COT.ASIG.INT<CT>
            ID.PAIS = COT.PAIS.NAC<CT>
            GOSUB LEE.PAIS
            PAIS.NAC.COT  = DES.PAIS
            FECHA.NAC.COT = COT.FECHA.NAC<CT>
            RFC.COT       = COT.RFC<CT>
            ID.PAIS = COT.NACIONAL<CT>
            GOSUB LEE.PAIS
            NACIONAL.COT  = DES.PAIS
            CURP.COT      = COT.CURP<CT>
            CALLE.COT     = COT.CALLE<CT>
            NUEM.EXT.COT  = COT.NUM.EXT<CT>
            NUM.INT.COT   = COT.NUM.INT<CT>
            IF NUEM.EXT.COT EQ '' THEN
                CALLE.COT.NUM = CALLE.COT: ", No. Int. ": NUM.INT.COT
            END
            IF NUM.INT.COT EQ '' THEN
                CALLE.COT.NUM = CALLE.COT: ", No. Ext. ": NUEM.EXT.COT
            END
            IF NUEM.EXT.COT NE '' AND NUM.INT.COT NE '' THEN
                CALLE.COT.NUM = CALLE.COT: ", No. Ext. ": NUEM.EXT.COT: ", No. Int. ": NUM.INT.COT
            END
            IF CALLE.COT EQ '' AND NUEM.EXT.COT EQ '' AND NUM.INT.COT EQ '' THEN
                CALLE.COT.NUM = ''
            END
            ID.ESTADO     = COT.ESTADO<CT>
            GOSUB LEE.ESTADO
            ESTADOS.COT   = DES.ESTADO
            ID.MUNICIPIO  = COT.MUNICIPIO<CT>
            GOSUB LEE.MUNICIPIO
            MUNICIPIO.COT = DES.MUNICIPIO
            ID.COLONIA    = COT.COLONIA<CT>
            GOSUB LEE.COLONIA
            COLONIA.COT   = DES.COLONIA
            ID.CIUDAD.COT    = COT.CIUDAD<CT>
            GOSUB LEE.CIUDAD
            CIUDAD.COT    = DES.CIUDAD
            COD.POT.CT    = COT.COD.POT<CT>

            ID.PAIS     = COT.PAIS<CT>
            GOSUB LEE.PAIS
            PAIS.COT = DES.PAIS
            DOMICILIO.COTITULAR = TRIM(CALLE.COT:' ':NUEM.EXT.COT:' ':NUM.INT.COT:' ':COLONIA.COT:' ':MUNICIPIO.COT:' ':CIUDAD.COT:' ':ESTADOS.COT:' ':COD.POT.CT:' ':PAIS.COT)
            TIPO.INDE.COT = COT.INDENTI<CT>
            ID.TIPO.IDENTIF = TIPO.INDE.COT
            GOSUB LEE.TIPO.IDENTIF
            DES.TIP.IDENT.COT = DES.TIPO.IDENTIF
            NUM.INDEN.COT = COT.NRO.IDENT<CT>
            TEL.COT       = COT.TEL<CT>
            TEL.CEL.COT   = COT.TEL.CEL<CT>
            CORREO.COT    = COT.EMAIL<CT>
            ID.ACT.ECO    = COT.ACT.ECO<CT>
            GOSUB LEE.ACT.ECO
            ACT.ECO.COT   = DES.ACT.ECO
            NOM.EMP.COT   = COT.NOM.EMP<CT>
            PROF.PUES.COT = COT.PROF.PUES<CT>
            TIPO.FIR      = COT.TIPO.FIR<CT>
            COT.PARENTESCO= PARENTESCO.COT<CT>
            OCUP.ACT.COT  = COT.OCUP.ACT<CT>
            FIRMA.ELE.COT = '';

            SALIDA.ANEXO.TEMP =''
            SALIDA.ANEXO.TEMP = '<ANEXO ID="':CAA:'">'
            SALIDA.ANEXO.TEMP := '<TIPO_ANEXO>':"COTITULAR":'</TIPO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NOMBRE_ANEXO>':NOMBRE.COMPLETO.COT:'</NOMBRE_ANEXO>'
            SALIDA.ANEXO.TEMP := '<PORC_ANEX_COT>':PORCENT.COT:'</PORC_ANEX_COT>'
            SALIDA.ANEXO.TEMP := '<LUG_NAC_ANEXO>':PAIS.NAC.COT:'</LUG_NAC_ANEXO>'        ;*ROHH_20181224
            SALIDA.ANEXO.TEMP := '<EDO_CIVIL_ANEXO>'::'</EDO_CIVIL_ANEXO>'
            SALIDA.ANEXO.TEMP := '<FEC_NAC_ANEXO>':FECHA.NAC.COT:'</FEC_NAC_ANEXO>'
            SALIDA.ANEXO.TEMP := '<RFC_ANEXO>':RFC.COT:'</RFC_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NACIONAL_ANEXO>':NACIONAL.COT:'</NACIONAL_ANEXO>'
            SALIDA.ANEXO.TEMP := '<CURP_ANEXO>':CURP.COT:'</CURP_ANEXO>'
            SALIDA.ANEXO.TEMP := '<CALLE_ANEXO>':CALLE.COT.NUM:'</CALLE_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NUM_EXT_ANEXO>':NUEM.EXT.COT:'</NUM_EXT_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NUM_INT_ANEXO>':NUM.INT.COT:'</NUM_INT_ANEXO>'
            SALIDA.ANEXO.TEMP := '<COLONIA_ANEXO>':COLONIA.COT:'</COLONIA_ANEXO>'
            SALIDA.ANEXO.TEMP := '<MUNICIPIO_ANEXO>':MUNICIPIO.COT:'</MUNICIPIO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<ESTADO_ANEXO>':ESTADOS.COT:'</ESTADO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<CIUDAD_ANEXO>':CIUDAD.COT:'</CIUDAD_ANEXO>'
            SALIDA.ANEXO.TEMP := '<CODIGO_POSTAL_ANEXO>':COD.POT.CT:'</CODIGO_POSTAL_ANEXO>'
            SALIDA.ANEXO.TEMP := '<PAIS_ANEXO>':PAIS.COT:'</PAIS_ANEXO>'
            SALIDA.ANEXO.TEMP := '<TIPO_FIR_ANEXO>':TIPO.FIR:'</TIPO_FIR_ANEXO>'
            SALIDA.ANEXO.TEMP := '<TIPO_IDEN_ANEXO>':DES.TIP.IDENT.COT:'</TIPO_IDEN_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NUM_IDEN_ANEXO>':NUM.INDEN.COT:'</NUM_IDEN_ANEXO>'
            SALIDA.ANEXO.TEMP := '<TELEFONO_ANEXO>':TEL.COT:'</TELEFONO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<CELULAR_ANEXO>':TEL.CEL.COT:'</CELULAR_ANEXO>'
            SALIDA.ANEXO.TEMP := '<CORREO_ANEXO>':CORREO.COT:'</CORREO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NOM_EMP_ANEXO>':NOM.EMP.COT:'</NOM_EMP_ANEXO>'
            SALIDA.ANEXO.TEMP := '<PUESTO_ANEXO>':PROF.PUES.COT:'</PUESTO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<ACT_ECO_ANEXO>':ACT.ECO.COT:'</ACT_ECO_ANEXO>'
            SALIDA.ANEXO.TEMP := '<NUMERO_RECA>':Y.NUMERO.RECA:'</NUMERO_RECA>'
            SALIDA.ANEXO.TEMP := '</ANEXO>'

            SALIDA.ANEXO.A := SALIDA.ANEXO.TEMP

            CAA += 1

            SALIDA.CONTITULAR.TEMP = ''
            SALIDA.CONTITULAR.TEMP = '<COTITULAR ID="':CT:'">'
            SALIDA.CONTITULAR.TEMP := '<NOMBRE_COMPLETO_COT>':NOMBRE.COMPLETO.COT:'</NOMBRE_COMPLETO_COT>'
            SALIDA.CONTITULAR.TEMP := '<COT_PARENTESCO>':COT.PARENTESCO:'</COT_PARENTESCO>'
            SALIDA.CONTITULAR.TEMP := '<RFC_COT>':RFC.COT:'</RFC_COT>'
            SALIDA.CONTITULAR.TEMP := '<FECHA_NAC_COT>':FECHA.NAC.COT:'</FECHA_NAC_COT>'
            SALIDA.CONTITULAR.TEMP := '<PORCENT_COT>':PORCENT.COT:'</PORCENT_COT>'
            SALIDA.CONTITULAR.TEMP := '<CURP_COT>':CURP.COT:'</CURP_COT>'
            SALIDA.CONTITULAR.TEMP := '<TIPO_INDE_COT>':TIPO.INDE.COT:'</TIPO_INDE_COT>'
            SALIDA.CONTITULAR.TEMP := '<NUM_INDEN_COT>':NUM.INDEN.COT:'</NUM_INDEN_COT>'
            SALIDA.CONTITULAR.TEMP := '<TIPO_FIR>':TIPO.FIR:'</TIPO_FIR>'
            SALIDA.CONTITULAR.TEMP := '<PAIS_NAC_COT>':PAIS.NAC.COT:'</PAIS_NAC_COT>'
            SALIDA.CONTITULAR.TEMP := '<NACIONAL_COT>':NACIONAL.COT:'</NACIONAL_COT>'
            SALIDA.CONTITULAR.TEMP := '<DOMICILIO_COTITULAR>':DOMICILIO.COTITULAR:'</DOMICILIO_COTITULAR>'
            SALIDA.CONTITULAR.TEMP := '<TEL_COT>':TEL.COT:'</TEL_COT>'
            SALIDA.CONTITULAR.TEMP := '<TEL_CEL_COT>':TEL.CEL.COT:'</TEL_CEL_COT>'
            SALIDA.CONTITULAR.TEMP := '<CORREO_COT>':CORREO.COT:'</CORREO_COT>'
            SALIDA.CONTITULAR.TEMP := '<NOM_EMP_COT>':NOM.EMP.COT:'</NOM_EMP_COT>'
            SALIDA.CONTITULAR.TEMP := '<PROF_PUES_COT>':PROF.PUES.COT:'</PROF_PUES_COT>'
            SALIDA.CONTITULAR.TEMP := '<OCUP_ACT_COT>':OCUP.ACT.COT:'</OCUP_ACT_COT>'
            SALIDA.CONTITULAR.TEMP := '<ACT_ECO_COT>':ACT.ECO.COT:'</ACT_ECO_COT>'
            SALIDA.CONTITULAR.TEMP := '</COTITULAR>'

            SALIDA.CONTITULAR := SALIDA.CONTITULAR.TEMP

            FACULTADOS := '<PERSONA_FACULTADA ID="':CFA:'">'
            FACULTADOS := '<NOMBRE_FACU>':NOMBRE.COMPLETO.COT:'</NOMBRE_FACU>'
            FACULTADOS := '<RELACION_FACU>':COT.PARENTESCO:'</RELACION_FACU>'
            FACULTADOS := '<PORC_COT>':PORCENT.COT:'</PORC_COT>'      ;*LFCR_20210817
            FACULTADOS := '<TIPO_FACU>':'COTITULAR':'</TIPO_FACU>'
            FACULTADOS := '</PERSONA_FACULTADA>'

            REG.FIRMAS.TEMP := '<NOMBRE_COMPLETO_FIRMANTE_':CFA:'>':NOMBRE.COMPLETO.COT:'</NOMBRE_COMPLETO_FIRMANTE_':CFA:'>'
            REG.FIRMAS.TEMP := '<TIPO_FIR_':CFA:'>':TIPO.FIR:'</TIPO_FIR_':CFA:'>'

            CFA += 1
        NEXT CT
    END

RETURN

*************LFCR_20221108-S
LEE.COTITULAR.CUSTOMER:
************

    REG.COTITULAR = ""
    REG.COTITULAR = ST.Customer.Customer.Read(Y.ID.COTITULAR, ERR.CLIENTE)
    R.INFO.CLIENTE.MXBASE.COTITULAR = MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Read(Y.ID.COTITULAR, ERR.CLIENTE)

    COT.AP.PARETNO<-1> = REG.COTITULAR<ST.Customer.Customer.EbCusShortName>
    COT.AP.MATERNO<-1> = REG.COTITULAR<ST.Customer.Customer.EbCusNameOne>
    COT.NOMBRES<-1>    = REG.COTITULAR<ST.Customer.Customer.EbCusNameTwo>
    COT.PAIS.NAC<-1>   = REG.COTITULAR<ST.Customer.Customer.EbCusOtherNationality>
    COT.FECHA.NAC<-1>  = REG.COTITULAR<ST.Customer.Customer.EbCusDateOfBirth>
    COT.RFC<-1>        = TRIM(REG.COTITULAR<ST.Customer.Customer.EbCusTaxId,1>)
    COT.NACIONAL<-1>   = REG.COTITULAR<ST.Customer.Customer.EbCusNationality>
    COT.CURP<-1>       = REG.COTITULAR<ST.Customer.Customer.EbCusExternCusId>
    COT.CALLE<-1>      = REG.COTITULAR<ST.Customer.Customer.EbCusStreet>
    COT.NUM.EXT<-1>    = FIELD(REG.COTITULAR<ST.Customer.Customer.EbCusAddress>,@SM,1)
    COT.NUM.INT<-1>    = FIELD(REG.COTITULAR<ST.Customer.Customer.EbCusAddress>,@SM,2)
    COT.ESTADO<-1>     = REG.COTITULAR<ST.Customer.Customer.EbCusCountrySubdivision>
    COT.MUNICIPIO<-1>  = REG.COTITULAR<ST.Customer.Customer.EbCusDepartment>
    COT.COLONIA<-1>    = REG.COTITULAR<ST.Customer.Customer.EbCusSubDepartment>
    COT.CIUDAD<-1>     = TRIM(REG.COTITULAR<ST.Customer.Customer.EbCusTownCountry,1>)
    COT.COD.POT<-1>    = REG.COTITULAR<ST.Customer.Customer.EbCusPostCode>
    COT.PAIS<-1>       = REG.COTITULAR<ST.Customer.Customer.EbCusCountry>
    COT.INDENTI<-1>    = REG.COTITULAR<ST.Customer.Customer.EbCusLegalDocName>
    COT.NRO.IDENT<-1>  = REG.COTITULAR<ST.Customer.Customer.EbCusLegalId>
    COT.TEL<-1>        = REG.COTITULAR<ST.Customer.Customer.EbCusPhoneOne>
    COT.TEL.CEL<-1>    = REG.COTITULAR<ST.Customer.Customer.EbCusSmsOne>
    COT.EMAIL<-1>      = REG.COTITULAR<ST.Customer.Customer.EbCusEmailOne>
    COT.ACT.ECO<-1>    = R.INFO.CLIENTE.MXBASE.COTITULAR<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.BanxicoEcoActivity>
    COT.NOM.EMP<-1>    = REG.COTITULAR<ST.Customer.Customer.EbCusEmployersName>
    COT.PROF.PUES<-1>  = REG.COTITULAR<ST.Customer.Customer.EbCusLocalRef, YPOS.EMP.PUESTO>
    COT.OCUP.ACT<-1>   = REG.COTITULAR<ST.Customer.Customer.EbCusOccupation>

RETURN          ;*LFCR_20221108-E

************
LEE.TERCERO:
************

    TER.APE.MATERNO = "" ; TER.APE.PATERNO = "" ; TER.NOMBRE.1 = "" ; TER.NOMBRE.2 = "" ; TER.NOMBRE.3 = "" ; TER.LUG.NAC = "" ; TER.FECHA.NACI = ""
    TER.ACTI.DES = "" ; TER.CALLE = "" ; TER.NUM.EXT = "" ; TER.NUM.INT = "" ; TER.ESTADO = "" ; TER.MUNICIPIO = "" ; TER.COLONIA = "" ; TER.CIUDAD = ""
    TER.CO.PO = "" ; TER.TELEF = "" ; TER.CORREO = "" ; TER.CURP = "" ; TER.RFC = "" ; TER.TIPO.IDE = "" ; TER.NUM.IDE = "" ; NOMBRE.COMPLETO.TER = ''
    PREG.FON.TER = "" ; ID.TIPO.IDENTIF = '' ; DES.TIP.IDENT.TER = '' ; ID.CIUDAD.COT = '' ; CIUDAD.TER.DESC ='' ; ID.MUNICIPIO = '' ; MUNICIPIO.TER = ''
    ID.ESTADO = '' ; ESTADOS.TER = '' ; ID.COLONIA = '' ; COLONIA.TER = '' ; TER.CALLE.NUM = ''

    IF R.INFO.CUENTA.LT NE "" THEN
        PREG.FON.TER    = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PregFonTer>
        IF PREG.FON.TER NE 'SI' THEN PREG.FON.TER = 'NO'
        TER.APE.PATERNO = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.ApPatFonTer>
        IF TER.APE.PATERNO EQ 'XXX' THEN
            TER.APE.PATERNO = ''
        END
        TER.APE.MATERNO = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.ApMatFonTer>
        IF TER.APE.MATERNO EQ 'XXX' THEN
            TER.APE.MATERNO = ''
        END
        TER.NOMBRE.1    = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PrNomFonTer>
        TER.NOMBRE.2    = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.SegNomFonTer>
        TER.NOMBRE.3    = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.TerNomFonTer>
        NOMBRE.COMPLETO.TER = TRIM(TER.NOMBRE.1:' ':TER.NOMBRE.2:' ':TER.NOMBRE.3:' ':TER.APE.PATERNO:' ': TER.APE.MATERNO)
        ID.PAIS = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.NacFonTer>
        GOSUB LEE.PAIS
        TER.LUG.NACI  = DES.PAIS
        TER.FECHA.NACI  = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FecNacFonTer>
        TER.ACT.DESE    = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.ActDesFonTer>
        TER.CALLE       = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.CalleFonTer>
        TER.NUM.EXT     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.NumExtFonTer>
        TER.NUM.INT     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.NumIntFonTer>
        IF TER.NUM.EXT EQ '' THEN
            TER.CALLE.NUM = TER.CALLE: ", No. Int. ": TER.NUM.INT
        END
        IF TER.NUM.INT EQ '' THEN
            TER.CALLE.NUM = TER.CALLE: ", No. Ext. ": TER.NUM.EXT
        END
        IF TER.NUM.EXT NE '' AND TER.NUM.INT NE '' THEN
            TER.CALLE.NUM = TER.CALLE: ", No. Ext. ": TER.NUM.EXT: ", No. Int. ": TER.NUM.INT
        END
        IF TER.CALLE EQ '' AND TER.NUM.EXT EQ '' AND TER.NUM.INT EQ '' THEN
            TER.CALLE.NUM = ''
        END
        TER.ESTADO      = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.EstFonTer>
        ID.ESTADO     = TER.ESTADO
        GOSUB LEE.ESTADO
        ESTADOS.TER   = DES.ESTADO
        TER.MUNICIPIO   = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.DelMunFonTer>
        ID.MUNICIPIO  = TER.MUNICIPIO
        GOSUB LEE.MUNICIPIO
        MUNICIPIO.TER = DES.MUNICIPIO
        TER.COLONIA     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.ColFonTer>
        ID.COLONIA    = TER.COLONIA
        GOSUB LEE.COLONIA
        COLONIA.TER   = DES.COLONIA
        TER.CIUDAD      = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.CiudadFonTer>
        ID.CIUDAD.COT    = TER.CIUDAD
        GOSUB LEE.CIUDAD
        CIUDAD.TER.DESC    = DES.CIUDAD
        TER.COD.PO      = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.CpFonTer>
        TER.TELEF       = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.TelFonter>
        TER.CORREO      = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.EmailFonTer>
        TER.CURP        = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.CurpFonTer>
        TER.RFC         = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.RfcFonTer>
        TER.TIPO.IDEN   = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.TipIdFonTer>
        ID.TIPO.IDENTIF = TER.TIPO.IDEN
        GOSUB LEE.TIPO.IDENTIF
        DES.TIP.IDENT.TER = DES.TIPO.IDENTIF
        TER.NUM.IDEN    = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.NumIdFonTer>
    END

    IF NOMBRE.COMPLETO.TER NE '' THEN
        NOMBRE.TERCER.AUT = '' ; TER.DOMICILIO = '';
        NOMBRE.TERCER.AUT = TER.NOMBRE.1 :" ":TER.NOMBRE.2 :" ": TER.NOMBRE.3:" ":TER.APE.PATERNO : " ":TER.APE.MATERNO
        NOMBRE.TERCER.AUT = TRIM(NOMBRE.TERCER.AUT)
***************AGREGAR A LA VARIABLE SALIDA.ANEXO.A LOS DATOS DE TERCERO**
        TER.DOMICILIO = TER.CALLE       : " ": TER.NUM.EXT :" ": TER.NUM.INT :" ": TER.COLONIA :" ": TER.MUNICIPIO :" ": TER.COD.PO :" ": TER.CIUDAD :" ": TER.ESTADO :" ": "MEXICO" : "|"

        SALIDA.ANEXO.TEMP =''
        SALIDA.ANEXO.TEMP = '<ANEXO ID="':CAA:'">'
        SALIDA.ANEXO.TEMP := '<TIPO_ANEXO>':"PROPIETARIO REAL":'</TIPO_ANEXO>'
        SALIDA.ANEXO.TEMP := '<NOMBRE_ANEXO>':NOMBRE.TERCER.AUT:'</NOMBRE_ANEXO>'
        SALIDA.ANEXO.TEMP := '<PAIS_ANEXO>':TER.LUG.NACI:'</PAIS_ANEXO>'
        SALIDA.ANEXO.TEMP := '<LUG_NAC_ANEXO>':TER.LUG.NACI:'</LUG_NAC_ANEXO>'  ;*ROHH_20181224
        SALIDA.ANEXO.TEMP := '<FEC_NAC_ANEXO>':TER.FECHA.NACI:'</FEC_NAC_ANEXO>'
        SALIDA.ANEXO.TEMP := '<RFC_ANEXO>':TER.RFC:'</RFC_ANEXO>'
        SALIDA.ANEXO.TEMP := '<NACIONAL_ANEXO>':TER.LUG.NACI:'</NACIONAL_ANEXO>'
        SALIDA.ANEXO.TEMP := '<CURP_ANEXO>':TER.CURP:'</CURP_ANEXO>'
        SALIDA.ANEXO.TEMP := '<CALLE_ANEXO>':TER.CALLE.NUM:'</CALLE_ANEXO>'
        SALIDA.ANEXO.TEMP := '<NUM_EXT_ANEXO>':TER.NUM.EXT:'</NUM_EXT_ANEXO>'
        SALIDA.ANEXO.TEMP := '<NUM_INT_ANEXO>':TER.NUM.INT:'</NUM_INT_ANEXO>'
        SALIDA.ANEXO.TEMP := '<COLONIA_ANEXO>':COLONIA.TER:'</COLONIA_ANEXO>'
        SALIDA.ANEXO.TEMP := '<MUNICIPIO_ANEXO>':MUNICIPIO.TER:'</MUNICIPIO_ANEXO>'
        SALIDA.ANEXO.TEMP := '<ESTADO_ANEXO>':ESTADOS.TER:'</ESTADO_ANEXO>'
        SALIDA.ANEXO.TEMP := '<CIUDAD_ANEXO>':CIUDAD.TER.DESC:'</CIUDAD_ANEXO>'
        SALIDA.ANEXO.TEMP := '<CODIGO_POSTAL_ANEXO>':TER.COD.PO:'</CODIGO_POSTAL_ANEXO>'
        SALIDA.ANEXO.TEMP := '<TIPO_FIR_ANEXO>'::'</TIPO_FIR_ANEXO>'
        SALIDA.ANEXO.TEMP := '<TIPO_IDEN_ANEXO>':DES.TIP.IDENT.TER:'</TIPO_IDEN_ANEXO>'
        SALIDA.ANEXO.TEMP := '<NUM_IDEN_ANEXO>':TER.NUM.IDEN:'</NUM_IDEN_ANEXO>'
        SALIDA.ANEXO.TEMP := '<TELEFONO_ANEXO>':TER.TELEF:'</TELEFONO_ANEXO>'
        SALIDA.ANEXO.TEMP := '<CELULAR_ANEXO>'::'</CELULAR_ANEXO>'
        SALIDA.ANEXO.TEMP := '<CORREO_ANEXO>':TER.CORREO:'</CORREO_ANEXO>'
        SALIDA.ANEXO.TEMP := '<NOM_EMP_ANEXO>'::'</NOM_EMP_ANEXO>'
        SALIDA.ANEXO.TEMP := '<PUESTO_ANEXO>'::'</PUESTO_ANEXO>'
        SALIDA.ANEXO.TEMP := '<ACT_ECO_ANEXO>':TER.ACT.DESE:'</ACT_ECO_ANEXO>'  ;*ROHH_20181224
        SALIDA.ANEXO.TEMP := '<NUMERO_RECA>':Y.NUMERO.RECA:'</NUMERO_RECA>'
        SALIDA.ANEXO.TEMP := '</ANEXO>'

        SALIDA.ANEXO.A := SALIDA.ANEXO.TEMP

        CAA += 1
    END

    IF PREG.FON.TER EQ 'NO' THEN NOMBRE.COMPLETO.TER = NOMBRE.CLIENTE
    TERCERO.AUTOR := '<TERCERO_AUTORIZADO>':PREG.FON.TER:'</TERCERO_AUTORIZADO>'

RETURN

******************
LEE.BENEFICIARIO:
******************

    BEN.APE.PATERNO = "" ; BEN.APE.MATERNO = "" ; BEN.NOMBRES = "" ; BEN.PORCENTAJE = "" ; BEN.CALLE = "" ; BEN.NUM.EXT = "" ; BEN.NUM.INT = ""
    BEN.ESTADO = "" ; BEN.MUNICICPIO = "" ; BEN.COLONIA = "" ; BEN.CIUDAD = "" ; BEN.COD.POST = "" ; BEN.TELEFONO = "" ; TOTAL.BENEFICIARIO = ""
    BEN.RFC = "" ; BEN.CURP = "" ; BEN.IDENTIFICA = "" ; BEN.NRO.IDENTI = "" ; BEN.PAIS.NAC = "" ; BEN.NACIONAL = "" ; BEN.PAIS = ""
    BEN.TEL.CEL = "" ; BEN.EMAIL = "" ; BEN.PROF.PUES = "" ; BEN.OCUP.ACT = ""

    IF R.INFO.CUENTA.LT NE "" THEN
        BEN.APE.PATERNO    = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenApePaterno>
        BEN.APE.MATERNO    = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenApeMaterno>
        BEN.NOMBRES        = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenNombres>
        BEN.PORCENTAJE     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenPorcentaje>
        BEN.CALLE          = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenCalle>
        BEN.NUM.EXT        = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenNumExt>
        BEN.NUM.INT        = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenNumInt>
        BEN.ESTADO         = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenEstado>
        BEN.MUNICICPIO     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenMunicipio>
        BEN.COLONIA        = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenColonia>
        BEN.CIUDAD         = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenCiudad>
        BEN.COD.POST       = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenCodPos>
        BEN.TELEFONO       = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenTelefono>
        BEN.PARENTESCO     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.ParentescoBen>
        BEN.FEC.NAC        = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenFecNac>

        BEN.RFC            = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenRfc>
        BEN.CURP           = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenCurp>
        BEN.IDENTIFICA     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenIdentifica>
        BEN.NRO.IDENTI     = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenNroIdenti>
        BEN.PAIS.NAC       = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenPaisNac>
        BEN.NACIONAL       = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenNacional>
        BEN.PAIS           = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenPais>
        BEN.TEL.CEL        = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenTelCel>
        BEN.EMAIL          = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenEmail>
        BEN.NOM.EMP        = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenNomEmp>
        BEN.PROF.PUES      = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenProfPues>
        BEN.OCUP.ACT       = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.BenOcupAct>
    END

    TOTAL.BENEFICIARIO = DCOUNT(BEN.APE.PATERNO, @SM)

    SALIDA.BENEFICIARIO = ""
    IF TOTAL.BENEFICIARIO GT 0 THEN
        FOR BN = 1 TO TOTAL.BENEFICIARIO
            AP.PART.BEN = ""    ; AP.MATE.BEN = ""  ; NOMBRES.BEN = ""            ; NOMBRE.COMPLETO.BEN = "" ; CALLE.BEN = ""      ;
            NUM.EXT.BEN = ""    ; NUM.INT.BEN = ""  ; COLONIA.BEN = ""            ; MUNICIP.BEN = ""         ; CIUDAD.BEN = ""     ;
            ESTADO.BEN = ""     ; COD.POST.BEN = "" ; DOMICILIO.BENEFICIARIO = "" ; TELEFONO.BEN = ""        ; PORCENTAJE.BEN = "" ;
            PARENTESCO.BEN = "" ; FEC.NAC.BEN = ""  ; RFC.BEN = ""                ; CURP.BEN = ""            ; IDENTIFICA.BEN = "" ;
            NRO.IDENTI.BEN = "" ; PAIS.NAC.BEN = "" ; NACIONAL.BEN = ""           ; PAIS.BEN = ""            ; TEL.CEL.BEN = ""    ;
            EMAIL.BEN = ""      ; NOM.EMP.BEN = ""  ; PROF.PUES.BEN = ""          ; OCUP.ACT.BEN = ""

            AP.PART.BEN    = BEN.APE.PATERNO<1,1,BN>
            IF AP.PART.BEN EQ 'XXX' THEN
                AP.PART.BEN = ''
            END
            AP.MATE.BEN    = BEN.APE.MATERNO<1,1,BN>
            IF AP.MATE.BEN EQ 'XXX' THEN
                AP.MATE.BEN = ''
            END
            NOMBRES.BEN    = BEN.NOMBRES<1,1,BN>
            NOMBRE.COMPLETO.BEN = TRIM(NOMBRES.BEN:' ':AP.PART.BEN:' ':AP.MATE.BEN)
            CALLE.BEN      = BEN.CALLE<1,1,BN>
            NUM.EXT.BEN    = BEN.NUM.EXT<1,1,BN>
            NUM.INT.BEN    = BEN.NUM.INT<1,1,BN>
            ID.COLONIA     = BEN.COLONIA<1,1,BN>
            GOSUB LEE.COLONIA
            COLONIA.BEN    = DES.COLONIA
            ID.MUNICIPIO   = BEN.MUNICICPIO<1,1,BN>
            GOSUB LEE.MUNICIPIO
            MUNICIP.BEN    = DES.MUNICIPIO
            ID.CIUDAD      = BEN.CIUDAD<1,1,BN>
            CIUDAD.BEN     = FIELD(ID.CIUDAD,'-',2)
            ID.ESTADO      =  BEN.ESTADO<1,1,BN>
            GOSUB LEE.ESTADO
            ESTADO.BEN     = DES.ESTADO
            COD.POST.BEN   = BEN.COD.POST<1,1,BN>
            TELEFONO.BEN   = BEN.TELEFONO<1,1,BN>
            PORCENTAJE.BEN = BEN.PORCENTAJE<1,1,BN>
            PARENTESCO.BEN = BEN.PARENTESCO<1,1,BN>
            FEC.NAC.BEN = BEN.FEC.NAC<1,1,BN>

            RFC.BEN     = BEN.RFC<1,1,BN>
            CURP.BEN    = BEN.CURP<1,1,BN>
            IDENTIFICA.BEN = BEN.IDENTIFICA<1,1,BN>
            NRO.IDENTI.BEN = BEN.NRO.IDENTI<1,1,BN>
            ID.PAIS = BEN.PAIS.NAC<1,1,BN>
            GOSUB LEE.PAIS
            PAIS.NAC.BEN  = DES.PAIS
            ID.PAIS = BEN.NACIONAL<1,1,BN>
            GOSUB LEE.PAIS
            NACIONAL.BEN  = DES.PAIS
            PAIS.BEN     = BEN.PAIS<1,1,BN>
            TEL.CEL.BEN    = BEN.TEL.CEL<1,1,BN>
            EMAIL.BEN     = BEN.EMAIL<1,1,BN>
            NOM.EMP.BEN    = BEN.NOM.EMP<1,1,BN>
            PROF.PUES.BEN  = BEN.PROF.PUES<1,1,BN>
            ID.OCUPACION   = BEN.OCUP.ACT<1,1,BN>
            GOSUB LEE.OCUPACION
            OCUP.ACT.BEN   = DES.OCUPACION

            DOMICILIO.BENEFICIARIO = TRIM(CALLE.BEN:' ':NUM.EXT.BEN:' ':NUM.INT.BEN:' ':COLONIA.BEN:' ':MUNICIP.BEN:' ':CIUDAD.BEN:' ':ESTADO.BEN:' ':COD.POST.BEN:' ':PAIS.BEN )

            SALIDA.BENEFICIARIO.TEMP = ''
            SALIDA.BENEFICIARIO.TEMP = '<BENEFICIARIO ID="':BN:'">'
            SALIDA.BENEFICIARIO.TEMP := '<NOMBRE_COMPLETO>':NOMBRE.COMPLETO.BEN:'</NOMBRE_COMPLETO>'
            SALIDA.BENEFICIARIO.TEMP := '<TELEFONO>':TELEFONO.BEN:'</TELEFONO>'
            SALIDA.BENEFICIARIO.TEMP := '<PORCENTAJE>':PORCENTAJE.BEN:'</PORCENTAJE>'
            SALIDA.BENEFICIARIO.TEMP := '<RFC>':RFC.BEN:'</RFC>'
            SALIDA.BENEFICIARIO.TEMP := '<CURP>':CURP.BEN:'</CURP>'
            SALIDA.BENEFICIARIO.TEMP := '<IDENTIFICA>':IDENTIFICA.BEN:'</IDENTIFICA>'
            SALIDA.BENEFICIARIO.TEMP := '<NRO_IDENTI>':NRO.IDENTI.BEN:'</NRO_IDENTI>'
            SALIDA.BENEFICIARIO.TEMP := '<PARENTESCO>':PARENTESCO.BEN:'</PARENTESCO>'
            SALIDA.BENEFICIARIO.TEMP := '<PAIS_NAC>':PAIS.NAC.BEN:'</PAIS_NAC>'
            SALIDA.BENEFICIARIO.TEMP := '<FEC_NAC>':FEC.NAC.BEN:'</FEC_NAC>'
            SALIDA.BENEFICIARIO.TEMP := '<NACIONAL>':NACIONAL.BEN:'</NACIONAL>'
            SALIDA.BENEFICIARIO.TEMP := '<DOMICILIO_BENEFICIARIO>':DOMICILIO.BENEFICIARIO:'</DOMICILIO_BENEFICIARIO>'
            SALIDA.BENEFICIARIO.TEMP := '<TEL_CEL>':TEL.CEL.BEN:'</TEL_CEL>'
            SALIDA.BENEFICIARIO.TEMP := '<EMAIL>':EMAIL.BEN:'</EMAIL>'
            SALIDA.BENEFICIARIO.TEMP := '<NOM_EMP>':NOM.EMP.BEN:'</NOM_EMP>'
            SALIDA.BENEFICIARIO.TEMP := '<PROF_PUES>':PROF.PUES.BEN:'</PROF_PUES>'
            SALIDA.BENEFICIARIO.TEMP := '<OCUP_ACT>':OCUP.ACT.BEN:'</OCUP_ACT>'
            SALIDA.BENEFICIARIO.TEMP := '</BENEFICIARIO>'

            SALIDA.BENEFICIARIO := SALIDA.BENEFICIARIO.TEMP
        NEXT BN
    END

RETURN

************
LEE.CLIENTE:
************

    TIPO.FORMATO = "" ; APELLIDO.P = "" ; APELLIDO.M = "" ; NOMBRE.1 = "" ; NOMBRE.CLIENTE = "" ; CURP.CLIENTE = "" ; FECHA.NAC.CLI = "" ; ID.ESTADO = ""
    LUG.NAC.CLI = "" ; ID.PAIS = "" ; NACIONALIDAD.CLI = "" ; RESIDENCIA.EU.CLI = "" ; NUM.REG.FISCAL = "" ; SEXO.CLIENTE = "" ; ID.TIP.IDEN = ""
    TIPO.INDENT.CLI = "" ; NUME.INDENT.CLI = "" ; ID.ESTADO.CIVIL = "" ; ESTADO.CIVIL.CLI = "" ; ID.DESTIN.RECURSOS = "" ; ID.OTRO.DESTIN.REC = ""
    DESTIN.RECURSOS = "" ; DESTIN.RECURSOS = "" ; ID.PROFESION = "" ; PROFESION.CLI = "" ; ID.TIPO.EMPLEO = "" ; TIPO.EMPLEO = "" ; PUESTO = ""
    INGR.MEN.BR = "" ; ID.SECTOR = "" ; SECTOR.EMP = "" ; ID.INDUSTRIA = "" ; INDUSTRIA.EMP = "" ; ID.ACT.ECO = "" ; ACT.ECONO.EMP = "" ; NOM.EMPRESA = ""
    TEL.EMPRESA = "" ; EXT.EMPRESA = "" ; EMPLEADO.ABC = "" ; RFC.CLIENTE = "" ; TEL.DOMI.CLI = "" ; TEL.CEL.CLI = "" ; CORREO.CLIENTE = "" ; TIENEFIR.ELEC = ""
    FIRMA.ELECTRO = "" ; DEPOS.TIPO = "" ; DEPOS.APRX.MEN = "" ; DEPOS.NUM.MEN = "" ; PROCED.RECURSOS = "" ; OTRA.PROCED = "" ; RETIR.TIPO = ""
    RETIR.APRX.MEN = "" ; RETIR.NUM.MEN = "" ; DESTIN.RECURSOS = "" ; R.INFO.CLIENTE = "" ; ERROR.CLIENTE = "" ; CLASSIFICATION = "" ; RESIDENCIA = ""
    ACT.VULNERABLE = "" ; FEC.NAC.CONY = "" ; RFC.CONY = "" ; TEL.CONY = "" ; CORREO.CONY = "" ; DENOMINACION = "" ; RESID.SOCIEDAD = "" ; PAG.WEB = ""
    DOMICILIO.SOCIAL = "" ; ACT.ESPECIFICA = "" ; SERV.EMPR = "" ; POR.PROD.IMP = "" ; POR.PROD.EXP = "" ; CANAL.DISTR = "" ; POL.VENTA = ""
    VENT.CICLICA = "" ; VENT.RAZON = "" ; VENT.PLAZ.CRED = "" ; VENT.DIAS.INVE.REQ = "" ; CORREO.EMPLEO = "" ; PLD.FUN.PUB = "" ; REL.PERSONA.EXP = ""
    PUESTO.ULT.ANIO = "" ; NOM.PER.POL.EXP = "" ; TIPO.PER.POL.EX = "" ; PER.POL.EXP = "" ; ID.CIUDAD.EMP = "" ; DESCR.CIUDAD.EMP = "" ; DES.TIPO.MORAL = ""
    ID.TIPO.MORAL = "" ; DESCR.MORAL = "" ; DESC.PAIS.CONST = "" ; DESC.LUGAR.CONST = "" ; AC.VULNERABLE = "" ; Y.VALOR.A = "" ; Y.VALOR.B = "" ; Y.NO.DAM = ""
    Y.AC.CELULAR.ASOCIADO = ''

    IF ID.CLIENTE THEN
        R.INFO.CLIENTE = ST.Customer.Customer.Read(ID.CLIENTE, ERROR.CLIENTE)
        R.INFO.CLIENTE.MXBASE = MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Read(ID.CLIENTE, ERROR.CLIENTE)
        IF R.INFO.CLIENTE THEN
            
            CLASSIFICATION = R.INFO.CLIENTE<ST.Customer.Customer.EbCusSector>
            DOMI.EMPRESA   = ""
            RAZON.SOCIAL   = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.NOM.PER.MORAL>
            IF RAZON.SOCIAL EQ '' THEN
                RAZON.SOCIAL   = R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameOne>
            END
*--------------------------------------------------------%% CCBC_20180212 %%-S
            IF Y.ACC.TITLE NE '' THEN
                RAZON.SOCIAL = Y.ACC.TITLE
            END
*----------------------------------------------------------------------------E

*--------------------------------------------------------%% ROHH_20180906

            GOSUB ADMINISTRA.BANCA.INTERNET

*--------------------------------------------------------%% ROHH_20180906

            
            CHANGE "," TO "" IN RAZON.SOCIAL
            ID.TIPO     = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.TIPO.MORAL>
            ID.TIPO.MORAL  = ID.TIPO
            GOSUB LEE.TIPO.MORAL
            DESCR.MORAL    = DES.TIPO.MORAL
            CALLE.EMP      = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.EMP.CALLE>
            NUM.EXT.EMP    = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.EMP.NUM.EXT>
            NUM.INT.EMP    = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.EMP.NUM.INT>
            ID.COLONIA     = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.EMP.COL>
            GOSUB LEE.COLONIA
            COLONIA.EMP    = DES.COLONIA
            ID.MUNICIPIO   = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.EMP.DEL.MUNI>
            GOSUB LEE.MUNICIPIO
            DEL.EMP        = DES.MUNICIPIO
            ID.ESTADO      = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.EMP.ENTIDAD>
            GOSUB LEE.ESTADO
            ENTI.EMP       = DES.ESTADO
            ID.CIUDAD.EMP  = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.CIUDAD>
            GOSUB LEE.CIUDAD.EMP
            DESCR.CIUDAD.EMP = DES.CIUDAD.EMP
            COD.PO.EMP     = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.EMP.COD.POS>
            ID.PAIS        = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.EMP.PAIS>
            GOSUB LEE.PAIS
            PAIS.EMP       = DES.PAIS
            DOMI.EMPRESA   = TRIM(CALLE.EMP:' ':NUM.EXT.EMP:' ':NUM.INT.EMP:' ':COLONIA.EMP:' ':DEL.EMP:' ':ENTI.EMP:' ':COD.PO.EMP:' ':PAIS.EMP)

            LISTA.SUCURSALES = '' ; CIUDAD.SUCURSALES = ''
            LISTA.SUCURSALES =  R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.MainCities>
            CONVERT @SM TO @FM IN LISTA.SUCURSALES

            TOTAL.SUCURSALES = DCOUNT(LISTA.SUCURSALES, @FM)
            IF TOTAL.SUCURSALES GT 0 THEN
                FOR SUC = 1 TO TOTAL.SUCURSALES
                    ID.ESTADO = LISTA.SUCURSALES<SUC>
                    GOSUB LEE.ESTADO
                    CIUDAD.SUCURSALES := DES.ESTADO:'|'
                NEXT SUC
            END
            
            IF CLASSIFICATION LT 2001 THEN
*IF CLASSIFICATION LT 3 THEN
                IF CLASSIFICATION EQ 1001 THEN TIPO.FORMATO = '1' ELSE TIPO.FORMATO = '2'
                APELLIDO.P     = R.INFO.CLIENTE<ST.Customer.Customer.EbCusShortName, 1>
                IF APELLIDO.P EQ 'XXX'THEN APELLIDO.P = ''
                APELLIDO.M     = R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameOne,1>
                IF APELLIDO.M EQ 'XXX' THEN APELLIDO.M = ''
                NOMBRE.1       = R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameTwo,1>
                NOMBRE.CLIENTE = TRIM(NOMBRE.1:' ':APELLIDO.P:' ':APELLIDO.M)
                CHANGE "," TO "" IN NOMBRE.CLIENTE
                CURP.CLIENTE   = R.INFO.CLIENTE<ST.Customer.Customer.EbCusExternCusId>
                ID.ESTADO      = R.INFO.CLIENTE<ST.Customer.Customer.EbCusDistrictName>
                GOSUB LEE.ESTADO
                LUG.NAC.CLI    = DES.ESTADO
                SEXO.CLIENTE       = R.INFO.CLIENTE<ST.Customer.Customer.EbCusGender>
                IF SEXO.CLIENTE EQ 'MALE' THEN
                    SEXO.CLIENTE = 'MASCULINO'
                END ELSE
                    IF SEXO.CLIENTE EQ 'FEMALE' THEN
                        SEXO.CLIENTE = 'FEMENINO'
                    END
                END
                
                ID.TIP.IDEN =  R.INFO.CLIENTE<ST.Customer.Customer.EbCusLegalDocName>
                Y.CADENA.LOG<-1> =  "ID.TIP.IDEN->" : ID.TIP.IDEN
                GOSUB LEE.TIPO.INDENT
                TIPO.INDENT.CLI      = DES.TIPO.INDENT
                NUME.INDENT.CLI      = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLegalId, 1>
                VIGE.INDENT.CLI      = ''
                VIGE.INDENT.CLI      = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLegalExpDate,1>
                ID.ESTADO.CIVIL      = R.INFO.CLIENTE<ST.Customer.Customer.EbCusMaritalStatus>
                GOSUB LEE.ESTADO.CIVIL
                ESTADO.CIVIL.CLI     = DES.ESTADO.CIVIL

                REGIMEN.CONYUGAL = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.REGIMEN>          ;*No se modifica porque sus registros provienen de Local.Table
                IF REGIMEN.CONYUGAL EQ 2 THEN
                    REGIMEN.CONYUGAL = 'SOCIEDAD CONYUGAL'
                END ELSE
                    IF REGIMEN.CONYUGAL EQ 1 THEN
                        REGIMEN.CONYUGAL = 'SEPARACION DE BIENES'
                    END
                END
                NOMBRE.CONYUGE = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.NOM.CONYUGUE>

                ID.PROFESION  = R.INFO.CLIENTE<ST.Customer.Customer.EbCusJobTitle>
                GOSUB LEE.PROFESION
                PROFESION.CLI = DES.PROFESION
                IF PROFESION.CLI EQ '' THEN       ;*CCBC_20180712   -------S
                    ID.OCUPACION  = R.INFO.CLIENTE<ST.Customer.Customer.EbCusOccupation>
                    GOSUB LEE.OCUPACION
                    PROFESION.CLI = DES.OCUPACION
                END ;*CCBC_20180712   -------E
                ID.TIPO.EMPLEO = R.INFO.CLIENTE<ST.Customer.Customer.EbCusEmploymentStatus>
                GOSUB LEE.TIPO.EMPLEO
                TIPO.EMPLEO   = DES.TIPO.EMPLEO
************************************************************************ROHH_20180906  Extrae otro tipo de empleo

                Y.OTRO.TIPO.EMPLEO = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.OTRO.EMPLEO>

                IF TIPO.EMPLEO EQ 'Otro' AND Y.OTRO.TIPO.EMPLEO NE '' THEN
                    TIPO.EMPLEO = Y.OTRO.TIPO.EMPLEO
                END
                IF TIPO.EMPLEO EQ '' AND Y.OTRO.TIPO.EMPLEO NE '' THEN
                    TIPO.EMPLEO = Y.OTRO.TIPO.EMPLEO
                END

************************************************************************ROHH_20180906




                PUESTO        = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.EMP.PUESTO>
                INGR.MEN.BR   = R.INFO.CLIENTE<ST.Customer.Customer.EbCusNetMonthlyIn>
                ID.INDUSTRIA  = R.INFO.CLIENTE<ST.Customer.Customer.EbCusIndustry>
                GOSUB LEE.INDUSTRIA
                INDUSTRIA.EMP = DES.INDUSTRIA
                NOM.EMPRESA   = R.INFO.CLIENTE<ST.Customer.Customer.EbCusEmployersName><1,1>      ;* ROHH_20181224
                TEL.EMPRESA   = R.INFO.CLIENTE<ST.Customer.Customer.EbCusOffPhone>
                EXT.EMPRESA   = R.INFO.CLIENTE<ST.Customer.Customer.EbCusFaxOne>
                EMPLEADO.ABC  = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.STAFF.OFFICIAL>
;*ID.SECTOR     = R.INFO.CLIENTE<ST.Customer.Customer.EbCusSector>
                ID.SECTOR     = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.BanxicoEcoActivity>
;*ID.SECTOR     = "BANXICO.ECO.ACTIVITY*" : ID.SECTOR
                
                GOSUB LEE.SECTOR
                SECTOR.EMP    = DES.SECTOR

                NUM.EMPLEADOS     = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.NumberOfEmployees>
                NUM.DE.SUCUR      = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.NumberOfBranch>
                COBERTURA.GEO     = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.COB.GEO>
                VENTAS.TOT.ANUAL  = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.TotalAnnualSales>
                TOTAL.ACTIVOS     = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.TotalAssets>
                TOTAL.PASIVOS     = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.TotalLiability>
                CAPITAL.CONTABLE  = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.StockHolderEquity>
                TIENE.IMPORTACION =  R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.TIENE.IMPOR>
                IF TIENE.IMPORTACION EQ 'SI' THEN

                    LISTA.MTO.IMPORTACION = '' ; LISTA.PAIS.IMPORTACION = '' ; MTO.IMPORTACION = 0 ; PAIS.IMPORTACION = '' ;
                    LISTA.MTO.IMPORTACION =  R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ImportationAmount>
                    CONVERT @SM TO @FM IN LISTA.MTO.IMPORTACION
                    LISTA.PAIS.IMPORTACION =  R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ImportationCountries>
                    CONVERT @SM TO @FM IN LISTA.PAIS.IMPORTACION

                    TOTAL.MTO.IMPORTACION = DCOUNT(LISTA.MTO.IMPORTACION, @FM)
                    IF TOTAL.MTO.IMPORTACION GT 0 THEN
                        FOR MON = 1 TO TOTAL.MTO.IMPORTACION
                            MTO.IMPORTACION += LISTA.MTO.IMPORTACION<MON>
                            IF MON GT 1 THEN PAIS.IMPORTACION := ", "
                            ID.PAIS = LISTA.PAIS.IMPORTACION<MON>
                            GOSUB LEE.PAIS
                            PAIS.IMPORTACION := DES.PAIS
                        NEXT MON
                    END

                END
                TIENE.EXPORTACION =  R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.TIENE.EXPOR>
                IF TIENE.EXPORTACION EQ 'SI' THEN

                    LISTA.MTO.EXPORTACION = '' ; LISTA.PAIS.EXPORTACION = '' ; MTO.EXPORTACION = 0 ; PAIS.EXPORTACION = '' ;
                    LISTA.MTO.EXPORTACION =  R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ImportationExportation>
                    CONVERT @SM TO @FM IN LISTA.MTO.EXPORTACION
                    LISTA.PAIS.EXPORTACION =  R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ExportationCountries>
                    CONVERT @SM TO @FM IN LISTA.PAIS.EXPORTACION

                    TOTAL.MTO.EXPORTACION = DCOUNT(LISTA.MTO.EXPORTACION, @FM)
                    IF TOTAL.MTO.EXPORTACION GT 0 THEN
                        FOR MON = 1 TO TOTAL.MTO.EXPORTACION
                            MTO.EXPORTACION += LISTA.MTO.EXPORTACION<MON>
                            IF MON GT 1 THEN PAIS.EXPORTACION := ", "
                            ID.PAIS = LISTA.PAIS.EXPORTACION<MON>
                            GOSUB LEE.PAIS
                            PAIS.EXPORTACION := DES.PAIS
                        NEXT MON
                    END

                END
            END ELSE
                
                IF CLASSIFICATION GE 2014 THEN
*IF CLASSIFICATION GE 3 THEN
                    TIPO.FORMATO       = '3'
                    NOMBRE.CLIENTE     = TRIM(R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameOne,1>)
                    ID.TIPO.SOCIEDAD   =  R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.CorporateCustomerType>
                    ID.TIPO.SOC.TMP    = ID.TIPO.SOCIEDAD
                    GPO.FINANCIERO    =  R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.GPO.FINANCIERO>       ;* LFCR_20200823-E
                    GOSUB LEE.SOCIEDAD
                    TIPO.SOCIEDAD.DESC = DES.TIPO.SOCIEDAD
                    RFC.CLIENTE.MOR    = R.INFO.CLIENTE<ST.Customer.Customer.EbCusTaxId,1>
                    ID.PAIS            = R.INFO.CLIENTE<ST.Customer.Customer.EbCusNationality>
                    GOSUB LEE.PAIS
                    NACIONALIDAD.CLI.MOR = DES.PAIS

                    IF ID.TIPO.SOC.TMP NE "" THEN
                        TIPO.SOCIEDAD = "SI":"|":TIPO.SOCIEDAD.DESC:"|":RFC.CLIENTE.MOR:"|":NACIONALIDAD.CLI.MOR:"|":
                    END ELSE
                        TIPO.SOCIEDAD = "NO||||"
                    END

                    FECHA.ACTA     = ""
                    NUM.ESCRITURA  = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.MxbaseConstitutionType>
                    NOM.NOTARIO    = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.NotaryName>
                    NUM.NOTARIO    = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.RegistrationNotaryNumber>
                    ID.ESTADO      = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.NotaryState>
                    GOSUB LEE.ESTADO
                    ENT.NOTARIO    = DES.ESTADO
                    PAIS.CONSTITUCION = R.INFO.CLIENTE<ST.Customer.Customer.EbCusOtherNationality>
                    ID.PAIS = PAIS.CONSTITUCION
                    GOSUB LEE.PAIS
                    DESC.PAIS.CONST = DES.PAIS
                    LUGAR.CONSTITUCION = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ConstitutionState>
                    ID.ESTADO      = LUGAR.CONSTITUCION
                    GOSUB LEE.ESTADO
                    DESC.LUGAR.CONST    = DES.ESTADO

                    DATOS.REG.PUB  = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.RegistrationCompanyNo>
                    FECHA.REG.PUB  = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.DateRegistration>
                    ID.SECTOR      = R.INFO.CLIENTE<ST.Customer.Customer.EbCusSector>
                    GOSUB LEE.SECTOR
                    GIRO.EMPRESA   = DES.SECTOR
                    ID.TIPO.GIRO   = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.CnbvEcoActivity>
                    GOSUB LEE.SEC.ECO
                    TIPO.GIRO = DES.SECTOR.ECONOMICO
                    
                    ID.SECT.EMP    = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.GIRO.MERC>
                    GOSUB LEE.GIRO.MER
                    SECTOR.EMP = DES.SECT.EMP     ;*ROHH_20180830
                    NUM.DE.SUCUR   = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.NumberOfBranch>
                    NUM.EMPLEADOS       = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.NumberOfEmployees>
                    COBERTURA.GEO       = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.COB.GEO>
                    VENTAS.TOT.ANUAL    = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.TotalAnnualSales>
                    TIENE.IMPORTACION   =  R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.TIENE.IMPOR>
                    IF TIENE.IMPORTACION EQ 'SI' THEN
                        LISTA.MTO.IMPORTACION = '' ; LISTA.PAIS.IMPORTACION = '' ; MTO.IMPORTACION = 0 ; PAIS.IMPORTACION = '' ;
                        LISTA.MTO.IMPORTACION =  R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ImportationAmount>
                        CONVERT @SM TO @FM IN LISTA.MTO.IMPORTACION
                        LISTA.PAIS.IMPORTACION =  R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ImportationCountries>
                        CONVERT @SM TO @FM IN LISTA.PAIS.IMPORTACION

                        TOTAL.MTO.IMPORTACION = DCOUNT(LISTA.MTO.IMPORTACION, @FM)
                        IF TOTAL.MTO.IMPORTACION GT 0 THEN
                            FOR MON = 1 TO TOTAL.MTO.IMPORTACION
                                MTO.IMPORTACION += LISTA.MTO.IMPORTACION<MON>
                                IF MON GT 1 THEN PAIS.IMPORTACION := ", "
                                ID.PAIS = LISTA.PAIS.IMPORTACION<MON>
                                GOSUB LEE.PAIS
                                PAIS.IMPORTACION := DES.PAIS
                            NEXT MON
                        END
                    END
                    TIENE.EXPORTACION =  R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.TIENE.EXPOR>
                    IF TIENE.EXPORTACION EQ 'SI' THEN
                        LISTA.MTO.EXPORTACION = '' ; LISTA.PAIS.EXPORTACION = '' ; MTO.EXPORTACION = 0 ; PAIS.EXPORTACION = '' ;
                        LISTA.MTO.EXPORTACION =  R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ImportationExportation>
                        CONVERT @SM TO @FM IN LISTA.MTO.EXPORTACION
                        LISTA.PAIS.EXPORTACION =  R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ExportationCountries>
                        CONVERT @SM TO @FM IN LISTA.PAIS.EXPORTACION

                        TOTAL.MTO.EXPORTACION = DCOUNT(LISTA.MTO.EXPORTACION, @FM)
                        IF TOTAL.MTO.EXPORTACION GT 0 THEN
                            FOR MON = 1 TO TOTAL.MTO.EXPORTACION
                                MTO.EXPORTACION += LISTA.MTO.EXPORTACION<MON>
                                IF MON GT 1 THEN PAIS.EXPORTACION := ", "
                                ID.PAIS = LISTA.PAIS.EXPORTACION<MON>
                                GOSUB LEE.PAIS
                                PAIS.EXPORTACION := DES.PAIS
                            NEXT MON
                        END
                    END

                    TOTAL.ACTIVOS    = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.TotalAssets>
                    TOTAL.PASIVOS    = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.TotalLiability>
                    CAPITAL.CONTABLE = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.StockHolderEquity>
                    FECHA.BALANCE    = EB.SystemTables.getToday()
                    FECHA.INI.OPER   = R.INFO.CLIENTE<ST.Customer.Customer.EbCusEmploymentStart>
                    TOMO.LIBRO.VOL   = ""
                END
            END

            RFC.CLIENTE    = R.INFO.CLIENTE<ST.Customer.Customer.EbCusTaxId,1>
            TEL.DOMI.CLI   = R.INFO.CLIENTE<ST.Customer.Customer.EbCusPhoneOne,1>
            TEL.CEL.CLI    = R.INFO.CLIENTE<ST.Customer.Customer.EbCusSmsOne,1>
            Y.AC.CELULAR.ASOCIADO = TEL.CEL.CLI

            GOSUB TEL.CEL.CLI.LETRA
            GOSUB TEL.CEL.CLI.DIGS
            CORREO.CLIENTE = R.INFO.CLIENTE<ST.Customer.Customer.EbCusEmailOne,1>
            FECHA.NAC.CLI  = R.INFO.CLIENTE<ST.Customer.Customer.EbCusDateOfBirth>
            TIENEFIR.ELEC  = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.TIENE.FIRMA.ELE>
            FIRMA.ELECTRO  = R.INFO.CLIENTE<ST.Customer.Customer.EbCusTaxId,2>
            PLD.FUN.PUB     = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Comments>
            REL.PERSONA.EXP = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.RelationClient>
            PUESTO.ULT.ANIO = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.JobPosition>
            NOM.PER.POL.EXP = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Others>
            TIPO.PER.POL.EX = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.RelationType>

            EB.DataAccess.FRead(FN.RELATION,TIPO.PER.POL.EX,R.RELATION,F.RELATION,ERROR.REL)
            TIPO.PER.POL.EX= R.RELATION<ST.Customer.Relation.EbRelDescription>

            GARAN.IPAB      = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.TIP.IPAB.GARAN>
*****CAMBIO CHRISTIAN***************************************************************************
            IF GARAN.IPAB NE 'SI' THEN
                GARAN.IPAB = 0
            END
************************************************************************************************

            DEPOS.TIPO     = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Type>
            DEPOS.TIPO = EREPLACE(DEPOS.TIPO,",","|")
            DEPOS.APRX.MEN = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.MonthlyApproxIncome>
            DEPOS.NUM.MEN  = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.TransactionOperationNumber, 1>
            PROCED.RECURSOS= R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.SourceRec>
            OTRA.PROCED    = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.OtherSource>
            RETIR.TIPO     = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.TypeOfOperation, 2>

            RETIR.TIPO = EREPLACE(RETIR.TIPO,",","|")
            RETIR.APRX.MEN = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.TransactionAmountMonthly, 2>
            RETIR.NUM.MEN  = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.TransactionOperationNumber, 2>
            ID.DESTIN.RECURSOS = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.AccountPurpose>
            ID.OTRO.DESTIN.REC = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.OtherPurpose>
            GOSUB LEE.DESTINO
            DESTIN.RECURSOS= DES.DESTIN.RECURSOS
            ID.PAIS =  R.INFO.CLIENTE<ST.Customer.Customer.EbCusNationality>
            GOSUB LEE.PAIS
            NACIONALIDAD.CLI = DES.PAIS
            ID.PAIS = R.INFO.CLIENTE<ST.Customer.Customer.EbCusResidence>
            GOSUB LEE.PAIS
            RESIDENCIA = DES.PAIS
            
            ID.ACT.ECO =  R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.BanxicoEcoActivity>
            GOSUB LEE.ACT.ECO
            ACT.ECONO.EMP = DES.ACT.ECO
            AC.VULNERABLE = ACT.VULNERABLE
            RESIDENCIA.EU.CLI  = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.CDNIA.RESID.EUA>
            IF RESIDENCIA.EU.CLI EQ 'SI' THEN
                NUM.REG.FISCAL = R.INFO.CLIENTE<ST.Customer.Customer.EbCusTaxId,3>
            END
            LUGAR.INSCRIPCION = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.StateRegistered>
            GOSUB OBTEN.DOMICILIO
            IF PLD.FUN.PUB EQ 'SI' OR REL.PERSONA.EXP EQ 'SI' THEN
                PER.POL.EXP = 'SI'
            END ELSE
                PER.POL.EXP = 'NO'
                PUESTO.ULT.ANIO = ''
                NOM.PER.POL.EXP = ''
                TIPO.PER.POL.EX = ''
            END
        END
    END

RETURN

****************
LEE.ACCIONISTAS:
****************

    LISTA.ACCIONISTAS = ''; LISTA.PORCENTAJE = ''; LISTA.RFC.ACC = '' ; LISTA.NAC.ACC = '' ; LISTA.RESI.ACC = ''        ;*LFCR_20200823-S
    TOTAL.ACCIONISTAS = ''; ACCIONISTAS = ''      ;* LFCR_20200823-S
    LISTA.ACCIONISTAS =  R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.NOM.ACCIONISTA>
    CONVERT @SM TO @FM IN LISTA.ACCIONISTAS
    LISTA.PORCENTAJE  =  R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.ACC.PORCENTAJE>
    CONVERT @SM TO @FM IN LISTA.PORCENTAJE
    LISTA.RFC.ACC = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.RFC.ACCIONISTA>
    CONVERT @SM TO @FM IN LISTA.RFC.ACC
    LISTA.NAC.ACC = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.NACI.ACCIONISTA>
    CONVERT @SM TO @FM IN LISTA.NAC.ACC
    LISTA.RESI.ACC = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.RESI.ACCIONISTA>
    CONVERT @SM TO @FM IN LISTA.RESI.ACC

    TOTAL.ACCIONISTAS = DCOUNT(LISTA.ACCIONISTAS, @FM)
    IF TOTAL.ACCIONISTAS GT 0 THEN
        FOR ACI = 1 TO TOTAL.ACCIONISTAS
            NOMBRE.ACCION = ''; PORCE.ACCION = ''; RFC.ACCION = '' ; NACI.ACCION = '' ; RESI.ACCION = ''
            NOMBRE.ACCION = LISTA.ACCIONISTAS<ACI>
            PORCE.ACCION  = LISTA.PORCENTAJE<ACI>
            RFC.ACCION = LISTA.RFC.ACC<ACI>
            NACI.ACCION = LISTA.NAC.ACC<ACI>
            RESI.ACCION = LISTA.RESI.ACC<ACI>

            ACCIONISTAS := '<PERSONA_ACCIONISTAS ID="':ACI:'">'
            ACCIONISTAS := '<NOMBRE_ACCION>':NOMBRE.ACCION:'</NOMBRE_ACCION>'
            ACCIONISTAS := '<PORCE_ACCION>':PORCE.ACCION:'</PORCE_ACCION>'
            ACCIONISTAS := '<RFC_ACCION>':RFC.ACCION:'</RFC_ACCION>'
            ACCIONISTAS := '<NAC_ACCION>':NACI.ACCION:'</NAC_ACCION>'
            ACCIONISTAS := '<RESI_ACCION>':RESI.ACCION:'</RESI_ACCION>'
            ACCIONISTAS := '<PUESTO_ACCION>'::'</PUESTO_ACCION>'
            ACCIONISTAS := '</PERSONA_ACCIONISTAS>'
        NEXT ACI
    END

RETURN

***********
LEE.FIRMAS:
***********

    PER.AUT.NOMBRE.CTA = ""; PER.AUT.APE.PAT.CTA = ""; PER.AUT.APE.MAT.CTA = ""; PER.AUT.TIP.FIR.CTA = "";
    IF R.INFO.CUENTA.LT NE "" THEN
        PER.AUT.NOMBRE.CTA = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutNombre>
        PER.AUT.APE.PAT.CTA = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutApePat>
        PER.AUT.APE.MAT.CTA = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutApeMat>
        PER.AUT.TIP.FIR.CTA = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.PerAutTipFir>
    
        LISTA.FIRMAS = ''; LISTA.FIRMAS.APE.PAT = ''; LISTA.FIRMAS.APE.MAT = ''; LISTA.FIRMAS.TIP.FIR = '';
        LISTA.FIRMAS =  PER.AUT.NOMBRE.CTA
        CONVERT @SM TO @FM IN LISTA.FIRMAS
        LISTA.FIRMAS.APE.PAT = PER.AUT.APE.PAT.CTA
        CONVERT @SM TO @FM IN LISTA.FIRMAS.APE.PAT
        LISTA.FIRMAS.APE.MAT = PER.AUT.APE.MAT.CTA
        CONVERT @SM TO @FM IN LISTA.FIRMAS.APE.MAT
        LISTA.FIRMAS.TIP.FIR = PER.AUT.TIP.FIR.CTA
        CONVERT @SM TO @FM IN LISTA.FIRMAS.TIP.FIR
    END

    TOTAL.FIRMAS = DCOUNT(LISTA.FIRMAS, @FM)
    IF TOTAL.FIRMAS GT 0 THEN
        FOR FIRM = 1 TO TOTAL.FIRMAS
            NOMBRE.FIRMAS = ''; APE.PAT.FIRMAS = ''; APE.MAT.FIRMAS = ''; TIPO.FIRMAS = '';
            NOMBRE.FIRMAS = LISTA.FIRMAS<FIRM>
            APE.PAT.FIRMAS = LISTA.FIRMAS.APE.PAT<FIRM>
            IF APE.PAT.FIRMAS EQ 'XXX' THEN
                APE.PAT.FIRMAS = ''
            END
            APE.MAT.FIRMAS = LISTA.FIRMAS.APE.MAT<FIRM>
            IF APE.MAT.FIRMAS EQ 'XXX' THEN
                APE.MAT.FIRMAS = ''
            END
            TIPO.FIRMAS = LISTA.FIRMAS.TIP.FIR<FIRM>
            FIRMAS := '<FIRMA ID="':FIRM:'">'
            FIRMAS := '<NOMBRE_FIRMAS>':NOMBRE.FIRMAS:' ':APE.PAT.FIRMAS:' ':APE.MAT.FIRMAS:'</NOMBRE_FIRMAS>'
            FIRMAS := '<TIPO_FIRMAS>':TIPO.FIRMAS:'</TIPO_FIRMAS>'
            FIRMAS := '</FIRMA>'
        NEXT FIRM

    END

RETURN

***************
LEE.FACULTADOS:
***************

    LISTA.FACULTADOS = ''; LISTA.FACULTADOS.APE.PAT = ''; LISTA.FACULTADOS.APE.MAT = ''; LISTA.FACULTADOS.RELACION = ''; LISTA.FACULTADOS.TIPO = ''; LISTA.FACULTADOS.NUMERO = '';
    LISTA.FACULTADOS.FIRMA = ''
    IF R.INFO.CUENTA.LT NE "" THEN
        LISTA.FACULTADOS = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuNombre>
        CONVERT @SM TO @FM IN LISTA.FACULTADOS
        LISTA.FACULTADOS.APE.PAT = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuApePatern>
        CONVERT @SM TO @FM IN LISTA.FACULTADOS.APE.PAT
        LISTA.FACULTADOS.APE.MAT = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuApeMatern>
        CONVERT @SM TO @FM IN LISTA.FACULTADOS.APE.MAT
        LISTA.FACULTADOS.RELACION = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuStatus>
        CONVERT @SM TO @FM IN LISTA.FACULTADOS.RELACION
        LISTA.FACULTADOS.TIPO = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuIndetifica>
        CONVERT @SM TO @FM IN LISTA.FACULTADOS.TIPO
        LISTA.FACULTADOS.NUMERO = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuNroIdenti>
        CONVERT @SM TO @FM IN LISTA.FACULTADOS.NUMERO
        LISTA.FACULTADOS.FIRMA = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.FacuTipoFirma>
        CONVERT @SM TO @FM IN LISTA.FACULTADOS.FIRMA
    END

    TOTAL.FACULTADOS = DCOUNT(LISTA.FACULTADOS, @FM)
    IF TOTAL.FACULTADOS GT 0 THEN
        FOR FACU = 1 TO TOTAL.FACULTADOS
            NOMBRE.FACULTADOS = ''; APE.PAT.FACULTADOS = ''; APE.MAT.FACULTADOS = ''; RELACION.FACULTADOS = ''; TIPO.FACULTADOS = ''; NO.IDENT.FACULTADOS = '';
            NOMBRE.FACULTADOS = LISTA.FACULTADOS<FACU>
            APE.PAT.FACULTADOS = LISTA.FACULTADOS.APE.PAT<FACU>
            APE.MAT.FACULTADOS = LISTA.FACULTADOS.APE.MAT<FACU>
            RELACION.FACULTADOS = LISTA.FACULTADOS.RELACION<FACU>
            TIPO.FACULTADOS = LISTA.FACULTADOS.TIPO<FACU>
            NO.IDENT.FACULTADOS = LISTA.FACULTADOS.NUMERO<FACU>
            FIRMA.FACULTADOS = LISTA.FACULTADOS.FIRMA<FACU>
        NEXT FACU
        CHANGE @FM TO "~" IN FACULTADOS
    END

RETURN

*************
REF.BANCARIA:
*************
    
    REF.BAN.BANCO = ''; REF.BAN.CUENTA = ''; REF.BAN.TIP.CTA = ''; REF.BAN.ANT.A = ''; TOTAL.REF.BAN = '';
    REF.BAN.BANCO = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.BankReference>
    CONVERT @SM TO @FM IN REF.BAN.BANCO
    REF.BAN.CUENTA = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.AccountNumber>
    CONVERT @SM TO @FM IN REF.BAN.CUENTA
    REF.BAN.TIP.CTA = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.AccountType>
    CONVERT @SM TO @FM IN REF.BAN.TIP.CTA
    REF.BAN.ANT.A = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.LimitedCompany>
    CONVERT @SM TO @FM IN REF.BAN.ANT.A
    
    TOTAL.REF.BAN = DCOUNT(REF.BAN.BANCO, @FM)
    IF TOTAL.REF.BAN GT 0 THEN
        FOR BAN = 1 TO TOTAL.REF.BAN
            BANCO.REF.BAN = ''; BANCO.REF.CUENTA = ''; BANCO.REF.TIP.CTA = ''; ID.BANCOS = ''; ID.TIP.CTA = ''; BANCO.REF.ANT = '';
            ID.BANCOS = REF.BAN.BANCO<BAN>
            GOSUB LEE.BANCO
            BANCO.REF.BAN = DES.BANCO
            ID.TIP.CTA = REF.BAN.TIP.CTA<BAN>
            GOSUB LEE.TIP.CTA
            BANCO.REF.TIP.CTA = DES.TIPO.CTA
            BANCO.REF.CUENTA = REF.BAN.CUENTA<BAN>
            BANCO.REF.ANT = REF.BAN.ANT.A<BAN>

            REFERNCIAS.BANCARIAS := '<REFERENCIA_BANCARIA ID="':BAN:'">'
            REFERNCIAS.BANCARIAS := '<BANCO_REF_BAN>':BANCO.REF.BAN:'</BANCO_REF_BAN>'
            REFERNCIAS.BANCARIAS := '<BANCO_REF_TIP_CTA>':BANCO.REF.TIP.CTA:'</BANCO_REF_TIP_CTA>'
            REFERNCIAS.BANCARIAS := '<BANCO_REF_CUENTA>':BANCO.REF.CUENTA:'</BANCO_REF_CUENTA>'
            REFERNCIAS.BANCARIAS := '<BANCO_REF_ANT>':BANCO.REF.ANT:'</BANCO_REF_ANT>'
            REFERNCIAS.BANCARIAS := '</REFERENCIA_BANCARIA>'

        NEXT BAN

    END

RETURN

*************
REF.PERSONAL:
*************

    REF.A.PAT = ''; REF.A.MAT = ''; REF.NOM.1 = ''; REF.NOM.2 = ''; REF.TELEFONO = ''; TOTAL.REF.PER = ''; REF.DOMIC = ''; REF.PARENTESCO = '';
    REF.A.PAT = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ReferralLastName>
    CONVERT @SM TO @FM IN REF.A.PAT
    REF.A.MAT = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ReferralMotherMaidenName>
    CONVERT @SM TO @FM IN REF.A.MAT
    REF.NOM.1 = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ReferralFirstName>
    CONVERT @SM TO @FM IN REF.NOM.1
    REF.NOM.2 = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ReferralSecondName>
    CONVERT @SM TO @FM IN REF.NOM.2
    REF.TELEFONO = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ReferralTelephoneNumber>
    CONVERT @SM TO @FM IN REF.TELEFONO
    REF.DOMIC = R.INFO.CLIENTE.MXBASE<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.ReferralEmail>
    CONVERT @SM TO @FM IN REF.DOMIC

    TOTAL.REF.PER = DCOUNT(REF.A.PAT, @FM)
    IF TOTAL.REF.PER GT 0 THEN
        FOR REF = 1 TO TOTAL.REF.PER
            A.PAT.REF = ''; A.MAT.REF = ''; NOM.1.REF = ''; NOM.2.REF = ''; TELEFONO.REF = ''; DOMIC.REF = '' ; REF.NOMBRE.COMP = ''
            A.PAT.REF = REF.A.PAT<REF>
            A.MAT.REF = REF.A.MAT<REF>
            NOM.1.REF = REF.NOM.1<REF>
            NOM.2.REF = REF.NOM.2<REF>
            DOMIC.REF = REF.DOMIC<REF>
            TELEFONO.REF = REF.TELEFONO<REF>
            REF.NOMBRE.COMP = TRIM(NOM.1.REF:' ':NOM.2.REF:' ':A.PAT.REF:' ':A.MAT.REF)

            REFERENCIAS.PERSONALES := '<REFERENCIA_PERSONAL ID="':REF:'">'
            REFERENCIAS.PERSONALES := '<REF_NOMBRE_COMP>':REF.NOMBRE.COMP:'</REF_NOMBRE_COMP>'
            REFERENCIAS.PERSONALES := '<REF_DOMICILIO>':DOMIC.REF:'</REF_DOMICILIO>'
            REFERENCIAS.PERSONALES := '<REF_PARENTESCO>':REF.PARENTESCO:'</REF_PARENTESCO>'
            REFERENCIAS.PERSONALES := '<TELEFONO_REF>':TELEFONO.REF:'</TELEFONO_REF>'
            REFERENCIAS.PERSONALES := '</REFERENCIA_PERSONAL>'

        NEXT REF

    END

RETURN

****************
OBTEN.DOMICILIO:
****************

    CP.CLIENTE = "" ; NUMERO.DOMI = "" ; PAIS.CLIENTE = "" ; CALLE.CLIENTE = "" ; CIUDAD.CLIENTE = "" ; NUM.EXT.CLIENTE = "" ; NUM.INT.CLIENTE = ""
    ID.ESTADO = "" ; ID.CIUDAD = "" ; DOMICILIO.CLIENTE = "" ; ID.COLONIA = "" ; ID.CIUDAD.COT = "" ; ID.MUNICIPIO = "" ; TIPO.DOMI.CLI = ""
    ANTIGUEDAD.ANOS = "" ; ANTIGUEDAD.MESES = "" ; ANTIGUEDAD.DOMICILIO = "" ; COMPROBANTE.DOMI = "" ; CALLE.NUMERO = ""

    IF R.INFO.CLIENTE NE "" THEN
        ID.COMPROBANTE.DOMI = R.INFO.CLIENTE<ST.Customer.Customer.EbCusAddressType>

        ERROR.LOOKUP = "" ; R.INFO.LOOKUP = ""
        ID.EB.LOOKUP = 'ADDR.TYPE*':ID.COMPROBANTE.DOMI
        EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
        IF R.INFO.LOOKUP THEN
            COMPR.DOMI = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        END ELSE
            COMPR.DOMI = 'SIN ESPECIFICAR'
        END

        TIPO.DOMI.CLI        = R.INFO.CLIENTE<ST.Customer.Customer.EbCusResidenceType>
        ANTIGUEDAD.ANOS      = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.DOM.ANOS>
        ANTIGUEDAD.MESES     = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef, YPOS.DOM.MESES>
        ANTIGUEDAD.DOMICILIO = TRIM(ANTIGUEDAD.ANOS:' ':ANTIGUEDAD.MESES)
        CALLE.CLIENTE        = TRIM(R.INFO.CLIENTE<ST.Customer.Customer.EbCusStreet,1>)
        NUMERO.DOMI          = TRIM(R.INFO.CLIENTE<ST.Customer.Customer.EbCusAddress>)
        CHANGE @SM TO @FM IN NUMERO.DOMI
        CHANGE @VM TO @FM IN NUMERO.DOMI
        NUM.EXT.CLIENTE      = NUMERO.DOMI<1>
        NUM.INT.CLIENTE      = NUMERO.DOMI<2>
        IF NUM.EXT.CLIENTE EQ '' THEN
            CALLE.NUMERO = CALLE.CLIENTE: ", No. Int. ": NUM.INT.CLIENTE
        END
        IF NUM.INT.CLIENTE EQ '' THEN
            CALLE.NUMERO = CALLE.CLIENTE: ", No. Ext. ": NUM.EXT.CLIENTE
        END
        IF NUM.EXT.CLIENTE NE '' AND NUM.INT.CLIENTE NE '' THEN
            CALLE.NUMERO = CALLE.CLIENTE: ", No. Ext. ": NUM.EXT.CLIENTE: ", No. Int. ": NUM.INT.CLIENTE
        END
        IF CALLE.CLIENTE EQ '' AND NUM.EXT.CLIENTE EQ '' AND NUM.INT.CLIENTE EQ '' THEN
            CALLE.NUMERO = ''
        END
        ID.COLONIA           = R.INFO.CLIENTE<ST.Customer.Customer.EbCusSubDepartment>
        GOSUB LEE.COLONIA
        ID.PAIS              = R.INFO.CLIENTE<ST.Customer.Customer.EbCusResidence>
        GOSUB LEE.PAIS
        PAIS.CLIENTE         = DES.PAIS
        COLONIA.CLIENTE      = DES.COLONIA
        ID.CIUDAD            = R.INFO.CLIENTE<ST.Customer.Customer.EbCusTownCountry,1>
        CIUDAD.CLIENTE       = FIELD(ID.CIUDAD,'-',2)
        CIUDAD.CLIENTE       = TRIM(CIUDAD.CLIENTE)
        ID.MUNICIPIO         = R.INFO.CLIENTE<ST.Customer.Customer.EbCusDepartment>
        GOSUB LEE.MUNICIPIO
        MUNICIPIO.CLIENTE    = DES.MUNICIPIO
        ID.ESTADO            = R.INFO.CLIENTE<ST.Customer.Customer.EbCusCountrySubdivision>
        GOSUB LEE.ESTADO
        ESTADO.CLIENTE       = DES.ESTADO
        CP.CLIENTE           = R.INFO.CLIENTE<ST.Customer.Customer.EbCusPostCode>
        DOMICILIO.CLIENTE    = TRIM(CALLE.CLIENTE:YSEP.2:NUM.EXT.CLIENTE:YSEP.2:NUM.INT.CLIENTE:YSEP.2:COLONIA.CLIENTE:YSEP.2:MUNICIPIO.CLIENTE:YSEP.2:ESTADO.CLIENTE:YSEP.2:CIUDAD.CLIENTE:YSEP.2:PAIS.CLIENTE:YSEP.2:CP.CLIENTE)
    END

RETURN

************
LEE.COLONIA:
************

    ERROR.COLONIA = "" ; R.INFO.COLONIA = "" ; DES.COLONIA = ""
    EB.DataAccess.FRead(FN.COLONIA,ID.COLONIA,R.INFO.COLONIA,F.COLONIA,ERROR.COLONIA)

    IF ERROR.COLONIA EQ "" THEN
        DES.COLONIA = TRIM(R.INFO.COLONIA<AbcTable.AbcColonia.Colonia>)
        ID.COLONIA  = ""
    END

RETURN

************
LEE.TIPO.MORAL:
************

    Y.SECTOR = R.INFO.CLIENTE<ST.Customer.Customer.EbCusSector>

    ERROR.SECTOR = "" ; R.INFO.SECTOR = "" ; DES.SECTOR = ""
    EB.DataAccess.FRead(FN.SECTOR,Y.SECTOR,R.INFO.SECTOR,F.SECTOR,ERROR.SECTOR)
    IF ERROR.SECTOR EQ '' THEN
        DES.TIPO.MORAL = TRIM(R.INFO.SECTOR<ST.Config.Sector.EbSecDescription>)
        Y.SECTOR = ''
    END

RETURN

************
LEE.CIUDAD:
************
    
    ERROR.CIUDAD = "" ; R.INFO.CIUDAD = "" ; DES.CIUDAD = ""
    EB.DataAccess.FRead(FN.CIUDAD,ID.CIUDAD.COT,R.INFO.CIUDAD,F.CIUDAD,ERROR.CIUDAD)
    IF ERROR.CIUDAD EQ "" THEN
        DES.CIUDAD = TRIM(R.INFO.CIUDAD<AbcTable.AbcCiudad.Ciudad>)  ;*<VPM.CIUDAD>)
        ID.CIUDAD  = ""
    END

RETURN

**************************;                ***************************ROHH_20180906
ADMINISTRA.BANCA.INTERNET:
**************************

    R.ADMINISTRADORES         = ''
    Y.ERR.BANCA               = ''
    Y.FILE.ABC.BANCA.INTERNET = ''
    Y.NOMBRE.ADMIN            = ''
    Y.TIPO.ADMIN              = ''
    Y.CORREO.ADMIN            = ''
    Y.TEL.ADMIN               = ''
    ADMIN.BANCA.LINEA         = ''
    Y.TIPO.CONTRATO           = ''
    Y.TIPO.BANCA              = ''

*TODO : REVISAR ESTO, PENDIENTE REVISAR SI SE MIGRA LA TABLA
;*CALL F.READ(FN.ABC.BANCA.INTERNET,ID.CLIENTE,R.ADMINISTRADORES,F.ABC.BANCA.INTERNET,Y.ERR.BANCA)
    R.ADMINISTRADORES = AbcTable.AbcBancaInternet.Read(ID.CLIENTE, ERR.BANCA)

    IF R.ADMINISTRADORES THEN
        Y.NUM.ADMIN = DCOUNT(AbcTable.AbcBancaInternet.NombreAdmin, @VM) ;*DCOUNT(R.ADMINISTRADORES<ABC.BAN.INT.NOMBRE.ADMIN>, @VM)
        Y.TIPO.CONTRATO = R.ADMINISTRADORES<AbcTable.AbcBancaInternet.TipoContrato, 1> ;*<ABC.BAN.INT.TIPO.CONTRATO,1>
        Y.TIPO.BANCA = R.ADMINISTRADORES<AbcTable.AbcBancaInternet.TipoBanca, 1> ;*<ABC.BAN.INT.TIPO.BANCA,1>

        IF (Y.TIPO.CONTRATO[1,1] EQ "A" OR Y.TIPO.CONTRATO='') AND Y.NUM.ADMIN GE 1 THEN
            Y.NUM.ADMIN = 1
        END
        IF Y.TIPO.CONTRATO[1,1] EQ "B" AND Y.NUM.ADMIN GT 1 THEN
            Y.NUM.ADMIN = 2
        END

        FOR Y.AD = 1 TO Y.NUM.ADMIN

            Y.NOMBRE.ADMIN = R.ADMINISTRADORES<AbcTable.AbcBancaInternet.NombreAdmin,Y.AD>:" ":R.ADMINISTRADORES<AbcTable.AbcBancaInternet.ApPatAdmin,Y.AD>: " ":R.ADMINISTRADORES<AbcTable.AbcBancaInternet.ApMatAdmin,Y.AD>
            Y.TIPO.ADMIN = R.ADMINISTRADORES<AbcTable.AbcBancaInternet.FacultadesAdmin,Y.AD>
            Y.CORREO.ADMIN= R.ADMINISTRADORES<AbcTable.AbcBancaInternet.EmailAdmin,Y.AD>
            Y.TEL.ADMIN = R.ADMINISTRADORES<AbcTable.AbcBancaInternet.CelAdmin,Y.AD>

            IF Y.NUM.ADMIN EQ 1 THEN    ;*Es necesaria el cambio de etiquetas para subreporte dinamico
                ADMIN.BANCA.LINEA := '<ADMIN_BANCA ID="':Y.AD:'">'
                ADMIN.BANCA.LINEA := '<NOMBRE_ADMIN>':Y.NOMBRE.ADMIN:'</NOMBRE_ADMIN>'
                ADMIN.BANCA.LINEA := '<TIPO_ADMIN>':Y.TIPO.ADMIN:'</TIPO_ADMIN>'
                ADMIN.BANCA.LINEA := '<CORREO_ADMIN>':Y.CORREO.ADMIN:'</CORREO_ADMIN>'
                ADMIN.BANCA.LINEA := '<TEL_ADMIN>':Y.TEL.ADMIN:'</TEL_ADMIN>'
                ADMIN.BANCA.LINEA := '</ADMIN_BANCA>'

            END
            IF Y.NUM.ADMIN EQ 2 THEN    ;*Es necesaria el cambio de etiquetas para subreporte dinamico
                ADMIN.BANCA.LINEA := '<ADMIN_BANCA_M ID="':Y.AD:'">'
                ADMIN.BANCA.LINEA := '<NOMBRE_ADMIN_M>':Y.NOMBRE.ADMIN:'</NOMBRE_ADMIN_M>'
                ADMIN.BANCA.LINEA := '<TIPO_ADMIN_M>':Y.TIPO.ADMIN:'</TIPO_ADMIN_M>'
                ADMIN.BANCA.LINEA := '<CORREO_ADMIN_M>':Y.CORREO.ADMIN:'</CORREO_ADMIN_M>'
                ADMIN.BANCA.LINEA := '<TEL_ADMIN_M>':Y.TEL.ADMIN:'</TEL_ADMIN_M>'
                ADMIN.BANCA.LINEA := '</ADMIN_BANCA_M>'
            END
            Y.NOMBRE.ADMIN    = ''
            Y.TIPO.ADMIN      = ''
            Y.CORREO.ADMIN    = ''
            Y.TEL.ADMIN       = ''


        NEXT Y.AD
    END

RETURN
************************************************************************ROHH_20180906

************
LEE.DIR.SUC:
************
    
    Y.SELECT = "SELECT ": FN.BA.AC.SUCURSALES :" WITH SUCURSAL EQ ": ID.SUC
    Y.LIST = ""
    EB.DataAccess.Readlist(Y.SELECT,Y.LIST,"",Y.TOT.REC,Y.ERROR)
    
    IF Y.LIST THEN
        FOR Y.LOOP = 1 TO Y.TOT.REC
            Y.ID.SUCU = Y.LIST<Y.LOOP>
            R.INFO.SUC = ""

            EB.DataAccess.FRead(FN.BA.AC.SUCURSALES,Y.ID.SUCU,R.INFO.SUC,F.BA.AC.SUCURSALES,Y.ERR.SUC)
            IF R.INFO.SUC THEN
;*DESCRIP.ID.EDO = TRIM(R.INFO.SUC<BA.AC.SUC.DIR.CIUDAD>)
                DESCRIP.ID.EDO = TRIM(R.INFO.SUC<AbcTable.BaAcSucursales.DirCiudad>)
            END
        NEXT Y.LOOP
    END

RETURN

************
LEE.CIUDAD.EMP:
************

    ERROR.CIUDAD.EMP = "" ; R.INFO.CIUDAD.EMP = "" ; DES.CIUDAD.EMP = ""
    EB.DataAccess.FRead(FN.CIUDAD,ID.CIUDAD.EMP, R.INFO.CIUDAD.EMP,F.CIUDAD,ERROR.CIUDAD.EMP)
    IF ERROR.CIUDAD.EMP EQ "" THEN
        DES.CIUDAD.EMP = TRIM(R.INFO.CIUDAD.EMP<AbcTable.AbcCiudad.Ciudad>)
        ID.CIUDAD.EMP  = ""
    END

RETURN

************
LEE.ESTADO:
************

    ERROR.ESTADO = "" ; R.INFO.ESTADO = "" ; DES.ESTADO  = ""
    EB.DataAccess.FRead(FN.ESTADO,ID.ESTADO,R.INFO.ESTADO,F.ESTADO,ERROR.ESTADO)
    IF ERROR.ESTADO EQ "" THEN
        DES.ESTADO = TRIM(R.INFO.ESTADO<AbcTable.AbcEstado.Estado>)
        ID.ESTADO  = ""
    END

RETURN

***************
LEE.MUNICIPIO:
***************

    ERROR.MUNICIPIO = "" ; DES.MUNICIPIO = "" ; R.INFO.MUNICIPIO = ""
    EB.DataAccess.FRead(FN.MUNICIPIO,ID.MUNICIPIO,R.INFO.MUNICIPIO,F.MUNICIPIO,ERROR.MUNICIPIO)
    IF ERROR.MUNICIPIO EQ "" THEN
        DES.MUNICIPIO = R.INFO.MUNICIPIO<AbcTable.AbcMunicipio.Municipio>
        ID.MUNICIPIO  = ""
    END

RETURN

********
LEE.DAO:
********

    ERROR.DAO = ''; R.INFO.DAO = ''; NOMBRE.DAO = '';
    EB.DataAccess.FRead(FN.DAO,ID.DAO,R.INFO.DAO,F.DAO,ERROR.DAO)
    IF ERROR.DAO EQ '' THEN
        NOMBRE.DAO = TRIM(R.INFO.DAO<ST.Config.DeptAcctOfficer.EbDaoName>)
        ID.DAO = ''
    END

RETURN

*********
LEE.PAIS:
*********

    ERROR.PAIS = "" ; R.INFO.PAIS = "" ; DES.PAIS = ""
* -Se a bandera si campo local L.IMP.CRS.FATCA = NULL CRS TCA   **CCBC_20180406**
    Y.FLAG.CRS.FATCA = ""
    R.INFO.PAIS = ST.Config.Country.Read(ID.PAIS, ERROR.PAIS)
    IF ERROR.PAIS EQ "" THEN
        DES.PAIS = TRIM(R.INFO.PAIS<ST.Config.Country.EbCouCountryName>)
        ID.PAIS  = ""
        Y.FLAG.CRS.FATCA = TRIM(R.INFO.PAIS<ST.Config.Country.EbCouLocalRef, YPOS.CRS.FATCA>)
        IF Y.FLAG.CRS.FATCA NE 'CRS' OR Y.FLAG.CRS.FATCA NE 'FATCA' THEN
            Y.FLAG.CRS.FATCA = 'NO'
        END
    END

RETURN

**************
LEE.PROFESION:
**************
    
    Y.JOB.TITLE.ID = R.INFO.CLIENTE<ST.Customer.Customer.EbCusJobTitle>

    EB.DataAccess.FRead(FN.JOB.TITLE,Y.JOB.TITLE.ID,R.JOB.TITLE,F.JOB.TITLE,ERROR.JOB)
    IF ERROR.JOB EQ '' THEN
        DES.PROFESION =  R.JOB.TITLE<ST.Customer.JobTitle.EbJtiDescription>
        ID.SECTOR = ''
    END

RETURN

**************
LEE.OCUPACION:
**************

    ERROR.OCUPA = "" ; R.INFO.OCUPA = "" ;

    ERROR.LOOKUP = "" ; R.INFO.LOOKUP = "" ; DES.OCUPACION = ""
    ID.EB.LOOKUP = 'ABC.OCUPACION*':ID.OCUPACION
    EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
    IF ERROR.LOOKUP EQ '' THEN
        DES.OCUPACION = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        ID.OCUPACION = ""
    END

RETURN

********COLL20190218*********
LEE.ESTADO.CIVIL:
*****************************

    ERROR.LOOKUP = "" ; R.INFO.LOOKUP = "" ; DES.ESTADO.CIVIL = ''
    ID.EB.LOOKUP = 'MARITAL.STATUS*':ID.ESTADO.CIVIL
    EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
    IF ERROR.LOOKUP EQ '' THEN
        DES.ESTADO.CIVIL = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        ID.ESTADO.CIVIL = ''
    END

RETURN

****************
LEE.TIPO.EMPLEO:
****************
    
    ERROR.LOOKUP = "" ; R.INFO.LOOKUP = "" ; DES.TIPO.EMPLEO = ''
    ID.EB.LOOKUP = 'EMPLOYMENT.STATUS*':ID.TIPO.EMPLEO
    EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
    IF ERROR.LOOKUP EQ '' THEN
        DES.TIPO.EMPLEO = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        ID.TIPO.EMPLEO = ''
    END

RETURN

****************
LEE.COBER.GEO:
****************

    ERROR.LOOKUP = "" ; R.INFO.LOOKUP = "" ; DESC.COB.GEO = ''
    ID.EB.LOOKUP = 'COB.GEO*':COBERTURA.GEO
    EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
    IF ERROR.LOOKUP EQ '' THEN
        DESC.COB.GEO = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        COBERTURA.GEO = ''
    END

RETURN

********FIN.COLL20190218*********
LEE.GIRO.MER:
*********************************
    
*Requiere tomar valor de Local Table (ID.SECT.EMP)
    DES.SECT.EMP = ""
    IF ID.SECT.EMP THEN
        BEGIN CASE
            CASE ID.SECT.EMP EQ 1
                DES.SECT.EMP = 'SERVICIOS'
            CASE ID.SECT.EMP EQ 2
                DES.SECT.EMP = 'COMERCIAL'
            CASE ID.SECT.EMP EQ 3
                DES.SECT.EMP = 'INDUSTRIAL'
            CASE ID.SECT.EMP EQ 4
                DES.SECT.EMP = 'OTROS'
        END CASE
        ID.SECT.EMP = ""
    END

RETURN

***********
LEE.SECTOR:
***********
    
    ERROR.SECTOR = "" ; R.INFO.SECTOR = "" ; DES.SECTOR = "" ;* LFCR_20251006_SECTOR_MXBASE - S
    
;*    EB.DataAccess.FRead(FN.SECTOR,ID.SECTOR,R.INFO.SECTOR,F.SECTOR,ERROR.SECTOR)
    R.MXBASE.RegCode = MXBASE.CustomerRegulatory.MxbaseRegulatoryCodes.Read(ID.SECTOR, ErrorSector)

    IF ErrorSector EQ "" THEN
        DES.SECTOR = TRIM(R.INFO.SECTOR<ST.Config.Sector.EbSecDescription>)
        DES.SECTOR = TRIM(R.MXBASE.RegCode<MXBASE.CustomerRegulatory.MxbaseRegulatoryCodes.Description>)
        ID.SECTOR = ''
    END
*    IF ERROR.SECTOR EQ '' THEN
*        DES.SECTOR = TRIM(R.INFO.SECTOR<ST.Config.Sector.EbSecDescription>)
*        ID.SECTOR = ''
*    END ;* LFCR_20251006_SECTOR_MXBASE - E

RETURN
***********
LEE.IVA:
***********

    ARR.ID = R.INFO.CUENTA<AC.AccountOpening.Account.ArrangementId>
    Y.TODAY = EB.SystemTables.getToday()
    EFF.DATE = Y.TODAY
    EFF.RATE=''
    IntCondition= ''
    Y.NOMBRE.RUTINA = "ABC.NOFILE.REPORTE.CONTRATOS"
    Y.CADENA.LOG<-1> =  "ARR.ID->" : ARR.ID
    Y.CADENA.LOG<-1> =  "Y.TODAY->" : Y.TODAY
    Y.CADENA.LOG<-1> =  "EFF.DATE->" : EFF.DATE
            
    AA.Framework.GetArrangementConditions(ARR.ID, 'INTEREST', '', EFF.DATE, r.int.Ids, IntCondition, r.Error)
    IntCondition = RAISE(IntCondition)
    EFF.RATE   = IntCondition<AA.Interest.Interest.IntEffectiveRate> ;*<AA.INT.EFFECTIVE.RATE>
    EFF.RATE   = EFF.RATE<1,1>
    
    IVA.GRUPO = EFF.RATE
    
    Y.NOMBRE.RUTINA = "ABC.NOFILE.REPORTE.CONTRATOS"
    Y.CADENA.LOG<-1> =  "EFF.RATE->" : EFF.RATE
    Y.CADENA.LOG<-1> =  "IVA.GRUPO->" : IVA.GRUPO
    

*    Y.SELECT = "SELECT ": FN.GROUP.CREDIT.INT : " WITH @ID LIKE ": GRUPO.COND : "MXN... BY-DSND @ID" ;* SE DESESTIMA PARA MIGRACION A R24 - S
*    Y.LIST = "" ; IVA.GRUPO = "" ; R.INFO.IVA = "" ; MNT.IVA.GRUPO = ""
*
*    EB.DataAccess.Readlist(Y.SELECT,Y.LIST,"",Y.TOT.REC,Y.ERROR)
*
*    IF Y.LIST THEN
*        Y.ID.IVA = Y.LIST<1>
*        EB.DataAccess.FRead(FN.GROUP.CREDIT.INT,Y.ID.IVA,R.INFO.IVA,F.GROUP.CREDIT.INT,Y.ERR.IVA)
*        IF R.INFO.IVA THEN
*            Y.IVA.CAMPO = R.INFO.IVA<IC.Config.GroupCreditInt.GciCrIntRate>
*            Y.NO.VAL = DCOUNT(Y.IVA.CAMPO, @VM)
*            IF BAND.PRINT.GAT EQ "SI" THEN        ;* LFCR_20240425_TASA_GAT - S
*                IVA.GRUPO = Y.IVA.CAMPO<1,1>
*            END ELSE
*                IVA.GRUPO = Y.IVA.CAMPO<1,Y.NO.VAL>
*            END
**IVA.GRUPO = Y.IVA.CAMPO<1,Y.NO.VAL> ;* LFCR_20240425_TASA_GAT - E
*******CAMBIO CHRISTIAN****************************************************************************
*            Y.IVA.MNT.CAMP = R.INFO.IVA<IC.Config.GroupCreditInt.GciCrLimitAmt>
*            Y.NO.VAL.MNT = DCOUNT(Y.IVA.MNT.CAMP, @VM) - 1
*            MNT.IVA.GRUPO = Y.IVA.MNT.CAMP<1,Y.NO.VAL.MNT> + 0.01
***************************************************************************************************
*        END
*
*    END ;* SE DESESTIMA PARA MIGRACION A R24 - S

RETURN

**************
LEE.INDUSTRIA:
**************

    ERROR.INDUSTRIA = "" ; R.INFO.INDUSTRIA = "" ; DES.INDUSTRIA = ""
    EB.DataAccess.FRead(FN.INDUSTRIA,ID.INDUSTRIA,R.INFO.INDUSTRIA,F.INDUSTRIA,ERROR.INDUSTRIA)
    IF ERROR.INDUSTRIA EQ '' THEN
        DES.INDUSTRIA = TRIM(R.INFO.INDUSTRIA<ST.Config.Industry.EbIndDescription>)
        ID.INDUSTRIA = ''
    END

RETURN

************
LEE.ACT.ECO:
************
    
    ERROR.ACT.ECO = "" ; R.INFO.ACT.ECO = "" ; DES.ACT.ECO = "" ; ACT.VULNERABLE = ""
         
;*EB.DataAccess.FRead(FN.ACT.ECO,ID.ACT.ECO,R.INFO.ACT.ECO,F.ACT.ECO,ERROR.ACT.ECO)
    R.INFO.ACT.ECO = MXBASE.CustomerRegulatory.MxbaseRegulatoryCodes.Read(ID.ACT.ECO, ERROR.ACT.ECO)
    IF ERROR.ACT.ECO EQ '' THEN
        DES.ACT.ECO = TRIM(R.INFO.ACT.ECO<AbcTable.AbcActividadEconomica.Descripcion>)
        ACT.VULNERABLE = TRIM(R.INFO.ACT.ECO<AbcTable.AbcActividadEconomica.Vulnerable>)
        ID.ACT.ECO = ''
    END
    IF ACT.VULNERABLE EQ '' THEN
        ACT.VULNERABLE = 'NO'
    END

RETURN

****************
LEE.TIPO.INDENT:
****************
    Y.CADENA.LOG<-1> = "--LEE.TIPO.INDENT--"
    ERROR.LOOKUP = "" ; R.INFO.LOOKUP = "" ; DES.TIPO.INDENT = ""
    ID.EB.LOOKUP = 'CUS.LEGAL.DOC.NAME*':ID.TIP.IDEN
    Y.CADENA.LOG<-1> = "ID.EB.LOOKUP->" : ID.EB.LOOKUP
    EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
    Y.CADENA.LOG<-1> = "R.INFO.LOOKUP->" : R.INFO.LOOKUP
    IF ERROR.LOOKUP EQ '' THEN
;*DES.TIPO.INDENT = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        DES.TIPO.INDENT = R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>
        Y.CADENA.LOG<-1> = "ERROR.LOOKUP EQ ''"
        Y.CADENA.LOG<-1> = "ERROR.LOOKUP EQ ''"
        ID.TIP.IDEN = ''
    END
    Y.CADENA.LOG<-1> = "DES.TIPO.INDENT->" : DES.TIPO.INDENT
RETURN

**********
LEE.BANCO:
**********
    
    ERROR.LOOKUP.BANCO = "" ; R.INFO.LOOKUP.BANCO = "" ; DES.BANCO = ""
    ID.EB.LOOKUP.BANCO = 'CLB.BANK.CODE*':ID.BANCOS
    EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP.BANCO,R.INFO.LOOKUP.BANCO,F.LOOKUP,ERROR.LOOKUP.BANCO)
    IF ERROR.LOOKUP.BANCO EQ "" THEN
        DES.BANCO = TRIM(R.INFO.BANCO<AbcTable.AbcBancos.ClavePuntoTrans>)
        ID.BANCOS = ""
    END

RETURN
************
LEE.TIP.CTA:
************
**TODO : pENDIENTE CONFIRMAR SI SE MIGRA ESTA TABLA
*    ERROR.TIP.CTA = "" ; R.INFO.TIP.CTA = "" ; DES.TIPO.CTA = ""
*    CALL F.READ(FN.TIP.CTA,ID.TIP.CTA,R.INFO.TIP.CTA,F.TIP.CTA,ERROR.TIP.CTA)
*    IF ERROR.TIP.CTA EQ "" THEN
*        DES.TIPO.CTA  = TRIM(R.INFO.TIP.CTA<1>)
*        ID.TIP.CTA    = ""
*    END
    DES.TIPO.CTA = ''

RETURN

*************
LEE.SOCIEDAD:
*************

    R.MXBASE.ADD.CUSTOMER.DETAILS = MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Read(ID.CLIENTE,Y.ERROR)

    IF Y.ERROR EQ "" THEN
        DES.TIPO.SOCIEDAD = TRIM(R.MXBASE.ADD.CUSTOMER.DETAILS<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.BanxicoEcoActivity>)
        ABR.TIPO.SOCIEDAD = TRIM(R.MXBASE.ADD.CUSTOMER.DETAILS<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.BanxicoEcoActivityCode>)
    END

RETURN

************
LEE.SEC.ECO:
************

    ERROR.SOC.ECO = "" ; R.INFO.SOC.ECO = ""

    ERROR.LOOKUP = "" ; R.INFO.LOOKUP = "" ; DES.SECTOR.ECONOMICO = ""
    ID.EB.LOOKUP = 'SECTOR.ECONOMICO*':ID.TIPO.GIRO
    EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
    IF ERROR.LOOKUP EQ '' THEN
        DES.SECTOR.ECONOMICO = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        ID.TIPO.GIRO = ""
    END

RETURN

****************
LEE.DESTINO:
****************

    ERROR.LOOKUP    = ""
    R.INFO.LOOKUP   = ""
    DES.DESTIN.RECURSOS = ""
    ID.EB.LOOKUP = 'ABC.DESTINO.RECURSO*':ID.DESTIN.RECURSOS
    EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
    IF ERROR.LOOKUP EQ '' THEN
        DES.DESTIN.RECURSOS = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        ID.DESTIN.RECURSOS = ''
    END

RETURN

****************
LEE.TIPO.IDENTIF:
****************

    ERROR.LOOKUP    = ""
    R.INFO.LOOKUP   = ""
    DES.TIPO.IDENTIF = ""
    ID.EB.LOOKUP = 'CUS.LEGAL.DOC.NAME*':ID.TIPO.IDENTIF
    EB.DataAccess.FRead(FN.LOOKUP,ID.EB.LOOKUP,R.INFO.LOOKUP,F.LOOKUP,ERROR.LOOKUP)
    IF ERROR.LOOKUP EQ '' THEN
        DES.TIPO.IDENTIF = TRIM(R.INFO.LOOKUP<EB.Template.Lookup.LuDescription,1>)
        ID.TIPO.IDENTIF = ''
    END

RETURN

**************
LEE.FIRM.CONT:
**************

    ERROR.FIRMANTE  = ""
    R.INFO.FIRMANTE = ""
    DES.FIRMANTE    = ""

    Y.FLAG.CON.GENT.AUT = 1
    Y.CADENA.LOG<-1> = "--LEE.FIRM.CONT--"
    EB.DataAccess.FRead(FN.ABC.FIRMANTE.CONTRATO,ID.FIRMANTE,R.INFO.FIRMANTE,F.ABC.FIRMANTE.CONTRATO,ERROR.FIRMANTE)
    Y.CADENA.LOG<-1> = "ID.FIRMANTE->" : ID.FIRMANTE
    IF ERROR.FIRMANTE EQ "" THEN
        DES.FIRMANTE = TRIM(R.INFO.FIRMANTE<AbcTable.AbcFirmanteContrato.FrContNombre>: " ": R.INFO.FIRMANTE<AbcTable.AbcFirmanteContrato.ApellidoPaterno>: " ": R.INFO.FIRMANTE<AbcTable.AbcFirmanteContrato.ApellidoMaterno>)
        Y.CADENA.LOG<-1> = "DES.FIRMANTE->" : DES.FIRMANTE
        ID.FIRMANTE = ""
    END

RETURN

***********
GENERA.XML:
***********

    Y.XML = '<?xml version="1.0" encoding="UTF-8"?>'
    Y.XML := '<Datos>'
    Y.XML := '<TIPO_FORMATO>':TIPO.FORMATO:'</TIPO_FORMATO>'

    GOSUB XML.BLOQUE.INICIO

    IF CLASSIFICATION LT 2001 THEN
*IF CLASSIFICATION LT 3 THEN
        GOSUB XML.BLOQUE.PF
        GOSUB XML.ANEXO.PF
    END ELSE
        GOSUB XML.BLOQUE.PM
        GOSUB XML.ANEXO.PM
    END

    GOSUB XML.BLOQUE.FINAL

    Y.XML := '</Datos>'
    
RETURN

******************
TEL.CEL.CLI.LETRA:
******************

    TELEFONO.CONT = 0
    TELEFONO.NUMERO = ''
    NUM.TEL.NUMERO = ''
    LON.TEL = LEN(Y.AC.CELULAR.ASOCIADO)          ;*ROHH_20180906   Se corrige numero celular asociado a cuenta
    IF LON.TEL EQ 10 THEN
        FOR I.TEL = 1 TO LON.TEL
            NUM.AUX = Y.AC.CELULAR.ASOCIADO[I.TEL,1]
            IF NUM.AUX NE '' THEN
                BEGIN CASE
                    CASE NUM.AUX EQ 1
                        NUM.TEL.CLI = " 1     UNO"
                    CASE NUM.AUX EQ 2
                        NUM.TEL.CLI = " 2     DOS"
                    CASE NUM.AUX EQ 3
                        NUM.TEL.CLI = " 3     TRES"
                    CASE NUM.AUX EQ 4
                        NUM.TEL.CLI = " 4     CUATRO"
                    CASE NUM.AUX EQ 5
                        NUM.TEL.CLI = " 5     CINCO"
                    CASE NUM.AUX EQ 6
                        NUM.TEL.CLI = " 6     SEIS"
                    CASE NUM.AUX EQ 7
                        NUM.TEL.CLI = " 7     SIETE"
                    CASE NUM.AUX EQ 8
                        NUM.TEL.CLI = " 8     OCHO"
                    CASE NUM.AUX EQ 9
                        NUM.TEL.CLI = " 9     NUEVE"
                    CASE NUM.AUX EQ 0
                        NUM.TEL.CLI = " 0     CERO"
                END CASE
                TELEFONO.CONT += 1
                TELEFONO.NUMERO:='<TEL_CEL_CLI_NUM_':TELEFONO.CONT:'>':NUM.TEL.CLI:'</TEL_CEL_CLI_NUM_':TELEFONO.CONT:'>'
            END
        NEXT I.TEL
    END

RETURN

******************----------------------------------------------------LFCR_20211118_UALA - S
TEL.CEL.CLI.DIGS:
******************

    TELEFONO.CONT = 0
    TELEFONO.DIGITOS = ''
    NUM.TEL.NUMERO = ''
    LON.TEL = LEN(Y.AC.CELULAR.ASOCIADO)
    IF LON.TEL EQ 10 THEN
        FOR I.TEL = 1 TO LON.TEL
            NUM.AUX = Y.AC.CELULAR.ASOCIADO[I.TEL,1]
            IF NUM.AUX NE '' THEN
                TELEFONO.CONT += 1
                TELEFONO.DIGITOS:='<CELU_DIG_NUM_':TELEFONO.CONT:'>':NUM.AUX:'</CELU_DIG_NUM_':TELEFONO.CONT:'>'
            END
        NEXT I.TEL
    END
    

RETURN
*----------------------------------------------------------------------LFCR_20211118_UALA - E
******************
XML.BLOQUE.INICIO:
******************

    Y.XML := '<NOM_EJECUTIVO>':NOM.EJECUTIVO:'</NOM_EJECUTIVO>'
    Y.XML := '<NUM_EJECUTIVO>':NUM.EJECUTIVO:'</NUM_EJECUTIVO>'
    Y.XML := '<NOM_SUCURSAL>':NOM.SUCURSAL:'</NOM_SUCURSAL>'
    Y.XML := '<NUM_SUCURSAL>':NUM.SUCURSAL:'</NUM_SUCURSAL>'
    Y.XML := '<RZN_SCL_SHORT>':Y.RAZON.SOCIAL.SHORT:'</RZN_SCL_SHORT>'          ;*20241029_RZN.SCL - S
    Y.XML := '<RZN_SCL_FULL>':Y.RAZON.SOCIAL.FULL:'</RZN_SCL_FULL>'
    Y.XML := '<DIR_SITIO_WEB>':Y.DIR.SITIO.WEB:'</DIR_SITIO_WEB>'     ;*20241029_RZN.SCL - E
    Y.XML := '<ID_CLIENTE>':ID.CLIENTE:'</ID_CLIENTE>'
    Y.XML := '<ID_CUENTA>':ID.CUENTA:'</ID_CUENTA>'
    Y.XML := '<CTA_CLABE>':CTA.CLABE:'</CTA_CLABE>'
    Y.XML := '<CATEGORIA_CTA>':CATEGORIA.CTA:'</CATEGORIA_CTA>'
    Y.XML := '<CANAL_CTA>':Y.CANAL.CTA:'</CANAL_CTA>'       ;*LFCR_20220728 S - E
*--------------------------------------------------------%% CCBC_20180503 %%-S
    Y.XML := '<NOM_COMERCIAL_PROD>':NAME.PROD.COMECIAL:'</NOM_COMERCIAL_PROD>'
*----------------------------------------------------------------------------E
    Y.XML := '<NUMERO_RECA>':Y.NUMERO.RECA:'</NUMERO_RECA>'
    Y.XML := '<SEL_SERVICIO>':SEL.SERVICIO:'</SEL_SERVICIO>'
    Y.XML :=  MED.DISPOSICION
    Y.XML := '<CALLE_CLIENTE>':CALLE.NUMERO:'</CALLE_CLIENTE>'
    Y.XML := '<NUM_EXT_CLIENTE>':NUM.EXT.CLIENTE:'</NUM_EXT_CLIENTE>'
    Y.XML := '<NUM_INT_CLIENTE>':NUM.INT.CLIENTE:'</NUM_INT_CLIENTE>'
    Y.XML := '<COLONIA_CLIENTE>':COLONIA.CLIENTE:'</COLONIA_CLIENTE>'
    Y.XML := '<MUNICIPIO_CLIENTE>':MUNICIPIO.CLIENTE:'</MUNICIPIO_CLIENTE>'
    Y.XML := '<ESTADO_CLIENTE>':ESTADO.CLIENTE:'</ESTADO_CLIENTE>'
    Y.XML := '<CIUDAD_CLIENTE>':ESTADO.CLIENTE:'</CIUDAD_CLIENTE>'
    Y.XML := '<CP_CLIENTE>':CP.CLIENTE:'</CP_CLIENTE>'
    Y.XML := '<PAIS_CLIENTE>':PAIS.CLIENTE:'</PAIS_CLIENTE>'
    Y.XML := '<FECHA_REG_PUB>':FECHA.REG.PUB:'</FECHA_REG_PUB>'
    Y.XML := '<TIENEFIR_ELEC>':TIENEFIR.ELEC:'</TIENEFIR_ELEC>'
    Y.XML := '<FIRMA_ELECTRO>':FIRMA.ELECTRO:'</FIRMA_ELECTRO>'
    Y.XML := '<TIPO_INDENT_CLI>':TIPO.INDENT.CLI:'</TIPO_INDENT_CLI>'
    Y.XML := '<NUME_INDENT_CLI>':NUME.INDENT.CLI:'</NUME_INDENT_CLI>'
    Y.XML := '<VIGE_INDENT_CLI>':VIGE.INDENT.CLI:'</VIGE_INDENT_CLI>'
    Y.XML := '<COMPR_DOMI>':COMPR.DOMI:'</COMPR_DOMI>'
    Y.XML := '<TEL_DOMI_CLI>':TEL.DOMI.CLI:'</TEL_DOMI_CLI>'
    Y.XML := '<TEL_CEL_CLI>':TEL.CEL.CLI:'</TEL_CEL_CLI>'
    Y.XML := TELEFONO.NUMERO
    Y.XML := TELEFONO.DIGITOS
    Y.XML := '<CORREO_CLIENTE>':CORREO.CLIENTE:'</CORREO_CLIENTE>'
    Y.XML := '<PROFESION_CLI>':PROFESION.CLI:'</PROFESION_CLI>'
    Y.XML := '<NOM_EMPRESA>':NOM.EMPRESA:'</NOM_EMPRESA>'
    Y.XML := '<CALLE_EMP>':CALLE.EMP:'</CALLE_EMP>'
    Y.XML := '<NUM_EXT_EMP>':NUM.EXT.EMP:'</NUM_EXT_EMP>'
    Y.XML := '<NUM_INT_EMP>':NUM.INT.EMP:'</NUM_INT_EMP>'
    Y.XML := '<COLONIA_EMP>':COLONIA.EMP:'</COLONIA_EMP>'
    Y.XML := '<DEL_EMP>':DEL.EMP:'</DEL_EMP>'
    Y.XML := '<ENTI_EMP>':ENTI.EMP:'</ENTI_EMP>'
    Y.XML := '<CIUDAD_EMP>':DESCR.CIUDAD.EMP:'</CIUDAD_EMP>'
    Y.XML := '<COD_PO_EMP>':COD.PO.EMP:'</COD_PO_EMP>'
    Y.XML := '<PAIS_EMP>':PAIS.EMP:'</PAIS_EMP>'
    Y.XML := '<TIPO_EMPLEO>':TIPO.EMPLEO:'</TIPO_EMPLEO>'
    Y.XML := '<GIRO_MERCANTIL>':SECTOR.EMP:'</GIRO_MERCANTIL>'
    Y.XML := '<PUESTO>':PUESTO:'</PUESTO>'
    Y.XML := '<INGR_MEN_BR>':INGR.MEN.BR:'</INGR_MEN_BR>'
    Y.XML := '<TEL_EMPRESA>':TEL.EMPRESA:'</TEL_EMPRESA>'
    Y.XML := '<ACT_ECONO_EMP>':ACT.ECONO.EMP:'</ACT_ECONO_EMP>'
    Y.XML := '<ACT_VULNERABLE>':AC.VULNERABLE:'</ACT_VULNERABLE>'
    Y.XML := '<PROCED_RECURSOS>':PROCED.RECURSOS:'</PROCED_RECURSOS>'
    Y.XML := '<USO_CUENTA>':USO.CUENTA:'</USO_CUENTA>'
    Y.XML := '<OTRO_USO_CTA>':OTRO.USO.CTA:'</OTRO_USO_CTA>'
    Y.XML := '<REFERNCIAS_BANCARIAS>':REFERNCIAS.BANCARIAS:'</REFERNCIAS_BANCARIAS>'
    Y.XML := '<DESTIN_RECURSOS>':DESTIN.RECURSOS:'</DESTIN_RECURSOS>'
    Y.XML := '<OTRO_DESTIN_RECURSOS>':ID.OTRO.DESTIN.REC:'</OTRO_DESTIN_RECURSOS>'
    Y.XML := '<PER_POL_EXP>':PER.POL.EXP:'</PER_POL_EXP>'
    Y.XML := '<PUESTO_ULT_ANIO>':PUESTO.ULT.ANIO:'</PUESTO_ULT_ANIO>'
    Y.XML := '<NOM_PER_POL_EXP>':NOM.PER.POL.EXP:'</NOM_PER_POL_EXP>'
    Y.XML := '<TIPO_PER_POL_EX>':TIPO.PER.POL.EX:'</TIPO_PER_POL_EX>'

    Y.XML := '<COBERTURA_GEO>':DESC.COB.GEO:'</COBERTURA_GEO>'
    Y.XML := '<NUM_EMPLEADOS>':NUM.EMPLEADOS:'</NUM_EMPLEADOS>'
    Y.XML := '<NO_EDO_PRES>':TOTAL.SUCURSALES:'</NO_EDO_PRES>'
    Y.XML := '<MTO_IMPORTACION>':MTO.IMPORTACION:'</MTO_IMPORTACION>'
    Y.XML := '<MTO_EXPORTACION>':MTO.EXPORTACION:'</MTO_EXPORTACION>'
    Y.XML := '<PAIS_IMPORTACION>':PAIS.IMPORTACION:'</PAIS_IMPORTACION>'
    Y.XML := '<PAIS_EXPORTACION>':PAIS.EXPORTACION:'</PAIS_EXPORTACION>'
    Y.XML := '<TIENE_EXPORTACION>':TIENE.EXPORTACION:'</TIENE_EXPORTACION>'
    Y.XML := '<TIENE_IMPORTACION>':TIENE.IMPORTACION:'</TIENE_IMPORTACION>'
    Y.XML := '<VENTAS_TOT_ANUAL>':VENTAS.TOT.ANUAL:'</VENTAS_TOT_ANUAL>'
    Y.XML := '<CIUDAD_SUCURSALES>':CIUDAD.SUCURSALES:'</CIUDAD_SUCURSALES>'
    Y.XML := '<TOTAL_ACTIVOS>':TOTAL.ACTIVOS:'</TOTAL_ACTIVOS>'
    Y.XML := '<TOTAL_PASIVOS>':TOTAL.PASIVOS:'</TOTAL_PASIVOS>'
    Y.XML := '<CAPITAL_CONTABLE>':CAPITAL.CONTABLE:'</CAPITAL_CONTABLE>'
    Y.XML := '<DEPOS_TIPO>':DEPOS.TIPO:'</DEPOS_TIPO>'
    Y.XML := '<DEPOS_APRX_MEN>':DEPOS.APRX.MEN:'</DEPOS_APRX_MEN>'
    Y.XML := '<DEPOS_NUM_MEN>':DEPOS.NUM.MEN:'</DEPOS_NUM_MEN>'
    Y.XML := '<RETIR_TIPO>':RETIR.TIPO:'</RETIR_TIPO>'
    Y.XML := '<RETIR_APRX_MEN>':RETIR.APRX.MEN:'</RETIR_APRX_MEN>'
    Y.XML := '<RETIR_NUM_MEN>':RETIR.NUM.MEN:'</RETIR_NUM_MEN>'
    Y.XML := '<FECHA_APERTURA>':FECHA.APERTURA:'</FECHA_APERTURA>'
    Y.XML := '<FECHA_IMPRESION>':EB.SystemTables.getToday():'</FECHA_IMPRESION>'
RETURN

**************
XML.BLOQUE.PF:
**************
    Y.XML := '<NOMBRE_CLIENTE>':NOMBRE.CLIENTE:'</NOMBRE_CLIENTE>'
    Y.XML := '<FECHA_NAC_CLI>':FECHA.NAC.CLI:'</FECHA_NAC_CLI>'
    Y.XML := '<LUG_NAC_CLI>':LUG.NAC.CLI:'</LUG_NAC_CLI>'
    Y.XML := '<RESIDENCIA_EU_CLI>':RESIDENCIA.EU.CLI:'</RESIDENCIA_EU_CLI>'
    Y.XML := '<RFC_CLIENTE>':RFC.CLIENTE:'</RFC_CLIENTE>'
    Y.XML := '<CURP_CLIENTE>':CURP.CLIENTE:'</CURP_CLIENTE>'
    Y.XML := '<SEXO_CLIENTE>':SEXO.CLIENTE:'</SEXO_CLIENTE>'
    Y.XML := '<NACIONALIDAD_CLI>':NACIONALIDAD.CLI:'</NACIONALIDAD_CLI>'
    Y.XML := '<RESIDENCIA_CLI>':RESIDENCIA:'</RESIDENCIA_CLI>'
    Y.XML := '<ESTADO_CIVIL_CLI>':ESTADO.CIVIL.CLI:'</ESTADO_CIVIL_CLI>'
    Y.XML := '<NOMBRE_CONYUGE>':NOMBRE.CONYUGE:'</NOMBRE_CONYUGE>'
    Y.XML := '<CIUDAD_SUC>':DESCR.CIUDAD:'</CIUDAD_SUC>'

RETURN

**************
XML.ANEXO.PF:
**************


    Y.XML := '<NIVEL>':NIVEL:'</NIVEL>'
    Y.XML := '<REGIMEN_CONYUGAL>':REGIMEN.CONYUGAL:'</REGIMEN_CONYUGAL>'
    Y.XML := '<SALIDA_CONTITULAR>':SALIDA.CONTITULAR:'</SALIDA_CONTITULAR>'
    Y.XML := '<SALIDA_BENEFICIARIO>':SALIDA.BENEFICIARIO:'</SALIDA_BENEFICIARIO>'

    TIPO.SOCIEDAD = ""
    RAZON.SOCIAL = ""
    CATEGORIA.CTA = ""
    OTRO.USO.CTA = ""

RETURN

*****************
XML.BLOQUE.FINAL:
*****************
    Y.XML := '<NUM_SUCURSALES>':NUM.DE.SUCUR:'</NUM_SUCURSALES>'      ;*ROHH_20181127
    Y.XML := '<REFERENCIAS_PERSONALES>':REFERENCIAS.PERSONALES:'</REFERENCIAS_PERSONALES>'
    Y.XML := '<SALIDA_ANEXO_A>':SALIDA.ANEXO.A:'</SALIDA_ANEXO_A>'
    Y.XML := TERCERO.AUTOR
    Y.XML := '<REGIMEN_CTA>':REGIMEN.CTA:'</REGIMEN_CTA>'
    Y.XML := '<TIT_TIPO_FIRMA>':TIT.TIPO.FIRMA:'</TIT_TIPO_FIRMA>'    ;*CCBC_20180711

    Y.XML := COMBINA.FIRMAS
    Y.XML := '<FIRMAS>':FIRMAS:'</FIRMAS>'
    Y.XML := '<FACULTADOS>':FACULTADOS:'</FACULTADOS>'
    Y.XML := '<REPRESENTANTE>':REPRESENTANTE_LEGAL:'</REPRESENTANTE>' ;******************ROHH_20180906
    Y.XML := '<BANCA_INTERNET>':ADMIN.BANCA.LINEA:'</BANCA_INTERNET>' ;******************ROHH_20180906
    Y.XML := '<TIPO_CONTRATO_BANCA>':Y.TIPO.CONTRATO:'</TIPO_CONTRATO_BANCA>'   ;********ROHH_20180906
    Y.XML := '<TIPO_BANCA_INTERNET>':Y.TIPO.BANCA:'</TIPO_BANCA_INTERNET>'      ;***********ROHH_20180906
    Y.XML := '<UNICO_APODERADO>':Y.UNICO.FACULTADO:'</UNICO_APODERADO>'         ;********ROHH_20180906
    Y.XML := REG.FIRMAS.TEMP
    Y.XML := '<RAZON_SOCIAL>':RAZON.SOCIAL:'</RAZON_SOCIAL>'
    Y.XML := '<CATEGORIA_CTA>':CATEGORIA.CTA:'</CATEGORIA_CTA>'
    Y.XML := '<OTRO_USO_CTA>':OTRO.USO.CTA:'</OTRO_USO_CTA>'
    Y.XML := '<FUNCIONARIO_PUB>':FUNCIONARIO.PUB:'</FUNCIONARIO_PUB>'
    Y.XML := '<FUNCIONARIO_PUB_ESP>':FUNCIONARIO.PUB.ESP:'</FUNCIONARIO_PUB_ESP>'

    Y.XML := '<ACCIONISTA_ABC>':ACCIONISTA.ABC:'</ACCIONISTA_ABC>'
    Y.XML := '<ACCIONISTA_ABC_ESP>':ACCIONISTA.ABC.ESP:'</ACCIONISTA_ABC_ESP>'
    Y.XML := '<Y_OTRA_PROCED>':OTRA.PROCED:'</Y_OTRA_PROCED>'
    Y.XML := '<SALIDA_ACCIONISTAS>':ACCIONISTAS:'</SALIDA_ACCIONISTAS>'
    Y.XML := '<PREG_PROP_REAL>':PREG.FON.TER:'</PREG_PROP_REAL>'
    Y.XML := '<NOM_PROP_REAL>':NOMBRE.COMPLETO.TER:'</NOM_PROP_REAL>'
    Y.XML := FIRMANTES
    Y.XML := '<GARAN_IPAB>':GARAN.IPAB:'</GARAN_IPAB>'

    Y.XML := '<RUTA_IMAGEN_JR>':RUTA.IMAGEN.JR:'</RUTA_IMAGEN_JR>'
    Y.XML := '<RUTA_SUBREPORTE_JR>':RUTA.SUBREPORTE.JR:'</RUTA_SUBREPORTE_JR>'
    Y.XML := '<IMPRIME_GAT>':BAND.PRINT.GAT:'</IMPRIME_GAT>'          ;*LFCR_20230321_GAT S-E
    Y.XML := '<IVA_DATO>':IVA.G:'</IVA_DATO>'
    Y.XML := '<IVA_MONTO>':MNT.IVA.GRUPO:'</IVA_MONTO>'
    Y.XML := '<IVA_DIAS>':IVA.DIAS:'</IVA_DIAS>'
    Y.XML := '<GAT_NOMINAL>':GAT.NOM:'</GAT_NOMINAL>'
    Y.XML := '<GAT_REAL>':GAT.R:'</GAT_REAL>'
    Y.XML := '<NOMB_CAT_CTA>':NOMB.CAT.CTA:'</NOMB_CAT_CTA>'
    Y.XML := '<NIVEL>':NIVEL:'</NIVEL>'
    Y.XML := '<FLAG_CRS_FATCA>':Y.FLAG.CRS.FATCA:'</FLAG_CRS_FATCA>'  ;**CCBC_20180406**
    Y.XML := ADICIONALES      ;**CCBC_20180515**
    Y.XML := Y.PRODUCTO.Y.ADICIONALES   ;*ROHH_20180814



RETURN

**************
XML.BLOQUE.PM:
**************

    IF Y.FLAG.FIDUCIARIA EQ '1' THEN    ;**CCBC_20180522** S
        Y.XML := Y.CORREO.FID
        SALIDA.FIDEICOMISARIO = '<PER_FIDEICOMISARIO ID="1"></PER_FIDEICOMISARIO>'
        Y.XML := '<SALIDA_FIDEICOMISARIOS>':SALIDA.FIDEICOMISARIO:'</SALIDA_FIDEICOMISARIOS>'
        SALIDA.FIDEICOMITENTE = '<PER_FIDEICOMITENTE ID="1"></PER_FIDEICOMITENTE>'
        Y.XML := '<SALIDA_FIDEICOMITENTES>':SALIDA.FIDEICOMITENTE:'</SALIDA_FIDEICOMITENTES>'
        Y.XML := Y.NOM.REL.FID
        Y.XML := '<NUM_FIDEICOMISO>':FIELD(RAZON.SOCIAL,"FID",2):'</NUM_FIDEICOMISO>'
        Y.XML := '<TIPO_SOCIEDAD>':ABR.TIPO.SOCIEDAD:'</TIPO_SOCIEDAD>'
    END ELSE
        Y.XML := '<TIPO_SOCIEDAD>':TIPO.SOCIEDAD.DESC:'</TIPO_SOCIEDAD>'
    END   ;**CCBC_20180522** E

    IF Y.FLAG.FINTECH EQ '1' THEN
        Y.XML := '<GPO_FINANCIERO>':GPO.FINANCIERO:'</GPO_FINANCIERO>'
    END

    Y.XML := '<NOMBRE_CLIENTE>':RAZON.SOCIAL:'</NOMBRE_CLIENTE>'
*    END
*----------------------------------------------------------------------------E
    Y.XML := '<TIPO_PER_MORAL>':DESCR.MORAL:'</TIPO_PER_MORAL>'

    Y.XML := '<FECHA_CONSTITUCION>':FECHA.NAC.CLI:'</FECHA_CONSTITUCION>'
    IF DESC.PAIS.CONST NE '' THEN
        Y.XML := '<PAIS_LUG_CONST>':DESC.PAIS.CONST:", ":DESC.LUGAR.CONST:'</PAIS_LUG_CONST>'
    END ELSE
        Y.XML := '<PAIS_LUG_CONST>':DESC.LUGAR.CONST:'</PAIS_LUG_CONST>'
    END
    Y.XML := '<ESCR_CONST>':NUM.ESCRITURA:'</ESCR_CONST>'
    Y.XML := '<DATO_REG_PUB>':DATOS.REG.PUB:'</DATO_REG_PUB>'
    Y.XML := '<REP_LEGAL>':NOMBRE.FACULTADO:'</REP_LEGAL>'
    Y.XML := '<NUM_ESCRITURA>':NUM.ESCRITURA:'</NUM_ESCRITURA>'
    Y.XML := '<RESIDENCIA_EU_CLI>':RESIDENCIA.EU.CLI:'</RESIDENCIA_EU_CLI>'
    Y.XML := '<RFC_CLIENTE>':RFC.CLIENTE:'</RFC_CLIENTE>'
    Y.XML := '<RESIDENCIA_CLI>':RESIDENCIA:'</RESIDENCIA_CLI>'
    Y.XML := '<CIUDAD_SUC>':DESCR.CIUDAD:'</CIUDAD_SUC>'

RETURN

**************
XML.ANEXO.PM:
**************

    Y.XML := '<FECHA_BALANCE>':FECHA.BALANCE:'</FECHA_BALANCE>'

RETURN
**************** CCBC_20180515
LEE.ADICIONALES:
****************

    Y.LIST.ADICIONALES = ''
    Y.LIST.VALUES.ADIC = ''
    Y.FECHA.APER = FECHA.APERTURA
    FECHA.ACT.ADI = Y.FECHA.APER[0,6]
    Y.DIAS = 30
    Y.ID.PARAM = 'ABC.INVERSION.CARATULA'
    
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.ADICIONALES, Y.LIST.VALUES.ADIC)
    NUM.ADICIONALES = DCOUNT(Y.LIST.ADICIONALES, @FM)
    ADICIONALES := '<SALIDA_CARATULA_ADIC>'
    IF NUM.ADICIONALES GT 0 THEN
        FOR ADI = 1 TO NUM.ADICIONALES
            NOMBRE.ADICIONAL = ''; IVA.ADI = '0'; IVA.MTO.ADI = '0'; GAT.NOM.ADI = '0'; GAT.R.ADI = '0'
            NOMBRE.ADICIONAL = Y.LIST.ADICIONALES<ADI>
            VAL.ADICIONALES  = Y.LIST.VALUES.ADIC<ADI>
            Y.AD.TASA = FIELD(VAL.ADICIONALES,"|",1)
            Y.AD.PREF = FIELD(VAL.ADICIONALES,"|",2)
            Y.AD.DIAS = FIELD(VAL.ADICIONALES,"|",3)
            Y.AD.GRUP = FIELD(VAL.ADICIONALES,"|",4)

            BEGIN CASE
                CASE Y.AD.PREF EQ 301
                    Y.TIPO = 1
                CASE Y.AD.PREF EQ 302
                    Y.TIPO = 2
                CASE Y.AD.PREF EQ 304
                    Y.TIPO = 3
            END CASE

            Y.PARAM.ADI  = Y.FECHA.APER:"|":Y.AD.PREF:"|":Y.AD.DIAS:"|":Y.AD.GRUP
            DISPLAY Y.PARAM.ADI
**TODO : DESCOMENTAR CODIGO DE ABAJO UNA VEZ COMPONENTIZADA LA RUTINA
            Y.IVA.MTO.ADI = ''
*CALL ABC.CALC.INTERES.CONTRATO(Y.PARAM.ADI,Y.IVA.AD,Y.IVA.MTO.ADI)
            IF  Y.IVA.AD THEN
                AbcContractService.AbcNewGetGat(FECHA.ACT.ADI,Y.IVA.AD,Y.DIAS,Y.TIPO,GAT.NOMINAL,GAT.REAL)
                GAT.NOM.ADI = GAT.NOMINAL
                GAT.R.ADI   = GAT.REAL
            END ELSE
                GAT.NOM.ADI = 0
                GAT.R.ADI   = 0
            END
            IF  ID.CUENTA MATCHES('1':@VM:'2':@VM:'3') THEN
                ADICIONALES = '<SALIDA_CARATULA_ADIC><CARATULA_ADICIONAL ID="1"></CARATULA_ADICIONAL>'
            END ELSE
                ADICIONALES := '<CARATULA_ADICIONAL ID="':ADI:'">'
                ADICIONALES := '<NOMBRE_ADICIONAL>':NOMBRE.ADICIONAL:'</NOMBRE_ADICIONAL>'
                ADICIONALES := '<TASA_ADI>'        :Y.AD.TASA:'</TASA_ADI>'
                ADICIONALES := '<IVA_ADI>'         :Y.IVA.AD:'</IVA_ADI>'
                ADICIONALES := '<IVA_MONTO_ADI>'   :Y.IVA.MTO.ADI:'</IVA_MONTO_ADI>'
                ADICIONALES := '<GAT_NOM_ADI>'     :GAT.NOM.ADI:'</GAT_NOM_ADI>'
                ADICIONALES := '<GAT_REAL_ADI>'    :GAT.R.ADI:'</GAT_REAL_ADI>'
                ADICIONALES := '<DIAS_ADI>'        :Y.AD.DIAS:'</DIAS_ADI>'
                ADICIONALES := '</CARATULA_ADICIONAL>'

                Y.PRODUCTO.Y.ADICIONALES:=NOMBRE.ADICIONAL:YSEP       ;*ROHH_20180814

            END
        NEXT ADI
    END
    ADICIONALES := '</SALIDA_CARATULA_ADIC>'

RETURN

**************
OBTIENE.PARAM.REPORTES:
**************
    
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.ID.PARAM = 'ABC.PARAMETROS.REPORTES'

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    NUM.LINEAS = DCOUNT(Y.LIST.PARAMS, @FM)

    LOCATE "RUTA_PDF" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.PDF = Y.LIST.VALUES<POS>
*AbcContractService.AbcObtieneRutaAbs(RUTA.PDF)
    END
    LOCATE "RUTA_SH" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RUTA.SH = Y.LIST.VALUES<POS>
*AbcContractService.AbcObtieneRutaAbs(RUTA.PDF)
    END
    
    
    LOCATE "RUTA_PDF_GENE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.RUTA.PDF.GENE = Y.LIST.VALUES<POS>
*AbcContractService.AbcObtieneRutaAbs(RUTA.PDF)
    END

    LOCATE "RUTA_XML" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.XML = Y.LIST.VALUES<POS>
    END

    LOCATE "RUTA_JRXML" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.JRXML = Y.LIST.VALUES<POS>
*AbcContractService.AbcObtieneRutaAbs(RUTA.JRXML)
    END

    LOCATE Y.NOMBRE.CONTRATO IN Y.LIST.PARAMS SETTING POS THEN
        NOMBRE.JR = Y.LIST.VALUES<POS>
    END
    
    BEGIN CASE
        CASE CLASSIFICATION EQ 1001
*CASE CLASSIFICATION EQ 1
            
            LOCATE "NOMBRE_JR_PF" IN Y.LIST.PARAMS SETTING POS THEN
                NOMBRE.JR = Y.LIST.VALUES<POS>
            END
*----------------------------------------------------------------------LFCR_20201105-S
            IF Y.FLAG.NIVEL2 EQ '1' THEN
                LOCATE "NOMBRE_JR_PF_N2" IN Y.LIST.PARAMS SETTING POS THEN
                    NOMBRE.JR = ''
                    NOMBRE.JR = Y.LIST.VALUES<POS>
                END
*----------------------------------------------------------------------LFCR_20211118_UALA - S
                IF Y.FLAG.UALA EQ 1 THEN
                    LOCATE "NOMBRE_JR_PF_UALA" IN Y.LIST.PARAMS SETTING POS THEN
                        NOMBRE.JR = ''
                        NOMBRE.JR = Y.LIST.VALUES<POS>
                    END
                END
*----------------------------------------------------------------------LFCR_20211118_UALA - E
            END
            
            IF Y.FLAG.REMUN EQ '1' THEN     ;*LFCR_20230327_REMU - S
                LOCATE "NOMBRE_JR_PF_REMU" IN Y.LIST.PARAMS SETTING POS THEN
                    NOMBRE.JR = ''
                    NOMBRE.JR = Y.LIST.VALUES<POS>
                END
            END         ;*LFCR_20230327_REMU - E
*----------------------------------------------------------------------LFCR_20201105-E
*----------------------------------------------------------------------LFCR_20221216_N4L S
            IF Y.FLAG.NIVEL4L EQ '1' THEN
                LOCATE "NOMBRE_JR_PF_N4_LITE" IN Y.LIST.PARAMS SETTING POS THEN
                    NOMBRE.JR = ''
                    NOMBRE.JR = Y.LIST.VALUES<POS>
                END
            END
*----------------------------------------------------------------------LFCR_20221216_N4L E

        CASE CLASSIFICATION EQ 1100
*CASE CLASSIFICATION EQ 2
            LOCATE "NOMBRE_JR_PFAEM" IN Y.LIST.PARAMS SETTING POS THEN
                NOMBRE.JR = Y.LIST.VALUES<POS>
            END

        CASE CLASSIFICATION GE 2001 AND CLASSIFICATION LE 2014
*CASE CLASSIFICATION EQ 3
            LOCATE "NOMBRE_JR_PM" IN Y.LIST.PARAMS SETTING POS THEN
                NOMBRE.JR = Y.LIST.VALUES<POS>
            END
*--------------------------------------------------------%% CCBC_20180212 %%-S
            IF Y.FLAG.FIDUCIARIA EQ '1' THEN
                LOCATE "NOMBRE_JR_PM_FID" IN Y.LIST.PARAMS SETTING POS THEN
                    NOMBRE.JR = Y.LIST.VALUES<POS>
                END
            END
*----------------------------------------------------------------------------E
*----------------------------------------------------------------------LFCR_20201105-S
            IF Y.FLAG.FINTECH EQ '1' THEN
                LOCATE "NOMBRE_JR_PM_FIN" IN Y.LIST.PARAMS SETTING POS THEN
                    NOMBRE.JR = Y.LIST.VALUES<POS>
                END
            END
*---------------------------------------------------------------------- LFCR_20201105-E
    END CASE

    IF Y.FLAG.GARANTIZADA EQ 1 THEN     ;* LFCR_20240319_GARANTIZADA - S
        LOCATE "NOMBRE_JR_PF_GARAN" IN Y.LIST.PARAMS SETTING POS THEN
            NOMBRE.JR = Y.LIST.VALUES<POS>
        END
    END   ;* LFCR_20240319_GARANTIZADA - E

    IF NOMBRE.JR EQ '' THEN   ;* LFCR_20230821_RESTRICCION S
        ERROR.CONTRATO = "NO SE ENCONTRO TIPO DE CONTRATO PARA CUENTA " : ID.CUENTA
        RETURN
    END

    FINDSTR "*" IN NOMBRE.JR SETTING Ap THEN
        ERROR.CONTRATO = "GENERACION DE CONTRATO NO PERMITIDA"
        RETURN
    END   ;* LFCR_20230821_RESTRICCION E

    LOCATE "NOMBRE_PDF" IN Y.LIST.PARAMS SETTING POS THEN
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
    Y.PRODUCTO.Y.ADICIONALES = '<PRODUCTO_Y_ADICIONALES>':NAME.PROD.COMECIAL:YSEP         ;*ROHH_20180814
    GOSUB LEE.ADICIONALES     ;**% CCBC_20180515 %**
    Y.PRODUCTO.Y.ADICIONALES:='</PRODUCTO_Y_ADICIONALES>'   ;*ROHH_20180814

RETURN
**************
OBTENER.CTA.LIQUI.NIVEL:
**************

    Y.ID.ACCT.LIQUI = ''
    R.INFO.CTA.LIQUI = ''
    Y.CATEG.CTA.LIQUI = ''
    Y.NIVEL.CTA.LIQUI = ''
    ID.ARRANGEMENT = R.INFO.CUENTA<AC.AccountOpening.Account.ArrangementId>
    GOSUB LEE.ACCT.LCL.FLDS
    IF R.INFO.CUENTA.LT NE "" THEN
        Y.ID.ACCT.LIQUI = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.IntLiquAcct>
        Y.NIVEL.CTA.LIQUI = R.INFO.CUENTA.LT<AbcTable.AbcAcctLclFlds.Nivel>
    END
    
    IF Y.ID.ACCT.LIQUI NE "" THEN
        R.INFO.CTA.LIQUI = AC.AccountOpening.Account.Read(ID.CUENTA, ERROR.CUENTA)
        Y.CATEG.CTA.LIQUI = R.INFO.CTA.LIQUI<AC.AccountOpening.Account.Category>
    END

RETURN
***********
REVISA.NUEVAS.RUTAS:
***********

    Y.PATTERN.RUTA  = "'RUTA_PDF_CANAL_'0N" : @VM : "'RUTA_PDF_CANAL_'0N'_NIVEL.'0X"
    Y.PATTERN.RUTA := "" : @VM : ""
    FOR Y.ITER.PARAM = 1 TO NUM.LINEAS
        Y.NOM.PARAM = '' ; Y.PTH.PARAM = '' ; NUM.NIVELES = ''

        Y.NOM.PARAM = Y.LIST.PARAMS<Y.ITER.PARAM>

        IF Y.NOM.PARAM MATCHES Y.PATTERN.RUTA THEN
            Y.PTH.PARAM = Y.LIST.VALUES<Y.ITER.PARAM>
*AbcContractService.AbcObtieneRutaAbs(Y.PTH.PARAM)

            OPENPATH Y.PTH.PARAM TO PATH.PARAM ELSE
                Y.RUTA.CAPETA = FIELD(Y.PTH.PARAM, "/", 1, COUNT(Y.PTH.PARAM, "/")-1)
                GOSUB CREA.NUEVA.RUTA
            END
        END

    NEXT Y.ITER.PARAM

RETURN
***********
CREA.NUEVA.RUTA:
***********

    Y.CARPETA.NUEVA = ""
    Y.SALTO = CHAR(10)
    Y.RUTA.NEW.CARPETA = Y.RUTA.CAPETA
    Y.CARPETA.NUEVA = FIELD(Y.PTH.PARAM, '/', COUNT(Y.PTH.PARAM, '/'))

*    str_path = '/shares/tafjud/ABC.CONTRATOS'
    str_filename = "ABC.CREA.CARPETA.NUEVA":RND(2000000):TIME():".sh"
    TEMP.FILE = Y.RUTA.SH : "/" : str_filename

    OPENSEQ TEMP.FILE TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

*SE COMENTA YA QUE PARECE NO SER NECESARIA
*    Y.SHELL  = "#!/bin/ksh" : Y.SALTO
    Y.SHELL := "cd " : Y.RUTA.NEW.CARPETA : Y.SALTO
    Y.SHELL := "mkdir " : Y.CARPETA.NUEVA : Y.SALTO
    Y.SHELL := "exit" : Y.SALTO
    Y.SHELL := "EOT"

    WRITESEQ Y.SHELL APPEND TO FILE.VAR1 ELSE
        Y.MENSAJE = "No se Consiguio Escribir el Archivo: " : TEMP.FILE
        DISPLAY Y.MENSAJE
    END
    CLOSESEQ FILE.VAR1

    EXECUTE "SH -c chmod 777 " : TEMP.FILE CAPTURING Y.RESPONSE.CHMOD
    EXECUTE "SH -c " : TEMP.FILE            CAPTURING Y.RETURNVAL
    EXECUTE "SH -c rm " : TEMP.FILE        CAPTURING Y.RESPONSE.RM

RETURN

************** CCBC_20180212
OBTIENE.PARAM.RECA:
**************

    Y.LIST.PARAMS.RECA = ''
    Y.LIST.VALUES.RECA = ''
    Y.NUMERO.RECA = ''
    Y.ID.PARAM = 'ABC.PARAM.REPO.RECA'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS.RECA, Y.LIST.VALUES.RECA)
    NUM.LINEAS = DCOUNT(Y.LIST.PARAMS.RECA, @FM)

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
    
;*EXECUTE "SH -c rm " : RUTA.XML:NOMBRE.XML        CAPTURING Y.RESPONSE.RM

    OPENSEQ RUTA.XML,NOMBRE.XML TO FILE.VAR1 THEN
        EXECUTE "SH -c rm " : RUTA.XML:NOMBRE.XML        CAPTURING Y.RESPONSE.RM
    END
    
    OPENSEQ RUTA.XML,NOMBRE.XML TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END
    
*Y.XML = UTF8(Y.XML)

    Y.XML = EREPLACE(Y.XML,Y.AMP,'&amp;')         ;*AAR-20191002 - S-E
    Y.XML = EREPLACE(Y.XML,@FM,' ')
    Y.XML = EREPLACE(Y.XML,@VM,' ')
    Y.XML = EREPLACE(Y.XML,@SM,' ')

    WRITESEQ Y.XML APPEND TO FILE.VAR1 ELSE
    END
    
RETURN

*************
CREA.REPORTE:
*************
    
    Y.RUTA.PDF = RUTA.PDF
    Y.RUTA.XML = RUTA.XML
    Y.RUTA.JRXML = RUTA.JRXML
    Y.NOMBRE.JR = NOMBRE.JR
    Y.NOMBRE.PDF = NOMBRE.PDF : ID.CUENTA: ".pdf" ;* NOMBRE.JR : ID.CUENTA: ".pdf" ;* *para pruebas
    Y.NOMBRE.JAR = NOMBRE.JAR
    Y.NOMBRE.XML = ID.CUENTA : "_TEMP"
    
* PARA CONTRATOS GENERADOS AUTOMATICAMENTE POR EL TSA.SERVICE
    IF Y.FLAG.CON.GENT.AUT EQ 1 THEN    ;*LFCR_20210416 - S
        GOSUB REVISA.NUEVAS.RUTAS
        GOSUB VALIDA.CANAL.NIVEL        ;* LFCR_20230509_RUTA S-E
    END   ;*LFCR_20210416 - E
    CRT "Y.DIRECTORIO->" :        Y.DIRECTORIO
    CRT "Y.RUTA.PDF.original->" : Y.RUTA.PDF
;*Y.PARAMETROS = Y.RUTA.JRXML: "*": Y.NOMBRE.JR: "*": Y.NOMBRE.XML: "*": Y.RUTA.XML: "*": Y.RUTA.PDF.GENE: "*": Y.NOMBRE.PDF
    Y.PARAMETROS = Y.RUTA.JRXML: "*": Y.NOMBRE.JR: "*": Y.NOMBRE.XML: "*": Y.RUTA.XML: "*": Y.RUTA.PDF: "*": Y.NOMBRE.PDF
    DISPLAY Y.PARAMETROS
    
    OPENSEQ Y.RUTA.PDF,Y.NOMBRE.PDF TO FILE.VAR1 THEN
        EXECUTE "SH -c rm " : Y.RUTA.PDF:"/":Y.NOMBRE.PDF        CAPTURING Y.RESPONSE.RM
    END
    
    AbcContractService.AbcEjecutaJarGeneric(Y.PARAMETROS,Y.NOMBRE.JAR,Y.DIRECTORIO)
    
    Y.DIRECTORIO.AUX = UPCASE(Y.DIRECTORIO)
    
    Y.STATUS = ""
    Y.RUTA.FIN = ""
    
    FINDSTR "EXCEPTION" IN Y.DIRECTORIO.AUX SETTING Ap THEN
        Y.STATUS = "NO DISPONIBLE"
        EB.Reports.setEnqError(Y.STATUS)
    END ELSE
        Y.STATUS = "OPERACION EXITOSA"
        CRT "Y.DIRECTORIO->" :        Y.DIRECTORIO
        CRT "Y.RUTA.PDF->" : Y.RUTA.PDF
        
        
        Y.DIR = Y.DIRECTORIO
        DATOS = ID.CUENTA:YSEP.1:Y.DIRECTORIO:YSEP.1:Y.STATUS:YSEP.1:Y.DIR
    END
    
*    IF Y.DIRECTORIO EQ '' THEN ;* SE DESESTIMA PARA MANEJAR EXCEPTION JAVA - S
*        Y.STATUS = "NO DISPONIBLE"
*    END
*    IF Y.DIRECTORIO NE '' THEN
*        Y.STATUS = "OPERACION EXITOSA"
*    END ;* SE DESESTIMA PARA MANEJAR EXCEPTION JAVA - E

    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)
RETURN
************* ;* LFCR_20230509_RUTA-S
VALIDA.CANAL.NIVEL:
*************
    
;*IF Y.CANAL.CTA MATCHES Y.CANALES.UALA THEN
    CRT "Y.CATEGORIA.CTA.CREA.REP->" : Y.CATEGORIA.CTA.CREA.REP
    CRT "Y.CATEGS.UALA.N2:@VM:Y.CATEGS.UALA.N4 ->" : Y.CATEGS.UALA.N2:@VM:Y.CATEGS.UALA.N4
    CRT "Y.NIVEL.CREA.REP ->" : Y.NIVEL.CREA.REP
    
    RUTA.PDF.CANAL = "RUTA_PDF_CANAL_13"
    BEGIN CASE
        
        CASE Y.CATEGORIA.CTA.CREA.REP MATCHES Y.CATEGS.UALA.N2
            LOCATE RUTA.PDF.CANAL : "_NIVEL.2"  IN Y.LIST.PARAMS SETTING POS THEN
                Y.RUTA.PDF = Y.LIST.VALUES<POS>
            END
    
        CASE Y.CATEGORIA.CTA.CREA.REP MATCHES Y.CATEGS.UALA.N4
            LOCATE RUTA.PDF.CANAL : "_NIVEL.4L"  IN Y.LIST.PARAMS SETTING POS THEN
                Y.RUTA.PDF = Y.LIST.VALUES<POS>
            END
        
        CASE Y.CATEGORIA.CTA.CREA.REP MATCHES Y.CATEGS.GARAN
            GOSUB OBTENER.CTA.LIQUI.NIVEL
            LOCATE RUTA.PDF.CANAL : "_NIVEL.4L"  IN Y.LIST.PARAMS SETTING POS THEN
                Y.RUTA.PDF = Y.LIST.VALUES<POS>
            END
        
        CASE 1
            RUTA.PDF.CANAL = "RUTA_PDF_CANAL_0" ;*: Y.CANAL.CTA
            LOCATE RUTA.PDF.CANAL  IN Y.LIST.PARAMS SETTING POS THEN
                Y.RUTA.PDF = Y.LIST.VALUES<POS>
            END
    END CASE
    
*    IF Y.CATEGORIA.CTA.CREA.REP MATCHES Y.CATEGS.UALA.N2:@VM:Y.CATEGS.UALA.N4 THEN
*        RUTA.PDF.CANAL = "RUTA_PDF_CANAL_13"
*
*        IF Y.CATEGORIA.CTA.CREA.REP MATCHES Y.CATEGS.UALA.N2 THEN
*            LOCATE RUTA.PDF.CANAL : "_NIVEL.2"  IN Y.LIST.PARAMS SETTING POS THEN
*                Y.RUTA.PDF = Y.LIST.VALUES<POS>
*            END
*        END
*
*    IF Y.CATEGORIA.CTA.CREA.REP MATCHES Y.CATEGS.UALA.N4 THEN
*        LOCATE RUTA.PDF.CANAL : "_NIVEL.4L"  IN Y.LIST.PARAMS SETTING POS THEN
*            Y.RUTA.PDF = Y.LIST.VALUES<POS>
*        END
*    END
*        LOCATE RUTA.PDF.CANAL : "_" : Y.NIVEL.CREA.REP  IN Y.LIST.PARAMS SETTING POS THEN
*            Y.RUTA.PDF = Y.LIST.VALUES<POS>
**AbcContractService.AbcObtieneRutaAbs(Y.RUTA.PDF)
*        END ELSE
*            LOCATE RUTA.PDF.CANAL  IN Y.LIST.PARAMS SETTING POS THEN
*                Y.RUTA.PDF = Y.LIST.VALUES<POS>
**AbcContractService.AbcObtieneRutaAbs(Y.RUTA.PDF)
*            END
*        END
*    END ELSE
*        RUTA.PDF.CANAL = "RUTA_PDF_CANAL_" : Y.CANAL.CTA
*        LOCATE RUTA.PDF.CANAL  IN Y.LIST.PARAMS SETTING POS THEN
*            Y.RUTA.PDF = Y.LIST.VALUES<POS>
**AbcContractService.AbcObtieneRutaAbs(Y.RUTA.PDF)
*        END
*    END
    CRT "VAL CANAL NIVEL Y.RUTA.PDF ->" : Y.RUTA.PDF

RETURN          ;* LFCR_20230509_RUTA - E
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
    
    EB.LocalReferences.GetLocRef('CUSTOMER','ABC.DOM.ANOS',YPOS.DOM.ANOS)
*TODO :  EN EL EXCEL NO ESTA DOM.MESES
    EB.LocalReferences.GetLocRef('CUSTOMER','DOM.MESES',YPOS.DOM.MESES)
    EB.LocalReferences.GetLocRef('CUSTOMER','CDNIA.RESID.EUA',YPOS.CDNIA.RESID.EUA)
    EB.LocalReferences.GetLocRef('CUSTOMER','ABC.NOMBRE.CONY',YPOS.NOM.CONYUGUE)
    EB.LocalReferences.GetLocRef('CUSTOMER','ABC.FIRMA.ELECT',YPOS.TIENE.FIRMA.ELE)
    EB.LocalReferences.GetLocRef('CUSTOMER','ABC.REGIMEN',YPOS.REGIMEN)
*TODO :  EN EL EXCEL NO ESTA EMP.PUESTO
    EB.LocalReferences.GetLocRef('CUSTOMER','EMP.PUESTO',YPOS.EMP.PUESTO)
    YPOS.EMP.PUESTO = 1
    EB.LocalReferences.GetLocRef('CUSTOMER','L.STAFF.OFFICIAL',YPOS.STAFF.OFFICIAL)
*TODO :  EN EL EXCEL NO ESTA COB.GEO
    EB.LocalReferences.GetLocRef('CUSTOMER','COB.GEO',YPOS.COB.GEO)
    YPOS.COB.GEO = 1
*NO SE AGREGO EN R14 DICE COMMENT EXCEL EB.LocalReferences.GetLocRef('CUSTOMER','TIENE.EXPOR',YPOS.TIENE.EXPOR)
    YPOS.TIENE.EXPOR = 1
*NO SE AGREGO EN R14 DICE COMMENT EXCEL  EB.LocalReferences.GetLocRef('CUSTOMER','TIENE.IMPOR',YPOS.TIENE.IMPOR)
    YPOS.TIENE.IMPOR = 1
    EB.LocalReferences.GetLocRef('CUSTOMER','L.NOM.ACCIONIST',YPOS.NOM.ACCIONISTA)
    EB.LocalReferences.GetLocRef('CUSTOMER','L.ACC.PORCENTAJ',YPOS.ACC.PORCENTAJE)
    EB.LocalReferences.GetLocRef('CUSTOMER','L.RFC.ACCIONIST',YPOS.RFC.ACCIONISTA)          ;* LFCR_20200823-S
    EB.LocalReferences.GetLocRef('CUSTOMER','L.NAC.ACCIONIST',YPOS.NACI.ACCIONISTA)
    EB.LocalReferences.GetLocRef('CUSTOMER','L.RES.ACCIONIST',YPOS.RESI.ACCIONISTA)
    EB.LocalReferences.GetLocRef('CUSTOMER','L.GPO.FINANCIER',YPOS.GPO.FINANCIERO)          ;* LFCR_20200823-E
    EB.LocalReferences.GetLocRef('CUSTOMER','L.GIRO.MERC',YPOS.GIRO.MERC)
    EB.LocalReferences.GetLocRef('CUSTOMER','L.NOM.PER.MORAL',YPOS.NOM.PER.MORAL)
*EL CAMPO SECTOR DE ABAJO O CAMPO LOCAL SECTOR ?
    EB.LocalReferences.GetLocRef('CUSTOMER','TIPO.MORAL',YPOS.TIPO.MORAL)
    YPOS.TIPO.MORAL = 1

    EB.LocalReferences.GetLocRef('CUSTOMER','EMP.CALLE',YPOS.EMP.CALLE)
    EB.LocalReferences.GetLocRef('CUSTOMER','EMP.NUM.EXT',YPOS.EMP.NUM.EXT)
    EB.LocalReferences.GetLocRef('CUSTOMER','EMP.NUM.INT',YPOS.EMP.NUM.INT)
    EB.LocalReferences.GetLocRef('CUSTOMER','EMP.COL',YPOS.EMP.COL)
    EB.LocalReferences.GetLocRef('CUSTOMER','EMP.DEL.MUNI',YPOS.EMP.DEL.MUNI)
    EB.LocalReferences.GetLocRef('CUSTOMER','EMP.COD.POS',YPOS.EMP.COD.POS)
    EB.LocalReferences.GetLocRef('CUSTOMER','EMP.ENTIDAD',YPOS.EMP.ENTIDAD)
    EB.LocalReferences.GetLocRef('CUSTOMER','EMP.CIUDAD',YPOS.CIUDAD)
    EB.LocalReferences.GetLocRef('CUSTOMER','EMP.PAIS',YPOS.EMP.PAIS)

    EB.LocalReferences.GetLocRef('CUSTOMER','L.TIP.IPAB.GARAN',YPOS.TIP.IPAB.GARAN)
    EB.LocalReferences.GetLocRef('CUSTOMER','TIPO.EMP.OTRO',YPOS.OTRO.EMPLEO)    ;******ROHH_20180906   Extrae otro empleo
    EB.LocalReferences.GetLocRef('COUNTRY','L.IMP.CRS.FATCA',YPOS.CRS.FATCA)     ;*CCBC_20180406
    EB.LocalReferences.GetLocRef('ACCOUNT', 'CANAL', Y.POS.CANAL.ACC)

RETURN

****
FIN:
****

RETURN TO FIN

END
