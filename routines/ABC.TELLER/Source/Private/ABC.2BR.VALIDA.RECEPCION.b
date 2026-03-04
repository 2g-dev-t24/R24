* @ValidationCode : Mjo3NTUyMTU1MDk6Q3AxMjUyOjE3NjMwNTUwOTAyNDg6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Nov 2025 14:31:30
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
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
SUBROUTINE ABC.2BR.VALIDA.RECEPCION
*-----------------------------------------------------------------------------
    $USING TT.Config
    $USING TT.Stock
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.Display
    $USING EB.DataAccess
    $USING EB.SystemTables
***********
    GOSUB INICIALIZA
    GOSUB PROCESA

RETURN
***********
INICIALIZA:
***********
    Y.MONEDA = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Moneda)
    
*ABRE TABLA DONDE SE GUARDARAN SALDOS POR CUENTA
    F.TELLER.DENOMINATION = ""
    FN.TELLER.DENOMINATION = "F.TELLER.DENOMINATION"
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION,F.TELLER.DENOMINATION)

    Y.MONTO.TOTAL   = 0
    Y.NO.EXISTE     = 0
    MONTO.DENOM.REC = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.MontoDenomRec)

RETURN
********
PROCESA:
********
    GOSUB LEE.ARCHIVO
    FOR Y.CON.DENOMINACION = 1 TO Y.NUM.DENOMINACION
        Y.DEN.TMP   = Y.ID.DENOMINACION<Y.CON.DENOMINACION>
        Y.REG.DENO   = ''
        EB.DataAccess.FRead(FN.TELLER.DENOMINATION, Y.DEN.TMP, Y.REG.DENO, F.TELLER.DENOMINATION, Er)
        IF (Y.REG.DENO) THEN
            Y.VAL = Y.REG.DENO<TT.Config.TellerDenomination.DenValue>
            Y.CANT = MONTO.DENOM.REC<1, Y.CON.DENOMINACION>
            Y.MONTO.DEN = Y.VAL * Y.CANT
            Y.MONTO.TOTAL = Y.MONTO.TOTAL + Y.MONTO.DEN
        END
    NEXT Y.CON.DENOMINACION
    EB.Display.RebuildScreen()
    
    Y.MONTO.CAPTURADO = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.MontoRecibido)
    IF Y.MONTO.CAPTURADO NE Y.MONTO.TOTAL THEN
        TEXT = "SUMA DE DENOMINACIONES NO IGUAL AL MONTO RECIBIDO:":Y.MONTO.TOTAL: "<>" :Y.MONTO.CAPTURADO
*        EB.SystemTables.setText(TEXT)
*        EB.Display.Rem();
        ETEXT = TEXT
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    EB.Display.RebuildScreen()

RETURN
************
LEE.ARCHIVO:
************
    YLD.NO = ''
    YLD.ID = ''
    SELECT.CMD  = "SELECT ":FN.TELLER.DENOMINATION:" WITH @ID LIKE ":DQUOTE(SQUOTE(Y.MONEDA):"..."):" BY-DSND VALUE"
    EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
    Y.NUM.DENOMINACION = YLD.NO
    Y.ID.DENOMINACION = YLD.ID

RETURN
**********
END


