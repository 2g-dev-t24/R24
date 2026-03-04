* @ValidationCode : MjoxOTc5MTc0Mzg5OkNwMTI1MjoxNzU4NTA1MDE4MDMxOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Sep 2025 22:36:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE AbcTeller

SUBROUTINE BAM.V.VALIDATE.STOCK
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING EB.ErrorProcessing
    $USING AbcTable
    $USING ST.CompanyCreation
    $USING TT.Config
    $USING TT.Stock
*-----------------------------------------------------------------------------

*    IF MESSAGE = 'VAL' THEN RETURN

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    PROCESS.GOAHEAD = 1
    APPLICATION     = EB.SystemTables.getApplication()
    COMI            = EB.SystemTables.getComi()
    ID.COMPANY      = EB.SystemTables.getIdCompany()
    AV              = EB.SystemTables.getAv()

    Y.ERROR       = ''
    Y.ID.PARAM    = 'SYSTEM'
    Y.REC.PARAM   = ''
    Y.CURRENCY    = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Moneda)
    Y.BOVEDA      = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Solicitante)
    Y.FIELD.DENOM = 'MONTO.DENOM'
    
RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    FV.TELLER.PARAMETER = ''
    EB.DataAccess.Opf(FN.TELLER.PARAMETER, FV.TELLER.PARAMETER)

RETURN
*-----------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------------------------------------------------------------
*
* Check for any Pre requisite conditions - like the existence of a record/parameter etc
* if not, set PROCESS.GOAHEAD to 0
*
* When adding more CASEs, remember to assign the number of CASE statements to MAX.LOOPS
*
*
    LOOP.CNT = 1 ; MAX.LOOPS = 4
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF APPLICATION NE 'ABC.2BR.BOVEDAS' THEN PROCESS.GOAHEAD = 0
            CASE LOOP.CNT EQ 2
                IF COMI THEN
                    Y.ID.PARAM = ID.COMPANY
                    ST.CompanyCreation.EbReadParameter(FN.TELLER.PARAMETER,'N','',Y.REC.PARAM,Y.ID.PARAM,FV.TELLER.PARAMETER,Y.ERROR)
                
                    IF Y.ERROR THEN
                        ETEXT = 'TELLER.PARAMETE NO DEFINIDO'
                        ETEXT<2,1> = Y.FIELD.DENOM
                        EB.SystemTables.setEtext(ETEXT)
                        PROCESS.GOAHEAD = 0
                    END
                    Y.CATEGORY = Y.REC.PARAM<TT.Config.TellerParameter.ParAutocashCategory>
                END ELSE
                    PROCESS.GOAHEAD = 0
                END
            CASE LOOP.CNT EQ 3
                IF NOT(Y.CURRENCY) THEN
                    ETEXT = 'Moneda no ingresada'
                    ETEXT<2,1> = Y.FIELD.DENOM
                    EB.SystemTables.setEtext(ETEXT)
                    PROCESS.GOAHEAD = 0
                END
            CASE LOOP.CNT EQ 4
                IF NOT(Y.BOVEDA) THEN
                    ETEXT = 'Boveda ':Y.BOVEDA:' no definida'
                    ETEXT<2,1> = Y.FIELD.DENOM
                    EB.SystemTables.setEtext(ETEXT)
                    PROCESS.GOAHEAD = 0
                END

        END CASE
        LOOP.CNT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.DENOMINACION  = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Denominacion)
    Y.DENOMINACION  = Y.DENOMINACION<1,AV>
    Y.ID.STOCK      = Y.CURRENCY:Y.CATEGORY:Y.BOVEDA
    
    Y.REC.STOCK = ''
    Y.REC.STOCK = TT.Stock.StockControl.Read(Y.ID.STOCK, Y.ERROR)
    IF Y.ERROR THEN
        ETEXT = 'No existe definido el Stock para ':Y.ID.STOCK
        ETEXT<2,1> = Y.FIELD.DENOM
        EB.SystemTables.setEtext(ETEXT)
    END
    SC.DENOMINATION = RAISE(Y.REC.STOCK<TT.Stock.StockControl.ScDenomination>)
    LOCATE Y.DENOMINACION IN SC.DENOMINATION SETTING Y.POS THEN
        SC.QUANTITY = Y.REC.STOCK<TT.Stock.StockControl.ScQuantity,Y.POS>
        IF COMI GT SC.QUANTITY THEN
            ETEXT = 'Se tiene en stock solo ': SC.QUANTITY
            ETEXT<2,1> = Y.FIELD.DENOM
            EB.SystemTables.setEtext(ETEXT)
        END
    END
    EB.Display.RebuildScreen()
    
RETURN
*-----------------------------------------------------------------------------
END