* @ValidationCode : MjoxMTUwMTM5OTIzOkNwMTI1MjoxNzYzMDU1MTgyOTA4Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Nov 2025 14:33:02
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

SUBROUTINE ABC.2BR.LIGA.TELLER

*-----------------------------------------------------------------------------
    $USING AbcTable
    $USING TT.Config
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING AbcTeller

    GOSUB INICIALIZA
    GOSUB PROCESA
    GOSUB LIGA.TELLER.TXN

RETURN
***********
INICIALIZA:
***********
*ABRE TABLA DONDE SE GUARDAN DENOMINACIONES

    F.TELLER.DENOMINATION = ""
    FN.TELLER.DENOMINATION = "F.TELLER.DENOMINATION"
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION,F.TELLER.DENOMINATION)
    
    BOV.MONEDA      = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Moneda)
    MONTO.DENOM     = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.MontoDenom)
    MONTO.DENOM.REC = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.MontoDenomRec)
    
    PGM.VERSION     = EB.SystemTables.getPgmVersion()

RETURN
********
PROCESA:
*******

    Y.TOT.MONEDAS = DCOUNT(BOV.MONEDA,@VM)
    FOR Y.CONT.MONEDAS = 1 TO Y.TOT.MONEDAS
        Y.MONEDA = BOV.MONEDA
        GOSUB LEE.ARCHIVO
        FOR Y.CON.DENOMINACION = 1 TO Y.NUM.DENOMINACION
            Y.DEN.TMP = Y.ID.DENOMINACION<Y.CON.DENOMINACION>
            
            Y.REG.DENO  = ''
            EB.DataAccess.FRead(FN.TELLER.DENOMINATION,Y.DEN.TMP,Y.REG.DENO,F.TELLER.DENOMINATION,ERR.TELLER.DENOMINATION)
            IF Y.REG.DENO THEN
                Y.VAL                       = Y.REG.DENO<TT.Config.TellerDenomination.DenValue>
                Y.CANT                      = MONTO.DENOM<1, Y.CON.DENOMINACION>
                Y.CANT.REC                  = MONTO.DENOM.REC<1, Y.CON.DENOMINACION>
                Y.MONTO.DEN.REC             = Y.VAL * Y.CANT.REC
                Y.MONTO.DEN                 = Y.VAL * Y.CANT
                Y.MONTO.TOTAL               = Y.MONTO.TOTAL + Y.MONTO.DEN
                Y.MONTO.TOTAL.REC           = Y.MONTO.TOTAL.REC + Y.MONTO.DEN.REC
                Y.DENOM<Y.CON.DENOMINACION> = Y.DEN.TMP
                IF Y.CANT EQ "" THEN
                    Y.CANT = 0
                END
                IF Y.CANT.REC EQ "" THEN
                    Y.CANT.REC = 0
                END
                Y.UNIDAD<Y.CON.DENOMINACION>        = Y.CANT
                Y.UNIDAD.REC<Y.CON.DENOMINACION>    = Y.CANT.REC
            END
        NEXT Y.CON.DENOMINACION
        IF (PGM.VERSION EQ ",RECEPCION.BOVEDA") OR (PGM.VERSION EQ ",TRAMITE.CONCENTRACION")  THEN
            Y.MONTO.TOTAL = Y.MONTO.TOTAL.REC
            Y.UNIDAD = Y.UNIDAD.REC
        END
        GOSUB CARGA.DATA
    NEXT Y.CONT.MONEDAS

RETURN
************
LEE.ARCHIVO:
************
    YLD.NO = ''
    YLD.ID = ''
    SELECT.CMD  = "SELECT ":FN.TELLER.DENOMINATION:" WITH @ID LIKE ":DQUOTE(SQUOTE(Y.MONEDA):"..."):" BY-DSND VALUE"  ;  * ITSS - SANGAVI - Added DQUOTE / SQUOTE
    EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
    Y.NUM.DENOMINACION  = YLD.NO
    Y.ID.DENOMINACION   = YLD.ID

RETURN
***********
CARGA.DATA:
***********
    IF LINK.DATA EQ "" OR LINK.DATA EQ 0 THEN
        LINK.DATA    = EB.SystemTables.getApplication():EB.SystemTables.getPgmVersion():@FM:EB.SystemTables.getVFunction():@FM:EB.SystemTables.getIdNew()
        LINK.DATA<5> = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Referencia)
        LINK.DATA<6> = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.CtaNostro)
        LINK.DATA<7> = EB.SystemTables.getIdNew()
        LINK.DATA<8> = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Solicitante)
        LINK.DATA<9> += 1
        Y.IDX = LINK.DATA<9> * 10
        LINK.DATA<Y.IDX>    = Y.MONEDA
        LINK.DATA<Y.IDX+1>  = Y.MONTO.TOTAL
        LINK.DATA<Y.IDX+2>  = Y.CON.DENOMINACION
        CONVERT @FM TO "|" IN Y.DENOM
        CONVERT @FM TO "|" IN Y.UNIDAD
        LINK.DATA<Y.IDX+3> = Y.DENOM
        LINK.DATA<Y.IDX+4> = Y.UNIDAD
        Y.MONTO.TOTAL = 0
        ARREGLO.AVIABLE = ''
        ARREGLO.AVIABLE = LINK.DATA
        AbcTeller.setarregloAviable(ARREGLO.AVIABLE)
    END

RETURN
****************
LIGA.TELLER.TXN:
****************
    IF PGM.VERSION EQ ",TRAMITE.BOVEDA" THEN
*AUTORIZACION DE BOVEDA PRINCIPAL DOTACIONES****
        EB.API.SetNextTask('TELLER,ABC.2BR.EM.TILLDOTACION.BOV I F3')
    END ELSE
        IF PGM.VERSION EQ ",RECEPCION.BOVEDA" THEN
*RECEPCION EN BOVEDA LOCAL DE DOTACION
            EB.API.SetNextTask('TELLER,ABC.2BR.EM.TILLCONCEN.BOV I F3')
        END ELSE
            IF PGM.VERSION EQ ",CONCENTRACION.BOVEDA" THEN
*CAPTURA CONCENTRACION EN BOVEDA DE SUCURSAL
                EB.API.SetNextTask('TELLER,ABC.2BR.EM.TILLDOTACION.BOV.INT I F3')
            END ELSE
                IF PGM.VERSION EQ ",TRAMITE.CONCENTRACION" THEN
*RECEPCION CONCENTRACION EN BOVEDA PRINCIPAL
                    EB.API.SetNextTask('TELLER,ABC.2BR.EM.TILLCONCEN.1.BOV I F3')
                END
            END
        END
    END

RETURN
***********
END



