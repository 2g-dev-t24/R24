$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.ENVIA.OFS.TT
*===============================================================================
* Nombre de Programa : ABC.ENVIA.OFS.TT
* Objetivo           : Rutina que envia OFS Teller cuando autorizan
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcSpei
    $USING EB.Interface
    $USING AbcTable
    $USING AC.AccountOpening

    GOSUB INITIALIZE
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
*** <region name= INITIALIZE>
INITIALIZE:
***
    FN.TELLER = 'F.TELLER'
    F.TELLER = '' 
    EB.DataAccess.Opf(FN.TELLER,F.TELLER)
    
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    Y.MODULO    = "CAP.CHQ"
    Y.SEPARADOR = "#"
    Y.CAMPOS = "VERSION" : Y.SEPARADOR
    AbcSpei.AbcTraeGeneralParam(Y.MODULO, Y.CAMPOS, Y.DATOS)
    Y.VER.ING = FIELD(Y.DATOS,Y.SEPARADOR,1)

    RETURN

PROCESS:
    Y.NO.CUENTA= EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.Cuenta)
    Y.ID.CUSTOMER= EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.IdCliente)
    Y.NOMBRE.CLIENTE= EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.NombreCliente)
    Y.IMPORTE= EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.MontoLocal)
    Y.NO.CHEQUE.GIRA= EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.NoChequeGirador)
    Y.NO.CUENTA.GIRA= EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.NoCtaGirador)
    Y.ID.BANCO= EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.NoBanco)
    Y.TIPO.CHEQUE= EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.TipoCheque)
    Y.COD.SEG.CHQ = EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.CodSegChq)
    Y.DIG.PREMARCADO = EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.DigPremarcado)
    Y.CVE.TXN.CHQ = EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.CveTxnChq)
    Y.PLAZA.COMP.CHQ = EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.PlazaCompChq)
    Y.DIG.INTRCAM.CHQ = EB.SystemTables.getRNew(AbcTable.AbcTmpSimulaTt.DigIntrcamChq)

    EB.DataAccess.FRead(FN.ACCOUNT, Y.NO.CUENTA, REC.CUENTA, F.ACCOUNT, YF.ERR)
    YR.BAL = REC.CUENTA<AC.AccountOpening.Account.OnlineClearedBal>


    IF Y.TIPO.CHEQUE EQ 'Cheque Personal' THEN
        Y.TIPO.CHEQUE = 1
    END ELSE
        Y.TIPO.CHEQUE = 2
    END

    OFS.MSG  = Y.VER.ING:"/I/PROCESS,,"
    OFS.MSG := ",ACCOUNT.2:1:1=" : Y.NO.CUENTA
    OFS.MSG := ",AMOUNT.LOCAL.1:1:1=" : Y.IMPORTE
    OFS.MSG := ",DRAW.CHQ.NO:1:1=" : Y.NO.CHEQUE.GIRA
    OFS.MSG := ",DRAW.ACCT.NO:1:1=" : Y.NO.CUENTA.GIRA
    OFS.MSG := ",DRAW.BANK:1:1=" : Y.ID.BANCO
    OFS.MSG := ",CHEQUE.NUMBER:1:1=" : Y.NO.CHEQUE.GIRA
    OFS.MSG := ",CHEQUE.ACCT.NO:1:1=" : Y.NO.CUENTA.GIRA
    OFS.MSG := ",CHEQUE.BANK.CDE:1:1=" : Y.ID.BANCO
    OFS.MSG := ",TIPO.CHEQUE:1:1=" : Y.TIPO.CHEQUE
    OFS.MSG := ",COD.SEG.CHQ:1:1=" : Y.COD.SEG.CHQ
    OFS.MSG := ",DIG.PREMARCADO:1:1=" : Y.DIG.PREMARCADO
    OFS.MSG := ",CVE.TXN.CHQ:1:1=" : Y.CVE.TXN.CHQ
    OFS.MSG := ",PLAZA.COMP.CHQ:1:1=" : Y.PLAZA.COMP.CHQ
    OFS.MSG := ",DIG.INTRCAM.CHQ:1:1=" : Y.DIG.INTRCAM.CHQ
    OFS.MSG := ",CLEARED.BAL:1:1=" : YR.BAL

    EB.Interface.OfsAddlocalrequest(OFS.MSG, "add", Y.RTN.ERR)

    IF Y.RTN.ERR EQ '' THEN
        SEL.CMD.TT = "SELECT ":FN.TELLER:" WITH TRANSACTION.CODE EQ '11' AND CHEQUE.NUMBER EQ ":DQUOTE(Y.NO.CHEQUE.GIRA):' BY-DSND @ID'
        EB.DataAccess.Readlist(SEL.CMD.TT,Y.LIST.TT,'',Y.CNT.TT,Y.SEL.ERR.TT)
        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.IdTeller, Y.LIST.TT<1>)
    END


    RETURN

END
