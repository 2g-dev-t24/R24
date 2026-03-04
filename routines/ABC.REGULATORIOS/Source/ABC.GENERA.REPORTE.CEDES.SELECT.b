* @ValidationCode : MjotODc5ODA0NzI4OkNwMTI1MjoxNzY0MTI3ODMyMzIxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Nov 2025 00:30:32
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

SUBROUTINE ABC.GENERA.REPORTE.CEDES.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AbcGetGeneralParam
    $USING EB.Updates
    $USING EB.Display
    $USING EB.Service
*-----------------------------------------------------------------------------

    GOSUB CREA.CARPETA
    GOSUB CARGA.ARCHIVO
    GOSUB FINALLY
RETURN

****************
CREA.CARPETA:
****************
    NOMBRE.FICHERO = AbcRegulatorios.getNombreFichero()
    NOMB.FOLDER = AbcRegulatorios.getNombFolder()
    RUTA.PDF = AbcRegulatorios.getRutaPdf();
    RUTA.XML = AbcRegulatorios.getRutaXml();
    RUTA.JRXML = AbcRegulatorios.getRutaJrxml();

    NOMBRE.JR.PAG = AbcRegulatorios.getNombreJrPag();
    NOMBRE.PDF.PAG = AbcRegulatorios.getNombrePdfPag();

    NOMBRE.JR.F = AbcRegulatorios.getNombreJrF();
    NOMBRE.PDF.F = AbcRegulatorios.getNombrePdfF();

    NOMBRE.JR.CEDE = AbcRegulatorios.getNombreJrCede();
    NOMBRE.PDF.CEDE = AbcRegulatorios.getNombrePdfCede();

    NOMBRE.JAR = AbcRegulatorios.getNombreJar();

    RUTA.IMAGEN.JR = AbcRegulatorios.getRutaImagenJr();
    RUTA.SUBREPORTE.JR = AbcRegulatorios.getRutaSubreporteJr();
    RUTA.FICHERO.VECTOR = AbcRegulatorios.getRutaFicheroVector();
    NOMBRE.FICHERO.VECTOR = AbcRegulatorios.getNombreFicheroVector();
    

    Y.SALTO = CHAR(10)
    Y.DATE = OCONV(DATE(), "DY4"):"":FMT(OCONV(DATE(), "DM"),"2'0'R"):"":FMT(OCONV(DATE(), "DD"),"2'0'R")
    Y.TIME = OCONV(TIME(),'MTS')

    Y.CARPETA.CEDES = NOMB.FOLDER:'_':Y.DATE:'_':Y.TIME
    AbcRegulatorios.setYCarpetaCedes(Y.CARPETA.CEDES);
     
    str_path = @PATH
    str_filename = "ABC.CREA.CARPETA.CEDES":RND(2000000):TIME():".sh"
    TEMP.FILE = str_path : "/" : str_filename

    OPENSEQ TEMP.FILE TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

* Armo Archivo
    Y.SHELL  = "#!/bin/ksh" : Y.SALTO
    Y.SHELL := "cd ":RUTA.FICHERO.VECTOR: Y.SALTO
    Y.SHELL := "mkdir ": Y.CARPETA.CEDES: Y.SALTO
    Y.SHELL := "exit" : Y.SALTO
    Y.SHELL := "EOT"

    WRITESEQ Y.SHELL APPEND TO FILE.VAR1 ELSE
        Y.MENSAJE = "No se Consiguio Escribir el Archivo: " : TEMP.FILE
        DISPLAY Y.MENSAJE
    END
    CLOSESEQ FILE.VAR1

    EXECUTE "chmod 777 ./" : str_filename CAPTURING Y.RESPONSE.CHMOD
    EXECUTE "./" : str_filename            CAPTURING Y.RETURNVAL
    EXECUTE "rm ./" : str_filename        CAPTURING Y.RESPONSE.RM


    Y.FILE.D = 'data_folder.temp.txt'
    Y.FOLDER.NAME = Y.CARPETA.CEDES
    OPEN RUTA.FICHERO.VECTOR TO F.RUTA.DIRECT ELSE Y.RESPUES = "ERROR AL ABRIR RUTA"
    WRITE Y.FOLDER.NAME TO F.RUTA.DIRECT,Y.FILE.D


RETURN

*******************
CARGA.ARCHIVO:
*******************
    Y.SEP = ','
    Y.LIST = ''
    Y.ARCHIVO = RUTA.FICHERO.VECTOR: NOMBRE.FICHERO
    OPENSEQ Y.ARCHIVO TO SOC.FILE THEN
        LOOP
            READSEQ Y.LINE FROM SOC.FILE THEN STATE=STATUS() ELSE EXIT
        UNTIL STATE=1

            ID.ARRANGEMENT = FIELD(Y.LINE,Y.SEP,1)

            Y.LIST := ID.ARRANGEMENT:@FM
            CONTA = CONTA + 1
        REPEAT
        NUM.PROCESA = CONTA
        CLOSESEQ SOC.FILE

    END ELSE

    END
    EB.Service.BatchBuildList('',Y.LIST)

    Y.RUTA.FOLD = RUTA.FICHERO.VECTOR:Y.CARPETA.CEDES

    COMMAND = 'mv ' :RUTA.FICHERO.VECTOR:NOMBRE.FICHERO:' ':Y.RUTA.FOLD:"/":NOMBRE.FICHERO
    EXECUTE COMMAND CAPTURING  Y.RESULTADO

    Y.FILE.D = 'data1_temp.txt'
    OPEN RUTA.FICHERO.VECTOR TO F.RUTA ELSE Y.RESPUES = "ERROR AL ABRIR RUTA"
    WRITE NUM.PROCESA TO F.RUTA,Y.FILE.D
RETURN

*-------------------------------------------------------------------------
*Last Step in Program
*-------------------------------------------------------------------------
FINALLY:
*-----------------------------------------------------------------------------

*Do Not Add Return :)

END

