*-----------------------------------------------------------------------------
$PACKAGE AbcBi
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.REP.INVERSION(DATOS)
*-----------------------------------------------------------------------------
    
    $USING EB.Reports
    $USING EB.DataAccess
    $USING CG.ChargeConfig
    $USING AC.AccountOpening
    $USING AA.Framework
    $USING ST.Config
*    $USING AbcSaldoOperPasivasAcc
    $USING AA.Officers
    $USING AA.Settlement
    $USING AA.TermAmount
    $USING AA.Interest
    $USING EB.SystemTables
    $USING AbcTable

    GOSUB INICIA
    GOSUB PROCESO

    RETURN
*******
INICIA:
*******

    FN.AA.ARR = 'F.AA.ARRANGEMENT'
    F.AA.ARR = ''
    EB.DataAccess.Opf(FN.AA.ARR,F.AA.ARR)

    FN.PRO = 'F.DEPT.ACCT.OFFICER'
    F.PRO = ''
    EB.DataAccess.Opf(FN.PRO,F.PRO)

    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    EB.DataAccess.Opf(FN.ACC,F.ACC)

    FN.TAX = 'F.TAX'
    F.TAX = ''
    EB.DataAccess.Opf(FN.TAX,F.TAX)


    ID.CLIENTE = ''
    YPOS.CLIENTE = ''
    
    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()

    LOCATE "CLIENTE" IN SEL.FIELDS<1> SETTING YPOS.CLIENTE THEN
        ID.CLIENTE = SEL.VALUES<YPOS.CLIENTE>
    END

    SEL.ISR = ''
    LISTA.ISR = ''
    TOTAL.ISR = ''
    ERROR.ISR = ''
    TASA.ISR = ''

    SEL.ISR = 'SELECT ':FN.TAX:' WITH @ID LIKE ':DQUOTE(SQUOTE('21'):"..."):' BY @ID' 
    EB.DataAccess.Readlist(SEL.ISR,LISTA.ISR,'',TOTAL.ISR,ERROR.ISR)

    IF LISTA.ISR THEN
        ID.ISR = LISTA.ISR<TOTAL.ISR>
        R.TAX = ''
        ER.ISR = ''

        EB.DataAccess.FRead(FN.TAX,ID.ISR,R.TAX,F.TAX,ER.ISR)
        IF R.TAX THEN
            TASA.ISR = R.TAX<CG.ChargeConfig.Tax.EbTaxBandedRate,1>
        END
    END

    YSEP = '*'

    RETURN
********
PROCESO:
********

    IF ID.CLIENTE THEN
        SEL.ARR = ''
        ARREGLO.AA = ''
        NO.OF.ARR = ''
        ARR.ERR = ''

        SEL.ARR = 'SELECT ':FN.AA.ARR:' WITH CUSTOMER EQ ':DQUOTE(ID.CLIENTE):' AND ARR.STATUS EQ ': DQUOTE('CURRENT'):' BY @ID'  ; *ITSS - ANJALI - Added DQUOTE
        EB.DataAccess.Readlist(SEL.ARR ,ARREGLO.AA,'',NO.OF.ARR,ARR.ERR)

        LOOP
            ARR.ID = ''
            ARR.POS = ''

            REMOVE ARR.ID FROM ARREGLO.AA SETTING ARR.POS
        WHILE ARR.ID : ARR.POS
            GOSUB GET.BASIC.DETAILS
            GOSUB GET.SET.ACC
            GOSUB GET.NO.OF.TERM
            GOSUB GET.INT.DETAILS
            GOSUB GET.ACCT.OFFICER
            IF FECHA.FIN GT EB.SystemTables.getToday() THEN
                NUM.CONSECUTIVO += 1
                GOSUB ARMA.CADENA
            END
        REPEAT
    END

    RETURN
*****************
GET.ACCT.OFFICER:
*****************

    EFF.DATE = ''
    offCondition = ''
    OFF.ID = ''

    AA.Framework.GetArrangementConditions(ARR.ID,'OFFICERS','OFFICERS',EFF.DATE,of.Ids,offCondition,of.Error)

    IF offCondition EQ '' THEN 
       AA.Framework.GetArrangementConditions(ARR.ID,'OFFICERS','OFFICER',EFF.DATE,of.Ids,offCondition,of.Error)
    END
    offCondition = RAISE(offCondition)
    OFF.ID = offCondition<AA.Officers.Officers.OffPrimaryOfficer>
    IF OFF.ID THEN
        EB.DataAccess.FRead(FN.PRO,OFF.ID,REC.PROMOTERS,F.PRO,PRO.ERR)
        NOMBRE.PROMOTOR = ''
        IF REC.PROMOTERS THEN
            NOMBRE.PROMOTOR = REC.PROMOTERS<2>
        END
    END

    RETURN
************
GET.SET.ACC:
************

    setCondition  = ''
    s.Ids = ''
    ID.CUENTA = ''
    YEX.IMPUESTO = ''
    REC.CTA = ''

    AA.Framework.GetArrangementConditions(ARR.ID, 'SETTLEMENT', '', '', s.Ids, setCondition, s.Error)
    setCondition = RAISE(setCondition)
    ID.CUENTA = setCondition<AA.Settlement.Settlement.SetPayoutAccount>
    IF ID.CUENTA THEN
        EB.DataAccess.FRead(FN.ACC,ID.CUENTA,REC.CTA,F.ACC,ACC.ERR)
        IF REC.CTA THEN
            Y.ID.ARRAY = REC.CTA<AC.AccountOpening.Account.ArrangementId>
            EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
            IF R.ABC.ACCT.LCL.FLDS THEN                    
                YEX.IMPUESTO = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.ExentoImpuesto>
            END
         END
    END

    RETURN
******************
GET.BASIC.DETAILS:
******************

    NOMBRE.CLIENTE = ''
    IF ID.CLIENTE THEN
*        AbcSaldoOperPasivasAcc.AaCustomerImpresion(ID.CLIENTE,NOMBRE.CLIENTE)
    END

    EFF.DATE = ''
    PRODUCT.ID = ''
    ARR.REC = ''
    PROPERTY.LIST = ''

    AA.Framework.GetArrangementProduct(ARR.ID,EFF.DATE,ARR.REC,PRODUCT.ID,PROPERTY.LIST)
    FECHA.INICIO = ''
    FECHA.INI.LD = ''
    IF ARR.REC THEN
        FECHA.INICIO = ARR.REC<AA.Framework.Arrangement.ArrStartDate>
        IF FECHA.INICIO EQ '' THEN
            FECHA.INI.LD = ARR.REC<AA.Framework.Arrangement.ArrOrigContractDate>
            FECHA.INICIO = FECHA.INI.LD
        END
    END

    DESCRIPCION = ''
    CATEGORIA = ''
    BEGIN CASE
    CASE PRODUCT.ID EQ 'DEPOSIT.FIXED.INT'
        DESCRIPCION = 'CEDE FIJA'
        CATEGORIA   = '21003'
    CASE PRODUCT.ID EQ 'DEPOSIT.PROMISSORY'
        DESCRIPCION = 'PAGARE'
        CATEGORIA   = '21004'
    CASE PRODUCT.ID EQ 'DEPOSIT.VAR.INT'
        DESCRIPCION = 'CEDE VARIABLE'
        CATEGORIA   = '21005'
    CASE PRODUCT.ID EQ 'DEPOSIT.REVIEW.INT'
        DESCRIPCION = 'CEDE REVISABLE'
        CATEGORIA   = '21006'
    END CASE

    RETURN
***************
GET.NO.OF.TERM:
***************

    custCondition = ''
    r.Ids = ''
    ID.LD = ''
    ID.INVERSION = ''

    AA.Framework.GetArrangementConditions(ARR.ID,'ACCOUNT','','',r.Ids,custCondition,r.Error)
    custCondition = RAISE(custCondition)
    ID.LD = custCondition<11,1>
    IF ID.LD EQ '' THEN
        ID.INVERSION = ARR.ID
    END ELSE
        ID.INVERSION = ID.LD
    END

    custCondition = ''
    r.Ids = ''
    CAPITAL = ''
    PLAZO = ''
    FECHA.FIN = ''
    YPLAZO = ''

    AA.Framework.GetArrangementConditions(ARR.ID, 'TERM.AMOUNT', '', '', r.Ids, custCondition, r.Error)
    custCondition = RAISE(custCondition)
    CAPITAL = custCondition<AA.TermAmount.TermAmount.AmtAmount>
    FECHA.FIN = custCondition<AA.TermAmount.TermAmount.AmtMaturityDate>
    YPLAZO = FIELD(custCondition<AA.TermAmount.TermAmount.AmtTerm>,'D',1)

    IF FECHA.INI.LD EQ '' THEN
        PLAZO = YPLAZO
    END ELSE
        IF LEN(FECHA.INI.LD) EQ 8 AND LEN(FECHA.FIN) EQ 8 THEN
            PLAZO = "C"
            CALL CDD('',FECHA.INI.LD,FECHA.FIN,PLAZO)
        END
    END

    RETURN
****************
GET.INT.DETAILS:
****************

    intCondition  = ''
    i.Ids = ''
    TASA.BRUTA = ''
    YSPREAD = ''
    TASA = ''
    TASA.EFECT = ''
    INT.FLOAT = ''

    AA.Framework.GetArrangementConditions(ARR.ID, 'INTEREST', '', '', i.Ids, intCondition, s.Error)
    intCondition = RAISE(intCondition)
    TASA = intCondition<AA.Interest.Interest.IntFixedRate>
    YSPREAD = intCondition<AA.Interest.Interest.IntMarginRate>
    TASA.EFECT = intCondition<AA.Interest.Interest.IntEffectiveRate>
    INT.FLOAT = intCondition<AA.Interest.Interest.IntFloatingIndex>

    IF INT.FLOAT THEN
        TASA = TASA.EFECT
    END ELSE
        TASA += YSPREAD
    END

    IF YEX.IMPUESTO EQ 'S' THEN
        TASA.BRUTA = TASA.EFECT
    END ELSE
        TASA.BRUTA = TASA.EFECT - TASA.ISR
    END

    RETURN

************
ARMA.CADENA:
************

    YSALIDA  = ''
    YSALIDA  = NUM.CONSECUTIVO:YSEP
    YSALIDA := ID.CLIENTE:YSEP
    YSALIDA := NOMBRE.CLIENTE:YSEP
    YSALIDA := NOMBRE.PROMOTOR:YSEP
    YSALIDA := ID.INVERSION:YSEP
    YSALIDA := CATEGORIA:YSEP
    YSALIDA := DESCRIPCION:YSEP
    YSALIDA := ID.CUENTA:YSEP
    YSALIDA := FECHA.INICIO:YSEP
    YSALIDA := PLAZO:YSEP
    YSALIDA := FECHA.FIN:YSEP
    YSALIDA := CAPITAL:YSEP
    YSALIDA := TASA:YSEP
    YSALIDA := YSPREAD:YSEP
    YSALIDA := TASA.BRUTA

    FINDSTR ID.INVERSION IN DATOS SETTING Ap, Vp ELSE
        DATOS<-1> = YSALIDA
    END

    RETURN
**********
END
