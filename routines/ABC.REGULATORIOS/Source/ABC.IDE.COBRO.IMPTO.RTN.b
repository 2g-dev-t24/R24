* @ValidationCode : MjoxMDY5MzQ1MDY1OkNwMTI1MjoxNzYxNzExNjg3NzQ0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 29 Oct 2025 01:21:27
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
$PACKAGE AbcRegulatorios

SUBROUTINE ABC.IDE.COBRO.IMPTO.RTN(P.PER, P.CLIE, P.CUENTA, P.MTO.COBRO, P.FOL.COBRO)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AC.EntryCreation
    $USING AC.AccountOpening
    $USING EB.Display
    $USING AC.API
    $USING ST.Customer
*-----------------------------------------------------------------------------

    GOSUB INICIO
    GOSUB PROCESO
RETURN



*==========
PROCESO:
*==========
    READ REC.PARAM FROM F.ABC.IDE.PARAM, ID.PARAM THEN
        Y.MONEDA       = REC.PARAM<AbcTable.AbcIdeParam.Moneda>
        Y.TRANS.CARGO  = REC.PARAM<AbcTable.AbcIdeParam.TransCr>
        Y.TRANS.ABONO  = REC.PARAM<AbcTable.AbcIdeParam.TransAb>
        Y.CUENTA.ABONO = REC.PARAM<AbcTable.AbcIdeParam.CuentaAb>

        READ REC.CLI FROM F.CUSTOMER, P.CLIE ELSE NULL

        P.FOL.COBRO = 'IDE-': P.PER :'-': TIME()

        STR.REC.ENTRY.EB.ACC = ''
        TODAY   = EB.SystemTables.getToday()
        STR.REC.ENTRY = ''
        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.SteCompanyCode>    = 'MX0010001'
        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.SteSystemId>       = 'A'
        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.SteValueDate>      = TODAY
        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.SteBookingDate>    = TODAY
        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.SteExposureDate>   = TODAY
        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.SteCustomerId>     = P.CLIE
        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.StePositionType>   = 'TR'
        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.SteCurrencyMarket> = '1'
        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.SteAccountOfficer> = REC.CLI<ST.Customer.Customer.EbCusAccountOfficer>
        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.SteDepartmentCode> = REC.CLI<ST.Customer.Customer.EbCusDeptCode>
        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.SteTheirReference> = P.CUENTA
        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.SteOurReference> = P.CUENTA

        STR.REC.ENTRY<AC.EntryCreation.StmtEntry.SteCurrency>        = Y.MONEDA

        STR.REC.ENTRY.CARGO = ''
        STR.REC.ENTRY.CARGO = STR.REC.ENTRY
        STR.REC.ENTRY.CARGO<AC.EntryCreation.StmtEntry.SteAmountLcy> = (-1) * P.MTO.COBRO
        STR.REC.ENTRY.CARGO<AC.EntryCreation.StmtEntry.SteAccountNumber> = P.CUENTA
        STR.REC.ENTRY.CARGO<AC.EntryCreation.StmtEntry.SteTransactionCode> = Y.TRANS.CARGO
        STR.REC.ENTRY.CARGO<AC.EntryCreation.StmtEntry.SteTransReference>   = 'IDE-': P.PER :'-': TIME()
        STR.REC.ENTRY.CARGO<AC.EntryCreation.StmtEntry.SteProductCategory> = ''
        STR.REC.ENTRY.EB.ACC<-1> = LOWER(STR.REC.ENTRY.CARGO)

        STR.REC.ENTRY.ABONO = ''
        STR.REC.ENTRY.ABONO = STR.REC.ENTRY
        STR.REC.ENTRY.ABONO<AC.EntryCreation.StmtEntry.SteAmountLcy> = P.MTO.COBRO
        STR.REC.ENTRY.ABONO<AC.EntryCreation.StmtEntry.SteAccountNumber> = Y.CUENTA.ABONO
        STR.REC.ENTRY.ABONO<AC.EntryCreation.StmtEntry.SteTransactionCode> = Y.TRANS.ABONO
        STR.REC.ENTRY.ABONO<AC.EntryCreation.StmtEntry.SteTransReference>  = P.CUENTA
        STR.REC.ENTRY.ABONO<AC.EntryCreation.StmtEntry.SteNarrative> = P.CUENTA :'-': P.PER :'-': TIME()
        STR.REC.ENTRY.ABONO<AC.EntryCreation.StmtEntry.SteProductCategory> = ''
        STR.REC.ENTRY.ABONO<AC.EntryCreation.StmtEntry.StePlCategory> = ''
        STR.REC.ENTRY.EB.ACC<-1> = LOWER(STR.REC.ENTRY.ABONO)

        YENTRY.REC = STR.REC.ENTRY.EB.ACC
        EB.SystemTables.setV(AC.EntryCreation.StmtEntry.SteDateTime)
*      V = AC.STE.DATE.TIME
        AC.API.EbAccounting("AC","SAO",YENTRY.REC,"")
*        R.NEW(21)
*        CALL JOURNAL.UPDATE("")
    END

RETURN




*==========
INICIO:
*==========
    F.CUSTOMER = ''
    FN.CUSTOMER = 'F.CUSTOMER'
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

    F.ABC.IDE.PARAM = ''
    FN.ABC.IDE.PARAM = 'F.ABC.IDE.PARAM'
    EB.DataAccess.Opf(FN.ABC.IDE.PARAM, F.ABC.IDE.PARAM)

    ID.PARAM = 'MX0010001'

RETURN

END

