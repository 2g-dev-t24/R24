* @ValidationCode : MjotMTk3NDk3MjYzNzpDcDEyNTI6MTc2NzM3MjcwMjUxODpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Jan 2026 13:51:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcTeller

SUBROUTINE ABC.2BR.VALIDA.BOVEDA.CAJERO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.Security
    $USING TT.Contract
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    F.USER = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER )

    F.TELLER.ID = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.OPERADOR = EB.SystemTables.getOperator()

    Y.CAJERO.DESTINO = EB.SystemTables.getComi()

    LOOP
    WHILE LEN(Y.CAJERO.DESTINO) LT 4
        Y.CAJERO.DESTINO = "0":Y.CAJERO.DESTINO
    REPEAT

    READ Y.REG.TELLER FROM F.TELLER.ID, Y.CAJERO.DESTINO THEN
        Y.USUARIO.DESTINO = Y.REG.TELLER<TT.Contract.TellerId.TidUser>
    END

    READ Y.REG.USER FROM F.USER, Y.USUARIO.DESTINO THEN
        Y.SUCURSAL.DESTINO = Y.REG.USER<EB.Security.User.UseDepartmentCode>
        Y.SUCURSAL.DESTINO = Y.SUCURSAL.DESTINO[1,5]
    END

    READ Y.REG.USER FROM F.USER, Y.OPERADOR THEN
        Y.SUCURSAL = Y.REG.USER<EB.Security.User.UseDepartmentCode>
        Y.SUCURSAL = Y.SUCURSAL[1,5]
    END

    IF Y.SUCURSAL NE Y.SUCURSAL.DESTINO THEN
        ETEXT = "CAJERO PERTENECE A OTRA SUCURSAL"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

    IF Y.USUARIO.DESTINO EQ Y.OPERADOR THEN
        ETEXT = "MISMO OPERADOR"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

RETURN
*-----------------------------------------------------------------------------
END