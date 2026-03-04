* @ValidationCode : MjotMTQ4ODkwNjEwNDpDcDEyNTI6MTc1OTc4NTQ0NDM0OTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Oct 2025 18:17:24
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
$PACKAGE AbcCob

SUBROUTINE ABC.GEN.IPAB.CTA.BEN

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Updates
    $USING ST.Customer
    $USING ST.Config
    $USING AbcTable


    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*---------------
INITIALISE:
*---------------

    Y.SEP = '|'

RETURN

*---------------
OPENFILES:
*---------------

    FN.ABC.IPAB.CTA.BEN = 'F.ABC.IPAB.CTA.BEN'
    F.ABC.IPAB.CTA.BEN = ''
    EB.DataAccess.Opf(FN.ABC.IPAB.CTA.BEN,F.ABC.IPAB.CTA.BEN)

    FN.ABC.IPAB.CLI.CTA.BEN = 'F.ABC.IPAB.CLI.CTA.BEN'
    F.ABC.IPAB.CLI.CTA.BEN = ''
    EB.DataAccess.Opf(FN.ABC.IPAB.CLI.CTA.BEN,F.ABC.IPAB.CLI.CTA.BEN)

    FN.ABC.FILE.REPORT.TMP = 'F.ABC.FILE.REPORT.TMP'
    F.ABC.FILE.REPORT.TMP = ''
    EB.DataAccess.Opf(FN.ABC.FILE.REPORT.TMP,F.ABC.FILE.REPORT.TMP)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    FN.COUNTRY = 'F.COUNTRY'
    F.COUNTRY = ''
    EB.DataAccess.Opf(FN.COUNTRY,F.COUNTRY)

    FN.VPM.COLONIA = 'F.ABC.COLONIA'
    F.VPM.COLONIA = ''
    EB.DataAccess.Opf(FN.VPM.COLONIA,F.VPM.COLONIA)

    FN.VPM.ESTADO = 'F.ABC.ESTADO'
    F.VPM.ESTADO = ''
    EB.DataAccess.Opf(FN.VPM.ESTADO,F.VPM.ESTADO)

    FN.VPM.MUNICIPIO = 'F.ABC.MUNICIPIO'
    F.VPM.MUNICIPIO = ''
    EB.DataAccess.Opf(FN.VPM.MUNICIPIO,F.VPM.MUNICIPIO)

RETURN

*---------------
LIMPIA.VARIABLES:
*---------------

    Y.SALDO.DISPONIBLE = ''
    Y.INTERESES = ''
    Y.SALDO.RETENIDO = ''
    Y.SALDO.NETO = ''
    Y.FECHA.CORTE = ''
    Y.TASA = ''
    Y.SALDO.PROMEDIO = ''
    Y.PERSONALIDAD = ''
    Y.NOMBRE = ''
    Y.APE.PATERNO = ''
    Y.APE.MATERNO = ''
    Y.CALLE.NUMERO = ''
    Y.COLONIA = ''
    Y.MUNICIPIO = ''
    Y.COD.POS = ''
    Y.PAIS = ''
    Y.ESTADO = ''
    Y.RFC = ''
    Y.CURP = ''
    Y.TELEFONO = ''
    Y.EMAIL = ''
    Y.FEC.NACIMIENTO = ''
    Y.SALDO.COMPENSADO = ''

RETURN

*---------------
PROCESS:
*---------------

    Y.CMD ='SSELECT ' :  FN.ABC.IPAB.CTA.BEN
    Y.LIST=''; Y.NO=''; Y.CO=''
    EB.DataAccess.Readlist(Y.CMD,Y.LIST,'',Y.NO,Y.CO)

    FOR CT = 1 TO Y.NO
        GOSUB LIMPIA.VARIABLES
        ID.CUENTA = Y.LIST<CT>
        REC.IPAB.CTA.BEN = ''
        EB.DataAccess.FRead(FN.ABC.IPAB.CTA.BEN,ID.CUENTA,REC.IPAB.CTA.BEN,F.ABC.IPAB.CTA.BEN,YERR.IPAB.CTA.BEN)
        IF REC.IPAB.CTA.BEN THEN
            Y.CLIENTE = REC.IPAB.CTA.BEN<AbcTable.AbcIpabCtaBen.Cliente>
            REC.REPORT.TMP = ID.CUENTA:Y.SEP:'0':Y.SEP:Y.CLIENTE:Y.SEP:'100.00'
            Y.ID.TMP = 'TABLA.3.ACC*':ID.CUENTA

            WRITE REC.REPORT.TMP TO F.ABC.FILE.REPORT.TMP, Y.ID.TMP

            Y.SALDO.DISPONIBLE = REC.IPAB.CTA.BEN<AbcTable.AbcIpabCtaBen.SaldoCuenta>
            Y.INTERESES = REC.IPAB.CTA.BEN<AbcTable.AbcIpabCtaBen.Intereses>
            Y.SALDO.RETENIDO = REC.IPAB.CTA.BEN<AbcTable.AbcIpabCtaBen.RetencionImpuestos>
            Y.SALDO.NETO = REC.IPAB.CTA.BEN<AbcTable.AbcIpabCtaBen.SaldoNeto>
            Y.FECHA.CORTE = REC.IPAB.CTA.BEN<AbcTable.AbcIpabCtaBen.FechaCorte>
            Y.TASA = REC.IPAB.CTA.BEN<AbcTable.AbcIpabCtaBen.Tasa>
            Y.SALDO.PROMEDIO = REC.IPAB.CTA.BEN<AbcTable.AbcIpabCtaBen.SaldoPromedio>
            REC.REPORT.TMP = ID.CUENTA:Y.SEP:'0':Y.SEP:'Articulo 61':Y.SEP:'CI':Y.SEP:'N':Y.SEP:'0':Y.SEP:'10104':Y.SEP
            REC.REPORT.TMP := Y.SALDO.DISPONIBLE:Y.SEP:Y.INTERESES:Y.SEP:Y.SALDO.RETENIDO:Y.SEP:'0':Y.SEP
            REC.REPORT.TMP := Y.SALDO.NETO:Y.SEP:'1':Y.SEP:Y.FECHA.CORTE:Y.SEP:'':Y.SEP:'':Y.SEP:'1':Y.SEP:Y.TASA:Y.SEP
            REC.REPORT.TMP := '':Y.SEP:'':Y.SEP:'':Y.SEP:'':Y.SEP:Y.SALDO.PROMEDIO
            Y.ID.TMP = 'TABLA.2.ACC*':ID.CUENTA

            WRITE REC.REPORT.TMP TO F.ABC.FILE.REPORT.TMP, Y.ID.TMP
        END
    NEXT CT

    Y.CMD ='SSELECT ' :  FN.ABC.IPAB.CLI.CTA.BEN
    Y.LIST=''; Y.NO=''; Y.CO=''
    EB.DataAccess.Readlist(Y.CMD,Y.LIST,'',Y.NO,Y.CO)

    FOR CT = 1 TO Y.NO
        GOSUB LIMPIA.VARIABLES
        ID.CLIENTE = Y.LIST<CT>
        Y.ID.TMP = 'TABLA.1*':ID.CLIENTE
        EB.DataAccess.FRead(FN.ABC.FILE.REPORT.TMP,Y.ID.TMP,REC.ABC.FILE.REPORT.TMP,F.ABC.FILE.REPORT.TMP,YERR.ABC.FILE.REPORT.TMP)
        IF REC.ABC.FILE.REPORT.TMP ELSE
            REC.IPAB.CLI.CTA.BEN = ''
            EB.DataAccess.FRead(FN.ABC.IPAB.CLI.CTA.BEN,ID.CLIENTE,REC.IPAB.CLI.CTA.BEN,F.ABC.IPAB.CLI.CTA.BEN,YERR.IPAB.CLI.CTA.BEN)
            GOSUB OBTIENE.CLI.CTA.BEN
            REC.CUSTOMER = ''
            EB.DataAccess.FRead(FN.CUSTOMER,ID.CLIENTE,REC.CUSTOMER,F.CUSTOMER,YERR.CUSTOMER)
            IF REC.CUSTOMER THEN
                GOSUB OBTIENE.CUSTOMER
                GOSUB GUARDA.TABLA.1
            END ELSE
                IF REC.IPAB.CLI.CTA.BEN THEN
                    GOSUB GUARDA.TABLA.1
                END
            END
        END
    NEXT CT

RETURN

*****************
OBTIENE.CUSTOMER:
*****************

    RESULT = ''
    AbcCob.funCus(ID.CLIENTE,'PERSONALIDAD',RESULT)
    Y.PERSONALIDAD = RESULT
    RESULT = ''
    AbcCob.funCus(ID.CLIENTE,'NOMBRE',RESULT)
    Y.NOMBRE = RESULT
    RESULT = ''
    AbcCob.funCus(ID.CLIENTE,'APELLIDO.P',RESULT)
    Y.APE.PATERNO = RESULT
    RESULT = ''
    AbcCob.funCus(ID.CLIENTE,'APELLIDO.M',RESULT)
    Y.APE.MATERNO = RESULT
    Y.CALLE = REC.CUSTOMER<ST.Customer.Customer.EbCusStreet,1>
    Y.NUMERO = REC.CUSTOMER<ST.Customer.Customer.EbCusAddress,1,1>
    Y.CALLE.NUMERO = Y.CALLE:' ':Y.NUMERO
    Y.COLONIA = REC.CUSTOMER<ST.Customer.Customer.EbCusSubDepartment,1>
    Y.MUNICIPIO = REC.CUSTOMER<ST.Customer.Customer.EbCusDepartment,1>
    Y.COD.POS = REC.CUSTOMER<ST.Customer.Customer.EbCusPostCode,1>
    Y.PAIS = REC.CUSTOMER<ST.Customer.Customer.EbCusCountry,1>
    Y.ESTADO = REC.CUSTOMER<ST.Customer.Customer.EbCusCountrySubdivision,1>
    RESULT = ''
    AbcCob.abcGetMappedValue('IPAB.ESTADOS',Y.ESTADO, RESULT, YERR)
    Y.ESTADO = RESULT
    Y.RFC = REC.CUSTOMER<ST.Customer.Customer.EbCusTaxId,1>
    Y.CURP = REC.CUSTOMER<ST.Customer.Customer.EbCusExternCusId,1>
    Y.TELEFONO = REC.CUSTOMER<ST.Customer.Customer.EbCusPhoneOne,1>
    Y.EMAIL = REC.CUSTOMER<ST.Customer.Customer.EbCusEmailOne,1>
    Y.FEC.NACIMIENTO = REC.CUSTOMER<ST.Customer.Customer.EbCusDateOfBirth,1>

    Y.COD.POS = FMT(Y.COD.POS,"5'0'R")

    IF Y.PAIS NE '' THEN
        REC.COUNTRY = ''
        EB.DataAccess.FRead(FN.COUNTRY,Y.PAIS,REC.COUNTRY,F.COUNTRY,YERR.COUNTRY)
        Y.PAIS = REC.COUNTRY<ST.Config.Country.EbCouCountryName>
    END

    IF Y.COLONIA NE '' THEN
        REC.COLONIA = ''
        EB.DataAccess.FRead(FN.VPM.COLONIA,Y.COLONIA,REC.COLONIA,F.VPM.COLONIA,YERR.COLONIA)
        Y.COLONIA = REC.COLONIA<AbcTable.AbcColonia.Colonia>
    END

    IF Y.MUNICIPIO NE '' THEN
        REC.MUNICIPIO = ''
        EB.DataAccess.FRead(FN.VPM.MUNICIPIO,Y.MUNICIPIO,REC.MUNICIPIO,F.VPM.MUNICIPIO,YERR.MUNICIPIO)
        Y.MUNICIPIO = REC.MUNICIPIO<AbcTable.AbcMunicipio.Municipio>
    END

RETURN

********************
OBTIENE.CLI.CTA.BEN:
********************

    Y.PERSONALIDAD = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Personalidad>
    Y.NOMBRE = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Nombre>
    Y.APE.PATERNO = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.ApellidoPaterno>
    Y.APE.MATERNO = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.ApellidoMaterno>
    Y.CALLE.NUMERO = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.CalleNumero>
    Y.COLONIA = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Colonia>
    Y.MUNICIPIO = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Municipio>
    Y.COD.POS = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.CodPos>
    Y.PAIS = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Pais>
    Y.ESTADO = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Estado>
    Y.RFC = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.RFC>
    Y.CURP = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Curp>
    Y.TELEFONO = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Telefono>
    Y.EMAIL = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Email>
    Y.FEC.NACIMIENTO = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.FechaNacimiento>
    Y.SALDO.COMPENSADO = REC.IPAB.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.SaldoCompensado>

RETURN

***************
GUARDA.TABLA.1:
***************

    REC.REPORT.TMP = ID.CLIENTE:Y.SEP:Y.PERSONALIDAD:Y.SEP:Y.NOMBRE:Y.SEP:Y.APE.PATERNO:Y.SEP:Y.APE.MATERNO:Y.SEP
    REC.REPORT.TMP := Y.CALLE.NUMERO:Y.SEP:Y.COLONIA:Y.SEP:Y.MUNICIPIO:Y.SEP:'':Y.SEP:Y.COD.POS:Y.SEP
    REC.REPORT.TMP := Y.PAIS:Y.SEP:Y.ESTADO:Y.SEP:'S':Y.SEP:'1.04':Y.SEP:'0':Y.SEP:Y.RFC:Y.SEP:Y.CURP:Y.SEP
    REC.REPORT.TMP := Y.TELEFONO:Y.SEP:Y.EMAIL:Y.SEP:Y.FEC.NACIMIENTO:Y.SEP:Y.SALDO.COMPENSADO:Y.SEP:'1'

    WRITE REC.REPORT.TMP TO F.ABC.FILE.REPORT.TMP, Y.ID.TMP

RETURN

END
