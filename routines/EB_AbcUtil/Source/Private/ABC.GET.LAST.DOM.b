* @ValidationCode : MjotMTI5NDA5NTMyMDpDcDEyNTI6MTc2ODU4NjYwNjIzNDpFZGdhcjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Jan 2026 12:03:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE EB.AbcUtil
SUBROUTINE ABC.GET.LAST.DOM(CCYYMM,L.DATE,L.DAY,M.NAME)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*--------------------------------------------------
*
*  Subroutine to obtain last day, last date & name of the
*month is given. If invalid month (MM = 0 or > 12) no
*outputs produce(W.LDATE = '', W.L.DATE = '' & W.M.NAME =
*'INVALID MONTH).
*
*
* $INSERT I_COMMON - Not Used anymore;
* $INSERT I_EQUATE - Not Used anymore;
* $INSERT I_ENQUIRY.COMMON - Not Used anymore;

    W.CCYYMM = CCYYMM
    W.L.DATE = ''
    W.L.DAY = ''
    W.M.NAME = 'INVALID MONTH '

    W.CCYY = ''
    W.MM = ''

    I = 0

    M01 = 'January  '
    M02 = 'February '
    M03 = 'March    '
    M04 = 'April    '
    M05 = 'May      '
    M06 = 'June     '
    M07 = 'July     '
    M08 = 'August   '
    M09 = 'September'
    M10 = 'October  '
    M11 = 'November '
    M12 = 'December '

    D01 = 31
    D02 = 28
    D03 = 31
    D04 = 30
    D05 = 31
    D06 = 30
    D07 = 31
    D08 = 31
    D09 = 30
    D10 = 31
    D11 = 30
    D12 = 31

    I = LEN(W.CCYYMM)
    IF I EQ 6 THEN
        W.CCYY = W.CCYYMM[1,4]
        W.MM = W.CCYYMM[5,2]
        IF W.MM GT 0 AND W.MM LE 12 THEN
            I = 0
            I = MOD(W.CCYY,'4')
            IF I = 0 THEN
                D02 = 29
            END ELSE
                D02 = 28
            END
            M.NAME.ARR = M01:@FM:M02:@FM:M03:@FM:M04:@FM:M05:@FM:M06:@FM:M07:@FM:M08:@FM:M09:@FM:M10:@FM:M11:@FM:M12
            L.DATE.ARR = D01:@FM:D02:@FM:D03:@FM:D04:@FM:D05:@FM:D06:@FM:D07:@FM:D08:@FM:D09:@FM:D10:@FM:D11:@FM:D12
            W.L.DAY = L.DATE.ARR<W.MM>
            W.L.DATE = W.CCYYMM:W.L.DAY
            W.M.NAME = W.CCYY:' ':M.NAME.ARR<W.MM>
        END
    END
    CCYYMM = W.CCYYMM
    L.DATE = W.L.DATE
    L.DAY = W.L.DAY
    M.NAME = W.M.NAME
RETURN
*--------------------------------------------------
END
