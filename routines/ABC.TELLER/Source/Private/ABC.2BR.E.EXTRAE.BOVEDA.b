* @ValidationCode : MjotMzQyNTg5NTpDcDEyNTI6MTc2MjkxNzk4NjAzNDpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Nov 2025 00:26:26
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
SUBROUTINE ABC.2BR.E.EXTRAE.BOVEDA(ENQ.PARAM)

******************************************************************

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING TT.Contract
    $USING EB.Security
**************MAIN PROCESS

    F.TELLER.ID = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    F.USER = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER )

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
        CLAVE.SOLICITANTE = Y.ID.BVD<Y.NUM.BVD>
    END

    ENQ.PARAM<2,1> = 'SOLICITANTE'
    ENQ.PARAM<3,1> = 'EQ'
    ENQ.PARAM<4,1,1> = CLAVE.SOLICITANTE

RETURN

END
