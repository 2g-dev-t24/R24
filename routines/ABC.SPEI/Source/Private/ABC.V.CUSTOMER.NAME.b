* @ValidationCode : MjotMTE4NjA0MDgwNTpDcDEyNTI6MTc2NzY2NzY2NDEzMDpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2026 23:47:44
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

SUBROUTINE ABC.V.CUSTOMER.NAME(Y.COMI,Y.NOMBRE,MSG)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
*MSG = EB.SystemTables.getMessage()
*IF EB.SystemTables.getMessage() EQ 'VAL' THEN
    IF MSG EQ 'VAL' THEN
        RETURN
    END

    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*

*----------
INITIALISE:
*----------
    Y.SEPARADOR = '*'
    Y.ORDEN.1 = "1" ;* Ordenamiento del nombre (Nombres y Apellidos)
    Y.ORDEN = ""

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
    

    
    NOM.CAMPOS     = 'L.NOM.PER.MORAL'
    POS.CAMP.LOCAL = ""
    
    
    EB.Updates.MultiGetLocRef("CUSTOMER",NOM.CAMPOS,POS.CAMP.LOCAL)

    
    NOM.PER.MORAL.POS = POS.CAMP.LOCAL<1,1>
    
    

RETURN

*-------
PROCESS:
*-------
    Y.ESPACIO = " "
    Y.ORDEN = FIELD(Y.COMI,Y.SEPARADOR,2)

    IF INDEX(Y.COMI,Y.SEPARADOR,1) GT 0 THEN
        Y.CUST.NO = FIELD(Y.COMI,Y.SEPARADOR,1)
        Y.ORDEN = FIELD(Y.COMI,Y.SEPARADOR,2)
    END ELSE
        Y.CUST.NO = Y.COMI
        Y.ORDEN = ''
    END

    EB.DataAccess.FRead(FN.CUSTOMER, Y.CUST.NO, R.CUS.REC, F.CUSTOMER, Y.ERR.CUS)
    
*   Y.APELLIDO.P = R.CUS.REC<ST.Customer.Customer.EbCusShortName>
*   Y.APELLIDO.M = R.CUS.REC<ST.Customer.Customer.EbCusNameOne>
*   Y.NOMBRE.1 =R.CUS.REC<ST.Customer.Customer.EbCusNameTwo>
*   Y.CUS.REF = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef>

    Y.APELLIDO.P = R.CUS.REC<2>
    Y.APELLIDO.M = R.CUS.REC<3>
    Y.NOMBRE.1 =R.CUS.REC<4>
    Y.CUS.REF = R.CUS.REC<179>

*Y.CLASSIFICATION = R.CUS.REC<ST.Customer.Customer.EbCusSector>
    Y.CLASSIFICATION = R.CUS.REC<23>
    Y.DENOMINACION =  Y.CUS.REF<1,NOM.PER.MORAL.POS>

    Y.NAME = ""
    Y.NOMBRE = ""

    BEGIN CASE
        CASE Y.CLASSIFICATION EQ '1001'
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

        CASE Y.CLASSIFICATION EQ '1100'
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

        CASE Y.CLASSIFICATION GE '2001' AND Y.CLASSIFICATION LE '2014'
            Y.NAME = Y.DENOMINACION
        CASE Y.CLASSIFICATION GE '1300' AND Y.CLASSIFICATION LE '1304'
            Y.NAME = Y.APELLIDO.P
    END CASE

    Y.NOMBRE = Y.NAME


RETURN
END

