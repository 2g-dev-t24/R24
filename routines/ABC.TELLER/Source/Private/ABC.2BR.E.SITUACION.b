* @ValidationCode : MjotMjA5OTQ3ODM3MDpDcDEyNTI6MTc2MjkxMzI5MjA2MjpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Nov 2025 23:08:12
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

SUBROUTINE ABC.2BR.E.SITUACION
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Updates
    $USING EB.Reports
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    O.DATA  = EB.Reports.getOData()
    Y.DESC  = ''

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.CVE = O.DATA
    BEGIN CASE
        CASE Y.CVE EQ "S"
            Y.DESC = "SOLICITUD"
        CASE Y.CVE EQ "T"
            Y.DESC = "TRAMITADA"
        CASE Y.CVE EQ "F"
            Y.DESC = "RECIBIDA"
        CASE Y.CVE EQ "R"
            Y.DESC = "RECHAZADA"
        CASE Y.CVE EQ "P"
            Y.DESC = "ENVIADA"
        CASE Y.CVE EQ "A"
            Y.DESC = "AUTORIZADA"
        CASE Y.CVE EQ "X"
            Y.DESC = "RECHAZO RECEPCION"
    END CASE
    
    EB.Reports.setOData(Y.DESC)

RETURN
*-----------------------------------------------------------------------------
END
