* @ValidationCode : MjoxMTEyMjY4NzU4OkNwMTI1MjoxNzU4NzYzODc2OTI1Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Sep 2025 22:31:16
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

SUBROUTINE ABC.2BR.TOT1.TOT2
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing

    $USING TT.Contract
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.APP = "TELLER"
    Y.FLD = "GRAN.TOTAL":@VM:"GRAN.TOTAL2"
    Y.POS.FLD = ''
    EB.Updates.MultiGetLocRef(Y.APP, Y.FLD, Y.POS.FLD)
    
    Y.POS.GRAN.TOTAL    = Y.POS.FLD<1,1>
    Y.POS.GRAN.TOTAL2   = Y.POS.FLD<1,2>

    TT.TE.LOCAL.REF     = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
    TOTAL1 = TT.TE.LOCAL.REF<1,Y.POS.GRAN.TOTAL>
    TOTAL2 = TT.TE.LOCAL.REF<1,Y.POS.GRAN.TOTAL2>
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF TOTAL1 NE TOTAL2 THEN
        TEXT = "Por favor, cierra la operacion y vuelve intentarla"
        EB.SystemTables.setText(TEXT)
        EB.OverrideProcessing.Ove()
        E ="Entrante diferente de Saliente"
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN
*-----------------------------------------------------------------------------
END