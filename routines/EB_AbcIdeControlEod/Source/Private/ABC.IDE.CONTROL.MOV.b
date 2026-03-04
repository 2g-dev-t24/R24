* @ValidationCode : MjotMTU5NzU1MDAwOkNwMTI1MjoxNzY2NTQwNDM0MDY2OkVkZ2FyIFNhbmNoZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 Dec 2025 19:40:34
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
SUBROUTINE ABC.IDE.CONTROL.MOV(Y.ID)
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
    $USING AC.EntryCreation
    $USING BF.ConBalanceUpdates
    $USING EB.Security
    $USING MXBASE.CustomerRegulatory
    $USING EB.Reports
    $USING AC.ModelBank
    $USING ABC.BP
    $USING AbcTable
    $USING AbcCob
    $USING EB.Interface
    
    $USING EB.AbcUtil
    
    GOSUB MOV.CLIE.CTA
    GOSUB FINALLY

RETURN

*----------------------------------------------------------------------------
MOV.CLIE.CTA:
*----------------------------------------------------------------------------
    
    yDataLog = ''
    
    yDataLog<-1> = 'Inicia cobro IDE'
    OPERATOR = EB.SystemTables.getOperator()
    TNO = ''
    TNO = EB.Service.getAgentNumber()
    USER.DEPT.CODE = ''
    R.ERROR = ''
    
    R.USER =EB.Security.User.Read(OPERATOR,R.ERROR)
    IF R.ERROR EQ '' THEN
        USER.DEPT.CODE = R.USER<EB.Security.User.UseDeptCode>
    END
    
    yDataLog<-1>= "Y.ID -> ": Y.ID
    CAD.TOTAL.CLIENTES = FIELD(Y.ID,'|',1)
    CAD.TOTAL.CUENTAS = FIELD(Y.ID,'|',2)
    CONVERT "*" TO @VM IN CAD.TOTAL.CUENTAS
    
    IF CAD.TOTAL.CLIENTES THEN
        IF CAD.TOTAL.CUENTAS THEN
            
            CAD.MSG.PROC<-1> = "EXISTEN CUENTAS-CLIENTES PARA CONSULTAR EN EL PERIODO"
            yDataLog<-1> = "EXISTEN CUENTAS-CLIENTES PARA CONSULTAR EN EL PERIODO"
            CAD.CLIE.MTO = ''
            CAD.CLIE.CONT = 0
            CAD.CLIE.TRANS = ''

            CAD.CLIE.FEC = ''
            CAD.CLIE.COD.TRANS = ''
            CAD.CLIE.CTA = ''
            CAD.CLIE.MONTO = ''
            CAD.MOV.DEP = ''

            X.CLIE = CAD.TOTAL.CLIENTES ;*<J.CLIE>         ;* EXTRAE EL CLIENTE DE LA CADENA FORMADA PREVIAMENTE
            X.CAD.CTA = CAD.TOTAL.CUENTAS         ;*<J.CLIE>       ;* EXTRAE LAS CUENTAS PARA EL CLIENTE SELECCIONADO

            CAD.MSG.PROC<-1> = "----------- PROCESANDO CLIENTE ": 1 :"/": DCOUNT(CAD.TOTAL.CLIENTES, @FM) :", CLIENTE = ": X.CLIE
            yDataLog<-1>= "----------- PROCESANDO CLIENTE ": 1 :"/": DCOUNT(CAD.TOTAL.CLIENTES, @FM) :", CLIENTE = ": X.CLIE
            yDataLog<-1> = "EXISTEN CUENTAS-CLIENTES PARA CONSULTAR EN EL PERIODO"
            Y.ERROR = ''
            REC.CLI = MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.Read(X.CLIE, Y.ERROR)
            IF Y.ERROR EQ '' THEN
                
                X.TIPO = REC.CLI<MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.SatTaxRegimeCode>
                IF X.TIPO = '1001' OR X.TIPO = '1100' THEN
                    X.TIPO = 'PF'
                END ELSE
                    X.TIPO = 'PM'
                END

                X.TMP.COD.TRANS = '7'
                X.TMP.COD.TRANS.EXCP = ''
                Y.NO.FECHAS=''
                X.FEC.FIN=''
                Y.STMT.MOVS=''
     
                CAD.FECHAS = EB.AbcIdeControlEod.getCadFechas()
                CAD.TIPO = EB.AbcIdeControlEod.getCadTipo()
                CAD.COD.TRANS = EB.AbcIdeControlEod.getCadCodTrans()
                LOCATE X.TIPO IN CAD.TIPO SETTING PS.TP THEN
                    X.TMP.COD.TRANS      = RAISE(CAD.COD.TRANS)
                    CAD.EXCP = EB.AbcIdeControlEod.getCadExcp()
                    X.TMP.COD.TRANS.EXCP = CAD.EXCP<PS.TP>
                    X.TMP.COD.TRANS.EXCP = RAISE(X.TMP.COD.TRANS.EXCP)
                    X.TOTAL.DEP.MES = 0

                    FOR J.CTA = 1 TO DCOUNT(X.CAD.CTA, @VM)

                        X.CTA = FIELD(X.CAD.CTA, @VM, J.CTA)
                        Y.NO.FECHAS=DCOUNT(CAD.FECHAS, @FM)
                        X.FEC = CAD.FECHAS<1>
                        X.FEC.FIN=CAD.FECHAS<Y.NO.FECHAS>
                        Y.RANG.FEC=X.FEC:@SM:X.FEC.FIN
                        ID.CTA.MOV = X.CTA

                        D.FIELDS = 'ACCOUNT':@FM:'BOOKING.DATE'
                        D.RANGE.AND.VALUE  = ID.CTA.MOV:@FM:Y.RANG.FEC
                        D.LOGICAL.OPERANDS = '1':@FM:'2'
                       
                        AC.ModelBank.EStmtEnqByConcat(Y.STMT.MOVS)

                        CONVERT @VM TO @FM IN Y.STMT.MOVS
                        Y.NO.MOV=DCOUNT(Y.STMT.MOVS, @FM)
                        FOR J.MOV = 1 TO Y.NO.MOV

                            ID.STMT=''
                            REC.STMT=''
                            ID.STMT = Y.STMT.MOVS<J.MOV>
                            ID.STMT=FIELD(ID.STMT,"*",2)
                                
                            Y.ERROR = ''
                            REC.STMT = AC.EntryCreation.StmtEntry.Read(ID.STMT, Y.ERROR)
                            IF Y.ERROR EQ '' THEN

                                COD.TRANS = REC.STMT<AC.EntryCreation.StmtEntry.SteTransactionCode>
                                MTO.TRANS = ABS(REC.STMT<AC.EntryCreation.StmtEntry.SteAmountLcy>)
                                EST.TRANS = REC.STMT<AC.EntryCreation.StmtEntry.SteRecordStatus>
                                PS.DC = EB.AbcIdeControlEod.getPsDc()
                                NAT.TRANS = REC.STMT<AC.EntryCreation.StmtEntry.SteLocalRef,PS.DC>
                                
                                IF EST.TRANS NE 'REVE' THEN
                                    LOCATE COD.TRANS IN X.TMP.COD.TRANS SETTING PS.TRANS THEN
                                        LOCATE COD.TRANS IN CAD.CLIE.TRANS SETTING PS.TR THEN

                                            X.TMP.CLIE.MTO  = CAD.CLIE.MTO<PS.TR>
                                            X.TMP.CLIE.CONT = CAD.CLIE.CONT<PS.TR>

                                            CAD.CLIE.MTO<PS.TR>  = X.TMP.CLIE.MTO + MTO.TRANS
                                            CAD.CLIE.CONT<PS.TR> = X.TMP.CLIE.CONT + 1
                                        END ELSE

                                            CAD.CLIE.TRANS<-1> = COD.TRANS
                                            CAD.CLIE.MTO<-1>  = MTO.TRANS
                                            CAD.CLIE.CONT<1> = 1
                                        END
                                        X.TOTAL.DEP.MES += MTO.TRANS
                                        
                                        
*==========================================================================================================================
                                        GOSUB  ESCRIBE.DATOS
*==========================================================================================================================
                                    END ELSE
                                        IF NAT.TRANS = 'D' THEN
                                            LOCATE COD.TRANS IN X.TMP.COD.TRANS.EXCP SETTING PS.EXCP THEN
                                                LOCATE COD.TRANS IN CAD.CLIE.TRANS SETTING PS.TR THEN

                                                    X.TMP.CLIE.MTO  = CAD.CLIE.MTO<PS.TR>
                                                    X.TMP.CLIE.CONT = CAD.CLIE.CONT<PS.TR>

                                                    CAD.CLIE.MTO<PS.TR>  = X.TMP.CLIE.MTO - MTO.TRANS
                                                    CAD.CLIE.CONT<PS.TR> = X.TMP.CLIE.CONT + 1
                                                END ELSE
                                                    CAD.CLIE.TRANS<-1> = COD.TRANS
                                                    CAD.CLIE.MTO<-1>  = (MTO.TRANS * -1)
                                                    CAD.CLIE.CONT<-1> = 1
                                                END
                                                X.TOTAL.DEP.MES = X.TOTAL.DEP.MES - MTO.TRANS

*=======================================================================================================================
                                                GOSUB  ESCRIBE.DATOS
*==========================================================================================================================
                                            END
                                        END
                                    END
                                END
                            END
                        NEXT
                    NEXT
                    
                    GOSUB CREA.ACT.MES
                    GOSUB CALC.MTO.DEP
                    GOSUB BUSQ.PER.ANT
                    GOSUB CREA.PER.ACT
                END ELSE
                    CAD.MSG.PROC<-1> = "CLIENTE ": X.CLIE :" NO TIPO DE PERSONA VALIDA"
                    yDataLog<-1> = "CLIENTE ": X.CLIE :" NO TIPO DE PERSONA VALIDA"
                END
            END ELSE
                CAD.MSG.PROC<-1> = "NO EXISTEN CUENTAS A CONSULTAR"
                yDataLog<-1> = "NO EXISTEN CUENTAS A CONSULTAR"
            END
        END ELSE
            CAD.MSG.PROC<-1> = "NO EXISTEN CLIENTES A CONSULTAR"
            yDataLog<-1> = "NO EXISTEN CLIENTES A CONSULTAR"
        END
    END
    yDataLog<-1> = 'Termine el cobro del IDE'
    
RETURN

*----------------------------------------------------------------------------
ESCRIBE.DATOS:
*----------------------------------------------------------------------------

    Y.CAD.TEMP = X.FEC:'*':COD.TRANS:'*':X.CTA:'*':MTO.TRANS
    CAD.MOV.DEP<-1> = Y.CAD.TEMP

RETURN

*----------------------------------------------------------------------------
CREA.ACT.MES:
*----------------------------------------------------------------------------
    MTO.LIMITE = EB.AbcIdeControlEod.getMtoLimite()
    Y.CURR.TR.MES = 0
    Y.ERROR = ''
    X.CLIE.C = ''
    X.CLIE.C =  X.CLIE:'.':X.FEC[1,6]
    IF (X.TOTAL.DEP.MES > MTO.LIMITE) THEN
        REC.TR.MES = AbcTable.AbcIdeTransMensual.Read(X.CLIE.C,Y.ERROR)
        IF Y.ERROR EQ '' THEN
            Y.CURR.TR.MES = REC.TR.MES<AbcTable.AbcIdeTransMensual.CurrNo>
        END ELSE
    
            REC.TR.MES<AbcTable.AbcIdeTransMensual.Moneda> = 'MXN'
        END
        FOR I.TR = 1 TO DCOUNT(CAD.CLIE.TRANS, @FM)
            REC.TR.MES<AbcTable.AbcIdeTransMensual.CodTrans, I.TR> = CAD.CLIE.TRANS<I.TR>
            REC.TR.MES<AbcTable.AbcIdeTransMensual.NoTrans, I.TR>  = CAD.CLIE.CONT<I.TR>
            REC.TR.MES<AbcTable.AbcIdeTransMensual.MtoTrans, I.TR> = CAD.CLIE.MTO<I.TR>
            
        NEXT

*=======================================================================
        FOR J.TR = 1 TO DCOUNT(CAD.MOV.DEP,@FM)
           
            REC.TR.MES<AbcTable.AbcIdeTransMensual.MovDep, J.TR> = CAD.MOV.DEP <J.TR>
        NEXT
*=======================================================================
        
        REC.TR.MES<AbcTable.AbcIdeTransMensual.CurrNo>    = Y.CURR.TR.MES + 1
        REC.TR.MES<AbcTable.AbcIdeTransMensual.Inputter>   = TNO:'_':OPERATOR
        REC.TR.MES<AbcTable.AbcIdeTransMensual.Authoriser> = TNO:'_':OPERATOR
        YTIME = TIMEDATE() ;*Revisar
        REC.TR.MES<AbcTable.AbcIdeTransMensual.DateTime>  = EB.SystemTables.getToday()[3,6]:YTIME[1,2]:YTIME[4,2]
        REC.TR.MES<AbcTable.AbcIdeTransMensual.CoCode>    = 'MX0010001'
        REC.TR.MES<AbcTable.AbcIdeTransMensual.DeptCode>  =  USER.DEPT.CODE
        
        AbcTable.AbcIdeTransMensual.Write(X.CLIE.C,REC.TR.MES)
        CAD.MSG.PROC<-1> = "CLIENTE ": X.CLIE :", SE HA REGISTRADO ACTIVIDAD MENSUAL"
        yDataLog<-1> = "CLIENTE ": X.CLIE :", SE HA REGISTRADO ACTIVIDAD MENSUAL"
    END ELSE
        CAD.MSG.PROC<-1> = "CLIENTE ":X.CLIE:", NO EXCEDE MONTO LIMITE PARA CALCULO DEL IDE"
        yDataLog<-1> = "CLIENTE ":X.CLIE:", NO EXCEDE MONTO LIMITE PARA CALCULO DEL IDE"
    END

RETURN

*----------------------------------------------------------------------------
CALC.MTO.DEP:
*----------------------------------------------------------------------------
    
    X.MTO.DEP.TOTAL = 0
    X.MTO.DEP.LINEA = 0
    X.MTO.CALC = 0
    X.MSG.TMP = ''
    MTO.LIMITE = EB.AbcIdeControlEod.getMtoLimite()
    X.CLIE.C = ''
    X.CLIE.C =  X.CLIE:'.':X.FEC[1,6]
    IF (X.TOTAL.DEP.MES > MTO.LIMITE) THEN

        REC.MOV = AbcTable.AbcIdeTransMensual.Read(X.CLIE.C,Y.ERROR)
        IF Y.ERROR EQ '' THEN

            Y.DEPOSITOS.TOTAL = REC.MOV<AbcTable.AbcIdeTransMensual.MtoTrans>
            Y.DEPOSITOS.LINEA = REC.MOV<AbcTable.AbcIdeTransMensual.MtoTransLn>

            FOR I.DT = 1 TO DCOUNT(Y.DEPOSITOS.TOTAL, @VM)
                X.MTO.DEP.TOTAL += FIELD(Y.DEPOSITOS.TOTAL, @VM, I.DT)
            NEXT

            FOR I.DL = 1 TO DCOUNT(Y.DEPOSITOS.LINEA, @VM)
                X.MTO.DEP.LINEA += FIELD(Y.DEPOSITOS.LINEA, @VM, I.DL)
            NEXT
        END

        
        PORC.IMPTO = EB.AbcIdeControlEod.getPorcImpto()
        AbcCob.abcIdeCalcImptoRtn(X.CLIE,X.MTO.DEP.TOTAL,X.MTO.DEP.LINEA,MTO.LIMITE,PORC.IMPTO,X.MTO.CALC,X.MSG.TMP) ;*REVISAR
       
        CAD.MSG.PROC<-1> = X.MSG.TMP
        yDataLog<-1> = X.MSG.TMP
    END

RETURN

*----------------------------------------------------------------------------
BUSQ.PER.ANT:
*----------------------------------------------------------------------------

    X.PER.ACT = X.FEC[1,6]
    Y.MTO.TOT.PEND = 0
    Y.UPD.PER.ANT = ''
    Y.UPD.MTO.ANT = ''
    X.CLIE.C = ''
    X.PER.ANT = X.PER.ACT - 1
    IF X.PER.ACT[5,2] > 1 THEN
        X.CLIE.C = X.CLIE :'.':X.PER.ANT
        Y.ERROR = ''
        REC.SALDO.ANT = AbcTable.AbcIdeSaldosClie.Read(X.CLIE.C, Y.ERROR)
        IF Y.ERROR EQ '' THEN
            
            X.STR.CVE.PER.ANT = REC.SALDO.ANT<AbcTable.AbcIdeSaldosClie.PeriodoAnt>
            X.STR.IDE.PER.ANT = REC.SALDO.ANT<AbcTable.AbcIdeSaldosClie.IdePerAnt>

            X.STR.REF.PER.IDE = REC.SALDO.ANT<AbcTable.AbcIdeSaldosClie.RefPerIde>
            X.STR.REF.PAG.IDE = REC.SALDO.ANT<AbcTable.AbcIdeSaldosClie.RefPagIde>

            FOR I.PA = 1 TO DCOUNT(X.STR.CVE.PER.ANT, @VM)
                CVE.PER.ANT = FIELD(X.STR.CVE.PER.ANT, @VM, I.PA)
                MTO.PER.ANT = FIELD(X.STR.IDE.PER.ANT, @VM, I.PA)

                IF MTO.PER.ANT > 0 THEN
                    FOR I.PB = 1 TO DCOUNT(X.STR.REF.PER.IDE, @VM)
                        REF.PER.IDE = FIELD(X.STR.REF.PER.IDE, @VM, I.PB)
                        REF.PAG.IDE = FIELD(X.STR.REF.PAG.IDE, @VM, I.PB)
                        IF (REF.PER.IDE = CVE.PER.ANT) THEN
                            MTO.PER.ANT = MTO.PER.ANT - REF.PAG.IDE
                            IF MTO.PER.ANT <= 0 THEN
                                BREAK
                            END
                        END
                    NEXT

*                   REVISA SI EN EL PERIODO ACTUAL YA HAY ALGO PAGADO DE PERIODOS ANTERIORES

                    Y.ERROR = ''
                    X.CLIE.C =''
                    X.CLIE.C = X.CLIE:'.':X.FEC[1,6]
                    REC.SC.TMP = AbcTable.AbcIdeSaldosClie.Read(X.CLIE.C, Y.ERROR)
                    IF Y.ERROR EQ '' THEN
                        FOR I.PV = 1 TO DCOUNT(REC.SC.TMP< AbcTable.AbcIdeSaldosClie.RefPerIde>, @VM)
                            IF (CVE.PER.ANT = REC.SC.TMP<AbcTable.AbcIdeSaldosClie.RefPerIde, I.PV>) THEN
                                MTO.PER.ANT = MTO.PER.ANT - REC.SC.TMP<AbcTable.AbcIdeSaldosClie.RefPagIde, I.PV>
                                IF MTO.PER.ANT <=  0 THEN
                                    BREAK
                                END
                            END
                        NEXT
                    END

                    IF MTO.PER.ANT > 0 THEN
                        Y.MTO.TOT.PEND += MTO.PER.ANT
                        Y.UPD.PER.ANT<1, -1> = CVE.PER.ANT
                        Y.UPD.MTO.ANT<1, -1> = MTO.PER.ANT
                    END
                END
            NEXT
        
            IF (REC.SALDO.ANT<AbcTable.AbcIdeSaldosClie.ImpuestoPend> > 0) THEN
                Y.MTO.MES.ANT = REC.SALDO.ANT<AbcTable.AbcIdeSaldosClie.ImpuestoPend>
*               REVISA SI EN EL PERIODO ACTUAL YA HAY ALGO PAGADO DEL IDE CALCULADO EN EL MES ANTERIOR

                Y.ERROR = ''
                X.CLIE.C = ''
                X.CLIE.C = X.CLIE:'.':X.FEC[1,6]
                REC.SC.TMP2 =  AbcTable.AbcIdeSaldosClie.Read(X.CLIE.C,Y.ERROR)
                IF Y.ERROR EQ  '' THEN
                    FOR I.PV2 = 1 TO DCOUNT(REC.SC.TMP2<AbcTable.AbcIdeSaldosClie.RefPerIde>, @VM)
                        IF (X.PER.ANT = REC.SC.TMP2<AbcTable.AbcIdeSaldosClie.RefPerIde, I.PV2>) THEN
                            Y.MTO.MES.ANT = Y.MTO.MES.ANT - REC.SC.TMP2<AbcTable.AbcIdeSaldosClie.RefPagIde, I.PV2>
                            IF Y.MTO.MES.ANT <=  0 THEN
                                BREAK
                            END
                        END
                    NEXT
                END
                IF Y.MTO.MES.ANT > 0 THEN
                    Y.MTO.TOT.PEND += Y.MTO.MES.ANT
                    Y.UPD.PER.ANT<1, -1> = X.PER.ANT
                    Y.UPD.MTO.ANT<1, -1> = Y.MTO.MES.ANT
                END
            END ELSE
                Y.UPD.PER.ANT<1, -1> = X.PER.ANT
                Y.UPD.MTO.ANT<1, -1> = 0
            END
        END ELSE
            CAD.MSG.PROC<-1> = "CLIENTE ": X.CLIE :", NO EXISTE PERIODO ANTERIOR ": X.PER.ANT
            yDataLog<-1> = "CLIENTE ": X.CLIE :", NO EXISTE PERIODO ANTERIOR ": X.PER.ANT
            Y.UPD.PER.ANT = X.PER.ANT
            Y.UPD.MTO.ANT = 0
        END
    END ELSE
        Y.AO.TMP = X.FEC[1,4] - 1
        Y.UPD.PER.ANT = Y.AO.TMP:'12'
        Y.UPD.MTO.ANT = 0
    END

RETURN

*----------------------------------------------------------------------------
CREA.PER.ACT:
*----------------------------------------------------------------------------

    Y.ERROR =''
    X.CLIE.C = ''
    X.CLIE.C = X.CLIE:'.':X.FEC[1,6]
    REC.TMES = AbcTable.AbcIdeTransMensual.Read(X.CLIE.C,Y.ERROR)
    IF Y.ERROR EQ '' THEN

        X.STR.DEP.FEC.LN = REC.TMES<AbcTable.AbcIdeTransMensual.FecTransLn>
        X.STR.DEP.MTO.LN = REC.TMES<AbcTable.AbcIdeTransMensual.IdeTransLn>
        X.STR.DEP.FOL.LN = REC.TMES<AbcTable.AbcIdeTransMensual.FolTransLn>
        Y.ERROR =''
        X.CLIE.C = ''
        X.CLIE.C = X.CLIE:'.':X.FEC[1,6]


        REC.SDO.MES = AbcTable.AbcIdeSaldosClie.Read(X.CLIE.C,Y.ERROR)
        IF Y.ERROR EQ '' THEN
            REC.SDO.MES = ''
            REC.SDO.MES<AbcTable.AbcIdeSaldosClie.Cliente> = X.CLIE
            REC.SDO.MES<AbcTable.AbcIdeSaldosClie.Moneda> = 'MXN'
        END

        FOR I.PC = 1 TO DCOUNT(Y.UPD.PER.ANT, @VM)
            Y.PER.TMP = FIELD(Y.UPD.PER.ANT, @VM, I.PC)
            Y.CAD.TMP = RAISE(REC.SDO.MES<AbcTable.AbcIdeSaldosClie.PeriodoAnt>)
            LOCATE Y.PER.TMP IN Y.CAD.TMP SETTING PS.PA ELSE
                Y.CONT.PA = DCOUNT(REC.SDO.MES<AbcTable.AbcIdeSaldosClie.PeriodoAnt>, @VM)
                REC.SDO.MES<AbcTable.AbcIdeSaldosClie.PeriodoAnt, Y.CONT.PA + 1> = FIELD(Y.UPD.PER.ANT, @VM, I.PC)
                REC.SDO.MES<AbcTable.AbcIdeSaldosClie.IdePerAnt, Y.CONT.PA + 1> = FIELD(Y.UPD.MTO.ANT,@VM, I.PC)
            END
        NEXT

        
        REC.SDO.MES<AbcTable.AbcIdeSaldosClie.TotDepMes>   = X.MTO.DEP.TOTAL
        REC.SDO.MES<AbcTable.AbcIdeSaldosClie.TotDepLin>   = X.MTO.DEP.LINEA
        REC.SDO.MES<AbcTable.AbcIdeSaldosClie.ImpuestoCalc> = X.MTO.CALC
        REC.SDO.MES<AbcTable.AbcIdeSaldosClie.ImpuestoReca> = 0
        REC.SDO.MES<AbcTable.AbcIdeSaldosClie.ImpuestoPend> = X.MTO.CALC

        FOR I.LN = 1 TO DCOUNT(X.STR.DEP.FEC.LN, @VM)
            
            REC.SDO.MES<AbcTable.AbcIdeSaldosClie.RefPerIdeLin, I.LN> = FIELD(X.STR.DEP.FEC.LN, @VM, I.LN)[1,6]
            REC.SDO.MES<AbcTable.AbcIdeSaldosClie.RefPagIdeLin, I.LN> = FIELD(X.STR.DEP.MTO.LN, @VM, I.LN)
            REC.SDO.MES<AbcTable.AbcIdeSaldosClie.RefFolIdeLin, I.LN> = FIELD(X.STR.DEP.FOL.LN, @VM, I.LN)
        NEXT
        
        REC.SDO.MES<AbcTable.AbcIdeSaldosClie.CurrNo> = 1
        REC.SDO.MES<AbcTable.AbcIdeSaldosClie.Inputter> = TNO:'_':OPERATOR
        REC.SDO.MES<AbcTable.AbcIdeSaldosClie.Authoriser> = TNO:'_':OPERATOR
        YTIME = TIMEDATE()
        REC.SDO.MES<AbcTable.AbcIdeSaldosClie.DateTime> = EB.SystemTables.getToday()[3,6]:YTIME[1,2]:YTIME[4,2]
        REC.SDO.MES<AbcTable.AbcIdeSaldosClie.CoCode> = 'MX0010001'
                
        REC.SDO.MES<AbcTable.AbcIdeSaldosClie.DeptCode> = USER.DEPT.CODE
        
        DISPLAY '----------------':X.CLIE:'---------------'
        DISPLAY REC.SDO.MES
        
        F.ABC.IDE.SALDOS.CLIE = EB.AbcIdeControlEod.getFnAbcIdeSaldosClie()
        
        AbcTable.AbcIdeSaldosClie.Write(X.CLIE.C,REC.SDO.MES)
        Y.FLAG = 0
        CAD.MSG.PROC<-1> = "CLIENTE ":X.CLIE:", SE HA CREADO REGISTRO DE SALDO MENSUAL"
        yDataLog<-1> = "CLIENTE ":X.CLIE:", SE HA CREADO REGISTRO DE SALDO MENSUAL"
    END
    
RETURN

*----------------------------------------------------------------------------
FINALLY:
*----------------------------------------------------------------------------
    
    yRtnName = 'ABC.IDE.CONTROL.EOD'
    EB.AbcUtil.abcEscribeLogGenerico(yRtnName, yDataLog)
RETURN
END
