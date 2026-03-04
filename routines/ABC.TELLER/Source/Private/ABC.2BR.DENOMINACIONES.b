* @ValidationCode : MjoxNDExODg2ODk1OkNwMTI1MjoxNzYzMDQ2MDEwMDc5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Nov 2025 12:00:10
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

SUBROUTINE ABC.2BR.DENOMINACIONES
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
    $USING TT.Config
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.MONEDA    = EB.SystemTables.getComi()
    MESSAGE     = EB.SystemTables.getMessage()
    AV          = EB.SystemTables.getAv()
    
    IF (Y.MONEDA EQ '') THEN
        Y.MONEDA    = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Moneda)
    END
    
*ABRE TABLA DONDE SE GUARDAN DENOMINACIONES
    F.TELLER.DENOMINATION = ""
    FN.TELLER.DENOMINATION = "F.TELLER.DENOMINATION"
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION,F.TELLER.DENOMINATION)

    GOSUB LEE.ARCHIVO
    
    DENOMINACION            = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Denominacion)
    MONTO.DENOM             = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.MontoDenom)
    
    IF MESSAGE NE 'VAL' THEN
        FOR Y.CON.DEN = 1 TO Y.NUM.DENOMINACION
            MONTO.DENOM<1, Y.CON.DEN>   = ''
            DENOMINACION<1, Y.CON.DEN>  = '0'
        NEXT Y.CON.DEN
    
        EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.MontoDenom, MONTO.DENOM)
        EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.Denominacion, DENOMINACION)
    END
    Y.MONTO.TOTAL = 0

RETURN
*-----------------------------------------------------------------------------
LEE.ARCHIVO:
*-----------------------------------------------------------------------------
    YLD.NO = ''
    YLD.ID = ''
    SELECT.CMD  = "SELECT ":FN.TELLER.DENOMINATION:" WITH @ID LIKE ":DQUOTE(SQUOTE(Y.MONEDA):"..."):" BY-DSND VALUE"
    EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
    Y.NUM.DENOMINACION  = YLD.NO
    Y.ID.DENOMINACION   = YLD.ID

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    FOR Y.CON.DENOMINACION = 1 TO Y.NUM.DENOMINACION
        Y.DEN.TMP   = Y.ID.DENOMINACION<Y.CON.DENOMINACION>
        Y.REG.DENO  = ''
        EB.DataAccess.FRead(FN.TELLER.DENOMINATION, Y.DEN.TMP, Y.REG.DENO, F.TELLER.DENOMINATION, ERR.TT.DEN)
        
        IF (Y.REG.DENO) THEN
            IF MESSAGE NE 'VAL' THEN
                DENOMINACION<1, Y.CON.DENOMINACION> = Y.DEN.TMP
                EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.Denominacion, DENOMINACION)
            END ELSE
                Y.VAL = Y.REG.DENO<TT.Config.TellerDenomination.DenValue>
                Y.CANT          = MONTO.DENOM<1,Y.CON.DENOMINACION>
                Y.MONTO.DEN     = Y.VAL * Y.CANT
                Y.MONTO.TOTAL   = Y.MONTO.TOTAL + Y.MONTO.DEN
            END
        END
    NEXT Y.CON.DENOMINACION
    
    IF MESSAGE EQ 'VAL' THEN
        Y.MONTO.CAPTURADO = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Monto)
        IF Y.MONTO.CAPTURADO NE Y.MONTO.TOTAL THEN
            ETEXT = "SUMA DE DENOMINACIONES NO IGUAL AL MONTO SOLICITADO: ":Y.MONTO.TOTAL: "<>" :Y.MONTO.CAPTURADO
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END
    EB.Display.RebuildScreen()
    
RETURN
*-----------------------------------------------------------------------------
END