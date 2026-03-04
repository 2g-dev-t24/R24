* @ValidationCode : MjotNDYyNzkwNzg4OkNwMTI1MjoxNzYwNzExMzc2NDY5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Oct 2025 11:29:36
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

SUBROUTINE ABC.NEW.GET.GAT(Y.FECHA.INFLACION,TASA.BRUTA,PLAZO,TIPO,GAT.NOMINAL,GAT.REAL)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*       Rutina:      ABC.NEW.GET.GAT
*       Req:         Calcula GAT REAL y GAT NOMINAL
*       Banco:       ABCCAPITAL
*       Autor:       CRM
*       Fecha:       25 Agosto 2016
*       Tipo:        ROUTINE MULTITHREAD
*       Descripcion: Esta Rutina es una copia de la original ABC.GET.GAT
*                    Se le incluyo el Parametro ID INFLACION para no ejecutar el SELECT
*                    a la Tabla de 'F.ABC.CAPTURA.INFLACION' para el Estado de Cuenta
*=============================================================================
*---------------------------------------------------------------------------
* DESCRIPCION: RUTINA CALCULA EL GAT REAL Y GAT NOMINAL
* FECHA:       JULIO 2015
* AUTOR:       MIREYA RESENDIZ
*---------------------------------------------------------------------------
*--- TIPO = 1 PAGARE
*             GAT.NOMINAL = ((1+(TASA.BRUTA*PLAZO/360)^(360/PLAZO))-1
*--- TIPO = 2 Deposito de CD con Interes Fijo
*             GAT.NOMINAL = ((1+(TASA.BRUTA/13))^(13))-1
*--- TIPO = 3 Deposito de CD con Int Revisable/Depositos de CD con Tasas Variables
*             GAT.NOMINAL = ((1+(TASA.BRUTA/13))^(13))-1
*--- TIPO = 0 CUENTA REMUNERADA
*             GAT.NOMINAL = ((1+(TASA.BRUTA/365))^(365))-1
*
*             GAT.REAL = ((1+GAT.NOMINAL)/(1+TASA.INFLACION))-1
*
*---------------------------------------------------------------------------
* FECHA:       AGOSTO 2016
* AUTOR:       CESAR MIRANDA (FYG)
*
*      CAMBIO EN EL TRATADO DE LOS DECIMALES PARA LOS C�LCULOS Y EN
*      FORMATO DE LOS DECIMALES PARA SU IMPRESION
*----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AA.Framework
    $USING AC.AccountOpening
    
    GOSUB INICIALIZA
    GOSUB OPEN.FILES
    GOSUB SACA.INFLACION
    GOSUB CALCULA.GAT.NOMINAL
    GOSUB CALCULA.GAT.REAL

RETURN

*----------
INICIALIZA:
*----------

    BASE           = '360'
    YDIAS.3        = '13'
    YDIAS.0        = '365'
    ID.INFLACION   = ''
    R.INFLACION    = ''
    ERR.INFLACION  = ''
    TASA.INFLACION = ''

RETURN

*----------
OPEN.FILES:
*----------

    FN.INFLACION = 'F.ABC.CAPTURA.INFLACION'
    F.INFLACION  = ''
    EB.DataAccess.Opf(FN.INFLACION,F.INFLACION)

RETURN

*--------------
SACA.INFLACION:
*--------------

    ID.INFLACION = Y.FECHA.INFLACION
    IF ID.INFLACION NE '' THEN
        EB.DataAccess.FRead(FN.INFLACION,ID.INFLACION,R.INFLACION,F.INFLACION,ERR.INFLACION)
        IF R.INFLACION NE '' THEN
            TASA.INFLACION = R.INFLACION<AbcTable.AbcCapturaInflacion.Inflacion>
            DISPLAY 'TASA INFLACION = ':TASA.INFLACION
        END
    END

RETURN

********************
CALCULA.GAT.NOMINAL:
********************

    GAT.NOM     = ''; GAT.RE   = ''; YDIAS    = ''; YDIAS.2 = '';
    GAT.NOMINAL = ''; GAT.REAL = ''; TASA.BRT = '';
    GAT.NOM.CAL = ''

    IF TIPO EQ 1 THEN
        TASA.BRT = TASA.BRUTA/100
        YDIAS  = (PLAZO/BASE)
        YDIAS.2 = (BASE/PLAZO)
        GAT.NOM = ((1+(TASA.BRT*YDIAS))^YDIAS.2)-1
    END ELSE
        IF TIPO GE 2 THEN
            TASA.BRT = TASA.BRUTA/100
            GAT.NOM = ((1+(TASA.BRT/YDIAS.3))^YDIAS.3)-1
        END ELSE
            IF TIPO EQ 0 THEN
                TASA.BRT = TASA.BRUTA/100
                GAT.NOM = ((1+(TASA.BRT/YDIAS.0))^YDIAS.0)-1
            END
        END
    END

    GAT.NOM.CAL = GAT.NOM
    GAT.NOM = GAT.NOM * 100
    GAT.NOMINAL = FMT((DROUND(GAT.NOM,2)), 'R2')

RETURN

*----------------
CALCULA.GAT.REAL:
*----------------

    DECIMALES = ''; GAT.NOM = ''; TASA.INF = '';

    GAT.NOM = GAT.NOM.CAL + 1
    TASA.INF = (TASA.INFLACION/100) + 1

    GAT.RE = ((GAT.NOM)/(TASA.INF)) - 1
    GAT.RE = GAT.RE * 100
    GAT.REAL = FMT((DROUND(GAT.RE,2)), 'R2')

RETURN

END

