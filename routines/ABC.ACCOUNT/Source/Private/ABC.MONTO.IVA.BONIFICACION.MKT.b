* @ValidationCode : Mjo1NDA1OTkxNTE6Q3AxMjUyOjE3NTc5MDI1MDgzNjg6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Sep 2025 23:15:08
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
$PACKAGE AbcAccount

SUBROUTINE ABC.MONTO.IVA.BONIFICACION.MKT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING CG.ChargeConfig
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING FT.Contract
    $USING AbcTable
    $USING AbcGetGeneralParam
*-----------------------------------------------------------------------------
    GOSUB INITIALIZE
    LOCATE Y.TRANS.TYPE IN Y.TRANSACTION.TYPE SETTING Y.POS THEN
        GOSUB PROCESS
        GOSUB FINALLY
    END

RETURN
*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------
    Y.TRANS.TYPE    = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)
    Y.MONTO.TOTAL   = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.IVA           = 0
    Y.MONTO.IVA     = 0
    Y.MONTO         = 0

    FN.TAX  = 'F.TAX'
    F.TAX   = ''
    EB.DataAccess.Opf(FN.TAX,F.TAX)

    Y.TRANSACTION.TYPE = ''
    Y.ID.PARAM      = 'ABC.MKT.BONIFICA.IVA.PARAM'

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'TRANSACTION.TYPE' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.TRANSACTION.TYPE = Y.LIST.VALUES<Y.POS>
    END

    LOCATE 'TAX.ID' IN Y.LIST.PARAMS SETTING Y.POS THEN
        Y.TAX.ID = Y.LIST.VALUES<Y.POS>
    END

    CHANGE ' ' TO @FM IN Y.TRANSACTION.TYPE

RETURN
*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
    SEL.LIST = ''; SEL.NO = ''; SEL.ERR = ''; SEL.CMD = '';

    SEL.CMD = 'SELECT ':FN.TAX:' WITH @ID LIKE ':Y.TAX.ID:'.... BY @ID'
    EB.DataAccess.Readlist(SEL.CMD,Y.LIST,'',Y.NO,Y.ERR)
    Y.TAX.ID = Y.LIST<Y.NO>

    EB.DataAccess.FRead(FN.TAX,Y.TAX.ID,R.TAX,F.TAX,TX.ERR)
    Y.IVA = R.TAX<CG.ChargeConfig.Tax.EbTaxRate>
    IF Y.IVA GT 1 THEN Y.IVA = DROUND(Y.IVA/100,2)

    Y.MONTO.IVA = Y.MONTO.TOTAL - (Y.MONTO.TOTAL / (1 + Y.IVA))
    Y.MONTO.IVA = DROUND(Y.MONTO.IVA,2)

    Y.MONTO = Y.MONTO.TOTAL - Y.MONTO.IVA

RETURN
*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------
    Y.MONTO = 'MONTO:':Y.MONTO:' IVA:':Y.MONTO.IVA
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.ExtendInfo,Y.MONTO)

RETURN
*-------------------------------------------------------------------------------
END


