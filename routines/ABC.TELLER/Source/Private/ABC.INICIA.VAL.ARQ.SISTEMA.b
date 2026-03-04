* @ValidationCode : MjotNjgwOTAxMTU3OkNwMTI1MjoxNzY0NzcwOTk2MDc1Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Dec 2025 11:09:56
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
SUBROUTINE ABC.INICIA.VAL.ARQ.SISTEMA
* ======================================================================
* Nombre de Programa : ABC.INICIA.VAL.ARQ.SISTEMA
* Parametros         :
* Objetivo           : Obtiene los valores iniciales con la informaci�n del sistema: denominaciones, unidades y total
* Requerimiento      : CORE-1305 Generar alertas para cuando se exceda el l�mite de efectivo y cuando se hacen arqueos
* Desarrollador      : CAST - FyG-Solutions
* Compania           : ABC Capital
* Fecha Creacion     :
* Modificaciones     :
* ======================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Stock
    $USING TT.Config
    $USING AbcTable
    $USING EB.ErrorProcessing
*----------

    TT.ARQUEO.DENOM = EB.SystemTables.getRNew(AbcTable.AbcTtArqueo.Denom)
    IF TT.ARQUEO.DENOM EQ "" THEN
        GOSUB INICIA
        GOSUB ABRE.ARCHIVOS
        GOSUB PROCESO
    END
RETURN

*----------
INICIA:
*----------

    Y.MONEDA = EB.SystemTables.getLccy()

    EB.SystemTables.setRNew(AbcTable.AbcTtArqueo.Moneda, Y.MONEDA)
    COMI = EB.SystemTables.getComi()
    Y.CUENTA = Y.MONEDA:'10000':COMI

    tmp = EB.SystemTables.getT(AbcTable.AbcTtArqueo.Cajero)
    tmp<3>="NOINPUT"
    EB.SystemTables.setT(AbcTable.AbcTtArqueo.Cajero, tmp)
    
RETURN
*----------
*----------
ABRE.ARCHIVOS:
*----------
    FN.TELLER.DENOMINATION = "F.TELLER.DENOMINATION"
    F.TELLER.DENOMINATION = ""
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION, F.TELLER.DENOMINATION)

    FN.TT.STOCK.CONTROL = "F.TT.STOCK.CONTROL"
    F.TT.STOCK.CONTROL=""
    EB.DataAccess.Opf(FN.TT.STOCK.CONTROL,F.TT.STOCK.CONTROL)

RETURN
*----------
*----------
PROCESO:
*----------
    R.TT.STOCK.CONTROL=""
    EB.DataAccess.FRead(FN.TT.STOCK.CONTROL,Y.CUENTA,R.TT.STOCK.CONTROL,F.TT.STOCK.CONTROL,ERR.PARAM)
    IF R.TT.STOCK.CONTROL EQ "" THEN
        E="EB-CASHLESS.TELLER"
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.Err()
        RETURN
    END
    Y.DENOM.EN.CAJA = R.TT.STOCK.CONTROL<TT.Stock.StockControl.ScDenomination>
    Y.TOTAL = 0
*El select descendente BY-DSND no acomoda correctamente las monedas por valor
    Y.SEL.CMD = 'SELECT ':FN.TELLER.DENOMINATION:' BY VALUE'
    EB.DataAccess.Readlist(Y.SEL.CMD,Y.SEL.LIST, '', Y.SEL.NO, Y.SEL.ERR)
    Y.SET.DENOM.ARQ = TT.ARQUEO.DENOM
    Y.ARQ.CANTIDAD  = EB.SystemTables.getRNew(AbcTable.AbcTtArqueo.Cantidad)
    
    Y.AA =1
    FOR Y.BB=Y.SEL.NO TO 1 STEP -1
        Y.DENOM = Y.SEL.LIST<Y.BB>
        Y.SET.DENOM.ARQ<1,Y.AA>= Y.DENOM
        EB.SystemTables.setRNew(AbcTable.AbcTtArqueo.Denom,Y.SET.DENOM.ARQ)
        FIND Y.DENOM IN Y.DENOM.EN.CAJA SETTING Y.FM,Y.VM THEN
            Y.ARQ.CANTIDAD<1,Y.AA> = R.TT.STOCK.CONTROL<TT.Stock.StockControl.ScQuantity,Y.VM>
            EB.SystemTables.setRNew(AbcTable.AbcTtArqueo.Cantidad, Y.ARQ.CANTIDAD)
            Y.CANTIDAD = R.TT.STOCK.CONTROL<TT.Stock.StockControl.ScQuantity,Y.VM>
            IF Y.CANTIDAD EQ "" THEN
                Y.ARQ.CANTIDAD<1,Y.AA> = 0
                EB.SystemTables.setRNew(AbcTable.AbcTtArqueo.Cantidad, Y.ARQ.CANTIDAD)
            END
            R.TELLER.DENOMINATION=""
            EB.DataAccess.FRead(FN.TELLER.DENOMINATION,Y.DENOM,R.TELLER.DENOMINATION,F.TELLER.DENOMINATION,ERR.TELLER.DENOMINATION)
            IF R.TELLER.DENOMINATION THEN
                Y.VALOR = R.TELLER.DENOMINATION<TT.Config.TellerDenomination.DenValue>
                Y.TOTAL.X.DENOM = Y.CANTIDAD * Y.VALOR
            END
            Y.TOTAL += Y.TOTAL.X.DENOM
        END ELSE
            Y.ARQ.CANT<1,Y.AA> = 0
            EB.SystemTables.setRNew(AbcTable.AbcTtArqueo.Cantidad, Y.ARQ.CANT)
        END
        Y.ARQ.CANT.FIS<1,Y.AA> = 0
        EB.SystemTables.setRNew(AbcTable.AbcTtArqueo.CantidadFis, Y.ARQ.CANT.FI)
        Y.AA = Y.AA + 1
    NEXT Y.BB
   
    EB.SystemTables.setRNew(AbcTable.AbcTtArqueo.Total, Y.TOTAL)

RETURN
*----------

END
