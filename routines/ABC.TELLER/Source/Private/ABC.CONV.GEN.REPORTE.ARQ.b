* @ValidationCode : MjoxNDY4MTk4Njk1OkNwMTI1MjoxNzY1MzA5MjIwNjc1Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Dec 2025 16:40:20
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
SUBROUTINE ABC.CONV.GEN.REPORTE.ARQ

    $USING EB.DataAccess
    $USING ST.Config
    $USING AbcTable
    $USING ABC.BP
    $USING EB.Reports
* ======================================================================
* Nombre de Programa : ABC.GET.TELLER.ID
* Parametros         :
* Objetivo           : Obtiene el TELLER.ID del usaurio
* Requerimiento      : CORE-1305 Generar alertas para cuando se exceda el l�mite de efectivo y cuando se hacen arqueos
* Desarrollador      :
* Compania           :
* Fecha Creacion     :
* Modificaciones     :
* ======================================================================


    GOSUB INICIA
    GOSUB ABRE.ARCHIVOS
    GOSUB PROCESO

RETURN
*-----------------------------------------------------------------------------------------------------------
*------------------------------
INICIA:
*------------------------------

    Y.RAZON.SOCIAL.ARG = "SHORT" ; Y.RAZON.SOCIAL = ''
    ABC.BP.AbcGetRazonSocial(Y.RAZON.SOCIAL.ARG)
    Y.RAZON.SOCIAL  = Y.RAZON.SOCIAL.ARG
    
    R.RECORD        = EB.Reports.getRRecord()
    
    Y.USER.DAO      = R.RECORD<AbcTable.AbcTtArqueo.DeptCode>
    Y.FECHA.HORA    = R.RECORD<AbcTable.AbcTtArqueo.DateTime>
    Y.TELLER.NO     = R.RECORD<AbcTable.AbcTtArqueo.Cajero>
    
    Y.ARQ.DENOM     = R.RECORD<AbcTable.AbcTtArqueo.Denom>
    Y.ARQ.CANT.FIS  = R.RECORD<AbcTable.AbcTtArqueo.CantidadFis>
    
    Y.ARQ.TOTAL     = R.RECORD<AbcTable.AbcTtArqueo.Total>
    Y.ARQ.TOTAL.FIS = R.RECORD<AbcTable.AbcTtArqueo.TotalFis>
    Y.ARQ.DIF       = R.RECORD<AbcTable.AbcTtArqueo.Diferencia>

RETURN
*-----------------------------------------------------------------------------------------------------------
*------------------------------
ABRE.ARCHIVOS:
*------------------------------
    FN.DAO = 'F.DEPT.ACCT.OFFICER'
    F.DAO = ''
    EB.DataAccess.Opf(FN.DAO,F.DAO)

RETURN
*-----------------------------------------------------------------------------------------------------------
*------------------------------
PROCESO:
*------------------------------
    GOSUB OBTEN.SUCURSAL
    GOSUB OBTEN.FECHA.HORA
    GOSUB OBTEN.BOVEDA.CAJA

	R.RECORD	  = ''
    R.RECORD<1,1> = UPCASE(Y.RAZON.SOCIAL)
    R.RECORD<1,2> = 'INSTITUCION DE BANCA MULTIPLE'
    R.RECORD<1,3> = 'Formato de  Arqueo de Efectivo'
    R.RECORD<1,4> = 'Sucursal: ':Y.USER.DAO:' ':Y.SUCURSAL
    R.RECORD<1,5> = 'Fecha: ':Y.FECHA
    R.RECORD<1,6> = 'Hora: ':Y.HORA

    R.RECORD<2,1> = ''
    R.RECORD<2,2> = ''
    R.RECORD<2,3> = ''
    R.RECORD<2,4> = ''
    R.RECORD<2,5> = ''
    R.RECORD<2,6> = ''
    R.RECORD<2,7> = ''
    R.RECORD<2,8> = Y.BOVEDA.CAJA:' ':Y.TELLER.NO
    R.RECORD<2,9> = 'Billetes'
    R.RECORD<2,10> = Y.ARQ.DENOM<1,1>
    R.RECORD<2,11> = Y.ARQ.DENOM<1,2>
    R.RECORD<2,12> = Y.ARQ.DENOM<1,3>
    R.RECORD<2,13> = Y.ARQ.DENOM<1,4>
    R.RECORD<2,14> = Y.ARQ.DENOM<1,5>
    R.RECORD<2,15> = Y.ARQ.DENOM<1,6>
    R.RECORD<2,16> = ''
    R.RECORD<2,17> = ''
    R.RECORD<2,18> = 'Monedas'
    R.RECORD<2,19> = Y.ARQ.DENOM<1,7>
    R.RECORD<2,20> = Y.ARQ.DENOM<1,8>
    R.RECORD<2,21> = Y.ARQ.DENOM<1,9>
    R.RECORD<2,22> = Y.ARQ.DENOM<1,10>
    R.RECORD<2,23> = Y.ARQ.DENOM<1,11>
    R.RECORD<2,24> = Y.ARQ.DENOM<1,12>
    R.RECORD<2,25> = Y.ARQ.DENOM<1,13>
    R.RECORD<2,26> = Y.ARQ.DENOM<1,14>
    R.RECORD<2,27> = ''
    R.RECORD<2,28> = ''

    R.RECORD<3,1> = ''
    R.RECORD<3,2> = ''
    R.RECORD<3,3> = ''
    R.RECORD<3,4> = ''
    R.RECORD<3,5> = ''
    R.RECORD<3,6> = ''
    R.RECORD<3,7> = ''
    R.RECORD<3,8> = ''
    R.RECORD<3,9> = 'Cantidad'
    R.RECORD<3,10> = Y.ARQ.CANT.FIS<1,1>
    R.RECORD<3,11> = Y.ARQ.CANT.FIS<1,2>
    R.RECORD<3,12> = Y.ARQ.CANT.FIS<1,3>
    R.RECORD<3,13> = Y.ARQ.CANT.FIS<1,4>
    R.RECORD<3,14> = Y.ARQ.CANT.FIS<1,5>
    R.RECORD<3,15> = Y.ARQ.CANT.FIS<1,6>
    R.RECORD<3,16> = '---------------'
    R.RECORD<3,17> = 'Total Billetes:'
    R.RECORD<3,18> = 'Cantidad'
    R.RECORD<3,19> = Y.ARQ.CANT.FIS<1,7>
    R.RECORD<3,20> = Y.ARQ.CANT.FIS<1,8>
    R.RECORD<3,21> = Y.ARQ.CANT.FIS<1,9>
    R.RECORD<3,22> = Y.ARQ.CANT.FIS<1,10>
    R.RECORD<3,23> = Y.ARQ.CANT.FIS<1,11>
    R.RECORD<3,24> = Y.ARQ.CANT.FIS<1,12>
    R.RECORD<3,25> = Y.ARQ.CANT.FIS<1,13>
    R.RECORD<3,26> = Y.ARQ.CANT.FIS<1,14>
    R.RECORD<3,27> = '---------------'
    R.RECORD<3,28> = 'Total Monedas:'
    R.RECORD<3,29> = 'Total Efectivo en ':Y.BOVEDA.CAJA
    R.RECORD<3,30> = 'Total en ':Y.BOVEDA.CAJA:' T24:'
    R.RECORD<3,31> = 'Diferencia:'

    R.RECORD<4,1> = ''
    R.RECORD<4,2> = ''
    R.RECORD<4,3> = ''
    R.RECORD<4,4> = ''
    R.RECORD<4,5> = ''
    R.RECORD<4,6> = ''
    R.RECORD<4,7> = ''
    R.RECORD<4,8> = ''
    R.RECORD<4,9> = 'Importe'

    Y.TOTAL = FIELD(Y.ARQ.DENOM<1,1>,'MXN',2)
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,1>
    Y.TOTAL.BILLETES += Y.TOTAL
    R.RECORD<4,10> = '$': Y.TOTAL

    Y.TOTAL = FIELD(Y.ARQ.DENOM<1,2>,'MXN',2)
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,2>
    Y.TOTAL.BILLETES += Y.TOTAL
    R.RECORD<4,11> = '$':Y.TOTAL

    Y.TOTAL = FIELD(Y.ARQ.DENOM<1,3>,'MXN',2)
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,3>
    Y.TOTAL.BILLETES += Y.TOTAL
    R.RECORD<4,12> = '$':Y.TOTAL

    Y.TOTAL = FIELD(Y.ARQ.DENOM<1,4>,'MXN',2)
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,4>
    Y.TOTAL.BILLETES += Y.TOTAL
    R.RECORD<4,13> = '$':Y.TOTAL

    Y.TOTAL = FIELD(Y.ARQ.DENOM<1,5>,'MXN',2)
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,5>
    Y.TOTAL.BILLETES += Y.TOTAL
    R.RECORD<4,14> = '$':Y.TOTAL

    Y.TOTAL = FIELD(Y.ARQ.DENOM<1,6>,'MXN',2)
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,6>
    Y.TOTAL.BILLETES += Y.TOTAL
    R.RECORD<4,15> = '$':Y.TOTAL
    R.RECORD<4,16> = '---------------'
    R.RECORD<4,17> = '$':Y.TOTAL.BILLETES
    R.RECORD<4,18> = 'Importe'

    Y.TOTAL = EREPLACE(FIELD(Y.ARQ.DENOM<1,7>,'MXN',2),',','.')
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,7>
    Y.TOTAL.MONEDAS += Y.TOTAL
    R.RECORD<4,19> = '$': Y.TOTAL

    Y.TOTAL = EREPLACE(FIELD(Y.ARQ.DENOM<1,8>,'MXN',2),',','.')
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,8>
    Y.TOTAL.MONEDAS += Y.TOTAL
    R.RECORD<4,20> = '$':Y.TOTAL

    Y.TOTAL = EREPLACE(FIELD(Y.ARQ.DENOM<1,9>,'MXN',2),',','.')
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,9>
    Y.TOTAL.MONEDAS += Y.TOTAL
    R.RECORD<4,21> = '$':Y.TOTAL

    Y.TOTAL = EREPLACE(FIELD(Y.ARQ.DENOM<1,10>,'MXN',2),',','.')
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,10>
    Y.TOTAL.MONEDAS += Y.TOTAL
    R.RECORD<4,22> = '$':Y.TOTAL

    Y.TOTAL = EREPLACE(FIELD(Y.ARQ.DENOM<1,11>,'MXN',2),',','.')
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,11>
    Y.TOTAL.MONEDAS += Y.TOTAL
    R.RECORD<4,23> = '$':Y.TOTAL

    Y.TOTAL = EREPLACE(FIELD(Y.ARQ.DENOM<1,12>,'MXN',2),',','.')
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,12>
    Y.TOTAL.MONEDAS += Y.TOTAL
    R.RECORD<4,24> = '$':Y.TOTAL

    Y.TOTAL = EREPLACE(FIELD(Y.ARQ.DENOM<1,13>,'MXN',2),',','.')
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,13>
    Y.TOTAL.MONEDAS += Y.TOTAL
    R.RECORD<4,25> = '$':Y.TOTAL

    Y.TOTAL = EREPLACE(FIELD(Y.ARQ.DENOM<1,14>,'MXN',2),',','.')
    Y.TOTAL = Y.TOTAL * Y.ARQ.CANT.FIS<1,14>
    Y.TOTAL.MONEDAS += Y.TOTAL
    R.RECORD<4,26> = '$':Y.TOTAL


    R.RECORD<4,27> = '---------------'
    R.RECORD<4,28> = '$':Y.TOTAL.MONEDAS

    R.RECORD<4,29> = '$':Y.ARQ.TOTAL
    R.RECORD<4,30> = '$':Y.ARQ.TOTAL.FIS
    R.RECORD<4,31> = '$':Y.ARQ.DIF

    VM.COUNT = 31

    EB.Reports.setRRecord(R.RECORD)


RETURN
*-----------------------------------------------------------------------------------------------------------
*------------------------------
OBTEN.SUCURSAL:
*------------------------------
*    Y.USER.DAO  = R.RECORD<AbcTable.AbcTtArqueo.DeptCode>
    Y.USER.DAO  = LEFT(Y.USER.DAO,5)
    R.DAO=""
    EB.DataAccess.FRead(FN.DAO,Y.USER.DAO,R.DAO,F.DAO,Y.ERR.DAO)
    IF R.DAO THEN
        Y.SUCURSAL = R.DAO<ST.Config.DeptAcctOfficer.EbDaoName>
    END

RETURN
*-----------------------------------------------------------------------------------------------------------
*------------------------------
OBTEN.FECHA.HORA:
*------------------------------
*    Y.FECHA.HORA = R.RECORD<AbcTable.AbcTtArqueo.DateTime>
    Y.FECHA = Y.FECHA.HORA[5,2]:'/':Y.FECHA.HORA[3,2]:'/':'20':Y.FECHA.HORA[1,2]
    Y.HORA = Y.FECHA.HORA[7,2]:':':Y.FECHA.HORA[9,2]

RETURN
*-----------------------------------------------------------------------------------------------------------
*------------------------------
OBTEN.BOVEDA.CAJA:
*------------------------------
*    Y.TELLER.NO = R.RECORD<AbcTable.AbcTtArqueo.Cajero>
    IF Y.TELLER.NO[1,1] EQ '9' THEN
        Y.BOVEDA.CAJA = 'Boveda'
    END ELSE
        Y.BOVEDA.CAJA = 'Caja'
    END

RETURN
*-----------------------------------------------------------------------------------------------------------
END
