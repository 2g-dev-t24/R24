* @ValidationCode : MjoxNTQzMTU4NTY2OkNwMTI1MjoxNzY5MTIxNzY5NDM5OkVkZ2FyIFNhbmNoZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2026 16:42:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar Sanchez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcCob
SUBROUTINE ABC.CAL.SDO.NETO.LOAD

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Updates
    $USING EB.Service
    $USING AbcGetGeneralParam
    $USING AbcTable
    
    TODAY = EB.SystemTables.getToday()
    
    GOSUB INICIALIZA
    GOSUB OBTIENE.TAX
    GOSUB OBTIENE.FECHAS
    GOSUB OBTIENE.BASE.CALCULO

RETURN

***********
INICIALIZA:
***********

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)
    AbcCob.setFnCustomer(FN.CUSTOMER)
    AbcCob.setFCustomer(F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    AbcCob.setFnAccount(FN.ACCOUNT)
    AbcCob.setFAccount(F.ACCOUNT)

    FN.AA.INTEREST.ACCRUALS = 'F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS = ''
    EB.DataAccess.Opf(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)
    AbcCob.setFnAaInterestAccruals(FN.AA.INTEREST.ACCRUALS)
    AbcCob.setFAaInterestAccruals(F.AA.INTEREST.ACCRUALS)

    FN.ABC.SDO.COMP.IPAB = 'F.ABC.SDO.COMP.IPAB'
    F.ABC.SDO.COMP.IPAB = ''
    EB.DataAccess.Opf(FN.ABC.SDO.COMP.IPAB,F.ABC.SDO.COMP.IPAB)
    AbcCob.setFnAbcSdoCompIpab(FN.ABC.SDO.COMP.IPAB)
    AbcCob.setFAbcSdoCompIpab(F.ABC.SDO.COMP.IPAB)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    EB.DataAccess.Opf(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)
    AbcCob.setFnEbContractBalances(FN.EB.CONTRACT.BALANCES)
    AbcCob.setFEbContractBalances(F.EB.CONTRACT.BALANCES)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    EB.DataAccess.Opf(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    AbcCob.setFnAaArrangement(FN.AA.ARRANGEMENT)
    AbcCob.setFAaArrangement(F.AA.ARRANGEMENT)

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)
    AbcCob.setFnAbcAcctLclFlds(FN.ABC.ACCT.LCL.FLDS)
    AbcCob.setFAbcAcctLclFlds(F.ABC.ACCT.LCL.FLDS)
    
   
    applications     = ""
    fields           = ""
    applications<1>  = "CUSTOMER"
    fields<1,1>      = "ITF.TAX.EXEMPT"
   
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications,fields,field_Positions)
    POS.EXENTO.IVA= field_Positions<1,1>
    AbcCob.setPosExentoIva(POS.EXENTO.IVA)
    
RETURN

***************
OBTIENE.TAX:
***************

    VAL.POR.RET = '0'
    VAL.POR.RET.INV = '0'

    EB.DataAccess.CacheRead('F.ABC.IPAB.PARAM','SYSTEM',R.ABC.IPAB.PARAM,YERR)
    TAX.ID.LIST = R.ABC.IPAB.PARAM<AbcTable.AbcIpabParam.IdIsr>
    CHANGE ',' TO @FM IN TAX.ID.LIST
    COUNT.TAX.ID = DCOUNT(TAX.ID.LIST,@FM)
    AbcCob.setTaxIdList(TAX.ID.LIST)
    AbcCob.setCountTaxId(COUNT.TAX.ID)

    FOR I = 1 TO COUNT.TAX.ID
        Y.TAX.ID = TAX.ID.LIST<I>
        AbcCob.abcObtieneTax(Y.TAX.ID,TODAY,TAX)
        IF I EQ 1 THEN VAL.POR.RET = TAX
        IF I EQ 2 THEN VAL.POR.RET.INV = TAX
    NEXT I
    AbcCob.setValPorRet(VAL.POR.RET)
    AbcCob.setValPorRetInv(VAL.POR.RET.INV)

RETURN

***************
OBTIENE.FECHAS:
***************

    EB.DataAccess.CacheRead('F.TSA.SERVICE','COB',R.TSA.SERVICE,YERR)

    Y.COB.STATUS = R.TSA.SERVICE<EB.Service.TsaService.TsTsmServiceControl>
    AbcCob.setYCobStatus(Y.COB.STATUS)

    IF Y.COB.STATUS EQ 'STOP' THEN
        FECHA.INI = TODAY[1,6]:'01'
        FECHA.FIN = TODAY
        VAL.FREC = 'D'
    END ELSE
        FECHA.INI = TODAY[1,6]:'01'
        VAL.FREC = 'M'
        GOSUB OBTIENE.ULTIMO.DIA
        FECHA.FIN = TODAY[1,6]:YVAR
    END
    AbcCob.setFechaIni(FECHA.INI)
    AbcCob.setFechaFin(FECHA.FIN)
    AbcCob.setValFrec(VAL.FREC)
    AbcCob.setYVar(YVAR)

RETURN

*******************
OBTIENE.ULTIMO.DIA:
*******************

    HOLIDAY.ID = 'MX00':FECHA.INI[1,4]
    YFLD = 14

    EB.DataAccess.CacheRead('F.HOLIDAY',HOLIDAY.ID,R.HOLIDAY,YERR)

    IF R.HOLIDAY THEN
        YMTH = FECHA.INI[5,2]
        FOR J = 1 TO 12
            IF YMTH = J THEN
                YVAR = LEN(R.HOLIDAY<YFLD>)-COUNT(R.HOLIDAY<YFLD>,'X')
                EXIT
            END
            YFLD += 1
        NEXT J
    END

RETURN

*********************
OBTIENE.BASE.CALCULO:
*********************

    Y.ID.GEN.PARAM = 'ABC.BASE.CALCULO.DIAS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'NUM.DIAS' IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.DIAS.CALC = Y.LIST.VALUES<YPOS.PARAM>
    END
    AbcCob.setYDiasCalc(Y.DIAS.CALC)

RETURN

END
