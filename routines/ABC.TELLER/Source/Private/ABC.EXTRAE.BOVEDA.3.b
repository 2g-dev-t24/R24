* @ValidationCode : MjotODA1NDk3NTk6Q3AxMjUyOjE3NjM0Mjk1NzQ3MDQ6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Nov 2025 22:32:54
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

SUBROUTINE ABC.EXTRAE.BOVEDA.3

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

    F.TELLER = ""
    FN.TELLER = "F.TELLER"
    EB.DataAccess.Opf(FN.TELLER,F.TELLER)

RETURN
*************
GENERABOVEDA:
************

    Y.MSG       = ""
    Y.OPERADOR  = EB.SystemTables.getOperator()
    Y.REG.USER  = ''
    Y.REG.USER  = EB.DataAccess.FRead(FN.USER, Y.OPERADOR, Y.REG.USER, F.USER, USR.ERR)
    IF (Y.REG.USER) THEN
        Y.SUCURSAL = Y.REG.USER<EB.Security.User.UseDepartmentCode>[1,5]
        SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH DEPT.CODE LIKE ":DQUOTE(SQUOTE(Y.SUCURSAL):"...")
        SELECT.CMD := " AND WITH USER EQ ''"
        YLD.ID  = ''
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.BVD = YLD.NO
        Y.ID.BVD = YLD.ID
        
        IF (YLD.ID) THEN
            Y.ACCOUNT.TWO = "MXN10000":Y.ID.BVD<Y.NUM.BVD>
        END ELSE
            Y.ACCOUNT.TWO = ''
        END
        EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountTwo,Y.ACCOUNT.TWO)
    END

    EB.Display.RebuildScreen()

RETURN
**********
END

