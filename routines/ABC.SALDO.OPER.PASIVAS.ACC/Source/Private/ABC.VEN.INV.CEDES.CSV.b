* @ValidationCode : MjoxMTY2MDUzNTI1OkNwMTI1MjoxNzYzNjc2NjcwOTgxOkVkZ2FyIFNhbmNoZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Nov 2025 16:11:10
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
$PACKAGE AbcSaldoOperPasivasAcc

SUBROUTINE ABC.VEN.INV.CEDES.CSV
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING EB.Service
    $USING EB.Updates
    $USING AA.Framework
    $USING AA.Officers
    $USING AA.Settlement
    $USING AC.AccountOpening
    $USING AbcSpei
    $USING ST.Config
    $USING AA.PaymentSchedule
    $USING AA.TermAmount
    $USING AA.Interest
    $USING EB.Reports
    $USING EB.API
    $USING AbcAccount
*-----------------------------------------------------------------------------
    GOSUB AA.INIT
    GOSUB AA.PROCESS

RETURN
********
AA.INIT:
********
    FN.AA.ARR   = 'F.AA.ARRANGEMENT'
    F.AA.ARR    = ''
    EB.DataAccess.Opf(FN.AA.ARR,F.AA.ARR)

    FN.ACC  = 'F.ACCOUNT'
    F.ACC   = ''
    EB.DataAccess.Opf(FN.ACC,F.ACC)

    F.AA.INT.ACC    = ''
    FN.AA.INT.ACC   = 'F.AA.INTEREST.ACCRUALS'
    EB.DataAccess.Opf(FN.AA.INT.ACC,F.AA.INT.ACC)

*    FN.CONCATE  = 'F.ABC.VEN.INV.CEDES.CSV.LIST'
*    F.CONCATE   = ''
*    EB.DataAccess.Opf(FN.CONCATE,F.CONCATE)
  
    FN.ABC.ACCT.LCL.FLDS    = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS     = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)

    A.SEP   = ','
    TODAY   = EB.SystemTables.getToday()

    Y.ID.GEN.PARAM  = 'ABC.VEN.SAL.OP.PAS'
    Y.LIST.PARAMS   = ''
    Y.LIST.VALUES   = ''
    Y.SEP = '|'
    
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE 'PATH' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.PATH = Y.LIST.VALUES<Y.POS.PARAM>
    END

    LOCATE 'NOM.ARCH.VEN.SAL.OP' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.NOM.ARCH.CEDE = Y.LIST.VALUES<Y.POS.PARAM>
    END

    Y.FECHA = TODAY
    Y.NOM.ARCH.CEDE = EREPLACE(Y.NOM.ARCH.CEDE,"AAAAMMDD",Y.FECHA)
    
    FN.SFILE    = Y.PATH : "/" : Y.NOM.ARCH.CEDE
    F.SFILE     = ""
    OPENSEQ FN.SFILE TO F.SFILE ELSE
        CREATE F.SFILE ELSE NULL
    END

    ENCABEZADO = 'SUCURSAL,NUMERO CLIENTE,NOMBRE CLIENTE,PROMOTOR,INVERSION,CUENTA,CATEGORIA,NOMBRE CATEGORIA,FECHA INICIO,'
    ENCABEZADO := 'FECHA FIN,MONTO INVERSION,CAPITAL,INTERES,DIAS,TIPO VENCIMIENTO,NUM GRUPO,NOMBRE GRUPO,SALDO GRUPO'

    WRITESEQ ENCABEZADO TO F.SFILE ELSE NULL

RETURN
***********
AA.PROCESS:
***********
    SEL.CMD     = ''
    SEL.LIST    = ''
    NO.OF.REC   = ''
    ERR         = ''
    
*SEL.CMD = 'SELECT ' : FN.AA.ARR :  ' WITH ( PRODUCT EQ "DEPOSIT.PROMISSORY" OR PRODUCT EQ "DEPOSIT.FIXED.INT" ) AND ARR.STATUS EQ "CURRENT" '  ; * ITSS - SUNDRAM - Added "
    SEL.CMD = 'SELECT ' : FN.AA.ARR :  ' WITH ( PRODUCT EQ "ABC.DEPOSIT.FIXED.INT" OR PRODUCT EQ "DEPOSIT.PROMISSORY" OR PRODUCT EQ "DEPOSIT.VAR.INT" OR PRODUCT EQ "DEPOSIT.FIXED.INT") AND ARR.STATUS EQ "CURRENT" '
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)

    EB.Service.BatchBuildList('',SEL.LIST)
    
    LOOP
        REMOVE ARR.ID FROM SEL.LIST SETTING ARR.POS
    WHILE ARR.ID : ARR.POS
        Y.ID.AA = ARR.ID
        EB.DataAccess.FRead(FN.AA.ARR,Y.ID.AA,REC.ARR,F.AA.ARR,ERR.ARR)
        AA.ARR.LINKED.ID = REC.ARR<AA.Framework.Arrangement.ArrLinkedApplId>
        EB.DataAccess.FRead(FN.ACC,AA.ARR.LINKED.ID,REC.ACC,F.ACC,ERR.ACC)
    
        idProperty  = ''
        returnIds   = ''
        returnConditions    = ''
        returnError         = ''
        ID.LD               = ''
        CURR.PROP = 'ACCOUNT'
        AA.Framework.GetArrangementConditions(Y.ID.AA,CURR.PROP,idProperty,effectiveDate,returnIds,returnConditions,returnError)
    
        IF returnConditions NE '' THEN
            returnConditions = RAISE(returnConditions)
            ID.LD = returnConditions<11,1>
        END
    
        GOSUB GET.OFFICER.DETAILS
    REPEAT

RETURN
********************
GET.OFFICER.DETAILS:
********************

    EFF.DATE        = TODAY
    R.ACCOUNT.ID    = ''
    R.ACCOUNT.COND  = ''
    ACCT.ERR        = ''
    
    AA.Framework.GetArrangementConditions(Y.ID.AA,'OFFICERS','',EFF.DATE,R.OFFICER.ID,R.OFFICER.COND,ACCT.ERR)
    
    IF R.OFFICER.COND EQ "" THEN
        AA.Framework.GetArrangementConditions(Y.ID.AA,'OFFICERS','OFFICERS',EFF.DATE,R.OFFICER.ID,R.OFFICER.COND,ACCT.ERR)
    END
    
    ID.CLIENTE      = ''
    NOMBRE.CLIENTE  = ''
    R.OFFICER.COND  = RAISE(R.OFFICER.COND)
    V.SUCURSAL      = R.OFFICER.COND<AA.Officers.Officers.OffPrimaryOfficer>
    V.CTE           = REC.ARR<AA.Framework.Arrangement.ArrCustomer>

    ID.CLIENTE = REC.ARR<AA.Framework.Arrangement.ArrCustomer>
    AbcSaldoOperPasivasAcc.AaCustomerImpresion(ID.CLIENTE,NOMBRE.CLIENTE)
    
    V.NOMBRE = NOMBRE.CLIENTE
    V.PROMOTOR =  V.SUCURSAL

    V.ID = ''
    IF ID.LD EQ '' THEN
        V.ID = Y.ID.AA
    END ELSE
        IF ID.LD[1,2] EQ 'LD' THEN
            V.ID = ID.LD
        END
    END

    EFF.DATE            = TODAY
    R.SETTLEMENT.ID     = ''
    R.SETTLEMENT.COND   = ''
    SET.ERR             = ''
    AA.Framework.GetArrangementConditions(Y.ID.AA,'SETTLEMENT','',EFF.DATE,R.SETTLEMENT.ID,R.SETTLEMENT.COND,SET.ERR)
    R.SETTLEMENT.COND = RAISE(R.SETTLEMENT.COND)

    SET.ACC = ''
    SET.ACC = R.SETTLEMENT.COND<AA.Settlement.Settlement.SetPayoutAccount>
    V.CTA   = R.SETTLEMENT.COND<AA.Settlement.Settlement.SetPayoutAccount>
    V.CATEGORY  = ''
    V.CATEGORY  = REC.ACC<AC.AccountOpening.Account.Category>
    YCATEG.R13  = V.CATEGORY
    YCATE.R06   = ''
    AbcSpei.AbcTraeGeneralParam("ABC.INVERSIONES",YCATEG.R13,YCATE.R06)
  
    V.CATEGORY = FIELD(YCATE.R06,"#",1)
    
*ITSS-NYADAV
*    CALL DBR("CATEGORY" : FM : EB.CAT.SHORT.NAME, V.CATEGORY, V.NOM.CATEGORY)
    EB.DataAccess.CacheRead("F.CATEGORY", V.CATEGORY, R.CAT, ERR.CAT)
    V.NOM.CATEGORY = R.CAT<ST.Config.Category.EbCatShortName>
*ITSS-NYADAV
    R.RECORD    = EB.Reports.getRRecord()
    V.MONTO.INVERSION = FMT(R.RECORD<17, 1>, "R2")
    GOSUB GET.TOT.AMT
    
    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS, SET.ACC, CTA.RS, F.ABC.ACCT.LCL.FLDS, ACC.ERR1)
    
    V.GPO  = CTA.RS<AbcTable.AbcAcctLclFlds.GpoClubAhorro>
    IF V.GPO NE '' THEN
        EB.DataAccess.Dbr("ABC.CLUB.AHORRO" : @FM : ACA.NOMBRE.GRUPO, V.GPO, V.NOM.GPO)
        O.DATA = V.GPO : '*0'
        EB.Reports.setOData(O.DATA)
        AbcAccount.BaClubAhorroGetSaldo()
        O.DATA  = EB.Reports.getOData()
        FINDSTR 'ERROR.' IN O.DATA SETTING Ap, Vp THEN
            V.SAL.GPO = ''
        END ELSE
            V.SAL.GPO = FMT(FIELD(O.DATA,'*',1), "R2")
        END
    END ELSE
        V.SAL.GPO = ''
    END

    SIM.REF         = ''
    CYCLE.DATE      = ''
    TOT.PAYMENT     = ''
    DUE.DATES       = ''
    DUE.TYPES       = ''
    DUE.METHODS     = ''
    DUE.TYPE.AMTS   = ''
    DUE.PROPS       = ''
    DUE.PROP.AMTS   = ''
    DUE.OUTS        = ''
*    CALL AA.SCHEDULE.PROJECTOR(Y.ID.AA,SIM.REF,"",CYCLE.DATE,TOT.PAYMENT,DUE.DATES,DUE.TYPES,DUE.METHODS,DUE.TYPE.AMTS,DUE.PROPS,DUE.PROP.AMTS,DUE.OUTS)         ;* Routine to Project complete schedules
    AA.PaymentSchedule.ScheduleProjector(Y.ID.AA, SIM.REF, '', CYCLE.DATE, TOT.PAYMENT, DUE.DATES, '', DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
    
    NO.OF.SCHEDULES = DCOUNT(DUE.DATES,@FM)
    FOR I = 2 TO NO.OF.SCHEDULES
        IF I EQ  NO.OF.SCHEDULES  THEN
            TIPO.VEN = 'CAPITAL E INTERES'
        END ELSE
            TIPO.VEN = 'INTERES'
        END
        GOSUB PROCESAR.CUPON
    NEXT I

RETURN
************
GET.TOT.AMT:
************
    AMT.ERR     = ''
    R.AMT.COND  = ''
    R.AMT.ID    = ''
    AA.Framework.GetArrangementConditions(Y.ID.AA,'TERM.AMOUNT','',EFF.DATE,R.AMT.ID,R.AMT.COND,AMT.ERR)
    R.AMT.COND  = RAISE(R.AMT.COND)
    V.CAPITAL   = R.AMT.COND<AA.TermAmount.TermAmount.AmtAmount>
    V.MONTO.INVERSION = R.AMT.COND<AA.TermAmount.TermAmount.AmtAmount>
    V.DIAS      = R.AMT.COND<AA.TermAmount.TermAmount.AmtTerm>

RETURN
***************
PROCESAR.CUPON:
***************
    V.VALUE.DATE = ''
    V.VALUE.DATE = REC.ARR<AA.PaymentSchedule.AccountDetails.AdContractDate>
    IF V.VALUE.DATE EQ '' THEN
        R.ACT.DET       = ''
        ERROR.ACT.DET   = ''
        PROCESS.TYPE    = "INITIALISE"
        AA.PaymentSchedule.ProcessAccountDetails(Y.ID.AA,PROCESS.TYPE,'',R.ACT.DET,ERROR.ACT.DET)

        IF R.ACT.DET NE '' THEN
            V.VALUE.DATE = R.ACT.DET<2>
        END
    END

    V.FIN.MAT.DATE = ''
    V.FIN.MAT.DATE = DUE.DATES<I>

    IF V.FIN.MAT.DATE[1,6] EQ TODAY[1,6] THEN
        V.DIAS = ''
        IF LEN(V.VALUE.DATE) EQ 8 AND LEN(V.FIN.MAT.DATE) EQ 8 THEN
            V.DIAS = 'C'
            EB.API.Cdd('',V.VALUE.DATE, V.FIN.MAT.DATE, V.DIAS)
        END

        V.INTERES = ''
        V.INTERES = DUE.TYPE.AMTS<I,1>
        A.DATOS.INS.2  = V.SUCURSAL :A.SEP: V.CTE :A.SEP: V.NOMBRE :A.SEP: V.PROMOTOR :A.SEP: V.ID :A.SEP: V.CTA :A.SEP: V.CATEGORY :A.SEP: V.NOM.CATEGORY:A.SEP
        A.DATOS.INS.2 := V.VALUE.DATE :A.SEP: V.FIN.MAT.DATE :A.SEP: V.MONTO.INVERSION :A.SEP: V.CAPITAL :A.SEP: V.INTERES  :A.SEP
        A.DATOS.INS.2 := V.DIAS :A.SEP : TIPO.VEN :A.SEP: V.GPO :A.SEP: V.NOM.GPO :A.SEP: V.SAL.GPO
        A.DATOS.2 = A.DATOS.INS.2

        WRITESEQ A.DATOS.2 TO F.SFILE ELSE NULL
    END

RETURN
**********
END
