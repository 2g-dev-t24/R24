* @ValidationCode : Mjo3MjYwMjA2MTg6Q3AxMjUyOjE3Njc5NzA2NDk5NTY6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2026 11:57:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
SUBROUTINE ABC.ACC.CUS.NAME.DB

*-----------------------------------------------------------------------
*
* This subroutine has to be Attached
* with any version in the Customer Id field.
* It will populate the complete Name of the Customer
*-----------------------------------------------------------------------

    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.LocalReferences
    $USING FT.Contract
    $USING EB.Display

*------ Main Processing Section

    MESSAGE = EB.SystemTables.getMessage()
    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

*----------
INITIALISE:
*----------
    Y.SEPARADOR = '*'
    Y.ORDEN.1 = "1" ;* Ordenamiento del nombre (Nombres y Apellidos)
    Y.ORDEN = ""

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
    Y.ACCOUNT = EB.SystemTables.getComi()
*    CALL DBR('ACCOUNT':FM:AC.CUSTOMER,YR.ACCOUNT,Y.CUSTOMER)
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ACCOUNT, REC.CUENTA, F.ACCOUNT, Y.ACCT.ERR)
    Y.CUSTOMER = REC.CUENTA<AC.AccountOpening.Account.Customer>

    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","FT.DB.CUS.NAME",FT.DB.CUS.NAME.POS)

RETURN

*-------
PROCESS:
*-------

    Y.ESPACIO = " "
    Y.CUST.NO = Y.CUSTOMER
    Y.ORDEN = ''

    EB.LocalReferences.GetLocRef("CUSTOMER","NOM.PER.MORAL",NOM.PER.MORAL.POS)

    EB.DataAccess.FRead(FN.CUSTOMER,Y.CUST.NO,R.CUSTOMER,F.CUSTOMER,ERROR.CUSTOMER)
    IF R.CUSTOMER THEN
        Y.APELLIDO.P = R.CUSTOMER<ST.Customer.Customer.EbCusShortName>
        Y.APELLIDO.M = R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>
        Y.NOMBRE.1 = R.CUSTOMER<ST.Customer.Customer.EbCusNameTwo>
        Y.SECTOR = R.CUSTOMER<ST.Customer.Customer.EbCusSector>
        Y.NOM.PER.MORAL = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef, NOM.PER.MORAL.POS>
    END ELSE
        ETEXT = "EL CLIENTE NO EXISTE"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END


    Y.NAME = ""
    Y.NOMBRE = ""

    BEGIN CASE
        CASE Y.SECTOR EQ 1001
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,@FM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,@VM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,"  "," ")
            Y.NOMBRE.1 = TRIM(Y.NOMBRE.1)

            IF Y.ORDEN EQ "" THEN
                Y.NAME = Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M:Y.ESPACIO:Y.NOMBRE.1

            END ELSE
                Y.NAME = Y.NOMBRE.1
                Y.NAME := Y.ESPACIO:Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M
            END

        CASE Y.SECTOR EQ 1100
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,@FM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,@VM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,"  "," ")
            Y.NOMBRE.1 = TRIM(Y.NOMBRE.1)

            IF Y.ORDEN EQ '' THEN
                Y.NAME = Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M:Y.ESPACIO:Y.NOMBRE.1

            END ELSE
                Y.NAME = Y.NOMBRE.1
                Y.NAME := Y.ESPACIO:Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M
            END

        CASE Y.SECTOR GE 2001 AND Y.SECTOR LE 2014
            Y.NAME = TRIM(Y.NOM.PER.MORAL)
        CASE Y.SECTOR GE 1300 AND Y.SECTOR 1304
            Y.NAME = TRIM(Y.NOM.PER.MORAL)
    END CASE
    
    
    Y.LOCAL.REF.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.LOCAL.REF.FT<1,FT.DB.CUS.NAME.POS> = Y.NAME
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.LOCAL.REF.FT)
    EB.Display.RebuildScreen()


RETURN

END
