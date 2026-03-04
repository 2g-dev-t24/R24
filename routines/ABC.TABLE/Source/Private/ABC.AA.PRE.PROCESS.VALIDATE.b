* @ValidationCode : MjoxMTk1MjY1NDMzOkNwMTI1MjoxNzcyNDE2ODQ4NzYxOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 01 Mar 2026 23:00:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.

$PACKAGE AbcTable

SUBROUTINE ABC.AA.PRE.PROCESS.VALIDATE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING AbcTable
    $USING AbcSpei
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING AC.AccountOpening
    $USING EB.API
    $USING ST.Config
    $USING AbcAccount
    $USING EB.AbcUtil
*    $USING AbcContractService
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.HOLI = 'F.HOLIDAY'
    F.HOLI  = ''
    EB.DataAccess.Opf(FN.HOLI,F.HOLI)

    FN.PRE.PROCESS.NAU  = 'F.ABC.AA.PRE.PROCESS$NAU'
    F.PRE.PROCESS.NAU   = ''
    EB.DataAccess.Opf(FN.PRE.PROCESS.NAU,F.PRE.PROCESS.NAU)
    
    Y.FUNCTION  = EB.SystemTables.getVFunction()
    TODAY       = EB.SystemTables.getToday()
    PGM.VERSION = EB.SystemTables.getPgmVersion()
    
    IF EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.EffectiveDate) EQ '' THEN
        EB.SystemTables.setRNew(AbcTable.AbcAaPreProcess.EffectiveDate, TODAY)
    END
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.FUNCTION EQ 'R' THEN
        DATE.CHK = TODAY
        EFFECTIVE.DATE = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.EffectiveDate)
        IF EFFECTIVE.DATE EQ DATE.CHK ELSE
            E = 'NOT ALLOWED TO REVERSE'
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
        END
    END
    
    AMT = ''

    IF Y.FUNCTION EQ 'I'  THEN
        PROM.DATE       = '1D':@VM:'7D':@VM:'14D':@VM:'21D':@VM:'28D':@VM:'60D':@VM:'91D':@VM:'180D':@VM:'270D':@VM:'365D'
        OTHER.DATE      = '84D':@VM:'168D':@VM:'252D':@VM:'364D':@VM:'532D':@VM:'728D':@VM:'140D'    ;*Se agrega el plazo de 140D
        AA.PRODUCT      = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.Product)
        AA.AMOUNT       = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.Amount)
        AA.TERM         = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.Term)
        AA.CUSTOMER.ID  = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.CustomerId)
        AA.CURRENCY     = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.Currency)
        AA.ACCOUNT.ID   = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.AccountId)
        
        BEGIN CASE
            CASE AA.PRODUCT EQ 'DEPOSIT.PROMISSORY' AND AA.AMOUNT LT '1'
                AMT ='1'
                GOSUB AMT.LESS.RAISE

            CASE AA.PRODUCT EQ 'DEPOSIT.FIXED.INT' AND AA.AMOUNT LT '1'
                AMT = '1'
                GOSUB AMT.LESS.RAISE

            CASE AA.PRODUCT EQ 'DEPOSIT.VAR.INT' AND AA.AMOUNT LT '1'
                AMT = '1'
                GOSUB AMT.LESS.RAISE

            CASE AA.PRODUCT EQ 'DEPOSIT.REVIEW.INT' AND AA.AMOUNT LT '1'
                AMT = '1'
                GOSUB AMT.LESS.RAISE
        END CASE

        BEGIN CASE
            CASE AA.PRODUCT EQ 'DEPOSIT.FIXED.INT' AND AA.TERM MATCHES OTHER.DATE
            CASE AA.PRODUCT EQ 'DEPOSIT.VAR.INT' AND AA.TERM MATCHES OTHER.DATE
            CASE AA.PRODUCT EQ 'DEPOSIT.REVIEW.INT' AND AA.TERM MATCHES OTHER.DATE
            CASE 1
                IF AA.PRODUCT NE 'DEPOSIT.PROMISSORY' THEN
                    GOSUB TERM.ERR.RAISE
                END
        END CASE

        IF AA.CUSTOMER.ID EQ '' THEN
            EB.SystemTables.setAf(AbcTable.AbcAaPreProcess.CustomerId)
            GOSUB INP.MAND.ERR
        END

        IF AA.CURRENCY EQ '' THEN
            EB.SystemTables.setAf(AbcTable.AbcAaPreProcess.Currency)
            GOSUB INP.MAND.ERR
        END

        IF AA.ACCOUNT.ID EQ '' THEN
            EB.SystemTables.setAf(AbcTable.AbcAaPreProcess.AccountId)
            GOSUB INP.MAND.ERR
        END
    
        GOSUB CHECK.AMT.DETAILS

    END

    Y.NOMBRE.RUTINA = "ABC.AA.PRE.PROCESS.VALIDATE" ;* aqui va el nombre de su rutina desde la que ejecutan la call rtn
    Y.CADENA.LOG<-1> =  "ID.NEW->" : EB.SystemTables.getIdNew()
    Y.CADENA.LOG<-1> =  "AA.PRODUCT->" : AA.PRODUCT
    Y.CADENA.LOG<-1> =  "Y.FUNCTION->" : Y.FUNCTION
    Y.CADENA.LOG<-1> =  "TODAY->" : TODAY
    Y.CADENA.LOG<-1> =  "PGM.VERSION->" : PGM.VERSION
    Y.CADENA.LOG<-1> =  "AA.EFFECTIVE.DATE->" : AA.EFFECTIVE.DATE
    Y.CADENA.LOG<-1> =  "AA.MAT.DATE->" : AA.MAT.DATE
    Y.CADENA.LOG<-1> =  "AA.PRODUCT->" : AA.PRODUCT
    Y.CADENA.LOG<-1> =  "AA.AMOUNT->" : AA.AMOUNT
    Y.CADENA.LOG<-1> =  "AA.CUSTOMER.ID->" : AA.CUSTOMER.ID
    Y.CADENA.LOG<-1> =  "AA.ACCOUNT.ID->" : AA.ACCOUNT.ID
    Y.CADENA.LOG<-1> =  "AA.TERM->" : AA.TERM
    Y.CADENA.LOG<-1> =  "AA.CURRENCY->" : AA.CURRENCY
    Y.CADENA.LOG<-1> =  "E->" : EB.SystemTables.getE()
    Y.CADENA.LOG<-1> =  "ETEXT->" : EB.SystemTables.getEtext()
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)

RETURN
*-----------------------------------------------------------------------------
CHECK.AMT.DETAILS:
*-----------------------------------------------------------------------------
    IF PGM.VERSION NE ',AA' THEN
        NAU.TOT.AMT     = ''
        
        ACCOUNT.NO      = AA.ACCOUNT.ID
        TOT.COMMITMENT  = AA.AMOUNT
        
        R.ACCT.DETS     = ''
        R.ACCT.DETS     = AC.AccountOpening.Account.Read(ACCOUNT.NO, ACC.ERR)

****** Additional Validation for Amount
* Working balance in account get updated immediately once record in ore preocess is created
* Once the service created AA record then only system will update the working balance in Account application

        NAU.SEL.CMD     = ''
        NAU.SEL.LIST    = ''
        NAU.SEL.CMD     = 'SELECT ' : FN.PRE.PROCESS.NAU :" WITH ARRANGEMENT.ID EQ '' AND RECORD.STATUS EQ 'INAU' AND ACCOUNT.ID EQ ": DQUOTE(ACCOUNT.NO)
        EB.DataAccess.Readlist(NAU.SEL.CMD,NAU.SEL.LIST,'',NO.OF.REC.DETS,SEL.CMD.ERR)

        LOOP
            REMOVE NAU.REC.ID FROM NAU.SEL.LIST SETTING NAU.POS
        WHILE NAU.REC.ID : NAU.POS
            NAR.REC.FULL.DETS = ''
            EB.DataAccess.FRead(FN.PRE.PROCESS.NAU,NAU.REC.ID,NAR.REC.FULL.DETS,F.PRE.PROCESS.NAU,PRE.PROCESS.ERR)
            AA.AMOUNT.NAU   = NAR.REC.FULL.DETS<AbcTable.AbcAaPreProcess.Amount>
            NAU.TOT.AMT     += AA.AMOUNT.NAU
        REPEAT
    
        LIV.WORK.AMT    = ''
        FIN.WORK.AMT    = ''

        TOT.LOCKED.AMOUNT = ''
        TODAY = EB.SystemTables.getToday()
        AbcSpei.AbcMontoBloqueado(ACCOUNT.NO,TOT.LOCKED.AMOUNT,TODAY)

        LIV.WORK.AMT = R.ACCT.DETS<AC.AccountOpening.Account.WorkingBalance>
        FIN.WORK.AMT = LIV.WORK.AMT - NAU.TOT.AMT - TOT.LOCKED.AMOUNT

        IF FIN.WORK.AMT LT TOT.COMMITMENT THEN
            EB.SystemTables.setAf(AbcTable.AbcAaPreProcess.Amount)
            E = 'Amount not available in the account. Available Amount is (Including NAU record in this application) ' : FIN.WORK.AMT
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
        END ELSE
            GOSUB GET.MAT.DATE
        END

    END

RETURN
*-----------------------------------------------------------------------------
CHECK.MATURITY.DATE.PRO:
*-----------------------------------------------------------------------------
    
    IF ROU.NO.DAYS NE NO.OF.DAYS THEN
        EB.SystemTables.setAf(AbcTable.AbcAaPreProcess.Term)
        E = 'Plazo & Vencimiento diferentes'
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.Err()
    END ELSE

        USR.MAT.DATE    = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.MatDate)
        DAYTYPE         = ''
        EB.API.Awd(YREGION,USR.MAT.DATE,DAYTYPE)

        AA.DATE.CONVENTION = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.DateConvention)
        
        IF DAYTYPE EQ 'H' AND AA.DATE.CONVENTION EQ '' THEN

            DATE.CONV ='1'
            
            tmp     = EB.SystemTables.getT(AbcTable.AbcAaPreProcess.DateConvention)
            tmp<3>  = ""
            EB.SystemTables.setT(AbcTable.AbcAaPreProcess.DateConvention, tmp)
            EB.Display.RebuildScreen()

            EB.SystemTables.setAf(AbcTable.AbcAaPreProcess.DateConvention)
            E = 'Maturity Date is a holiday,Choose either FORWARD or BACKWARD'
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
        END ELSE

            CONV.VALUE = AA.DATE.CONVENTION
            IF DATE.CONV EQ '1' OR DAYTYPE EQ 'H' THEN
* DIA_INHABIL
*  SIGUIENTE - Forward
                BEGIN CASE
                    CASE CONV.VALUE EQ 'SIGUIENTE'
                        EB.API.Cdt('',USR.MAT.DATE,"+1W")
                    CASE CONV.VALUE EQ 'ANTERIOR'
                        EB.API.Cdt('',USR.MAT.DATE,"-1W")
                END CASE

                EB.Display.RebuildScreen()
                
                NEW.NO.OF.DAYS  = ''
                NEW.NO.OF.DAYS  = 'C'
                EB.API.Cdd('',TODAY,USR.MAT.DATE,NEW.NO.OF.DAYS)
                
                EB.SystemTables.setRNew(AbcTable.AbcAaPreProcess.MatDate, USR.MAT.DATE)
                EB.SystemTables.setRNew(AbcTable.AbcAaPreProcess.Term, NEW.NO.OF.DAYS)
                
*                R.NEW(17) = ''
                EB.SystemTables.setRNew(AbcTable.AbcAaPreProcess.DateConvention, '')
                DATE.CONV = ''
            END

        END
    END

RETURN
*-----------------------------------------------------------------------------
CHECK.MATURITY.DATE:
*-----------------------------------------------------------------------------
    USR.MAT.DATE        = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.MatDate)
    DATE.USR.MAT.DATE   = USR.MAT.DATE[7,2]
    MONTH.USR.MAT.DATE  = USR.MAT.DATE[5,2]
    R.HOLIDAY           = ''
    Y.ID.HOLIDAY        = 'MX00':USR.MAT.DATE[1,4]
    EB.DataAccess.FRead(FN.HOLI,Y.ID.HOLIDAY,R.HOLIDAY,F.HOLI,ERR.HOLI)

    DATE.CONV   = ''
    FORM.VAR    = ST.Config.Holiday.EbHolMthZerOneTable
    FORM.VAR    = FORM.VAR + (MONTH.USR.MAT.DATE *1) -1
    
    CRT1        = R.HOLIDAY<FORM.VAR>
    CRT1        = CRT1[DATE.USR.MAT.DATE,1]
    CRT CRT1
    
    DEF.VALUE   ='13'
    DEF.VALUE   += MONTH.USR.MAT.DATE
    
    CRT2        = R.HOLIDAY<DEF.VALUE>
    CRT2        = CRT2[DATE.USR.MAT.DATE,1]
    CRT CRT2
    
    DATE.CONV   = '0'
    
    
*    IF R.HOLIDAY<DEF.VALUE>[DATE.USR.MAT.DATE,1] EQ 'H' THEN
    IF CRT1 EQ 'H' THEN

        OLD.MAT.DATE = ''
        OLD.MAT.DATE = USR.MAT.DATE
        EB.API.Cdt('',USR.MAT.DATE,'+1W')
        EB.SystemTables.setRNew(AbcTable.AbcAaPreProcess.MatDate, USR.MAT.DATE)

        TEXT = "Maturity date falls on holiday " : OLD.MAT.DATE :' & Moved to next working day ':USR.MAT.DATE
        EB.SystemTables.setText(TEXT)
        AA.OVERRIDE = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.Override)
        CURR.NO = DCOUNT(AA.OVERRIDE,@VM) + 1
        EB.OverrideProcessing.StoreOverride(CURR.NO)

    END

RETURN
*-----------------------------------------------------------------------------
GET.MAT.DATE:
*-----------------------------------------------------------------------------

    NO.OF.DAYS  = ''
    YDATE       = ''
;*    YDATE = TODAY   ;* MADM
    YDATE = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.EffectiveDate)          ;* MADM FIN
    
    IF YDATE LT TODAY THEN    ;* LFCR_20250516_VAL_EFF.DATE - S
        E = 'Effective Date cannot be less than today'
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.Err()
        RETURN
    END
    
    Y.NEXT.WD = TODAY
    EB.API.Cdt('', Y.NEXT.WD, "+1W")
    IF (YDATE NE TODAY) AND (YDATE NE Y.NEXT.WD) THEN
        E = 'Effective Date can only be TODAY or NEXT WORKING DAY'
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.Err()
        RETURN
    END   ;* LFCR_20250516_VAL_EFF.DATE - E
    
    EB.SystemTables.setRNew(AbcTable.AbcAaPreProcess.EffectiveDate, YDATE)
    NO.OF.DAYS  = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.Term)
    NO.OF.DAYS  = EREPLACE(NO.OF.DAYS,'D','')
    Y.CALENDAR = "+":NO.OF.DAYS:"C"
    EB.API.Cdt('',YDATE,Y.CALENDAR)
    
    AA.MAT.DATE = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.MatDate)
    IF AA.MAT.DATE EQ '' THEN
        EB.SystemTables.setRNew(AbcTable.AbcAaPreProcess.MatDate, YDATE)
        EB.SystemTables.setRNew(AbcTable.AbcAaPreProcess.RevFlag, '1')
        ROU.NO.DAYS = 'C'
        AA.MAT.DATE = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.MatDate)
        AA.EFF.DATE.AUX = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.EffectiveDate)
        EB.API.Cdd('',AA.EFF.DATE.AUX,AA.MAT.DATE,ROU.NO.DAYS)
    END ELSE
        ROU.NO.DAYS = 'C'
        AA.MAT.DATE = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.MatDate)
        EB.API.Cdd('',TODAY,AA.MAT.DATE,ROU.NO.DAYS)
        AA.TERM = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.Term)
        IF AA.TERM EQ '' THEN
            NO.OF.DAYS = ROU.NO.DAYS
        END
        IF AA.TERM EQ '' THEN
            TERM.UPD = ROU.NO.DAYS:"D"
            EB.SystemTables.setRNew(AbcTable.AbcAaPreProcess.Term, TERM.UPD)
        END
    END
    
    AA.PRODUCT = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.Product)
    IF AA.PRODUCT EQ 'DEPOSIT.PROMISSORY' THEN
        GOSUB CHECK.MATURITY.DATE.PRO
    END ELSE
        EB.SystemTables.setRNew(AbcTable.AbcAaPreProcess.MatDate, YDATE)
        USR.MAT.DATE = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.MatDate)
        GOSUB CHECK.MATURITY.DATE
    END

    E = EB.SystemTables.getE()
    IF NOT(E) THEN
        RET.ARRAY = ''
*        CALL INT.UPDATE(R.NEW(ABC.AA.ACCOUNT.ID),R.NEW(ABC.AA.EFFECTIVE.DATE),R.NEW(ABC.AA.TERM),R.NEW(ABC.AA.AMOUNT),R.NEW(ABC.AA.PRODUCT), RET.ARRAY)
        AA.ACCOUNT.ID       = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.AccountId)
        AA.EFFECTIVE.DATE   = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.EffectiveDate)
        AA.TERM             = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.Term)
        AA.AMOUNT           = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.Amount)
        AA.PRODUCT          = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.Product)
        AbcAccount.AbcIntUpdate(AA.ACCOUNT.ID,AA.EFFECTIVE.DATE,AA.TERM ,AA.AMOUNT,AA.PRODUCT, RET.ARRAY)
        
        EB.SystemTables.setRNew(AbcTable.AbcAaPreProcess.InterestRate, RET.ARRAY)
        
        AA.TERM.UPD = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.Term)
        AA.TERM.UPD = AA.TERM.UPD:"D"
        EB.SystemTables.setRNew(AbcTable.AbcAaPreProcess.Term, AA.TERM.UPD)

    END

RETURN
*-----------------------------------------------------------------------------
INP.MAND.ERR:
*-----------------------------------------------------------------------------
    E = 'Mandatory Input'
    EB.SystemTables.setE(E)
    EB.ErrorProcessing.Err()
    
RETURN
*-----------------------------------------------------------------------------
TERM.ERR.RAISE:
*-----------------------------------------------------------------------------
    EB.SystemTables.setAf(AbcTable.AbcAaPreProcess.Term)
    E = 'Term not the Specified one '
    EB.SystemTables.setE(E)
    EB.ErrorProcessing.Err()
    
RETURN
*-----------------------------------------------------------------------------
AMT.GTR.RAISE:
*-----------------------------------------------------------------------------
    EB.SystemTables.setAf(AbcTable.AbcAaPreProcess.Amount)
    E = 'Amount Greater than the Specified one ' : AMT
    EB.SystemTables.setE(E)
    EB.ErrorProcessing.Err()
    
RETURN
*-----------------------------------------------------------------------------
AMT.LESS.RAISE:
*-----------------------------------------------------------------------------
    EB.SystemTables.setAf(AbcTable.AbcAaPreProcess.Amount)
    E = 'Amount Less then the the Specified one ' : AMT
    EB.SystemTables.setE(E)
    EB.ErrorProcessing.Err()
    
RETURN
*-----------------------------------------------------------------------------
END