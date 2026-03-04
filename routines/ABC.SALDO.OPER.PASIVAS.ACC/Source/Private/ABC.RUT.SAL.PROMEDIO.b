* @ValidationCode : MjotMTIxMjQ5MjQ1NTpDcDEyNTI6MTc1OTQ1NzM1MDg3NTpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Oct 2025 23:09:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSaldoOperPasivasAcc

SUBROUTINE ABC.RUT.SAL.PROMEDIO (IN.CTA, IN.FECHA.HASTA, OUT.SALDO.PROM)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING EB.API
    $USING AC.BalanceUpdates
    $USING AC.AccountOpening
    $USING AC.AccountStatement
    $USING EB.Service
    $USING EB.Utility
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    CTA.ERR1    = ''
    CTA.RS      = ''


    CTA.ACT.ERR1    = ''
    CTA.ACT.RS      = ''

    CTA.SALDO.ERR1  = ''
    CTA.SALDO.RS    = ''

    V.FECHA.INICIO      = ''
    V.FECHA.APERTURA    = ''
    V.NO.DIAS       = 'C'
    V.SUM.SALDO     = 0
    V.SUM.DIAS      = 0
    V.SALDO.INI     = 0
    V.SALDO.ACTUAL  = 0

    OUT.SALDO.PROM  = 0

    A.ERROR.ULT.DIA = ''

    TODAY               = EB.SystemTables.getToday()
    BATCH.INFO          = EB.Service.getBatchInfo()
    Y.NOM.PROC.OP.PAS   = AbcSaldoOperPasivasAcc.getYNomProcOpPas()
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB SET.FECHA.INICIO
    GOSUB SET.FECHA.HASTA

    IF A.FECHA.HASTA LT V.FECHA.APERTURA THEN
        RETURN
    END

    EB.API.Cdd('', V.FECHA.INICIO, A.FECHA.HASTA, V.NO.DIAS)

    Y.ID.CTA.ACT    = IN.CTA : '-'  : A.FECHA.HASTA[1,6]
    CTA.ACT.RS      = AC.BalanceUpdates.AcctActivity.Read(RecId, CTA.ACT.ERR1)

    GOSUB SET.SALDO.INI

    OUT.SALDO.PROM = V.SALDO.INI

    V.SALDO.ACTUAL = V.SALDO.INI

    ACT.DAY.NO  = CTA.ACT.RS<AC.BalanceUpdates.AcctActivity.IcActDayNo>
    A.NO.CAMPOS =  DCOUNT(ACT.DAY.NO,@VM)
    
    ACT.BALANCE = CTA.ACT.RS<AC.BalanceUpdates.AcctActivity.IcActBalance>

    IF A.NO.CAMPOS GT 0 THEN

        A.POS.CAMPO = 1

        A.FECHA.IZQ = V.FECHA.INICIO

        LOOP

            A.FECHA.DER = V.FECHA.INICIO[1,6] : FIELD(ACT.DAY.NO ,@VM ,A.POS.CAMPO)

            IF A.FECHA.DER GT A.FECHA.HASTA THEN
                A.FECHA.DER = A.FECHA.HASTA
            END

            A.DIAS = 'C'

            EB.API.Cdd('', A.FECHA.IZQ, A.FECHA.DER, A.DIAS)

            V.SUM.SALDO += V.SALDO.ACTUAL *  A.DIAS
            V.SUM.DIAS  += A.DIAS

            V.SALDO.ACTUAL  = FIELD(ACT.BALANCE,@VM,A.POS.CAMPO)

            A.FECHA.IZQ     = A.FECHA.DER

            A.POS.CAMPO ++


        WHILE (A.FECHA.IZQ LE A.FECHA.HASTA) AND (A.POS.CAMPO LE A.NO.CAMPOS)
        REPEAT

        IF A.FECHA.IZQ LE A.FECHA.HASTA THEN
            A.DIAS = 'C'
            EB.API.Cdd('', A.FECHA.IZQ, A.FECHA.HASTA, A.DIAS)
            A.DIAS += 1

            V.SUM.SALDO += V.SALDO.ACTUAL * A.DIAS
            V.SUM.DIAS  += A.DIAS
        END

        OUT.SALDO.PROM = DROUND(V.SUM.SALDO / V.SUM.DIAS, 2)

    END

RETURN
*-----------------------------------------------------------------------------
SET.FECHA.INICIO:
*-----------------------------------------------------------------------------
    CTA.RS  = AC.AccountOpening.Account.Read(IN.CTA, CTA.ERR1)

    V.FECHA.APERTURA = CTA.RS<AC.AccountOpening.Account.OpeningDate>

    IF V.FECHA.APERTURA[1,6] EQ IN.FECHA.HASTA[1,6] AND V.FECHA.APERTURA NE ''  THEN

        V.FECHA.INICIO = V.FECHA.APERTURA

    END ELSE

        V.FECHA.INICIO = IN.FECHA.HASTA[1,6] : '01'

    END

RETURN
*-----------------------------------------------------------------------------
SET.FECHA.HASTA:
*-----------------------------------------------------------------------------
    A.ULT.DIA.WORK = ''

    AbcSaldoOperPasivasAcc.AbcRutUltimoDiaMes(IN.FECHA.HASTA[1,6], 'W', A.ULT.DIA.WORK, A.ERROR.ULT.DIA)

    IF IN.FECHA.HASTA EQ A.ULT.DIA.WORK THEN

        A.ULT.DIA.CAL = ''

        AbcSaldoOperPasivasAcc.AbcRutUltimoDiaMes(IN.FECHA.HASTA[1,6], 'C', A.ULT.DIA.CAL, A.ERROR.ULT.DIA)

        A.FECHA.HASTA = A.ULT.DIA.CAL

    END ELSE

        A.FECHA.HASTA = IN.FECHA.HASTA

    END

RETURN
*-----------------------------------------------------------------------------
SET.SALDO.INI:
*-----------------------------------------------------------------------------
    CTA.SALDO.RS    = AC.AccountStatement.AcctStmtPrint.Read(IN.CTA, CTA.SALDO.ERR1)

    A.ANIO.MES.HASTA    = A.FECHA.HASTA[1,6]
    A.MES.SISTEMA       = TODAY[1,6]
* CAST.20240919.I
    IF BATCH.INFO<3> EQ Y.NOM.PROC.OP.PAS THEN    ;*Y.NOM.PROC.OP.PAS es una variable dentro de I_ABC.SALDO.OPER.PASIVAS.ACC.COMMON
        A.MES.SISTEMA = EB.SystemTables.getRDates(EB.Utility.Dates.DatLastWorkingDay)
        A.MES.SISTEMA = A.MES.SISTEMA[1,6]
    END
* CAST.20240919.F
    IF A.ANIO.MES.HASTA EQ A.MES.SISTEMA THEN

        A.CANT.CAMPOS   = DCOUNT(CTA.SALDO.RS,@FM)
        A.REG.ANIO.MES  = SUBSTRINGS(FIELD(CTA.SALDO.RS,@FM,A.CANT.CAMPOS),1,6)

        IF A.REG.ANIO.MES EQ A.ANIO.MES.HASTA THEN

            A.REG.TAM   = LEN (FIELD(CTA.SALDO.RS,@FM,A.CANT.CAMPOS))
            V.SALDO.INI = SUBSTRINGS(FIELD(CTA.SALDO.RS,@FM,A.CANT.CAMPOS),10,A.REG.TAM - 10)

        END ELSE

            V.SALDO.INI = CTA.RS<AC.AccountOpening.Account.WorkingBalance>

        END

    END ELSE

        A.CANT.CAMPOS   = DCOUNT(CTA.SALDO.RS,@FM)
        A.POS.CAMPOS    = 0

        LOOP

            A.POS.CAMPOS        += 1
            A.ANIO.MES.CAMPO    = SUBSTRINGS(FIELD(CTA.SALDO.RS,@FM,A.POS.CAMPOS),1,6)

        WHILE A.ANIO.MES.CAMPO EQ  A.ANIO.MES.HASTA
        REPEAT

        A.REG.TAM   = LEN (FIELD(CTA.SALDO.RS,@FM,A.POS.CAMPOS))
        V.SALDO.INI = SUBSTRINGS(FIELD(CTA.SALDO.RS,@FM,A.POS.CAMPOS),10,A.REG.TAM - 10)

    END

    IF V.SALDO.INI EQ '' THEN
        V.SALDO.INI = 0
    END

RETURN
*-----------------------------------------------------------------------------
END