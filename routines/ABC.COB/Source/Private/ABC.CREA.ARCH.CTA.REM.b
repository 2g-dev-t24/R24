* @ValidationCode : MjoyNTI1OTU2Mzk6Q3AxMjUyOjE3NzA3NDk2MTc5MjU6Q8Opc2FyTWlyYW5kYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Feb 2026 12:53:37
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
SUBROUTINE ABC.CREA.ARCH.CTA.REM(Y.ID.CUENTA)

    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING IC.InterestAndCapitalisation
    $USING EB.Service
    $USING AA.Interest
    $USING AC.EntryCreation
    $USING EB.AbcUtil
    $USING AA.PaymentSchedule
    
    GOSUB PROCESO
    GOSUB FINALIZA

RETURN

********
PROCESO:
********

    Y.SALDO.MOV = 0
    Y.MONTO = 0
    Y.ISR = 0

    FN.ACCOUNT = AbcCob.getFnAccountRem()
    F.ACCOUNT = AbcCob.getFAccountRem()
    FN.STMT.ACCT.CR = AbcCob.getFnStmtAcctCrRem()
    F.STMT.ACCT.CR = AbcCob.getFStmtAcctCrRem()
    FN.STMT.ENTRY.DETAIL = AbcCob.getFnStmtEntryDetail()
    F.STMT.ENTRY.DETAIL = AbcCob.getFStmtEntryDetail()
    FN.AA.INTEREST.ACCRUALS = AbcCob.getFnAaInterestAccruals()
    F.AA.INTEREST.ACCRUALS = AbcCob.getFAaInterestAccruals()
    FN.ABC.ACCT.LCL.FLDS = AbcCob.getFnAbcAcctLclFldsRem()
    F.ABC.ACCT.LCL.FLDS = AbcCob.getFAbcAcctLclFldsRem()
    Y.LIST.VALUES = AbcCob.getYListValuesRem()
    Y.LIST.PARAMS = AbcCob.getYListParamsRem()
*************************************** INICIO CMB 20260119 ***************************************
    FN.AA.ACCOUNT.DETAILS = AbcCob.getFnAaAccountDetails()
    F.AA.ACCOUNT.DETAILS = AbcCob.getFAaAccountDetails()
    FN.AA.BILL.DETAILS = AbcCob.getFnAaBillDetails()
    F.AA.BILL.DETAILS = AbcCob.getFAaBillDetails()
***************************************** FIN CMB 20260119 ****************************************
    LOCATE "TRANSACTION.CODE" IN Y.LIST.PARAMS SETTING POS THEN
        Y.TRANSACTION.CODE.LIST = Y.LIST.VALUES<POS>
        CHANGE ',' TO @VM IN Y.TRANSACTION.CODE.LIST
    END
    
    Y.ACCOUNT.ID.TYPE = AbcCob.getYAccountIdTypeRem()
    Y.TRANSACTION.TYPE = AbcCob.getYTransactionTypeRem()
    Y.TRANSACTION.SUB.TYPE = AbcCob.getYTransactionSubTypeRem()
    Y.DESC.1 = AbcCob.getYDesc1Rem()
    Y.DESC.2 = AbcCob.getYDesc2Rem()
    Y.DESC.3 = AbcCob.getYDesc3Rem()
    Y.DESC.4 = AbcCob.getYDesc4Rem()
    Y.LOCATION.TYPE = AbcCob.getYLocationTypeRem()
    Y.LOCATION.ID = AbcCob.getYLocationIdRem()
    Y.TRANSACTION.IDENTIFIER = AbcCob.getYTransactionIdentifierRem()
    Y.RUTA.ARCHIVO.TEMP = AbcCob.getYRutaArchivoTempRem()
    
    EB.DataAccess.FRead(FN.ACCOUNT,Y.ID.CUENTA,R.ACCOUNT,F.ACCOUNT,ERROR.AC)
    IF ERROR.AC EQ '' THEN
*************************************** INICIO CMB 20260119 ***************************************
*        EB.DataAccess.CacheRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.CUENTA,R.ABC.ACCT.LCL.FLDS,YERR.LCL)
*        Y.PRN = FMT(R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Prn>,"R#50")
        Y.ALT.ACCT.TYPE = R.ACCOUNT<AC.AccountOpening.Account.AltAcctType>
        Y.ALT.ACCT.ID = R.ACCOUNT<AC.AccountOpening.Account.AltAcctId>
        CHANGE @VM TO @FM IN Y.ALT.ACCT.TYPE
        CHANGE @VM TO @FM IN Y.ALT.ACCT.ID
        
        LOCATE "PRN" IN Y.ALT.ACCT.TYPE SETTING POS1 THEN
	        Y.PRN = Y.ALT.ACCT.ID<POS1>
	    END
    
        Y.PRN = FMT(Y.PRN,"R#50")
    
        Y.ID.ARRANGENENT = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
        Y.ID.CLIENTE = R.ACCOUNT<AC.AccountOpening.Account.Customer>
        Y.ID.INTEREST.ACCRUALS = Y.ID.ARRANGENENT:'-CRINTEREST'
            
        EB.DataAccess.FRead(FN.AA.INTEREST.ACCRUALS,Y.ID.INTEREST.ACCRUALS,R.INFO.STMT,F.AA.INTEREST.ACCRUALS,ERROR.STMT)
*   AA.Interest.accruals
        IF ERROR.STMT EQ '' THEN
*            Y.TASA = R.INFO.STMT<AA.Interest.InterestAccruals.IntAccRate,1>
            Y.CADENA.LOG<-1> = "-----------------------INICIO ":Y.ID.ARRANGENENT:"-----------------------"
            Y.RATE =R.INFO.STMT<AA.Interest.InterestAccruals.IntAccRate,1>
            Y.CADENA.LOG<-1> = "Y.RATE->" : Y.RATE

            CHANGE @SM TO @FM IN Y.RATE
            Y.CADENA.LOG<-1> = "Y.RATE SM->" : Y.RATE
                
            Y.TASA = Y.RATE<1>
                
            Y.TOT.ACCR.AMT = R.INFO.STMT<AA.Interest.InterestAccruals.IntAccTotAccrAmt>
            Y.PERIOD.END = R.INFO.STMT<AA.Interest.InterestAccruals.IntAccPeriodEnd>
                
            CHANGE @VM TO @FM IN Y.TOT.ACCR.AMT
            CHANGE @VM TO @FM IN Y.PERIOD.END
            
            Y.CADENA.LOG<-1> = "Y.TOT.ACCR.AMT VM->" : Y.TOT.ACCR.AMT
            Y.CADENA.LOG<-1> = "Y.PERIOD.END VM->" : Y.PERIOD.END
            
            EB.DataAccess.FRead(FN.AA.ACCOUNT.DETAILS,Y.ID.ARRANGENENT,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR.AC.DET)
            IF ERR.AC.DET EQ '' THEN
                Y.BILL.DATE = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillDate>
                Y.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillId>
                CHANGE @VM TO @FM IN Y.BILL.DATE
                CHANGE @VM TO @FM IN Y.BILL.ID
                Y.CADENA.LOG<-1> = "Y.BILL.DATE VM->" : Y.BILL.DATE
                Y.CADENA.LOG<-1> = "Y.BILL.ID VM->" : Y.BILL.ID
                CHANGE @SM TO @FM IN Y.BILL.DATE
                CHANGE @SM TO @FM IN Y.BILL.ID
                
                Y.NUM.BILL.ID = DCOUNT(Y.BILL.ID,FM)
                
                Y.CADENA.LOG<-1> = "Y.ID.ARRANGENENT->" : Y.ID.ARRANGENENT
                Y.CADENA.LOG<-1> = "R.AA.ACCOUNT.DETAILS->" : R.AA.ACCOUNT.DETAILS
                Y.CADENA.LOG<-1> = "Y.BILL.DATE SM->" : Y.BILL.DATE
                Y.CADENA.LOG<-1> = "Y.BILL.ID SM->" : Y.BILL.ID
                
***************************************** FIN CMB 20260119 ****************************************
        
		        Y.NUM.FECHAS = AbcCob.getYNumFechasRem()
		        Y.FECHAS = AbcCob.getYFechasRem()
		        
		        FOR V = 1 TO Y.NUM.FECHAS
		            Y.FEC.MOV = Y.FECHAS<V>
*      ID.STMT = Y.ID.CUENTA:"-":Y.FEC.MOV
*      EB.DataAccess.FRead(FN.STMT.ACCT.CR,ID.STMT,R.INFO.STMT,F.STMT.ACCT.CR,ERROR.STMT)

*************************************** INICIO CMB 20260119 ***************************************
*            Y.ID.ARRANGENENT = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
*            Y.ID.INTEREST.ACCRUALS = Y.ID.ARRANGENENT:'-CRINTEREST'
*
*            Y.PRN = FMT(Y.PRN:" ":Y.ID.CUENTA:" ":Y.ID.ARRANGENENT,"R#50")
*
*            EB.DataAccess.FRead(FN.AA.INTEREST.ACCRUALS,Y.ID.INTEREST.ACCRUALS,R.INFO.STMT,F.AA.INTEREST.ACCRUALS,ERROR.STMT)
**   AA.Interest.accruals
*            IF ERROR.STMT EQ '' THEN
*                Y.TASA =R.INFO.STMT<AA.Interest.InterestAccruals.IntAccRate,1>
**   Y.CR.INT.AMT = R.INFO.STMT<AA.Interest.accruals
*                Y.ID.CLIENTE = R.ACCOUNT<AC.AccountOpening.Account.Customer>
*                SEL.CMD = "SELECT ":FN.STMT.ENTRY.DETAIL:" WITH ACCOUNT.NUMBER EQ 'MXN172050001' AND OUR.REFERENCE EQ ":SQUOTE(Y.ID.CLIENTE)
*                EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,YSTMT.ERR)
*                Y.ID.STMT.ENTRY.DETAIL = SEL.LIST<1>
*                EB.DataAccess.FRead(FN.STMT.ENTRY.DETAIL,Y.ID.STMT.ENTRY.DETAIL,R.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL,ERR.STMT.ED)
*                NO.OF.REC.TOT = DCOUNT(R.INFO.STMT<AA.Interest.InterestAccruals.IntAccTotAccrAmt>,@VM)
*                Y.CR.INT.AMT = R.INFO.STMT<AA.Interest.InterestAccruals.IntAccTotAccrAmt,NO.OF.REC.TOT>
*                Y.CR.INT.TAX.AMT = R.STMT.ENTRY.DETAIL<AC.EntryCreation.StmtEntry.SteAmountLcy>
*                Y.SALDO.MOV = R.INFO.STMT<AA.Interest.InterestAccruals.IntAccTotPosAccrAmt>
*
*                Y.TOT.ACCR.AMT = R.INFO.STMT<AA.Interest.InterestAccruals.IntAccTotAccrAmt>
*                Y.PERIOD.END = R.INFO.STMT<AA.Interest.InterestAccruals.IntAccPeriodEnd>
*
*                CHANGE @VM TO @FM IN Y.TOT.ACCR.AMT
*                CHANGE @VM TO @FM IN Y.PERIOD.END
                
                    Y.CADENA.LOG<-1> = "Y.FEC.MOV->" : Y.FEC.MOV
                    
		            LOCATE Y.FEC.MOV IN Y.PERIOD.END SETTING POS2 THEN
		                Y.CR.INT.AMT = Y.TOT.ACCR.AMT<POS2>
                        Y.CADENA.LOG<-1> = "Y.CR.INT.AMT->" : Y.CR.INT.AMT
		            END

*                EB.DataAccess.FRead(FN.AA.ACCOUNT.DETAILS,Y.ID.CUENTA,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR.AC.DET)
*                IF ERR.AC.DET EQ '' THEN
*                    Y.BILL.DATE = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillDate>
*                    Y.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillId>
*                    CHANGE @SM TO @FM IN Y.BILL.DATE
*                    CHANGE @SM TO @FM IN Y.BILL.ID
*
*		            LOCATE Y.FEC.MOV IN Y.BILL.DATE SETTING POS3 THEN
*					    Y.ID.AA.BILL = Y.BILL.ID<POS3>
*                        Y.CADENA.LOG<-1> = "Y.ID.AA.BILL.DETAILS->" : Y.ID.AA.BILL.DETAILS
*					END
                
                    FOR X = Y.NUM.BILL.ID TO 1 STEP -1
                        Y.CADENA.LOG<-1> = X : " DE " : Y.NUM.BILL.ID
                        Y.BILL.DATE.AUX = Y.BILL.DATE<X>
                        Y.CADENA.LOG<-1> = "Y.BILL.DATE.AUX->" : Y.BILL.DATE.AUX
                        IF Y.BILL.DATE.AUX EQ Y.FEC.MOV THEN
	                        Y.ID.AA.BILL.DETAILS = Y.BILL.ID<X>
                            Y.CADENA.LOG<-1> = "Y.ID.AA.BILL.DETAILS->" : Y.ID.AA.BILL.DETAILS
				            EB.DataAccess.FRead(FN.AA.BILL.DETAILS,Y.ID.AA.BILL.DETAILS,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,ERR.BILL.DET)
				            IF ERR.BILL.DET EQ '' THEN
				                Y.PROPERTY = R.AA.BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdProperty>
				                Y.ORPROP.AMOUNT = R.AA.BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdOrPropAmount>
				                CHANGE @VM TO @FM IN Y.PROPERTY
				                CHANGE @VM TO @FM IN Y.ORPROP.AMOUNT
		                        
		                        Y.CADENA.LOG<-1> = "Y.PROPERTY VM->" : Y.PROPERTY
		                        Y.CADENA.LOG<-1> = "Y.ORPROP.AMOUNT VM->" : Y.ORPROP.AMOUNT
				                        
				                LOCATE "ISRTAX" IN Y.PROPERTY SETTING POS4 THEN
					                Y.CR.INT.TAX.AMT = Y.ORPROP.AMOUNT<POS4>
		                            Y.CADENA.LOG<-1> = "Y.CR.INT.TAX.AMT->" : Y.CR.INT.TAX.AMT
                                    X = 1
				                END
                            END
			            END
                    NEXT X
		                
		            Y.SALDO.MOV = Y.CR.INT.AMT - Y.CR.INT.TAX.AMT
***************************************** FIN CMB 20260119 ****************************************
*Y.TASA = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCrIntRate,1>
*Y.CR.INT.AMT = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrTotalInterest>
*Y.CR.INT.TAX.AMT = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrTaxForCustomer>
*Y.SALDO.MOV = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrGrandTotal>
		            IF Y.SALDO.MOV GT 0 THEN
		                Y.NO.MOVIMIENTOS += 1
		                Y.NO.MOVIMIENTOS.AUX = FMT(Y.NO.MOVIMIENTOS,"R%6")
		                Y.SALDO.MOV *= -1
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
*		            GOSUB VALIDA.CORRECC.INT         ;*CMB 20260119
                NEXT V
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

    Y.CADENA.LOG<-1> = "R.MOVIMIENTOS->" : R.MOVIMIENTOS                ;*CMB 20260109
    
RETURN

*********
FINALIZA:
*********

    Y.CADENA.LOG<-1> = "-------------------------FIN-------------------------"
    Y.NOMBRE.RUTINA = "ABC.CREA.ARCH.CTA.REM_":AGENT.NUMBER          ;*CMB 20260123
    IF Y.CADENA.LOG NE '' THEN
        EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)         ;*CMB 20260109
    END

RETURN

*********
VALIDA.CORRECC.INT:
*********
    IF R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCorrectionId> NE '' THEN
        Y.NO.CORRECCIONES = ''
        Y.NO.CORRECCIONES = DCOUNT(R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrCorrectionId>,@VM)
        FOR Y.AA=1 TO Y.NO.CORRECCIONES
            Y.INT.CORR = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrAdjIntAmt,Y.AA>
            Y.TAX.CORR = R.INFO.STMT<IC.InterestAndCapitalisation.StmtAcctCr.StmcrAdjTaxAmt,Y.AA>
            Y.SALDO.MOV = Y.INT.CORR + Y.TAX.CORR
            IF Y.SALDO.MOV GT 0 OR Y.SALDO.MOV LT 0 THEN
                Y.SALDO.MOV *= -1
                Y.TAX.CORR *= -1
                Y.SALDO.MOV = FMT(Y.SALDO.MOV,"13R,2")
                Y.INT.CORR = FMT(Y.INT.CORR,"13R,2")
                Y.TAX.CORR = FMT(Y.TAX.CORR,"13R,2")
                CHANGE ' ' TO '' IN Y.INT.CORR
                CHANGE ' ' TO '' IN Y.TAX.CORR
                Y.TRANSACTION.DESCRIPTION = Y.DESC.1 : Y.INT.CORR : " , " : Y.DESC.2 : Y.TAX.CORR : " , " : Y.DESC.3 : Y.TASA : Y.DESC.4
                Y.TRANSACTION.DESCRIPTION = FMT(Y.TRANSACTION.DESCRIPTION,"40L,2")
                IF R.MOVIMIENTOS NE '' THEN R.MOVIMIENTOS := CHAR(10)
                R.MOVIMIENTOS := Y.ACCOUNT.ID.TYPE : Y.PRN : Y.LOCATION.TYPE : Y.LOCATION.ID : Y.TRANSACTION.TYPE
                R.MOVIMIENTOS := Y.TRANSACTION.SUB.TYPE : Y.SALDO.MOV : Y.TRANSACTION.DESCRIPTION : Y.TRANSACTION.IDENTIFIER
            END
        NEXT Y.AA

    END

RETURN

END
