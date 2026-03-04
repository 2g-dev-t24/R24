$PACKAGE EB.AbcUtil
* @ValidationCode : Mjo4MTExMzcxNTY6Q3AxMjUyOjE3NjYwODc1OTA0OTY6VXN1YXJpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Dec 2025 13:53:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usuario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
SUBROUTINE ABC.MOVE.TO.S3(Y.RUTA.ARCHIVO.ORIGEN, Y.RUTA.FIN.S3, Y.NOMBRE.ARCHIVO)
*-----------------------------------------------------------------------------
* Modification History:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB MOVER.ARCHIVO
    
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    Y.NOMBRE.RUTINA = '' ; Y.CADENA.LOG = ''

    Y.LONGITUD.RUTA.ORIGEN = LEN(Y.RUTA.ARCHIVO.ORIGEN)
    
    Y.CADENA.LOG<-1> =  "Y.RUTA.ARCHIVO.ORIGEN->" : Y.RUTA.ARCHIVO.ORIGEN
    
    IF Y.RUTA.ARCHIVO.ORIGEN[Y.LONGITUD.RUTA.ORIGEN, 1] EQ "/" ELSE
        Y.RUTA.ARCHIVO.ORIGEN = Y.RUTA.ARCHIVO.ORIGEN : "/"
        Y.CADENA.LOG<-1> =  "Y.RUTA.ARCHIVO.ORIGEN->" : Y.RUTA.ARCHIVO.ORIGEN
    END

    Y.RUTA.ARCHIVO.ORIGEN = Y.RUTA.ARCHIVO.ORIGEN : Y.NOMBRE.ARCHIVO
    Y.CADENA.LOG<-1> =  "Y.RUTA.ARCHIVO.ORIGEN->" : Y.RUTA.ARCHIVO.ORIGEN
    
    Y.RUTA.ARCHIVO.DESTINO = Y.RUTA.FIN.S3
    Y.CADENA.LOG<-1> =  "Y.RUTA.ARCHIVO.DESTINO->" : Y.RUTA.ARCHIVO.DESTINO
    
RETURN
*-----------------------------------------------------------------------------
MOVER.ARCHIVO:
*-----------------------------------------------------------------------------

    Y.CMD.MV = 'SH -c mv ' : Y.RUTA.ARCHIVO.ORIGEN : ' ' : Y.RUTA.ARCHIVO.DESTINO
    EXECUTE Y.CMD.MV CAPTURING Y.RESPONSE.MV
    
    Y.CADENA.LOG<-1> =  "Y.CMD.MV->" : Y.CMD.MV
    Y.CADENA.LOG<-1> =  "Y.RESPONSE.MV->" : Y.RESPONSE.MV
    
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)
    
    
RETURN
*-----------------------------------------------------------------------------
END
