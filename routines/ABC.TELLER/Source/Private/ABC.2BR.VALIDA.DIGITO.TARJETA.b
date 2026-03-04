* @ValidationCode : MjotNzU4MDM3NTkyOkNwMTI1MjoxNzYxNTczOTY4NDc4Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Oct 2025 11:06:08
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
* <Rating>-49</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.2BR.VALIDA.DIGITO.TARJETA
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------

    GOSUB INITIALIZE

    GOSUB PROCESS

RETURN
************************
INITIALIZE:
************************
    YARRAY      = ""

    Y.TARJETA   = EB.SystemTables.getComi()
    Y.LEN       = LEN(Y.TARJETA)
    YCONST.SEP  = "____"
    YSEP        = "_"
    YTOTAL      = ""
    MENSAJE     = ""
    YLIST       = ""
    COMI        = EB.SystemTables.getComi()

RETURN
************************
PROCESS:
************************

    IF COMI NE '' THEN
        IF NUM(Y.TARJETA) THEN
            IF NOT(Y.LEN EQ '13' OR Y.LEN EQ '15' OR Y.LEN EQ '16') THEN
                ETEXT = "Longitud de tarjeta no vda"
                EB.SystemTables.setE(ETEXT)
                EB.ErrorProcessing.Err()
                EB.SystemTables.setComi('')
                RETURN
            END ELSE
                GOSUB VALIDATION
            END
        END ELSE
            ETEXT = "La narrativa debe ser nmerica"
            EB.SystemTables.setE(ETEXT)
            EB.ErrorProcessing.Err()
            EB.SystemTables.setComi('')
            RETURN
        END
    END

RETURN
************************
VALIDATION:
************************
    FOR YIND =1 TO Y.LEN
        YVALOR  = Y.TARJETA[YIND,1]
        YVAL2   = YVALOR*2
        YRES    = YIND - (YIND/2)
        IF LEN(YRES) EQ 1 THEN
            YTOTAL += YVALOR
        END ELSE
            IF YVAL2 GT 9 THEN
                YVAL2 = YVAL2-9
            END
            YTOTAL += YVAL2
        END
    NEXT YIND

    YLIST = YTOTAL
    YRESULTADO = MOD(YLIST, 10)
    IF (YRESULTADO EQ 0) AND (YLIST LT 150) THEN
        MENSAJE = "NO. TARJETA ACEPTADA"
    END ELSE
        ETEXT = "No. de Tarjeta no vdo"
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.Err()
        EB.SystemTables.setComi('')
        RETURN
    END

RETURN
**********
END
