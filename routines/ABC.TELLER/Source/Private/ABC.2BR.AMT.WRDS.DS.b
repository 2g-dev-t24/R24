* @ValidationCode : MjotMTcxNzUwMzkwOTpDcDEyNTI6MTc2MzY1MDExNTY1MjpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Nov 2025 11:48:35
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
$PACKAGE AbcTeller

SUBROUTINE ABC.2BR.AMT.WRDS.DS(YAMOUNT)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Updates
    $USING ABC.BP
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    CONVERT "," TO "" IN YAMOUNT
    YAMOUNT.WRDS = ""
    YERR.MSG     = ""
    YSPACE       = ""

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    ABC.BP.VpmCantidadLetra(YAMOUNT, YAMOUNT.WRDS, '', '', YERR.MSG)
    
    YAMOUNT.WRDS.SLIP = ""
    YAMOUNT.WRDS = RAISE(YAMOUNT.WRDS)
    YNUM.LINES = DCOUNT(YAMOUNT.WRDS,FM)
    FOR YIND = 1 TO YNUM.LINES
        YAMOUNT.SPACE = 76 - LEN(YAMOUNT.WRDS<YIND>)
        YSPACE        = STR(" ",YAMOUNT.SPACE)
        IF YIND = 1 THEN
            YFIRST = "("
        END ELSE
            YFIRST = ""
        END
        IF YIND = YNUM.LINES THEN
            YLAST = ")"
        END ELSE
            YLAST = ""
        END
        YAMOUNT.WRDS.SLIP<-1> = YFIRST:YAMOUNT.WRDS<YIND>:YLAST:YSPACE:YFIRST:YAMOUNT.WRDS<YIND>:YLAST
    NEXT YIND
    CONVERT @FM TO CHAR(13) IN YAMOUNT.WRDS.SLIP

    YAMOUNT = YAMOUNT.WRDS.SLIP

RETURN
*-----------------------------------------------------------------------------
END
