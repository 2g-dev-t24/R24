* @ValidationCode : MjotMTEzMjU1MTAxNjpDcDEyNTI6MTc2NjUwNTMxNDMxODpDw6lzYXJNaXJhbmRhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 Dec 2025 09:55:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : CésarMiranda
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSaldoOperPasivasAcc


SUBROUTINE ABC.SALDO.OPER.PASIVAS.ACC.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING EB.Service
    $USING EB.Updates
    $USING EB.Utility
    $USING EB.AbcUtil
*-----------------------------------------------------------------------------
    GOSUB INICIA
    GOSUB ABRE.ARCHIVOS
    GOSUB FINALIZA
    
RETURN
*-------------------------------------
    
*-------------------------------------
INICIA:
*-------------------------------------

    Y.NOMBRE.RUTINA = "ABC.SALDO.OPER.PASIVAS.ACC.LOAD"
    
RETURN
*-------------------------------------
*-------------------------------------
ABRE.ARCHIVOS:
*-------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
    FN.DAO = 'F.DEPT.ACCT.OFFICER'
    F.DAO = ''
    EB.DataAccess.Opf(FN.DAO, F.DAO)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
    
    FN.EB.CONTRACT.BALANCES='F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES=''
    EB.DataAccess.Opf(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)
    
    FN.STMT.ACCT.CR = 'F.STMT.ACCT.CR'
    F.STMT.ACCT.CR = ''
    EB.DataAccess.Opf(FN.STMT.ACCT.CR, F.STMT.ACCT.CR)
     
    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY = ''
    EB.DataAccess.Opf(FN.CATEGORY, F.CATEGORY)
    
    FN.ABC.PROM.ENLACE = 'F.ABC.PROM.ENLACE'
    F.ABC.PROM.ENLACE = ''
    EB.DataAccess.Opf(FN.ABC.PROM.ENLACE, F.ABC.PROM.ENLACE)
    
    FN.GROUP.CREDIT.INT= 'F.GROUP.CREDIT.INT'
    F.GROUP.CREDIT.INT = ''
    EB.DataAccess.Opf(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)
    
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS =''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)
            
    Y.APP.NAME=''
    Y.FIELD.NAME=''
    Y.FIELD.POS=''
    Y.APP.NAME<1>='CUSTOMER'
    Y.FIELD.NAME<1,1> = 'CLASSIFICATION'
    Y.FIELD.NAME<1,2> = 'NOM.PER.MORAL'
    EB.Updates.MultiGetLocRef(Y.APP.NAME,Y.FIELD.NAME,Y.FIELD.POS)
    Y.POS.CLASSIFICATION    = Y.FIELD.POS<1,1>
    Y.POS.NOM.PER.MORAL     = Y.FIELD.POS<1,2>


    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS, Y.CUENTA, R.INFO.ACC, F.ABC.ACCT.LCL.FLDS, ERROR.ACC)

    Y.LWD = EB.SystemTables.getRDates(EB.Utility.Dates.DatLastWorkingDay)
        
    Y.ID.GEN.PARAM = 'ABC.CATEG.SAL.OP.PAS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.SEP = '|'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'CUENTA.AHORRO' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.CATEG.CUENTA.AHORRO = Y.LIST.VALUES<Y.POS.PARAM>
        CHANGE Y.SEP TO @VM IN Y.CATEG.CUENTA.AHORRO
    END
    LOCATE 'CUENTA.SIN.CHEQUERA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.CATEG.CUENTA.SIN.CHEQUERA = Y.LIST.VALUES<Y.POS.PARAM>
        CHANGE Y.SEP TO @VM IN Y.CATEG.CUENTA.SIN.CHEQUERA
    END
    LOCATE 'CUENTA.CON.CHEQUERA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.CATEG.CUENTA.CON.CHEQUERA = Y.LIST.VALUES<Y.POS.PARAM>
        CHANGE Y.SEP TO @VM IN Y.CATEG.CUENTA.CON.CHEQUERA
    END

    LOCATE 'PATH' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.PATH = Y.LIST.VALUES<Y.POS.PARAM>
    END

    LOCATE 'NOM.ARCH.SAL.OPERA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.NOM.ARCH.SAL.OPER = Y.LIST.VALUES<Y.POS.PARAM>
    END
    
    LOCATE 'NOM.PROC.OP.PAS' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.NOM.PROC.OP.PAS = Y.LIST.VALUES<Y.POS.PARAM>
    END
    
    Y.PATH.ORI = Y.PATH
    Y.PATH := "/tmp"
    
    IF CHDIR (Y.PATH.ORI) THEN
        Y.CADENA.LOG<-1> = "Directorio origen existente " : Y.PATH.ORI
    END ELSE
        Y.CADENA.LOG<-1> = "No existe el directorio origen " : Y.PATH.ORI
        EXECUTE 'SH -c mkdir ': Y.PATH.ORI CAPTURING Y.RETURNVAL.ORI
        Y.CADENA.LOG<-1> = "Y.RETURNVAL.ORI->" : Y.RETURNVAL.ORI
    END
    
    IF CHDIR (Y.PATH) THEN
        Y.CADENA.LOG<-1> = "Directorio tmp existente " : Y.PATH
    END ELSE
        Y.CADENA.LOG<-1> = "No existe el directorio tmp " : Y.PATH
        EXECUTE 'SH -c mkdir ': Y.PATH CAPTURING Y.RETURNVAL
        Y.CADENA.LOG<-1> = "Y.RETURNVAL->" : Y.RETURNVAL
    END
    

    AGENT.NUMBER    = EB.Service.getAgentNumber()

    CTA.NOM.FILE.4 = "Cuentas004.csv"
    CTA.FILE.4 = Y.PATH:'/':Y.LWD:".":Y.NOM.ARCH.SAL.OPER:".":AGENT.NUMBER:".":CTA.NOM.FILE.4

    CTA.NOM.FILE.5 = "Cuentas005.csv"
    CTA.FILE.5 = Y.PATH:'/':Y.LWD:".":Y.NOM.ARCH.SAL.OPER:".":AGENT.NUMBER:".":CTA.NOM.FILE.5

    CTA.NOM.FILE.6 = "Cuentas006.csv"
    CTA.FILE.6 = Y.PATH:'/':Y.LWD:".":Y.NOM.ARCH.SAL.OPER:".":AGENT.NUMBER:".":CTA.NOM.FILE.6
    
    OTR.NOM.FILE = "Otros.csv"
    OTR.FILE = Y.PATH : '/':Y.LWD:".":Y.NOM.ARCH.SAL.OPER:".":AGENT.NUMBER:".": OTR.NOM.FILE

    
    OPENSEQ CTA.FILE.4 TO CTA.STR.4 ELSE
        CREATE CTA.STR.4 ELSE NULL
    END
    OPENSEQ CTA.FILE.5 TO CTA.STR.5 ELSE
        CREATE CTA.STR.5 ELSE NULL
    END
    OPENSEQ CTA.FILE.6 TO CTA.STR.6 ELSE
        CREATE CTA.STR.6 ELSE NULL
    END
    
    OPENSEQ OTR.FILE TO OTR.STR ELSE
        CREATE OTR.STR ELSE NULL
    END
       

    Y.CTA.GC.SEL.CMD = "SELECT " : FN.GROUP.CREDIT.INT : " BY-DSND @ID"
    EB.DataAccess.Readlist(Y.CTA.GC.SEL.CMD, CTA.GC.SEL.LIST, '', CTA.GC.NO.OF.REC, CTA.GC.RET.COD)
    
    Y.ULT.DIA.W = ''
    Y.ULT.DIA.C = ''
    Y.ERROR.ULT.DIA = ''
    AbcSaldoOperPasivasAcc.AbcRutUltimoDiaMes(Y.LWD[1,6], 'W', Y.ULT.DIA.W, Y.ERROR.ULT.DIA)
    AbcSaldoOperPasivasAcc.AbcRutUltimoDiaMes(Y.LWD[1,6], 'C', Y.ULT.DIA.C, A.ERROR.ULT.DIA)
     
RETURN
*-------------------------------------
FINALIZA:
*-------------------------------------
    AbcSaldoOperPasivasAcc.setFnAccount(FN.ACCOUNT)
    AbcSaldoOperPasivasAcc.setFAccount(F.ACCOUNT)
   
    AbcSaldoOperPasivasAcc.setFnDao(FN.DAO)
    AbcSaldoOperPasivasAcc.setFDao(F.DAO)
    
    AbcSaldoOperPasivasAcc.setFnCustomer(FN.CUSTOMER)
    AbcSaldoOperPasivasAcc.setFCustomer(F.CUSTOMER)
    
    AbcSaldoOperPasivasAcc.setFnEbContractBalance(FN.EB.CONTRACT.BALANCES)
    AbcSaldoOperPasivasAcc.setFEbContractBalance(F.EB.CONTRACT.BALANCES)
    
    AbcSaldoOperPasivasAcc.setFnStmtAcctCr(FN.STMT.ACCT.CR)
    AbcSaldoOperPasivasAcc.setFStmtAcctCr(F.STMT.ACCT.CR)
    
    AbcSaldoOperPasivasAcc.setFnCategory(FN.CATEGORY)
    AbcSaldoOperPasivasAcc.setFCategory(F.CATEGORY)
    
    AbcSaldoOperPasivasAcc.setFnAbcPromEnlace(FN.ABC.PROM.ENLACE)
    AbcSaldoOperPasivasAcc.setFAbcPromEnlace(F.ABC.PROM.ENLACE)
    
    AbcSaldoOperPasivasAcc.setFnGroupCreditInt(FN.GROUP.CREDIT.INT)
    AbcSaldoOperPasivasAcc.setFGroupCreditInt(F.GROUP.CREDIT.INT)
    
    AbcSaldoOperPasivasAcc.setYPosClassification(Y.POS.CLASSIFICATION)
    
    AbcSaldoOperPasivasAcc.setYPosNomPerMoral(Y.POS.NOM.PER.MORAL)
    AbcSaldoOperPasivasAcc.setYLwd(Y.LWD)
    AbcSaldoOperPasivasAcc.setYPath(Y.PATH)
    AbcSaldoOperPasivasAcc.setYCategCuentaAhorro(Y.CATEG.CUENTA.AHORRO)
    AbcSaldoOperPasivasAcc.setYUltDiaW(Y.ULT.DIA.W)
    AbcSaldoOperPasivasAcc.setYUltDiaC(Y.ULT.DIA.C)
    AbcSaldoOperPasivasAcc.setYNomProcOpPas(Y.NOM.PROC.OP.PAS)
    AbcSaldoOperPasivasAcc.setCtaStr4(CTA.STR.4)
    AbcSaldoOperPasivasAcc.setCtaStr5(CTA.STR.5)
    AbcSaldoOperPasivasAcc.setCtaStr6(CTA.STR.6)
    AbcSaldoOperPasivasAcc.setOtrStr(OTR.STR)
    AbcSaldoOperPasivasAcc.setCtaGcNoOfRec(CTA.GC.NO.OF.REC)
    AbcSaldoOperPasivasAcc.setCtaGcSelList(CTA.GC.SEL.LIST)
    AbcSaldoOperPasivasAcc.setYCategCuentaSinChequera(Y.CATEG.CUENTA.SIN.CHEQUERA)
    AbcSaldoOperPasivasAcc.setYCategCuentaConChequera(Y.CATEG.CUENTA.CON.CHEQUERA)
    
    Y.CADENA.LOG<-1> = "Y.POS.NOM.PER.MORAL->" : Y.POS.NOM.PER.MORAL
    Y.CADENA.LOG<-1> = "Y.LWD->" : Y.LWD
    Y.CADENA.LOG<-1> = "Y.PATH->" : Y.PATH
    Y.CADENA.LOG<-1> = "Y.CATEG.CUENTA.AHORRO->" : Y.CATEG.CUENTA.AHORRO
    Y.CADENA.LOG<-1> = "Y.ULT.DIA.W->" : Y.ULT.DIA.W
    Y.CADENA.LOG<-1> = "Y.ULT.DIA.C->" : Y.ULT.DIA.C
    Y.CADENA.LOG<-1> = "Y.NOM.PROC.OP.PAS->" : Y.NOM.PROC.OP.PAS
    Y.CADENA.LOG<-1> = "CTA.STR.4->" : CTA.STR.4
    Y.CADENA.LOG<-1> = "CTA.STR.5->" : CTA.STR.5
    Y.CADENA.LOG<-1> = "CTA.STR.6->" : CTA.STR.6
    Y.CADENA.LOG<-1> = "OTR.STR->" : OTR.STR
    Y.CADENA.LOG<-1> = "CTA.GC.NO.OF.REC->" : CTA.GC.NO.OF.REC
    Y.CADENA.LOG<-1> = "CTA.GC.SEL.LIST->" : CTA.GC.SEL.LIST
    Y.CADENA.LOG<-1> = "Y.CATEG.CUENTA.SIN.CHEQUERA->" : Y.CATEG.CUENTA.SIN.CHEQUERA
    Y.CADENA.LOG<-1> = "Y.CATEG.CUENTA.CON.CHEQUERA->" : Y.CATEG.CUENTA.CON.CHEQUERA
    
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)
    
RETURN

END

