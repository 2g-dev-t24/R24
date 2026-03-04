* @ValidationCode : MjotMTU0OTE4NTU2MzpDcDEyNTI6MTc2NjA2NDY1NzMyMzplbnpvY29yaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Dec 2025 10:30:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : enzocorio
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTarjetaMc
*-----------------------------------------------------------------------------
SUBROUTINE ABC.CREA.ARCH.CTA.GARAN(Y.ID.CUENTA)
*===============================================================================
* Nombre de Programa : ABC.CREA.ARCH.CTA.GARAN
* Objetivo           : Rutina que crea un archivo .txt con los intereses pagados
*                      a las cuentas garantizadas
*===============================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING IC.InterestAndCapitalisation
    $USING AbcTable
    $USING EB.Service
    $USING AbcGetGeneralParam
    $USING AC.EntryCreation
    $USING AA.Interest
    $USING AC.AccountOpening
    
    GOSUB INIC
    GOSUB PROCESO
    GOSUB FINALIZA

RETURN

********
INIC:
********

    Y.DESC.1 = AbcTarjetaMc.getYDesc1()
    Y.DESC.2 = AbcTarjetaMc.getYDesc2()
    Y.DESC.3 = AbcTarjetaMc.getYDesc3()
    Y.DESC.4 = AbcTarjetaMc.getYDesc4()
    Y.TRANSACTION.IDENTIFIER = AbcTarjetaMc.getYTransactionIdentifier()
    Y.ACCOUNT.ID.TYPE = AbcTarjetaMc.getYAccountIdType()
    Y.LOCATION.TYPE = AbcTarjetaMc.getYLocationType()
    Y.TRANSACTION.SUB.TYPE = AbcTarjetaMc.getYTransactionSubType()
    Y.TRANSACTION.CODE.LIST = AbcTarjetaMc.getYTransactionCodeList()
    Y.FECHA.INICIO = AbcTarjetaMc.getYFechaInicio()
    Y.LOCATION.ID = AbcTarjetaMc.getYLocationId()
    AGENT.NUMBER = EB.Service.getAgentNumber()
    Y.RUTA.ARCHIVO.TEMP = AbcTarjetaMc.getYRutaArchivoTemp()
    Y.TRANSACTION.TYPE = AbcTarjetaMc.getYTransactionType()
    FN.ABC.ACCT.LCL.FLDS = AbcTarjetaMc.getFnAbcAcctLclFlds()
    F.ABC.ACCT.LCL.FLDS  = AbcTarjetaMc.getFAbcAcctLclFlds()
    FN.STMT.ACCT.CR      = AbcTarjetaMc.getFnStmtAcctCr()
    F.STMT.ACCT.CR       = AbcTarjetaMc.getFStmtAcctCr()
    FN.STMT.ENTRY.DETAIL      = AbcTarjetaMc.getFnStmtEntryDetail()
    F.STMT.ENTRY.DETAIL       = AbcTarjetaMc.getFStmtEntryDetail()
    FN.AA.INTEREST.ACCRUALS      = AbcTarjetaMc.getFnAaInterestAccruals()
    F.AA.INTEREST.ACCRUALS       = AbcTarjetaMc.getFAaInterestAccruals()

RETURN
********

********
PROCESO:
********

    Y.SALDO.MOV = 0
    Y.MONTO = 0
    Y.ISR = 0

    EB.DataAccess.FRead(FN.ACCOUNT,Y.ID.CUENTA,R.ACCOUNT,F.ACCOUNT,ERROR.AC)
    Y.ID.ARRANGENENT = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRANGENENT,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERROR.AC)

    IF R.ABC.ACCT.LCL.FLDS THEN
        Y.INT.ACCT.LIQ = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.IntLiquAcct>
        Y.PRN = FMT(R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Prn>,"R#50")

*        ID.STMT = Y.ID.CUENTA:"-":Y.FECHA.INICIO
*        EB.DataAccess.FRead(FN.STMT.ACCT.CR,ID.STMT,R.INFO.STMT,F.STMT.ACCT.CR,ERROR.STMT)
        Y.ID.ARRANGENENT = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
        Y.ID.INTEREST.ACCRUALS = Y.ID.ARRANGENENT:'-CRINTEREST'
        EB.DataAccess.FRead(FN.AA.INTEREST.ACCRUALS,Y.ID.INTEREST.ACCRUALS,R.INFO.STMT,F.AA.INTEREST.ACCRUALS,ERROR.STMT)

        IF ERROR.STMT EQ '' THEN
*            Y.CR.INT.AMT = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCrIntAmt,1>
*            Y.CR.INT.TAX.AMT = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCrIntTaxAmt,1>
*            Y.CR.INT.TR.AC = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCrIntTrAc>
*            Y.CR.INT.TAXTRSDR = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCrIntTaxtrsdr,1>
*            Y.TASA = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCrIntRate,1>
            Y.ID.CLIENTE = R.ACCOUNT<AC.AccountOpening.Account.Customer>
            SEL.CMD = "SELECT ":FN.STMT.ENTRY.DETAIL:" WITH ACCOUNT.NUMBER EQ 'MXN172050001' AND OUR.REFERENCE EQ ":SQUOTE(Y.ID.CLIENTE)
            EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,YSTMT.ERR)
            Y.ID.STMT.ENTRY.DETAIL = SEL.LIST<1>
            EB.DataAccess.FRead(FN.STMT.ENTRY.DETAIL,Y.ID.STMT.ENTRY.DETAIL,R.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL,ERR.STMT.ED)
            Y.CR.INT.TAX.AMT = R.STMT.ENTRY.DETAIL<AC.EntryCreation.StmtEntry.SteAmountLcy>

            NO.OF.REC.TOT = DCOUNT(R.INFO.STMT<AA.Interest.InterestAccruals.IntAccTotAccrAmt>,@VM)
            Y.TASA = R.INFO.STMT<AA.Interest.InterestAccruals.IntAccRate,1>
            Y.CR.INT.AMT = R.INFO.STMT<AA.Interest.InterestAccruals.IntAccTotAccrAmt,NO.OF.REC.TOT>
            Y.CR.INT.TR.AC = '974'
            Y.CR.INT.TAXTRSDR = '813'

            IF Y.CR.INT.TR.AC MATCH Y.TRANSACTION.CODE.LIST THEN
                Y.SALDO.MOV += Y.CR.INT.AMT
            END

            IF Y.CR.INT.TAXTRSDR MATCH Y.TRANSACTION.CODE.LIST THEN
                Y.SALDO.MOV -= Y.CR.INT.TAX.AMT
            END

            IF Y.SALDO.MOV GT 0 THEN
                Y.NO.MOVIMIENTOS += 1
                Y.NO.MOVIMIENTOS.AUX = FMT(Y.NO.MOVIMIENTOS,"R%6")
                Y.SALDO.MOV *= 1
                Y.SALDO.MOV = FMT(Y.SALDO.MOV,"13R,2")
                Y.MONTO = FMT(Y.CR.INT.AMT,"13R,2")
                Y.ISR = FMT(Y.CR.INT.TAX.AMT,"13R,2")
                CHANGE ' ' TO '' IN Y.MONTO
                CHANGE ' ' TO '' IN Y.ISR
                Y.TRANSACTION.DESCRIPTION = Y.DESC.1 : Y.MONTO : " , " : Y.DESC.2 : Y.ISR : " , " : Y.DESC.3 : Y.TASA : Y.DESC.4
                Y.TRANSACTION.DESCRIPTION = FMT(Y.TRANSACTION.DESCRIPTION,"40L,2")
                IF R.MOVIMIENTOS NE '' THEN R.MOVIMIENTOS := CHAR(10)
                R.MOVIMIENTOS := Y.ACCOUNT.ID.TYPE : Y.PRN : Y.LOCATION.TYPE : Y.LOCATION.ID : Y.TRANSACTION.TYPE
                R.MOVIMIENTOS := Y.TRANSACTION.SUB.TYPE : Y.SALDO.MOV : Y.TRANSACTION.DESCRIPTION : Y.TRANSACTION.IDENTIFIER
                Y.SALDO.MOV = 0
                Y.MONTO = 0
                Y.ISR = 0
            END
        END
        R.MOVIMIENTOS := "Y.ID.CUENTA" : "2" : "3" : "4"
        IF R.MOVIMIENTOS NE '' THEN
            GOSUB ESCRIBE.ARCHIVO
        END
        RETURN

******************
ESCRIBE.ARCHIVO:
*****************
        Y.ID.PARAM = 'ABC.CREA.ARCH.CTA.GARAN'
        Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
        AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
        LOCATE "RUTA.AGENTE" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
            Y.RUTA.AGENTE = Y.LIST.VALUES<YPOS.PARAM>
        END

        str_filename = "AGENTE_":AGENT.NUMBER:".txt"
*Y.RUTA.ARCHIVO.TEMP=  "CTA.GARANTIZADA"
        SEQ.FILE.NAME = Y.RUTA.AGENTE : "/" : Y.RUTA.ARCHIVO.TEMP: "/" :str_filename

*    OPENSEQ SEQ.FILE.NAME,str_filename TO FILE.VAR1 ELSE
        OPENSEQ SEQ.FILE.NAME,str_filename TO FILE.VAR1 ELSE
            CREATE FILE.VAR1 ELSE
            END
        END

        WRITESEQ R.MOVIMIENTOS APPEND TO FILE.VAR1 ELSE
        END

        RETURN

*********
FINALIZA:
*********

        RETURN

    END
