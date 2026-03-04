* @ValidationCode : MjotNzU4MzA2NjQxOkNwMTI1MjoxNzYwMzk4NTAzNzgwOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Oct 2025 20:35:03
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
$PACKAGE AbcUdis
SUBROUTINE ABC.B.UDIS.CLEANUP
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.API
    $USING AbcTable
    $USING AbcSpei
    $USING AbcGetGeneralParam
    
    GOSUB INITIALIZE
    IF Y.DAY.TODAY EQ '01' THEN
        GOSUB PROCESS
        GOSUB FINALLY
    END
RETURN

*---------------------------------------------------------------
INITIALIZE:
*---------------------------------------------------------------
    SEL.CMD.CASHIN = ''
    Y.LISTA.IDS = ''
    Y.TOTAL.IDS = ''
    ERR.SEL = ''

    FN.ABC.UDIS.CONCAT = 'F.ABC.UDIS.CONCAT'
    F.ABC.UDIS.CONCAT =  ''
    FN.ABC.UDIS.CONCAT.HIS = 'F.ABC.UDIS.CONCAT.HIS'
    F.ABC.UDIS.CONCAT.HIS =  ''
    
    EB.DataAccess.Opf(FN.ABC.UDIS.CONCAT, F.ABC.UDIS.CONCAT)
    
    EB.DataAccess.Opf(FN.ABC.UDIS.CONCAT.HIS, F.ABC.UDIS.CONCAT.HIS)
    
    Y.FECHA = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R"):FMT(OCONV(DATE(), "DD"),"2'0'R")
    Y.HORA  = OCONV(TIME(), 'MTS')
    CHANGE ':' TO '' IN Y.HORA
    
    
    Y.ID.PARAM = 'ABC.B.UDIS.CLEANUP'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE "RUTA" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.RUTA = Y.LIST.VALUES<YPOS.PARAM>
    END
    LOCATE "FILE.NAME" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.FILE.NAME = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    Y.PATH = Y.RUTA
    Y.ARCHIVO.LOG = Y.FILE.NAME : Y.FECHA : Y.HORA
    yArchivoGuardar = Y.PATH : Y.ARCHIVO.LOG
    yIniciando = 1
    Y.TOTAL.LEIDOS = 0
    Y.TOTAL.NO.LEIDOS = 0
    Y.TODAY = EB.SystemTables.getToday()
    
    Y.DAY.TODAY = RIGHT(Y.TODAY, 2)
    Y.PERIODO = LEFT(Y.TODAY, 6) : '01'
    EB.API.Cdt('', Y.PERIODO, '-1C')
    Y.PERIODO = LEFT(Y.PERIODO, 6)

RETURN
*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    Y.FECHA = OCONV(DATE(), "DY4"):"-":FMT(OCONV(DATE(), "DM"),"2'0'R"):"-":FMT(OCONV(DATE(), "DD"),"2'0'R")
    Y.HORA  = OCONV(TIME(), 'MTS')
    Y.SALIDA.LOG = "Proceso inicia: " : Y.FECHA : " " : Y.HORA
    AbcSpei.PbsInslog(yArchivoGuardar, Y.SALIDA.LOG, yIniciando)
    yIniciando = 0
    
    SEL.CMD.UDIS  = 'SELECT ':FN.ABC.UDIS.CONCAT:' WITH @ID LIKE ':DQUOTE('...':SQUOTE(Y.PERIODO))
    EB.DataAccess.Readlist(SEL.CMD.UDIS, Y.LISTA.IDS, '', Y.TOTAL.IDS, ERR.SEL)
    
    Y.SALIDA.LOG = "Registros seleccionados " : Y.TOTAL.IDS
    AbcSpei.PbsInslog(yArchivoGuardar, Y.SALIDA.LOG, yIniciando)
    
    LOOP
        REMOVE Y.ID FROM Y.LISTA.IDS SETTING Y.POS
    WHILE Y.ID:Y.POS DO
        R.ABC.UDIS.CONCAT = AbcTable.AbcUdisConcat.Read(Y.ID, Error)
        IF NOT(Error) THEN
            EB.DataAccess.FWrite(FN.ABC.UDIS.CONCAT.HIS,Y.ID,R.ABC.UDIS.CONCAT)
            Y.TOTAL.LEIDOS = Y.TOTAL.LEIDOS + 1
            EB.DataAccess.FDelete(FN.ABC.UDIS.CONCAT,Y.ID)
        END ELSE
            Y.TOTAL.NO.LEIDOS = Y.TOTAL.NO.LEIDOS + 1
        END
    REPEAT
    

    Y.SALIDA.LOG        = "Total de registros leidos y escritos en HIS " : Y.TOTAL.LEIDOS
    
    AbcSpei.PbsInslog(yArchivoGuardar, Y.SALIDA.LOG, yIniciando)
    
    Y.SALIDA.LOG        = "Total de registros no leidos " : Y.TOTAL.NO.LEIDOS
    AbcSpei.PbsInslog(yArchivoGuardar, Y.SALIDA.LOG, yIniciando)
    
    SEL.CMD.UDIS  = 'DELETE ':FN.ABC.UDIS.CONCAT:' WITH @ID LIKE ':DQUOTE('...':SQUOTE(Y.PERIODO))
    EB.DataAccess.Readlist(SEL.CMD.UDIS, Y.LISTA.IDS, '', Y.TOTAL.IDS, ERR.SEL)

    Y.FECHA = OCONV(DATE(), "DY4"):"-":FMT(OCONV(DATE(), "DM"),"2'0'R"):"-":FMT(OCONV(DATE(), "DD"),"2'0'R")
    Y.HORA  = OCONV(TIME(), 'MTS')
    Y.SALIDA.LOG = "Proceso finaliza: " : Y.FECHA : " " : Y.HORA
    AbcSpei.PbsInslog(yArchivoGuardar, Y.SALIDA.LOG, yIniciando)

RETURN
*---------------------------------------------------------------
FINALLY:
*---------------------------------------------------------------

RETURN

