* @ValidationCode : MjoxNzE2Nzc1MzM1OkNwMTI1MjoxNzU3NTUzOTMxMTQzOm1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Sep 2025 22:25:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcPortNom
*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.DATOS.PN

* ======================================================================
* Nombre de Programa : ABC.DATOS.PN
* Parametros         :
* Objetivo           : REGRESA LOS DATOS DE LOS CAMPOS DE ALTA DE PN
* Desarrollador      : SANDRA FIGUEROA ESQUIVEL
* Compania           : ABC
* Fecha Creacion     : 2016/09/22
* Modificaciones     :
* ======================================================================

    $USING EB.SystemTables
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING ST.Customer
    
    GOSUB OPEN.TABLE
    GOSUB INIT
RETURN

INIT:

    Y.CUS= EB.SystemTables.getComi()
    GOSUB CHECK.REC
    Y.TIME = TIMEDATE()
    Y.HHMMSS= FIELD(Y.TIME," ",1)
    Y.HHMMSS=EREPLACE( Y.HHMMSS, ":","")
    Y.DATE= EB.SystemTables.getToday()
    Y.BANCO='40138'

    R.CUS=''
    ERR.CUS=''
    Y.NAME=''
    Y.APP=''
    Y.APM=''
    Y.RFC=''
    Y.CURP=''
    Y.BIRTH=''

    EB.DataAccess.FRead(FN.CUS,Y.CUS,R.CUS,F.CUS,ERR.CUS)
    IF R.CUS NE '' THEN

        Y.APP=R.CUS<ST.Customer.Customer.EbCusShortName>
        Y.APM=R.CUS<ST.Customer.Customer.EbCusNameOne>
        Y.NAME=R.CUS<ST.Customer.Customer.EbCusNameTwo>
        Y.RFC=R.CUS<ST.Customer.Customer.EbCusTaxId,1>
        Y.CURP=R.CUS<ST.Customer.Customer.EbCusExternCusId>
        Y.BIRTH=R.CUS<ST.Customer.Customer.EbCusDateOfBirth>
        Y.T.O=EB.SystemTables.getRNew(AbcTable.AbcPortabilidadNomina.TO)
        ID.NEW = EB.SystemTables.getIdNew()
        Y.FOLIO =Y.DATE:Y.HHMMSS:Y.BANCO:Y.T.O:ID.NEW[3,8]

        GOSUB WRITE.FIELDS
    END ELSE
        E= "CLIENTE NO EXISTE"
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.Err()
    END


RETURN

CHECK.REC:

    CUST.LIST=''
    Y.SEL.PN=''
    CUST.NO=''

    Y.SEL.PN='SELECT ':FN.PN:' WITH NO.CLIENTE EQ ':DQUOTE(Y.CUS): ' AND (ESTATUS LE "3" OR ESTATUS EQ "4" OR ESTATUS EQ "7")'  ; * ITSS - SANGAVI - Added DQUOTE / "
    EB.DataAccess.Readlist( Y.SEL.PN, CUST.LIST, '', CUST.NO, '')
    IF CUST.NO GT 0 THEN
        R.PN=''
        Y.ERR.PN=''
        EB.DataAccess.FRead(FN.PN,CUST.LIST,R.PN,F.PN,Y.ERR.PN)
        Y.ESTATUS=R.PN<AbcTable.AbcPortabilidadNomina.Estatus>
        BEGIN CASE

            CASE Y.ESTATUS=1
                E= "CLIENTE CUENTA CON SOLICITUD DE ALTA DE SERVICIO: ":CUST.LIST
                EB.SystemTables.setE(E)
                EB.ErrorProcessing.Err()
            CASE Y.ESTATUS=2
                E= "CLIENTE CUENTA CON EL SERVICIO: ":CUST.LIST
                EB.SystemTables.setE(E)
                EB.ErrorProcessing.Err()
            CASE Y.ESTATUS=3
                E= "CLIENTE TIENE EN TRAMITE UNA CANCELACION DE SERVICIO: ":CUST.LIST
                EB.SystemTables.setE(E)
                EB.ErrorProcessing.Err()
        END CASE

    END

RETURN

WRITE.FIELDS:

    EB.SystemTables.setRNew(AbcTable.AbcPortabilidadNomina.Nombre, Y.NAME:" ":Y.APP:" ":Y.APM)
    EB.SystemTables.setRNew(AbcTable.AbcPortabilidadNomina.FecNac, Y.BIRTH)
    EB.SystemTables.setRNew(AbcTable.AbcPortabilidadNomina.Rfc, Y.RFC)
    EB.SystemTables.setRNew(AbcTable.AbcPortabilidadNomina.Curp, Y.CURP)
    EB.SystemTables.setRNew(AbcTable.AbcPortabilidadNomina.FolioSolicitud, Y.FOLIO)
RETURN

OPEN.TABLE:
    FN.CUS='F.CUSTOMER'
    F.CUS=''
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    
    FN.PN='F.ABC.PORTABILIDAD.NOMINA'
    F.PN=''
    EB.DataAccess.Opf(FN.PN, F.PN)
RETURN
END
