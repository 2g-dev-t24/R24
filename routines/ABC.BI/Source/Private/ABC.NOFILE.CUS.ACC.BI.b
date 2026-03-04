* @ValidationCode : MjotMTIwMzk3NjIyNjpDcDEyNTI6MTc2NzY2Njg5MzgyMDpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2026 23:34:53
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
*-----------------------------------------------------------------------------
$PACKAGE AbcBi
*-----------------------------------------------------------------------------
SUBROUTINE ABC.NOFILE.CUS.ACC.BI (DATOS)
*=============================================================================
*       Rutina:      ABC.NOFILE.CUS.ACC.BI
*       Req:
*       Autor:
*       Fecha:
*       Tipo:        NOFILE ROUTINE
*       Descripcion: Se modifica la rutina se incluye campo de CLABE
*                    y al saldo por aplicar se le suma el saldo
*                    de las autorizaciones pendientes de la cuenta
*=============================================================================

    $USING EB.Security
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING AC.AccountOpening
    $USING ST.Config
    $USING ST.Customer
    $USING AbcSpei
    $USING AbcTable
    
    GOSUB FILES
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------
FILES:

    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""

    FN.CHE.COL = "F.CHEQUE.COLLECTION"
    F.CHE.COL = ""

    FN.CUS.ACC = "F.CUSTOMER.ACCOUNT"
    F.CUS.ACC = ""

    FN.CATEGORY = "F.CATEGORY"
    F.CATEGORY = ""

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""


    CUENTA = ""
    J.REC = ""
    J.ERR = ""
    DATOS = ""
    TODAY = EB.SystemTables.getToday()

RETURN
*---------------------------------------------------------------------
OPENFILES:

    EB.DataAccess.Opf(FN.ACC,FV.ACC)
    EB.DataAccess.Opf(FN.CHE.COL,F.CHE.COL)
    EB.DataAccess.Opf(FN.CUS.ACC,F.CUS.ACC)
    EB.DataAccess.Opf(FN.CATEGORY,F.CATEGORY)
    EB.DataAccess.Opf(FN.CUS,F.CUS)

RETURN

*---------------------------------------------------------------------
PROCESS:

    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()

    LOCATE "CUS.NO" IN SEL.FIELDS<1> SETTING CUS.POS THEN
        CUS.NO = SEL.VALUES<CUS.POS>
    END

    EB.DataAccess.FRead(FN.CUS,CUS.NO,CUS.REC,F.CUS,CUS.ERR)

    IF CUS.REC THEN
        Y.SECTOR = CUS.REC<ST.Customer.Customer.EbCusSector>
    END

    EB.DataAccess.FRead(FN.CUS.ACC,CUS.NO,CUS.ACC.REC,F.CUS.ACC,CUS.ACC.ERR)

    IF CUS.ACC.REC THEN

        COUNT.VM = 0
        COUNT.ACC = DCOUNT(CUS.ACC.REC,@FM)
        FOR X = 1 TO COUNT.ACC
            ACC.NO = CUS.ACC.REC<X>
            EB.DataAccess.FRead(FN.ACC,ACC.NO,J.REC,FV.ACC,J.ERR)
            IF J.REC THEN
                CATEGORY = J.REC<AC.AccountOpening.Account.Category>
                IF CATEGORY EQ '6605' OR CATEGORY EQ '6606' OR CATEGORY EQ '6607' OR CATEGORY EQ '6608' OR CATEGORY EQ '6008'  ELSE
                    EB.DataAccess.FRead(FN.CATEGORY,CATEGORY,CAT.REC,F.CATEGORY,CAT.ERR)

                    IF CAT.REC THEN
                        REG.NOM.PRO.CTA = CAT.REC<ST.Config.Category.EbCatDescription>
                        IF DCOUNT(REG.NOM.PRO.CTA,@VM) GE 4 THEN
                            NOM.PRO.CTA = FIELD(REG.NOM.PRO.CTA,@VM,4)
                        END ELSE
                            NOM.PRO.CTA = FIELD(REG.NOM.PRO.CTA,@VM,1)
                        END
                    END

                    AbcSpei.AbcMontoBloqueado(ACC.NO,J.SAL.BLO,TODAY)

                    IF J.SAL.BLO EQ '' THEN J.SAL.BLO = 0
                    J.SAL.BLO = FMT(J.SAL.BLO,"R2")

                    SEL.SBC = "SELECT ":FN.CHE.COL:" AMOUNT WITH CREDIT.ACC.NO EQ ":DQUOTE(ACC.NO):" AND CHQ.STATUS EQ 'DEPOSITED' OR 'CLEARING'"  ; *ITSS - TEJASHWINI - Added DQUOTE / '
                    LIST.SEL.SBC = ''
                    NO.SEL.SBC = 0
                    ERR.SEL.SBC = ''
                    EB.DataAccess.Readlist(SEL.SBC,LIST.SEL.SBC,'',NO.SEL.SBC,ERR.SEL.SBC)

                    J.SAL.SBC = ''
                    FOR YNO.SEL.SBC = 1 TO NO.SEL.SBC
                        J.SAL.SBC += DROUND(FIELD(LIST.SEL.SBC,@FM,YNO.SEL.SBC),2)
                    NEXT YNO.SEL.SBC
                    IF J.SAL.SBC EQ '' THEN J.SAL.SBC = 0
                    J.SAL.SBC = FMT(J.SAL.SBC,"R2")

                    Y.CLABE    = ''
                    Y.ID.ARRAY = J.REC<AC.AccountOpening.Account.ArrangementId>
                    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
                    IF R.ABC.ACCT.LCL.FLDS THEN
                        Y.CLABE = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Clabe>
                    END

                 
                    Y.NAU.MVMT.LIST  = 0
                    Y.NAU.MVMT.LIST  = J.REC<AC.AccountOpening.Account.AvAuthCrMvmt>
                    Y.NAU.AVAIL.DATE = ''
                    Y.NAU.AVAIL.DATE = J.REC<AC.AccountOpening.Account.AvailableDate>

                    Y.NUM.AVAIL.DATE = DCOUNT(Y.NAU.AVAIL.DATE,@VM)

                    Y.NAU.MVMT  = 0
                    FOR Y.NUM.DATE = 1 TO Y.NUM.AVAIL.DATE
                        Y.NAU.MVMT1 = 0; Y.NAU.MVMT1 = FIELD(Y.NAU.MVMT.LIST,@VM,Y.NUM.DATE)

                        IF Y.NAU.MVMT1 < 0 THEN
                            Y.NAU.MVMT1 = Y.NAU.MVMT1 * -1
                        END
                        Y.NAU.MVMT += Y.NAU.MVMT1

                    NEXT Y.NUM.DATE

                    J.WOR.BAL = J.REC<AC.AccountOpening.Account.WorkingBalance>
                    J.SAL.DIS = J.WOR.BAL - J.SAL.BLO
                    J.SAL.BLO = J.SAL.BLO + Y.NAU.MVMT
                    DATOS<-1> = ACC.NO :"*": NOM.PRO.CTA :"*": J.SAL.DIS :"*": J.SAL.BLO :"*": J.SAL.SBC :"*": Y.SECTOR :"*": J.WOR.BAL :"*": Y.CLABE

                END
            END

        NEXT X

    END

    DISPLAY DATOS

RETURN

END
