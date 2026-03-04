* @ValidationCode : MjotMjU4MzU5ODE1OkNwMTI1MjoxNzU4Njc2MzA1OTk4Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 Sep 2025 22:11:45
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
* <Rating>584</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.2BR.FORMATO.DSF(IN.FORMATO)
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
**********
    GOSUB INIT
    GOSUB PROCESS

RETURN
**********
INIT:
**********
    Y.FORMATO = IN.FORMATO
    Y.TIPO    = Y.FORMATO[1,3]

RETURN
**********
PROCESS:
**********
    IF NOT(NUM(Y.TIPO)) THEN
        IN.FORMATO = FMT(Y.FORMATO,"R&0#8")
    END ELSE
        IN.FORMATO = FMT(Y.FORMATO,"R&0#4")
    END

RETURN
**********
END

