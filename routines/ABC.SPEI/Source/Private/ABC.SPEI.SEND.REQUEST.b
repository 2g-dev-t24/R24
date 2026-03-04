* @ValidationCode : MjoxNjgzNzI0NzE3OkNwMTI1MjoxNzcyNDg0NTYyMTMxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Mar 2026 17:49:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.SPEI.SEND.REQUEST(Y.CD.SHELL, Y.DATOS.ENVIO, Y.RETURNVAL)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING AbcGetGeneralParam
    
    GOSUB INIT.VARS
    GOSUB PROCESS
RETURN

**********
INIT.VARS:
**********
    Y.SEP = "|"
    YSEP.ORI = ";"
    Y.SEPA3 = "/"
    Y.HOY = EB.SystemTables.getToday()

    Y.CADENA.ENVIO = FIELD(Y.DATOS.ENVIO, Y.SEP, 1)
    Y.RUTA.LOG = FIELD(Y.DATOS.ENVIO, Y.SEP, 2)
    Y.PREF.ARCHIVO.LOG = FIELD(Y.DATOS.ENVIO, Y.SEP, 3)
    Y.ID.FT = FIELD(Y.DATOS.ENVIO, Y.SEP, 4)
    Y.ARCHIVO.LOG = Y.RUTA.LOG : Y.SEPA3 : Y.PREF.ARCHIVO.LOG : Y.HOY : ".": Y.ID.FT: ".log"
RETURN

********
PROCESS:
********
    Y.SALTO = CHAR(10)
    Y.MENSAJE = Y.SALTO : "--------------------------------------------------------------------------"
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "PROCESANDO TRANSACCION ...  " : Y.ID.FT
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

*    str_path = @PATH

    Y.ID.PARAM = 'ABC.SPEI.SEND.REQUEST'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE "RUTA" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.RUTA = Y.LIST.VALUES<YPOS.PARAM>
    END
    LOCATE "JAR" IN Y.LIST.PARAMS SETTING YPOS.JAR THEN
        Y.JAR = Y.LIST.VALUES<YPOS.JAR>
    END
    str_path = Y.RUTA
    str_filename = "SPEI":RND(2000000):TIME():".sh"
    TEMP.FILE = str_path : "/" : str_filename

    OPENSEQ TEMP.FILE TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    Y.CADENA = 'java -jar ':Y.JAR : ' "' : Y.CADENA.ENVIO : '"' : Y.SALTO

    Y.MENSAJE = "ENVIANDO REQUEST ...  "
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = Y.CADENA
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

* Armo Archivo, comentada primera linea no necesaria
*    Y.SHELL  = "#!/bin/ksh" : Y.SALTO
    Y.SHELL := "cd " : Y.CD.SHELL : Y.SALTO
    Y.SHELL := Y.CADENA
    Y.SHELL := "exit" : Y.SALTO
    Y.SHELL := "EOT"

    WRITESEQ Y.SHELL APPEND TO FILE.VAR1 ELSE
        Y.MENSAJE = "No se Consiguio Escribir el Archivo: " : TEMP.FILE
        AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)
        DISPLAY Y.MENSAJE
    END
    CLOSESEQ FILE.VAR1

    Y.EXECUTE.CHMOD = "SH -c chmod 777 " : TEMP.FILE
    EXECUTE Y.EXECUTE.CHMOD

    Y.EXECUTE.SCRIPT = "SH -c " : TEMP.FILE
    EXECUTE Y.EXECUTE.SCRIPT CAPTURING Y.RETURNVAL
    EXECUTE "SH -c rm " : TEMP.FILE

    Y.MENSAJE = "RECIBIENDO RESPUESTA...... "
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "RESPUESTA : " : Y.RETURNVAL
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "PROCESAMIENTO TERMINADO.  TRANSACCION ...  " : Y.ID.FT
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

    Y.MENSAJE = "--------------------------------------------------------------------------" : Y.SALTO
    AbcSpei.PbsInslog(Y.ARCHIVO.LOG, Y.MENSAJE, 0)

RETURN
END