* @ValidationCode : MjotNjE2ODIxOTgwOkNwMTI1MjoxNzY3MTIzODY5NDI1OkVkZ2FyIFNhbmNoZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 30 Dec 2025 13:44:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar Sanchez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcCob

SUBROUTINE ABC.REP.MULTI.R24D24.41.42.POST

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING EB.AbcUtil
    GOSUB CALCULA.FECHA
    GOSUB EXTRAE.PARAMAMETROS
    GOSUB INICIO.VARIABLES
    GOSUB GENERA.ARCHIVO
    GOSUB PROCESO.EXTRACCION

RETURN

********************
EXTRAE.PARAMAMETROS:
********************

    FORMULARIO.2441 = '2441'

    FORMULARIO.2442 = '2442'

    Y.ARR.NOM.PARAM = ''
    Y.ARR.DAT.PARAM = ''
    Y.RUTA.S3 = ''
    Y.ID.PARAM = 'PARAMETROS.R2441.R2442'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.ARR.NOM.PARAM, Y.ARR.DAT.PARAM)
    NUM.LINEAS = DCOUNT(Y.ARR.NOM.PARAM,@FM)

    LOCATE "RUTA.2441" IN Y.ARR.NOM.PARAM SETTING POS THEN
        J.RUTA.2441 = Y.ARR.DAT.PARAM<POS>
        J.RUTA.2441.TEMP = J.RUTA.2441:"/TEMP/"
    END

    LOCATE "NOMBRE.ARCHIVO.2441" IN Y.ARR.NOM.PARAM SETTING POS THEN
        J.NOM.ARC.2441 = Y.ARR.DAT.PARAM<POS>
    END

    LOCATE "EXTENSION.2441" IN Y.ARR.NOM.PARAM SETTING POS THEN
        J.EXT.2441 = Y.ARR.DAT.PARAM<POS>
    END

    LOCATE "RUTA.2442" IN Y.ARR.NOM.PARAM SETTING POS THEN
        J.RUTA.2442 = Y.ARR.DAT.PARAM<POS>
        J.RUTA.2442.TEMP = J.RUTA.2442:"/TEMP/"
    END

    LOCATE "NOMBRE.ARCHIVO.2442" IN Y.ARR.NOM.PARAM SETTING POS THEN
        J.NOM.ARC.2442 = Y.ARR.DAT.PARAM<POS>
    END

    LOCATE "EXTENSION.2442" IN Y.ARR.NOM.PARAM SETTING POS THEN
        J.EXT.2442 = Y.ARR.DAT.PARAM<POS>
    END

    LOCATE "CLAVE.REP.REG" IN Y.ARR.NOM.PARAM SETTING POS THEN
        CLAVE.ENT = Y.ARR.DAT.PARAM<POS>
    END
    LOCATE "RUTA.MOV.S3" IN Y.ARR.NOM.PARAM SETTING POS THEN
        Y.RUTA.S3 = Y.ARR.DAT.PARAM<POS>
    END
    J.NOM.ARCHIVO.2441 = J.NOM.ARC.2441:J.EXT.2441
    J.NOM.ARCHIVO.2442 = J.NOM.ARC.2442:J.EXT.2442

RETURN

*****************
INICIO.VARIABLES:
*****************

* -Datos Iniciales
    SP = ']'
    CONST_CLV_ENT = CLAVE.ENT
    ARRAY_BRUTO = ''
    ENCABEZADO.2441 = "PERIODO]CLAVE DE LA ENTIDAD]FORMULARIO]TIPO DE CUENTA TRANSACCIONAL]CANAL DE LA TRANSACCION]TIPO DE OPERACION]MONTO DE LAS OPERACIONES]NUMERO DE OPERACIONES]NUMERO DE CLIENTES"
    ARRAY_CHECK = ''
    J.ARR.DESG = 'R24,CUENTA,CATEGORY,ID.STMT,CODE.TRANS,AMOUNT,ID.OPERACION,INPUTTER.FT,CREDIT.THEIR.REF,CREDIT.ACCT.NO,DEBIT.THEIR.REF,TIPO.CUENTA,CANAL,TIPO.OPERACION,ID.COMISIONISTA,CANALFT'

    ENCABEZADO = 'PERIODO,CLAVE DE LA ENTIDAD,FORMULARIO,TIPO DE CUENTA TRANSACCIONAL,'
    ENCABEZADO := 'CANAL DE TRANSACCION,TIPO DE OPERACION,FRECUENCIA DE OPERACIONES,NUMERO DE CUENTAS'

RETURN

*******************
PROCESO.EXTRACCION:
*******************
    
    yDataLog<-1> = 'Empieza Log'
    SEL.CMD = "SELECT ":J.RUTA.2441.TEMP
    yDataLog<-1> = 'Ejecute SELECT '
    EB.DataAccess.Readlist(SEL.CMD,LIST.ARCH,'',NO.ARCH,ERR.ARCH)

    FOR CNT.ARCH = 1 TO NO.ARCH
        EOF = ''
        ID.ARCH = FIELD(LIST.ARCH,@FM,CNT.ARCH)
        OPENSEQ J.RUTA.2441.TEMP:ID.ARCH TO Y.PUNTERO THEN
            LOOP
            WHILE NOT(EOF) DO
                READSEQ REC.LINE FROM Y.PUNTERO THEN
                    GOSUB ESCRIBE.ARCHIVO.DESGLOSE
                    IF FIELD(REC.LINE,',',1) EQ 'SI' THEN
                        J.CANAL = FIELD(REC.LINE,',',13)
                        J.TIPO.OPER = FIELD(REC.LINE,',',14)
                        J.TIPO.CTA = FIELD(REC.LINE,',',12)
                        ID.AC = FIELD(REC.LINE,',',2)
                        J.AMOUNT = FIELD(REC.LINE,',',6)
                        
                        GOSUB AGRUPACION.ARR.R2441
                        GOSUB AGRUPACION.ARR.R2442
                    END
                END ELSE
                    EOF = 1
                END
            REPEAT
        END
        
        CLOSESEQ Y.PUNTERO
        EXECUTE 'SH -c rm ': J.RUTA.2441.TEMP:ID.ARCH
    NEXT CNT.ARCH
    
    GOSUB ESCRIBE.ARCHIVO

RETURN

****************
GENERA.ARCHIVO:
****************

    F.SFILE = ""
    F.SFILE.1 = ""
    F.SFILE.2 = ""
    F.SFILE.3 = ""

    J.NOM.ARCHIVO.2441.DESG = J.NOM.ARC.2441:'.DESG':J.EXT.2441
    OPENSEQ J.RUTA.2441,J.NOM.ARCHIVO.2441.DESG TO F.SFILE ELSE
        CREATE F.SFILE ELSE
        END
    END

    J.NOM.ARCHIVO.2442.DESG = J.NOM.ARC.2442:'.DESG':J.EXT.2442
    OPENSEQ J.RUTA.2442,J.NOM.ARCHIVO.2442.DESG TO F.SFILE.1 ELSE
        CREATE F.SFILE.1 ELSE
        END
    END

    OPENSEQ J.RUTA.2441,J.NOM.ARCHIVO.2441 TO F.SFILE.2 ELSE
        CREATE F.SFILE.2 ELSE
        END
    END

    OPENSEQ J.RUTA.2442,J.NOM.ARCHIVO.2442 TO F.SFILE.3 ELSE
        CREATE F.SFILE.3 ELSE
        END
    END

    REC.LINE = J.ARR.DESG

    WRITESEQ REC.LINE APPEND TO F.SFILE ELSE
    END

    WRITESEQ REC.LINE APPEND TO F.SFILE.1 ELSE
    END

RETURN

*************************
ESCRIBE.ARCHIVO.DESGLOSE:
*************************

    WRITESEQ REC.LINE APPEND TO F.SFILE ELSE
    END

    WRITESEQ REC.LINE APPEND TO F.SFILE.1 ELSE
    END

RETURN

****************
ESCRIBE.ARCHIVO:
****************

    J.ARR.CTAS = ENCABEZADO.2441
    IF ARRAY_BRUTO NE '' THEN
        J.ARR.CTAS<-1> = ARRAY_BRUTO
    END

    CHANGE @VM TO ',' IN J.ARR.CTAS
    CHANGE ']' TO ',' IN J.ARR.CTAS
    CHANGE @FM TO CHAR(13) IN J.ARR.CTAS

    WRITESEQ J.ARR.CTAS APPEND TO F.SFILE.2 ELSE
    END

    IF J.ARR.CTAS.R2442 THEN
        GOSUB ARM.ARR.FINAL
    END ;*esanchez20251230  Si no hay registros con SI aun asi se escribe el encabezado.
    
    Y.ARR.FIN<-1> = ENCABEZADO
    Y.ARR.FIN<-1> = Y.ARR.FINAL
    CHANGE @FM TO CHAR(13) IN Y.ARR.FIN

    WRITESEQ Y.ARR.FIN APPEND TO F.SFILE.3 ELSE
    END

    
    CLOSESEQ F.SFILE
    CLOSESEQ F.SFILE.1
    CLOSESEQ F.SFILE.2
    CLOSESEQ F.SFILE.3
    
    Y.CMD.MK = 'SH -c mkdir ' : yRutaArchivoOrigen
    EXECUTE Y.CMD.MK CAPTURING Y.RESPONSE.MK
        
    yRutaArchivoOrigen = J.RUTA.2441
    yNombreArchivo = J.NOM.ARCHIVO.2441.DESG
    yRutaFinS3 = Y.RUTA.S3
    yDataLog<-1> =  'Ruta Origen-> ':yRutaArchivoOrigen
    yDataLog<-1> =  'Nombre Archivo-> ': yNombreArchivo
    yDataLog<-1> =  'Ruta S3-> ': yRutaFinS3
    EB.AbcUtil.abcMoveFileToS3(yRutaArchivoOrigen, yRutaFinS3, yNombreArchivo)
    
    yRutaArchivoOrigen = ''
    yNombreArchivo = ''
    
    yRutaArchivoOrigen = J.RUTA.2442
    yNombreArchivo = J.NOM.ARCHIVO.2442.DESG
    EB.AbcUtil.abcMoveFileToS3(yRutaArchivoOrigen, yRutaFinS3, yNombreArchivo)
    
    yRutaArchivoOrigen = ''
    yNombreArchivo = ''
    
    yRutaArchivoOrigen = J.RUTA.2441
    yNombreArchivo = J.NOM.ARCHIVO.2441
    EB.AbcUtil.abcMoveFileToS3(yRutaArchivoOrigen, yRutaFinS3, yNombreArchivo)
    
    yRutaArchivoOrigen = ''
    yNombreArchivo = ''
    
    yRutaArchivoOrigen = J.RUTA.2442
    yNombreArchivo = J.NOM.ARCHIVO.2442
    EB.AbcUtil.abcMoveFileToS3(yRutaArchivoOrigen, yRutaFinS3, yNombreArchivo)
    
    yDataLog<-1> = 'Termine mov S3'
    yRtnName = 'ABC.REP.R24'
    EB.AbcUtil.abcEscribeLogGenerico(yRtnName, yDataLog)

RETURN

***************
AGRUPACION.ARR.R2441:
***************

    IF J.CANAL NE '' AND J.TIPO.OPER NE '' THEN
        TMP_STR = J.TIPO.CTA : SP : J.CANAL : SP : J.TIPO.OPER
        TMP_CTA_STR = ID.AC : SP : TMP_STR
        FIND TMP_STR IN ARRAY_BRUTO SETTING Apn, Vpn THEN
            Y.POS.BRUTO = Apn
            ARRAY_BRUTO<Y.POS.BRUTO, 4> += 1
            ARRAY_BRUTO<Y.POS.BRUTO, 3> += ABS(J.AMOUNT)
            FIND TMP_CTA_STR IN ARRAY_CHECK SETTING Ap2, Vp2 ELSE
                ARRAY_BRUTO<Y.POS.BRUTO, 5> += 1
                ARRAY_CHECK<-1> = TMP_CTA_STR
            END
        END ELSE
            ARRAY_BRUTO<-1> = PERIODO : SP : CONST_CLV_ENT : SP : FORMULARIO.2441 : @VM  : TMP_STR : @VM : ABS(J.AMOUNT) : @VM : 1 : @VM : 1
            ARRAY_CHECK<-1> = TMP_CTA_STR
        END
        J.ARR.CTAS = ARRAY_BRUTO
    END

RETURN

*********************
AGRUPACION.ARR.R2442:
*********************

    IF J.CANAL NE '' AND J.TIPO.OPER NE '' THEN
        Y.TMP = ID.AC:',':J.TIPO.CTA:',':J.CANAL:',':J.TIPO.OPER
        Y.TMP.2 =  J.TIPO.CTA:',':J.CANAL:',':J.TIPO.OPER
        FIND Y.TMP.2 IN Y.ARR.AGR SETTING Apf, Vpf ELSE
            Y.ARR.AGR<-1> = Y.TMP.2
        END
        FIND Y.TMP IN J.ARR.CTAS.R2442 SETTING Ape,Vpe THEN
            Y.NUM.OP = J.ARR.CTAS.R2442<Ape,3> * 1
            Y.NUM.OP += 1
            Y.FREQ = ''
            BEGIN CASE
                CASE Y.NUM.OP EQ 1
                    Y.FREQ = '461'
                CASE Y.NUM.OP GE 2 AND Y.NUM.OP LE 5
                    Y.FREQ = '462'
                CASE Y.NUM.OP GE 6 AND Y.NUM.OP LE 10
                    Y.FREQ = '463'
                CASE Y.NUM.OP GT 10
                    Y.FREQ = '464'
            END CASE
            J.ARR.CTAS.R2442<Ape,3> = Y.NUM.OP
            J.ARR.CTAS.R2442<Ape,2> = Y.FREQ
        END ELSE
            Y.NUM.OP = 1
            Y.FREQ = ''
            Y.FREQ = '461'
            J.ARR.CTAS.R2442<-1> = Y.TMP:@VM:Y.FREQ:@VM:Y.NUM.OP
        END
    END

RETURN

**************
ARM.ARR.FINAL:
**************

    Y.ARR.FINAL = ''
    FOR X=1 TO DCOUNT(Y.ARR.AGR,@FM)
        Y.START.POS = 1
        Y.COUNT = COUNT(J.ARR.CTAS.R2442,Y.ARR.AGR<X>)
        FOR Y=1 TO Y.COUNT
            FINDSTR Y.ARR.AGR<X> IN J.ARR.CTAS.R2442,Y.START.POS SETTING Apx,Vpx THEN
                Y.START.POS = Apx + 1
                Y.FREQ = J.ARR.CTAS.R2442<Apx,2>
                Y.CNT.FIN = COUNT(J.ARR.CTAS.R2442,Y.ARR.AGR<X>:@VM:Y.FREQ)
                FINDSTR Y.ARR.AGR<X>:',':Y.FREQ IN Y.ARR.FINAL SETTING Ap2,Vp2 ELSE
                    Y.ARR.FINAL<-1> = PERIODO:',':CLAVE.ENT:',':FORMULARIO.2442:',':Y.ARR.AGR<X>:',':Y.FREQ:',':Y.CNT.FIN
                END
            END

        NEXT Y
    NEXT X

RETURN

**************
CALCULA.FECHA:
**************

    NUMERO.DIAS.PERIODO = ''
    FECHA.SISTEMA = ''
    PERIODO = ''
    FEC.FIN.PER = ''
    FEC.INI.PER = ''

    FECHA.SISTEMA = EB.SystemTables.getToday()
    FEC.FIN.PER = EB.SystemTables.getToday()
    FEC.INI.PER = FEC.FIN.PER[1,6]:'01'
    PERIODO = FEC.INI.PER[1,6]
    NUMERO.DIAS.PERIODO = 'C'
    EB.API.Cdd('',FEC.INI.PER,FEC.FIN.PER,NUMERO.DIAS.PERIODO)

RETURN

END
