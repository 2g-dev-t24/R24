* @ValidationCode : Mjo3OTc5NTkzMjA6Q3AxMjUyOjE3NjgyNDg1NTQxMDc6Q8Opc2FyTWlyYW5kYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2026 14:09:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : CésarMiranda
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcCob
SUBROUTINE ABC.CREA.ARCH.CTA.GARAN(Y.ID.CUENTA)
 
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING IC.InterestAndCapitalisation
    $USING EB.Service
    $USING EB.AbcUtil
    
    GOSUB PROCESO
    GOSUB FINALIZA

RETURN

********
PROCESO:
********

    Y.NOMBRE.RUTINA = "ABC.CREA.ARCH.CTA.GARAN"          ;*CMB 20260112
    Y.SALDO.MOV = 0
    Y.MONTO = 0
    Y.ISR = 0

    FN.ACCOUNT = AbcCob.getFnAccountGaran()
    F.ACCOUNT = AbcCob.getFAccountGaran()
    FN.STMT.ACCT.CR = AbcCob.getFnStmtAcctCr()
    F.STMT.ACCT.CR = AbcCob.getFStmtAcctCr()
    FN.ABC.ACCT.LCL.FLDS = AbcCob.getFnAbcAcctLclFldsGaran()
    F.ABC.ACCT.LCL.FLDS = AbcCob.getFAbcAcctLclFldsGaran()
    Y.FECHA.INICIO = AbcCob.getYFechaInicio()
    Y.LIST.VALUES = AbcCob.getYListValues()
    Y.LIST.PARAMS = AbcCob.getYListParams()
    
    LOCATE "TRANSACTION.CODE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRANSACTION.CODE.LIST = Y.LIST.VALUES<POS>
        CHANGE ',' TO @VM IN Y.TRANSACTION.CODE.LIST
    END
    
    Y.ACCOUNT.ID.TYPE = AbcCob.getYAccountIdType()
    Y.TRANSACTION.TYPE = AbcCob.getYTransactionType()
    Y.TRANSACTION.SUB.TYPE = AbcCob.getYTransactionSubType()
    Y.DESC.1 = AbcCob.getYDesc1()
    Y.DESC.2 = AbcCob.getYDesc2()
    Y.DESC.3 = AbcCob.getYDesc3()
    Y.DESC.4 = AbcCob.getYDesc4()
    Y.LOCATION.TYPE = AbcCob.getYLocationType()
    Y.LOCATION.ID = AbcCob.getYLocationId()
    Y.TRANSACTION.IDENTIFIER = AbcCob.getYTransactionIdentifier()
    Y.RUTA.ARCHIVO.TEMP = AbcCob.getYRutaArchivoTemp()

    EB.DataAccess.FRead(FN.ACCOUNT,Y.ID.CUENTA,R.ACCOUNT,F.ACCOUNT,ERROR.AC)
    IF ERROR.AC EQ '' THEN
        Y.INT.ACCT.LIQ = R.ACCOUNT<AC.AccountOpening.Account.IntLiquAcct>
        EB.DataAccess.CacheRead(FN.ABC.ACCT.LCL.FLDS,Y.INT.ACCT.LIQ,R.ABC.ACCT.LCL.FLDS,YERR.LCL)
        Y.PRN = FMT(R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Prn>,"R#50")

        ID.STMT = Y.ID.CUENTA:"-":Y.FECHA.INICIO
        EB.DataAccess.FRead(FN.STMT.ACCT.CR,ID.STMT,R.INFO.STMT,F.STMT.ACCT.CR,ERROR.STMT)
        IF ERROR.STMT EQ '' THEN
            Y.CR.INT.AMT = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCrIntAmt,1>
            Y.CR.INT.TAX.AMT = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCrIntTaxAmt,1>
            Y.CR.INT.TR.AC = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCrIntTrAc>
            Y.CR.INT.TAXTRSDR = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCrIntTaxtrsdr,1>
            Y.TASA = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCrIntRate,1>

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
    END

    IF R.MOVIMIENTOS NE '' THEN GOSUB ESCRIBE.ARCHIVO

RETURN

******************
ESCRIBE.ARCHIVO:
*****************
    AGENT.NUMBER    = EB.Service.getAgentNumber()
    str_filename = "AGENTE_":AGENT.NUMBER:".txt"
    SEQ.FILE.NAME = Y.RUTA.ARCHIVO.TEMP

    OPENSEQ SEQ.FILE.NAME,str_filename TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    WRITESEQ R.MOVIMIENTOS APPEND TO FILE.VAR1 ELSE
    END

    Y.CADENA.LOG<-1> = "R.MOVIMIENTOS->" : R.MOVIMIENTOS                ;*CMB 20260112
    
RETURN

*********
FINALIZA:
*********

    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)         ;*CMB 20260112

RETURN

END
