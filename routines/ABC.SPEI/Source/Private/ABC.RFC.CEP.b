* @ValidationCode : MjoyMDIwODk2ODc3OkNwMTI1MjoxNzY3NjY5MTQ3MzA3Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Jan 2026 00:12:27
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
$PACKAGE AbcSpei
SUBROUTINE ABC.RFC.CEP
*=============================================================================
* DESCRIPCION: Se guarda en el registro de la transacción SPEI entrante el RFC
*              que se tiene registrado en el Cliente para que el CDA cumpla con RFC
* FECHA:       2018/07/18
* AUTOR:
*=============================================================================
* Modificacion:
* Objetivo           :
* Desarrollador      :
* Compania           :
* Fecha Creacion     :
*=============================================================================

    $USING EB.DataAccess
    $USING EB.Updates
    $USING ST.Customer
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING ABC.BP
    $USING AbcSpei
    
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

********
PROCESS:
********
    Y.RFC = ''
    Y.NOMBRE = ''
    Y.ID.CUS = ''
    
    Y.ID.ACCOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)

    Y.LOCAL.REF  = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)

    EB.DataAccess.FRead(FN.ACCOUNT,Y.ID.ACCOUNT,R.ACCOUNT,F.ACCOUNT,Y.ERROR)

    IF R.ACCOUNT THEN
        Y.ID.CUS = R.ACCOUNT<AC.AccountOpening.Account.Customer>
        EB.DataAccess.FRead(FN.CUSTOMER,Y.ID.CUS,R.CUSTOMER,F.CUSTOMER,Y.ERROR)
        IF R.CUSTOMER THEN
            Y.RFC = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId><1,1>
            Y.LOCAL.REF<1,Y.POS.RFC.CTE>= Y.RFC
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LOCAL.REF)
            Y.ID.CUS = R.ACCOUNT<AC.AccountOpening.Account.Customer>
            Y.COMI = Y.ID.CUS:'*1'
*            ABC.BP.VpmVCustomerName()
            MSG = EB.SystemTables.getMessage()
            AbcSpei.abcVCustomerName(Y.COMI, Y.NOMBRE,MSG)
*            Y.NOMBRE = EB.SystemTables.getComiEnri()
            IF LEN(Y.NOMBRE) GT 40 THEN
                Y.NOMBRE=Y.NOMBRE[1,40]
            END
            Y.LOCAL.REF<1,Y.POS.FT.CUS.NAME>= Y.NOMBRE
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LOCAL.REF)
        END
    END
RETURN

***********
OPEN.FILES:
***********

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    APP.NAME = "FUNDS.TRANSFER"
    FIELD.NAME = "RFC.BENEF.SPEI": @VM :"FT.CUS.NAME"
    FIELD.POS = ""
    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    Y.POS.RFC.CTE        = FIELD.POS<1,1>
    Y.POS.FT.CUS.NAME    = FIELD.POS<1,2>

RETURN

END
