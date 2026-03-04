* @ValidationCode : MjotODEzODU3MDQ3OkNwMTI1MjoxNzY4MjU2OTc4Njc1OkVkZ2FyIFNhbmNoZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jan 2026 16:29:38
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

SUBROUTINE ABC.CONTROLBOX.MULTI.XML.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*======================================================================================
* Nombre de Programa : ABC.CONTROLBOX.MULTI.XML.SELECT
* Objetivo           : Se requiere conversi�n a multithreat para extraer informacion de
*                      customer y account en archivos XML para alimentar el sistema CONTROLBOX
* Desarrollador      : C�sar Miranda - FyG Solutions
* Fecha Creacion     : 2023-11-13
*======================================================================================
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.API
    $USING EB.AbcUtil
    
    GOSUB SELECCIONA.CLIENTES
    GOSUB ESCRIBE.LOG
RETURN

********************
SELECCIONA.CLIENTES:
********************
    yDataLog = ''
   
    yDataLog<-1> = 'Inicia Ejecucion de SELECT'
*   PRINT 'FN.CLIENTE ' : TIMEDATE()
    Y.ULTIMA_FECHA_EXTRAC = AbcCob.getYUltimaFechaExtrac()
    FN.CLIENTE = AbcCob.getFnCustomerCB()
    Y.CATEGORIAS = AbcCob.getYCategoriasCB()
    FN.CUENTA = AbcCob.getFnAccountCB()
    
    SEL.CMD.CUS = 'SSELECT ':FN.CLIENTE:' WITH DATE.TIME GE ':DQUOTE(Y.ULTIMA_FECHA_EXTRAC)
    EB.DataAccess.Readlist(SEL.CMD.CUS,Y.REC.CLIENTES,'',Y.NO.CLIENTES,Y.CUS.ERROR)   ;*Me trae los registros por su id
    yDataLog<-1> = 'SELECT -> ': SEL.CMD.CUS : ' NO.CLIENTES: ' : Y.NO.CLIENTES
    Y.CATEGORY = Y.CATEGORIAS
    Y.CANT.CATEGORY = DCOUNT(Y.CATEGORY,@FM)
    yDataLog<-1> := 'Y.CANT.CATEGORY--> ':Y.CANT.CATEGORY
*CHANGE @FM TO '" "' IN Y.CATEGORY

    FOR Y = 1 TO Y.CANT.CATEGORY
        IF (Y EQ 1) THEN
            Y.MENSAJE = '(CATEGORY = ':Y.CATEGORY
        END ELSE
            Y.MENSAJE := ' OR CATEGORY = ':Y.CATEGORY
        END
    NEXT Y
    Y.MENSAJE := ')'
    yDataLog<-1> :='**********MENSAJE*******':Y.MENSAJE
    
*    PRINT 'FN.CUENTA ' : TIMEDATE()
*   SEL.CMD.ACC = 'SELECT ':FN.CUENTA:' WITH CATEGORY IN (':DQUOTE(Y.CATEGORY):') AND DATE.TIME GE ':DQUOTE(Y.ULTIMA_FECHA_EXTRAC)
    SEL.CMD.ACC = 'SELECT ':FN.CUENTA:' WITH ':Y.MENSAJE:' AND DATE.TIME GE ':DQUOTE(Y.ULTIMA_FECHA_EXTRAC)
    SEL.CMD.ACC := ' SAVING UNIQUE CUSTOMER'
    yDataLog<-1> :='**********SEL.CMD.ACC******* ':SEL.CMD.ACC
    
*SEL.CMD.ACC = 'SELECT ':FN.CUENTA:' WITH (CATEGORY = 1004 OR CATEGORY = 6001 OR CATEGORY = 1006 OR CATEGORY = 1014 OR CATEGORY = 6006 OR CATEGORY = 6007 OR CATEGORY = 6008) AND DATE.TIME GE "2507310000" SAVING UNIQUE CUSTOMER'
    EB.DataAccess.Readlist(SEL.CMD.ACC,Y.REC.CUENTAS,'',Y.NO.CUENTAS,Y.ACC.ERROR)     ;*Me trae los registros por su id
    yDataLog<-1> = 'SELECT -> ': SEL.CMD.ACC : ' NO.CUENTAS: ' Y.NO.CUENTAS
    yDataLog<-1> = '*********SEL.CMD.ACC*********--> :':SEL.CMD.ACC
    yDataLog<-1> = '////////// resultado SEL.CMD.ACC--> :':Y.NO.CUENTAS
    LISTA.AUX = Y.REC.CLIENTES:@FM:Y.REC.CUENTAS
    NO.TOTAL = Y.NO.CLIENTES+Y.NO.CUENTAS
    LISTA.ARCH = LISTA.AUX

    CHANGE @FM TO CHAR(10) IN LISTA.ARCH

*    PRINT 'INICIO CUENTAS ' : TIMEDATE()

    LISTA.AUX.SORT = SORT(LISTA.AUX)

*    PRINT "SORT " : TIMEDATE()
    Y.CLIENTE.ID.AUX = ''
    NUM.FINAL = 0
*    FOR Y.COUNT = 1 TO NO.TOTAL
    FOR Y.COUNT = 1 TO NO.TOTAL
        Y.CLIENTE.ID = LISTA.AUX.SORT<Y.COUNT>
        IF Y.CLIENTE.ID NE Y.CLIENTE.ID.AUX THEN
            LISTA.FINAL<-1> = Y.CLIENTE.ID
            NUM.FINAL += 1
            Y.CLIENTE.ID.AUX = Y.CLIENTE.ID
        END
    NEXT Y.COUNT
    
    yDataLog<-1> := '********LISTA.FINAL**********':LISTA.FINAL
    EB.Service.BatchBuildList('',LISTA.FINAL)

*    PRINT 'FIN CUENTAS ' : TIMEDATE()
    yDataLog<-1> = 'Termina Ejecucion de SELECT'
    GOSUB ESCRIBE.LOG
    
    
RETURN

*-----------------------------------------------------------------------------;*
ESCRIBE.LOG:
*-----------------------------------------------------------------------------
    yRtnName = 'ABC.CONTROLBOX.XML'
 
    EB.AbcUtil.abcEscribeLogGenerico(yRtnName, yDataLog)


    
RETURN

END