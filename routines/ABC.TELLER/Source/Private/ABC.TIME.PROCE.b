* @ValidationCode : MjotMTQxNTM4MTQxNTpDcDEyNTI6MTc2MTU3NTA4NDQ1NDpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Oct 2025 11:24:44
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
SUBROUTINE ABC.TIME.PROCE(Y.DT)
*=======================================================================
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Display
    $USING AbcTeller
    $USING EB.Utility
*=======================================================================
    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN
*=======================================================================
INITIALIZE:
*=======================================================================
    Y.DATE.TIME = Y.DT
    Y.YEAR = Y.DT[1,2]
    Y.MM   = Y.DT[3,2]
    Y.DAY  = Y.DT[5,2]
    
*    Y.DT = TODAY
*    Y.YEAR = Y.DT[3,2]
*    Y.MM   = Y.DT[5,2]
*    Y.DAY  = Y.DT[7,2]

    PTIME = Y.DATE.TIME[7,4]
*   FTIME = PTIME[1,2]:":":PTIME[3,4]
 
RETURN
*=======================================================================
PROCESS:
*=======================================================================


*    FTIME=OCONV(PTIME,"MTH")

*    EB.Utility.Timenow(PTIME) Metodo Privado
    PTIME = TIMEDATE()
    PTIME = PTIME[1,8]
    
*    Y.DT = "Fecha de Operacion: ":Y.DAY:"/":Y.MM:"/":Y.YEAR:" ":FTIME
    Y.DT = "Fecha de Operacion: ":Y.DAY:"/":Y.MM:"/":Y.YEAR:" ":PTIME

RETURN
*=======================================================================
END
