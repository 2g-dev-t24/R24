* @ValidationCode : MjoxNTY1OTQ5MTY6Q3AxMjUyOjE3Njc2NjY5NjUzNTc6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2026 23:36:05
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
SUBROUTINE ENQ.ACC.SAL (CUENTA)

    $USING EB.Reports
    $USING EB.DataAccess
    $USING CQ.ChqSubmit
    $USING AC.AccountOpening
    $USING AbcSpei
    $USING EB.SystemTables
    
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

    CUENTA = ""
    J.REC = ""
    J.ERR = ""

RETURN
*---------------------------------------------------------------------
OPENFILES:

    EB.DataAccess.Opf(FN.ACC,FV.ACC)
    EB.DataAccess.Opf(FN.CHE.COL,F.CHE.COL)

RETURN

*---------------------------------------------------------------------
PROCESS:
    
    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()

    LOCATE "ACC.NO" IN SEL.FIELDS<1> SETTING ACC.POS THEN
        ACC.NO = SEL.VALUES<ACC.POS>
    END

    EB.DataAccess.FRead(FN.ACC,ACC.NO,J.REC,FV.ACC,J.ERR)

    TODAY = EB.SystemTables.getToday()
    AbcSpei.AbcMontoBloqueado(ACC.NO, J.SAL.BLO,TODAY)

    IF J.SAL.BLO EQ '' THEN J.SAL.BLO = 0
    J.SAL.BLO = FMT(J.SAL.BLO,"R2")

    SEL.SBC = "SELECT ":FN.CHE.COL:" AMOUNT WITH CREDIT.ACC.NO EQ ":DQUOTE(ACC.NO):" AND CHQ.STATUS EQ 'DEPOSITED' OR 'CLEARING'"

    LIST.SEL.SBC = ''; NO.SEL.SBC = 0; ERR.SEL.SBC = ''
    EB.DataAccess.Readlist(SEL.SBC,LIST.SEL.SBC,'',NO.SEL.SBC,ERR.SEL.SBC)

    J.SAL.SBC = ''
    FOR YNO.SEL.SBC = 1 TO NO.SEL.SBC
        J.SAL.SBC += DROUND(FIELD(LIST.SEL.SBC,FM,YNO.SEL.SBC),2)
    NEXT YNO.SEL.SBC
    IF J.SAL.SBC EQ '' THEN J.SAL.SBC = 0
    J.SAL.SBC = FMT(J.SAL.SBC,"R2")

    J.WOR.BAL = J.REC<AC.AccountOpening.Account.WorkingBalance>
    J.SAL.DIS = J.WOR.BAL - J.SAL.BLO

    CUENTA = J.SAL.DIS :"*": J.SAL.BLO :"*": J.SAL.SBC

RETURN

END
