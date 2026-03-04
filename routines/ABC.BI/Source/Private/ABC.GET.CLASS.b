$PACKAGE AbcBi
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.GET.CLASS
*=============================================================================
*       Descripcion: Rutina que Regresa la clasificacion del Cliente
*                    dependiendo de su tipo de Banca, para Banca Empresarial
*                    de la tabla ABC.BANCA.INTERNET.
*=============================================================================

    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Reports

    GOSUB OPEN.FILES
    GOSUB INITIALISE
    GOSUB PROCESS

*----------
OPEN.FILES:
*----------

    FN.ABC.BANCA.INTERNET = 'F.ABC.BANCA.INTERNET'
    F.ABC.BANCA.INTERNET = ''
    EB.DataAccess.Opf(FN.ABC.BANCA.INTERNET,F.ABC.BANCA.INTERNET)

    FN.CUSTOMER           = 'F.CUSTOMER'
    F.CUSTOMER           = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    RETURN

*----------
INITIALISE:
*----------

    Y.TIPO.BANCA = 'BANCA EMPRESARIAL'
    Y.SEPARADOR  = '*'
    Y.CUST.NO    = ''
    Y.BAN.EMP    = ''
    Y.CLASS      = ''

    RETURN


*-------
PROCESS:
*-------

    Y.COMI = EB.Reports.getOData()

    Y.CUST.NO = FIELD(Y.COMI,Y.SEPARADOR,1)
    Y.BAN.EMP = FIELD(Y.COMI,Y.SEPARADOR,2)

    EB.DataAccess.FRead(FN.CUSTOMER, Y.CUST.NO, REC.CUS, F.CUSTOMER, Y.ERR.CUS)

    IF REC.CUS NE '' THEN
        Y.CLASSIFICATION = ''; 
        Y.CLASSIFICATION = REC.CUS<ST.Customer.Customer.EbCusSector>

        IF Y.CLASSIFICATION GE 2 THEN
            IF Y.BAN.EMP EQ Y.TIPO.BANCA THEN
                Y.CLASS = Y.CLASSIFICATION
            END ELSE
                Y.CLASS = 1
            END
        END ELSE
            Y.CLASS = Y.CLASSIFICATION
        END
    END

    EB.Reports.setOData(Y.CLASS)

    RETURN

END
