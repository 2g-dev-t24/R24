*-------------------------------------------------------------------------------------------------
$PACKAGE AbcBi
*-------------------------------------------------------------------------------------------------

    SUBROUTINE ABC.GET.GAT.REIMPRESION(TASA.BRUTA,PLAZO,TIPO,FECHA.INICIO,GAT.NOMINAL,GAT.REAL)

*------------------------------------------------------------------------------------------------
* DESCRIPCION: RUTINA CALCULA EL GAT REAL Y GAT NOMINAL, CON LA INFLACION
*              CORREPONDIENTE A SU FECHA DE APERTURA
* AUTOR:       
*------------------------------------------------------------------------------------------------
*TIPO = 1 PAGARE
* GAT.NOMINAL = ((1+(TASA.BRUTA*PLAZO/360)^(360/PLAZO))-1
*TIPO = 2 Deposito de CD con Interes Fijo
* GAT.NOMINAL = ((1+(TASA.BRUTA/13))^(13))-1
*TIPO = 3 Deposito de CD con Int Revisable/Depositos de CD con Tasas Variables
*GAT.NOMINAL = ((1+(TASA.BRUTA/13))^(13))-1
*
*GAT.REAL = ((1+GAT.NOMINAL)/(1+TASA.INFLACION))-1
*
*-----------------------------------------------------------------------------------------------
    
    $USING EB.DataAccess
    $USING AbcTable

    GOSUB INICIALIZA
    GOSUB GET.INFLACION

    RETURN
***********
INICIALIZA:
***********

    FN.INFLACION = 'F.ABC.CAPTURA.INFLACION'; F.INFLACION = ''; EB.DataAccess.Opf(FN.INFLACION,F.INFLACION)
    ID.INFLACION = ''
    ID.INFLACION = FECHA.INICIO[1,6]
    BASE = '360'
    YDIAS.3 = '13'

    RETURN
**************
GET.INFLACION:
**************

    ER.INFLACION = ''; R.INFLACION = ''; TASA.INFLACION = '';
    EB.DataAccess.FRead(FN.INFLACION,ID.INFLACION,R.INFLACION,F.INFLACION,ERR.INFLACION)
    IF R.INFLACION NE '' THEN
        TASA.INFLACION = R.INFLACION<AbcTable.AbcCapturaInflacion.Inflacion>
        GOSUB CALCULA.GAT.NOMINAL
        GOSUB CALCULA.GAT.REAL
    END ELSE
        GOSUB CALCULA.ID
    END

    RETURN
********************
CALCULA.GAT.NOMINAL:
********************

    GAT.NOM = ''; GAT.RE = ''; YDIAS = ''; YDIAS.2 = '';
    PARTE.1 = '';  PARTE.2 = '';  PARTE.3 = '';
    GAT.NOMINAL = '';  GAT.REAL = ''; TASA.BRT = '';
    GAT.NOM.CAL = '';

    IF TIPO EQ 1 THEN
        TASA.BRT = TASA.BRUTA/100
        YDIAS  = (PLAZO/BASE)
        YDIAS.2 = (BASE/PLAZO)
        GAT.NOM = ((1+(TASA.BRT*YDIAS))^YDIAS.2)-1
        GAT.NOM.CAL = GAT.NOM
        GAT.NOM = GAT.NOM * 100
        GAT.NOMINAL =FMT((DROUND(GAT.NOM,2)), 'R2')

    END ELSE
        IF TIPO GE 2 THEN
            TASA.BRT = TASA.BRUTA/100
            GAT.NOM = ((1+(TASA.BRT/YDIAS.3))^YDIAS.3)-1
            GAT.NOM.CAL = GAT.NOM
            GAT.NOM = GAT.NOM * 100
            GAT.NOMINAL =FMT((DROUND(GAT.NOM,2)), 'R2')
        END
    END

    RETURN
*****************
CALCULA.GAT.REAL:
*****************

    PARTE.1 = '';  PARTE.2 = '';  PARTE.3 = ''; GAT.NOM = ''; TASA.INF = '';

    GAT.NOM = GAT.NOM.CAL + 1
    TASA.INF = (TASA.INFLACION/100) + 1
    GAT.RE = ((GAT.NOM)/(TASA.INF)) - 1
    GAT.RE = GAT.RE * 100
    GAT.REAL = FMT((DROUND(GAT.RE,2)), 'R2')

    RETURN
***********
CALCULA.ID:
***********

    MES.INF = '';  ANIO.INF = '';
    MES.INF = ID.INFLACION[5,2]
    ANIO.INF = ID.INFLACION[1,4]
    IF MES.INF EQ '01' THEN
        MES.INF = '12'
        ANIO.INF = ANIO.INF - 1
    END ELSE
        MES.INF = MES.INF -1
        IF MES.INF LT '10' THEN
            MES.INF = FMT(MES.INF, "R%2")
        END
    END

    ID.INFLACION = '';
    ID.INFLACION = ANIO.INF:MES.INF
    IF ID.INFLACION EQ '201212' THEN
        GAT.REAL = 'NA'
        GAT.NOMINAL = 'NA'
    END ELSE
        GOSUB GET.INFLACION
    END

    RETURN
**********

END
