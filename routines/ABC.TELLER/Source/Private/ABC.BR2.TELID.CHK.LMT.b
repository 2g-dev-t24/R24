* @ValidationCode : MjoxMzY0OTgwODE2OkNwMTI1MjoxNzU4ODk3MTQ3NDUxOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Sep 2025 11:32:27
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
$PACKAGE AbcTeller
SUBROUTINE ABC.BR2.TELID.CHK.LMT
* This is added to Teller ID versions to check
* if they havee excess amount in till before closing
* at end of day.
* If the teller has more cash in till then CALLOW, he
* won't be able to close the till.
* He has to do Concentracion a Boveda first.

******************************************************************
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING TT.Contract
    $USING EB.ErrorProcessing

    $USING AbcTable
******************************************************************
    GOSUB INIT
    GOSUB PROCESS

RETURN
**************
INIT:
**************
    FN.ABC.LIMITE = 'F.ABC.2BR.LIMITES.CAJA'
    FV.ABC.LIMITE = ''
    EB.DataAccess.Opf(FN.ABC.LIMITE,FV.ABC.LIMITE)

RETURN
**************
PROCESS:
**************
    TT.TID.STATUS   = EB.SystemTables.getRNew(TT.Contract.TellerId.TidStatus)
    IF TT.TID.STATUS EQ 'CLOSE' THEN

        TELL.CAT    = "SYSTEM"
        ABC.CAT.REC = ''
        ABC.TEL.ERR = ''
        EB.DataAccess.FRead(FN.ABC.LIMITE,TELL.CAT,ABC.CAT.REC,FV.ABC.LIMITE,ABC.TEL.ERR)

        IF ABC.TEL.ERR = '' THEN
            TT.ID.CATEGORY  = EB.SystemTables.getRNew(TT.Contract.TellerId.TidCategory)
            CNT.CATEGORY    = DCOUNT(TT.ID.CATEGORY,@VM)
            TT.ID.CURRENCY  = EB.SystemTables.getRNew(TT.Contract.TellerId.TidCurrency)
            TT.ID.CLOSEBAL  = EB.SystemTables.getRNew(TT.Contract.TellerId.TidTillClosBal)
            LIM.CAJA.CURR   = RAISE(ABC.CAT.REC<AbcTable.Abc2brLimitesCaja.Currency>)
            LIM.CAJA.TRAN   = ABC.CAT.REC<AbcTable.Abc2brLimitesCaja.Transaction>

            FOR NO.OF.CAT = 1 TO CNT.CATEGORY
                TEL.CURR    = TT.ID.CURRENCY<1,NO.OF.CAT>
                TCLOS.BAL   = TT.ID.CLOSEBAL<1,NO.OF.CAT>
                TCLOS.BAL   = ABS(TCLOS.BAL)

                LOCATE TEL.CURR IN LIM.CAJA.CURR SETTING VPPOS THEN
                    LIM.CAJA.TRAN.AUX = LIM.CAJA.TRAN<1,VPPOS>
                    IF TCLOS.BAL GT LIM.CAJA.TRAN.AUX THEN
                        EXCESS.AMT = TCLOS.BAL - LIM.CAJA.TRAN.AUX
                        ETEXT = 'EXCESS AMT OF  ':EXCESS.AMT:' IN TILL - TRANSFER TO VAULT BEFORE CLOSING'
                        EB.SystemTables.setAf(TT.Contract.TellerId.TidStatus)
                        EB.SystemTables.setEtext(ETEXT)
                        EB.ErrorProcessing.StoreEndError()
                        EXIT

                    END
                END

                VPPOS = ''

            NEXT NO.OF.CAT
        END
    END

RETURN
******************************************************************
END
