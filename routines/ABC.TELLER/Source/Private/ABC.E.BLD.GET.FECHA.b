* @ValidationCode : MjotMTA4MjkwODI2NjpDcDEyNTI6MTc2NTI0NDM5MDU2MDpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Dec 2025 22:39:50
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
SUBROUTINE ABC.E.BLD.GET.FECHA(ENQ.DATA)

    $USING AbcTable
    $USING EB.Reports
    $USING EB.Utility
    $USING EB.SystemTables
    $USING EB.API
    
* ======================================================================
* Nombre de Programa : ABC.E.BLD.GET.FECHA
* Parametros         :
* Objetivo           : Obtiene el @id con base en la fecha
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
    Y.FIELDS = RAISE(ENQ.DATA<2>)
    Y.VALUES = RAISE(ENQ.DATA<4>)

    LOCATE 'ABC.TT.ARQ.ID' IN Y.FIELDS SETTING Y.ABC.TT.ARQ.ID.POS THEN
        Y.FECHA = ENQ.DATA<4,Y.ABC.TT.ARQ.ID.POS>
    END

    LOCATE 'CAJERO' IN Y.FIELDS SETTING Y.CAJERO.POS THEN
        Y.CAJERO = ENQ.DATA<4,Y.CAJERO.POS>
    END



RETURN
*-----------------------------------------------------------------------------------------------------------
*------------------------------
ABRE.ARCHIVOS:
*------------------------------

RETURN
*-----------------------------------------------------------------------------------------------------------
*------------------------------
PROCESO:
*------------------------------
    IF LEN(Y.FECHA) EQ '8' THEN
        Y.FECHA.JULIANA = ''
        EB.API.Juldate(Y.FECHA, Y.FECHA.JULIANA)
        Y.FECHA.JULIANA = Y.FECHA.JULIANA[3,5]
        ENQ.DATA<2,Y.ABC.TT.ARQ.ID.POS> = 'ABC.TT.ARQ.ID'
        ENQ.DATA<3,Y.ABC.TT.ARQ.ID.POS> = 'LK'
        ENQ.DATA<4,Y.ABC.TT.ARQ.ID.POS> = 'TTARQ':Y.FECHA.JULIANA:'...'
    END

    IF LEN(Y.CAJERO) LT '4' THEN
        Y.CAJERO = FMT(Y.CAJERO,"R%4")
        ENQ.DATA<2,Y.CAJERO.POS> = 'CAJERO'
        ENQ.DATA<3,Y.CAJERO.POS> = 'EQ'
        ENQ.DATA<4,Y.CAJERO.POS> = Y.CAJERO
    END


RETURN
*-----------------------------------------------------------------------------------------------------------
END
