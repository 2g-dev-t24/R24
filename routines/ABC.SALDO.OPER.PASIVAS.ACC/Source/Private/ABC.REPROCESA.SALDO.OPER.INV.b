* @ValidationCode : MjotMjk3MjI0MDg6Q3AxMjUyOjE3Njk2MTUxMzU0NDA6RWRnYXIgU2FuY2hlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Jan 2026 09:45:35
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
$PACKAGE AbcSaldoOperPasivasAcc

SUBROUTINE ABC.REPROCESA.SALDO.OPER.INV(ARR.ID)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*===============================================================================
* Modificado por : CAST
* Fecha          : 07 Mayo 2024
* Descripcion    : Rutina emergente se genera para obtener el reporte de Saldos
*                      Operativos de Inversiones para fechas pasadas.
*===============================================================================
* Modificado     : esanchezg - FyG Solutions
* Fecha Cambio   : 20250908
* Modificaciones : Se agrega validacion de tasa de interes para Saldos
*      Operativos para PRLV 1D.
*===============================================================================
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING AbcTable
    $USING AC.AccountOpening
    $USING ST.Config
    $USING AA.PaymentSchedule
    $USING AbcSaldoOperPasivasAcc
    $USING AA.Framework
    $USING AA.Settlement
    $USING ST.Customer
    $USING AA.Officers
    $USING AA.Interest
    $USING AC.EntryCreation
    $USING BF.ConBalanceUpdates
    $USING AA.TermAmount
    $USING EB.API
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    DISPLAY ARR.ID
    
    CLI.ERR1        = ''
    CLI.RS          = ''
    A.SEP.INI       = '*'
    A.SEP.FIN       = ','
    Y.CUENTA        = ''
    Y.NO.CLIENTE    = ''
    Y.NOM.CLIENTE   = ''
    Y.EJECUTIVO     = ''
    Y.LD.SUC        = ''
    Y.LD.NO.INV     = ''
    Y.LD.FECHA.INI  = ''
    Y.LD.FECHA.VEN  = ''
    Y.LD.CAPITAL    = ''
    Y.LD.INT.DEV    = ''
    Y.LD.SPREAD     = ''
    Y.LD.PLAZO      = ''
    Y.LD.TASA       = ''
    Y.LD.EJECUTIVO  = ''
    Y.LD.GRUPO      = ''
    Y.LD.PRODUCTO   = ''
    Y.VARIABLE = CHAR(236)
    Y.TODAY                 = AbcSaldoOperPasivasAcc.getYToday()
    
    FN.ABC.ACCT.LCL.FLDS    = AbcSaldoOperPasivasAcc.getFnAbcAcctLclFlds()
    F.ABC.ACCT.LCL.FLDS     = AbcSaldoOperPasivasAcc.getFAbcAcctLclFlds()

    FN.TBL.INS      = AbcSaldoOperPasivasAcc.getFnTblIns()
    F.TBL.INS       = AbcSaldoOperPasivasAcc.getFTblIns()
    
    YPOS.NOM.PER.MORAL  = AbcSaldoOperPasivasAcc.getYPosNomPerMoral()
    
    A.CAT.CAMPO.001 = AbcSaldoOperPasivasAcc.getACatCampo001()
    A.CAT.CAMPO.002 = AbcSaldoOperPasivasAcc.getACatCampo002()
    A.CAT.CAMPO.003 = AbcSaldoOperPasivasAcc.getACatCampo003()
    
***LOG
    Y.MSG = ''
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    R.ACCOUNT.DETAILS   = ''
    ST.DT               = ''
    MAT.DT              = ''
    AC.ACCRUAL.STATUS   = ''
    ACC.OVERDUE.STATUS  = ''
***LOG
*    GOSUB CREATE.LOG
    Y.MSG<-1>= 'ID A PROCESAR: ':ARR.ID
    
    AA.PaymentSchedule.ProcessAccountDetails(ARR.ID, 'INITIALISE', '', R.ACCOUNT.DETAILS, ERRMSG)
***LOG
    Y.MSG<-1>=  'AA.PaymentSchedule.ProcessAccountDetails-->':R.ACCOUNT.DETAILS

    IF R.ACCOUNT.DETAILS THEN
        Y.LD.FECHA.INI = R.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdValueDate>
        Y.LD.FECHA.VEN = R.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdMaturityDate>
    END
    IF Y.LD.FECHA.INI LE Y.TODAY AND Y.LD.FECHA.VEN GT Y.TODAY THEN
        GOSUB SET.VALORES.INV.AA
    END ELSE
*        RETURN
    END
***LOG
*    GOSUB SAVE.LOG

RETURN
*-----------------------------------------------------------------------------
SET.VALORES.INV.AA:
*-----------------------------------------------------------------------------
    GOSUB GET.AC.DETAILS
    GOSUB GET.OFFICER.DETAILS
    GOSUB GET.ACCR.INT
    GOSUB GET.TOT.AMT
    GOSUB GET.INT.RATE

RETURN
*-----------------------------------------------------------------------------
GET.AC.DETAILS:
*-----------------------------------------------------------------------------
    EFF.DATE    = Y.TODAY
    R.SETT.ID   = ''
    R.SETT.COND = ''
    SETT.ERR    = ''
    AA.Framework.GetArrangementConditions(ARR.ID,'SETTLEMENT','',EFF.DATE,R.SETT.ID,R.SETT.COND,SETT.ERR)
    IF R.SETT.COND EQ "" THEN
        AA.Framework.GetArrangementConditions(ARR.ID,'SETTLEMENT','SETTLEMENT',EFF.DATE,R.SETT.ID,R.SETT.COND,SETT.ERR)
    END

    R.SETT.COND = RAISE(R.SETT.COND)
    Y.CUENTA    = R.SETT.COND<AA.Settlement.Settlement.SetPayoutAccount><1,1>

    CTA.RS      = ''
    CTA.ERR1    = ''
    CTA.RS      = AC.AccountOpening.Account.Read(Y.CUENTA, CTA.ERR1)
    AC.ACCOUNT.OFFICER  = CTA.RS<AC.AccountOpening.Account.AccountOfficer>
    ACC.ID.FLDS         = CTA.RS<AC.AccountOpening.Account.ArrangementId>

    EJE.RS = ST.Config.DeptAcctOfficer.Read(AC.ACCOUNT.OFFICER, EJE.ERR1)
    
    Y.EJECUTIVO = EJE.RS<ST.Config.DeptAcctOfficer.EbDaoName>
    Y.EJECUTIVO = UPCASE(Y.EJECUTIVO)

    Y.NO.CLIENTE    = ''
    Y.NO.CLIENTE    = CTA.RS<AC.AccountOpening.Account.Customer>
    CLI.RS          = ''
    CLI.ERR1        = ''
    CLI.RS          = ST.Customer.Customer.Read(Y.NO.CLIENTE, CLI.ERR1)

    A.CLI.CLAS          = CLI.RS<ST.Customer.Customer.EbCusSector>
    A.CLI.CLAS          = A.CLI.CLAS[1,1]
    Y.NOM.CLIENTE       = ''
    IF A.CLI.CLAS LT 3 THEN
        Y.NOM.CLIENTE  = CLI.RS<ST.Customer.Customer.EbCusShortName>:' '
        Y.NOM.CLIENTE := CLI.RS<ST.Customer.Customer.EbCusNameOne>:' '
        Y.NOM.CLIENTE := CLI.RS<ST.Customer.Customer.EbCusNameTwo>:' '
    END ELSE
        EB.CUS.LOCAL.REF    = CLI.RS<ST.Customer.Customer.EbCusLocalRef>
        Y.NOM.CLIENTE       = EB.CUS.LOCAL.REF<1,YPOS.NOM.PER.MORAL>
    END
    Y.NOM.CLIENTE = TRIM(Y.NOM.CLIENTE)

RETURN
*-----------------------------------------------------------------------------*
GET.OFFICER.DETAILS:
*-----------------------------------------------------------------------------*
    EFF.DATE        = Y.TODAY
    R.OFFICER.ID    = ''
    R.OFFICER.COND  = ''
    DAO.ERR         = ''
    AA.Framework.GetArrangementConditions(ARR.ID,'OFFICERS','',EFF.DATE,R.OFFICER.ID,R.OFFICER.COND,DAO.ERR)
    IF R.OFFICER.COND EQ "" THEN
        AA.Framework.GetArrangementConditions(ARR.ID,'OFFICERS','OFFICER',EFF.DATE,R.OFFICER.ID,R.OFFICER.COND,DAO.ERR)
    END

    R.OFFICER.COND  = RAISE(R.OFFICER.COND)
    Y.LD.SUC        = R.OFFICER.COND<AA.Officers.Officers.OffPrimaryOfficer>
    Y.LD.SUC        = Y.LD.SUC[1,5]
    EJE.RS          = ST.Config.DeptAcctOfficer.Read(Y.LD.SUC, EJE.ERR1)

    Y.LD.SUC = EJE.RS<ST.Config.DeptAcctOfficer.EbDaoName>

    idProperty          = ''
    returnIds           = ''
    returnConditions    = ''
    returnError         = ''
    ID.LD               = ''
    CURR.PROP = 'ACCOUNT'
    AA.Framework.GetArrangementConditions(ARR.ID,CURR.PROP,idProperty,effectiveDate,returnIds,returnConditions,returnError)
    IF returnConditions NE '' THEN
        returnConditions = RAISE(returnConditions)
        ID.LD = returnConditions<11,1>
    END

RETURN
*-----------------------------------------------------------------------------
GET.ACCR.INT:
*-----------------------------------------------------------------------------
    R.ARR.REC   = AA.Framework.Arrangement.Read(ARR.ID, ARR.RR)
    
    Y.AA.ACCOUNT = R.ARR.REC<AA.Framework.Arrangement.ArrLinkedApplId>
    Y.AA.PRODUCT = R.ARR.REC<AA.Framework.Arrangement.ArrProduct>
    IF Y.AA.PRODUCT EQ 'DEPOSIT.PROMISSORY' THEN
*    IF Y.AA.PRODUCT EQ 'DEPOSIT.VAR.INT' THEN
        Y.LD.INT.DEV    = ''
        INT.ACC.ID      = ARR.ID :"-": 'DEPOSITINT'
        R.INT.ACC       = ''
        R.INT.ACC       = AA.Interest.InterestAccruals.Read(INT.ACC.ID, ACC.ERR)

        NO.OF.REC           = DCOUNT(R.INT.ACC<AA.Interest.InterestAccruals.IntAccTotAccrAmt>,@VM)
        IntAccTotAccrAmt    = R.INT.ACC<AA.Interest.InterestAccruals.IntAccTotAccrAmt,NO.OF.REC>
        IntAccTotRpyAmt     = R.INT.ACC<AA.Interest.InterestAccruals.IntAccTotRpyAmt,NO.OF.REC>
        Y.LD.INT.DEV        = IntAccTotAccrAmt - IntAccTotRpyAmt
        
        R.EB.CONTRACT.BALANCES  = ''
        R.EB.CONTRACT.BALANCES  = BF.ConBalanceUpdates.EbContractBalances.Read(Y.AA.ACCOUNT, Y.ERR.EB.CONTRACT.BALANCES)

        IF R.EB.CONTRACT.BALANCES NE '' THEN
            Y.TOT.ECB.CATEG.ENT.IDS = R.EB.CONTRACT.BALANCES<BF.ConBalanceUpdates.EbContractBalances.EcbCategEntIds>
            Y.NO.ECB.CATEG.ENT.IDS = DCOUNT(Y.TOT.ECB.CATEG.ENT.IDS,@VM)
            FOR Y.AA = 1 TO Y.NO.ECB.CATEG.ENT.IDS
                Y.CATEG.ID      = FIELD(Y.TOT.ECB.CATEG.ENT.IDS<1,Y.AA>,"/",1)
                R.CATEG.ENTRY   = ''
                R.CATEG.ENTRY   = AC.EntryCreation.CategEntry.Read(Y.CATEG.ID, Y.ERR.CATEG.ENTRY)

                IF R.CATEG.ENTRY NE '' THEN
                    Y.AC.CAT.VALUE.DATE = R.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatValueDate>
                    IF Y.AC.CAT.VALUE.DATE GT Y.TODAY AND Y.NO.ECB.CATEG.ENT.IDS GT 1 THEN       ;* CAMB esanchez20250908
                        Y.AC.CAT.TRANSACTION.CODE = R.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatTransactionCode>
                        IF Y.AC.CAT.TRANSACTION.CODE EQ "862" OR Y.AC.CAT.TRANSACTION.CODE EQ "863" THEN
                            AC.CAT.AMOUNT.LCY   = R.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatAmountLcy>
                            Y.MONTO.INT.DEV     = AC.CAT.AMOUNT.LCY * (-1)
                            Y.LD.INT.DEV        -= Y.MONTO.INT.DEV
                        END
                    END
                    IF Y.AC.CAT.VALUE.DATE LE Y.TODAY THEN
                        BREAK
                    END
                END
            NEXT Y.AA
        END
    END ELSE
        R.AA.ACTIVITY.BALANCES  = ''
        R.AA.ACTIVITY.BALANCES  = AA.Framework.ActivityBalances.Read(ARR.ID, Y.ERR.AA.ACTIVITY.BALANCES)

        IF R.AA.ACTIVITY.BALANCES NE '' THEN
            Y.TOT.AA.ACT.BAL.ACTIVITY.DATE = R.AA.ACTIVITY.BALANCES<AA.Framework.ActivityBalances.ActBalActivityDate>
            Y.NO.AA.ACT.BAL.ACTIVITY.DATE = DCOUNT(Y.TOT.AA.ACT.BAL.ACTIVITY.DATE,@VM)
            FOR Y.AA = Y.NO.AA.ACT.BAL.ACTIVITY.DATE TO 1 STEP -1
                Y.AA.ACT.BAL.ACTIVITY.DATE = R.AA.ACTIVITY.BALANCES<AA.Framework.ActivityBalances.ActBalActivityDate,Y.AA>
                IF Y.AA.ACT.BAL.ACTIVITY.DATE EQ Y.TODAY THEN
                    Y.FECHA.DESDE = Y.TODAY
                    BREAK
                END
                IF Y.AA.ACT.BAL.ACTIVITY.DATE LT Y.TODAY THEN
                    Y.FECHA.DESDE = Y.AA.ACT.BAL.ACTIVITY.DATE
                    BREAK
                END
            NEXT Y.AA

            R.EB.CONTRACT.BALANCES  = ''
            R.EB.CONTRACT.BALANCES  = BF.ConBalanceUpdates.EbContractBalances.Read(Y.AA.ACCOUNT, Y.ERR.EB.CONTRACT.BALANCES)
 
            IF R.EB.CONTRACT.BALANCES NE '' THEN
                Y.TOT.ECB.CATEG.ENT.IDS = R.EB.CONTRACT.BALANCES<BF.ConBalanceUpdates.EbContractBalances.EcbCategEntIds>
                Y.NO.ECB.CATEG.ENT.IDS = DCOUNT(Y.TOT.ECB.CATEG.ENT.IDS,@VM)
                FOR Y.AA = 1 TO Y.NO.ECB.CATEG.ENT.IDS
                    Y.CATEG.ID = FIELD(Y.TOT.ECB.CATEG.ENT.IDS<1,Y.AA>,"/",1)
                    R.CATEG.ENTRY = ''
                    AC.EntryCreation.CategEntry.Read(Y.CATEG.ID, Y.ERR.CATEG.ENTRY)

                    IF R.CATEG.ENTRY NE '' THEN
                        Y.AC.CAT.VALUE.DATE = R.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatValueDate>
                        IF Y.AC.CAT.VALUE.DATE GE Y.FECHA.DESDE AND Y.AC.CAT.VALUE.DATE LE Y.TODAY THEN
                            Y.AC.CAT.TRANSACTION.CODE = R.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatTransactionCode>
                            IF Y.AC.CAT.TRANSACTION.CODE EQ "862" OR Y.AC.CAT.TRANSACTION.CODE EQ "863" THEN
                                AC.CAT.AMOUNT.LCY   = R.CATEG.ENTRY<AC.EntryCreation.CategEntry.CatAmountLcy>
                                Y.MONTO.INT.DEV     = AC.CAT.AMOUNT.LCY * (-1)
                                Y.LD.INT.DEV        += Y.MONTO.INT.DEV
                                Y.DISPLAY   = Y.FECHA.DESDE
                                Y.DISPLAY   := '-':Y.TODAY
                                Y.DISPLAY   := '-':ARR.ID
                                Y.DISPLAY   := '-':Y.CATEG.ID
                                Y.DISPLAY   := '-':Y.AC.CAT.VALUE.DATE
                                Y.DISPLAY   := '-':Y.MONTO.INT.DEV
                                DISPLAY Y.DISPLAY
                            END
                        END
                        IF Y.AC.CAT.VALUE.DATE LT Y.FECHA.DESDE THEN
                            BREAK
                        END
                    END
                NEXT Y.AA

            END
        END
    END
    Y.LD.INT.DEV = FMT(Y.LD.INT.DEV,"R3#19")

RETURN
*-----------------------------------------------------------------------------
GET.TOT.AMT:
*-----------------------------------------------------------------------------
    AMT.ERR     = ''
    R.AMT.COND  = ''
    R.AMT.ID    = ''
    AA.Framework.GetArrangementConditions(ARR.ID,'TERM.AMOUNT','',EFF.DATE,R.AMT.ID,R.AMT.COND,AMT.ERR)
    IF R.AMT.ID THEN
        R.AMT.COND      = RAISE(R.AMT.COND)
        Y.LD.CAPITAL    = ''
        Y.LD.CAPITAL    = R.AMT.COND<AA.TermAmount.TermAmount.AmtAmount>
        Y.LD.PLAZO      = ''
        IF Y.LD.FECHA.INI EQ '' THEN
            Y.LD.FECHA.INI  = R.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdContractDate>
            YPLAZO          = R.AMT.COND<AA.TermAmount.TermAmount.AmtTerm>
            Y.LD.PLAZO = FIELD(YPLAZO,'D',1)
        END ELSE
            Y.LD.PLAZO = 'C'
            IF LEN(Y.LD.FECHA.INI) EQ 8 AND LEN(Y.LD.FECHA.VEN) EQ 8 THEN
                EB.API.Cdd('',Y.LD.FECHA.INI,Y.LD.FECHA.VEN,Y.LD.PLAZO)
            END
        END
    END

    R.ACT.HIS   = ''
    ER.ACTI.HIS = ''
    V.CAPITAL   = ''
    LISTA.ACT.AMT       = ''
    LISTA.ACTIVITY.AMT  = ''
    R.ACT.HIS   = AA.Framework.ActivityHistory.Read(ARR.ID, ER.ACTI.HIS)

    IF R.ACT.HIS NE '' THEN
        LISTA.ACT.AMT       = R.ACT.HIS<AA.Framework.ActivityHistory.AhActivityAmt>
        LISTA.ACTIVITY.AMT  = R.ACT.HIS<AA.Framework.ActivityHistory.AhActivity>

        CONVERT @SM TO '' IN LISTA.ACT.AMT
        CONVERT @VM TO @FM IN LISTA.ACT.AMT
        CONVERT @VM TO @FM IN LISTA.ACTIVITY.AMT
        YPOS = ''
        FINDSTR 'DEPOSITS-APPLYPAYMENT-PR.DEPOSIT' IN LISTA.ACTIVITY.AMT SETTING YPOS THEN
            V.CAPITAL = LISTA.ACT.AMT<YPOS>
        END
    END

    IF V.CAPITAL NE '' THEN
        Y.LD.CAPITAL = V.CAPITAL
    END

RETURN
*-----------------------------------------------------------------------------
GET.INT.RATE:
*-----------------------------------------------------------------------------
    REC.ARR = ''
    REC.ARR = AC.AccountOpening.Account.Read(Y.AA.ACCOUNT, ERR.ARR)

    IF REC.ARR EQ '' THEN
        Y.ACCOUNT.ID.HIS = Y.AA.ACCOUNT
        REC.ARR = AC.AccountOpening.Account.ReadHis(Y.ACCOUNT.ID.HIS, Y.AC.HIS)
    END
    EFF.DATE        = Y.TODAY
    R.ACCOUNT.ID    = ''
    R.ACCOUNT.COND  = ''
    ACCT.ERR        = ''
    AA.Framework.GetArrangementConditions(ARR.ID,'INTEREST','',EFF.DATE,R.INTEREST.ID,R.INTEREST.COND,INT.ERR)
    A.LD.CATEGORY   = REC.ARR<AC.AccountOpening.Account.Category>
    Y.LD.SPREAD     = ''
    IF R.INTEREST.COND THEN
        R.INTEREST.COND = RAISE(R.INTEREST.COND)
        IF A.LD.CATEGORY NE '6605' THEN
            Y.LD.SPREAD = R.INTEREST.COND<AA.Interest.Interest.IntMarginRate>
        END
        Y.LD.TASA = R.INTEREST.COND<AA.Interest.Interest.IntEffectiveRate>
    END

    CTA.RS.LCL  = ''
    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS, ACC.ID.FLDS, CTA.RS.LCL, F.ABC.ACCT.LCL.FLDS, ERR.LCL)

    Y.LD.GRUPO      = CTA.RS.LCL<AbcTable.AbcAcctLclFlds.GpoClubAhorro>
    A.LD.CATEGORY   = REC.ARR<AC.AccountOpening.Account.Category>
    CAT.RS          = ST.Config.Category.Read(A.LD.CATEGORY, CAT.ERR1)

    EB.CAT.SHORT.NAME   = CAT.RS<ST.Config.Category.EbCatShortName,2>
    Y.LD.PRODUCTO       = UPCASE(EB.CAT.SHORT.NAME)

    Y.LD.NO.INV = ''
    IF ID.LD EQ '' THEN
        Y.LD.NO.INV = ARR.ID
    END ELSE
        IF ID.LD[1,2] EQ 'LD' THEN
            Y.LD.NO.INV = ID.LD
        END
    END
    
***LOG
    Y.MSG<-1>= 'IF Y.LD.FECHA.VEN GT Y.TODAY THEN':Y.LD.FECHA.VEN:'//':Y.TODAY
    
    IF Y.LD.FECHA.VEN GT Y.TODAY THEN
*        A.REGISTRO  = FMT(Y.CUENTA, "%11") : A.SEP.INI
        A.REGISTRO  = Y.CUENTA : A.SEP.INI
        A.REGISTRO := Y.NO.CLIENTE : A.SEP.INI
        A.REGISTRO := Y.LD.SUC : A.SEP.INI
        A.REGISTRO := Y.LD.NO.INV : A.SEP.INI
        A.REGISTRO := Y.NOM.CLIENTE : A.SEP.INI
        A.REGISTRO := Y.LD.FECHA.INI : A.SEP.INI
        A.REGISTRO := Y.LD.FECHA.VEN : A.SEP.INI
        A.REGISTRO := Y.LD.CAPITAL : A.SEP.INI
        A.REGISTRO := Y.LD.INT.DEV : A.SEP.INI
        A.REGISTRO := Y.LD.SPREAD : A.SEP.INI
        A.REGISTRO := Y.LD.PLAZO : A.SEP.INI
        A.REGISTRO := Y.LD.TASA : A.SEP.INI
        A.REGISTRO := Y.EJECUTIVO : A.SEP.INI
        A.REGISTRO := Y.LD.GRUPO : A.SEP.INI
        A.REGISTRO := Y.LD.PRODUCTO

        A.CATEGORY = A.LD.CATEGORY
        A.CONCEPTO = Y.LD.NO.INV

        GOSUB SET.GRABAR.REGISTRO
    END

RETURN
*-----------------------------------------------------------------------------*
SET.GRABAR.REGISTRO:
*-----------------------------------------------------------------------------*
    REGISTRO = ''
    REGISTRO<AbcTable.TmppRepSalOp.InfoReg> = A.REGISTRO

    REG.ID  = ''
    BEGIN CASE
        CASE A.CATEGORY MATCHES A.CAT.CAMPO.001       ;* CEDES TASA FIJA
            REG.ID = '001'
        CASE A.CATEGORY MATCHES A.CAT.CAMPO.002       ;* CEDES TASA VARIABLE Y CEDES TASA REVISABLES
            REG.ID = '002'
        CASE A.CATEGORY MATCHES A.CAT.CAMPO.003       ;* PAGARE
            REG.ID = '003'
    END CASE
    
    IF (REG.ID EQ '') THEN
        REG.ID = '007'  ;*OTROS
    END
    

    SEP.ID = '.'
    REG.ID = REG.ID:SEP.ID:A.CONCEPTO:SEP.ID:Y.TODAY
    CONVERT A.SEP.FIN TO '' IN REGISTRO
    CONVERT A.SEP.INI TO A.SEP.FIN IN REGISTRO
    
***LOG
    Y.MSG<-1>= 'GRABAT FN.TBL.INS -->':REG.ID:'/////':REGISTRO:'/////':FN.TBL.INS:'/////':F.TBL.INS
    
    EB.DataAccess.FWrite(FN.TBL.INS, REG.ID, REGISTRO)
*   WRITE REGISTRO TO F.TBL.INS, REG.ID ON ERROR
*       PRINT "ERROR AL ESCRIBIR EN TABLA ":FN.TBL.INS:" CON ID - ":REG.ID
*   END

    A.CATEGORY = ''
    A.CONCEPTO = ''

RETURN
**-----------------------------------------------------------------------------
*CREATE.LOG:
**-----------------------------------------------------------------------------
**    str_path = Y.RUTA.INFORMES.APP
*    str_path = '/shares/log'
*    str_filename = "ABC.REPROCESA.SALDO.OPER.INV":RND(2000000):TIME():".txt"
*    TEMP.FILE = str_path : "/" : str_filename
*
*    OPENSEQ TEMP.FILE TO ARCHIVO.LOG ELSE
*        CREATE ARCHIVO.LOG ELSE
*        END
*    END
*
*RETURN
**-----------------------------------------------------------------------------
*SAVE.LOG:
**-----------------------------------------------------------------------------
*    WRITESEQ Y.MSG APPEND TO ARCHIVO.LOG ELSE
*        Y.MENSAJE = "No se Consiguio Escribir el Archivo de log "
*        DISPLAY Y.MENSAJE
*    END
*
*RETURN
*-----------------------------------------------------------------------------
END