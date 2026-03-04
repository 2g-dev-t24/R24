* @ValidationCode : MjoxOTgwMDE5OTY0OkNwMTI1MjoxNzU4NjQzNzIzODY5OlVzdWFyaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 Sep 2025 11:08:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usuario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcContractService
SUBROUTINE ABC.CALC.INTERES.CONTRATO(Y.PARAM.ADI,Y.IVA.AD,Y.IVA.MTO.ADI)

*======================================================================================
* Nombre de Programa : ABC.CALC.INTERES.CONTRATO
* Objetivo           : Rutina para calculo de intereses de contratos para carátulas
*                      adicionales.
* Desarrollador      : Claudia Catalina Benitez Cerrillo - F&GSolutions
* Fecha Creacion     : CCBC_20180510
* Fecha Modificacion :
* Desarrollador      :
* Modificaciones     :
*======================================================================================
* Subroutine Type : CALL RTN
* Attached to : Called from ABC.NOFILE.REPORTE.CONTRATOS
* Attached as : Call Rtn
* Primary Purpose : Rutina para calculo de intereses de contratos
*-----------------------------------------------------------------------
* Luis Cruz
* 22/09/2025
* Revision de rutina componentizada por 2G
*-----------------------------------------------------------------------
* $INSERT I_COMMON - Not Used anymore;
* $INSERT I_EQUATE - Not Used anymore;
* $INSERT I_TSA.COMMON - Not Used anymore;
* $INSERT I_ENQUIRY.COMMON - Not Used anymore;
* $INSERT I_F.ACCOUNT - Not Used anymore;
* $INSERT I_F.CUSTOMER - Not Used anymore;

*    $INSERT I_F.ABC.2LN.DEPOSIT.RATES
*    $INSERT I_F.REVAISABLE.INTEREST
    
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING AbcTable
    $USING EB.Template
    


    GOSUB INICIALIZA

RETURN

INICIALIZA:

    Y.FECHA.APER = FIELD(Y.PARAM.ADI,"|",1)
    Y.AD.PREF    = FIELD(Y.PARAM.ADI,"|",2)
    Y.AD.DIAS    = FIELD(Y.PARAM.ADI,"|",3)
    Y.AD.GRUP    = FIELD(Y.PARAM.ADI,"|",4)

    FN.ABC.2LN.DEPOSIT.RATES = 'F.ABC.2LN.DEPOSIT.RATES'
    F.ABC.2LN.DEPOSIT.RATES = ''
    EB.DataAccess.Opf(FN.ABC.2LN.DEPOSIT.RATES,F.ABC.2LN.DEPOSIT.RATES)

    FN.REVAISABLE.INTEREST = 'F.REVAISABLE.INTEREST'
    F.REVAISABLE.INTEREST = ''
    EB.DataAccess.Opf(FN.REVAISABLE.INTEREST,F.REVAISABLE.INTEREST)

    Y.IVA.AD      = 0
    Y.IVA.MTO.ADI = 0
    Y.REV.INT     = 0

    BEGIN CASE
        CASE Y.AD.PREF EQ 301 OR Y.AD.PREF EQ 302
            GOSUB LEE.IVA.VPM
        CASE Y.AD.PREF EQ 304
            GOSUB LEE.IVA.VPM
            GOSUB LEE.IVA.REV
    END CASE

RETURN

***********
LEE.IVA.VPM:
***********

*SELECT FBNK.VPM.2LN.DEPOSIT.RATES WITH EVAL'@ID[1,3]' EQ 301 AND EVAL'@ID[4,8]' LE 20180321 AND EVAL'@ID[12,4]' EQ MXN5 BY-DSND @ID

    Y.SELECT = "SELECT ": FN.ABC.2LN.DEPOSIT.RATES : " WITH EVAL'@ID[1,3]' EQ ": DQUOTE(Y.AD.PREF) : " AND EVAL'@ID[4,8]' LE " : DQUOTE(Y.FECHA.APER) : " AND EVAL'@ID[12,4]' EQ ":DQUOTE("MXN" : Y.AD.GRUP) : " BY-DSND @ID"  ; * ITSS - BINDHU - Added DQUOTE
    Y.LIST = "" ; IVA.GRUPO = "" ; R.INFO.IVA = "" ; MNT.IVA.GRUPO = ""
    EB.DataAccess.Readlist(Y.SELECT,Y.LIST,"",Y.TOT.REC,Y.ERROR)

    IF Y.LIST THEN
        Y.ID.IVA = Y.LIST<1>
;*EB.DataAccess.FRead(FN.ABC.2LN.DEPOSIT.RATES,Y.ID.IVA,R.INFO.IVA,F.ABC.2LN.DEPOSIT.RATES,Y.ERR.IVA)
        R.INFO.IVA = AbcTable.Abc2lnDepositRates.Read(Y.ID.IVA, ERR.DEP.RAT)
        IF R.INFO.IVA THEN
            Y.LIST.PERIOD = RAISE(AbcTable.Abc2lnDepositRates.DayPeriod) ;*(R.INFO.IVA<DEP.RAT.DAY.PERIOD>)
            Y.LIST.AMT    = R.INFO.IVA<AbcTable.Abc2lnDepositRates.Amount> ;*<DEP.RAT.AMOUNT>
            Y.LIST.PER    = R.INFO.IVA<AbcTable.Abc2lnDepositRates.Percentage> ;*<DEP.RAT.PERCENTAGE>
            LOCATE Y.AD.DIAS IN Y.LIST.PERIOD SETTING POS THEN
                Y.LIST.AMT = Y.LIST.AMT<1,POS>
                Y.LIST.PER = Y.LIST.PER<1,POS>
            END
            Y.ULT.VAL = DCOUNT(Y.LIST.AMT,@SM)
            Y.IVA.AD      = Y.LIST.PER<1,1,Y.ULT.VAL>
            Y.IVA.MTO.ADI = Y.LIST.AMT<1,1,Y.ULT.VAL>
        END
    END
RETURN

***********
LEE.IVA.REV:
***********

*SELECT FBNK.REVAISABLE.INTEREST WITH EVAL'@ID[1,3]' EQ 301 AND EVAL'@ID[7,8]' LE 20180321 BY-DSND @ID

    Y.SELECT = "SELECT ": FN.REVAISABLE.INTEREST : " WITH EVAL'@ID[1,3]' EQ ":DQUOTE(Y.AD.PREF) : " AND EVAL'@ID[7,8]' LE " : DQUOTE(Y.FECHA.APER) : " BY-DSND @ID"  ; * ITSS - BINDHU - Added DQUOTE
    Y.LIST = "" ; IVA.GRUPO = "" ; R.INFO.IVA = "" ; MNT.IVA.GRUPO = ""
    EB.DataAccess.Readlist(Y.SELECT,Y.LIST,"",Y.TOT.REC,Y.ERROR)

    IF Y.LIST THEN
        Y.ID.IVA = Y.LIST<1>
;*EB.DataAccess.FRead(FN.REVAISABLE.INTEREST,Y.ID.IVA,R.INFO.IVA,F.REVAISABLE.INTEREST,Y.ERR.IVA)
        R.INFO.IVA = AbcTable.RevaisableInterest.Read(Y.ID.IVA, ERR.REV.INT)
        IF R.INFO.IVA THEN
            Y.REV.INT = R.INFO.IVA<AbcTable.RevaisableInterest.InterestRate> ;*<ABC.RI.INTEREST.RATE>
            Y.IVA.AD += Y.REV.INT
        END

    END

RETURN

END
