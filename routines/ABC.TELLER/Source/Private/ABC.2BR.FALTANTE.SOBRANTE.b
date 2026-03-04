* @ValidationCode : MjoyMDcxMjkxNDkzOkNwMTI1MjoxNzY0NjgzNzc0NDM1Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Dec 2025 10:56:14
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
*-----------------------------------------------------------------
* <Rating>-24</Rating>
*-----------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.2BR.FALTANTE.SOBRANTE

******************************************************************
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.Display
    $USING TT.Contract
    $USING EB.Security
    $USING TT.Config
*****************
    MESSAGE = EB.SystemTables.getMessage()
    IF MESSAGE NE "VAL" THEN
        GOSUB INITIALISE
        GOSUB PROCESS
    END

RETURN
*****************
INITIALISE:
*****************
    F.TELLER.PARAMETER = ''
    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    EB.DataAccess.Opf(FN.TELLER.PARAMETER,F.TELLER.PARAMETER)

    F.TELLER.ID = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    F.USER = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER)

RETURN

*********************
PROCESS:
*********************
    Y.OPERADOR = EB.SystemTables.getRUser()
    EB.DataAccess.FRead(FN.USER, Y.OPERADOR, R.USER, F.USER, ERR.USER)
    IF R.USER THEN
        Y.SUCURSAL = R.USER<EB.Security.User.UseDepartmentCode>
        Y.SUCURSAL = Y.SUCURSAL[1,5]
        SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH DEPT.CODE LIKE ":DQUOTE(SQUOTE(Y.SUCURSAL):"...")  ; * ITSS - NYADAV - Added DQUOTE / SQUOTE
        SELECT.CMD := " AND WITH USER EQ ''"
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.BVD = YLD.NO
        Y.ID.BVD = YLD.ID
        Y.BOVEDA = Y.ID.BVD<Y.NUM.BVD>
    END
    
    Y.OPERADOR = EB.SystemTables.getOperator()
    Y.REG.USER = ''
    EB.DataAccess.FRead(FN.USER, Y.OPERADOR, Y.REG.USER, F.USER, Y.ERR.USER)
    IF Y.REG.USER THEN
        Y.SUCURSAL = Y.REG.USER<EB.Security.User.UseDepartmentCode>
        Y.SUCURSAL = Y.SUCURSAL[1,5]
        SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH DEPT.CODE LIKE ":DQUOTE(SQUOTE(Y.SUCURSAL):"...")
        SELECT.CMD := " AND WITH USER EQ ''"
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.BVD = YLD.NO
        Y.ID.BVD = YLD.ID
        Y.BOVEDA = Y.ID.BVD<Y.NUM.BVD>
    END

    Y.TXN    = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)
    Y.MONEDA = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)
    Y.ID.TELLER = TT.Contract.getTid()

*******************************************************************************************************************
    Y.ID.TT.PARAMETER = "MX0010001"
    EB.DataAccess.FRead(FN.TELLER.PARAMETER,Y.ID.TT.PARAMETER,R.TELLER.PARAMETER,F.TELLER.PARAMETER,ERR.TELLER.PARAMETER)

    Y.OVER.CATEGORY  = R.TELLER.PARAMETER<TT.Config.TellerParameter.ParOverCategory>
    Y.SHORT.CATEGORY = R.TELLER.PARAMETER<TT.Config.TellerParameter.ParShortCategory>

    TEXT = "Y.OVER.CATEGORY " : Y.OVER.CATEGORY
    EB.SystemTables.setText(TEXT)
    EB.Display.Rem()

    TEXT = "Y.SHORT.CATEGORY " : Y.SHORT.CATEGORY
    EB.SystemTables.setText(TEXT)
    EB.Display.Rem()
    
    IF Y.MONEDA EQ '' THEN
        RETURN
	END
    
    IF Y.TXN EQ 2 THEN
        Y.AC.UNO = Y.MONEDA:Y.SHORT.CATEGORY:Y.ID.TELLER
        EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountOne, Y.AC.UNO)
        Y.AC.DOS = Y.MONEDA:"10000":Y.BOVEDA
        EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountTwo, Y.AC.DOS)
    END ELSE
        IF Y.TXN EQ 3 THEN
            Y.AC.UNO = Y.MONEDA:"10000":Y.ID.TELLER
            EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountOne, Y.AC.UNO)
            Y.AC.DOS = Y.MONEDA:Y.OVER.CATEGORY:Y.BOVEDA
            EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountTwo, Y.AC.DOS)
        END
    END
*******************************************************************************************************************
RETURN
END

