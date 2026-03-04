* @ValidationCode : MjotMTUxNTcxODE2OkNwMTI1MjoxNzY4NjIxMzAyMDc1OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Jan 2026 21:41:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcRegulatorios
SUBROUTINE ABC.OEMN.GENERA.SECC6
*-----------------------------------------------------------------------------
*===============================================
* Objetivo:             Rutina que extrae el saldo en b�vedas.
* Desarrollador:        Isaias Rodriguez Ventura
* Compania:    FYG Solutions
* Fecha Creacion:       2018/04/03
*===============================================*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING TT.Stock
    $USING TT.Config
    $USING AbcTable
    
    GOSUB INICIO
    GOSUB OBTIENE.PARAMETROS
    GOSUB PROCESO
    GOSUB FINALIZA

RETURN

*******
INICIO:
*******

    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    F.TELLER.PARAMETER = ''
    EB.DataAccess.Opf(FN.TELLER.PARAMETER, F.TELLER.PARAMETER)

    FN.TT.STOCK.CONTROL = 'F.TT.STOCK.CONTROL'
    F.TT.STOCK.CONTROL = ''
    EB.DataAccess.Opf(FN.TT.STOCK.CONTROL, F.TT.STOCK.CONTROL)

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM  = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    SEP = ','

RETURN

*******************
OBTIENE.PARAMETROS:
******************
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,'ABC.OEMN.6',R.DATOS.GP,F.ABC.GENERAL.PARAM,ERR.PARAM)
    Y.NOMB.PARAMETROS = R.DATOS.GP<AbcTable.AbcGeneralParam.NombParametro>

    FIND 'ID.TT.PARAM' IN Y.NOMB.PARAMETROS SETTING AA, VA, SA THEN
        Y.ID.TT.PARAM = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VA>
    END
    FIND 'ID.STOCK.CONTROL' IN Y.NOMB.PARAMETROS SETTING AB, VB, SB THEN
        Y.ID.STOCK.CONTROL = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VB>
    END
    FIND 'INSTITUCION' IN Y.NOMB.PARAMETROS SETTING AC, VC, SC THEN
        Y.INSTITUCION = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VC>
    END
    FIND 'TITULOS' IN Y.NOMB.PARAMETROS SETTING AD, VD, SD THEN
        Y.TITULOS = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VD>
    END
    FIND 'RUTA.ARCHIVO' IN Y.NOMB.PARAMETROS SETTING AE, VE, SE THEN
        Y.RUTA.ARCHIVO = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VE>
    END
    FIND 'NOMBRE.ARCHIVO' IN Y.NOMB.PARAMETROS SETTING AF, VF, SF THEN
        Y.NOMBRE.ARCHIVO = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VF>
    END

RETURN
********
PROCESO:
********

    EB.DataAccess.FRead(FN.TELLER.PARAMETER,Y.ID.TT.PARAM,REC.TELLER.PARAMETER,F.TELLER.PARAMETER,ERR.TP)
    Y.REC.VAULT.IDS = REC.TELLER.PARAMETER<TT.Config.TellerParameter.ParVaultId>
    Y.REC.VAULT.DESC = REC.TELLER.PARAMETER<TT.Config.TellerParameter.ParVaultDesc>
    CHANGE @VM TO @FM IN Y.REC.VAULT.IDS
    CHANGE @VM TO @FM IN Y.REC.VAULT.DESC
    Y.TOT.BOVEDAS = DCOUNT(Y.REC.VAULT.IDS,FM)

    FOR REC = 1 TO Y.TOT.BOVEDAS
        Y.TIPO.DENO = ''
        Y.TOT.DISPONIBLE = ''
        Y.ID.BOVEDA = ''
        Y.ID.VAULT.DESC = ''
        Y.ID.BOVEDA = Y.REC.VAULT.IDS<REC>
        Y.ID.VAULT.DESC = Y.REC.VAULT.DESC<REC>
        Y.DESC.BOVEDA = FIELD(Y.ID.VAULT.DESC,'-',2)
        IF Y.ID.BOVEDA EQ '9999' THEN
            Y.TIPO.MD = 2
        END ELSE
            Y.TIPO.MD = 1
        END
        EB.DataAccess.FRead(FN.TT.STOCK.CONTROL,Y.ID.STOCK.CONTROL:Y.ID.BOVEDA,REC.TT.STOCK.CONTROL,F.TT.STOCK.CONTROL,ERR.TSC)

        Y.DENOMINATIONS = REC.TT.STOCK.CONTROL<TT.Stock.StockControl.ScDenomination>
        Y.ORDER.DENOMINATIONS = Y.DENOMINATIONS
        Y.QUANTITY = REC.TT.STOCK.CONTROL<TT.Stock.StockControl.ScQuantity>
        CHANGE @VM TO @FM IN Y.ORDER.DENOMINATIONS
        CHANGE @VM TO @FM IN Y.QUANTITY
        CHANGE 'MXN' TO '.' IN Y.ORDER.DENOMINATIONS
        CHANGE '0,' TO '0.' IN Y.ORDER.DENOMINATIONS
        AbcRegulatorios.AbcSortd(Y.ORDER.DENOMINATIONS, Y.DENOMINATIONS.ORDER, "AR")
        CHANGE '.0.' TO 'MXN0,' IN Y.DENOMINATIONS.ORDER
        CHANGE '.' TO 'MXN' IN Y.DENOMINATIONS.ORDER
        TODAY   = EB.SystemTables.getToday()
        Y.TOT.DENOMINATION = DCOUNT(Y.ORDER.DENOMINATIONS,FM)
        FOR REC.DENO = Y.TOT.DENOMINATION TO 1 STEP -1
            Y.TIPO.DENO =  ''
            Y.AVAILABLE = ''
            Y.TIPO.DENO = Y.DENOMINATIONS.ORDER<REC.DENO>
            FIND Y.TIPO.DENO IN Y.DENOMINATIONS SETTING AE, VE, SE THEN
                Y.AVAILABLE = Y.QUANTITY<VE>
            END
            IF Y.TIPO.DENO NE 'MXN0,01' THEN
                GOSUB VERIFICA.DENOMINACION
                Y.DATOS<-1>= Y.INSTITUCION:SEP:TODAY:SEP:Y.DESC.BOVEDA:SEP:Y.TIPO.MD:SEP:Y.DENOMINACION:SEP:Y.TOT.DISPONIBLE
            END
        NEXT REC.DENO

    NEXT REC

RETURN

**********************
VERIFICA.DENOMINACION:
**********************
    Y.DENOMINACION = ''
    Y.TOT.DISPONIBLE = ''

    BEGIN CASE
        CASE Y.TIPO.DENO = 'MXN1000'
            Y.DENOMINACION = '1000B'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * 1000
        CASE Y.TIPO.DENO = 'MXN500'
            Y.DENOMINACION = '500B'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * 500
        CASE Y.TIPO.DENO = 'MXN200'
            Y.DENOMINACION = '200B'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * 200
        CASE Y.TIPO.DENO = 'MXN100'
            Y.DENOMINACION = '100B'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * 100
        CASE Y.TIPO.DENO = 'MXN50'
            Y.DENOMINACION = '50B'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * 50
        CASE Y.TIPO.DENO = 'MXN20'
            Y.DENOMINACION = '20B'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * 20
        CASE Y.TIPO.DENO = 'MXN10'
            Y.DENOMINACION = '10M'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * 10
        CASE Y.TIPO.DENO = 'MXN5'
            Y.DENOMINACION = '5M'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * 5
        CASE Y.TIPO.DENO = 'MXN2'
            Y.DENOMINACION = '2M'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * 2
        CASE Y.TIPO.DENO = 'MXN1'
            Y.DENOMINACION = '1M'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * 1
        CASE Y.TIPO.DENO = 'MXN0,50'
            Y.DENOMINACION = '50CM'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * '.50'
        CASE Y.TIPO.DENO = 'MXN0,20'
            Y.DENOMINACION = '20CM'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * '.20'
        CASE Y.TIPO.DENO = 'MXN0,10'
            Y.DENOMINACION = '10CM'
            Y.TOT.DISPONIBLE = Y.AVAILABLE * '.10'
    END CASE
    Y.TOT.DISPONIBLE  = FMT(Y.TOT.DISPONIBLE, "R2#10")

RETURN

*********
FINALIZA:
*********
    IF Y.DATOS NE '' THEN
        Y.DATOS = Y.TITULOS:FM:Y.DATOS
        OPEN '',Y.RUTA.ARCHIVO TO Y.ARCHIVO ELSE NULL
        Y.NOMBRE.COMPLETO = TODAY:".":Y.NOMBRE.ARCHIVO

        WRITE Y.DATOS TO Y.ARCHIVO,Y.NOMBRE.COMPLETO
        CLOSE Y.ARCHIVO
    END
RETURN

END

