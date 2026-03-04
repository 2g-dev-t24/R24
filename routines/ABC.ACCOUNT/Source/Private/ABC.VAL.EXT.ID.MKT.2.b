* @ValidationCode : MjoxMTA2MDE5ODMxOkNwMTI1MjoxNzU3OTAwMDA3ODYxOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Sep 2025 22:33:27
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

SUBROUTINE ABC.VAL.EXT.ID.MKT.2
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING FT.Contract
    $USING AbcTable
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INICIO
    GOSUB PROCESS
    GOSUB FINALLY

RETURN
*-------------------------------------------------------------------------------
INICIO:
*-------------------------------------------------------------------------------
    FN.ABC.FT.DETAIL = "F.ABC.L.FT.TXN.DETAIL"
    FV.ABC.FT.DETAIL = ""
    EB.DataAccess.Opf(FN.ABC.FT.DETAIL, FV.ABC.FT.DETAIL)

    FN.ABC.FT.DETAIL.HIS = "F.ABC.L.FT.TXN.DETAIL$HIS"
    FV.ABC.FT.DETAIL.HIS = ""
    EB.DataAccess.Opf(FN.ABC.FT.DETAIL.HIS, FV.ABC.FT.DETAIL.HIS)

    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","EXT.TRANS.ID", Y.POS.EXT.TRANS.ID)

    Y.FUNCION   = ""
    Y.MENSAJE   = ""
    Y.ID.FT.ORI = ""

RETURN
*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
    Y.LOCAL.REF     = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.EXT.TRANS.ID  = Y.LOCAL.REF<1, Y.POS.EXT.TRANS.ID>

    IF Y.EXT.TRANS.ID NE "" THEN
        REC.FT.DET.CONCAT = ""
        EB.DataAccess.FRead(FN.ABC.FT.DETAIL,Y.EXT.TRANS.ID,REC.FT.DET.CONCAT,FV.ABC.FT.DETAIL,Y.ACC.ERR)
        
        IF (Y.ACC.ERR EQ '') THEN
            Y.ID.FT.ORI = REC.FT.DET.CONCAT<AbcTable.AbcLFtTxnDetail.IdFt>
        END ELSE
            Y.EXT.TRANS.ID.HIS = Y.EXT.TRANS.ID
            EB.DataAccess.FReadHistory(FN.ABC.FT.DETAIL.HIS, Y.EXT.TRANS.ID.HIS, REC.FT.DET.CONCAT, FV.ABC.FT.DETAIL.HIS, Y.ERR)
            Y.ID.FT.ORI = REC.FT.DET.CONCAT<AbcTable.AbcLFtTxnDetail.IdFt>
        END
    
        IF REC.FT.DET.CONCAT NE "" THEN
            ETEXT = "EXT TRANS ID: " : Y.EXT.TRANS.ID : " YA REGISTRADO: ": Y.ID.FT.ORI
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END

    END

RETURN
*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------
RETURN
*-------------------------------------------------------------------------------
END

