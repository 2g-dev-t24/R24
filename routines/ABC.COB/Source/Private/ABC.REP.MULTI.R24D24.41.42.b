* @ValidationCode : MjotMTc3MTcyMjgyOTpDcDEyNTI6MTc2MjMwNDAwMzY4MjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Nov 2025 21:53:23
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
$PACKAGE AbcCob

SUBROUTINE ABC.REP.MULTI.R24D24.41.42(ID.AC)

    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING ST.Customer
    $USING AbcTable
    $USING AC.EntryCreation
    $USING AC.AccountStatement
    $USING EB.Reports

    GOSUB PROCESO.EXTRACCION

RETURN

*******************
PROCESO.EXTRACCION:
*******************
 
    J.ARR.DESG = ''
    FN.STMT.ENTRY = AbcCob.getFnStmtEntry24()
    F.STMT.ENTRY = AbcCob.getFStmtEntry24()
    FN.ACCOUNT = AbcCob.getFnAccountR24()
    F.ACCOUNT = AbcCob.getFAccountR24()
    FN.FUNDS.TRANSFER = AbcCob.getFnFundsTransfer()
    F.FUNDS.TRANSFER = AbcCob.getFFundsTransfer()
    FN.FUNDS.TRANSFER.HIS = AbcCob.getFnFundsTransferHis()
    F.FUNDS.TRANSFER.HIS = AbcCob.getFFundsTransferHis()
    FN.CUSTOMER = AbcCob.getFnCustomerR24()
    F.CUSTOMER = AbcCob.getFCustomerR24()
    FN.ABC.ACCT.LCL.FLDS = AbcCob.getFnAbcAcctLclFldsR24()
    F.ABC.ACCT.LCL.FLDS = AbcCob.getFAbcAcctLclFldsR24()
    Y.ARR.NOM.PARAM = AbcCob.getYArrNomParam()
    Y.ARR.DAT.PARAM = AbcCob.getYArrDatParam()
    FEC.INI.PER = AbcCob.getYFechaIniPer()
    FEC.FIN.PER = AbcCob.getYFechaFinPer()
    NUMERO.DIAS.PERIODO = AbcCob.getYNumeroDiasPeriodo()
     
    YPOS.ID.COMISIONISTA = AbcCob.getYPosIdComisionista()
    YPOS.CANAL = AbcCob.getYPosCanal()
    F.SFILE = AbcCob.getFSFile()
    F.SFILE.1 = AbcCob.getFSFile1()
    Y.TIPO.AC.TRANS.NVL2 = AbcCob.getYTipoAcTransNvl2()
    Y.TIPO.AC.TRANS.NVL4L = AbcCob.getYTipoAcTransNvl4()
    Y.ARR.NOM.PARAM.CANAL = AbcCob.getYArrNomParamCanal()
    Y.ARR.DAT.PARAM.CANAL = AbcCob.getYArrDatParamCanal()
    NO.USER = AbcCob.getNoUser4142()
    Y.CATEGORIAS.CELULAR = AbcCob.getYCategoriasCelular()
    Y.USUARIOS.CELULAR = AbcCob.getYUsuariosCelular()
    Y.ARR.NOM.PARAM.REP = AbcCob.getYArrNomParamRep()
    Y.ARR.DAT.PARAM.REP = AbcCob.getYArrDatParamRep()
    CANAL.COMISIONISTA = AbcCob.getCanalComisionaste()
    YARR.AA.BANCA = AbcCob.getYArrAABanca()
    
    
    EB.DataAccess.FRead(FN.ACCOUNT,ID.AC,REGISTRO.CUENTA,F.ACCOUNT,ERR.CUENTA)
    IF REGISTRO.CUENTA THEN
        CATEG = REGISTRO.CUENTA<AC.AccountOpening.Account.Category>
        Y.CONDITION.GROUP = REGISTRO.CUENTA<AC.AccountOpening.Account.ConditionGroup>
        Y.CUSTOMER = REGISTRO.CUENTA<AC.AccountOpening.Account.Customer>
        IF Y.CUSTOMER NE '' AND Y.CONDITION.GROUP NE '80' THEN
            EB.DataAccess.CacheRead(FN.ABC.ACCT.LCL.FLDS,CUENTA,R.ABC.ACCT.LCL.FLDS,YERR.LCL)
            Y.NIVEL = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Nivel>
            Y.FLAG.FECHA.UPD.NVL = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.FechaUpdNvl>      ;* AAR-20221107 S-E
            LOCATE Y.NIVEL IN Y.ARR.NOM.PARAM SETTING POS THEN        ;* AAR-20200306 - S
                J.TIPO.CTA = Y.ARR.DAT.PARAM<POS>
            END ELSE          ;* AAR-20200306 - E
                LOCATE CATEG IN Y.ARR.NOM.PARAM SETTING POS THEN
                    J.TIPO.CTA = Y.ARR.DAT.PARAM<POS>
                END
            END

            IF CATEG EQ '6008' THEN     ;* INICIO CMB-20240503
                LOCATE CATEG IN Y.ARR.NOM.PARAM SETTING POS THEN
                    J.TIPO.CTA = Y.ARR.DAT.PARAM<POS>
                END
            END     ;* FIN CMB-20240503

            Y.TIPO.CUENTA.REP = J.TIPO.CTA
            D.FIELDS = 'ACCOUNT':@FM:'BOOKING.DATE'
            D.RANGE.AND.VALUE = ID.AC:@FM:FEC.INI.PER:@SM:FEC.FIN.PER
            D.LOGICAL.OPERANDS = '1':@FM:'2'
            
            EB.Reports.setDRangeAndValue(D.RANGE.AND.VALUE)
            EB.Reports.setDFields(D.FIELDS)
            EB.Reports.setLogicalOperands(D.LOGICAL.OPERANDS)
            LISTA.STMT = ''; CANT.STMT = '';
            
            AC.AccountStatement.EbAcctEntryList(ID.AC, FEC.INI.PER, FEC.FIN.PER, LISTA.STMT, OPENING.BAL, ER)

            IF LISTA.STMT THEN
                CANT.STMT = DCOUNT(LISTA.STMT,@FM)
                FOR CNT.STMT = 1 TO CANT.STMT
                    ID.STMT = ''
                    FINDSTR '*' IN LISTA.STMT<CNT.STMT> SETTING Ap, Vp THEN
                        ID.STMT = FIELD(LISTA.STMT<CNT.STMT>,'*',2)
                    END ELSE
                        ID.STMT = LISTA.STMT<CNT.STMT>
                    END
                    IF ID.STMT EQ '' OR ID.STMT EQ 0 OR LEN(ID.STMT) LE 1 THEN CONTINUE
                    EB.DataAccess.FRead(FN.STMT.ENTRY,ID.STMT,REC.STMT,F.STMT.ENTRY,ERR.STMT)
                    IF REC.STMT THEN
                        J.TIPO.CTA = Y.TIPO.CUENTA.REP
                        J.RECORD = REC.STMT<AC.EntryCreation.StmtEntry.SteRecordStatus>
                        IF J.RECORD NE "REVE" THEN
                            GOSUB CHECK.OPERACION
                            LOCATE J.TRANS.CODE IN Y.ARR.NOM.PARAM SETTING POS THEN
                                IF J.AMOUNT GT 0 THEN
                                    J.TIPO.OPER = ARR.VALORES.TRANS<1,1,4>
                                END ELSE
                                    J.TIPO.OPER = ARR.VALORES.TRANS<1,1,3>
                                END
                                J.AMOUNT = J.AMOUNT * -1
                                J.TIPO.CTA = Y.ARR.DAT.PARAM<POS>
                                J.ARR.DESG = J.R24:',':ID.AC:',':CATEG:',':ID.STMT:',':J.TRANS.CODE:',':J.AMOUNT:',':J.TRANS.REF:',':J.INPUTTER.FT:',':J.CRED.REF:',':J.CRED.ACC:',':J.DEBT.REF:',':J.TIPO.CTA:',':J.CANAL:',':J.TIPO.OPER
                                GOSUB ESCRIBE.ARCHIVO
                            END
                        END
                    END
                NEXT CNT.STMT
            END
        END
    END

RETURN

****************
ESCRIBE.ARCHIVO:
****************

    WRITESEQ J.ARR.DESG APPEND TO F.SFILE ELSE
    END

    J.ARR.DESG = ''

RETURN

****************
CHECK.OPERACION:
****************

    J.CANAL    = ''
    J.TIPO.OPER= ''
    Y.ID.COMISIONISTA = ''
    Y.CANAL.OPERACION = ''

    J.AMOUNT     = REC.STMT<AC.EntryCreation.StmtEntry.SteAmountLcy>
    J.TRANS.CODE = REC.STMT<AC.EntryCreation.StmtEntry.SteTransactionCode>
    J.TRANS.REF  = REC.STMT<AC.EntryCreation.StmtEntry.SteTransReference>
    J.OUR.REF    = REC.STMT<AC.EntryCreation.StmtEntry.SteOurReference>
    YAPLICACION  = REC.STMT<AC.EntryCreation.StmtEntry.SteSystemId>
    YID.CLIENTE  = REC.STMT<AC.EntryCreation.StmtEntry.SteCustomerId>

    IF J.TRANS.REF THEN
        EB.DataAccess.FRead(FN.FUNDS.TRANSFER,J.TRANS.REF,REC.FUNDS.TRANFER,F.FUNDS.TRANSFER,ERR.FT)
        IF REC.FUNDS.TRANFER EQ '' THEN
            J.TRANS.REF.HIS = J.TRANS.REF
            EB.DataAccess.FReadHistory(FN.FUNDS.TRANSFER.HIS,J.TRANS.REF.HIS,REC.FUNDS.TRANFER,F.FUNDS.TRANSFER.HIS,ERR.FT)
        END
    END
    Y.CANAL.OPERACION = REC.FUNDS.TRANFER<FT.Contract.FundsTransfer.LocalRef><1,YPOS.CANAL>
    J.INPUTTER.FT = REC.FUNDS.TRANFER<FT.Contract.FundsTransfer.Inputter>
    J.CRED.REF = REC.FUNDS.TRANFER<FT.Contract.FundsTransfer.CreditTheirRef>
    J.DEBT.REF = REC.FUNDS.TRANFER<FT.Contract.FundsTransfer.DebitTheirRef>
    YFLD.PAYMENT.DETAILS = REC.FUNDS.TRANFER<FT.Contract.FundsTransfer.PaymentDetails>
    YFLD.PAYMENT = YFLD.PAYMENT.DETAILS[1,3]
    Y.FT.DATE.TIME = REC.FUNDS.TRANFER<FT.Contract.FundsTransfer.DateTime>

    IF Y.FLAG.FECHA.UPD.NVL NE '' THEN  ;* AAR-20221107 - S
        Y.FLAG.FECHA.VAL = Y.FLAG.FECHA.UPD.NVL[3,6]:Y.FLAG.FECHA.UPD.NVL[10,2]:Y.FLAG.FECHA.UPD.NVL[13,2]
        IF Y.FT.DATE.TIME LT Y.FLAG.FECHA.VAL THEN
            J.TIPO.CTA = Y.TIPO.AC.TRANS.NVL2
        END ELSE
            IF Y.FT.DATE.TIME GT Y.FLAG.FECHA.VAL THEN
                J.TIPO.CTA = Y.TIPO.AC.TRANS.NVL4L
            END
        END
    END   ;* AAR-20221107 - E

    J.CRED.ACC = REC.FUNDS.TRANFER<FT.Contract.FundsTransfer.CreditAcctNo>
    FIND Y.CANAL.OPERACION IN Y.ARR.NOM.PARAM.CANAL SETTING AvCan, VpCan, SmCan THEN
        Y.CANAL.REPORTE = Y.ARR.DAT.PARAM.CANAL<AvCan,VpCan>
    END ELSE
        FINDSTR "XT24.USER" IN J.INPUTTER.FT SETTING Ap4, Vp4 THEN
            Y.CANAL.REPORTE = "BANCA"
        END ELSE
            Y.CANAL.REPORTE = "SUCURSAL"
        END
    END

    LOCATE J.TRANS.REF[1,16] IN YARR.AA.BANCA SETTING POS THEN
        Y.CANAL.REPORTE = "BANCA"
    END

    Y.USER.CELULAR = 0
    Y.CATEG.CELULAR = 0

    FOR I.USER = 1 TO NO.USER
        FINDSTR Y.USUARIOS.CELULAR<I.USER> IN J.INPUTTER.FT SETTING Ap4, Vp4 THEN
            Y.USER.CELULAR = 1
        END
    NEXT I.USER

    LOCATE CATEG IN Y.CATEGORIAS.CELULAR SETTING POS.CATEG THEN
        Y.CATEG.CELULAR = 1
    END

    IF Y.USER.CELULAR AND Y.CATEG.CELULAR THEN
        Y.CANAL.REPORTE = "CELULAR"
    END

    FIND J.TRANS.CODE IN Y.ARR.NOM.PARAM.REP SETTING AvTr, Vptr, SmTr THEN
        ARR.VALORES.TRANS = Y.ARR.DAT.PARAM.REP<AvTr,Vptr>
        IF J.TRANS.CODE EQ "910" THEN

            IF YFLD.PAYMENT EQ "ABC" THEN
                Y.CANAL.REPORTE = "SUCURSAL"
            END ELSE
                Y.CANAL.REPORTE = ""
            END
        END
        IF Y.CANAL.REPORTE EQ "SUCURSAL" THEN
            J.CANAL = ARR.VALORES.TRANS<1,1,1>
        END
        IF Y.CANAL.REPORTE EQ "BANCA" THEN
            J.CANAL = ARR.VALORES.TRANS<1,1,2>
        END
        IF Y.CANAL.REPORTE EQ "OTROS" THEN
            J.CANAL = ARR.VALORES.TRANS<1,1,2>
        END
        IF Y.CANAL.REPORTE EQ "CELULAR" THEN      ;* INICIO CMB-20240503
            J.CANAL = ARR.VALORES.TRANS<1,1,5>
        END         ;* FIN CMB-20240503
        IF J.AMOUNT GT 0 THEN
            J.TIPO.OPER = ARR.VALORES.TRANS<1,1,3>
        END ELSE
            J.TIPO.OPER = ARR.VALORES.TRANS<1,1,4>
        END
    END
    J.R24 = ''
    IF J.CANAL NE '' AND J.TIPO.OPER NE '' THEN
        EB.DataAccess.FRead(FN.CUSTOMER,YID.CLIENTE,REGISTRO.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
        IF REGISTRO.CUSTOMER THEN
            Y.ID.COMISIONISTA = REGISTRO.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,YPOS.ID.COMISIONISTA>
            IF Y.ID.COMISIONISTA NE "" THEN
                J.CANAL = CANAL.COMISIONISTA
            END
        END
        J.R24 = 'SI'
    END

    J.ARR.DESG = J.R24:',':ID.AC:',':CATEG:',':ID.STMT:',':J.TRANS.CODE:',':J.AMOUNT:',':J.TRANS.REF:',':J.INPUTTER.FT:',':J.CRED.REF:',':J.CRED.ACC:',':J.DEBT.REF:',':J.TIPO.CTA:',':J.CANAL:',':J.TIPO.OPER:',':Y.ID.COMISIONISTA:',':Y.CANAL.OPERACION
    GOSUB ESCRIBE.ARCHIVO

RETURN

END