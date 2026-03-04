* @ValidationCode : MjotMTcwMjE0MjE4NDpDcDEyNTI6MTc1NzY0MTE2ODc5MjpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Sep 2025 22:39:28
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

SUBROUTINE ABC.VAL.PLAZO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING AbcSpei
*-----------------------------------------------------------------------------
    Y.PLAZO     = ''
    Y.LONG      = ' '
    COMI        = EB.SystemTables.getComi()
    Y.FECHA.VEN = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.MatDate)
    
    IF COMI EQ '' AND Y.FECHA.VEN EQ '' THEN
        ETEXT = "SE DEBE CAPTURAR PLAZO "
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
        IF COMI LE 0 OR COMI EQ '0D' AND  Y.FECHA.VEN EQ '' THEN
            ETEXT = "EL PLAZO DEBE SER MAYOR A 0D"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END ELSE
            Y.PLAZO = COMI
            Y.LONG  = LEN(Y.PLAZO)
            FOR I.LON=1 TO Y.LONG
                IF NUM(COMI) THEN ELSE
                    IF NUM(COMI[I.LON,1]) THEN ELSE
                        IF COMI[I.LON,1] NE 'D' THEN
                            ETEXT = "INGRESE PLAZO VALIDO: ":I.LON
                            EB.SystemTables.setEtext(ETEXT)
                            EB.ErrorProcessing.StoreEndError()
                        END
                    END
                END

            NEXT I.LON

        END
    END

RETURN
*-----------------------------------------------------------------------------
END
