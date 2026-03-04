* @ValidationCode : MjoxNzk4NDI3ODIzOkNwMTI1MjoxNzcyMTU5NTkyOTY1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Feb 2026 23:33:12
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
$PACKAGE AbcDeposits

SUBROUTINE ABC.UPD.DEP.FECS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING AA.Account
    $USING EB.Updates
    $USING AA.Framework
    $USING AA.PaymentSchedule
    $USING EB.DataAccess
    $USING AA.ProductFramework
    $USING AA.TermAmount
    $USING EB.API

*-----------------------------------------------------------------------------

    GOSUB INIT

RETURN

INIT:

    FN.AA.ACT.DETAILS = "F.AA.ACCOUNT.DETAILS"
    F.AA.ACT.DETAILS = ""
    EB.DataAccess.Opf(FN.AA.ACT.DETAILS,F.AA.ACT.DETAILS)

    APP.NAME = 'AA.PRD.DES.ACCOUNT'
    FIELD.NAME ='L.FEC.INI.DEP':@VM:'L.FEC.FIN.DEP'
    FIELD.POS = '';
    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    L.FEC.INI.DEP.POS   = FIELD.POS<1,1>
    L.FEC.FIN.DEP.POS   = FIELD.POS<1,2>

    LOCAL.REF = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)

    ARRANGEMENT.ID = AA.Framework.getArrId()
    EB.DataAccess.FRead(FN.AA.ACT.DETAILS,ARRANGEMENT.ID,R.DETAILS,F.AA.ACT.DETAILS,Y.ERR.AA)
    Y.VALUE.DATE = R.DETAILS<AA.PaymentSchedule.AccountDetails.AdValueDate>
    Y.MATURITY.DATE = R.DETAILS<AA.PaymentSchedule.AccountDetails.AdMaturityDate>
    R.ARRANGEMENT.ACTIVITY = AA.Framework.getRArrangementActivity()
    Y.EFFECTIVE.DATE = R.ARRANGEMENT.ACTIVITY<AA.Framework.ArrangementActivity.ArrActEffectiveDate>
    
    DEBUG
    AA.ProductFramework.GetPropertyRecord('', ARRANGEMENT.ID, 'COMMITMENT', '', '', '', TM.RECORD, TM.ERR)
    AA.ProductFramework.GetPropertyRecord('', ARRANGEMENT.ID, 'TERM.AMOUNT', '', '', '', TM.RECORD, TM.ERR)

    IF Y.VALUE.DATE EQ '' THEN
        Y.VALUE.DATE = Y.EFFECTIVE.DATE
    END
    
    
    Y.PADRES = R.ARRANGEMENT.ACTIVITY<36>
    Y.TITULOS = R.ARRANGEMENT.ACTIVITY<38>
    Y.PROPERTY = R.ARRANGEMENT.ACTIVITY<39>

    Y.TERM.FLAG = ''
    Y.MATURITY.FLAG = ''
    Y.TITULOS.FLAG = ''
    POS = 0
    Y.PADRES = EREPLACE(Y.PADRES,@VM,@FM)
    LOCATE "COMMITMENT" IN Y.PADRES SETTING POS.PADRES THEN
        Y.TITULOS.FLAG = 1
        Y.TITULOS = FIELD(Y.TITULOS, @VM, POS.PADRES)
        Y.TITULOS = EREPLACE(Y.TITULOS,@SM,@FM)
    END
    
    IF Y.TITULOS.FLAG EQ 1 THEN
        LOCATE "TERM" IN Y.TITULOS SETTING POS THEN
            Y.TERM.FLAG = 1
            Y.FECHA.TERM = FIELD(Y.PROPERTY, @VM, POS.PADRES)
            Y.FECHA.TERM = FIELD(Y.FECHA.TERM, @SM, POS)
        END

        LOCATE "MATURITY.DATE" IN Y.TITULOS SETTING POS.M THEN
            Y.MATURITY.FLAG = 1
            Y.FECHA.TERM = FIELD(Y.PROPERTY, @VM, POS.PADRES)
            Y.FECHA.TERM = FIELD(Y.FECHA.TERM, @SM, POS.M)
        END

        IF (Y.MATURITY.FLAG EQ 1) THEN
            Y.MATURITY.DATE = Y.FECHA.TERM
        END
    END

    IF (Y.TERM.FLAG EQ 1) THEN
        Y.MATURITY.DATE = Y.VALUE.DATE
        Y.TERM.NUM = Y.FECHA.TERM[1, LEN(Y.FECHA.TERM) - 1]
        EB.API.Cdt('', Y.MATURITY.DATE, '+':Y.TERM.NUM:'C')
    END ELSE
        IF (Y.MATURITY.DATE EQ '')THEN

            AA.ProductFramework.GetPropertyRecord('', ARRANGEMENT.ID, 'COMMITMENT', Y.EFFECTIVE.DATE, 'TERM.AMOUNT', '', TM.RECORD, TM.ERR)
            Y.TERM = TM.RECORD<AA.TermAmount.TermAmount.AmtTerm>
            Y.MATURITY.DATE = TM.RECORD<AA.TermAmount.TermAmount.AmtMaturityDate>

            IF (Y.MATURITY.DATE EQ '') THEN
                IF Y.TERM EQ '' THEN
                    AA.Framework.GetArrangementConditionRecord(ArrangementRef, EffectiveDate, NewArrangementFlag, PropertyClass, RArrangementCondition, RetError)
                
                    AA.Framework.GetArrangementConditions(ARRANGEMENT.ID, 'TERM.AMOUNT', '', '', r.Ids, custCondition, r.Error)
                    custCondition = RAISE(custCondition)
                    Y.TERM = custCondition<AA.TermAmount.TermAmount.AmtTerm>
                END
           
                Y.MATURITY.DATE = Y.VALUE.DATE
                Y.TERM.NUM = Y.TERM[1, LEN(Y.TERM) - 1]
                EB.API.Cdt('', Y.MATURITY.DATE, '+':Y.TERM.NUM:'C')
            END

        END
    END
    LOCAL.REF<1, L.FEC.INI.DEP.POS> = Y.VALUE.DATE
    LOCAL.REF<1, L.FEC.FIN.DEP.POS> = Y.MATURITY.DATE

    EB.SystemTables.setRNew(AA.Account.Account.AcLocalRef, LOCAL.REF)

RETURN

END