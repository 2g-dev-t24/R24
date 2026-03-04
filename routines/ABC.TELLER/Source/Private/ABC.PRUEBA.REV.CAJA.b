* @ValidationCode : MjoxNTcwMjQzOTg4OkNwMTI1MjoxNzYzNjQ5NTAxNTYyOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Nov 2025 11:38:21
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
SUBROUTINE ABC.PRUEBA.REV.CAJA
*-------------------
    $USING TT.Contract
    $USING EB.Security
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
*-------------------
    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    EB.DataAccess.Opf(FN.TELLER,F.TELLER)

    FN.TELLER.NAU = 'F.TELLER$NAU'
    F.TELLER.NAU = ''
    EB.DataAccess.Opf(FN.TELLER.NAU, F.TELLER.NAU)

    FN.USER = 'F.USER'
    F.USER = ''
    EB.DataAccess.Opf(FN.USER,F.USER)


    ID.TRANSACCION = EB.SystemTables.getComi()

    READ REC.TTH FROM F.TELLER.NAU, ID.TRANSACCION ELSE NULL
    TT.ESTATUSH = REC.TTH<TT.Contract.Teller.TeRecordStatus>


*... Cajero diferente solo puede autorizar
    R.USER = EB.SystemTables.getRUser()
    Y.USER.CAJERO = R.USER<EB.Security.User.UseDepartmentCode>          ;*... usuario caja principal
    Y.USER.CAJA.SUC = Y.USER.CAJERO[1,5]

    IF REC.TTH NE '' THEN
        Y.TRANS.CAJERO = REC.TTH<TT.Contract.Teller.TeDeptCode> ;*... usuario caja mixta
        Y.TRANS.CAJA.SUC = Y.TRANS.CAJERO[1,5]

        IF NOT(Y.USER.CAJA.SUC = Y.TRANS.CAJA.SUC) THEN
            E = "FUNCION NO PERMITIDA, REVERSO NO PERTENECE A SUCURSAL"
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END
    
*-------------------
END
