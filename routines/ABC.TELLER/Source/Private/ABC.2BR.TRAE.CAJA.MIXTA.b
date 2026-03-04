* @ValidationCode : MjoyMTM2NDc1ODg4OkNwMTI1MjoxNzYzNjQ1ODc0OTMwOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Nov 2025 10:37:54
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
SUBROUTINE ABC.2BR.TRAE.CAJA.MIXTA(ENQ.PARAM)


    $USING EB.Security
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables


    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN

*--------------
INITIALIZE:
*--------------
    F.TELLER.ID  = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID, F.TELLER.ID)

    F.USER  = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER, F.USER)

    SELECT.CMD = "SELECT ":FN.TELLER.ID

RETURN
*--------------
PROCESS:
*--------------
    R.USER = EB.SystemTables.getRUser()
    Y.DEPT = R.USER<EB.Security.User.UseDepartmentCode>
    Y.USER = EB.SystemTables.getOperator()

    Y.SUCURSAL = Y.DEPT[1,5]
    Y.PREFIJO  = Y.DEPT[1,1]
    Y.CONSULTA = ENQ.PARAM<4,1>


*... busca usuario dado de alta en TELLER.ID
    SELECT.CMD := " WITH DEPT.CODE LIKE ":DQUOTE(SQUOTE(Y.SUCURSAL):"..."):" AND USER EQ ":DQUOTE(Y.USER)
    EB.DataAccess.Readlist(SELECT.CMD, YLD.ID, '', YLD.NO, '')

    Y.TELLER.ID = YLD.ID<YLD.NO>
*    Y.TELLER.ID = TRIM(YLD.ID, "0", "L")

    IF Y.PREFIJO EQ 1 THEN
        IF Y.CONSULTA EQ Y.TELLER.ID THEN
            ENQ.PARAM<2,1>= 'TELLER.ID'
            ENQ.PARAM<3,1>= 'EQ'
            ENQ.PARAM<4,1>= Y.TELLER.ID
        END ELSE
            ENQ.PARAM<2,1>= 'TELLER.ID'
            ENQ.PARAM<3,1>= 'EQ'
            ENQ.PARAM<4,1>= '0000'
        END
    END

RETURN
END