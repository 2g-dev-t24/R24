* @ValidationCode : MjoxOTU2NzA4NzgxOkNwMTI1MjoxNzYzNDc0MTI3MzE3Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Nov 2025 10:55:27
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
SUBROUTINE ABC.2BR.EXTRAE.BOVEDA

*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Security
    $USING AbcTable
    $USING EB.Display

    GOSUB INICIALIZA
    GOSUB GENERABOVEDA

    TODAY           = EB.SystemTables.getToday()
    EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.FechaSolicitud, TODAY)
    Y.FECHA.HORA    = TIMEDATE()
    Y.HORA          = Y.FECHA.HORA[1,8]
    EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.HoraSolicitud, Y.HORA)
    
RETURN
***********
INICIALIZA:
***********
    F.TELLER.ID = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    F.USER = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER)

RETURN
*************
GENERABOVEDA:
*************
    Y.MSG = ""
    
    Y.OPERADOR  = EB.SystemTables.getOperator()
    EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.UsrSolicita, Y.OPERADOR)
    Y.REG.USER  = ''
    EB.DataAccess.FRead(FN.USER, Y.OPERADOR, Y.REG.USER, F.USER, ERR.USR)
    IF (Y.REG.USER) THEN
        Y.SUCURSAL = Y.REG.USER<EB.Security.User.UseDepartmentCode>
        Y.SUCURSAL = Y.SUCURSAL[1,5]
        SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH DEPT.CODE LIKE ":DQUOTE(SQUOTE(Y.SUCURSAL):"...")
        SELECT.CMD := " AND WITH USER EQ ''"
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.BVD = YLD.NO
        Y.ID.BVD = YLD.ID<Y.NUM.BVD>
        IF (Y.ID.BVD) THEN
            EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.Solicitante, Y.ID.BVD)
        END
    END

    EB.Display.RebuildScreen()

RETURN
**********
END




