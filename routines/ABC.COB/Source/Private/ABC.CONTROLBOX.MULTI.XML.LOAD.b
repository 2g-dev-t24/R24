* @ValidationCode : MjoxMjEwMjEyMDAxOkNwMTI1MjoxNzY3NzI5NzQ2MTIwOkVkZ2FyIFNhbmNoZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Jan 2026 14:02:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar Sanchez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcCob

SUBROUTINE ABC.CONTROLBOX.MULTI.XML.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*======================================================================================
* Nombre de Programa : ABC.CONTROLBOX.MULTI.XML.LOAD
* Objetivo           : Se requiere conversi�n a multithreat para extraer informacion de
*                      customer y account en archivos XML para alimentar el sistema CONTROLBOX
* Desarrollador      : C�sar Miranda - FyG Solutions
* Fecha Creacion     : 2023-11-13
*======================================================================================
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING EB.Updates
    
    
    GOSUB INICIO
    GOSUB OBTIENE.VARIABLES

RETURN
 
***************
INICIO:
***************
    FN.CLIENTE = 'F.CUSTOMER'
    F.CLIENTE  = ''
    EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)
    AbcCob.setFnCustomerCB(FN.CLIENTE)
    AbcCob.setFCustomerCB(F.CLIENTE)

    FN.CUENTA = 'F.ACCOUNT'
    F.CUENTA  = ''
    EB.DataAccess.Opf(FN.CUENTA,F.CUENTA)
    AbcCob.setFnAccountCB(FN.CUENTA)
    AbcCob.setFAccountCB(F.CUENTA)

    FN.ABC.GENERAL.PARAM ='F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM  =''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    FN.CUS.ACC  = 'F.CUSTOMER.ACCOUNT'
    F.CUS.ACC   = ''
    EB.DataAccess.Opf(FN.CUS.ACC,F.CUS.ACC)
    AbcCob.setFnCustomerAccountCB(FN.CUS.ACC)
    AbcCob.setFCustomerAccountCB(F.CUS.ACC)
    
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)
    AbcCob.setFnAbcAcctLclFldsCB(FN.ABC.ACCT.LCL.FLDS)
    AbcCob.setFAbcAcctLclFldsCB(F.ABC.ACCT.LCL.FLDS)
 
    Y.ID.PARAM            = 'ABC.CONTROLBOX'

RETURN


******************
OBTIENE.VARIABLES:
******************

    Y.DIA.EXTRACCION = OCONV(DATE(), "D-YMD[4,2,2]")
    CHANGE '-' TO '' IN Y.DIA.EXTRACCION
        
    Y.HORA.EXTRACCION = TIMEDATE()
    Y.HORA.EXTRACCION.LOG = OCONV(TIME(), "MTS")
    CHANGE ':' TO '' IN Y.HORA.EXTRACCION

    Y.HORA.EXTRACCION=Y.HORA.EXTRACCION[1,6]

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)        ;*LEE PARAMETRIZACION PARA EXTRAER INFORMACION

    Y.NUM.LIST.PARAMS = DCOUNT(Y.LIST.PARAMS,@FM)

    IF Y.NUM.LIST.PARAMS GT 0 THEN
        LOCATE "CATEGORIAS_CUENTA" IN Y.LIST.PARAMS SETTING LOC THEN
            Y.CATEGORIAS = TRIM(Y.LIST.VALUES<LOC>)
*CHANGE ',' TO @FM IN Y.CATEGORIAS
            LOC=''
            AbcCob.setYCategoriasCB(Y.CATEGORIAS)
        END
        LOCATE "LIMITE_REGISTROS_POR_ARCHIVO" IN Y.LIST.PARAMS SETTING LOC THEN
            LIMITE = TRIM(Y.LIST.VALUES<LOC>)
            LIMITE.TEMP = LIMITE
            LOC=''
        END
        LOCATE "RUTA_ARCHIVO_XML" IN Y.LIST.PARAMS SETTING LOC THEN
            Y.RUTA_ARCHIVO_XML = TRIM(Y.LIST.VALUES<LOC>)
*CALL ABC.OBTIENE.RUTA.ABS(Y.RUTA_ARCHIVO_XML)
            LOC=''
            AbcCob.setYRutaArchivoXmlCB(Y.RUTA_ARCHIVO_XML)
        END
        LOCATE "RUTA_CONTROLBOX_LOG" IN Y.LIST.PARAMS SETTING LOC THEN
            Y.RUTA_CONTROLBOX_LOG = TRIM(Y.LIST.VALUES<LOC>)
            LOC = ''
            Y.RUTA_CONTROLBOX_LOG = Y.RUTA_ARCHIVO_XML:"Log"
            
*CALL ABC.OBTIENE.RUTA.ABS(Y.RUTA_CONTROLBOX_LOG)
            LOC=''
        END
        LOCATE "NOMBRE_ARCHIVO_XML" IN Y.LIST.PARAMS SETTING LOC THEN
            Y.NOMBRE_ARCHIVO_XML = TRIM(Y.LIST.VALUES<LOC>)
            LOC=''
            AbcCob.setYNombreArchivoXmlCB(Y.NOMBRE_ARCHIVO_XML)
        END
        LOCATE "FECHA_PRIMERA_EXTRACCION" IN Y.LIST.PARAMS SETTING LOC THEN     ;* TOMA LA FECHA DE LA PRIMERA EXTRACCION
            Y.FECHA_PRIMER_EXTRAC = TRIM(Y.LIST.VALUES<LOC>)

            Y.POS.FECHA_PRIMER_EXTRAC = LOC
            LOC=''
        END
        LOCATE "ULTIMA_EXTRACCION_SATISFACTORIA" IN Y.LIST.PARAMS SETTING LOC THEN
            Y.POS.ULT_EXTRAC_SATISFAC=LOC
            Y.ULTIMA_EXTRACCION = TRIM(Y.LIST.VALUES<LOC>)
            IF Y.ULTIMA_EXTRACCION NE '' AND Y.ULTIMA_EXTRACCION NE 'YYYYMMDD' THEN
                Y.ULTIMA_EXTRACCION = TRIM(Y.LIST.VALUES<LOC>)[3,8]:'0000'
            END
            LOC=''
        END
    END

    IF Y.RUTA_ARCHIVO_XML NE '' THEN
        Y.RUTA_ARCHIVO_XML_TEMP = Y.RUTA_ARCHIVO_XML:"TEMP/"
        Y.RUTA_ARCHIVO_XML_ERR = Y.RUTA_ARCHIVO_XML:"ERROR/"
        
;*esanchezg20260106 si no existe el directorio se crea.
        Y.CMD.MK = 'SH -c mkdir ' : Y.RUTA_ARCHIVO_XML_TEMP
        EXECUTE Y.CMD.MK CAPTURING Y.RESPONSE.MK
    
        Y.CMD.MK.ERR = 'SH -c mkdir ' : Y.RUTA_ARCHIVO_XML_ERR
        EXECUTE Y.CMD.MK.ERR CAPTURING Y.RESPONSE.MK.ERR
        
        Y.CMD.MK.LOG = 'SH -c mkdir ' : Y.RUTA_CONTROLBOX_LOG
        EXECUTE Y.CMD.MK.LOG CAPTURING Y.RESPONSE.MK.LOG
    
;*esanchezg20260106 fin de modificacion
        AbcCob.setYRutaArchivoXmlTempCB(Y.RUTA_ARCHIVO_XML_TEMP)
        AbcCob.setYRutaArchivoXmlErrorCB(Y.RUTA_ARCHIVO_XML_ERR)
    END
    TODAY   = EB.SystemTables.getToday()
    IF Y.FECHA_PRIMER_EXTRAC EQ TODAY OR Y.ULTIMA_EXTRACCION EQ '' OR Y.ULTIMA_EXTRACCION EQ 'YYYYMMDD' THEN  ;*ES LA PRIMERA VEZ QUE CORRE -> TOMO TODOS LOS CLIENTES
        Y.ULTIMA_FECHA_EXTRAC = '0001010000'
    END ELSE        ;*SOLO TOMO LOS CLIENTES QUE HAN SUFRIDO MODIFICACIONES A PARTIR DE LA TIMA FECHA
        Y.ULTIMA_FECHA_EXTRAC = Y.ULTIMA_EXTRACCION         ;*CON UN LOCATE LA TOMO DE DONDE LA ESCRIB*        Y.PRIMERA_EJEC = '0'
    END
    AbcCob.setYUltimaFechaExtrac(Y.ULTIMA_FECHA_EXTRAC)

    Y.NO.CAT = DCOUNT(Y.CATEGORIAS,',')
    AbcCob.setYNoCatCB(Y.NO.CAT)
*    AbcCob.setYDiaExtraccionCB(Y.DIA.EXTRACCION)
    AbcCob.setYDiaExtraccionCB(EB.SystemTables.getToday()) ;* esanchezg20251204
RETURN

END

