* @ValidationCode : Mjo1ODMzNjUyNjY6Q3AxMjUyOjE3NjM2NzU1MTUyMzQ6RWRnYXIgU2FuY2hlejotMTotMTowOjA6ZmFsc2U6Ti9BOlVuZGVmaW5lZDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Nov 2025 15:51:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar Sanchez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : Undefined
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSaldoOperPasivasAcc

SUBROUTINE ABC.REPROCESA.SALDO.OPER.INV.LOAD
*===============================================================================
* Modificado por : CAST
* Fecha          : 07 Mayo 2024
* Descripcion    : Rutina emergente se genera para obtener el reporte de Saldos Operativos de Inversiones para fechas pasadas.
*
*===============================================================================
* Modificaciones:
*===============================================================================
* Fecha Modificacion :  2025-04-03
* Modificado por     :  FyG Solutions
* Descripcion        :  Se agrega validacion en el valor de fecha
*===============================================================================
* Fecha Modificacion :  2025-10-01
* Modificado por     :  esanchezg - FyG Solutions
* Descripcion        :  Se cambia el valor de Fecha a TODAY -1C
*===============================================================================
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING EB.API

    $USING AbcTable
    $USING AbcGetGeneralParam
    $USING EB.Utility
    $USING AbcSaldoOperPasivasAcc
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.ARR  = 'F.AA.ARRANGEMENT'
    F.ARR   = ''
    EB.DataAccess.Opf(FN.ARR,F.ARR)

    FN.TBL.INS  = 'F.TMP.REP.SAL.OP'
    F.TBL.INS   = ''
    EB.DataAccess.Opf(FN.TBL.INS, F.TBL.INS)

    FN.ABC.ACCT.LCL.FLDS  = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS   = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)
    
    Y.APP   = "CUSTOMER"
    Y.FLD   = "L.NOM.PER.MORAL"
    Y.POS.FLD = ''
    EB.Updates.MultiGetLocRef(Y.APP, Y.FLD, Y.POS.FLD)
    YPOS.NOM.PER.MORAL = Y.POS.FLD<1,1>

    Y.ID.GEN.PARAM = 'ABC.REPROC.SAL.OP.PAS'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.SEP = '|'
    
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'CEDE.FIJO' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.CATEG.CEDE.FIJO= Y.LIST.VALUES<Y.POS.PARAM>
        CHANGE Y.SEP TO @VM IN Y.CATEG.CEDE.FIJO
    END
    LOCATE 'CEDES.VARI.REVI' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.CATEG.CEDES.VARI.REVI = Y.LIST.VALUES<Y.POS.PARAM>
        CHANGE Y.SEP TO @VM IN Y.CATEG.CEDES.VARI.REVI
    END
    LOCATE 'PAGARE' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.CATEG.PAGARE = Y.LIST.VALUES<Y.POS.PARAM>
        CHANGE Y.SEP TO @VM IN Y.CATEG.PAGARE
    END
    LOCATE 'FECHA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.TODAY = Y.LIST.VALUES<Y.POS.PARAM>
    END

    FN.DATES = 'F.DATES'
    F.DATES     = ''
    EB.DataAccess.Opf(FN.DATES,F.DATES)
    
    ID.COMPANY  = EB.SystemTables.getIdCompany()
    EB.DataAccess.FRead(FN.DATES,ID.COMPANY,YREC.DATES,F.DATES,YF.ERR)
    
    IF Y.TODAY EQ "!TODAY" THEN
*        Y.TODAY = YREC.DATES<EB.Utility.Dates.DatLastWorkingDay>
        Y.TODAY = YREC.DATES<EB.Utility.Dates.DatToday>     ;*esanchezg-20251001
        EB.API.Cdt('', Y.TODAY, '-1C')                      ;*esanchezg-20251001
    END

    A.CAT.CAMPO.001 = Y.CATEG.CEDE.FIJO ;* CD Fixed
    A.CAT.CAMPO.002 = Y.CATEG.CEDES.VARI.REVI     ;* CD Variable y CD Revisable
    A.CAT.CAMPO.003 = Y.CATEG.PAGARE    ;* Promissory
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    AbcSaldoOperPasivasAcc.setFnArr(FN.ARR)
    AbcSaldoOperPasivasAcc.setFArr(F.ARR)
    
    AbcSaldoOperPasivasAcc.setFnTblIns(FN.TBL.INS)
    AbcSaldoOperPasivasAcc.setFTblIns(F.TBL.INS)
    
    AbcSaldoOperPasivasAcc.setFnAbcAcctLclFlds(FN.ABC.ACCT.LCL.FLDS)
    AbcSaldoOperPasivasAcc.setFAbcAcctLclFlds(F.ABC.ACCT.LCL.FLDS)
    
    AbcSaldoOperPasivasAcc.setYPosNomPerMoral(YPOS.NOM.PER.MORAL)
    
    AbcSaldoOperPasivasAcc.setYToday(Y.TODAY)
    AbcSaldoOperPasivasAcc.setACatCampo001(A.CAT.CAMPO.001)
    AbcSaldoOperPasivasAcc.setACatCampo002(A.CAT.CAMPO.002)
    AbcSaldoOperPasivasAcc.setACatCampo003(A.CAT.CAMPO.003)
   
RETURN
*-----------------------------------------------------------------------------
END