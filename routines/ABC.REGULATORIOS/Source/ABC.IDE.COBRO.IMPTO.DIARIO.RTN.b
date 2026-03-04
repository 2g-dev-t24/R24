* @ValidationCode : MjoxMTk4Nzg4NjEwOkNwMTI1MjoxNzYxNzEwODM5MTIxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 29 Oct 2025 01:07:19
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
$PACKAGE AbcRegulatorios

SUBROUTINE ABC.IDE.COBRO.IMPTO.DIARIO.RTN
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modificado por : Arturo Villalobos
* Fecha          : 14/Enero/2014
* Descripcion    : Cambio solicitado por el SAT para no cobrar IDE, Se omite el llamado a VAL.COBRO.
*-----------------------------------------------------------------------------
* Modificado por : Luis Pecina
* Fecha          : 10/Junio/2013
* Descripcion    : Carga todos los cobros(monto, cuenta y fecha) del IDE a la tabla ABC.IDE.SALDOS.CLIE
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.API
    $USING AC.AccountOpening
    $USING EB.Display
    $USING EB.Security
    
    GOSUB INICIO
    GOSUB BUSCA.CLIE
    GOSUB CREA.LOG
RETURN



*==========
BUSCA.CLIE:
*==========
    COMI =EB.SystemTables.getComi()
    
    TODAY   = EB.SystemTables.getToday()
    IF NOT(EB.SystemTables.getRunningUnderBatch()) THEN
        EB.Display.Txtinp("TECLEAR PERIODO DE COBRO IDE (--yyyymm--):", 6,6,6.6,"")
*       CALL TXTINP("TECLEAR PERIODO DE COBRO IDE (--yyyymm--):", 6,6,6.6,"")
        IF NOT(COMI[1,4] > 2006) THEN
            TEXT = "FECHA NO VALIDA (-yyyy-)"
            EB.Display.Rem()
            RETURN
        END
        IF NOT(COMI[5,2] > 0 AND COMI[5,2] < 13) THEN
            TEXT = "FECHA NO VALIDA (-mm-)"
            EB.Display.Rem()
            RETURN
        END

        Y.FEC.PER = COMI[1,6]
    END ELSE
        Y.FEC = TODAY
        Y.FEC.PER = Y.FEC[1,6]:'01'
        EB.API.Cdt('', Y.FEC.PER, '-1C')
        IF Y.FEC.PER[5,2] < 12 THEN
            Y.FEC.PER = Y.FEC.PER[1,6]
        END ELSE
            CAD.LOG<-1> = "NO SE PUEDE COBRAR MES ": Y.FEC.PER[1,6] :" PORQUE TE ENCUENTRAS EN ": Y.FEC[1,6]
            RETURN
        END
    END

    Y.FEC.PER.NVO = TODAY
    Y.FEC.PER.NVO = Y.FEC.PER.NVO[1,6]

    CAD.PER.PEND = ''
    CAD.MTO.PEND = ''
    MTO.TOT.PEND = 0

    CAD.LOG<-1> = "INICIA PROCESO DE COBRO DEL IDE CON FRECUENCIA DIARIA, PERIODO: ": Y.FEC.PER

    READ REC.PR FROM F.ABC.IDE.PARAM, ID.PARAM THEN
        RUTA.LOG = REC.PR<AbcTable.AbcIdeParam.RutaRep>

        SEL.CLIE = "SELECT ": FN.ABC.IDE.SALDOS.CLIE :" WITH @ID LIKE ":DQUOTE("...": SQUOTE(Y.FEC.PER[1,6])):" BY @ID"  ; * ITSS - BINDHU - Added DQUOTE / SQUOTE
        EB.DataAccess.Readlist(SEL.CLIE, LISTA.CLIE, '', NO.CLIE, '')
        IF LISTA.CLIE THEN
            FOR I.CLIE = 1 TO NO.CLIE
                Y.SAL.CLIE = LISTA.CLIE<I.CLIE>
                CAD.LOG<-1> = "CONSULTANDO CLIENTE ": FIELD(Y.SAL.CLIE, '.', 1) :", #": I.CLIE :" DE #": NO.CLIE

                READ REC.SALDO.ANT FROM F.ABC.IDE.SALDOS.CLIE, Y.SAL.CLIE THEN
                    Y.CLIE = REC.SALDO.ANT<AbcTable.AbcIdeSaldosClie.Cliente>

                    Y.DEUDA.PER = ''; Y.DEUDA.MTO = ''; Y.DEUDA.TOTAL = 0

                    READ REC.CUSAC FROM F.CUSTOMER.ACCOUNT, Y.CLIE THEN
                        Y.STR.PANT = REC.SALDO.ANT<AbcTable.AbcIdeSaldosClie.PeriodoAnt>
                        Y.STR.MANT = REC.SALDO.ANT<AbcTable.AbcIdeSaldosClie.IdePerAnt>

                        Y.STR.RPANT = REC.SALDO.ANT<AbcTable.AbcIdeSaldosClie.RefPerIde>
                        Y.STR.RMANT = REC.SALDO.ANT<AbcTable.AbcIdeSaldosClie.RefPagIde>

                        FOR I.PA = 1 TO DCOUNT(Y.STR.PANT, @VM)
                            Y.PER.ANT = FIELD(Y.STR.RPANT, @VM, I.PA)
                            Y.MTO.ANT = FIELD(Y.STR.RMANT, @VM, I.PA)
                            IF Y.MTO.ANT > 0 THEN
                                FOR I.PB = 1 TO DCOUNT(Y.STR.RPANT, @VM)
                                    Y.REF.PER = FIELD(Y.STR.RPANT, @VM, I.PB)
                                    Y.REF.MTO = FIELD(Y.STR.RMANT, @VM, I.PB)
                                    IF (Y.PER.ANT = Y.REF.PER) THEN
                                        Y.MTO.ANT = Y.MTO.ANT - Y.REF.MTO
                                        IF Y.MTO.ANT <= 0 THEN
                                            BREAK
                                        END
                                    END
                                NEXT

                                IF Y.MTO.ANT > 0 THEN
                                    Y.DEUDA.TOTAL += Y.MTO.ANT
                                    Y.DEUDA.PER<-1> = Y.PER.ANT
                                    Y.DEUDA.MTO<-1> = Y.MTO.ANT
                                END
                            END
                        NEXT

                        IF (REC.SALDO.ANT< AbcTable.AbcIdeSaldosClie.ImpuestoPend> > 0) THEN
                            Y.PER.ANT = FIELD(Y.SAL.CLIE, '.', 2)
                            Y.MTO.ANT = REC.SALDO.ANT<AbcTable.AbcIdeSaldosClie.ImpuestoPend>
                            Y.DEUDA.TOTAL += Y.MTO.ANT
                            Y.DEUDA.PER<-1> = Y.PER.ANT
                            Y.DEUDA.MTO<-1> = Y.MTO.ANT
                        END

                        GOSUB VAL.DEUDA
*Cambio solicitado por el SAT para no cobrar IDE, solamente identificar quien debe
*GOSUB VAL.COBRO
                    END ELSE
                        CAD.LOG<-1> = "CLIENTE ": Y.CLIE :", NO TIENE CUENTAS EXISTENTES"
                    END
                END
            NEXT
        END ELSE
            CAD.LOG<-1> = "NO EXISTEN CLIENTES A CONSULTAR EN SALDOS"
        END
    END ELSE
        CAD.LOG<-1> = "NO EXISTEN PARAMETROS"
    END

    CAD.LOG<-1> = "FINALIZA PROCESO"

RETURN




*==========
VAL.DEUDA:
*==========
    IF Y.DEUDA.TOTAL > 0 THEN
        READ REC.SALDO.NVO FROM F.ABC.IDE.SALDOS.CLIE, Y.CLIE:'.':Y.FEC.PER.NVO ELSE
            REC.SALDO.NVO = ''
            REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.Cliente> = Y.CLIE
            REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.Moneda> = 'MXN'
            FOR I.PAD = 1 TO DCOUNT(Y.DEUDA.PER, @FM)
                REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.PeriodoAnt, I.PAD> = Y.DEUDA.PER<I.PAD>
                REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.IdePerAnt, I.PAD> = Y.DEUDA.MTO<I.PAD>
            NEXT
            OPERATOR = EB.SystemTables.getOperator()
            TNO = EB.SystemTables.getTno()
            REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.CurrNo> = 1
            REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.Inputter> = TNO:'_':OPERATOR
            REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.Authoriser> = TNO:'_':OPERATOR
            YTIME = TIMEDATE()
            REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.CoCode> = 'MX0010001'
            R.USER = EB.SystemTables.getRUser()
            REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.DeptCode> = R.USER<EB.Security.User.UseDepartmentCode>
            YTIME = TIMEDATE()
            REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.DateTime> = TODAY[3,6]:YTIME[1,2]:YTIME[4,2]
            WRITE REC.SALDO.NVO TO F.ABC.IDE.SALDOS.CLIE, Y.CLIE:'.':Y.FEC.PER.NVO
        END
    END

RETURN

*==========
VAL.COBRO:
*==========
    READ REC.SALDO.NVO FROM F.ABC.IDE.SALDOS.CLIE, Y.CLIE:'.':Y.FEC.PER.NVO THEN

        Y.CURR.NO = REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.CurrNo>
        Y.STR.PER.ANT = REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.PeriodoAnt>
        Y.STR.IDE.ANT = REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.IdePerAnt>
        Y.STR.REF.PER = REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.RefPerIde>
        Y.STR.REF.PAG = REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.RefPagIde>
        FOR I.PA = 1 TO DCOUNT(Y.STR.PER.ANT, @VM)
            CVE.PER.ANT = FIELD(Y.STR.PER.ANT, @VM, I.PA)
            MTO.PER.ANT = FIELD(Y.STR.IDE.ANT, @VM, I.PA)

            IF MTO.PER.ANT > 0 THEN
                FOR I.PB = 1 TO DCOUNT(Y.STR.REF.PER, @VM)
                    REF.PER.IDE = FIELD(Y.STR.REF.PER, @VM, I.PB)
                    REF.PAG.IDE = FIELD(Y.STR.REF.PAG, @VM, I.PB)
                    IF (REF.PER.IDE = CVE.PER.ANT) THEN
                        MTO.PER.ANT = MTO.PER.ANT - REF.PAG.IDE
                        IF MTO.PER.ANT <= 0 THEN
                            BREAK
                        END
                    END
                NEXT

                IF MTO.PER.ANT > 0 THEN
                    FOR I.CUSAC = 1 TO DCOUNT(REC.CUSAC, FM)
                        Y.CTA.COB = REC.CUSAC<I.CUSAC>
                        READ REC.CTA FROM F.ACCOUNT, Y.CTA.COB THEN
*Y.CTA.COB.SALDO = REC.CTA<AC.WORKING.BALANCE>
                            Y.CTA.COB.SALDO = REC.CTA<AC.AccountOpening.Account.OpenClearedBal>      ;* NS  Changes
                            IF Y.CTA.COB.SALDO >= MTO.PER.ANT THEN
                                Y.FOL.PAG = ''
                                AbcRegulatorios.AbcIdeCobroImptoRtn(CVE.PER.ANT, Y.CLIE, Y.CTA.COB, MTO.PER.ANT, Y.FOL.PAG)
*CALL JOURNAL.UPDATE("")
                                CAD.LOG<-1> = "CLIENTE ": Y.CLIE :", PAGO IDE TOTAL ": CVE.PER.ANT :" DE ": MTO.PER.ANT :", ": Y.FOL.PAG

                                REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.RefPerIde, -1> = CVE.PER.ANT
                                REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.RefFolIde, -1> = Y.FOL.PAG
                                REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.RefPagIde, -1> = MTO.PER.ANT

                                Y.CANT.COBRAR = MTO.PER.ANT

                                Y.CURR.NO += 1
                                REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.CurrNo> = Y.CURR.NO
                                REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.Inputter> = TNO:'_':OPERATOR
                                REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.Authoriser> = TNO:'_':OPERATOR

                                GOSUB INSERTAR.DATOS

                                REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.DateTime> = TODAY[3,6]:YTIME[1,2]:YTIME[4,2]
                                REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.CoCode> = 'MX0010001'
                                REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.DeptCode> = R.USER<EB.Security.User.UseDepartmentCode>
                                WRITE REC.SALDO.NVO TO F.ABC.IDE.SALDOS.CLIE, Y.CLIE:'.':Y.FEC.PER.NVO
                                MTO.PER.ANT = 0
                                BREAK
                            END ELSE
                                IF Y.CTA.COB.SALDO > 1 THEN
                                    Y.CTA.COB.SALDO = FIELD(Y.CTA.COB.SALDO, '.', 1)
                                    Y.FOL.PAG = ''
                                    AbcRegulatorios.AbcIdeCobroImptoRtn(CVE.PER.ANT, Y.CLIE, Y.CTA.COB, Y.CTA.COB.SALDO, Y.FOL.PAG)
*  CALL JOURNAL.UPDATE("")
                                    CAD.LOG<-1> = "CLIENTE ": Y.CLIE :", PAGO IDE PARCIAL ": CVE.PER.ANT :" DE ": MTO.PER.ANT :", ": Y.FOL.PAG
                                    MTO.PER.ANT = MTO.PER.ANT - Y.CTA.COB.SALDO

                                    Y.CANT.COBRAR = Y.CTA.COB.SALDO

                                    REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.RefPerIde, -1> = CVE.PER.ANT
                                    REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.RefFolIde, -1> = Y.FOL.PAG
                                    REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.RefPagIde, -1> = Y.CTA.COB.SALDO
                                    Y.CURR.NO += 1

                                    REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.CurrNo> = Y.CURR.NO
                                    REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.Inputter> = TNO:'_':OPERATOR
                                    REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.Authoriser> = TNO:'_':OPERATOR

                                    GOSUB INSERTAR.DATOS

                                    REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.DateTime> = TODAY[3,6]:YTIME[1,2]:YTIME[4,2]
                                    REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.CoCode> = 'MX0010001'
                                    REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.DeptCode> = R.USER<EB.Security.User.UseDepartmentCode>
                                    WRITE REC.SALDO.NVO TO F.ABC.IDE.SALDOS.CLIE, Y.CLIE:'.':Y.FEC.PER.NVO
                                END
                            END
                        END ELSE
                            CAD.LOG<-1> = "CLIENTE ": Y.CLIE :" CON CUENTA ": Y.CTA.COB :" NO EXISTENTE"
                        END

                        IF MTO.PER.ANT > 0 THEN
                            BREAK
                        END
                    NEXT
                END
            END
        NEXT
    END

RETURN

*=====
INSERTAR.DATOS:
*=====

    Y.FECHA.AUX = TODAY

    Y.CAD.TEMP = Y.FECHA.AUX:'*':Y.CTA.COB:'*':Y.CANT.COBRAR
    REC.SALDO.NVO<AbcTable.AbcIdeSaldosClie.MovPago, -1> = Y.CAD.TEMP

RETURN


*==========
CREA.LOG:
*==========
    IF CAD.LOG THEN
        RUTA.ARCHIVO = RUTA.LOG : 'IDE.PENDIENTE.': Y.FEC.PER :'.': TIME() :'.LOG'
        OPENSEQ RUTA.ARCHIVO TO FILE.TEXT ELSE
            CREATE FILE.TEXT ELSE NULL
        END

        WRITESEQ "---------------------------------------------------------------------" TO FILE.TEXT ELSE NULL
        WRITESEQ "---------------------------------------------------------------------" TO FILE.TEXT ELSE NULL

        FOR I.ARR = 1 TO DCOUNT(CAD.LOG, FM)
            Y.ARR.LIN = CAD.LOG<I.ARR>
            WRITESEQ Y.ARR.LIN TO FILE.TEXT ELSE NULL
        NEXT

        CLOSESEQ FILE.TEXT
    END

RETURN




*==========
INICIO:
*==========
    F.ABC.IDE.PARAM = ''
    FN.ABC.IDE.PARAM = 'F.ABC.IDE.PARAM'
    EB.DataAccess.Opf(FN.ABC.IDE.PARAM, F.ABC.IDE.PARAM)

    F.ABC.IDE.SALDOS.CLIE = ''
    FN.ABC.IDE.SALDOS.CLIE = 'F.ABC.IDE.SALDOS.CLIE'
    EB.DataAccess.Opf(FN.ABC.IDE.SALDOS.CLIE, F.ABC.IDE.SALDOS.CLIE)

    F.CUSTOMER.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    EB.DataAccess.Opf(FN.CUSTOMER.ACCOUNT, F.CUSTOMER.ACCOUNT)

    F.ACCOUNT = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    ID.PARAM = 'MX0010001'
    CAD.LOG = ''

RETURN
END

