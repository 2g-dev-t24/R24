* @ValidationCode : MjotMTM3MDk5OTY0MzpDcDEyNTI6MTc1NzY0MDkzNjQwNzpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Sep 2025 22:35:36
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
$PACKAGE AbcAccount

SUBROUTINE ABC.FMT.AMT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    Y.COMI = EB.SystemTables.getComi()
    IF Y.COMI EQ '' THEN
        ETEXT = "EL MONTO NO TIENE DATO"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
        IF LEN(FIELD(Y.COMI,'.',2)) GT 2 THEN
            ETEXT = "EL MONTO CONTIENE MAS DE 2 DECIMALES"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

RETURN
*-----------------------------------------------------------------------------
END

