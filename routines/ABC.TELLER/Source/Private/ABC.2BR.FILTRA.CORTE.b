* @ValidationCode : MjotMTI3NzUzNTcwOkNwMTI1MjoxNzY2NDEzMjkxOTM5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Dec 2025 11:21:31
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
SUBROUTINE ABC.2BR.FILTRA.CORTE(ENQ.PARAM)

    $USING EB.Security
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    
    GOSUB PROCESS
RETURN

PROCESS:

* inicializa
    F.TELLER.ID     = ""
    FN.TELLER.ID    = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    F.USER  = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER)
    
    R.USER      = EB.SystemTables.getRUser()
    Y.DEPT      = R.USER<EB.Security.User.UseDepartmentCode>
    Y.SUCURSAL  = Y.DEPT[1,5]
    Y.PREFIJO   = Y.DEPT[1,1]
    Y.CONSULTA  = ENQ.PARAM<4,1>

* variables
    SELECT.CMD = "SELECT ":FN.TELLER.ID

    IF Y.PREFIJO EQ 1 THEN
        IF Y.CONSULTA EQ '' THEN
            SELECT.CMD :=" WITH DEPT.CODE EQ ":DQUOTE(Y.SUCURSAL):" AND USER EQ '' "
            SELECT.CMD :=" WITH DEPT.CODE LIKE ":DQUOTE(SQUOTE(Y.SUCURSAL):"..."):" AND @ID EQ ": DQUOTE(Y.CONSULTA)
        END

        EB.DataAccess.Readlist(SELECT.CMD, YLD.ID, '', YLD.NO, '')
        IF YLD.NO NE '0' THEN
            Y.CAJERO    = YLD.NO
            Y.IDCAJERO  = YLD.ID
            Y.PARAMETRO = Y.IDCAJERO<Y.CAJERO>

            ENQ.PARAM<2,1>= 'TELLER.ID'
            ENQ.PARAM<3,1>= 'EQ'
            ENQ.PARAM<4,1>= Y.PARAMETRO
        END ELSE
            ENQ.PARAM<2,1>= 'TELLER.ID'
            ENQ.PARAM<3,1>= 'EQ'
            ENQ.PARAM<4,1>= '0000'
        END

    END

RETURN
END
