* @ValidationCode : MjoxNTY5MzMxMjkyOkNwMTI1MjoxNzYxNTc0NDcwMzg0Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Oct 2025 11:14:30
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
*=======================================================================
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.FEC.APP.PAGO.TC(Y.DT)
*=======================================================================
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.API
    $USING AbcTeller
*=======================================================================
    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN
*=======================================================================
INITIALIZE:
*=======================================================================
    Y.YEAR   = Y.DT[1,2]      ;* Year
    Y.MM     = Y.DT[3,2]      ;* Month
    Y.DAY    = Y.DT[5,2]      ;* Day
    Y.HOUR   = Y.DT[7,2]      ;* Hour
    Y.MINUTE = Y.DT[9,2]      ;* Minute
    Y.NARRATIVE = TT.Contract.Teller.TeNarrativeOne
    Y.NARRATIVE = Y.NARRATIVE[1,6]   ;* Narrative
    Y.NEXT.DATE = ''

    Y.16 = 16       ;* 16:00 Hours

* First Digits of Banco Amigo Card's
    Y.VISA.445016   = '445016'
    Y.VISA.445017   = '445017'
    Y.MASTER.542861 = '542861'
 
RETURN
*=======================================================================
PROCESS:
*=======================================================================
    Y.HOUR   = FMT(Y.HOUR,"RZ")
    Y.MINUTE = FMT(Y.MINUTE,"RZ")

    IF (Y.NARRATIVE NE Y.VISA.445016) AND (Y.NARRATIVE NE Y.VISA.445017) AND (Y.NARRATIVE NE Y.MASTER.542861) THEN
        IF Y.HOUR LE Y.16 THEN
            IF Y.HOUR EQ Y.16 AND Y.MINUTE GT 0 THEN
                Y.NEXT.DATE = "20":Y.YEAR:Y.MM:Y.DAY
                EB.API.Cdt('',Y.NEXT.DATE,'2W')
            END ELSE
                Y.NEXT.DATE = "20":Y.YEAR:Y.MM:Y.DAY
                EB.API.Cdt('',Y.NEXT.DATE,'1W')
            END
        END ELSE
            Y.NEXT.DATE = "20":Y.YEAR:Y.MM:Y.DAY
            EB.API.Cdt('',Y.NEXT.DATE,'2W')
        END
        Y.YEAR = Y.NEXT.DATE[3,2]
        Y.MM = Y.NEXT.DATE[5,2]
        Y.DAY = Y.NEXT.DATE[7,2]
    END

*    Y.DT = "Fecha de Aplicacion : ":Y.YEAR:"/":Y.MM:"/":Y.DAY
    Y.DT = "Fecha de Aplicacion : ":Y.DAY:"/":Y.MM:"/":Y.YEAR

RETURN
*=======================================================================
END
