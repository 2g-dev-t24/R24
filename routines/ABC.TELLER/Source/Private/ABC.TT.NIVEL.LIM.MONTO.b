* @ValidationCode : Mjo3NzAyMDAwNTI6Q3AxMjUyOjE3NjE2MTY2MzcxNzE6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2025 22:57:17
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
SUBROUTINE ABC.TT.NIVEL.LIM.MONTO
*-----------------------------------------------------------------------------
* Creado por   :
* Fecha        :
* Descripcion  : Rutina para validar el monto l�mite para las cuentas seg�n su nivel
*-----------------------------------------------------------------------------

    $USING TT.Contract
    $USING AC.AccountOpening
    $USING AbcTable
    $USING EB.DataAccess
    $USING AbcSpei
    $USING EB.SystemTables
******************
    GOSUB INICIO
    GOSUB APERTURA
    GOSUB PROCESO

RETURN
*************************
INICIO:
*************************
    Y.CUENTA.CR = ''
    Y.CUENTA.DR = ''
    Y.CUENTA = ''
    Y.MONTO.TRANS = 0
    Y.TRANS.TYPE = ''
    Y.NIVEL.CR = ''
    Y.NIVEL.DR = ''
    R.ACCOUNT = ''
    YERR.ACCOUNT = ''
    R.NIVEL = ''
    YERR.NIVEL = ''
    Y.CLIENTE = ''
    Y.ID.LIMITE = ''
    Y.FEC.LIMITE = OCONV(DATE(), "DY4"):FMT(OCONV(DATE(), "DM"),"2'0'R")
    
    APPLICATION = EB.SystemTables.getApplication()
    VFUNCTION   = EB.SystemTables.getVFunction()

RETURN
***************************
APERTURA:
***************************
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.ABC.NIVEL.CUENTA = 'F.ABC.NIVEL.CUENTA'
    F.ABC.NIVEL.CUENTA = ''
    EB.DataAccess.Opf(FN.ABC.NIVEL.CUENTA,F.ABC.NIVEL.CUENTA)
    
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)
    
RETURN
***************************
PROCESO:
***************************
    Y.CUENTA.CR         = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
    Y.CUENTA.DR         = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
    Y.MONTO.TRANS       = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
    IF Y.MONTO.TRANS EQ '' THEN
        Y.MONTO.TRANS = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalTwo)
    END
    Y.TRANS.TYPE = EB.SystemTables.getRNew(TT.Contract.Teller.TeTransactionCode)

    IF Y.CUENTA.CR[1,3] EQ "MXN" THEN
        EB.DataAccess.FRead(FN.ACCOUNT,Y.CUENTA.DR,R.ACCOUNT,F.ACCOUNT,YERR.ACCOUNT)
        IF R.ACCOUNT THEN
            Y.CLIENTE = R.ACCOUNT<AC.AccountOpening.Account.Customer>
            Y.ID.ARRAY = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
            EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,YERR.LCL)
            IF R.ABC.ACCT.LCL.FLDS THEN
                Y.NIVEL.DR = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Nivel>
            END
        END

        EB.DataAccess.FRead(FN.ABC.NIVEL.CUENTA,Y.NIVEL.DR,R.NIVEL,F.ABC.NIVEL.CUENTA,YERR.NIVEL)
        IF R.NIVEL THEN
            Y.MONTO.LIMITE = R.NIVEL<AbcTable.AbcNivelCuenta.ValorLimite>
            Y.APP = R.NIVEL<AbcTable.AbcNivelCuenta.Aplicacion>

            Y.APP = RAISE(Y.APP)

            LOCATE APPLICATION IN Y.APP SETTING YPOS.APP THEN
                Y.TRANS.DR = R.NIVEL<AbcTable.AbcNivelCuenta.TransaccionDr,YPOS.APP>
                CHANGE @SM TO @FM IN Y.TRANS.DR
                LOCATE Y.TRANS.TYPE IN Y.TRANS.DR SETTING YPOS.TRANS.DR THEN
                    Y.ID.LIMITE = Y.CUENTA.DR:"-":Y.FEC.LIMITE
                    Y.MONTO.TRANS *= -1
                    AbcSpei.AbcValidaLimiteMonto(Y.ID.LIMITE,Y.MONTO.TRANS,Y.MONTO.LIMITE,ID.NEW,Y.CLIENTE)
                END
            END
        END
    END ELSE
        EB.DataAccess.FRead(FN.ACCOUNT,Y.CUENTA.CR,R.ACCOUNT,F.ACCOUNT,YERR.ACCOUNT)
        IF R.ACCOUNT THEN
            Y.CLIENTE = R.ACCOUNT<AC.AccountOpening.Account.Customer>
            Y.ID.ARRAY = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
            EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,YERR.LCL)
            IF R.ABC.ACCT.LCL.FLDS THEN
                Y.NIVEL.CR = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Nivel>
            END
            
        END

        EB.DataAccess.FRead(FN.ABC.NIVEL.CUENTA,Y.NIVEL.CR,R.NIVEL,F.ABC.NIVEL.CUENTA,YERR.NIVEL)
        IF R.NIVEL THEN
            Y.MONTO.LIMITE = R.NIVEL<AbcTable.AbcNivelCuenta.ValorLimite>
            Y.APP = R.NIVEL<AbcTable.AbcNivelCuenta.Aplicacion>

            Y.APP = RAISE(Y.APP)

            LOCATE APPLICATION IN Y.APP SETTING YPOS.APP THEN
                Y.TRANS.CR = R.NIVEL<AbcTable.AbcNivelCuenta.TransaccionCr,YPOS.APP>
                CHANGE @SM TO @FM IN Y.TRANS.CR
                LOCATE Y.TRANS.TYPE IN Y.TRANS.CR SETTING YPOS.TRANS.CR THEN
                    Y.ID.LIMITE = Y.CUENTA.CR:"-":Y.FEC.LIMITE
                    IF VFUNCTION EQ "R" THEN Y.MONTO.TRANS *= -1
                    AbcSpei.AbcValidaLimiteMonto(Y.ID.LIMITE,Y.MONTO.TRANS,Y.MONTO.LIMITE,ID.NEW,Y.CLIENTE)
                END
            END
        END
    END

RETURN
***************************
END
