* @ValidationCode : MjotMTA5NTg1ODEyOkNwMTI1MjoxNzYzNjQ5NjE3NzAwOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Nov 2025 11:40:17
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
SUBROUTINE ABC.E.FT.ABC.CC.REV(R.DATA)
*===============================================================================
* Descripci�n:          Obtiene los ID de los FT para Traspasos entre Cuentas
*                       pendientes de autorizar y que pertenencen a la caja
*                       del usuario loggeado.
*===============================================================================

    $USING FT.Contract
    $USING EB.Security
    $USING EB.DataAccess
    $USING EB.SystemTables
*===============================================================================

    GOSUB INICIA
    GOSUB OBTIENE.USUARIO
    GOSUB PROCESA.TRANSFERENCIAS

RETURN
*******
INICIA:
*******
    FN.FUNDS.TRANSFER.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER.NAU = ''
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER.NAU, F.FUNDS.TRANSFER.NAU)

    FN.USER = 'F.USER'
    F.USER = ''
    EB.DataAccess.Opf(FN.USER,F.USER)

    Y.USUARIO = EB.SystemTables.getOperator()

RETURN
***********************
OBTIENE.USUARIO:
***********************
    EB.DataAccess.FRead(FN.USER,Y.USUARIO,R.USER,F.USER,ERROR.USER)
    IF R.USER THEN
        Y.DEPT.CODE = R.USER<EB.Security.User.UseDepartmentCode>[1,5]
    END

RETURN
***********************
PROCESA.TRANSFERENCIAS:
***********************
    SELECT.FT = '' ; FT.ID.LIST = '' ; FT.NO.SELECTED = ''
    SELECT.FT = "SELECT " : FN.FUNDS.TRANSFER.NAU : " WITH TRANSACTION.TYPE EQ 'AC' AND DEPT.CODE LIKE ":DQUOTE(SQUOTE(Y.DEPT.CODE):"..."): " BY @ID"

    EB.DataAccess.Readlist(SELECT.FT,FT.ID.LIST,'',FT.NO.SELECTED,'')

    IF FT.ID.LIST GT 0 THEN
        FOR I = 1 TO FT.NO.SELECTED
            FT.ID = ""
            FT.ID = FT.ID.LIST<I>
            EB.DataAccess.FRead(FN.FUNDS.TRANSFER.NAU,FT.ID,R.FT,F.FUNDS.TRANSFER.NAU,ERROR.FT)
            IF R.FT THEN
                R.DATA <-1> = FT.ID
            END
        NEXT I
    END ELSE
        R.DATA = ""
    END

RETURN
*******
END
