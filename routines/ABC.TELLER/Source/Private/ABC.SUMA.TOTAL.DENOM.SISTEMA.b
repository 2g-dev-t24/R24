* @ValidationCode : MjotODQ0MjQ5NTAxOkNwMTI1MjoxNzY0NzcwNzExMTU5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Dec 2025 11:05:11
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
*-----------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.SUMA.TOTAL.DENOM.SISTEMA
* ======================================================================
* Nombre de Programa : ABC.SUMA.TOTAL.DENOM.SISTEMA
* Parametros         :
* Objetivo           : Actualiza el total de denominaci�nes en f�sico y la diferencia con loq ue tiene el sistema
* Requerimiento      : CORE-1305 Generar alertas para cuando se exceda el l�mite de efectivo y cuando se hacen arqueos
* Desarrollador      : CAST - FyG-Solutions
* Compania           : ABC Capital
* Fecha Creacion     :
* Modificaciones     :
* ======================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Config
    $USING EB.Display
    $USING EB.ErrorProcessing
    $USING AbcTable

    GOSUB INICIA
    GOSUB ABRE.ARCHIVOS
    GOSUB PROCESO

RETURN

*----------
INICIA:
*----------
    COMI    = EB.SystemTables.getComi()
    IF COMI EQ "" THEN
        EB.SystemTables.setComi(0)
    END

RETURN
*----------
*----------
ABRE.ARCHIVOS:
*----------
    FN.TELLER.DENOMINATION = "F.TELLER.DENOMINATION"
    F.TELLER.DENOMINATION = ""
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION, F.TELLER.DENOMINATION)

RETURN
*----------
*----------
PROCESO:
*----------
    TT.ARQ.DENOM    = EB.SystemTables.getRNew(AbcTable.AbcTtArqueo.Denom)
    TT.CANT.FIS     = EB.SystemTables.getRNew(AbcTable.AbcTtArqueo.CantidadFis)
    Y.NO.DENOM      = DCOUNT(TT.ARQ.DENOM,@VM)
    AV              = EB.SystemTables.getAv()
    FOR Y.AA=1 TO Y.NO.DENOM
        IF Y.AA EQ AV THEN
            Y.CANTIDAD = EB.SystemTables.getComi()
        END ELSE
            Y.CANTIDAD = TT.CANT.FIS<1,Y.AA>
        END
        Y.DENOM = TT.ARQ.DENOM<1,Y.AA>
        R.TELLER.DENOMINATION=""
        EB.DataAccess.FRead(FN.TELLER.DENOMINATION,Y.DENOM,R.TELLER.DENOMINATION,F.TELLER.DENOMINATION,ERR.TELLER.DENOMINATION)
        IF R.TELLER.DENOMINATION THEN
            Y.VALOR = R.TELLER.DENOMINATION<TT.Config.TellerDenomination.DenValue>
            Y.TOTAL.X.DENOM = Y.CANTIDAD * Y.VALOR
        END
        Y.TOTAL += Y.TOTAL.X.DENOM
    NEXT Y.AA
    
    EB.SystemTables.setRNew(AbcTable.AbcTtArqueo.TotalFis, Y.TOTAL)
    Y.TOTAL.SISTEMA = EB.SystemTables.getRNew(AbcTable.AbcTtArqueo.Total)
    Y.TOTAL.SIS.TOTAL = Y.TOTAL.SISTEMA - Y.TOTAL
    EB.SystemTables.setRNew(AbcTable.AbcTtArqueo.Diferencia, Y.TOTAL.SIS.TOTAL)
    EB.Display.RebuildScreen()

RETURN
*----------

END
