* @ValidationCode : MjotMTU5NzM1Mzc3NDpDcDEyNTI6MTc2ODYxMzAwMjg3NTpFZGdhcjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Jan 2026 19:23:22
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
$PACKAGE AbcRegulatorios
SUBROUTINE ABC.OEMN.SEL(FECHA.INI,COD.TRANS,FECHA.FIN,LIST.TT,NO.REG.TT,COND.TT.ADD)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables

    GOSUB INICIALIZA
    GOSUB ABRIR.ARCHIVOS
    GOSUB PROCESO

RETURN

*---------*
INICIALIZA:
*---------*

    Y.SELECT = ''
    Y.LIST.TT= ''
    Y.NO.TT=''
    Y.SELECT.HIS=''
    Y.NO.TT.HIS=''
    Y.LIST.TT.HIS=''
    Y.NO.REG=''
    Y.LIST.TT=''

    LIST.TT=''
    NO.REG.TT=''

RETURN

*-------*
PROCESO:
*-------*

    GOSUB SELECT.LIVE
    GOSUB SELECT.HIS
    Y.NO.REG = Y.NO.TT + Y.NO.TT.HIS
    IF Y.LIST.TT GT 0 THEN
        Y.LIST.TT = Y.LIST.TT:@FM:Y.LIST.TT.HIS
    END ELSE
        Y.LIST.TT = Y.LIST.TT.HIS
    END

    NO.REG.TT = Y.NO.REG
    LIST.TT =  Y.LIST.TT

RETURN

*----------*
SELECT.LIVE:
*----------*

    Y.SELECT = 'SSELECT ':FN.TELLER:' WITH TRANSACTION.CODE EQ ':DQUOTE(COD.TRANS):' AND VALUE.DATE.1 LE ':DQUOTE(FECHA.FIN):' AND VALUE.DATE.1 GE ': DQUOTE(FECHA.INI:COND.TT.ADD)  ; *ITSS - SINDHU - Added DQUOTE
    EB.DataAccess.Readlist(Y.SELECT,Y.LIST.TT,'',Y.NO.TT,'')

RETURN
*---------*
SELECT.HIS:
*---------*

    Y.SELECT.HIS = 'SSELECT ':FN.TELLER.HIS:' WITH TRANSACTION.CODE EQ ':DQUOTE(COD.TRANS):' AND VALUE.DATE.1 LE ':DQUOTE(FECHA.FIN):' AND VALUE.DATE.1 GE ': DQUOTE(FECHA.INI:COND.TT.ADD)  ; *ITSS - SINDHU - Added DQUOTE
    EB.DataAccess.Readlist(Y.SELECT.HIS,Y.LIST.TT.HIS,'',Y.NO.TT.HIS,'')

RETURN

*-------------*
ABRIR.ARCHIVOS:
*-------------*

    FN.TELLER= 'FBNK.TELLER'
    F.TELLER= ''
    EB.DataAccess.Opf(FN.TELLER,F.TELLER)

    FN.TELLER.HIS= 'FBNK.TELLER$HIS'
    F.TELLER.HIS= ''
    EB.DataAccess.Opf(FN.TELLER.HIS,F.TELLER.HIS)

RETURN
END

END
