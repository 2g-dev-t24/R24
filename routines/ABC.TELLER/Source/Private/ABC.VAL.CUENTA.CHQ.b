* @ValidationCode : MjotMjExNjA3ODY1OkNwMTI1MjoxNzY3NjcwNDQwNzQ1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Jan 2026 00:34:00
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
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
SUBROUTINE ABC.VAL.CUENTA.CHQ
*===============================================================================
* Nombre de Programa : ABC.VAL.CUENTA.CHQ
* Objetivo           : Rutina que valida que la cuenta exista y llena los datos del cheque
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcSpei
    $USING AbcTable
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

RETURN
*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
    Y.ID.ACC = EB.SystemTables.getComi()
    Y.ID.ACC = FMT(Y.ID.ACC,"11'0'R")
    Y.ID.NEW = EB.SystemTables.getIdNew()

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER  = ""
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    EB.DataAccess.FRead(FN.ACCOUNT,Y.ID.ACC,REC.ACCOUNT,F.ACCOUNT,AC.ERR)

    Y.CLIENTE = EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.IdCliente)
    AbcSpei.AbcValPostRest(Y.ID.ACC)
    IF REC.ACCOUNT THEN
        Y.ID.CUSTOMER = REC.ACCOUNT<AC.AccountOpening.Account.Customer>
        IF Y.CLIENTE NE Y.ID.CUSTOMER THEN
            Y.CUS = Y.ID.CUSTOMER
            Y.NOMBRE = ''
            MSG = EB.SystemTables.getMessage()
            AbcSpei.abcVCustomerName(Y.CUS, Y.NOMBRE,MSG)
            EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.IdCliente, Y.ID.CUSTOMER)
            EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.NombreCliente, Y.NOMBRE)
            EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.IdRegistro, Y.ID.NEW)
        END
    END ELSE
        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.IdCliente, '')
        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.NombreCliente, '')
        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.IdRegistro, '')
        ETEXT = "LA CUENTA NO EXISTE "
        EB.SystemTables.setEtext(ETEXT)
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

RETURN

*** <region name= FINALIZE>
FINALIZE:
***
RETURN
END
