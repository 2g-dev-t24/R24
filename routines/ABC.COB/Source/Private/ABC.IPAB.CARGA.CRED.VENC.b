* @ValidationCode : MjotOTc3OTc3NDI5OkNwMTI1MjoxNzYwNTQ2ODcyOTk0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Oct 2025 13:47:52
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

SUBROUTINE ABC.IPAB.CARGA.CRED.VENC

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.TransactionControl
    $USING AC.AccountOpening
    $USING AbcTable
    $USING AbcGetGeneralParam

    GOSUB INITIALISATION      ;* file opening, variable set up
    GOSUB MAIN.PROCESS        ;* main subroutine processing

RETURN

*-----------------------------------------------------------------------------

*** <region name= INITIALISATION>
INITIALISATION:
*** <desc>file opening, variable set up</desc>

    GOSUB OPEN.FILES          ;*
    GOSUB INIT.VARIABLES      ;*

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= OPEN.FILES>
OPEN.FILES:
***

    FN.ABC.IPAB.CRED.VENC = 'F.ABC.IPAB.CRED.VENC'
    F.ABC.IPAB.CRED.VENC = ''
    EB.DataAccess.Opf(FN.ABC.IPAB.CRED.VENC,F.ABC.IPAB.CRED.VENC)

    FN.ABC.SDO.COMP.IPAB = 'F.ABC.SDO.COMP.IPAB'
    F.ABC.SDO.COMP.IPAB = ''
    EB.DataAccess.Opf(FN.ABC.SDO.COMP.IPAB,F.ABC.SDO.COMP.IPAB)

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= INIT.VARIABLES>
INIT.VARIABLES:
***

    Y.SEP   = ','
    Y.DOT   = '.'
    Y.SPACE = ' '
    Y.N     = 0
    Y.HYPHEN = '-'

RETURN
*** </region>

*-----------------------------------INICIO CAMB------------------------------------------

*** <region name= OPEN.FILE>
OPEN.FILE:
***

    Y.NOMBRE.ARCHIVO = "LISTA.CREDITOS.":Y.PERIODO.ACTUAL:".txt"
    OPENSEQ Y.DIRECTORIO.CARGA,Y.NOMBRE.ARCHIVO TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

RETURN
*** </region>
*-------------------------------------FIN CAMB-------------------------------------------

*-----------------------------------------------------------------------------

*** <region name= MAIN.PROCESS>
MAIN.PROCESS:
*** <desc>main subroutine processing</desc>

    GOSUB LOAD.FILE ;*

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= LOAD.FILE>
LOAD.FILE:
***
    Y.ID.PARAM = 'ABC.IPAB.CARGA.CRED.VENC'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE "RUTA" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.RUTA= Y.LIST.VALUES<YPOS.PARAM>
    END

    Y.DIRECTORIO.CARGA = Y.RUTA

    Y.PERIODO.ACTUAL = EB.SystemTables.getToday()[1,6]

    GOSUB OPEN.FILE ;* CAMB

    Y.CMD.SQL='SSELECT ' :  Y.DIRECTORIO.CARGA : ' WITH @ID EQ "CRED.VENC.' : Y.PERIODO.ACTUAL : '.csv"'      ;* ITSS - BINDHU Added "
    Y.LIST=''; Y.NO=''; Y.CO=''
    EB.DataAccess.Readlist(Y.CMD.SQL,Y.LIST,'',Y.NO,Y.CO)

    IF Y.NO LE 0 THEN
        DISPLAY 'No se encuentra el archivo: ' : 'CRED.VENC.' : Y.PERIODO.ACTUAL : '.csv'
        RETURN
    END

    LOOP
        Y.NOMBRE.ARCHIVO = ''
    WHILE READNEXT Y.NOMBRE.ARCHIVO FROM Y.LIST DO

        Path = Y.DIRECTORIO.CARGA : Y.NOMBRE.ARCHIVO

        OPENSEQ Path TO MyPath ELSE
            CRT "Can't find the specified directory or file."
            ABORT
        END

        Y.EXEC.CMD = 'EDELETE ': FN.ABC.IPAB.CRED.VENC
        EXEC Y.EXEC.CMD

        LOOP
            READSEQ Line FROM MyPath ELSE EXIT

            ABC.IPAB.CRED.VENC.ID = ''
            R.BA.IPAB.CRED.VENC  = ''

            ACCOUNT.ID = ''
            ACCOUNT.ID = FMT(FIELD(Line,Y.SEP,1), "R%11")

            R.ACCOUNT = ''
            EB.DataAccess.CacheRead('F.ACCOUNT',ACCOUNT.ID,R.ACCOUNT,YERR)

            IF R.ACCOUNT THEN

                ABC.IPAB.CRED.VENC.ID = ACCOUNT.ID : Y.HYPHEN : Y.PERIODO.ACTUAL          ;*

                GOSUB GET.RECORD.INFO   ;*
                R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.CodigoCliente,Y.N>   = R.ACCOUNT<AC.AccountOpening.Account.Customer>
                GOSUB CREATE.RECORD

                EB.DataAccess.FWrite(FN.ABC.IPAB.CRED.VENC,ABC.IPAB.CRED.VENC.ID,R.ABC.IPAB.CRED.VENC)
                EB.TransactionControl.JournalUpdate(BA.IPAB.CRED.VENC.ID)

                GOSUB GUARDA.SDO.COMP

            END ELSE
                CUSTOMER.ID = FIELD(Line,Y.SEP,2) ;*
                R.CUSTOMER = ''
                EB.DataAccess.CacheRead('F.CUSTOMER',CUSTOMER.ID,R.CUSTOMER,YERR.CUS)
                IF R.CUSTOMER THEN
                    ABC.IPAB.CRED.VENC.ID = ACCOUNT.ID : Y.HYPHEN : Y.PERIODO.ACTUAL      ;*

                    GOSUB GET.RECORD.INFO         ;*
                    R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.CodigoCliente,Y.N>   = CUSTOMER.ID
                    GOSUB CREATE.RECORD

                    EB.DataAccess.FWrite(FN.ABC.IPAB.CRED.VENC,ABC.IPAB.CRED.VENC.ID,R.ABC.IPAB.CRED.VENC)
                    EB.TransactionControl.JournalUpdate(BA.IPAB.CRED.VENC.ID)

                    GOSUB GUARDA.SDO.COMP

                    MENSAJE = "TABLA.1":"*":CUSTOMER.ID
                    GOSUB WRITE.FILE
                END
            END

        REPEAT

        CLOSESEQ MyPath

    REPEAT

RETURN

*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.RECORD.INFO>
GET.RECORD.INFO:
***
    Y.N = 1
    R.ABC.IPAB.CRED.VENC = ''
    YERR = ''
    EB.DataAccess.FRead(FN.ABC.IPAB.CRED.VENC,ABC.IPAB.CRED.VENC.ID,R.ABC.IPAB.CRED.VENC,F.ABC.IPAB.CRED.VENC,YERR)

    IF R.ABC.IPAB.CRED.VENC THEN
        Y.N = DCOUNT(R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.NumeroCredito>,@VM) + 1
    END

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= CREATE.RECORD>
CREATE.RECORD:
***

    R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.NumeroCredito,Y.N>   = FIELD(Line,Y.SEP,3)         ;*
    R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.Moneda,Y.N>           = FIELD(Line,Y.SEP,4)         ;*
    R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.Segmento,Y.N>         = FIELD(Line,Y.SEP,5)         ;*
    R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.TipoCobranza,Y.N>    = FIELD(Line,Y.SEP,6)         ;*
    R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.CapitalVigente,Y.N>  = FIELD(Line,Y.SEP,7)         ;*
    R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.CapitalVencido,Y.N>  = FIELD(Line,Y.SEP,8)         ;*
    R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.IntOrdExigible,Y.N> = FIELD(Line,Y.SEP,9)         ;*
    R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.IntMoratorio,Y.N>    = FIELD(Line,Y.SEP,10)        ;*
    R.ABC.IPAB.CRED.VENC<AbcTable.AbcIpabCredVenc.OtrosAccesorios,Y.N> = FIELD(Line,Y.SEP,11)        ;*

RETURN
*** </region>
*-----------------------------------INICIO CAMB------------------------------------------

*** <region name= GUARDA.SDO.COMP>
GUARDA.SDO.COMP:
***

    CAPITAL.VENCIDO = 0; INT.ORD.EXIGIBLE = 0; INT.MORATORIO = 0; OTROS.ACCESORIOS = 0;
    SALDO.CREDITO.VENCIDO = 0; TIPO.COBRANZA = 0;

    SALDO.CREDITO.VENCIDO = FIELD(Line,Y.SEP,6)
    IF SALDO.CREDITO.VENCIDO NE '2' THEN
        CAPITAL.VENCIDO = FIELD(Line,Y.SEP,8)
        INT.ORD.EXIGIBLE = FIELD(Line,Y.SEP,9)
        INT.MORATORIO = FIELD(Line,Y.SEP,10)
        OTROS.ACCESORIOS = FIELD(Line,Y.SEP,11)

        SALDO.CREDITO.VENCIDO = CAPITAL.VENCIDO + INT.ORD.EXIGIBLE + INT.MORATORIO + OTROS.ACCESORIOS

        CUSTOMER.ID = FIELD(Line,Y.SEP,2)
        R.ABC.SDO.COMP.IPAB = ''
        YERR.IPAB = ''
        EB.DataAccess.FRead(FN.ABC.SDO.COMP.IPAB,CUSTOMER.ID,R.ABC.SDO.COMP.IPAB,F.ABC.SDO.COMP.IPAB,YERR.IPAB)

        IF R.ABC.SDO.COMP.IPAB THEN
            SALDO.CREDITO.VENCIDO += R.ABC.SDO.COMP.IPAB<AbcTable.AbcSdoCompIpab.SaldoVencido>
        END

        R.ABC.SDO.COMP.IPAB<AbcTable.AbcSdoCompIpab.SaldoVencido> = SALDO.CREDITO.VENCIDO

        EB.DataAccess.FWrite(FN.ABC.SDO.COMP.IPAB,CUSTOMER.ID,R.ABC.SDO.COMP.IPAB)
        EB.TransactionControl.JournalUpdate(CUSTOMER.ID)
    END

RETURN
*** </region>
*-----------------------------------INICIO CAMB------------------------------------------

*** <region name= WRITE.FILE>
WRITE.FILE:
***

    WRITESEQ MENSAJE APPEND TO FILE.VAR1 ELSE
    END
    MENSAJE = ''

RETURN

*** </region>
*-------------------------------------FIN CAMB-------------------------------------------

END
