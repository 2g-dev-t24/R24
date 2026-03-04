* @ValidationCode : MjoxMDA2ODA2MTQ3OkNwMTI1MjoxNzY2NDE1NDQxMDIxOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Dec 2025 11:57:21
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

SUBROUTINE ABC.E.TRAE.CAJERO(ENQ.PARAM)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Updates
    $USING EB.Security
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    FN.USER = 'F.USER'
    FV.USER = ''
    EB.DataAccess.Opf(FN.USER,FV.USER)

    FN.TI  = 'F.TELLER.ID'
    F.TI   = ''
    EB.DataAccess.Opf(FN.TI,F.TI)

    SELECT.CMD      = ''
    TI.SELECT.LIST  = ''
    TI.REC          = ''

    YR.OPERATOR = EB.SystemTables.getOperator()
    R.USER      = EB.SystemTables.getRUser()
    Y.DEPT      = R.USER<EB.Security.User.UseDepartmentCode>
    Y.PREFIJO   = Y.DEPT[1,1]

    CRT YR.OPERATOR

    IF Y.PREFIJO EQ 1 THEN
        SELECT.CMD = "SELECT ":FN.TI:" WITH USER EQ ":DQUOTE(YR.OPERATOR)  ; * ITSS - ANJALI - Added DQUOTE
        EB.DataAccess.Readlist(SELECT.CMD,TI.SELECT.LIST,'',NO.OF.REC,GRL.ERR)
        CRT NO.OF.REC
        CRT TI.SELECT.LIST
*   IND = 1
        IF NO.OF.REC NE '0' THEN
            FOR IND = 1 TO NO.OF.REC
                EB.DataAccess.FRead(FN.TI,TI.SELECT.LIST<IND>,TI.REC,F.TI,GRL.ERR)
                Y.TELLER.ID = TI.SELECT.LIST<IND>
                CRT Y.TELLER.ID
            NEXT IND

            ENQ.PARAM<2,1> = 'TELLER.ID'
            ENQ.PARAM<3,1> = 'EQ'
            ENQ.PARAM<4,1> = Y.TELLER.ID

        END ELSE

            ENQ.PARAM<2,1> = 'TELLER.ID'
            ENQ.PARAM<3,1> = 'EQ'
            ENQ.PARAM<4.1> = '0000'

        END
    END

RETURN
*-----------------------------------------------------------------------------
END
