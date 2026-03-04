* @ValidationCode : MjotMTU4ODM0NDgyMzpDcDEyNTI6MTc2MzA4ODM5NDk0MzpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Nov 2025 23:46:34
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

SUBROUTINE ABC.2BR.EXTRAE.BOVEDA.2

*-----------------------------------------------------------------------------

    $USING EB.Security
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.Display
    $USING EB.SystemTables

    GOSUB INICIALIZA
    GOSUB GENERABOVEDA

RETURN
***********
INICIALIZA:
***********
    F.TELLER.ID = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    F.USER = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER )

RETURN
*************
GENERABOVEDA:
************
    Y.ACCOUNT.ONE = ""
    Y.MSG       = ""
    Y.OPERADOR  = EB.SystemTables.getOperator()
    Y.REG.USER  = ''
    EB.DataAccess.FRead(FN.USER, Y.OPERADOR, Y.REG.USER, F.USER, ERR.USR)
    IF (Y.REG.USER) THEN
        Y.SUCURSAL = Y.REG.USER<EB.Security.User.UseDepartmentCode>
        Y.SUCURSAL = Y.SUCURSAL[1,5]
        SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH DEPT.CODE LIKE ":DQUOTE(SQUOTE(Y.SUCURSAL):"...")
        SELECT.CMD := " AND WITH USER EQ ''"
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.BVD = YLD.NO
        Y.ID.BVD = YLD.ID
        IF (Y.ID.BVD) THEN
            Y.ACCOUNT.ONE = "MXN10000":Y.ID.BVD<Y.NUM.BVD>
            EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountOne,Y.ACCOUNT.ONE)
        END ELSE
            Y.ACCOUNT.ONE = ""
            EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountOne,Y.ACCOUNT.ONE)
        END
    END

    EB.Display.RebuildScreen()

RETURN
**********
END
