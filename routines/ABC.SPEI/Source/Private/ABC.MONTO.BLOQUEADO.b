* @ValidationCode : MjotMzY2NjYxODE1OkNwMTI1MjoxNzY3NjY2ODAwODQ3Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2026 23:33:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.MONTO.BLOQUEADO(Y.NO.ACC,Y.SALDO.BLOQ,Y.TODAY)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*  $USING EB.SystemTables
    $USING EB.DataAccess
    
* $USING AC.AccountOpening
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.SALDO.BLOQ =0
    R.ACCOUNT = ''
    Y.ERROR = ''
*   Y.TODAY = EB.SystemTables.getToday()

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
* R.ACCOUNT = AC.AccountOpening.Account.Read(Y.NO.ACC, Y.AC.ERR)
    EB.DataAccess.FRead(FN.ACCOUNT,Y.NO.ACC,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
    IF R.ACCOUNT EQ '' THEN
        RETURN
    END
    
* Y.FROM.DATE      = RAISE(R.ACCOUNT<AC.AccountOpening.Account.FromDate>)121
*Y.AMOUNT.LOCKED  = RAISE(R.ACCOUNT<AC.AccountOpening.Account.LockedAmount>)122
    Y.FROM.DATE      = RAISE(R.ACCOUNT<121>)
    Y.AMOUNT.LOCKED  = RAISE(R.ACCOUNT<122>)
    Y.NUM.DATE       = DCOUNT(Y.FROM.DATE,@FM)
    YACCT.LOCKED.AMT = 0
    YFOUND           = 0
    YFOUND.INT       = 0

    FOR Y.IND = 1 TO Y.NUM.DATE WHILE YFOUND = 0
        IF Y.FROM.DATE<Y.IND> EQ Y.TODAY THEN
            YFOUND     = 1
            YFOUND.IND = Y.IND
        END ELSE
            IF Y.FROM.DATE<Y.IND> GT Y.TODAY THEN
                YFOUND     = 1
                YFOUND.IND = Y.IND -1
            END
        END
    NEXT Y.IND
    
    IF YFOUND.IND > 0 THEN
        YACCT.LOCKED.AMT = Y.AMOUNT.LOCKED<YFOUND.IND>
    END ELSE
        IF Y.IND EQ Y.NUM.DATE THEN
            YACCT.LOCKED.AMT = Y.AMOUNT.LOCKED<Y.NUM.DATE>
        END
    END
    
    Y.SALDO.BLOQ = YACCT.LOCKED.AMT

RETURN
*-----------------------------------------------------------------------------
END
