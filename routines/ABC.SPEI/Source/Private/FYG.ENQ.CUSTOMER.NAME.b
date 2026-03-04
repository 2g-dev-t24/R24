* @ValidationCode : Mjo1NDE3NzU4MDg6Q3AxMjUyOjE3NjAzNjQ2MTU0ODI6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Oct 2025 11:10:15
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
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
SUBROUTINE FYG.ENQ.CUSTOMER.NAME(CUST.ID)

*-----------------------------------------------------------------------

    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.LocalReferences
   
*------ Main Processing Section

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

*----------
INITIALISE:
*----------

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
    
*	EB.LocalReferences.GetLocRef("CUSTOMER","CLASSIFICATION",CLASSIFICATION.POS)
    EB.LocalReferences.GetLocRef("CUSTOMER","NOM.PER.MORAL",NOM.PER.MORAL.POS)

RETURN

*-------
PROCESS:
*-------
    Y.ESPACIO = " "
    
    EB.DataAccess.FRead(FN.CUSTOMER,CUST.ID,R.INFO.CUST,F.CUSTOMER,ERROR.CUST)
    IF R.INFO.CUST THEN
    	Y.APELLIDO.P = R.INFO.CUST<ST.Customer.Customer.EbCusShortName>
    	Y.APELLIDO.M = R.INFO.CUST<ST.Customer.Customer.EbCusNameOne>
    	Y.NOMBRE.1 = R.INFO.CUST<ST.Customer.Customer.EbCusNameTwo>
    	Y.CLASSIFICATION = R.INFO.CUST<ST.Customer.Customer.EbCusSector>
    	Y.DENOMINACION = R.INFO.CUST<ST.Customer.Customer.EbCusLocalRef,NOM.PER.MORAL.POS>
    END
    
    Y.NAME = ""
    Y.NOMBRE = ""

    BEGIN CASE
        CASE Y.CLASSIFICATION EQ 1001
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,@FM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,@VM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,"  "," ")
            Y.NOMBRE.1 = TRIM(Y.NOMBRE.1)

            Y.NAME = Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M:Y.ESPACIO:Y.NOMBRE.1

        CASE Y.CLASSIFICATION EQ 1100
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,FM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,@VM," ")
            Y.NOMBRE.1 = EREPLACE(Y.NOMBRE.1,"  "," ")
            Y.NOMBRE.1 = TRIM(Y.NOMBRE.1)

            Y.NAME = Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M:Y.ESPACIO:Y.NOMBRE.1

        CASE (Y.CLASSIFICATION GE 2001) AND (Y.CLASSIFICATION LE 2014)
            Y.NAME = Y.DENOMINACION
        CASE Y.CLASSIFICATION EQ 4
            Y.NAME = Y.APELLIDO.P
        CASE Y.CLASSIFICATION EQ 5
            Y.NAME = Y.APELLIDO.P
    END CASE

    CUST.ID = Y.NAME

RETURN
END
