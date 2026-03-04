* @ValidationCode : MjoxNzYzODQ0MTU5OkNwMTI1MjoxNzU5NzgyMDI0NjE4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Oct 2025 17:20:24
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
$PACKAGE AbcCob

SUBROUTINE ABC.IPAB.TABLA.4

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.TransactionControl
    $USING AbcTable

    GOSUB INITIALISATION      ;* file opening, variable set up
    GOSUB MAIN.PROCESS        ;* main subroutine processing

RETURN

*-----------------------------------------------------------------------------

*** <region name= INITIALISATION>
INITIALISATION:
*** <desc>file opening, variable set up</desc>

    FN.ABC.IPAB.CRED.VENC = 'F.ABC.IPAB.CRED.VENC'
    F.ABC.IPAB.CRED.VENC = ''
    EB.DataAccess.Opf(FN.ABC.IPAB.CRED.VENC, F.ABC.IPAB.CRED.VENC)

    FN.ABC.FILE.MAPPING = 'F.ABC.FILE.MAPPING'
    F.ABC.FILE.MAPPING = ''
    EB.DataAccess.Opf(FN.ABC.FILE.MAPPING,F.ABC.FILE.MAPPING)

    FN.ABC.FILE.REPORT.TMP = 'F.ABC.FILE.REPORT.TMP'
    F.ABC.FILE.REPORT.TMP = ''
    EB.DataAccess.Opf(FN.ABC.FILE.REPORT.TMP,F.ABC.FILE.REPORT.TMP)

    ABC.FILE.MAPPING.ID.4 = 'TABLA.4'
    ABC.FILE.MAPPING.ID.5 = 'TABLA.5'
    Y.SPACE = ' '
    Y.SEP = '|'

    CMD = 'EDELETE ':FN.ABC.FILE.REPORT.TMP
    CMD :=' IF @ID EQ ':ABC.FILE.MAPPING.ID.4:"... ":ABC.FILE.MAPPING.ID.5:'...'
    EXEC CMD

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= MAIN.PROCESS>
MAIN.PROCESS:
*** <desc>main subroutine processing</desc>

    EB.DataAccess.CacheRead(FN.ABC.FILE.MAPPING,ABC.FILE.MAPPING.ID.4,R.ABC.FILE.MAPPING,YERR)

    Y.FM.MAIN.APPLICATION = R.ABC.FILE.MAPPING<AbcTable.AbcFileMapping.MainApplication>
    Y.FM.FIXED.SELECTION = R.ABC.FILE.MAPPING<AbcTable.AbcFileMapping.FixedSelection>
    Y.FM.FIELD.NAME = R.ABC.FILE.MAPPING<AbcTable.AbcFileMapping.FieldName>

    FN.APP  = 'F.':Y.FM.MAIN.APPLICATION
    F.APP = ''

    EB.DataAccess.Opf(FN.APP,F.APP)

    IF Y.FM.FIXED.SELECTION THEN

        Y.FM.FIXED.SELECTION = Y.SPACE : Y.FM.FIXED.SELECTION

    END

    CHANGE "!PERIODO.ACTUAL" TO EB.SystemTables.getToday()[1,6] IN Y.FM.FIXED.SELECTION

    SELECT.STATEMENT  = 'SSELECT ': FN.APP :
    SELECT.STATEMENT := Y.FM.FIXED.SELECTION

    APP.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    EB.DataAccess.Readlist(SELECT.STATEMENT,APP.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    GOSUB SET.REGISTRO        ;*

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= SET.REGISTRO>
SET.REGISTRO:
*** <desc>record processing</desc>

    LOOP
        REMOVE APP.ID FROM APP.LIST SETTING APP.MARK
    WHILE APP.ID : APP.MARK

        ABC.IPAB.CRED.VENC.ID = APP.ID

        EB.DataAccess.CacheRead(FN.ABC.IPAB.CRED.VENC,ABC.IPAB.CRED.VENC.ID,R.ABC.IPAB.CRED.VENC,YERR)

        Y.NO.CRED.VENC = 0
        Y.NO.CRED.VENC = DCOUNT(R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.NumeroCredito>,@VM)

        FOR ICV = 1 TO Y.NO.CRED.VENC

            CODIGO.CLIENTE   = R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.CodigoCliente,ICV>
            NUMERO.CREDITO   = R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.NumeroCredito,ICV>
            MONEDA           = R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.Moneda,ICV>
            SEGMENTO         = R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.Segmento,ICV>
            TIPO.COBRANZA    = R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.TipoCobranza,ICV>
            CAPITAL.VIGENTE  = R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.CapitalVigente,ICV>
            CAPITAL.VENCIDO  = R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.CapitalVencido,ICV>
            INT.ORD.EXIGIBLE = R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.IntOrdExigible,ICV>
            INT.MORATORIO    = R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.IntMoratorio,ICV>
            OTROS.ACCESORIOS = R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.OtrosAccesorios,ICV>

            GOSUB WRITE.REGISTRO        ;*

        NEXT ICV

    REPEAT

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= WRITE.REGISTRO>
WRITE.REGISTRO:
***
****TABLA.4
    ID = ABC.FILE.MAPPING.ID.4 :'*': ABC.IPAB.CRED.VENC.ID :'-':ICV

    Y.REGISTRO =  NUMERO.CREDITO  : Y.SEP
    Y.REGISTRO := MONEDA          : Y.SEP
    Y.REGISTRO := SEGMENTO        : Y.SEP
    Y.REGISTRO := TIPO.COBRANZA   : Y.SEP
    Y.REGISTRO := CAPITAL.VIGENTE : Y.SEP
    Y.REGISTRO := CAPITAL.VENCIDO : Y.SEP
    Y.REGISTRO := INT.ORD.EXIGIBLE: Y.SEP
    Y.REGISTRO := INT.MORATORIO   : Y.SEP
    Y.REGISTRO := OTROS.ACCESORIOS

    EB.DataAccess.FWrite(FN.ABC.FILE.REPORT.TMP, ID, Y.REGISTRO)

    EB.TransactionControl.JournalUpdate(ID)
****TABLA.5

    ID = ABC.FILE.MAPPING.ID.5 :'*': ABC.IPAB.CRED.VENC.ID :'-':ICV

    Y.REGISTRO = ''
    Y.REGISTRO =  NUMERO.CREDITO  : Y.SEP
    Y.REGISTRO :=  CODIGO.CLIENTE

    EB.DataAccess.FWrite(FN.ABC.FILE.REPORT.TMP, ID, Y.REGISTRO)

    EB.TransactionControl.JournalUpdate(ID)

    Y.REGISTRO = ''

RETURN
*** </region>
END
