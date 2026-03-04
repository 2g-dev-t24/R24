* @ValidationCode : MjotNzUxMzU4ODc3OkNwMTI1MjoxNzY2NTQwMzcxNTI4OkVkZ2FyIFNhbmNoZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 Dec 2025 19:39:31
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

******************************************************************
$PACKAGE EB.AbcIdeControlEod
SUBROUTINE ABC.IDE.CONTROL.MOV.SELECT
******************************************************************
*----------------------------------------------------------------------------
* Autor         : Jesus Hernandez JHF - FyG
* Fecha         : 09/02/2017
* DESCRIPCION:    EXTRAE TODOS LOS MOVIMIENTOS DEL CLIENTE DURANTE EL MES
*                 POR CADA CUENTA EXISTENTE, Y COMPARA CONTRA LAS TRANSACCIONES
*                 VALIDAS PARA EL TIPO DE PERSONA (FISICA O MORAL) SEGUN LOS
*                 PARAMETROS ESTABLECIDOS Y EXCEPCIONES MARCADAS
*----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.API
    $USING ST.Customer
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING EB.Service
    $USING EB.Interface
    $USING EB.Template
    $USING EB.AbcUtil
    
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*----------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------
    yDataLog = ''
    Y.LISTA.FINAL = ''
    FN.EB.CONTRACT.BALANCES = EB.AbcIdeControlEod.getFnEbContractBalances()
    CAD.FECHAS = EB.AbcIdeControlEod.getCadFechas()
    
    SEL.CTA = "SELECT ": FN.EB.CONTRACT.BALANCES
    SEL.CTA:= " WITH ACTIVITY.MONTHS LIKE  ...": CAD.FECHAS<1>[1,6] :"..."
    
    yDataLog<-1> = "Rutina LOAD"
    yDataLog<-1> = "SELECT-> ": SEL.CTA
    EB.DataAccess.Readlist(SEL.CTA,LISTA.CTA,'',NO.CTA,'')
    yDataLog<-1> = "NO.CTAS-> ": NO.CTA
    IF LISTA.CTA THEN
        FOR I.CTA = 1 TO DCOUNT(LISTA.CTA, @FM)
            yDataLog<-1> = "CUENTA -> ": LISTA.CTA<I.CTA>
            NUM.CTA = LISTA.CTA<I.CTA>
*            READ REC.CTA FROM F.ACCOUNT, NUM.CTA THEN
            Y.ERROR = ''
            REC.CTA = AC.AccountOpening.Account.Read(NUM.CTA, Y.ERROR)
            yDataLog<-1> = "REC.CTA -> ": REC.CTA
            IF Y.ERROR EQ '' THEN
                NUM.CATEG = REC.CTA<AC.AccountOpening.Account.Category>
                PS.CATEG = ''
                CAD.CATEG = EB.AbcIdeControlEod.getCadCateg()
                LOCATE NUM.CATEG IN CAD.CATEG SETTING PS.CATEG THEN
*NUM.CLIE = REC.CTA<AC.CUSTOMER>
                    NUM.CLIE = REC.CTA<AC.AccountOpening.Account.Customer>
                    yDataLog<-1> = "NUM.CLIE -> ": NUM.CLIE
                    LOCATE NUM.CLIE IN CAD.TOTAL.CLIENTES SETTING PS.CLIE THEN
                        Y.STR.CTA = CAD.TOTAL.CUENTAS<PS.CLIE>
                        Y.STR.CTA = RAISE(Y.STR.CTA)
                        LOCATE NUM.CTA IN Y.STR.CTA SETTING PS.CTA ELSE
                            Y.ARR.CUENTAS =  ''
                            Y.CLIENTE  = ''
                            CAD.TOTAL.CUENTAS<PS.CLIE,-1> = NUM.CTA
                            
                            Y.VALOR = Y.LISTA.FINAL<PS.CLIE>
                            Y.CLIENTE   = FIELD(Y.LISTA.FINAL<PS.CLIE>,'|',1)
                            Y.ARR.CUENTAS = FIELD(Y.LISTA.FINAL<PS.CLIE>,'|',2)
                            Y.ARR.CUENTAS  := '*':NUM.CTA
                            Y.LISTA.FINAL<PS.CLIE> = Y.CLIENTE:'|':Y.ARR.CUENTAS
                            Y.VALOR = Y.LISTA.FINAL<PS.CLIE>
                        END
                    END ELSE
                        CAD.TOTAL.CLIENTES<-1> = NUM.CLIE
                        TOT.CLIE = DCOUNT(CAD.TOTAL.CLIENTES, @FM)
                        CAD.TOTAL.CUENTAS<TOT.CLIE, -1> = NUM.CTA
                        Y.LISTA.FINAL<-1> = NUM.CLIE:'|':NUM.CTA
                    END
                END
            END ELSE
                CAD.MSG.PROC<-1> = "CUENTA ": NUM.CTA :" NO EXISTE, ESTA EN HISTORIA, PROBABLE ERROR"
                yDataLog<-1> = "CUENTA ": NUM.CTA :" NO EXISTE, ESTA EN HISTORIA, PROBABLE ERROR"
            END
        NEXT
    END ELSE
        CAD.MSG.PROC<-1> = "NO EXISTEN CUENTAS A CONSULTAR, PROBABLE ERROR"
        yDataLog<-1> = "NO EXISTEN CUENTAS A CONSULTAR, PROBABLE ERROR"
    END
  
    FN.ABC.IDE.SALDOS.CLIE = EB.AbcIdeControlEod.getFnAbcIdeSaldosClie()
    SEL.CTE.ANT = "SSELECT ": FN.ABC.IDE.SALDOS.CLIE
    EB.DataAccess.Readlist(SEL.CTE.ANT,LISTA.CTE.ANT,'',NO.CTE.ANT.AUX, '')
    yDataLog<-1> = "SELECT-> ":SEL.CTE.ANT
    yDataLog<-1> = "Numero de Registros sin filtrar-> ":NO.CTE.ANT.AUX
;*ID Clientes unicos
    LISTA.CTE.ANT.AUX = ''
    Y.ULTIMO = ''
    FOR Y.AA = 1 TO  NO.CTE.ANT.AUX
        Y.ID.AUX = FIELD(LISTA.CTE.ANT<Y.AA>,'.',1)
        IF Y.ULTIMO NE Y.ID.AUX THEN
            Y.ULTIMO = Y.ID.AUX
            LISTA.CTE.ANT.AUX<-1> = Y.ID.AUX
        END
    NEXT Y.AA
       
    NO.CTE.ANT = DCOUNT(LISTA.CTE.ANT.AUX,@FM)
    yDataLog<-1> = 'ABC.IDE.SALDOS.CLIE Unicos = : ':NO.CTE.ANT
    LISTA.CTE.ANT = LISTA.CTE.ANT.AUX
    
*;Fin de Clientes unicos
    IF LISTA.CTE.ANT THEN
        FOR I.SCLIE = 1 TO NO.CTE.ANT
            Y.TMP.CLIE = LISTA.CTE.ANT<I.SCLIE>
            Y.ERROR = ''

            REC.CUSACT = AC.AccountOpening.CustomerAccount.Read(Y.TMP.CLIE, Y.ERROR)
            IF Y.ERROR EQ '' THEN
                LOCATE Y.TMP.CLIE IN CAD.TOTAL.CLIENTES SETTING PS.TCL ELSE

                    Y.TMP.STR.CTA = ''
                    FOR I.SCTA = 1 TO DCOUNT(REC.CUSACT, @FM)
                        Y.TMP.CTA = REC.CUSACT<I.SCTA>
                        Y.TMP.CTA = EB.AbcIdeControlEod.getYTmpCta()
                        Y.TMP.STR.CTA<1,-1> = Y.TMP.CTA
                    NEXT
                    IF Y.TMP.STR.CTA THEN
                        CAD.TOTAL.CLIENTES<-1> = Y.TMP.CLIE
                        TOT.CLIE = DCOUNT(CAD.TOTAL.CLIENTES,@FM)
                        CAD.TOTAL.CUENTAS<TOT.CLIE, -1> = Y.TMP.STR.CTA
                        CONVERT @VM TO "*" IN Y.TMP.STR.CTA
                        Y.LISTA.FINAL<-1> = NUM.CLIE:'|':Y.TMP.STR.CTA
                    END
                END

            END ELSE
                CAD.MSG.PROC0<-1> = "CLIENTE ": Y.TMP.CLIE :" NO TIENE CUENTAS LIGADAS"
                yDataLog<-1> = "CLIENTE ": Y.TMP.CLIE :" NO TIENE CUENTAS LIGADAS"
            END
        NEXT
    END ELSE
        CAD.MSG.PROC<-1> = "NO EXISTEN CLIENTES EN TABLA DE SALDOS-CLIENTE"
        yDataLog<-1> = "NO EXISTEN CLIENTES EN TABLA DE SALDOS-CLIENTE"
    END
      
    Y.LISTA.TOT = Y.LISTA.FINAL
    
    yDataLog<-1> = "Y.LISTA.FINAL-> " : Y.LISTA.FINAL
    yDataLog<-1> = "Y.LISTA.TOT-> " : Y.LISTA.TOT
    
    EB.Service.BatchBuildList('',Y.LISTA.TOT)
    yRtnName = 'ABC.IDE.CONTROL.EOD'
    EB.AbcUtil.abcEscribeLogGenerico(yRtnName, yDataLog)
    
RETURN
*----------------------------------------------------------------------------
FINALLY:
*----------------------------------------------------------------------------
RETURN
END
