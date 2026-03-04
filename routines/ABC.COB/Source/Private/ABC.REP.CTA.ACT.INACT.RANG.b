* @ValidationCode : Mjo5NDE4NTgwMjQ6Q3AxMjUyOjE3Njg4NTU3NTc4NzA6RWRnYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jan 2026 14:49:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcCob
SUBROUTINE ABC.REP.CTA.ACT.INACT.RANG

    $USING EB.DataAccess
    $USING EB.API
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING EB.Utility
    $USING AbcTable
    $USING AbcGetGeneralParam
    $USING EB.Template

    GOSUB INICIO

    STR.CUADRE = ''; STR.TOTAL.PF = ''; STR.TOTAL.PM = '';
    FOR YNO.CLAS.CTA = 1 TO DCOUNT(CLAS.CTAS,@FM)
        CIC.FIL = FIELD(CLAS.CTAS,@FM,YNO.CLAS.CTA)
        RANG.CTAS = ''
        RANG.SALD = ''
        GOSUB SELECT
        GOSUB PROCESS
        IF YNO.CLAS.CTA EQ 1 THEN
            Y.REG.RANG.CTAS = RANG.CTAS
            Y.REG.RANG.SALD = RANG.SALD
        END ELSE
            Y.REG.RANG.CTAS := "*": RANG.CTAS
            Y.REG.RANG.SALD := "*": RANG.SALD
        END
    NEXT YNO.CLAS.CTA
    GOSUB ARCHIVA

RETURN

*------
INICIO:
*------

    FN.ACC   = 'F.ACCOUNT';  F.ACC   = ''; EB.DataAccess.Opf(FN.ACC,F.ACC)
    FN.CLI   = 'F.CUSTOMER'; F.CLI   = ''; EB.DataAccess.Opf(FN.CLI, F.CLI)
    FN.FECHA = 'F.DATES';    F.FECHA = ''; EB.DataAccess.Opf(FN.FECHA,F.FECHA)

    Y.ID.PARAM = 'ABC.REP.CTA.ACT.INACT.RANG'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE "PATH" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.PATH = Y.LIST.VALUES<YPOS.PARAM>
    END

    LOCATE "PATH.CD" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.PATH.CD = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    LOCATE "SALDO.MINIMO" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        SALDO.MINIMO = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    LOCATE "COMPANY" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        YID.FECHA = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    LOCATE "Y.NOM.ARCH" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.NOM.ARCH = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    LOCATE "EB.LOOKUP.MIN" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        EB.RANG.MIN = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    LOCATE "EB.LOOKUP.MAX" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        EB.RANG.MAX = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    LOCATE "CATEGORY.CHEQUES" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        CATEGORY.CHEQUES = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    LOCATE "ETIQUETA.CHEQUES" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        ETIQUETA.CHEQUES = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    LOCATE "CATEGORY.AHORRO" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        CATEGORY.AHORRO = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    LOCATE "ETIQUETA.AHORRO" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        ETIQUETA.AHORRO = Y.LIST.VALUES<YPOS.PARAM>
    END
    FN.SFILE     = Y.PATH
    F.SFILE      = ''
    FN.CUADRE    = Y.PATH.CD
    F.CUADRE     = ''
    SEP          = ','
    RANG.MIN     = ''
    RANG.MAX     = ''

    REC.MIN = EB.Template.Lookup.Read(EB.RANG.MIN, ERR.MIN)
    IF REC.MIN THEN
        RANG.MIN = REC.MIN<EB.Template.Lookup.LuDataValue>
        CHANGE @VM TO @FM IN RANG.MIN
    END

    REC.MAX = EB.Template.Lookup.Read(EB.RANG.MAX, ERR.MAX)
    IF REC.MAX THEN
        RANG.MAX = REC.MIN<EB.Template.Lookup.LuDataValue>
        CHANGE @VM TO @FM IN RANG.MAX
    END

    RANG.CTAS = ''
    RANG.SALD = ''

    Y.REG.RANG.CTAS = ''
    Y.REG.RANG.SALD = ''

    CLAS.CTAS = ''
    CLAS.CTAS<-1> = CATEGORY.CHEQUES :@VM: ETIQUETA.CHEQUES
    CLAS.CTAS<-1> = CATEGORY.AHORRO :@VM: ETIQUETA.AHORRO

    NUMERO.DIAS.PERIODO = ''; FECHA.SISTEMA = ''; YTODAY = ''; YDATE = ''; YLWD = ''; YNWD = ''; YLWD.1 = ''; YDATE.1 = ''; PERIODO = '';
    R.FECHA = ''; ERROR.FECHA = '';
    EB.DataAccess.FRead(FN.FECHA,YID.FECHA,R.FECHA,F.FECHA,ERROR.FECHA)
    IF ERROR.FECHA EQ '' THEN
        YTODAY = R.FECHA<EB.Utility.Dates.DatToday>
        YLWD   = R.FECHA<EB.Utility.Dates.DatLastWorkingDay>
        YNWD   = R.FECHA<EB.Utility.Dates.DatNextWorkingDay>
    END

    YDATE = YTODAY
    YLWD.1 = YLWD

    EB.API.Cdt('',YLWD.1, "+1C")
    IF YLWD.1 EQ YDATE THEN
        EB.API.Cdt('',YDATE, "-1C")
    END ELSE
        YDIA =  YDATE[7,2]
        YDATE.1 = YDATE
        EB.API.Cdt('',YDATE.1, "-":YDIA:"C")
        IF YLWD GT YDATE.1 THEN
            EB.API.Cdt('',YDATE, "-1C")
        END ELSE
            EB.API.Cdt('',YDATE, "-":YDIA:"C")
        END
    END

    FECHA.SISTEMA = YTODAY
    FEC.INI.PER = YDATE
    FEC.INI.PER = FEC.INI.PER[1,6]:'01'
    FEC.FIN.PER = YDATE
    PERIODO = FEC.INI.PER[1,6]
    NUMERO.DIAS.PERIODO = FEC.FIN.PER[7,2]

    MAX.RANG.MAX = DCOUNT(RANG.MAX,@FM)

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)

RETURN

*------
SELECT:
*------
    FILTRO = FIELD(CIC.FIL,@VM,1)
    SEL.CMD = ""; LIST.AC = ""; NO.ACC = 0 ; ERR.SEL = "";
    SEL.CMD = "SELECT ":FN.ACC:" WITH CATEGORY EQ ":FILTRO:" AND @ID UNLIKE ":DQUOTE(SQUOTE('MXN'):"..."):" AND @ID UNLIKE " :DQUOTE(SQUOTE('USD'):"..."):" AND CONDITION.GROUP NE ": DQUOTE(80) : " AND ARRANGEMENT.ID EQ '' BY @ID"  ; *ITSS - ANJALI - Added DQUOTE / SQUOTE
    EB.DataAccess.Readlist(SEL.CMD,LIST.AC,'',NO.ACC,ERR.SEL)
RETURN

*-------
PROCESS:
*-------

    FOR YNO.LIST.AC = 1 TO NO.ACC
        CIC.ACC = FIELD(LIST.AC,@FM,YNO.LIST.AC)
        BAN.ACTIVA = 0

        READ REC.AC FROM F.ACC, CIC.ACC THEN
            DAT.CR.CUS = ''; DAT.BR.CUS = ''; SAL.CORT = ''; FEC.APRT = ''; TIP.PER = ''; CATEGORIA = '';
            ID.CLIENTE = REC.AC<AC.AccountOpening.Account.Customer>
            CLI.RS = ''; CLI.ERR1 = '';
            EB.DataAccess.FRead(FN.CLI,ID.CLIENTE,CLI.RS,F.CLI,CLI.ERR1)
            IF CLI.RS THEN
                YRESTRICT = ''; YSTA.CUS = '';
                YRESTRICT = CLI.RS<ST.Customer.Customer.EbCusPostingRestrict>
                IF YRESTRICT NE 90 THEN
                    YSTA.CUS = CLI.RS<ST.Customer.Customer.EbCusCustomerStatus>
                    IF YSTA.CUS NE 2 THEN
                        DAT.CR.CUS = REC.AC<AC.AccountOpening.Account.DateLastCrCust>
                        DAT.BR.CUS = REC.AC<AC.AccountOpening.Account.DateLastDrCust>
                        SAL.CORT   = REC.AC<AC.AccountOpening.Account.OpenClearedBal>      ;* NS Changes
                        FEC.APRT   = REC.AC<AC.AccountOpening.Account.OpeningDate>
                        EB.DataAccess.CacheRead(FN.ABC.ACCT.LCL.FLDS,CTA.C,R.ABC.ACCT.LCL.FLDS,YERR.LCL)
                        TIP.PER    = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Classification>
                        CATEGORIA  = REC.AC<AC.AccountOpening.Account.Category>
                        IF SAL.CORT GE SALDO.MINIMO THEN
                            GOSUB CLASIFICA
                            BAN.ACTIVA = 1
                        END ELSE
                            IF SAL.CORT GE 0  THEN
                                GOSUB CLASIFICA
                                BAN.ACTIVA = 1
                            END ELSE
                                RANG.CTAS<MAX.RANG.MAX> += 1
                                RANG.SALD<MAX.RANG.MAX> += SAL.CORT
                                BAN.ACTIVA = 0
                            END
                        END
                        IF BAN.ACTIVA EQ 1 THEN
                            IF TIP.PER EQ '3' THEN
                                ACUM.CTA = STR.TOTAL.PM<YNO.CLAS.CTA,1> + 1
                                ACUM.SAL = STR.TOTAL.PM<YNO.CLAS.CTA,2> + SAL.CORT
                                STR.TOTAL.PM<YNO.CLAS.CTA> = ACUM.CTA :@VM: ACUM.SAL
                            END ELSE
                                IF TIP.PER LT '3' THEN
                                    ACUM.CTA = STR.TOTAL.PF<YNO.CLAS.CTA,1> + 1
                                    ACUM.SAL = STR.TOTAL.PF<YNO.CLAS.CTA,2> + SAL.CORT
                                    STR.TOTAL.PF<YNO.CLAS.CTA> = ACUM.CTA :@VM: ACUM.SAL
                                END
                            END
                        END
                        STR.CUADRE<-1> = CIC.ACC:"*":DAT.CR.CUS:"*":DAT.BR.CUS:"*":SAL.CORT:"*":CATEGORIA:"*":FEC.APRT:"*":R.MIN:"*":R.MAX:"*":BAN.ACTIVA:"*":TIP.PER
                        CIC.ACC = ''; DAT.CR.CUS = ''; DAT.BR.CUS = ''; SAL.CORT = ''; CATEGORIA = ''; FEC.APRT = ''; R.MIN = ''; R.MAX = '';
                    END
                END
            END
        END
    NEXT YNO.LIST.AC

RETURN

*---------
CLASIFICA:
*---------

    R.MIN = ''; R.MAX = '';
    IF SAL.CORT LE 0 THEN
        RANG.CTAS<1> += 1
        RANG.SALD<1> += SAL.CORT
    END ELSE
        FOR YNO.RANG = 1 TO MAX.RANG.MAX - 1
            RANG = MAX.RANG.MAX - 1
            IF YNO.RANG EQ RANG THEN
                R.MIN = '';
                R.MIN = RANG.MIN<YNO.RANG>
                IF SAL.CORT GT R.MIN THEN
                    RANG.CTAS<YNO.RANG> += 1
                    RANG.SALD<YNO.RANG> += SAL.CORT
                    BREAK
                END
            END ELSE
                R.MAX = '';
                R.MIN = RANG.MIN<YNO.RANG>
                R.MAX = RANG.MAX<YNO.RANG>
                IF SAL.CORT GT R.MIN AND SAL.CORT LE R.MAX THEN
                    RANG.CTAS<YNO.RANG> += 1
                    RANG.SALD<YNO.RANG> += SAL.CORT
                    BREAK
                END
            END
        NEXT YNO.RANG
    END

RETURN

*-------
ARCHIVA:
*-------

    Y.ARR = ''
    FOR YNO.CLAS.CTA = 1 TO DCOUNT(CLAS.CTAS,@FM)
        CIC.FIL   = ''
        CIC.FIL   = FIELD(CLAS.CTAS,@FM,YNO.CLAS.CTA)
        Y.ARR<-1> = FIELD(CIC.FIL,@VM,2) :SEP: "" :SEP: "CUENTAS" :SEP: "SALDOS"

        SUM.CTAS  = 0
        SUM.SALD  = 0
        RANG.CTAS = ''
        RANG.SALD = ''
        RANG.CTAS = FIELD(Y.REG.RANG.CTAS,"*",YNO.CLAS.CTA)
        RANG.SALD = FIELD(Y.REG.RANG.SALD,"*",YNO.CLAS.CTA)

        FOR YNO.ARCH = 1 TO MAX.RANG.MAX
            IF RANG.CTAS<YNO.ARCH> EQ '' THEN RANG.CTAS<YNO.ARCH> = 0
            IF RANG.SALD<YNO.ARCH> EQ '' THEN RANG.SALD<YNO.ARCH> = 0
            Y.ARR<-1> = RANG.MIN<YNO.ARCH> :SEP: RANG.MAX<YNO.ARCH> :SEP: RANG.CTAS<YNO.ARCH> :SEP: FMT(DROUND(RANG.SALD<YNO.ARCH>,2),"R2")
            SUM.CTAS += RANG.CTAS<YNO.ARCH>
            SUM.SALD += FMT(DROUND(RANG.SALD<YNO.ARCH>,2),"R2")
        NEXT YNO.ARCH

        Y.ARR<-1>= "" :SEP: "Total" :SEP: SUM.CTAS :SEP: SUM.SALD
        Y.ARR<-1>= "" :SEP: "" :SEP: "" :SEP: ""

    NEXT YNO.CLAS.CTA

    FOR YNO.CLAS.CTA = 1 TO DCOUNT(CLAS.CTAS,@FM)
        CIC.FIL = FIELD(CLAS.CTAS,@FM,YNO.CLAS.CTA)
        CANT.CTA = STR.TOTAL.PF<YNO.CLAS.CTA,1>
        IF CANT.CTA EQ '' THEN CANT.CTA = 0
        Y.ARR<-1>=  ",Persona Fisica":SEP: CANT.CTA :SEP: STR.TOTAL.PF<YNO.CLAS.CTA,2> :SEP: FIELD(CIC.FIL,@VM,2)
    NEXT YNO.CLAS.CTA

    FOR YNO.CLAS.CTA = 1 TO DCOUNT(CLAS.CTAS,@FM)
        CIC.FIL = FIELD(CLAS.CTAS,@FM,YNO.CLAS.CTA)
        CANT.CTA = STR.TOTAL.PM<YNO.CLAS.CTA,1>
        IF CANT.CTA EQ '' THEN CANT.CTA = 0
        Y.ARR<-1>= ",Persona Moral" :SEP: CANT.CTA :SEP: FMT(DROUND(STR.TOTAL.PM<YNO.CLAS.CTA,2>,2),"R2") :SEP: FIELD(CIC.FIL,@VM,2)
    NEXT YNO.CLAS.CTA

    OPEN '', FN.SFILE TO F.SFILE ELSE NULL

    YSTMT.ID = PERIODO:"_": Y.NOM.ARCH      ;* :".csv" - se comenta por migracion. Dato parametrico
    WRITE Y.ARR TO F.SFILE,YSTMT.ID
    CLOSE F.SFILE
    
    OPEN '', FN.CUADRE TO F.CUADRE ELSE NULL
    WRITE STR.CUADRE TO F.CUADRE, "CUADRE_":YSTMT.ID
    CLOSE F.CUADRE
RETURN

END
