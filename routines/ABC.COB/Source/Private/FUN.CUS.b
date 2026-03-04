* @ValidationCode : Mjo0NzQ3NzQ3MTI6Q3AxMjUyOjE3NTk3ODE4MTI2OTc6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Oct 2025 17:16:52
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

SUBROUTINE FUN.CUS(APP.ID,VALUE.TO.GET,RESULT)
*-----------------------------------------------------------------------------
* ESTA RUTINA NO HA SIDO MIGRADA EN SU TOTALIDAD, SOLO LO NECESARIO PARA LA MIGRACION
* DE LAS RUTINAS RELACIONADAS A LA EJECUCION DEL COB
*-----------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer

    GOSUB INITIALISATION
    GOSUB MAIN.PROCESS

    RESULT = UPCASE(TRIM(RESULT,'','D'))

RETURN

*-----------------------------------------------------------------------------

*** <region name= INITIALISATION>

INITIALISATION:

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    GOSUB GET.LOCAL.REF.FIELDS

RETURN

*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.LOCAL.REF.FIELDS>
GET.LOCAL.REF.FIELDS:
***

    Y.LOCAL.REF.APP   = 'CUSTOMER'
    Y.LOCAL.REF.FIELD =  'L.NOM.PER.MORAL'
    Y.LOCAL.REF.POS   = ''

    EB.Updates.MultiGetLocRef(Y.LOCAL.REF.APP,Y.LOCAL.REF.FIELD,Y.LOCAL.REF.POS)

    Y.NOM.PER.MORAL.POS  = Y.LOCAL.REF.POS   ;* Posicion campo L.NOM.PER.MORAL

RETURN

*** </region>

*-----------------------------------------------------------------------------

*** <region name= MAIN.PROCESS>
MAIN.PROCESS:
*** <desc>main subroutine processing</desc>

    BEGIN CASE

        CASE VALUE.TO.GET = 'PERSONALIDAD'
            RESULT = ''
            CUSTOMER.ID = APP.ID
            GOSUB GET.PERSONALIDAD
        CASE VALUE.TO.GET = 'NOMBRE'
            RESULT = ''
            CUSTOMER.ID = APP.ID
            GOSUB GET.NOMBRE
        CASE VALUE.TO.GET = 'APELLIDO.P'
            RESULT = ''
            CUSTOMER.ID = APP.ID
            GOSUB GET.APELLIDO.PATERNO
        CASE VALUE.TO.GET = 'APELLIDO.M'
            RESULT = ''
            CUSTOMER.ID = APP.ID
            GOSUB GET.APELLIDO.MATERNO
        CASE 1
            CRT "You came nowhere: " : VALUE.TO.GET
    END CASE

RETURN

*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.NOMBRE>
GET.NOMBRE:
***

    EB.DataAccess.CacheRead(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,YERR)

    GOSUB GET.CLASSIFICATION

    Y.NAME  = ''

    IF Y.CLASSIFICATION NE '3' THEN

        RESULT = R.CUSTOMER<ST.Customer.Customer.EbCusNameTwo>

    END ELSE

        RESULT = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,Y.NOM.PER.MORAL.POS>

    END

RETURN

*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.CLASSIFICATION>
GET.CLASSIFICATION:
***
    Y.CLASSIFICATION = R.CUSTOMER<ST.Customer.Customer.EbCusSector>

RETURN

*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.PERSONALIDAD>
GET.PERSONALIDAD:
***

    EB.DataAccess.CacheRead(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,YERR)

    GOSUB GET.CLASSIFICATION

    IF Y.CLASSIFICATION NE '3' THEN

        RESULT = 'F'

    END ELSE

        RESULT = 'M'

    END

RETURN

*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.APELLIDO.PATERNO>
GET.APELLIDO.PATERNO:
***

    EB.DataAccess.CacheRead(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,YERR)

    GOSUB GET.CLASSIFICATION

    RESULT = ''

    IF Y.CLASSIFICATION NE 3 THEN

        RESULT = R.CUSTOMER<ST.Customer.Customer.EbCusShortName>

    END

RETURN

*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.APELLIDO.MATERNO>
GET.APELLIDO.MATERNO:
***

    EB.DataAccess.CacheRead(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,YERR)

    GOSUB GET.CLASSIFICATION

    RESULT = ''

    IF Y.CLASSIFICATION NE 3 THEN
        RESULT = R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>
    END

RETURN

*-----------------------------------------------------------------------------

END
