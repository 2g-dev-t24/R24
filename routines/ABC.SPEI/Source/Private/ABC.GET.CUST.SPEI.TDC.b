* @ValidationCode : MjotMTcyMzk4NjQxMDpDcDEyNTI6MTc2MDU4NDMwNTEwMzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Oct 2025 00:11:45
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
*===============================================================================
* <Rating>-50</Rating>
*===============================================================================
$PACKAGE AbcSpei
SUBROUTINE ABC.GET.CUST.SPEI.TDC
*===============================================================================
* Nombre de Programa : ABC.GET.CUST.SPEI.TDC
* Objetivo           : Rutina para extraer los campos de cliente
* Requerimiento      : Pago SPEI IN TDC UALA
* Desarrollador      : Alexis Almaraz Robles - F&G Solutions
* Compania           : ABC Capital
* Fecha Creacion     : 2023/05/18
*===============================================================================
* Modificaciones:
*===============================================================================

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
    $USING AbcTable
    $USING EB.Display

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ID.CLABE.TDC = ''
    Y.ID.TARJ.TDC = ''
    R.ABC.TARJETA.CRED.UALA = ''
    ERR.TDC.UALA = ''
    R.CUSTOMER = ''
    ERR.CUS = ''
    Y.RFC = ''
    Y.NOMBRE = ''
    Y.ID.CLIENTE.TDC = ''
    Y.ID.CUSTOMER = ''
    Y.ID.CUSTOMER.TDC = ''
    Y.CLABE.TDC.UALA = ''

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.ABC.TARJETA.CRED.UALA = 'F.ABC.TARJETA.CRED.UALA'
    F.ABC.TARJETA.CRED.UALA = ''
    EB.DataAccess.Opf(FN.ABC.TARJETA.CRED.UALA, F.ABC.TARJETA.CRED.UALA)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER','RFC.BENEF.SPEI',Y.POS.RFC.CTE)
    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER','FT.CUS.NAME',Y.POS.FT.CUS.NAME)
    EB.Updates.MultiGetLocRef('FUNDS.TRANSFER','ID.CLIENTE.TDC',Y.POS.ID.CLIENTE.TDC)

RETURN


*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------

    Y.ID.CLABE.TDC = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.ID.CLIENTE.TDC = Y.LOCAL.REF<1,Y.POS.ID.CLIENTE.TDC>

    BEGIN CASE
        CASE LEN(Y.ID.CLABE.TDC) EQ 16

            IF Y.ID.CLIENTE.TDC EQ '' THEN
                ETEXT = "FAVOR DE ENVIAR EL NUMERO DE CLIENTE"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            Y.ID.CUSTOMER = Y.ID.CLIENTE.TDC
            GOSUB GET.UPD.DATOS.CLIENTE

        CASE LEN(Y.ID.CLABE.TDC) EQ 18

            Y.ID.TARJ.TDC = Y.ID.CLABE.TDC[7,11]
            EB.DataAccess.FRead(FN.ABC.TARJETA.CRED.UALA, Y.ID.TARJ.TDC, R.ABC.TARJETA.CRED.UALA, F.ABC.TARJETA.CRED.UALA, ERR.TDC.UALA)
            IF R.ABC.TARJETA.CRED.UALA THEN
                Y.CLABE.TDC.UALA = R.ABC.TARJETA.CRED.UALA<AbcTable.AbcTarjetaCredUala.Clabe>

                IF Y.ID.CLABE.TDC NE Y.CLABE.TDC.UALA THEN
                    ETEXT = "CUENTA CLABE NO VALIDA"
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                END

                Y.ID.CUSTOMER.TDC = R.ABC.TARJETA.CRED.UALA<AbcTable.AbcTarjetaCredUala.Customer>
                Y.ID.CUSTOMER = Y.ID.CUSTOMER.TDC
                GOSUB GET.UPD.DATOS.CLIENTE

                EB.Display.RebuildScreen()
            END ELSE
                ETEXT = "CUENTA CLABE NO VALIDA"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END

    END CASE

RETURN

*-------------------------------------------------------------------------------
GET.UPD.DATOS.CLIENTE:
*-------------------------------------------------------------------------------

    EB.DataAccess.FRead(FN.CUSTOMER, Y.ID.CUSTOMER, R.CUSTOMER, F.CUSTOMER, ERR.CUS)
    IF R.CUSTOMER THEN
        Y.RFC = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId><1,1>

        AbcSpei.fygEnqCustomerName(Y.ID.CUSTOMER)
        Y.NOMBRE = Y.ID.CUSTOMER

        IF LEN(Y.NOMBRE)GT 40 THEN
            Y.NOMBRE=Y.NOMBRE[1,40]
        END
    END
    Y.LOCAL.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.LOCAL.REF<1,Y.POS.RFC.CTE> = Y.RFC
    Y.LOCAL.REF<1,Y.POS.FT.CUS.NAME> = Y.NOMBRE
    Y.LOCAL.REF<1,Y.POS.ID.CLIENTE.TDC> = Y.ID.CUSTOMER.TDC
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LOCAL.REF)

    EB.Display.RebuildScreen()

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------



RETURN

END
