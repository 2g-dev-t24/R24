* @ValidationCode : MjotOTk4NTg1OTpDcDEyNTI6MTc1Njk0OTEyNjc4NTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Sep 2025 22:25:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.UPD.ACLK.FT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING AbcTable
    $USING ST.Customer
    $USING EB.Updates
*-----------------------------------------------------------------------------

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ID.FT = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckDescription)
    Y.ID.SEND.OFS = EB.SystemTables.getIdNew()
    EB.Updates.MultiGetLocRef("FUNDS.TRANSFER","AUTH.ID",Y.POS.AUTH.ID)

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER.NAU = ''
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER.NAU, F.FUNDS.TRANSFER.NAU)

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------

    R.FUNDS.TRANSFER = ''
    ERR.FT = ''
    EB.DataAccess.FRead(FN.FUNDS.TRANSFER, Y.ID.FT, R.FUNDS.TRANSFER, F.FUNDS.TRANSFER, ERR.FT)
    IF R.FUNDS.TRANSFER EQ '' THEN
        EB.DataAccess.FRead(FN.FUNDS.TRANSFER.NAU, Y.ID.FT, R.FUNDS.TRANSFER, F.FUNDS.TRANSFER.NAU, ERR.FT)
        R.FUNDS.TRANSFER<FT.Contract.FundsTransfer.LocalRef,Y.POS.AUTH.ID> = Y.ID.SEND.OFS
        EB.DataAccess.FWrite(FN.FUNDS.TRANSFER.NAU,Y.ID.FT,R.FUNDS.TRANSFER)
    END ELSE
        R.FUNDS.TRANSFER<FT.Contract.FundsTransfer.LocalRef,Y.POS.AUTH.ID> = Y.ID.SEND.OFS
        EB.DataAccess.FWrite(FN.FUNDS.TRANSFER,Y.ID.FT,R.FUNDS.TRANSFER)

    END

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------



RETURN

END

