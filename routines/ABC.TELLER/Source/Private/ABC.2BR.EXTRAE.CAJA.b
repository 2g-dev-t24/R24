* @ValidationCode : MjotMTkxMzMzMzI4NDpDcDEyNTI6MTc2MjQ4MzM2NTk4NzpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Nov 2025 23:42:45
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
SUBROUTINE ABC.2BR.EXTRAE.CAJA

    $USING EB.DataAccess
    $USING TT.Contract
    $USING EB.Security
    $USING EB.SystemTables
******************************************************************
*  RUTINA PARA EXTEAER EL NUMERO DE LA CAJA
******************************************************************
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

RETURN
**************
GENERABOVEDA:
**************
    Y.OPERADOR = EB.SystemTables.getOperator()

    Y.REG.USER  = ''
    Y.REG.USER  = EB.Security.User.Read(Y.OPERADOR, ERR.USR)
    
    IF (Y.REG.USER) THEN
        Y.SUCURSAL = Y.REG.USER<EB.Security.User.UseDepartmentCode>
        Y.SUCURSAL = Y.SUCURSAL[1,5]
        SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH DEPT.CODE LK " : DQUOTE(SQUOTE(Y.SUCURSAL):"...")
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

    EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdOne,Y.CAJERO)

RETURN
**************
END
