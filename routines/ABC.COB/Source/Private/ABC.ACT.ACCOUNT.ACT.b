* @ValidationCode : MjoxOTQ4NDg3NjM5OkNwMTI1MjoxNzYwMzI2Nzk5OTk5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Oct 2025 00:39:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE AbcCob
SUBROUTINE ABC.ACT.ACCOUNT.ACT(Y.ACCOUNT.ID)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* Nombre de Programa :  ABC.ACT.ACCOUNT.ACT
* Objetivo           :  Actualiza la tabla ACCOUNT.ACT para las cuentas que no se han actualizado porque se hizo el cambio de categor�a durante el COB
* Requerimiento      :  AR-10328 T24 - Optimizaci�n Proceso Actualiza Cuenta Remunerada
* Desarrollador      :  CAST - F&G Solutions
* Compania           :  ABC Capital Banco
* Fecha Creacion     :  07/10/2024
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.API
    $USING AC.AccountOpening
    
    GOSUB PROCESS

RETURN

*===============================================================================
PROCESS:
*===============================================================================
    FN.ACCOUNT = AbcCob.getFnAccountA()
    F.ACCOUNT = AbcCob.getFAccountA()
    FN.ACCOUNT.ACT = AbcCob.getFnAccountAct()
    FN.ACCOUNT.ACT = AbcCob.getFAccountAct()
    TODAY   = EB.SystemTables.getToday()

    R.ACCOUNT = ""
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ACCOUNT.ID, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACCOUNT)
    IF R.ACCOUNT THEN
        Y.CATEGORY =  R.ACCOUNT<AC.AccountOpening.Account.Category>
        Y.OPEN.CATEGORY = R.ACCOUNT<AC.AccountOpening.Account.OpenCategory>
        IF (Y.CATEGORY EQ '6006' AND Y.OPEN.CATEGORY NE '6006') OR (Y.CATEGORY EQ '6007' AND Y.OPEN.CATEGORY NE '6007') THEN
            Y.ACCOUNT.CURR.NO = R.ACCOUNT<AC.AccountOpening.Account.CurrNo>
            Y.ACCOUNT.ULT.HIST = Y.ACCOUNT.CURR.NO - 1
            Y.ACCOUNT.ACCT.ID = Y.ACCOUNT.ID:";":Y.ACCOUNT.ULT.HIST
            R.ACCOUNT.ACT = ""
            EB.DataAccess.FRead(FN.ACCOUNT.ACT, Y.ACCOUNT.ACCT.ID, R.ACCOUNT.ACT, F.ACCOUNT.ACT, Y.ERR.ACCOUNT.ACCT)
            IF R.ACCOUNT.ACT EQ "" THEN
                R.ACCOUNT.ACT = TODAY
                EB.DataAccess.FWrite(FN.ACCOUNT.ACT, Y.ACCOUNT.ACCT.ID, R.ACCOUNT.ACT)
*               DISPLAY "ACTUALIZA     ---->": Y.ACCOUNT.ACCT.ID,R.ACCOUNT.ACT
            END
        END
    END

RETURN
*===============================================================================

END

