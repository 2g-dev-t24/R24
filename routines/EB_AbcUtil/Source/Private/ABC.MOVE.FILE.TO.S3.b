* @ValidationCode : MjotMTYwNDQxMzQzNTpDcDEyNTI6MTc3MDg0MDQzMTI5MDpDw6lzYXJNaXJhbmRhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Feb 2026 14:07:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : CésarMiranda
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE EB.AbcUtil
SUBROUTINE ABC.MOVE.FILE.TO.S3(Y.RUTA.ARCHIVO.ORIGEN, Y.RUTA.FIN.S3, Y.NOMBRE.ARCHIVO)
*-----------------------------------------------------------------------------
* Modification History:
*-----------------------------------------------------------------------------

    $USING EB.SystemTables

    GOSUB INIT
    GOSUB MOVER.ARCHIVO
    
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    Y.NOMBRE.RUTINA = '' ; Y.CADENA.LOG = ''
    Y.ID.PARAM = '' ; Y.RUTA.ARCHIVO.ORIGEN.AUX = ''

    Y.ID.PARAM = EB.SystemTables.getBatchDetails()
    Y.ID.PARAM = Y.ID.PARAM<3>
    
    
    Y.NOMBRE.RUTINA = 'ABC.MOVE.FILE.TO.S3'
    Y.LONGITUD.RUTA.ORIGEN = LEN(Y.RUTA.ARCHIVO.ORIGEN)
    Y.RUTA.ARCHIVO.ORIGEN.AUX = Y.RUTA.ARCHIVO.ORIGEN
    
    Y.CADENA.LOG<-1> =  "Y.RUTA.ARCHIVO.ORIGEN->" : Y.RUTA.ARCHIVO.ORIGEN
    
    IF Y.RUTA.ARCHIVO.ORIGEN.AUX[Y.LONGITUD.RUTA.ORIGEN, 1] EQ "/" ELSE
        Y.RUTA.ARCHIVO.ORIGEN.AUX = Y.RUTA.ARCHIVO.ORIGEN.AUX : "/"
        Y.CADENA.LOG<-1> =  "Y.RUTA.ARCHIVO.ORIGEN.AUX->" : Y.RUTA.ARCHIVO.ORIGEN.AUX
    END

    Y.RUTA.ARCHIVO.ORIGEN.AUX = Y.RUTA.ARCHIVO.ORIGEN.AUX : Y.NOMBRE.ARCHIVO
    Y.CADENA.LOG<-1> =  "Y.RUTA.ARCHIVO.ORIGEN.AUX->" : Y.RUTA.ARCHIVO.ORIGEN.AUX
    
    Y.RUTA.ARCHIVO.DESTINO = Y.RUTA.FIN.S3
    Y.CADENA.LOG<-1> =  "Y.RUTA.ARCHIVO.DESTINO->" : Y.RUTA.ARCHIVO.DESTINO
    
RETURN
*-----------------------------------------------------------------------------
MOVER.ARCHIVO:
*-----------------------------------------------------------------------------

    Y.CMD.MV = 'SH -c mv ' : Y.RUTA.ARCHIVO.ORIGEN.AUX : ' ' : Y.RUTA.ARCHIVO.DESTINO
    EXECUTE Y.CMD.MV CAPTURING Y.RESPONSE.MV
    
    Y.CADENA.LOG<-1> =  "Y.CMD.MV->" : Y.CMD.MV
    Y.CADENA.LOG<-1> =  "Y.RESPONSE.MV->" : Y.RESPONSE.MV
    
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)
    
    
RETURN
*-----------------------------------------------------------------------------
END
