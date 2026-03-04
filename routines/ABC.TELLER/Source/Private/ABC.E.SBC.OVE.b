* @ValidationCode : MjoxOTUzMzY0NTk2OkNwMTI1MjoxNzY2NDE0MzQ3MjY5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Dec 2025 11:39:07
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
SUBROUTINE ABC.E.SBC.OVE
*----------------------------------------------------------------------------

    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.Reports
*--------------------------
* Main Program Loop
*--------------------------
    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN
*---------------
PROCESS:
*---------------
    EB.DataAccess.FRead(FN.TELLER, YTELLER.ID, R.TELLER, FV.TELLER, YF.ERROR)
    IF NOT(R.TELLER) THEN
        RETURN
    END
    YOVERRIDE.1 = FIELD(R.TELLER<TT.Contract.Teller.TeOverride>,@SM,1)
    YOVERRIDE.2 = FIELD(R.TELLER<TT.Contract.Teller.TeOverride>,@SM,2)
    YOVERRIDE.3 = FIELD(R.TELLER<TT.Contract.Teller.TeOverride>,@SM,3)
    IF YOVERRIDE.2 = "EXC5" THEN
        O.DATA = YOVERRIDE.3
        EB.Reports.setOData(O.DATA)
    END
    
RETURN
*---------------
INITIALIZE:
*---------------
    YTELLER.ID = EB.Reports.getOData()
    FN.TELLER = "F.TELLER"
    FV.TELLER = ""
    EB.DataAccess.Opf(FN.TELLER,FV.TELLER)
    EB.Reports.setOData("")

RETURN
*---------------
END

