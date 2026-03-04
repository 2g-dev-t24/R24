* @ValidationCode : MjotMTIyNDY0MjU5OkNwMTI1MjoxNzYyNDgzMjg4Njk3Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Nov 2025 23:41:28
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

$PACKAGE AbcTable

SUBROUTINE ABC.2BR.BOVEDAS.ID
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING AbcTable
    $USING EB.Updates
    $USING EB.Security
    $USING EB.ErrorProcessing
    $USING EB.TransactionControl
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    F.ABC.2BR.BOVEDAS   = ""
    FN.ABC.2BR.BOVEDAS  = "F.ABC.2BR.BOVEDAS"
    EB.DataAccess.Opf(FN.ABC.2BR.BOVEDAS,F.ABC.2BR.BOVEDAS)

    F.TELLER.ID = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    Y.MSG       = ""
    Y.OPERADOR  = EB.SystemTables.getOperator()
    Y.COMI      = EB.SystemTables.getComi()
    YLD.ID      = ''
    YLD.NO      = ''
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    R.BOVEDAS   = ''
    EB.DataAccess.FRead(FN.ABC.2BR.BOVEDAS, Y.COMI, R.BOVEDAS, F.ABC.2BR.BOVEDAS, ERR.BOV)
    IF (R.BOVEDAS) THEN
        RETURN
    END
    
	Y.REG.USER  = ''
    Y.REG.USER  = EB.Security.User.Read(Y.OPERADOR, ERR.USR)
    
    IF (Y.REG.USER) THEN
        Y.SUCURSAL = Y.REG.USER<EB.Security.User.UseDepartmentCode>
        Y.SUCURSAL = Y.SUCURSAL[1,5]
        SELECT.CMD = "SELECT ":FN.TELLER.ID:" WITH DEPT.CODE EQ ":DQUOTE(Y.SUCURSAL)
        SELECT.CMD := " AND WITH USER EQ ''"
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.BVD   = YLD.NO
        Y.ID.BVD    = YLD.ID
        IF Y.NUM.BVD EQ 0 THEN
            Y.MSG = "SUCURSAL ":Y.SUCURSAL:", NO TIENE BOVEDA DEFINIDA"
        END
        IF Y.NUM.BVD GT 1 THEN
            Y.MSG = "SUCURSAL ":Y.SUCURSAL:", TIENE M�S DE UNA BOVEDA DEFINIDA"
        END

        Y.LLAVE.SOL = "BV":Y.ID.BVD<1>
    END

    IF Y.MSG NE "" THEN
        EB.SystemTables.setE(Y.MSG)
        EB.ErrorProcessing.StoreEndError()
    END

    EB.TransactionControl.FormatId(Y.LLAVE.SOL)

RETURN
*-----------------------------------------------------------------------------
END