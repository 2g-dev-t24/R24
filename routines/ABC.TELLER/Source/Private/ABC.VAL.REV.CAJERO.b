* @ValidationCode : Mjo1MDk1MzM1MjU6Q3AxMjUyOjE3NjQyOTU5OTM5NzA6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Nov 2025 23:13:13
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
* <Rating>196</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
SUBROUTINE ABC.VAL.REV.CAJERO
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.Security
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
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
    
    EB.DataAccess.FRead(FN.TELLER,ID.TRANSACCION,REC.TT,F.TELLER,ERR.DETAIL)
    
    IF REC.TT THEN
        TT.ESTATUS = REC.TT<TT.Contract.Teller.TeRecordStatus>

        EB.DataAccess.FRead(FN.TELLER.NAU,ID.TRANSACCION,REC.TTH,F.TELLER.NAU,ERR.DETAIL)
        TT.ESTATUSH = REC.TTH<TT.Contract.Teller.TeRecordStatus>


*... el mismo cajero unicamente podra reversar sus movimientos
        Y.USER.ID = EB.SystemTables.getOperator()
        EB.DataAccess.FRead(FN.USER, Y.USER.ID, R.USER, F.USER, Y.ERR.USER)
        Y.USER.CAJERO = R.USER<EB.Security.User.UseDepartmentCode>

        IF REC.TT NE '' THEN
            Y.TRANS.CAJERO = REC.TT<TT.Contract.Teller.TeDeptCode>

            IF NOT(Y.USER.CAJERO = Y.TRANS.CAJERO) THEN
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END

    END
*-----------------------------------------------------------------------------

END
