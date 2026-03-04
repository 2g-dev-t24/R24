* @ValidationCode : MjoxNDEzMzI2NDI3OkNwMTI1MjoxNzYwNTQ2NzkwMjQ3Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Oct 2025 13:46:30
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
* <Rating>-90</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
SUBROUTINE ABC.IXP.DATOS.CEP

    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.LocalReferences
    $USING AA.Framework
    $USING EB.Updates
    $USING EB.Interface
    $USING FT.Contract
    $USING AbcGetGeneralParam

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

********
PROCESS:
********
    Y.RFCY.RFC = ''
    Y.NOMBRE.BENEFICIARIO = ''
    send_param = ''
    className = "Abono"
    methodName = "AplicacionPagosPC"

    EB.DataAccess.FRead(FN.ACCOUNT,EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo),R.ACCOUNT,F.ACCOUNT,Y.ERROR)
    IF R.ACCOUNT THEN
        EB.DataAccess.FRead(FN.CUSTOMER,R.ACCOUNT<AC.AccountOpening.Account.Customer>,R.CUSTOMER,F.CUSTOMER,Y.ERROR)
        IF R.CUSTOMER THEN
            Y.LOCAL.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
            Y.RFC = Y.LOCAL.REF<1,Y.POS.RFC.CTE>
            Y.NOMBRE = EREPLACE(TRIM(R.CUSTOMER<EST.Customer.Customer.EbCusNameTwo>),@VM,' ')
            IF Y.NOMBRE THEN
                Y.NOMBRE.BENEFICIARIO := Y.NOMBRE:' '
            END
            Y.NOMBRE2 = TRIM(Y.LOCAL.REF<1,Y.POS.FORMER.NAME>)
            IF Y.NOMBRE2 THEN
                Y.NOMBRE.BENEFICIARIO := Y.NOMBRE2:' '
            END
            Y.PATERNO = EREPLACE(TRIM(R.CUSTOMER<ST.Customer.Customer.EbCusShortName>),@VM,' ')
            IF Y.PATERNO THEN
                Y.NOMBRE.BENEFICIARIO := Y.PATERNO:' '
            END
            Y.MATERNO = EREPLACE(TRIM(R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>),@VM,' ')
            IF Y.MATERNO THEN
                Y.NOMBRE.BENEFICIARIO := Y.MATERNO
            END

            Y.NOMBRE.BENEFICIARIO = EREPLACE(Y.NOMBRE.BENEFICIARIO,"�","@")
            Y.NOMBRE.BENEFICIARIO = TRIM(Y.NOMBRE.BENEFICIARIO)[1,40]

            Y.FECHA.HORA =  OCONV(DATE(),"DY4"):FMT(OCONV(DATE(),"DM"),"R0%2"):FMT(OCONV(DATE(),"DD"),"R0%2"):' ':TIMEDATE()[1,8]
            Y.PATH = EREPLACE(@PATH,"/","*")
            send_param = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails):"|":Y.RFC:"|":Y.FECHA.HORA:"|":Y.NOMBRE.BENEFICIARIO:"|":Y.PATH
            MENSAJE = "Paramtros enviados --> ":send_param:" Clase ":className:" Metodo ":methodName
            GOSUB BITACORA
            CALLJ className,methodName, send_param SETTING ret_value ON ERROR
                GOSUB errorHandler
            END
            MENSAJE = "Resupuesta CALLJ --> ":ret_value
            GOSUB BITACORA
        END
    END

RETURN

*************
errorHandler:
*************

    err = SYSTEM(0)

    BEGIN CASE
        CASE err EQ 1
            Y.ERROR.CALLJ =  "Fatal Error creating Thread!"
        CASE err EQ 2
            Y.ERROR.CALLJ = "Can't find JAVA library on the system"
        CASE err EQ 3
            Y.ERROR.CALLJ = "Class " : className : " doesn't exist!"
        CASE err EQ 4
            Y.ERROR.CALLJ = "UNICODE conversion error!"
        CASE err EQ 5
            Y.ERROR.CALLJ = "Method " : methodName : " doesn't exist!"
        CASE err EQ 6
            Y.ERROR.CALLJ = "Cannot find object Constructor!"
        CASE err EQ 7
            Y.ERROR.CALLJ = "Cannot instantiate object!"
        CASE @TRUE
            Y.ERROR.CALLJ =  "Unknown error!"
    END CASE

    MENSAJE = "ERROR --> ":Y.ERROR.CALLJ
    GOSUB BITACORA

RETURN

*********
BITACORA:
*********
    WRITESEQ TIMEDATE():" ":MENSAJE APPEND TO FILE.VAR2 ELSE
    END
    MENSAJE = ''
RETURN


***********
OPEN.FILES:
***********

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    EB.LocalReferences.GetLocRef('CUSTOMER','RFC.CTE',Y.POS.RFC.CTE)
    EB.LocalReferences.GetLocRef('CUSTOMER','FORMER.NAME',Y.POS.FORMER.NAME)

    str_filename = "CEP." : OCONV(DATE(), "DD") : "." : OCONV(DATE(), "DM") : "." : OCONV(DATE(), "DY4")
    
    Y.ID.PARAM = 'ABC.IXP.DATOS.CEP'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE "RUTA" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.RUTA = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    
    TEMP.FILE = Y.RUTA : str_filename
    OPENSEQ TEMP.FILE TO FILE.VAR2 ELSE
        CREATE FILE.VAR2 ELSE
        END
    END


RETURN

END
