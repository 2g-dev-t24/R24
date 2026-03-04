* @ValidationCode : MjotNDY3MDk0NDM3OkNwMTI1MjoxNzYyMjIxMTYzNzc1Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Nov 2025 22:52:43
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
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.2BR.EXTRAE.DEFAULT

******************************************************************
*
*
******************************************************************
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.Display
    $USING AC.AccountOpening
    $USING TT.Contract
    $USING EB.Security
    $USING TT.Config
**************MAIN PROCESS
    GOSUB INICIALIZA

    GOSUB GENERABOVEDA

RETURN
**************
INICIALIZA:
**************
    F.TELLER.ID = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    F.USER = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER )

    AF = EB.SystemTables.getAf()
    Y.OPERADOR = EB.SystemTables.getOperator()
    
RETURN
**************
GENERABOVEDA:
**************
    EB.DataAccess.FRead(FN.USER, Y.OPERADOR, R.USER, F.USER, ERR.USER)
    IF R.USER THEN
        Y.SUCURSAL = R.USER<EB.Security.User.UseDepartmentCode>
        Y.SUCURSAL = Y.SUCURSAL[1,5]
        SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH DEPT.CODE EQ ":DQUOTE(Y.SUCURSAL)
        SELECT.CMD := " AND WITH USER EQ ''"
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.BVD   = YLD.NO
        Y.ID.BVD    = YLD.ID

        Y.BOVEDA = Y.ID.BVD<Y.NUM.BVD>

        SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH USER EQ ":DQUOTE(Y.OPERADOR)
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.BVD   = YLD.NO
        Y.ID.BVD    = YLD.ID

        Y.CAJERO = Y.ID.BVD<Y.NUM.BVD>
    END

    TT.TELLER1 = TT.Contract.Teller.TeTellerIdOne
    IF AF EQ TT.TELLER1 THEN
        EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdOne,Y.BOVEDA)
        EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdTwo,Y.CAJERO)
    END
    
    TT.TELLER2 = TT.Contract.Teller.TeTellerIdTwo
    IF AF EQ TT.TELLER2 THEN
        EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdTwo,Y.BOVEDA)
        EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdOne,Y.CAJERO)
    END
    
    tmp     = EB.SystemTables.getT(TT.Contract.Teller.TeTellerIdOne)
    tmp<3>  = "NOINPUT"
    EB.SystemTables.setT(TT.Contract.Teller.TeTellerIdOne, tmp)
    
    tmp     = EB.SystemTables.getT(TT.Contract.Teller.TeTellerIdTwo)
    tmp<3>  = "NOINPUT"
    EB.SystemTables.setT(TT.Contract.Teller.TeTellerIdTwo, tmp)

RETURN
**************
END
