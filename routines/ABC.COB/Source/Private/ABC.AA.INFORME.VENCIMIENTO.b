* @ValidationCode : MjoxNzM2MzEzOTUzOkNwMTI1MjoxNzY3MTQyNTU3NjA2OkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 30 Dec 2025 18:55:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcCob
SUBROUTINE ABC.AA.INFORME.VENCIMIENTO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* ======================================================================
* FyG Solutions
* Nombre de Programa : ABC.AA.INFORME.VENCIMIENTO
* Objetivo           : Rutina que genera un archivo de las inversiones que vencen
*                      en el dia.
* Desarrollador      : Cesar Miranda
* Compania           : ABC Capital
* Fecha Creacion     : 15 de Enero del 2025
* ======================================================================
*       Req:
*       Banco:       ABCCAPITAL
*       Autor:       Cesar Miranda (CAMB) FYG
*       Fecha:       6 Junio 2025
*       Descripcion: Se modifica la Rutina para mostrar el valor 0 en caso de que no
*                    se tenga retencion de ISR. Se modifica el nombre de los encabezados
*                    del archivo final.
*-----------------------------------------------------------------------------
*********************************************************************
* Company Name      : Uala
* Developed By      : FYG Solutions
* Product Name      : EB
*--------------------------------------------------------------------------------------------
* Subroutine Type : BATCH SERVICE
* Attached to : PGM.FILE>ABC.AA.INFORME.VENCIMIENTO
*               BATCH>ABC.INFORME.VENCIMIENTO
*
* Attached as : JOB EN COB A048
* Primary Purpose : Rutina para generacion de informe de vencimiento
*--------------------------------------------------------------------------------------------
*  Modification Details:
* -----------------------------
* 03/12/2025 - Migracion
*              Se aplican ajustes por cambio de infraestructura.
*              Se optimiza rutina para R24
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.Updates
    $USING AbcGetGeneralParam
    $USING EB.API
    $USING AA.Framework
    $USING EB.SystemTables
    $USING AbcTable
    $USING AbcBi
    $USING AA.PaymentSchedule
    $USING EB.Reports
    $USING EB.Utility
    $USING EB.AbcUtil
*-----------------------------------------------------------------------------
    GOSUB APERTURA.TABLAS
    GOSUB EXTRAE.PARAMAMETROS
    GOSUB SELECCIONA.CUENTAS
    GOSUB PROCESA.REPORTE
    GOSUB GENERA.ARCHIVO
    Y.NOMBRE.RUTINA = "ABC.AA.INFORME.VENCIMIENTO"
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.DATA.LOG)
*-----------------------------------------------------------------------------

RETURN

*------------------------
APERTURA.TABLAS:
*------------------------

    FN.ABC.AA.PRE.PROCESS = "F.ABC.AA.PRE.PROCESS"
    F.ABC.AA.PRE.PROCESS  = ""
    EB.DataAccess.Opf(FN.ABC.AA.PRE.PROCESS,F.ABC.AA.PRE.PROCESS)

    FN.STMT.ENTRY = "F.STMT.ENTRY"
    F.STMT.ENTRY  = ""
    EB.DataAccess.Opf(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.AA.SCHEDULED.ACTIVITY = "F.AA.SCHEDULED.ACTIVITY"
    F.AA.SCHEDULED.ACTIVITY  = ""
    EB.DataAccess.Opf(FN.AA.SCHEDULED.ACTIVITY,F.AA.SCHEDULED.ACTIVITY)
    
* Migracion - S
*APPL.ARR = "ABC.AA.PRE.PROCESS"
*FIELDNAME.ARR<1,1> = "EXT.TRANS.ID"
*FIELDNAME.ARR<1,2> = "CANAL.ENTIDAD"
*POS.ARR = ""
*EB.Updates.MultiGetLocRef(APPL.ARR,FIELDNAME.ARR,Y.POS.EXT.ID)
    EB.Updates.MultiGetLocRef("ABC.AA.PRE.PROCESS","EXT.TRANS.ID",Y.POS.EXT.ID)
    EB.Updates.MultiGetLocRef("ABC.AA.PRE.PROCESS","CANAL.ENTIDAD",Y.POS.CANAL)
*    Y.POS.EXT.ID = POS.ARR<1,1>
*    Y.POS.CANAL = POS.ARR<1,2>
* Migracion - E

RETURN

*-------------------
EXTRAE.PARAMAMETROS:
*-------------------

    Y.FECHA = EB.SystemTables.getToday()
    Y.DATA.LOG <-1> = Y.FECHA
    EB.API.Cdt('',Y.FECHA, "+1W")
    Y.ARR.NOM.PARAM = ''
    Y.ARR.DAT.PARAM = ''
    Y.SEP = ''
    Y.RUTA = ''
    Y.NOMBRE.ARCH = ''

    Y.ID.PARAM = 'ABC.AA.ARCHIVO.VENCIMIENTO'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.ARR.NOM.PARAM, Y.ARR.DAT.PARAM)
    NUM.LINEAS = DCOUNT(Y.ARR.NOM.PARAM,FM)

    LOCATE "SEPARADOR" IN Y.ARR.NOM.PARAM SETTING POS THEN
        Y.SEP = Y.ARR.DAT.PARAM<POS>
    END

    LOCATE "RUTA" IN Y.ARR.NOM.PARAM SETTING POS THEN
        Y.RUTA = Y.ARR.DAT.PARAM<POS>
    END

    LOCATE "NOMBRE.ARCHIVO" IN Y.ARR.NOM.PARAM SETTING POS THEN
        Y.NOMBRE.ARCH = Y.ARR.DAT.PARAM<POS>
        CHANGE 'TODAY' TO Y.FECHA IN Y.NOMBRE.ARCH
    END

    LOCATE "EXTENSION" IN Y.ARR.NOM.PARAM SETTING POS THEN
        Y.EXTENSION = Y.ARR.DAT.PARAM<POS>
    END

    LOCATE "RUTA.SECUNDARIA" IN Y.ARR.NOM.PARAM SETTING POS THEN
        Y.RUTA.SECUNDARIA = Y.ARR.DAT.PARAM<POS>
    END

    Y.NOMBRE.ARCHIVO = Y.NOMBRE.ARCH:Y.EXTENSION
    Y.ARCHIVO = Y.RUTA:"/":Y.NOMBRE.ARCHIVO
    Y.ARCHIVO.SECUNDARIO = Y.RUTA.SECUNDARIA:"/":Y.NOMBRE.ARCHIVO  ;*@PATH:"/":Y.RUTA.SECUNDARIA:"/":Y.NOMBRE.ARCHIVO ;* - Migracion

RETURN

*------------------
SELECCIONA.CUENTAS:
*------------------

    Y.CTA.INV = ''

    SELECT.CMD = "SELECT ":FN.AA.SCHEDULED.ACTIVITY:" WITH NEXT.DATE EQ ":Y.FECHA
    EB.DataAccess.Readlist(SELECT.CMD, Y.LIST.INV, '', NO.INV, Y.ERR.INV)
* Migracion - S
    X = 1
    LOOP
    WHILE X LE NO.INV
*    FOR X = 1 TO NO.INV
* Migracion - E
        ID.ACTIVITY = ''
        ID.ACTIVITY = Y.LIST.INV<X>
        ERROR.ACTIVITY = ''
        EB.DataAccess.FRead(FN.AA.SCHEDULED.ACTIVITY,ID.ACTIVITY,R.ACTIVITY,F.AA.SCHEDULED.ACTIVITY,ERROR.ACTIVITY)
        IF ERROR.ACTIVITY EQ '' THEN
            Y.NEXT.DATE = ''; Y.ACTIVITY.NAME = '';
            Y.NEXT.DATE.LIST = R.ACTIVITY<AA.Framework.ScheduledActivity.SchNextDate>
            Y.ACTIVITY.NAME.LIST = R.ACTIVITY<AA.Framework.ScheduledActivity.SchActivityName>

            CHANGE @VM TO @FM IN Y.NEXT.DATE.LIST
            CHANGE @VM TO @FM IN Y.ACTIVITY.NAME.LIST

            LOCATE 'DEPOSITS-MATURE-ARRANGEMENT' IN Y.ACTIVITY.NAME.LIST SETTING POS.ACT THEN
                Y.NEXT.DATE = Y.NEXT.DATE.LIST<POS.ACT>
            END

            IF Y.NEXT.DATE EQ Y.FECHA THEN
                LOCATE ID.ACTIVITY IN Y.ID.INV SETTING YPOS.INV ELSE
                    Y.ID.INV<-1> = ID.ACTIVITY
                END
            END
        END
* Migracion - S
        X++
    REPEAT
*    NEXT X
* Migracion - E
RETURN

*---------------
PROCESA.REPORTE:
*---------------

    Y.NO.INV = DCOUNT(Y.ID.INV,FM)
    YTR = 1
    LOOP
    WHILE YTR LE Y.NO.INV
*    FOR I = 1 TO Y.NO.INV  ;* - Migracion
        Y.ID.ARRANGEMENT = ''
        Y.ID.ARRANGEMENT = Y.ID.INV<YTR>
        Y.DATA.LOG <-1> = "Y.ID.ARRANGEMENT=":Y.ID.ARRANGEMENT
        IF Y.ID.ARRANGEMENT THEN
            GOSUB GET.PRE.PROCESS.RECORD ; *Obtiene el registro de la tabla ABC.AA.PRE.PROCESS usando el ID de ARRANGEMENT
            GOSUB CLEAN.VARIABLES ; *Limpieza de variables
            IF ERROR.PRE.PRO EQ '' THEN
                Y.EXT.TRANS.ID = R.PRE.PRO<AbcTable.AbcAaPreProcess.LocalRef,Y.POS.EXT.ID>
                Y.CANAL = R.PRE.PRO<AbcTable.AbcAaPreProcess.LocalRef,Y.POS.CANAL>
*            PRINT Y.EXT.TRANS.ID:", ":Y.CANAL
                Y.DATA.LOG <-1> = "Y.EXT.TRANS.ID=":Y.EXT.TRANS.ID
                Y.DATA.LOG <-1> = "Y.CANAL=":Y.CANAL
            END

            GOSUB VALIDA.CANAL
* Migracion - S
*    NEXT I
        END
        YTR++
    REPEAT
* Migracion - E
RETURN

*--------------
GENERA.ARCHIVO:
*--------------

******************************* INICIO CAMB 20250606 *******************************
*     ARR.REP = "Id Externo":Y.SEP:"ID Cliente":Y.SEP:"Id del Pagar�":Y.SEP:"Plazo":Y.SEP:"Fecha y hora de Inicio":Y.SEP
*     ARR.REP := "Fecha de fin":Y.SEP:"Descripci�n de Moneda":Y.SEP:"Tasa de Interes Bruta":Y.SEP:"Porcentaje ISR":Y.SEP
*     ARR.REP := "Porcentaje Neto":Y.SEP:"Ganancia Anual":Y.SEP:"Ganancia Real":Y.SEP:"Monto Capital Inicial":Y.SEP
*     ARR.REP := "Monto Interes total":Y.SEP:"Monto Capital Vencimiento":Y.SEP:"Monto Interes total":Y.SEP:"Monto ISR retenido":CHAR(13)
    ARR.REP = "EXT.TRANS.ID":Y.SEP:"ID.CLIENTE":Y.SEP:"ID.ARRANGEMENT":Y.SEP:"PLAZO":Y.SEP:"FECHA.INICIO":Y.SEP
    ARR.REP := "FECHA.FIN":Y.SEP:"MONEDA":Y.SEP:"TASA.BRUTA":Y.SEP:"TASA.ISR":Y.SEP
    ARR.REP := "TASA.NETA":Y.SEP:"GAT.NOMINAL":Y.SEP:"GAT.REAL":Y.SEP:"CAPITAL.INI":Y.SEP
    ARR.REP := "INTERES.NETO":Y.SEP:"CAPITAL.VENCI":Y.SEP:"INTERES.BRUTO":Y.SEP:"ISR":CHAR(10)
********************************* FIN CAMB 20250606 ********************************

    YNO.LINEA.REP = DCOUNT(Y.INVERSIONES.VENCIDAS,FM)
    CHANGE @FM TO CHAR(10) IN Y.INVERSIONES.VENCIDAS

    ARR.REP := Y.INVERSIONES.VENCIDAS

    ARCH.LOGICO = ''
    ARCH.LOGICO.SECUNDARIO = ''

    OPENSEQ Y.ARCHIVO TO ARCH.LOGICO ELSE
        CREATE ARCH.LOGICO ELSE
            DISPLAY "NO SE PUEDE CREAR ":Y.NOMBRE.ARCHIVO
            ARCH.LOGICO = ''
            OPENSEQ Y.ARCHIVO.SECUNDARIO TO ARCH.LOGICO ELSE
                CREATE ARCH.LOGICO ELSE
                    DISPLAY "NO SE PUEDE CREAR EN LA RUTA SECUNDARIA ":Y.NOMBRE.ARCHIVO
                END
            END
        END
    END

    WRITESEQ ARR.REP TO ARCH.LOGICO ELSE
        DISPLAY "ERROR AL ESCIBIR ":ARCH.LOGICO
    END
    CLOSESEQ ARCH.LOGICO        ;* - Migracion
RETURN

*-----------------------------------------------------------------------------

*** <region name= GET.PRE.PROCESS.RECORD>
GET.PRE.PROCESS.RECORD:
*** <desc>Obtiene el registro de la tabla ABC.AA.PRE.PROCESS usando el ID de ARRANGEMENT </desc>
    SEL.PRE.PRO = 'SELECT ':FN.ABC.AA.PRE.PROCESS:' WITH ARRANGEMENT.ID EQ ':DQUOTE(Y.ID.ARRANGEMENT)
    EB.DataAccess.Readlist(SEL.PRE.PRO,LISTA.PRE.PRO,'',TOTAL.PRE.PRO,ERROR.PRE.PRO)
    Y.DATA.LOG <-1> = "LISTA.PRE.PRO=":LISTA.PRE.PRO
    Y.DATA.LOG <-1> = "TOTAL.PRE.PRO=":TOTAL.PRE.PRO
    EB.DataAccess.FRead(FN.ABC.AA.PRE.PROCESS,LISTA.PRE.PRO,R.PRE.PRO,F.ABC.AA.PRE.PROCESS,ERROR.PRE.PRO)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= CLEAN.VARIABLES>
CLEAN.VARIABLES:
*** <desc>Limpieza de variables </desc>
    Y.EXT.TRANS.ID = ''
    Y.CANAL = ''
    Y.ID.CLIENTE = ''
    Y.PLAZO = ''
    Y.FECHA.INICIO = ''
    Y.FECHA.FIN = ''
    Y.MONEDA = ''
    Y.TASA.BRUTA = ''
    Y.TASA.ISR = ''
    Y.TASA.NETA = ''
    Y.GAT.NOMINAL = ''
    Y.GAT.REAL = ''
    Y.CAPITAL.INI = ''
    Y.INTERES.NETO = ''
    Y.CAPITAL.VENCI = ''
    Y.INTERES.BRUTO = ''
    Y.ISR = ''
    Y.RESUL = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= GET.DATA.ARRANGEMENT>
GET.DATA.ARRANGEMENT:
*** <desc> </desc>
    IF R.DATA NE '' THEN
        Y.ID.CLIENTE = FIELD(R.DATA,YSEP,2)
        Y.ID.ARRANGEMENT = FIELD(R.DATA,YSEP,8)
        Y.PLAZO = FIELD(R.DATA,YSEP,9)
        Y.FECHA.INICIO = FIELD(R.DATA,YSEP,10)
        Y.FECHA.FIN = FIELD(R.DATA,YSEP,11)
        Y.MONEDA = FIELD(R.DATA,YSEP,12)
        Y.TASA.BRUTA = FIELD(R.DATA,YSEP,13)
        Y.TASA.ISR = FIELD(R.DATA,YSEP,14)
        Y.TASA.NETA = FIELD(R.DATA,YSEP,15)
        Y.GAT.NOMINAL = FIELD(R.DATA,YSEP,16)
        Y.GAT.REAL = FIELD(R.DATA,YSEP,17)
        Y.CAPITAL.INI = FIELD(R.DATA,YSEP,18)
        Y.INTERES.NETO = FIELD(R.DATA,YSEP,20)
        Y.CAPITAL.VENCI = FIELD(R.DATA,YSEP,21)
* Migracion - S
        Y.DATA.LOG <-1> = "Y.ID.CLIENTE=":Y.ID.CLIENTE
        Y.DATA.LOG <-1> = "Y.ID.ARRANGEMENT=":Y.ID.ARRANGEMENT
        Y.DATA.LOG <-1> = "Y.PLAZO=":Y.PLAZO
        Y.DATA.LOG <-1> = "Y.FECHA.INICIO=":Y.FECHA.INICIO
        Y.DATA.LOG <-1> = "Y.FECHA.FIN=":Y.FECHA.FIN
        Y.DATA.LOG <-1> = "Y.MONEDA=":Y.MONEDA
        Y.DATA.LOG <-1> = "Y.TASA.BRUTA=":Y.TASA.BRUTA
        Y.DATA.LOG <-1> = "Y.TASA.ISR=":Y.TASA.ISR
        Y.DATA.LOG <-1> = "Y.TASA.NETA=":Y.TASA.NETA
        Y.DATA.LOG <-1> = "Y.GAT.NOMINAL=":Y.GAT.NOMINAL
        Y.DATA.LOG <-1> = "Y.GAT.REAL=":Y.GAT.REAL
        Y.DATA.LOG <-1> = "Y.CAPITAL.INI=":Y.CAPITAL.INI
        Y.DATA.LOG <-1> = "Y.INTERES.NETO=":Y.INTERES.NETO
        Y.DATA.LOG <-1> = "Y.CAPITAL.VENCI=":Y.CAPITAL.VENCI
* Migracion - E
    END
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= GET.SCHEDULE.DATA>
GET.SCHEDULE.DATA:
*** <desc> </desc>
    CYCLE.DATE = Y.FECHA.FIN[7,4]:Y.FECHA.FIN[4,2]:Y.FECHA.FIN[1,2]
* AA.PaymentSchedule.ScheduleProjector(Y.ID.ARRANGEMENT,"","",CYCLE.DATE,TOT.PAYMENT,DUE.DATES,"",DUE.TYPES,DUE.METHODS,DUE.TYPE.AMTS)
    AA.PaymentSchedule.ProjectScheduleProjector(Y.ID.ARRANGEMENT,"","",CYCLE.DATE,TOT.PAYMENT,DUE.DATES,"",DUE.TYPES,DUE.METHODS,DUE.TYPE.AMTS,DUE.PROPS,DUE.PROP.AMTS,DUE.OUTS,"","","","","","","","","")

    CHANGE @VM TO @FM IN DUE.TYPES
    CHANGE @VM TO @FM IN DUE.PROPS
    CHANGE @VM TO @FM IN DUE.PROP.AMTS

    LOCATE 'INTEREST' IN DUE.TYPES SETTING POS THEN
        Y.DUE.PROPS = DUE.PROPS<POS>
        Y.DUE.PROP.AMTS = DUE.PROP.AMTS<POS>

        CHANGE @SM TO @FM IN Y.DUE.PROPS
        CHANGE @SM TO @FM IN Y.DUE.PROP.AMTS

        LOCATE 'DEPOSITINT' IN Y.DUE.PROPS SETTING POS.INT THEN
            Y.INTERES.BRUTO = Y.DUE.PROP.AMTS<POS.INT>
        END

        LOCATE 'DEPOSITINT-TAX' IN Y.DUE.PROPS SETTING POS.TAX THEN
            Y.ISR = Y.DUE.PROP.AMTS<POS.TAX>
        END
    END
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= VALIDA.CANAL>
VALIDA.CANAL:
*** <desc> </desc>
    IF Y.CANAL EQ 13 THEN
        YSEP = '*'; R.DATA = '';
* Migracion - S
        EB.Reports.setDRangeAndValue(Y.ID.ARRANGEMENT)
        EB.Reports.setDFields('ID.ARRANGEMENT')
        EB.Reports.setLogicalOperands(1)
* Migracion - E
        AbcBi.AbcNofileImpresion(R.DATA)
        GOSUB GET.DATA.ARRANGEMENT
******************************* INICIO CAMB 20250606 *******************************
        Y.INTERES.BRUTO = 0
        Y.ISR = 0
********************************* FIN CAMB 20250606 ********************************
        GOSUB GET.SCHEDULE.DATA
        
        Y.RESUL<-1> = Y.EXT.TRANS.ID
        Y.RESUL<-1> = Y.ID.CLIENTE
        Y.RESUL<-1> = Y.ID.ARRANGEMENT
        Y.RESUL<-1> = Y.PLAZO
        Y.RESUL<-1> = Y.FECHA.INICIO
        Y.RESUL<-1> = Y.FECHA.FIN
        Y.RESUL<-1> = Y.MONEDA
        Y.RESUL<-1> = Y.TASA.BRUTA
        Y.RESUL<-1> = Y.TASA.ISR
        Y.RESUL<-1> = Y.TASA.NETA
        Y.RESUL<-1> = Y.GAT.NOMINAL
        Y.RESUL<-1> = Y.GAT.REAL
        Y.RESUL<-1> = Y.CAPITAL.INI
        Y.RESUL<-1> = Y.INTERES.NETO
        Y.RESUL<-1> = Y.CAPITAL.VENCI
        Y.RESUL<-1> = Y.INTERES.BRUTO
        Y.RESUL<-1> = Y.ISR
            
        CHANGE @FM TO Y.SEP IN Y.RESUL

        Y.INVERSIONES.VENCIDAS<-1> = Y.RESUL
    END
RETURN
*** </region>

END