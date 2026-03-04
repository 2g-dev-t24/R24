* @ValidationCode : MjotMTE2MzA4OTg5NzpDcDEyNTI6MTc2MDM5NzM4ODE4NTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Oct 2025 20:16:28
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

SUBROUTINE ABC.CARGA.DET.CLI.CTA.BEN
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Updates
    $USING EB.Service
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING ST.Config


    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN


*---------------
INITIALISE:
*---------------

    Y.SEP = '|'
    SEP.TAB = CHAR(9)

    Y.ID.PARAM = 'ABC.CARGA.DET.CLI.CTA.BEN'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE "RUTA.CARGA.DETALLE.CLI.CTA.BEN" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.RUTA = Y.LIST.VALUES<YPOS.PARAM>
    END
    LOCATE "FILE.NAME" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.FILE.NAME = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    LOCATE "RUTA.IPAB.CARGA" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.RUTA.IPAB.CARGA = Y.LIST.VALUES<YPOS.PARAM>
    END
    LOCATE "FILE.NAME.CLIENTE" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.FILE.NAME.CLIENTE = Y.LIST.VALUES<YPOS.PARAM>
    END
    LOCATE "RUTA.IPAB" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.FILE.NAME.CLIENTE.MV = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    FECHA.FILE = FMT(OCONV(DATE(), "DD"),"2'0'R"):".":FMT(OCONV(DATE(), "DM"),"2'0'R"):".":OCONV(DATE(), "DY4")
    str_filename = Y.FILE.NAME:"." : FECHA.FILE : ".log"
    SEQ.FILE.NAME = Y.RUTA

    OPENSEQ SEQ.FILE.NAME,str_filename TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    Y.FILE.PATH    = Y.RUTA.IPAB.CARGA
    Y.FILE.NAME    = Y.FILE.NAME.CLIENTE
    Y.FILE.PATHMV    = Y.FILE.NAME.CLIENTE.MV

RETURN

*---------------
OPENFILES:
*---------------

    FN.ABC.IPAB.CLI.CTA.BEN = 'F.ABC.IPAB.CLI.CTA.BEN'
    F.ABC.IPAB.CLI.CTA.BEN = ''
    EB.DataAccess.Opf(FN.ABC.IPAB.CLI.CTA.BEN,F.ABC.IPAB.CLI.CTA.BEN)

    FN.COUNTRY = 'F.COUNTRY'
    F.COUNTRY = ''
    EB.DataAccess.Opf(FN.COUNTRY,F.COUNTRY)

    FN.ABC.COLONIA = 'F.ABC.COLONIA'
    F.ABC.COLONIA = ''
    EB.DataAccess.Opf(FN.ABC.COLONIA,F.ABC.COLONIA)

    FN.ABC.ESTADO = 'F.ABC.ESTADO'
    F.ABC.ESTADO = ''
    EB.DataAccess.Opf(FN.ABC.ESTADO,F.ABC.ESTADO)

    FN.ABC.MUNICIPIO = 'F.ABC.MUNICIPIO'
    F.ABC.MUNICIPIO = ''
    EB.DataAccess.Opf(FN.ABC.MUNICIPIO,F.ABC.MUNICIPIO)


RETURN


*---------------
LIMPIA.VARIABLES:
*---------------

    Y.CLIENTE = ''
    Y.NOMBRE = ''
    Y.APELLIDO.PATERNO = ''
    Y.APELLIDO.MATERNO = ''
    Y.CALLE.NUMERO = ''
    Y.COLONIA = ''
    Y.MUNICIPIO = ''
    Y.COD.POS = ''
    Y.PAIS = ''
    Y.ESTADO = ''
    Y.RFC = ''
    Y.CURP = ''
    Y.TELEFONO = ''
    Y.CORREO.ELECTRONICO = ''
    Y.FECHA.NACIMIENTO = ''

RETURN


*---------------
PROCESS:
*---------------

    OPENSEQ Y.FILE.PATH,Y.FILE.NAME TO Y.PUNTERO THEN
        MENSAJE = "***********************************************************"
        GOSUB BITACORA
        MENSAJE = "INICIO"
        GOSUB BITACORA
        MENSAJE = "***********************************************************"
        GOSUB BITACORA
        LOOP
        WHILE NOT(EOF) DO
            READSEQ REC.LINE FROM Y.PUNTERO THEN
                GOSUB LIMPIA.VARIABLES
                Y.COUNT += 1
                Y.CLIENTE = FIELD(REC.LINE,Y.SEP,1)
                IF ISDIGIT(Y.CLIENTE) THEN
                    Y.NOMBRE = FIELD(REC.LINE,Y.SEP,2)
                    Y.APELLIDO.PATERNO = FIELD(REC.LINE,Y.SEP,3)
                    Y.APELLIDO.MATERNO = FIELD(REC.LINE,Y.SEP,4)
                    Y.CALLE.NUMERO = FIELD(REC.LINE,Y.SEP,5)
                    Y.COLONIA = FIELD(REC.LINE,Y.SEP,6)
                    Y.MUNICIPIO = FIELD(REC.LINE,Y.SEP,7)
                    Y.COD.POS = FIELD(REC.LINE,Y.SEP,8)
                    Y.PAIS = FIELD(REC.LINE,Y.SEP,9)
                    Y.ESTADO = FIELD(REC.LINE,Y.SEP,10)
                    Y.RFC = FIELD(REC.LINE,Y.SEP,11)
                    Y.CURP = FIELD(REC.LINE,Y.SEP,12)
                    Y.TELEFONO = FIELD(REC.LINE,Y.SEP,13)
                    Y.CORREO.ELECTRONICO = FIELD(REC.LINE,Y.SEP,14)
                    Y.FECHA.NACIMIENTO = FIELD(REC.LINE,Y.SEP,15)

                    IF Y.PAIS NE '' THEN
                        REC.COUNTRY = ''
                        EB.DataAccess.FRead(FN.COUNTRY,Y.PAIS,REC.COUNTRY,F.COUNTRY,YERR.COUNTRY)
                        Y.PAIS = REC.COUNTRY<ST.Config.Country.EbCouCountryName>
                    END

                    IF Y.COLONIA NE '' THEN
                        REC.COLONIA = ''
                        EB.DataAccess.FRead(FN.ABC.COLONIA,Y.COLONIA,REC.COLONIA,F.ABC.COLONIA,YERR.COLONIA)
                        Y.COLONIA = REC.COLONIA<AbcTable.AbcColonia.Colonia>
                    END

                    IF Y.ESTADO NE '' THEN
                        RESULT = ''
                        AbcCob.abcGetMappedValue('IPAB.ESTADOS',Y.ESTADO, RESULT, YERR)
                        Y.ESTADO = RESULT
                    END

                    IF Y.MUNICIPIO NE '' THEN
                        REC.MUNICIPIO = ''
                        EB.DataAccess.FRead(FN.ABC.MUNICIPIO,Y.MUNICIPIO,REC.MUNICIPIO,F.ABC.MUNICIPIO,YERR.MUNICIPIO)
                        Y.MUNICIPIO = REC.MUNICIPIO<AbcTable.AbcMunicipio.Municipio>
                    END

                    GOSUB ARMA.REG.CLIENTE
                END
            END ELSE
                EOF = 1
            END
        REPEAT
    END

RETURN

*****************
ARMA.REG.CLIENTE:
*****************

    REC.CLI.CTA.BEN = ''
    YERR = ''
    EB.DataAccess.FRead(FN.ABC.IPAB.CLI.CTA.BEN,Y.CLIENTE,REC.CLI.CTA.BEN,F.ABC.IPAB.CLI.CTA.BEN,YERR)

    Y.CLI.PERSONALIDAD = REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Personalidad>

    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Nombre> = Y.NOMBRE
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.ApellidoPaterno> = Y.APELLIDO.PATERNO
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.ApellidoMaterno> = Y.APELLIDO.MATERNO
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.CalleNumero> = Y.CALLE.NUMERO
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Colonia> = Y.COLONIA
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Municipio> = Y.MUNICIPIO
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.CodPos> = Y.COD.POS
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Pais> = Y.PAIS
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Estado> = Y.ESTADO
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.RFC> = Y.RFC
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Curp> = Y.CURP
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Telefono> = Y.TELEFONO
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Email> = Y.CORREO.ELECTRONICO
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.FechaNacimiento> = Y.FECHA.NACIMIENTO

    WRITE REC.CLI.CTA.BEN TO F.ABC.IPAB.CLI.CTA.BEN, Y.CLIENTE

RETURN

*********
BITACORA:
*********

    WRITESEQ TIMEDATE():" ":MENSAJE APPEND TO FILE.VAR1 ELSE
    END
    MENSAJE = ''
RETURN

********
FINALLY:
********

    EXECUTE "mv ":Y.FILE.PATH:Y.FILE.NAME:" ":Y.FILE.PATHMV:"CLIENTE_R06_2019.":FECHA.FILE:".":TIMEDATE()[1,2]:TIMEDATE()[4,2]:TIMEDATE()[7,2]:".csv" CAPTURING Y.RESPONSE.MV
    IF Y.RESPONSE.MV THEN
        MENSAJE = "RESPUESTA DE MOVIMIENTO: ":Y.RESPONSE.MV
        DISPLAY MENSAJE
        GOSUB BITACORA
    END

* TEXT = 'CARGA FINALIZADA'
*  CALL REM

RETURN

END

