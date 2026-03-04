* @ValidationCode : Mjo2MDMyMjU3MTpDcDEyNTI6MTc2MzY0ODk3ODM5NDpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Nov 2025 11:29:38
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
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
SUBROUTINE ABC.2BR.MONTO(IN.MONTO)
******************************************************************
    $USING TT.Contract
    $USING EB.DataAccess
********************
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
********************
INIT:
********************
    FN.TT = "F.TELLER"
    F.TT = ""
    Y.IN.MONTO = IN.MONTO
    TT.ERR1 = ""
    R.CI = ""
    
RETURN
********************
OPENFILES:
********************
    EB.DataAccess.Opf(FN.TT,F.TT)
    
RETURN
********************
PROCESS:
********************
    EB.DataAccess.FRead(FN.TT,Y.IN.MONTO,R.CI,F.TT,TT.ERR1)
    Y.MONEDA    = R.CI<TT.Contract.Teller.TeCurrencyOne>
    Y.MONTO.MXN = R.CI<TT.Contract.Teller.TeAmountLocalOne>
    Y.MONTO.USD = R.CI<TT.Contract.Teller.TeAmountFcyOne>

    IF Y.MONEDA EQ 'MXN' THEN
        IN.MONTO = Y.MONTO.MXN
    END ELSE
        IN.MONTO = Y.MONTO.USD
    END

    IN.MONTO = FMT(IN.MONTO,'R2,')
    
RETURN
********************
END
